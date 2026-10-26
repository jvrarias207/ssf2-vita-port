package
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol221")]
   public dynamic class mario_fireball extends MovieClip
   {
      
      public var stance:MovieClip;
      
      public function mario_fireball()
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

