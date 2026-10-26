package com.mcleodgaming.ssf2.engine
{
   import com.mcleodgaming.ssf2.Main;
   import com.mcleodgaming.ssf2.controllers.MenuController;
   
   public class CharacterData extends InteractiveSpriteStats
   {
      
      protected var m_player_id:int;
      
      protected var m_shieldType:String;
      
      protected var m_statsName:String;
      
      protected var m_displayName:String;
      
      protected var m_linkage_id2:String;
      
      protected var m_linkage_id_special:String;
      
      protected var m_thumbnail:String;
      
      protected var m_seriesIcon:String;
      
      protected var m_cam_width:Number;
      
      protected var m_cam_height:Number;
      
      protected var m_cam_x_offset:Number;
      
      protected var m_cam_y_offset:Number;
      
      protected var m_deathSwitchID:String;
      
      protected var m_revivalEffect:String;
      
      protected var m_jumpSpeed:Number;
      
      protected var m_jumpSpeedMidair:Number;
      
      protected var m_jumpSpeedList:String;
      
      protected var m_shortHopSpeed:Number;
      
      protected var m_jumpStartup:int;
      
      protected var m_max_jumpSpeed:Number;
      
      protected var m_midAirTurn:Boolean;
      
      protected var m_midAirHover:int;
      
      protected var m_midAirJumpConstant:int;
      
      protected var m_midAirJumpConstantDelay:int;
      
      protected var m_midAirJumpConstantAccel:Number;
      
      protected var m_wallJump:Boolean;
      
      protected var m_wallStick:int;
      
      protected var m_airDodgeSpeed:Number;
      
      protected var m_tiltTossMultiplier:Number;
      
      protected var m_smashTossMultiplier:Number;
      
      protected var m_dodgeSpeed:Number;
      
      protected var m_dodgeStartup:int;
      
      protected var m_dodgeDecel:Number;
      
      protected var m_power:String;
      
      protected var m_norm_xSpeed:Number;
      
      protected var m_max_xSpeed:Number;
      
      protected var m_fastFallSpeed:Number;
      
      protected var m_accel_start:Number;
      
      protected var m_accel_start_dash:Number;
      
      protected var m_accel_rate:Number;
      
      protected var m_accel_rate_air:Number;
      
      protected var m_decel_rate:Number;
      
      protected var m_decel_rate_air:Number;
      
      protected var m_glideSpeed:Number;
      
      protected var m_holdJump:Boolean;
      
      protected var m_max_jump:int;
      
      protected var m_tetherGrab:Boolean;
      
      protected var m_roll_speed:Number;
      
      protected var m_roll_decay:Number;
      
      protected var m_roll_decay_ice:Number;
      
      protected var m_roll_delay:int;
      
      protected var m_getup_roll_delay:int;
      
      protected var m_tech_roll_delay:int;
      
      protected var m_climb_roll_delay:int;
      
      protected var m_itemScaleRatio:Number;
      
      protected var m_shieldBreakPower:Number;
      
      protected var m_shieldBreakKBConstant:Number;
      
      protected var m_shieldBreakWeightKB:Number;
      
      protected var m_shield_x_offset:Number;
      
      protected var m_shield_y_offset:Number;
      
      protected var m_shield_scale:Number;
      
      protected var m_special_type:int;
      
      protected var m_normalStats_id:String;
      
      protected var m_alternateStats_id:String;
      
      protected var m_specialStats_id:String;
      
      protected var m_sounds:Array;
      
      protected var m_hurtFrames:int;
      
      protected var m_attacks:AttackData;
      
      protected var m_canThrow:Boolean;
      
      protected var m_canBeGrabbed:Boolean;
      
      protected var m_canHoldItems:Boolean;
      
      protected var m_canUseItems:Boolean;
      
      protected var m_canShield:Boolean;
      
      protected var m_canDodge:Boolean;
      
      protected var m_canTaunt:Boolean;
      
      protected var m_canBarrel:Boolean;
      
      protected var m_canGrabLedges:Boolean;
      
      protected var m_canUseSpecials:Boolean;
      
      protected var m_canStarKO:Boolean;
      
      protected var m_grabDamage:int;
      
      protected var m_damageIncrease:Number;
      
      protected var m_damageIncreaseInterval:int;
      
      protected var m_heavyArmor:Number;
      
      protected var m_windArmor:Number;
      
      protected var m_launchResistance:Number;
      
      protected var m_customShield:Boolean;
      
      protected var m_customShieldStartup:int;
      
      protected var m_crouchWalkSpeed:Number;
      
      protected var m_volume_sfx:Number;
      
      protected var m_volume_vfx:Number;
      
      protected var m_forceTransformTime:int;
      
      protected var m_forceTransformID:String;
      
      protected var m_fs_time_limit:int;
      
      protected var m_fs_magnet:Boolean;
      
      protected var m_minShieldSize:Number;
      
      protected var m_maxShieldSize:Number;
      
      protected var m_statusEffectImmunity:Boolean;
      
      protected var m_groundToAirMultiplier:Number;
      
      protected var m_finalSmashCutin:String;
      
      public var m_damageRatio:Number;
      
      public var m_attackRatio:Number;
      
      public var m_unlimitedFinal:Boolean;
      
      public var m_finalSmashMeter:Boolean;
      
      public var m_startDamage:int;
      
      public function CharacterData()
      {
         super();
         this.m_player_id = -1;
         this.m_shieldType = "shield-1";
         this.m_statsName = null;
         this.m_displayName = null;
         this.m_linkage_id2 = null;
         this.m_linkage_id_special = null;
         this.m_thumbnail = null;
         this.m_seriesIcon = null;
         this.m_cam_width = 150;
         this.m_cam_height = 150;
         this.m_cam_x_offset = 25;
         this.m_cam_y_offset = 50;
         this.m_deathSwitchID = null;
         this.m_revivalEffect = null;
         this.m_jumpSpeed = 0;
         this.m_jumpSpeedMidair = 0;
         this.m_jumpSpeedList = null;
         this.m_shortHopSpeed = 0;
         this.m_jumpStartup = 0;
         this.m_max_jumpSpeed = 0;
         this.m_midAirTurn = false;
         this.m_midAirHover = 0;
         this.m_midAirJumpConstant = 0;
         this.m_midAirJumpConstantDelay = 0;
         this.m_midAirJumpConstantAccel = 0;
         this.m_wallJump = false;
         this.m_wallStick = 0;
         this.m_airDodgeSpeed = 6.5;
         this.m_tiltTossMultiplier = 1;
         this.m_smashTossMultiplier = 1.2;
         this.m_dodgeSpeed = 7;
         this.m_dodgeStartup = 0;
         this.m_dodgeDecel = 0;
         this.m_power = null;
         this.m_norm_xSpeed = 0;
         this.m_max_xSpeed = 0;
         this.m_fastFallSpeed = 0;
         this.m_accel_start = 0;
         this.m_accel_start_dash = -1;
         this.m_accel_rate = 0;
         this.m_accel_rate_air = 0.7;
         this.m_decel_rate = 0;
         this.m_decel_rate_air = -0.15;
         this.m_glideSpeed = 0;
         this.m_holdJump = false;
         this.m_max_jump = 1;
         this.m_tetherGrab = false;
         this.m_roll_speed = 0;
         this.m_roll_decay = 0.65;
         this.m_roll_decay_ice = 0.93;
         this.m_getup_roll_delay = 0;
         this.m_tech_roll_delay = 0;
         this.m_climb_roll_delay = 0;
         this.m_itemScaleRatio = 0;
         this.m_shieldBreakPower = 14;
         this.m_shieldBreakKBConstant = 100;
         this.m_shieldBreakWeightKB = 40;
         this.m_shield_x_offset = 0;
         this.m_shield_y_offset = 0;
         this.m_shield_scale = 1;
         this.m_special_type = 0;
         this.m_normalStats_id = null;
         this.m_alternateStats_id = null;
         this.m_specialStats_id = null;
         this.m_sounds = new Array();
         this.m_hurtFrames = 1;
         this.m_attacks = new AttackData(null,["a","a_up","a_up_tilt","a_forward","a_forward_tilt","a_forwardsmash","a_down","a_air","a_air_up","a_air_forward","a_air_backward","a_air_down","b","b_air","b_up","b_up_air","b_forward","b_forward_air","b_down","b_down_air","throw_up","throw_forward","throw_back","throw_down","crouch_attack","ledge_attack","getup_attack","kirby","kirby_air","star","item","special"]);
         this.m_canDodge = true;
         this.m_canHoldItems = true;
         this.m_canShield = true;
         this.m_canThrow = true;
         this.m_canBeGrabbed = true;
         this.m_canUseItems = true;
         this.m_canTaunt = true;
         this.m_canBarrel = true;
         this.m_canGrabLedges = true;
         this.m_canUseSpecials = true;
         this.m_canStarKO = true;
         this.m_grabDamage = 0;
         this.m_damageIncrease = 0;
         this.m_damageIncreaseInterval = 30;
         this.m_heavyArmor = 0;
         this.m_windArmor = 0;
         this.m_launchResistance = 0;
         this.m_customShield = false;
         this.m_customShieldStartup = 0;
         this.m_crouchWalkSpeed = 0;
         this.m_volume_sfx = 1;
         this.m_volume_vfx = 1;
         this.m_forceTransformTime = 0;
         this.m_forceTransformID = null;
         this.m_fs_time_limit = 0;
         this.m_fs_magnet = false;
         this.m_minShieldSize = 0.5;
         this.m_maxShieldSize = 1.4;
         this.m_statusEffectImmunity = false;
         this.m_groundToAirMultiplier = 1;
         this.m_finalSmashCutin = null;
         this.m_attackRatio = 1;
         this.m_damageRatio = 1;
         this.m_unlimitedFinal = false;
         this.m_finalSmashMeter = false;
         this.m_startDamage = 0;
      }
      
      public function get PlayerID() : int
      {
         return this.m_player_id;
      }
      
      public function get ShieldType() : String
      {
         return this.m_shieldType;
      }
      
      public function get StatsName() : String
      {
         return this.m_statsName;
      }
      
      public function get DisplayName() : String
      {
         if(this.m_displayName == null)
         {
            return "";
         }
         return this.m_displayName;
      }
      
      public function get LinkageID2() : String
      {
         return this.m_linkage_id2;
      }
      
      public function get LinkageIDSpecial() : String
      {
         return this.m_linkage_id_special;
      }
      
      public function get Thumbnail() : String
      {
         return this.m_thumbnail;
      }
      
      public function get SeriesIcon() : String
      {
         return this.m_seriesIcon;
      }
      
      public function get CamWidth() : Number
      {
         return this.m_cam_width;
      }
      
      public function get CamHeight() : Number
      {
         return this.m_cam_height;
      }
      
      public function get CamXOffset() : Number
      {
         return this.m_cam_x_offset;
      }
      
      public function get CamYOffset() : Number
      {
         return this.m_cam_y_offset;
      }
      
      public function get DeathSwitchID() : String
      {
         return this.m_deathSwitchID;
      }
      
      public function get RevivalEffect() : String
      {
         return this.m_revivalEffect;
      }
      
      public function get JumpSpeed() : Number
      {
         return this.m_jumpSpeed;
      }
      
      public function get JumpSpeedMidAir() : Number
      {
         return this.m_jumpSpeedMidair;
      }
      
      public function get JumpSpeedList() : String
      {
         return this.m_jumpSpeedList;
      }
      
      public function get ShortHopSpeed() : Number
      {
         return this.m_shortHopSpeed;
      }
      
      public function get JumpStartup() : int
      {
         return this.m_jumpStartup;
      }
      
      public function get MaxJumpSpeed() : Number
      {
         return this.m_max_jumpSpeed;
      }
      
      public function set MaxJumpSpeed(value:Number) : void
      {
         this.m_max_jumpSpeed = value;
      }
      
      public function get MidAirTurn() : Boolean
      {
         return this.m_midAirTurn;
      }
      
      public function get MidAirHover() : int
      {
         return this.m_midAirHover;
      }
      
      public function get MidAirJumpConstant() : int
      {
         return this.m_midAirJumpConstant;
      }
      
      public function get MidAirJumpConstantDelay() : int
      {
         return this.m_midAirJumpConstantDelay;
      }
      
      public function get MidAirJumpConstantAccel() : Number
      {
         return this.m_midAirJumpConstantAccel;
      }
      
      public function get WallJump() : Boolean
      {
         return this.m_wallJump;
      }
      
      public function get WallStick() : int
      {
         return this.m_wallStick;
      }
      
      public function get AirDodgeSpeed() : int
      {
         return this.m_airDodgeSpeed;
      }
      
      public function get DodgeSpeed() : Number
      {
         return this.m_dodgeSpeed;
      }
      
      public function get DodgeStartup() : int
      {
         return this.m_dodgeStartup;
      }
      
      public function get DodgeDecel() : Number
      {
         return this.m_dodgeDecel;
      }
      
      public function get TiltTossMultiplier() : Number
      {
         return this.m_tiltTossMultiplier;
      }
      
      public function get SmashTossMultiplier() : Number
      {
         return this.m_smashTossMultiplier;
      }
      
      public function get Power() : String
      {
         return this.m_power;
      }
      
      public function set Power(value:String) : void
      {
         this.m_power = value;
      }
      
      public function get NormalXSpeed() : Number
      {
         return this.m_norm_xSpeed;
      }
      
      public function get MaxXSpeed() : Number
      {
         return this.m_max_xSpeed;
      }
      
      public function get FastFallSpeed() : Number
      {
         return this.m_fastFallSpeed;
      }
      
      public function get AccelStart() : Number
      {
         return this.m_accel_start;
      }
      
      public function get AccelStartDash() : Number
      {
         return this.m_accel_start_dash;
      }
      
      public function get AccelRate() : Number
      {
         return this.m_accel_rate;
      }
      
      public function get AccelRateAir() : Number
      {
         return this.m_accel_rate_air;
      }
      
      public function get DecelRate() : Number
      {
         return this.m_decel_rate;
      }
      
      public function get DecelRateAir() : Number
      {
         return this.m_decel_rate_air;
      }
      
      public function get GlideSpeed() : Number
      {
         return this.m_glideSpeed;
      }
      
      public function get HoldJump() : Boolean
      {
         return this.m_holdJump;
      }
      
      public function get MaxJump() : int
      {
         return this.m_max_jump;
      }
      
      public function set MaxJump(value:int) : void
      {
         this.m_max_jump = value;
      }
      
      public function get TetherGrab() : Boolean
      {
         return this.m_tetherGrab;
      }
      
      public function get RollSpeed() : Number
      {
         return this.m_roll_speed;
      }
      
      public function get RollDecay() : Number
      {
         return this.m_roll_decay;
      }
      
      public function get RollDecayIce() : Number
      {
         return this.m_roll_decay_ice;
      }
      
      public function get GetupRollDelay() : int
      {
         return this.m_getup_roll_delay;
      }
      
      public function get TechRollDelay() : int
      {
         return this.m_tech_roll_delay;
      }
      
      public function get ClimbRollDelay() : int
      {
         return this.m_climb_roll_delay;
      }
      
      public function get ItemScaleRatio() : Number
      {
         return this.m_itemScaleRatio;
      }
      
      public function get ShieldBreakPower() : Number
      {
         return this.m_shieldBreakPower;
      }
      
      public function get ShieldBreakKBConstant() : Number
      {
         return this.m_shieldBreakKBConstant;
      }
      
      public function get ShieldBreakWeightKB() : Number
      {
         return this.m_shieldBreakWeightKB;
      }
      
      public function get ShieldXOffset() : Number
      {
         return this.m_shield_x_offset;
      }
      
      public function get ShieldYOffset() : Number
      {
         return this.m_shield_y_offset;
      }
      
      public function get ShieldScale() : Number
      {
         return this.m_shield_scale;
      }
      
      public function get SpecialType() : int
      {
         return this.m_special_type;
      }
      
      public function get NormalStatsID() : String
      {
         return this.m_normalStats_id;
      }
      
      public function get AlternateStatsID() : String
      {
         return this.m_alternateStats_id;
      }
      
      public function get SpecialStatsID() : String
      {
         return this.m_specialStats_id;
      }
      
      public function get Sounds() : Array
      {
         return this.m_sounds;
      }
      
      public function set Sounds(value:Array) : void
      {
         this.m_sounds = value;
      }
      
      public function get HurtFrames() : int
      {
         return this.m_hurtFrames;
      }
      
      public function get Attacks() : AttackData
      {
         return this.m_attacks;
      }
      
      public function get CanDodge() : Boolean
      {
         return this.m_canDodge;
      }
      
      public function get CanHoldItems() : Boolean
      {
         return this.m_canHoldItems;
      }
      
      public function get CanThrow() : Boolean
      {
         return this.m_canThrow;
      }
      
      public function get CanBeGrabbed() : Boolean
      {
         return this.m_canBeGrabbed;
      }
      
      public function get CanShield() : Boolean
      {
         return this.m_canShield;
      }
      
      public function get CanUseItems() : Boolean
      {
         return this.m_canUseItems;
      }
      
      public function get CanTaunt() : Boolean
      {
         return this.m_canTaunt;
      }
      
      public function get CanBarrel() : Boolean
      {
         return this.m_canBarrel;
      }
      
      public function get CanGrabLedges() : Boolean
      {
         return this.m_canGrabLedges;
      }
      
      public function get CanUseSpecials() : Boolean
      {
         return this.m_canUseSpecials;
      }
      
      public function get CanStarKO() : Boolean
      {
         return this.m_canStarKO;
      }
      
      public function get GrabDamage() : int
      {
         return this.m_grabDamage;
      }
      
      public function get DamageIncrease() : Number
      {
         return this.m_damageIncrease;
      }
      
      public function get DamageIncreaseInterval() : int
      {
         return this.m_damageIncreaseInterval;
      }
      
      public function get HeavyArmor() : Number
      {
         return this.m_heavyArmor;
      }
      
      public function get WindArmor() : Number
      {
         return this.m_windArmor;
      }
      
      public function get LaunchResistance() : Number
      {
         return this.m_launchResistance;
      }
      
      public function get CustomShield() : Boolean
      {
         return this.m_customShield;
      }
      
      public function get CustomShieldStartup() : int
      {
         return this.m_customShieldStartup;
      }
      
      public function get CrouchWalkSpeed() : Number
      {
         return this.m_crouchWalkSpeed;
      }
      
      public function get VolumeSFX() : Number
      {
         return this.m_volume_sfx;
      }
      
      public function get VolumeVFX() : Number
      {
         return this.m_volume_vfx;
      }
      
      public function get ForceTransformTime() : int
      {
         return this.m_forceTransformTime;
      }
      
      public function get ForceTransformID() : String
      {
         return this.m_forceTransformID;
      }
      
      public function get FSTimer() : int
      {
         return this.m_fs_time_limit;
      }
      
      public function get FSMagnet() : Boolean
      {
         return this.m_fs_magnet;
      }
      
      public function get MinShieldSize() : Number
      {
         return this.m_minShieldSize;
      }
      
      public function get MaxShieldSize() : Number
      {
         return this.m_maxShieldSize;
      }
      
      public function get StatusEffectImmunity() : Boolean
      {
         return this.m_statusEffectImmunity;
      }
      
      public function get GroundToAirMultiplier() : Number
      {
         return this.m_groundToAirMultiplier;
      }
      
      public function get FinalSmashCutin() : String
      {
         return this.m_finalSmashCutin;
      }
      
      public function get DamageRatio() : Number
      {
         return this.m_damageRatio;
      }
      
      public function get AttackRatio() : Number
      {
         return this.m_attackRatio;
      }
      
      public function get UnlimitedFinal() : Boolean
      {
         return this.m_unlimitedFinal;
      }
      
      public function get FinalSmashMeter() : Boolean
      {
         return this.m_finalSmashMeter;
      }
      
      public function get StartDamage() : Number
      {
         return this.m_startDamage;
      }
      
      override public function importData(data:Object) : Boolean
      {
         var obj:* = undefined;
         var s:* = undefined;
         var flag:Boolean = true;
         var oldSeriesIcon:String = this.m_seriesIcon;
         if(data != null)
         {
            if(Main.DEBUG && "roll_delay" in data)
            {
               MenuController.debugConsole.alert("Warning: roll_delay field is deprecated and should be removed in character \'" + (data.statsName || this.m_statsName) + "\'");
            }
            for(obj in data)
            {
               if(this["m_" + obj] !== undefined)
               {
                  if(obj == "sounds")
                  {
                     for(s in data[obj])
                     {
                        this.m_sounds[s] = data[obj][s];
                     }
                  }
                  else
                  {
                     this["m_" + obj] = data[obj];
                  }
               }
               else
               {
                  flag = false;
                  trace("You tried to set \"m_" + obj + "\" but it doesn\'t exist in the CharacterData class.");
               }
            }
            if(this.m_volume_sfx > 1)
            {
               this.m_volume_sfx = 1;
            }
            else if(this.m_volume_sfx < 0)
            {
               this.m_volume_sfx = 0;
            }
            if(this.m_volume_vfx > 1)
            {
               this.m_volume_vfx = 1;
            }
            else if(this.m_volume_vfx < 0)
            {
               this.m_volume_vfx = 0;
            }
         }
         if(Boolean(oldSeriesIcon))
         {
            this.m_seriesIcon = oldSeriesIcon;
         }
         return flag;
      }
      
      public function importAttacks(attacks:Object) : void
      {
         if(attacks != null)
         {
            this.m_attacks.importAttacks(attacks);
         }
      }
      
      public function addProjectiles(projectiles:Object) : void
      {
         var obj:* = undefined;
         var i:ProjectileAttack = null;
         if(projectiles != null)
         {
            for(obj in projectiles)
            {
               i = new ProjectileAttack();
               i.importData(projectiles[obj]);
               this.m_attacks.addProjectile(obj,i);
            }
         }
      }
      
      public function addItems(items:Object) : void
      {
         var obj:* = undefined;
         var i:ItemData = null;
         if(items != null)
         {
            for(obj in items)
            {
               i = new ItemData();
               i.importData(items[obj]);
               this.m_attacks.addItem(obj,i);
            }
         }
      }
      
      override public function exportData() : Object
      {
         var j:* = undefined;
         var data:Object = super.exportData();
         var character:Object = new Object();
         var i:int = 0;
         var obj:* = null;
         character.classAPI = m_classAPI;
         character.statsName = this.m_statsName;
         character.displayName = this.m_displayName;
         character.linkage_id = m_linkage_id;
         character.linkage_id2 = this.m_linkage_id2;
         character.linkage_id_special = this.m_linkage_id_special;
         character.thumbnail = this.m_thumbnail;
         character.seriesIcon = this.m_seriesIcon;
         character.width = m_width;
         character.height = m_height;
         character.cam_width = this.m_cam_width;
         character.cam_height = this.m_cam_height;
         character.cam_x_offset = this.m_cam_x_offset;
         character.cam_y_offset = this.m_cam_y_offset;
         character.deathSwitchID = this.m_deathSwitchID;
         character.revivalEffect = this.m_revivalEffect;
         character.jumpSpeed = this.m_jumpSpeed;
         character.jumpSpeedMidair = this.m_jumpSpeedMidair;
         character.jumpSpeedList = this.m_jumpSpeedList;
         character.shortHopSpeed = this.m_shortHopSpeed;
         character.jumpStartup = this.m_jumpStartup;
         character.max_jumpSpeed = this.m_max_jumpSpeed;
         character.midAirTurn = this.m_midAirTurn;
         character.midAirHover = this.m_midAirHover;
         character.midAirJumpConstant = this.m_midAirJumpConstant;
         character.midAirJumpConstantDelay = this.m_midAirJumpConstantDelay;
         character.midAirJumpConstantAccel = this.m_midAirJumpConstantAccel;
         character.wallJump = this.m_wallJump;
         character.wallStick = this.m_wallStick;
         character.airDodgeSpeed = this.m_airDodgeSpeed;
         character.dodgeSpeed = this.m_dodgeSpeed;
         character.dodgeStartup = this.m_dodgeStartup;
         character.dodgeDecel = this.m_dodgeDecel;
         character.tiltTossMultiplier = this.m_tiltTossMultiplier;
         character.smashTossMultiplier = this.m_smashTossMultiplier;
         character.gravity = m_gravity;
         character.weight1 = m_weight1;
         character.power = this.m_power;
         character.norm_xSpeed = this.m_norm_xSpeed;
         character.max_xSpeed = this.m_max_xSpeed;
         character.max_ySpeed = m_max_ySpeed;
         character.fastFallSpeed = this.m_fastFallSpeed;
         character.accel_start = this.m_accel_start;
         character.accel_start_dash = this.m_accel_start_dash;
         character.accel_rate = this.m_accel_rate;
         character.accel_rate_air = this.m_accel_rate_air;
         character.decel_rate = this.m_decel_rate;
         character.decel_rate_air = this.m_decel_rate_air;
         character.glideSpeed = this.m_glideSpeed;
         character.holdJump = this.m_holdJump;
         character.max_jump = this.m_max_jump;
         character.max_projectile = m_max_projectile;
         character.tetherGrab = this.m_tetherGrab;
         character.roll_speed = this.m_roll_speed;
         character.roll_decay = this.m_roll_decay;
         character.roll_decay_ice = this.m_roll_decay_ice;
         character.getup_roll_delay = this.m_getup_roll_delay;
         character.tech_roll_delay = this.m_tech_roll_delay;
         character.climb_roll_delay = this.m_climb_roll_delay;
         character.itemScaleRatio = this.m_itemScaleRatio;
         character.shieldBreakPower = this.m_shieldBreakPower;
         character.shieldBreakKBConstant = this.m_shieldBreakKBConstant;
         character.shieldBreakWeightKB = this.m_shieldBreakWeightKB;
         character.shield_x_offset = this.m_shield_x_offset;
         character.shield_y_offset = this.m_shield_y_offset;
         character.shield_scale = this.m_shield_scale;
         character.special_type = this.m_special_type;
         character.normalStats_id = this.m_normalStats_id;
         character.alternateStats_id = this.m_alternateStats_id;
         character.specialStats_id = this.m_specialStats_id;
         character.sounds = new Array();
         for(obj in this.m_sounds)
         {
            character.sounds[obj] = this.m_sounds[obj];
         }
         character.hurtFrames = this.m_hurtFrames;
         character.canDodge = this.m_canDodge;
         character.canHoldItems = this.m_canHoldItems;
         character.canShield = this.m_canShield;
         character.canThrow = this.m_canThrow;
         character.canBeGrabbed = this.m_canBeGrabbed;
         character.canUseItems = this.m_canUseItems;
         character.canTaunt = this.m_canTaunt;
         character.canBarrel = this.m_canBarrel;
         character.canGrabLedges = this.m_canGrabLedges;
         character.canUseSpecials = this.m_canUseSpecials;
         character.canStarKO = this.m_canStarKO;
         character.canReceiveKnockback = m_canReceiveKnockback;
         character.canReceiveDamage = m_canReceiveDamage;
         character.grabDamage = this.m_grabDamage;
         character.damageIncrease = this.m_damageIncrease;
         character.damageIncreaseInterval = this.m_damageIncreaseInterval;
         character.heavyArmor = this.m_heavyArmor;
         character.windArmor = this.m_windArmor;
         character.launchResistance = this.m_launchResistance;
         character.customShield = this.m_customShield;
         character.customShieldStartup = this.m_customShieldStartup;
         character.crouchWalkSpeed = this.m_crouchWalkSpeed;
         character.volume_sfx = this.m_volume_sfx;
         character.volume_vfx = this.m_volume_vfx;
         character.forceTransformTime = this.m_forceTransformTime;
         character.forceTransformID = this.m_forceTransformID;
         character.fs_time_limit = this.m_fs_time_limit;
         character.fs_magnet = this.m_fs_magnet;
         character.minShieldSize = this.m_minShieldSize;
         character.maxShieldSize = this.m_maxShieldSize;
         character.statusEffectImmunity = this.m_statusEffectImmunity;
         character.groundToAirMultiplier = this.m_groundToAirMultiplier;
         character.finalSmashCutin = this.m_finalSmashCutin;
         for(j in data)
         {
            if(!(j in character))
            {
               character[j] = data[j];
            }
         }
         character.attackRatio = this.m_attackRatio;
         character.damageRatio = this.m_damageRatio;
         character.unlimitedFinal = this.m_unlimitedFinal;
         character.finalSmashMeter = this.m_finalSmashMeter;
         character.startDamage = this.m_startDamage;
         return character;
      }
      
      override public function getVar(varName:String) : *
      {
         if(this["m_" + varName] !== undefined)
         {
            return this["m_" + varName];
         }
         return null;
      }
   }
}

