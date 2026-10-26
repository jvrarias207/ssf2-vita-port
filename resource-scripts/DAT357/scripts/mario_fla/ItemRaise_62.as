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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1176")]
   public dynamic class ItemRaise_62 extends MovieClip
   {
      
      public var hitBox:MovieClip;
      
      public var itemBox:MovieClip;
      
      public var self:MarioExt;
      
      public function ItemRaise_62()
      {
         super();
         addFrameScript(0,this.frame1,7,this.frame8,16,this.frame17,26,this.frame27,30,this.frame31);
      }
      
      internal function frame1() : *
      {
         this.self = SSF2API.getCharacter(this) as MarioExt;
      }
      
      internal function frame8() : *
      {
         this.self.getItem().activateItem();
      }
      
      internal function frame17() : *
      {
         SSF2API.playSound("mario_jumpsfx");
      }
      
      internal function frame27() : *
      {
         if(this.self.getMetalStatus())
         {
            this.self.playSound("metal_land_s");
         }
         else
         {
            this.self.playSound("mario_landLight");
         }
      }
      
      internal function frame31() : *
      {
         this.self.endAttack();
      }
   }
}

