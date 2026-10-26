package com.mcleodgaming.ssf2.engine
{
   public class ItemData extends InteractiveSpriteStats
   {
      
      protected var m_statsName:String;
      
      protected var m_type:String;
      
      protected var m_class_id:String;
      
      protected var m_inheritPalette:Boolean;
      
      protected var m_displayName:String;
      
      protected var m_retainPlayerID:Boolean;
      
      protected var m_disableFlip:Boolean;
      
      protected var m_sizeRatio:Number;
      
      protected var m_canBeReversed:Boolean;
      
      protected var m_canPickup:Boolean;
      
      protected var m_canToss:Boolean;
      
      protected var m_canBackToss:Boolean;
      
      protected var m_canJumpWith:Boolean;
      
      protected var m_canAttackWith:Boolean;
      
      protected var m_canHangWith:Boolean;
      
      protected var m_canShieldWith:Boolean;
      
      protected var m_canRunWith:Boolean;
      
      protected var m_canBePushed:Boolean;
      
      protected var m_pushCharacters:Boolean;
      
      protected var m_time_max:int;
      
      protected var m_max_gravity:Number;
      
      protected var m_effectSound:String;
      
      protected var m_landSound:String;
      
      protected var m_spawnEffect:String;
      
      protected var m_deathEffect:String;
      
      protected var m_bounce:Number;
      
      protected var m_bounce_decay:Number;
      
      protected var m_bounce_limit:int;
      
      protected var m_bounce_max_height:Number;
      
      protected var m_initialBounce:Boolean;
      
      protected var m_slideDecay:Number;
      
      protected var m_dangerous:Boolean;
      
      protected var m_redirects:Array;
      
      protected var m_tossSpeed:Number;
      
      protected var m_rotate:Boolean;
      
      protected var m_spawnLimit:int;
      
      protected var m_attackData:AttackData;
      
      protected var m_projectiles:Object;
      
      public function ItemData()
      {
         super();
         this.m_statsName = null;
         this.m_type = "carryable";
         this.m_class_id = null;
         this.m_inheritPalette = false;
         this.m_displayName = null;
         this.m_retainPlayerID = false;
         this.m_disableFlip = false;
         this.m_sizeRatio = 1;
         this.m_canBeReversed = true;
         this.m_canPickup = false;
         this.m_canToss = true;
         this.m_canBackToss = false;
         this.m_canJumpWith = true;
         this.m_canAttackWith = true;
         this.m_canHangWith = true;
         this.m_canShieldWith = true;
         this.m_canRunWith = true;
         this.m_canBePushed = true;
         this.m_pushCharacters = true;
         this.m_time_max = 750;
         this.m_max_gravity = 5;
         this.m_effectSound = null;
         this.m_landSound = "item_land";
         this.m_spawnEffect = "global_spark";
         this.m_deathEffect = "dust";
         this.m_bounce = 0;
         this.m_bounce_decay = 1;
         this.m_bounce_limit = 0;
         this.m_bounce_max_height = -1;
         this.m_initialBounce = true;
         this.m_slideDecay = 0.85;
         this.m_dangerous = false;
         this.m_tossSpeed = 8;
         this.m_rotate = false;
         this.m_spawnLimit = 8;
         this.m_redirects = [];
         this.m_attackData = new AttackData(null,["attack_idle","attack_toss","attack_hold"]);
         this.m_projectiles = new Object();
      }
      
      public function get StatsName() : String
      {
         return this.m_statsName;
      }
      
      public function get Type() : String
      {
         return this.m_type;
      }
      
      public function get ClassID() : String
      {
         return this.m_class_id;
      }
      
      public function get InheritPalette() : Boolean
      {
         return this.m_inheritPalette;
      }
      
      public function get DisplayName() : String
      {
         if(this.m_displayName == null)
         {
            return "";
         }
         return this.m_displayName;
      }
      
      public function get RetainPlayerID() : Boolean
      {
         return this.m_retainPlayerID;
      }
      
      public function get DisableFlip() : Boolean
      {
         return this.m_disableFlip;
      }
      
      public function get SizeRatio() : Number
      {
         return this.m_sizeRatio;
      }
      
      public function get CanBeReversed() : Boolean
      {
         return this.m_canBeReversed;
      }
      
      public function set CanBeReversed(value:Boolean) : void
      {
         this.m_canBeReversed = value;
      }
      
      public function get CanPickup() : Boolean
      {
         return this.m_canPickup;
      }
      
      public function set CanPickup(value:Boolean) : void
      {
         this.m_canPickup = value;
      }
      
      public function get CanToss() : Boolean
      {
         return this.m_canToss;
      }
      
      public function set CanToss(value:Boolean) : void
      {
         this.m_canToss = value;
      }
      
      public function get CanBackToss() : Boolean
      {
         return this.m_canBackToss;
      }
      
      public function get CanJumpWith() : Boolean
      {
         return this.m_canJumpWith;
      }
      
      public function get CanAttackWith() : Boolean
      {
         return this.m_canAttackWith;
      }
      
      public function get CanHangWith() : Boolean
      {
         return this.m_canHangWith;
      }
      
      public function get CanShieldWith() : Boolean
      {
         return this.m_canShieldWith;
      }
      
      public function get CanRunWith() : Boolean
      {
         return this.m_canRunWith;
      }
      
      public function get CanBePushed() : Boolean
      {
         return this.m_canBePushed;
      }
      
      public function set CanBePushed(value:Boolean) : void
      {
         this.m_canBePushed = value;
      }
      
      public function get PushCharacters() : Boolean
      {
         return this.m_pushCharacters;
      }
      
      public function set PushCharacters(value:Boolean) : void
      {
         this.m_pushCharacters = value;
      }
      
      public function get TimeMax() : int
      {
         return this.m_time_max;
      }
      
      public function set TimeMax(value:int) : void
      {
         this.m_time_max = value;
      }
      
      public function get MaxGravity() : Number
      {
         return this.m_max_gravity;
      }
      
      public function get EffectSound() : String
      {
         return this.m_effectSound;
      }
      
      public function get LandSound() : String
      {
         return this.m_landSound;
      }
      
      public function get SpawnEffect() : String
      {
         return this.m_spawnEffect;
      }
      
      public function get DeathEffect() : String
      {
         return this.m_deathEffect;
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
      
      public function get InitialBounce() : Boolean
      {
         return this.m_initialBounce;
      }
      
      public function get Dangerous() : Boolean
      {
         return this.m_dangerous;
      }
      
      public function set Dangerous(value:Boolean) : void
      {
         this.m_dangerous = value;
      }
      
      public function get TossSpeed() : Number
      {
         return this.m_tossSpeed;
      }
      
      public function set TossSpeed(value:Number) : void
      {
         this.m_tossSpeed = value;
      }
      
      public function get Rotate() : Boolean
      {
         return this.m_rotate;
      }
      
      public function set Rotate(value:Boolean) : void
      {
         this.m_rotate = value;
      }
      
      public function get SpawnLimit() : int
      {
         return this.m_spawnLimit;
      }
      
      public function set SpawnLimit(value:int) : void
      {
         this.m_spawnLimit = value;
      }
      
      public function get Redirects() : Array
      {
         return this.m_redirects;
      }
      
      public function set Redirects(value:Array) : void
      {
         this.m_redirects = value;
      }
      
      public function get SlideDecay() : Number
      {
         return this.m_slideDecay;
      }
      
      public function set SlideDecay(value:Number) : void
      {
         this.m_slideDecay = value;
      }
      
      public function get AttackDataObj() : AttackData
      {
         return this.m_attackData;
      }
      
      public function get Projectiles() : Object
      {
         return this.m_projectiles;
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
            else if(Boolean(String(obj).match(/^attack_/)))
            {
               this.m_attackData.AttackArray[obj] = new AttackObject(obj);
               this.m_attackData.AttackMap.push(obj,this.m_attackData.AttackArray[obj]);
               this.m_attackData.getAttack(obj).importAttackData(data[obj]);
            }
            else if(this["m_" + obj] !== undefined)
            {
               this["m_" + obj] = data[obj];
            }
            else
            {
               flag = false;
               trace("You tried to set \"m_" + obj + "\" but it doesn\'t exist in the ItemData class.");
            }
         }
         return flag;
      }
      
      override public function exportData() : Object
      {
         var i:* = undefined;
         var j:* = undefined;
         var k:* = undefined;
         var pData:ProjectileAttack = null;
         var data:Object = super.exportData();
         var item:Object = new Object();
         item.statsName = this.m_statsName;
         item.type = this.m_type;
         item.class_id = this.m_class_id;
         item.inheritPalette = this.m_inheritPalette;
         item.displayName = this.m_displayName;
         item.retainPlayerID = this.m_retainPlayerID;
         item.disableFlip = this.m_disableFlip;
         item.sizeRatio = this.m_sizeRatio;
         item.canBeReversed = this.m_canBeReversed;
         item.canPickup = this.m_canPickup;
         item.canToss = this.m_canToss;
         item.canBackToss = this.m_canBackToss;
         item.canJumpWith = this.m_canJumpWith;
         item.canAttackWith = this.m_canAttackWith;
         item.canHangWith = this.m_canHangWith;
         item.canShieldWith = this.m_canShieldWith;
         item.canRunWith = this.m_canRunWith;
         item.canBePushed = this.m_canBePushed;
         item.pushCharacters = this.m_pushCharacters;
         item.time_max = this.m_time_max;
         item.max_gravity = this.m_max_gravity;
         item.effectSound = this.m_effectSound;
         item.landSound = this.m_landSound;
         item.spawnEffect = this.m_spawnEffect;
         item.deathEffect = this.m_deathEffect;
         item.bounce = this.m_bounce;
         item.bounce_decay = this.m_bounce_decay;
         item.bounce_limit = this.m_bounce_limit;
         item.bounce_max_height = this.m_bounce_max_height;
         item.initialBounce = this.m_initialBounce;
         item.slideDecay = this.m_slideDecay;
         item.dangerous = this.m_dangerous;
         item.redirects = this.m_redirects;
         item.tossSpeed = this.m_tossSpeed;
         item.rotate = this.m_rotate;
         item.spawnLimit = this.m_spawnLimit;
         item.projectiles = {};
         for(i in this.m_attackData.AttackArray)
         {
            item[i] = this.m_attackData.AttackArray[i].exportAttackData();
         }
         for(j in this.m_projectiles)
         {
            pData = new ProjectileAttack();
            pData.importData(this.m_projectiles[j]);
            item.projectiles[j] = pData.exportData();
         }
         for(k in data)
         {
            if(!(k in item))
            {
               item[k] = data[k];
            }
         }
         return item;
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

