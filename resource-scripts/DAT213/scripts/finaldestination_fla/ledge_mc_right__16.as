package finaldestination_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol29")]
   public dynamic class ledge_mc_right__16 extends MovieClip
   {
      
      public var type:String;
      
      public function ledge_mc_right__16()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      internal function frame1() : *
      {
         this.type = "r_ledge";
         this.visible = false;
      }
   }
}

