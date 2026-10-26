#pragma once
#include <algorithm>
#include <cmath>
#include "generated-assets.h"

namespace ssf {
enum Anim {Idle,Walk,Run,Dash,Turn,Skid,Land,Jump,DoubleJump,Fall,Jab,Hurt,Flying,Tumble,GetUp,FTilt,UTilt,DTilt,FSmash,USmash,DSmash,NAir,FAir,BAir,UAir,DAir,Crouch,Uncrouch,Shield,ShieldDrop,NSpecial,NSpecialAir,SSpecial,SSpecialAir,USpecial,USpecialAir,DSpecial,Helpless,SpecialLand,Dizzy,Fireball,Grab,DashGrab,GrabHold,Pummel,Caught,FThrow,BThrow,UThrow,DThrow,DashAttack,Hang,HangClimb,HangRoll,HangAttack,GetUpRoll,GetUpAttack,DodgeRoll,SpotDodge,AirDodge,TechGround,TechRoll,EdgeLean,TauntSide,TauntNeutral,TauntUpDown,DodgeLand,CaughtSpin};
constexpr int FULL_CHARGE_TICKS=60,MAX_CHARGE_HOLD_TICKS=120;
constexpr float WALK_SPEED=4.f,RUN_SPEED=11.f,GROUND_ACCEL=1.1f,GROUND_DECEL=1.04f;
constexpr float NORMAL_FALL_SPEED=13.f,FAST_FALL_SPEED=16.f;
inline bool isAerial(int a){return a>=NAir&&a<=DAir;}
inline bool isSmash(int a){return a>=FSmash&&a<=DSmash;}
inline bool isSpecial(int a){return a>=NSpecial&&a<=DSpecial;}
inline bool isUpSpecial(int a){return a==USpecial||a==USpecialAir;}
inline bool isCape(int a){return a==SSpecial||a==SSpecialAir;}
inline bool isNeutralSpecial(int a){return a==NSpecial||a==NSpecialAir;}
inline bool isThrow(int a){return a>=FThrow&&a<=DThrow;}
inline bool isExtra(int a){return a>=Grab&&a<=CaughtSpin;}
inline bool isAttack(int a){return a==Jab||(a>=FTilt&&a<=DAir)||isSpecial(a)||a==DashAttack||a==HangAttack||a==GetUpAttack;}
inline int aerialEnd(int a){return a==NAir?20:a==FAir?29:a==BAir?14:a==UAir?15:19;}
inline int aerialLanding(int a){return a==NAir?21:a==FAir?30:a==BAir?23:a==UAir?16:20;}
inline bool aerialLandingLag(int a,int frame){
 return a==NAir?(frame>=2&&frame<16):a==FAir?(frame>=1&&frame<24):a==BAir?(frame>=2):a==UAir?(frame>=1&&frame<8):(frame>=2&&frame<16);
}
inline int chargeStart(int a){return a==USmash?4:2;}
inline int releaseFrame(int a){return a==FSmash?43:a==USmash?45:42;}
struct Input {int axis=0; bool jump=false, jumpHeld=false, attack=false, fastFall=false; int attackMove=Jab; bool smashHeld=false; int attackFacing=0; bool shield=false,specialPressed=false,normalAttackPressed=false,up=false,grab=false;int taunt=0;};
struct Fighter {
 float x=0,y=GROUND,vx=0,vy=0,damage=0;
 float weight=100,gravity=1.3f;
 int chargeTicks=0,chargeHold=0;bool smashReleased=false;
 bool aerialLanded=false;int landingLock=0;
 float kx=0,ky=0,decayX=0,decayY=0;
 int injuryTicks=0,knockbackAge=5;
 int facing=1,anim=Idle,frame=0,freeze=0,stun=0,jumpDelay=0,airJumps=1,kos=0,attackSerial=0;
 int jabPhase=0,nextJab=0,comboUntil=0,hurtStart=0;
 bool queuedJab=false,injured=false;
 bool heavyHit=false;
 int downTicks=0;
 int invincibleTicks=0; // Character revival timer: 75 on respawn, 15 on shield break.
 int dashDir=0,prevAxis=0,lastDirPressTick=-100,lastDirPressDir=0,turnDir=0;
 bool dashStopPending=false;
 bool grounded=true,hitThisAttack=false,shortHop=false;
 bool downHeld=false;
 float shieldHealth=100,specialAngle=0,tornadoRise=-6;
 int shieldAge=0,shieldStun=0,dizzyTicks=0,specialEventFrame=-1,neutralCooldown=0;
 bool helpless=false,tornadoCanRise=true,tornadoLifted=false;
 int grabTarget=-1,grabbedBy=-1,grabTimer=0,extraEventFrame=-1,actionDir=0,ledgeSide=0,ledgeAge=0,ledgeCooldown=0,techWindow=0;
 bool upHeld=false,shieldHeld=false;
 float rollSpeed=0,rotation=0;
 int victimFacing=1;
 bool victimSpin=false;
 int lastCameraSprite=-1;
 void setAnim(int a){if(anim!=a){anim=a;frame=0;}}
 int sprite()const{return ANIM_START[anim]+std::clamp(frame,0,ANIM_COUNT[anim]-1);}
};
inline bool fighterIntangible(const Fighter&f){
 return FRAME_INTANGIBLE[f.sprite()]||(f.anim==Hang&&f.ledgeAge<14);
}
inline bool fighterProtected(const Fighter&f){return fighterIntangible(f)||f.invincibleTicks>0;}
inline bool fighterGrabbable(const Fighter&f){
  // Prototype's standing/dash grabs only catch fighters standing on FD.
  // Character.reactionGrab excludes CRASH_LAND and Capture excludes Hanging;
  // the grounded-target restriction is the requested Mario prototype rule.
  // An aerial can still display its last active pose for a tick after ground
  // contact (deferred landAerial). Do not grab that visually airborne pose.
  return f.grounded&&std::abs(f.y-GROUND)<1.4f&&f.x>=LEFT&&f.x<=RIGHT&&
   !isAerial(f.anim)&&f.anim!=Jump&&f.anim!=DoubleJump&&f.anim!=Fall&&
   f.anim!=Flying&&f.anim!=Tumble&&f.anim!=AirDodge&&f.anim!=Helpless&&
   f.anim!=NSpecialAir&&f.anim!=SSpecialAir&&f.anim!=USpecialAir&&
   !fighterProtected(f)&&!(f.anim==GetUp&&f.frame<15)&&f.anim!=Hang&&f.grabbedBy<0;
}
#include "fight-camera.h"
struct AttackStats {float damage,angle,power,kbc,weightKB;int targetPause=-1,selfPause=-1;bool reversible=true;float recoveryMultiplier=1;};
inline AttackStats attackStats(const Fighter&f,int box){
 switch(f.anim){
 case FTilt:return {9,35,10,100,0};
 case UTilt:return {8,96,26,125,0};
 case DTilt:return {10,70,30,80,0};
 case FSmash:return box==2?AttackStats{14,60,25,99,0}:AttackStats{17,50,25,103,0};
 case USmash:return {15,83,32,97,0};
 case DSmash:return f.frame>=46?AttackStats{10,30,35,75,0}:AttackStats{14,30,30,100,0};
 case NAir:return f.frame<4?AttackStats{12,40,20,99,0,4,2,true,1.1f}:AttackStats{8,55,13,99,0,2,1,true,1.1f};
 case FAir:
  if(box==2)return {16,55,20,100,0,5,3,true,1.1f};
  return f.frame<9?AttackStats{16,300,20,90,0,5,3,false}:AttackStats{16,55,20,100,0,5,3,false};
 case BAir:return f.frame<5?AttackStats{13,40,15,110,0,5,2,true,1.1f}:AttackStats{9,40,7,90,0,3,1,true,1.1f};
 case UAir:return {7,box==2?45.f:60.f,10,110,0,4,2,true,1.2f};
  case DAir:return {2,80,30,100,f.aerialLanded&&box==1?40.f:30.f,2,1,true,1.23f};
  case NSpecial:case NSpecialAir:return {0,30,0,1,0,0,0};
  case SSpecial:case SSpecialAir:return {8,180,40,0,0,0,0,false};
  case USpecial:case USpecialAir:
   if(f.frame>=11)return {3,60,70,100,0,2,2,false};
   return {f.frame>=3?1.f:f.anim==USpecial?5.f:4.f,f.frame>=3?f.specialAngle:78.f,0,100,120,2,2,false};
  case DSpecial:
   if(f.frame>=20||box==2)return {5,65,75,100,0,2,2};
   return {1,f.tornadoLifted?110.f:145.f,45,0,40,2,2};
  case FThrow:return {9,45,60,72,0,0,0,false};
  case BThrow:return {12,145,80,65,0,0,0,false};
  case UThrow:return {8,85,80,90,0,0,0,false,1.3f};
  case DThrow:return {9,80,75,30,0,-1,-1,false};
  case DashAttack:return f.frame<4?AttackStats{9,75,70,50,0}:AttackStats{7,45,55,30,0};
  case HangAttack:return {6,45,75,25,0,2,1};
  case GetUpAttack:return {8,50,80,50,0};
 default:return f.jabPhase==1?AttackStats{3,80,0,100,20,3}:f.jabPhase==2?AttackStats{2,70,0,100,20,3}:AttackStats{5,45,40,100,0,3};
 }
}
inline float calculateKnockback(const AttackStats&s,float damage,float previousDamage,float weight){
 float term=s.weightKB!=0?s.weightKB*10*.05f+1:(previousDamage+damage)*.1f+damage*(previousDamage+damage)*.05f;
 return (term*1.4f*(200.f/(weight+100))+18)*(s.kbc*.01f)+s.power;
}
inline float approach(float x,float target,float speed){return x<target?std::min(target,x+speed):std::max(target,x-speed);}
inline bool overlaps(const Box&a,const Box&b){return a.x<b.x+b.w&&a.x+a.w>b.x&&a.y<b.y+b.h&&a.y+a.h>b.y;}
inline Box worldBox(Box b,const Fighter&f){
 b.x=f.facing>0?b.x:-b.x-b.w;
 if(f.rotation!=0){
  float c=std::cos(f.rotation*3.14159265f/180),s=std::sin(f.rotation*3.14159265f/180);
  float left=1e9f,right=-1e9f,top=1e9f,bottom=-1e9f;
  for(float x:{b.x,b.x+b.w})for(float y:{b.y,b.y+b.h}){float rx=x*c-y*s,ry=x*s+y*c;left=std::min(left,rx);right=std::max(right,rx);top=std::min(top,ry);bottom=std::max(bottom,ry);}
  b.x=left;b.y=top;b.w=right-left;b.h=bottom-top;
 }
 b.x+=f.x;b.y+=f.y;return b;
}
inline float shieldRadius(const Fighter&f){return 27.5f*(.5f+.75f*std::clamp(f.shieldHealth,0.f,100.f)/100.f);}
inline bool touchesShield(const Box&b,const Fighter&f){
 float r=shieldRadius(f),cx=f.x,cy=f.y-46.f/3;
 float dx=cx-std::clamp(cx,b.x,b.x+b.w),dy=cy-std::clamp(cy,b.y,b.y+b.h);
 return f.anim==Shield&&f.grounded&&dx*dx+dy*dy<=r*r;
}
struct Projectile {
 bool active=false;int owner=0,age=0;float x=0,y=0,vx=0,vy=0,bounce=9;
 int sprite()const{return ANIM_START[Fireball]+(age<9?age:1+(age-1)%8);}
};
inline bool inside(float x,float y){
 bool c=false;constexpr int n=sizeof(TERRAIN)/sizeof(TERRAIN[0]);
 for(int i=0,j=n-1;i<n;j=i++){
  auto a=TERRAIN[i],b=TERRAIN[j];
  if((a.y>y)!=(b.y>y)&&x<(b.x-a.x)*(y-a.y)/(b.y-a.y)+a.x)c=!c;
 }return c;
}
// Solid-stage approximation: sample the body perimeter against the extracted polygon.
// Original SSF2 has additional collision/ledge states which are intentionally outside this milestone.
inline bool bodyCollides(float x,float y){
 for(float dx=-12;dx<=12;dx+=4)if(inside(x+dx,y-.05f)||inside(x+dx,y-45.95f))return true;
 for(float dy=-44;dy<=-2;dy+=3)if(inside(x-12,y+dy)||inside(x+12,y+dy))return true;
 return false;
}
#include "fighter-ai.h"
struct Game {
  Fighter player,dummy;int ticks=0,hits=0;float lastKnockback=0;
  Projectile projectiles[12]{};
  FightCamera camera;
  FighterAI ai;bool aiEnabled=false;
 Game(){reset();}
  void reset(){player=Fighter{};dummy=Fighter{};player.x=-35;dummy.x=35;dummy.facing=-1;ticks=hits=0;lastKnockback=0;for(auto&p:projectiles)p=Projectile{};camera.reset(player,dummy);ai.reset();}
 void heavyTest(){reset();player.x=-10;dummy.x=20;dummy.damage=60;}
  static bool intangible(const Fighter&f){return fighterIntangible(f);}
  Fighter& fighterAt(int id){return id==0?player:dummy;}
  int fighterId(const Fighter&f)const{return &f==&player?0:1;}
  void beginExtra(Fighter&f,int anim,int direction=0);
  bool extraTick(Fighter&f,Input in,bool downPressed,bool upPressed,bool shieldPressed);
  void extraAdvance(Fighter&f);
  void updateGrabs();
  void attachHeld(Fighter&f);
  void releaseGrip(Fighter&f);
  void tryLedge(Fighter&f,Input in);
  void specialTick(Fighter&f,Input in);
  void spawnFireball(Fighter&f);
  void updateProjectiles();
  void shieldHit(Fighter&f,float damage);
  void breakShield(Fighter&f);
  void respawn(Fighter&f,float x){releaseGrip(f);int ko=f.kos+1;float weight=f.weight,gravity=f.gravity;f=Fighter{};f.weight=weight;f.gravity=gravity;f.x=x;f.y=GROUND-90;f.grounded=false;f.kos=ko;f.invincibleTicks=75;}
  void startJab(Fighter&f,int phase){
    f.dashDir=f.turnDir=0;f.dashStopPending=false;
  f.setAnim(Jab);f.jabPhase=phase;f.frame=phase==1?0:phase==2?8:18;
  f.hitThisAttack=false;f.queuedJab=false;f.nextJab=0;++f.attackSerial;f.vx=0;
 }
  void startAttack(Fighter&f,int move){
   if(move==DashAttack||move==HangAttack||move==GetUpAttack){beginExtra(f,move);return;}
   if(isNeutralSpecial(move)&&f.neutralCooldown>0)return;
   if(isSpecial(move)&&f.helpless)return;
   if((move<FTilt||move>DAir)&&!isSpecial(move)){startJab(f,1);return;}
   if(move==NSpecial||move==NSpecialAir)move=f.grounded?NSpecial:NSpecialAir;
   if(move==SSpecial||move==SSpecialAir)move=f.grounded?SSpecial:SSpecialAir;
   if(isUpSpecial(move))move=f.grounded?USpecial:USpecialAir;
  f.setAnim(move);f.frame=0;f.hitThisAttack=false;f.queuedJab=false;f.nextJab=0;
   f.chargeTicks=0;f.chargeHold=0;f.smashReleased=false;f.aerialLanded=false;f.landingLock=0;
   f.dashDir=f.turnDir=0;f.dashStopPending=false;
   f.specialEventFrame=-1;f.tornadoLifted=false;
   if(isUpSpecial(move)){f.specialAngle=std::atan(26.f/18.f)*180.f/3.14159265f;f.vx=f.vy=0;}
   if(move==DSpecial){f.tornadoRise=-6;if(!f.grounded&&f.vy>0)f.vy=0;}
  if(!isAerial(move))f.vx=0;
  ++f.attackSerial;
 }
 void move(Fighter&f){
  int steps=std::max(1,(int)std::ceil(std::max(std::abs(f.vx),std::abs(f.vy))));
  float dx=f.vx/steps,dy=f.vy/steps;f.grounded=false;
  for(int i=0;i<steps;i++){
   if(!bodyCollides(f.x+dx,f.y))f.x+=dx;else{f.vx=0;dx=0;}
   if(!bodyCollides(f.x,f.y+dy))f.y+=dy;else{
    if(dy>0){f.grounded=true;f.airJumps=1;}
    f.vy=0;dy=0;
   }
  }
  if(!f.grounded&&f.vy>=0&&bodyCollides(f.x,f.y+.4f)){f.grounded=true;f.vy=0;f.airJumps=1;}
  if(f.grounded&&std::abs(f.y-GROUND)<1.4f)f.y=GROUND;
 }
 void knockbackForces(Fighter&f){
  // Character.m_forces performs two 60-Hz knockback moves per 30-Hz tick.
  // Preserve ordinary velocity: gravity/fall-speed limits never clamp knockback.
  float vx=f.vx,vy=f.vy;
  for(int step=0;step<2;step++){
   if(f.kx==0&&f.ky==0)break;
   if(f.grounded&&f.ky>0)f.ky=0;
   f.vx=f.kx;f.vy=f.ky;move(f);
   if(f.vx==0)f.kx=0;
   if(f.vy==0)f.ky=0;
   f.kx=approach(f.kx,0,f.decayX);f.ky=approach(f.ky,0,f.decayY);
  }
  f.vx=vx;f.vy=vy;
 }
   void landAerial(Fighter&f){
    if(aerialLandingLag(f.anim,f.frame)){
     f.aerialLanded=true;f.frame=aerialLanding(f.anim);
     if(f.anim==DAir){f.hitThisAttack=false;++f.attackSerial;}
     else f.hitThisAttack=true;
    }else{f.setAnim(Land);f.landingLock=2;f.dashDir=f.turnDir=0;}
   }
    void updateFighter(Fighter&f,Input in,bool deferAerialLanding=false){
   if(f.invincibleTicks>0)--f.invincibleTicks;
   const bool downPressed=in.fastFall&&!f.downHeld;
   f.downHeld=in.fastFall;
   const bool upPressed=in.up&&!f.upHeld,shieldPressed=in.shield&&!f.shieldHeld;
   f.upHeld=in.up;f.shieldHeld=in.shield;
   if(f.ledgeCooldown>0)--f.ledgeCooldown;
   if(f.techWindow>0)--f.techWindow;
   if(shieldPressed&&f.injured)f.techWindow=10;
   if(f.grabbedBy>=0){
    Fighter&holder=fighterAt(f.grabbedBy);
    // Struggle only shortens a held grab, never an in-progress throw.
    if(holder.anim==GrabHold||holder.anim==Pummel){
     int loss=(downPressed||upPressed||(in.axis&&in.axis!=f.prevAxis)?4:0)+(in.normalAttackPressed||(in.attack&&!in.specialPressed)?4:0)+(in.specialPressed?4:0);
     holder.grabTimer-=loss;
     if(holder.grabTimer<=0)releaseGrip(f);
    }
    f.prevAxis=in.axis;f.vx=f.vy=f.kx=f.ky=0;
    return;
   }
  // Input events are release/repress edges, not a held attack button.
  if(f.anim==Jab&&in.attack&&((f.jabPhase==1&&f.frame>=3)||(f.jabPhase==2&&f.frame>=12)))f.queuedJab=true;
   if(f.freeze>0){--f.freeze;return;}
   const bool wasGrounded=f.grounded;
   if(f.neutralCooldown>0)--f.neutralCooldown;
   if(f.anim!=Shield)f.shieldHealth=std::min(100.f,f.shieldHealth+.28f);
  ++f.knockbackAge;
  knockbackForces(f);
   if(extraTick(f,in,downPressed,upPressed,shieldPressed)){}
   else if(f.landingLock>0){--f.landingLock;f.vx=approach(f.vx,0,1.04f);}
  else if(f.anim==GetUp){
   f.vx=approach(f.vx,0,1.04f);
   ++f.downTicks;
   // Source crash timer 13, automatic get-up timer 110. Frame 16 starts getup.
   if(f.frame==13&&(f.downTicks>=110||(in.jump&&f.downTicks>=13)))f.frame=15;
  }
  else if(f.injured){
   ++f.injuryTicks;
   if(f.stun>0)--f.stun;
   f.vx=approach(f.vx,0,f.grounded?1.04f:.15f);
    if(f.heavyHit)f.setAnim(f.stun>0?Flying:Tumble);
    // Source TUMBLE_FALL is actionable once moving hit recovery has expired.
    if(f.heavyHit&&f.stun==0&&!f.grounded){
     if(in.axis)f.vx=approach(f.vx,in.axis*7.f,.7f);
     if(in.jump&&f.airJumps){--f.airJumps;f.injured=f.heavyHit=false;f.vy=-17.4f;f.setAnim(DoubleJump);}
     else if(in.attack&&(isAerial(in.attackMove)||isSpecial(in.attackMove))){
      f.injured=f.heavyHit=false;if(isSpecial(in.attackMove)&&in.attackFacing)f.facing=in.attackFacing;startAttack(f,in.attackMove);
     }
    }
   // Play through hurtN -> doneN, then recover on landing. Never display jump
   // poses while the target is being launched upward by a hit.
    if(f.injured&&!f.heavyHit&&((f.stun==0&&f.injuryTicks>=15)||(f.grounded&&f.injuryTicks>=12))){
    f.injured=false;f.stun=0;f.setAnim(f.grounded?Idle:Fall);
   }
  }
   else if(f.dizzyTicks>0){
    f.setAnim(Dizzy);f.vx=approach(f.vx,0,GROUND_DECEL);
    if(f.grounded&&--f.dizzyTicks==0)f.setAnim(Idle);
   }
   else if(f.anim==ShieldDrop){f.vx=approach(f.vx,0,GROUND_DECEL);}
    else if(f.grounded&&!f.helpless&&!f.jumpDelay&&(f.anim==Shield||(in.shield&&!isAttack(f.anim)&&f.anim!=SpecialLand))){
    if(f.anim!=Shield){f.setAnim(Shield);f.shieldAge=0;f.dashDir=f.turnDir=0;f.dashStopPending=false;}
    f.vx=approach(f.vx,0,GROUND_DECEL);++f.shieldAge;
    if(f.shieldStun>0)--f.shieldStun;
    else if(!in.shield)f.setAnim(ShieldDrop);
    else if(in.jump){f.setAnim(Idle);f.jumpDelay=3;f.shortHop=false;}
    else if(f.shieldAge>5){f.shieldHealth-=1.12f;if(f.shieldHealth<=0)breakShield(f);}
   }
   else {
   if(f.anim==FAir&&!f.aerialLanded&&f.frame>=24&&(in.jump||in.attack))f.setAnim(Fall);
   bool attacking=isAttack(f.anim);
    if(attacking){
    if(f.anim==Jab&&f.queuedJab&&((f.jabPhase==1&&f.frame>=5)||(f.jabPhase==2&&f.frame>=14)))startJab(f,f.jabPhase+1);
    if(isSmash(f.anim)&&!f.smashReleased&&f.frame>=chargeStart(f.anim)){
     if(in.smashHeld){
       if(f.chargeTicks<FULL_CHARGE_TICKS)++f.chargeTicks;
       else if(++f.chargeHold>=MAX_CHARGE_HOLD_TICKS){f.smashReleased=true;f.frame=releaseFrame(f.anim);}
     }else {f.smashReleased=true;f.frame=releaseFrame(f.anim);}
    }
     if(isSpecial(f.anim)){} // Special timeline controls velocity independently.
     else if(isAerial(f.anim)&&!f.aerialLanded)f.vx=in.axis?approach(f.vx,in.axis*7.f,.7f):approach(f.vx,0,.15f);
    else if(f.anim==Jab&&f.jabPhase==3&&f.frame==20)f.vx=7.f*f.facing;
    else f.vx=approach(f.vx,0,1.04f);
   }
   if(!attacking&&!f.helpless){
    if(f.grounded&&in.fastFall&&!in.jump&&!in.attack){
     f.setAnim(Crouch);f.dashDir=f.turnDir=0;f.dashStopPending=false;
    }else if(f.anim==Crouch)f.setAnim(Uncrouch);
    bool startedDash=false;
     if(f.grounded&&f.anim!=Turn&&f.anim!=Crouch&&f.anim!=Uncrouch){
      if(f.dashDir&&in.axis&&in.axis!=f.dashDir&&!f.dashStopPending){
      if(f.anim==Dash){
       // Preserve the requested quick dash-dance momentum during initial dash.
       f.dashDir=f.facing=in.axis;f.vx=std::copysign(std::abs(f.vx),(float)in.axis);f.frame=0;
      }else{f.turnDir=in.axis;f.setAnim(Turn);}
     }
      if(!in.axis&&f.dashDir){
       // Finish initial acceleration before braking; release is not a tap toward a new dash.
       if(!f.dashStopPending){f.lastDirPressTick=-100;f.lastDirPressDir=0;}
       if(f.anim==Dash)f.dashStopPending=true;
       else{f.dashDir=0;f.setAnim(Skid);}
      }
     if(in.axis&&f.prevAxis==0){
      if(f.lastDirPressDir==in.axis&&ticks-f.lastDirPressTick<=12){
        f.dashDir=f.facing=in.axis;f.dashStopPending=false;f.setAnim(Dash);f.frame=0;
       // Character.initDash: AccelStartDash * MaxXSpeed, not AccelRate.
       f.vx=in.axis*1.1f*RUN_SPEED;startedDash=true;
       }else if(f.dashStopPending||f.anim==Skid){
        f.dashStopPending=false;f.dashDir=0;f.setAnim(Walk);
       }
      f.lastDirPressTick=ticks;f.lastDirPressDir=in.axis;
     }
    }
     if(f.grounded&&(f.anim==Crouch||f.anim==Uncrouch))f.vx=approach(f.vx,0,GROUND_DECEL);
     else if(f.grounded&&f.anim==Turn)f.vx=approach(f.vx,0,GROUND_DECEL);
     else if(f.grounded&&f.anim==Dash&&f.dashStopPending)f.vx=approach(f.vx,f.dashDir*RUN_SPEED,GROUND_ACCEL);
    else if(!startedDash&&in.axis){
     if(f.grounded)f.facing=in.axis;
     const float target=f.grounded?(f.dashDir?RUN_SPEED:WALK_SPEED):7.f;
     if(f.grounded&&f.vx==0&&!f.dashDir)f.vx=in.axis*.5f*WALK_SPEED;
     else f.vx=approach(f.vx,in.axis*target,f.grounded?GROUND_ACCEL:.7f);
    }else if(!startedDash)f.vx=approach(f.vx,0,f.grounded?GROUND_DECEL:.15f);
    if(in.jump&&f.jumpDelay==0){
     if(f.grounded){f.jumpDelay=3;f.shortHop=false;}
     else if(f.airJumps){--f.airJumps;f.vy=-17.4f;f.setAnim(DoubleJump);}
    }
    if(f.jumpDelay){f.shortHop|=!in.jumpHeld;if(--f.jumpDelay==0){f.vy=f.shortHop?-9.5f:-17.4f;f.grounded=false;f.setAnim(Jump);}}
    if(in.attack&&!f.grounded&&!f.jumpDelay&&(isAerial(in.attackMove)||isSpecial(in.attackMove))){
     if(isSpecial(in.attackMove)&&in.attackFacing)f.facing=in.attackFacing;
     startAttack(f,in.attackMove);attacking=true;
    }
    if(in.attack&&f.grounded&&!f.jumpDelay&&!isAerial(in.attackMove)){
     if(in.attackFacing)f.facing=in.attackFacing;
     if(in.attackMove==Jab)startJab(f,f.nextJab&&ticks<=f.comboUntil?f.nextJab:1);
     else startAttack(f,in.attackMove);
     attacking=true;
    }
    if(!attacking&&!f.jumpDelay){
     if(f.grounded){
       if(f.anim!=Turn&&f.anim!=Crouch&&f.anim!=Uncrouch&&!(f.anim==Dash&&f.dashDir)&&!(f.anim==Skid&&!in.axis))
       f.setAnim(std::abs(f.vx)<.1f?Idle:f.dashDir?Run:in.axis?Walk:Idle);
     }
     else if(f.vy>=0)f.setAnim(Fall);
     else if(f.anim!=DoubleJump)f.setAnim(Jump);
    }
   }
   if(f.helpless)f.vx=in.axis?approach(f.vx,in.axis*7.f,.7f):approach(f.vx,0,.15f);
   }
   if(isSpecial(f.anim)&&!f.injured)specialTick(f,in);
  f.prevAxis=in.axis;
   // Main.as / Character.m_charFall: gravity only while below the normal cap.
   // A fresh Down press while descending sets speed directly to FastFallSpeed.
   // Do not clamp it back to 13 when Down is released.
   if(f.vy<NORMAL_FALL_SPEED)f.vy=std::min(NORMAL_FALL_SPEED,f.vy+f.gravity);
     if(!f.grounded&&downPressed&&f.vy>0&&f.vy<FAST_FALL_SPEED&&((!f.injured&&!f.heavyHit)||(f.anim==Tumble&&f.stun==0))&&f.anim!=GetUp&&f.anim!=DSpecial)
     f.vy=FAST_FALL_SPEED;
   if(isCape(f.anim))f.vy=std::min(5.f,f.vy);
   if(isUpSpecial(f.anim)&&f.frame>=11&&f.frame<15)f.vy=0;
   if(f.anim==Hang)f.vy=0;else move(f);
   tryLedge(f,in);
   if(!wasGrounded&&f.grounded&&f.anim==AirDodge){beginExtra(f,DodgeLand);f.landingLock=4;}
   if(isExtra(f.anim)&&f.anim!=Hang&&f.anim!=AirDodge&&f.anim!=Caught&&std::abs(f.y-GROUND)<1.4f){
    f.x=std::clamp(f.x,LEFT+12,RIGHT-12);f.y=GROUND;f.vy=0;f.grounded=true;
   }
   if(isAerial(f.anim)&&!f.aerialLanded&&f.grounded){
    if(!deferAerialLanding)landAerial(f);
   }
    else if(!wasGrounded&&f.grounded&&!f.injured&&f.anim!=GetUp&&f.anim!=Dizzy&&!isExtra(f.anim)&&(!isAttack(f.anim)||isUpSpecial(f.anim))){
    bool heavy=f.helpless||isUpSpecial(f.anim);
    f.setAnim(heavy?SpecialLand:Land);f.landingLock=heavy?15:2;f.dashDir=f.turnDir=0;f.helpless=false;f.tornadoCanRise=true;
   }
   if(isNeutralSpecial(f.anim))f.anim=f.grounded?NSpecial:NSpecialAir;
   if(isCape(f.anim))f.anim=f.grounded?SSpecial:SSpecialAir;
   if(f.grounded)f.tornadoCanRise=true;
    if(!f.grounded){f.dashDir=f.turnDir=0;f.dashStopPending=false;}
  if(isAerial(f.anim)&&f.aerialLanded&&!f.grounded){f.aerialLanded=false;f.setAnim(Fall);}
   if(f.injured&&f.heavyHit&&f.grounded){
    if(f.techWindow>0){beginExtra(f,in.axis?TechRoll:TechGround,in.axis);f.techWindow=0;}
    else{f.setAnim(GetUp);f.downTicks=0;f.injured=false;f.heavyHit=false;f.stun=0;}
   }
  // Sliding off a platform while downed must resume falling, not stand in midair.
  if(f.anim==GetUp&&!f.grounded){f.injured=true;f.heavyHit=true;f.setAnim(Tumble);}
   if(isAttack(f.anim)&&!isAerial(f.anim)&&!isSpecial(f.anim)&&f.y<=GROUND+1&&f.y>=GROUND-1){f.x=std::clamp(f.x,LEFT+12,RIGHT-12);}
   if(f.x<DEATH_LEFT||f.x>DEATH_RIGHT||f.y<DEATH_TOP||f.y>DEATH_BOTTOM)respawn(f,&f==&player?-35.f:35.f);
 }
  void advance(Fighter&f){
   if(f.freeze>0)return;
   if(isExtra(f.anim)){extraAdvance(f);return;}
   if(isSpecial(f.anim)){
    ++f.frame;
    if(isUpSpecial(f.anim)&&f.frame>=21){f.setAnim(Helpless);f.helpless=true;}
    else if(!isUpSpecial(f.anim)&&f.frame>=ANIM_COUNT[f.anim]-1){
     if(isNeutralSpecial(f.anim))f.neutralCooldown=10;
     f.setAnim(f.grounded?Idle:Fall);
    }
    return;
   }
  if(isAerial(f.anim)){
   int end=f.aerialLanded?ANIM_COUNT[f.anim]-1:aerialEnd(f.anim);
   if(++f.frame>=end){f.setAnim(f.grounded?Idle:Fall);f.aerialLanded=false;}
   else if(f.anim==DAir&&!f.aerialLanded&&(f.frame==6||f.frame==8||f.frame==10||f.frame==12)){f.hitThisAttack=false;++f.attackSerial;}
   return;
  }
  if(f.anim>=FTilt&&f.anim<=DSmash){
   if(isSmash(f.anim)&&!f.smashReleased&&f.frame>=chargeStart(f.anim)){
    if(++f.frame>=releaseFrame(f.anim)-1)f.frame=chargeStart(f.anim);
   }else if(++f.frame>=ANIM_COUNT[f.anim]-1)f.setAnim(f.grounded?Idle:Fall);
   return;
  }
  if(f.anim==Jab){
   int end=f.jabPhase==1?7:f.jabPhase==2?17:29;
   if(++f.frame>=end){f.nextJab=f.jabPhase<3?f.jabPhase+1:0;f.comboUntil=ticks+12;f.queuedJab=false;f.setAnim(f.grounded?Idle:Fall);}
  }
  else if(f.anim==Idle)f.frame=(f.frame+1)%32;
  else if(f.anim==Walk)f.frame=(f.frame+1)%20;
  // Terminal frame scripts redirect before rendering that source frame.
  else if(f.anim==Run){if(++f.frame>=ANIM_COUNT[Run]-1)f.frame=0;}
   else if(f.anim==Dash){if(++f.frame>=ANIM_COUNT[Dash]-1){
    if(f.dashStopPending){f.dashStopPending=false;f.dashDir=0;f.setAnim(Skid);}
    else f.setAnim(Run);
   }}
  else if(f.anim==Turn){if(++f.frame>=ANIM_COUNT[Turn]-1){f.facing=f.dashDir=f.turnDir;f.turnDir=0;f.setAnim(Run);}}
  else if(f.anim==Skid){if(++f.frame>=ANIM_COUNT[Skid]-1)f.setAnim(Idle);}
   else if(f.anim==Land){if(++f.frame>=2)f.setAnim(Idle);} // Land_21.frame3; frames 4-8 are dodgeland.
   else if(f.anim==Crouch)f.frame=std::min(3,f.frame+1);
   else if(f.anim==Uncrouch){if(++f.frame>=3)f.setAnim(Idle);}
   else if(f.anim==Shield)f.frame=std::min(2,f.frame+1);
   else if(f.anim==ShieldDrop){if(++f.frame>=5)f.setAnim(Idle);}
   else if(f.anim==Helpless)f.frame=1;
   else if(f.anim==SpecialLand){if(++f.frame>=15)f.setAnim(Idle);}
   else if(f.anim==Dizzy){if(++f.frame>=ANIM_COUNT[Dizzy]-1)f.frame=1;}
  else if(f.anim==Fall)f.frame=1+(f.frame%12);
  else if(f.anim==Hurt)f.frame=std::min(f.hurtStart+8,f.frame+1);
  else if(f.anim==Flying||f.anim==Tumble)f.frame=(f.frame+1)%ANIM_COUNT[f.anim];
  else if(f.anim==GetUp){
   if(f.frame<13)++f.frame;
   else if(f.frame>=15&&++f.frame>=30){f.setAnim(Idle);f.downTicks=0;}
  }
  else f.frame=std::min(26,f.frame+1);
 }
  void hit(Fighter&player,Fighter&dummy){
   if(player.grabbedBy>=0||dummy.grabbedBy==fighterId(player))return;
  if(!isAttack(player.anim)||player.hitThisAttack||player.freeze>0||fighterProtected(dummy))return;
  if(isSmash(player.anim)&&!player.smashReleased)return;
   if(isNeutralSpecial(player.anim))return;
   Frame af=FRAMES[player.sprite()],df=FRAMES[dummy.sprite()];int contact=0;bool blocked=false;
   for(int i=0;i<af.count;i++){Box a=BOXES[af.offset+i];if(!a.attack)continue;
    if(touchesShield(worldBox(a,player),dummy)){contact=a.attack;blocked=true;break;}
   for(int j=0;j<df.count;j++){Box d=BOXES[df.offset+j];if(!d.attack&&overlaps(worldBox(a,player),worldBox(d,dummy)))if(contact==0||a.attack<contact)contact=a.attack;}
  }
  if(!contact)return;
  player.hitThisAttack=true;++hits;
   AttackStats stats=attackStats(player,contact);
   if(blocked){shieldHit(dummy,stats.damage*(isSmash(player.anim)?1+player.chargeTicks/(float)FULL_CHARGE_TICKS*.4f:1));player.freeze=2;return;}
   damageTarget(player,dummy,stats);
   if(isCape(player.anim))dummy.facing=-dummy.facing;
  }
  void damageTarget(Fighter&player,Fighter&dummy,AttackStats stats,bool scaleSmash=true){
  if(fighterProtected(dummy))return;
   releaseGrip(dummy);
   float damage=stats.damage*(scaleSmash&&isSmash(player.anim)?1+std::clamp(player.chargeTicks,0,FULL_CHARGE_TICKS)/(float)FULL_CHARGE_TICKS*.4f:1);
  float direction=stats.angle;
  if(dummy.grounded&&direction>180&&direction<360)direction=360-direction;
  float oldDamage=dummy.damage;dummy.damage+=damage;
  // Main.as and Jab_23.as: first two use weightKB=20; finisher uses power=40,
  // weightKB=0 and damage-dependent knockback. Mario weight=100, ratios=1.
  lastKnockback=calculateKnockback(stats,damage,oldDamage,dummy.weight);
  float speed=lastKnockback*.03f*3.488f,angle=direction*3.14159265358979323846f/180;
  // ReversableAngle defaults true: send away from the attack origin even if
  // an authored box reaches behind the attacker (Utils.calculateReversedAngle).
  float side=!stats.reversible||dummy.x==player.x?(float)player.facing:(dummy.x>player.x?1.f:-1.f);
  float newX=std::cos(angle)*speed*side,newY=-std::sin(angle)*speed;
  if(dummy.knockbackAge>=5&&(dummy.kx!=0||dummy.ky!=0)){
   auto stack=[](float old,float next){return old*next<=0?old+next:(std::abs(next)>std::abs(old)?next:old);};
   newX=stack(dummy.kx,newX);newY=stack(dummy.ky,newY);
  }
  dummy.kx=newX;dummy.ky=newY;dummy.vx=dummy.vy=0;dummy.grounded=false;
  float magnitude=std::sqrt(newX*newX+newY*newY);
  dummy.decayX=magnitude>0?std::abs(newX)/magnitude*(3.488f*.051f):0;
  dummy.decayY=magnitude>0?std::abs(newY)/magnitude*(3.488f*.051f):0;
  dummy.knockbackAge=0;dummy.injuryTicks=0;
  // SSF2 names the brief action-shot pause HitStun, while HitLag is a
  // moving knockback-recovery timer. Do not freeze both actors for HitLag.
  dummy.stun=(int)std::ceil(std::floor(lastKnockback*.4f*.5f)*stats.recoveryMultiplier);
  dummy.injured=true;dummy.hurtStart=((hits-1)%3)*10;
  // Character.HEAVY_KNOCKBACK_THRESHOLD = 2.4 * VELOCITY_SCALE.
  dummy.heavyHit=speed>=2.4f*3.488f;dummy.downTicks=0;
  dummy.setAnim(Hurt);dummy.frame=dummy.hurtStart;dummy.nextJab=0;dummy.queuedJab=false;
   dummy.aerialLanded=false;dummy.landingLock=0;
   dummy.helpless=false;dummy.dashDir=dummy.turnDir=0;dummy.dashStopPending=false;
  dummy.freeze=stats.targetPause>=0?stats.targetPause:(int)std::ceil(std::floor(damage/3.f+3)/2.f+.5f);
  player.freeze=stats.selfPause>=0?stats.selfPause:(int)std::floor((damage/3.f+3)/2);
  }
  void hit(){hit(player,dummy);hit(dummy,player);}
  void tick(Input in={},Input opponent={}){
   ++ticks;advance(player);advance(dummy);
   if(aiEnabled)opponent=ai.think(dummy,player,projectiles,ticks,fighterId(dummy));
   updateFighter(player,in,true);updateFighter(dummy,opponent,true);updateGrabs();hit();
   // Resolve the last active aerial pose before ground contact replaces its boxes.
   for(auto f:{&player,&dummy})if(isAerial(f->anim)&&!f->aerialLanded&&f->grounded)landAerial(*f);
   updateProjectiles();
   for(Fighter*f:{&player,&dummy})if(f->lastCameraSprite!=f->sprite()){
    f->lastCameraSprite=f->sprite();if(FRAME_CAMERA_SHAKE[f->sprite()])camera.shake(FRAME_CAMERA_SHAKE[f->sprite()]);
   }
   camera.update(player,dummy);
 }
};
#include "special-actions.h"
#include "extended-actions.h"
}
