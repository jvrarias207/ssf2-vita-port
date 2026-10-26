package
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol87")]
   public dynamic class finalsmash_cutin extends MovieClip
   {
      
      public var cutinbox:MovieClip;
      
      public function finalsmash_cutin()
      {
         super();
         addFrameScript(1,this.frame2,30,this.frame31);
      }
      
      internal function frame2() : *
      {
         SSF2API.playSound("fs_activation");
      }
      
      internal function frame31() : *
      {
         stop();
         if(parent != null)
         {
            parent.removeChild(this);
         }
      }
   }
}

