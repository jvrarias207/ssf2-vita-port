package luigi_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1405")]
   public dynamic class Sleep_102 extends MovieClip
   {
      
      public var hitBox:MovieClip;
      
      public var hitBox2:MovieClip;
      
      public var hitBox3:MovieClip;
      
      public var hitBox4:MovieClip;
      
      public var itemBox:MovieClip;
      
      public var self:LuigiExt;
      
      public function Sleep_102()
      {
         super();
         addFrameScript(0,this.frame1,14,this.frame15,31,this.frame32,59,this.frame60,90,this.frame91,122,this.frame123);
      }
      
      internal function frame1() : *
      {
         this.self = SSF2API.getCharacter(this) as LuigiExt;
         if(Boolean(parent) && Boolean(SSF2API.isReady()) && Boolean(this.self))
         {
            this.self.playSound("fall_asleep");
         }
      }
      
      internal function frame15() : *
      {
         if(this.self.getMetalStatus())
         {
            this.self.playSound("metal_land_s");
         }
      }
      
      internal function frame32() : *
      {
         if(!this.self.getMetalStatus())
         {
            this.self.playSound("luigi_sleep",true);
         }
      }
      
      internal function frame60() : *
      {
         this.self.attachEffect("global_bubbles");
      }
      
      internal function frame91() : *
      {
         this.self.stancePlayFrame("again");
      }
      
      internal function frame123() : *
      {
         this.self.endAttack();
      }
   }
}

