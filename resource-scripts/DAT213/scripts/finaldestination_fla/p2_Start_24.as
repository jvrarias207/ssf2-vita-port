package finaldestination_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol45")]
   public dynamic class p2_Start_24 extends MovieClip
   {
      
      public var type:String;
      
      public function p2_Start_24()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      internal function frame1() : *
      {
         this.type = "p2_start";
         this.visible = false;
      }
   }
}

