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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1347")]
   public dynamic class DThrow_63 extends MovieClip
   {
      
      public var attackBox:MovieClip;
      
      public var attackBox2:MovieClip;
      
      public var hitBox:MovieClip;
      
      public var hitBox2:MovieClip;
      
      public var hitBox3:MovieClip;
      
      public var hitBox4:MovieClip;
      
      public var hitBox5:MovieClip;
      
      public var itemBox:MovieClip;
      
      public var touchBox:MovieClip;
      
      public var self:LuigiExt;
      
      public var playsound:Number;
      
      public var audio:Number;
      
      public var enemy:Object;
      
      public function DThrow_63()
      {
         super();
         addFrameScript(0,this.frame1,1,this.frame2,2,this.frame3,10,this.frame11,12,this.frame13,14,this.frame15,21,this.frame22);
      }
      
      internal function frame1() : *
      {
         this.self = SSF2API.getCharacter(this) as LuigiExt;
         if(Boolean(parent) && Boolean(SSF2API.isReady()) && Boolean(this.self))
         {
            this.playsound = SSF2API.random();
            this.audio = this.self.getGlobalVariable("audio");
            this.enemy = this.self.getGrabbedOpponents()[0];
            this.self.bringBehind(this.enemy);
         }
      }
      
      internal function frame2() : *
      {
         this.self.playSound("throw_woosh");
      }
      
      internal function frame3() : *
      {
         this.self.forceGrabbedHurtFrame("faint");
      }
      
      internal function frame11() : *
      {
         this.self.bringInFront(this.enemy);
      }
      
      internal function frame13() : *
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
         this.self.forceGrabbedHurtFrame("downed");
      }
      
      internal function frame15() : *
      {
         this.self.attachEffect("global_dust_cloud");
         SSF2API.getCamera().shake(9);
      }
      
      internal function frame22() : *
      {
         this.self.endAttack();
      }
   }
}

