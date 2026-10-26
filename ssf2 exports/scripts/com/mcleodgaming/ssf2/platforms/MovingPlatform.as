package com.mcleodgaming.ssf2.platforms
{
   import com.mcleodgaming.ssf2.api.*;
   import com.mcleodgaming.ssf2.enemies.*;
   import com.mcleodgaming.ssf2.engine.*;
   import com.mcleodgaming.ssf2.util.*;
   import flash.display.MovieClip;
   import flash.geom.Point;
   
   public class MovingPlatform extends Platform
   {
      
      protected var m_foregroundPiece:MovieClip;
      
      protected var m_foregroundPoint:Point;
      
      protected var m_disabled:Boolean;
      
      protected var m_ledges:Vector.<MovieClip>;
      
      protected var m_ledgePoints:Vector.<Point>;
      
      protected var m_ledgePointsPrev:Vector.<Point>;
      
      protected var m_findLedges:Boolean;
      
      protected var m_xSpeed:Number;
      
      protected var m_ySpeed:Number;
      
      private var m_moveTimer:FrameTimer;
      
      private var m_waitTimer:FrameTimer;
      
      private var m_wait:Boolean;
      
      private var m_platformMovement:Vector.<PlatformMovement>;
      
      private var m_moveIndex:int;
      
      private var m_xLoc:Number;
      
      private var m_yLoc:Number;
      
      public function MovingPlatform(mc:MovieClip, stageData:StageData, instance:String = "ground", stats:Object = null)
      {
         if(!stats)
         {
            stats = {};
         }
         if(!stats.classAPI)
         {
            stats.classAPI = stageData.BASE_CLASSES.SSF2Platform;
         }
         m_apiInstance = new SSF2Platform(stats.classAPI,this);
         if(!mc)
         {
            mc = ResourceManager.getLibraryMC(m_apiInstance.getOwnStats().linkage_id);
            stageData.StageRef.addChild(mc);
         }
         super(mc,stageData,instance);
         this.m_xSpeed = 0;
         this.m_ySpeed = 0;
         this.m_disabled = false;
         this.m_ledges = new Vector.<MovieClip>();
         this.m_ledgePoints = new Vector.<Point>();
         this.m_ledgePointsPrev = new Vector.<Point>();
         this.m_foregroundPiece = null;
         this.m_foregroundPoint = new Point();
         this.m_findLedges = Boolean(m_apiInstance) && typeof m_apiInstance.getOwnStats().attachLedges !== "undefined" ? Boolean(m_apiInstance.getOwnStats().attachLedges) : true;
         this.m_platformMovement = new Vector.<PlatformMovement>();
         this.m_moveTimer = new FrameTimer(1);
         this.m_waitTimer = new FrameTimer(1);
         this.m_xSpeed = 0;
         this.m_ySpeed = 0;
         for(var i:int = 1; Boolean(m_platform["movement" + i]); i++)
         {
            this.addMovement(m_platform["movement" + i]);
         }
         this.m_moveIndex = Boolean(m_platform.startIndex) ? int(m_platform.startIndex) : this.m_moveIndex;
         this.m_wait = false;
         this.m_xLoc = m_platform.x;
         this.m_yLoc = m_platform.y;
         if(this.m_foregroundPiece != null)
         {
            this.m_foregroundPoint.x = this.m_foregroundPiece.x;
            this.m_foregroundPoint.y = this.m_foregroundPiece.y;
         }
         this.findLedges();
      }
      
      public function get syncPlatform() : String
      {
         return Boolean(m_collisionClip.syncPlatform) ? m_collisionClip.syncPlatform : null;
      }
      
      public function set syncPlatform(value:String) : void
      {
         m_collisionClip.syncPlatform = value;
      }
      
      public function get LedgeList() : Vector.<MovieClip>
      {
         return this.m_ledges;
      }
      
      override public function set X(value:Number) : void
      {
         super.X = value;
         this.syncForeground();
      }
      
      override public function set Y(value:Number) : void
      {
         super.Y = value;
         this.syncForeground();
      }
      
      public function getXSpeed() : Number
      {
         return this.m_xSpeed;
      }
      
      public function setXSpeed(value:Number) : void
      {
         this.m_xSpeed = value;
      }
      
      public function getYSpeed() : Number
      {
         return this.m_ySpeed;
      }
      
      public function setYSpeed(value:Number) : void
      {
         this.m_ySpeed = value;
      }
      
      override public function set foreground(value:String) : void
      {
         m_collisionClipContainer.foreground = value;
         this.findForegroundPieces();
      }
      
      public function addMovement(movement:Object) : void
      {
         var movementInstance:PlatformMovement = new PlatformMovement();
         movementInstance.xAccel = Boolean(movement.xAccel) ? Number(movement.xAccel) : 0;
         movementInstance.xDecel = Boolean(movement.xDecel) ? Number(movement.xDecel) : 0;
         movementInstance.yAccel = Boolean(movement.yAccel) ? Number(movement.yAccel) : 0;
         movementInstance.yDecel = Boolean(movement.yDecel) ? Number(movement.yDecel) : 0;
         movementInstance.moveTime = Boolean(movement.moveTime) ? int(movement.moveTime) : 0;
         movementInstance.waitTime = Boolean(movement.waitTime) ? int(movement.waitTime) : 0;
         movementInstance.xSpeed = Boolean(movement.xSpeed) ? Number(movement.xSpeed) : 0;
         movementInstance.ySpeed = Boolean(movement.ySpeed) ? Number(movement.ySpeed) : 0;
         movementInstance.fallthrough = movement.fallthrough !== undefined ? Boolean(movement.fallthrough) : fallthrough;
         movementInstance.noDropThrough = movement.noDropThrough !== undefined ? Boolean(movement.noDropThrough) : noDropThrough;
         movementInstance.camFocus = movement.camFocus !== undefined ? Boolean(movement.camFocus) : false;
         this.m_platformMovement.push(movementInstance);
         if(this.m_platformMovement.length === 1)
         {
            this.m_wait = false;
            this.m_moveIndex = 0;
            this.m_moveTimer.MaxTime = movementInstance.moveTime;
            this.m_moveTimer.MaxTime = movementInstance.moveTime;
            this.m_waitTimer.reset();
            this.m_waitTimer.reset();
            this.m_xSpeed = movementInstance.xAccel > 0 ? 0 : movementInstance.xSpeed;
            this.m_ySpeed = movementInstance.yAccel > 0 ? 0 : movementInstance.ySpeed;
            if(movementInstance.camFocus)
            {
               STAGEDATA.CamRef.addForcedTarget(m_platform);
            }
         }
      }
      
      public function clearMovement() : void
      {
         this.m_platformMovement.splice(0,this.m_platformMovement.length);
      }
      
      private function incrementMovement() : void
      {
         ++this.m_moveIndex;
         if(this.m_moveIndex >= this.m_platformMovement.length)
         {
            this.m_moveIndex = 0;
         }
      }
      
      public function extraHitTests(x_offset:Number, y_offset:Number, caller:InteractiveSprite) : Boolean
      {
         if(!m_apiInstance || !m_apiInstance.instance)
         {
            return false;
         }
         return SSF2Platform(m_apiInstance).extraHitTests(x_offset,y_offset,caller);
      }
      
      public function updateStart(point:Point) : void
      {
         m_x_start = point.x;
         m_y_start = point.y;
      }
      
      public function setForegroundPiece(mc:MovieClip) : void
      {
         this.m_foregroundPiece = mc;
         this.m_foregroundPoint.x = this.m_foregroundPiece.x;
         this.m_foregroundPoint.y = this.m_foregroundPiece.y;
      }
      
      public function findForegroundPieces() : void
      {
         var i:int = 0;
         var found:Boolean = false;
         var foregroundMC:MovieClip = null;
         var curObject:MovieClip = null;
         if(Boolean(foreground))
         {
            i = 0;
            found = false;
            foregroundMC = STAGEDATA.StageParentRef;
            curObject = null;
            for(i = 0; i < foregroundMC.numChildren; i++)
            {
               if(foregroundMC.getChildAt(i) is MovieClip)
               {
                  curObject = MovieClip(foregroundMC.getChildAt(i));
                  if(Boolean(curObject.foreground) && curObject.foreground == foreground)
                  {
                     this.m_foregroundPiece = curObject;
                     found = true;
                     break;
                  }
               }
            }
            if(!found)
            {
               foregroundMC = STAGEDATA.StageFG;
               i = 0;
               while(foregroundMC != null && i < foregroundMC.numChildren)
               {
                  if(foregroundMC.getChildAt(i) is MovieClip)
                  {
                     curObject = MovieClip(foregroundMC.getChildAt(i));
                     if(Boolean(curObject.foreground) && curObject.foreground == foreground)
                     {
                        this.m_foregroundPiece = curObject;
                        break;
                     }
                  }
                  i++;
               }
            }
            if(this.m_foregroundPiece != null)
            {
               this.m_foregroundPoint.x = this.m_foregroundPiece.x;
               this.m_foregroundPoint.y = this.m_foregroundPiece.y;
            }
         }
      }
      
      public function findLedges() : void
      {
         var ledges1:Vector.<MovieClip> = null;
         var ledges2:Vector.<MovieClip> = null;
         var tmpPoint:Point = null;
         var i:int = 0;
         if(this.m_findLedges)
         {
            ledges1 = STAGEDATA.getLedges_L();
            ledges2 = STAGEDATA.getLedges_R();
            tmpPoint = new Point();
            for(i = 0; i < ledges1.length; i++)
            {
               if(Boolean(ledges1[i].syncPlatform && this.syncPlatform) && Boolean(ledges1[i].syncPlatform == this.syncPlatform) || !ledges1[i].syncPlatform && !this.syncPlatform && hitTestPoint(ledges1[i].x,ledges1[i].y))
               {
                  this.m_ledges.push(ledges1[i]);
                  this.m_ledgePoints.push(new Point(ledges1[i].x,ledges1[i].y));
                  this.m_ledgePointsPrev.push(new Point(ledges1[i].x,ledges1[i].y));
               }
            }
            for(i = 0; i < ledges2.length; i++)
            {
               if(Boolean(ledges2[i].syncPlatform && this.syncPlatform) && Boolean(ledges2[i].syncPlatform == this.syncPlatform) || !ledges2[i].syncPlatform && !this.syncPlatform && hitTestPoint(ledges2[i].x,ledges2[i].y))
               {
                  this.m_ledges.push(ledges2[i]);
                  this.m_ledgePoints.push(new Point(ledges2[i].x,ledges2[i].y));
                  this.m_ledgePointsPrev.push(new Point(ledges2[i].x,ledges2[i].y));
               }
            }
         }
      }
      
      public function syncLedges() : void
      {
         var diff:Point = null;
         for(var i:int = 0; i < this.m_ledges.length; i++)
         {
            diff = new Point(m_platform.x - m_x_start,m_platform.y - m_y_start);
            this.m_ledges[i].x = this.m_ledgePoints[i].x + diff.x;
            this.m_ledges[i].y = this.m_ledgePoints[i].y + diff.y;
         }
      }
      
      public function syncForeground() : void
      {
         var diff:Point = null;
         if(this.m_foregroundPiece != null)
         {
            diff = new Point(m_platform.x - m_x_start,m_platform.y - m_y_start);
            this.m_foregroundPiece.x = this.m_foregroundPoint.x + diff.x * (m_platform.parent.scaleX / this.m_foregroundPiece.parent.scaleX);
            this.m_foregroundPiece.y = this.m_foregroundPoint.y + diff.y * (m_platform.parent.scaleY / this.m_foregroundPiece.parent.scaleY);
         }
      }
      
      protected function move() : void
      {
         if(Boolean(this.m_platformMovement.length))
         {
            if(!this.m_wait)
            {
               this.m_moveTimer.tick();
               this.m_xLoc += this.m_xSpeed;
               this.m_yLoc += this.m_ySpeed;
               m_platform.x = this.m_xLoc;
               m_platform.y = this.m_yLoc;
               this.syncLedges();
               if(!this.m_moveTimer.IsComplete)
               {
                  if(this.m_platformMovement[this.m_moveIndex].xAccel > 0)
                  {
                     if(this.m_platformMovement[this.m_moveIndex].xSpeed > 0 && this.m_xSpeed < this.m_platformMovement[this.m_moveIndex].xSpeed)
                     {
                        this.m_xSpeed += this.m_platformMovement[this.m_moveIndex].xAccel;
                     }
                     else if(this.m_platformMovement[this.m_moveIndex].xSpeed < 0 && this.m_xSpeed > this.m_platformMovement[this.m_moveIndex].xSpeed)
                     {
                        this.m_xSpeed -= this.m_platformMovement[this.m_moveIndex].xAccel;
                     }
                  }
                  if(this.m_platformMovement[this.m_moveIndex].yAccel > 0)
                  {
                     if(this.m_platformMovement[this.m_moveIndex].ySpeed > 0 && this.m_ySpeed < this.m_platformMovement[this.m_moveIndex].ySpeed)
                     {
                        this.m_ySpeed += this.m_platformMovement[this.m_moveIndex].yAccel;
                     }
                     else if(this.m_platformMovement[this.m_moveIndex].ySpeed < 0 && this.m_ySpeed > this.m_platformMovement[this.m_moveIndex].ySpeed)
                     {
                        this.m_ySpeed -= this.m_platformMovement[this.m_moveIndex].yAccel;
                     }
                  }
               }
               else if(this.m_moveTimer.IsComplete)
               {
                  if(this.m_platformMovement[this.m_moveIndex].xDecel > 0)
                  {
                     if(this.m_platformMovement[this.m_moveIndex].xSpeed > 0)
                     {
                        this.m_xSpeed -= this.m_platformMovement[this.m_moveIndex].xDecel;
                        if(this.m_xSpeed <= 0)
                        {
                           this.m_moveTimer.reset();
                           this.m_wait = true;
                        }
                     }
                     else if(this.m_platformMovement[this.m_moveIndex].xSpeed < 0)
                     {
                        this.m_xSpeed += this.m_platformMovement[this.m_moveIndex].xDecel;
                        if(this.m_xSpeed >= 0)
                        {
                           this.m_moveTimer.reset();
                           this.m_wait = true;
                        }
                     }
                  }
                  if(this.m_platformMovement[this.m_moveIndex].yDecel > 0)
                  {
                     if(this.m_platformMovement[this.m_moveIndex].ySpeed > 0)
                     {
                        this.m_ySpeed -= this.m_platformMovement[this.m_moveIndex].yDecel;
                        if(this.m_ySpeed < 0)
                        {
                           this.m_moveTimer.reset();
                           this.m_wait = true;
                        }
                     }
                     else if(this.m_platformMovement[this.m_moveIndex].ySpeed < 0)
                     {
                        this.m_ySpeed += this.m_platformMovement[this.m_moveIndex].yDecel;
                        if(this.m_ySpeed > 0)
                        {
                           this.m_moveTimer.reset();
                           this.m_wait = true;
                        }
                     }
                     else
                     {
                        this.m_moveTimer.reset();
                        this.m_wait = true;
                     }
                  }
                  if(this.m_platformMovement[this.m_moveIndex].xDecel <= 0 && this.m_platformMovement[this.m_moveIndex].yDecel <= 0)
                  {
                     this.m_moveTimer.reset();
                     this.m_wait = true;
                  }
               }
            }
            if(this.m_wait)
            {
               if(this.m_waitTimer.IsComplete)
               {
                  this.m_moveTimer.reset();
                  this.m_waitTimer.reset();
                  this.incrementMovement();
                  this.m_moveTimer.MaxTime = this.m_platformMovement[this.m_moveIndex].moveTime;
                  this.m_waitTimer.MaxTime = this.m_platformMovement[this.m_moveIndex].waitTime < 0 ? int.MAX_VALUE : this.m_platformMovement[this.m_moveIndex].waitTime;
                  this.m_xSpeed = this.m_platformMovement[this.m_moveIndex].xAccel > 0 ? 0 : this.m_platformMovement[this.m_moveIndex].xSpeed;
                  this.m_ySpeed = this.m_platformMovement[this.m_moveIndex].yAccel > 0 ? 0 : this.m_platformMovement[this.m_moveIndex].ySpeed;
                  noDropThrough = this.m_platformMovement[this.m_moveIndex].noDropThrough;
                  fallthrough = this.m_platformMovement[this.m_moveIndex].fallthrough;
                  this.m_wait = false;
                  if(this.m_platformMovement[this.m_moveIndex].camFocus)
                  {
                     STAGEDATA.CamRef.addForcedTarget(m_platform);
                  }
                  else
                  {
                     STAGEDATA.CamRef.deleteForcedTarget(m_platform);
                  }
               }
               if(this.m_waitTimer.MaxTime < int.MAX_VALUE)
               {
                  this.m_waitTimer.tick();
               }
            }
         }
         if(this.m_xSpeed !== 0 || this.m_ySpeed !== 0)
         {
            m_platform.x += this.m_xSpeed;
            m_platform.y += this.m_ySpeed;
         }
         this.syncLedges();
         this.syncForeground();
      }
      
      override public function stop() : void
      {
         super.stop();
         if(this.m_foregroundPiece != null)
         {
            this.m_foregroundPiece.stop();
         }
      }
      
      override public function play() : void
      {
         super.play();
         if(this.m_foregroundPiece != null)
         {
            this.m_foregroundPiece.play();
         }
      }
      
      public function syncPlayers() : void
      {
         var i:int = 0;
         for(i = 0; i < STAGEDATA.Characters.length; i++)
         {
            STAGEDATA.Characters[i].checkMovingPlatforms(this);
         }
         for(i = 0; i < STAGEDATA.Projectiles.length; i++)
         {
            STAGEDATA.Projectiles[i].checkMovingPlatforms(this);
         }
         for(i = 0; i < STAGEDATA.Enemies.length; i++)
         {
            if(STAGEDATA.Enemies[i] != null)
            {
               STAGEDATA.Enemies[i].checkMovingPlatforms(this);
            }
         }
         for(i = 0; i < STAGEDATA.ItemsRef.ItemsInUse.length; i++)
         {
            if(STAGEDATA.ItemsRef.ItemsInUse[i] != null && !STAGEDATA.ItemsRef.ItemsInUse[i].Dead)
            {
               STAGEDATA.ItemsRef.ItemsInUse[i].checkMovingPlatforms(this);
            }
         }
      }
      
      override public function destroy() : void
      {
         m_dead = true;
         STAGEDATA.removePlatform(this);
      }
      
      override public function PERFORMALL() : void
      {
         this.PREPERFORM();
         if(!this.m_disabled)
         {
            storeOldLocation();
            this.move();
            if(Boolean(m_apiInstance))
            {
               m_apiInstance.update();
            }
            this.syncPlayers();
         }
         this.POSTPERFORM();
      }
      
      protected function PREPERFORM() : void
      {
         if(!this.m_disabled)
         {
            if(m_platform.currentFrame == m_platform.totalFrames)
            {
               m_platform.gotoAndStop(1);
            }
            else
            {
               m_platform.nextFrame();
            }
            if(this.m_foregroundPiece != null)
            {
               if(this.m_foregroundPiece.currentFrame == this.m_foregroundPiece.totalFrames)
               {
                  this.m_foregroundPiece.gotoAndStop(1);
               }
               else
               {
                  this.m_foregroundPiece.nextFrame();
               }
            }
         }
      }
      
      protected function POSTPERFORM() : void
      {
         if(!this.m_disabled)
         {
            this.stop();
         }
      }
      
      override public function setAlpha(val:Number) : void
      {
         super.setAlpha(val);
         if(this.m_foregroundPiece != null)
         {
            this.m_foregroundPiece.alpha = val;
         }
      }
      
      public function killPlatform() : void
      {
         m_platform.visible = false;
         if(this.m_foregroundPiece != null)
         {
            this.m_foregroundPiece.visible = false;
         }
         if(Boolean(m_platform.ground))
         {
            MovieClip(m_platform.ground).fallthrough = true;
         }
         else
         {
            m_platform.fallthrough = true;
         }
         m_platform.visible = false;
         this.m_disabled = true;
      }
   }
}

