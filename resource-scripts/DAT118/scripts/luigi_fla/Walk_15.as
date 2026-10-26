package luigi_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1297")]
   public dynamic class Walk_15 extends MovieClip
   {
      
      public var hitBox:MovieClip;
      
      public var hitBox2:MovieClip;
      
      public var hitBox3:MovieClip;
      
      public var hitBox4:MovieClip;
      
      public var hitBox5:MovieClip;
      
      public var itemBox:MovieClip;
      
      public var self:LuigiExt;
      
      public function Walk_15()
      {
         super();
         addFrameScript(0,this.frame1,8,this.frame9,18,this.frame19);
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
      
      internal function frame9() : *
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
      
      internal function frame19() : *
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
   }
}

