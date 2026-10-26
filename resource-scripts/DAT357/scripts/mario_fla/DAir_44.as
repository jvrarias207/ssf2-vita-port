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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1158")]
   public dynamic class DAir_44 extends MovieClip
   {
      
      public var attackBox:MovieClip;
      
      public var attackBox2:MovieClip;
      
      public var hitBox:MovieClip;
      
      public var hitBox2:MovieClip;
      
      public var hitBox3:MovieClip;
      
      public var hitBox4:MovieClip;
      
      public var hitBox5:MovieClip;
      
      public var itemBox:MovieClip;
      
      public var self:MarioExt;
      
      public var playsound:Number;
      
      public var audio:Number;
      
      public function DAir_44()
      {
         super();
         addFrameScript(0,this.frame1,2,this.frame3,5,this.frame6,6,this.frame7,7,this.frame8,8,this.frame9,9,this.frame10,10,this.frame11,11,this.frame12,12,this.frame13,16,this.frame17,19,this.frame20,20,this.frame21,26,this.frame27);
      }
      
      internal function frame1() : *
      {
         this.self = SSF2API.getCharacter(this) as MarioExt;
         if(Boolean(parent) && Boolean(SSF2API.isReady()) && Boolean(this.self))
         {
            this.playsound = SSF2API.random();
            this.audio = this.self.getGlobalVariable("audio");
            this.self.setLandingLag(false);
         }
      }
      
      internal function frame3() : *
      {
         this.self.setLandingLag(true);
      }
      
      internal function frame6() : *
      {
         this.self.playSound("mario_spin");
         this.self.attachEffect("global_dust_spiral",{
            "x":this.self.flipX(1),
            "y":-13,
            "scaleX":1.2,
            "scaleY":1.2,
            "rotation":this.self.flipX(-30),
            "parentLock":true
         });
      }
      
      internal function frame7() : *
      {
         this.self.refreshAttackID();
      }
      
      internal function frame8() : *
      {
         this.self.playSound("mario_spin");
      }
      
      internal function frame9() : *
      {
         this.self.refreshAttackID();
      }
      
      internal function frame10() : *
      {
         this.self.playSound("mario_spin");
      }
      
      internal function frame11() : *
      {
         this.self.refreshAttackID();
      }
      
      internal function frame12() : *
      {
         this.self.playSound("mario_spin");
      }
      
      internal function frame13() : *
      {
         this.self.refreshAttackID();
      }
      
      internal function frame17() : *
      {
         this.self.setLandingLag(false);
      }
      
      internal function frame20() : *
      {
         this.self.endAttack();
      }
      
      internal function frame21() : *
      {
         this.self.updateAttackBoxStats(1,{
            "weightKB":40,
            "damage":2
         });
         this.self.updateAttackStats({"refreshRate":50});
         this.self.refreshAttackID();
         this.self.setGlobalVariable("canStartRise",true);
         this.self.removeAllEffects();
         SSF2API.getCamera().shake(3);
         if(this.self.getMetalStatus())
         {
            this.self.playSound("metal_land_s");
         }
         else
         {
            this.self.playSound("mario_landLight");
         }
      }
      
      internal function frame27() : *
      {
         this.self.endAttack();
      }
   }
}

