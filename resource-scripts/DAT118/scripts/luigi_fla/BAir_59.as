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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1343")]
   public dynamic class BAir_59 extends MovieClip
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
      
      public function BAir_59()
      {
         super();
         addFrameScript(0,this.frame1,2,this.frame3,3,this.frame4,5,this.frame6,12,this.frame13,18,this.frame19,19,this.frame20,24,this.frame25);
      }
      
      internal function frame1() : *
      {
         if(Boolean(parent) && Boolean(SSF2API.isReady()) && Boolean(this.self))
         {
            this.self.setLandingLag(false);
         }
         this.self = SSF2API.getCharacter(this) as LuigiExt;
         if(Boolean(parent) && Boolean(SSF2API.isReady()) && Boolean(this.self))
         {
            this.playsound = SSF2API.random();
            this.audio = this.self.getGlobalVariable("audio");
         }
      }
      
      internal function frame3() : *
      {
         this.self.setLandingLag(true);
      }
      
      internal function frame4() : *
      {
         this.self.attachEffect("global_dust_blast",{
            "x":this.self.flipX(-40),
            "y":-10,
            "parentLock":true
         });
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
         this.self.playSound("brawl_swing_s");
      }
      
      internal function frame6() : *
      {
         this.self.updateAttackBoxStats(1,{
            "damage":7,
            "hitStun":3,
            "selfHitStun":1,
            "effect_id":"effect_hit1"
         });
      }
      
      internal function frame13() : *
      {
         this.self.setLandingLag(false);
      }
      
      internal function frame19() : *
      {
         this.self.endAttack();
      }
      
      internal function frame20() : *
      {
         if(SSF2API.isReady())
         {
            SSF2API.getCamera().shake(2);
            this.self.setGlobalVariable("canStartRise",true);
            if(this.self.getMetalStatus())
            {
               this.self.playSound("metal_land_s");
            }
            else
            {
               this.self.playSound("luigi_landAttack");
            }
         }
      }
      
      internal function frame25() : *
      {
         this.self.endAttack();
      }
   }
}

