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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1147")]
   public dynamic class SSpecialAir_37 extends MovieClip
   {
      
      public var attackBox:MovieClip;
      
      public var hand:MovieClip;
      
      public var hitBox:MovieClip;
      
      public var hitBox2:MovieClip;
      
      public var hitBox3:MovieClip;
      
      public var hitBox4:MovieClip;
      
      public var itemBox:MovieClip;
      
      public var reverseBox:MovieClip;
      
      public var self:MarioExt;
      
      public function SSpecialAir_37()
      {
         super();
         addFrameScript(0,this.frame1,2,this.frame3,5,this.frame6,18,this.frame19);
      }
      
      public function grounded(param1:* = null) : *
      {
         this.self.removeEventListener(SSF2Event.GROUND_TOUCH,this.grounded);
         this.self.setGlobalVariable("canStartRise",true);
         this.self.setGlobalVariable("MarioSSpecFrame",currentFrame);
         this.self.forceAttack("b_forward",null,true);
      }
      
      public function reflected(param1:* = null) : *
      {
         this.self.playSound("reflect_sfx");
         SSF2API.attachEffect("reflect_effect",{
            "x":param1.data.opponent.getX(),
            "y":param1.data.opponent.getY()
         });
      }
      
      internal function frame1() : *
      {
         this.self = SSF2API.getCharacter(this) as MarioExt;
         if(SSF2API.isReady() && Boolean(this.self))
         {
            this.self.addEventListener(SSF2Event.GROUND_TOUCH,this.grounded);
            this.self.addEventListener(SSF2Event.REVERSE_HIT,this.reflected);
         }
      }
      
      internal function frame3() : *
      {
         this.self.playSound("mario_capespawn");
      }
      
      internal function frame6() : *
      {
         this.self.playSound("mario_cape");
         this.self.attachEffect("global_dust_heavy",{
            "x":this.self.flipX(5),
            "y":1,
            "scaleX":-0.5,
            "scaleY":-0.5,
            "parentLock":true
         });
         this.self.setYSpeed(-4);
      }
      
      internal function frame19() : *
      {
         this.self.endAttack();
      }
   }
}

