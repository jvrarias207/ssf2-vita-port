#pragma once
#include "simulation.h"
#include <cstdio>
inline int runActionChecks(FILE* output){
 int failures=0;
 auto check=[&](bool ok,const char*name){if(!ok)++failures;if(output)fprintf(output,"%s: %s\n",ok?"PASS":"FAIL",name);};
 for(int side:{-1,1}){
  // Whole short hop, not a manually positioned airborne pose. Source boxes are unchanged.
  ssf::Game g;g.player.x=0;g.player.facing=side;g.dummy.x=-side*40;g.dummy.facing=side;
  ssf::Input in;in.jump=in.jumpHeld=true;g.tick(in);g.tick();g.tick();
  for(int i=0;i<8;i++)g.tick();
  in={};in.attack=true;in.attackMove=ssf::UAir;g.tick(in);
  for(int i=0;i<8&&!g.hits;i++)g.tick();
  check(g.hits==1&&g.dummy.damage==7&&g.player.grounded&&g.player.facing==side,"Short-hop up-air last active frame hits a grounded opponent behind Mario before landing boxes replace it");
  g.reset();g.player.x=0;g.dummy.x=700;in={};in.fastFall=true;
  for(int i=0;i<8;i++)g.tick(in);
  check(g.player.anim==ssf::Crouch&&g.player.frame==3&&g.player.vx==0,"Crouch enters and holds original loop frame 4");
  float crouchTop=0,idleTop=0;
  auto bounds=[&](int anim){ssf::Fighter f;f.anim=anim;f.frame=anim==ssf::Crouch?3:0;Frame fr=FRAMES[f.sprite()];float top=0;for(int j=0;j<fr.count;j++){const auto&b=BOXES[fr.offset+j];if(!b.attack)top=std::min(top,b.y);}return top;};
  crouchTop=bounds(ssf::Crouch);idleTop=bounds(ssf::Idle);
  check(crouchTop>idleTop,"Crouching uses lower source hurtboxes rather than copied idle geometry");
  g.tick();check(g.player.anim==ssf::Uncrouch&&g.player.frame==0,"Releasing Down enters original uncrouch frames 65-68");
  for(int i=0;i<4;i++)g.tick();check(g.player.anim==ssf::Idle,"Uncrouch returns to idle at the source terminal event");
  g.reset();in={};in.shield=true;for(int i=0;i<7;i++)g.tick(in);
  check(g.player.anim==ssf::Shield&&g.player.frame==2&&std::abs(g.player.shieldHealth-97.76f)<.01f,"Shield holds source pause frame 3 and drains 1.12 per tick after startup");
  float hp=g.player.shieldHealth;g.tick();
  check(g.player.anim==ssf::ShieldDrop&&g.player.shieldHealth==hp,"Release enters shield-drop rather than immediately exposing idle");
  for(int i=0;i<6;i++)g.tick();check(g.player.anim==ssf::Idle&&g.player.shieldHealth>hp,"Shield-drop restores control and shield recovers off shield");
  g.reset();in={};in.shield=true;g.tick(in);in.jump=in.jumpHeld=true;g.tick(in);in.jump=false;
  for(int i=0;i<4;i++)g.tick(in);
  check(!g.player.grounded&&g.player.vy<0,"Jump out of shield works even while the shield button stays held");
  g.reset();g.player.x=0;g.player.facing=side;g.dummy.x=700;in={};in.attack=true;in.attackMove=ssf::NSpecial;g.tick(in);
  int count=0;for(auto&p:g.projectiles)count+=p.active;
  check(count==0&&g.player.anim==ssf::NSpecial,"Neutral special uses the grounded source animation before its firing frame");
  for(int i=0;i<7;i++)g.tick();count=0;for(auto&p:g.projectiles)count+=p.active;
  check(count==0,"Fireball is not spawned before source frame 9");
  g.tick();count=0;for(auto&p:g.projectiles)if(p.active){++count;check(p.owner==0&&p.vx==side*8,"Fireball travels in facing direction at source speed 8");}
  check(count==1,"Exactly one fireball spawns on source frame 9");
  g.reset();g.dummy.x=700;for(int i=0;i<8;i++)g.spawnFireball(g.player);count=0;for(auto&p:g.projectiles)count+=p.active;
  check(count==6,"Source fireball ownership limit is six projectiles");
  for(int i=0;i<40;i++)g.updateProjectiles();count=0;for(auto&p:g.projectiles)count+=p.active;
  check(count==0,"Fireballs expire at source time_max 40");
  g.reset();g.player.x=0;g.player.facing=side;g.dummy.x=700;in={};in.attack=true;in.attackMove=ssf::USpecial;g.tick(in);
  for(int i=0;i<3;i++)g.tick();
  check(!g.player.grounded&&g.player.vy<-15&&g.player.vx*side>0,"Super Jump Punch launches on source frame 4 using speed 25 and its source angle");
  for(int i=0;i<19;i++)g.tick();check(g.player.helpless&&g.player.anim==ssf::Helpless,"Up-special completes into authored helpless falling");
  in={};in.attack=true;in.attackMove=ssf::NSpecial;in.jump=true;g.tick(in);
  check(g.player.helpless&&g.player.anim==ssf::Helpless,"Helpless prevents another jump or special until landing");
  for(int i=0;i<70&&!g.player.grounded;i++)g.tick();
  check(g.player.grounded&&!g.player.helpless&&g.player.anim==ssf::SpecialLand,"Up-special recovery enters source heavy-landing sequence");
  g.reset();g.player.x=0;g.player.y=GROUND-120;g.player.grounded=false;g.startAttack(g.player,ssf::SSpecial);g.player.frame=5;g.player.specialEventFrame=-1;g.specialTick(g.player,{});
  check(g.player.anim==ssf::SSpecialAir&&g.player.vy==-4,"Air cape uses its own source timeline and frame-6 lift");
  g.reset();g.player.y=GROUND-100;g.player.grounded=false;g.startAttack(g.player,ssf::DSpecial);g.player.frame=2;in={};in.specialPressed=true;g.specialTick(g.player,in);
  check(g.player.vy==-8&&g.player.tornadoLifted,"Tornado mashing applies the source rise increment");
  g.player.frame=16;g.specialTick(g.player,{});g.player.frame=17;float vy=g.player.vy;g.specialTick(g.player,in);
  check(!g.player.tornadoCanRise&&g.player.vy==vy,"Tornado stops accepting lift after source frame 17");
 }
 // Hit actual source attack boxes against a shielding target, not just shield bookkeeping.
 bool capeHit=false,blocked=false;
 for(int x=-80;x<=80&&(!capeHit||!blocked);x+=5){
  ssf::Game g;g.player.x=0;g.dummy.x=(float)x;g.dummy.facing=-1;g.startAttack(g.player,ssf::SSpecial);g.player.frame=5;g.hit();
  if(g.hits){capeHit=true;check(g.dummy.damage==8&&g.dummy.facing==1,"Cape deals source 8% and reverses the struck target");}
  g.reset();g.player.x=0;g.dummy.x=(float)x;g.dummy.setAnim(ssf::Shield);g.startAttack(g.player,ssf::FTilt);g.player.frame=2;g.hit();
  if(g.dummy.shieldHealth<100){blocked=true;check(g.dummy.damage==0&&std::abs(g.dummy.shieldHealth-87.4f)<.01f,"Shield blocks an authored tilt box and loses damage * 1.4 health");}
 }
 check(capeHit&&blocked,"Cape and shield checks found real geometry contact");
 {ssf::Game g;g.player.x=0;g.dummy.x=35;g.spawnFireball(g.player);
  for(int i=0;i<5&&!g.hits;i++)g.updateProjectiles();
  check(g.hits==1&&g.dummy.damage==5&&!g.projectiles[0].active,"Fireball damages a real target once for source 5% then disappears");}
 {ssf::Game g;g.player.x=0;g.dummy.x=35;g.dummy.setAnim(ssf::Shield);g.spawnFireball(g.player);
  for(int i=0;i<5&&!g.hits;i++)g.updateProjectiles();
  check(g.dummy.damage==0&&g.dummy.shieldHealth==93&&!g.projectiles[0].active,"Shield blocks and destroys fireballs with source shield-health loss");}
 {ssf::Game g;g.player.x=0;g.startAttack(g.player,ssf::SSpecial);g.player.frame=5;
  Frame frame=FRAMES[g.player.sprite()];bool reflected=false;
  for(int i=0;i<frame.count;i++){Box b=BOXES[frame.offset+i];if(!b.attack)continue;b=ssf::worldBox(b,g.player);
   auto&p=g.projectiles[0];p=ssf::Projectile{};p.active=true;p.owner=1;p.vx=-8;p.x=b.x+b.w/2+8;p.y=b.y+b.h/2-1.1f;
   g.updateProjectiles();reflected=p.active&&p.owner==0&&p.vx==8;break;
  }check(reflected,"Active cape geometry reflects a fireball and transfers ownership");}
 {ssf::Game g;g.player.setAnim(ssf::Shield);g.player.shieldHealth=1;g.shieldHit(g.player,5);
  check(g.player.anim==ssf::Dizzy&&g.player.dizzyTicks==90&&g.player.vy<0&&g.player.shieldHealth==60,"Shield break launches into dizzy recovery with source reset health");}
 if(output){fprintf(output,"Action checks: %d failures\n",failures);fflush(output);}return failures;
}
