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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1219")]
   public dynamic class Sleep_86 extends MovieClip
   {
      
      public var hitBox:MovieClip;
      
      public var hitBox2:MovieClip;
      
      public var hitBox3:MovieClip;
      
      public var hitBox4:MovieClip;
      
      public var hitBox5:MovieClip;
      
      public var hitBox6:MovieClip;
      
      public var itemBox:MovieClip;
      
      public var self:MarioExt;
      
      public function Sleep_86()
      {
         super();
         addFrameScript(0,this.frame1,1,this.frame2,14,this.frame15,31,this.frame32,56,this.frame57,87,this.frame88,119,this.frame120);
      }
      
      internal function frame1() : *
      {
         this.self = SSF2API.getCharacter(this) as MarioExt;
         if(Boolean(parent) && Boolean(SSF2API.isReady()) && Boolean(this.self))
         {
            this.self.playSound("fall_asleep");
         }
      }
      
      internal function frame2() : *
      {
         this.self.attachEffect("global_bubbles",{
            "x":this.self.flipX(3),
            "y":-14
         });
      }
      
      internal function frame15() : *
      {
         SSF2API.getCamera().shake(2);
         if(this.self.getMetalStatus())
         {
            this.self.playSound("metal_land_s");
         }
         else
         {
            this.self.playSound("mario_landLight");
         }
      }
      
      internal function frame32() : *
      {
         if(!this.self.getMetalStatus())
         {
            this.self.playSound("mario_sleep",true);
         }
      }
      
      internal function frame57() : *
      {
         this.self.attachEffect("global_bubbles",{
            "x":this.self.flipX(-6),
            "y":9
         });
      }
      
      internal function frame88() : *
      {
         this.self.stancePlayFrame("again");
      }
      
      internal function frame120() : *
      {
         this.self.endAttack();
      }
   }
}

