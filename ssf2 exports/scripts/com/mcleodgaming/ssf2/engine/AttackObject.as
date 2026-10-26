package com.mcleodgaming.ssf2.engine
{
   import com.mcleodgaming.ssf2.util.Dictionary;
   
   public class AttackObject
   {
      
      protected var m_name:String;
      
      protected var m_refreshRate:int;
      
      protected var m_resetMovement:Boolean;
      
      protected var m_attackDelay:int;
      
      protected var m_cancel:Boolean;
      
      protected var m_cancelWhenAirborne:Boolean;
      
      protected var m_cancelSoundOnEnd:Boolean;
      
      protected var m_cancelVoiceOnEnd:Boolean;
      
      protected var m_jumpCancel:Boolean;
      
      protected var m_jumpCancelAttack:Boolean;
      
      protected var m_doubleJumpCancel:Boolean;
      
      protected var m_doubleJumpCancelAttack:Boolean;
      
      protected var m_airCancel:Boolean;
      
      protected var m_airCancelSpecial:Boolean;
      
      protected var m_mustCharge:Boolean;
      
      protected var m_xVelocityDecay:Number;
      
      protected var m_yVelocityDecay:Number;
      
      protected var m_xSpeedAccel:Number;
      
      protected var m_xSpeedAccelAir:Number;
      
      protected var m_xSpeedDecay:Number;
      
      protected var m_xSpeedDecayAir:Number;
      
      protected var m_conserveJumpConstant:Boolean;
      
      protected var m_invincible:Boolean;
      
      protected var m_superArmor:Boolean;
      
      protected var m_heavyArmor:Number;
      
      protected var m_launchResistance:Number;
      
      protected var m_air_ease:Number;
      
      protected var m_hit_ease:Number;
      
      protected var m_xSpeedCap:Number;
      
      protected var m_allowControl:Boolean;
      
      protected var m_allowControlGround:Boolean;
      
      protected var m_chargetime:int;
      
      protected var m_chargetime_max:int;
      
      protected var m_charge_retain:Boolean;
      
      protected var m_linkCharge:String;
      
      protected var m_combo_max:int;
      
      protected var m_forceComboContinue:Boolean;
      
      protected var m_forceUseAtMaxCharge:Boolean;
      
      protected var m_forceGrabbable:Boolean;
      
      protected var m_holdRepeat:Boolean;
      
      protected var m_rotate:Boolean;
      
      protected var m_stale:Boolean;
      
      protected var m_flip:Boolean;
      
      protected var m_canBeAbsorbed:Boolean;
      
      protected var m_canFallOff:Boolean;
      
      protected var m_canGrabInverseLedges:Boolean;
      
      protected var m_forceFallthrough:Boolean;
      
      protected var m_hitEffect:String;
      
      protected var m_disableOnHit:Boolean;
      
      protected var m_maintainSpeed:Boolean;
      
      protected var m_jumpFrame:String;
      
      protected var m_parentAttack:String;
      
      protected var m_secondaryAttack:String;
      
      protected var m_isHorizontalRecoveryMove:Boolean;
      
      protected var m_isRecoveryMove:Boolean;
      
      protected var m_isLongRangeMove:Boolean;
      
      protected var m_disableForCPU:Boolean;
      
      protected var m_cpuAttackQueue:String;
      
      protected var m_facedLedgesOnly:Boolean;
      
      protected var m_chargeInAir:Boolean;
      
      protected var m_canUseInAir:Boolean;
      
      protected var m_allowJump:Boolean;
      
      protected var m_allowFastFall:Boolean;
      
      protected var m_allowRun:Boolean;
      
      protected var m_allowTurn:Boolean;
      
      protected var m_allowDoubleJump:Boolean;
      
      protected var m_allowFullInterrupt:Boolean;
      
      protected var m_linkFrames:Boolean;
      
      protected var m_isDisabled:Boolean;
      
      protected var m_enabled:Boolean;
      
      protected var m_disableMove:Boolean;
      
      protected var m_reenableEffect:String;
      
      protected var m_reenableTimer:int;
      
      protected var m_reenableTimerCount:int;
      
      protected var m_disableJump:Boolean;
      
      protected var m_controlDirection:Boolean;
      
      protected var m_homingSpeed:Number;
      
      protected var m_chargeClick:Boolean;
      
      protected var m_lastUsed:int;
      
      protected var m_lastUsed_previous:int;
      
      protected var m_customChargeGlow:String;
      
      protected var m_useChargeBar:Boolean;
      
      protected var m_lock_x_target:Boolean;
      
      protected var m_lock_y_target:Boolean;
      
      protected var m_ledgeFrame:String;
      
      protected var m_ignorePlatformInfluence:Boolean;
      
      protected var m_IASA:Boolean;
      
      protected var m_grabBehind:Boolean;
      
      protected var m_attackVoices:Array;
      
      protected var m_attackSounds:Array;
      
      protected var m_attackBoxes:Array;
      
      protected var m_overrideMap:Dictionary;
      
      public function AttackObject(name:String)
      {
         super();
         this.m_name = name;
         this.init();
      }
      
      public function init() : void
      {
         this.m_refreshRate = 50;
         this.m_resetMovement = false;
         this.m_attackDelay = 0;
         this.m_cancel = false;
         this.m_cancelWhenAirborne = true;
         this.m_cancelSoundOnEnd = false;
         this.m_cancelVoiceOnEnd = false;
         this.m_jumpCancel = false;
         this.m_jumpCancelAttack = false;
         this.m_doubleJumpCancel = false;
         this.m_doubleJumpCancelAttack = false;
         this.m_airCancel = false;
         this.m_airCancelSpecial = false;
         this.m_mustCharge = false;
         this.m_xVelocityDecay = -1;
         this.m_yVelocityDecay = -1;
         this.m_xSpeedAccel = 0;
         this.m_xSpeedAccelAir = 0;
         this.m_xSpeedDecay = 0;
         this.m_xSpeedDecayAir = 0;
         this.m_conserveJumpConstant = true;
         this.m_invincible = false;
         this.m_superArmor = false;
         this.m_heavyArmor = 0;
         this.m_launchResistance = 0;
         this.m_air_ease = -1;
         this.m_hit_ease = 0;
         this.m_xSpeedCap = -1;
         this.m_allowControl = false;
         this.m_allowControlGround = true;
         this.m_chargetime = 0;
         this.m_chargetime_max = 0;
         this.m_charge_retain = false;
         this.m_linkCharge = null;
         this.m_combo_max = 0;
         this.m_forceComboContinue = false;
         this.m_forceUseAtMaxCharge = false;
         this.m_forceGrabbable = false;
         this.m_holdRepeat = false;
         this.m_rotate = false;
         this.m_stale = false;
         this.m_flip = false;
         this.m_canFallOff = true;
         this.m_canGrabInverseLedges = true;
         this.m_forceFallthrough = false;
         this.m_canBeAbsorbed = false;
         this.m_hitEffect = null;
         this.m_disableOnHit = false;
         this.m_maintainSpeed = false;
         this.m_jumpFrame = null;
         this.m_parentAttack = null;
         this.m_secondaryAttack = null;
         this.m_isHorizontalRecoveryMove = false;
         this.m_isRecoveryMove = false;
         this.m_isLongRangeMove = false;
         this.m_disableForCPU = false;
         this.m_cpuAttackQueue = null;
         this.m_facedLedgesOnly = false;
         this.m_chargeInAir = true;
         this.m_canUseInAir = false;
         this.m_allowJump = false;
         this.m_allowFastFall = true;
         this.m_allowRun = false;
         this.m_allowTurn = false;
         this.m_allowDoubleJump = false;
         this.m_allowFullInterrupt = false;
         this.m_linkFrames = false;
         this.m_isDisabled = false;
         this.m_enabled = true;
         this.m_disableMove = false;
         this.m_reenableEffect = null;
         this.m_reenableTimer = 0;
         this.m_reenableTimerCount = 0;
         this.m_disableJump = false;
         this.m_controlDirection = false;
         this.m_homingSpeed = -1;
         this.m_chargeClick = false;
         this.m_lastUsed = 0;
         this.m_lastUsed_previous = 0;
         this.m_customChargeGlow = null;
         this.m_useChargeBar = true;
         this.m_lock_x_target = false;
         this.m_lock_y_target = false;
         this.m_ledgeFrame = null;
         this.m_ignorePlatformInfluence = false;
         this.m_IASA = false;
         this.m_grabBehind = false;
         this.m_attackVoices = new Array();
         this.m_attackSounds = new Array();
         this.m_attackBoxes = new Array();
         this.m_overrideMap = new Dictionary(Object);
      }
      
      public function get Name() : String
      {
         return this.m_name;
      }
      
      public function set Name(value:String) : void
      {
         this.m_name = this.m_name;
      }
      
      public function get RefreshRate() : int
      {
         return this.m_refreshRate;
      }
      
      public function get ResetMovement() : Boolean
      {
         return this.m_resetMovement;
      }
      
      public function get AttackDelay() : int
      {
         return this.m_attackDelay;
      }
      
      public function get Cancel() : Boolean
      {
         return this.m_cancel;
      }
      
      public function get CancelWhenAirborne() : Boolean
      {
         return this.m_cancelWhenAirborne;
      }
      
      public function get CancelSoundOnEnd() : Boolean
      {
         return this.m_cancelSoundOnEnd;
      }
      
      public function get CancelVoiceOnEnd() : Boolean
      {
         return this.m_cancelVoiceOnEnd;
      }
      
      public function get JumpCancel() : Boolean
      {
         return this.m_jumpCancel;
      }
      
      public function get JumpCancelAttack() : Boolean
      {
         return this.m_jumpCancelAttack;
      }
      
      public function get DoubleJumpCancel() : Boolean
      {
         return this.m_doubleJumpCancel;
      }
      
      public function get DoubleJumpCancelAttack() : Boolean
      {
         return this.m_doubleJumpCancelAttack;
      }
      
      public function get AirCancel() : Boolean
      {
         return this.m_airCancel;
      }
      
      public function get AirCancelSpecial() : Boolean
      {
         return this.m_airCancelSpecial;
      }
      
      public function get MustCharge() : Boolean
      {
         return this.m_mustCharge;
      }
      
      public function get XVelocityDecay() : Number
      {
         return this.m_xVelocityDecay;
      }
      
      public function get YVelocityDecay() : Number
      {
         return this.m_yVelocityDecay;
      }
      
      public function get XSpeedAccel() : Number
      {
         return this.m_xSpeedAccel;
      }
      
      public function get XSpeedAccelAir() : Number
      {
         return this.m_xSpeedAccelAir;
      }
      
      public function get XSpeedDecay() : Number
      {
         return this.m_xSpeedDecay;
      }
      
      public function get XSpeedDecayAir() : Number
      {
         return this.m_xSpeedDecayAir;
      }
      
      public function get ConserveJumpConstant() : Boolean
      {
         return this.m_conserveJumpConstant;
      }
      
      public function get Invincible() : Boolean
      {
         return this.m_invincible;
      }
      
      public function get SuperArmor() : Boolean
      {
         return this.m_superArmor;
      }
      
      public function get HeavyArmor() : Number
      {
         return this.m_heavyArmor;
      }
      
      public function get LaunchResistance() : Number
      {
         return this.m_launchResistance;
      }
      
      public function get AirEase() : Number
      {
         return this.m_air_ease;
      }
      
      public function get HitEase() : Number
      {
         return this.m_hit_ease;
      }
      
      public function get XSpeedCap() : Number
      {
         return this.m_xSpeedCap;
      }
      
      public function get AllowControl() : Boolean
      {
         return this.m_allowControl;
      }
      
      public function get AllowControlGround() : Boolean
      {
         return this.m_allowControlGround;
      }
      
      public function get ChargeTime() : int
      {
         return this.m_chargetime;
      }
      
      public function set ChargeTime(value:int) : void
      {
         this.m_chargetime = value;
         if(this.m_chargetime > this.m_chargetime_max)
         {
            this.m_chargetime = this.m_chargetime_max;
         }
      }
      
      public function get ChargeTimeMax() : int
      {
         return this.m_chargetime_max;
      }
      
      public function get ChargeRetain() : Boolean
      {
         return this.m_charge_retain;
      }
      
      public function get LinkCharge() : String
      {
         return this.m_linkCharge;
      }
      
      public function get ComboMax() : int
      {
         return this.m_combo_max;
      }
      
      public function get ForceComboContinue() : Boolean
      {
         return this.m_forceComboContinue;
      }
      
      public function get ForceUseAtMaxCharge() : Boolean
      {
         return this.m_forceUseAtMaxCharge;
      }
      
      public function get ForceGrabbable() : Boolean
      {
         return this.m_forceGrabbable;
      }
      
      public function get HoldRepeat() : Boolean
      {
         return this.m_holdRepeat;
      }
      
      public function get Rotate() : Boolean
      {
         return this.m_rotate;
      }
      
      public function get Stale() : Boolean
      {
         return this.m_stale;
      }
      
      public function get Flip() : Boolean
      {
         return this.m_flip;
      }
      
      public function get CanFallOff() : Boolean
      {
         return this.m_canFallOff;
      }
      
      public function get CanGrabInverseLedges() : Boolean
      {
         return this.m_canGrabInverseLedges;
      }
      
      public function get ForceFallThrough() : Boolean
      {
         return this.m_forceFallthrough;
      }
      
      public function get CanBeAbsorbed() : Boolean
      {
         return this.m_canBeAbsorbed;
      }
      
      public function get HitEffect() : String
      {
         return this.m_hitEffect;
      }
      
      public function get DisableOnHit() : Boolean
      {
         return this.m_disableOnHit;
      }
      
      public function get MaintainSpeed() : Boolean
      {
         return this.m_maintainSpeed;
      }
      
      public function get JumpFrame() : String
      {
         return this.m_jumpFrame;
      }
      
      public function get ParentAttack() : String
      {
         return this.m_parentAttack;
      }
      
      public function get SecondaryAttack() : String
      {
         return this.m_secondaryAttack;
      }
      
      public function get IsHorizontalRecoveryMove() : Boolean
      {
         return this.m_isHorizontalRecoveryMove;
      }
      
      public function get IsRecoveryMove() : Boolean
      {
         return this.m_isRecoveryMove;
      }
      
      public function get IsLongRangeMove() : Boolean
      {
         return this.m_isLongRangeMove;
      }
      
      public function get DisableForCPU() : Boolean
      {
         return this.m_disableForCPU;
      }
      
      public function get CPUAttackList() : String
      {
         return this.m_cpuAttackQueue;
      }
      
      public function get FacedLedgesOnly() : Boolean
      {
         return this.m_facedLedgesOnly;
      }
      
      public function get ChargeInAir() : Boolean
      {
         return this.m_chargeInAir;
      }
      
      public function get CanUseInAir() : Boolean
      {
         return this.m_canUseInAir;
      }
      
      public function get AllowJump() : Boolean
      {
         return this.m_allowJump;
      }
      
      public function get AllowFastFall() : Boolean
      {
         return this.m_allowFastFall;
      }
      
      public function get AllowRun() : Boolean
      {
         return this.m_allowRun;
      }
      
      public function get AllowTurn() : Boolean
      {
         return this.m_allowTurn;
      }
      
      public function get AllowDoubleJump() : Boolean
      {
         return this.m_allowDoubleJump;
      }
      
      public function get AllowFullInterrupt() : Boolean
      {
         return this.m_allowFullInterrupt;
      }
      
      public function get LinkFrames() : Boolean
      {
         return this.m_linkFrames;
      }
      
      public function get IsDisabled() : Boolean
      {
         return this.m_isDisabled;
      }
      
      public function get Enabled() : Boolean
      {
         return this.m_enabled;
      }
      
      public function set IsDisabled(value:Boolean) : void
      {
         this.m_isDisabled = value;
      }
      
      public function get ReenableEffect() : String
      {
         return this.m_reenableEffect;
      }
      
      public function get ReenableTimer() : int
      {
         return this.m_reenableTimer;
      }
      
      public function get ReenableTimerCount() : int
      {
         return this.m_reenableTimerCount;
      }
      
      public function set ReenableTimerCount(value:int) : void
      {
         this.m_reenableTimerCount = value;
      }
      
      public function get DisableJump() : Boolean
      {
         return this.m_disableJump;
      }
      
      public function get ControlDirection() : Boolean
      {
         return this.m_controlDirection;
      }
      
      public function get HomingSpeed() : Number
      {
         return this.m_homingSpeed;
      }
      
      public function get ChargeClick() : Boolean
      {
         return this.m_chargeClick;
      }
      
      public function get LastUsed() : int
      {
         return this.m_lastUsed;
      }
      
      public function set LastUsed(value:int) : void
      {
         this.m_lastUsed = value;
      }
      
      public function get LastUsedPrevious() : int
      {
         return this.m_lastUsed_previous;
      }
      
      public function set LastUsedPrevious(value:int) : void
      {
         this.m_lastUsed_previous = value;
      }
      
      public function get CustomChargeGlow() : String
      {
         return this.m_customChargeGlow;
      }
      
      public function get UseChargeBar() : Boolean
      {
         return this.m_useChargeBar;
      }
      
      public function get LockXTarget() : Boolean
      {
         return this.m_lock_x_target;
      }
      
      public function get LockYTarget() : Boolean
      {
         return this.m_lock_y_target;
      }
      
      public function get LedgeFrame() : String
      {
         return this.m_ledgeFrame;
      }
      
      public function get IgnorePlatformInfluence() : Boolean
      {
         return this.m_ignorePlatformInfluence;
      }
      
      public function get IASA() : Boolean
      {
         return this.m_IASA;
      }
      
      public function get GrabBehind() : Boolean
      {
         return this.m_grabBehind;
      }
      
      public function get AttackVoices() : Array
      {
         return this.m_attackVoices;
      }
      
      public function get AttackSounds() : Array
      {
         return this.m_attackSounds;
      }
      
      public function get AttackBoxes() : Array
      {
         return this.m_attackBoxes;
      }
      
      public function set Stale(value:Boolean) : void
      {
         this.m_stale = value;
      }
      
      public function get OverrideMap() : Dictionary
      {
         return this.m_overrideMap;
      }
      
      public function Clone() : AttackObject
      {
         var obj:Object = this.exportAttackData();
         var attack:AttackObject = new AttackObject(this.m_name);
         attack.importAttackData(obj);
         return attack;
      }
      
      public function importAttackData(data:Object) : void
      {
         var obj:* = undefined;
         var b:* = undefined;
         for(obj in data)
         {
            if(Boolean(obj.match(/^attackVoice\d+_id$/)))
            {
               this.m_attackVoices[parseInt(obj.match(/\d+/)[0]) - 1] = data[obj];
            }
            else if(Boolean(obj.match(/^attackSound\d+_id$/)))
            {
               this.m_attackSounds[parseInt(obj.match(/\d+/)[0]) - 1] = data[obj];
            }
            else if(obj == "attackBoxes")
            {
               for(b in data[obj])
               {
                  this.m_attackBoxes[b] = new AttackDamage(-1,null);
                  this.m_attackBoxes[b].importAttackDamageData(data[obj][b]);
               }
            }
            else if(this["m_" + obj] !== undefined)
            {
               this["m_" + obj] = data[obj];
            }
            else
            {
               trace("You tried to set \"m_" + obj + "\" but it doesn\'t exist in the AttackObject class.");
            }
         }
      }
      
      public function setVar(vName:String, value:*) : void
      {
         if(this["m_" + vName] !== undefined)
         {
            this["m_" + vName] = value;
         }
         else
         {
            trace("Could not set var \"" + vName + "\" to " + value + " in AttackObject");
         }
      }
      
      public function updateAllAttackBoxes(data:Object) : void
      {
         var obj:* = undefined;
         for(obj in this.m_attackBoxes)
         {
            this.m_attackBoxes[obj].importAttackDamageData(data);
         }
      }
      
      public function exportAttackData() : Object
      {
         var obj:* = undefined;
         var attack:Object = new Object();
         attack.name = this.m_name;
         attack.refreshRate = this.m_refreshRate;
         attack.resetMovement = this.m_resetMovement;
         attack.attackDelay = this.m_attackDelay;
         attack.cancel = this.m_cancel;
         attack.cancelWhenAirborne = this.m_cancelWhenAirborne;
         attack.cancelSoundOnEnd = this.m_cancelSoundOnEnd;
         attack.cancelVoiceOnEnd = this.m_cancelVoiceOnEnd;
         attack.jumpCancel = this.m_jumpCancel;
         attack.jumpCancelAttack = this.m_jumpCancelAttack;
         attack.doubleJumpCancel = this.m_doubleJumpCancel;
         attack.doubleJumpCancelAttack = this.m_doubleJumpCancelAttack;
         attack.airCancel = this.m_airCancel;
         attack.airCancelSpecial = this.m_airCancelSpecial;
         attack.mustCharge = this.m_mustCharge;
         attack.xVelocityDecay = this.m_xVelocityDecay;
         attack.yVelocityDecay = this.m_yVelocityDecay;
         attack.xSpeedAccel = this.m_xSpeedAccel;
         attack.xSpeedAccelAir = this.m_xSpeedAccelAir;
         attack.xSpeedDecay = this.m_xSpeedDecay;
         attack.xSpeedDecayAir = this.m_xSpeedDecayAir;
         attack.conserveJumpConstant = this.m_conserveJumpConstant;
         attack.invincible = this.m_invincible;
         attack.superArmor = this.m_superArmor;
         attack.heavyArmor = this.m_heavyArmor;
         attack.launchResistance = this.m_launchResistance;
         attack.air_ease = this.m_air_ease;
         attack.hit_ease = this.m_hit_ease;
         attack.xSpeedCap = this.m_xSpeedCap;
         attack.allowControl = this.m_allowControl;
         attack.allowControlGround = this.m_allowControlGround;
         attack.chargetime = this.m_chargetime;
         attack.chargetime_max = this.m_chargetime_max;
         attack.charge_retain = this.m_charge_retain;
         attack.linkCharge = this.m_linkCharge;
         attack.combo_max = this.m_combo_max;
         attack.forceComboContinue = this.m_forceComboContinue;
         attack.forceUseAtMaxCharge = this.m_forceUseAtMaxCharge;
         attack.forceGrabbable = this.m_forceGrabbable;
         attack.holdRepeat = this.m_holdRepeat;
         attack.rotate = this.m_rotate;
         attack.stale = this.m_stale;
         attack.flip = this.m_flip;
         attack.canFallOff = this.m_canFallOff;
         attack.canGrabInverseLedges = this.m_canGrabInverseLedges;
         attack.forceFallthrough = this.m_forceFallthrough;
         attack.canBeAbsorbed = this.m_canBeAbsorbed;
         attack.hitEffect = this.m_hitEffect;
         attack.disableOnHit = this.m_disableOnHit;
         attack.maintainSpeed = this.m_maintainSpeed;
         attack.jumpFrame = this.m_jumpFrame;
         attack.parentAttack = this.m_parentAttack;
         attack.secondaryAttack = this.m_secondaryAttack;
         attack.isHorizontalRecoveryMove = this.m_isHorizontalRecoveryMove;
         attack.isRecoveryMove = this.m_isRecoveryMove;
         attack.isLongRangeMove = this.m_isLongRangeMove;
         attack.disableForCPU = this.m_disableForCPU;
         attack.cpuAttackQueue = this.m_cpuAttackQueue;
         attack.facedLedgesOnly = this.m_facedLedgesOnly;
         attack.chargeInAir = this.m_chargeInAir;
         attack.canUseInAir = this.m_canUseInAir;
         attack.allowJump = this.m_allowJump;
         attack.allowFastFall = this.m_allowFastFall;
         attack.allowRun = this.m_allowRun;
         attack.allowTurn = this.m_allowTurn;
         attack.allowDoubleJump = this.m_allowDoubleJump;
         attack.allowFullInterrupt = this.m_allowFullInterrupt;
         attack.linkFrames = this.m_linkFrames;
         attack.isDisabled = this.m_isDisabled;
         attack.enabled = this.m_enabled;
         attack.disableMove = this.m_disableMove;
         attack.reenableEffect = this.m_reenableEffect;
         attack.reenableTimer = this.m_reenableTimer;
         attack.reenableTimerCount = this.m_reenableTimerCount;
         attack.disableJump = this.m_disableJump;
         attack.controlDirection = this.m_controlDirection;
         attack.homingSpeed = this.m_homingSpeed;
         attack.lastUsed = this.m_lastUsed;
         attack.customChargeGlow = this.m_customChargeGlow;
         attack.useChargeBar = this.m_useChargeBar;
         attack.lock_x_target = this.m_lock_x_target;
         attack.lock_y_target = this.m_lock_y_target;
         attack.ledgeFrame = this.m_ledgeFrame;
         attack.ignorePlatformInfluence = this.m_ignorePlatformInfluence;
         attack.IASA = this.m_IASA;
         attack.grabBehind = this.m_grabBehind;
         attack.chargeClick = this.m_chargeClick;
         var i:Number = 0;
         for(i = 0; i < this.m_attackVoices.length; i++)
         {
            attack["attackVoice" + (i + 1) + "_id"] = this.m_attackVoices[i];
         }
         for(i = 0; i < this.m_attackSounds.length; i++)
         {
            attack["attackSound" + (i + 1) + "_id"] = this.m_attackSounds[i];
         }
         attack.attackBoxes = new Object();
         for(obj in this.m_attackBoxes)
         {
            attack.attackBoxes[obj] = this.m_attackBoxes[obj].exportAttackDamageData();
         }
         return attack;
      }
   }
}

