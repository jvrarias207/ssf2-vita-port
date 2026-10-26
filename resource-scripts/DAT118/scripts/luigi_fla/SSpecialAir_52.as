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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1337")]
   public dynamic class SSpecialAir_52 extends MovieClip
   {
      
      public var attackBox:MovieClip;
      
      public var hitBox:MovieClip;
      
      public var hitBox2:MovieClip;
      
      public var hitBox3:MovieClip;
      
      public var hitBox4:MovieClip;
      
      public var itemBox:MovieClip;
      
      public var self:LuigiExt;
      
      public var chargeFrames:Number;
      
      public var controls:Object;
      
      public var attackSFX:Number;
      
      public var voiceSFX:Number;
      
      public var chargeSFX:Number;
      
      public var xframe:*;
      
      public var loops:*;
      
      public var totalSpeed:*;
      
      public var startSpeed:*;
      
      public var dmg:*;
      
      public var dmgTot:*;
      
      public function SSpecialAir_52()
      {
         super();
         addFrameScript(0,this.frame1,8,this.frame9,14,this.frame15,15,this.frame16,18,this.frame19,19,this.frame20,23,this.frame24,24,this.frame25,28,this.frame29,29,this.frame30,49,this.frame50,50,this.frame51,55,this.frame56,64,this.frame65,70,this.frame71,71,this.frame72,103,this.frame104,111,this.frame112,117,this.frame118);
      }
      
      public function charge() : void
      {
         this.controls = this.self.getControls();
         if(!this.controls.BUTTON1)
         {
            this.self.destroyTimer(this.charge);
            this.self.stancePlayFrame("attack");
         }
         if(this.chargeFrames % 6 == 0)
         {
            this.chargeSFX = this.self.playSound("luigi_sspecial_charge");
            if(this.chargeFrames < 36)
            {
               this.self.attachEffect("luigi_sSpec_charge",{
                  "y":-10,
                  "parentLock":true,
                  "behind":true
               });
            }
         }
         ++this.chargeFrames;
      }
      
      public function stopOnHit(param1:* = null) : void
      {
         if(param1.data.receiver.getType() != "SSF2Projectile")
         {
            this.self.removeEventListener(SSF2Event.ATTACK_CONNECT,this.stopOnHit);
            this.self.removeEventListener(SSF2Event.ATTACK_CONNECT_SHIELD,this.stopOnHit);
            this.self.removeEventListener(SSF2Event.ATTACK_HIT_POWER_SHIELD,this.stopOnHit);
            if(this.self.hasEventListener(SSF2Event.HIT_WALL,this.wallCling))
            {
               this.self.removeEventListener(SSF2Event.HIT_WALL,this.wallCling);
            }
            SSF2API.stopSound(this.attackSFX);
            this.self.resetMovement();
            this.self.updateAttackStats({"air_ease":-1});
            this.self.stancePlayFrame("end");
         }
      }
      
      public function wallCling(param1:* = null) : void
      {
         if(Boolean(this.self.isFacingRight()) && Boolean(param1.data.right) || Boolean(!this.self.isFacingRight()) && Boolean(param1.data.left))
         {
            this.self.removeEventListener(SSF2Event.HIT_WALL,this.wallCling);
            this.self.playSound("luigi_sspecial_stuck");
            this.self.resetMovement();
            this.self.updateAttackStats({"air_ease":0});
            this.self.stancePlayFrame("wallcling");
         }
      }
      
      public function trailFX(param1:* = null) : void
      {
         this.self.attachEffect("dust",{
            "x":this.self.flipX(SSF2API.random() * 10 - 15),
            "y":SSF2API.random() * 10 - 10,
            "behind":true
         });
      }
      
      public function misfireFX(param1:* = null) : void
      {
         this.self.attachEffect("dust",{
            "x":this.self.flipX(SSF2API.random() * 10 - 15),
            "y":SSF2API.random() * 10 - 10,
            "behind":true
         });
      }
      
      internal function frame1() : *
      {
         this.self = SSF2API.getCharacter(this) as LuigiExt;
         this.chargeFrames = -1;
         this.controls = null;
         this.attackSFX = 0;
         this.voiceSFX = 1;
         this.chargeSFX = 2;
         this.xframe = "charging";
         if(SSF2API.isReady() && Boolean(this.self))
         {
            this.self.setXSpeed(this.self.getXSpeed() * 0.5);
         }
      }
      
      internal function frame9() : *
      {
         this.self.createTimer(1,0,this.charge);
      }
      
      internal function frame15() : *
      {
         if(this.chargeFrames >= 36)
         {
            this.self.stancePlayFrame("fullcharge");
         }
         else
         {
            this.self.stancePlayFrame("charging");
         }
      }
      
      internal function frame16() : *
      {
         this.xframe = "attack";
         this.self.updateAttackStats({"cancelWhenAirborne":false});
      }
      
      internal function frame19() : *
      {
         this.loops = 0;
         this.totalSpeed = 0;
         SSF2API.stopSound(this.chargeSFX);
         this.attackSFX = this.self.playSound("luigi_sspecial_release");
         if(this.self.isOnGround())
         {
            this.self.updateAttackStats({"air_ease":0});
         }
         this.self.unnattachFromGround();
         this.self.setYSpeed(-6.5);
         this.self.updateAttackStats({"xSpeedDecayAir":-0.3});
         this.self.setLandingLag(true);
         this.self.addEventListener(SSF2Event.ATTACK_CONNECT,this.stopOnHit);
         this.self.addEventListener(SSF2Event.ATTACK_CONNECT_SHIELD,this.stopOnHit);
         this.self.addEventListener(SSF2Event.ATTACK_HIT_POWER_SHIELD,this.stopOnHit);
         if(SSF2API.random() < 1 / 8)
         {
            this.self.updateAttackBoxStats(1,{
               "damage":25,
               "kbConstant":80
            });
            this.totalSpeed = 26.5;
            this.self.setXSpeed(this.totalSpeed,false);
            SSF2API.print("misfire!");
            this.self.addEventListener(SSF2Event.HIT_WALL,this.wallCling);
            this.self.attachEffect("uppercut_burst");
            this.self.stancePlayFrame("misfire");
            this.self.playSound("bombexplode");
            if(!this.self.getMetalStatus())
            {
               this.self.playSound("luigi_hurtBad2",true);
            }
            this.self.attachEffect("effect_explosion_luigi",{
               "scaleX":2,
               "scaleY":2
            });
            SSF2API.getCamera().shake(8);
         }
         else
         {
            if(this.chargeFrames >= 36)
            {
               this.chargeFrames = 35;
            }
            this.voiceSFX = this.self.playVoiceSound(1);
            this.startSpeed = 2.5;
            this.dmg = this.self.getAttackBoxStat(1,"damage");
            this.dmgTot = this.dmg + this.chargeFrames / 5;
            this.self.updateAttackBoxStats(1,{"damage":this.dmgTot});
            SSF2API.print("damage is " + this.dmg + " + " + this.chargeFrames / 5 + " = " + this.dmgTot);
            this.totalSpeed = (this.startSpeed + this.chargeFrames / 18) * 4;
            this.self.setXSpeed(this.totalSpeed,false);
            this.self.stancePlayFrame("loop");
         }
      }
      
      internal function frame20() : *
      {
         this.self.createTimer(2,0,this.trailFX);
      }
      
      internal function frame24() : *
      {
         if(this.loops <= 2)
         {
            ++this.loops;
            this.self.stancePlayFrame("loop");
         }
         else
         {
            this.self.destroyTimer(this.trailFX);
            this.self.stancePlayFrame("whiff");
         }
      }
      
      internal function frame25() : *
      {
         this.self.attachEffect("missile_wind",{
            "x":this.self.flipX(50),
            "y":-15
         });
         this.self.attachEffect("effect_explosion_luigi",{"behind":true});
         this.self.createTimer(1,0,this.misfireFX);
      }
      
      internal function frame29() : *
      {
         if(this.loops <= 2)
         {
            ++this.loops;
            this.self.stancePlayFrame("misfire");
         }
         else
         {
            this.self.destroyTimer(this.misfireFX);
            this.self.stancePlayFrame("end");
         }
      }
      
      internal function frame30() : *
      {
         this.self.destroyTimer(this.trailFX);
         this.self.destroyTimer(this.misfireFX);
         SSF2API.stopSound(this.attackSFX);
         SSF2API.getCamera().shake(4);
         if(this.self.getMetalStatus())
         {
            this.self.playSound("metal_land_m");
         }
         else
         {
            this.self.playSound("luigi_sspecial_land");
         }
         this.self.setGlobalVariable("canStartRise",true);
      }
      
      internal function frame50() : *
      {
         this.self.endAttack();
      }
      
      internal function frame51() : *
      {
         this.self.updateAttackStats({
            "air_ease":-1,
            "xSpeedDecayAir":0.95
         });
      }
      
      internal function frame56() : *
      {
         this.self.updateAttackStats({"air_ease":-1});
      }
      
      internal function frame65() : *
      {
         this.self.setLandingLag(false);
      }
      
      internal function frame71() : *
      {
         this.self.endAttack();
      }
      
      internal function frame72() : *
      {
         this.self.destroyTimer(this.misfireFX);
         SSF2API.stopSound(this.attackSFX);
         this.self.setGlobalVariable("canStartRise",true);
         SSF2API.getCamera().shake(8);
         this.self.resetMovement();
         this.self.resetKnockback();
      }
      
      internal function frame104() : *
      {
         this.self.playSound("luigi_sspecial_pluck");
         SSF2API.getCamera().shake(4);
      }
      
      internal function frame112() : *
      {
         this.self.updateAttackStats({"air_ease":-1});
      }
      
      internal function frame118() : *
      {
         this.self.endAttack();
      }
   }
}

