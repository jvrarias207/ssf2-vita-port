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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1123")]
   public dynamic class USpecial_34 extends MovieClip
   {
      
      public var attackBox:MovieClip;
      
      public var hand:MovieClip;
      
      public var hitBox:MovieClip;
      
      public var hitBox2:MovieClip;
      
      public var hitBox3:MovieClip;
      
      public var hitBox4:MovieClip;
      
      public var hitBox5:MovieClip;
      
      public var itemBox:MovieClip;
      
      public var self:MarioExt;
      
      public var controls:Object;
      
      public var facingRight:Boolean;
      
      public var angle:Number;
      
      public var speed:Number;
      
      public var angleAlt:Number;
      
      public function USpecial_34()
      {
         super();
         addFrameScript(0,this.frame1,1,this.frame2,2,this.frame3,3,this.frame4,4,this.frame5,5,this.frame6,6,this.frame7,7,this.frame8,8,this.frame9,9,this.frame10,10,this.frame11,11,this.frame12,15,this.frame16,21,this.frame22);
      }
      
      public function moveIt() : void
      {
         this.self.setXSpeed(this.speed * Math.cos(this.angle * Math.PI / 180),false);
         this.self.setYSpeed(-1 * this.speed * Math.sin(this.angle * Math.PI / 180));
      }
      
      internal function frame1() : *
      {
         if(Boolean(parent) && Boolean(SSF2API.isReady()) && Boolean(this.self))
         {
            this.self.addEventListener(SSF2Event.CHAR_ATTACK_COMPLETE,this.self.toHelpless);
         }
         this.self = SSF2API.getCharacter(this) as MarioExt;
         this.angle = Math.atan(26 / 18) * 180 / Math.PI;
         this.speed = 25;
         this.angleAlt = 5.5;
         if(Boolean(parent) && Boolean(SSF2API.isReady()) && Boolean(this.self))
         {
            this.controls = this.self.getControls();
            this.facingRight = this.self.isFacingRight();
            this.controls = this.self.getControls();
            if(Boolean(this.facingRight) && Boolean(this.controls.LEFT) || Boolean(!this.facingRight) && Boolean(this.controls.RIGHT))
            {
               this.angle += this.angleAlt;
            }
            if(Boolean(this.facingRight) && Boolean(this.controls.RIGHT) || Boolean(!this.facingRight) && Boolean(this.controls.LEFT))
            {
               this.angle -= this.angleAlt;
            }
         }
      }
      
      internal function frame2() : *
      {
         this.self.setIntangibility(true);
         this.controls = this.self.getControls();
         if(Boolean(this.facingRight) && Boolean(this.controls.LEFT) || Boolean(!this.facingRight) && Boolean(this.controls.RIGHT))
         {
            this.angle += this.angleAlt;
         }
         if(Boolean(this.facingRight) && Boolean(this.controls.RIGHT) || Boolean(!this.facingRight) && Boolean(this.controls.LEFT))
         {
            this.angle -= this.angleAlt;
         }
      }
      
      internal function frame3() : *
      {
         this.controls = this.self.getControls();
         if(Boolean(this.facingRight) && Boolean(this.controls.LEFT) || Boolean(!this.facingRight) && Boolean(this.controls.RIGHT))
         {
            this.angle += this.angleAlt;
         }
         if(Boolean(this.facingRight) && Boolean(this.controls.RIGHT) || Boolean(!this.facingRight) && Boolean(this.controls.LEFT))
         {
            this.angle -= this.angleAlt;
         }
      }
      
      internal function frame4() : *
      {
         this.self.setIntangibility(false);
         this.self.updateAttackBoxStats(1,{"damage":1});
         this.self.refreshAttackID();
         this.self.playSound("mario_uspec");
         this.self.attachEffect("global_dust_heavy",{
            "x":this.self.flipX(5),
            "y":1,
            "scaleX":-0.5,
            "scaleY":-0.5
         });
         this.controls = this.self.getControls();
         if(Boolean(this.facingRight) && Boolean(this.controls.LEFT) || Boolean(!this.facingRight) && Boolean(this.controls.RIGHT))
         {
            this.angle += this.angleAlt;
         }
         if(Boolean(this.facingRight) && Boolean(this.controls.RIGHT) || Boolean(!this.facingRight) && Boolean(this.controls.LEFT))
         {
            this.angle -= this.angleAlt;
         }
         if(this.angle < 45)
         {
            this.angle = 45;
         }
         this.self.updateAttackBoxStats(1,{"direction":this.angle});
         this.self.createTimer(1,-1,this.moveIt,{"pauseHitstun":true});
         this.self.addEventListener(SSF2Event.GROUND_TOUCH,this.self.toHeavyLand);
      }
      
      internal function frame5() : *
      {
         this.self.refreshAttackID();
      }
      
      internal function frame6() : *
      {
         this.self.refreshAttackID();
      }
      
      internal function frame7() : *
      {
         this.self.refreshAttackID();
      }
      
      internal function frame8() : *
      {
         this.self.refreshAttackID();
      }
      
      internal function frame9() : *
      {
         this.self.refreshAttackID();
      }
      
      internal function frame10() : *
      {
         this.self.destroyTimer(this.moveIt);
         this.self.refreshAttackID();
      }
      
      internal function frame11() : *
      {
         this.self.refreshAttackID();
      }
      
      internal function frame12() : *
      {
         this.self.updateAttackBoxStats(1,{
            "power":70,
            "kbConstant":100,
            "direction":60,
            "damage":3,
            "weightKB":0,
            "effectSound":"mario_uspecCoin2"
         });
         this.self.refreshAttackID();
         this.self.updateAttackStats({"air_ease":0});
         this.self.setYSpeed(0);
         this.self.setXSpeed(0);
      }
      
      internal function frame16() : *
      {
         this.self.updateAttackStats({
            "allowControl":true,
            "air_ease":-1,
            "xSpeedDecay":0,
            "xSpeedDecayAir":0
         });
      }
      
      internal function frame22() : *
      {
         this.self.toHelpless();
      }
   }
}

