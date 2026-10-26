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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1118")]
   public dynamic class USmash_29 extends MovieClip
   {
      
      public var attackBox:MovieClip;
      
      public var attackBox2:MovieClip;
      
      public var attackBox3:MovieClip;
      
      public var hitBox:MovieClip;
      
      public var hitBox2:MovieClip;
      
      public var hitBox3:MovieClip;
      
      public var hitBox4:MovieClip;
      
      public var hitBox5:MovieClip;
      
      public var hitBox6:MovieClip;
      
      public var itemBox:MovieClip;
      
      public var self:MarioExt;
      
      public var xframe:String;
      
      public function USmash_29()
      {
         super();
         addFrameScript(0,this.frame1,4,this.frame5,44,this.frame45,45,this.frame46,46,this.frame47,48,this.frame49,65,this.frame66);
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
      }
      
      internal function frame5() : *
      {
         this.xframe = "charging";
         this.self.createTimer(4,-1,this.effects);
      }
      
      internal function frame45() : *
      {
         this.self.stancePlayFrame("charging");
      }
      
      internal function frame46() : *
      {
         this.xframe = "attack";
         this.self.destroyTimer(this.effects);
         this.self.attachEffect("global_dust_heavy",{
            "x":this.self.flipX(5),
            "y":1,
            "scaleX":-0.5,
            "scaleY":-0.5
         });
         this.self.clearEffectsOnStateChange();
         this.self.playVoiceSound(1);
      }
      
      internal function frame47() : *
      {
         this.self.playSound("brawl_swing_l");
         this.self.playSound("mario_kickswing");
      }
      
      internal function frame49() : *
      {
         SSF2API.getCamera().shake(2);
         if(this.self.getMetalStatus())
         {
            this.self.playSound("metal_land_s");
         }
         else
         {
            this.self.playSound("mario_lightLand");
         }
      }
      
      internal function frame66() : *
      {
         this.self.endAttack();
      }
   }
}

