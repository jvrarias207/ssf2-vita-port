package
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol346")]
   public dynamic class luigi_fs_windbottom extends MovieClip
   {
      
      public function luigi_fs_windbottom()
      {
         super();
         addFrameScript(43,this.frame44);
      }
      
      internal function frame44() : *
      {
         stop();
         if(parent != null)
         {
            parent.removeChild(this);
         }
      }
   }
}

