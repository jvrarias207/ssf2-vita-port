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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1342")]
   public dynamic class FAir_58 extends MovieClip
   {
      
      public var attackBox:MovieClip;
      
      public var hitBox:MovieClip;
      
      public var hitBox2:MovieClip;
      
      public var hitBox3:MovieClip;
      
      public var hitBox4:MovieClip;
      
      public var hitBox5:MovieClip;
      
      public var itemBox:MovieClip;
      
      public var self:LuigiExt;
      
      public var playsound:Number;
      
      public var audio:Number;
      
      public function FAir_58()
      {
         super();
         addFrameScript(0,this.frame1,1,this.frame2,4,this.frame5,10,this.frame11,15,this.frame16,16,this.frame17,23,this.frame24);
      }
      
      internal function frame1() : *
      {
         this.self = SSF2API.getCharacter(this) as LuigiExt;
         if(Boolean(parent) && Boolean(SSF2API.isReady()) && Boolean(this.self))
         {
            this.playsound = SSF2API.random();
            this.audio = this.self.getGlobalVariable("audio");
         }
         if(Boolean(parent) && Boolean(SSF2API.isReady()) && Boolean(this.self))
         {
            this.self.setLandingLag(false);
         }
      }
      
      internal function frame2() : *
      {
         this.self.setLandingLag(true);
      }
      
      internal function frame5() : *
      {
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
         this.self.setLandingLag(true);
      }
      
      internal function frame11() : *
      {
         this.self.setLandingLag(false);
      }
      
      internal function frame16() : *
      {
         this.self.endAttack();
      }
      
      internal function frame17() : *
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
      }
      
      internal function frame24() : *
      {
         this.self.endAttack();
      }
   }
}

