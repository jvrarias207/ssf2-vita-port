package luigi_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1295")]
   public dynamic class Win_13 extends MovieClip
   {
      
      public function Win_13()
      {
         super();
         addFrameScript(60,this.frame61,64,this.frame65,71,this.frame72,84,this.frame85);
      }
      
      internal function frame61() : *
      {
         SSF2API.playSound("grab_swing4");
      }
      
      internal function frame65() : *
      {
         SSF2API.playSound("luigi_footstep");
      }
      
      internal function frame72() : *
      {
         SSF2API.playSound("luigi_win");
      }
      
      internal function frame85() : *
      {
         this.gotoAndPlay("repeat");
      }
   }
}

