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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1105")]
   public dynamic class DoubleJump_18 extends MovieClip
   {
      
      public var hand:MovieClip;
      
      public var hitBox:MovieClip;
      
      public var hitBox2:MovieClip;
      
      public var hitBox3:MovieClip;
      
      public var hitBox4:MovieClip;
      
      public var itemBox:MovieClip;
      
      public var self:MarioExt;
      
      public var rand:int;
      
      public var done:Boolean;
      
      public function DoubleJump_18()
      {
         super();
         addFrameScript(0,this.frame1,20,this.frame21,25,this.frame26,29,this.frame30,33,this.frame34,37,this.frame38,48,this.frame49);
      }
      
      internal function frame1() : *
      {
         this.self = SSF2API.getCharacter(this) as MarioExt;
         this.rand = 0;
         if(SSF2API.isReady() && Boolean(this.self))
         {
            this.done = false;
            if(Boolean(this.self.getGlobalVariable("screwAttackOn")) && this.self.getMidairJumpCount() < 2)
            {
               this.self.forceAttack("item_screw");
            }
            else if(Boolean(this.self.getGlobalVariable("sonicShieldFiredash")) && (Boolean(this.self.getControls().LEFT) || Boolean(this.self.getControls().RIGHT)))
            {
               this.self.forceAttack("item_firedash");
            }
            else if(Boolean(this.self.getGlobalVariable("sonicShieldBubbleBounce")) && Boolean(this.self.getControls().DOWN))
            {
               this.self.forceAttack("item_bubblebounce");
            }
            else
            {
               this.rand = 10 * SSF2API.random();
               if(this.rand >= 5)
               {
                  if(!this.self.getMetalStatus())
                  {
                     this.self.playSound("mario_jump2",true);
                  }
               }
               this.self.playSound("mario_jump2sfx");
               if(Boolean(this.self.isFacingRight()) && Boolean(this.self.getControls().LEFT) || Boolean(!this.self.isFacingRight()) && Boolean(this.self.getControls().RIGHT))
               {
                  this.self.stancePlayFrame("backflip");
               }
            }
         }
      }
      
      internal function frame21() : *
      {
         this.self.endAttack();
      }
      
      internal function frame26() : *
      {
         this.self.playSound("mario_backjump");
      }
      
      internal function frame30() : *
      {
         this.self.playSound("mario_backjump");
      }
      
      internal function frame34() : *
      {
         this.self.playSound("mario_backjump");
      }
      
      internal function frame38() : *
      {
         this.self.playSound("mario_backjump");
      }
      
      internal function frame49() : *
      {
         this.self.endAttack();
      }
   }
}

