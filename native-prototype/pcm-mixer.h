#pragma once
#include <algorithm>
#include <cstddef>
#include <cstdint>
#include <cstdlib>
#include <vector>

// Extracted/converted files are interleaved signed 16-bit stereo at 48 kHz,
// matching the Vita MAIN port. Offline conversion avoids the previous cheap
// linear resampler at playback time.
struct PcmMixer {
 struct Voice {int clip;double frame;};
 static constexpr double STEP=1.0;
 static constexpr int MAX_VOICES=8;
 std::vector<Voice> voices;
 int lastMusic=-1;
 double musicFrame=0;
 PcmMixer(){voices.reserve(MAX_VOICES);}
 void start(int clip){if(clip>=0&&voices.size()<MAX_VOICES)voices.push_back({clip,0});}
 template<class Clip> static int sample(const Clip&clip,double frame,int channel){
  size_t count=clip.data.size()/2;
  if(!count)return 0;
  size_t i=std::min((size_t)frame,count-1),next=std::min(i+1,count-1);
  double fraction=frame-i;
  return (int)(clip.data[i*2+channel]*(1-fraction)+clip.data[next*2+channel]*fraction);
 }
 template<class Clips> void render(const Clips&clips,int music,short*output,size_t frames){
  if(music!=lastMusic){lastMusic=music;musicFrame=0;}
  for(size_t i=0;i<frames;i++){
   int left=0,right=0;
   if(music>=0&&music<(int)clips.size()&&!clips[music].data.empty()){
    const auto&clip=clips[music];
     left+=sample(clip,musicFrame,0)/4;
     right+=sample(clip,musicFrame,1)/4;
    musicFrame+=STEP;
    if(musicFrame>=clip.data.size()/2)musicFrame-=clip.data.size()/2;
   }
   for(size_t j=0;j<voices.size();){
    auto&voice=voices[j];
    if(voice.clip<0||voice.clip>=(int)clips.size()||
       voice.frame>=clips[voice.clip].data.size()/2){
     voices[j]=voices.back();voices.pop_back();continue;
    }
    const auto&clip=clips[voice.clip];
    left+=sample(clip,voice.frame,0)*3/5;
    right+=sample(clip,voice.frame,1)*3/5;
    voice.frame+=STEP;++j;
   }
   auto softLimit=[](int x){
    int sign=x<0?-1:1;int magnitude=std::abs(x);constexpr int knee=28000,range=4767;
    if(magnitude>knee)magnitude=knee+(magnitude-knee)*range/(magnitude-knee+range);
    return (short)(sign*std::min(magnitude,32767));
   };
   output[i*2]=softLimit(left);
   output[i*2+1]=softLimit(right);
  }
 }
};
