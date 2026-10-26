#pragma once
#include "simulation.h"
#include <cstdio>
// Medium AI behavior checks: approach, defense, recovery, mash-out, throws,
// projectile use, edge discipline and determinism. AI is off by default in
// Game, so these tests enable it explicitly.
inline int runAiChecks(FILE* output){
 int failures=0;
 auto check=[&](bool ok,const char*name){if(!ok)++failures;if(output)fprintf(output,"%s: %s\n",ok?"PASS":"FAIL",name);};
 for(int side:{-1,1}){
  {ssf::Game g;g.dummy.x=0;g.player.x=70*side;g.player.anim=ssf::FTilt;g.player.facing=-side;
   check(g.ai.threatened(g.dummy,g.player,70),"AI sees attacks facing toward it");
   g.player.facing=side;
   check(!g.ai.threatened(g.dummy,g.player,70),"AI ignores distant attacks facing away");}
  {ssf::Game g;g.dummy.x=0;g.player.x=200*side;
   auto&p=g.projectiles[0];p.active=true;p.owner=0;p.x=80*side;p.y=g.dummy.y-25;p.vx=-8*side;
   g.ai.think(g.dummy,g.player,g.projectiles,1,1);
   check(g.ai.reactArmed,"AI detects approaching projectiles");
   g.ai.reset();p.vx=8*side;g.ai.think(g.dummy,g.player,g.projectiles,1,1);
   check(!g.ai.reactArmed,"AI ignores departing projectiles");}
  {ssf::Game g;g.ai.plan=ssf::FighterAI::P_Smash;g.ai.planTicks=50;g.ai.decisionCd=8;
   g.dummy.x=(side<0?LEFT:RIGHT)+70*side;g.dummy.y=GROUND+30;g.dummy.grounded=false;g.dummy.vy=2;
   auto in=g.ai.think(g.dummy,g.player,g.projectiles,1,1);
   check(g.ai.plan==ssf::FighterAI::P_Recover&&in.jump&&in.axis==-side,"Recovery interrupts a stale attack plan");}
  {ssf::Game g;g.player.x=70*side;g.player.anim=ssf::FTilt;g.player.facing=-side;g.dummy.x=0;g.dummy.shieldHealth=20;
   g.ai.reactArmed=true;g.ai.reactCd=0;g.ai.decide(g.dummy,g.player,g.projectiles,1,70,side);
   check(g.ai.plan!=ssf::FighterAI::P_Shield,"Low shield selects dodge rather than shielding");}
  // Approach and land attacks on a stationary target.
  {ssf::Game g;g.aiEnabled=true;g.player.x=-70*side;g.player.facing=side;g.dummy.x=70*side;g.dummy.facing=-side;
   for(int i=0;i<900&&g.player.damage<=0;i++)g.tick();
   check(g.player.damage>0,"AI closes distance and damages a stationary foe, both sides");}
  // React to repeated attacks with a shield or dodge at some point.
  {ssf::Game g;g.aiEnabled=true;g.player.x=-35*side;g.player.facing=side;g.dummy.x=35*side;g.dummy.facing=-side;
   bool defended=false;
   for(int i=0;i<600;i++){
    ssf::Input p;
    if(i%35==0){p.attack=true;p.attackMove=ssf::FTilt;p.attackFacing=side;p.axis=side;}
    g.tick(p);
    defended|=g.dummy.anim==ssf::Shield||g.dummy.anim==ssf::SpotDodge||
               g.dummy.anim==ssf::DodgeRoll||g.dummy.anim==ssf::AirDodge;
   }
   check(defended,"AI reacts to incoming attacks with shield or dodge, both sides");}
  // Recover from offstage: double jump, up special, drift back.
  {ssf::Game g;g.aiEnabled=true;g.player.x=0;
   g.dummy.x=(side<0?LEFT:RIGHT)+70*side;g.dummy.y=GROUND+30;
   g.dummy.grounded=false;g.dummy.vy=2;g.dummy.facing=side;
   bool back=false;
   for(int i=0;i<600;i++){g.tick();
    if(g.dummy.grounded&&g.dummy.x>=LEFT&&g.dummy.x<=RIGHT&&g.dummy.y<=GROUND+1)back=true;}
   check(back&&g.dummy.kos==0,"AI recovers from offstage without self-destructing, both sides");}
  // Mash out of a grab before the passive timer.
  {ssf::Game g;g.aiEnabled=true;g.player.x=0;g.dummy.x=30*side;g.dummy.facing=-side;
   ssf::Input grab;grab.grab=true;g.player.facing=side;g.tick(grab);
   for(int i=0;i<12&&g.player.grabTarget<0;i++)g.tick();
   check(g.player.grabTarget==1,"AI can be grabbed, both sides");
   int escaped=-1;
   for(int i=0;i<40&&escaped<0;i++){g.tick();if(g.dummy.grabbedBy<0)escaped=i;}
   check(escaped>=0&&escaped<30,"AI mashes out before passive grab release, both sides");}
  // Shield-grab and throw a blocking foe.
  {ssf::Game g;g.aiEnabled=true;g.player.x=-15*side;g.player.facing=side;g.dummy.x=15*side;g.dummy.facing=-side;
   bool threw=false,sawThrow=false;
   for(int i=0;i<900&&!threw;i++){ssf::Input p;p.shield=true;g.tick(p);
    sawThrow|=ssf::isThrow(g.dummy.anim);
    threw=sawThrow&&g.player.damage>0&&g.hits>0;}
   check(threw,"AI shield-grabs and throws a blocking opponent, both sides");}
  // Fireball at mid range.
  {ssf::Game g;g.aiEnabled=true;g.player.x=-140*side;g.player.facing=side;g.dummy.x=140*side;g.dummy.facing=-side;
   bool fired=false;
   for(int i=0;i<900&&!fired;i++){g.tick();
    for(auto&p:g.projectiles)if(p.active&&p.owner==1)fired=true;}
   check(fired,"AI uses Fireball at mid range, both sides");}
  // Sustain neutral without self-destructing; brief ledge chases are fine.
  {ssf::Game g;g.aiEnabled=true;g.player.x=0;g.dummy.x=60*side;g.dummy.facing=-side;
   for(int i=0;i<1200;i++)g.tick();
   check(g.dummy.kos==0&&g.dummy.grounded&&g.dummy.x>=LEFT&&g.dummy.x<=RIGHT,
         "AI never self-destructs and finishes neutral on stage, both sides");}
 }
 {ssf::Game g;g.ai.plan=ssf::FighterAI::P_Hop;g.ai.planTicks=20;g.ai.planAge=-1;g.ai.decisionCd=8;g.ai.planCharge=0;
  auto first=g.ai.think(g.dummy,g.player,g.projectiles,1,1);
  auto second=g.ai.think(g.dummy,g.player,g.projectiles,2,1);
  check(first.jump&&first.jumpHeld&&!second.jumpHeld,"AI short hop releases jump after the press");
  g.ai.reset();g.ai.plan=ssf::FighterAI::P_Hop;g.ai.planTicks=20;g.ai.planAge=-1;g.ai.decisionCd=8;g.ai.planCharge=1;
  first=g.ai.think(g.dummy,g.player,g.projectiles,1,1);second=g.ai.think(g.dummy,g.player,g.projectiles,2,1);
  check(first.jump&&second.jumpHeld,"AI full hop holds jump through startup");}
 // Deterministic: identical resets replay identical trajectories.
 {ssf::Game a,b;a.aiEnabled=b.aiEnabled=true;
  a.player.x=b.player.x=-50;a.dummy.x=b.dummy.x=50;
  for(int i=0;i<400;i++)a.tick();
  for(int i=0;i<400;i++)b.tick();
  check(a.dummy.x==b.dummy.x&&a.dummy.y==b.dummy.y&&a.player.damage==b.player.damage,
        "AI decisions are deterministic across identical runs");
  check(a.player.damage>0||a.dummy.damage>0,"AI sparring produces damage over 400 ticks");}
 // Dummy stays inert when AI is disabled (default).
 {ssf::Game g;g.player.x=-70;g.dummy.x=70;
  for(int i=0;i<300;i++)g.tick();
  check(g.dummy.anim==ssf::Idle&&g.player.damage==0&&g.dummy.damage==0,
        "Disabled AI leaves the dummy inert");}
 if(output){fprintf(output,"AI checks: %d failures\n",failures);fflush(output);}return failures;
}
