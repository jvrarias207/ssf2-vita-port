package com.mcleodgaming.ssf2.api
{
   import com.mcleodgaming.ssf2.enemies.Enemy;
   import com.mcleodgaming.ssf2.engine.InteractiveSprite;
   import com.mcleodgaming.ssf2.engine.Projectile;
   
   public class SSF2Enemy extends SSF2GameObject
   {
      
      protected var _ownerCasted:Enemy;
      
      public function SSF2Enemy(api:Class, owner:Enemy)
      {
         super(api,owner);
         this._ownerCasted = owner;
      }
      
      public function destroy() : void
      {
         this._ownerCasted.destroy();
      }
      
      public function getOwner() : *
      {
         return this._ownerCasted.getOwnerAPI();
      }
      
      public function setOwner(object:*) : void
      {
         this._ownerCasted.setOwnerAPI(Boolean(object) ? object.$ext.getAPI().owner : null);
      }
      
      public function fireProjectile(projData:*, xOverride:Number = 0, yOverride:Number = 0, absolute:Boolean = false, options:Object = null) : *
      {
         var proj:Projectile = this._ownerCasted.fireProjectile(projData,xOverride,yOverride,absolute,options);
         return Boolean(proj) && Boolean(proj.APIInstance) ? proj.APIInstance.instance : null;
      }
      
      public function getEnemyStat(statName:String) : *
      {
         return this._ownerCasted.getEnemyStat(statName);
      }
      
      public function updateEnemyStats(statValues:Object) : void
      {
         this._ownerCasted.updateEnemyStats(statValues);
      }
      
      public function setHurtInterrupt(fn:Function) : void
      {
         _ownerCastedBase.HurtInterrupt = fn;
      }
   }
}

