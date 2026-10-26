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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1300")]
   public dynamic class DoubleJump_18 extends MovieClip
   {
      
      public var hand:MovieClip;
      
      public var hitBox:MovieClip;
      
      public var hitBox2:MovieClip;
      
      public var hitBox3:MovieClip;
      
      public var hitBox4:MovieClip;
      
      public var itemBox:MovieClip;
      
      public var self:LuigiExt;
      
      public var done:Boolean;
      
      public function DoubleJump_18()
      {
         super();
         addFrameScript(0,this.frame1,24,this.frame25,29,this.frame30,33,this.frame34,37,this.frame38,41,this.frame42,52,this.frame53);
      }
      
      internal function frame1() : *
      {
         this.self = SSF2API.getCharacter(this) as LuigiExt;
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
               if(!this.self.getMetalStatus())
               {
                  if(this.self.getGlobalVariable("mute"))
                  {
                     this.self.setGlobalVariable("mute",false);
                  }
                  else
                  {
                     this.self.playSound("luigi_jump2",true);
                     this.self.setGlobalVariable("mute",true);
                  }
               }
               this.self.playSound("luigi_doublejumpsfx");
               if(Boolean(this.self.isFacingRight()) && Boolean(this.self.getControls().LEFT) || Boolean(!this.self.isFacingRight()) && Boolean(this.self.getControls().RIGHT))
               {
                  this.self.stancePlayFrame("backflip");
               }
            }
         }
      }
      
      internal function frame25() : *
      {
         this.self.endAttack();
      }
      
      internal function frame30() : *
      {
         this.self.playSound("luigi_backjump");
      }
      
      internal function frame34() : *
      {
         this.self.playSound("luigi_backjump");
      }
      
      internal function frame38() : *
      {
         this.self.playSound("luigi_backjump");
      }
      
      internal function frame42() : *
      {
         this.self.playSound("luigi_backjump");
      }
      
      internal function frame53() : *
      {
         this.self.endAttack();
      }
   }
}

