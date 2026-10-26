#pragma once
#include <psp2/audioout.h>
#include <psp2/kernel/threadmgr.h>
#include <atomic>
#include <algorithm>
#include <cstdint>
#include <cstdio>
#include <deque>
#include <utility>
#include <vector>
#include "pcm-mixer.h"

// The Vita MAIN port only accepts 48 kHz. Mix supplied 44.1 kHz stereo PCM
// into a single MAIN port so music and effects share one hardware clock.
struct VitaAudio {
 struct Clip {std::vector<int16_t> data;};
 static constexpr int BLOCK_FRAMES=1024;
 int port=-1,thread=-1,volume=SCE_AUDIO_OUT_MAX_VOL;
 std::atomic<int> lastError{0};
 bool ready=false,mutexReady=false;
 std::atomic<bool> running{false},musicPlaying{false};
 std::atomic<int> musicIndex{-1};
 std::atomic<unsigned> outputBlocks{0};
 SceKernelLwMutexWork queueMutex{};
 std::deque<int> pendingSfx;
 std::vector<Clip> clips;

 bool init(){
  port=sceAudioOutOpenPort(SCE_AUDIO_OUT_PORT_TYPE_MAIN,BLOCK_FRAMES,48000,SCE_AUDIO_OUT_MODE_STEREO);
  if(port<0){lastError=port;return false;}
  int result=sceKernelCreateLwMutex(&queueMutex,"ssf2-audio",0,0,NULL);
  if(result<0){lastError=result;sceAudioOutReleasePort(port);port=-1;return false;}
  mutexReady=true;
  thread=sceKernelCreateThread("ssf2-audio",audioThread,0x40,0x10000,0,0,NULL);
  if(thread<0){lastError=thread;sceKernelDeleteLwMutex(&queueMutex);mutexReady=false;
   sceAudioOutReleasePort(port);port=-1;return false;}
  VitaAudio*self=this;running=true;
  result=sceKernelStartThread(thread,sizeof(self),&self);
  if(result<0){lastError=result;running=false;sceKernelDeleteThread(thread);thread=-1;
   sceKernelDeleteLwMutex(&queueMutex);mutexReady=false;sceAudioOutReleasePort(port);port=-1;return false;}
  ready=true;return true;
 }
 void shutdown(){
  if(!ready)return;
  running=false;musicPlaying=false;
  if(thread>=0){sceKernelWaitThreadEnd(thread,NULL,NULL);sceKernelDeleteThread(thread);thread=-1;}
  if(mutexReady){sceKernelDeleteLwMutex(&queueMutex);mutexReady=false;}
  if(port>=0){sceAudioOutReleasePort(port);port=-1;}
  ready=false;
 }
 // PCM is raw signed 16-bit little-endian. Supplied files are stereo.
 int loadClip(const char*path,bool stereo){
  FILE*f=fopen(path,"rb");if(!f)return -1;
  if(fseek(f,0,SEEK_END)!=0){fclose(f);return -1;}
  long bytes=ftell(f);
  if(bytes<=0||bytes%(stereo?4:2)||fseek(f,0,SEEK_SET)!=0){fclose(f);return -1;}
  Clip clip;clip.data.resize(bytes/2);
  size_t got=fread(clip.data.data(),sizeof(int16_t),clip.data.size(),f);fclose(f);
  if(got!=clip.data.size())return -1;
  if(!stereo){std::vector<int16_t>dual(clip.data.size()*2);
   for(size_t i=0;i<clip.data.size();i++)dual[2*i]=dual[2*i+1]=clip.data[i];
   clip.data=std::move(dual);
  }
  clips.push_back(std::move(clip));return (int)clips.size()-1;
 }
 void playMusic(int clip){if(clip>=0&&clip<(int)clips.size()){
  musicIndex=clip;musicPlaying=true;
 }}
 void stopMusic(){musicPlaying=false;}
 void setVolume(int v){
  if(!ready)return;
  volume=std::clamp(v,0,(int)SCE_AUDIO_OUT_MAX_VOL);int levels[2]={volume,volume};
  int result=sceAudioOutSetVolume(port,(SceAudioOutChannelFlag)
   (SCE_AUDIO_VOLUME_FLAG_L_CH|SCE_AUDIO_VOLUME_FLAG_R_CH),levels);
  if(result<0)lastError=result;
 }
 void playSfx(int clip){
  if(!ready||clip<0||clip>=(int)clips.size())return;
  sceKernelLockLwMutex(&queueMutex,1,NULL);
  if(pendingSfx.size()<16)pendingSfx.push_back(clip);
  sceKernelUnlockLwMutex(&queueMutex,1);
 }
 static int audioThread(SceSize,void*argp){
  VitaAudio*a=*(VitaAudio**)argp;
  int16_t output[BLOCK_FRAMES*2]{};PcmMixer mixer;
  while(a->running){
   sceKernelLockLwMutex(&a->queueMutex,1,NULL);
   while(!a->pendingSfx.empty()&&mixer.voices.size()<PcmMixer::MAX_VOICES){
    mixer.start(a->pendingSfx.front());a->pendingSfx.pop_front();
   }
   sceKernelUnlockLwMutex(&a->queueMutex,1);
   int music=a->musicPlaying.load()?a->musicIndex.load():-1;
   mixer.render(a->clips,music,output,BLOCK_FRAMES);
   int result=sceAudioOutOutput(a->port,output);
   if(result<0){a->lastError=result;a->running=false;break;}
   ++a->outputBlocks;
  }
  return 0;
 }
};
