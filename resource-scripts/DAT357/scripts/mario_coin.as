package
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol206")]
   public dynamic class mario_coin extends MovieClip
   {
      
      public function mario_coin()
      {
         super();
         addFrameScript(12,this.frame13);
      }
      
      internal function frame13() : *
      {
         stop();
         parent.removeChild(this);
      }
   }
}

