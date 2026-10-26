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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1154")]
   public dynamic class NAir_40 extends MovieClip
   {
      
      public var attackBox:MovieClip;
      
      public var hitBox:MovieClip;
      
      public var hitBox2:MovieClip;
      
      public var hitBox3:MovieClip;
      
      public var hitBox4:MovieClip;
      
      public var hitBox5:MovieClip;
      
      public var itemBox:MovieClip;
      
      public var self:MarioExt;
      
      public function NAir_40()
      {
         super();
         addFrameScript(0,this.frame1,1,this.frame2,2,this.frame3,4,this.frame5,16,this.frame17,20,this.frame21,21,this.frame22,25,this.frame26);
      }
      
      internal function frame1() : *
      {
         this.self = SSF2API.getCharacter(this) as MarioExt;
         if(Boolean(this.self) && SSF2API.isReady())
         {
            this.self.setLandingLag(false);
         }
      }
      
      internal function frame2() : *
      {
         this.self.clearEffectsOnStateChange();
      }
      
      internal function frame3() : *
      {
         this.self.setLandingLag(true);
         this.self.playSound("brawl_swing_s");
         this.self.attachEffect("global_dust_blast",{
            "x":this.self.flipX(25),
            "y":-15,
            "parentLock":true
         });
      }
      
      internal function frame5() : *
      {
         this.self.updateAttackBoxStats(1,{
            "direction":55,
            "damage":8,
            "power":13,
            "hitStun":2,
            "selfHitStun":1,
            "effect_id":"effect_hit2",
            "effectSound":"brawl_kick_s"
         });
      }
      
      internal function frame17() : *
      {
         this.self.setLandingLag(false);
      }
      
      internal function frame21() : *
      {
         this.self.endAttack();
      }
      
      internal function frame22() : *
      {
         this.self.removeAllEffects();
         SSF2API.getCamera().shake(2);
         if(this.self.getMetalStatus())
         {
            this.self.playSound("metal_land_s");
         }
         else
         {
            this.self.playSound("mario_landLight");
         }
      }
      
      internal function frame26() : *
      {
         this.self.endAttack();
      }
   }
}

