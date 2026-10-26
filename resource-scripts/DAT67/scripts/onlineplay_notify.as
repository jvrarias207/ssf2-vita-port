package
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol498")]
   public dynamic class onlineplay_notify extends MovieClip
   {
      
      public var txt_mc:MovieClip;
      
      public function onlineplay_notify()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      internal function frame1() : *
      {
         stop();
         this.mouseEnabled = false;
         this.mouseChildren = false;
      }
   }
}

