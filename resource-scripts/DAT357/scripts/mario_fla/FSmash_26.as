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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1117")]
   public dynamic class FSmash_26 extends MovieClip
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
      
      public var xframe:String;
      
      public var customData:Object;
      
      public function FSmash_26()
      {
         super();
         addFrameScript(0,this.frame1,2,this.frame3,42,this.frame43,43,this.frame44,47,this.frame48,64,this.frame65);
      }
      
      public function effects() : void
      {
         this.self.attachEffect("global_dust_heavy",{
            "x":this.self.flipX(5),
            "y":3,
            "scaleX":-0.5,
            "scaleY":-0.5
         });
      }
      
      internal function frame1() : *
      {
         this.self = SSF2API.getCharacter(this) as MarioExt;
         this.xframe = null;
         this.customData = {"attackBox2":{
            "damage":14,
            "power":30,
            "kbConstant":93,
            "hitStun":5,
            "selfHitStun":2,
            "priority":5
         }};
      }
      
      internal function frame3() : *
      {
         this.xframe = "charging";
         this.self.createTimer(4,-1,this.effects);
      }
      
      internal function frame43() : *
      {
         this.self.stancePlayFrame("charging");
      }
      
      internal function frame44() : *
      {
         this.xframe = "attack";
         this.self.destroyTimer(this.effects);
      }
      
      internal function frame48() : *
      {
         this.self.attachEffect("global_dust_heavy",{
            "x":this.self.flipX(5),
            "y":1,
            "scaleX":-0.5,
            "scaleY":-0.5
         });
         this.self.attachEffect("effect_explosion",{
            "x":this.self.flipX(48),
            "y":-25
         });
         SSF2API.getCamera().shake(6);
         this.self.playSound("mario_Fsmash_sfx");
         this.self.playVoiceSound(1);
      }
      
      internal function frame65() : *
      {
         this.self.endAttack();
      }
   }
}

