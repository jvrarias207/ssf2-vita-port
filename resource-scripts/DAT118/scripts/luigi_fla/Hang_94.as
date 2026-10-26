package luigi_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1395")]
   public dynamic class Hang_94 extends MovieClip
   {
      
      public var hitBox:MovieClip;
      
      public var hitBox2:MovieClip;
      
      public var hitBox3:MovieClip;
      
      public var itemBox:MovieClip;
      
      public var self:LuigiExt;
      
      public function Hang_94()
      {
         super();
         addFrameScript(0,this.frame1,2,this.frame3,7,this.frame8);
      }
      
      internal function frame1() : *
      {
         this.self = SSF2API.getCharacter(this) as LuigiExt;
         if(Boolean(this.self) && SSF2API.isReady())
         {
            this.self.setGlobalVariable("canStartRise",true);
         }
      }
      
      internal function frame3() : *
      {
         this.self.attachEffect("ledgeGrab_gfx",{
            "x":this.self.flipX(0),
            "y":0,
            "scaleX":-0.4,
            "scaleY":-0.4
         });
      }
      
      internal function frame8() : *
      {
         this.self.stancePlayFrame("loop");
      }
   }
}

