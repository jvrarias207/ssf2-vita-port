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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1050")]
   public dynamic class Idle_3 extends MovieClip
   {
      
      public var hitBox:MovieClip;
      
      public var hitBox2:MovieClip;
      
      public var hitBox3:MovieClip;
      
      public var hitBox4:MovieClip;
      
      public var hitBox5:MovieClip;
      
      public var itemBox:MovieClip;
      
      public var self:MarioExt;
      
      public var rand:int;
      
      public var repeats:int;
      
      public function Idle_3()
      {
         super();
         addFrameScript(0,this.frame1,32,this.frame33,63,this.frame64,67,this.frame68);
      }
      
      public function uncrouch(param1:* = null) : *
      {
         if(param1.data.fromState == 12 && Boolean(this.self.getGlobalVariable("crouchdown")))
         {
            this.self.setGlobalVariable("crouchdown",false);
            this.self.stancePlayFrame("uncrouch");
         }
         else
         {
            this.self.setGlobalVariable("crouchdown",false);
         }
      }
      
      internal function frame1() : *
      {
         this.self = SSF2API.getCharacter(this) as MarioExt;
         this.rand = 0;
         if(!this.repeats)
         {
            this.repeats = 0;
         }
         if(Boolean(parent) && Boolean(SSF2API.isReady()) && Boolean(this.self))
         {
            if(this.repeats >= 3)
            {
               this.rand = SSF2API.randomInteger(0,3);
               if(this.rand >= 3)
               {
                  this.repeats = 0;
                  this.gotoAndStop("wait1");
               }
            }
         }
         if(Boolean(this.self) && SSF2API.isReady())
         {
            if(!this.self.hasEventListener(SSF2Event.STATE_CHANGE,this.uncrouch))
            {
               this.self.addEventListener(SSF2Event.STATE_CHANGE,this.uncrouch);
            }
         }
      }
      
      internal function frame33() : *
      {
         ++this.repeats;
         this.gotoAndStop("loop");
      }
      
      internal function frame64() : *
      {
         this.gotoAndStop("loop");
      }
      
      internal function frame68() : *
      {
         gotoAndStop("loop");
      }
   }
}

