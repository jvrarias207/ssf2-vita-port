package com.mcleodgaming.ssf2.engine
{
   import com.mcleodgaming.ssf2.api.SSF2Event;
   import com.mcleodgaming.ssf2.util.Dictionary;
   
   public class AttackData
   {
      
      private var m_owner:InteractiveSprite;
      
      private var m_attacks:Object;
      
      private var m_attackMap:Dictionary;
      
      private var m_projectiles:Array;
      
      private var m_items:Array;
      
      public function AttackData(owner:InteractiveSprite, defaultAttackList:Array = null)
      {
         super();
         this.m_owner = owner;
         var attacks:Array = Boolean(defaultAttackList) ? defaultAttackList : new Array();
         this.m_attacks = new Object();
         this.m_attackMap = new Dictionary(AttackObject);
         this.m_projectiles = new Array();
         this.m_items = new Array();
         for(var i:Number = 0; i < attacks.length; i++)
         {
            this.m_attacks[attacks[i]] = new AttackObject(attacks[i]);
            this.m_attackMap.push(attacks[i],this.m_attacks[attacks[i]]);
         }
      }
      
      public function get Owner() : InteractiveSprite
      {
         return this.m_owner;
      }
      
      public function set Owner(value:InteractiveSprite) : void
      {
         this.m_owner = value;
      }
      
      public function get AttackArray() : Object
      {
         return this.m_attacks;
      }
      
      public function get AttackMap() : Dictionary
      {
         return this.m_attackMap;
      }
      
      public function get ProjectilesArray() : Object
      {
         return this.m_projectiles;
      }
      
      public function get ItemsArray() : Object
      {
         return this.m_items;
      }
      
      public function setAttackDamageVar(attackName:String, hitBoxName:String, varName:String, value:*) : void
      {
         var obj:Object = null;
         if(this.m_attacks[attackName] != null && this.m_attacks[attackName].AttackBoxes[hitBoxName] != null)
         {
            obj = new Object();
            obj[varName] = value;
            this.m_attacks[attackName].AttackBoxes[hitBoxName].importAttackDamageData(obj);
         }
         else
         {
            trace(attackName + " does not cotnain the hitbox " + hitBoxName + " in AttackData array");
         }
      }
      
      public function setAttackBoxDataOverride(animation:String, hBoxName:String, data:Object) : void
      {
         var i:* = undefined;
         var copiedData:Object = null;
         var attack:AttackObject = this.getAttack(animation);
         if(Boolean(attack))
         {
            if(Boolean(attack.AttackBoxes[hBoxName]))
            {
               if(attack.OverrideMap.containsKey(hBoxName))
               {
                  for(i in data)
                  {
                     attack.OverrideMap.getKey(hBoxName)[i] = data[i];
                  }
               }
               else
               {
                  copiedData = {};
                  for(i in data)
                  {
                     copiedData[i] = data[i];
                  }
                  attack.OverrideMap.setKey(hBoxName,copiedData);
               }
            }
         }
      }
      
      public function getAttackBoxData(animation:String, hBoxName:String) : AttackDamage
      {
         var attackDamage:AttackDamage = new AttackDamage(Boolean(this.m_owner) ? this.m_owner.ID : -1,this.m_owner);
         var attack:AttackObject = this.getAttack(animation);
         if(Boolean(attack))
         {
            if(Boolean(attack.AttackBoxes[hBoxName]) && (Boolean(!this.m_owner) || Boolean(this.m_owner.AttackStateData)))
            {
               attackDamage.importAttackDamageData(attack.AttackBoxes[hBoxName].exportAttackDamageData());
               if(attack.OverrideMap.containsKey(hBoxName))
               {
                  attackDamage.importAttackDamageData(attack.OverrideMap.getKey(hBoxName));
               }
            }
         }
         return attackDamage;
      }
      
      public function resetCharges() : void
      {
         var obj:* = undefined;
         for(obj in this.m_attacks)
         {
            this.m_attacks[obj].ChargeTime = 0;
         }
      }
      
      public function resetDisabledAttacks() : void
      {
         var obj:* = undefined;
         for(obj in this.m_attacks)
         {
            this.m_attacks[obj].IsDisabled = false;
         }
      }
      
      public function incrementAttackTimers(fromChar:Character) : void
      {
         var obj:* = undefined;
         for(obj in this.m_attacks)
         {
            if(this.m_attacks[obj].ReenableTimer > 0 && this.m_attacks[obj].ReenableTimerCount > 0)
            {
               --this.m_attacks[obj].ReenableTimerCount;
               if(this.m_attacks[obj].ReenableTimerCount == 0)
               {
                  if(Boolean(this.m_owner))
                  {
                     this.m_owner.EventManagerObj.dispatchEvent(new SSF2Event(SSF2Event.ATTACK_ENABLED,{
                        "caller":this.m_owner.APIInstance.instance,
                        "attackData":this.m_attacks[obj].exportAttackData()
                     }));
                  }
                  this.m_attacks[obj].IsDisabled = false;
                  if(this.m_attacks[obj].ReenableEffect != null)
                  {
                     fromChar.attachEffect(this.m_attacks[obj].ReenableEffect);
                  }
               }
            }
            ++this.m_attacks[obj].LastUsed;
            ++this.m_attacks[obj].LastUsedPrevious;
         }
      }
      
      public function addProjectile(name:String, obj:ProjectileAttack) : void
      {
         this.m_projectiles[name] = obj;
         obj.StatsName = name;
      }
      
      public function getProjectile(name:String) : ProjectileAttack
      {
         if(this.m_projectiles[name] == undefined)
         {
            return null;
         }
         return this.m_projectiles[name];
      }
      
      public function addItem(name:String, obj:ItemData) : void
      {
         this.m_items[name] = obj;
      }
      
      public function getItem(name:String) : ItemData
      {
         if(this.m_items[name] == undefined)
         {
            return null;
         }
         return this.m_items[name];
      }
      
      public function getAttack(attack:String) : AttackObject
      {
         if(attack == null)
         {
            return null;
         }
         return this.m_attacks[attack] != null ? this.m_attacks[attack] : null;
      }
      
      public function setAttack(attackName:String, attack:AttackObject) : void
      {
         if(attackName != null && attack != null)
         {
            attack.Name = attackName;
            this.m_attacks[attackName] = attack;
         }
         else
         {
            trace("Error, in attempting to set \"" + attackName + "\" to \"" + attack.Name + "\"a null was returned");
         }
      }
      
      public function setAttackVar(attackName:String, varName:String, value:*) : void
      {
         var obj:Object = null;
         if(this.m_attacks[attackName] != null)
         {
            obj = new Object();
            obj[varName] = value;
            this.m_attacks[attackName].importAttackData(obj);
         }
         else
         {
            trace(attackName + " does not exist in AttackData array");
         }
      }
      
      public function importAttacks(attacks:Object) : void
      {
         var obj:* = undefined;
         for(obj in attacks)
         {
            if(this.m_attacks[obj] !== undefined)
            {
               this.m_attacks[obj].importAttackData(attacks[obj]);
            }
            else
            {
               this.m_attacks[obj] = new AttackObject(obj);
               this.m_attacks[obj].importAttackData(attacks[obj]);
            }
         }
      }
      
      public function importProjectiles(projectiles:Object) : void
      {
         var obj:* = undefined;
         for(obj in projectiles)
         {
            if(this.m_projectiles[obj] !== undefined)
            {
               this.m_projectiles[obj].importData(projectiles[obj]);
            }
            else
            {
               this.m_projectiles[obj] = new ProjectileAttack();
               this.m_projectiles[obj].importData(projectiles[obj]);
            }
         }
      }
      
      public function importItems(items:Object) : void
      {
         var obj:* = undefined;
         for(obj in items)
         {
            if(this.m_items[obj] !== undefined)
            {
               this.m_items[obj].importData(items[obj]);
            }
            else
            {
               this.m_items[obj] = new ItemData();
               this.m_items[obj].importData(items[obj]);
            }
         }
      }
   }
}

