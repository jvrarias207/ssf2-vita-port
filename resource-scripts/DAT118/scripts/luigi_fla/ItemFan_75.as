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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1359")]
   public dynamic class ItemFan_75 extends MovieClip
   {
      
      public var hitBox:MovieClip;
      
      public var hitBox2:MovieClip;
      
      public var hitBox3:MovieClip;
      
      public var hitBox4:MovieClip;
      
      public var itemBox:MovieClip;
      
      public var self:LuigiExt;
      
      public function ItemFan_75()
      {
         super();
         addFrameScript(0,this.frame1,2,this.frame3,3,this.frame4,5,this.frame6);
      }
      
      internal function frame1() : *
      {
         this.self = SSF2API.getCharacter(this) as LuigiExt;
      }
      
      internal function frame3() : *
      {
         this.self.getItem().activateItem();
         this.self.playAttackSound(1);
         this.self.attachEffect("global_dust_light",{"x":this.self.flipX(-8)});
      }
      
      internal function frame4() : *
      {
         this.self.getItem().deactivateItem();
      }
      
      internal function frame6() : *
      {
         this.self.endAttack();
      }
   }
}

