package mario_fla
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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1114")]
   public dynamic class Jab_23 extends MovieClip
   {
      
      public var attackBox:MovieClip;
      
      public var attackBox2:MovieClip;
      
      public var hitBox:MovieClip;
      
      public var hitBox2:MovieClip;
      
      public var hitBox3:MovieClip;
      
      public var hitBox4:MovieClip;
      
      public var hitBox5:MovieClip;
      
      public var hitBox6:MovieClip;
      
      public var itemBox:MovieClip;
      
      public var self:MarioExt;
      
      public var playsound:Number;
      
      public var audio:Number;
      
      public var controls:Object;
      
      public var used:Boolean;
      
      public var used2:Boolean;
      
      public var time:Number;
      
      public var pressed1:Boolean;
      
      public var pressed2:Boolean;
      
      public var newStats:Object;
      
      public function Jab_23()
      {
         super();
         addFrameScript(0,this.frame1,1,this.frame2,2,this.frame3,3,this.frame4,4,this.frame5,5,this.frame6,7,this.frame8,8,this.frame9,11,this.frame12,12,this.frame13,13,this.frame14,14,this.frame15,17,this.frame18,18,this.frame19,20,this.frame21,26,this.frame27,29,this.frame30);
      }
      
      public function updateControls() : *
      {
         this.controls = this.self.getControls();
      }
      
      public function continueCombo() : *
      {
         if(this.used && this.time <= 12)
         {
            this.self.stancePlayFrame("hit2");
         }
         if(this.used2 && this.time <= 12)
         {
            this.self.stancePlayFrame("hit3");
         }
      }
      
      public function checkControls() : *
      {
         this.controls = this.self.getControls();
         if(!this.controls.BUTTON2)
         {
            this.pressed1 = true;
         }
         if(this.pressed1 && Boolean(this.controls.BUTTON2))
         {
            this.pressed2 = true;
         }
      }
      
      public function checkForGoToJab2() : *
      {
         if(this.pressed2)
         {
            this.pressed1 = false;
            this.pressed2 = false;
            this.self.stancePlayFrame("hit2");
         }
      }
      
      public function checkForGoToJab3() : *
      {
         if(this.pressed2)
         {
            this.pressed1 = false;
            this.pressed2 = false;
            this.self.stancePlayFrame("hit3");
         }
      }
      
      internal function frame1() : *
      {
         this.self = SSF2API.getCharacter(this) as MarioExt;
         if(Boolean(parent) && Boolean(SSF2API.isReady()) && Boolean(this.self))
         {
            this.playsound = SSF2API.random();
            this.audio = this.self.getGlobalVariable("audio");
         }
         if(SSF2API.isReady())
         {
            this.controls = this.self.getControls();
            this.used = this.self.getGlobalVariable("jab");
            this.used2 = this.self.getGlobalVariable("jab2");
            this.time = SSF2API.getElapsedFrames() - (this.self.getGlobalVariable("lastUsedJab") || -999);
            this.self.createTimer(1,39,this.updateControls,false);
            this.continueCombo();
         }
         this.pressed1 = false;
         this.pressed2 = false;
      }
      
      internal function frame2() : *
      {
         this.self.attachEffect("global_dust_blast",{
            "x":this.self.flipX(43),
            "y":-18,
            "parentLock":true
         });
         this.self.attachEffect("global_dust_light",{"x":this.self.flipX(-8)});
         this.self.playSound("brawl_swing_s");
         this.self.clearEffectsOnStateChange();
      }
      
      internal function frame3() : *
      {
         this.self.setGlobalVariable("jab",true);
         this.self.setGlobalVariable("jab2",false);
      }
      
      internal function frame4() : *
      {
         this.pressed1 = false;
         this.checkControls();
      }
      
      internal function frame5() : *
      {
         this.self.createTimer(1,6,this.checkControls,false);
      }
      
      internal function frame6() : *
      {
         this.self.createTimer(1,5,this.checkForGoToJab2,false);
      }
      
      internal function frame8() : *
      {
         this.self.endAttack();
      }
      
      internal function frame9() : *
      {
         this.newStats = {
            "direction":70,
            "damage":2
         };
         this.self.updateAttackBoxStats(1,this.newStats);
         this.self.refreshAttackID();
         this.self.setGlobalVariable("jab",false);
         this.self.setGlobalVariable("jab2",true);
         this.self.setGlobalVariable("lastUsedJab",SSF2API.getElapsedFrames());
         this.self.destroyTimer(this.checkControls);
         this.self.destroyTimer(this.checkForGoToJab2);
      }
      
      internal function frame12() : *
      {
         this.self.playSound("brawl_swing_m");
         this.self.attachEffect("global_dust_blast",{
            "x":this.self.flipX(43),
            "y":-15,
            "parentLock":true
         });
         this.self.attachEffect("global_dust_light",{"x":this.self.flipX(-8)});
      }
      
      internal function frame13() : *
      {
         this.pressed1 = false;
         this.checkControls();
      }
      
      internal function frame14() : *
      {
         this.self.createTimer(1,6,this.checkControls,false);
      }
      
      internal function frame15() : *
      {
         this.self.createTimer(1,6,this.checkForGoToJab3,false);
      }
      
      internal function frame18() : *
      {
         this.self.endAttack();
      }
      
      internal function frame19() : *
      {
         this.self.setGlobalVariable("jab",false);
         this.self.setGlobalVariable("jab2",false);
         this.newStats = {
            "direction":45,
            "power":40,
            "damage":5,
            "kbConstant":100,
            "weightKB":0
         };
         this.self.updateAttackBoxStats(1,this.newStats);
         this.self.updateAttackBoxStats(2,this.newStats);
         this.self.setGlobalVariable("lastUsedJab",SSF2API.getElapsedFrames());
         this.self.refreshAttackID();
         this.self.destroyTimer(this.checkControls);
         this.self.destroyTimer(this.checkForGoToJab3);
      }
      
      internal function frame21() : *
      {
         this.self.updateAttackBoxStats(1,{"effectSound":"brawl_kick_m"});
         this.self.updateAttackBoxStats(2,{"effectSound":"brawl_kick_m"});
         this.self.attachEffect("global_dust_heavy",{
            "x":this.self.flipX(5),
            "y":1,
            "scaleX":-0.5,
            "scaleY":-0.5
         });
         this.self.playSound("brawl_swing_l");
         this.self.setXSpeed(7,false);
         if(this.playsound > 0.2 && this.playsound <= 0.4 && this.audio != 1)
         {
            this.self.playVoiceSound(1);
            this.self.setGlobalVariable("audio",1);
         }
         if(this.playsound > 0.4 && this.playsound <= 0.6 && this.audio != 2)
         {
            this.self.playVoiceSound(2);
            this.self.setGlobalVariable("audio",2);
         }
         if(this.playsound > 0.6 && this.playsound <= 0.8 && this.audio != 3)
         {
            this.self.playVoiceSound(3);
            this.self.setGlobalVariable("audio",3);
         }
         if(this.playsound > 0.8 && this.playsound <= 1 && this.audio != 4)
         {
            this.self.playVoiceSound(4);
            this.self.setGlobalVariable("audio",4);
         }
      }
      
      internal function frame27() : *
      {
         if(this.self.getMetalStatus())
         {
            this.self.playSound("metal_land_s");
         }
         else
         {
            this.self.playSound("mario_landLight");
         }
      }
      
      internal function frame30() : *
      {
         this.self.endAttack();
      }
   }
}

