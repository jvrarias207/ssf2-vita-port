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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1344")]
   public dynamic class DAir_60 extends MovieClip
   {
      
      public var attackBox:MovieClip;
      
      public var attackBox2:MovieClip;
      
      public var hitBox:MovieClip;
      
      public var hitBox2:MovieClip;
      
      public var hitBox3:MovieClip;
      
      public var hitBox4:MovieClip;
      
      public var hitBox5:MovieClip;
      
      public var itemBox:MovieClip;
      
      public var self:LuigiExt;
      
      public var playsound:Number;
      
      public var audio:Number;
      
      public function DAir_60()
      {
         super();
         addFrameScript(0,this.frame1,1,this.frame2,4,this.frame5,5,this.frame6,9,this.frame10,12,this.frame13,13,this.frame14,16,this.frame17,17,this.frame18,23,this.frame24);
      }
      
      internal function frame1() : *
      {
         this.self = SSF2API.getCharacter(this) as LuigiExt;
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
      }
      
      internal function frame5() : *
      {
         this.self.addEffectToList(this.self.attachEffect("global_dust_spiral",{
            "x":this.self.flipX(6),
            "y":-15,
            "scaleX":1.2,
            "scaleY":1.2,
            "rotation":this.self.flipX(-25),
            "parentLock":true,
            "loop":1,
            "syncHitStun":true
         }));
         this.self.clearEffectsOnStateChange();
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
         this.self.playSound("luigi_spin");
         this.self.playSound("luigi_spinwind");
      }
      
      internal function frame6() : *
      {
         this.self.updateAttackBoxStats(2,{
            "hitStun":4,
            "selfHitStun":2,
            "direction":45
         });
      }
      
      internal function frame10() : *
      {
         this.self.playSound("luigi_spin");
         this.self.playSound("luigi_spinwind");
      }
      
      internal function frame13() : *
      {
         this.self.removeAllEffects();
      }
      
      internal function frame14() : *
      {
         this.self.setLandingLag(false);
      }
      
      internal function frame17() : *
      {
         this.self.endAttack();
      }
      
      internal function frame18() : *
      {
         if(SSF2API.isReady())
         {
            SSF2API.getCamera().shake(3);
            this.self.setGlobalVariable("canStartRise",true);
            if(this.self.getMetalStatus())
            {
               this.self.playSound("metal_land_m");
            }
            else
            {
               this.self.playSound("luigi_landAttack");
            }
         }
         this.self.removeAllEffects();
      }
      
      internal function frame24() : *
      {
         this.self.endAttack();
      }
   }
}

