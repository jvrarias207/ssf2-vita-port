package mario_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1198")]
   public dynamic class Crouch_69 extends MovieClip
   {
      
      public var hitBox:MovieClip;
      
      public var hitBox2:MovieClip;
      
      public var hitBox3:MovieClip;
      
      public var itemBox:MovieClip;
      
      public var self:MarioExt;
      
      public function Crouch_69()
      {
         super();
         addFrameScript(0,this.frame1,3,this.frame4,4,this.frame5);
      }
      
      internal function frame1() : *
      {
         this.self = SSF2API.getCharacter(this) as MarioExt;
         if(Boolean(parent) && Boolean(SSF2API.isReady()) && Boolean(this.self))
         {
            this.self.setGlobalVariable("canStartRise",true);
            this.self.setGlobalVariable("jab",false);
            this.self.setGlobalVariable("jab2",false);
         }
      }
      
      internal function frame4() : *
      {
         this.self.setGlobalVariable("crouchdown",true);
      }
      
      internal function frame5() : *
      {
         gotoAndStop("loop");
      }
   }
}

