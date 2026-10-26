package mario_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1211")]
   public dynamic class HangRoll_80 extends MovieClip
   {
      
      public var hitBox:MovieClip;
      
      public var hitBox2:MovieClip;
      
      public var hitBox3:MovieClip;
      
      public var hitBox4:MovieClip;
      
      public var itemBox:MovieClip;
      
      public var self:MarioExt;
      
      public function HangRoll_80()
      {
         super();
         addFrameScript(0,this.frame1,3,this.frame4,6,this.frame7,18,this.frame19,19,this.frame20,23,this.frame24,24,this.frame25);
      }
      
      internal function frame1() : *
      {
         this.self = SSF2API.getCharacter(this) as MarioExt;
         if(Boolean(parent) && Boolean(SSF2API.isReady()) && Boolean(this.self))
         {
            this.self.playSound("mario_lift");
         }
         if(Boolean(parent) && Boolean(SSF2API.isReady()) && Boolean(this.self))
         {
            this.self.setIntangibility(true);
         }
      }
      
      internal function frame4() : *
      {
         this.self.playSound("mario_runstart");
      }
      
      internal function frame7() : *
      {
      }
      
      internal function frame19() : *
      {
         this.self.setIntangibility(false);
      }
      
      internal function frame20() : *
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
      
      internal function frame24() : *
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
      
      internal function frame25() : *
      {
         this.self.endAttack();
      }
   }
}

