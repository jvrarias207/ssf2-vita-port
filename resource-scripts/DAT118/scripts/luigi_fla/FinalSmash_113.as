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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1428")]
   public dynamic class FinalSmash_113 extends MovieClip
   {
      
      public var attackBox:MovieClip;
      
      public var attackBox2:MovieClip;
      
      public var attackBox3:MovieClip;
      
      public var camBox:MovieClip;
      
      public var grabBox:MovieClip;
      
      public var touchBox:MovieClip;
      
      public var self:*;
      
      public var tmpArr:Array;
      
      public var i:int;
      
      public var damageTracking:Object;
      
      public var camera:*;
      
      public var vroom_vroom:*;
      
      public var p:*;
      
      public function FinalSmash_113()
      {
         super();
         addFrameScript(0,this.frame1,1,this.frame2,3,this.frame4,10,this.frame11,18,this.frame19,27,this.frame28,73,this.frame74,74,this.frame75,79,this.frame80,81,this.frame82,83,this.frame84,85,this.frame86,87,this.frame88,89,this.frame90,91,this.frame92,93,this.frame94,95,this.frame96,96,this.frame97,98,this.frame99,100,this.frame101,102,this.frame103,104,this.frame105,129,this.frame130,130,this.frame131,137,this.frame138,147,this.frame148,157,this.frame158,177,this.frame178,178,this.frame179);
      }
      
      public function grabbedSound(param1:* = null) : *
      {
         this.self.playAttackSound(3);
      }
      
      public function onDamageInflict(param1:* = null) : *
      {
         if(Boolean(param1.data.receiver) && !param1.data.receiver.isDisposed())
         {
            if(!this.damageTracking[param1.data.receiver.getID()])
            {
               this.damageTracking[param1.data.receiver.getID()] = {
                  "player":param1.data.receiver,
                  "startFrame":this.currentFrame,
                  "damageDealt":0
               };
            }
         }
      }
      
      public function checkGrabbed() : *
      {
         var _loc1_:Array = this.self.getGrabbedOpponents();
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            if(Boolean(_loc1_[_loc2_]) && !_loc1_[_loc2_].isDisposed())
            {
               _loc1_[_loc2_].setVisibility(false);
            }
            _loc2_++;
         }
      }
      
      public function checkSucked() : *
      {
         var _loc1_:* = undefined;
         var _loc2_:int = 0;
         var _loc3_:Number = NaN;
         for(_loc1_ in this.damageTracking)
         {
            if(!this.damageTracking[_loc1_].player.isDisposed())
            {
               _loc2_ = 75 - this.damageTracking[_loc1_].startFrame;
               if(_loc2_ > 0)
               {
                  _loc3_ = 30 / _loc2_;
                  this.damageTracking[_loc1_].damageDealt += _loc3_;
                  if(this.damageTracking[_loc1_].player.getGameObjectStat("stamina") > 0)
                  {
                     this.damageTracking[_loc1_].player.setDamage(this.damageTracking[_loc1_].player.getDamage() - _loc3_);
                  }
                  else
                  {
                     this.damageTracking[_loc1_].player.setDamage(this.damageTracking[_loc1_].player.getDamage() + _loc3_);
                  }
               }
            }
         }
      }
      
      internal function frame1() : *
      {
         this.self = SSF2API.getCharacter(this);
         this.damageTracking = {};
         if(Boolean(parent) && Boolean(SSF2API.isReady()) && Boolean(this.self))
         {
            this.self.camFocus(25);
            this.self.unnattachFromGround();
         }
      }
      
      internal function frame2() : *
      {
         this.camera = SSF2API.getCamera();
         this.camera.killDarkener(true);
      }
      
      internal function frame4() : *
      {
         this.self.playAttackSound(1);
      }
      
      internal function frame11() : *
      {
         this.self.attachEffect("effect_land");
         SSF2API.getCamera().shake(3);
      }
      
      internal function frame19() : *
      {
         this.vroom_vroom = this.self.playAttackSound(2);
         this.self.addEventListener(SSF2Event.CHAR_GRAB,this.grabbedSound);
         this.self.addEventListener(SSF2Event.ATTACK_HIT,this.onDamageInflict);
         this.self.createTimer(1,-1,this.checkGrabbed);
         this.self.createTimer(1,-1,this.checkSucked);
      }
      
      internal function frame28() : *
      {
         this.self.pushEffectBehind(this.self.attachEffect("luigi_fs_windbottom",{
            "scaleX":1.15,
            "scaleY":1.15
         }));
         this.self.attachEffect("luigi_fs_windtop",{
            "scaleX":1.15,
            "scaleY":1.15
         });
      }
      
      internal function frame74() : *
      {
         SSF2API.stopSound(this.vroom_vroom);
         this.self.removeEventListener(SSF2Event.CHAR_GRAB,this.grabbedSound);
         this.self.removeEventListener(SSF2Event.ATTACK_HIT,this.onDamageInflict);
         this.self.destroyTimer(this.checkSucked);
         if(!this.self.getGrabbedOpponents()[0])
         {
            this.self.stancePlayFrame("trash");
         }
      }
      
      internal function frame75() : *
      {
         for(this.p in this.damageTracking)
         {
            if(!this.damageTracking[this.p].player.isDisposed() && this.damageTracking[this.p].damageDealt <= 29)
            {
               if(this.damageTracking[this.p].player.getGameObjectStat("stamina") > 0)
               {
                  this.damageTracking[this.p].player.setDamage(this.damageTracking[this.p].player.getDamage() - (30 - this.damageTracking[this.p].damageDealt));
               }
               else
               {
                  this.damageTracking[this.p].player.setDamage(this.damageTracking[this.p].player.getDamage() + (30 - this.damageTracking[this.p].damageDealt));
               }
            }
         }
         this.self.updateAttackBoxStats(1,{
            "damage":10,
            "hitLag":-1,
            "hasEffect":true,
            "direction":75,
            "power":80,
            "kbConstant":150,
            "bypassNonGrabbed":true
         });
         this.self.playAttackSound(4);
      }
      
      internal function frame80() : *
      {
         SSF2API.getCamera().shake(1);
      }
      
      internal function frame82() : *
      {
         SSF2API.getCamera().shake(2);
      }
      
      internal function frame84() : *
      {
         SSF2API.getCamera().shake(4);
      }
      
      internal function frame86() : *
      {
         SSF2API.getCamera().shake(6);
      }
      
      internal function frame88() : *
      {
         SSF2API.getCamera().shake(7);
      }
      
      internal function frame90() : *
      {
         SSF2API.getCamera().shake(8);
      }
      
      internal function frame92() : *
      {
         SSF2API.getCamera().shake(9);
         this.self.playAttackSound(5);
      }
      
      internal function frame94() : *
      {
         SSF2API.getCamera().shake(10);
      }
      
      internal function frame96() : *
      {
         this.self.attachEffect("global_dust_cloud");
         this.self.refreshAttackID();
      }
      
      internal function frame97() : *
      {
         this.tmpArr = this.self.getGrabbedOpponents();
         this.i = 0;
         while(this.i < this.tmpArr.length)
         {
            if(Boolean(this.tmpArr[this.i]) && !this.tmpArr[this.i].isDisposed())
            {
               this.tmpArr[this.i].setVisibility(true);
            }
            ++this.i;
         }
         this.self.attachEffect("luigi_fs_fire",{
            "scaleX":1.15,
            "scaleY":1.15
         });
         this.self.attachEffect("global_dust_blast",{
            "x":this.self.flipX(20),
            "y":-27
         });
         this.self.attachEffect("ground_bounce");
         SSF2API.getCamera().shake(20);
      }
      
      internal function frame99() : *
      {
         SSF2API.getCamera().shake(16);
      }
      
      internal function frame101() : *
      {
         SSF2API.getCamera().shake(10);
      }
      
      internal function frame103() : *
      {
         SSF2API.getCamera().shake(5);
      }
      
      internal function frame105() : *
      {
         SSF2API.getCamera().shake(2);
      }
      
      internal function frame130() : *
      {
         this.self.forceOnGround(5);
         if(!this.self.isOnGround())
         {
            this.self.updateAttackStats({"allowControl":true});
            this.self.resetJumps();
            this.self.toJump();
         }
      }
      
      internal function frame131() : *
      {
         this.self.endAttack();
      }
      
      internal function frame138() : *
      {
         this.self.playAttackSound(6);
      }
      
      internal function frame148() : *
      {
         this.self.playAttackSound(7);
      }
      
      internal function frame158() : *
      {
         this.self.attachEffect("global_dust_cloud");
         this.self.playAttackSound(8);
         SSF2API.getCamera().shake(4);
      }
      
      internal function frame178() : *
      {
         this.self.forceOnGround(5);
         if(!this.self.isOnGround())
         {
            this.self.updateAttackStats({"allowControl":true});
            this.self.resetJumps();
            this.self.toJump();
         }
      }
      
      internal function frame179() : *
      {
         this.self.endAttack();
      }
   }
}

