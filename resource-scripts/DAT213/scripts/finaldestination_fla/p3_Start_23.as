package finaldestination_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol44")]
   public dynamic class p3_Start_23 extends MovieClip
   {
      
      public var type:String;
      
      public function p3_Start_23()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      internal function frame1() : *
      {
         this.type = "p3_start";
         this.visible = false;
      }
   }
}

