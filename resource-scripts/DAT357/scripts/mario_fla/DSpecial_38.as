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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1153")]
   public dynamic class DSpecial_38 extends MovieClip
   {
      
      public var attackBox:MovieClip;
      
      public var attackBox2:MovieClip;
      
      public var hitBox:MovieClip;
      
      public var hitBox2:MovieClip;
      
      public var hitBox3:MovieClip;
      
      public var hitBox4:MovieClip;
      
      public var itemBox:MovieClip;
      
      public var self:MarioExt;
      
      public var riseAmt:*;
      
      public var riseAmtMax:*;
      
      public var riseAmtIncr:*;
      
      public var pressed1:Boolean;
      
      public var pressed2:Boolean;
      
      public function DSpecial_38()
      {
         super();
         addFrameScript(0,this.frame1,2,this.frame3,4,this.frame5,5,this.frame6,7,this.frame8,8,this.frame9,10,this.frame11,11,this.frame12,13,this.frame14,14,this.frame15,16,this.frame17,18,this.frame19,19,this.frame20,20,this.frame21,21,this.frame22,22,this.frame23,25,this.frame26,32,this.frame33);
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
            this.self.updateAttackBoxStats(1,{"direction":110});
            this.self.setYSpeed(this.riseAmt);
         }
         else
         {
            this.self.updateAttackBoxStats(1,{"direction":145});
         }
      }
      
      public function reenableForCPU(param1:* = null) : void
      {
         this.self.setAttackEnabled(true,"b_down_air");
         this.self.removeEventListener(SSF2Event.GROUND_TOUCH,this.reenableForCPU);
      }
      
      internal function frame1() : *
      {
         this.self = SSF2API.getCharacter(this) as MarioExt;
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
         this.self.playSound("mario_dspec");
         this.self.refreshAttackID();
         this.self.updateAttackStats({"air_ease":-1});
         this.self.attachEffect("global_dust_spin",{
            "y":-28,
            "scaleX":0.55,
            "parentLock":true
         });
         if(this.self.isOnGround())
         {
            this.self.attachEffect("global_dust_swirl");
         }
         this.self.createTimer(1,0,this.rise);
      }
      
      internal function frame5() : *
      {
         this.self.refreshAttackID();
         this.self.playSound("mario_dspec");
      }
      
      internal function frame6() : *
      {
         this.self.refreshAttackID();
         this.self.playSound("mario_dspec2");
      }
      
      internal function frame8() : *
      {
         this.self.playSound("mario_dspec2");
      }
      
      internal function frame9() : *
      {
         this.self.playSound("mario_dspec3");
         this.self.refreshAttackID();
      }
      
      internal function frame11() : *
      {
         this.self.refreshAttackID();
         this.self.playSound("mario_dspec3");
         this.self.attachEffect("global_dust_spin",{
            "y":-28,
            "scaleX":0.55,
            "parentLock":true
         });
      }
      
      internal function frame12() : *
      {
         this.self.refreshAttackID();
         this.self.playSound("mario_dspec4");
      }
      
      internal function frame14() : *
      {
         this.self.refreshAttackID();
         this.self.playSound("mario_dspec4");
      }
      
      internal function frame15() : *
      {
         this.self.playSound("mario_dspec5");
         this.self.refreshAttackID();
      }
      
      internal function frame17() : *
      {
         this.self.refreshAttackID();
         this.self.destroyTimer(this.rise);
         if(!this.self.isOnGround())
         {
            this.self.setGlobalVariable("canStartRise",false);
         }
      }
      
      internal function frame19() : *
      {
         this.self.refreshAttackID();
         this.self.attachEffect("global_dust_swirl");
         if(!this.self.isOnGround())
         {
            this.self.setYSpeed(-4);
         }
      }
      
      internal function frame20() : *
      {
         this.self.playVoiceSound(1);
      }
      
      internal function frame21() : *
      {
         this.self.updateAttackBoxStats(1,{
            "damage":5,
            "direction":65,
            "power":75,
            "kbConstant":100,
            "weightKB":0
         });
         this.self.refreshAttackID();
      }
      
      internal function frame22() : *
      {
         this.self.playSound("mario_dspec6");
         if(this.self.isOnGround())
         {
            this.self.attachEffect("global_dust_swirl");
         }
      }
      
      internal function frame23() : *
      {
         this.self.updateAttackStats({"air_ease":0});
      }
      
      internal function frame26() : *
      {
         this.self.updateAttackStats({"air_ease":-1});
      }
      
      internal function frame33() : *
      {
         if(this.self.isCPU())
         {
            if(this.self.getCPUAction() == 3)
            {
               this.self.setAttackEnabled(false,"b_down_air");
               this.self.addEventListener(SSF2Event.GROUND_TOUCH,this.reenableForCPU,{"persistent":true});
            }
         }
         if(this.self.isOnGround())
         {
            this.self.setGlobalVariable("canStartRise",true);
         }
         this.self.endAttack();
      }
   }
}

