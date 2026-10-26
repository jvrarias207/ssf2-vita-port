#pragma once
// Included inside namespace ssf after Game. Original frame numbers are one-based in comments.
inline void Game::specialTick(Fighter&f,Input in){
 bool entered=f.specialEventFrame!=f.frame;
 if(entered){
  f.specialEventFrame=f.frame;
  if(isNeutralSpecial(f.anim)&&f.frame==8)spawnFireball(f); // NSpecial.frame9
  if(isCape(f.anim)&&f.frame==5&&!f.grounded)f.vy=-4; // Cape.frame6
  if(isUpSpecial(f.anim)){
   if(f.frame<=3){
    f.specialAngle-=in.axis*f.facing*5.5f;
    if(f.frame==3)f.specialAngle=std::max(45.f,f.specialAngle);
   }
   if(f.frame>=3&&f.frame<=11){f.hitThisAttack=false;++f.attackSerial;}
   if(f.frame==11)f.vx=f.vy=0;
  }
  if(f.anim==DSpecial){
   const int refresh[]={2,4,5,8,10,11,13,14,16,18,20};
   for(int frame:refresh)if(f.frame==frame){f.hitThisAttack=false;++f.attackSerial;}
   if(f.frame==16&&!f.grounded)f.tornadoCanRise=false;
   if(f.frame==18&&!f.grounded)f.vy=-4;
  }
 }
 if(isNeutralSpecial(f.anim))f.vx=f.grounded?approach(f.vx,0,GROUND_DECEL):in.axis?approach(f.vx,in.axis*7.f,.7f):approach(f.vx,0,.15f);
 if(isCape(f.anim))f.vx=f.grounded?approach(f.vx,0,GROUND_DECEL):approach(f.vx,0,1.f);
 if(isUpSpecial(f.anim)){
  const int end=f.anim==USpecial?8:10;
  if(f.frame>=3&&f.frame<=end){
   float angle=f.specialAngle*3.14159265f/180.f;
   f.vx=f.facing*25.f*std::cos(angle);f.vy=-25.f*std::sin(angle);f.grounded=false;
  }else if(f.frame<3)f.vx=0;
  else if(f.frame<11)f.vx=approach(f.vx,0,f.grounded?.86f:2.f);
  else if(f.frame>=15)f.vx=in.axis?approach(f.vx,in.axis*7.f,.7f):f.vx;
 }
 if(f.anim==DSpecial){
  f.tornadoLifted=false;
  f.vx=in.axis?approach(f.vx,in.axis*3.f,f.grounded?GROUND_ACCEL:.7f):approach(f.vx,0,f.grounded?GROUND_DECEL:.15f);
  if(f.frame>=2&&f.frame<16&&in.specialPressed&&f.tornadoCanRise){
   f.tornadoRise-=2;f.vy=f.tornadoRise;f.grounded=false;f.tornadoLifted=true;
  }
  if(f.frame>=22&&f.frame<25)f.vy=-f.gravity; // air_ease=0 after gravity
 }
}
inline void Game::spawnFireball(Fighter&f){
 int owner=&f==&player?0:1,count=0;
 for(const auto&p:projectiles)if(p.active&&p.owner==owner)++count;
 if(count>=6)return; // Main.mario_fireball.limit
 for(auto&p:projectiles)if(!p.active){p=Projectile{};p.active=true;p.owner=owner;p.x=f.x+f.facing*22;p.y=f.y-20;p.vx=f.facing*8;return;}
}
inline void Game::breakShield(Fighter&f){
 f.invincibleTicks=15; // Character.m_breakShield, revival timer MaxTime - 15.
 f.shieldHealth=60;f.dizzyTicks=90;f.setAnim(Dizzy);f.vx=f.kx=f.ky=0;
 f.vy=-calculateKnockback({0,90,14,100,40},0,0,f.weight)*.03f*3.488f;
 f.grounded=false;f.dashDir=f.turnDir=0;f.dashStopPending=false;
}
inline void Game::shieldHit(Fighter&f,float damage){
 f.shieldHealth-=damage*1.4f; // Character.takeDamage: damage * .7 * 2
 f.shieldStun=std::max(f.shieldStun,2+(int)std::ceil(damage*.3f));
 if(f.shieldHealth<=0)breakShield(f);
}
inline void Game::updateProjectiles(){
 for(auto&p:projectiles){
  if(!p.active)continue;
  if(++p.age>=40){p.active=false;continue;}
  p.vy=std::min(7.f,p.vy+1.1f);
  float nextX=p.x+p.vx;
  if(inside(nextX,p.y)&&p.y>GROUND){p.vx=-p.vx;nextX=p.x+p.vx;}
  p.x=nextX;p.y+=p.vy;
  if(p.x>=LEFT&&p.x<=RIGHT&&p.vy>0&&p.y+5.5f>=GROUND){p.y=GROUND-5.5f;p.vy=-p.bounce;p.bounce*=.95f;}
  Fighter&target=p.owner==0?dummy:player;
  Box bounds{p.x-5.5f,p.y-5.5f,11,11,1};
  Fighter pose;pose.x=p.x;pose.y=p.y;pose.facing=p.vx>=0?1:-1;pose.anim=Fireball;pose.frame=p.sprite()-ANIM_START[Fireball];
  Frame projectileFrame=FRAMES[p.sprite()];
  for(int i=0;i<projectileFrame.count;i++){Box b=BOXES[projectileFrame.offset+i];if(b.attack){bounds=worldBox(b,pose);break;}}
  if(isCape(target.anim)){
   Frame cape=FRAMES[target.sprite()];bool reflect=false;
   for(int i=0;i<cape.count;i++){Box a=BOXES[cape.offset+i];if(a.attack&&overlaps(worldBox(a,target),bounds))reflect=true;}
   if(reflect){p.owner=1-p.owner;p.vx=-p.vx;continue;}
  }
  if(fighterProtected(target))continue;
  if(touchesShield(bounds,target)){shieldHit(target,5);p.active=false;++hits;continue;}
  Frame frame=FRAMES[target.sprite()];bool contact=false;
  for(int i=0;i<frame.count;i++){Box b=BOXES[frame.offset+i];if(!b.attack&&overlaps(bounds,worldBox(b,target)))contact=true;}
  if(contact){
   Fighter&owner=p.owner==0?player:dummy;int oldFreeze=owner.freeze;
   damageTarget(owner,target,{5,45,20,0,0,2,0,true,1.2f},false);owner.freeze=oldFreeze;
   p.active=false;++hits;
  }
 }
}
