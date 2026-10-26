package
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol423")]
   public dynamic class luigi_sSpec_charge extends MovieClip
   {
      
      public function luigi_sSpec_charge()
      {
         super();
         addFrameScript(6,this.frame7);
      }
      
      internal function frame7() : *
      {
         stop();
         parent.removeChild(this);
      }
   }
}

