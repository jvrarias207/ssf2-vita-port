package com.mcleodgaming.ssf2.api
{
   import com.mcleodgaming.ssf2.engine.Character;
   import com.mcleodgaming.ssf2.engine.InteractiveSprite;
   import com.mcleodgaming.ssf2.engine.Projectile;
   import com.mcleodgaming.ssf2.items.Item;
   
   public class SSF2Item extends SSF2GameObject
   {
      
      protected var _ownerCasted:Item;
      
      public function SSF2Item(api:Class, owner:Item)
      {
         super(api,owner);
         this._ownerCasted = Item(owner);
      }
      
      public function destroy(sfx:Boolean = false) : void
      {
         this._ownerCasted.destroy(sfx);
      }
      
      public function fireProjectile(projData:*, xOverride:Number = 0, yOverride:Number = 0, absolute:Boolean = false, options:Object = null) : *
      {
         var proj:Projectile = this._ownerCasted.fireProjectile(projData,xOverride,yOverride,absolute,options);
         return Boolean(proj) && Boolean(proj.APIInstance) ? proj.APIInstance.instance : null;
      }
      
      public function getItemStat(statName:String) : *
      {
         return this._ownerCasted.getItemStat(statName);
      }
      
      public function isReversed() : Boolean
      {
         return this._ownerCasted.isReversed();
      }
      
      public function resetTime() : void
      {
         this._ownerCasted.resetTime();
      }
      
      public function updateItemStats(statValues:Object) : void
      {
         this._ownerCasted.updateItemStats(statValues);
      }
      
      public function getOwner() : *
      {
         return this._ownerCasted.getOwnerAPI();
      }
      
      public function setOwner(object:*) : void
      {
         return this._ownerCasted.setOwnerAPI(Boolean(object) ? object.$ext.getAPI().owner : null);
      }
      
      public function getHolder() : *
      {
         return this._ownerCasted.getHolderAPI();
      }
      
      public function setHolder(character:*) : void
      {
         return this._ownerCasted.setHolderAPI(Boolean(character) ? character.$ext.getAPI().owner : null);
      }
      
      public function toIdle(e:* = null) : void
      {
         this._ownerCasted.toIdle(e);
      }
      
      public function toHeld(e:* = null) : void
      {
         this._ownerCasted.toHeld(e);
      }
      
      public function toToss(e:* = null) : void
      {
         this._ownerCasted.toToss(e);
      }
      
      public function setFrameInterrupt(fn:Function) : void
      {
         this._ownerCasted.FrameInterrupt = fn;
      }
      
      public function setHurtInterrupt(fn:Function) : void
      {
         _ownerCastedBase.HurtInterrupt = fn;
      }
      
      public function isZDropped() : Boolean
      {
         return this._ownerCasted.WasZDropped;
      }
   }
}

