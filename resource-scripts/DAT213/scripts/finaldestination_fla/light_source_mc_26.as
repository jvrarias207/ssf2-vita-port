package finaldestination_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol48")]
   public dynamic class light_source_mc_26 extends MovieClip
   {
      
      public var type:String;
      
      public function light_source_mc_26()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      internal function frame1() : *
      {
         this.type = "light_source";
         this.visible = false;
      }
   }
}

