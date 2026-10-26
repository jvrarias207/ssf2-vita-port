package
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol503")]
   public dynamic class shield4_hit extends MovieClip
   {
      
      public function shield4_hit()
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

