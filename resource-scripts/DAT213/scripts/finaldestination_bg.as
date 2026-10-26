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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol204")]
   public dynamic class finaldestination_bg extends MovieClip
   {
      
      public var clouds:MovieClip;
      
      public var container:MovieClip;
      
      public var lensflare:MovieClip;
      
      public var spinny:MovieClip;
      
      public function finaldestination_bg()
      {
         super();
         addFrameScript(0,this.frame1,62,this.frame63,124,this.frame125,125,this.frame126,186,this.frame187,248,this.frame249,249,this.frame250,310,this.frame311,372,this.frame373);
      }
      
      internal function frame1() : *
      {
         gotoAndStop("BG1");
      }
      
      internal function frame63() : *
      {
         if(SSF2API.getCurrentMusicInfo().linkage == "bgm_finaldestination" && SSF2API.getCurrentMusicInfo().position >= 52450 || SSF2API.getStage().frames > 38 * 30)
         {
            gotoAndStop("BG1FADEOUT");
         }
         else
         {
            gotoAndStop("BG1");
         }
      }
      
      internal function frame125() : *
      {
         if(SSF2API.getCurrentMusicInfo().linkage == "bgm_finaldestination")
         {
            if(SSF2API.getCurrentMusicInfo().position >= 140550 || SSF2API.getCurrentMusicInfo().position < 52450)
            {
               gotoAndStop("BG1FADEIN");
            }
            else if(SSF2API.getCurrentMusicInfo().position >= 52450 && SSF2API.getCurrentMusicInfo().position < 101150)
            {
               gotoAndStop("BG2FADEIN");
            }
            else if(SSF2API.getCurrentMusicInfo().position >= 101150 && SSF2API.getCurrentMusicInfo().position < 140550)
            {
               gotoAndStop("BG3FADEIN");
            }
         }
         else
         {
            gotoAndStop("BG2FADEIN");
         }
      }
      
      internal function frame126() : *
      {
         if(SSF2API.getQualitySettings().stage_effects == "simple")
         {
            this.lensflare.visible = false;
            this.clouds.visible = false;
         }
      }
      
      internal function frame187() : *
      {
         if(SSF2API.getCurrentMusicInfo().linkage == "bgm_finaldestination" && (SSF2API.getCurrentMusicInfo().position >= 101150 || SSF2API.getCurrentMusicInfo().position < 54450) || SSF2API.getStage().frames > 78 * 30)
         {
            gotoAndStop("BG2FADEOUT");
         }
         else
         {
            gotoAndStop("BG2");
         }
      }
      
      internal function frame249() : *
      {
         if(SSF2API.getCurrentMusicInfo().linkage == "bgm_finaldestination")
         {
            if(SSF2API.getCurrentMusicInfo().position >= 140550 || SSF2API.getCurrentMusicInfo().position < 52450)
            {
               gotoAndStop("BG1FADEIN");
            }
            else if(SSF2API.getCurrentMusicInfo().position >= 52450 && SSF2API.getCurrentMusicInfo().position < 101150)
            {
               gotoAndStop("BG2FADEIN");
            }
            else if(SSF2API.getCurrentMusicInfo().position >= 101150 && SSF2API.getCurrentMusicInfo().position < 140550)
            {
               gotoAndStop("BG3FADEIN");
            }
         }
         else
         {
            gotoAndStop("BG3FADEIN");
         }
      }
      
      internal function frame250() : *
      {
         SSF2API.getStage().startPhase3();
      }
      
      internal function frame311() : *
      {
         if(SSF2API.getCurrentMusicInfo().linkage == "bgm_finaldestination" && (SSF2API.getCurrentMusicInfo().position >= 140550 || SSF2API.getCurrentMusicInfo().position < 103150) || SSF2API.getStage().frames > 118 * 30)
         {
            gotoAndStop("BG3FADEOUT");
         }
         else
         {
            gotoAndStop("BG3");
         }
      }
      
      internal function frame373() : *
      {
         SSF2API.getStage().killPhase3();
         if(SSF2API.getCurrentMusicInfo().linkage == "bgm_finaldestination")
         {
            if(SSF2API.getCurrentMusicInfo().position >= 140550 || SSF2API.getCurrentMusicInfo().position < 52450)
            {
               gotoAndStop("BG1FADEIN");
            }
            else if(SSF2API.getCurrentMusicInfo().position >= 52450 && SSF2API.getCurrentMusicInfo().position < 101150)
            {
               gotoAndStop("BG2FADEIN");
            }
            else if(SSF2API.getCurrentMusicInfo().position >= 101150 && SSF2API.getCurrentMusicInfo().position < 140550)
            {
               gotoAndStop("BG3FADEIN");
            }
         }
         else
         {
            gotoAndStop("BG1FADEIN");
         }
      }
   }
}

