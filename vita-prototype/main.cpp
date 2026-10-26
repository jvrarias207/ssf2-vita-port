#include <vitaGL.h>
#include <psp2/ctrl.h>
#include <cstring>
#include <psp2/kernel/processmgr.h>
#include <psp2/kernel/threadmgr.h>
#include <psp2/io/stat.h>
#include <cstdio>
#include <cstdlib>
#include <cstdint>
#include <algorithm>
#include "../native-prototype/simulation.h"
#include "../native-prototype/generated-audio-events.h"
#include "../native-prototype/recovery-checks.h"
#include "../native-prototype/ground-attack-checks.h"
#include "../native-prototype/aerial-checks.h"
#include "../native-prototype/movement-checks.h"
#include "../native-prototype/action-checks.h"
#include "../native-prototype/extended-checks.h"
#include "../native-prototype/ai-checks.h"
#include "../native-prototype/protection-checks.h"
#include "../native-prototype/pcm-checks.h"
#include "../native-prototype/audio.h"
#include "../native-prototype/smash-input.h"
#include "atlas.h"

extern "C" { int _newlib_heap_size_user = 64 * 1024 * 1024; }
static ssf::Game game;
static VitaAudio audio;
static const char* sfxNames[]={
 "1_mario_cape_hit","2_MarioVictory","3_mario_win2_pt2","4_mario_win2",
 "5_mario_uspecCoin2","6_mario_uspecCoin","7_mario_uspec","8_mario_Usmash",
 "9_mario_tauntSide","10_mario_star","11_mario_spin","12_mario_sleep",
 "13_mario_runstop","14_mario_runstart","15_mario_otto","16_mario_landLight",
 "17_mario_landAttack","18_mario_kickswing","19_mario_jumpsfx","20_mario_jump2sfx",
 "21_mario_jump2","22_mario_hurtBad2","23_mario_hurtBad","24_mario_hurt2",
 "25_mario_hoo","26_mario_hoo_old","27_mario_heavyLand","28_mario_grunt4",
 "29_mario_grunt3","30_mario_grunt2","31_mario_grunt1","32_mario_grow2",
 "33_mario_grow1","34_mario_fsready","35_mario_Fsmash_sfx","36_mario_Fsmash",
 "37_mario_footstep2","38_mario_footstep","39_mario_fireballspawn","40_mario_fireballsfx",
 "41_mario_fireballLand","42_mario_finale","43_mario_final2","44_mario_final",
 "45_letsago","46_mario_edgegrab","47_mario_dspec6","48_mario_dspec5",
 "49_mario_dspec4","50_mario_dspec3","51_mario_dspec2","52_mario_dspec",
 "53_mario_Dsmash","54_mario_dizzy","55_mario_dead2","56_mario_dead",
 "57_mario_charge","58_mario_capespawn","59_mario_cape","60_mario_bthrow",
 "61_mario_backjump","62_mario_yoohoo","63_MarioDTauntSpin",
 "brawl_swing_s","brawl_swing_m","brawl_swing_l","grab_swing4","grab_swing6",
 "throw_woosh","brawl_kick_l"};
static constexpr int SFX_COUNT=sizeof(sfxNames)/sizeof(sfxNames[0]);
static int sfxIndices[SFX_COUNT]{};
static int sfxIdx(const char* name){
 if(!audio.ready)return -1;
 for(int i=0;i<SFX_COUNT;i++){
  if(strcmp(sfxNames[i],name)==0)return sfxIndices[i];
  const char*sep=strchr(sfxNames[i],'_');
  const char*label=sep?sep+1:sfxNames[i];
  if(strncmp(label,"mario_",6)==0)label+=6;
  if(strcmp(label,name)==0||strcmp(sep?sep+1:sfxNames[i],name)==0)return sfxIndices[i];
 }
 return -1;
}
static int prevKos=0,prevPlayerAnim=ssf::Idle,prevDummyAnim=ssf::Idle;
static int prevPlayerFrame=-1,prevDummyFrame=-1;
static float prevPlayerDamage=0,prevDummyDamage=0;
static HurtSoundGate playerHurtGate,dummyHurtGate;
static void authoredSounds(const ssf::Fighter&f,int&oldAnim,int&oldFrame){
 for(const auto&e:AUTHORED_AUDIO_EVENTS){
  if(f.anim==e.anim&&f.frame==e.frame&&(oldAnim!=e.anim||oldFrame!=e.frame))audio.playSfx(sfxIdx(e.sound));
 }
 oldAnim=f.anim;oldFrame=f.frame;
}
static void hurtSound(const ssf::Fighter&target,HurtSoundGate&gate){
 if(target.grabbedBy>=0)return;
 // Character.takeDamage: light hurt is randomized at 40%; strong knockback uses hurtBad.
 const bool bad=game.lastKnockback*.03f>24.f;
 if(!gate.allow(game.ticks,bad))return;
 // Main.as maps Character sound key "hurt" to the Mario clip mario_edgegrab.
 audio.playSfx(sfxIdx(bad?"hurtBad":"edgegrab"));
}
static void updateGameplayAudio(){
 if(game.player.damage>prevPlayerDamage)hurtSound(game.player,playerHurtGate);
 if(game.dummy.damage>prevDummyDamage)hurtSound(game.dummy,dummyHurtGate);
 authoredSounds(game.player,prevPlayerAnim,prevPlayerFrame);
 authoredSounds(game.dummy,prevDummyAnim,prevDummyFrame);
 if(game.player.kos+game.dummy.kos>prevKos)audio.playSfx(sfxIdx("dead"));
 prevPlayerDamage=game.player.damage;prevDummyDamage=game.dummy.damage;
 prevKos=game.player.kos+game.dummy.kos;
}
static GLuint atlas=0,fontTexture=0;
static FILE* logFile=nullptr;
static bool debugBoxes=false,paused=false;
static float fps=0,cpuMs=0;
static int recoveryFailures=0;
static float sx(float x){return 480+(x-game.camera.x)*game.camera.scale();}
static float sy(float y){return 274+(y-game.camera.y)*game.camera.scale();}
static void log(const char* message){if(logFile){fprintf(logFile,"%s\n",message);fflush(logFile);}}
static GLuint loadTexture(const char*path,int w,int h){
 FILE*f=fopen(path,"rb");if(!f){log(path);log("ERROR: texture file missing");return 0;}
 size_t size=(size_t)w*h*4;void*data=malloc(size);if(!data){fclose(f);log("ERROR: texture allocation failed");return 0;}
 if(fread(data,1,size,f)!=size){free(data);fclose(f);log("ERROR: short texture read");return 0;}fclose(f);
 GLuint texture;glGenTextures(1,&texture);glBindTexture(GL_TEXTURE_2D,texture);
 glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_NEAREST);glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_NEAREST);
 glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_WRAP_S,GL_CLAMP_TO_EDGE);glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_WRAP_T,GL_CLAMP_TO_EDGE);
 glTexImage2D(GL_TEXTURE_2D,0,GL_RGBA,w,h,0,GL_RGBA,GL_UNSIGNED_BYTE,data);free(data);
 if(glGetError()!=GL_NO_ERROR){log("ERROR: texture upload failed");return 0;}return texture;
}
static void rect(float x,float y,float w,float h,float r,float g,float b){
 glDisable(GL_TEXTURE_2D);glColor4f(r,g,b,1);glBegin(GL_QUADS);glVertex2f(x,y);glVertex2f(x+w,y);glVertex2f(x+w,y+h);glVertex2f(x,y+h);glEnd();
}
static void text(const char*str,float x,float y,float scale=1,float r=.9f,float g=.94f,float b=1){
 glEnable(GL_TEXTURE_2D);glBindTexture(GL_TEXTURE_2D,fontTexture);glColor4f(r,g,b,1);glBegin(GL_QUADS);
 for(;*str;str++,x+=9*scale){unsigned c=(unsigned char)*str;if(c<32||c>=128)c='?';int i=c-32;
  float u=(i%16)*12.f/256,v=(i/16)*20.f/128,u2=u+12.f/256,v2=v+20.f/128;
  glTexCoord2f(u,v);glVertex2f(x,y);glTexCoord2f(u2,v);glVertex2f(x+12*scale,y);glTexCoord2f(u2,v2);glVertex2f(x+12*scale,y+20*scale);glTexCoord2f(u,v2);glVertex2f(x,y+20*scale);
 }glEnd();glDisable(GL_TEXTURE_2D);
}
static void sprite(int index,float px,float py,int facing){
 const auto&im=IMAGES[index];float x=sx(px+facing*im.dx),y=sy(py+im.dy),w=facing*im.w*game.camera.scale(),h=im.h*game.camera.scale();
 float u=im.x/(float)ATLAS_W,v=im.y/(float)ATLAS_H,u2=(im.x+im.w)/(float)ATLAS_W,v2=(im.y+im.h)/(float)ATLAS_H;
 glEnable(GL_TEXTURE_2D);glBindTexture(GL_TEXTURE_2D,atlas);glColor4f(1,1,1,1);glBegin(GL_QUADS);
 glTexCoord2f(u,v);glVertex2f(x,y);glTexCoord2f(u2,v);glVertex2f(x+w,y);glTexCoord2f(u2,v2);glVertex2f(x+w,y+h);glTexCoord2f(u,v2);glVertex2f(x,y+h);glEnd();glDisable(GL_TEXTURE_2D);
}
static void fighter(const ssf::Fighter&f,const char*label){
 glPushMatrix();glTranslatef(sx(f.x),sy(f.y),0);glRotatef(f.rotation,0,0,1);glTranslatef(-sx(f.x),-sy(f.y),0);
 sprite(f.sprite(),f.x,f.y,f.facing);
 glPopMatrix();
 if(f.anim==ssf::Shield){
  float cx=sx(f.x),cy=sy(f.y-46.f/3),r=ssf::shieldRadius(f)*game.camera.scale();
  glDisable(GL_TEXTURE_2D);glColor4f(.25f,.55f,1,.35f);glBegin(GL_TRIANGLE_FAN);glVertex2f(cx,cy);
  for(int i=0;i<=40;i++){float angle=i*6.2831853f/40;glVertex2f(cx+std::cos(angle)*r,cy+std::sin(angle)*r);}glEnd();
 }
 text(label,sx(f.x)-18,sy(f.y)-95,.75f,.5f,.9f,.8f);
 if(debugBoxes){auto frame=FRAMES[f.sprite()];for(int i=0;i<frame.count;i++){
  auto box=ssf::worldBox(BOXES[frame.offset+i],f);glColor4f(box.attack?1:.4f,box.attack?.35f:.7f,box.attack?.45f:1,1);
  glBegin(GL_LINE_LOOP);glVertex2f(sx(box.x),sy(box.y));glVertex2f(sx(box.x+box.w),sy(box.y));glVertex2f(sx(box.x+box.w),sy(box.y+box.h));glVertex2f(sx(box.x),sy(box.y+box.h));glEnd();
 }}
}
static void render(){
 glClear(GL_COLOR_BUFFER_BIT);glDisable(GL_TEXTURE_2D);glColor4f(.17f,.24f,.33f,1);
 glEnable(GL_SCISSOR_TEST);glScissor(0,72,960,396);
 glBegin(GL_TRIANGLE_FAN);for(const auto&p:TERRAIN)glVertex2f(sx(p.x),sy(p.y));glEnd();
 glColor4f(.4f,.8f,.72f,1);glBegin(GL_LINE_LOOP);for(const auto&p:TERRAIN)glVertex2f(sx(p.x),sy(p.y));glEnd();
 fighter(game.dummy,"TARGET");fighter(game.player,"P1");
 for(const auto&p:game.projectiles)if(p.active)sprite(p.sprite(),p.x,p.y,p.vx>=0?1:-1);
 glDisable(GL_SCISSOR_TEST);
 rect(0,0,960,76,.07f,.1f,.16f);rect(0,472,960,72,.07f,.1f,.16f);
  text("SSF2 / 0.52",22,10,1.5f);text("Mario + Final Destination | 30 Hz simulation",22,44,.95f,.6f,.72f,.8f);
 char buffer[200];snprintf(buffer,sizeof(buffer),"%.1f FPS | CPU %.2f ms | Atlas %d MiB",fps,cpuMs,ATLAS_W*ATLAS_H*4/(1024*1024));text(buffer,560,46,.9f,.5f,.85f,.75f);
 snprintf(buffer,sizeof(buffer),"Target %.1f%%   Hits %d   KOs %d / %d   Charge %d%%   AI %s   %s",game.dummy.damage,game.hits,game.player.kos,game.dummy.kos,ssf::isSmash(game.player.anim)?game.player.chargeTicks*100/ssf::FULL_CHARGE_TICKS:0,game.aiEnabled?"MED":"OFF",paused?"PAUSED":"");text(buffer,22,480,1.15f);
 text("Square/Triangle jump | Circle attack | X special | R shield | L grab | Select+Up AI",22,513,.85f,.65f,.75f,.85f);
 if(recoveryFailures)text("Recovery check failed - please send log.txt",22,106,1,1,.4f,.3f);
 if(debugBoxes){snprintf(buffer,sizeof(buffer),"x %.1f y %.1f | tick %d | L step paused | Start+Select exit",game.player.x,game.player.y,game.ticks);text(buffer,22,82,.9f);}
}
int main(){
 sceIoMkdir("ux0:data/SSF2P0001",0777);logFile=fopen("ux0:data/SSF2P0001/log.txt","w");
  log("SSF2 Vita prototype 0.52 - JPEXS sounds/source timing");log("Shared simulation: source animation frames; fixed 30 Hz");
 recoveryFailures=runRecoveryChecks(logFile);
 recoveryFailures+=runGroundAttackChecks(logFile);
 recoveryFailures+=runAerialChecks(logFile);
 recoveryFailures+=runMovementChecks(logFile);
 recoveryFailures+=runActionChecks(logFile);
 recoveryFailures+=runExtendedChecks(logFile);
 recoveryFailures+=runAiChecks(logFile);
 recoveryFailures+=runProtectionChecks(logFile);
 recoveryFailures+=runPcmChecks(logFile);
 game.aiEnabled=true;
 log("Initializing vitaGL");
 // The return value indicates resolution fallback, not initialization success.
 GLboolean resolutionFallback=vglInitExtended(8*1024*1024,960,544,32*1024*1024,SCE_GXM_MULTISAMPLE_NONE);
 log(resolutionFallback?"vitaGL returned; resolution fallback active":"vitaGL returned; requested resolution retained");
 vglWaitVblankStart(GL_TRUE);
 glViewport(0,0,960,544);glMatrixMode(GL_PROJECTION);glLoadIdentity();glOrtho(0,960,544,0,-1,1);glMatrixMode(GL_MODELVIEW);glLoadIdentity();
 glDisable(GL_DEPTH_TEST);glDisable(GL_CULL_FACE);glEnable(GL_BLEND);glBlendFunc(GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);glClearColor(.05f,.075f,.12f,1);
 atlas=loadTexture("app0:assets/mario.rgba",ATLAS_W,ATLAS_H);fontTexture=loadTexture("app0:assets/font.rgba",256,128);
 if(!atlas||!fontTexture){log("ERROR: could not load packaged assets");if(logFile)fclose(logFile);return 2;}
  sceCtrlSetSamplingMode(SCE_CTRL_MODE_ANALOG);log("Graphics and textures ready");
  sceIoMkdir("ux0:data/SSF2",0777);
  if(!audio.init()){char error[80];snprintf(error,sizeof(error),"Audio init failed: 0x%08x",(unsigned)audio.lastError.load());log(error);}else{log("Audio ready");audio.setVolume(32767);
   // Load the supplied stereo PCM data. Missing files keep their own -1 slot.
   int musicIdx=audio.loadClip("ux0:data/SSF2/Main Theme - Super Smash Bros_ Brawl-soConvert.pcm",true);
   if(musicIdx<0)log("Music missing/invalid in ux0:data/SSF2/");
    int loaded=0,failed=0;
    for(int i=0;i<SFX_COUNT;i++){
    char buf[128];snprintf(buf,sizeof(buf),"ux0:data/SSF2/%s-soConvert.pcm",sfxNames[i]);
    sfxIndices[i]=audio.loadClip(buf,true); // The supplied Mario PCM is already dual-mono stereo.
     if(sfxIndices[i]>=0)++loaded;else ++failed;
   }
    char audioStatus[140];snprintf(audioStatus,sizeof(audioStatus),"Source SFX loaded: %d/%d missing=%d music=%d",loaded,SFX_COUNT,failed,musicIdx);log(audioStatus);
   if(musicIdx>=0){audio.playMusic(musicIdx);log("Music loaded");}
  }
 uint32_t previousButtons=0;bool pendingJump=false,pendingAttack=false,pendingSpecialTap=false,pendingNormalTap=false,pendingGrab=false,running=true;
 int pendingTaunt=0;
 int pendingMove=ssf::Jab,pendingFacing=0,pendingSmash=0;
  SmashInputWindow smashWindow;
  int prevRsDirection=0;bool smashFromStick=false;
 auto clearPending=[&](){pendingJump=pendingAttack=pendingSpecialTap=pendingNormalTap=pendingGrab=false;pendingTaunt=0;};
 uint64_t last=sceKernelGetProcessTimeWide(),sampleStart=last,logStart=last;double accumulator=0,cpuSum=0;int frames=0;
 while(running){
  uint64_t begin=sceKernelGetProcessTimeWide();double delta=(begin-last)/1000000.;last=begin;
  SceCtrlData pad{};sceCtrlPeekBufferPositive(0,&pad,1);uint32_t pressed=pad.buttons&~previousButtons;previousButtons=pad.buttons;
  // Discard time spent suspended rather than running a burst of stale simulation steps.
  if(delta>.5){delta=0;clearPending();pressed=0;}
  if((pad.buttons&(SCE_CTRL_START|SCE_CTRL_SELECT))==(SCE_CTRL_START|SCE_CTRL_SELECT))running=false;
  if(pressed&SCE_CTRL_START){paused=!paused;clearPending();}
   if((pressed&SCE_CTRL_SELECT)&&!(pad.buttons&(SCE_CTRL_RTRIGGER|SCE_CTRL_TRIANGLE|SCE_CTRL_UP))){game.reset();smashWindow.reset();prevKos=0;prevPlayerDamage=prevDummyDamage=0;prevPlayerAnim=prevDummyAnim=ssf::Idle;prevPlayerFrame=prevDummyFrame=-1;playerHurtGate=HurtSoundGate{};dummyHurtGate=HurtSoundGate{};clearPending();}
  if((pressed&SCE_CTRL_SELECT)&&(pad.buttons&SCE_CTRL_UP)&&!(pad.buttons&(SCE_CTRL_RTRIGGER|SCE_CTRL_TRIANGLE))){game.aiEnabled=!game.aiEnabled;clearPending();}
   if((pressed&(SCE_CTRL_SELECT|SCE_CTRL_RTRIGGER))&&(pad.buttons&SCE_CTRL_SELECT)&&(pad.buttons&SCE_CTRL_RTRIGGER)){game.heavyTest();smashWindow.reset();prevKos=0;prevPlayerDamage=prevDummyDamage=0;prevPlayerAnim=prevDummyAnim=ssf::Idle;prevPlayerFrame=prevDummyFrame=-1;playerHurtGate=HurtSoundGate{};dummyHurtGate=HurtSoundGate{};clearPending();}
  if(!(pad.buttons&SCE_CTRL_SELECT))pendingGrab|=!!(pressed&SCE_CTRL_LTRIGGER);
  if(!(pad.buttons&SCE_CTRL_SELECT))pendingJump|=!!(pressed&(SCE_CTRL_SQUARE|SCE_CTRL_TRIANGLE));
  ssf::Input in;
  bool left=(pad.buttons&SCE_CTRL_LEFT)||pad.lx<88,right=(pad.buttons&SCE_CTRL_RIGHT)||pad.lx>168;
  bool up=(pad.buttons&SCE_CTRL_UP)||pad.ly<88,down=(pad.buttons&SCE_CTRL_DOWN)||pad.ly>168;
  if((pressed&SCE_CTRL_TRIANGLE)&&(pad.buttons&SCE_CTRL_SELECT))debugBoxes=!debugBoxes;
  bool dirHeld=left||right||up||down;
  auto advanceSmashWindow=[&](){
   smashWindow.tick(dirHeld,pad.buttons&SCE_CTRL_CIRCLE,pad.buttons&SCE_CTRL_CROSS,
    game.player.anim==ssf::Land||game.player.anim==ssf::SpecialLand||game.player.anim==ssf::DodgeLand||game.player.landingLock>0,
    game.player.anim==ssf::Skid);
  };
  advanceSmashWindow();
  // Right-stick smash shortcut.
  bool rsUp=pad.ry<88,rsDown=pad.ry>168,rsLeft=pad.rx<88,rsRight=pad.rx>168;
  bool rsDeflected=rsUp||rsDown||rsLeft||rsRight;
  int rsDirection=rsUp?1:rsDown?2:rsRight?3:rsLeft?4:0;
  bool rsJustDeflected=rsDirection&&rsDirection!=prevRsDirection;
  prevRsDirection=rsDirection;
  if(!(pad.buttons&SCE_CTRL_SELECT)&&((pressed&SCE_CTRL_CIRCLE)||rsJustDeflected)){
   smashFromStick=rsJustDeflected;
   pendingAttack=pendingNormalTap=true;
   if(rsJustDeflected){
    if(!game.player.grounded){
     int direction=rsRight?1:rsLeft?-1:0;
     pendingMove=rsUp?ssf::UAir:rsDown?ssf::DAir:direction==game.player.facing?ssf::FAir:ssf::BAir;pendingFacing=0;
    }
    else if(rsUp){pendingMove=ssf::USmash;pendingFacing=0;}
    else if(rsDown){pendingMove=ssf::DSmash;pendingFacing=0;}
    else {pendingMove=ssf::FSmash;pendingFacing=rsRight?1:(rsLeft?-1:0);}
   } else {
    bool isSmash=dirHeld&&smashWindow.allows(up||down);
    pendingFacing=up||down?0:(int)right-(int)left;
    if(!game.player.grounded){
     int direction=(int)right-(int)left;
     pendingMove=up?ssf::UAir:down?ssf::DAir:direction==0?ssf::NAir:direction==game.player.facing?ssf::FAir:ssf::BAir;
     pendingFacing=0;
    } else {
     if(up)pendingMove=isSmash?ssf::USmash:ssf::UTilt;
     else if(down)pendingMove=isSmash?ssf::DSmash:ssf::DTilt;
     else if(game.player.dashDir&&!isSmash)pendingMove=ssf::DashAttack;
     else if(left||right)pendingMove=isSmash?ssf::FSmash:ssf::FTilt;
     else pendingMove=ssf::Jab;
    }
   }
  }
  if((pressed&SCE_CTRL_CROSS)&&!(pad.buttons&SCE_CTRL_SELECT)){
   pendingAttack=pendingSpecialTap=true;pendingFacing=up||down?0:(int)right-(int)left;
   pendingMove=up?ssf::USpecial:down?ssf::DSpecial:left||right?ssf::SSpecial:ssf::NSpecial;
  }
  in.axis=(int)right-(int)left;in.up=up;in.jumpHeld=pad.buttons&(SCE_CTRL_SQUARE|SCE_CTRL_TRIANGLE);in.fastFall=(pad.buttons&SCE_CTRL_DOWN)||pad.ly>168;
  in.attackMove=pendingMove;in.attackFacing=pendingFacing;in.shield=!paused&&!(pad.buttons&SCE_CTRL_SELECT)&&(pad.buttons&SCE_CTRL_RTRIGGER);in.smashHeld=smashFromStick?rsDeflected:!!(pad.buttons&SCE_CTRL_CIRCLE);
  if(pendingAttack&&pendingFacing)in.axis=pendingFacing;
  if(paused){accumulator=0;if(pressed&SCE_CTRL_LTRIGGER){in.jump=pendingJump;in.attack=pendingAttack;in.specialPressed=pendingSpecialTap;in.normalAttackPressed=pendingNormalTap;in.grab=pendingGrab;in.taunt=pendingTaunt;game.tick(in);updateGameplayAudio();}clearPending();}
  else {accumulator+=std::min(delta,.15);while(accumulator>=1./30){in.jump=pendingJump;in.attack=pendingAttack;in.specialPressed=pendingSpecialTap;in.normalAttackPressed=pendingNormalTap;in.grab=pendingGrab;in.taunt=pendingTaunt;clearPending();game.tick(in);updateGameplayAudio();accumulator-=1./30;}}
  render();cpuSum+=(sceKernelGetProcessTimeWide()-begin)/1000.;++frames;
  vglSwapBuffers(GL_FALSE);uint64_t now=sceKernelGetProcessTimeWide();
  if(now-sampleStart>=1000000){fps=frames*1000000.f/(now-sampleStart);cpuMs=cpuSum/frames;frames=0;cpuSum=0;sampleStart=now;}
   if(now-logStart>=5000000){if(logFile){fprintf(logFile,"ticks=%d fps=%.1f cpu_ms=%.3f hits=%d kos=%d/%d audio=%d blocks=%u error=0x%08x\n",game.ticks,fps,cpuMs,game.hits,game.player.kos,game.dummy.kos,audio.ready?1:0,(unsigned)audio.outputBlocks.load(),(unsigned)audio.lastError.load());fflush(logFile);}logStart=now;}
 }
 log("Clean exit");audio.shutdown();glDeleteTextures(1,&atlas);glDeleteTextures(1,&fontTexture);if(logFile)fclose(logFile);sceKernelExitProcess(0);return 0;
}





