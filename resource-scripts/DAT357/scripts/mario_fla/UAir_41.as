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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1155")]
   public dynamic class UAir_41 extends MovieClip
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
      
      public function UAir_41()
      {
         super();
         addFrameScript(0,this.frame1,1,this.frame2,2,this.frame3,7,this.frame8,8,this.frame9,15,this.frame16,16,this.frame17,20,this.frame21);
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
      
      internal function frame2() : *
      {
         this.self.setLandingLag(true);
         this.self.clearEffectsOnStateChange();
      }
      
      internal function frame3() : *
      {
         this.self.playSound("brawl_swing_s");
      }
      
      internal function frame8() : *
      {
      }
      
      internal function frame9() : *
      {
         this.self.setLandingLag(false);
      }
      
      internal function frame16() : *
      {
         this.self.endAttack();
      }
      
      internal function frame17() : *
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
      
      internal function frame21() : *
      {
         this.self.endAttack();
      }
   }
}

