package finaldestination_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol43")]
   public dynamic class p1_Start_22 extends MovieClip
   {
      
      public var type:String;
      
      public function p1_Start_22()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      internal function frame1() : *
      {
         this.type = "p1_start";
         this.visible = false;
      }
   }
}

