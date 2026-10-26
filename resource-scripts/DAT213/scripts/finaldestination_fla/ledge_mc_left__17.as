package finaldestination_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol31")]
   public dynamic class ledge_mc_left__17 extends MovieClip
   {
      
      public var type:String;
      
      public function ledge_mc_left__17()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      internal function frame1() : *
      {
         this.type = "l_ledge";
         this.visible = false;
      }
   }
}

