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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol691")]
   public dynamic class starkoholder extends MovieClip
   {
      
      public var char:MovieClip;
      
      public var self:*;
      
      public function starkoholder()
      {
         super();
         addFrameScript(1,this.frame2,80,this.frame81,99,this.frame100);
      }
      
      internal function frame2() : *
      {
         this.self = SSF2API.getCharacter(this);
         if(Boolean(this.self) && SSF2API.isReady())
         {
            this.self.playCharacterSound("starko");
         }
      }
      
      internal function frame81() : *
      {
         SSF2API.playSound("starkosound");
      }
      
      internal function frame100() : *
      {
         stop();
         if(root != null && parent != null)
         {
            parent.removeChild(this);
         }
      }
   }
}

