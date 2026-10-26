package
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol57")]
   public dynamic class newrecord_mc extends MovieClip
   {
      
      public var stadiumMenuBar:MovieClip;
      
      public function newrecord_mc()
      {
         super();
         addFrameScript(98,this.frame99,99,this.frame100);
      }
      
      internal function frame99() : *
      {
         stop();
      }
      
      internal function frame100() : *
      {
         gotoAndStop(currentFrame - 1);
      }
   }
}

