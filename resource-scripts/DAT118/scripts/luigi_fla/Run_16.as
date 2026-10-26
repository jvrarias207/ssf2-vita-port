package luigi_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1298")]
   public dynamic class Run_16 extends MovieClip
   {
      
      public var hitBox:MovieClip;
      
      public var hitBox2:MovieClip;
      
      public var hitBox3:MovieClip;
      
      public var hitBox4:MovieClip;
      
      public var hitBox5:MovieClip;
      
      public var hitBox6:MovieClip;
      
      public var itemBox:MovieClip;
      
      public var self:LuigiExt;
      
      public function Run_16()
      {
         super();
         addFrameScript(0,this.frame1,3,this.frame4,9,this.frame10,12,this.frame13,13,this.frame14,20,this.frame21,21,this.frame22,32,this.frame33);
      }
      
      internal function frame1() : *
      {
         this.self = SSF2API.getCharacter(this) as LuigiExt;
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
            this.self.playSound("luigi_footstep");
         }
      }
      
      internal function frame10() : *
      {
         if(this.self.getMetalStatus())
         {
            this.self.playSound("metal_step_m2");
         }
         else
         {
            this.self.playSound("luigi_footstep2");
         }
      }
      
      internal function frame13() : *
      {
         this.self.stancePlayFrame("run");
      }
      
      internal function frame14() : *
      {
         this.self.setGlobalVariable("canStartRise",true);
         this.self.setGlobalVariable("jab",false);
         this.self.setGlobalVariable("jab2",false);
         this.self.playSound("luigi_dashstart");
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
         this.self.playSound("luigi_dashstop");
      }
      
      internal function frame33() : *
      {
         this.self.stancePlayFrame("run");
      }
   }
}

