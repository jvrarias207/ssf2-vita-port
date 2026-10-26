package
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol514")]
   public dynamic class scoreAnim2_mc extends MovieClip
   {
      
      public function scoreAnim2_mc()
      {
         super();
         addFrameScript(54,this.frame55);
      }
      
      internal function frame55() : *
      {
         stop();
         if(parent != null)
         {
            parent.removeChild(this);
         }
      }
   }
}

