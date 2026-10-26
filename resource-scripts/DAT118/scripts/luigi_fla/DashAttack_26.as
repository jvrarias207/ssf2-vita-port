package luigi_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1312")]
   public dynamic class DashAttack_26 extends MovieClip
   {
      
      public var attackBox:MovieClip;
      
      public var hitBox:MovieClip;
      
      public var hitBox2:MovieClip;
      
      public var hitBox3:MovieClip;
      
      public var hitBox4:MovieClip;
      
      public var hitBox5:MovieClip;
      
      public var itemBox:MovieClip;
      
      public var self:LuigiExt;
      
      public function DashAttack_26()
      {
         super();
         addFrameScript(0,this.frame1,2,this.frame3,6,this.frame7,10,this.frame11,14,this.frame15,18,this.frame19,22,this.frame23,27,this.frame28,38,this.frame39);
      }
      
      public function move() : void
      {
         this.self.setXSpeed(6,false);
      }
      
      internal function frame1() : *
      {
         this.self = SSF2API.getCharacter(this) as LuigiExt;
         if(Boolean(parent) && Boolean(SSF2API.isReady()) && Boolean(this.self))
         {
            this.self.playSound("brawl_swing_m");
            this.self.setXSpeed(14,false);
         }
      }
      
      internal function frame3() : *
      {
         this.self.attachEffect("global_dust_light",{"x":this.self.flipX(-8)});
         this.self.playSound("luigi_spazpunch");
      }
      
      internal function frame7() : *
      {
         this.self.refreshAttackID();
         this.self.attachEffect("global_dust_light",{"x":this.self.flipX(-8)});
         this.self.createTimer(1,20,this.move);
         this.self.playVoiceSound(1);
         this.self.playSound("luigi_spazpunch");
      }
      
      internal function frame11() : *
      {
         this.self.refreshAttackID();
         this.self.attachEffect("global_dust_light",{"x":this.self.flipX(-8)});
         this.self.playSound("luigi_spazpunch");
      }
      
      internal function frame15() : *
      {
         this.self.refreshAttackID();
         this.self.attachEffect("global_dust_light",{"x":this.self.flipX(-8)});
         this.self.playSound("luigi_spazpunch");
      }
      
      internal function frame19() : *
      {
         this.self.refreshAttackID();
         this.self.attachEffect("global_dust_light",{"x":this.self.flipX(-8)});
         this.self.playSound("luigi_spazpunch");
      }
      
      internal function frame23() : *
      {
         this.self.refreshAttackID();
         this.self.attachEffect("global_dust_light",{"x":this.self.flipX(-8)});
         this.self.playSound("luigi_spazpunch");
      }
      
      internal function frame28() : *
      {
         this.self.refreshAttackID();
         this.self.updateAttackBoxStats(1,{
            "damage":5,
            "hitStun":4,
            "selfHitStun":4,
            "weightKB":0,
            "power":70,
            "direction":45,
            "kbConstant":100
         });
         this.self.setXSpeed(9,false);
         this.self.attachEffect("global_dust_heavy",{
            "x":this.self.flipX(5),
            "y":3,
            "scaleX":-0.5,
            "scaleY":-0.5
         });
         this.self.playSound("luigi_spazpunch");
      }
      
      internal function frame39() : *
      {
         this.self.endAttack();
      }
   }
}

