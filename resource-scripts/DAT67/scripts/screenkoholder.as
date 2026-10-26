package
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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol511")]
   public dynamic class screenkoholder extends MovieClip
   {
      
      public var char:MovieClip;
      
      public var self:*;
      
      public function screenkoholder()
      {
         super();
         addFrameScript(1,this.frame2,29,this.frame30,59,this.frame60,64,this.frame65);
      }
      
      internal function frame2() : *
      {
         this.self = SSF2API.getCharacter(this);
         if(Boolean(this.self) && SSF2API.isReady())
         {
         }
      }
      
      internal function frame30() : *
      {
         SSF2API.getCamera().shake(20);
         SSF2API.playSound("glassbreak");
         if(this.self)
         {
            this.self.playCharacterSound("screenko");
         }
      }
      
      internal function frame60() : *
      {
         SSF2API.playSound("deathExplosion");
      }
      
      internal function frame65() : *
      {
         stop();
         if(root != null && parent != null)
         {
            parent.removeChild(this);
         }
      }
   }
}

