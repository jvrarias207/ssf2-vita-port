package mario_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1099")]
   public dynamic class Win_12 extends MovieClip
   {
      
      public var fire:*;
      
      public function Win_12()
      {
         super();
         addFrameScript(39,this.frame40,81,this.frame82,86,this.frame87,197,this.frame198);
      }
      
      internal function frame40() : *
      {
         SSF2API.playSound("mario_win2",true);
         this.fire = SSF2API.playSound("mario_finale");
      }
      
      internal function frame82() : *
      {
         SSF2API.playSound("mario_win2_pt2",true);
      }
      
      internal function frame87() : *
      {
         SSF2API.stopSound(this.fire);
      }
      
      internal function frame198() : *
      {
         this.gotoAndPlay("loop");
      }
   }
}

