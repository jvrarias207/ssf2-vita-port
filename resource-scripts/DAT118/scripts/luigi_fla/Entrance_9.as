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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1272")]
   public dynamic class Entrance_9 extends MovieClip
   {
      
      public var self:LuigiExt;
      
      public function Entrance_9()
      {
         super();
         addFrameScript(0,this.frame1,8,this.frame9,32,this.frame33,39,this.frame40);
      }
      
      internal function frame1() : *
      {
         this.self = SSF2API.getCharacter(this) as LuigiExt;
         if(SSF2API.isReady())
         {
            this.self.setGlobalVariable("canStartRise",true);
         }
      }
      
      internal function frame9() : *
      {
         if(!this.self.getMetalStatus())
         {
            this.self.playSound("luigi_letsago",true);
         }
         this.self.playSound("luigi_jumpsfx");
      }
      
      internal function frame33() : *
      {
         if(this.self.getMetalStatus())
         {
            this.self.playSound("metal_land_m");
         }
         else
         {
            this.self.playSound("luigi_landHeavy");
         }
      }
      
      internal function frame40() : *
      {
         SSF2API.getCharacter(this).endAttack();
      }
   }
}

