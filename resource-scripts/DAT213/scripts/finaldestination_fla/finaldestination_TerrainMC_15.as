package finaldestination_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol27")]
   public dynamic class finaldestination_TerrainMC_15 extends MovieClip
   {
      
      public var type:String;
      
      public function finaldestination_TerrainMC_15()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      internal function frame1() : *
      {
         this.type = "terrain";
         this.visible = false;
      }
   }
}

