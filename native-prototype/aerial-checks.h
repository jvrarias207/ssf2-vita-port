#pragma once
#include "simulation.h"
#include <cstdio>
inline int runAerialChecks(FILE* output){
 int failures=0;
 auto check=[&](bool ok,const char*name){if(!ok)++failures;if(output)fprintf(output,"%s: %s\n",ok?"PASS":"FAIL",name);};
 const int active[]={2,8,3,2,5};
 const float expected[]={12,16,13,7,2};
 for(int move=ssf::NAir;move<=ssf::DAir;move++)for(int side:{-1,1}){
  bool connected=false;
  for(int x=-80;x<=80&&!connected;x+=10)for(int y=-60;y<=60&&!connected;y+=10){
   ssf::Game g;g.player.x=0;g.player.y=GROUND-120;g.player.grounded=false;g.player.facing=side;
   g.dummy.x=x*side;g.dummy.y=g.player.y+y;g.dummy.grounded=false;
   g.startAttack(g.player,move);g.player.frame=active[move-ssf::NAir];g.hit();
   if(g.hits){connected=true;check(g.dummy.damage==expected[move-ssf::NAir],"Aerial early damage matches source in both facings");g.player.freeze=0;g.hit();check(g.hits==1,"Aerial hit cannot repeat without source ID refresh");}
  }
  check(connected,"Authored aerial hitboxes connect in both facings");
 }
 ssf::Game g;ssf::Input in;in.attack=true;in.attackMove=ssf::BAir;in.axis=-1;
 g.player.y=GROUND-80;g.player.grounded=false;g.tick(in);
 check(g.player.anim==ssf::BAir&&g.player.facing==1&&g.player.vx<0,"Back air drifts backward without turning the fighter");
 for(int move=ssf::NAir;move<=ssf::DAir;move++){
  g.reset();g.dummy.x=700;g.player.y=GROUND-.1f;g.player.grounded=false;g.startAttack(g.player,move);g.player.frame=2;g.tick();
  check(g.player.aerialLanded&&g.player.frame==ssf::aerialLanding(move),"Landing during lag window enters authored continuation");
  for(int i=0;i<12;i++)g.tick();check(g.player.anim==ssf::Idle&&!g.player.aerialLanded,"Landing recovery ends and restores control");
  g.reset();g.player.y=GROUND-.1f;g.player.grounded=false;g.startAttack(g.player,move);g.updateFighter(g.player,{});
  check(g.player.anim==ssf::Land&&g.player.landingLock==2,"Early autocancel enters normal source landing, not dodgeland");
 }
 g.reset();g.startAttack(g.player,ssf::DAir);g.player.frame=5;g.player.hitThisAttack=true;
 int refreshes=0;for(int i=0;i<7;i++){g.advance(g.player);if(!g.player.hitThisAttack){++refreshes;g.player.hitThisAttack=true;}}
 check(refreshes==4,"Down air refreshes attack identity on source frames 7,9,11,13");
 ssf::Fighter f;f.anim=ssf::NAir;f.frame=4;check(ssf::attackStats(f,1).damage==8&&ssf::attackStats(f,1).targetPause==2,"Neutral air late hit uses weaker damage and pause");
 f.anim=ssf::BAir;f.frame=5;check(ssf::attackStats(f,1).damage==9&&ssf::attackStats(f,1).kbc==90,"Back air late hit uses source stat change");
 f.anim=ssf::FAir;f.frame=8;check(ssf::attackStats(f,1).angle==300&&!ssf::attackStats(f,1).reversible&&ssf::attackStats(f,2).angle==55,"Forward air separates meteor and outward hitboxes");
 f.frame=9;check(ssf::attackStats(f,1).angle==55,"Forward air meteor becomes outward hit on source frame 10");
 f.anim=ssf::DAir;f.aerialLanded=true;check(ssf::attackStats(f,1).weightKB==40&&ssf::attackStats(f,2).weightKB==30,"Down air landing refresh retains per-box source stats");
 if(output){fprintf(output,"Aerial checks: %d failures\n",failures);fflush(output);}return failures;
}
