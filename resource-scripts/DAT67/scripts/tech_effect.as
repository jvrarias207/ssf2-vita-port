package
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol169")]
   public dynamic class tech_effect extends MovieClip
   {
      
      public function tech_effect()
      {
         super();
         addFrameScript(10,this.frame11);
      }
      
      internal function frame11() : *
      {
         stop();
         if(root != null && parent != null)
         {
            parent.removeChild(this);
         }
      }
   }
}

