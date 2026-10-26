package luigi_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1396")]
   public dynamic class HangClimb_95 extends MovieClip
   {
      
      public var hitBox:MovieClip;
      
      public var hitBox2:MovieClip;
      
      public var hitBox3:MovieClip;
      
      public var itemBox:MovieClip;
      
      public var self:LuigiExt;
      
      public function HangClimb_95()
      {
         super();
         addFrameScript(0,this.frame1,2,this.frame3,9,this.frame10,13,this.frame14,15,this.frame16,16,this.frame17);
      }
      
      internal function frame1() : *
      {
         this.self = SSF2API.getCharacter(this) as LuigiExt;
         if(Boolean(parent) && Boolean(SSF2API.isReady()) && Boolean(this.self))
         {
            if(Boolean(parent) && Boolean(SSF2API.isReady()) && Boolean(this.self))
            {
               this.self.setIntangibility(true);
            }
         }
      }
      
      internal function frame3() : *
      {
         this.self.playSound("luigi_dashstart");
      }
      
      internal function frame10() : *
      {
         this.self.setXSpeed(3.5,false);
      }
      
      internal function frame14() : *
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

