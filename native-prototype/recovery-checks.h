#pragma once
#include <cstdio>
#include "simulation.h"

// Exercises the real shared simulation. On Vita this runs before graphics startup
// and writes results to log.txt; it does not alter the playable Game instance.
inline int runRecoveryChecks(FILE* output){
 int failures=0;
 auto check=[&](bool ok,const char* name){if(!ok)++failures;if(output)fprintf(output,"%s: %s\n",ok?"PASS":"FAIL",name);};
 ssf::Game g;
 for(int side:{-1,1})for(int phase=1;phase<=3;phase++){
  g.reset();g.player.x=-10.f*side;g.player.facing=side;g.dummy.x=20.f*side;g.dummy.facing=-side;
  g.startJab(g.player,phase);for(int i=0;i<8&&g.hits==0;i++)g.tick();
  float expectedDamage=phase==1?3.f:phase==2?2.f:5.f;
  float expectedAngle=phase==1?80.f:phase==2?70.f:45.f;
  float actualAngle=std::atan2(-g.dummy.ky,std::abs(g.dummy.kx))*180.f/3.14159265358979323846f;
  check(g.hits==1&&g.dummy.damage==expectedDamage,"Source jab percentage, both facings");
  check(std::abs(actualAngle-expectedAngle)<.01f&&g.dummy.kx*side>0,"Source jab launch vector, both facings");
  check(g.dummy.stun==(phase<3?6:12)&&g.dummy.freeze==3,"Moving recovery and stationary hitstun are separate");
 }
 g.reset();g.dummy.x=0;g.dummy.y=GROUND-200;g.dummy.grounded=false;
 g.dummy.kx=3;g.dummy.ky=-4;g.dummy.decayX=.1067328f;g.dummy.decayY=.1423104f;
 float initialY=g.dummy.y;g.tick();
 check(std::abs(g.dummy.x-5.8932672f)<.001f&&std::abs((g.dummy.y-initialY)-(-6.5576896f))<.001f,"Two source knockback substeps plus independent gravity");
 check(std::abs(g.dummy.kx-2.7865344f)<.001f&&std::abs(g.dummy.ky-(-3.7153792f))<.001f,"Vector knockback decays twice per 30-Hz tick");
 for(int phase=1;phase<=3;phase++){
  g.heavyTest();g.startJab(g.player,phase);
  for(int i=0;i<8&&g.hits==0;i++)g.tick();
  check(g.hits==1&&g.dummy.freeze==3&&g.player.freeze==(phase==2?1:2),"Impact pause uses action-shot timing, not knockback recovery");
  float x=g.dummy.x,y=g.dummy.y;
  for(int i=0;i<4;i++)g.tick();
  check(g.dummy.freeze==0&&(g.dummy.x!=x||g.dummy.y!=y),"Target moves again after three impact-pause ticks");
 }
 g.heavyTest();g.startJab(g.player,3);
 bool flying=false,tumble=false,landing=false,gettingUp=false;
 for(int i=0;i<260;i++){
  g.tick();flying|=g.dummy.anim==ssf::Flying;tumble|=g.dummy.anim==ssf::Tumble;
  landing|=g.dummy.anim==ssf::GetUp&&g.dummy.frame<=13;
  gettingUp|=g.dummy.anim==ssf::GetUp&&g.dummy.frame>=15;
 }
 check(g.hits==1&&g.dummy.damage==65,"Heavy finisher connects once");
 check(flying&&tumble&&landing&&gettingUp,"Heavy hit visits flight, tumble, landing and getup");
 check(g.dummy.anim==ssf::Idle&&g.dummy.grounded&&!g.dummy.heavyHit,"Heavy recovery returns to grounded idle");
 g.reset();g.player.x=-10;g.dummy.x=20;g.startJab(g.player,3);bool lowHeavy=false;
 for(int i=0;i<100;i++){g.tick();lowHeavy|=g.dummy.heavyHit||g.dummy.anim==ssf::GetUp;}
 check(g.hits==1&&!lowHeavy,"Low-damage finisher keeps light-hit recovery");
 g.reset();g.dummy.setAnim(ssf::GetUp);g.dummy.frame=13;g.dummy.downTicks=13;
 for(int i=0;i<96;i++)g.tick();check(g.dummy.frame==13,"Downed target waits until automatic getup timer");
 g.tick();check(g.dummy.frame==15&&ssf::Game::intangible(g.dummy),"Getup starts on source frame 16 with intangibility");
 for(int i=0;i<10;i++)g.tick();check(g.dummy.frame==25&&!ssf::Game::intangible(g.dummy),"Getup intangibility ends on source frame 26");
 for(int i=0;i<5;i++)g.tick();check(g.dummy.anim==ssf::Idle,"Getup ends on source frame 31");
 g.reset();g.dummy.x=RIGHT+80;g.dummy.y=GROUND+30;g.dummy.grounded=false;g.dummy.injured=true;g.dummy.heavyHit=true;g.dummy.setAnim(ssf::Tumble);
 for(int i=0;i<160;i++)g.tick();check(g.dummy.kos==1&&!g.dummy.heavyHit&&g.dummy.anim==ssf::Idle,"Offstage tumble still KOs and respawns");
 if(output){fprintf(output,"Recovery checks: %d failures\n",failures);fflush(output);}return failures;
}
