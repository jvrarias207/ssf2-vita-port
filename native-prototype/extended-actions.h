#pragma once
inline void Game::beginExtra(Fighter&f,int anim,int direction){
 float oldSpeed=f.vx;
 f.setAnim(anim);f.frame=0;f.extraEventFrame=-1;f.actionDir=direction?direction:f.facing;
 f.dashDir=f.turnDir=0;f.dashStopPending=false;f.landingLock=0;f.helpless=false;
 f.hitThisAttack=false;++f.attackSerial;
 if(anim!=EdgeLean&&anim!=Hang&&anim!=AirDodge)f.vx=0;
 if(anim==Grab)f.vx=oldSpeed*.7f;
 if(anim==DashGrab)f.vx=f.actionDir*RUN_SPEED;
 if(anim==DashAttack)f.vx=f.facing*14.f;
 if(anim==DodgeRoll||anim==TechRoll||anim==GetUpRoll)f.facing=-f.actionDir;
 if(anim==DodgeRoll)f.vx=f.actionDir*15.f;
 if(anim==TechRoll)f.vx=f.rollSpeed=f.actionDir*22.f;
 if(anim==TechGround||anim==TechRoll){f.injured=f.heavyHit=false;f.stun=0;f.kx=f.ky=0;}
 if(anim==AirDodge)f.rollSpeed=0; // Source Brawl air dodge; preserve momentum.
 if(anim==AirDodge){int nudge=direction?direction:f.facing;f.vx=std::clamp(f.vx+nudge*3.f,-RUN_SPEED,RUN_SPEED);}
}
inline void Game::releaseGrip(Fighter&f){
 if(f.grabTarget>=0){
  Fighter&t=fighterAt(f.grabTarget);t.grabbedBy=-1;t.rotation=0;
  if(t.anim==Caught||t.anim==CaughtSpin)t.setAnim(t.grounded?Idle:Fall);
  f.grabTarget=-1;
  if(f.anim==GrabHold||f.anim==Pummel)f.setAnim(f.grounded?Idle:Fall);
 }
 if(f.grabbedBy>=0){
  Fighter&holder=fighterAt(f.grabbedBy);holder.grabTarget=-1;
  if(holder.anim==GrabHold||holder.anim==Pummel)holder.setAnim(holder.grounded?Idle:Fall);
  f.grabbedBy=-1;f.rotation=0;
  if(f.anim==Caught||f.anim==CaughtSpin)f.setAnim(f.grounded?Idle:Fall);
 }
}
inline bool Game::extraTick(Fighter&f,Input in,bool downPressed,bool upPressed,bool shieldPressed){
 bool freshSide=in.axis&&in.axis!=f.prevAxis;
 if(f.grabTarget>=0){
  Fighter&t=fighterAt(f.grabTarget);
  if(f.anim==GrabHold||f.anim==Pummel){
   if(--f.grabTimer<=0){releaseGrip(f);return true;}
   if(in.attack||in.grab||in.specialPressed||freshSide||upPressed||downPressed){
    if(in.up)beginExtra(f,UThrow);
    else if(in.fastFall)beginExtra(f,DThrow);
    else if(in.axis)beginExtra(f,in.axis==f.facing?FThrow:BThrow);
    else if(f.anim==GrabHold)beginExtra(f,Pummel);
   }
  }
  if(f.extraEventFrame!=f.frame){
   int sprite=f.sprite();
   if(FRAME_THROW_SPIN[sprite])f.victimSpin=true;
   if(FRAME_THROW_FLIP[sprite])f.victimFacing=-f.victimFacing;
   if(FRAME_THROW_ROTATION[sprite]!=9999.f)t.rotation=FRAME_THROW_ROTATION[sprite]*f.facing;
  }
  attachHeld(f);
  if(f.anim==Pummel&&!f.hitThisAttack){
   Frame active=FRAMES[f.sprite()];bool contact=false;
   for(int i=0;i<active.count;i++)contact|=BOXES[active.offset+i].attack>0;
   if(contact){t.damage+=1;++hits;f.freeze=2;f.hitThisAttack=true;}
  }
 }
 if(f.anim==Hang){
  ++f.ledgeAge;f.vx=f.vy=f.kx=f.ky=0;
  if(f.ledgeAge>4){
   if(downPressed||(freshSide&&in.axis!=f.facing)||f.ledgeAge>=120){
    f.ledgeCooldown=15;f.setAnim(Fall);f.x-=f.facing*14;f.y+=2;f.vy=1.3f;return true;
   }
   if(in.jump){f.ledgeCooldown=15;f.setAnim(Jump);f.vy=-17.4f;f.airJumps=1;f.x-=f.facing*6;return true;}
   int action=in.shield?HangRoll:in.attack||in.specialPressed?HangAttack:upPressed||(freshSide&&in.axis==f.facing)?HangClimb:Hang;
   if(action!=Hang){int inward=f.facing;f.x=std::clamp(f.x+inward*14.f,LEFT+12,RIGHT-12);f.y=GROUND;f.grounded=true;f.ledgeCooldown=15;beginExtra(f,action,inward);}
  }
  return true;
 }
 if(f.anim==GetUp&&f.frame==13&&f.downTicks>=13){
  if(in.attack||in.grab){beginExtra(f,GetUpAttack);return true;}
  if(in.axis){beginExtra(f,GetUpRoll,in.axis);return true;}
 }
 if(!f.injured&&!f.helpless&&!f.landingLock){
  bool freeGround=f.anim==Idle||f.anim==Walk||f.anim==Run||f.anim==Dash||f.anim==Crouch||f.anim==Uncrouch||f.anim==EdgeLean||f.anim==Shield;
  if(f.grounded&&in.grab&&freeGround){
   beginExtra(f,f.anim==Run||f.anim==Dash?DashGrab:Grab,f.facing);return true;
  }
  if(f.grounded&&(f.anim==Shield||(shieldPressed&&freeGround))&&f.shieldStun==0){
   if(downPressed){beginExtra(f,SpotDodge);return true;}
   if(freshSide){beginExtra(f,DodgeRoll,in.axis);return true;}
  }
  if(!f.grounded&&shieldPressed&&!isAttack(f.anim)&&!isExtra(f.anim)){beginExtra(f,AirDodge,in.axis);return true;}
  if(f.grounded&&in.taunt&&freeGround){beginExtra(f,in.taunt==1?TauntSide:in.taunt==2?TauntNeutral:TauntUpDown);return true;}
 }
 if(f.anim==EdgeLean){
  if(in.axis||in.fastFall||in.jump||in.attack||in.grab||in.shield||in.taunt){f.setAnim(Idle);return false;}
  f.vx=0;return true;
 }
 if(f.anim==Idle&&f.grounded&&!in.axis&&!in.fastFall&&!in.attack&&!in.jump&&!in.shield){
  if((f.facing<0&&f.x<LEFT+16)||(f.facing>0&&f.x>RIGHT-16)){beginExtra(f,EdgeLean);return true;}
 }
 if(!isExtra(f.anim))return false;
 if(f.anim==Grab||f.anim==DashGrab)f.vx=approach(f.vx,0,f.anim==DashGrab?.6f:GROUND_DECEL);
 if(f.anim==DashAttack)f.vx=approach(f.vx,0,.85f);
 if(f.anim==GrabHold||f.anim==Pummel||isThrow(f.anim)||f.anim>=TauntSide)f.vx=0;
 if(f.anim==HangClimb){if(f.frame==6&&f.extraEventFrame!=f.frame)f.vx=f.facing*6.f;else f.vx=approach(f.vx,0,GROUND_DECEL);}
 if(f.anim==HangAttack){if(f.frame==9&&f.extraEventFrame!=f.frame)f.vx=f.facing*8.5f;else f.vx=approach(f.vx,0,GROUND_DECEL);}
 if(f.anim==HangRoll||f.anim==GetUpRoll||f.anim==TechRoll){
  int start=f.anim==HangRoll?8:f.anim==GetUpRoll?4:0;
  if(f.frame==start&&f.extraEventFrame!=f.frame)f.rollSpeed=f.actionDir*22.f;
  else if(f.frame>start&&f.extraEventFrame>=0)f.rollSpeed=std::round(f.rollSpeed*.8f*10)/10;
  f.vx=f.frame>=start?f.rollSpeed:0;
 }
 if(f.anim==DodgeRoll){if(f.frame==0&&f.extraEventFrame!=f.frame)f.vx=f.actionDir*15.f;else f.vx=approach(f.vx,0,1.03f);}
 if(f.anim==SpotDodge||f.anim==TechGround)f.vx=0;
 if(f.anim==DodgeLand){f.vx=approach(f.vx,0,GROUND_DECEL);if(f.landingLock>0)--f.landingLock;}
 if(f.anim==AirDodge){} // Source preserves momentum; directional nudge applied at entry.
 f.extraEventFrame=f.frame;
 return true;
}
inline void Game::extraAdvance(Fighter&f){
 if(f.anim==Caught){f.frame=0;return;}
 if(f.anim==CaughtSpin){f.frame=(f.frame+1)%9;return;}
 if(f.anim==GrabHold){f.frame=1;return;}
 if(f.anim==Hang){if(++f.frame>=6)f.frame=3;return;}
 if(f.anim==EdgeLean){if(++f.frame>=42)f.frame=2;return;}
 int old=f.anim;
 if(++f.frame>=ANIM_COUNT[old]-1){
  if(old==Pummel&&f.grabTarget>=0){f.setAnim(GrabHold);return;}
  if(isThrow(old)){releaseGrip(f);if(old==BThrow)f.facing=-f.facing;}
  f.setAnim(f.grounded?Idle:Fall);
 }
}
inline void Game::updateGrabs(){
 for(Fighter*f:{&player,&dummy}){
  Fighter&t=&player==f?dummy:player;
  if((f->anim==Grab||f->anim==DashGrab)&&f->grabTarget<0&&fighterGrabbable(t)){
   Frame markers=MARKER_FRAMES[f->sprite()];bool contact=false;
   for(int i=0;i<markers.count;i++){Box b=MARKERS[markers.offset+i];if(b.attack!=1)continue;b=worldBox(b,*f);
    Frame hurt=FRAMES[t.sprite()];for(int j=0;j<hurt.count;j++){Box h=BOXES[hurt.offset+j];if(!h.attack&&overlaps(b,worldBox(h,t)))contact=true;}
   }
   if(contact){
    releaseGrip(t);f->grabTarget=fighterId(t);t.grabbedBy=fighterId(*f);t.injured=t.heavyHit=t.helpless=false;t.freeze=t.stun=0;t.kx=t.ky=t.vx=t.vy=0;
    t.setAnim(Caught);t.frame=0;f->victimSpin=false;f->victimFacing=-f->facing;f->grabTimer=(int)((90+t.damage*1.7f)/2);beginExtra(*f,GrabHold);
   }
  }
  if(f->grabTarget>=0){
   attachHeld(*f);
   if(isThrow(f->anim)&&!f->hitThisAttack){
    Frame active=FRAMES[f->sprite()];bool release=false;
    for(int i=0;i<active.count;i++)release|=BOXES[active.offset+i].attack>0;
    if(release){Fighter&target=fighterAt(f->grabTarget);auto stats=attackStats(*f,1);releaseGrip(*f);f->hitThisAttack=true;++hits;damageTarget(*f,target,stats,false);}
   }
  }
 }
}
inline void Game::attachHeld(Fighter&f){
 if(f.grabTarget<0)return;
 Fighter&target=fighterAt(f.grabTarget);Frame markers=MARKER_FRAMES[f.sprite()];bool positioned=false;
 for(int i=0;i<markers.count;i++){Box b=MARKERS[markers.offset+i];if(b.attack!=2)continue;b=worldBox(b,f);target.x=b.x+b.w/2;target.y=b.y+b.h;positioned=true;break;}
 if(!positioned&&!isThrow(f.anim)){target.x=f.x+f.facing*28;target.y=f.y;}
 target.facing=f.victimFacing;target.grounded=f.grounded;
 if(f.victimSpin&&target.anim!=CaughtSpin)target.setAnim(CaughtSpin);
}
inline void Game::tryLedge(Fighter&f,Input in){
 if(f.anim==Hang||f.ledgeCooldown||f.grounded||f.grabbedBy>=0||in.fastFall||(f.injured&&f.stun>0)||(f.vy<0&&!isAttack(f.anim)))return;
 Fighter&other=&f==&player?dummy:player;
 Frame markers=MARKER_FRAMES[f.sprite()];
 for(int side:{-1,1}){
  float ledge=side<0?LEDGE_LEFT_X:LEDGE_RIGHT_X,ledgeY=side<0?LEDGE_LEFT_Y:LEDGE_RIGHT_Y;
  float w=side<0?LEDGE_LEFT_W:LEDGE_RIGHT_W,h=side<0?LEDGE_LEFT_H:LEDGE_RIGHT_H;
  if((side<0&&f.x>=ledge)||(side>0&&f.x<=ledge)||(other.anim==Hang&&other.ledgeSide==side))continue;
  Box ledgeBox{ledge-w/2,ledgeY-h/2,w,h,0};bool contact=false;
  for(int i=0;i<markers.count;i++){Box hand=MARKERS[markers.offset+i];if(hand.attack==3&&overlaps(worldBox(hand,f),ledgeBox))contact=true;}
  if(!contact)continue;
  releaseGrip(f);f.setAnim(Hang);f.frame=0;f.ledgeSide=side;f.ledgeAge=0;f.facing=-side;f.x=ledge;f.y=ledgeY;
  f.vx=f.vy=f.kx=f.ky=0;f.injured=f.heavyHit=f.helpless=false;f.freeze=f.stun=0;f.airJumps=1;f.tornadoCanRise=true;return;
 }
}
