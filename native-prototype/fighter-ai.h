#pragma once
// Medium-level opponent AI (30 Hz). Emits only inputs a human can produce on
// the prototype controls: bounded reaction window, imperfect defense, source
// legal moves only. Deterministic from reset() so native checks are repeatable.
struct FighterAI {
 enum Plan {P_Neutral,P_Approach,P_Space,P_Strike,P_Smash,P_Grab,P_Shield,P_Dodge,
            P_Roll,P_AirDodge,P_Hop,P_AirStrike,P_AirIdle,P_Fireball,P_Cape,P_Tornado,
            P_Recover,P_Taunt,P_Downed,P_Tech,P_EdgeGuard};
 int plan=P_Neutral,planTicks=0,planAge=0,decisionCd=0,reactCd=0;
 int planMove=Jab,planFacing=0,planCharge=0,holdAge=0,throwAt=0,seq=0;
 bool reactArmed=false,planFired=false,pummeled=false;
 int prevGrabTarget=-1;
 unsigned rng=0x2545f491u;
 void reset(){plan=P_Neutral;planTicks=planAge=decisionCd=reactCd=0;
  planMove=Jab;planFacing=planCharge=holdAge=throwAt=seq=0;
  reactArmed=planFired=pummeled=false;prevGrabTarget=-1;rng=0x2545f491u;}
 unsigned rand(){rng^=rng<<13;rng^=rng>>17;rng^=rng<<5;return rng;}
 int roll(int n){return (int)(rand()%n);}
 static bool isDefense(int p){return p==P_Shield||p==P_Dodge||p==P_Roll||p==P_AirDodge;}
 // Attack reaching toward me, or a grab attempt inside burst range.
 bool threatened(const Fighter&me,const Fighter&foe,int adx)const{
  if(!(isAttack(foe.anim)||foe.anim==Grab||foe.anim==DashGrab))return false;
  return adx<85&&(me.x-foe.x)*foe.facing>=-40;
 }
 bool pickStrike(int adx,const Fighter&me,int dir){
  if(adx<40){int r=roll(6);planMove=r<2?Jab:r<5?FTilt:DTilt;}
  else if(me.anim==Dash||me.anim==Run){int r=roll(5);planMove=r<3?FTilt:(r==3?DashAttack:Jab);}
  else {int r=roll(6);planMove=r<4?FTilt:Jab;}
  planFacing=dir;return true;
 }
 void decide(const Fighter&me,const Fighter&foe,const Projectile*pr,int meId,int adx,int dir){
  int r;
  // Offstage: double jump, then up special, drifting toward the stage.
  if(!me.grounded&&(plan==P_Recover||me.x<LEFT-3||me.x>RIGHT+3||me.y>GROUND+8)){plan=P_Recover;planTicks=30;return;}
  if(me.anim==GetUp){plan=P_Downed;planTicks=40;return;}
  bool threat=threatened(me,foe,adx);
  bool incoming=false;
  for(int i=0;i<12;i++){const Projectile&p=pr[i];
   if(!p.active||p.owner==meId)continue;
   float d=p.x-me.x;
   if(d*p.vx<0&&std::abs(d)<110&&std::abs(p.y-(me.y-25))<50){incoming=true;break;}}
  // Tech a heavy landing by holding shield just before touchdown.
  if(me.injured&&me.heavyHit&&me.stun==0&&!me.grounded&&me.vy>0&&me.y>GROUND-55){
   plan=P_Tech;planTicks=6;return;}
  // Reacted threat: imperfect defense menu.
  if((threat||incoming)&&reactArmed&&reactCd==0){
   if(!me.grounded){plan=roll(10)<6?P_AirDodge:P_AirIdle;planTicks=8;return;}
   r=roll(10);
   if(me.shieldHealth<35)plan=P_Dodge,planTicks=4;
   else if(r<5)plan=P_Shield,planTicks=24;
   else if(r<7)plan=P_Dodge,planTicks=4;
   else if(r<8&&me.x-dir*35>LEFT+15&&me.x-dir*35<RIGHT-15)plan=P_Roll,planFacing=-dir,planTicks=4;
   else plan=P_Space,planTicks=8;
   return;}
  // Still reacting: give ground instead of challenging.
  if((threat||incoming)&&reactArmed){plan=P_Space;planTicks=reactCd+3;return;}
  if(!me.grounded){
   if(adx<85&&!(foe.anim==SpotDodge||foe.anim==DodgeRoll||foe.anim==AirDodge||FRAME_INTANGIBLE[foe.sprite()]))
    plan=P_AirStrike,planTicks=14;
   else plan=P_AirIdle,planTicks=10;
   return;}
  bool foeLag=foe.grounded&&(foe.landingLock>0||foe.anim==Land||foe.anim==SpecialLand||
   foe.anim==Dizzy||foe.anim==ShieldDrop||(foe.injured&&foe.stun>0)||
   (foe.anim==GetUp&&foe.frame>=15)||(foe.anim==Turn));
  if(adx<75&&foeLag){
   if(adx<40&&roll(4)==0)plan=P_Grab,planTicks=18;
   else if(adx<60&&roll(5)==0){plan=P_Smash;planMove=roll(2)?FSmash:USmash;
    planFacing=planMove==FSmash?dir:0;planCharge=6+roll(14);planTicks=planCharge+35;}
   else {pickStrike(adx,me,dir);plan=P_Strike;planTicks=12;}
   return;}
  // Shield-grab a blocking opponent.
  if(adx<38&&foe.anim==Shield&&fighterGrabbable(foe)){plan=P_Grab;planTicks=18;return;}
  // Juggle a foe overhead.
  if(foe.y<me.y-38&&adx<50){
   if(roll(3)){pickStrike(adx,me,dir);planMove=UTilt;planFacing=0;plan=P_Strike;planTicks=12;}
   else {plan=P_Smash;planMove=USmash;planFacing=0;planCharge=6+roll(12);planTicks=planCharge+35;}
   return;}
  // Full or short hop into an aerial on an airborne foe.
  if(!foe.grounded&&adx<95&&adx>25&&foe.y<me.y-15){
   plan=P_Hop;planCharge=roll(3)?1:0;planTicks=22;return;}
  bool foeDodge=foe.anim==SpotDodge||foe.anim==DodgeRoll||foe.anim==AirDodge||fighterProtected(foe);
  if(adx<62&&!foeDodge){
   r=roll(10);
   if(r<5){pickStrike(adx,me,dir);plan=P_Strike;planTicks=12;}
   else if(r<6&&adx<35){plan=P_Tornado;planTicks=30;}
   else if(r<7){plan=P_Smash;planMove=FSmash;planFacing=dir;planCharge=6+roll(14);planTicks=planCharge+35;}
   else if(r<8&&adx<40){plan=P_Grab;planTicks=18;}
   else plan=P_Space,planTicks=6;
   return;}
  if(adx<62){plan=P_Space;planTicks=8;return;}
  // Edge-guard a foe trying to return.
  bool foeOff=foe.x<LEFT||foe.x>RIGHT||(!foe.grounded&&(foe.x<LEFT+30||foe.x>RIGHT+30));
  if(foeOff){plan=P_EdgeGuard;planTicks=20;return;}
  bool edgeBlocked=(dir<0&&me.x<LEFT+95)||(dir>0&&me.x>RIGHT-95);
  if(adx>150&&me.facing==dir&&me.neutralCooldown==0&&roll(3)==0){plan=P_Fireball;planTicks=4;return;}
  if(adx>230&&roll(14)==0){plan=P_Taunt;planTicks=3;return;}
  if(adx>=62){
   if(edgeBlocked&&me.facing==dir&&me.neutralCooldown==0&&roll(2)==0){plan=P_Fireball;planTicks=4;return;}
   plan=edgeBlocked?P_Space:P_Approach;planTicks=edgeBlocked?6:14;return;}
  plan=P_Space;planTicks=8;
 }
 Input think(const Fighter&me,const Fighter&foe,const Projectile* pr,int now,int meId){
  Input out;
  int dx=(int)(foe.x-me.x);int adx=std::abs(dx);
  int dir=dx==0?me.facing:(dx>0?1:-1);
  // Mashing: alternate direction every two ticks plus attack presses.
  if(me.grabbedBy>=0){
   out.axis=((now>>1)&1)?dir:-dir;
   if(now%4==0){out.attack=true;out.normalAttackPressed=true;}
   if(now%6==0)out.specialPressed=true;
   return out;}
  // Holding a grab: one pummel, then a throw.
  if(me.grabTarget>=0){
   if(prevGrabTarget<0){holdAge=0;throwAt=6+roll(9);pummeled=false;}
   prevGrabTarget=me.grabTarget;
   if(isThrow(me.anim))return out;
   ++holdAge;
   if(!pummeled&&holdAge==3&&roll(2)==0){pummeled=true;out.attack=true;out.normalAttackPressed=true;return out;}
   if(holdAge>=throwAt){
    holdAge=0;out.attack=true;out.normalAttackPressed=true;
    int r=roll(10);
    if(r<5)out.axis=me.facing;          // forward throw
    else if(r<7){out.up=true;}          // up throw
    else if(r<8)out.axis=-me.facing;    // back throw
    else out.fastFall=true;             // down throw
   }
   return out;}
  prevGrabTarget=-1;
  // On the ledge: climb once the source startup has passed.
  if(me.anim==Hang){if(me.ledgeAge>6)out.up=true;return out;}
  bool threat=threatened(me,foe,adx),incoming=false;
  for(int i=0;i<12;i++){const Projectile&p=pr[i];
   if(!p.active||p.owner==meId)continue;
   float d=p.x-me.x;
   if(d*p.vx<0&&std::abs(d)<110&&std::abs(p.y-(me.y-25))<50){incoming=true;break;}}
  bool forceDecide=false;
  if(threat||incoming){
   if(!reactArmed){reactArmed=true;reactCd=5+roll(6);forceDecide=true;}
   else if(reactCd>0)--reactCd;
  }else{reactArmed=false;reactCd=0;}
  bool reacted=reactArmed&&reactCd==0;
  if(reacted&&plan==P_Space)forceDecide=true;
  bool offstage=!me.grounded&&(me.x<LEFT-3||me.x>RIGHT+3||me.y>GROUND+8);
  if(offstage&&plan!=P_Recover)forceDecide=true;
  if(me.grounded&&plan==P_Recover)forceDecide=true;
  if(plan==P_Shield&&!threat&&!incoming)plan=P_Neutral;
  if(planTicks>0)--planTicks;
  if(forceDecide||(planTicks<=0&&decisionCd<=0)){
   decide(me,foe,pr,meId,adx,dir);decisionCd=4+roll(5);planAge=0;planFired=false;
  }else{if(decisionCd>0)--decisionCd;++planAge;}
  // ---- emission ----
  switch(plan){
  case P_Neutral:
   if(me.grounded&&me.facing!=dir&&adx>10)out.axis=dir;
   break;
  case P_Approach:
   if(me.grounded){
    bool nearEdge=(dir<0&&me.x<LEFT+90)||(dir>0&&me.x>RIGHT-90);
    if(adx<58||nearEdge)out.axis=0;
    else if(adx>110){ // double-tap into a dash
     if(planAge==1)out.axis=0;else out.axis=dir;
    }else out.axis=dir;}
   break;
  case P_Space:
   if(me.grounded&&adx<28){int back=-dir;
    if(me.x+back*6>LEFT+16&&me.x+back*6<RIGHT-16)out.axis=back;}
   else if(me.grounded&&me.facing!=dir&&adx>12)out.axis=dir;
   break;
  case P_Strike:
   if(planAge==0&&me.grounded){
    out.attack=true;out.normalAttackPressed=true;out.attackMove=planMove;
    out.attackFacing=planFacing;if(planFacing)out.axis=planFacing;}
   break;
  case P_Smash:
   if(me.grounded&&planAge<=planCharge){
    if(planAge==0){out.attack=true;out.normalAttackPressed=true;out.attackMove=planMove;
     out.attackFacing=planFacing;if(planFacing)out.axis=planFacing;out.smashHeld=true;}
    else out.smashHeld=true;}
   break;
  case P_Grab:
   if(planAge==0&&me.grounded)out.grab=true;
   break;
  case P_Shield:
   if(me.grounded&&me.shieldHealth>25)out.shield=true;
   break;
  case P_Dodge:
   if(me.grounded&&planAge==0)out.shield=true;
   else if(me.grounded&&planAge==1){out.shield=true;out.fastFall=true;}
   break;
  case P_Roll:
   if(me.grounded&&planAge==0)out.shield=true;
   else if(me.grounded&&planAge==1){out.shield=true;out.axis=planFacing;}
   break;
  case P_AirDodge:
   if(!me.grounded&&planAge==0)out.shield=true;
   break;
  case P_Hop:
   if(me.grounded&&planAge<=4){
    if(planAge==0){out.jump=true;out.jumpHeld=true;seq=planCharge?4:1;}
    else if(planCharge)out.jumpHeld=true;}
   else if(!me.grounded&&planAge>=5){out.axis=dir;
    if(!planFired&&adx<72&&std::abs(me.y-foe.y)<55){
     planFired=true;out.attack=true;out.normalAttackPressed=true;
     out.attackMove=foe.y<me.y-30?UAir:me.y<foe.y-35?DAir:dir==me.facing?FAir:BAir;}}
   break;
  case P_AirStrike:
   out.axis=dir;
   if(!planFired&&adx<72&&std::abs(me.y-foe.y)<55){
    planFired=true;out.attack=true;out.normalAttackPressed=true;
    out.attackMove=foe.y<me.y-30?UAir:me.y<foe.y-35?DAir:dir==me.facing?FAir:BAir;}
   break;
  case P_AirIdle:
   if(me.vy>2&&me.y<GROUND-25)out.fastFall=true;
   break;
  case P_Fireball:
   if(planAge==0&&me.grounded&&me.neutralCooldown==0){
    out.attack=true;out.normalAttackPressed=true;out.specialPressed=true;
    out.attackMove=NSpecial;out.attackFacing=0;}
   break;
  case P_Cape:
   if(planAge==0&&me.grounded){
    out.attack=true;out.normalAttackPressed=true;out.specialPressed=true;
    out.attackMove=SSpecial;out.attackFacing=dir;out.axis=dir;}
   break;
  case P_Tornado:
   if(planAge==0&&me.grounded){
    out.attack=true;out.normalAttackPressed=true;out.specialPressed=true;
    out.attackMove=DSpecial;out.attackFacing=0;}
   break;
  case P_Recover:{
   int stageDir=me.x<LEFT?1:me.x>RIGHT?-1:(me.x<0?1:-1);
   out.axis=stageDir;
   if(!me.grounded){
    if(seq==0&&me.airJumps>0&&me.vy>0&&me.y>GROUND-60){
     out.jump=true;out.jumpHeld=true;seq=4;}
    else if(seq==0&&me.airJumps==0&&!planFired&&!me.helpless&&
            !isUpSpecial(me.anim)&&me.vy>0&&me.y>GROUND+15){
     planFired=true;out.attack=true;out.normalAttackPressed=true;out.specialPressed=true;
     out.attackMove=USpecial;out.attackFacing=stageDir;}
   }
   break;}
  case P_Taunt:
   if(planAge==0&&me.grounded)out.taunt=1;
   break;
  case P_Downed:
   if(!planFired&&me.anim==GetUp&&me.frame==13&&me.downTicks>=13){
    planFired=true;int r=roll(10);
    bool canRoll=me.x-dir*35>LEFT+15&&me.x-dir*35<RIGHT-15;
    if(adx<55&&r<4){out.attack=true;out.normalAttackPressed=true;}
    else if(canRoll&&r<7)out.axis=-dir;
    else out.jump=true;}
   break;
  case P_Tech:
   if(me.injured&&!me.grounded)out.shield=true;
   break;
  case P_EdgeGuard:{
   int t=dir;
   if((t<0&&me.x<LEFT+25)||(t>0&&me.x>RIGHT-25))t=0;
   out.axis=t;
   if(planAge==0&&me.grounded&&me.facing==dir&&me.neutralCooldown==0&&adx<200&&roll(3)==0){
    out.attack=true;out.normalAttackPressed=true;out.specialPressed=true;
    out.attackMove=NSpecial;out.attackFacing=0;out.axis=0;}
   break;}
  default:break;
  }
  // Brake aerial approaches before long, uncancellable aerials drift past the lip.
  if(!me.grounded&&plan!=P_Recover){
   if(me.x<LEFT+60)out.axis=1;
   else if(me.x>RIGHT-60)out.axis=-1;
  }
  if(seq>0){out.jumpHeld=true;--seq;}
  return out;
 }
};
