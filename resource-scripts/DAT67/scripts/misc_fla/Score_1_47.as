package misc_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol521")]
   public dynamic class Score_1_47 extends MovieClip
   {
      
      public function Score_1_47()
      {
         super();
         addFrameScript(54,this.frame55);
      }
      
      internal function frame55() : *
      {
         stop();
         if(parent != null)
         {
            parent.removeChild(this);
         }
      }
   }
}

