package mario_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1210")]
   public dynamic class HangClimb_79 extends MovieClip
   {
      
      public var hitBox:MovieClip;
      
      public var hitBox2:MovieClip;
      
      public var hitBox3:MovieClip;
      
      public var itemBox:MovieClip;
      
      public var self:MarioExt;
      
      public function HangClimb_79()
      {
         super();
         addFrameScript(0,this.frame1,3,this.frame4,6,this.frame7,8,this.frame9,15,this.frame16,16,this.frame17);
      }
      
      internal function frame1() : *
      {
         this.self = SSF2API.getCharacter(this) as MarioExt;
         if(Boolean(parent) && Boolean(SSF2API.isReady()) && Boolean(this.self))
         {
            this.self.setIntangibility(true);
            this.self.playSound("mario_lift");
         }
      }
      
      internal function frame4() : *
      {
         this.self.playSound("mario_runstart");
      }
      
      internal function frame7() : *
      {
         this.self.setXSpeed(6,false);
      }
      
      internal function frame9() : *
      {
         if(this.self.getMetalStatus())
         {
            this.self.playSound("metal_land_m");
         }
         else
         {
            this.self.playSound("mario_landLight");
         }
      }
      
      internal function frame16() : *
      {
         this.self.setIntangibility(false);
      }
      
      internal function frame17() : *
      {
         this.self.endAttack();
      }
   }
}

