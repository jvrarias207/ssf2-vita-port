package com.mcleodgaming.ssf2.engine
{
   import flash.utils.getQualifiedClassName;
   
   public class InteractiveSpriteStats
   {
      
      protected var m_classAPI:Class;
      
      protected var m_width:Number;
      
      protected var m_height:Number;
      
      protected var m_weight1:Number;
      
      protected var m_linkage_id:String;
      
      protected var m_gravity:Number;
      
      protected var m_max_ySpeed:Number;
      
      protected var m_max_projectile:int;
      
      protected var m_ghost:Boolean;
      
      protected var m_surviveDeathBounds:Boolean;
      
      protected var m_canReceiveKnockback:Boolean;
      
      protected var m_canReceiveDamage:Boolean;
      
      protected var m_canReceiveHits:Boolean;
      
      protected var m_bypassCollisionTesting:Boolean;
      
      protected var m_shadow:Boolean;
      
      protected var m_reflection:Boolean;
      
      protected var m_stamina:int;
      
      protected var m_knee_x_offset:Number;
      
      protected var m_knee_y_offset:Number;
      
      protected var m_hurtByOwner:Boolean;
      
      protected var m_hurtByTeam:Boolean;
      
      public function InteractiveSpriteStats()
      {
         super();
         this.m_classAPI = null;
         this.m_width = 0;
         this.m_height = 0;
         this.m_weight1 = 100;
         this.m_linkage_id = null;
         this.m_gravity = 0;
         this.m_max_ySpeed = 0;
         this.m_max_projectile = 10;
         this.m_ghost = false;
         this.m_surviveDeathBounds = false;
         this.m_canReceiveKnockback = true;
         this.m_canReceiveDamage = true;
         this.m_canReceiveHits = true;
         this.m_bypassCollisionTesting = false;
         this.m_shadow = true;
         this.m_reflection = true;
         this.m_stamina = 0;
         this.m_knee_x_offset = 11;
         this.m_knee_y_offset = -25;
         this.m_hurtByOwner = false;
         this.m_hurtByTeam = false;
      }
      
      public function get ClassAPI() : Class
      {
         return this.m_classAPI;
      }
      
      public function get Width() : Number
      {
         return this.m_width;
      }
      
      public function get Height() : Number
      {
         return this.m_height;
      }
      
      public function get Weight1() : Number
      {
         return this.m_weight1;
      }
      
      public function get LinkageID() : String
      {
         return this.m_linkage_id;
      }
      
      public function get Gravity() : Number
      {
         return this.m_gravity;
      }
      
      public function get MaxYSpeed() : Number
      {
         return this.m_max_ySpeed;
      }
      
      public function get MaxProjectile() : int
      {
         return this.m_max_projectile;
      }
      
      public function get Ghost() : Boolean
      {
         return this.m_ghost;
      }
      
      public function get SurviveDeathBounds() : Boolean
      {
         return this.m_surviveDeathBounds;
      }
      
      public function get CanReceiveKnockback() : Boolean
      {
         return this.m_canReceiveKnockback;
      }
      
      public function get CanReceiveDamage() : Boolean
      {
         return this.m_canReceiveDamage;
      }
      
      public function get CanReceiveHits() : Boolean
      {
         return this.m_canReceiveHits;
      }
      
      public function get BypassCollisionTesting() : Boolean
      {
         return this.m_bypassCollisionTesting;
      }
      
      public function get Shadow() : Boolean
      {
         return this.m_shadow;
      }
      
      public function get Reflection() : Boolean
      {
         return this.m_reflection;
      }
      
      public function get Stamina() : int
      {
         return this.m_stamina;
      }
      
      public function get KneeXOffset() : Number
      {
         return this.m_knee_x_offset;
      }
      
      public function get KneeYOffset() : Number
      {
         return this.m_knee_y_offset;
      }
      
      public function get HurtByOwner() : Boolean
      {
         return this.m_hurtByOwner;
      }
      
      public function get HurtByTeam() : Boolean
      {
         return this.m_hurtByTeam;
      }
      
      public function getVar(varName:String) : *
      {
         if(this["m_" + varName] !== undefined)
         {
            return this["m_" + varName];
         }
         return null;
      }
      
      public function importData(data:Object) : Boolean
      {
         var obj:* = undefined;
         var flag:Boolean = true;
         for(obj in data)
         {
            if(this["m_" + obj] !== undefined)
            {
               this["m_" + obj] = data[obj];
            }
            else
            {
               flag = false;
               trace("You tried to set \"m_" + obj + "\" but it doesn\'t exist in the " + getQualifiedClassName(this) + " class. (" + data["linkage_id"] + ")");
            }
         }
         return flag;
      }
      
      public function exportData() : Object
      {
         var data:Object = new Object();
         data.classAPI = this.m_classAPI;
         data.width = this.m_width;
         data.height = this.m_height;
         data.weight1 = this.m_weight1;
         data.linkage_id = this.m_linkage_id;
         data.gravity = this.m_gravity;
         data.height = this.m_height;
         data.max_ySpeed = this.m_max_ySpeed;
         data.max_projectile = this.m_max_projectile;
         data.ghost = this.m_ghost;
         data.surviveDeathBounds = this.m_surviveDeathBounds;
         data.canReceiveKnockback = this.m_canReceiveKnockback;
         data.canReceiveDamage = this.m_canReceiveDamage;
         data.canReceiveHits = this.m_canReceiveHits;
         data.bypassCollisionTesting = this.m_bypassCollisionTesting;
         data.shadow = this.m_shadow;
         data.reflection = this.m_reflection;
         data.stamina = this.m_stamina;
         data.knee_x_offset = this.m_knee_x_offset;
         data.knee_y_offset = this.m_knee_y_offset;
         data.hurtByOwner = this.m_hurtByOwner;
         data.hurtByTeam = this.m_hurtByTeam;
         return data;
      }
   }
}

