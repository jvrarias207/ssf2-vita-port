package
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol523")]
   public dynamic class scoreAnim_mc extends MovieClip
   {
      
      public var score:MovieClip;
      
      public function scoreAnim_mc()
      {
         super();
         addFrameScript(55,this.frame56);
      }
      
      internal function frame56() : *
      {
         stop();
         if(parent != null)
         {
            parent.removeChild(this);
         }
      }
   }
}

