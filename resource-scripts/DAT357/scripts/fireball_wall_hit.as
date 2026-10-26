package
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol126")]
   public dynamic class fireball_wall_hit extends MovieClip
   {
      
      public function fireball_wall_hit()
      {
         super();
         addFrameScript(7,this.frame8);
      }
      
      internal function frame8() : *
      {
         stop();
         parent.removeChild(this);
      }
   }
}

