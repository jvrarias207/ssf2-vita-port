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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1213")]
   public dynamic class Guard_82 extends MovieClip
   {
      
      public var hitBox:MovieClip;
      
      public var hitBox2:MovieClip;
      
      public var hitBox3:MovieClip;
      
      public var itemBox:MovieClip;
      
      public var self:MarioExt;
      
      public function Guard_82()
      {
         super();
         addFrameScript(0,this.frame1,3,this.frame4,9,this.frame10);
      }
      
      public function outOfShield(param1:* = null) : void
      {
         var _loc2_:Number = NaN;
         if(param1.data.caller == this.self)
         {
            if(this.self.isCPU() && this.self.getCPULevel() >= 7)
            {
               _loc2_ = SSF2API.random();
               if(_loc2_ < 0.25)
               {
                  this.self.importCPUControls([4099,2,6147,1,6209,1,4161,2,4097,1]);
               }
               else if(_loc2_ < 0.4)
               {
                  this.self.importCPUControls([4163,2]);
               }
               else if(_loc2_ < 0.55)
               {
                  this.self.importCPUControls([6179,2]);
               }
            }
         }
      }
      
      internal function frame1() : *
      {
         if(SSF2API.isReady())
         {
            this.self = SSF2API.getCharacter(this) as MarioExt;
         }
         if(Boolean(parent) && Boolean(this.self) && SSF2API.isReady())
         {
            this.self.addEventListener(SSF2Event.CHAR_SHIELD_HIT,this.outOfShield);
         }
         if(Boolean(parent) && Boolean(SSF2API.isReady()) && Boolean(this.self))
         {
            this.self.setGlobalVariable("jab",false);
            this.self.setGlobalVariable("jab2",false);
         }
      }
      
      internal function frame4() : *
      {
         this.self.stancePlayFrame("pause");
      }
      
      internal function frame10() : *
      {
         this.self.endAttack();
      }
   }
}

