package finaldestination_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol37")]
   public dynamic class p1_Spawn_19 extends MovieClip
   {
      
      public var type:String;
      
      public function p1_Spawn_19()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      internal function frame1() : *
      {
         this.type = "p1_spawn";
         this.visible = false;
      }
   }
}

