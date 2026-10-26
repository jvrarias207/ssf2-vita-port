package mario_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1102")]
   public dynamic class Turn_15 extends MovieClip
   {
      
      public var hitBox:MovieClip;
      
      public var hitBox2:MovieClip;
      
      public var hitBox3:MovieClip;
      
      public var itemBox:MovieClip;
      
      public var self:MarioExt;
      
      public function Turn_15()
      {
         super();
         addFrameScript(0,this.frame1,3,this.frame4,10,this.frame11,14,this.frame15,15,this.frame16,20,this.frame21,21,this.frame22,25,this.frame26,30,this.frame31);
      }
      
      internal function frame1() : *
      {
         this.self = SSF2API.getCharacter(this) as MarioExt;
         if(SSF2API.isReady())
         {
            this.self.setGlobalVariable("canStartRise",true);
            this.self.setGlobalVariable("jab",false);
            this.self.setGlobalVariable("jab2",false);
         }
      }
      
      internal function frame4() : *
      {
         if(this.self.getMetalStatus())
         {
            this.self.playSound("metal_step_m1");
         }
         else
         {
            this.self.playSound("mario_footstep");
         }
      }
      
      internal function frame11() : *
      {
         if(this.self.getMetalStatus())
         {
            this.self.playSound("metal_step_m2");
         }
         else
         {
            this.self.playSound("mario_footstep2");
         }
      }
      
      internal function frame15() : *
      {
         this.self.stancePlayFrame("run");
      }
      
      internal function frame16() : *
      {
         this.self.setGlobalVariable("canStartRise",true);
         this.self.setGlobalVariable("jab",false);
         this.self.setGlobalVariable("jab2",false);
         this.self.playSound("mario_runstart");
      }
      
      internal function frame21() : *
      {
         this.self.stancePlayFrame("run");
      }
      
      internal function frame22() : *
      {
         this.self.setGlobalVariable("canStartRise",true);
         this.self.setGlobalVariable("jab",false);
         this.self.setGlobalVariable("jab2",false);
      }
      
      internal function frame26() : *
      {
         this.self.attachEffect("global_dust_light_rv",{"x":this.self.flipX(20)});
         this.self.playSound("mario_runstop");
      }
      
      internal function frame31() : *
      {
         this.self.stancePlayFrame("run");
      }
   }
}

