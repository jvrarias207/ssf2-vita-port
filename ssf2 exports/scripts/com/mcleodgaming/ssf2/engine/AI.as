package com.mcleodgaming.ssf2.engine
{
   import com.mcleodgaming.ssf2.enemies.Enemy;
   import com.mcleodgaming.ssf2.enums.*;
   import com.mcleodgaming.ssf2.items.*;
   import com.mcleodgaming.ssf2.net.*;
   import com.mcleodgaming.ssf2.platforms.*;
   import com.mcleodgaming.ssf2.util.*;
   import flash.display.MovieClip;
   import flash.geom.Point;
   
   public class AI
   {
      
      private var ROOT:MovieClip;
      
      private var STAGE:MovieClip;
      
      private var STAGEPARENT:MovieClip;
      
      private var STAGEDATA:StageData;
      
      private var m_level:int;
      
      private var m_playerClassInstance:Character;
      
      private var m_player_id:int;
      
      private var m_action:int;
      
      private var m_actionsList:Array;
      
      private var m_forceAction:int;
      
      private var m_keys:ControlsObject;
      
      private var m_keys_hist:ControlsObject;
      
      private var m_target:Target;
      
      private var m_targetTemp:Target;
      
      private var m_shortestPath:Vector.<Beacon>;
      
      private var m_running:Boolean;
      
      private var m_fallthrough:Boolean;
      
      private var m_fallthroughTimer:FrameTimer;
      
      private var m_shieldDodge:Boolean;
      
      private var m_shieldProjectile:Boolean;
      
      private var m_grabTimer:FrameTimer;
      
      private var m_grabHitTimer:FrameTimer;
      
      private var m_shieldTimer:FrameTimer;
      
      private var m_shieldHoldTimer:FrameTimer;
      
      private var m_dodgeTimer:FrameTimer;
      
      private var m_attackTimer:FrameTimer;
      
      private var m_franticEvadeTimer:FrameTimer;
      
      private var m_evadeTimer:FrameTimer;
      
      private var m_evadeOverrideTimer:FrameTimer;
      
      private var m_jumpTimer:FrameTimer;
      
      private var m_idleTimer:FrameTimer;
      
      private var m_runTimer:FrameTimer;
      
      private var m_beaconTimer:FrameTimer;
      
      private var m_targetTimer:FrameTimer;
      
      private var m_hangTimer:FrameTimer;
      
      private var m_itemTossTimer:FrameTimer;
      
      private var m_itemPickupTimer:FrameTimer;
      
      private var m_itemGiveUpTimer:FrameTimer;
      
      private var m_fsSpecialTimer:FrameTimer;
      
      private var m_projectileTimer:FrameTimer;
      
      private var m_enemyTimer:FrameTimer;
      
      private var m_itemTimer:FrameTimer;
      
      private var m_confusionTimer:FrameTimer;
      
      private var m_idleFixTimer:FrameTimer;
      
      private var m_boredTimer:FrameTimer;
      
      private var m_boredActionTimer:FrameTimer;
      
      private var m_projectileWarningTimer:FrameTimer;
      
      private var m_hoverTimer:FrameTimer;
      
      private var m_tauntTrigger:Boolean;
      
      private var m_itemPickup:Boolean;
      
      private var m_evadeRight:Boolean;
      
      private var m_currentAttackQueue:Vector.<String>;
      
      private var m_currentAttackQueueTimer:FrameTimer;
      
      private var m_initatedAttack:Boolean;
      
      private var m_currentAttack:AttackObject;
      
      private var m_currentAttackIsProjectile:Boolean;
      
      private var m_currentAttackCombos:int;
      
      private var m_currentAttackChargetime:int;
      
      private var m_currentAttackUseCharge:Boolean;
      
      private var m_disabledAttackList:Vector.<AttackObject>;
      
      private var m_recovering:Boolean;
      
      private var m_finalRecovery:Boolean;
      
      private var m_horizontalRecoveryAttackList:Vector.<AttackObject>;
      
      private var m_recoveryAttackList:Vector.<AttackObject>;
      
      private var m_controlOverrides:Vector.<int>;
      
      public function AI(level:int, player:Character, stageData:StageData)
      {
         super();
         this.STAGEDATA = stageData;
         this.ROOT = this.STAGEDATA.RootRef;
         this.STAGE = this.STAGEDATA.StageRef;
         this.STAGEPARENT = this.STAGEDATA.StageRef;
         this.m_playerClassInstance = player;
         this.m_initatedAttack = false;
         this.m_currentAttack = null;
         this.m_currentAttackIsProjectile = false;
         this.m_currentAttackCombos = 0;
         this.m_currentAttackChargetime = 0;
         this.m_currentAttackUseCharge = false;
         this.m_player_id = player.ID;
         this.m_forceAction = CPUState.NULL;
         this.m_keys = new ControlsObject();
         this.m_keys_hist = new ControlsObject();
         this.storeKeyHistory();
         this.m_fallthrough = false;
         this.m_fallthroughTimer = new FrameTimer(3);
         this.m_fallthroughTimer.finish();
         this.m_running = false;
         this.m_shieldDodge = false;
         this.m_shieldProjectile = false;
         this.m_grabTimer = new FrameTimer(5);
         this.m_grabHitTimer = new FrameTimer(10);
         this.m_shieldTimer = new FrameTimer(5);
         this.m_shieldHoldTimer = new FrameTimer(10);
         this.m_dodgeTimer = new FrameTimer(5);
         this.m_attackTimer = new FrameTimer(1);
         this.m_franticEvadeTimer = new FrameTimer(10);
         this.m_evadeTimer = new FrameTimer(10);
         this.m_evadeOverrideTimer = new FrameTimer(30);
         this.m_beaconTimer = new FrameTimer(150);
         this.m_jumpTimer = new FrameTimer(5);
         this.m_runTimer = new FrameTimer(10);
         this.m_idleTimer = new FrameTimer(5);
         this.m_targetTimer = new FrameTimer(5);
         this.m_hangTimer = new FrameTimer(2);
         this.m_itemPickupTimer = new FrameTimer(5);
         this.m_itemGiveUpTimer = new FrameTimer(30 * 5);
         this.m_itemTossTimer = new FrameTimer(30 * 2);
         this.m_fsSpecialTimer = new FrameTimer(15);
         this.m_projectileTimer = new FrameTimer(6);
         this.m_enemyTimer = new FrameTimer(8);
         this.m_itemTimer = new FrameTimer(5);
         this.m_confusionTimer = new FrameTimer(1);
         this.m_idleFixTimer = new FrameTimer(10);
         this.m_boredTimer = new FrameTimer(15);
         this.m_boredActionTimer = new FrameTimer(5);
         this.m_projectileWarningTimer = new FrameTimer(5);
         this.m_hoverTimer = new FrameTimer(20);
         this.m_evadeOverrideTimer.CurrentTime = this.m_evadeOverrideTimer.MaxTime;
         this.m_projectileWarningTimer.finish();
         this.m_confusionTimer.finish();
         this.m_tauntTrigger = false;
         this.m_evadeRight = false;
         this.m_target = new Target();
         this.m_targetTemp = new Target();
         this.m_action = CPUState.IDLE;
         this.m_actionsList = new Array();
         this.m_actionsList = this.createActionsList();
         this.m_shortestPath = null;
         this.m_recovering = false;
         this.m_finalRecovery = false;
         this.m_itemPickup = false;
         this.m_horizontalRecoveryAttackList = new Vector.<AttackObject>();
         this.m_recoveryAttackList = new Vector.<AttackObject>();
         this.m_disabledAttackList = new Vector.<AttackObject>();
         this.m_controlOverrides = new Vector.<int>();
         this.m_currentAttackQueue = new Vector.<String>();
         this.m_currentAttackQueueTimer = new FrameTimer(30);
         this.setLevel(level);
      }
      
      public function get ControlOverrides() : Vector.<int>
      {
         return this.m_controlOverrides;
      }
      
      public function get Recovering() : Boolean
      {
         return this.m_recovering;
      }
      
      public function get CurrentTarget() : Target
      {
         return this.m_target;
      }
      
      public function get Running() : Boolean
      {
         return this.m_running;
      }
      
      public function get FallThrough() : Boolean
      {
         return this.m_fallthrough;
      }
      
      public function get ActionText() : String
      {
         return this.m_actionsList[this.m_action];
      }
      
      public function set ActionText(action:String) : void
      {
         this.m_forceAction = this.m_actionsList.indexOf(action) >= 0 ? this.m_actionsList.indexOf(action) : CPUState.NULL;
      }
      
      public function get Action() : int
      {
         return this.m_action;
      }
      
      public function get ForcedAction() : int
      {
         return this.m_forceAction;
      }
      
      public function set ForcedAction(value:int) : void
      {
         this.m_forceAction = value;
      }
      
      public function get ControlsObj() : ControlsObject
      {
         return this.m_keys;
      }
      
      public function getLevel() : int
      {
         return this.m_level;
      }
      
      public function setLevel(value:int) : void
      {
         if(value < 0)
         {
            value = 0;
         }
         else if(value > 9)
         {
            value = 9;
         }
         this.m_level = value;
         this.adjustLevelTimers();
      }
      
      private function adjustLevelTimers() : void
      {
         if(this.m_level === 0)
         {
            this.m_idleTimer.MaxTime = 10;
            this.m_jumpTimer.MaxTime = 40;
            this.m_runTimer.MaxTime = 30;
            this.m_evadeTimer.MaxTime = 30;
         }
         else
         {
            this.m_grabTimer.MaxTime = this.timeByLevel(5,15);
            this.m_grabHitTimer.MaxTime = this.timeByLevel(10,15);
            this.m_shieldTimer.MaxTime = this.timeByLevel(5,15);
            this.m_shieldHoldTimer.MaxTime = this.timeByLevel(10,15);
            this.m_attackTimer.MaxTime = this.timeByLevel(1,30);
            this.m_franticEvadeTimer.MaxTime = this.timeByLevel(10,30);
            this.m_evadeTimer.MaxTime = this.timeByLevel(10,20);
            this.m_evadeOverrideTimer.MaxTime = this.timeByLevel(30,40);
            this.m_jumpTimer.MaxTime = this.timeByLevel(5,40);
            this.m_runTimer.MaxTime = this.timeByLevel(10,30);
            this.m_idleTimer.MaxTime = this.timeByLevel(5,30);
            this.m_targetTimer.MaxTime = this.timeByLevel(5,15);
            this.m_hangTimer.MaxTime = this.timeByLevel(2,20);
            this.m_itemPickupTimer.MaxTime = this.timeByLevel(5,15);
            this.m_itemTossTimer.MaxTime = this.timeByLevel(30 * 2,30 * 4);
            this.m_fsSpecialTimer.MaxTime = this.timeByLevel(15,30);
            this.m_projectileTimer.MaxTime = this.timeByLevel(6,10);
            this.m_enemyTimer.MaxTime = this.timeByLevel(8,12);
            this.m_itemTimer.MaxTime = this.timeByLevel(5,10);
            this.m_confusionTimer.MaxTime = this.timeByLevel(1,5);
            this.m_idleFixTimer.MaxTime = this.timeByLevel(10,20);
            this.m_boredTimer.MaxTime = this.timeByLevel(15,30);
            this.m_boredActionTimer.MaxTime = this.timeByLevel(5,20);
            this.m_projectileWarningTimer.MaxTime = this.timeByLevel(5,10);
            this.m_hoverTimer.MaxTime = this.timeByLevel(20,30);
         }
         this.m_evadeOverrideTimer.CurrentTime = this.m_evadeOverrideTimer.MaxTime;
         this.m_projectileWarningTimer.finish();
         this.m_confusionTimer.finish();
      }
      
      private function timeByLevel(min:int, max:int, inverse:Boolean = false) : int
      {
         if(inverse)
         {
            return this.m_level / 9 * (max - min) + min;
         }
         return (1 - this.m_level / 9) * (max - min) + min;
      }
      
      private function execIfSmartEnough(multiplier:Number = 1, useLastSeed:Boolean = false) : Boolean
      {
         return useLastSeed ? Utils.LastRandom > (1 - this.m_level / 10) * multiplier : Utils.random() > (1 - this.m_level / 10) * multiplier;
      }
      
      private function execIfDumbEnough(multiplier:Number = 1, useLastSeed:Boolean = false) : Boolean
      {
         return useLastSeed ? Utils.LastRandom > this.m_level / 10 * multiplier : Utils.random() > this.m_level / 10 * multiplier;
      }
      
      public function beginConfusion(length:int) : void
      {
         this.m_confusionTimer.reset();
         this.m_confusionTimer.MaxTime = length;
         this.resetControlOverrides();
      }
      
      public function refreshRecoveryAttackList() : void
      {
         var attackList:Array = this.m_playerClassInstance.AttackDataObj.AttackMap.Values;
         var i:int = 0;
         this.m_recoveryAttackList = new Vector.<AttackObject>();
         for(i = 0; i < attackList.length; i++)
         {
            if(Boolean(attackList[i].IsRecoveryMove))
            {
               this.m_recoveryAttackList.push(AttackObject(attackList[i]));
            }
         }
         this.m_horizontalRecoveryAttackList = new Vector.<AttackObject>();
         for(i = 0; i < attackList.length; i++)
         {
            if(Boolean(attackList[i].IsHorizontalRecoveryMove))
            {
               this.m_horizontalRecoveryAttackList.push(AttackObject(attackList[i]));
            }
         }
      }
      
      public function refreshDisabledAttackList() : void
      {
         var attackList:Array = this.m_playerClassInstance.AttackDataObj.AttackMap.Values;
         this.m_disabledAttackList = new Vector.<AttackObject>();
         for(var i:int = 0; i < attackList.length; i++)
         {
            if(Boolean(attackList[i].DisableForCPU) || !attackList[i].Enabled)
            {
               this.m_disabledAttackList.push(AttackObject(attackList[i]));
            }
         }
      }
      
      public function getDisabledAttack(name:String) : Boolean
      {
         for(var i:int = 0; i < this.m_disabledAttackList.length; i++)
         {
            if(this.m_disabledAttackList[i].Name == name)
            {
               this.m_attackTimer.finish();
               return true;
            }
         }
         return false;
      }
      
      public function triggerTaunt() : void
      {
         this.m_tauntTrigger = true;
      }
      
      private function showCurrentPath() : void
      {
         var s:String = null;
         var i:int = 0;
         if(this.m_shortestPath != null)
         {
            s = "Current Path: { ";
            for(i = this.m_shortestPath.length - 1; i >= 0; i--)
            {
               s += this.m_shortestPath[i].Z + " ";
            }
            s += "}";
            trace(s);
         }
      }
      
      public function importControlOverrides(overrides:Array) : void
      {
         for(var i:int = 0; i < overrides.length; i++)
         {
            this.m_controlOverrides.push(overrides[i]);
         }
      }
      
      public function resetControlOverrides() : void
      {
         this.m_controlOverrides.splice(0,this.m_controlOverrides.length);
      }
      
      public function createActionsList() : Array
      {
         var arr:Array = new Array();
         arr[0] = "idle";
         arr[1] = "chase";
         arr[2] = "evade";
         arr[3] = "recovery";
         arr[4] = "init. attack";
         arr[5] = "attacking";
         arr[6] = "init. shield";
         arr[7] = "shielding";
         arr[8] = "init grab";
         arr[9] = "grabbing";
         arr[10] = "jump";
         arr[11] = "walk";
         arr[12] = "run";
         arr[13] = "force do nothing";
         return arr;
      }
      
      public function getAction() : void
      {
         this.m_initatedAttack = false;
         this.m_itemPickup = false;
         this.storeKeyHistory();
         if(this.m_forceAction < 0 && !this.m_target.BeaconSprite && !this.STAGEDATA.Paused && !this.STAGEDATA.FSCutscene && this.STAGEDATA.FSCutins <= 0)
         {
            this.runShieldTimer();
            this.runAttackTimer();
            this.runGrabTimer();
         }
         else
         {
            this.m_action = CPUState.CHASE;
         }
         if(!this.STAGEDATA.Paused && !this.STAGEDATA.FSCutscene && this.STAGEDATA.FSCutins <= 0 && this.STAGEDATA.getBeacons().length > 0)
         {
            this.runBeaconTimer();
            this.runTargetTimer();
         }
         if(this.m_playerClassInstance.CollisionObj.lbound_upper || this.m_playerClassInstance.CollisionObj.lbound_lower || this.m_playerClassInstance.CollisionObj.rbound_upper || this.m_playerClassInstance.CollisionObj.rbound_lower)
         {
            if(this.m_action == CPUState.EVADE && this.m_evadeOverrideTimer.IsComplete)
            {
               this.m_evadeOverrideTimer.reset();
               this.m_evadeRight = this.m_playerClassInstance.CollisionObj.lbound_upper || this.m_playerClassInstance.CollisionObj.lbound_lower;
            }
            else
            {
               this.m_action = CPUState.RECOVERY;
            }
         }
         else if(this.m_forceAction >= 0)
         {
            this.m_action = this.m_forceAction;
         }
         if(this.m_action == CPUState.IDLE)
         {
            this.idle();
         }
         else if(this.m_action == CPUState.CHASE)
         {
            this.chase();
         }
         else if(this.m_action == CPUState.EVADE)
         {
            this.evade();
         }
         else if(this.m_action == CPUState.RECOVERY)
         {
            this.checkBoundaries();
         }
         else if(this.m_action == CPUState.INIT_ATTACK)
         {
            this.resetAllKeys();
            this.chooseAttack();
            this.m_action = CPUState.ATTACK;
         }
         else if(this.m_action == CPUState.ATTACK)
         {
            this.resetAllKeys();
            this.attackOptions();
         }
         else if(this.m_action == CPUState.INIT_SHIELD)
         {
            this.resetAllKeys();
            this.m_keys.SHIELD = true;
            this.m_action = CPUState.SHIELD;
            this.m_shieldHoldTimer.MaxTime = Utils.randomInteger(10,45);
            this.m_dodgeTimer.MaxTime = Utils.randomInteger(10,30);
            this.m_shieldProjectile = false;
         }
         else if(this.m_action == CPUState.SHIELD)
         {
            this.resetAllKeys();
            this.shield();
         }
         else if(this.m_action == CPUState.INIT_GRAB)
         {
            this.resetAllKeys();
            if(this.m_playerClassInstance.inState(CState.SHIELDING))
            {
               this.m_keys.BUTTON2 = true;
            }
            else
            {
               this.m_keys.GRAB = true;
            }
            this.m_action = CPUState.GRAB;
         }
         else if(this.m_action == CPUState.GRAB)
         {
            this.resetAllKeys();
            this.grab();
         }
         else if(this.m_action == CPUState.FORCE_JUMP)
         {
            this.resetAllKeys();
            if(this.m_playerClassInstance.netYSpeed() < 0)
            {
               this.m_keys.JUMP = true;
            }
            else
            {
               this.m_keys.JUMP = !this.m_keys_hist.JUMP;
            }
         }
         else if(this.m_action == CPUState.FORCE_WALK)
         {
            this.resetAllKeys();
            this.m_keys.DASH = false;
            this.m_keys.RIGHT = this.m_playerClassInstance.FacingForward;
            this.m_keys.LEFT = !this.m_playerClassInstance.FacingForward;
            this.m_running = false;
            this.m_playerClassInstance.calculateAICollision(this.m_playerClassInstance.netXSpeed(),this.m_playerClassInstance.netYSpeed());
            if(this.m_playerClassInstance.FacingForward && this.m_keys.RIGHT && (this.m_playerClassInstance.willFallOffRange(this.m_playerClassInstance.X + 10,this.m_playerClassInstance.Y,9) || this.m_playerClassInstance.CollisionObj.rightSide))
            {
               this.m_keys.RIGHT = false;
               this.m_keys.LEFT = true;
            }
            else if(!this.m_playerClassInstance.FacingForward && this.m_keys.LEFT && (this.m_playerClassInstance.willFallOffRange(this.m_playerClassInstance.X - 10,this.m_playerClassInstance.Y,9) || this.m_playerClassInstance.CollisionObj.leftSide))
            {
               this.m_keys.RIGHT = true;
               this.m_keys.LEFT = false;
            }
         }
         else if(this.m_action == CPUState.FORCE_RUN)
         {
            this.resetAllKeys();
            this.m_keys.DASH = true;
            this.m_keys.RIGHT = this.m_playerClassInstance.FacingForward;
            this.m_keys.LEFT = !this.m_playerClassInstance.FacingForward;
            this.m_running = true;
            this.m_playerClassInstance.calculateAICollision(this.m_playerClassInstance.netXSpeed(),this.m_playerClassInstance.netYSpeed());
            if(this.m_playerClassInstance.FacingForward && this.m_keys.RIGHT && (this.m_playerClassInstance.willFallOffRange(this.m_playerClassInstance.X + 10,this.m_playerClassInstance.Y,9) || this.m_playerClassInstance.CollisionObj.rightSide))
            {
               this.m_keys.RIGHT = false;
               this.m_keys.LEFT = true;
            }
            else if(!this.m_playerClassInstance.FacingForward && this.m_keys.LEFT && (this.m_playerClassInstance.willFallOffRange(this.m_playerClassInstance.X - 10,this.m_playerClassInstance.Y,9) || this.m_playerClassInstance.CollisionObj.leftSide))
            {
               this.m_keys.RIGHT = true;
               this.m_keys.LEFT = false;
            }
         }
         this.checkFinalActions();
         this.m_tauntTrigger = false;
         this.checkPause();
         if(this.m_forceAction === CPUState.FORCE_DO_NOTHING)
         {
            this.storeKeyHistory();
            this.resetAllKeys();
            if(!this.m_playerClassInstance.inState(CState.CRASH_LAND))
            {
               this.checkBoundaries();
            }
            else
            {
               this.m_keys.UP = true;
            }
         }
      }
      
      private function checkControlOverrides() : Boolean
      {
         if(this.m_controlOverrides.length > 0)
         {
            if(this.m_controlOverrides.length != 1)
            {
               this.resetAllKeys();
               this.m_keys.controls = this.m_controlOverrides[0];
               --this.m_controlOverrides[1];
               if(this.m_controlOverrides[1] <= 0)
               {
                  this.m_controlOverrides.splice(0,1);
                  if(this.m_controlOverrides.length > 0)
                  {
                     this.m_controlOverrides.splice(0,1);
                  }
               }
               return true;
            }
            this.m_controlOverrides.splice(0,1);
         }
         return false;
      }
      
      private function checkEvadeOverride() : void
      {
         if(this.m_forceAction < 0 && !this.m_recovering && !this.m_finalRecovery && this.m_action != CPUState.EVADE && (this.m_playerClassInstance.Disabled || this.m_playerClassInstance.inState(CState.TUMBLE_FALL)))
         {
            if(this.m_playerClassInstance.inState(CState.TUMBLE_FALL) && this.m_target.PlayerSprite != null && this.m_target.Distance < 100 && Utils.random() > 0.5)
            {
               this.m_action = CPUState.INIT_ATTACK;
            }
            else
            {
               this.evade();
            }
         }
         else if(Boolean(this.m_forceAction < 0 && !this.m_recovering && !this.m_finalRecovery && this.m_target != null && this.m_target.PlayerSprite && this.m_target.PlayerSprite != null && this.m_target.Distance > 75 && this.m_target.PlayerSprite.UsingFinalSmash && this.m_action != CPUState.INIT_ATTACK && this.m_action != CPUState.SHIELD) && Boolean(this.m_action != CPUState.INIT_SHIELD) && this.execIfSmartEnough())
         {
            this.evade();
         }
      }
      
      private function checkFranticEvade() : void
      {
         if(this.m_forceAction < 0 && !this.m_recovering && !this.m_finalRecovery && this.m_action != CPUState.INIT_SHIELD && this.m_action != CPUState.SHIELD && this.targetUsingDangerousFS())
         {
            this.m_franticEvadeTimer.tick();
            if(this.m_franticEvadeTimer.IsComplete)
            {
               if(Utils.random() > 0.7)
               {
                  this.m_action = CPUState.INIT_SHIELD;
               }
               else
               {
                  this.resetAllKeys();
                  this.m_keys.RIGHT = this.m_playerClassInstance.FacingForward;
                  this.m_keys.LEFT = !this.m_playerClassInstance.FacingForward;
                  this.m_running = true;
                  this.m_playerClassInstance.calculateAICollision(this.m_playerClassInstance.netXSpeed(),this.m_playerClassInstance.netYSpeed());
                  if(this.m_playerClassInstance.FacingForward && this.m_keys.RIGHT && (this.m_playerClassInstance.willFallOffRange(this.m_playerClassInstance.X + 10,this.m_playerClassInstance.Y,9) || this.m_playerClassInstance.CollisionObj.rightSide))
                  {
                     this.m_keys.RIGHT = false;
                     this.m_keys.LEFT = true;
                  }
                  else if(!this.m_playerClassInstance.FacingForward && this.m_keys.LEFT && (this.m_playerClassInstance.willFallOffRange(this.m_playerClassInstance.X - 10,this.m_playerClassInstance.Y,9) || this.m_playerClassInstance.CollisionObj.leftSide))
                  {
                     this.m_keys.RIGHT = true;
                     this.m_keys.LEFT = false;
                  }
                  this.m_franticEvadeTimer.reset();
               }
            }
         }
      }
      
      private function checkStruggle() : void
      {
         if(!this.m_recovering && this.m_forceAction < 0 && this.m_playerClassInstance.IsCaught && this.execIfSmartEnough())
         {
            this.resetAllKeys();
            this.m_keys.BUTTON2 = !this.m_keys_hist.BUTTON2;
         }
      }
      
      private function checkItemToss() : void
      {
         if(this.m_forceAction < 0 && !this.m_recovering && this.m_playerClassInstance.ItemObj != null)
         {
            this.m_itemTossTimer.tick();
            if(this.m_itemTossTimer.IsComplete && this.execIfSmartEnough())
            {
               this.m_itemTossTimer.reset();
               this.m_keys.GRAB = true;
            }
         }
      }
      
      private function checkItemGiveUp() : void
      {
         if(Boolean(this.m_forceAction < 0 && !this.m_recovering && this.m_playerClassInstance.ItemObj == null) && Boolean(this.m_target) && Boolean(this.m_target.ItemSprite))
         {
            this.m_itemGiveUpTimer.tick();
            if(this.m_itemGiveUpTimer.IsComplete)
            {
               this.m_action = CPUState.CHASE;
               this.getNearestOpponent();
               this.m_itemGiveUpTimer.reset();
            }
         }
      }
      
      private function checkWallBlock() : void
      {
         if(this.m_forceAction < 0 && !this.m_playerClassInstance.inState(CState.ATTACKING) && (this.m_playerClassInstance.CollisionObj.ground || !this.m_playerClassInstance.CollisionObj.ground && this.m_playerClassInstance.JumpCount < this.m_playerClassInstance.MaxJump && this.m_playerClassInstance.netYSpeed() >= 0))
         {
            this.m_playerClassInstance.calculateAICollision(this.m_playerClassInstance.netXSpeed(),this.m_playerClassInstance.netYSpeed());
            if(this.m_playerClassInstance.CollisionObj.leftSide || this.m_playerClassInstance.CollisionObj.rightSide)
            {
               if(this.m_keys.JUMP && this.m_keys_hist.JUMP)
               {
                  this.m_keys.JUMP = false;
               }
               else if(!this.m_keys.JUMP && !this.m_keys_hist.JUMP)
               {
                  this.m_keys.JUMP = true;
               }
            }
         }
      }
      
      private function checkItemPickup() : void
      {
         if(this.m_forceAction < 0 && !this.m_recovering && this.m_itemPickup)
         {
            this.resetAllKeys();
            this.m_keys.BUTTON2 = true;
         }
      }
      
      private function checkDropThrough() : void
      {
         if(this.m_forceAction < 0 && this.m_playerClassInstance.OnPlatform && this.m_target != null && this.m_target.CurrentTarget != null && this.m_target.BeaconSprite == null && this.m_target.CurrentTarget.Y > this.m_playerClassInstance.Y && this.m_target.YDistance > 10 && this.m_playerClassInstance.inFreeState() && this.m_playerClassInstance.CurrentPlatform != this.m_target.CurrentTarget.CurrentPlatform && this.m_playerClassInstance.CurrentPlatform.noDropThrough != true)
         {
            this.m_fallthrough = true;
            this.m_keys.DOWN = true;
            this.m_fallthroughTimer.reset();
         }
         if(!this.m_fallthroughTimer.IsComplete)
         {
            this.m_fallthroughTimer.tick();
            this.m_keys.DOWN = true;
         }
         if(this.m_fallthrough && this.m_playerClassInstance.CollisionObj.ground && this.m_keys.DOWN && this.m_keys_hist.DOWN)
         {
            this.m_keys.DOWN = false;
         }
      }
      
      private function checkAllowControl() : void
      {
         if(this.m_forceAction < 0 && this.m_playerClassInstance.inState(CState.ATTACKING) && (this.m_playerClassInstance.AttackStateData.AllowControl || this.m_playerClassInstance.AttackStateData.AllowTurn))
         {
            if(this.m_target != null && this.m_target.CurrentTarget != null && this.m_target.CurrentTarget.X > this.m_playerClassInstance.X && !this.m_keys.RIGHT)
            {
               this.m_keys.RIGHT = true;
               this.m_keys.LEFT = false;
            }
            else if(this.m_target != null && this.m_target.CurrentTarget != null && this.m_target.CurrentTarget.X < this.m_playerClassInstance.X && !this.m_keys.LEFT)
            {
               this.m_keys.LEFT = false;
               this.m_keys.LEFT = true;
            }
         }
      }
      
      private function checkProjectileControl() : void
      {
         var tmpProj:Projectile = null;
         if(this.m_forceAction < 0 && this.m_playerClassInstance.inState(CState.ATTACKING) && this.m_playerClassInstance.AttackDataObj.getAttack(this.m_playerClassInstance.AttackStateData.Frame) != null && Boolean(this.m_playerClassInstance.getCurrentProjectile()))
         {
            tmpProj = this.m_playerClassInstance.getCurrentProjectile();
            if(Boolean(tmpProj.ProjectileAttackObj.ControlDirection && this.m_target != null && this.m_target.CurrentTarget != null) && Boolean(this.m_target.BeaconSprite == null) && !(this.m_target.ItemSprite != null && !this.m_target.ItemSprite.IsSmashBall))
            {
               this.resetAllKeys();
               if(this.m_target.CurrentTarget.X > tmpProj.X + 5)
               {
                  this.m_keys.RIGHT = true;
               }
               else if(this.m_target.CurrentTarget.X < tmpProj.X - 5)
               {
                  this.m_keys.LEFT = true;
               }
               if(this.m_target.CurrentTarget.Y > tmpProj.Y + 5)
               {
                  this.m_keys.DOWN = true;
               }
               else if(this.m_target.CurrentTarget.Y < tmpProj.Y - 5)
               {
                  this.m_keys.UP = true;
               }
            }
         }
      }
      
      private function checkFinalRecovery() : void
      {
         if(this.m_recovering && this.m_finalRecovery && this.m_playerClassInstance.netYSpeed() >= 0 && (this.m_playerClassInstance.JumpCount >= this.m_playerClassInstance.MaxJump || this.m_playerClassInstance.JumpCount < this.m_playerClassInstance.MaxJump && this.m_playerClassInstance.inState(CState.ATTACKING)))
         {
            if(this.m_playerClassInstance.inState(CState.ATTACKING))
            {
               this.m_keys.UP = true;
               if(this.m_playerClassInstance.FacingForward)
               {
                  this.m_keys.RIGHT = true;
                  this.m_keys.LEFT = false;
               }
               else
               {
                  this.m_keys.RIGHT = false;
                  this.m_keys.LEFT = true;
               }
            }
         }
      }
      
      private function checkDangerRecovery() : void
      {
         if(this.m_playerClassInstance.CollisionObj.ground && this.m_playerClassInstance.CurrentPlatform != null && (this.m_playerClassInstance.CurrentPlatform.danger == true || this.m_playerClassInstance.inLowerLeftWarningBounds() || this.m_playerClassInstance.inLowerRightWarningBounds()))
         {
            if(this.m_playerClassInstance.Crashed)
            {
               if(this.m_playerClassInstance.CollisionObj.lbound_upper || this.m_playerClassInstance.CollisionObj.lbound_lower)
               {
                  this.m_keys.RIGHT = true;
               }
               else
               {
                  this.m_keys.LEFT = true;
               }
            }
            else
            {
               this.resetAllKeys();
               this.m_keys.JUMP = !this.m_keys_hist.JUMP;
            }
         }
      }
      
      private function checkFinalSmash() : void
      {
         var tmpTarget:Target = null;
         var myLoc:Point = null;
         if(this.m_playerClassInstance.UsingFinalSmash && this.m_playerClassInstance.SpecialType == 4 && this.m_playerClassInstance.AttachedReticule != null && this.m_target.CurrentTarget != null)
         {
            this.m_fsSpecialTimer.tick();
            if(this.m_fsSpecialTimer.IsComplete)
            {
               this.m_fsSpecialTimer.reset();
               tmpTarget = this.m_target;
               this.m_target = this.findOpponent();
               if(this.m_target == null)
               {
                  this.m_target = tmpTarget;
               }
            }
            if(this.m_target != null && this.m_target.CurrentTarget != null)
            {
               myLoc = new Point(this.m_playerClassInstance.AttachedReticule.x,this.m_playerClassInstance.AttachedReticule.y);
               myLoc = this.STAGEDATA.HudForegroundRef.localToGlobal(myLoc);
               myLoc = this.STAGE.globalToLocal(myLoc);
               this.resetAllKeys();
               if(this.m_target.CurrentTarget.X > myLoc.x + 5)
               {
                  this.m_keys.RIGHT = true;
               }
               else if(this.m_target.CurrentTarget.X < myLoc.x - 5)
               {
                  this.m_keys.LEFT = true;
               }
               if(this.m_target.CurrentTarget.Y > myLoc.y + 5)
               {
                  this.m_keys.DOWN = true;
               }
               else if(this.m_target.CurrentTarget.Y < myLoc.y - 5)
               {
                  this.m_keys.UP = true;
               }
               this.m_target.setDistance(myLoc);
               if(this.m_target.Distance < 10)
               {
                  this.m_keys.BUTTON2 = true;
                  if(this.execIfSmartEnough())
                  {
                     this.m_keys.BUTTON2 = false;
                     this.m_keys.BUTTON1 = true;
                  }
               }
            }
         }
      }
      
      private function checkRevival() : void
      {
         if(this.m_playerClassInstance.inState(CState.REVIVAL) && this.opponenentUsingSpecial())
         {
            this.resetAllKeys();
         }
         else if(this.STAGEDATA.GameRef.GameMode == Mode.TRAINING && this.m_playerClassInstance.inState(CState.REVIVAL) && this.m_forceAction >= 0)
         {
            this.m_keys.DOWN = !this.m_keys_hist.DOWN;
         }
         else if(this.m_recovering)
         {
            if(this.m_playerClassInstance.CollisionObj.lbound_upper || this.m_playerClassInstance.CollisionObj.lbound_lower)
            {
               this.m_keys.LEFT = false;
            }
            else if(this.m_playerClassInstance.CollisionObj.rbound_upper || this.m_playerClassInstance.CollisionObj.rbound_lower)
            {
               this.m_keys.RIGHT = false;
            }
         }
      }
      
      private function checkIdleness() : void
      {
         if(this.m_forceAction < 0 && !this.m_finalRecovery && this.m_level > 0)
         {
            if(this.m_playerClassInstance.inState(CState.IDLE))
            {
               this.m_idleFixTimer.tick();
            }
            else
            {
               this.m_idleFixTimer.reset();
            }
            if(this.m_idleFixTimer.IsComplete)
            {
               if(this.execIfDumbEnough())
               {
                  this.m_idleFixTimer.reset();
               }
            }
            if(Boolean(this.m_playerClassInstance.inState(CState.IDLE) && this.m_action != CPUState.EVADE && this.m_target && this.m_target.CurrentTarget && this.m_target.YDistance > 50 && this.m_target.CurrentTarget.Y < this.m_playerClassInstance.Y && this.m_playerClassInstance.Ground && this.m_target.CurrentTarget.Ground) && Boolean(this.m_idleFixTimer.IsComplete) && this.execIfSmartEnough())
            {
               this.m_keys.JUMP = true;
               trace("-Idle fix1");
            }
            else if(this.m_playerClassInstance.inState(CState.IDLE) && this.m_action != CPUState.IDLE && this.m_action != CPUState.RECOVERY && this.m_idleFixTimer.IsComplete && this.execIfSmartEnough())
            {
               this.m_idleFixTimer.reset();
               this.m_action = CPUState.CHASE;
               trace("-Idle fix2");
            }
            else if(this.m_playerClassInstance.inState(CState.IDLE) && this.m_target.Distance < 100 && this.m_idleFixTimer.IsComplete && this.execIfSmartEnough())
            {
               this.m_idleFixTimer.reset();
               this.m_action = CPUState.CHASE;
               trace("-Idle fix3");
            }
            else if(Boolean(this.m_playerClassInstance.inState(CState.IDLE) && this.m_action != CPUState.EVADE && this.m_target && this.m_target.CurrentTarget && this.m_target.XDistance < 100 && (this.m_target.CurrentTarget.X < this.m_playerClassInstance.X && this.m_playerClassInstance.FacingForward || this.m_target.CurrentTarget.X > this.m_playerClassInstance.X && !this.m_playerClassInstance.FacingForward) && this.m_playerClassInstance.Ground) && Boolean(this.m_idleFixTimer.IsComplete) && this.execIfSmartEnough())
            {
               this.resetAllKeys();
               this.m_keys.LEFT = this.m_target.CurrentTarget.X < this.m_playerClassInstance.X;
               this.m_keys.RIGHT = !this.m_keys.LEFT;
               trace("-Idle fix4");
            }
         }
      }
      
      private function checkProjectileAvoidance() : void
      {
         this.m_projectileWarningTimer.tick();
         var i:int = 0;
         var j:int = 0;
         var closest_projectile:Projectile = null;
         var distance:Number = -1;
         var opponent:Character = null;
         var enemy:Enemy = null;
         var arr:Vector.<Projectile> = null;
         var temparr:Vector.<Projectile> = null;
         if(this.m_forceAction < 0 && !this.m_recovering)
         {
            this.m_projectileTimer.tick();
            if(this.m_projectileTimer.IsComplete && this.execIfSmartEnough())
            {
               arr = new Vector.<Projectile>();
               this.m_projectileTimer.reset();
               for(i = 0; i < this.STAGEDATA.Characters.length; i++)
               {
                  opponent = this.STAGEDATA.Characters[i];
                  if(opponent != null && opponent != this.m_playerClassInstance)
                  {
                     temparr = opponent.getActiveProjectiles(this.m_playerClassInstance.ID,this.m_playerClassInstance.Team);
                     for(j = 0; j < temparr.length; j++)
                     {
                        if(temparr[j].ProjectileAttackObj.Dangerous)
                        {
                           arr.push(temparr[j]);
                        }
                     }
                  }
               }
               for(i = 0; i < this.STAGEDATA.Enemies.length; i++)
               {
                  enemy = this.STAGEDATA.Enemies[i];
                  if(enemy != null)
                  {
                     temparr = enemy.getActiveProjectiles(this.m_playerClassInstance.ID,this.m_playerClassInstance.Team);
                     for(j = 0; j < temparr.length; j++)
                     {
                        if(temparr[j].ProjectileAttackObj.Dangerous)
                        {
                           arr.push(temparr[j]);
                        }
                     }
                  }
               }
               for(i = 0; i < arr.length; i++)
               {
                  if(distance < 0 || Utils.getDistanceFrom(this.m_playerClassInstance,arr[i]) < distance)
                  {
                     closest_projectile = arr[i];
                  }
               }
               if(closest_projectile != null)
               {
                  if(distance < this.m_playerClassInstance.Width * 2 && !(Boolean(this.m_target) && Boolean(this.m_target.PlayerSprite) && this.m_target.Distance < 30))
                  {
                     this.resetAllKeys();
                     if(this.m_playerClassInstance.CollisionObj.ground && this.execIfSmartEnough() || this.execIfDumbEnough())
                     {
                        this.m_keys.JUMP = true;
                     }
                     else
                     {
                        this.m_keys.SHIELD = true;
                        if(this.m_playerClassInstance.CollisionObj.ground)
                        {
                           this.m_shieldHoldTimer.reset();
                           this.m_shieldTimer.reset();
                           this.m_action = CPUState.SHIELD;
                           this.m_shieldHoldTimer.MaxTime = Utils.randomInteger(10,45);
                           this.m_dodgeTimer.MaxTime = Utils.randomInteger(10,30);
                           this.m_shieldProjectile = true;
                        }
                     }
                     this.m_projectileWarningTimer.reset();
                  }
               }
            }
         }
      }
      
      private function checkEnemyAvoidance() : void
      {
         var i:int = 0;
         var j:int = 0;
         var closest_enemy:Enemy = null;
         var distance:Number = -1;
         var distance2:Number = -1;
         var enemy:Enemy = null;
         if(this.m_forceAction < 0 && !this.m_recovering)
         {
            this.m_enemyTimer.tick();
            if(this.m_enemyTimer.IsComplete && this.execIfSmartEnough())
            {
               this.m_enemyTimer.reset();
               for(i = 0; i < this.STAGEDATA.Enemies.length; i++)
               {
                  enemy = this.STAGEDATA.Enemies[i];
                  if(enemy != null)
                  {
                     distance2 = Utils.getDistanceFrom(this.m_playerClassInstance,enemy);
                     if((distance < 0 || distance2 < distance) && enemy.PlayerID != this.m_playerClassInstance.ID && !(enemy.TeamID > 0 && enemy.TeamID == this.m_playerClassInstance.Team))
                     {
                        closest_enemy = enemy;
                        distance = distance2;
                     }
                  }
               }
               if(closest_enemy != null)
               {
                  if(distance < this.m_playerClassInstance.Width * 2)
                  {
                     this.resetAllKeys();
                     if(this.m_playerClassInstance.CollisionObj.ground && this.execIfSmartEnough() || this.execIfDumbEnough())
                     {
                        this.m_keys.JUMP = true;
                     }
                     else
                     {
                        this.m_keys.SHIELD = true;
                        if(this.m_playerClassInstance.CollisionObj.ground)
                        {
                           this.m_shieldHoldTimer.reset();
                           this.m_shieldTimer.reset();
                           this.m_action = CPUState.SHIELD;
                           this.m_shieldHoldTimer.MaxTime = Utils.randomInteger(10,45);
                           this.m_dodgeTimer.MaxTime = Utils.randomInteger(10,30);
                           this.m_shieldProjectile = false;
                        }
                     }
                     this.m_projectileWarningTimer.reset();
                  }
               }
            }
         }
      }
      
      private function checkItemAvoidance() : void
      {
         var i:int = 0;
         var j:int = 0;
         var closest_item:Item = null;
         var distance:Number = -1;
         var distance2:Number = -1;
         var item:Item = null;
         if(this.m_forceAction < 0 && !this.m_recovering)
         {
            this.m_itemTimer.tick();
            if(this.m_itemTimer.IsComplete && this.execIfSmartEnough())
            {
               this.m_itemTimer.reset();
               for(i = 0; i < this.STAGEDATA.ItemsRef.ItemsInUse.length; i++)
               {
                  item = this.STAGEDATA.ItemsRef.getItemData(i);
                  if(item != null)
                  {
                     distance2 = Utils.getDistanceFrom(this.m_playerClassInstance,item);
                     if((distance < 0 || distance2 < distance) && (item.inState(IState.TOSS) || item.Dangerous) && item.PlayerID != this.m_playerClassInstance.ID && !(item.TeamID > 0 && item.TeamID == this.m_playerClassInstance.Team))
                     {
                        closest_item = item;
                        distance = distance2;
                     }
                  }
               }
               if(closest_item != null)
               {
                  if(distance < this.m_playerClassInstance.Width * 2)
                  {
                     this.resetAllKeys();
                     if(Utils.random() > this.execIfSmartEnough())
                     {
                        this.m_keys.SHIELD = true;
                        if(this.m_playerClassInstance.CollisionObj.ground)
                        {
                           this.m_shieldHoldTimer.reset();
                           this.m_shieldTimer.reset();
                           this.m_action = CPUState.SHIELD;
                           this.m_shieldHoldTimer.MaxTime = Utils.randomInteger(10,30);
                           this.m_dodgeTimer.MaxTime = Utils.randomInteger(10,25);
                        }
                     }
                     else
                     {
                        this.m_keys.JUMP = true;
                     }
                     this.m_shieldProjectile = false;
                  }
               }
            }
         }
      }
      
      private function checkConfusion() : void
      {
         this.m_confusionTimer.tick();
         if(this.m_forceAction < 0 && !this.m_confusionTimer.IsComplete)
         {
            if(this.m_confusionTimer.CurrentTime == 1)
            {
               this.resetAllKeys();
            }
            else
            {
               this.restoreKeyHistory();
            }
            if(this.m_confusionTimer.CurrentTime % 10 == 0)
            {
               if(this.m_keys_hist.SHIELD)
               {
                  this.m_keys.SHIELD = false;
               }
               if(Utils.random() > 0.5)
               {
                  this.m_keys.LEFT = true;
                  this.m_keys.RIGHT = false;
               }
               else
               {
                  this.m_keys.LEFT = false;
                  this.m_keys.RIGHT = true;
               }
               if(!this.m_keys_hist.JUMP)
               {
                  if(Utils.random() < 0.15)
                  {
                     this.m_keys.JUMP = true;
                  }
               }
               if(this.m_level > 0 && this.execIfSmartEnough())
               {
                  this.m_keys.BUTTON2 = Utils.random() < 0.25;
                  if(!this.m_keys.BUTTON2 && !this.m_keys_hist.SHIELD)
                  {
                     this.m_keys.SHIELD = Utils.random() < 0.15;
                  }
               }
            }
            if(this.m_keys_hist.JUMP)
            {
               this.m_keys.JUMP = false;
            }
         }
      }
      
      private function checkDI() : void
      {
         if(Boolean(this.m_forceAction < 0 && this.m_playerClassInstance.inState(CState.INJURED) && this.m_playerClassInstance.isHitStunOrParalysis()) && Boolean(this.m_target) && Boolean(this.m_target.CurrentTarget))
         {
            this.resetAllKeys();
            if(this.m_target.CurrentTarget.X >= this.m_playerClassInstance.X)
            {
               this.m_keys.LEFT = !this.m_keys_hist.LEFT;
            }
            if(this.m_target.CurrentTarget.X < this.m_playerClassInstance.X)
            {
               this.m_keys.RIGHT = !this.m_keys_hist.RIGHT;
            }
            if(this.m_target.CurrentTarget.Y < this.m_playerClassInstance.Y)
            {
               this.m_keys.DOWN = !this.m_keys_hist.DOWN;
            }
            if(this.m_target.CurrentTarget.Y >= this.m_playerClassInstance.Y)
            {
               this.m_keys.UP = !this.m_keys_hist.UP;
            }
         }
         else if(Boolean(this.m_forceAction < 0 && this.m_playerClassInstance.inState(CState.FLYING) && this.m_playerClassInstance.isHitStunOrParalysis()) && Boolean(this.m_target) && Boolean(this.m_target.CurrentTarget))
         {
            this.resetAllKeys();
            if(this.m_target.CurrentTarget.X >= this.m_playerClassInstance.X)
            {
               this.m_keys.RIGHT = !this.m_keys_hist.RIGHT;
            }
            if(this.m_target.CurrentTarget.X < this.m_playerClassInstance.X)
            {
               this.m_keys.LEFT = !this.m_keys_hist.LEFT;
            }
            if(this.m_target.CurrentTarget.Y >= this.m_playerClassInstance.Y)
            {
               this.m_keys.DOWN = !this.m_keys_hist.DOWN;
            }
            if(this.m_target.CurrentTarget.Y < this.m_playerClassInstance.Y)
            {
               this.m_keys.UP = !this.m_keys_hist.UP;
            }
         }
      }
      
      private function checkTaunt() : void
      {
         var id:int = 0;
         if(this.m_forceAction < 0 && this.m_tauntTrigger && !this.m_recovering && this.m_playerClassInstance.inFreeState() && this.m_playerClassInstance.CollisionObj.ground)
         {
            if(!this.m_target || !this.m_target.CurrentTarget || this.m_target.Distance > 150 || this.m_action == CPUState.IDLE || Boolean(this.m_target.PlayerSprite) && (Boolean(this.m_target.PlayerSprite.inState(CState.REVIVAL) || this.m_target.PlayerSprite.inState(CState.SCREEN_KO) || this.m_target.PlayerSprite.inState(CState.STAR_KO))))
            {
               this.resetAllKeys();
               this.m_keys.TAUNT = true;
               id = Utils.randomInteger(1,3);
               if(id != 1)
               {
                  if(id == 2)
                  {
                     this.m_keys.DOWN = true;
                  }
                  else if(id == 3)
                  {
                     if(Utils.random() > 0.5)
                     {
                        this.m_keys.RIGHT = true;
                     }
                     else
                     {
                        this.m_keys.LEFT = true;
                     }
                  }
               }
            }
            this.m_tauntTrigger = false;
         }
      }
      
      private function checkTech() : void
      {
         var speed:Number = NaN;
         var point1:Point = null;
         var x_speed:Number = NaN;
         var y_speed:Number = NaN;
         var point2:Point = null;
         if(this.m_forceAction < 0 && (this.m_playerClassInstance.inState(CState.FLYING) || this.m_playerClassInstance.inState(CState.TUMBLE_FALL)) && this.execIfSmartEnough())
         {
            speed = this.m_playerClassInstance.netSpeed();
            if(Utils.random() > speed / 40 && Utils.LastRandom <= 1)
            {
               return;
            }
            point1 = new Point(this.m_playerClassInstance.X,this.m_playerClassInstance.Y);
            x_speed = 0;
            y_speed = 0;
            x_speed = this.m_playerClassInstance.netXSpeed();
            y_speed = this.m_playerClassInstance.netYSpeed();
            point2 = new Point(point1.x + x_speed,point1.y + y_speed + 2);
            if(!this.m_playerClassInstance.checkLinearPathBetweenPoints(point1,point2,false) && !this.m_keys.SHIELD)
            {
               if(!this.m_keys.SHIELD)
               {
                  this.resetAllKeys();
                  if(Utils.random() > 0.25)
                  {
                     if(Boolean(this.m_target && this.m_target.CurrentTarget) && Boolean(this.m_target.CurrentTarget.X >= this.m_playerClassInstance.X) || Utils.random() < 0.5)
                     {
                        this.m_keys.LEFT = true;
                     }
                     else
                     {
                        this.m_keys.RIGHT = true;
                     }
                  }
               }
               this.m_keys.SHIELD = true;
            }
            else
            {
               this.m_keys.SHIELD = false;
            }
         }
      }
      
      private function checkGetup() : void
      {
         if(this.m_forceAction < 0 && this.m_playerClassInstance.inState(CState.CRASH_LAND) && this.execIfSmartEnough())
         {
            this.resetAllKeys();
            this.getNearestOpponent();
            if(Boolean(this.m_target != null && this.m_target.PlayerSprite) && Boolean(this.m_target.Distance < 40) && this.execIfSmartEnough())
            {
               if(this.m_target.PlayerSprite.inState(CState.ATTACKING))
               {
                  if(this.m_target.CurrentTarget.X > this.m_playerClassInstance.X)
                  {
                     this.m_keys.LEFT = true;
                  }
                  else
                  {
                     this.m_keys.RIGHT = true;
                  }
               }
               else
               {
                  this.m_keys.BUTTON2 = true;
               }
            }
            else if(this.m_target != null && Boolean(this.m_target.CurrentTarget))
            {
               if(Utils.random() > 0.5 && this.m_target.Distance > 90)
               {
                  this.m_keys.UP = true;
               }
               else if(this.m_target.CurrentTarget.X > this.m_playerClassInstance.X)
               {
                  this.m_keys.LEFT = true;
               }
               else
               {
                  this.m_keys.RIGHT = true;
               }
            }
         }
      }
      
      private function checkShortHop() : void
      {
         if(this.m_forceAction < 0 || this.m_forceAction == CPUState.FORCE_JUMP || this.m_forceAction == CPUState.CHASE)
         {
            if(this.m_forceAction == CPUState.FORCE_JUMP)
            {
               if(this.m_playerClassInstance.inState(CState.JUMP_CHAMBER))
               {
                  this.m_keys.JUMP = true;
               }
            }
            else if(this.m_playerClassInstance.inState(CState.JUMP_CHAMBER))
            {
               if(Boolean(this.m_target && this.m_target.CurrentTarget && (this.m_target.CurrentTarget.Y < this.m_playerClassInstance.Y && this.m_target.YDistance > 85 || !this.m_projectileWarningTimer.IsComplete)) && Boolean(this.execIfSmartEnough()) || this.m_level === 0 && Utils.random() < 0.9)
               {
                  this.m_keys.JUMP = true;
               }
            }
         }
      }
      
      private function checkGliding() : void
      {
         if(this.m_recovering)
         {
            if((this.m_playerClassInstance.CollisionObj.lbound_lower || this.m_playerClassInstance.CollisionObj.lbound_upper) && this.m_playerClassInstance.inState(CState.GLIDING) && !this.m_playerClassInstance.FacingForward)
            {
               this.resetAllKeys();
               this.m_keys.BUTTON2 = !this.m_keys_hist.BUTTON2;
            }
            else if((this.m_playerClassInstance.CollisionObj.rbound_lower || this.m_playerClassInstance.CollisionObj.rbound_upper) && this.m_playerClassInstance.inState(CState.GLIDING) && this.m_playerClassInstance.FacingForward)
            {
               this.resetAllKeys();
               this.m_keys.BUTTON2 = !this.m_keys_hist.BUTTON2;
            }
            if(this.m_keys_hist.BUTTON1 && this.m_keys.BUTTON1)
            {
               this.m_keys.BUTTON1 = false;
            }
         }
      }
      
      private function checkAttackQueue() : void
      {
         if(this.m_currentAttackQueue.length > 0 && !this.m_playerClassInstance.inState(CState.ATTACKING))
         {
            this.m_currentAttackQueueTimer.tick();
            if(this.m_currentAttackQueueTimer.IsComplete)
            {
               this.m_currentAttackQueueTimer.reset();
               while(this.m_currentAttackQueue.length > 0)
               {
                  this.m_currentAttackQueue.splice(0,1);
               }
            }
         }
      }
      
      private function checkBarrel() : void
      {
         var ground:Platform = null;
         if(this.m_playerClassInstance.inState(CState.BARREL) && this.execIfSmartEnough())
         {
            this.resetAllKeys();
            this.m_keys.BUTTON2 = !this.m_keys_hist.BUTTON2;
         }
      }
      
      private function checkBored() : void
      {
         var checkCliffs:Boolean = false;
         if(this.m_forceAction < 0 && !this.m_recovering && (!this.m_target || !this.m_target.CurrentTarget))
         {
            checkCliffs = false;
            if(this.m_playerClassInstance.inState(CState.IDLE) && !this.m_keys_hist.LEFT && !this.m_keys_hist.RIGHT)
            {
               this.m_boredTimer.tick();
               if(this.m_boredTimer.IsComplete)
               {
                  this.m_keys.RIGHT = Utils.random() > 0.65;
                  this.m_keys.LEFT = !this.m_keys.RIGHT;
                  this.m_keys.DASH = Utils.random() > 0.85;
                  this.m_running = this.m_keys.DASH;
                  if(Utils.random() < 0.3)
                  {
                     this.m_keys.JUMP = true;
                  }
                  this.m_playerClassInstance.calculateAICollision(this.m_playerClassInstance.netXSpeed(),this.m_playerClassInstance.netYSpeed());
                  checkCliffs = true;
                  this.m_boredActionTimer.reset();
                  this.m_boredTimer.reset();
               }
            }
            else if(this.m_keys_hist.LEFT || !this.m_keys_hist.RIGHT)
            {
               this.m_keys.LEFT = this.m_keys_hist.LEFT;
               this.m_keys.RIGHT = this.m_keys_hist.RIGHT;
               this.m_boredActionTimer.tick();
               if(this.m_boredActionTimer.IsComplete)
               {
                  if(Utils.random() > 0.4)
                  {
                     if(Utils.random() < 0.3)
                     {
                        this.m_keys.JUMP = true;
                     }
                     this.m_keys.RIGHT = !this.m_keys_hist.RIGHT;
                     this.m_keys.LEFT = !this.m_keys_hist.LEFT;
                     this.m_keys.DASH = Utils.random() > 0.85;
                     checkCliffs = true;
                  }
                  else
                  {
                     if(Utils.random() < 0.2)
                     {
                        this.m_keys.TAUNT = true;
                        if(Utils.random() < 0.3)
                        {
                           if(Utils.random() < 0.5)
                           {
                              this.m_keys.DOWN = Utils.random() < 0.5;
                           }
                           else
                           {
                              this.m_keys.RIGHT = Utils.random() < 0.5;
                              this.m_keys.LEFT = !this.m_keys.RIGHT;
                           }
                        }
                     }
                     this.m_keys.RIGHT = false;
                     this.m_keys.LEFT = false;
                  }
                  this.m_boredActionTimer.reset();
                  this.m_boredTimer.reset();
               }
            }
            if(checkCliffs)
            {
               if(this.m_playerClassInstance.FacingForward && this.m_keys.RIGHT && (this.m_playerClassInstance.willFallOffRange(this.m_playerClassInstance.X + 10,this.m_playerClassInstance.Y,9) || this.m_playerClassInstance.CollisionObj.rightSide))
               {
                  this.m_keys.RIGHT = false;
                  this.m_keys.LEFT = true;
                  this.m_keys.DASH = true;
               }
               else if(!this.m_playerClassInstance.FacingForward && this.m_keys.LEFT && (this.m_playerClassInstance.willFallOffRange(this.m_playerClassInstance.X - 10,this.m_playerClassInstance.Y,9) || this.m_playerClassInstance.CollisionObj.leftSide))
               {
                  this.m_keys.RIGHT = true;
                  this.m_keys.LEFT = false;
                  this.m_keys.DASH = true;
               }
            }
         }
      }
      
      private function checkHover() : void
      {
         if(this.m_forceAction < 0 && this.m_playerClassInstance.MidAirHover > 0 && !this.m_playerClassInstance.CollisionObj.ground && (this.m_playerClassInstance.inState(CState.JUMP_RISING) || this.m_playerClassInstance.inState(CState.JUMP_MIDAIR_RISING) || this.m_playerClassInstance.inState(CState.JUMP_FALLING) || this.m_playerClassInstance.inState(CState.HOVER) || this.m_playerClassInstance.inState(CState.ATTACKING) && this.m_playerClassInstance.AttackHovering))
         {
            if(this.m_playerClassInstance.inState(CState.HOVER) || this.m_playerClassInstance.inState(CState.ATTACKING) && this.m_playerClassInstance.AttackHovering)
            {
               this.m_hoverTimer.tick();
               if(this.m_hoverTimer.IsComplete && !this.m_initatedAttack && this.m_playerClassInstance.inState(CState.HOVER) && Utils.random() < 0.25)
               {
                  this.m_keys.UP = false;
                  this.m_keys.DOWN = false;
               }
               else if(this.m_hoverTimer.IsComplete && (this.m_playerClassInstance.inState(CState.ATTACKING) && this.m_playerClassInstance.AttackHovering) && !this.m_initatedAttack && Utils.random() < 0.15)
               {
                  this.m_keys.UP = false;
                  this.m_keys.DOWN = false;
               }
               else if(!this.m_initatedAttack)
               {
                  this.m_keys.UP = true;
                  this.m_keys.DOWN = true;
               }
               else
               {
                  this.m_keys.JUMP = true;
               }
            }
            else if(this.m_playerClassInstance.CanHover && !this.m_initatedAttack)
            {
               this.m_hoverTimer.tick();
               if(this.m_hoverTimer.IsComplete)
               {
                  this.m_hoverTimer.reset();
                  if(Utils.random() < 0.1 || this.m_recovering && Utils.LastRandom < 0.85)
                  {
                     this.m_keys.UP = true;
                     this.m_keys.DOWN = true;
                     this.m_hoverTimer.reset();
                  }
               }
            }
         }
      }
      
      private function checkFinalActions() : void
      {
         if(this.checkControlOverrides())
         {
            return;
         }
         this.checkEvadeOverride();
         this.checkFranticEvade();
         this.checkStruggle();
         this.checkItemToss();
         this.checkItemGiveUp();
         this.checkWallBlock();
         this.checkItemPickup();
         this.checkDropThrough();
         this.checkAllowControl();
         this.checkProjectileControl();
         this.checkFinalSmash();
         this.checkRevival();
         this.checkProjectileAvoidance();
         this.checkEnemyAvoidance();
         this.checkItemAvoidance();
         this.checkDI();
         this.checkIdleness();
         this.checkTaunt();
         this.checkTech();
         this.checkGetup();
         this.checkShortHop();
         this.checkGliding();
         this.checkAttackQueue();
         this.checkDangerRecovery();
         this.checkFinalRecovery();
         this.checkHover();
         this.checkBarrel();
         this.checkBored();
         this.m_keys.DASH = this.m_running;
         this.checkConfusion();
      }
      
      private function runAttackTimer() : void
      {
         var distanceTolerance:Number = NaN;
         var xDistanceTolerance:Number = NaN;
         var yDistanceTolerance:Number = NaN;
         var item:Item = null;
         this.m_attackTimer.tick();
         if(this.m_attackTimer.IsComplete && this.m_action < 4)
         {
            this.m_attackTimer.reset();
            if(this.m_level === 0)
            {
               return;
            }
            this.getNearestOpponent();
            if(Boolean(!this.m_playerClassInstance.inState(CState.ATTACKING) && this.m_playerClassInstance.State != CState.SHIELDING) && (Boolean(this.m_target.PlayerSprite || this.m_target.ItemSprite && this.m_target.ItemSprite.IsSmashBall)) && this.execIfSmartEnough())
            {
               distanceTolerance = 60;
               xDistanceTolerance = 100;
               yDistanceTolerance = 40;
               if(this.m_currentAttackQueue.length >= 0)
               {
                  distanceTolerance *= 1.5;
                  xDistanceTolerance *= 1.3;
                  yDistanceTolerance *= 2;
               }
               if(Boolean(this.m_target.PlayerSprite) && (this.m_target.PlayerSprite.isInvincible() || this.m_target.PlayerSprite.isIntangible()))
               {
                  this.m_action = this.m_target.Distance < 20 && this.execIfSmartEnough() ? CPUState.INIT_SHIELD : CPUState.EVADE;
               }
               else if((Boolean(!this.m_playerClassInstance.CollisionObj.ground && this.m_target.Distance < distanceTolerance || this.m_playerClassInstance.CollisionObj.ground && this.m_target.Distance < 60 && this.m_target.XDistance < 35) || Boolean(this.m_target.PlayerSprite && this.m_target.XDistance > xDistanceTolerance && this.m_target.YDistance < yDistanceTolerance && Utils.random() < 0.35)) && !(this.execIfSmartEnough() && Boolean(this.m_target.PlayerSprite) && (this.m_target.PlayerSprite.isIntangible() || this.m_target.PlayerSprite.isInvincible())))
               {
                  this.m_action = CPUState.INIT_ATTACK;
               }
            }
            else if(Boolean(this.m_playerClassInstance.ItemObj == null && this.m_playerClassInstance.inFreeState()) && Boolean(this.m_target.ItemSprite) && this.execIfSmartEnough())
            {
               this.m_itemPickupTimer.tick();
               if(this.m_itemPickupTimer.IsComplete)
               {
                  item = this.m_target.ItemSprite;
                  if(Boolean(item) && Boolean(this.m_playerClassInstance.HasHitBox) && HitBoxSprite.hitTestArray(this.m_playerClassInstance.CurrentAnimation.getHitBoxes(this.m_playerClassInstance.CurrentFrameNum,HitBoxSprite.HIT),item.CurrentAnimation.getHitBoxes(item.CurrentFrameNum,HitBoxSprite.HIT),this.m_playerClassInstance.Location,item.Location,!this.m_playerClassInstance.FacingForward,!item.FacingForward,this.m_playerClassInstance.CurrentScale,item.CurrentScale,this.m_playerClassInstance.CurrentRotation,item.CurrentRotation).length > 0)
                  {
                     this.resetAllKeys();
                     this.m_keys.BUTTON2 = true;
                     this.m_itemPickup = true;
                  }
                  this.m_itemPickupTimer.reset();
               }
            }
         }
      }
      
      private function runShieldTimer() : void
      {
         this.m_shieldTimer.tick();
         if(this.m_playerClassInstance.State != CState.SHIELDING && this.m_action < 4)
         {
            if(this.m_shieldTimer.IsComplete)
            {
               this.m_shieldTimer.reset();
               this.m_shieldHoldTimer.reset();
               this.m_dodgeTimer.reset();
               this.getNearestOpponent();
               if(!this.m_playerClassInstance.inState(CState.ATTACKING) && this.m_playerClassInstance.State != CState.INJURED && this.m_playerClassInstance.State != CState.FLYING && this.m_playerClassInstance.ShieldPower > 35 && this.m_target.PlayerSprite != null && this.m_target.Distance < 50 && this.m_target.PlayerSprite.inState(CState.ATTACKING) && this.execIfSmartEnough())
               {
                  this.m_action = CPUState.INIT_SHIELD;
               }
            }
         }
      }
      
      private function runGrabTimer() : void
      {
         this.m_grabTimer.tick();
         if(this.m_playerClassInstance.State != CState.GRABBING && (this.m_action < 4 || this.m_action == CPUState.SHIELD))
         {
            if(this.m_grabTimer.IsComplete)
            {
               this.m_grabTimer.reset();
               this.m_grabHitTimer.reset();
               this.getNearestOpponent();
               if(Utils.random() > 0.5)
               {
                  this.m_grabHitTimer.finish();
               }
               if(!this.m_playerClassInstance.inState(CState.ATTACKING) && this.m_playerClassInstance.State != CState.INJURED && this.m_playerClassInstance.State != CState.FLYING && this.m_playerClassInstance.CollisionObj.ground && this.m_target.PlayerSprite != null && this.m_target.Distance <= 45 && this.execIfSmartEnough() && (this.m_target.CurrentTarget.X > this.m_playerClassInstance.X && this.m_playerClassInstance.FacingForward || this.m_target.CurrentTarget.X < this.m_playerClassInstance.X && !this.m_playerClassInstance.FacingForward) && !this.targetUsingDangerousFS() && !(this.m_target.PlayerSprite && (this.m_target.PlayerSprite.isIntangible() || this.m_target.PlayerSprite.isInvincible())))
               {
                  this.m_action = CPUState.INIT_GRAB;
               }
            }
         }
      }
      
      private function runBeaconTimer() : void
      {
         this.m_beaconTimer.tick();
         if(this.m_beaconTimer.IsComplete)
         {
            if(Boolean(this.m_target.BeaconSprite))
            {
               trace("regenerated path");
               this.m_shortestPath = null;
               this.getNearestOpponent();
            }
            this.m_beaconTimer.reset();
         }
      }
      
      private function runTargetTimer() : void
      {
         this.m_targetTimer.tick();
         if(this.m_targetTimer.IsComplete)
         {
            this.checkPotentialBeaconPath();
            this.m_targetTimer.reset();
         }
      }
      
      private function runHangTimer() : void
      {
         var choice:int = 0;
         this.m_hangTimer.tick();
         if(this.m_hangTimer.IsComplete && this.m_playerClassInstance.inState(CState.LEDGE_HANG))
         {
            this.resetAllKeys();
            if(this.m_target.CurrentTarget != null && this.m_target.CurrentTarget.Y > this.m_playerClassInstance.Y + 30 && !(this.m_target.PlayerSprite && this.m_target.PlayerSprite.WarningCollision))
            {
               if(this.m_playerClassInstance.FacingForward)
               {
                  this.tap_Left();
               }
               else
               {
                  this.tap_Right();
               }
            }
            else
            {
               choice = Utils.randomInteger(0,4);
               switch(choice)
               {
                  case 0:
                     this.jump();
                     break;
                  case 1:
                     if(this.m_playerClassInstance.FacingForward)
                     {
                        this.tap_Right();
                     }
                     else
                     {
                        this.tap_Left();
                     }
                     break;
                  case 2:
                     if(this.m_playerClassInstance.FacingForward)
                     {
                        this.tap_Left();
                     }
                     else
                     {
                        this.tap_Right();
                     }
                     break;
                  case 3:
                     this.tap_A();
                     break;
                  case 4:
                     this.tap_Shield();
               }
            }
            this.m_hangTimer.reset();
         }
      }
      
      private function idle() : void
      {
         this.resetAllKeys();
         this.m_idleTimer.tick();
         if(this.m_idleTimer.IsComplete && this.execIfSmartEnough(0.5))
         {
            this.getNearestOpponent();
            if(this.m_forceAction < 0 && this.m_target.CurrentTarget != null && !(Boolean(this.m_target.PlayerSprite) && this.m_target.Distance > 200 && (this.m_target.PlayerSprite.isIntangible() || this.m_target.PlayerSprite.isInvincible() || this.m_target.PlayerSprite.inState(CState.REVIVAL))))
            {
               if(this.m_target.Distance > 30)
               {
                  this.m_action = CPUState.CHASE;
                  this.m_runTimer.reset();
                  if(this.m_target.XDistance >= 100 && this.m_target.XDistance > 30 && (this.execIfSmartEnough(0.5) || this.m_level === 0 && Utils.random() > 0.8))
                  {
                     this.m_running = true;
                  }
                  else
                  {
                     this.m_running = false;
                  }
               }
               else if(Boolean(this.m_target) && Boolean(this.m_target.ItemSprite))
               {
                  if(this.m_target.Distance > this.m_target.ItemSprite.Width / 2)
                  {
                     if(this.m_target.ItemSprite.X >= this.m_playerClassInstance.X)
                     {
                        this.m_keys.RIGHT = true;
                     }
                     else if(this.m_target.ItemSprite.X < this.m_playerClassInstance.X)
                     {
                        this.m_keys.LEFT = true;
                     }
                  }
                  else if(this.m_level > 0)
                  {
                     this.m_keys.BUTTON2 = !this.m_keys_hist.BUTTON2;
                  }
               }
               else
               {
                  this.m_action = CPUState.ATTACK;
               }
            }
         }
         else if(this.m_idleTimer.IsComplete)
         {
            this.m_idleTimer.reset();
         }
      }
      
      private function chase() : void
      {
         this.m_runTimer.tick();
         this.resetAllKeys();
         if(this.m_target.CurrentTarget != null)
         {
            this.m_target.setDistance(new Point(this.m_playerClassInstance.X,this.m_playerClassInstance.Y));
            if(this.m_playerClassInstance.inState(CState.GLIDING) && (this.m_target.CurrentTarget.X < this.m_playerClassInstance.X && this.m_playerClassInstance.FacingForward || this.m_target.CurrentTarget.X > this.m_playerClassInstance.X && !this.m_playerClassInstance.FacingForward || this.m_target.Distance < 40))
            {
               this.m_keys.BUTTON2 = true;
            }
            if(this.m_target.CurrentTarget.X > this.m_playerClassInstance.X && (this.m_target.XDistance > 30 || this.m_target.BeaconSprite != null && this.m_target.XDistance > 15))
            {
               this.m_keys.RIGHT = true;
               this.m_keys.LEFT = false;
            }
            else if(this.m_target.CurrentTarget.X < this.m_playerClassInstance.X && (this.m_target.XDistance > 30 || this.m_target.BeaconSprite != null && this.m_target.XDistance > 15))
            {
               this.m_keys.RIGHT = false;
               this.m_keys.LEFT = true;
            }
            else
            {
               this.m_keys.RIGHT = false;
               this.m_keys.LEFT = false;
            }
            if((this.m_playerClassInstance.CollisionObj.ground && this.m_keys_hist.JUMP || !this.m_playerClassInstance.CollisionObj.ground && !this.m_keys_hist.JUMP) && this.m_target.CurrentTarget.Y < this.m_playerClassInstance.Y && (this.m_playerClassInstance.netYSpeed() >= 0 || this.m_playerClassInstance.CollisionObj.ground && this.m_playerClassInstance.CurrentPlatform != this.m_target.CurrentTarget.CurrentPlatform))
            {
               this.m_keys.JUMP = true;
            }
            else
            {
               this.m_keys.JUMP = false;
            }
            if(!this.m_keys_hist.JUMP)
            {
               this.m_jumpTimer.tick();
            }
            if(this.m_jumpTimer.IsComplete)
            {
               this.m_jumpTimer.reset();
               this.m_playerClassInstance.calculateAICollision(this.m_playerClassInstance.netXSpeed(),this.m_playerClassInstance.netYSpeed());
               if(this.m_playerClassInstance.JumpCount < this.m_playerClassInstance.MaxJump && (this.m_target.CurrentTarget.Y < this.m_playerClassInstance.Y && this.m_target.YDistance > 40 && this.m_target.XDistance < 60 || this.m_target.CurrentTarget.Y < this.m_playerClassInstance.Y && (this.m_keys.RIGHT && this.m_playerClassInstance.CollisionObj.rightSide || this.m_keys.LEFT && this.m_playerClassInstance.CollisionObj.leftSide)) && (this.m_forceAction == CPUState.CHASE || this.m_forceAction != CPUState.CHASE && this.execIfSmartEnough(0.5)))
               {
                  this.m_keys.JUMP = !this.m_keys_hist.JUMP;
               }
               else if(Boolean(this.m_level > 0 && this.m_playerClassInstance.CharacterStats.CanUseSpecials && this.m_target.BeaconSprite && this.m_playerClassInstance.JumpCount >= this.m_playerClassInstance.MaxJump) && (Boolean(this.m_target.CurrentTarget.Y < this.m_playerClassInstance.Y && this.m_target.YDistance > 10 && this.m_target.XDistance < 60 || this.m_target.CurrentTarget.Y < this.m_playerClassInstance.Y && (this.m_keys.RIGHT && this.m_playerClassInstance.CollisionObj.rightSide || this.m_keys.LEFT && this.m_playerClassInstance.CollisionObj.leftSide))) && this.m_playerClassInstance.netYSpeed() > -1)
               {
                  this.B_attackUp();
               }
               else if(Boolean(this.m_forceAction < 0 && this.m_target && this.m_target.PlayerSprite && this.m_target.Distance < 75) && Boolean(this.execIfSmartEnough(0.5)) && this.m_playerClassInstance.CollisionObj.ground)
               {
                  this.m_keys.JUMP = true;
               }
               else if(this.m_keys_hist.JUMP)
               {
                  this.m_keys.JUMP = false;
               }
            }
            if(this.m_target.CurrentTarget != null && this.m_playerClassInstance.CollisionObj.ground && this.m_playerClassInstance.State != CState.INJURED && this.m_playerClassInstance.State != CState.FLYING && this.m_target.YDistance > 20 * this.m_playerClassInstance.SizeRatio && this.m_target.CurrentTarget.Y > this.m_playerClassInstance.Y && this.m_playerClassInstance.CurrentPlatform != null && this.STAGEDATA.Platforms.indexOf(this.m_playerClassInstance.CurrentPlatform) >= 0 && (this.m_forceAction == CPUState.CHASE || this.m_forceAction != CPUState.CHASE && this.execIfSmartEnough(0.5)) && this.m_playerClassInstance.CurrentPlatform.noDropThrough != true)
            {
               this.resetAllKeys();
               this.m_keys.DOWN = true;
               this.m_fallthrough = true;
               this.m_fallthroughTimer.reset();
            }
            else
            {
               this.m_fallthrough = false;
            }
            if(this.m_playerClassInstance.inState(CState.LEDGE_HANG))
            {
               this.runHangTimer();
            }
            else if(Boolean(this.m_target) && Boolean(this.m_target.BeaconSprite) && this.m_playerClassInstance.CollisionObj.ground)
            {
               if(this.m_recovering && (this.m_playerClassInstance.YSpeed > 0 || this.m_playerClassInstance.HoldJump && this.m_playerClassInstance.JumpCount > 1))
               {
                  this.jump();
               }
            }
            else if(Boolean(this.m_target) && Boolean(this.m_target.ItemSprite))
            {
               if(this.m_target.Distance > this.m_target.ItemSprite.Width / 2)
               {
                  if(this.m_target.ItemSprite.X >= this.m_playerClassInstance.X)
                  {
                     this.m_keys.RIGHT = true;
                  }
                  else if(this.m_target.ItemSprite.X < this.m_playerClassInstance.X)
                  {
                     this.m_keys.LEFT = true;
                  }
               }
               else
               {
                  this.m_keys.BUTTON2 = !this.m_keys_hist.BUTTON2;
               }
            }
            else if(Boolean(this.m_target) && Boolean(this.m_target.PlayerSprite) && (this.m_target.PlayerSprite.isInvincible() || this.m_target.PlayerSprite.isIntangible() || this.m_target.PlayerSprite.inState(CState.REVIVAL)))
            {
               this.m_evadeTimer.reset();
               this.m_idleTimer.reset();
               if(this.m_target.Distance > 200)
               {
                  this.m_action = CPUState.IDLE;
               }
               else
               {
                  this.m_action = CPUState.EVADE;
               }
            }
         }
         else
         {
            this.m_action = CPUState.IDLE;
            this.m_idleTimer.reset();
            this.resetAllKeys();
         }
         if(this.m_runTimer.IsComplete && this.m_action != CPUState.EVADE)
         {
            this.getNearestOpponent();
            if(this.m_forceAction < 0 && (this.m_target.CurrentTarget == null || this.m_target.CurrentTarget != null && this.execIfSmartEnough()))
            {
               this.m_action = CPUState.IDLE;
               this.m_idleTimer.reset();
               this.resetAllKeys();
            }
            else
            {
               this.m_runTimer.reset();
               if(this.m_target.CurrentTarget != null && this.m_target.XDistance >= 100 && this.m_target.XDistance > 30 && this.execIfSmartEnough(0.5))
               {
                  this.m_running = true;
               }
               else
               {
                  this.m_running = false;
               }
            }
         }
      }
      
      private function evade() : void
      {
         this.m_evadeTimer.tick();
         this.resetAllKeys();
         if(this.m_target.CurrentTarget != null)
         {
            if(this.m_evadeOverrideTimer.IsComplete)
            {
               if(this.m_target.CurrentTarget.X <= this.m_playerClassInstance.X && (Boolean(this.m_target.XDistance < 120) || Boolean(this.m_target.PlayerSprite && this.m_target.PlayerSprite.UsingFinalSmash && this.m_target.PlayerSprite.SpecialType == 0)))
               {
                  this.m_keys.RIGHT = true;
                  this.m_keys.LEFT = false;
               }
               else if(this.m_target.CurrentTarget.X > this.m_playerClassInstance.X && (Boolean(this.m_target.XDistance < 120) || Boolean(this.m_target.PlayerSprite && this.m_target.PlayerSprite.UsingFinalSmash && this.m_target.PlayerSprite.SpecialType == 0)))
               {
                  this.m_keys.RIGHT = false;
                  this.m_keys.LEFT = true;
               }
               else
               {
                  this.m_keys.RIGHT = false;
                  this.m_keys.LEFT = false;
               }
            }
            else
            {
               this.m_evadeOverrideTimer.tick();
               this.m_keys.RIGHT = this.m_evadeRight;
               this.m_keys.LEFT = !this.m_evadeRight;
            }
            if(this.m_keys_hist.JUMP && this.m_target.XDistance < 20 && this.m_playerClassInstance.netYSpeed() <= 0 && this.m_target.YDistance < 30)
            {
               this.m_keys.JUMP = true;
            }
            else
            {
               this.m_keys.JUMP = false;
            }
            if(!this.m_keys_hist.JUMP)
            {
               this.m_jumpTimer.tick();
            }
            if(this.m_jumpTimer.IsComplete)
            {
               this.m_jumpTimer.reset();
               if(this.m_playerClassInstance.JumpCount < this.m_playerClassInstance.MaxJump && (this.m_target.YDistance < 40 && this.m_target.XDistance < 20 || !this.m_evadeOverrideTimer.IsComplete) && (this.m_forceAction == CPUState.EVADE || this.m_forceAction != CPUState.EVADE && this.execIfSmartEnough(0.5)))
               {
                  this.m_keys.JUMP = true;
               }
            }
            if(this.m_target.CurrentTarget != null && this.m_playerClassInstance.CollisionObj.ground && this.m_playerClassInstance.State != CState.INJURED && this.m_playerClassInstance.State != CState.FLYING && this.m_target.YDistance > 20 * this.m_playerClassInstance.SizeRatio && this.m_target.CurrentTarget.Y < this.m_playerClassInstance.Y && this.m_playerClassInstance.CurrentPlatform != null && this.STAGEDATA.Platforms.indexOf(this.m_playerClassInstance.CurrentPlatform) >= 0 && this.execIfSmartEnough(0.5) && this.m_playerClassInstance.CurrentPlatform.noDropThrough != true)
            {
               this.resetAllKeys();
               this.m_keys.DOWN = true;
               this.m_fallthrough = true;
               this.m_fallthroughTimer.reset();
            }
            else
            {
               this.m_fallthrough = false;
            }
         }
         else
         {
            this.m_action = CPUState.IDLE;
            this.m_idleTimer.reset();
            this.resetAllKeys();
         }
         if(this.m_evadeTimer.IsComplete)
         {
            this.getNearestOpponent();
            if(this.m_forceAction < 0 && (this.m_target.CurrentTarget == null || this.m_target.CurrentTarget != null && this.execIfSmartEnough(0.5)))
            {
               this.m_action = CPUState.IDLE;
               this.m_idleTimer.reset();
               this.resetAllKeys();
            }
            else
            {
               this.m_evadeTimer.reset();
               if(this.execIfSmartEnough())
               {
                  this.m_action = CPUState.CHASE;
               }
               if(this.m_target.CurrentTarget != null && this.m_target.XDistance <= 80 && this.execIfSmartEnough(0.5))
               {
                  this.m_running = true;
               }
               else
               {
                  this.m_running = false;
               }
            }
         }
      }
      
      private function shield() : void
      {
         this.resetAllKeys();
         if(this.m_playerClassInstance.State != CState.DODGE_ROLL && this.m_playerClassInstance.State != CState.AIR_DODGE && this.m_playerClassInstance.State != CState.SIDESTEP_DODGE)
         {
            this.m_shieldHoldTimer.tick();
            this.m_dodgeTimer.tick();
         }
         if(Boolean(!this.m_playerClassInstance.CollisionObj.ground) || Boolean(this.m_target && this.m_target.PlayerSprite && this.m_target.Distance > 120 && !this.targetUsingDangerousFS() && this.m_playerClassInstance.State != CState.SHIELDING) || this.m_playerClassInstance.inState(CState.SHIELDING) && (this.m_playerClassInstance.ShieldPower < 20 || this.m_shieldHoldTimer.IsComplete && this.execIfDumbEnough()))
         {
            this.resetAllKeys();
            if(this.execIfSmartEnough(0.5))
            {
               this.m_action = CPUState.EVADE;
            }
            else
            {
               this.m_action = CPUState.IDLE;
            }
            this.m_shieldTimer.reset();
         }
         else if(this.m_playerClassInstance.inState(CState.SHIELDING))
         {
            this.m_keys.SHIELD = true;
            if(this.m_dodgeTimer.IsComplete)
            {
               this.m_dodgeTimer.reset();
               if(this.m_target.CurrentTarget != null && this.execIfSmartEnough())
               {
                  if(Utils.random() > 0.5)
                  {
                     this.m_keys.DOWN = true;
                  }
                  else
                  {
                     if(this.m_target.CurrentTarget.X > this.m_playerClassInstance.X)
                     {
                        this.m_keys.LEFT = true;
                     }
                     else
                     {
                        this.m_keys.RIGHT = true;
                     }
                     if(this.m_shieldProjectile)
                     {
                        this.m_keys.LEFT = !this.m_keys.LEFT;
                        this.m_keys.RIGHT = !this.m_keys.RIGHT;
                     }
                  }
               }
            }
         }
      }
      
      private function targetUsingDangerousFS() : Boolean
      {
         return Boolean(this.m_target.PlayerSprite) && this.m_target.PlayerSprite.UsingFinalSmash && this.m_target.PlayerSprite.SpecialType > 3;
      }
      
      private function grab() : void
      {
         var randNum:int = 0;
         this.resetAllKeys();
         if(this.m_playerClassInstance.State != CState.GRABBING)
         {
            this.m_grabHitTimer.tick();
            if(this.m_grabHitTimer.IsComplete)
            {
               this.resetAllKeys();
               this.m_action = CPUState.CHASE;
            }
         }
         else if(this.m_playerClassInstance.Grabbed.length > 0)
         {
            this.m_grabHitTimer.tick();
            if(this.m_grabHitTimer.IsComplete)
            {
               this.m_keys.BUTTON2 = false;
               randNum = Utils.randomInteger(1,4);
               switch(randNum)
               {
                  case 1:
                     this.m_keys.UP = true;
                     break;
                  case 2:
                     this.m_keys.DOWN = true;
                     break;
                  case 3:
                     this.m_keys.LEFT = true;
                     break;
                  case 4:
                     this.m_keys.RIGHT = true;
               }
            }
            else
            {
               this.m_keys.BUTTON2 = !this.m_keys_hist.BUTTON2;
            }
         }
      }
      
      private function chooseAttack() : void
      {
         var angle:Number = NaN;
         var tmpFunc:Function = null;
         this.m_initatedAttack = true;
         var justFinishedQueue:Boolean = false;
         this.m_currentAttack = null;
         if(this.m_level > 0 && this.m_target.CurrentTarget != null)
         {
            angle = this.getAngleOfOpponent();
            if(this.m_currentAttackQueue.length > 0)
            {
               this.m_currentAttackQueueTimer.reset();
               tmpFunc = this.getAttackFunction(this.m_currentAttackQueue[0]);
               this.m_currentAttackQueue.splice(0,1);
               if(tmpFunc != null)
               {
                  tmpFunc();
               }
               if(this.m_currentAttackQueue.length <= 0)
               {
                  justFinishedQueue = true;
               }
            }
            else if((Utils.random() > 0.25 || !this.m_playerClassInstance.CharacterStats.CanUseSpecials || !this.m_playerClassInstance.CollisionObj.ground && this.execIfDumbEnough()) && this.m_target.Distance < 100)
            {
               if(this.m_playerClassInstance.CollisionObj.ground)
               {
                  if(this.m_playerClassInstance.HasSmashBall && !this.getDisabledAttack("b"))
                  {
                     this.B_attack();
                  }
                  if((angle >= 0 && angle < 45 || angle >= 330 && angle < 360) && !this.getDisabledAttack("a_forwardsmash"))
                  {
                     if(Utils.random() < 0.5)
                     {
                        this.A_attackRight();
                     }
                     else if(Utils.random() < 0.5)
                     {
                        this.A_attackDown();
                     }
                     else
                     {
                        this.A_attack();
                     }
                  }
                  else if(angle >= 135 && angle < 210 && !this.getDisabledAttack("a_forwardsmash"))
                  {
                     if(Utils.random() < 0.5)
                     {
                        this.A_attackLeft();
                     }
                     else if(Utils.random() < 0.5)
                     {
                        this.A_attackDown();
                     }
                     else
                     {
                        this.A_attack();
                     }
                  }
                  else if(angle >= 45 && angle < 135 && !this.getDisabledAttack("a_up"))
                  {
                     this.A_attackUp();
                  }
                  else
                  {
                     switch(Math.round(Utils.random() * 1) + 1)
                     {
                        case 1:
                           if(this.m_playerClassInstance.FacingForward && !this.getDisabledAttack("a_forwardsmash"))
                           {
                              this.A_attackRight();
                           }
                           else if(!this.getDisabledAttack("a_forwardsmash"))
                           {
                              this.A_attackLeft();
                           }
                           break;
                        case 2:
                           if(!this.getDisabledAttack("a_up"))
                           {
                              this.A_attackUp();
                           }
                     }
                  }
               }
               else if(!this.m_playerClassInstance.CollisionObj.lbound_upper && !this.m_playerClassInstance.CollisionObj.rbound_upper && !this.m_playerClassInstance.CollisionObj.lbound_lower && !this.m_playerClassInstance.CollisionObj.rbound_lower)
               {
                  if(angle >= 0 && angle < 45 || angle >= 315 && angle < 360)
                  {
                     if(Utils.random() > 0.5 && !(this.m_playerClassInstance.FacingForward && this.getDisabledAttack("a_air_forward") || !this.m_playerClassInstance.FacingForward && this.getDisabledAttack("a_air_backward")))
                     {
                        this.A_attackRightAir();
                     }
                     else if(!this.getDisabledAttack("a_air"))
                     {
                        this.A_attackAir();
                     }
                  }
                  else if(angle >= 135 && angle < 225)
                  {
                     if(Utils.random() > 0.5 && !(!this.m_playerClassInstance.FacingForward && this.getDisabledAttack("a_air_forward") || this.m_playerClassInstance.FacingForward && this.getDisabledAttack("a_air_backward")))
                     {
                        this.A_attackLeftAir();
                     }
                     else if(!this.getDisabledAttack("a_air"))
                     {
                        this.A_attackAir();
                     }
                  }
                  else if(angle >= 45 && angle < 135 && !this.getDisabledAttack("a_air_up"))
                  {
                     this.A_attackUpAir();
                  }
                  else if(!this.getDisabledAttack("a_down"))
                  {
                     this.A_attackDownAir();
                  }
                  if(this.m_playerClassInstance.HasSmashBall)
                  {
                     this.B_attack();
                  }
               }
            }
            else if(this.m_playerClassInstance.CharacterStats.CanUseSpecials && !this.m_playerClassInstance.CollisionObj.lbound_upper && !this.m_playerClassInstance.CollisionObj.rbound_upper && !this.m_playerClassInstance.CollisionObj.lbound_lower && !this.m_playerClassInstance.CollisionObj.rbound_lower && this.m_target.Distance < 100)
            {
               if(angle >= 0 && angle < 45 || angle >= 315 && angle < 360)
               {
                  if(Utils.random() > 0.6 && !(this.m_playerClassInstance.CollisionObj.ground && this.getDisabledAttack("b_forward") || !this.m_playerClassInstance.CollisionObj.ground && this.getDisabledAttack("b_forward_air")))
                  {
                     this.B_attackRight();
                  }
                  else if(Utils.random() > 0.3 && !(this.m_playerClassInstance.CollisionObj.ground && this.getDisabledAttack("b") || !this.m_playerClassInstance.CollisionObj.ground && this.getDisabledAttack("b_air")))
                  {
                     this.B_attack();
                  }
                  else if(!(this.m_playerClassInstance.CollisionObj.ground && this.getDisabledAttack("b_down") || !this.m_playerClassInstance.CollisionObj.ground && this.getDisabledAttack("b_down_air")))
                  {
                     this.B_attackDown();
                  }
               }
               else if(angle >= 135 && angle < 225)
               {
                  if(Utils.random() > 0.6 && !(this.m_playerClassInstance.CollisionObj.ground && this.getDisabledAttack("b_forward") || !this.m_playerClassInstance.CollisionObj.ground && this.getDisabledAttack("b_forward_air")))
                  {
                     this.B_attackLeft();
                  }
                  else if(!(this.m_playerClassInstance.CollisionObj.ground && this.getDisabledAttack("b") || !this.m_playerClassInstance.CollisionObj.ground && this.getDisabledAttack("b_air")))
                  {
                     this.B_attack();
                  }
               }
               else if(angle >= 45 && angle < 135 && !(this.m_playerClassInstance.CollisionObj.ground && this.getDisabledAttack("b_up") || !this.m_playerClassInstance.CollisionObj.ground && this.getDisabledAttack("b_up_air")))
               {
                  this.B_attackUp();
               }
               else
               {
                  switch(Math.round(Utils.random() * 3) + 1)
                  {
                     case 1:
                        if(this.m_playerClassInstance.FacingForward && !(this.m_playerClassInstance.CollisionObj.ground && this.getDisabledAttack("b_forward") || !this.m_playerClassInstance.CollisionObj.ground && this.getDisabledAttack("b_forward_air")))
                        {
                           this.B_attackRight();
                        }
                        else if(!(this.m_playerClassInstance.CollisionObj.ground && this.getDisabledAttack("b_forward") || !this.m_playerClassInstance.CollisionObj.ground && this.getDisabledAttack("b_forward_air")))
                        {
                           this.B_attackLeft();
                        }
                        break;
                     case 2:
                        if(!(this.m_playerClassInstance.CollisionObj.ground && this.getDisabledAttack("b_up") || !this.m_playerClassInstance.CollisionObj.ground && this.getDisabledAttack("b_up_air")))
                        {
                           this.B_attackUp();
                        }
                        break;
                     case 3:
                        if(!(this.m_playerClassInstance.CollisionObj.ground && this.getDisabledAttack("b_down") || !this.m_playerClassInstance.CollisionObj.ground && this.getDisabledAttack("b_down_air")))
                        {
                           this.B_attackDown();
                        }
                        break;
                     case 4:
                        if(!(this.m_playerClassInstance.CollisionObj.ground && this.getDisabledAttack("b") || !this.m_playerClassInstance.CollisionObj.ground && this.getDisabledAttack("b_air")))
                        {
                           this.B_attack();
                        }
                  }
               }
               if(this.m_playerClassInstance.HasSmashBall)
               {
                  this.B_attack();
               }
            }
            else if(this.m_playerClassInstance.CharacterStats.CanUseSpecials && this.m_target.XDistance > 100)
            {
               if(this.m_playerClassInstance.AttackDataObj.getAttack("b").IsLongRangeMove && Utils.random() < 0.3 && !(this.m_playerClassInstance.CollisionObj.ground && this.getDisabledAttack("b") || !this.m_playerClassInstance.CollisionObj.ground && this.getDisabledAttack("b_air")))
               {
                  this.B_attack();
               }
               else if(this.m_playerClassInstance.AttackDataObj.getAttack("b_forward").IsLongRangeMove && Utils.random() >= 0.3 && Utils.random() < 0.6 && !(this.m_playerClassInstance.CollisionObj.ground && this.getDisabledAttack("b_forward") || !this.m_playerClassInstance.CollisionObj.ground && this.getDisabledAttack("b_forward_air")))
               {
                  if(this.m_target.CurrentTarget.X > this.m_playerClassInstance.X)
                  {
                     this.B_attackRight();
                  }
                  else
                  {
                     this.B_attackLeft();
                  }
               }
               else if(this.m_playerClassInstance.AttackDataObj.getAttack("b_down").IsLongRangeMove && Utils.random() >= 0.6 && Utils.random() < 0.9 && !(this.m_playerClassInstance.CollisionObj.ground && this.getDisabledAttack("b_down") || !this.m_playerClassInstance.CollisionObj.ground && this.getDisabledAttack("b_down_air")))
               {
                  this.B_attackDown();
               }
               else if(this.m_playerClassInstance.AttackDataObj.getAttack("b_up").IsLongRangeMove && Utils.random() >= 0.9 && Utils.random() < 1 && !(this.m_playerClassInstance.CollisionObj.ground && this.getDisabledAttack("b_up") || !this.m_playerClassInstance.CollisionObj.ground && this.getDisabledAttack("b_up_air")))
               {
                  this.B_attackUp();
               }
            }
         }
         this.m_currentAttackCombos = this.m_currentAttack != null && this.m_currentAttack.ComboMax > 0 ? Utils.randomInteger(1,this.m_currentAttack.ComboMax - 1) : 0;
         if(this.m_currentAttackCombos > 10)
         {
            this.m_currentAttackCombos = 10;
         }
         this.m_currentAttackIsProjectile = this.m_currentAttack != null && this.m_currentAttack.IsLongRangeMove ? true : false;
         if(this.m_currentAttack != null && this.m_currentAttack.ChargeTimeMax > 0)
         {
            switch(Math.round(Utils.random() * (4 - 1)) + 1)
            {
               case 1:
                  this.m_currentAttackChargetime = 1;
                  break;
               case 2:
                  this.m_currentAttackChargetime = Math.round(this.m_currentAttack.ChargeTimeMax * (1 / 3));
                  break;
               case 3:
                  this.m_currentAttackChargetime = Math.round(this.m_currentAttack.ChargeTimeMax * (2 / 3));
                  break;
               case 4:
                  this.m_currentAttackChargetime = this.m_currentAttack.ChargeTimeMax;
            }
            this.m_currentAttackUseCharge = this.m_level / 10 > Utils.random() ? true : false;
         }
         else
         {
            this.m_currentAttackUseCharge = false;
            this.m_currentAttackChargetime = 0;
         }
         if(Boolean(!justFinishedQueue && this.m_currentAttackQueue.length == 0 && Utils.random() > 0.5 && this.execIfSmartEnough()) && Boolean(this.m_currentAttack) && this.m_currentAttack.CPUAttackList != null)
         {
            this.addToAttackQueue(this.m_currentAttack.CPUAttackList);
         }
      }
      
      public function addToAttackQueue(str:String) : void
      {
         if(!str)
         {
            return;
         }
         while(this.m_currentAttackQueue.length > 0)
         {
            this.m_currentAttackQueue.splice(0,1);
         }
         while(str.indexOf(" ") >= 0)
         {
            str = str.replace(" ","");
         }
         var chainList:Array = str.split(";");
         var pickedList:Array = String(chainList[Utils.randomInteger(0,chainList.length - 1)]).split(",");
         for(var i:int = 0; i < pickedList.length; i++)
         {
            if(!(!this.m_playerClassInstance.CharacterStats.CanUseSpecials && (pickedList[i] === "b" || Boolean(pickedList[i].match(/^b_/)))))
            {
               this.m_currentAttackQueue.push(pickedList[i]);
            }
         }
         this.m_currentAttackQueueTimer.reset();
      }
      
      private function attackOptions() : void
      {
         if(this.m_playerClassInstance.inState(CState.ATTACKING) && this.m_currentAttack != null)
         {
            if(this.m_currentAttack.ComboMax > 0)
            {
               if(this.m_playerClassInstance.AttackStateData.ComboTotal < this.m_currentAttackCombos)
               {
                  if(this.m_playerClassInstance.AttackStateData.AttackType == 1)
                  {
                     if(this.m_keys_hist.BUTTON2)
                     {
                        this.m_keys.BUTTON2 = false;
                     }
                     else if(!this.m_keys_hist.BUTTON2)
                     {
                        this.m_keys.BUTTON2 = true;
                     }
                  }
                  else if(this.m_playerClassInstance.AttackStateData.AttackType == 2)
                  {
                     if(this.m_keys_hist.BUTTON1)
                     {
                        this.m_keys.BUTTON1 = false;
                     }
                     else if(!this.m_keys_hist.BUTTON1)
                     {
                        this.m_keys.BUTTON1 = true;
                     }
                  }
               }
            }
            else if(this.m_currentAttack != null && this.m_currentAttack.ChargeTimeMax > 0)
            {
               if(this.m_target.CurrentTarget != null)
               {
                  this.m_target.setDistance(new Point(this.m_playerClassInstance.X,this.m_playerClassInstance.Y));
               }
               if(this.m_currentAttack.ChargeTime > this.m_currentAttackChargetime || this.m_target.CurrentTarget != null && this.m_target.Distance < 50)
               {
                  if(this.m_playerClassInstance.AttackStateData.AttackType == 1)
                  {
                     if(this.m_currentAttack.ChargeRetain)
                     {
                        if(!this.m_currentAttackUseCharge)
                        {
                           this.m_keys.BUTTON2 = false;
                           this.m_keys.SHIELD = true;
                        }
                     }
                     else
                     {
                        this.m_keys.BUTTON2 = false;
                     }
                  }
                  else if(this.m_playerClassInstance.AttackStateData.AttackType == 2)
                  {
                     if(this.m_currentAttack.ChargeRetain)
                     {
                        if(!this.m_currentAttackUseCharge)
                        {
                           this.m_keys.BUTTON1 = false;
                           this.m_keys.SHIELD = true;
                        }
                     }
                     else
                     {
                        this.m_keys.BUTTON1 = false;
                     }
                  }
                  this.m_currentAttack = null;
               }
               else if(this.m_currentAttack.ChargeRetain)
               {
                  this.m_keys.BUTTON2 = false;
                  this.m_keys.BUTTON1 = false;
               }
               else if(this.m_playerClassInstance.AttackStateData.AttackType == 1)
               {
                  this.m_keys.BUTTON2 = true;
               }
               else if(this.m_playerClassInstance.AttackStateData.AttackType == 2)
               {
                  this.m_keys.BUTTON1 = true;
               }
            }
            else
            {
               this.m_keys.BUTTON2 = false;
               this.m_keys.BUTTON1 = false;
               this.m_keys.DOWN = false;
               if(this.m_playerClassInstance.CollisionObj.lbound_lower || this.m_playerClassInstance.CollisionObj.lbound_upper)
               {
                  this.m_keys.RIGHT = true;
               }
               else if(this.m_playerClassInstance.CollisionObj.rbound_lower || this.m_playerClassInstance.CollisionObj.rbound_upper)
               {
                  this.m_keys.LEFT = true;
               }
            }
            if(this.m_playerClassInstance.inState(CState.ATTACKING) && this.m_playerClassInstance.AttackStateData.ComboTotal >= this.m_playerClassInstance.AttackStateData.ComboMax && this.m_playerClassInstance.AttackStateData.ExecTime > 60)
            {
               if(this.m_playerClassInstance.AttackStateData.AttackType == 1)
               {
                  this.m_keys.BUTTON2 = false;
               }
               else if(this.m_playerClassInstance.AttackStateData.AttackType == 2)
               {
                  this.m_keys.BUTTON1 = false;
               }
            }
         }
         else
         {
            this.resetAllKeys();
            if(this.execIfSmartEnough(0.25))
            {
               this.m_action = CPUState.CHASE;
            }
            else
            {
               this.m_action = CPUState.EVADE;
            }
         }
      }
      
      private function excess() : void
      {
         this.updateTargetPosition();
         if(this.m_action == CPUState.EVADE && !this.m_keys.SHIELD)
         {
            if(this.m_target.Distance < 30 * this.m_playerClassInstance.SizeRatio)
            {
               if(this.m_target.CurrentTarget.X > this.m_playerClassInstance.X || !this.m_playerClassInstance.FacingForward && this.m_target.CurrentTarget.X > this.m_playerClassInstance.X)
               {
                  this.m_keys.RIGHT = false;
                  this.m_keys.LEFT = true;
               }
               else if(this.m_target.CurrentTarget.X < this.m_playerClassInstance.X || this.m_playerClassInstance.FacingForward && this.m_target.CurrentTarget.X < this.m_playerClassInstance.X)
               {
                  this.m_keys.LEFT = false;
                  this.m_keys.RIGHT = true;
               }
               else
               {
                  this.m_keys.LEFT = false;
                  this.m_keys.RIGHT = false;
               }
               if(this.m_target.Distance < 60 * this.m_playerClassInstance.SizeRatio && this.execIfSmartEnough())
               {
               }
            }
            else
            {
               this.m_keys.LEFT = false;
               this.m_keys.RIGHT = false;
            }
         }
         else if(this.m_action == CPUState.EVADE && !this.m_keys.SHIELD)
         {
            if(this.m_target.CurrentTarget.X - 30 > this.m_playerClassInstance.X || !this.m_playerClassInstance.FacingForward && this.m_target.CurrentTarget.X > this.m_playerClassInstance.X)
            {
               this.m_keys.RIGHT = true;
               this.m_keys.LEFT = false;
            }
            else if(this.m_target.CurrentTarget.X + 30 < this.m_playerClassInstance.X || this.m_playerClassInstance.FacingForward && this.m_target.CurrentTarget.X < this.m_playerClassInstance.X)
            {
               this.m_keys.LEFT = true;
               this.m_keys.RIGHT = false;
            }
            else
            {
               this.m_keys.LEFT = false;
               this.m_keys.RIGHT = false;
            }
         }
         if(this.m_keys.SHIELD)
         {
            this.m_shieldTimer.tick();
            if(this.m_shieldDodge && (this.m_playerClassInstance.inState(CState.DODGE_ROLL) || this.m_playerClassInstance.inState(CState.AIR_DODGE) || this.m_playerClassInstance.inState(CState.SIDESTEP_DODGE)))
            {
               this.m_keys.LEFT = false;
               this.m_keys.RIGHT = false;
               this.m_shieldDodge = false;
            }
            if(this.m_shieldTimer.IsComplete || this.m_shieldTimer.CurrentTime > 0 && !this.m_playerClassInstance.inState(CState.SHIELDING))
            {
               this.m_keys.SHIELD = false;
            }
         }
         if(this.m_playerClassInstance.inState(CState.CROUCH))
         {
            this.m_keys.DOWN = false;
         }
         else if(this.m_attackTimer.IsComplete && !this.m_keys.SHIELD && !this.m_playerClassInstance.inState(CState.ATTACKING))
         {
            this.m_attackTimer.reset();
            if(this.execIfSmartEnough(0.5))
            {
               this.chooseAttack();
               if(this.m_currentAttackIsProjectile)
               {
                  if(this.m_target.Distance < 100 * this.m_playerClassInstance.SizeRatio)
                  {
                     if(this.execIfDumbEnough())
                     {
                        this.m_keys.BUTTON2 = false;
                        this.m_keys.BUTTON1 = false;
                     }
                  }
               }
            }
         }
         if((this.m_target.Distance > 50 * this.m_playerClassInstance.SizeRatio && this.m_playerClassInstance.CollisionObj.ground || this.m_target.Distance > 100 * this.m_playerClassInstance.SizeRatio && !this.m_playerClassInstance.CollisionObj.ground) && this.m_currentAttack != null && this.m_currentAttack.IsLongRangeMove)
         {
            this.m_keys.BUTTON2 = false;
            this.m_keys.BUTTON1 = false;
            this.m_keys.UP = false;
         }
         this.checkBoundaries();
         if(!(!this.m_playerClassInstance.CollisionObj.ground && (this.m_playerClassInstance.CollisionObj.lbound_lower || this.m_playerClassInstance.CollisionObj.rbound_lower)) && this.m_playerClassInstance.JumpCount < this.m_playerClassInstance.MaxJump && this.m_jumpTimer.IsComplete)
         {
            this.m_jumpTimer.reset();
            if(this.execIfSmartEnough(0.5) && (this.m_playerClassInstance.YSpeed > 0 || this.m_playerClassInstance.HoldJump && this.m_playerClassInstance.JumpCount > 1) && this.m_playerClassInstance.Y > this.m_target.CurrentTarget.Y && (this.m_target.CurrentTarget.CurrentPlatform != this.m_playerClassInstance.CurrentPlatform || this.m_target.PlayerSprite != null && this.m_target.PlayerSprite.Ground == false))
            {
               this.jump();
            }
            else if(this.execIfSmartEnough() && this.m_playerClassInstance.Y < this.m_target.CurrentTarget.Y && this.m_playerClassInstance.CurrentPlatform != null && this.m_target.CurrentTarget.CurrentPlatform != this.m_playerClassInstance.CurrentPlatform && this.m_playerClassInstance.OnPlatform && this.m_playerClassInstance.CurrentPlatform.noDropThrough != true)
            {
               this.m_keys.DOWN = true;
               this.m_fallthrough = true;
               this.m_fallthroughTimer.reset();
            }
         }
         if(this.m_action == CPUState.IDLE && !this.m_playerClassInstance.CollisionObj.lbound_upper && !this.m_playerClassInstance.CollisionObj.rbound_upper && !this.m_playerClassInstance.CollisionObj.lbound_lower && !this.m_playerClassInstance.CollisionObj.rbound_lower && !this.m_playerClassInstance.inState(CState.ATTACKING))
         {
            this.m_keys.RIGHT = false;
            this.m_keys.LEFT = false;
         }
         else if((this.m_playerClassInstance.CollisionObj.lbound_lower || this.m_playerClassInstance.CollisionObj.lbound_upper) && this.m_currentAttack == null)
         {
            this.m_keys.RIGHT = true;
         }
         else if((this.m_playerClassInstance.CollisionObj.rbound_lower || this.m_playerClassInstance.CollisionObj.rbound_upper) && this.m_currentAttack == null)
         {
            this.m_keys.LEFT = true;
         }
         if(this.m_playerClassInstance.CollisionObj.ground && Utils.random() > 0.75 && this.m_target.Distance < 50 || this.m_playerClassInstance.ItemObj != null && Utils.random() > 0.5)
         {
            this.tap_Grab();
         }
         else if(this.m_keys.GRAB)
         {
            this.tap_Grab();
         }
      }
      
      private function checkBoundaries() : void
      {
         var randAttk:AttackObject = null;
         var tmpFunc:Function = null;
         this.resetAllKeys();
         if(this.m_playerClassInstance.CollisionObj.lbound_upper || this.m_playerClassInstance.CollisionObj.lbound_lower)
         {
            this.m_keys.RIGHT = true;
            this.m_keys.LEFT = false;
            this.m_recovering = true;
            if(this.m_playerClassInstance.CollisionObj.lbound_lower)
            {
               this.m_finalRecovery = true;
            }
            else
            {
               this.m_finalRecovery = false;
            }
         }
         else if(this.m_playerClassInstance.CollisionObj.rbound_upper || this.m_playerClassInstance.CollisionObj.rbound_lower)
         {
            this.m_keys.LEFT = true;
            this.m_keys.RIGHT = false;
            this.m_recovering = true;
            if(this.m_playerClassInstance.CollisionObj.rbound_lower)
            {
               this.m_finalRecovery = true;
            }
            else
            {
               this.m_finalRecovery = false;
            }
         }
         else
         {
            this.m_action = CPUState.CHASE;
            this.m_recovering = false;
            this.m_finalRecovery = false;
         }
         if(!this.m_playerClassInstance.CollisionObj.ground && !(this.m_playerClassInstance.inState(CState.HOVER) || this.m_playerClassInstance.AttackHovering) && (this.m_playerClassInstance.CollisionObj.lbound_lower || this.m_playerClassInstance.CollisionObj.rbound_lower || this.m_playerClassInstance.CollisionObj.lbound_upper || this.m_playerClassInstance.CollisionObj.rbound_upper))
         {
            if(this.m_playerClassInstance.HoldJump)
            {
               if(this.m_playerClassInstance.YSpeed > 0 && this.m_playerClassInstance.HasMidAirJumps && this.m_playerClassInstance.CurrentMidairJumpSpeed < 0 && (this.m_playerClassInstance.CollisionObj.lbound_lower || this.m_playerClassInstance.CollisionObj.rbound_lower) || this.m_playerClassInstance.inState(CState.TUMBLE_FALL))
               {
                  this.jump();
               }
               else
               {
                  this.m_keys.JUMP = true;
               }
            }
            else if(this.m_playerClassInstance.CollisionObj.lbound_lower || this.m_playerClassInstance.CollisionObj.rbound_lower)
            {
               this.jump();
            }
            if(!this.m_playerClassInstance.CollisionObj.ground && (this.m_playerClassInstance.CollisionObj.lbound_lower || this.m_playerClassInstance.CollisionObj.rbound_lower || this.m_playerClassInstance.HoldJump && (this.m_playerClassInstance.CollisionObj.lbound_upper || this.m_playerClassInstance.CollisionObj.rbound_upper)))
            {
               if(!this.m_playerClassInstance.inState(CState.HOVER) && !(!this.m_playerClassInstance.inState(CState.ATTACKING) && this.m_playerClassInstance.AttackHovering) && !this.m_playerClassInstance.CollisionObj.ground && (this.m_playerClassInstance.YSpeed > 0 && this.m_playerClassInstance.HasMidAirJumps && !this.m_playerClassInstance.HoldJump || this.m_playerClassInstance.HoldJump))
               {
                  if(!this.m_playerClassInstance.HoldJump)
                  {
                     this.jump();
                  }
               }
            }
         }
         if(this.m_level > 0 && this.m_recovering && this.m_playerClassInstance.JumpCount >= this.m_playerClassInstance.MaxJump && this.m_playerClassInstance.netYSpeed() > 0 && !(this.m_playerClassInstance && this.m_playerClassInstance.usingMidAirJumpConstant()))
         {
            randAttk = null;
            if(this.m_finalRecovery && this.m_recoveryAttackList.length > 0)
            {
               randAttk = this.m_recoveryAttackList[Utils.randomInteger(0,this.m_recoveryAttackList.length - 1)];
            }
            else if(this.m_horizontalRecoveryAttackList.length > 0)
            {
               randAttk = this.m_horizontalRecoveryAttackList[Utils.randomInteger(0,this.m_horizontalRecoveryAttackList.length - 1)];
               if(this.m_playerClassInstance.touchingUpperWarningBounds(this.m_playerClassInstance.X,this.m_playerClassInstance.Y + 100) && !this.m_playerClassInstance.touchingLowerWarningBounds(this.m_playerClassInstance.X + 100,this.m_playerClassInstance.Y) && !this.m_playerClassInstance.touchingUpperWarningBounds(this.m_playerClassInstance.X,this.m_playerClassInstance.Y + 100))
               {
                  return;
               }
            }
            if(randAttk != null)
            {
               tmpFunc = this.getAttackFunction(randAttk.Name);
               if(tmpFunc != null)
               {
                  tmpFunc();
               }
            }
         }
         if(this.m_recovering && !this.m_keys.LEFT && !this.m_keys.RIGHT)
         {
            if(this.m_playerClassInstance.CollisionObj.rbound_upper || this.m_playerClassInstance.CollisionObj.rbound_lower)
            {
               this.m_keys.LEFT = true;
            }
            if(this.m_playerClassInstance.CollisionObj.lbound_upper || this.m_playerClassInstance.CollisionObj.lbound_lower)
            {
               this.m_keys.RIGHT = true;
            }
         }
      }
      
      private function checkPause() : void
      {
         var pObj:Character = null;
         var c:int = 0;
         var noHumans:Boolean = this.STAGEDATA.NoHumans;
         if(noHumans)
         {
            pObj = null;
            for(c = 0; c < this.STAGEDATA.Players.length; c++)
            {
               if(this.STAGEDATA.Players[c] != null)
               {
                  pObj = this.STAGEDATA.Players[c];
               }
            }
            if(pObj.ID == this.m_player_id)
            {
               this.m_keys.START = !MultiplayerManager.Connected && this.STAGEDATA.getControllerNum(1).IsDown(this.STAGEDATA.getControllerNum(1)._START) ? true : false;
            }
         }
      }
      
      private function getNearestOpponent() : void
      {
         var myBeacon:Beacon = null;
         var theirBeacon:Beacon = null;
         if(this.m_targetTemp.CurrentTarget != null && this.m_targetTemp.CurrentTarget.MC.parent == null)
         {
            this.m_targetTemp.CurrentTarget = null;
         }
         this.m_target.CurrentTarget = null;
         var results:Target = this.findSmashBall();
         if(results == null || results.ItemSprite.Dead || this.m_playerClassInstance.HasSmashBall || this.m_playerClassInstance.UsingFinalSmash)
         {
            results = this.findItem();
            if(results == null || results.ItemSprite.Dead || this.m_playerClassInstance.HasSmashBall || this.m_playerClassInstance.UsingFinalSmash || this.m_itemGiveUpTimer.IsComplete)
            {
               results = this.findOpponent();
            }
         }
         if(results != null)
         {
            this.m_target.CurrentTarget = results.CurrentTarget;
            this.m_targetTemp.CurrentTarget = this.m_target.CurrentTarget;
            this.m_target.setDistance(new Point(this.m_playerClassInstance.X - results.CurrentTarget.netXSpeed() + this.m_playerClassInstance.netXSpeed(),this.m_playerClassInstance.Y - results.CurrentTarget.netYSpeed() + this.m_playerClassInstance.netYSpeed()));
            this.m_targetTemp.setDistance(new Point(this.m_playerClassInstance.X - results.CurrentTarget.netXSpeed(),this.m_playerClassInstance.Y - results.CurrentTarget.netYSpeed()));
         }
         if(this.m_target != null && this.m_target.CurrentTarget != null && this.STAGEDATA.getBeacons().length > 0 && this.m_shortestPath == null && (this.m_target.Distance > 200 || !this.m_target.CurrentTarget.checkLinearPath(this.m_playerClassInstance)))
         {
            myBeacon = Utils.getClosetBeaconTo(this.STAGEDATA,this.m_playerClassInstance.MC);
            theirBeacon = Utils.getClosetBeaconTo(this.STAGEDATA,this.m_target.CurrentTarget.MC);
            if(myBeacon != theirBeacon)
            {
               this.m_shortestPath = Utils.getPath(this.STAGEDATA.getBeacons(),Utils.dijkstra(this.STAGEDATA,this.STAGEDATA.getBeacons(),this.STAGEDATA.getAdjMatrix(),myBeacon,theirBeacon),myBeacon.BID,theirBeacon.BID);
               this.showCurrentPath();
            }
         }
         else if(this.m_shortestPath != null)
         {
            this.m_target.CurrentTarget = this.m_shortestPath[this.m_shortestPath.length - 1];
            this.m_target.setDistance(new Point(this.m_playerClassInstance.X,this.m_playerClassInstance.Y));
         }
      }
      
      private function findSmashBall() : Target
      {
         var tmpTarget:Target = new Target();
         var smashball:Item = this.STAGEDATA.ItemsRef.CurrentSmashBall;
         if(smashball != null && !smashball.Dead && !this.m_playerClassInstance.HasSmashBall && !this.m_playerClassInstance.UsingFinalSmash && smashball.MC.parent != null)
         {
            tmpTarget.CurrentTarget = smashball;
            tmpTarget.setDistance(new Point(this.m_playerClassInstance.X,this.m_playerClassInstance.Y));
            return tmpTarget;
         }
         return null;
      }
      
      private function findItem() : Target
      {
         var tmpTarget:Target = new Target();
         for(var i:int = 0; i < this.STAGEDATA.ItemsRef.ItemsInUse.length; i++)
         {
            if(this.m_playerClassInstance.CollisionObj.ground && this.m_playerClassInstance.inFreeState() && this.m_playerClassInstance.ItemObj == null && this.STAGEDATA.ItemsRef.ItemsInUse[i] != null && !this.STAGEDATA.ItemsRef.ItemsInUse[i].PickedUp && !this.STAGEDATA.ItemsRef.ItemsInUse[i].inState(IState.TOSS) && !this.STAGEDATA.ItemsRef.ItemsInUse[i].Dangerous && this.STAGEDATA.ItemsRef.ItemsInUse[i].CanPickup && !this.STAGEDATA.ItemsRef.ItemsInUse[i].Dead && Utils.getDistanceFrom(this.m_playerClassInstance,this.STAGEDATA.ItemsRef.ItemsInUse[i]) < 100)
            {
               tmpTarget.CurrentTarget = this.STAGEDATA.ItemsRef.ItemsInUse[i];
               tmpTarget.setDistance(new Point(this.m_playerClassInstance.X,this.m_playerClassInstance.Y));
               return tmpTarget;
            }
         }
         return null;
      }
      
      private function opponenentUsingSpecial() : Boolean
      {
         for(var i:int = 0; i < this.STAGEDATA.Characters.length; i++)
         {
            if(this.STAGEDATA.Characters[i] != this.m_playerClassInstance && !this.STAGEDATA.Characters[i].StandBy && (this.STAGEDATA.Characters[i].UsingFinalSmash || this.STAGEDATA.Characters[i].HasSmashBall))
            {
               return true;
            }
         }
         return false;
      }
      
      private function findOpponent() : Target
      {
         var opponent:Character = null;
         var dis:Number = NaN;
         var myLoc:Point = null;
         var tmpTarget:Target = new Target();
         var found:Boolean = false;
         var smashball:Item = this.STAGEDATA.ItemsRef.CurrentSmashBall;
         for(var i:int = 0; i < this.STAGEDATA.Characters.length; i++)
         {
            opponent = this.STAGEDATA.Characters[i];
            if(opponent != this.m_playerClassInstance && !(this.m_playerClassInstance.Team == opponent.Team && this.m_playerClassInstance.Team > 0) && !opponent.inState(CState.DEAD) && !opponent.inState(CState.STAMINA_KO) && !opponent.StandBy && !(opponent.Revival && !opponent.MC.visible) && opponent.MC.parent != null)
            {
               dis = 0;
               myLoc = null;
               if(this.m_playerClassInstance.UsingFinalSmash && this.m_playerClassInstance.SpecialType == 4 && this.m_playerClassInstance.AttachedReticule != null)
               {
                  myLoc = new Point(this.m_playerClassInstance.AttachedReticule.x,this.m_playerClassInstance.AttachedReticule.y);
                  myLoc = this.STAGEDATA.HudForegroundRef.localToGlobal(myLoc);
                  myLoc = this.STAGE.globalToLocal(myLoc);
                  dis = Utils.getDistance(new Point(opponent.X,opponent.Y),new Point(myLoc.x,myLoc.y));
               }
               else
               {
                  dis = this.getDistanceFrom(opponent.X,opponent.Y);
               }
               if((tmpTarget.CurrentTarget == null || dis < tmpTarget.Distance) && !(opponent.WarningCollision && !opponent.inState(CState.FLYING) && !opponent.CollisionObj.ground && dis > 100))
               {
                  tmpTarget.CurrentTarget = opponent;
                  if(this.m_playerClassInstance.UsingFinalSmash && this.m_playerClassInstance.SpecialType == 4 && this.m_playerClassInstance.AttachedReticule != null)
                  {
                     myLoc = new Point(this.m_playerClassInstance.AttachedReticule.x,this.m_playerClassInstance.AttachedReticule.y);
                     myLoc = this.STAGEDATA.HudForegroundRef.localToGlobal(myLoc);
                     myLoc = this.STAGE.globalToLocal(myLoc);
                     tmpTarget.setDistance(new Point(myLoc.x,myLoc.y));
                  }
                  else
                  {
                     tmpTarget.setDistance(new Point(this.m_playerClassInstance.X,this.m_playerClassInstance.Y));
                  }
               }
            }
         }
         if(tmpTarget.CurrentTarget == null)
         {
            return null;
         }
         return tmpTarget;
      }
      
      private function checkPotentialBeaconPath() : void
      {
         if(this.m_targetTemp.CurrentTarget != null)
         {
            this.m_targetTemp.setDistance(new Point(this.m_playerClassInstance.X,this.m_playerClassInstance.Y));
         }
         if(this.m_shortestPath != null && this.m_targetTemp.CurrentTarget != null && (this.m_targetTemp.Distance < 100 && this.m_targetTemp.CurrentTarget.checkLinearPath(this.m_playerClassInstance)))
         {
            this.m_shortestPath = null;
            this.m_target.CurrentTarget = this.m_targetTemp.CurrentTarget;
            this.m_targetTemp.CurrentTarget = null;
            this.getNearestOpponent();
         }
         else if(this.m_shortestPath != null)
         {
            this.m_target.CurrentTarget = this.m_shortestPath[this.m_shortestPath.length - 1];
            this.m_target.setDistance(new Point(this.m_playerClassInstance.X,this.m_playerClassInstance.Y));
            if(this.m_target.Distance < 50)
            {
               this.m_target.CurrentTarget = null;
               trace(this.m_shortestPath.pop().Z);
               if(this.m_shortestPath.length > 0 && !(this.m_targetTemp.CurrentTarget != null && this.m_targetTemp.CurrentTarget.checkLinearPath(this.m_playerClassInstance) && this.m_targetTemp.Distance < Utils.getDistanceFrom(this.m_playerClassInstance,this.m_shortestPath[this.m_shortestPath.length - 1])))
               {
                  this.showCurrentPath();
                  this.m_beaconTimer.reset();
                  this.m_target.CurrentTarget = this.m_shortestPath[this.m_shortestPath.length - 1];
               }
               else
               {
                  this.m_shortestPath = null;
                  this.getNearestOpponent();
               }
            }
         }
      }
      
      private function updateTargetPosition() : void
      {
         var smashball:Item = this.STAGEDATA.ItemsRef.CurrentSmashBall;
         if(this.m_target.CurrentTarget != null && smashball != null && !this.m_playerClassInstance.HasSmashBall && !this.m_playerClassInstance.UsingFinalSmash)
         {
            this.m_target.setDistance(new Point(this.m_playerClassInstance.X - this.m_target.CurrentTarget.netXSpeed() + this.m_playerClassInstance.netXSpeed(),this.m_playerClassInstance.Y - this.m_target.CurrentTarget.netYSpeed() + this.m_playerClassInstance.netYSpeed()));
         }
         else if(this.m_target.CurrentTarget != null)
         {
            this.m_target.setDistance(new Point(this.m_playerClassInstance.X - this.m_target.CurrentTarget.netXSpeed() + this.m_playerClassInstance.netXSpeed(),this.m_playerClassInstance.Y - this.m_target.CurrentTarget.netYSpeed() + this.m_playerClassInstance.netYSpeed()));
         }
      }
      
      public function getAngleOfOpponent() : Number
      {
         var angle:Number = 0;
         var adjacent:Number = this.m_target.CurrentTarget.X - this.m_playerClassInstance.X;
         var opposite:Number = -(this.m_target.CurrentTarget.Y - this.m_playerClassInstance.Y);
         angle = Math.round(Math.atan(opposite / adjacent) / (Math.PI / 180));
         if(adjacent < 0)
         {
            angle = 180 + angle;
         }
         if(opposite < 0 && adjacent > 0)
         {
            angle = 360 + angle;
         }
         return angle;
      }
      
      private function getDistanceFrom(x:Number, y:Number) : Number
      {
         return Math.sqrt(Math.pow(x - this.m_playerClassInstance.X,2) + Math.pow(y - this.m_playerClassInstance.Y,2));
      }
      
      private function B_attackRight() : void
      {
         this.resetAllKeys();
         this.m_keys.RIGHT = true;
         this.m_keys.BUTTON1 = true;
         this.m_currentAttack = this.m_playerClassInstance.AttackDataObj.getAttack("b_forward");
      }
      
      private function B_attackLeft() : void
      {
         this.resetAllKeys();
         this.m_keys.LEFT = true;
         this.m_keys.BUTTON1 = true;
         this.m_currentAttack = this.m_playerClassInstance.AttackDataObj.getAttack("b_forward");
      }
      
      private function B_attack() : void
      {
         this.resetAllKeys();
         this.m_keys.BUTTON1 = true;
         this.m_currentAttack = this.m_playerClassInstance.AttackDataObj.getAttack("b");
      }
      
      private function B_attackUp() : void
      {
         this.resetAllKeys();
         this.m_keys.UP = true;
         this.m_keys.BUTTON1 = true;
         this.m_currentAttack = this.m_playerClassInstance.AttackDataObj.getAttack("b_up");
      }
      
      private function B_attackDown() : void
      {
         this.resetAllKeys();
         this.m_keys.DOWN = true;
         this.m_keys.BUTTON1 = true;
         this.m_currentAttack = this.m_playerClassInstance.AttackDataObj.getAttack("b_down");
      }
      
      private function A_attackAir() : void
      {
         this.resetAllKeys();
         this.m_keys.BUTTON2 = true;
         this.m_currentAttack = this.m_playerClassInstance.AttackDataObj.getAttack("a_air");
      }
      
      private function A_attackUpAir() : void
      {
         this.resetAllKeys();
         this.m_keys.UP = true;
         this.m_keys.BUTTON2 = true;
         this.m_currentAttack = this.m_playerClassInstance.AttackDataObj.getAttack("a_air_up");
      }
      
      private function A_attackDownAir() : void
      {
         this.resetAllKeys();
         this.m_keys.DOWN = true;
         this.m_keys.BUTTON2 = true;
         this.m_currentAttack = this.m_playerClassInstance.AttackDataObj.getAttack("a_air_down");
      }
      
      private function A_attackRightAir() : void
      {
         this.resetAllKeys();
         this.m_keys.RIGHT = true;
         this.m_keys.BUTTON2 = true;
         this.m_currentAttack = this.m_playerClassInstance.AttackDataObj.getAttack("a_air_forward");
      }
      
      private function A_attackLeftAir() : void
      {
         this.resetAllKeys();
         this.m_keys.LEFT = true;
         this.m_keys.BUTTON2 = true;
         this.m_currentAttack = this.m_playerClassInstance.AttackDataObj.getAttack("a_air_forward");
      }
      
      private function A_attack() : void
      {
         this.resetAllKeys();
         this.m_keys.BUTTON2 = true;
         this.m_currentAttack = this.m_playerClassInstance.AttackDataObj.getAttack("a");
      }
      
      private function A_attackRight() : void
      {
         this.resetAllKeys();
         this.m_keys.RIGHT = true;
         this.m_keys.BUTTON2 = true;
         var rand:Number = Utils.random();
         if(rand < 0.3)
         {
            this.m_currentAttack = this.m_playerClassInstance.AttackDataObj.getAttack("a_forward");
         }
         else
         {
            this.m_currentAttack = this.m_playerClassInstance.AttackDataObj.getAttack("a_forwardsmash");
         }
      }
      
      private function A_attackLeft() : void
      {
         this.resetAllKeys();
         this.m_keys.LEFT = true;
         this.m_keys.BUTTON2 = true;
         var rand:Number = Utils.random();
         if(rand < 0.3)
         {
            this.m_currentAttack = this.m_playerClassInstance.AttackDataObj.getAttack("a_forward");
         }
         else
         {
            this.m_currentAttack = this.m_playerClassInstance.AttackDataObj.getAttack("a_forwardsmash");
         }
      }
      
      private function A_attackDown() : void
      {
         this.resetAllKeys();
         this.m_keys.BUTTON2 = true;
         this.m_keys.DOWN = true;
         this.m_currentAttack = this.m_playerClassInstance.AttackDataObj.getAttack("a_down");
      }
      
      private function A_attackUp() : void
      {
         this.resetAllKeys();
         this.m_keys.RIGHT = true;
         this.m_keys.UP = true;
         this.m_keys.BUTTON2 = true;
         this.m_currentAttack = this.m_playerClassInstance.AttackDataObj.getAttack("a_up");
      }
      
      private function getAttackFunction(name:String) : Function
      {
         if(name == "a")
         {
            return this.A_attack;
         }
         if(name == "a_air")
         {
            return this.A_attackAir;
         }
         if(name == "a_up" || name == "a_up_tilt" || name == "a_up_air")
         {
            return this.A_attackUp;
         }
         if(name == "a_forward" || name == "a_forward_tilt" || name == "a_forwardsmash" || name == "a_air_forward" || name == "a_air_backward")
         {
            return this.m_playerClassInstance.FacingForward ? this.A_attackRight : this.A_attackLeft;
         }
         if(name == "a_air_forward" || name == "a_air_backward")
         {
            return this.m_playerClassInstance.FacingForward ? this.A_attackRightAir : this.A_attackLeftAir;
         }
         if(name == "a_down" || name == "crouch_attack")
         {
            return this.A_attackDown;
         }
         if(name == "a_air_down")
         {
            return this.A_attackDownAir;
         }
         if(name == "b" || name == "b_air")
         {
            return this.B_attack;
         }
         if(name == "b_up" || name == "b_up_air")
         {
            return this.B_attackUp;
         }
         if(name == "b_forward" || name == "b_forward_air")
         {
            return this.m_keys.RIGHT ? this.B_attackRight : this.B_attackLeft;
         }
         if(name == "b_down" || name == "b_down_air")
         {
            return this.B_attackDown;
         }
         return null;
      }
      
      private function storeKeyHistory() : void
      {
         this.m_keys_hist.controls = this.m_keys.controls;
      }
      
      private function restoreKeyHistory() : void
      {
         this.m_keys.controls = this.m_keys_hist.controls;
      }
      
      private function resetAllKeys() : void
      {
         this.m_keys.controls = 0;
      }
      
      private function jump() : void
      {
         if(this.m_keys_hist.JUMP)
         {
            this.m_keys.JUMP = false;
         }
         else
         {
            this.m_keys.JUMP = true;
         }
      }
      
      private function tap_A() : void
      {
         if(this.m_keys_hist.BUTTON2)
         {
            this.m_keys.BUTTON2 = false;
         }
         else
         {
            this.m_keys.BUTTON2 = true;
         }
      }
      
      private function tap_B() : void
      {
         if(this.m_keys_hist.BUTTON1)
         {
            this.m_keys.BUTTON1 = false;
         }
         else
         {
            this.m_keys.BUTTON1 = true;
         }
      }
      
      private function tap_Grab() : void
      {
         if(this.m_keys_hist.GRAB)
         {
            this.m_keys.GRAB = false;
         }
         else
         {
            this.m_keys.GRAB = true;
         }
      }
      
      private function tap_Shield() : void
      {
         if(this.m_keys_hist.RIGHT)
         {
            this.m_keys.RIGHT = false;
         }
         else
         {
            this.m_keys.RIGHT = true;
         }
      }
      
      private function tap_Left() : void
      {
         this.m_keys.RIGHT = false;
         if(this.m_keys_hist.LEFT)
         {
            this.m_keys.LEFT = false;
         }
         else
         {
            this.m_keys.LEFT = true;
         }
      }
      
      private function tap_Right() : void
      {
         this.m_keys.LEFT = false;
         if(this.m_keys_hist.RIGHT)
         {
            this.m_keys.RIGHT = false;
         }
         else
         {
            this.m_keys.RIGHT = true;
         }
      }
   }
}

