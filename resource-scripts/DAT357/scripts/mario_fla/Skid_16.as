package mario_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1103")]
   public dynamic class Skid_16 extends MovieClip
   {
      
      public var hitBox:MovieClip;
      
      public var hitBox2:MovieClip;
      
      public var hitBox3:MovieClip;
      
      public var itemBox:MovieClip;
      
      public var self:MarioExt;
      
      public function Skid_16()
      {
         super();
         addFrameScript(0,this.frame1,2,this.frame3,6,this.frame7);
      }
      
      internal function frame1() : *
      {
         this.self = SSF2API.getCharacter(this) as MarioExt;
         if(SSF2API.isReady() && Boolean(this.self))
         {
            this.self.playSound("mario_runstop");
         }
      }
      
      internal function frame3() : *
      {
         this.self.attachEffect("global_dust_light_rv",{"x":this.self.flipX(20)});
      }
      
      internal function frame7() : *
      {
         this.self.endAttack();
      }
   }
}

