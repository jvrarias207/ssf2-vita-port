package
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol372")]
   public dynamic class green_fireball_wall_hit extends MovieClip
   {
      
      public function green_fireball_wall_hit()
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

