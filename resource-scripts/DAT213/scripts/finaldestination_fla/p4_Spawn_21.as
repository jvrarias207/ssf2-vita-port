package finaldestination_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol41")]
   public dynamic class p4_Spawn_21 extends MovieClip
   {
      
      public var type:String;
      
      public function p4_Spawn_21()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      internal function frame1() : *
      {
         this.type = "p4_spawn";
         this.visible = false;
      }
   }
}

