#pragma once
#include "simulation.h"
#include <cstdio>
inline int runMovementChecks(FILE* output){
 int failures=0;
 auto check=[&](bool ok,const char*name){if(!ok)++failures;if(output)fprintf(output,"%s: %s\n",ok?"PASS":"FAIL",name);};
 for(int side:{-1,1}){
  ssf::Game g;g.dummy.x=700;ssf::Input in;in.axis=side;
  g.tick(in);check(std::abs(g.player.vx-side*2.f)<.001f,"Walk begins at source AccelStart * NormXSpeed");
  g.tick();g.tick(in);
  check(g.player.anim==ssf::Dash&&std::abs(g.player.vx-side*12.1f)<.001f,"Dash begins at source frame 16 and AccelStartDash * MaxXSpeed");
  in.axis=-side;float speed=std::abs(g.player.vx);g.tick(in);
  check(g.player.anim==ssf::Dash&&g.player.facing==-side&&std::abs(g.player.vx)>=speed-1.1f-.001f,"Quick dash dance reverses facing and preserves momentum without forced minimum boost");
  for(int i=0;i<8;i++)g.tick(in);
  check(g.player.anim==ssf::Run&&std::abs(g.player.vx+side*11.f)<.001f,"Dash-start redirects to run at source frame 21");
  in.axis=side;g.tick(in);
  check(g.player.anim==ssf::Turn&&g.player.frame==0&&g.player.facing==-side,"Run reversal starts source turn frame 22 in original facing");
  for(int i=0;i<9;i++)g.tick(in);
  check(g.player.anim==ssf::Run&&g.player.facing==side&&g.player.dashDir==side,"Turn frame 31 returns to run and flips facing once");
  for(int i=0;i<12;i++)g.tick(in);
  g.tick();check(g.player.anim==ssf::Skid&&g.player.frame==0,"Releasing run enters skid immediately, ahead of speed-based run selection");
  bool seen[7]={true};
  for(int i=0;i<6;i++){g.tick();if(g.player.anim==ssf::Skid)seen[g.player.frame]=true;}
  bool sequence=true;for(int i=0;i<6;i++)sequence&=seen[i];
  check(sequence&&g.player.anim==ssf::Idle,"Skid advances through frames 1-6 then executes source frame-7 endAttack");
  g.reset();g.player.x=0;g.player.y=GROUND-1;g.player.vy=3;g.player.grounded=false;g.player.setAnim(ssf::Fall);g.tick();
  check(g.player.anim==ssf::Land&&g.player.frame==0&&g.player.landingLock==2,"Ordinary airborne landing enters normal Land sequence");
  g.tick();check(g.player.anim==ssf::Land&&g.player.frame==1,"Normal landing plays source frame 2");
  g.tick();check(g.player.anim==ssf::Idle&&g.player.landingLock==0,"Source Land frame 3 restores control without playing dodgeland");
  g.reset();g.player.facing=-side;g.player.setAnim(ssf::Turn);g.player.turnDir=-side;
  in={};in.attack=true;in.attackMove=ssf::FSmash;in.attackFacing=side;g.tick(in);
  check(g.player.anim==ssf::FSmash&&g.player.facing==side,"Side-smash facing override works even while turning");
  auto beginDash=[&](){g.reset();g.dummy.x=700;in={};in.axis=side;g.tick(in);g.tick();g.tick(in);};
  beginDash();g.tick();
  check(g.player.anim==ssf::Dash&&g.player.dashStopPending&&g.player.dashDir==side,"Initial dash release queues a stop without interrupting acceleration");
  for(int i=0;i<3;i++)g.tick();
  check(g.player.anim==ssf::Dash,"Released dash retains its remaining acceleration frames");
  g.tick();check(g.player.anim==ssf::Skid&&!g.player.dashStopPending&&g.player.dashDir==0,"Initial dash enters skid at its terminal frame rather than run");
  for(int i=0;i<20;i++)g.tick();
  float stoppedX=g.player.x;g.tick();
  check(g.player.anim==ssf::Idle&&g.player.vx==0&&g.player.x==stoppedX,"No directional input after skid comes to a complete stop");
  beginDash();for(int i=0;i<5;i++)g.tick();
  g.tick(in);check(g.player.anim==ssf::Walk&&g.player.dashDir==0,"First single directional press during skid selects walking, not a stale double tap");
  for(int i=0;i<6;i++)g.tick(in);
  check(g.player.anim==ssf::Walk&&std::abs(g.player.vx-side*ssf::WALK_SPEED)<.001f,"Holding that single press settles at walk speed");
  g.tick();g.tick(in);
  check(g.player.anim==ssf::Dash&&g.player.dashDir==side&&std::abs(g.player.vx-side*12.1f)<.001f,"A new double tap restarts dash acceleration from walking");
  beginDash();g.tick();g.tick(in);
  check(g.player.anim==ssf::Walk&&!g.player.dashStopPending&&g.player.dashDir==0,"A single press can cancel a queued dash stop into walking");
 }
 {
  ssf::Game g;ssf::Input down;down.fastFall=true;
  auto falling=[&](float vy){g.reset();g.player.x=0;g.player.y=GROUND-180;g.player.grounded=false;g.player.vy=vy;g.player.setAnim(ssf::Fall);};
  falling(2);float y=g.player.y;g.tick(down);
  check(g.player.vy==16&&std::abs(g.player.y-y-16)<.001f,"Fresh Down while descending immediately sets source FastFallSpeed 16");
  g.tick();check(g.player.vy==16,"Fast fall persists after releasing Down instead of clamping back to 13");
  for(int i=0;i<20&&!g.player.grounded;i++)g.tick();
  check(g.player.grounded&&g.player.vy==0&&g.player.anim==ssf::Land,"Fast fall ends at ground contact and enters normal landing");
  falling(-6);g.tick(down);
  check(g.player.vy<0,"Down during ascent does not cancel the upward jump");
  g.player.vy=1;g.tick(down);
  check(std::abs(g.player.vy-2.3f)<.001f,"Holding Down from ascent does not retrigger fast fall on descent");
  g.tick();g.tick(down);check(g.player.vy==16,"Release and repress Down during descent triggers fast fall");
  falling(12.5f);g.tick();check(g.player.vy==13,"Normal gravity caps at source max_ySpeed 13");
  falling(2);g.startAttack(g.player,ssf::UAir);g.tick(down);
  check(g.player.anim==ssf::UAir&&g.player.vy==16,"Source up-air allows fast fall without replacing its animation");
  falling(2);g.player.injured=true;g.player.stun=10;g.player.setAnim(ssf::Hurt);g.tick(down);
  check(g.player.vy<16,"Fast fall cannot be activated while injured");
  falling(2);g.respawn(g.player,0);g.tick();
  check(g.player.vy<16&&!g.player.downHeld,"Respawn resets fast fall and Down history");
 }
 for(int move=ssf::FSmash;move<=ssf::DSmash;move++){
  ssf::Game g;g.dummy.x=700;g.startAttack(g.player,move);g.player.frame=ssf::chargeStart(move);ssf::Input hold;hold.smashHeld=true;
  for(int i=0;i<60;i++)g.updateFighter(g.player,hold);
  check(g.player.chargeTicks==60&&g.player.chargeHold==0&&!g.player.smashReleased,"Full charge takes exactly 60 charging ticks");
  for(int i=0;i<119;i++)g.updateFighter(g.player,hold);
  check(g.player.chargeTicks==60&&g.player.chargeHold==119&&!g.player.smashReleased,"119 extra hold ticks neither release nor increase damage");
  g.updateFighter(g.player,hold);
  check(g.player.smashReleased&&g.player.frame==ssf::releaseFrame(move)&&g.player.chargeTicks==60,"120th extra tick auto-releases at full capped damage");
 }
 if(output){fprintf(output,"Movement checks: %d failures\n",failures);fflush(output);}return failures;
}
