package
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol436")]
   public dynamic class luigi_fireball_wrapper extends MovieClip
   {
      
      public var stance:luigi_fireball;
      
      public function luigi_fireball_wrapper()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      internal function frame1() : *
      {
         stop();
      }
   }
}

