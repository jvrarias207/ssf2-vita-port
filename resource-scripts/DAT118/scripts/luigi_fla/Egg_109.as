package luigi_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1422")]
   public dynamic class Egg_109 extends MovieClip
   {
      
      public var hitBox:MovieClip;
      
      public var self:LuigiExt;
      
      public function Egg_109()
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
            this.self.setGlobalVariable("jab",false);
            this.self.setGlobalVariable("jab2",false);
         }
      }
   }
}

