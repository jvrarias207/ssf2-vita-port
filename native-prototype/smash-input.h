#pragma once

// Character.as: attack selection at 6930/6946/6966; timer at 15597–15604.
// One shared timer, advanced at 30 Hz, not once per rendered/controller frame.
struct SmashInputWindow {
 int age=0;
 void reset(){age=0;}
 bool allows(bool vertical)const{return age<(vertical?4:5);}
 void tick(bool directionHeld,bool attackHeld,bool specialHeld,bool landing,bool skidding){
  if(landing){age=99;return;}
  if(!directionHeld&&!attackHeld&&!specialHeld&&!skidding)age=0;
  else if(age<99)++age;
 }
};
