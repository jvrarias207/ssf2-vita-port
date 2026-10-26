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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1166")]
   public dynamic class ItemTilt_52 extends MovieClip
   {
      
      public var hitBox:MovieClip;
      
      public var itemBox:MovieClip;
      
      public var self:MarioExt;
      
      public function ItemTilt_52()
      {
         super();
         addFrameScript(0,this.frame1,6,this.frame7,8,this.frame9,18,this.frame19);
      }
      
      internal function frame1() : *
      {
         this.self = SSF2API.getCharacter(this) as MarioExt;
      }
      
      internal function frame7() : *
      {
         this.self.getItem().activateItem();
         this.self.playAttackSound(1);
         this.self.attachEffect("global_dust_heavy",{
            "x":this.self.flipX(5),
            "y":3,
            "scaleX":-0.5,
            "scaleY":-0.5
         });
      }
      
      internal function frame9() : *
      {
         this.self.getItem().deactivateItem();
      }
      
      internal function frame19() : *
      {
         this.self.endAttack();
      }
   }
}

