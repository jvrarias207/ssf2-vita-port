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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1175")]
   public dynamic class ItemHeavyShoot_61 extends MovieClip
   {
      
      public var hitBox:MovieClip;
      
      public var itemBox:MovieClip;
      
      public var self:MarioExt;
      
      public function ItemHeavyShoot_61()
      {
         super();
         addFrameScript(0,this.frame1,3,this.frame4,25,this.frame26);
      }
      
      internal function frame1() : *
      {
         this.self = SSF2API.getCharacter(this) as MarioExt;
      }
      
      internal function frame4() : *
      {
         this.self.getItem().activateItem();
         this.self.attachEffect("global_dust_heavy",{
            "x":this.self.flipX(5),
            "y":3,
            "scaleX":-0.5,
            "scaleY":-0.5
         });
      }
      
      internal function frame26() : *
      {
         this.self.endAttack();
      }
   }
}

