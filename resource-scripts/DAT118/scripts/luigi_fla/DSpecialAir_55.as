package luigi_fla
{
   import adobe.utils.*;
   import flash.accessibility.*;
   import flash.desktop.*;
   import flash.display.*;
   import flash.errors.*;
   import flash.events.*;
   import flash.external.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.globalization.*;
   import flash.media.*;
   import flash.net.*;
   import flash.net.drm.*;
   import flash.printing.*;
   import flash.profiler.*;
   import flash.sampler.*;
   import flash.sensors.*;
   import flash.system.*;
   import flash.text.*;
   import flash.text.engine.*;
   import flash.text.ime.*;
   import flash.ui.*;
   import flash.utils.*;
   import flash.xml.*;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1339")]
   public dynamic class DSpecialAir_55 extends MovieClip
   {
      
      public var attackBox:MovieClip;
      
      public var hitBox:MovieClip;
      
      public var hitBox2:MovieClip;
      
      public var hitBox3:MovieClip;
      
      public var hitBox4:MovieClip;
      
      public var itemBox:MovieClip;
      
      public var self:LuigiExt;
      
      public var riseAmt:*;
      
      public var riseAmtMax:*;
      
      public var riseAmtIncr:*;
      
      public var pressed1:Boolean;
      
      public var pressed2:Boolean;
      
      public var controls:Object;
      
      public var landed:Boolean;
      
      public function DSpecialAir_55()
      {
         super();
         addFrameScript(0,this.frame1,2,this.frame3,3,this.frame4,5,this.frame6,6,this.frame7,8,this.frame9,9,this.frame10,11,this.frame12,12,this.frame13,14,this.frame15,15,this.frame16,18,this.frame19,21,this.frame22,25,this.frame26,31,this.frame32,39,this.frame40,48,this.frame49);
      }
      
      public function rise() : *
      {
         var _loc1_:* = undefined;
         if(this.self.getGlobalVariable("canStartRise"))
         {
            _loc1_ = this.self.getControls();
            if(!_loc1_.BUTTON1)
            {
               this.pressed1 = true;
            }
            if(this.pressed1 && Boolean(_loc1_.BUTTON1))
            {
               this.pressed2 = true;
               this.riseAmt += this.riseAmtIncr;
            }
         }
         else
         {
            this.pressed1 = false;
            this.pressed2 = false;
         }
         if(this.pressed2)
         {
            this.pressed1 = false;
            this.pressed2 = false;
            this.self.setYSpeed(this.riseAmt);
         }
      }
      
      public function move() : void
      {
         this.controls = this.self.getControls();
         if(Boolean(this.controls.LEFT) && !this.controls.RIGHT)
         {
            this.self.setXSpeed(-7);
         }
         else if(this.controls.RIGHT)
         {
            this.self.setXSpeed(7);
         }
      }
      
      public function nowGround(param1:* = null) : *
      {
         this.self.updateAttackStats({
            "allowControl":false,
            "canFallOff":false
         });
         this.self.createTimer(1,0,this.move);
         this.self.destroyTimer(this.rise);
         this.landed = true;
      }
      
      public function reenableForCPU(param1:* = null) : void
      {
         this.self.setAttackEnabled(true,"b_down_air");
         this.self.removeEventListener(SSF2Event.GROUND_TOUCH,this.reenableForCPU);
      }
      
      internal function frame1() : *
      {
         this.self = SSF2API.getCharacter(this) as LuigiExt;
         this.riseAmt = -6;
         this.riseAmtMax = -12;
         this.riseAmtIncr = -2;
         this.pressed1 = false;
         this.pressed2 = false;
         if(SSF2API.isReady() && Boolean(this.self))
         {
            if(!this.self.isOnGround() && this.self.getYSpeed() > 0)
            {
               this.self.setYSpeed(0);
            }
         }
      }
      
      internal function frame3() : *
      {
         this.self.createTimer(1,0,this.rise);
         this.controls = null;
         this.landed = false;
         this.self.addEventListener(SSF2Event.GROUND_TOUCH,this.nowGround);
      }
      
      internal function frame4() : *
      {
         this.self.addEffectToList(this.self.attachEffect("global_dust_spin",{
            "y":-28,
            "scaleX":0.55,
            "parentLock":true,
            "loop":2,
            "syncHitStun":true
         }));
         this.self.clearEffectsOnStateChange();
         this.self.playSound("luigi_dspecial");
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
         this.self.updateAttackBoxStats(1,{
            "damage":10,
            "direction":66
         });
         this.self.refreshAttackID();
         if(!this.self.isOnGround())
         {
            this.self.setYSpeed(-4);
         }
         this.self.removeAllEffects();
         this.self.destroyTimer(this.rise);
         if(!this.self.isOnGround())
         {
            this.self.setGlobalVariable("canStartRise",false);
         }
      }
      
      internal function frame22() : *
      {
         this.self.updateAttackStats({"air_ease":0});
         this.self.playSound("luigi_dspecial6");
         this.self.attachEffect("global_dust_blast",{
            "y":-20,
            "scaleX":2,
            "scaleY":2,
            "parentLock":true
         });
         this.self.playVoiceSound(1);
         this.self.destroyTimer(this.move);
      }
      
      internal function frame26() : *
      {
         this.self.refreshAttackID();
      }
      
      internal function frame32() : *
      {
         if(this.self.isCPU())
         {
            if(this.self.getCPUAction() == 3)
            {
               this.self.setAttackEnabled(false,"b_down_air");
               this.self.addEventListener(SSF2Event.GROUND_TOUCH,this.reenableForCPU,{"persistent":true});
            }
         }
         if(this.landed)
         {
            this.self.stancePlayFrame("continue");
         }
         this.self.updateAttackStats({"air_ease":-1});
      }
      
      internal function frame40() : *
      {
         this.self.endAttack();
         this.self.destroyTimer(this.move);
      }
      
      internal function frame49() : *
      {
         this.self.endAttack();
      }
   }
}

