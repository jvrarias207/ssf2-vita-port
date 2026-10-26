#pragma once
#include "recovery-checks.h"
#include "smash-input.h"
inline int runGroundAttackChecks(FILE* output){
 int failures=0;
 auto check=[&](bool ok,const char*name){if(!ok)++failures;if(output)fprintf(output,"%s: %s\n",ok?"PASS":"FAIL",name);};
 {SmashInputWindow window;
  for(int age=0;age<=5;++age){
   check(window.allows(true)==(age<4),"Vertical smash grace expires at four simulation ticks");
   check(window.allows(false)==(age<5),"Side smash grace expires at five simulation ticks");
   window.tick(true,false,false,false,false);
  }
  window.tick(false,true,false,false,false);
  check(!window.allows(false),"Holding attack does not rearm smash selection");
  window.tick(false,false,true,false,false);
  check(!window.allows(false),"Holding special does not rearm smash selection");
  window.tick(false,false,false,false,true);
  check(!window.allows(false),"Skidding does not rearm smash selection");
  window.tick(false,false,false,false,false);
  check(window.allows(true),"Neutral simulation tick rearms the smash window");
  window.tick(false,false,false,true,false);
  check(!window.allows(false),"Landing kills the source smash timer");
  window.reset();check(window.allows(true),"Match reset restores immediate smash selection");
 }
 // Contact the source hitboxes directly at their first active frame, including
 // positions above/behind the fighter. Do not depend on a single target placement.
 const int active[]={2,2,2,47,45,42};
 for(int move=ssf::FTilt;move<=ssf::DSmash;move++)for(int facing:{-1,1}){
  bool connected=false;
  for(int x=-60;x<=90&&!connected;x+=10)for(int y=0;y>=-60&&!connected;y-=10){
   ssf::Game g;g.player.x=0;g.player.facing=facing;g.dummy.x=x*facing;g.dummy.y=GROUND+y;
   g.startAttack(g.player,move);g.player.smashReleased=true;g.player.frame=active[move-ssf::FTilt];g.hit();
   if(g.hits){
    connected=true;float damage=g.dummy.damage;g.player.freeze=0;g.hit();
    check(g.hits==1&&g.dummy.damage==damage,"Ground attack damages a target only once across boxes");
   }
  }
  check(connected,"Source tilt/smash hitboxes connect in both facings");
 }
 for(int move=ssf::FSmash;move<=ssf::DSmash;move++){
  ssf::Game g;g.dummy.x=700;g.startAttack(g.player,move);ssf::Input hold;hold.smashHeld=true;
  for(int i=0;i<100;i++)g.tick(hold);
   check(g.player.anim==move&&!g.player.smashReleased&&g.player.chargeTicks==ssf::FULL_CHARGE_TICKS&&g.hits==0,"Smash caps at 60 and remains held within the extra 120 ticks");
  g.tick();check(g.player.frame==ssf::releaseFrame(move)&&g.player.smashReleased,"Smash release enters source attack label");
  for(int i=0;i<30;i++)g.tick();check(g.player.anim==ssf::Idle,"Smash reaches endAttack and returns control");
  g.reset();g.startAttack(g.player,move);for(int i=0;i<8&&!g.player.smashReleased;i++)g.tick();
  check(g.player.smashReleased&&g.player.chargeTicks==0,"Quick smash tap releases without mandatory charge");
 }
 ssf::Fighter f;f.anim=ssf::FSmash;
 check(ssf::attackStats(f,1).damage==17&&ssf::attackStats(f,2).damage==14,"Forward smash retains sweetspot and inner-hitbox damage");
 f.anim=ssf::DSmash;f.frame=42;auto front=ssf::attackStats(f,1);f.frame=46;auto rear=ssf::attackStats(f,1);
 check(front.damage==14&&rear.damage==10&&rear.power==35&&rear.kbc==75,"Down smash rear swing uses source frame-47 stat change");
 bool chargeCompared=false;
 for(int x=0;x<=90&&!chargeCompared;x+=5){
  ssf::Game base,charged;
  for(auto g:{&base,&charged}){g->player.x=0;g->dummy.x=(float)x;g->startAttack(g->player,ssf::FSmash);g->player.smashReleased=true;g->player.frame=47;}
   charged.player.chargeTicks=ssf::FULL_CHARGE_TICKS;base.hit();charged.hit();
  if(base.hits){chargeCompared=true;check(charged.hits==1&&std::abs(charged.dummy.damage-base.dummy.damage*1.4f)<.001f&&charged.lastKnockback>base.lastKnockback,"Full charge increases actual hit damage and resulting knockback");}
 }
 check(chargeCompared,"Charged hit comparison found contact");
 auto jab=ssf::AttackStats{3,80,0,100,20,3};
 check(std::abs(ssf::calculateKnockback(jab,3,0,100)-33.4f)<.001f,"General attack data preserves validated Mario jab knockback");
 check(ssf::calculateKnockback(jab,3,0,150)<ssf::calculateKnockback(jab,3,0,100),"Heavier future characters receive less knockback");
 if(output){fprintf(output,"Ground attack checks: %d failures\n",failures);fflush(output);}return failures;
}
