package
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol416")]
   public dynamic class luigi_coin extends MovieClip
   {
      
      public function luigi_coin()
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

