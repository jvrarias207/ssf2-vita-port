package luigi_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1338")]
   public dynamic class DSpecial_54 extends MovieClip
   {
      
      public var attackBox:MovieClip;
      
      public var hitBox:MovieClip;
      
      public var hitBox2:MovieClip;
      
      public var hitBox3:MovieClip;
      
      public var hitBox4:MovieClip;
      
      public var itemBox:MovieClip;
      
      public var self:LuigiExt;
      
      public function DSpecial_54()
      {
         super();
         addFrameScript(0,this.frame1,3,this.frame4,5,this.frame6,6,this.frame7,8,this.frame9,9,this.frame10,11,this.frame12,12,this.frame13,14,this.frame15,15,this.frame16,18,this.frame19,21,this.frame22,23,this.frame24,40,this.frame41);
      }
      
      public function reenableForCPU(param1:* = null) : void
      {
         this.self.setAttackEnabled(true,"b_down_air");
         this.self.removeEventListener(SSF2Event.GROUND_TOUCH,this.reenableForCPU);
      }
      
      internal function frame1() : *
      {
         this.self = SSF2API.getCharacter(this) as LuigiExt;
      }
      
      internal function frame4() : *
      {
         this.self.addEffectToList(this.self.attachEffect("global_dust_spin",{
            "y":-28,
            "scaleX":0.55,
            "loop":2,
            "parentLock":true,
            "syncHitStun":true
         }));
         this.self.clearEffectsOnStateChange();
         this.self.playSound("luigi_dspecial");
         this.self.updateAttackStats({"allowControl":true});
      }
      
      internal function frame6() : *
      {
         this.self.playSound("luigi_dspecial");
      }
      
      internal function frame7() : *
      {
         this.self.playSound("luigi_dspecial2");
      }
      
      internal function frame9() : *
      {
         this.self.playSound("luigi_dspecial2");
      }
      
      internal function frame10() : *
      {
         this.self.playSound("luigi_dspecial3");
      }
      
      internal function frame12() : *
      {
         this.self.playSound("luigi_dspecial3");
      }
      
      internal function frame13() : *
      {
         this.self.playSound("luigi_dspecial4");
      }
      
      internal function frame15() : *
      {
         this.self.playSound("luigi_dspecial4");
      }
      
      internal function frame16() : *
      {
         this.self.playSound("luigi_dspecial5");
      }
      
      internal function frame19() : *
      {
         this.self.updateAttackBoxStats(1,{"damage":12});
         this.self.refreshAttackID();
         if(!this.self.isOnGround())
         {
            this.self.setYSpeed(-4);
         }
         this.self.removeAllEffects();
         this.self.updateAttackStats({"allowControl":false});
      }
      
      internal function frame22() : *
      {
         this.self.updateAttackStats({"air_ease":0});
         this.self.attachEffect("global_dust_blast",{
            "y":-20,
            "scaleX":2,
            "scaleY":2,
            "parentLock":true
         });
         this.self.playSound("luigi_dspecial6");
         this.self.playVoiceSound(1);
         this.self.updateAttackStats({"xSpeedCap":-1});
         this.self.setXSpeed(this.self.getXSpeed() * 0.2);
      }
      
      internal function frame24() : *
      {
         this.self.updateAttackStats({"air_ease":-1});
      }
      
      internal function frame41() : *
      {
         if(this.self.isCPU())
         {
            if(this.self.getCPUAction() == 3)
            {
               this.self.setAttackEnabled(false,"b_down_air");
               this.self.addEventListener(SSF2Event.GROUND_TOUCH,this.reenableForCPU,{"persistent":true});
            }
         }
         this.self.endAttack();
         this.self.updateAttackStats({"xSpeedCap":-1});
         this.self.setXSpeed(this.self.getXSpeed() * 0.2);
      }
   }
}

