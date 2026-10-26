package mario_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1074")]
   public dynamic class Revival_9 extends MovieClip
   {
      
      public var self:MarioExt;
      
      public function Revival_9()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      internal function frame1() : *
      {
         this.self = SSF2API.getCharacter(this) as MarioExt;
         if(SSF2API.isReady())
         {
            this.self.setGlobalVariable("canStartRise",true);
            this.self.setIntangibility(false);
         }
      }
   }
}

