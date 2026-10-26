package com.mcleodgaming.ssf2.engine
{
   import com.mcleodgaming.ssf2.items.Item;
   import flash.geom.Point;
   
   public class Target
   {
      
      private var m_target:InteractiveSprite;
      
      private var m_distance:Number;
      
      private var m_xDistance:Number;
      
      private var m_yDistance:Number;
      
      public function Target()
      {
         super();
         this.m_target = null;
         this.m_distance = 0;
         this.m_xDistance = 0;
         this.m_yDistance = 0;
      }
      
      public function get PlayerSprite() : Character
      {
         return this.m_target is Character ? this.m_target as Character : null;
      }
      
      public function get ItemSprite() : Item
      {
         return this.m_target is Item ? this.m_target as Item : null;
      }
      
      public function get ProjectileSprite() : Projectile
      {
         return this.m_target is Projectile ? this.m_target as Projectile : null;
      }
      
      public function get BeaconSprite() : Beacon
      {
         return this.m_target is Beacon ? this.m_target as Beacon : null;
      }
      
      public function get CurrentTarget() : InteractiveSprite
      {
         return this.m_target;
      }
      
      public function set CurrentTarget(value:InteractiveSprite) : void
      {
         this.m_target = value;
      }
      
      public function get Distance() : Number
      {
         return this.m_distance;
      }
      
      public function set Distance(value:Number) : void
      {
         this.m_distance = value;
      }
      
      public function get XDistance() : Number
      {
         return this.m_xDistance;
      }
      
      public function get YDistance() : Number
      {
         return this.m_yDistance;
      }
      
      public function setDistance(point:Point) : void
      {
         if(this.m_target != null)
         {
            this.m_xDistance = Math.abs(this.m_target.X - point.x);
            this.m_yDistance = Math.abs(this.m_target.Y - point.y);
            this.m_distance = this.m_target != null ? Math.sqrt(Math.pow(this.m_target.X - point.x,2) + Math.pow(this.m_target.Y - point.y,2)) : 0;
         }
      }
      
      public function reset() : void
      {
         this.m_target = null;
         this.m_distance = 0;
      }
   }
}

