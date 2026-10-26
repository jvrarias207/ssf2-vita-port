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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1052")]
   public dynamic class Entrance_7 extends MovieClip
   {
      
      public var self:MarioExt;
      
      public function Entrance_7()
      {
         super();
         addFrameScript(0,this.frame1,9,this.frame10,30,this.frame31,46,this.frame47,64,this.frame65,78,this.frame79,92,this.frame93);
      }
      
      internal function frame1() : *
      {
         this.self = SSF2API.getCharacter(this) as MarioExt;
         if(SSF2API.isReady())
         {
            this.self.setGlobalVariable("canStartRise",true);
            if(this.self.getMetalStatus())
            {
               this.self.stancePlayFrame("metal");
            }
            else
            {
               this.self.stancePlayFrame("regular");
            }
         }
      }
      
      internal function frame10() : *
      {
         if(!this.self.getMetalStatus())
         {
            this.self.playSound("letsago",true);
         }
         this.self.playSound("mario_jumpsfx");
      }
      
      internal function frame31() : *
      {
         if(this.self.getMetalStatus())
         {
            this.self.playSound("metal_land_m");
         }
         else
         {
            this.self.playSound("mario_landHeavy");
         }
      }
      
      internal function frame47() : *
      {
         SSF2API.getCharacter(this).endAttack();
      }
      
      internal function frame65() : *
      {
         SSF2API.getCamera().shake(10);
         this.self.attachEffect("global_dust_swirl");
         this.self.attachEffect("ground_bounce");
         this.self.attachEffect("global_dust_cloud");
         this.self.playSound("metal_land_l");
      }
      
      internal function frame79() : *
      {
         this.self.playSound("metal_land_m");
         SSF2API.getCamera().shake(3);
      }
      
      internal function frame93() : *
      {
         SSF2API.getCharacter(this).endAttack();
      }
   }
}

