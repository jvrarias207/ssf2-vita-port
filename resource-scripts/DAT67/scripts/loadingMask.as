package
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol491")]
   public dynamic class loadingMask extends MovieClip
   {
      
      public var masker:SimpleButton;
      
      public function loadingMask()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      internal function frame1() : *
      {
         this.masker.useHandCursor = false;
      }
   }
}

