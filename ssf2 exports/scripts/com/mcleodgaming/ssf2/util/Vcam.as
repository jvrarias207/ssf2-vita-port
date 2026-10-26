package com.mcleodgaming.ssf2.util
{
   import com.mcleodgaming.ssf2.Main;
   import com.mcleodgaming.ssf2.api.SSF2Camera;
   import com.mcleodgaming.ssf2.controllers.GameController;
   import com.mcleodgaming.ssf2.engine.*;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class Vcam
   {
      
      public static const NORMAL_MODE:int = 0;
      
      public static const ZOOM_MODE:int = 1;
      
      public static const STAGE_MODE:int = 2;
      
      public static const FREE_MODE:int = 3;
      
      public static const LOCK_MODE:int = 4;
      
      private static var FREE_CAM_MAX_SPEED:Number = 15;
      
      private static var FREE_CAM_ACCEL:Number = 4;
      
      private var m_apiInstance:SSF2Camera;
      
      private var BG_CONTAINER:DisplayObjectContainer;
      
      private var STAGE:MovieClip;
      
      private var m_xbounds:Array;
      
      private var m_ybounds:Array;
      
      private var m_xtarget:Number;
      
      private var m_ytarget:Number;
      
      private var m_xspeed:Number;
      
      private var m_yspeed:Number;
      
      private var m_horizontalPanLock:Vector.<Boolean>;
      
      private var m_verticalPanLock:Vector.<Boolean>;
      
      private var m_zoomSpeed:Number;
      
      private var m_mainTerrain:MovieClip;
      
      private var m_targets:Vector.<MovieClip>;
      
      private var m_timedTargets:Vector.<MovieClip>;
      
      private var m_forcedTargets:Vector.<MovieClip>;
      
      private var m_timedTargetTimers:Vector.<int>;
      
      private var m_timedTargetPoints:Vector.<Point>;
      
      private var m_timedTargetPointTimers:Vector.<int>;
      
      private var m_cam:MovieClip;
      
      private var m_backgrounds:Vector.<VcamBG>;
      
      private var m_bg_holder:MovieClip;
      
      private var m_fg_holder:MovieClip;
      
      private var m_shakeSpeed:Number;
      
      private var m_x_shakeSpeed:Number;
      
      private var m_y_shakeSpeed:Number;
      
      private var m_focusMCs:Vector.<MovieClip>;
      
      private var m_focusTimers:Vector.<int>;
      
      private var m_stageFocus:FrameTimer;
      
      private var m_mode:int;
      
      private var m_dead:Boolean;
      
      private var m_settings:VcamSettings;
      
      private var cX:Number;
      
      private var cY:Number;
      
      private var sX:Number;
      
      private var sY:Number;
      
      private var oX:Number;
      
      private var oY:Number;
      
      public function Vcam(parameters:VcamSettings, stageMC:MovieClip, backgroundHolder:DisplayObjectContainer)
      {
         super();
         this.STAGE = stageMC;
         this.BG_CONTAINER = backgroundHolder;
         this.m_apiInstance = new SSF2Camera(null,this);
         this.m_backgrounds = new Vector.<VcamBG>();
         this.m_bg_holder = null;
         this.m_fg_holder = null;
         this.m_dead = false;
         this.init(parameters);
         this.m_targets = new Vector.<MovieClip>();
         this.m_focusMCs = new Vector.<MovieClip>();
         this.m_focusTimers = new Vector.<int>();
         this.m_stageFocus = new FrameTimer(1);
         this.m_stageFocus.finish();
         this.m_timedTargets = new Vector.<MovieClip>();
         this.m_forcedTargets = new Vector.<MovieClip>();
         this.m_timedTargetTimers = new Vector.<int>();
         this.m_timedTargetPoints = new Vector.<Point>();
         this.m_timedTargetPointTimers = new Vector.<int>();
      }
      
      public function get APIInstance() : SSF2Camera
      {
         return this.m_apiInstance;
      }
      
      private function init(parameters:VcamSettings) : void
      {
         this.m_settings = parameters;
         if(Boolean(this.m_cam) && Boolean(this.m_cam.parent))
         {
            this.m_cam.parent.removeChild(this.m_cam);
         }
         this.m_cam = this.STAGE.parent.addChild(new MovieClip()) as MovieClip;
         this.m_cam.graphics.beginFill(16711680,0.5);
         this.m_cam.graphics.drawRect(-Main.Width / 2,-Main.Height / 2,Main.Width,Main.Height);
         this.m_cam.graphics.endFill();
         this.m_cam.x = this.m_settings.x_start;
         this.m_cam.y = this.m_settings.y_start;
         this.m_cam.width = this.m_settings.width;
         this.m_cam.height = this.m_settings.height;
         this.cX = Main.Width / 2;
         this.cY = Main.Height / 2;
         this.sX = Main.Width;
         this.sY = Main.Height;
         this.oX = this.m_cam.parent.x;
         this.oY = this.m_cam.parent.y;
         this.m_cam.visible = false;
         this.m_mainTerrain = this.m_settings.mainTerrain;
         this.changeBG(this.m_settings.backgrounds);
         while(this.m_cam.width > this.m_mainTerrain.width)
         {
            this.m_cam.width -= Main.Width / Main.Width;
            this.m_cam.height -= Main.Height / Main.Width;
         }
         while(this.m_cam.height > this.m_mainTerrain.height)
         {
            this.m_cam.width -= Main.Width / Main.Width;
            this.m_cam.height -= Main.Height / Main.Width;
         }
         this.m_xbounds = new Array();
         this.m_ybounds = new Array();
         this.m_xtarget = 0;
         this.m_ytarget = 0;
         this.m_xspeed = 0;
         this.m_yspeed = 0;
         this.m_zoomSpeed = 0;
         this.m_shakeSpeed = 0;
         this.m_x_shakeSpeed = 0;
         this.m_y_shakeSpeed = 0;
         this.m_mode = 0;
         this.m_targets = new Vector.<MovieClip>();
      }
      
      public function reload(settings:VcamSettings) : void
      {
         this.killBGs();
         if(Boolean(this.m_mainTerrain.parent))
         {
            this.m_mainTerrain.parent.removeChild(this.m_mainTerrain);
         }
         if(Boolean(this.m_cam.parent))
         {
            this.m_cam.parent.removeChild(this.m_cam);
         }
         this.m_mainTerrain = null;
         this.m_cam = null;
         this.init(settings);
      }
      
      public function get Width() : Number
      {
         return this.m_cam.width;
      }
      
      public function get Height() : Number
      {
         return this.m_cam.height;
      }
      
      public function get OriginalWidth() : Number
      {
         return this.m_settings.width;
      }
      
      public function get OriginalHeight() : Number
      {
         return this.m_settings.height;
      }
      
      public function get X() : Number
      {
         return this.m_cam.x;
      }
      
      public function get Y() : Number
      {
         return this.m_cam.y;
      }
      
      public function get CornerX() : Number
      {
         return this.m_cam.x - this.m_cam.width / 2;
      }
      
      public function get CornerY() : Number
      {
         return this.m_cam.y - this.m_cam.height / 2;
      }
      
      public function set CornerX(value:Number) : void
      {
         this.m_cam.x = value + this.m_cam.width / 2;
      }
      
      public function set CornerY(value:Number) : void
      {
         this.m_cam.y = value + this.m_cam.height / 2;
      }
      
      public function get MainTerrain() : MovieClip
      {
         return this.m_mainTerrain;
      }
      
      public function get CamMC() : MovieClip
      {
         return this.m_cam;
      }
      
      public function get Mode() : int
      {
         return this.m_mode;
      }
      
      public function get Targets() : Vector.<MovieClip>
      {
         return this.m_targets;
      }
      
      public function get ForcedTargets() : Vector.<MovieClip>
      {
         return this.m_forcedTargets;
      }
      
      public function get TimedTargets() : Vector.<MovieClip>
      {
         return this.m_timedTargets;
      }
      
      public function get BGs() : Vector.<VcamBG>
      {
         return this.m_backgrounds;
      }
      
      public function get Settings() : VcamSettings
      {
         return this.m_settings;
      }
      
      public function get MinZoomHeight() : Number
      {
         return this.m_settings.minZoomHeight;
      }
      
      public function set MinZoomHeight(value:Number) : void
      {
         this.m_settings.minZoomHeight = value;
      }
      
      public function get CamEaseFactor() : Number
      {
         return this.m_settings.camEaseFactor;
      }
      
      public function set CamEaseFactor(value:Number) : void
      {
         this.m_settings.camEaseFactor = value;
      }
      
      public function get PanSpeedCap() : Number
      {
         return this.m_settings.panSpeedCap;
      }
      
      public function set PanSpeedCap(value:Number) : void
      {
         this.m_settings.panSpeedCap = value;
      }
      
      public function get ZoomSpeedCap() : Number
      {
         return this.m_settings.zoomSpeedCap;
      }
      
      public function set ZoomSpeedCap(value:Number) : void
      {
         this.m_settings.zoomSpeedCap = value;
      }
      
      public function forceSetMode(value:int) : void
      {
      }
      
      public function die() : void
      {
         this.killBGs();
         this.deleteAllTargets();
         if(this.m_cam != null && Boolean(this.m_cam.parent))
         {
            this.m_cam.parent.removeChild(this.m_cam);
         }
         if(Boolean(this.m_bg_holder) && Boolean(this.m_bg_holder.parent))
         {
            this.m_bg_holder.parent.removeChild(this.m_bg_holder);
         }
         if(Boolean(this.m_fg_holder) && Boolean(this.m_fg_holder.parent))
         {
            this.m_fg_holder.parent.removeChild(this.m_fg_holder);
         }
         this.m_dead = true;
      }
      
      public function changeBG(parameters:Vector.<VcamBGSettings>) : void
      {
         var i:* = undefined;
         if(!this.BG_CONTAINER)
         {
            return;
         }
         var currBGObj:VcamBG = null;
         if(this.m_bg_holder == null)
         {
            this.m_bg_holder = new MovieClip();
            this.BG_CONTAINER.addChildAt(this.m_bg_holder,0);
         }
         if(this.m_fg_holder == null)
         {
            this.m_fg_holder = new MovieClip();
            this.BG_CONTAINER.addChild(this.m_fg_holder);
         }
         while(this.m_backgrounds.length > 0)
         {
            this.m_backgrounds[0].dispose();
            this.m_backgrounds.splice(0,1);
         }
         for(i = 0; i < parameters.length; i++)
         {
            currBGObj = new VcamBG(ResourceManager.getLibraryMC(parameters[i].linkage_id),parameters[i]);
            currBGObj.settings.width_override = parameters[i].width_override || currBGObj.sprite.width;
            currBGObj.settings.height_override = parameters[i].height_override || currBGObj.sprite.height;
            if(currBGObj.settings.foreground)
            {
               this.m_fg_holder.addChild(currBGObj.sprite);
               this.m_backgrounds.push(currBGObj);
            }
            else
            {
               this.m_bg_holder.addChild(currBGObj.sprite);
               this.m_backgrounds.push(currBGObj);
            }
            if(currBGObj.settings.autoPanMultiplier)
            {
               currBGObj.settings.xPanMultiplier = (currBGObj.settings.width_override - Main.Width) / 2 / currBGObj.settings.width_override;
               currBGObj.settings.yPanMultiplier = (currBGObj.settings.height_override - Main.Height) / 2 / currBGObj.settings.height_override;
            }
            currBGObj.sprite.x = Main.Width / 2;
            currBGObj.sprite.y = Main.Height / 2;
            currBGObj.centX = currBGObj.sprite.x;
            currBGObj.centY = currBGObj.sprite.y;
            if(currBGObj.settings.horizontalScroll && currBGObj.settings.mode !== VcamBGSettings.BOUNDS_MODE)
            {
               currBGObj.horizontalScrollPair.push(ResourceManager.getLibraryMC(parameters[i].linkage_id));
               currBGObj.horizontalScrollPair.push(ResourceManager.getLibraryMC(parameters[i].linkage_id));
               currBGObj.horizontalScrollPair[0].x -= currBGObj.sprite.width;
               currBGObj.horizontalScrollPair[1].x += currBGObj.sprite.width;
               if(currBGObj.settings.foreground)
               {
                  this.m_fg_holder.addChild(currBGObj.horizontalScrollPair[0]);
                  this.m_fg_holder.addChild(currBGObj.horizontalScrollPair[1]);
               }
               else
               {
                  this.m_bg_holder.addChild(currBGObj.horizontalScrollPair[0]);
                  this.m_bg_holder.addChild(currBGObj.horizontalScrollPair[1]);
               }
            }
            if(currBGObj.settings.verticalScroll && currBGObj.settings.mode !== VcamBGSettings.BOUNDS_MODE)
            {
               currBGObj.verticalScrollPair.push(ResourceManager.getLibraryMC(parameters[i].linkage_id));
               currBGObj.verticalScrollPair.push(ResourceManager.getLibraryMC(parameters[i].linkage_id));
               currBGObj.verticalScrollPair[0].y -= currBGObj.sprite.height;
               currBGObj.verticalScrollPair[1].y += currBGObj.sprite.height;
               if(currBGObj.settings.foreground)
               {
                  this.m_fg_holder.addChild(currBGObj.verticalScrollPair[0]);
                  this.m_fg_holder.addChild(currBGObj.verticalScrollPair[1]);
               }
               else
               {
                  this.m_bg_holder.addChild(currBGObj.verticalScrollPair[0]);
                  this.m_bg_holder.addChild(currBGObj.verticalScrollPair[1]);
               }
            }
         }
         this.fixBG();
      }
      
      public function killBGs() : void
      {
         this.pauseBG();
         while(this.m_backgrounds.length > 0)
         {
            this.m_backgrounds[0].dispose();
            this.m_backgrounds[0] = null;
            this.m_backgrounds.splice(0,1);
         }
      }
      
      public function set Mode(value:int) : void
      {
         this.m_mode = value;
         if(this.m_mode < 0)
         {
            this.m_mode = Vcam.STAGE_MODE;
            this.maxZoomOut();
            this.fixBG();
         }
         else if(this.m_mode > 2)
         {
            this.m_mode = Vcam.NORMAL_MODE;
         }
      }
      
      public function fixBG() : void
      {
         for(var i:int = 0; i < this.m_backgrounds.length; i++)
         {
            this.m_backgrounds[i].sprite.x = Main.Width / 2;
            this.m_backgrounds[i].sprite.y = Main.Height / 2;
            this.m_backgrounds[i].centX = this.m_backgrounds[i].sprite.x;
            this.m_backgrounds[i].centY = this.m_backgrounds[i].sprite.y;
            this.m_backgrounds[i].diffX = (this.m_backgrounds[i].settings.width_override - Main.Width - 10) / 2;
            this.m_backgrounds[i].diffY = (this.m_backgrounds[i].settings.height_override - Main.Height - 10) / 2;
         }
      }
      
      public function camControl() : void
      {
         if(!this.m_cam || !this.m_cam.parent || this.m_mode === LOCK_MODE)
         {
            return;
         }
         var nsX:Number = this.sX / this.m_cam.width;
         var nsY:Number = this.sY / this.m_cam.height;
         this.m_cam.parent.x = this.cX - this.m_cam.x * nsX;
         this.m_cam.parent.y = this.cY - this.m_cam.y * nsY;
         this.m_cam.parent.scaleX = nsX;
         this.m_cam.parent.scaleY = nsY;
      }
      
      private function resetStage() : void
      {
         this.m_cam.parent.scaleX = 1;
         this.m_cam.parent.scaleY = 1;
         this.m_cam.parent.x = this.oX;
         this.m_cam.parent.y = this.oY;
      }
      
      private function getPositions() : void
      {
         var t:* = undefined;
         var targetmc:MovieClip = null;
         var points:Vector.<Point> = null;
         var i:int = 0;
         if(this.m_targets.length > 0)
         {
            this.m_xbounds = new Array();
            this.m_ybounds = new Array();
         }
         var cameraBounds:Rectangle = new Rectangle();
         var targetsToSearch:Vector.<MovieClip> = this.m_forcedTargets.length > 0 ? this.m_forcedTargets : (this.m_focusMCs.length > 0 ? this.m_focusMCs : this.m_targets);
         for(t in targetsToSearch)
         {
            targetmc = targetsToSearch[t];
            points = new Vector.<Point>();
            if(!(this.m_focusMCs.length > 0 && this.m_focusMCs.indexOf(targetmc) < 0 || !this.m_stageFocus.IsComplete))
            {
               if(targetmc)
               {
                  if(Boolean(targetmc.camOverride))
                  {
                     cameraBounds.x = targetmc.camOverride.x;
                     cameraBounds.y = targetmc.camOverride.y;
                     cameraBounds.width = targetmc.camOverride.width;
                     cameraBounds.height = targetmc.camOverride.height;
                     if(targetmc.transform.matrix.a < 0)
                     {
                        cameraBounds.x = -cameraBounds.x - targetmc.camOverride.width;
                     }
                  }
                  else
                  {
                     if(Boolean(targetmc.cam_width))
                     {
                        if(targetmc.transform.matrix.a < 0)
                        {
                           cameraBounds.x = -targetmc.cam_width / 2;
                           cameraBounds.width = targetmc.cam_width;
                           if(targetmc.cam_x_offset !== undefined)
                           {
                              cameraBounds.x -= targetmc.cam_x_offset;
                           }
                        }
                        else
                        {
                           cameraBounds.x = -targetmc.cam_width / 2;
                           cameraBounds.width = targetmc.cam_width;
                           if(targetmc.cam_x_offset !== undefined)
                           {
                              cameraBounds.x += targetmc.cam_x_offset;
                           }
                        }
                     }
                     if(Boolean(targetmc.cam_height))
                     {
                        cameraBounds.y = -targetmc.cam_height;
                        cameraBounds.height = targetmc.cam_height;
                        if(targetmc.cam_y_offset !== undefined)
                        {
                           cameraBounds.y += targetmc.cam_y_offset;
                        }
                     }
                  }
                  cameraBounds.x *= Utils.fastAbs(targetmc.scaleX);
                  cameraBounds.y *= Utils.fastAbs(targetmc.scaleY);
                  cameraBounds.width *= Utils.fastAbs(targetmc.scaleX);
                  cameraBounds.height *= Utils.fastAbs(targetmc.scaleY);
                  points.push(new Point(cameraBounds.x,cameraBounds.y));
                  points.push(new Point(cameraBounds.x + cameraBounds.width,cameraBounds.y));
                  points.push(new Point(cameraBounds.x + cameraBounds.width,cameraBounds.y + cameraBounds.height));
                  points.push(new Point(cameraBounds.x,cameraBounds.y + cameraBounds.height));
                  for(i = 0; i < points.length; i++)
                  {
                     if(targetmc != null)
                     {
                        if(targetmc.x + points[i].x < this.m_mainTerrain.x)
                        {
                           this.m_xbounds.push(this.m_mainTerrain.x + this.STAGE.x);
                        }
                        else if(targetmc.x + points[i].x > this.m_mainTerrain.x + this.m_mainTerrain.width)
                        {
                           this.m_xbounds.push(this.m_mainTerrain.x + this.m_mainTerrain.width + this.STAGE.x);
                        }
                        else
                        {
                           this.m_xbounds.push(targetmc.x + points[i].x + this.STAGE.x);
                        }
                        if(targetmc.y + points[i].y < this.m_mainTerrain.y)
                        {
                           this.m_ybounds.push(this.m_mainTerrain.y + this.STAGE.y);
                        }
                        else if(targetmc.y + points[i].y > this.m_mainTerrain.y + this.m_mainTerrain.height)
                        {
                           this.m_ybounds.push(this.m_mainTerrain.y + this.m_mainTerrain.height + this.STAGE.y);
                        }
                        else
                        {
                           this.m_ybounds.push(targetmc.y + points[i].y + this.STAGE.y);
                        }
                     }
                  }
               }
            }
         }
         if(this.m_focusMCs.length > 0)
         {
            for(i = 0; i < this.m_focusTimers.length; i++)
            {
               --this.m_focusTimers[i];
               if(this.m_focusTimers[i] < 0 || !this.m_focusMCs[i].parent)
               {
                  this.m_focusMCs.splice(i,1);
                  this.m_focusTimers.splice(i,1);
                  i--;
               }
            }
         }
         for(i = 0; i < this.m_timedTargets.length; i++)
         {
            --this.m_timedTargetTimers[i];
            if(this.m_timedTargetTimers[i] <= 0)
            {
               this.deleteTimedTarget(this.m_timedTargets[i]);
               i--;
            }
         }
         for(i = 0; i < this.m_timedTargetPoints.length; i++)
         {
            --this.m_timedTargetPointTimers[i];
            if(this.m_timedTargetPointTimers[i] <= 0)
            {
               this.deleteTimedTargetPoint(this.m_timedTargetPoints[i]);
               i--;
            }
            else
            {
               if(this.m_timedTargetPoints[i].x < this.m_mainTerrain.x)
               {
                  this.m_xbounds.push(this.m_mainTerrain.x + this.STAGE.x);
               }
               else if(this.m_timedTargetPoints[i].x > this.m_mainTerrain.x + this.m_mainTerrain.width)
               {
                  this.m_xbounds.push(this.m_mainTerrain.x + this.m_mainTerrain.width + this.STAGE.x);
               }
               else
               {
                  this.m_xbounds.push(this.m_timedTargetPoints[i].x + this.STAGE.x);
               }
               if(this.m_timedTargetPoints[i].y < this.m_mainTerrain.y)
               {
                  this.m_ybounds.push(this.m_mainTerrain.y + this.STAGE.y);
               }
               else if(this.m_timedTargetPoints[i].y > this.m_mainTerrain.y + this.m_mainTerrain.height)
               {
                  this.m_ybounds.push(this.m_mainTerrain.y + this.m_mainTerrain.height + this.STAGE.y);
               }
               else
               {
                  this.m_ybounds.push(this.m_timedTargetPoints[i].y + this.STAGE.y);
               }
            }
         }
         if(!this.m_stageFocus.IsComplete)
         {
            this.m_stageFocus.tick();
            this.m_xbounds.push(this.m_mainTerrain.x + this.STAGE.x);
            this.m_xbounds.push(this.m_mainTerrain.x + this.m_mainTerrain.width + this.STAGE.x);
            this.m_ybounds.push(this.m_mainTerrain.y + this.STAGE.y);
            this.m_ybounds.push(this.m_mainTerrain.y + this.m_mainTerrain.height + this.STAGE.y);
         }
         this.m_xbounds.sort(Array.NUMERIC);
         this.m_ybounds.sort(Array.NUMERIC);
      }
      
      public function targetCenterStage() : void
      {
         this.m_xbounds.push(this.m_mainTerrain.x + this.m_mainTerrain.width / 2);
         this.m_ybounds.push(this.m_mainTerrain.y + this.m_mainTerrain.height / 2);
      }
      
      public function targetSelf() : void
      {
         this.m_xbounds.push(this.m_cam.x);
         this.m_ybounds.push(this.m_cam.y);
      }
      
      public function setStageFocus(length:int) : void
      {
         this.m_stageFocus.reset();
         this.m_stageFocus.MaxTime = length;
      }
      
      public function removeStageFocus() : void
      {
         this.m_stageFocus.finish();
      }
      
      public function addZoomFocus(mc:MovieClip, length:int) : void
      {
         if(mc != null && this.m_focusMCs.indexOf(mc) < 0)
         {
            this.m_focusMCs.push(mc);
            this.m_focusTimers.push(length);
         }
      }
      
      public function removeZoomFocus(mc:MovieClip) : void
      {
         if(mc == null)
         {
            return;
         }
         var location:int = this.m_focusMCs.indexOf(mc);
         if(location >= 0)
         {
            this.m_focusMCs.splice(location,1);
            this.m_focusTimers.splice(location,1);
         }
      }
      
      public function removeAllZoomFocus() : void
      {
         while(this.m_focusMCs.length > 0)
         {
            this.m_focusMCs.splice(0,1);
            this.m_focusTimers.splice(0,1);
         }
      }
      
      public function addTarget(target:MovieClip) : void
      {
         if(target != null && this.m_targets.indexOf(target) < 0)
         {
            this.m_targets.push(target);
         }
      }
      
      public function addTargets(targets:Vector.<MovieClip>) : void
      {
         var t:* = undefined;
         for(t in targets)
         {
            if(targets[t] != null && this.m_targets.indexOf(targets[t]) < 0)
            {
               this.m_targets.push(targets[t]);
            }
         }
      }
      
      public function addTimedTarget(target:MovieClip, length:int) : void
      {
         var index:int = this.m_timedTargets.indexOf(target);
         if(index < 0)
         {
            this.addTarget(target);
            this.m_timedTargets.push(target);
            this.m_timedTargetTimers.push(length);
         }
         else
         {
            this.m_timedTargetTimers[index] = length;
         }
      }
      
      public function addTimedTargetPoint(target:Point, length:int) : void
      {
         var index:int = this.m_timedTargetPoints.indexOf(target);
         if(index < 0)
         {
            this.m_timedTargetPoints.push(target);
            this.m_timedTargetPointTimers.push(length);
         }
         else
         {
            this.m_timedTargetPointTimers[index] = length;
         }
      }
      
      public function addForcedTarget(target:MovieClip) : void
      {
         var index:int = this.m_forcedTargets.indexOf(target);
         if(index < 0)
         {
            this.m_forcedTargets.push(target);
         }
      }
      
      public function hasTarget(target:MovieClip) : Boolean
      {
         return this.m_targets.indexOf(target) >= 0;
      }
      
      public function hasTargets(targets:Vector.<MovieClip>) : Boolean
      {
         var t:* = undefined;
         var ot:* = undefined;
         var found:Boolean = false;
         for(t in targets)
         {
            for(ot in this.m_targets)
            {
               if(this.m_targets[ot] != null && this.m_targets[ot] == targets[t])
               {
                  found = true;
               }
            }
            if(!found)
            {
               return false;
            }
         }
         return true;
      }
      
      public function deleteTarget(target:MovieClip) : void
      {
         if(target != null && this.m_targets.indexOf(target) >= 0)
         {
            this.m_targets.splice(this.m_targets.indexOf(target),1);
         }
      }
      
      public function deleteTargets(targets:Vector.<MovieClip>) : void
      {
         var t:* = undefined;
         var index:int = 0;
         for(t in targets)
         {
            index = this.m_targets.indexOf(targets[t]);
            if(index >= 0)
            {
               this.m_targets.splice(index,1);
            }
         }
      }
      
      public function deleteTimedTarget(target:MovieClip) : void
      {
         var index:int = this.m_timedTargets.indexOf(target);
         if(index >= 0)
         {
            this.deleteTarget(target);
            this.m_timedTargets.splice(index,1);
            this.m_timedTargetTimers.splice(index,1);
         }
      }
      
      public function deleteForcedTarget(target:MovieClip) : void
      {
         var index:int = this.m_forcedTargets.indexOf(target);
         if(index >= 0)
         {
            this.m_forcedTargets.splice(index,1);
         }
      }
      
      public function deleteTimedTargetPoint(target:Point) : void
      {
         var index:int = this.m_timedTargetPoints.indexOf(target);
         if(index >= 0)
         {
            this.m_timedTargetPoints.splice(index,1);
            this.m_timedTargetPointTimers.splice(index,1);
         }
      }
      
      public function deleteAllTargets() : void
      {
         this.m_targets.splice(0,this.m_targets.length);
      }
      
      public function followTargets() : void
      {
         if(this.m_xbounds.length == 0 || this.m_xbounds.length == 0)
         {
         }
         this.m_xtarget = this.m_xbounds[0] + Math.sqrt(Math.pow(this.m_xbounds[0] - this.m_xbounds[this.m_xbounds.length - 1],2)) / 2;
         this.m_ytarget = this.m_ybounds[0] + Math.sqrt(Math.pow(this.m_ybounds[0] - this.m_ybounds[this.m_ybounds.length - 1],2)) / 2;
         this.m_xspeed = (this.m_xtarget - this.m_cam.x) / this.m_settings.camEaseFactor;
         this.m_yspeed = (this.m_ytarget - this.m_cam.y) / this.m_settings.camEaseFactor;
         if(Utils.fastAbs(this.m_xspeed) < 1 && Utils.fastAbs(this.m_yspeed) < 1)
         {
            this.m_xspeed = 0;
            this.m_yspeed = 0;
         }
         if(this.m_xspeed != 0 && this.m_settings.panSpeedCap !== 0)
         {
            this.m_xspeed = this.m_xspeed > 0 ? Math.min(this.m_xspeed,this.m_settings.panSpeedCap) : Math.max(this.m_xspeed,-this.m_settings.panSpeedCap);
         }
         if(this.m_yspeed != 0 && this.m_settings.panSpeedCap !== 0)
         {
            this.m_yspeed = this.m_yspeed > 0 ? Math.min(this.m_yspeed,this.m_settings.panSpeedCap) : Math.max(this.m_yspeed,-this.m_settings.panSpeedCap);
         }
         this.m_cam.x += this.m_xspeed;
         this.m_cam.y += this.m_yspeed;
         this.forceInBounds();
         this.syncPositions();
      }
      
      public function forceTarget() : void
      {
         if(this.m_xbounds.length == 0 || this.m_xbounds.length == 0)
         {
         }
         this.m_xtarget = this.m_xbounds[0] + Math.sqrt(Math.pow(this.m_xbounds[0] - this.m_xbounds[this.m_xbounds.length - 1],2)) / 2;
         this.m_ytarget = this.m_ybounds[0] + Math.sqrt(Math.pow(this.m_ybounds[0] - this.m_ybounds[this.m_ybounds.length - 1],2)) / 2;
         this.m_xspeed = 0;
         this.m_yspeed = 0;
         this.m_cam.x = this.m_xtarget;
         this.m_cam.y = this.m_ytarget;
         this.forceInBounds();
         this.syncPositions();
      }
      
      public function zoom() : void
      {
         var targetHeight:Number = NaN;
         var targetWidth:Number = NaN;
         var xDiff:Number = NaN;
         var yDiff:Number = NaN;
         if(this.m_xbounds.length == 0 || this.m_xbounds.length == 0)
         {
         }
         if(this.m_ybounds.length > 0)
         {
            targetHeight = this.m_settings.minZoomHeight;
            targetWidth = targetHeight * (this.m_settings.width / this.m_settings.height);
            xDiff = this.m_xbounds[this.m_xbounds.length - 1] - this.m_xbounds[0];
            yDiff = this.m_ybounds[this.m_ybounds.length - 1] - this.m_ybounds[0];
            if(xDiff < targetWidth)
            {
               xDiff = targetWidth;
            }
            if(yDiff < targetHeight)
            {
               yDiff = targetHeight;
            }
            if(xDiff / yDiff > this.m_settings.width / this.m_settings.height)
            {
               yDiff = xDiff * (this.m_settings.height / this.m_settings.width);
            }
            else
            {
               xDiff = yDiff * (this.m_settings.width / this.m_settings.height);
            }
            targetWidth = (xDiff - this.m_cam.width) / this.m_settings.camZoomFactor;
            targetHeight = (yDiff - this.m_cam.height) / this.m_settings.camZoomFactor;
            if(targetWidth > this.m_settings.zoomSpeedCap && this.m_settings.zoomSpeedCap !== 0)
            {
               targetWidth = this.m_settings.zoomSpeedCap;
               targetHeight = targetWidth * (this.m_settings.height / this.m_settings.width);
            }
            if(targetHeight > this.m_settings.zoomSpeedCap && this.m_settings.zoomSpeedCap !== 0)
            {
               targetHeight = this.m_settings.zoomSpeedCap;
               targetWidth = targetHeight * (this.m_settings.width / this.m_settings.height);
            }
            if(Utils.fastAbs(targetWidth) < 1 && Utils.fastAbs(targetHeight) < 1)
            {
               targetWidth = 0;
               targetHeight = 0;
            }
         }
         if(this.m_cam.width + targetWidth < this.m_mainTerrain.width && this.m_cam.height + targetHeight < this.m_mainTerrain.height)
         {
            this.m_cam.width += targetWidth;
            this.m_cam.height += targetHeight;
            this.syncPositions();
         }
      }
      
      public function zoomIn() : void
      {
         if(this.m_cam.width > this.m_settings.width / 10)
         {
            this.m_cam.width += -15 * 1;
            this.m_cam.height += -15 * 0.5625;
            this.forceInBounds();
            this.syncPositions();
            this.camControl();
         }
      }
      
      public function zoomOut() : void
      {
         if(this.m_cam.height < this.m_mainTerrain.height)
         {
            this.m_cam.width += 15 * 1;
            this.m_cam.height += 15 * 0.5625;
            this.forceInBounds();
            this.syncPositions();
            this.camControl();
         }
      }
      
      public function shake(s:Number) : void
      {
         this.m_shakeSpeed = s;
         if(this.m_shakeSpeed > 20)
         {
            this.m_shakeSpeed = 20;
         }
      }
      
      public function lightFlash(fade:Boolean = true) : void
      {
         GameController.stageData.lightFlash(fade);
      }
      
      private function effects() : void
      {
         var x_temp:Number = NaN;
         var y_temp:Number = NaN;
         if(this.m_shakeSpeed > 0)
         {
            x_temp = Math.round(Utils.safeRandom() * (this.m_shakeSpeed * 2) - this.m_shakeSpeed);
            y_temp = Math.round(Utils.safeRandom() * (this.m_shakeSpeed * 2) - this.m_shakeSpeed);
            this.m_cam.x += x_temp;
            this.m_cam.y += y_temp;
            this.syncPositions();
            --this.m_shakeSpeed;
         }
      }
      
      public function forceInBounds() : void
      {
         if(!this.m_stageFocus.IsComplete)
         {
            return;
         }
         var ratio:Number = Main.Width / Main.Height;
         if(this.m_cam.height > this.m_mainTerrain.height)
         {
            this.m_cam.height = this.m_mainTerrain.height;
            this.m_cam.width = this.m_mainTerrain.height * ratio;
         }
         if(this.m_cam.width > this.m_mainTerrain.width)
         {
            this.m_cam.width = this.m_mainTerrain.width;
            this.m_cam.height = this.m_mainTerrain.width * (1 / ratio);
         }
         if(this.CornerX < this.m_mainTerrain.x + this.STAGE.x)
         {
            this.CornerX = this.m_mainTerrain.x + this.STAGE.x;
         }
         if(this.CornerX + this.m_cam.width > this.m_mainTerrain.x + this.m_mainTerrain.width + this.STAGE.x)
         {
            this.CornerX = this.m_mainTerrain.x + this.m_mainTerrain.width - this.m_cam.width + this.STAGE.x;
         }
         if(this.CornerY < this.m_mainTerrain.y + this.STAGE.y)
         {
            this.CornerY = this.m_mainTerrain.y + this.STAGE.y;
         }
         if(this.CornerY + this.m_cam.height > this.m_mainTerrain.y + this.m_mainTerrain.height + this.STAGE.y)
         {
            this.CornerY = this.m_mainTerrain.y + this.m_mainTerrain.height - this.m_cam.height + this.STAGE.y;
         }
      }
      
      public function syncPositions() : void
      {
         var multiplier:int = 0;
         for(var i:int = 0; i < this.m_backgrounds.length; i++)
         {
            if(this.m_backgrounds[i].settings.mode === VcamBGSettings.PAN_MODE)
            {
               if(this.m_backgrounds[i].settings.xPanMultiplier != 0 && !this.m_backgrounds[i].settings.horizontalPanLock)
               {
                  if(!this.m_backgrounds[i].settings.horizontalScroll)
                  {
                     this.m_backgrounds[i].sprite.x = this.m_backgrounds[i].centX;
                     multiplier = this.m_backgrounds[i].settings.xPanMultiplier < 0 ? -1 : 1;
                     this.m_backgrounds[i].sprite.x += multiplier * (this.m_mainTerrain.x + this.STAGE.x + this.m_mainTerrain.width / 2 - this.m_cam.x) * Utils.fastAbs(this.m_backgrounds[i].settings.xPanMultiplier);
                  }
                  else
                  {
                     this.m_backgrounds[i].sprite.x = this.m_backgrounds[i].centX;
                     multiplier = this.m_backgrounds[i].settings.xPanMultiplier < 0 ? -1 : 1;
                     this.m_backgrounds[i].sprite.x += multiplier * (this.m_mainTerrain.x + this.STAGE.x + this.m_mainTerrain.width / 2 - this.m_cam.x) * Utils.fastAbs(this.m_backgrounds[i].settings.xPanMultiplier) % this.m_backgrounds[i].sprite.width;
                     this.m_backgrounds[i].horizontalScrollPair[0].sprite.x = this.m_backgrounds[i].sprite.x - this.m_backgrounds[i].settings.width_override[i];
                     this.m_backgrounds[i].horizontalScrollPair[1].sprite.x = this.m_backgrounds[i].sprite.x + this.m_backgrounds[i].settings.width_override[i];
                  }
               }
               if(this.m_backgrounds[i].settings.yPanMultiplier != 0 && !this.m_backgrounds[i].settings.verticalPanLock)
               {
                  if(!this.m_backgrounds[i].settings.verticalScroll)
                  {
                     this.m_backgrounds[i].sprite.y = this.m_backgrounds[i].centY;
                     multiplier = this.m_backgrounds[i].settings.yPanMultiplier < 0 ? -1 : 1;
                     this.m_backgrounds[i].sprite.y += multiplier * (this.m_mainTerrain.y + this.STAGE.y + this.m_mainTerrain.height / 2 - this.m_cam.y) * Utils.fastAbs(this.m_backgrounds[i].settings.yPanMultiplier);
                  }
                  else
                  {
                     this.m_backgrounds[i].sprite.y = this.m_backgrounds[i].centY;
                     multiplier = this.m_backgrounds[i].settings.yPanMultiplier < 0 ? -1 : 1;
                     this.m_backgrounds[i].sprite.y += multiplier * (this.m_mainTerrain.y + this.STAGE.y + this.m_mainTerrain.height / 2 - this.m_cam.y) * Utils.fastAbs(this.m_backgrounds[i].settings.yPanMultiplier) % this.m_backgrounds[i].sprite.height;
                     this.m_backgrounds[i].verticalScrollPair[0].sprite.y = this.m_backgrounds[i].sprite.y - this.m_backgrounds[i].settings.height_override[i];
                     this.m_backgrounds[i].verticalScrollPair[1].sprite.y = this.m_backgrounds[i].sprite.y + this.m_backgrounds[i].settings.height_override[i];
                  }
               }
               if(this.m_backgrounds[i].settings.horizontalScroll)
               {
                  this.m_backgrounds[i].horizontalScrollPair[0].y = this.m_backgrounds[i].sprite.y;
                  this.m_backgrounds[i].horizontalScrollPair[1].y = this.m_backgrounds[i].sprite.y;
               }
               if(this.m_backgrounds[i].settings.verticalScroll)
               {
                  this.m_backgrounds[i].verticalScrollPair[0].x = this.m_backgrounds[i].sprite.x;
                  this.m_backgrounds[i].verticalScrollPair[1].x = this.m_backgrounds[i].sprite.x;
               }
            }
            else if(this.m_backgrounds[i].settings.mode === VcamBGSettings.BOUNDS_MODE)
            {
               if(this.m_backgrounds[i].diffX > 0 && !this.m_backgrounds[i].settings.horizontalPanLock)
               {
                  this.m_backgrounds[i].sprite.x = this.m_backgrounds[i].centX + (this.m_mainTerrain.x + this.STAGE.x + this.m_mainTerrain.width / 2 - this.m_cam.x) / this.m_mainTerrain.width * this.m_backgrounds[i].diffX / (this.m_backgrounds.length - i);
               }
               if(this.m_backgrounds[i].diffY > 0 && !this.m_backgrounds[i].settings.verticalPanLock)
               {
                  this.m_backgrounds[i].sprite.y = this.m_backgrounds[i].centY + (this.m_mainTerrain.y + this.STAGE.y + this.m_mainTerrain.height / 2 - this.m_cam.y) / this.m_mainTerrain.height * this.m_backgrounds[i].diffY / (this.m_backgrounds.length - i);
               }
            }
         }
      }
      
      public function panLeft(speed:Number = 15) : void
      {
         if(this.CornerX > this.m_mainTerrain.x + this.STAGE.x)
         {
            this.m_cam.x -= speed;
            this.syncPositions();
            this.camControl();
         }
      }
      
      public function panRight(speed:Number = 15) : void
      {
         if(this.CornerX + this.m_cam.width < this.m_mainTerrain.x + this.STAGE.x + this.m_mainTerrain.width)
         {
            this.m_cam.x += speed;
            this.syncPositions();
            this.camControl();
         }
      }
      
      public function panUp(speed:Number = 15) : void
      {
         if(this.CornerY > this.m_mainTerrain.y + this.STAGE.y)
         {
            this.m_cam.y -= speed;
            this.syncPositions();
            this.camControl();
         }
      }
      
      public function panDown(speed:Number = 15) : void
      {
         if(this.CornerY + this.m_cam.height < this.m_mainTerrain.y + this.STAGE.y + this.m_mainTerrain.height)
         {
            this.m_cam.y += speed;
            this.syncPositions();
            this.camControl();
         }
      }
      
      public function maxZoomOut() : void
      {
         this.m_cam.height = this.m_mainTerrain.height;
         this.m_cam.width = this.m_cam.height * (this.m_settings.width / this.m_settings.height);
         this.m_cam.x = this.m_mainTerrain.x + this.m_mainTerrain.width / 2 + this.STAGE.x;
         this.m_cam.y = this.m_mainTerrain.y + this.m_mainTerrain.height / 2 + this.STAGE.y;
      }
      
      private function checkMode() : void
      {
         if(this.m_mode == Vcam.STAGE_MODE)
         {
            this.maxZoomOut();
         }
         else if(this.m_mode == Vcam.ZOOM_MODE)
         {
            this.m_cam.width = this.m_settings.width / 3;
            this.m_cam.height = this.m_settings.height / 3;
         }
         else if(this.m_mode == Vcam.FREE_MODE)
         {
            if(SaveData.Controllers[3].IsDown(SaveData.Controllers[3]._BUTTON2) && !SaveData.Controllers[3].IsDown(SaveData.Controllers[3]._BUTTON1))
            {
               this.zoomIn();
            }
            else if(SaveData.Controllers[3].IsDown(SaveData.Controllers[3]._BUTTON1) && !SaveData.Controllers[3].IsDown(SaveData.Controllers[3]._BUTTON2))
            {
               this.zoomOut();
            }
            if(SaveData.Controllers[3].IsDown(SaveData.Controllers[3]._LEFT) !== SaveData.Controllers[3].IsDown(SaveData.Controllers[3]._RIGHT))
            {
               if(SaveData.Controllers[3].IsDown(SaveData.Controllers[3]._LEFT))
               {
                  if(this.m_xspeed > 0)
                  {
                     this.m_xspeed = 0;
                  }
                  this.panLeft(this.m_cam.scaleX * -this.m_xspeed);
                  this.m_xspeed -= FREE_CAM_ACCEL;
                  if(this.m_xspeed < -FREE_CAM_MAX_SPEED)
                  {
                     this.m_xspeed = -FREE_CAM_MAX_SPEED;
                  }
               }
               else if(SaveData.Controllers[3].IsDown(SaveData.Controllers[3]._RIGHT))
               {
                  if(this.m_xspeed < 0)
                  {
                     this.m_xspeed = 0;
                  }
                  this.panRight(this.m_cam.scaleX * this.m_xspeed);
                  this.m_xspeed += FREE_CAM_ACCEL;
                  if(this.m_xspeed > FREE_CAM_MAX_SPEED)
                  {
                     this.m_xspeed = FREE_CAM_MAX_SPEED;
                  }
               }
            }
            else
            {
               this.m_xspeed = 0;
            }
            if(SaveData.Controllers[3].IsDown(SaveData.Controllers[3]._DOWN) !== SaveData.Controllers[3].IsDown(SaveData.Controllers[3]._UP))
            {
               if(SaveData.Controllers[3].IsDown(SaveData.Controllers[3]._DOWN))
               {
                  if(this.m_yspeed < 0)
                  {
                     this.m_yspeed = 0;
                  }
                  this.panDown(this.m_cam.scaleX * this.m_yspeed);
                  this.m_yspeed += FREE_CAM_ACCEL;
                  if(this.m_yspeed > FREE_CAM_MAX_SPEED)
                  {
                     this.m_yspeed = FREE_CAM_MAX_SPEED;
                  }
               }
               else if(SaveData.Controllers[3].IsDown(SaveData.Controllers[3]._UP))
               {
                  if(this.m_yspeed > 0)
                  {
                     this.m_yspeed = 0;
                  }
                  this.panUp(this.m_cam.scaleX * -this.m_yspeed);
                  this.m_yspeed -= FREE_CAM_ACCEL;
                  if(this.m_yspeed < -FREE_CAM_MAX_SPEED)
                  {
                     this.m_yspeed = -FREE_CAM_MAX_SPEED;
                  }
               }
            }
            else
            {
               this.m_yspeed = 0;
            }
         }
      }
      
      public function pauseBG() : void
      {
         for(var i:int = 0; i < this.m_backgrounds.length; i++)
         {
            this.m_backgrounds[i].sprite.stop();
            Utils.recursiveMovieClipPlay(this.m_backgrounds[i].sprite,false,false);
         }
      }
      
      public function playBG() : void
      {
         for(var i:int = 0; i < this.m_backgrounds.length; i++)
         {
            this.m_backgrounds[i].sprite.play();
            Utils.recursiveMovieClipPlay(this.m_backgrounds[i].sprite,true,false);
         }
      }
      
      public function showBGs() : void
      {
         for(var i:int = 0; i < this.m_backgrounds.length; i++)
         {
            this.m_backgrounds[i].sprite.visible = true;
         }
      }
      
      public function hideBGs() : void
      {
         for(var i:int = 0; i < this.m_backgrounds.length; i++)
         {
            this.m_backgrounds[i].sprite.visible = false;
         }
      }
      
      public function gotoAndPlayBG(frame:String) : void
      {
         var i:int = 0;
         if(frame != null)
         {
            for(i = 0; i < this.m_backgrounds.length; i++)
            {
               Utils.tryToGotoAndPlay(this.m_backgrounds[i].sprite,frame);
            }
         }
      }
      
      public function nextFrameBG() : void
      {
         for(var i:int = 0; i < this.m_backgrounds.length; i++)
         {
            Utils.advanceFrame(this.m_backgrounds[i].sprite);
            Utils.recursiveMovieClipPlay(this.m_backgrounds[i].sprite,true);
         }
      }
      
      public function darken() : void
      {
         GameController.stageData.HudRef.darkenCamera();
      }
      
      public function killDarkener(immediate:Boolean = false) : void
      {
         if(immediate)
         {
            GameController.stageData.HudRef.killCameraDarkener();
         }
         else
         {
            GameController.stageData.HudRef.brightenCamera();
         }
      }
      
      public function PERFORMALL() : void
      {
         if(!this.m_dead)
         {
            this.camControl();
            if(this.m_mode == Vcam.STAGE_MODE)
            {
               this.checkMode();
               return;
            }
            this.getPositions();
            if(this.m_mode !== FREE_MODE)
            {
               this.zoom();
               this.followTargets();
            }
            this.checkMode();
            this.effects();
         }
      }
   }
}

