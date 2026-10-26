#pragma once
#include "simulation.h"
#include "generated-audio-events.h"
#include "pcm-mixer.h"
#include "hurt-sound-policy.h"
#include <cstdio>
#include <cstring>
inline int runPcmChecks(FILE*out){
 int fails=0;
 auto check=[&](bool ok,const char*name){if(!ok)++fails;if(out)fprintf(out,"%s: %s\n",ok?"PASS":"FAIL",name);};
 struct Clip{std::vector<int16_t> data;};
 std::vector<Clip> clips(3);
 clips[0].data={1000,-1000,2000,-2000,3000,-3000,4000,-4000};
 clips[1].data.assign(441*2,1000);
 clips[2].data.assign(441*2,1000);
 PcmMixer mixer;
 short buf[480*2]{};
 mixer.render(clips,0,buf,2);
 check(buf[0]==250&&buf[1]==-250,"Stereo music preserves separate left and right channels");
 check(buf[2]>buf[0]&&buf[3]<buf[1],"Preconverted 48 kHz PCM advances one stereo frame per output frame");
 mixer.start(1);mixer.start(2);
 mixer.render(clips,-1,buf,1);
 check(buf[0]==1200&&buf[1]==1200,"Simultaneous effects are mixed, not queued serially");
 mixer.render(clips,-1,buf,480);
 mixer.render(clips,-1,buf,1);
 check(buf[0]==0&&mixer.voices.empty(),"SFX stop cleanly after 44.1 kHz source duration");
 mixer.render(clips,0,buf,480);
 bool audible=false;for(short s:buf)audible|=s!=0;
 check(audible,"Music loops without a silent partial output block");
 HurtSoundGate gate;
 check(gate.allow(0,true),"Source strong-hit voice always plays");
 check(!gate.allow(1,true),"Hurt voice cooldown suppresses rapid repeated damage");
 check(gate.allow(12,true),"Hurt voice becomes available after 12 ticks");
 HurtSoundGate light;int lightVoices=0;
 for(int i=0;i<100;i++)lightVoices+=light.allow(i*12,false);
 check(lightVoices>=25&&lightVoices<=55,"Source light-hurt voice remains randomized near 40 percent");
 bool foundF=false,foundU=false,foundD=false,foundJab2=false;
 for(const auto&e:AUTHORED_AUDIO_EVENTS){
  foundF|=e.anim==ssf::FTilt&&e.frame==2&&!strcmp(e.sound,"brawl_swing_m");
  foundU|=e.anim==ssf::UTilt&&e.frame==2&&!strcmp(e.sound,"brawl_swing_l");
  foundD|=e.anim==ssf::DTilt&&e.frame==2&&!strcmp(e.sound,"brawl_swing_m");
  foundJab2|=e.anim==ssf::Jab&&e.frame==11&&!strcmp(e.sound,"brawl_swing_m");
 }
 check(foundF&&foundU&&foundD&&foundJab2,"Move sounds preserve authored tilt and jab source frames");
 std::vector<Clip> hot(1);hot[0].data.assign(4096,32767);
 PcmMixer limiter;limiter.start(0);limiter.start(0);short peak[2]{};limiter.render(hot,-1,peak,1);
 check(peak[0]<32767&&peak[1]<32767,"Overlapping full-scale SFX use a soft limiter instead of crunchy hard clipping");
 if(out)fprintf(out,"PCM checks: %d failures\n",fails);
 return fails;
}
