#pragma once
#include "simulation.h"
#include <cstdio>
inline int runProtectionChecks(FILE*out){
 int failures=0;
 auto check=[&](bool ok,const char*name){if(!ok)++failures;if(out)fprintf(out,"%s: %s\n",ok?"PASS":"FAIL",name);};
 // Original one-based Mario frame intervals, inclusive. Spot dodge's frame 1
 // comes from Character.initSidestepDodge, not the frame-2 timeline event.
 struct Window {int anim,first,last;};
 const Window windows[]={{ssf::GetUp,16,25},{ssf::USpecial,2,3},{ssf::USpecialAir,2,3},
  {ssf::HangClimb,1,15},{ssf::HangRoll,1,18},{ssf::HangAttack,1,12},
  {ssf::GetUpRoll,1,11},{ssf::GetUpAttack,1,13},{ssf::DodgeRoll,3,8},
  {ssf::SpotDodge,2,8},{ssf::AirDodge,3,14},{ssf::TechGround,1,10},{ssf::TechRoll,1,10}};
 for(auto w:windows){
  bool exact=true,blocked=true;
  for(int frame=0;frame<ANIM_COUNT[w.anim];++frame){
   ssf::Game g;g.dummy.anim=w.anim;g.dummy.frame=frame;
   bool expected=frame+1>=w.first&&frame+1<=w.last;
   exact&=ssf::Game::intangible(g.dummy)==expected;
   if(expected){
    blocked&=!ssf::fighterGrabbable(g.dummy);
    g.damageTarget(g.player,g.dummy,{5,45,20,0,0},false);
    blocked&=g.dummy.damage==0&&!g.dummy.injured;
   }
  }
  check(exact,"Authored protection starts and ends on original Mario frames");
  check(blocked,"Protected action rejects damage and grabs");
 }
 {ssf::Game g;g.dummy.anim=ssf::GetUp;g.dummy.frame=13;
  check(!ssf::fighterGrabbable(g.dummy)&&!ssf::fighterProtected(g.dummy),"Crash waiting state blocks grabs without invented hit immunity");
  g.dummy.frame=25;
  check(ssf::fighterGrabbable(g.dummy)&&!ssf::fighterProtected(g.dummy),"Get-up frame 26 restores hit and grab vulnerability");
  g.dummy.anim=ssf::Hang;g.dummy.frame=0;g.dummy.ledgeAge=13;
  check(ssf::fighterProtected(g.dummy),"Ledge age 13 is protected");g.dummy.ledgeAge=14;
  check(!ssf::fighterProtected(g.dummy)&&!ssf::fighterGrabbable(g.dummy),"Ledge age 14 permits hits but never a standing grab");}
 for(int side:{-1,1}){
  // Real grab collision: same placement must grab idle, but not crash/revival.
  for(int state=0;state<3;++state){ssf::Game g;g.player.x=0;g.player.facing=side;g.dummy.x=30*side;
   if(state==1){g.dummy.anim=ssf::GetUp;g.dummy.frame=13;}
   if(state==2)g.dummy.invincibleTicks=75;
   ssf::Input grab;grab.grab=true;g.tick(grab);
   for(int i=0;i<12&&g.player.grabTarget<0;i++)g.tick();
   check(state==0?g.player.grabTarget==1:g.player.grabTarget<0,"Real grab contacts respect crash and timed protection, both facings");}
  {ssf::Game g;g.player.x=0;g.player.facing=side;g.dummy.x=30*side;g.dummy.invincibleTicks=1;
   g.startAttack(g.player,ssf::FTilt);g.player.frame=2;g.hit();
   check(g.hits==0&&g.dummy.damage==0,"Melee ignores timed invincibility");
   g.dummy.invincibleTicks=0;g.hit();check(g.hits==1&&g.dummy.damage>0,"Melee connects immediately after invincibility expires");}
 }
 {ssf::Game g;g.respawn(g.dummy,150);g.player.x=-150;
  check(g.dummy.invincibleTicks==75&&!ssf::fighterGrabbable(g.dummy),"Respawn grants source 75-tick protection");
  for(int i=0;i<74;i++)g.tick();check(ssf::fighterProtected(g.dummy),"Respawn protection remains through tick 74");
  g.tick();check(!ssf::fighterProtected(g.dummy),"Respawn protection expires on tick 75");
  g.breakShield(g.dummy);check(g.dummy.invincibleTicks==15,"Shield break grants source 15-tick protection");
  for(int i=0;i<14;i++)g.tick();check(ssf::fighterProtected(g.dummy),"Shield-break protection remains through tick 14");
  g.tick();check(!ssf::fighterProtected(g.dummy),"Shield-break protection expires on tick 15");}
 // Find an actual fireball/hurtbox overlap; replay it with timed protection.
 bool projectileContact=false;
 for(int x=-35;x<=35&&!projectileContact;x+=5)for(int y=-40;y<=-5&&!projectileContact;y+=5){
  ssf::Game vulnerable,protectedGame;
  for(auto*g:{&vulnerable,&protectedGame}){g->dummy.x=0;auto&p=g->projectiles[0];p.active=true;p.owner=0;p.x=x;p.y=GROUND+y;p.vx=0;}
  protectedGame.dummy.invincibleTicks=15;
  vulnerable.updateProjectiles();protectedGame.updateProjectiles();
  if(vulnerable.dummy.damage>0){projectileContact=true;check(protectedGame.dummy.damage==0&&protectedGame.hits==0,"Fireball contact respects timed protection");}
 }
 check(projectileContact,"Fireball protection test has a real damaging control contact");
 if(out)fprintf(out,"Protection checks: %d failures\n",failures);
 return failures;
}
