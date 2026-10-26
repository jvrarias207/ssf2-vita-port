package mario_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1209")]
   public dynamic class Hang_78 extends MovieClip
   {
      
      public var hitBox:MovieClip;
      
      public var hitBox2:MovieClip;
      
      public var hitBox3:MovieClip;
      
      public var itemBox:MovieClip;
      
      public var self:MarioExt;
      
      public function Hang_78()
      {
         super();
         addFrameScript(0,this.frame1,1,this.frame2,6,this.frame7);
      }
      
      internal function frame1() : *
      {
         this.self = SSF2API.getCharacter(this) as MarioExt;
         if(Boolean(this.self) && SSF2API.isReady())
         {
            this.self.setGlobalVariable("canStartRise",true);
         }
      }
      
      internal function frame2() : *
      {
         this.self.attachEffect("ledgeGrab_gfx",{
            "x":this.self.flipX(0),
            "y":0,
            "scaleX":-0.4,
            "scaleY":-0.4
         });
      }
      
      internal function frame7() : *
      {
         this.self.stancePlayFrame("loop");
      }
   }
}

