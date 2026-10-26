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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1303")]
   public dynamic class Land_21 extends MovieClip
   {
      
      public var hitBox:MovieClip;
      
      public var hitBox2:MovieClip;
      
      public var hitBox3:MovieClip;
      
      public var hitBox4:MovieClip;
      
      public var hitBox5:MovieClip;
      
      public var itemBox:MovieClip;
      
      public var self:LuigiExt;
      
      public function Land_21()
      {
         super();
         addFrameScript(0,this.frame1,3,this.frame4,10,this.frame11);
      }
      
      internal function frame1() : *
      {
         this.self = SSF2API.getCharacter(this) as LuigiExt;
         if(SSF2API.isReady())
         {
            SSF2API.getCamera().shake(2);
            this.self.setGlobalVariable("canStartRise",true);
            if(this.self.getMetalStatus())
            {
               this.self.playSound("metal_land_s");
            }
            else
            {
               this.self.playSound("luigi_landAttack");
            }
         }
      }
      
      internal function frame4() : *
      {
         this.self.endAttack();
      }
      
      internal function frame11() : *
      {
         this.self.endAttack();
      }
   }
}

