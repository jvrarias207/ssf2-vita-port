package luigi_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1305")]
   public dynamic class Skid_23 extends MovieClip
   {
      
      public var hitBox:MovieClip;
      
      public var hitBox2:MovieClip;
      
      public var hitBox3:MovieClip;
      
      public var hitBox4:MovieClip;
      
      public var hitBox5:MovieClip;
      
      public var itemBox:MovieClip;
      
      public var self:LuigiExt;
      
      public var currXSpeed:Number;
      
      public function Skid_23()
      {
         super();
         addFrameScript(0,this.frame1,1,this.frame2,2,this.frame3,9,this.frame10);
      }
      
      internal function frame1() : *
      {
         this.self = SSF2API.getCharacter(this) as LuigiExt;
         if(SSF2API.isReady() && Boolean(this.self))
         {
            this.self.playSound("luigi_dashstop");
         }
      }
      
      internal function frame2() : *
      {
         this.currXSpeed = 0;
      }
      
      internal function frame3() : *
      {
         SSF2API.print("" + this.self.getXSpeed());
         if(Math.abs(this.self.getXSpeed()) >= 1)
         {
            this.self.stancePlayFrame("loop");
         }
         else
         {
            this.self.stancePlayFrame("continue");
         }
      }
      
      internal function frame10() : *
      {
         this.self.endAttack();
      }
   }
}

