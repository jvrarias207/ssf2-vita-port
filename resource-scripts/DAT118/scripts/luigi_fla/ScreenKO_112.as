package luigi_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1427")]
   public dynamic class ScreenKO_112 extends MovieClip
   {
      
      public var self:LuigiExt;
      
      public function ScreenKO_112()
      {
         super();
         addFrameScript(0,this.frame1,30,this.frame31);
      }
      
      internal function frame1() : *
      {
         this.self = SSF2API.getCharacter(this) as LuigiExt;
      }
      
      internal function frame31() : *
      {
         if(!this.self.getMetalStatus())
         {
            this.self.playSound("luigi_hurt2",true);
         }
      }
   }
}

