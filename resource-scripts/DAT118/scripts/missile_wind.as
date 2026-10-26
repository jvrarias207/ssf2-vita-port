package
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol430")]
   public dynamic class missile_wind extends MovieClip
   {
      
      public function missile_wind()
      {
         super();
         addFrameScript(6,this.frame7);
      }
      
      internal function frame7() : *
      {
         stop();
         parent.removeChild(this);
      }
   }
}

