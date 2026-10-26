package
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol430")]
   public dynamic class failure_mc extends MovieClip
   {
      
      public var stadiumMenuBar:MovieClip;
      
      public function failure_mc()
      {
         super();
         addFrameScript(59,this.frame60);
      }
      
      internal function frame60() : *
      {
         gotoAndStop("failcont");
      }
   }
}

