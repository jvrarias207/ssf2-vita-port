package
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol504")]
   public dynamic class shield3_hit extends MovieClip
   {
      
      public function shield3_hit()
      {
         super();
         addFrameScript(10,this.frame11);
      }
      
      internal function frame11() : *
      {
         stop();
         if(root != null && parent != null)
         {
            parent.removeChild(this);
         }
      }
   }
}

