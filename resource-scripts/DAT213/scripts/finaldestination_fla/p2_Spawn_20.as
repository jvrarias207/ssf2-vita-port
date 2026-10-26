package finaldestination_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol39")]
   public dynamic class p2_Spawn_20 extends MovieClip
   {
      
      public var type:String;
      
      public function p2_Spawn_20()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      internal function frame1() : *
      {
         this.type = "p2_spawn";
         this.visible = false;
      }
   }
}

