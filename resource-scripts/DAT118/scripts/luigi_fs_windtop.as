package
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol193")]
   public dynamic class luigi_fs_windtop extends MovieClip
   {
      
      public function luigi_fs_windtop()
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

