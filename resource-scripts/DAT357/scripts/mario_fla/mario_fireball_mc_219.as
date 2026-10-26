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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol220")]
   public dynamic class mario_fireball_mc_219 extends MovieClip
   {
      
      public var attackBox:MovieClip;
      
      public var hitBox:MovieClip;
      
      public var self:*;
      
      public var character:*;
      
      public function mario_fireball_mc_219()
      {
         super();
         addFrameScript(0,this.frame1,9,this.frame10,18,this.frame19,19,this.frame20);
      }
      
      public function wallBounce(param1:Event = null) : void
      {
         this.self.setXSpeed(-1 * this.self.getXSpeed());
         SSF2API.playSound("mario_fireballLand");
         this.self.attachEffect("fireball_wall_hit",{"y":0});
      }
      
      public function groundBounce(param1:Event = null) : void
      {
         SSF2API.playSound("mario_fireballLand");
         this.self.attachEffect("fireball_land",{"y":0});
      }
      
      internal function frame1() : *
      {
         this.self = SSF2API.getProjectile(this);
         if(SSF2API.isReady() && Boolean(this.self))
         {
            this.character = this.self.getOwner();
            this.self.addEventListener(SSF2Event.ATTACK_CONNECT,this.self.destroy);
            this.self.addEventListener(SSF2Event.ATTACK_HIT_SHIELD,this.self.destroy);
            this.self.addEventListener(SSF2Event.HIT_WALL,this.wallBounce);
            this.self.addEventListener(SSF2Event.GROUND_TOUCH,this.groundBounce);
         }
      }
      
      internal function frame10() : *
      {
         this.self.stancePlayFrame("loop");
      }
      
      internal function frame19() : *
      {
         if(this.self == null)
         {
            this.self = SSF2API.getProjectile(this);
         }
         this.self.stancePlayFrame("suspend");
      }
      
      internal function frame20() : *
      {
         this.self = SSF2API.getProjectile(this);
         if(SSF2API.isReady() && Boolean(this.self))
         {
            this.character = this.self.getOwner();
            this.self.addEventListener(SSF2Event.ATTACK_CONNECT,this.self.destroy);
            this.self.addEventListener(SSF2Event.ATTACK_HIT_SHIELD,this.self.destroy);
            this.self.addEventListener(SSF2Event.HIT_WALL,this.wallBounce);
            this.self.addEventListener(SSF2Event.GROUND_TOUCH,this.groundBounce);
            this.self.stancePlayFrame("loop");
         }
      }
   }
}

