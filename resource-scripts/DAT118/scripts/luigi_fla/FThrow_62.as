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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1346")]
   public dynamic class FThrow_62 extends MovieClip
   {
      
      public var attackBox:MovieClip;
      
      public var hitBox:MovieClip;
      
      public var hitBox2:MovieClip;
      
      public var hitBox3:MovieClip;
      
      public var hitBox4:MovieClip;
      
      public var itemBox:MovieClip;
      
      public var touchBox:MovieClip;
      
      public var self:LuigiExt;
      
      public var playsound:Number;
      
      public var audio:Number;
      
      public var xframe:String;
      
      public var enemy:Object;
      
      public function FThrow_62()
      {
         super();
         addFrameScript(0,this.frame1,1,this.frame2,4,this.frame5,6,this.frame7,7,this.frame8,8,this.frame9,9,this.frame10,11,this.frame12,12,this.frame13,13,this.frame14,14,this.frame15,20,this.frame21);
      }
      
      internal function frame1() : *
      {
         this.self = SSF2API.getCharacter(this) as LuigiExt;
         if(Boolean(parent) && Boolean(SSF2API.isReady()) && Boolean(this.self))
         {
            this.playsound = SSF2API.random();
            this.audio = this.self.getGlobalVariable("audio");
            this.xframe = null;
         }
         if(Boolean(parent) && Boolean(this.self) && SSF2API.isReady())
         {
            this.enemy = this.self.getGrabbedOpponent();
            this.self.bringBehind(this.enemy);
            if(!this.self.isFacingRight())
            {
               this.enemy.setRotation(-4);
            }
            else
            {
               this.enemy.setRotation(4);
            }
         }
      }
      
      internal function frame2() : *
      {
         this.self.playSound("throw_woosh");
         this.self.forceGrabbedHurtFrame("spin");
         if(!this.self.isFacingRight())
         {
            this.enemy.setRotation(-9);
         }
         else
         {
            this.enemy.setRotation(9);
         }
      }
      
      internal function frame5() : *
      {
         this.self.bringBehind(this.enemy);
         if(!this.self.isFacingRight())
         {
            this.enemy.setRotation(-11);
         }
         else
         {
            this.enemy.setRotation(11);
         }
      }
      
      internal function frame7() : *
      {
         this.enemy.flip();
         this.self.attachEffect("global_dust_swirl");
         if(!this.self.isFacingRight())
         {
            this.enemy.setRotation(-341);
         }
         else
         {
            this.enemy.setRotation(341);
         }
      }
      
      internal function frame8() : *
      {
         this.self.playSound("throw_woosh");
         this.self.bringInFront(this.enemy);
         if(!this.self.isFacingRight())
         {
            this.enemy.setRotation(-6);
         }
         else
         {
            this.enemy.setRotation(6);
         }
      }
      
      internal function frame9() : *
      {
         this.enemy.flip();
         this.self.bringBehind(this.enemy);
         if(!this.self.isFacingRight())
         {
            this.enemy.setRotation(-8);
         }
         else
         {
            this.enemy.setRotation(8);
         }
      }
      
      internal function frame10() : *
      {
         if(!this.self.isFacingRight())
         {
            this.enemy.setRotation(-11);
         }
         else
         {
            this.enemy.setRotation(11);
         }
      }
      
      internal function frame12() : *
      {
         this.enemy.flip();
         this.self.attachEffect("global_dust_swirl");
         if(!this.self.isFacingRight())
         {
            this.enemy.setRotation(-341);
         }
         else
         {
            this.enemy.setRotation(341);
         }
      }
      
      internal function frame13() : *
      {
         this.self.bringInFront(this.enemy);
         if(!this.self.isFacingRight())
         {
            this.enemy.setRotation(-6);
         }
         else
         {
            this.enemy.setRotation(6);
         }
      }
      
      internal function frame14() : *
      {
         this.enemy.flip();
         if(!this.self.isFacingRight())
         {
            this.enemy.setRotation(-8);
         }
         else
         {
            this.enemy.setRotation(8);
         }
      }
      
      internal function frame15() : *
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
         this.self.bringBehind(this.enemy);
         SSF2API.getCamera().shake(9);
         this.enemy.resetRotation();
      }
      
      internal function frame21() : *
      {
         this.self.endAttack();
      }
   }
}

