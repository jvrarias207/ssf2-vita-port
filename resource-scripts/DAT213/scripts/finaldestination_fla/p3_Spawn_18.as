package finaldestination_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol35")]
   public dynamic class p3_Spawn_18 extends MovieClip
   {
      
      public var type:String;
      
      public function p3_Spawn_18()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      internal function frame1() : *
      {
         this.type = "p3_spawn";
         this.visible = false;
      }
   }
}

