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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1320")]
   public dynamic class USmash_34 extends MovieClip
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
      
      public var self:LuigiExt;
      
      public var xframe:String;
      
      public function USmash_34()
      {
         super();
         addFrameScript(0,this.frame1,3,this.frame4,43,this.frame44,44,this.frame45,46,this.frame47,47,this.frame48,62,this.frame63);
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
         this.self = SSF2API.getCharacter(this) as LuigiExt;
         this.xframe = null;
      }
      
      internal function frame4() : *
      {
         this.xframe = "charging";
         this.self.createTimer(4,-1,this.effects);
      }
      
      internal function frame44() : *
      {
         this.self.stancePlayFrame("charging");
      }
      
      internal function frame45() : *
      {
         this.xframe = "attack";
         this.self.destroyTimer(this.effects);
         this.self.playVoiceSound(1);
      }
      
      internal function frame47() : *
      {
         this.self.updateAttackBoxStats(1,{"direction":90});
         this.self.updateAttackBoxStats(2,{"direction":90});
         this.self.updateAttackBoxStats(3,{"direction":90});
         this.self.playSound("brawl_swing_m");
         this.self.playSound("luigi_kickswing");
         this.self.attachEffect("global_dust_cloud");
      }
      
      internal function frame48() : *
      {
         this.self.updateAttackBoxStats(1,{"direction":100});
         this.self.updateAttackBoxStats(2,{"direction":100});
         this.self.updateAttackBoxStats(3,{"direction":100});
         SSF2API.getCamera().shake(2);
         if(this.self.getMetalStatus())
         {
            this.self.playSound("metal_land_s");
         }
         else
         {
            this.self.playSound("luigi_landAttack");
         }
      }
      
      internal function frame63() : *
      {
         this.self.endAttack();
      }
   }
}

