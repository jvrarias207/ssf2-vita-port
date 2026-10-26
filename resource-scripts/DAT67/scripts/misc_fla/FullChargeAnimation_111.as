package misc_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol159")]
   public dynamic class FullChargeAnimation_111 extends MovieClip
   {
      
      public function FullChargeAnimation_111()
      {
         super();
         addFrameScript(1,this.frame2,10,this.frame11);
      }
      
      internal function frame2() : *
      {
         gotoAndPlay("off");
      }
      
      internal function frame11() : *
      {
         gotoAndPlay("on");
      }
   }
}

