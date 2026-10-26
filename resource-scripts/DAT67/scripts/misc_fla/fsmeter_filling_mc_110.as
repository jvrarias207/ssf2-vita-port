package misc_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol138")]
   public dynamic class fsmeter_filling_mc_110 extends MovieClip
   {
      
      public function fsmeter_filling_mc_110()
      {
         super();
         addFrameScript(29,this.frame30,235,this.frame236,237,this.frame238);
      }
      
      internal function frame30() : *
      {
         gotoAndPlay("empty");
      }
      
      internal function frame236() : *
      {
         gotoAndPlay("fill");
      }
      
      internal function frame238() : *
      {
         gotoAndPlay("full");
      }
   }
}

