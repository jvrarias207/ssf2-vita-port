package luigi_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1397")]
   public dynamic class HangRoll_96 extends MovieClip
   {
      
      public var hitBox:MovieClip;
      
      public var hitBox2:MovieClip;
      
      public var hitBox3:MovieClip;
      
      public var hitBox4:MovieClip;
      
      public var itemBox:MovieClip;
      
      public var self:LuigiExt;
      
      public function HangRoll_96()
      {
         super();
         addFrameScript(0,this.frame1,3,this.frame4,7,this.frame8,18,this.frame19,20,this.frame21,24,this.frame25);
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
      
      internal function frame4() : *
      {
         this.self.playSound("luigi_dashstart");
      }
      
      internal function frame8() : *
      {
         this.self.setXSpeed(15,false);
      }
      
      internal function frame19() : *
      {
         this.self.setIntangibility(false);
      }
      
      internal function frame21() : *
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
      
      internal function frame25() : *
      {
         this.self.endAttack();
      }
   }
}

