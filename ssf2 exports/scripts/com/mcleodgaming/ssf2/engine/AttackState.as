package com.mcleodgaming.ssf2.engine
{
   import com.mcleodgaming.ssf2.items.*;
   import com.mcleodgaming.ssf2.util.*;
   
   public class AttackState
   {
      
      protected var m_owner:InteractiveSprite;
      
      protected var m_isAttacking:Boolean;
      
      protected var m_isForward:Boolean;
      
      protected var m_staleMultiplier:Number;
      
      protected var m_xSpeedAccel:Number;
      
      protected var m_xSpeedAccelAir:Number;
      
      protected var m_xSpeedDecay:Number;
      
      protected var m_xSpeedDecayAir:Number;
      
      protected var m_invincible:Boolean;
      
      protected var m_superArmor:Boolean;
      
      protected var m_heavyArmor:Number;
      
      protected var m_launchResistance:Number;
      
      protected var m_combo_total:int;
      
      protected var m_combo_max:int;
      
      protected var m_forceComboContinue:Boolean;
      
      protected var m_forceTumbleFall:Boolean;
      
      protected var m_forceFallThrough:Boolean;
      
      protected var m_forceGrabbable:Boolean;
      
      protected var m_rocket:Boolean;
      
      protected var m_holdRepeat:Boolean;
      
      protected var m_rotate:Boolean;
      
      protected var m_nextComboFrame:String;
      
      protected var m_atk_id:int;
      
      protected var m_id:int;
      
      protected var m_frame:String;
      
      protected var m_letGo:Boolean;
      
      protected var m_hasLanded:Boolean;
      
      protected var m_exec_time:int;
      
      protected var m_allowControl:Boolean;
      
      protected var m_allowControlGround:Boolean;
      
      protected var m_disable:Boolean;
      
      protected var m_chargedAttacks:Object;
      
      protected var m_direction:Number;
      
      protected var m_reversableAngle:Boolean;
      
      protected var m_chargetime:int;
      
      protected var m_chargetime_max:int;
      
      protected var m_linkCharge:String;
      
      protected var m_charge_retain:Boolean;
      
      protected var m_ignoreChargeKnockback:Boolean;
      
      protected var m_attackType:int;
      
      protected var m_transformed:Boolean;
      
      protected var m_refreshRate:int;
      
      protected var m_refreshRateTimer:int;
      
      protected var m_refreshRateReady:Boolean;
      
      protected var m_resetMovement:Boolean;
      
      protected var m_cancel:Boolean;
      
      protected var m_cancelWhenAirborne:Boolean;
      
      protected var m_cancelSoundOnEnd:Boolean;
      
      protected var m_cancelVoiceOnEnd:Boolean;
      
      protected var m_wasCancelled:Boolean;
      
      protected var m_airCancel:Boolean;
      
      protected var m_airCancelSpecial:Boolean;
      
      protected var m_xloc:Number;
      
      protected var m_yloc:Number;
      
      protected var m_attackDelay:int;
      
      protected var m_mustCharge:Boolean;
      
      protected var m_isAirAttack:Boolean;
      
      protected var m_disableHurtSound:Boolean;
      
      protected var m_disableHurtFallOff:Boolean;
      
      protected var m_disableLastHitUpdate:Boolean;
      
      protected var m_reverseID:int;
      
      protected var m_reverseTeam:int;
      
      protected var m_air_ease:Number;
      
      protected var m_hit_ease:Number;
      
      protected var m_xSpeedCap:Number;
      
      protected var m_homingTarget:InteractiveSprite;
      
      protected var m_homingSpeed:Number;
      
      protected var m_disableJump:Boolean;
      
      protected var m_jumpCancelAttack:Boolean;
      
      protected var m_doubleJumpCancelAttack:Boolean;
      
      protected var m_allowJump:Boolean;
      
      protected var m_allowFastFall:Boolean;
      
      protected var m_allowRun:Boolean;
      
      protected var m_allowTurn:Boolean;
      
      protected var m_allowDoubleJump:Boolean;
      
      protected var m_allowFullInterrupt:Boolean;
      
      protected var m_linkFrames:Boolean;
      
      protected var m_isTurning:Boolean;
      
      protected var m_isAccelerating:Boolean;
      
      protected var m_isThrow:Boolean;
      
      protected var m_chargeInAir:Boolean;
      
      protected var m_canFallOff:Boolean;
      
      protected var m_canBeAbsorbed:Boolean;
      
      protected var m_maintainSpeed:Boolean;
      
      protected var m_secondaryAttack:String;
      
      protected var m_sizeStatus:int;
      
      protected var m_facedLedgesOnly:Boolean;
      
      protected var m_canGrabInverseLedges:Boolean;
      
      protected var m_ledgeFrame:String;
      
      protected var m_ignorePlatformInfluence:Boolean;
      
      protected var m_IASA:Boolean;
      
      protected var m_grabBehind:Boolean;
      
      protected var m_attackRatio:Number;
      
      protected var m_hasClanked:Boolean;
      
      public function AttackState(owner:InteractiveSprite = null)
      {
         super();
         this.m_owner = owner;
         this.m_isAttacking = false;
         this.m_isForward = true;
         this.m_staleMultiplier = 1.05;
         this.m_xSpeedAccel = 0;
         this.m_xSpeedAccelAir = 0;
         this.m_xSpeedDecay = 0;
         this.m_xSpeedDecayAir = 0;
         this.m_invincible = false;
         this.m_superArmor = false;
         this.m_heavyArmor = 0;
         this.m_launchResistance = 0;
         this.m_combo_total = 0;
         this.m_combo_max = 0;
         this.m_forceComboContinue = false;
         this.m_forceTumbleFall = false;
         this.m_forceFallThrough = false;
         this.m_forceGrabbable = false;
         this.m_rocket = false;
         this.m_holdRepeat = false;
         this.m_rotate = false;
         this.m_nextComboFrame = null;
         this.m_atk_id = Utils.getUID();
         this.m_id = Utils.getUID();
         this.m_frame = null;
         this.m_letGo = false;
         this.m_hasLanded = true;
         this.m_exec_time = 0;
         this.m_allowControl = false;
         this.m_allowControlGround = true;
         this.m_chargedAttacks = {};
         this.m_charge_retain = false;
         this.m_chargetime = 0;
         this.m_chargetime_max = 0;
         this.m_linkCharge = null;
         this.m_attackType = 0;
         this.m_transformed = false;
         this.m_refreshRate = 50;
         this.m_refreshRateTimer = 1;
         this.m_refreshRateReady = true;
         this.m_resetMovement = false;
         this.m_cancel = false;
         this.m_cancelWhenAirborne = true;
         this.m_cancelSoundOnEnd = false;
         this.m_cancelVoiceOnEnd = false;
         this.m_wasCancelled = false;
         this.m_airCancel = false;
         this.m_airCancelSpecial = false;
         this.m_xloc = 0;
         this.m_yloc = 0;
         this.m_attackDelay = 0;
         this.m_mustCharge = false;
         this.m_isAirAttack = false;
         this.m_disableHurtSound = false;
         this.m_disableHurtFallOff = false;
         this.m_disableLastHitUpdate = false;
         this.m_reverseID = -1;
         this.m_reverseTeam = -1;
         this.m_air_ease = -1;
         this.m_hit_ease = 0;
         this.m_xSpeedCap = -1;
         this.m_homingTarget = null;
         this.m_homingSpeed = -1;
         this.m_disableJump = false;
         this.m_jumpCancelAttack = false;
         this.m_doubleJumpCancelAttack = false;
         this.m_allowJump = false;
         this.m_allowFastFall = true;
         this.m_allowRun = false;
         this.m_allowTurn = false;
         this.m_allowDoubleJump = false;
         this.m_allowFullInterrupt = false;
         this.m_linkFrames = false;
         this.m_isTurning = false;
         this.m_isAccelerating = false;
         this.m_isThrow = false;
         this.m_chargeInAir = true;
         this.m_canFallOff = false;
         this.m_canBeAbsorbed = false;
         this.m_maintainSpeed = false;
         this.m_secondaryAttack = null;
         this.m_sizeStatus = 0;
         this.m_facedLedgesOnly = false;
         this.m_canGrabInverseLedges = true;
         this.m_ledgeFrame = null;
         this.m_ignorePlatformInfluence = false;
         this.m_IASA = false;
         this.m_grabBehind = false;
         this.m_attackRatio = 1;
         this.m_hasClanked = false;
      }
      
      public function simpleReset() : void
      {
         this.m_isAttacking = false;
         this.m_isForward = true;
         this.m_staleMultiplier = 1.05;
         this.m_xSpeedAccel = 0;
         this.m_xSpeedAccelAir = 0;
         this.m_xSpeedDecay = 0;
         this.m_xSpeedDecayAir = 0;
         this.m_invincible = false;
         this.m_superArmor = false;
         this.m_heavyArmor = 0;
         this.m_launchResistance = 0;
         this.m_combo_total = 0;
         this.m_combo_max = 0;
         this.m_forceComboContinue = false;
         this.m_forceTumbleFall = false;
         this.m_forceFallThrough = false;
         this.m_forceGrabbable = false;
         this.m_rocket = false;
         this.m_holdRepeat = false;
         this.m_rotate = false;
         this.m_nextComboFrame = null;
         this.m_frame = null;
         this.m_letGo = false;
         this.m_hasLanded = true;
         this.m_exec_time = 0;
         this.m_allowControl = false;
         this.m_allowControlGround = true;
         this.m_chargedAttacks = {};
         this.m_charge_retain = false;
         this.m_chargetime = 0;
         this.m_chargetime_max = 0;
         this.m_linkCharge = null;
         this.m_attackType = 0;
         this.m_transformed = false;
         this.m_refreshRate = 50;
         this.m_resetMovement = false;
         this.m_cancel = false;
         this.m_cancelWhenAirborne = true;
         this.m_cancelSoundOnEnd = false;
         this.m_cancelVoiceOnEnd = false;
         this.m_wasCancelled = false;
         this.m_airCancel = false;
         this.m_airCancelSpecial = false;
         this.m_xloc = 0;
         this.m_yloc = 0;
         this.m_attackDelay = 0;
         this.m_mustCharge = false;
         this.m_isAirAttack = false;
         this.m_disableHurtSound = false;
         this.m_disableHurtFallOff = false;
         this.m_disableLastHitUpdate = false;
         this.m_reverseID = -1;
         this.m_reverseTeam = -1;
         this.m_air_ease = -1;
         this.m_hit_ease = 0;
         this.m_xSpeedCap = -1;
         this.m_homingTarget = null;
         this.m_homingSpeed = -1;
         this.m_disableJump = false;
         this.m_jumpCancelAttack = false;
         this.m_doubleJumpCancelAttack = false;
         this.m_allowJump = false;
         this.m_allowFastFall = true;
         this.m_allowRun = false;
         this.m_allowTurn = false;
         this.m_allowDoubleJump = false;
         this.m_allowFullInterrupt = false;
         this.m_linkFrames = false;
         this.m_isTurning = false;
         this.m_isAccelerating = false;
         this.m_isThrow = false;
         this.m_chargeInAir = true;
         this.m_canFallOff = false;
         this.m_canBeAbsorbed = false;
         this.m_maintainSpeed = false;
         this.m_secondaryAttack = null;
         this.m_sizeStatus = 0;
         this.m_facedLedgesOnly = false;
         this.m_canGrabInverseLedges = true;
         this.m_ledgeFrame = null;
         this.m_ignorePlatformInfluence = false;
         this.m_IASA = false;
         this.m_grabBehind = false;
         this.m_attackRatio = 1;
         this.m_hasClanked = false;
      }
      
      public function syncState(attackState:AttackState) : void
      {
         this.m_isForward = attackState.IsForward;
         this.m_id = attackState.ID;
         this.m_atk_id = attackState.AttackID;
         this.m_isAirAttack = attackState.IsAirAttack;
         this.m_isThrow = attackState.IsThrow;
         this.m_attackRatio = attackState.AttackRatio;
         this.m_sizeStatus = attackState.SizeStatus;
         this.m_disableHurtSound = attackState.DisableHurtSound;
         this.m_xloc = attackState.XLoc;
         this.m_yloc = attackState.YLoc;
         this.m_owner = attackState.Owner;
         this.m_chargetime = attackState.ChargeTime;
         this.m_chargetime_max = attackState.ChargeTimeMax;
         this.m_staleMultiplier = attackState.StaleMultiplier;
         this.m_frame = attackState.Frame;
      }
      
      public function get Owner() : InteractiveSprite
      {
         return this.m_owner;
      }
      
      public function get IsAttacking() : Boolean
      {
         return this.m_isAttacking;
      }
      
      public function get IsForward() : Boolean
      {
         return this.m_isForward;
      }
      
      public function get StaleMultiplier() : Number
      {
         return this.m_staleMultiplier;
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
      
      public function get ComboTotal() : int
      {
         return this.m_combo_total;
      }
      
      public function set ComboTotal(value:int) : void
      {
         this.m_combo_total = value;
      }
      
      public function get ComboMax() : int
      {
         return this.m_combo_max;
      }
      
      public function set ComboMax(value:int) : void
      {
         this.m_combo_max = value;
      }
      
      public function get ForceComboContinue() : Boolean
      {
         return this.m_forceComboContinue;
      }
      
      public function get ForceTumbleFall() : Boolean
      {
         return this.m_forceTumbleFall;
      }
      
      public function get ForceFallThrough() : Boolean
      {
         return this.m_forceFallThrough;
      }
      
      public function get ForceGrabbable() : Boolean
      {
         return this.m_forceGrabbable;
      }
      
      public function get Rocket() : Boolean
      {
         return this.m_rocket;
      }
      
      public function get HoldRepeat() : Boolean
      {
         return this.m_holdRepeat;
      }
      
      public function get Rotate() : Boolean
      {
         return this.m_rotate;
      }
      
      public function get NextComboFrame() : String
      {
         return this.m_nextComboFrame;
      }
      
      public function get AttackID() : int
      {
         return this.m_atk_id;
      }
      
      public function get ID() : int
      {
         return this.m_id;
      }
      
      public function get Frame() : String
      {
         return this.m_frame;
      }
      
      public function get LetGo() : Boolean
      {
         return this.m_letGo;
      }
      
      public function get HasLanded() : Boolean
      {
         return this.m_hasLanded;
      }
      
      public function get ExecTime() : int
      {
         return this.m_exec_time;
      }
      
      public function get AllowControl() : Boolean
      {
         return this.m_allowControl;
      }
      
      public function get AllowControlGround() : Boolean
      {
         return this.m_allowControlGround;
      }
      
      public function get ChargedAttacks() : Object
      {
         return this.m_chargedAttacks;
      }
      
      public function get ChargeTime() : int
      {
         return this.m_chargetime;
      }
      
      public function get ChargeTimeMax() : int
      {
         return this.m_chargetime_max;
      }
      
      public function get LinkCharge() : String
      {
         return this.m_linkCharge;
      }
      
      public function get AttackType() : int
      {
         return this.m_attackType;
      }
      
      public function get Transformed() : Boolean
      {
         return this.m_transformed;
      }
      
      public function get RefreshRate() : int
      {
         return this.m_refreshRate;
      }
      
      public function get RefreshRateTimer() : int
      {
         return this.m_refreshRateTimer;
      }
      
      public function get RefreshRateReady() : Boolean
      {
         return this.m_refreshRateReady;
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
      
      public function get WasCancelled() : Boolean
      {
         return this.m_wasCancelled;
      }
      
      public function get AirCancel() : Boolean
      {
         return this.m_airCancel;
      }
      
      public function get AirCancelSpecial() : Boolean
      {
         return this.m_airCancelSpecial;
      }
      
      public function get XLoc() : Number
      {
         return this.m_xloc;
      }
      
      public function get YLoc() : Number
      {
         return this.m_yloc;
      }
      
      public function get AttackDelay() : int
      {
         return this.m_attackDelay;
      }
      
      public function get MustCharge() : Boolean
      {
         return this.m_mustCharge;
      }
      
      public function get IsAirAttack() : Boolean
      {
         return this.m_isAirAttack;
      }
      
      public function get DisableHurtSound() : Boolean
      {
         return this.m_disableHurtSound;
      }
      
      public function get DisableHurtFallOff() : Boolean
      {
         return this.m_disableHurtFallOff;
      }
      
      public function get DisableLastHitUpdate() : Boolean
      {
         return this.m_disableLastHitUpdate;
      }
      
      public function get ReverseID() : int
      {
         return this.m_reverseID;
      }
      
      public function get ReverseTeam() : int
      {
         return this.m_reverseTeam;
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
      
      public function get HomingTarget() : InteractiveSprite
      {
         return this.m_homingTarget;
      }
      
      public function get HomingSpeed() : Number
      {
         return this.m_homingSpeed;
      }
      
      public function get DisableJump() : Boolean
      {
         return this.m_disableJump;
      }
      
      public function get JumpCancelAttack() : Boolean
      {
         return this.m_jumpCancelAttack;
      }
      
      public function get DoubleJumpCancelAttack() : Boolean
      {
         return this.m_doubleJumpCancelAttack;
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
      
      public function get IsTurning() : Boolean
      {
         return this.m_isTurning;
      }
      
      public function get IsAccelerating() : Boolean
      {
         return this.m_isAccelerating;
      }
      
      public function get IsThrow() : Boolean
      {
         return this.m_isThrow;
      }
      
      public function get ChargeInAir() : Boolean
      {
         return this.m_chargeInAir;
      }
      
      public function get SizeStatus() : int
      {
         return this.m_sizeStatus;
      }
      
      public function get FacedLedgesOnly() : Boolean
      {
         return this.m_facedLedgesOnly;
      }
      
      public function get CanGrabInverseLedges() : Boolean
      {
         return this.m_canGrabInverseLedges;
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
      
      public function get AttackRatio() : Number
      {
         return this.m_attackRatio;
      }
      
      public function get ChargeRetain() : Boolean
      {
         return this.m_charge_retain;
      }
      
      public function get IgnoreChargeKnockback() : Boolean
      {
         return this.m_ignoreChargeKnockback;
      }
      
      public function get ResetMovement() : Boolean
      {
         return this.m_resetMovement;
      }
      
      public function get CanFallOff() : Boolean
      {
         return this.m_canFallOff;
      }
      
      public function get CanBeAbsorbed() : Boolean
      {
         return this.m_canBeAbsorbed;
      }
      
      public function get MaintainSpeed() : Boolean
      {
         return this.m_maintainSpeed;
      }
      
      public function get SecondaryAttack() : String
      {
         return this.m_secondaryAttack;
      }
      
      public function get HasClanked() : Boolean
      {
         return this.m_hasClanked;
      }
      
      public function set Owner(value:InteractiveSprite) : void
      {
         this.m_owner = value;
      }
      
      public function set IsAttacking(value:Boolean) : void
      {
         this.m_isAttacking = value;
      }
      
      public function set IsForward(value:Boolean) : void
      {
         this.m_isForward = value;
      }
      
      public function set StaleMultiplier(value:Number) : void
      {
         this.m_staleMultiplier = value;
      }
      
      public function set XSpeedAccel(value:Number) : void
      {
         this.m_xSpeedAccel = value;
      }
      
      public function set XSpeedAccelAir(value:Number) : void
      {
         this.m_xSpeedAccelAir = value;
      }
      
      public function set XSpeedDecay(value:Number) : void
      {
         this.m_xSpeedDecay = value;
      }
      
      public function set XSpeedDecayAir(value:Number) : void
      {
         this.m_xSpeedDecayAir = value;
      }
      
      public function set Invincible(value:Boolean) : void
      {
         this.m_invincible = value;
      }
      
      public function set SuperArmor(value:Boolean) : void
      {
         this.m_superArmor = value;
      }
      
      public function set HeavyArmor(value:Number) : void
      {
         this.m_heavyArmor = value;
      }
      
      public function set LaunchResistance(value:Number) : void
      {
         this.m_launchResistance = value;
      }
      
      public function set ForceComboContinue(value:Boolean) : void
      {
         this.m_forceComboContinue = value;
      }
      
      public function set ForceTumbleFall(value:Boolean) : void
      {
         this.m_forceTumbleFall = value;
      }
      
      public function set ForceFallThrough(value:Boolean) : void
      {
         this.m_forceFallThrough = value;
      }
      
      public function set ForceGrabbable(value:Boolean) : void
      {
         this.m_forceGrabbable = value;
      }
      
      public function set Rocket(value:Boolean) : void
      {
         this.m_rocket = value;
      }
      
      public function set HoldRepeat(value:Boolean) : void
      {
         this.m_holdRepeat = value;
      }
      
      public function set Rotate(value:Boolean) : void
      {
         this.m_rotate = value;
      }
      
      public function set NextComboFrame(value:String) : void
      {
         this.m_nextComboFrame = value;
      }
      
      public function set AttackID(value:int) : void
      {
         this.m_atk_id = value;
      }
      
      public function set ID(value:int) : void
      {
         this.m_id = value;
      }
      
      public function set Frame(value:String) : void
      {
         this.m_frame = value;
      }
      
      public function set LetGo(value:Boolean) : void
      {
         this.m_letGo = value;
      }
      
      public function set HasLanded(value:Boolean) : void
      {
         this.m_hasLanded = value;
      }
      
      public function set ExecTime(value:int) : void
      {
         this.m_exec_time = value;
      }
      
      public function set AllowControl(value:Boolean) : void
      {
         this.m_allowControl = value;
      }
      
      public function set AllowControlGround(value:Boolean) : void
      {
         this.m_allowControlGround = value;
      }
      
      public function set ChargedAttacks(value:Object) : void
      {
         this.m_chargedAttacks = value;
      }
      
      public function set ChargeTime(value:int) : void
      {
         this.m_chargetime = value;
      }
      
      public function set ChargeTimeMax(value:int) : void
      {
         this.m_chargetime_max = value;
      }
      
      public function set LinkCharge(value:String) : void
      {
         this.m_linkCharge = value;
      }
      
      public function set AttackType(value:int) : void
      {
         this.m_attackType = value;
      }
      
      public function set Transformed(value:Boolean) : void
      {
         this.m_transformed = value;
      }
      
      public function set RefreshRate(value:int) : void
      {
         this.m_refreshRate = value;
      }
      
      public function set RefreshRateTimer(value:int) : void
      {
         if(this.m_refreshRateReady)
         {
            this.m_refreshRateTimer = value;
         }
      }
      
      public function set RefreshRateReady(value:Boolean) : void
      {
         this.m_refreshRateReady = value;
      }
      
      public function set Cancel(value:Boolean) : void
      {
         this.m_cancel = value;
      }
      
      public function set CancelWhenAirborne(value:Boolean) : void
      {
         this.m_cancelWhenAirborne = value;
      }
      
      public function set CancelSoundOnEnd(value:Boolean) : void
      {
         this.m_cancelSoundOnEnd = value;
      }
      
      public function set CancelVoiceOnEnd(value:Boolean) : void
      {
         this.m_cancelVoiceOnEnd = value;
      }
      
      public function set WasCancelled(value:Boolean) : void
      {
         this.m_wasCancelled = value;
      }
      
      public function set AirCancel(value:Boolean) : void
      {
         this.m_airCancel = value;
      }
      
      public function set AirCancelSpecial(value:Boolean) : void
      {
         this.m_airCancelSpecial = value;
      }
      
      public function set XLoc(value:Number) : void
      {
         this.m_xloc = value;
      }
      
      public function set YLoc(value:Number) : void
      {
         this.m_yloc = value;
      }
      
      public function set AttackDelay(value:int) : void
      {
         this.m_attackDelay = value;
      }
      
      public function set MustCharge(value:Boolean) : void
      {
         this.m_mustCharge = value;
      }
      
      public function set IsAirAttack(value:Boolean) : void
      {
         this.m_isAirAttack = value;
      }
      
      public function set DisableHurtSound(value:Boolean) : void
      {
         this.m_disableHurtSound = value;
      }
      
      public function set DisableHurtFallOff(value:Boolean) : void
      {
         this.m_disableHurtFallOff = value;
      }
      
      public function set DisableLastHitUpdate(value:Boolean) : void
      {
         this.m_disableLastHitUpdate = value;
      }
      
      public function set ReverseID(value:int) : void
      {
         this.m_reverseID = value;
      }
      
      public function set ReverseTeam(value:int) : void
      {
         this.m_reverseTeam = value;
      }
      
      public function set AirEase(value:Number) : void
      {
         this.m_air_ease = value;
      }
      
      public function set XSpeedCap(value:Number) : void
      {
         this.m_xSpeedCap = value;
      }
      
      public function set HitEase(value:Number) : void
      {
         this.m_hit_ease = value;
      }
      
      public function set HomingTarget(value:InteractiveSprite) : void
      {
         this.m_homingTarget = value;
      }
      
      public function set HomingSpeed(value:Number) : void
      {
         this.m_homingSpeed = value;
      }
      
      public function set DisableJump(value:Boolean) : void
      {
         this.m_disableJump = value;
      }
      
      public function set JumpCancelAttack(value:Boolean) : void
      {
         this.m_jumpCancelAttack = value;
      }
      
      public function set DoubleJumpCancelAttack(value:Boolean) : void
      {
         this.m_doubleJumpCancelAttack = value;
      }
      
      public function set AllowJump(value:Boolean) : void
      {
         this.m_allowJump = value;
      }
      
      public function set AllowFastFall(value:Boolean) : void
      {
         this.m_allowFastFall = value;
      }
      
      public function set AllowRun(value:Boolean) : void
      {
         this.m_allowRun = value;
      }
      
      public function set AllowTurn(value:Boolean) : void
      {
         this.m_allowTurn = value;
      }
      
      public function set AllowDoubleJump(value:Boolean) : void
      {
         this.m_allowDoubleJump = value;
      }
      
      public function set AllowFullInterrupt(value:Boolean) : void
      {
         this.m_allowFullInterrupt = value;
      }
      
      public function set LinkFrames(value:Boolean) : void
      {
         this.m_linkFrames = value;
      }
      
      public function set IsTurning(value:Boolean) : void
      {
         this.m_isTurning = value;
      }
      
      public function set IsAccelerating(value:Boolean) : void
      {
         this.m_isAccelerating = value;
      }
      
      public function set IsThrow(value:Boolean) : void
      {
         this.m_isThrow = value;
      }
      
      public function set ChargeInAir(value:Boolean) : void
      {
         this.m_chargeInAir = value;
      }
      
      public function set SizeStatus(value:int) : void
      {
         this.m_sizeStatus = value;
      }
      
      public function set FacedLedgesOnly(value:Boolean) : void
      {
         this.m_facedLedgesOnly = value;
      }
      
      public function set CanGrabInverseLedges(value:Boolean) : void
      {
         this.m_canGrabInverseLedges = value;
      }
      
      public function set AttackRatio(value:Number) : void
      {
         this.m_attackRatio = value;
      }
      
      public function set LedgeFrame(value:String) : void
      {
         this.m_ledgeFrame = value;
      }
      
      public function set IgnorePlatformInfluence(value:Boolean) : void
      {
         this.m_ignorePlatformInfluence = value;
      }
      
      public function set IASA(value:Boolean) : void
      {
         this.m_IASA = value;
      }
      
      public function set GrabBehind(value:Boolean) : void
      {
         this.m_grabBehind = value;
      }
      
      public function set ChargeRetain(value:Boolean) : void
      {
         this.m_charge_retain = value;
      }
      
      public function set IgnoreChargeKnockback(value:Boolean) : void
      {
         this.m_ignoreChargeKnockback = value;
      }
      
      public function set ResetMovement(value:Boolean) : void
      {
         this.m_resetMovement = value;
      }
      
      public function set CanFallOff(value:Boolean) : void
      {
         this.m_canFallOff = value;
      }
      
      public function set CanBeAbsorbed(value:Boolean) : void
      {
         this.m_canBeAbsorbed = value;
      }
      
      public function set MaintainSpeed(value:Boolean) : void
      {
         this.m_maintainSpeed = value;
      }
      
      public function set SecondaryAttack(value:String) : void
      {
         this.m_secondaryAttack = value;
      }
      
      public function set HasClanked(value:Boolean) : void
      {
         this.m_hasClanked = value;
      }
      
      public function importAttackStateData(data:Object) : void
      {
         var obj:* = undefined;
         for(obj in data)
         {
            if(this["m_" + obj] !== undefined)
            {
               this["m_" + obj] = data[obj];
            }
            else
            {
               trace("You tried to set \"m_" + obj + "\" but it doesn\'t exist in the AttackState class.");
            }
         }
      }
      
      public function getVar(varName:String) : *
      {
         if(this["m_" + varName] !== undefined)
         {
            return this["m_" + varName];
         }
         return null;
      }
   }
}

