package
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol398")]
   public dynamic class fireballexplosiong extends MovieClip
   {
      
      public function fireballexplosiong()
      {
         super();
         addFrameScript(11,this.frame12);
      }
      
      internal function frame12() : *
      {
         stop();
         parent.removeChild(this);
      }
   }
}

