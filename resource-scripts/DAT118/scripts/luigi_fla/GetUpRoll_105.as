package luigi_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1408")]
   public dynamic class GetUpRoll_105 extends MovieClip
   {
      
      public var hitBox:MovieClip;
      
      public var hitBox2:MovieClip;
      
      public var hitBox3:MovieClip;
      
      public var hitBox4:MovieClip;
      
      public var itemBox:MovieClip;
      
      public var self:LuigiExt;
      
      public function GetUpRoll_105()
      {
         super();
         addFrameScript(0,this.frame1,11,this.frame12,17,this.frame18);
      }
      
      internal function frame1() : *
      {
         this.self = SSF2API.getCharacter(this) as LuigiExt;
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

