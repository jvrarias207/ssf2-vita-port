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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1384")]
   public dynamic class Crouch_85 extends MovieClip
   {
      
      public var hitBox:MovieClip;
      
      public var hitBox2:MovieClip;
      
      public var hitBox3:MovieClip;
      
      public var itemBox:MovieClip;
      
      public var self:LuigiExt;
      
      public var moving:Boolean;
      
      public var controls:Object;
      
      public function Crouch_85()
      {
         super();
         addFrameScript(0,this.frame1,3,this.frame4,4,this.frame5,5,this.frame6,6,this.frame7,9,this.frame10,11,this.frame12,12,this.frame13,17,this.frame18,21,this.frame22);
      }
      
      public function updateCrawl() : *
      {
         this.controls = this.self.getControls();
         if(!this.controls.LEFT && !this.controls.RIGHT || Boolean(this.controls.LEFT) && Boolean(this.controls.RIGHT))
         {
            this.self.destroyTimer(this.updateCrawl);
            gotoAndStop("redo");
         }
         else if(Boolean(this.self.isFacingRight()) && Boolean(this.controls.RIGHT) || Boolean(!this.self.isFacingRight()) && Boolean(this.controls.LEFT))
         {
            if(currentFrame < 7 || currentFrame >= 12)
            {
               gotoAndStop("crawlforward");
            }
         }
         else if(Boolean(!this.self.isFacingRight()) && Boolean(this.controls.RIGHT) || Boolean(this.self.isFacingRight()) && Boolean(this.controls.LEFT))
         {
            if(currentFrame < 13)
            {
               gotoAndStop("crawlback");
            }
         }
      }
      
      internal function frame1() : *
      {
         this.self = SSF2API.getCharacter(this) as LuigiExt;
         this.moving = false;
      }
      
      internal function frame4() : *
      {
         this.self.setGlobalVariable("crouchdown",true);
         this.moving = false;
      }
      
      internal function frame5() : *
      {
         this.gotoAndStop("redo");
      }
      
      internal function frame6() : *
      {
         this.moving = true;
         this.self.createTimer(1,-1,this.updateCrawl);
      }
      
      internal function frame7() : *
      {
         if(this.self.getMetalStatus())
         {
            this.self.playSound("metal_step_s1");
         }
         else
         {
            this.self.playSound("luigi_footstep");
         }
      }
      
      internal function frame10() : *
      {
         if(this.self.getMetalStatus())
         {
            this.self.playSound("metal_step_s2");
         }
         else
         {
            this.self.playSound("luigi_footstep2");
         }
      }
      
      internal function frame12() : *
      {
         gotoAndStop("crawlforward");
      }
      
      internal function frame13() : *
      {
         if(this.self.getMetalStatus())
         {
            this.self.playSound("metal_step_s1");
         }
         else
         {
            this.self.playSound("luigi_footstep");
         }
      }
      
      internal function frame18() : *
      {
         if(this.self.getMetalStatus())
         {
            this.self.playSound("metal_step_s2");
         }
         else
         {
            this.self.playSound("luigi_footstep2");
         }
      }
      
      internal function frame22() : *
      {
         gotoAndStop("crawlback");
      }
   }
}

