package
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol168")]
   public dynamic class mario_finale_projectile extends MovieClip
   {
      
      public var stance:firemario_finale;
      
      public function mario_finale_projectile()
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

