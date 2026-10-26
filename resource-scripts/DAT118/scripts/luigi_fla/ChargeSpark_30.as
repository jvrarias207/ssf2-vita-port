package luigi_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol356")]
   public dynamic class ChargeSpark_30 extends MovieClip
   {
      
      public function ChargeSpark_30()
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

