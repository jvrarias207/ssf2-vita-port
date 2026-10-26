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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1327")]
   public dynamic class USpecial_43 extends MovieClip
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
      
      public var angle:Number;
      
      public var speed:Number;
      
      public var angleAlt:Number;
      
      public function USpecial_43()
      {
         super();
         addFrameScript(0,this.frame1,1,this.frame2,2,this.frame3,3,this.frame4,7,this.frame8,8,this.frame9,13,this.frame14,18,this.frame19);
      }
      
      public function moveIt() : void
      {
         this.self.setYSpeed(-1 * this.speed);
      }
      
      internal function frame1() : *
      {
         this.self = SSF2API.getCharacter(this) as LuigiExt;
         this.angle = Math.atan(26 / 18) * 180 / Math.PI;
         this.speed = 28;
         this.angleAlt = 5.5;
      }
      
      internal function frame2() : *
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
         this.self.setIntangibility(true);
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
         this.self.createTimer(1,-1,this.moveIt);
         this.self.unnattachFromGround();
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
         this.self.attachEffect("global_dust_heavy");
      }
      
      internal function frame8() : *
      {
         this.self.destroyTimer(this.moveIt);
      }
      
      internal function frame9() : *
      {
         this.self.updateAttackStats({"air_ease":0});
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

