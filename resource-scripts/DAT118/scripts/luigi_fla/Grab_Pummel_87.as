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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1386")]
   public dynamic class Grab_Pummel_87 extends MovieClip
   {
      
      public var attackBox:MovieClip;
      
      public var grabBox:MovieClip;
      
      public var hitBox:MovieClip;
      
      public var hitBox2:MovieClip;
      
      public var hitBox3:MovieClip;
      
      public var hitBox4:MovieClip;
      
      public var hitBox5:MovieClip;
      
      public var hitBox6:MovieClip;
      
      public var touchBox:MovieClip;
      
      public var self:LuigiExt;
      
      public var xframe:String;
      
      public var curSpeed:*;
      
      public var xDecay:*;
      
      public var isMovingRight:*;
      
      public var target:*;
      
      public var grab:*;
      
      public var rand:int;
      
      public function Grab_Pummel_87()
      {
         super();
         addFrameScript(0,this.frame1,2,this.frame3,3,this.frame4,15,this.frame16,16,this.frame17,20,this.frame21,21,this.frame22,36,this.frame37,37,this.frame38,38,this.frame39,39,this.frame40,40,this.frame41,45,this.frame46,46,this.frame47,50,this.frame51);
      }
      
      public function xSpeedDecay() : void
      {
         if(this.self.getXSpeed() == 0 || this.isMovingRight != this.self.getXSpeed() > 0)
         {
            this.self.setXSpeed(0);
            this.self.destroyTimer(this.xSpeedDecay);
            return;
         }
         this.curSpeed -= this.xDecay;
         if(this.curSpeed > 0)
         {
            this.self.setXSpeed(this.isMovingRight ? Number(this.curSpeed) : -this.curSpeed);
         }
         else
         {
            this.self.setXSpeed(0);
            this.self.destroyTimer(this.xSpeedDecay);
         }
      }
      
      internal function frame1() : *
      {
         this.self = SSF2API.getCharacter(this) as LuigiExt;
         this.xframe = "grab";
         if(Boolean(this.self) && SSF2API.isReady())
         {
            this.self.setXSpeed(this.self.getXSpeed() * 0.4);
         }
      }
      
      internal function frame3() : *
      {
         SSF2API.playSound("grab_swing4");
      }
      
      internal function frame4() : *
      {
         this.self.attachEffect("global_dust_light",{"x":this.self.flipX(-8)});
      }
      
      internal function frame16() : *
      {
         this.self.endAttack();
      }
      
      internal function frame17() : *
      {
         this.xframe = "grab";
         this.curSpeed = this.self.getCharacterStat("max_xSpeed");
         this.xDecay = 0.4;
         this.isMovingRight = this.self.getXSpeed() > 0;
         this.self.createTimer(1,-1,this.xSpeedDecay);
      }
      
      internal function frame21() : *
      {
         SSF2API.playSound("grab_swing6");
      }
      
      internal function frame22() : *
      {
         this.self.attachEffect("global_dust_heavy",{
            "x":this.self.flipX(5),
            "y":3,
            "scaleX":-0.5,
            "scaleY":-0.5
         });
      }
      
      internal function frame37() : *
      {
         this.self.endAttack();
      }
      
      internal function frame38() : *
      {
         this.self.addEffectToList(this.self.attachEffect("grabbed_gfx",{
            "x":this.self.flipX(30),
            "y":-22,
            "scaleX":-0.4,
            "scaleY":-0.4
         }));
         this.self.clearEffectsOnStateChange();
      }
      
      internal function frame39() : *
      {
         this.xframe = "grab";
         this.target = null;
         this.grab = 0;
         this.rand = 0;
         if(this.self.isCPU() && this.self.getCPULevel() >= 1)
         {
            this.rand = 10 * SSF2API.random();
            if(this.rand >= 6)
            {
               this.self.stancePlayFrame("attack");
            }
         }
         if(this.self.isCPU() && this.self.getCPULevel() >= 7)
         {
            this.target = this.self.getGrabbedOpponents()[0];
            this.grab = SSF2API.random();
            if(this.target != null && this.target.getDamage() <= 50)
            {
               if(this.grab <= 0.7)
               {
                  this.self.importCPUControls([1024,1]);
               }
               else if(this.grab <= 0.75)
               {
                  this.self.importCPUControls([2048,1]);
               }
               else if(this.grab <= 0.85)
               {
                  this.self.importCPUControls([4609,1]);
               }
               else if(this.grab <= 0.95)
               {
                  this.self.importCPUControls([4385,1]);
               }
               else
               {
                  this.self.importCPUControls([4129,1]);
               }
            }
         }
         stop();
      }
      
      internal function frame40() : *
      {
         this.self.stancePlayFrame("grabbed2");
      }
      
      internal function frame41() : *
      {
         this.xframe = "attack";
      }
      
      internal function frame46() : *
      {
         this.self.updateAttackBoxStats(1,{"effect_id":"effect_lightHit"});
         this.self.refreshAttackID();
      }
      
      internal function frame47() : *
      {
         this.self.attachEffect("global_dust_light",{"x":this.self.flipX(-8)});
      }
      
      internal function frame51() : *
      {
         this.self.stancePlayFrame("grabbed2");
      }
   }
}

