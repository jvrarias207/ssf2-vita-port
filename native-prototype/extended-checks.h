#pragma once
#include "simulation.h"
#include <cstdio>
inline int runExtendedChecks(FILE* output){
 int failures=0;
 auto check=[&](bool ok,const char*name){if(!ok)++failures;if(output)fprintf(output,"%s: %s\n",ok?"PASS":"FAIL",name);};
 for(int side:{-1,1}){
  ssf::Game g;
  auto grab=[&](bool shielding=false){
   g.reset();g.player.x=0;g.player.facing=side;g.dummy.x=side*30;g.dummy.facing=-side;
   ssf::Input in,enemy;in.grab=true;enemy.shield=shielding;g.tick(in,enemy);
   for(int i=0;i<12&&g.player.grabTarget<0;i++)g.tick({},enemy);
  };
  grab();check(g.player.anim==ssf::GrabHold&&g.player.grabTarget==1&&g.dummy.grabbedBy==0,"Standing grab catches using original grabBox and enters source hold pose in both facings");
  check(g.player.grabTimer==45,"Zero-percent grab duration follows Utils.calculateGrabLength");
  ssf::Input pummel;pummel.attack=true;g.tick(pummel);
  for(int i=0;i<4;i++)g.tick();
  check(g.dummy.damage==0,"Pummel waits for its authored active box rather than the earlier stat-refresh event");
  g.tick();check(g.dummy.damage==1,"Pummel's source frame 46 deals grabDamage 1 exactly once");
  for(int i=0;i<14;i++)g.tick();check(g.player.anim==ssf::GrabHold&&g.dummy.damage==1,"Pummel ends at source frame 51 and returns to holding");
   grab(true);check(g.player.grabTarget==1&&g.dummy.grabbedBy==0,"Grab bypasses shielding without treating it as a damage hit");
   for(int action:{ssf::Grab,ssf::DashGrab}){
    const int active=action==ssf::Grab?4:6; // Mario's exported grabBox, one-based.
    bool authoredWindow=true;
    for(int frame=0;frame<ANIM_COUNT[action];++frame){
     Frame markers=MARKER_FRAMES[ANIM_START[action]+frame];bool hasGrabBox=false;
     for(int j=0;j<markers.count;++j)hasGrabBox|=MARKERS[markers.offset+j].attack==1;
     authoredWindow&=hasGrabBox==(frame+1==active);
    }
    check(authoredWindow,"Grab and dash grab have exactly one authored active frame");
    auto setup=[&](int frame){
     g.reset();g.player.x=0;g.player.y=GROUND;g.player.facing=side;g.player.anim=action;g.player.frame=frame-1;
     g.dummy.x=30*side;g.dummy.y=GROUND;g.dummy.facing=-side;
    };
    setup(active-1);g.updateGrabs();
    check(g.player.grabTarget<0,"Grab startup frame cannot capture");
    setup(active+1);g.updateGrabs();
    check(g.player.grabTarget<0,"Grab recovery frame cannot capture");
    setup(active);g.updateGrabs();
    check(g.player.grabTarget==1,"Authored active frame captures grounded opponent");
    setup(active);g.dummy.anim=ssf::FAir;g.dummy.grounded=true;
    check(!ssf::fighterGrabbable(g.dummy),"Landing aerial pose is not standing-grabbable");
    g.updateGrabs();check(g.player.grabTarget<0,"Grab cannot catch deferred airborne pose on landing tick");

    // Position a real airborne hurtbox inside the exported grabBox. A missed
    // grab without overlap would not test the airborne rule at all.
    bool overlapsAir=false;int airX=0,airHeight=0;
    for(int x=5;x<=50&&!overlapsAir;x+=5)for(int height=5;height<=45&&!overlapsAir;height+=5){
     setup(active);g.dummy.x=x*side;g.dummy.y=GROUND-height;g.dummy.grounded=false;
     Frame markers=MARKER_FRAMES[g.player.sprite()],hurt=FRAMES[g.dummy.sprite()];
     for(int i=0;i<markers.count;i++)if(MARKERS[markers.offset+i].attack==1)
      for(int j=0;j<hurt.count;j++)if(!BOXES[hurt.offset+j].attack&&
       ssf::overlaps(ssf::worldBox(MARKERS[markers.offset+i],g.player),
                     ssf::worldBox(BOXES[hurt.offset+j],g.dummy))){overlapsAir=true;airX=x;airHeight=height;}
    }
    check(overlapsAir,"Airborne hurtbox actually overlaps the active grabBox");
    if(overlapsAir){
     check(!ssf::fighterGrabbable(g.dummy),"Airborne fighter cannot be grabbed");
     g.updateGrabs();check(g.player.grabTarget<0&&g.dummy.grabbedBy<0,
      "Active standing/dash grab whiffs on airborne opponent");
     g.dummy.grounded=true;g.updateGrabs();
     check(g.player.grabTarget<0,"Stale grounded flag above stage does not allow a grab");
     setup(active-1);g.dummy.x=airX*side;g.dummy.y=GROUND-airHeight;g.dummy.grounded=false;
     g.player.frame=active-2; // advance() moves to the one active frame this tick.
     g.tick();
     check(g.player.grabTarget<0&&g.dummy.grabbedBy<0,
      "Simulation tick also rejects an airborne hurtbox on the active frame");
    }
   }
   grab();for(int i=0;i<50;i++)g.tick();
  check(g.player.grabTarget<0&&g.dummy.grabbedBy<0&&g.dummy.anim!=ssf::Caught,"Expired grab releases both participants without leaving a caught pose");
  grab();int timer=g.player.grabTimer;ssf::Input mash;mash.attack=mash.normalAttackPressed=true;mash.specialPressed=true;mash.axis=side;g.tick({},mash);
  check(g.player.grabTimer==timer-13,"Victim struggle uses four frames per direction/attack/special input group plus normal timer decay");
  for(int i=0;i<5;i++){g.tick();g.tick({},mash);}
  check(g.dummy.grabbedBy<0,"Mashing can escape a grab before its passive timer");
  for(int move=ssf::FThrow;move<=ssf::DThrow;move++){
   grab();ssf::Input in;
   if(move==ssf::FThrow)in.axis=side;
   if(move==ssf::BThrow)in.axis=-side;
   if(move==ssf::UThrow)in.up=true;
   if(move==ssf::DThrow)in.fastFall=true;
   g.tick(in);check(g.player.anim==move,"Held directional input selects the matching source throw");
   int active=move==ssf::FThrow?10:move==ssf::BThrow?26:move==ssf::UThrow?12:10;
   for(int i=0;i<active-1;i++)g.tick();
   check(g.dummy.damage==0&&g.dummy.grabbedBy==0,"Throw keeps the victim attached until its authored release box");
   g.tick();float damage=move==ssf::FThrow?9:move==ssf::BThrow?12:move==ssf::UThrow?8:9;
   check(g.dummy.damage==damage&&g.dummy.grabbedBy<0&&g.player.grabTarget<0&&g.hits==1,"Throw releases once at its source active frame with original damage");
   check(move==ssf::BThrow?g.dummy.kx*side<0:g.dummy.kx*side>0,"Throw knockback mirrors correctly, including backward throw");
   for(int i=0;i<35;i++)g.tick();check(!ssf::isThrow(g.player.anim),"Throw returns control after its original terminal event");
  }
  g.reset();g.player.facing=side;g.startAttack(g.player,ssf::DashAttack);
  check(g.player.anim==ssf::DashAttack&&g.player.vx==side*14,"Dash attack uses authored startup movement 14");
  g.player.frame=4;check(ssf::attackStats(g.player,1).damage==7,"Dash attack weakens on source frame 5");
  // Locate a real hand helper and align it with the stage's exported ledge bounds.
  g.reset();g.player.anim=ssf::Fall;g.player.frame=1;g.player.facing=-side;g.player.grounded=false;g.player.vy=2;
  g.dummy.x=0;Frame hands=MARKER_FRAMES[g.player.sprite()];bool setup=false;
  for(int i=0;i<hands.count;i++){Box h=MARKERS[hands.offset+i];if(h.attack!=3)continue;auto local=ssf::worldBox(h,g.player);
   float ledge=side<0?LEFT:RIGHT;
   g.player.x+=ledge-(local.x+local.w/2);g.player.y+=GROUND-(local.y+local.h/2);setup=true;break;
  }
  g.tryLedge(g.player,{});
  check(setup&&g.player.anim==ssf::Hang&&g.player.facing==-side&&g.player.airJumps==1,"Source hand geometry grabs the ledge, faces inward, and restores recovery");
  if(g.player.anim==ssf::Hang){
   float x=g.player.x,y=g.player.y;for(int i=0;i<5;i++)g.tick();
   check(g.player.anim==ssf::Hang&&g.player.x==x&&g.player.y==y,"Ledge hang stays attached rather than falling through body collision");
   check(ssf::Game::intangible(g.player),"Initial ledge hang intangibility matches the source 14-tick window");
   ssf::Input climb;climb.up=true;g.tick(climb);
   check(g.player.anim==ssf::HangClimb&&g.player.grounded,"Up from ledge starts authored climb animation");
   for(int i=0;i<18;i++)g.tick();check(g.player.anim!=ssf::HangClimb,"Ledge climb completes and returns control");
  }
  for(int action:{ssf::HangRoll,ssf::HangAttack}){
   g.reset();g.player.x=side<0?LEFT:RIGHT;g.player.y=GROUND;g.player.grounded=false;g.player.facing=-side;g.player.anim=ssf::Hang;g.player.ledgeSide=side;g.player.ledgeAge=5;
   ssf::Input in;in.shield=action==ssf::HangRoll;in.attack=action==ssf::HangAttack;g.tick(in);
   check(g.player.anim==action&&ssf::Game::intangible(g.player),"Ledge roll/attack enters original action and authored intangibility");
   for(int i=0;i<27;i++)g.tick();check(g.player.grounded&&!ssf::isAttack(g.player.anim)&&g.player.anim!=action,"Ledge roll/attack finishes safely on stage");
  }
  g.reset();g.player.anim=ssf::Hang;g.player.x=side<0?LEFT:RIGHT;g.player.y=GROUND;g.player.facing=-side;g.player.grounded=false;g.player.ledgeAge=5;
  ssf::Input drop;drop.fastFall=true;g.tick(drop);
  check(g.player.anim==ssf::Fall&&g.player.ledgeCooldown>0,"Ledge drop applies the source re-grab cooldown");
  for(int action:{ssf::DodgeRoll,ssf::SpotDodge}){
   g.reset();ssf::Input in;in.shield=true;g.tick(in);if(action==ssf::DodgeRoll)in.axis=side;else in.fastFall=true;g.tick(in);
   check(g.player.anim==action,"Shield direction selects roll or spot dodge");
   for(int i=0;i<2;i++)g.tick();check(ssf::Game::intangible(g.player),"Dodge becomes intangible on original script frames");
   for(int i=0;i<20;i++)g.tick();check(g.player.anim!=action,"Dodge ends at its source terminal frame");
  }
  g.reset();g.player.y=GROUND-60;g.player.grounded=false;g.player.vy=1;ssf::Input dodge;dodge.shield=true;g.tick(dodge);
  check(g.player.anim==ssf::AirDodge,"Airborne shield press enters original air-dodge animation");
  for(int i=0;i<15&&!g.player.grounded;i++)g.tick();
  check(g.player.grounded&&g.player.anim==ssf::DodgeLand,"Air dodge uses the separate source dodgeland branch on touchdown");
  for(int i=0;i<5;i++)g.tick();check(g.player.landingLock==0,"Dodge landing restores control after its own source event");
  for(int action:{ssf::GetUpRoll,ssf::GetUpAttack}){
   g.reset();g.player.anim=ssf::GetUp;g.player.frame=13;g.player.downTicks=14;ssf::Input in;if(action==ssf::GetUpRoll)in.axis=side;else in.attack=true;g.tick(in);
   check(g.player.anim==action,"Downed input selects get-up roll or attack after source crash delay");
  }
  g.reset();g.player.x=0;g.player.y=GROUND-1;g.player.grounded=false;g.player.vy=3;g.player.injured=g.player.heavyHit=true;g.player.anim=ssf::Tumble;
  ssf::Input tech;tech.shield=true;tech.axis=side;g.tick(tech);
  check(g.player.anim==ssf::TechRoll&&!g.player.injured&&ssf::Game::intangible(g.player),"Timed shield input at heavy landing starts source tech roll");
  g.reset();g.player.x=0;g.player.y=GROUND-150;g.player.grounded=false;g.player.injured=g.player.heavyHit=true;g.player.stun=0;g.player.injuryTicks=40;g.player.anim=ssf::Tumble;g.player.vy=1;
  ssf::Input recover;recover.jump=true;g.tick(recover);
  check(!g.player.injured&&g.player.anim==ssf::DoubleJump&&g.player.vy<0&&g.player.airJumps==0,"Expired heavy-hit recovery allows a midair jump out of tumble");
  g.reset();g.player.y=GROUND-150;g.player.grounded=false;g.player.injured=g.player.heavyHit=true;g.player.stun=0;g.player.anim=ssf::Tumble;g.player.vy=1;
  recover={};recover.fastFall=true;g.tick(recover);
  check(g.player.anim==ssf::Tumble&&g.player.vy==16,"Source tumble-fall can fast fall after moving recovery expires");
 }
 {ssf::Game g;g.player.x=-20;g.dummy.x=20;for(int i=0;i<90;i++)g.camera.update(g.player,g.dummy);float close=g.camera.height;
  g.player.x=-210;g.dummy.x=210;for(int i=0;i<90;i++)g.camera.update(g.player,g.dummy);
  check(g.camera.height>close&&close>=200,"Camera zooms out with fighter separation, respecting source minimum view height");
  g.player.y=GROUND-200;g.dummy.y=GROUND;float before=g.camera.y;g.camera.update(g.player,g.dummy);
  check(g.camera.y<before&&std::abs(g.camera.y-before)<=50,"Camera follows vertical action with source easing and pan cap");
  float hw=g.camera.height*ssf::FightCamera::ASPECT/2,hh=g.camera.height/2;
  check(g.camera.x-hw>=CAM_LEFT-.01f&&g.camera.x+hw<=CAM_RIGHT+.01f&&g.camera.y-hh>=CAM_TOP-.01f&&g.camera.y+hh<=CAM_BOTTOM+.01f,"Camera stays inside the exported Final Destination camera boundary");}
 if(output){fprintf(output,"Extended checks: %d failures\n",failures);fflush(output);}return failures;
}
