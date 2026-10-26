package com.mcleodgaming.ssf2.engine
{
   public class ProjectileAttack extends InteractiveSpriteStats
   {
      
      protected var m_statsName:String;
      
      protected var m_inheritPalette:Boolean;
      
      protected var m_time_max:int;
      
      protected var m_xdecay:Number;
      
      protected var m_trailEffect:String;
      
      protected var m_trailEffectInterval:int;
      
      protected var m_trailEffectRotate:Boolean;
      
      protected var m_homingSpeed:Number;
      
      protected var m_homingEase:Number;
      
      protected var m_xspeed:Number;
      
      protected var m_yspeed:Number;
      
      protected var m_calcAngle:Boolean;
      
      protected var m_influenceXMovement:Number;
      
      protected var m_influenceYMovement:Number;
      
      protected var m_influenceXFactor:Number;
      
      protected var m_influenceYFactor:Number;
      
      protected var m_controlInitDirection:Boolean;
      
      protected var m_controlDirection:Number;
      
      protected var m_rocketSpeed:Number;
      
      protected var m_rocketDecay:Number;
      
      protected var m_rocketAngleAbsolute:Boolean;
      
      protected var m_rocketRotation:Boolean;
      
      protected var m_rotate:Boolean;
      
      protected var m_cancel:Boolean;
      
      protected var m_cancelSoundOnEnd:Boolean;
      
      protected var m_cancelVoiceOnEnd:Boolean;
      
      protected var m_maxgravity:Number;
      
      protected var m_rideGround:Boolean;
      
      protected var m_disableHurtSound:Boolean;
      
      protected var m_disableHurtFallOff:Boolean;
      
      protected var m_disableLastHitUpdate:Boolean;
      
      protected var m_stale:Boolean;
      
      protected var m_pushCharacters:Boolean;
      
      protected var m_bounce:Number;
      
      protected var m_bounce_decay:Number;
      
      protected var m_bounce_limit:int;
      
      protected var m_bounce_max_height:Number;
      
      protected var m_followUser:Boolean;
      
      protected var m_xoffset:Number;
      
      protected var m_yoffset:Number;
      
      protected var m_canBeReversed:Boolean;
      
      protected var m_canBeAbsorbed:Boolean;
      
      protected var m_canBePocketed:Boolean;
      
      protected var m_sticky:Boolean;
      
      protected var m_latch:Boolean;
      
      protected var m_latch_x_offset:Number;
      
      protected var m_latch_y_offset:Number;
      
      protected var m_suction:Boolean;
      
      protected var m_boomerang:Boolean;
      
      protected var m_limit:int;
      
      protected var m_limitOverwrite:Boolean;
      
      protected var m_linkAttackID:Boolean;
      
      protected var m_lockTrajectory:Boolean;
      
      protected var m_canFallOff:Boolean;
      
      protected var m_noFlip:Boolean;
      
      protected var m_lockSize:Boolean;
      
      protected var m_dangerous:Boolean;
      
      protected var m_suspend:Boolean;
      
      protected var m_sizeStatus:int;
      
      protected var m_attackData:AttackData;
      
      public function ProjectileAttack()
      {
         super();
         this.m_statsName = null;
         this.m_inheritPalette = false;
         this.m_time_max = 60;
         this.m_xdecay = 0;
         this.m_trailEffect = null;
         this.m_trailEffectInterval = 1;
         this.m_trailEffectRotate = false;
         this.m_homingSpeed = -1;
         this.m_homingEase = 1;
         this.m_xspeed = 0;
         this.m_yspeed = 0;
         this.m_calcAngle = false;
         this.m_influenceXMovement = -1;
         this.m_influenceYMovement = -1;
         this.m_influenceXFactor = 1;
         this.m_influenceYFactor = 1;
         this.m_controlInitDirection = false;
         this.m_controlDirection = -1;
         this.m_rocketSpeed = 0;
         this.m_rocketDecay = -1;
         this.m_rocketAngleAbsolute = true;
         this.m_rocketRotation = false;
         this.m_rotate = false;
         this.m_cancel = false;
         this.m_cancelSoundOnEnd = false;
         this.m_cancelVoiceOnEnd = false;
         this.m_maxgravity = 0;
         this.m_rideGround = true;
         this.m_disableHurtSound = false;
         this.m_disableHurtFallOff = false;
         this.m_disableLastHitUpdate = false;
         this.m_stale = true;
         this.m_pushCharacters = false;
         this.m_bounce = 0;
         this.m_bounce_decay = 1;
         this.m_bounce_limit = 0;
         this.m_bounce_max_height = -1;
         this.m_followUser = false;
         this.m_xoffset = 0;
         this.m_yoffset = 0;
         this.m_canBeReversed = true;
         this.m_canBeAbsorbed = true;
         this.m_canBePocketed = true;
         this.m_sticky = false;
         this.m_latch = false;
         this.m_latch_x_offset = 0;
         this.m_latch_y_offset = 0;
         this.m_suction = false;
         this.m_boomerang = false;
         this.m_limit = 10;
         this.m_limitOverwrite = true;
         this.m_linkAttackID = false;
         this.m_lockTrajectory = false;
         this.m_canFallOff = true;
         this.m_noFlip = false;
         this.m_lockSize = false;
         this.m_dangerous = true;
         this.m_suspend = false;
         this.m_sizeStatus = 0;
         m_canReceiveDamage = false;
         m_canReceiveKnockback = false;
         m_canReceiveHits = false;
         this.m_attackData = new AttackData(null,["attack_idle"]);
      }
      
      public function get StatsName() : String
      {
         return this.m_statsName;
      }
      
      public function set StatsName(value:String) : void
      {
         this.m_statsName = value;
      }
      
      public function get InheritPalette() : Boolean
      {
         return this.m_inheritPalette;
      }
      
      public function get TimeMax() : int
      {
         return this.m_time_max;
      }
      
      public function get XDecay() : Number
      {
         return this.m_xdecay;
      }
      
      public function set XDecay(value:Number) : void
      {
         this.m_xdecay = value;
      }
      
      public function get TrailEffect() : String
      {
         return this.m_trailEffect;
      }
      
      public function get TrailEffectInterval() : int
      {
         return this.m_trailEffectInterval;
      }
      
      public function get TrailEffectRotate() : Boolean
      {
         return this.m_trailEffectRotate;
      }
      
      public function get HomingSpeed() : Number
      {
         return this.m_homingSpeed;
      }
      
      public function set HomingSpeed(value:Number) : void
      {
         this.m_homingSpeed = value;
      }
      
      public function get HomingEase() : Number
      {
         return this.m_homingEase;
      }
      
      public function get XSpeed() : Number
      {
         return this.m_xspeed;
      }
      
      public function get YSpeed() : Number
      {
         return this.m_yspeed;
      }
      
      public function get MaxGravity() : Number
      {
         return this.m_maxgravity;
      }
      
      public function get RideGround() : Boolean
      {
         return this.m_rideGround;
      }
      
      public function get CalcAngle() : Boolean
      {
         return this.m_calcAngle;
      }
      
      public function get InfluenceXMovement() : Number
      {
         return this.m_influenceXMovement;
      }
      
      public function get InfluenceYMovement() : Number
      {
         return this.m_influenceYMovement;
      }
      
      public function get InfluenceXFactor() : Number
      {
         return this.m_influenceXFactor;
      }
      
      public function get InfluenceYFactor() : Number
      {
         return this.m_influenceYFactor;
      }
      
      public function get ControlInitDirection() : Boolean
      {
         return this.m_controlInitDirection;
      }
      
      public function get ControlDirection() : Number
      {
         return this.m_controlDirection;
      }
      
      public function get RocketSpeed() : Number
      {
         return this.m_rocketSpeed;
      }
      
      public function set RocketSpeed(value:Number) : void
      {
         this.m_rocketSpeed = value;
      }
      
      public function get RocketAngleAbsolute() : Boolean
      {
         return this.m_rocketAngleAbsolute;
      }
      
      public function get RocketDecay() : Number
      {
         return this.m_rocketDecay;
      }
      
      public function get RocketRotation() : Boolean
      {
         return this.m_rocketRotation;
      }
      
      public function get Rotate() : Boolean
      {
         return this.m_rotate;
      }
      
      public function get Cancel() : Boolean
      {
         return this.m_cancel;
      }
      
      public function get CancelSoundOnEnd() : Boolean
      {
         return this.m_cancelSoundOnEnd;
      }
      
      public function get CancelVoiceOnEnd() : Boolean
      {
         return this.m_cancelVoiceOnEnd;
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
      
      public function get Stale() : Boolean
      {
         return this.m_stale;
      }
      
      public function get PushCharacters() : Boolean
      {
         return this.m_pushCharacters;
      }
      
      public function get Bounce() : Number
      {
         return this.m_bounce;
      }
      
      public function set Bounce(value:Number) : void
      {
         this.m_bounce = value;
      }
      
      public function get BounceDecay() : Number
      {
         return this.m_bounce_decay;
      }
      
      public function get BounceLimit() : int
      {
         return this.m_bounce_limit;
      }
      
      public function get BounceMaxHeight() : Number
      {
         return this.m_bounce_max_height;
      }
      
      public function get FollowUser() : Boolean
      {
         return this.m_followUser;
      }
      
      public function get XOffset() : Number
      {
         return this.m_xoffset;
      }
      
      public function get YOffset() : Number
      {
         return this.m_yoffset;
      }
      
      public function get CanBeReversed() : Boolean
      {
         return this.m_canBeReversed;
      }
      
      public function set CanBeReversed(value:Boolean) : void
      {
         this.m_canBeReversed = value;
      }
      
      public function get CanBeAbsorbed() : Boolean
      {
         return this.m_canBeAbsorbed;
      }
      
      public function get CanBePocketed() : Boolean
      {
         return this.m_canBePocketed;
      }
      
      public function get Sticky() : Boolean
      {
         return this.m_sticky;
      }
      
      public function get Latch() : Boolean
      {
         return this.m_latch;
      }
      
      public function get LatchXOffset() : Number
      {
         return this.m_latch_x_offset;
      }
      
      public function get LatchYOffset() : Number
      {
         return this.m_latch_y_offset;
      }
      
      public function get Suction() : Boolean
      {
         return this.m_suction;
      }
      
      public function get Boomerang() : Boolean
      {
         return this.m_boomerang;
      }
      
      public function get Limit() : int
      {
         return this.m_limit;
      }
      
      public function get LimitOverwrite() : Boolean
      {
         return this.m_limitOverwrite;
      }
      
      public function get LinkAttackID() : Boolean
      {
         return this.m_linkAttackID;
      }
      
      public function get LockTrajectory() : Boolean
      {
         return this.m_lockTrajectory;
      }
      
      public function get CanFallOff() : Boolean
      {
         return this.m_canFallOff;
      }
      
      public function get NoFlip() : Boolean
      {
         return this.m_noFlip;
      }
      
      public function get LockSize() : Boolean
      {
         return this.m_lockSize;
      }
      
      public function get Dangerous() : Boolean
      {
         return this.m_dangerous;
      }
      
      public function get Suspend() : Boolean
      {
         return this.m_suspend;
      }
      
      public function get SizeStatus() : int
      {
         return this.m_sizeStatus;
      }
      
      public function get AttackDataObj() : AttackData
      {
         return this.m_attackData;
      }
      
      public function Clone() : ProjectileAttack
      {
         var obj:Object = this.exportData();
         var projectile:ProjectileAttack = new ProjectileAttack();
         projectile.importData(obj);
         return projectile;
      }
      
      override public function importData(data:Object) : Boolean
      {
         var obj:* = undefined;
         var flag:Boolean = true;
         for(obj in data)
         {
            if(this.m_attackData.getAttack(obj) != null)
            {
               this.m_attackData.getAttack(obj).importAttackData(data[obj]);
            }
            else if(this["m_" + obj] !== undefined)
            {
               this["m_" + obj] = data[obj];
            }
            else
            {
               flag = false;
               trace("You tried to set \"m_" + obj + "\" but it doesn\'t exist in the ProjectileAttack class. (" + data["linkage_id"] + ")");
            }
         }
         return flag;
      }
      
      public function importDataCopy(projectileAttack:ProjectileAttack) : Boolean
      {
         var key:* = undefined;
         var data:Object = null;
         var flag:Boolean = false;
         var obj:* = undefined;
         var otherAttackObj:AttackObject = null;
         var clonedAttackObj:AttackObject = null;
         for(key in projectileAttack.AttackDataObj.AttackArray)
         {
            otherAttackObj = projectileAttack.m_attackData.AttackArray[key];
            clonedAttackObj = this.m_attackData.getAttack(otherAttackObj.Name) != null ? this.m_attackData.getAttack(otherAttackObj.Name) : new AttackObject(otherAttackObj.Name);
            clonedAttackObj.importAttackData(otherAttackObj.exportAttackData());
            this.m_attackData.setAttack(clonedAttackObj.Name,clonedAttackObj);
         }
         data = projectileAttack.exportData();
         flag = true;
         for(obj in data)
         {
            if(this.m_attackData.getAttack(obj) != null)
            {
               this.m_attackData.getAttack(obj).importAttackData(data[obj]);
            }
            else if(this["m_" + obj] !== undefined)
            {
               this["m_" + obj] = data[obj];
            }
         }
         return flag;
      }
      
      override public function exportData() : Object
      {
         var i:* = undefined;
         var j:* = undefined;
         var data:Object = super.exportData();
         var projectile:Object = new Object();
         projectile.statsName = this.m_statsName;
         projectile.inheritPalette = this.m_inheritPalette;
         projectile.time_max = this.m_time_max;
         projectile.xdecay = this.m_xdecay;
         projectile.trailEffect = this.m_trailEffect;
         projectile.trailEffectInterval = this.m_trailEffectInterval;
         projectile.trailEffectRotate = this.m_trailEffectRotate;
         projectile.homingSpeed = this.m_homingSpeed;
         projectile.homingEase = this.m_homingEase;
         projectile.xspeed = this.m_xspeed;
         projectile.yspeed = this.m_yspeed;
         projectile.calcAngle = this.m_calcAngle;
         projectile.influenceXMovement = this.m_influenceXMovement;
         projectile.influenceYMovement = this.m_influenceYMovement;
         projectile.influenceXFactor = this.m_influenceXFactor;
         projectile.influenceYFactor = this.m_influenceYFactor;
         projectile.controlInitDirection = this.m_controlInitDirection;
         projectile.controlDirection = this.m_controlDirection;
         projectile.rocketSpeed = this.m_rocketSpeed;
         projectile.rocketDecay = this.m_rocketDecay;
         projectile.rocketAngleAbsolute = this.m_rocketAngleAbsolute;
         projectile.rocketRotation = this.m_rocketRotation;
         projectile.rotate = this.m_rotate;
         projectile.cancel = this.m_cancel;
         projectile.cancelSoundOnEnd = this.m_cancelSoundOnEnd;
         projectile.cancelVoiceOnEnd = this.m_cancelVoiceOnEnd;
         projectile.maxgravity = this.m_maxgravity;
         projectile.rideGround = this.m_rideGround;
         projectile.disableHurtSound = this.m_disableHurtSound;
         projectile.disableHurtFallOff = this.m_disableHurtFallOff;
         projectile.disableLastHitUpdate = this.m_disableLastHitUpdate;
         projectile.pushCharacters = this.m_pushCharacters;
         projectile.bounce = this.m_bounce;
         projectile.bounce_decay = this.m_bounce_decay;
         projectile.bounce_limit = this.m_bounce_limit;
         projectile.bounce_max_height = this.m_bounce_max_height;
         projectile.followUser = this.m_followUser;
         projectile.xoffset = this.m_xoffset;
         projectile.yoffset = this.m_yoffset;
         projectile.canBeReversed = this.m_canBeReversed;
         projectile.canBeAbsorbed = this.m_canBeAbsorbed;
         projectile.canBePocketed = this.m_canBePocketed;
         projectile.sticky = this.m_sticky;
         projectile.latch = this.m_latch;
         projectile.latch_x_offset = this.m_latch_x_offset;
         projectile.latch_y_offset = this.m_latch_y_offset;
         projectile.suction = this.m_suction;
         projectile.boomerang = this.m_boomerang;
         projectile.limit = this.m_limit;
         projectile.limitOverwrite = this.m_limitOverwrite;
         projectile.linkAttackID = this.m_linkAttackID;
         projectile.lockTrajectory = this.m_lockTrajectory;
         projectile.canFallOff = this.m_canFallOff;
         projectile.noFlip = this.m_noFlip;
         projectile.lockSize = this.m_lockSize;
         projectile.dangerous = this.m_dangerous;
         projectile.suspend = this.m_suspend;
         projectile.sizeStatus = this.m_sizeStatus;
         for(i in this.m_attackData.AttackArray)
         {
            projectile[i] = this.m_attackData.AttackArray[i].exportAttackData();
         }
         for(j in data)
         {
            if(!(j in projectile))
            {
               projectile[j] = data[j];
            }
         }
         return projectile;
      }
      
      public function exportAttackStateData() : Object
      {
         var attack:Object = new Object();
         attack.cancelSoundOnEnd = this.m_cancelSoundOnEnd;
         attack.cancelVoiceOnEnd = this.m_cancelVoiceOnEnd;
         attack.sizeStatus = this.m_sizeStatus;
         attack.disableHurtSound = this.m_disableHurtSound;
         attack.disableHurtFallOff = this.m_disableHurtFallOff;
         attack.disableLastHitUpdate = this.m_disableLastHitUpdate;
         return attack;
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

