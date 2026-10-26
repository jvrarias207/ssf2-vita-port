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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1139")]
   public dynamic class SSpecial_36 extends MovieClip
   {
      
      public var attackBox:MovieClip;
      
      public var hand:MovieClip;
      
      public var hitBox:MovieClip;
      
      public var hitBox2:MovieClip;
      
      public var hitBox3:MovieClip;
      
      public var hitBox4:MovieClip;
      
      public var itemBox:MovieClip;
      
      public var reverseBox:MovieClip;
      
      public var self:MarioExt;
      
      public var gliding:Boolean;
      
      public var curFrame:int;
      
      public function SSpecial_36()
      {
         super();
         addFrameScript(0,this.frame1,2,this.frame3,5,this.frame6,18,this.frame19);
      }
      
      public function glideAway(param1:* = null) : *
      {
         this.self.removeEventListener(SSF2Event.GROUND_LEAVE,this.glideAway);
         this.self.setXSpeed(9,false);
         SSF2API.print("gliding");
         this.self.updateAttackStats({
            "air_ease":0,
            "xSpeedDecayAir":-0.4,
            "xSpeedDecay":-0.2,
            "allowControl":true
         });
         this.gliding = true;
      }
      
      public function reflected(param1:* = null) : *
      {
         this.self.playSound("reflect_sfx");
         SSF2API.attachEffect("reflect_effect",{
            "x":param1.data.opponent.getX(),
            "y":param1.data.opponent.getY()
         });
      }
      
      internal function frame1() : *
      {
         this.self = SSF2API.getCharacter(this) as MarioExt;
         this.gliding = false;
         if(SSF2API.isReady())
         {
            this.curFrame = this.self.getGlobalVariable("MarioSSpecFrame");
            this.self.setGlobalVariable("MarioSSpecFrame",0);
            this.self.addEventListener(SSF2Event.GROUND_LEAVE,this.glideAway);
            this.self.addEventListener(SSF2Event.REVERSE_HIT,this.reflected);
            if(this.curFrame > 1)
            {
               this.self.stancePlayFrame(this.curFrame);
            }
         }
      }
      
      internal function frame3() : *
      {
         if(this.curFrame != currentFrame)
         {
            this.self.playSound("mario_capespawn");
         }
         this.self.removeEventListener(SSF2Event.GROUND_LEAVE,this.glideAway);
      }
      
      internal function frame6() : *
      {
         if(this.curFrame != currentFrame)
         {
            this.self.playSound("mario_cape");
            if(this.self.isOnGround())
            {
               this.self.attachEffect("global_dust_heavy",{
                  "x":this.self.flipX(5),
                  "y":1,
                  "scaleX":-0.5,
                  "scaleY":-0.5
               });
               this.self.attachEffect("global_dust_swirl");
            }
            else if(!this.gliding)
            {
               this.self.setYSpeed(-4);
            }
         }
         else
         {
            SSF2API.print("ha ha you dorks failed.");
            this.self.updateAttackBoxStats(1,{
               "damage":0,
               "power":0,
               "kbConstant":0,
               "hasEffect":false,
               "reverse_character":false
            });
         }
      }
      
      internal function frame19() : *
      {
         this.self.endAttack();
      }
   }
}

