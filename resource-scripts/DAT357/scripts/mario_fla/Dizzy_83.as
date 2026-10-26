package mario_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1218")]
   public dynamic class Dizzy_83 extends MovieClip
   {
      
      public var dizzy_stars:MovieClip;
      
      public var hitBox:MovieClip;
      
      public var hitBox2:MovieClip;
      
      public var itemBox:MovieClip;
      
      public var self:MarioExt;
      
      public function Dizzy_83()
      {
         super();
         addFrameScript(0,this.frame1,37,this.frame38);
      }
      
      internal function frame1() : *
      {
         this.self = SSF2API.getCharacter(this) as MarioExt;
         if(Boolean(parent) && Boolean(SSF2API.isReady()) && Boolean(this.self))
         {
            this.self.setGlobalVariable("canStartRise",true);
            this.self.setGlobalVariable("jab",false);
            this.self.setGlobalVariable("jab2",false);
            if(!this.self.getMetalStatus())
            {
               this.self.playSound("mario_dizzy",true);
            }
         }
      }
      
      internal function frame38() : *
      {
         this.gotoAndStop("loop");
      }
   }
}

