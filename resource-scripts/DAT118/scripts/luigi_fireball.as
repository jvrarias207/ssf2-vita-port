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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol435")]
   public dynamic class luigi_fireball extends MovieClip
   {
      
      public var attackBox:MovieClip;
      
      public var hitBox:MovieClip;
      
      public var self:*;
      
      public var speed:*;
      
      public var slow:*;
      
      public var character:*;
      
      public function luigi_fireball()
      {
         super();
         addFrameScript(0,this.frame1,4,this.frame5,5,this.frame6,8,this.frame9,9,this.frame10,11,this.frame12,12,this.frame13,13,this.frame14,17,this.frame18,18,this.frame19,19,this.frame20,36,this.frame37,37,this.frame38,40,this.frame41);
      }
      
      public function updateSpeed(param1:* = null) : *
      {
         if(this.self.getXSpeed() != this.speed)
         {
            this.speed = this.self.getXSpeed();
         }
         if(this.slow != 0)
         {
            this.self.setX(this.self.getX() - this.speed * this.slow);
         }
      }
      
      public function wallBounce(param1:Event = null) : void
      {
         this.self.setXSpeed(-1 * this.self.getXSpeed());
         this.self.playSound("luigi_fireballLand");
         this.self.attachEffect("green_fireball_wall_hit",{"y":0});
      }
      
      public function groundBounce(param1:Event = null) : void
      {
         this.self.playSound("luigi_fireballLand");
         this.self.attachEffect("green_fireball_land",{"y":0});
      }
      
      internal function frame1() : *
      {
         this.self = SSF2API.getProjectile(this);
         this.slow = 0;
         if(SSF2API.isReady() && Boolean(this.self))
         {
            this.character = this.self.getOwner();
            this.speed = this.self.getXSpeed();
            this.self.addEventListener(SSF2Event.ATTACK_CONNECT,this.self.destroy);
            this.self.addEventListener(SSF2Event.ATTACK_HIT_SHIELD,this.self.destroy);
            this.self.addEventListener(SSF2Event.HIT_WALL,this.wallBounce);
            this.self.addEventListener(SSF2Event.GROUND_TOUCH,this.groundBounce);
            this.self.createTimer(1,-1,this.updateSpeed);
         }
      }
      
      internal function frame5() : *
      {
         this.slow = -0.1;
      }
      
      internal function frame6() : *
      {
         this.slow = -0.3;
      }
      
      internal function frame9() : *
      {
         this.slow = -0.1;
      }
      
      internal function frame10() : *
      {
         this.slow = 0;
      }
      
      internal function frame12() : *
      {
         this.slow = 0.15;
      }
      
      internal function frame13() : *
      {
         this.slow = 0.4;
      }
      
      internal function frame14() : *
      {
         this.slow = 0.75;
      }
      
      internal function frame18() : *
      {
         this.slow = 0.4;
      }
      
      internal function frame19() : *
      {
         this.slow = 0.15;
      }
      
      internal function frame20() : *
      {
         this.slow = 0;
         this.self.stancePlayFrame("loop");
      }
      
      internal function frame37() : *
      {
         if(this.self == null)
         {
            this.self = SSF2API.getProjectile(this);
         }
         this.self.stancePlayFrame("suspend");
      }
      
      internal function frame38() : *
      {
         this.self = SSF2API.getProjectile(this);
         this.slow = 0;
         if(SSF2API.isReady() && Boolean(this.self))
         {
            this.character = this.self.getOwner();
            this.speed = this.self.getXSpeed();
            this.self.addEventListener(SSF2Event.ATTACK_CONNECT,this.self.destroy);
            this.self.addEventListener(SSF2Event.ATTACK_HIT_SHIELD,this.self.destroy);
            this.self.addEventListener(SSF2Event.HIT_WALL,this.wallBounce);
            this.self.addEventListener(SSF2Event.GROUND_TOUCH,this.groundBounce);
            this.self.createTimer(1,-1,this.updateSpeed);
         }
      }
      
      internal function frame41() : *
      {
         this.self.stancePlayFrame("loop");
      }
   }
}

