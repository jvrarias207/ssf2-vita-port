package luigi_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1425")]
   public dynamic class Star_110 extends MovieClip
   {
      
      public var attackBox:MovieClip;
      
      public var self:LuigiExt;
      
      public function Star_110()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      internal function frame1() : *
      {
         this.self = SSF2API.getCharacter(this) as LuigiExt;
         if(Boolean(parent) && Boolean(SSF2API.isReady()) && Boolean(this.self))
         {
            this.self.setGlobalVariable("canStartRise",true);
         }
      }
   }
}

