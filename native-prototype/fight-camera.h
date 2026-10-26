#pragma once
// Vcam.followTargets/zoom, VcamSettings and CharacterData camera bounds.
// The aspect ratio is adapted to the unobscured Vita gameplay viewport.
struct FightCamera {
 static constexpr float VIEW_W=960,VIEW_H=396,ASPECT=VIEW_W/VIEW_H;
 float x=0,y=0,height=360;
 int shakeLevel=0;unsigned randomState=0x13579bdu;
 void reset(const Fighter&a,const Fighter&b){x=(a.x+b.x)/2;y=(a.y+b.y)/2-25;height=360;shakeLevel=0;randomState=0x13579bdu;}
 void shake(int strength){shakeLevel=std::clamp(strength,0,20);}
 float random(){randomState^=randomState<<13;randomState^=randomState>>17;randomState^=randomState<<5;return (randomState&0xffffff)/16777215.f;}
 void update(const Fighter&a,const Fighter&b){
  float left=CAM_RIGHT,right=CAM_LEFT,top=CAM_BOTTOM,bottom=CAM_TOP;
  for(const Fighter*f:{&a,&b}){
   float cx=f->x+f->facing*25.f;
   left=std::min(left,std::clamp(cx-75.f,CAM_LEFT,CAM_RIGHT));
   right=std::max(right,std::clamp(cx+75.f,CAM_LEFT,CAM_RIGHT));
   top=std::min(top,std::clamp(f->y-100.f,CAM_TOP,CAM_BOTTOM));
   bottom=std::max(bottom,std::clamp(f->y+50.f,CAM_TOP,CAM_BOTTOM));
  }
  float dx=((left+right)/2-x)/5.6f,dy=((top+bottom)/2-y)/5.6f;
  if(std::abs(dx)<1&&std::abs(dy)<1)dx=dy=0;
  x+=std::clamp(dx,-50.f,50.f);y+=std::clamp(dy,-50.f,50.f);
  float target=std::max({200.f,bottom-top,(right-left)/ASPECT});
  float change=(target-height)/8.f;
  if(std::abs(change)<1&&std::abs(change*ASPECT)<1)change=0;
  height=std::clamp(height+change,200.f,std::min(CAM_BOTTOM-CAM_TOP,(CAM_RIGHT-CAM_LEFT)/ASPECT));
  float halfW=height*ASPECT/2,halfH=height/2;
  if(shakeLevel>0){x+=std::round(random()*shakeLevel*2-shakeLevel);y+=std::round(random()*shakeLevel*2-shakeLevel);--shakeLevel;}
  x=std::clamp(x,CAM_LEFT+halfW,CAM_RIGHT-halfW);
  y=std::clamp(y,CAM_TOP+halfH,CAM_BOTTOM-halfH);
 }
 float scale()const{return VIEW_H/height;}
};
