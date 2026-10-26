package luigi_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1294")]
   public dynamic class Revival_10 extends MovieClip
   {
      
      public var self:LuigiExt;
      
      public function Revival_10()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      internal function frame1() : *
      {
         this.self = SSF2API.getCharacter(this) as LuigiExt;
         if(SSF2API.isReady())
         {
            this.self.setGlobalVariable("canStartRise",true);
         }
      }
   }
}

