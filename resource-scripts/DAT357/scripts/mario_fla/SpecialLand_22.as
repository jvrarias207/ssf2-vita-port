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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1109")]
   public dynamic class SpecialLand_22 extends MovieClip
   {
      
      public var hitBox:MovieClip;
      
      public var hitBox2:MovieClip;
      
      public var hitBox3:MovieClip;
      
      public var hitBox4:MovieClip;
      
      public var hitBox5:MovieClip;
      
      public var itemBox:MovieClip;
      
      public var self:MarioExt;
      
      public function SpecialLand_22()
      {
         super();
         addFrameScript(0,this.frame1,15,this.frame16);
      }
      
      internal function frame1() : *
      {
         this.self = SSF2API.getCharacter(this) as MarioExt;
         if(SSF2API.isReady() && Boolean(this.self))
         {
            SSF2API.getCamera().shake(4);
            if(this.self.getMetalStatus())
            {
               this.self.playSound("metal_land_m");
            }
            else
            {
               this.self.playSound("mario_heavyLand");
            }
            this.self.setGlobalVariable("canStartRise",true);
         }
      }
      
      internal function frame16() : *
      {
         this.self.endAttack();
      }
   }
}

