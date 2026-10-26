package mario_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1223")]
   public dynamic class GetUpAttack_90 extends MovieClip
   {
      
      public var attackBox:MovieClip;
      
      public var hitBox:MovieClip;
      
      public var hitBox2:MovieClip;
      
      public var hitBox3:MovieClip;
      
      public var hitBox4:MovieClip;
      
      public var itemBox:MovieClip;
      
      public var self:MarioExt;
      
      public function GetUpAttack_90()
      {
         super();
         addFrameScript(0,this.frame1,3,this.frame4,7,this.frame8,11,this.frame12,13,this.frame14,24,this.frame25);
      }
      
      internal function frame1() : *
      {
         this.self = SSF2API.getCharacter(this) as MarioExt;
         if(SSF2API.isReady() && Boolean(this.self))
         {
            this.self.setIntangibility(true);
         }
      }
      
      internal function frame4() : *
      {
         this.self.attachEffect("global_dust_swirl");
      }
      
      internal function frame8() : *
      {
         this.self.playSound("brawl_swing_l");
      }
      
      internal function frame12() : *
      {
         this.self.playSound("brawl_swing_l");
      }
      
      internal function frame14() : *
      {
         this.self.setIntangibility(false);
      }
      
      internal function frame25() : *
      {
         this.self.endAttack();
      }
   }
}

