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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1162")]
   public dynamic class BThrow_48 extends MovieClip
   {
      
      public var attackBox:MovieClip;
      
      public var hitBox:MovieClip;
      
      public var hitBox2:MovieClip;
      
      public var hitBox3:MovieClip;
      
      public var itemBox:MovieClip;
      
      public var touchBox:MovieClip;
      
      public var self:MarioExt;
      
      public var xframe:String;
      
      public var enemy:Object;
      
      public function BThrow_48()
      {
         super();
         addFrameScript(0,this.frame1,1,this.frame2,2,this.frame3,4,this.frame5,6,this.frame7,8,this.frame9,10,this.frame11,12,this.frame13,14,this.frame15,16,this.frame17,18,this.frame19,20,this.frame21,22,this.frame23,24,this.frame25,26,this.frame27,32,this.frame33);
      }
      
      internal function frame1() : *
      {
         this.self = SSF2API.getCharacter(this) as MarioExt;
         if(Boolean(parent) && Boolean(this.self) && SSF2API.isReady())
         {
            this.xframe = null;
            this.self.swapDepthsWithGrabbedOpponent(false);
         }
         if(Boolean(parent) && Boolean(this.self) && SSF2API.isReady())
         {
            this.enemy = this.self.getGrabbedOpponent();
            this.self.bringBehind(this.enemy);
            if(!this.self.isFacingRight())
            {
               this.enemy.setRotation(-3);
            }
            else
            {
               this.enemy.setRotation(3);
            }
         }
      }
      
      internal function frame2() : *
      {
         this.self.playSound("throw_woosh");
      }
      
      internal function frame3() : *
      {
         this.self.forceGrabbedHurtFrame("spin");
         if(!this.self.isFacingRight())
         {
            this.enemy.setRotation(-9);
         }
         else
         {
            this.enemy.setRotation(9);
         }
      }
      
      internal function frame5() : *
      {
         this.self.bringBehind(this.enemy);
         if(!this.self.isFacingRight())
         {
            this.enemy.setRotation(-11);
         }
         else
         {
            this.enemy.setRotation(11);
         }
      }
      
      internal function frame7() : *
      {
         this.self.playSound("throw_woosh");
         this.enemy.flip();
         if(!this.self.isFacingRight())
         {
            this.enemy.setRotation(-341);
         }
         else
         {
            this.enemy.setRotation(341);
         }
      }
      
      internal function frame9() : *
      {
         this.self.attachEffect("global_dust_swirl");
         this.self.bringInFront(this.enemy);
         if(!this.self.isFacingRight())
         {
            this.enemy.setRotation(-351);
         }
         else
         {
            this.enemy.setRotation(351);
         }
      }
      
      internal function frame11() : *
      {
         this.enemy.flip();
         if(!this.self.isFacingRight())
         {
            this.enemy.setRotation(-4);
         }
         else
         {
            this.enemy.setRotation(4);
         }
      }
      
      internal function frame13() : *
      {
         if(!this.self.isFacingRight())
         {
            this.enemy.setRotation(-9);
         }
         else
         {
            this.enemy.setRotation(9);
         }
      }
      
      internal function frame15() : *
      {
         this.self.bringBehind(this.enemy);
         if(!this.self.isFacingRight())
         {
            this.enemy.setRotation(-11);
         }
         else
         {
            this.enemy.setRotation(11);
         }
      }
      
      internal function frame17() : *
      {
         this.self.playSound("throw_woosh");
         this.enemy.flip();
         if(!this.self.isFacingRight())
         {
            this.enemy.setRotation(-341);
         }
         else
         {
            this.enemy.setRotation(341);
         }
      }
      
      internal function frame19() : *
      {
         this.self.attachEffect("global_dust_swirl");
         this.self.bringInFront(this.enemy);
         if(!this.self.isFacingRight())
         {
            this.enemy.setRotation(-351);
         }
         else
         {
            this.enemy.setRotation(351);
         }
      }
      
      internal function frame21() : *
      {
         this.enemy.flip();
         if(!this.self.isFacingRight())
         {
            this.enemy.setRotation(-4);
         }
         else
         {
            this.enemy.setRotation(4);
         }
      }
      
      internal function frame23() : *
      {
         if(!this.self.isFacingRight())
         {
            this.enemy.setRotation(-9);
         }
         else
         {
            this.enemy.setRotation(9);
         }
      }
      
      internal function frame25() : *
      {
         SSF2API.getCamera().shake(9);
         this.enemy.flip();
         this.self.bringBehind(this.enemy);
         if(!this.self.isFacingRight())
         {
            this.enemy.setRotation(-11);
         }
         else
         {
            this.enemy.setRotation(11);
         }
      }
      
      internal function frame27() : *
      {
         this.self.playVoiceSound(1);
         this.self.attachEffect("global_dust_heavy_rv",{
            "x":this.self.flipX(-5),
            "y":1,
            "scaleX":-0.5,
            "scaleY":-0.5
         });
         this.enemy.resetRotation();
      }
      
      internal function frame33() : *
      {
         this.self.flip();
         this.self.endAttack();
      }
   }
}

