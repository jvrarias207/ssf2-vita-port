package
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol577")]
   public dynamic class darkening extends MovieClip
   {
      
      public var shouldStop:Boolean;
      
      public var finished:Boolean;
      
      public function darkening()
      {
         super();
         addFrameScript(0,this.frame1,39,this.frame40,79,this.frame80);
      }
      
      internal function frame1() : *
      {
         this.shouldStop = true;
         this.finished = false;
      }
      
      internal function frame40() : *
      {
         if(this.shouldStop)
         {
            stop();
            this.finished = true;
         }
      }
      
      internal function frame80() : *
      {
         parent.removeChild(this);
         stop();
      }
   }
}

