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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1233")]
   public dynamic class Taunts_94 extends MovieClip
   {
      
      public var hitBox:MovieClip;
      
      public var hitBox2:MovieClip;
      
      public var hitBox3:MovieClip;
      
      public var hitBox4:MovieClip;
      
      public var itemBox:MovieClip;
      
      public var self:MarioExt;
      
      public function Taunts_94()
      {
         super();
         addFrameScript(0,this.frame1,1,this.frame2,41,this.frame42,46,this.frame47,94,this.frame95,114,this.frame115,115,this.frame116,143,this.frame144,160,this.frame161);
      }
      
      internal function frame1() : *
      {
         this.self = SSF2API.getCharacter(this) as MarioExt;
      }
      
      internal function frame2() : *
      {
         if(!this.self.getMetalStatus())
         {
            this.self.playSound("mario_tauntSide",true);
         }
         this.self.attachEffect("global_dust_swirl",{"x":this.self.flipX(5)});
      }
      
      internal function frame42() : *
      {
         this.self.endAttack();
      }
      
      internal function frame47() : *
      {
         this.self.playSound("mario_grow1");
      }
      
      internal function frame95() : *
      {
         this.self.playSound("mario_grow2");
      }
      
      internal function frame115() : *
      {
         this.self.endAttack();
      }
      
      internal function frame116() : *
      {
         this.self.playSound("MarioDTauntSpin");
      }
      
      internal function frame144() : *
      {
         this.self.attachEffect("global_dust_cloud",{
            "scaleX":-0.5,
            "scaleY":-0.5
         });
         SSF2API.getCamera().shake(2);
         if(this.self.getMetalStatus())
         {
            this.self.playSound("metal_land_m");
         }
         else
         {
            this.self.playSound("mario_heavyLand");
         }
      }
      
      internal function frame161() : *
      {
         this.self.endAttack();
      }
   }
}

