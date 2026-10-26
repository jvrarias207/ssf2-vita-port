package luigi_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1328")]
   public dynamic class USpecialAir_44 extends MovieClip
   {
      
      public var attackBox:MovieClip;
      
      public var hand:MovieClip;
      
      public var hitBox:MovieClip;
      
      public var hitBox2:MovieClip;
      
      public var hitBox3:MovieClip;
      
      public var hitBox4:MovieClip;
      
      public var hitBox5:MovieClip;
      
      public var itemBox:MovieClip;
      
      public var self:LuigiExt;
      
      public var controls:Object;
      
      public var facingRight:Boolean;
      
      public var speed:Number;
      
      public function USpecialAir_44()
      {
         super();
         addFrameScript(0,this.frame1,1,this.frame2,3,this.frame4,8,this.frame9,13,this.frame14,18,this.frame19);
      }
      
      public function moveIt() : void
      {
         this.self.setYSpeed(-1 * this.speed);
      }
      
      internal function frame1() : *
      {
         this.self = SSF2API.getCharacter(this) as LuigiExt;
         this.speed = 28;
      }
      
      internal function frame2() : *
      {
         this.self.setIntangibility(true);
      }
      
      internal function frame4() : *
      {
         this.self.createTimer(1,-1,this.moveIt);
         this.self.updateAttackBoxStats(1,{
            "burn":false,
            "damage":1,
            "kbConstant":0,
            "power":0,
            "hitStun":1,
            "selfHitStun":0,
            "camShake":3,
            "effectSound":"luigi_coin_sfx",
            "effect_id":"luigi_coin"
         });
         this.self.setIntangibility(false);
         this.self.playSound("luigi_uspec");
      }
      
      internal function frame9() : *
      {
         this.self.updateAttackStats({"air_ease":0});
         this.self.destroyTimer(this.moveIt);
         this.self.setYSpeed(0);
         this.self.setXSpeed(0);
      }
      
      internal function frame14() : *
      {
         this.self.updateAttackStats({
            "allowControl":true,
            "air_ease":-1,
            "xSpeedDecay":0,
            "xSpeedDecayAir":0
         });
      }
      
      internal function frame19() : *
      {
         if(this.self.isOnGround())
         {
            this.self.toHeavyLand();
         }
         else
         {
            this.self.setGlobalVariable("usedUpB",true);
            this.self.toHelpless();
         }
      }
   }
}

