package com.mcleodgaming.ssf2.api
{
   import com.mcleodgaming.ssf2.engine.InteractiveSprite;
   import com.mcleodgaming.ssf2.engine.Projectile;
   
   public class SSF2Projectile extends SSF2GameObject
   {
      
      protected var _ownerCasted:Projectile;
      
      public function SSF2Projectile(api:Class, owner:Projectile)
      {
         super(api,owner);
         this._ownerCasted = Projectile(owner);
      }
      
      public function angleControl(speed:Number, angle:Number) : void
      {
         this._ownerCasted.angleControl(speed,angle);
      }
      
      public function destroy(e:* = null) : void
      {
         this._ownerCasted.destroy(e);
      }
      
      public function endControl() : void
      {
         this._ownerCasted.endControl();
         SSF2API.print("WARNING: SSF2Projectile\'s endControl() method has been deprecated. Use updateProjectileStats() instead");
      }
      
      public function exportStats() : Object
      {
         return this._ownerCasted.exportStats();
      }
      
      public function getProjectileStat(statName:String) : *
      {
         return this._ownerCasted.getProjectileStat(statName);
      }
      
      public function isReversed() : Boolean
      {
         return this._ownerCasted.isReversed();
      }
      
      public function updateProjectileStats(statValues:Object) : void
      {
         this._ownerCasted.updateProjectileStats(statValues);
      }
      
      public function getOwner() : *
      {
         return this._ownerCasted.getOwnerAPI();
      }
      
      public function setOwner(object:*) : void
      {
         return this._ownerCasted.setOwnerAPI(Boolean(object) ? object.$ext.getAPI().owner : null);
      }
   }
}

