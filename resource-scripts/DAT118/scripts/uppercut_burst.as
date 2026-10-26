package
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol419")]
   public dynamic class uppercut_burst extends MovieClip
   {
      
      public function uppercut_burst()
      {
         super();
         addFrameScript(10,this.frame11);
      }
      
      internal function frame11() : *
      {
         stop();
         parent.removeChild(this);
      }
   }
}

