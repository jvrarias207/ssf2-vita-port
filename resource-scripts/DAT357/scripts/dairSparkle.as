package
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol216")]
   public dynamic class dairSparkle extends MovieClip
   {
      
      public function dairSparkle()
      {
         super();
         addFrameScript(5,this.frame6);
      }
      
      internal function frame6() : *
      {
         stop();
         if(parent != null)
         {
            parent.removeChild(this);
         }
      }
   }
}

