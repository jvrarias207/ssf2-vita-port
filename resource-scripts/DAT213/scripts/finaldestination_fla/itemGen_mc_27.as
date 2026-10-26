package finaldestination_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol50")]
   public dynamic class itemGen_mc_27 extends MovieClip
   {
      
      public var type:String;
      
      public function itemGen_mc_27()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      internal function frame1() : *
      {
         this.type = "itemGen";
         this.visible = false;
      }
   }
}

