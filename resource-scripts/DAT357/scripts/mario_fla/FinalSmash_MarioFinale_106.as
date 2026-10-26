package mario_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1477")]
   public dynamic class FinalSmash_MarioFinale_106 extends MovieClip
   {
      
      public var itemBox:MovieClip;
      
      public var self:MarioExt;
      
      public var camera:*;
      
      public function FinalSmash_MarioFinale_106()
      {
         super();
         addFrameScript(0,this.frame1,1,this.frame2,29,this.frame30,68,this.frame69,69,this.frame70);
      }
      
      internal function frame1() : *
      {
         this.self = SSF2API.getCharacter(this) as MarioExt;
         if(SSF2API.isReady() && Boolean(this.self))
         {
            this.self.playVoiceSound(1);
            this.self.playSound("mario_fsready");
            this.self.camFocus(25);
            this.self.unnattachFromGround();
         }
      }
      
      internal function frame2() : *
      {
         this.camera = SSF2API.getCamera();
      }
      
      internal function frame30() : *
      {
         this.self.playSound("mario_finale");
         this.self.playVoiceSound(2);
         this.self.fireProjectile("mario_finale");
      }
      
      internal function frame69() : *
      {
         this.self.forceOnGround(5);
         if(!this.self.isOnGround())
         {
            this.self.updateAttackStats({"allowControl":true});
            this.self.resetJumps();
            this.self.toJump();
         }
      }
      
      internal function frame70() : *
      {
         this.self.endAttack();
      }
   }
}

