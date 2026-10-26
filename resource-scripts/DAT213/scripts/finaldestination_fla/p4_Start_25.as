package finaldestination_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol46")]
   public dynamic class p4_Start_25 extends MovieClip
   {
      
      public var type:String;
      
      public function p4_Start_25()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      internal function frame1() : *
      {
         this.type = "p4_start";
         this.visible = false;
      }
   }
}

