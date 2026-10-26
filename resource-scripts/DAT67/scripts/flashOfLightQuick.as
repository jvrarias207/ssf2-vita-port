package
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol494")]
   public dynamic class flashOfLightQuick extends MovieClip
   {
      
      public function flashOfLightQuick()
      {
         super();
         addFrameScript(1,this.frame2);
      }
      
      internal function frame2() : *
      {
         if(parent)
         {
            parent.removeChild(this);
         }
         stop();
      }
   }
}

