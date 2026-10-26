package com.mcleodgaming.ssf2.engine
{
   import com.mcleodgaming.ssf2.Main;
   import com.mcleodgaming.ssf2.api.*;
   import com.mcleodgaming.ssf2.enums.TState;
   import com.mcleodgaming.ssf2.platforms.*;
   import com.mcleodgaming.ssf2.util.*;
   import flash.display.MovieClip;
   
   public class TargetTestTarget extends InteractiveSprite
   {
      
      protected var m_targetMovement:Vector.<PlatformMovement>;
      
      protected var m_moveIndex:int;
      
      protected var m_moveTimer:FrameTimer;
      
      protected var m_waitTimer:FrameTimer;
      
      protected var m_wait:Boolean;
      
      protected var m_xLoc:Number;
      
      protected var m_yLoc:Number;
      
      protected var m_className:String;
      
      public function TargetTestTarget(mc:MovieClip, stageData:StageData, stats:Object = null)
      {
         m_baseStats = new InteractiveSpriteStats();
         if(!stats)
         {
            stats = {};
         }
         if(!stats.classAPI)
         {
            stats.classAPI = stageData.BASE_CLASSES.SSF2Target;
         }
         m_apiInstance = new SSF2Target(stats.classAPI,this);
         if(!mc)
         {
            mc = ResourceManager.getLibraryMC(m_apiInstance.getOwnStats().linkage_id);
            stageData.StageRef.addChild(mc);
         }
         super(mc,stageData,false);
         STAGEDATA = stageData;
         m_sprite = mc;
         m_gravity = 0;
         m_max_ySpeed = 0;
         this.m_targetMovement = new Vector.<PlatformMovement>();
         this.m_moveIndex = Boolean(m_sprite.startIndex) ? int(m_sprite.startIndex) : 0;
         this.m_moveTimer = new FrameTimer(1);
         this.m_waitTimer = new FrameTimer(1);
         for(var i:int = 1; Boolean(m_sprite["movement" + i]); i++)
         {
            this.addMovement(m_sprite["movement" + i]);
         }
         this.m_wait = false;
         this.m_xLoc = m_sprite.x;
         this.m_yLoc = m_sprite.y;
         this.m_className = Main.getClassName(m_sprite);
         buildHitBoxData(this.m_className,false);
         disableDelayPlayback();
         setState(TState.IDLE);
      }
      
      override public function get CurrentAnimation() : HitBoxAnimation
      {
         return m_hitBoxManager == null ? null : (m_hitBoxManager.HitBoxAnimationList.length <= 0 || !m_sprite.currentLabel ? null : m_hitBoxManager.getHitBoxAnimation(this.m_className + "_" + m_sprite.currentLabel));
      }
      
      override protected function m_controlFrames() : void
      {
         if(m_state == TState.IDLE)
         {
            playFrame("idle");
         }
         else if(m_state == TState.BROKEN)
         {
            playFrame("idle");
         }
         else if(m_state == TState.DEAD)
         {
         }
      }
      
      override protected function validateBypass(attackObj:AttackDamage) : Boolean
      {
         if(attackObj.BypassNonGrabbed)
         {
            return false;
         }
         if(Boolean(attackObj.Owner as Projectile && attackObj.BypassNonLatched) && Boolean(Projectile(attackObj.Owner).Latched) && Projectile(attackObj.Owner).LatchID == this)
         {
            return false;
         }
         return true;
      }
      
      override public function validateHit(attackObj:AttackDamage, ignoreInvincible:Boolean = false, ignoreIntangible:Boolean = false) : Boolean
      {
         if(!super.validateHit(attackObj,ignoreInvincible,ignoreIntangible) || !inState(TState.IDLE))
         {
            return false;
         }
         return true;
      }
      
      override public function takeDamage(attackObj:AttackDamage, collisionHitBox:HitBoxSprite = null) : Boolean
      {
         var angle:Number = NaN;
         var effect1MC:MovieClip = null;
         if(!this.validateHit(attackObj,false,true))
         {
            return false;
         }
         if(attackObj.HasEffect || !attackObj.HasEffect && !isIntangible() && attackObj.Damage > 0)
         {
            if(m_hurtInterrupt != null && Boolean(m_hurtInterrupt({
               "target":(Boolean(attackObj.Owner) && Boolean(attackObj.Owner.APIInstance) ? attackObj.Owner.APIInstance.instance : null),
               "attackBoxData":attackObj.exportAttackDamageData(),
               "collisionRect":(Boolean(collisionHitBox) ? collisionHitBox.BoundingBox : null)
            })))
            {
               return false;
            }
            initDelayPlayback(false);
            angle = Utils.calculateReversedAngle(Utils.calculateAttackDirection(attackObj,this),attackObj,this);
            if(attackObj.EffectID != null && attackObj.EffectID != null && Boolean(STAGEDATA.getQualitySettings().hit_effects))
            {
               effect1MC = attachHurtEffect(attackObj.EffectID,collisionHitBox,{
                  "scaleX":0.25 + 0.75 * Math.min(attackObj.Damage / 16,1),
                  "scaleY":0.25 + 0.75 * Math.min(attackObj.Damage / 16,1)
               });
               if(Boolean(effect1MC))
               {
                  effect1MC.rotation = attackObj.IsForward ? 180 - angle : -angle;
               }
            }
            this.breakTarget();
            return true;
         }
         return false;
      }
      
      public function destroy() : void
      {
         if(!inState(TState.DEAD))
         {
            m_skipAttackCollisionTests = true;
            m_skipAttackProcessing = true;
            STAGEDATA.CamRef.deleteTarget(m_sprite);
            m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.TARGET_DESTROYED,{"caller":this.APIInstance.instance}));
            disableDelayPlayback();
            setState(TState.DEAD);
            if(Boolean(m_sprite.parent))
            {
               m_sprite.parent.removeChild(m_sprite);
            }
            removeAllTempEvents();
            flushTimers();
            if(Boolean(m_shadowEffect) && Boolean(m_shadowEffect.parent))
            {
               m_shadowEffect.parent.removeChild(m_shadowEffect);
            }
            m_shadowEffect = null;
            if(Boolean(m_reflectionEffect) && Boolean(m_reflectionEffect.parent))
            {
               m_reflectionEffect.parent.removeChild(m_reflectionEffect);
            }
            m_reflectionEffect = null;
            STAGEDATA.removeTarget(this);
         }
      }
      
      public function breakTarget() : void
      {
         if(inState(TState.IDLE))
         {
            disableDelayPlayback();
            setState(TState.BROKEN);
            stancePlayFrame("break");
            STAGEDATA.playSpecificSound("targetbreak");
            m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.TARGET_BROKEN,{"caller":this.APIInstance.instance}));
         }
      }
      
      override protected function move() : void
      {
         if(Boolean(this.m_targetMovement.length))
         {
            if(!this.m_wait)
            {
               if(!this.m_moveTimer.IsComplete)
               {
                  if(this.m_targetMovement[this.m_moveIndex].xAccel > 0)
                  {
                     if(this.m_targetMovement[this.m_moveIndex].xSpeed > 0 && m_xSpeed < this.m_targetMovement[this.m_moveIndex].xSpeed)
                     {
                        m_xSpeed += this.m_targetMovement[this.m_moveIndex].xAccel;
                     }
                     else if(this.m_targetMovement[this.m_moveIndex].xSpeed < 0 && m_xSpeed > this.m_targetMovement[this.m_moveIndex].xSpeed)
                     {
                        m_xSpeed -= this.m_targetMovement[this.m_moveIndex].xAccel;
                     }
                  }
                  if(this.m_targetMovement[this.m_moveIndex].yAccel > 0)
                  {
                     if(this.m_targetMovement[this.m_moveIndex].ySpeed > 0 && m_ySpeed < this.m_targetMovement[this.m_moveIndex].ySpeed)
                     {
                        m_ySpeed += this.m_targetMovement[this.m_moveIndex].yAccel;
                     }
                     else if(this.m_targetMovement[this.m_moveIndex].ySpeed < 0 && m_ySpeed > this.m_targetMovement[this.m_moveIndex].ySpeed)
                     {
                        m_ySpeed -= this.m_targetMovement[this.m_moveIndex].yAccel;
                     }
                  }
               }
               else if(this.m_moveTimer.IsComplete)
               {
                  if(this.m_targetMovement[this.m_moveIndex].xDecel > 0)
                  {
                     if(this.m_targetMovement[this.m_moveIndex].xSpeed > 0)
                     {
                        m_xSpeed -= this.m_targetMovement[this.m_moveIndex].xDecel;
                        if(m_xSpeed <= 0)
                        {
                           this.m_moveTimer.reset();
                           this.m_wait = true;
                        }
                     }
                     else if(this.m_targetMovement[this.m_moveIndex].xSpeed < 0)
                     {
                        m_xSpeed += this.m_targetMovement[this.m_moveIndex].xDecel;
                        if(m_xSpeed >= 0)
                        {
                           this.m_moveTimer.reset();
                           this.m_wait = true;
                        }
                     }
                  }
                  if(this.m_targetMovement[this.m_moveIndex].yDecel > 0)
                  {
                     if(this.m_targetMovement[this.m_moveIndex].ySpeed > 0)
                     {
                        m_ySpeed -= this.m_targetMovement[this.m_moveIndex].yDecel;
                        if(m_ySpeed < 0)
                        {
                           this.m_moveTimer.reset();
                           this.m_wait = true;
                        }
                     }
                     else if(this.m_targetMovement[this.m_moveIndex].ySpeed < 0)
                     {
                        m_ySpeed += this.m_targetMovement[this.m_moveIndex].yDecel;
                        if(m_ySpeed > 0)
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
                  if(this.m_targetMovement[this.m_moveIndex].xDecel <= 0 && this.m_targetMovement[this.m_moveIndex].yDecel <= 0)
                  {
                     this.m_moveTimer.reset();
                     this.m_wait = true;
                  }
               }
            }
            else
            {
               this.m_waitTimer.tick();
               if(this.m_waitTimer.IsComplete)
               {
                  this.m_moveTimer.reset();
                  this.m_waitTimer.reset();
                  this.incrementMovement();
                  this.m_moveTimer.MaxTime = this.m_targetMovement[this.m_moveIndex].moveTime;
                  this.m_waitTimer.MaxTime = this.m_targetMovement[this.m_moveIndex].waitTime;
                  m_xSpeed = this.m_targetMovement[this.m_moveIndex].xAccel > 0 ? 0 : this.m_targetMovement[this.m_moveIndex].xSpeed;
                  m_ySpeed = this.m_targetMovement[this.m_moveIndex].yAccel > 0 ? 0 : this.m_targetMovement[this.m_moveIndex].ySpeed;
                  this.m_wait = false;
               }
            }
         }
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
         movementInstance.fallthrough = movement.fallthrough !== undefined ? Boolean(movement.fallthrough) : false;
         movementInstance.noDropThrough = movement.noDropThrough !== undefined ? Boolean(movement.noDropThrough) : false;
         movementInstance.camFocus = movement.camFocus !== undefined ? Boolean(movement.camFocus) : false;
         this.m_targetMovement.push(movementInstance);
         if(this.m_targetMovement.length === 1)
         {
            this.m_wait = false;
            this.m_moveIndex = 0;
            this.m_moveTimer.MaxTime = movementInstance.moveTime;
            this.m_moveTimer.MaxTime = movementInstance.moveTime;
            this.m_waitTimer.reset();
            this.m_waitTimer.reset();
            m_xSpeed = movementInstance.xAccel > 0 ? 0 : movementInstance.xSpeed;
            m_ySpeed = movementInstance.yAccel > 0 ? 0 : movementInstance.ySpeed;
            if(movementInstance.camFocus)
            {
               STAGEDATA.CamRef.addForcedTarget(m_sprite);
            }
         }
      }
      
      public function clearMovement() : void
      {
         this.m_targetMovement.splice(0,this.m_targetMovement.length);
      }
      
      private function incrementMovement() : void
      {
         ++this.m_moveIndex;
         if(this.m_moveIndex >= this.m_targetMovement.length)
         {
            this.m_moveIndex = 0;
         }
      }
      
      public function stop() : void
      {
         m_sprite.stop();
      }
      
      public function play() : void
      {
         m_sprite.play();
      }
      
      override public function PERFORMALL() : void
      {
         PREPERFORM();
         if(inState(TState.IDLE))
         {
            this.move();
         }
         POSTPERFORM();
      }
   }
}

