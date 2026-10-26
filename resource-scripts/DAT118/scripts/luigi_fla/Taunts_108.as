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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1411")]
   public dynamic class Taunts_108 extends MovieClip
   {
      
      public var attackBox:MovieClip;
      
      public var attackBox2:MovieClip;
      
      public var hitBox:MovieClip;
      
      public var hitBox2:MovieClip;
      
      public var hitBox3:MovieClip;
      
      public var hitBox4:MovieClip;
      
      public var hitbox4:MovieClip;
      
      public var itemBox:MovieClip;
      
      public var self:LuigiExt;
      
      public function Taunts_108()
      {
         super();
         addFrameScript(0,this.frame1,1,this.frame2,5,this.frame6,7,this.frame8,8,this.frame9,34,this.frame35,48,this.frame49,50,this.frame51,99,this.frame100,110,this.frame111,115,this.frame116,131,this.frame132);
      }
      
      internal function frame1() : *
      {
         this.self = SSF2API.getCharacter(this) as LuigiExt;
      }
      
      internal function frame2() : *
      {
         if(!this.self.getMetalStatus())
         {
            this.self.playSound("luigi_tauntSide",true);
         }
      }
      
      internal function frame6() : *
      {
         this.self.setXSpeed(3,false);
      }
      
      internal function frame8() : *
      {
         SSF2API.getCamera().shake(2);
      }
      
      internal function frame9() : *
      {
         if(this.self.getMetalStatus())
         {
            this.self.playSound("metal_land_m");
         }
         else
         {
            this.self.playSound("luigi_tauntbounce");
         }
      }
      
      internal function frame35() : *
      {
         this.self.setXSpeed(-2.5,false);
      }
      
      internal function frame49() : *
      {
         this.self.endAttack();
      }
      
      internal function frame51() : *
      {
         if(!this.self.getMetalStatus())
         {
            this.self.playSound("luigi_taunt2",true);
         }
      }
      
      internal function frame100() : *
      {
         this.self.endAttack();
      }
      
      internal function frame111() : *
      {
         if(!this.self.getMetalStatus())
         {
            this.self.playSound("luigi_taunt3",true);
         }
      }
      
      internal function frame116() : *
      {
         this.self.playSound("luigi_crawl_backward");
      }
      
      internal function frame132() : *
      {
         this.self.endAttack();
      }
   }
}

