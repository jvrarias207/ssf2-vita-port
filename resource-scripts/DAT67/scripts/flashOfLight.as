package
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol602")]
   public dynamic class flashOfLight extends MovieClip
   {
      
      public function flashOfLight()
      {
         super();
         addFrameScript(20,this.frame21);
      }
      
      internal function frame21() : *
      {
         parent.removeChild(this);
         stop();
      }
   }
}

