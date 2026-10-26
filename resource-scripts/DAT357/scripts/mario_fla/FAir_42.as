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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1156")]
   public dynamic class FAir_42 extends MovieClip
   {
      
      public var attackBox:MovieClip;
      
      public var attackBox2:MovieClip;
      
      public var attackBox3:MovieClip;
      
      public var hitBox:MovieClip;
      
      public var hitBox2:MovieClip;
      
      public var hitBox3:MovieClip;
      
      public var hitBox4:MovieClip;
      
      public var hitBox5:MovieClip;
      
      public var itemBox:MovieClip;
      
      public var self:MarioExt;
      
      public function FAir_42()
      {
         super();
         addFrameScript(0,this.frame1,1,this.frame2,7,this.frame8,9,this.frame10,24,this.frame25,29,this.frame30,30,this.frame31,37,this.frame38);
      }
      
      internal function frame1() : *
      {
         this.self = SSF2API.getCharacter(this) as MarioExt;
         if(Boolean(parent) && Boolean(SSF2API.isReady()) && Boolean(this.self))
         {
            this.self.setLandingLag(false);
         }
      }
      
      internal function frame2() : *
      {
         this.self.setLandingLag(true);
      }
      
      internal function frame8() : *
      {
         this.self.clearEffectsOnStateChange();
         this.self.playSound("brawl_swing_s");
         this.self.playVoiceSound(1);
      }
      
      internal function frame10() : *
      {
         this.self.updateAttackBoxStats(1,{
            "camShake":2,
            "direction":55,
            "kbConstant":100,
            "reversableAngle":false
         });
         this.self.updateAttackBoxStats(2,{
            "hitLag":-1.1,
            "camShake":2,
            "direction":55,
            "power":20,
            "kbConstant":100,
            "reversableAngle":true
         });
      }
      
      internal function frame25() : *
      {
         this.self.setLandingLag(false);
         this.self.updateAttackStats({
            "allowFullInterrupt":true,
            "doubleJumpCancelAttack":true
         });
      }
      
      internal function frame30() : *
      {
         this.self.endAttack();
      }
      
      internal function frame31() : *
      {
         this.self.setGlobalVariable("canStartRise",true);
         this.self.removeAllEffects();
         SSF2API.getCamera().shake(4);
         if(this.self.getMetalStatus())
         {
            this.self.playSound("metal_land_m");
         }
         else
         {
            this.self.playSound("mario_landHeavy");
         }
      }
      
      internal function frame38() : *
      {
         this.self.endAttack();
      }
   }
}

