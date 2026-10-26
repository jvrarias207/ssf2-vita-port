package mario_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol110")]
   public dynamic class ChargeSpark_27 extends MovieClip
   {
      
      public function ChargeSpark_27()
      {
         super();
         addFrameScript(4,this.frame5);
      }
      
      internal function frame5() : *
      {
         stop();
         parent.removeChild(this);
      }
   }
}

