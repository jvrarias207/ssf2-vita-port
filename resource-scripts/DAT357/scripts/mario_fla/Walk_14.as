package mario_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1101")]
   public dynamic class Walk_14 extends MovieClip
   {
      
      public var hitBox:MovieClip;
      
      public var hitBox2:MovieClip;
      
      public var hitBox3:MovieClip;
      
      public var itemBox:MovieClip;
      
      public var self:MarioExt;
      
      public function Walk_14()
      {
         super();
         addFrameScript(0,this.frame1,4,this.frame5,14,this.frame15);
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
      
      internal function frame5() : *
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
      
      internal function frame15() : *
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
   }
}

