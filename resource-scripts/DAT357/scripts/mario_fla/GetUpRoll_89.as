package mario_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1222")]
   public dynamic class GetUpRoll_89 extends MovieClip
   {
      
      public var hitBox:MovieClip;
      
      public var hitBox2:MovieClip;
      
      public var itemBox:MovieClip;
      
      public var self:MarioExt;
      
      public function GetUpRoll_89()
      {
         super();
         addFrameScript(0,this.frame1,11,this.frame12,17,this.frame18);
      }
      
      internal function frame1() : *
      {
         this.self = SSF2API.getCharacter(this) as MarioExt;
         if(SSF2API.isReady() && Boolean(this.self))
         {
            this.self.setIntangibility(true);
         }
      }
      
      internal function frame12() : *
      {
         this.self.setIntangibility(false);
      }
      
      internal function frame18() : *
      {
         this.self.endAttack();
      }
   }
}

