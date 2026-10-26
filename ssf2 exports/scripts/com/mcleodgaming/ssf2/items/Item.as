package com.mcleodgaming.ssf2.items
{
   import com.mcleodgaming.ssf2.Main;
   import com.mcleodgaming.ssf2.api.SSF2Event;
   import com.mcleodgaming.ssf2.api.SSF2Item;
   import com.mcleodgaming.ssf2.controllers.MenuController;
   import com.mcleodgaming.ssf2.enemies.Enemy;
   import com.mcleodgaming.ssf2.engine.*;
   import com.mcleodgaming.ssf2.enums.*;
   import com.mcleodgaming.ssf2.util.*;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class Item extends InteractiveSprite
   {
      
      public static const ATTACK_IDLE:String = "attack_idle";
      
      public static const ATTACK_TOSS:String = "attack_toss";
      
      public static const ATTACK_HOLD:String = "attack_hold";
      
      protected var m_owner:InteractiveSprite;
      
      protected var m_linkage_id:String;
      
      protected var m_slot:int;
      
      protected var m_originalPlayerID:int;
      
      protected var m_currentHolder:Character;
      
      protected var m_previousHolder:Character;
      
      protected var m_wasZDropped:Boolean;
      
      protected var m_lastReleaseTimer:int;
      
      protected var m_time:int;
      
      protected var m_projectile:Vector.<Projectile>;
      
      protected var m_lastProjectile:int;
      
      protected var m_pickedUp:Boolean;
      
      protected var m_bounceOrig:Number;
      
      protected var m_bounce_limit:FrameTimer;
      
      protected var m_bounce_total:int;
      
      protected var m_effectSound:String;
      
      protected var m_landSound:String;
      
      protected var m_initTimer:int;
      
      protected var m_reverseTimer:int;
      
      protected var m_wasReversed:Boolean;
      
      protected var m_reverse_id:int;
      
      protected var m_richochetTimer:FrameTimer;
      
      protected var m_richochetX:Number;
      
      protected var m_richochetY:Number;
      
      protected var m_reactivationDelay:FrameTimer;
      
      protected var m_bounce_remaining:int;
      
      protected var m_frameInterrupt:Function;
      
      protected var m_itemStats:ItemData;
      
      public function Item(parameters:ItemData, slot:int, stageData:StageData)
      {
         m_baseStats = this.m_itemStats = new ItemData();
         this.m_itemStats.importData(parameters.exportData());
         m_apiInstance = new SSF2Item(this.m_itemStats.ClassAPI,this);
         this.m_owner = null;
         this.m_itemStats.importData(m_apiInstance.getOwnStats());
         this.m_slot = slot;
         this.m_linkage_id = this.m_itemStats.LinkageID;
         m_sizeRatio = this.m_itemStats.SizeRatio;
         stageData.ItemsRef.ItemsInUse[slot] = this;
         var tmpMC:MovieClip = ResourceManager.getLibraryMC(this.m_linkage_id);
         tmpMC.ACTIVE = true;
         super(tmpMC,stageData);
         tmpMC.width *= m_sizeRatio;
         tmpMC.height *= m_sizeRatio;
         m_currentPlatform = null;
         this.m_frameInterrupt = null;
         m_player_id = 0;
         this.m_originalPlayerID = 0;
         this.m_currentHolder = null;
         this.m_previousHolder = null;
         m_team_id = -1;
         m_sprite.uid = m_uid;
         m_gravity = this.m_itemStats.Gravity;
         m_max_ySpeed = this.m_itemStats.MaxGravity;
         m_xSpeed = 0;
         m_ySpeed = 0;
         this.m_initTimer = 0;
         this.m_time = 0;
         m_lastAttackID = new Array(15);
         m_lastAttackIndex = 0;
         m_width = this.m_itemStats.Width;
         m_height = this.m_itemStats.Height;
         this.m_pickedUp = false;
         m_collision = new Collision();
         this.m_effectSound = this.m_itemStats.EffectSound;
         this.m_landSound = this.m_itemStats.LandSound;
         this.m_lastReleaseTimer = 0;
         this.m_wasZDropped = false;
         m_attackData = this.m_itemStats.AttackDataObj;
         m_attackData.Owner = this;
         m_attackData.importProjectiles(this.m_itemStats.Projectiles);
         this.m_projectile = new Vector.<Projectile>();
         this.m_bounce_remaining = this.m_itemStats.InitialBounce ? 3 : 0;
         this.m_lastProjectile = 0;
         m_actionShot = false;
         m_actionTimer = 0;
         m_hitStunTimer = 0;
         m_hitStunToggle = false;
         this.m_reverseTimer = 0;
         this.m_wasReversed = false;
         this.m_reverse_id = 0;
         this.m_richochetTimer = new FrameTimer(2);
         this.m_richochetX = 0;
         this.m_richochetY = 0;
         m_sprite.cam_width = m_width;
         m_sprite.cam_height = m_height;
         this.m_reactivationDelay = new FrameTimer(3);
         buildHitBoxData(this.m_linkage_id);
         if(Main.DEBUG)
         {
            verifiyHitBoxData();
         }
         this.getTerrainData();
         m_state = IState.IDLE;
         m_attackData.importAttacks(m_apiInstance.getAttackStats());
         m_attackData.importItems(m_apiInstance.getItemStats());
         m_attackData.importProjectiles(m_apiInstance.getProjectileStats());
         this.m_bounceOrig = this.m_itemStats.Bounce;
         this.m_bounce_limit = new FrameTimer(this.m_itemStats.BounceLimit);
         this.m_bounce_total = 0;
         for(var i:int = 0; i < this.m_itemStats.MaxProjectile; i++)
         {
            this.m_projectile[i] = null;
         }
         this.syncStats();
         m_apiInstance.initialize();
         this.Attack(Item.ATTACK_IDLE,m_facingForward);
         if(this.m_itemStats.StatsName === "cucco")
         {
            ++STAGEDATA.CuccoCount;
         }
         if(this.m_itemStats.StatsName === "assistTrophy")
         {
            ++STAGEDATA.AssistCount;
         }
         if(this.m_itemStats.StatsName === "pokeball")
         {
            ++STAGEDATA.PokemonCount;
         }
      }
      
      override public function get CurrentAnimation() : HitBoxAnimation
      {
         return m_hitBoxManager == null ? null : (m_hitBoxManager.HitBoxAnimationList.length <= 0 || !m_currentAnimationID ? null : m_hitBoxManager.getHitBoxAnimation(this.m_linkage_id + "_" + m_currentAnimationID));
      }
      
      protected function m_initFunctions() : void
      {
      }
      
      override public function setVisibility(value:Boolean) : void
      {
         if(!this.m_pickedUp)
         {
            super.setVisibility(value);
         }
         else
         {
            m_sprite.visible = value;
            m_reflectionEffect.visible = value;
         }
      }
      
      public function isReversed() : Boolean
      {
         return this.m_wasReversed;
      }
      
      public function getCurrentProjectile() : Projectile
      {
         if(this.m_lastProjectile >= 0 && this.m_lastProjectile < this.m_projectile.length)
         {
            return this.m_projectile[this.m_lastProjectile];
         }
         return null;
      }
      
      public function getProjectile(num:Number) : Projectile
      {
         if(num >= 0 && num < this.m_projectile.length)
         {
            return this.m_projectile[num];
         }
         return null;
      }
      
      override public function getProjectiles() : Array
      {
         var arr:Array = new Array();
         for(var i:int = 0; i < this.m_projectile.length; i++)
         {
            if(Boolean(this.m_projectile[i]) && !this.m_projectile[i].Dead)
            {
               arr.push(this.m_projectile[i]);
            }
         }
         return arr;
      }
      
      private function getProjectileLimit(linkID:String) : Number
      {
         var total:Number = 0;
         for(var i:int = 0; i < this.m_projectile.length; i++)
         {
            if(this.m_projectile[i] != null && !this.m_projectile[i].inState(PState.DEAD) && (Boolean(this.m_projectile[i].LinkageID == linkID) || Boolean(this.m_projectile[i].getProjectileStat("statsName") && this.m_projectile[i].getProjectileStat("statsName") == linkID)))
            {
               total++;
            }
         }
         return total;
      }
      
      private function checkDeadProjectiles() : void
      {
         for(var i:int = 0; i < this.m_projectile.length; i++)
         {
            if(this.m_projectile[i] != null && this.m_projectile[i].Dead)
            {
               this.m_projectile[i] = null;
            }
         }
      }
      
      public function destroyAllProjectiles() : void
      {
         var i:int = 0;
         while(i < this.m_itemStats.MaxProjectile && i < this.m_projectile.length)
         {
            if(this.m_projectile[i] != null)
            {
               this.m_projectile[i].destroy();
               this.m_projectile[i] = null;
            }
            i++;
         }
      }
      
      private function getIndexOfOldestProjectile(statsName:String) : int
      {
         var oldest:int = -1;
         var i:int = 0;
         while(i < this.m_itemStats.MaxProjectile && i < this.m_projectile.length)
         {
            if(this.m_projectile[i] != null && this.m_projectile[i].ProjectileAttackObj.StatsName == statsName && (oldest < 0 || this.m_projectile[i].Time > this.m_projectile[oldest].Time))
            {
               oldest = i;
            }
            i++;
         }
         return oldest;
      }
      
      public function fireProjectile(projData:*, xOverride:Number = 0, yOverride:Number = 0, absolute:Boolean = false, options:Object = null) : Projectile
      {
         var i:int = 0;
         var old:int = 0;
         var position:Point = null;
         var facingForward:Boolean = false;
         var rep:int = 0;
         var success:Projectile = null;
         var n:ProjectileAttack = null;
         if(Boolean(projData as String))
         {
            n = m_attackData.getProjectile(projData);
         }
         else
         {
            n = new ProjectileAttack();
            n.importData(projData);
         }
         if(!options)
         {
            options = {};
         }
         if(n != null)
         {
            i = 0;
            while(i < this.m_itemStats.MaxProjectile && i < this.m_projectile.length && !success)
            {
               if((this.m_projectile[i] == null || this.m_projectile[i].inState(PState.DEAD) || n.LimitOverwrite) && n.LinkageID != null && (this.getProjectileLimit(n.LinkageID) < n.Limit || n.LimitOverwrite))
               {
                  old = i;
                  if(n.LimitOverwrite && this.getProjectileLimit(n.LinkageID) >= n.Limit)
                  {
                     i = this.getIndexOfOldestProjectile(n.LinkageID);
                     if(i < 0)
                     {
                        return null;
                     }
                     this.m_projectile[i].destroy();
                     this.m_projectile[i] = null;
                  }
                  else if(n.LimitOverwrite)
                  {
                     i = this.getIndexOfOldestProjectile(n.StatsName);
                     for(rep = 0; rep < this.m_projectile.length; rep++)
                     {
                        if(this.m_projectile[rep] == null)
                        {
                           i = rep;
                           break;
                        }
                     }
                     if(i < 0)
                     {
                        return null;
                     }
                     if(Boolean(this.m_projectile[i]))
                     {
                        this.m_projectile[i].destroy();
                     }
                  }
                  position = new Point(m_sprite.x,m_sprite.y);
                  facingForward = m_facingForward;
                  if(Boolean(this.m_currentHolder) && this.m_pickedUp)
                  {
                     position.x = this.m_currentHolder.X;
                     position.y = this.m_currentHolder.Y;
                     facingForward = this.m_currentHolder.isFacingRight();
                  }
                  this.m_projectile[i] = new Projectile({
                     "owner":this,
                     "player_id":m_player_id,
                     "x_start":position.x,
                     "y_start":position.y,
                     "sizeRatio":m_sizeRatio,
                     "facingForward":facingForward,
                     "chargetime":options.chargetime || m_attack.ChargeTime,
                     "chargetime_max":options.chargetime_max || m_attack.ChargeTimeMax,
                     "frame":n.StatsName + "_proj",
                     "staleMultiplier":1,
                     "sizeStatus":1,
                     "terrains":m_terrains,
                     "platforms":m_platforms,
                     "team_id":m_team_id,
                     "keys":(Boolean(this.m_currentHolder) ? this.m_currentHolder.ControlSettings : null),
                     "volume_sfx":1,
                     "volume_vfx":1
                  },n,STAGEDATA);
                  success = this.m_projectile[i];
                  this.m_lastProjectile = i;
                  if(xOverride != 0 || yOverride != 0)
                  {
                     if(absolute)
                     {
                        this.m_projectile[i].X = xOverride;
                        this.m_projectile[i].Y = yOverride;
                        this.m_projectile[i].X += m_facingForward ? n.XOffset * m_sizeRatio : -n.XOffset * m_sizeRatio;
                        this.m_projectile[i].Y += n.YOffset * m_sizeRatio;
                     }
                     else
                     {
                        this.m_projectile[i].X += m_facingForward ? xOverride : -xOverride;
                        this.m_projectile[i].Y += yOverride * m_sizeRatio;
                        this.m_projectile[i].X += m_facingForward ? n.XOffset * m_sizeRatio : -n.XOffset * m_sizeRatio;
                        this.m_projectile[i].Y += n.YOffset * m_sizeRatio;
                     }
                  }
                  else
                  {
                     this.m_projectile[i].X += m_facingForward ? n.XOffset * m_sizeRatio : -n.XOffset * m_sizeRatio;
                     this.m_projectile[i].Y += n.YOffset * m_sizeRatio;
                  }
                  break;
               }
               i++;
            }
         }
         return success;
      }
      
      public function getTerrainData() : void
      {
      }
      
      protected function m_checkReverse() : void
      {
         if(!inState(IState.DEAD))
         {
            if(this.m_reverseTimer > 0)
            {
               --this.m_reverseTimer;
            }
         }
      }
      
      protected function m_itemAttack() : void
      {
         if(HasAttackBox)
         {
            if(Boolean(this.m_currentHolder))
            {
               m_attack.XLoc = this.m_currentHolder.X;
               m_attack.YLoc = this.m_currentHolder.Y;
            }
            else
            {
               m_attack.XLoc = m_sprite.x;
               m_attack.YLoc = m_sprite.y;
            }
         }
         if(!isHitStunOrParalysis())
         {
            ++m_attack.ExecTime;
            ++m_attack.RefreshRateTimer;
            if(m_attack.RefreshRate > 0 && m_attack.RefreshRateReady && m_attack.RefreshRateTimer % m_attack.RefreshRate == 0)
            {
               m_attack.AttackID = Utils.getUID();
            }
         }
      }
      
      override public function forceAttack(value:String, toFrame:* = null, isSpecial:Boolean = false) : Boolean
      {
         if(value === m_attack.Frame)
         {
            if(Boolean(Main.DEBUG) && Boolean(MenuController.debugConsole) && MenuController.debugConsole.Alerts)
            {
               MenuController.debugConsole.alert("[Warning] forceAttack(\"" + value + "\") was called when the SSF2Projectile object was already using that attack. Call has been aborted");
            }
            return false;
         }
         if(value != null)
         {
            if(value !== m_attack.Frame)
            {
               flushTimers();
               removeAllTempEvents();
            }
            this.Attack(value,m_facingForward);
            if(toFrame !== null)
            {
               stancePlayFrame(toFrame);
            }
            return true;
         }
         return false;
      }
      
      public function Attack(frame:String, isForward:Boolean) : void
      {
         var atkObj:AttackObject = m_attackData.getAttack(frame);
         atkObj.OverrideMap.clear();
         m_attack.simpleReset();
         m_attack.Frame = frame;
         m_attack.ExecTime = 0;
         m_attack.AttackID = Utils.getUID();
         m_attack.ID = Utils.getUID();
         m_attack.ChargeTime = atkObj.ChargeTime;
         m_attack.ChargeTimeMax = atkObj.ChargeTimeMax;
         m_attack.ChargeRetain = atkObj.ChargeRetain;
         m_attack.ResetMovement = atkObj.ResetMovement;
         m_attack.RefreshRate = atkObj.RefreshRate;
         m_attack.ForceComboContinue = atkObj.ForceComboContinue;
         m_attack.AirEase = atkObj.AirEase;
         m_attack.RefreshRateReady = false;
         m_attack.IsForward = isForward;
         m_attack.HasClanked = false;
         playFrame(m_attack.Frame);
         if(!atkObj.ChargeRetain)
         {
            atkObj.ChargeTime = 0;
         }
         switch(frame)
         {
            case "attack_idle":
               this.setState(IState.IDLE);
               break;
            case "attack_hold":
               this.setState(IState.HOLD);
               break;
            case "attack_toss":
               this.setState(IState.TOSS);
         }
      }
      
      override public function reactionShield(otherSprite:InteractiveSprite, hBoxResult:HitBoxCollisionResult) : Boolean
      {
         var opponent:Character = Boolean(otherSprite as Character) ? Character(otherSprite) : null;
         var attackDamage:AttackDamage = m_attackData.getAttackBoxData(m_attackCache.Frame,hBoxResult.FirstHitBox.Name).syncState(m_attackCache);
         if(Boolean(opponent))
         {
            if(attackDamage.BypassShield && otherSprite.takeDamage(attackDamage,hBoxResult.OverlapHitBox))
            {
               m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.ATTACK_CONNECT,{
                  "caller":this.APIInstance.instance,
                  "receiver":otherSprite.APIInstance.instance,
                  "attackBoxData":attackDamage.exportAttackDamageData()
               }));
               this.handleHit(otherSprite,attackDamage,hBoxResult);
               return true;
            }
            if(opponent.takeShieldDamage(attackDamage,hBoxResult.OverlapHitBox))
            {
               m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.ATTACK_CONNECT_SHIELD,{
                  "caller":this.APIInstance.instance,
                  "receiver":otherSprite.APIInstance.instance,
                  "attackBoxData":attackDamage.exportAttackDamageData()
               }));
               startActionShot(Utils.calculateSelfHitStun(attackDamage.SelfHitStun,Utils.calculateChargeDamage(attackDamage)));
               m_eventManager.dispatchEvent(new SSF2Event(Character(otherSprite).PerfectShield ? SSF2Event.ATTACK_HIT_POWER_SHIELD : SSF2Event.ATTACK_HIT_SHIELD,{
                  "caller":this.APIInstance.instance,
                  "receiver":otherSprite.APIInstance.instance,
                  "attackBoxData":attackDamage.exportAttackDamageData()
               }));
               return true;
            }
         }
         return false;
      }
      
      override public function reactionAbsorb(otherSprite:InteractiveSprite, hBoxResult:HitBoxCollisionResult) : Boolean
      {
         return false;
      }
      
      override public function reactionReverse(otherSprite:InteractiveSprite, hBoxResult:HitBoxCollisionResult) : Boolean
      {
         if(Boolean(otherSprite as Projectile) || Boolean(otherSprite as Item))
         {
            if(otherSprite.reverse(m_player_id,m_team_id,m_facingForward))
            {
               otherSprite.EventManagerObj.dispatchEvent(new SSF2Event(SSF2Event.REVERSE,{
                  "caller":otherSprite.APIInstance.instance,
                  "opponent":this.APIInstance.instance,
                  "attackBoxData":null
               }));
               m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.REVERSE_HIT,{
                  "caller":this.APIInstance.instance,
                  "opponent":otherSprite.APIInstance.instance,
                  "attackBoxData":null
               }));
            }
         }
         return false;
      }
      
      override public function reactionAttackReverse(otherSprite:InteractiveSprite, hBoxResult:HitBoxCollisionResult) : Boolean
      {
         var attackDamage:AttackDamage = m_attackData.getAttackBoxData(m_attackCache.Frame,hBoxResult.FirstHitBox.Name).syncState(m_attackCache);
         if(Boolean(attackDamage.ReverseProjectile) && Boolean(otherSprite as Projectile) && otherSprite.reverse(m_player_id,m_team_id,m_facingForward))
         {
            otherSprite.EventManagerObj.dispatchEvent(new SSF2Event(SSF2Event.REVERSE,{
               "caller":otherSprite.APIInstance.instance,
               "opponent":this.APIInstance.instance,
               "attackBoxData":null
            }));
            m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.REVERSE_HIT,{
               "caller":this.APIInstance.instance,
               "opponent":otherSprite.APIInstance.instance,
               "attackBoxData":null
            }));
         }
         else if(Boolean(attackDamage.ReverseItem) && Boolean(otherSprite as Item) && otherSprite.reverse(m_player_id,m_team_id,m_facingForward))
         {
            otherSprite.EventManagerObj.dispatchEvent(new SSF2Event(SSF2Event.REVERSE,{
               "caller":otherSprite.APIInstance.instance,
               "opponent":this.APIInstance.instance,
               "attackBoxData":null
            }));
            m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.REVERSE_HIT,{
               "caller":this.APIInstance.instance,
               "opponent":otherSprite.APIInstance.instance,
               "attackBoxData":null
            }));
         }
         return false;
      }
      
      override public function reactionCounter(otherSprite:InteractiveSprite, hBoxResult:HitBoxCollisionResult) : Boolean
      {
         if(inState(IState.DEAD))
         {
            return false;
         }
         var attackDamage2:AttackDamage = otherSprite.AttackDataObj.getAttackBoxData(otherSprite.AttackStateData.Frame,hBoxResult.SecondHitBox.Name).syncState(otherSprite.AttackCache);
         if(this.validateHit(attackDamage2,true))
         {
            return true;
         }
         return false;
      }
      
      override public function reactionClank(otherSprite:InteractiveSprite, hBoxResult:HitBoxCollisionResult) : Boolean
      {
         if(inState(IState.DEAD))
         {
            return false;
         }
         var attackDamage1:AttackDamage = m_attackData.getAttackBoxData(m_attackCache.Frame,hBoxResult.FirstHitBox.Name).syncState(m_attackCache);
         var attackDamage2:AttackDamage = otherSprite.AttackDataObj.getAttackBoxData(otherSprite.AttackStateData.Frame,hBoxResult.SecondHitBox.Name).syncState(otherSprite.AttackCache);
         var totalDamage1:Number = Utils.calculateChargeDamage(attackDamage1);
         var totalDamage2:Number = Utils.calculateChargeDamage(attackDamage2);
         var nonDamagingReverseBox:Boolean = attackDamage1.Damage === 0 && attackDamage1.ReverseProjectile && otherSprite is Projectile || attackDamage1.Damage === 0 && attackDamage1.ReverseItem && otherSprite is Item || attackDamage1.Damage === 0 && attackDamage1.ReverseCharacter && otherSprite is Character || attackDamage2.Damage === 0 && attackDamage2.ReverseItem;
         var nonDamagingProjectileHitStun:Boolean = attackDamage1.Damage === 0 && Boolean(attackDamage1.HitStunProjectile) && otherSprite is Projectile;
         if(!attackDamage1.HasEffect || !attackDamage2.HasEffect || isInvincible() || otherSprite.isInvincible() || attackDamage1.IsThrow || attackDamage2.IsThrow || (!m_collision.ground || !otherSprite.CollisionObj.ground || attackDamage1.IsAirAttack || attackDamage2.IsAirAttack) && inState(IState.HOLD) || !this.validateHit(attackDamage2) || !otherSprite.validateHit(attackDamage1) || nonDamagingReverseBox || nonDamagingProjectileHitStun)
         {
            return false;
         }
         if(!(attackDamage1.PlayerID == attackDamage2.PlayerID && !attackDamage1.HurtSelf) && !(attackDamage1.TeamID > 0 && attackDamage1.TeamID == attackDamage2.TeamID && (attackDamage1.HurtSelf || STAGEDATA.TeamDamage)))
         {
            if(Utils.fastAbs(totalDamage1 - totalDamage2) < 8 && attackDamage1.Priority != -1 && attackDamage2.Priority != -1)
            {
               if(m_attack.HasClanked || otherSprite.AttackStateData.HasClanked || otherSprite is Item && !Item(otherSprite).PickedUp || !this.m_pickedUp)
               {
                  return false;
               }
               if(m_hurtInterrupt != null && Boolean(m_hurtInterrupt({
                  "target":(Boolean(otherSprite.APIInstance) ? otherSprite.APIInstance.instance : null),
                  "attackBoxData":null,
                  "collisionRect":hBoxResult.OverlapHitBox.BoundingBox
               })))
               {
                  return false;
               }
               m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.ATTACK_COLLIDE,{
                  "caller":this.APIInstance.instance,
                  "receiver":otherSprite.APIInstance.instance,
                  "callerAttackBoxData":attackDamage1.exportAttackDamageData(),
                  "receiverAttackBoxData":attackDamage2.exportAttackDamageData()
               }));
               otherSprite.EventManagerObj.dispatchEvent(new SSF2Event(SSF2Event.ATTACK_COLLIDE,{
                  "caller":otherSprite.APIInstance.instance,
                  "receiver":this.APIInstance.instance,
                  "callerAttackBoxData":attackDamage2.exportAttackDamageData(),
                  "receiverAttackBoxData":attackDamage1.exportAttackDamageData()
               }));
               m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.ATTACK_CLANK,{
                  "caller":this.APIInstance.instance,
                  "receiver":otherSprite.APIInstance.instance,
                  "callerAttackBoxData":attackDamage1.exportAttackDamageData(),
                  "receiverAttackBoxData":attackDamage2.exportAttackDamageData()
               }));
               otherSprite.EventManagerObj.dispatchEvent(new SSF2Event(SSF2Event.ATTACK_CLANK,{
                  "caller":otherSprite.APIInstance.instance,
                  "receiver":this.APIInstance.instance,
                  "callerAttackBoxData":attackDamage2.exportAttackDamageData(),
                  "receiverAttackBoxData":attackDamage1.exportAttackDamageData()
               }));
               STAGEDATA.playSpecificSound("reflected");
               attachEffect("effect_cancel",Boolean(hBoxResult) && Boolean(hBoxResult.OverlapHitBox) ? {
                  "x":hBoxResult.OverlapHitBox.centerx,
                  "y":hBoxResult.OverlapHitBox.centery,
                  "absolute":true
               } : null);
               CAM.shake(15);
               this.clang(attackDamage2,hBoxResult);
               return true;
            }
            if(totalDamage1 - totalDamage2 >= 8 && attackDamage1.Priority != -1 && attackDamage2.Priority != -1)
            {
               if(m_hurtInterrupt != null && Boolean(m_hurtInterrupt({
                  "target":(Boolean(otherSprite.APIInstance) ? otherSprite.APIInstance.instance : null),
                  "attackBoxData":null,
                  "collisionRect":hBoxResult.OverlapHitBox.BoundingBox
               })))
               {
                  return false;
               }
               m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.ATTACK_COLLIDE,{
                  "caller":this.APIInstance.instance,
                  "receiver":otherSprite.APIInstance.instance,
                  "callerAttackBoxData":attackDamage1.exportAttackDamageData(),
                  "receiverAttackBoxData":attackDamage2.exportAttackDamageData()
               }));
               otherSprite.EventManagerObj.dispatchEvent(new SSF2Event(SSF2Event.ATTACK_COLLIDE,{
                  "caller":otherSprite.APIInstance.instance,
                  "receiver":this.APIInstance.instance,
                  "callerAttackBoxData":attackDamage2.exportAttackDamageData(),
                  "receiverAttackBoxData":attackDamage1.exportAttackDamageData()
               }));
               if(otherSprite.takeDamage(attackDamage1,hBoxResult.OverlapHitBox))
               {
                  this.handleHit(otherSprite,attackDamage1,hBoxResult);
               }
               return true;
            }
            if(totalDamage1 - totalDamage2 <= -8 && attackDamage1.Priority != -1 && attackDamage2.Priority != -1)
            {
               if(m_hurtInterrupt != null && Boolean(m_hurtInterrupt({
                  "target":(Boolean(otherSprite.APIInstance) ? otherSprite.APIInstance.instance : null),
                  "attackBoxData":null,
                  "collisionRect":hBoxResult.OverlapHitBox.BoundingBox
               })))
               {
                  return false;
               }
               m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.ATTACK_COLLIDE,{
                  "caller":this.APIInstance.instance,
                  "receiver":otherSprite.APIInstance.instance,
                  "callerAttackBoxData":attackDamage1.exportAttackDamageData(),
                  "receiverAttackBoxData":attackDamage2.exportAttackDamageData()
               }));
               otherSprite.EventManagerObj.dispatchEvent(new SSF2Event(SSF2Event.ATTACK_COLLIDE,{
                  "caller":otherSprite.APIInstance.instance,
                  "receiver":this.APIInstance.instance,
                  "callerAttackBoxData":attackDamage2.exportAttackDamageData(),
                  "receiverAttackBoxData":attackDamage1.exportAttackDamageData()
               }));
               if(this.takeDamage(attackDamage2,hBoxResult.OverlapHitBox))
               {
                  otherSprite.handleHit(this,attackDamage2,hBoxResult);
               }
               return true;
            }
         }
         return false;
      }
      
      override public function clang(attackBoxData:AttackDamage, hBoxResult:HitBoxCollisionResult) : void
      {
         initDelayPlayback(true);
         stackAttackID(attackBoxData.AttackID);
         m_skipAttackCollisionTests = true;
         if(Boolean(this.m_currentHolder) && this.m_pickedUp)
         {
            this.m_currentHolder.clang(attackBoxData,hBoxResult);
         }
         else
         {
            startActionShot(attackBoxData.HitStun);
         }
      }
      
      override public function handleHit(otherSprite:InteractiveSprite, attackBoxData:AttackDamage, hBoxResult:HitBoxCollisionResult) : void
      {
         m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.ATTACK_HIT,{
            "caller":this.APIInstance.instance,
            "receiver":otherSprite.APIInstance.instance,
            "attackBoxData":attackBoxData.exportAttackDamageData()
         }));
         startActionShot(Utils.calculateSelfHitStun(attackBoxData.SelfHitStun,Utils.calculateChargeDamage(attackBoxData)));
         if(Boolean(attackBoxData.ReverseCharacter) && Boolean(otherSprite as Character) || Boolean(attackBoxData.ReverseProjectile) && Boolean(otherSprite as Projectile) || Boolean(attackBoxData.ReverseItem) && Boolean(otherSprite as Item))
         {
            if(otherSprite.reverse(attackBoxData.PlayerID,attackBoxData.TeamID,attackBoxData.IsForward))
            {
               otherSprite.EventManagerObj.dispatchEvent(new SSF2Event(SSF2Event.REVERSE,{
                  "caller":otherSprite.APIInstance.instance,
                  "opponent":this.APIInstance.instance,
                  "attackBoxData":attackBoxData.exportAttackDamageData()
               }));
               m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.REVERSE_HIT,{
                  "caller":this.APIInstance.instance,
                  "opponent":otherSprite.APIInstance.instance,
                  "attackBoxData":attackBoxData.exportAttackDamageData()
               }));
            }
         }
      }
      
      override public function cancelAttack(attackBoxData:AttackDamage, hBoxResult:HitBoxCollisionResult) : void
      {
         m_skipAttackCollisionTests = true;
         if(this.m_pickedUp && Boolean(this.m_currentHolder))
         {
            this.m_currentHolder.cancelAttack(attackBoxData,hBoxResult);
         }
         else
         {
            this.destroy();
         }
      }
      
      override public function reactionHit(otherSprite:InteractiveSprite, hBoxResult:HitBoxCollisionResult) : Boolean
      {
         var attackDamage:AttackDamage = m_attackData.getAttackBoxData(m_attackCache.Frame,hBoxResult.FirstHitBox.Name).syncState(m_attackCache);
         m_attack.RefreshRateReady = true;
         if(otherSprite.takeDamage(attackDamage,hBoxResult.OverlapHitBox))
         {
            m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.ATTACK_CONNECT,{
               "caller":this.APIInstance.instance,
               "receiver":otherSprite.APIInstance.instance,
               "attackBoxData":attackDamage.exportAttackDamageData()
            }));
            this.handleHit(otherSprite,attackDamage,hBoxResult);
            return true;
         }
         if(otherSprite.validateHit(attackDamage,true) && otherSprite.isInvincible())
         {
            m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.ATTACK_CONNECT,{
               "caller":this.APIInstance.instance,
               "receiver":otherSprite.APIInstance.instance,
               "attackBoxData":attackDamage.exportAttackDamageData()
            }));
            return true;
         }
         return false;
      }
      
      override public function reactionTouch(otherSprite:InteractiveSprite, hBoxResult:HitBoxCollisionResult) : Boolean
      {
         if(!otherSprite.Invincible)
         {
            m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.ITEM_TOUCH,{
               "caller":this.APIInstance.instance,
               "receiver":otherSprite.APIInstance.instance
            }));
            return true;
         }
         return false;
      }
      
      override public function attackCollisionTest() : void
      {
         if(m_bypassCollisionTesting || !m_hitBoxManager.HasHitBoxes || m_attackCollisionTestsPreProcessed)
         {
            return;
         }
         var i:int = 0;
         var opponent:Character = null;
         var enemy:Enemy = null;
         var projectile:Projectile = null;
         var item:Item = null;
         var collisionRect:Vector.<HitBoxCollisionResult> = null;
         var hBoxArr:Array = null;
         var target:TargetTestTarget = null;
         m_attackCache.syncState(m_attack);
         i = 0;
         while(i < STAGEDATA.Characters.length && !inState(IState.DEAD))
         {
            opponent = STAGEDATA.Characters[i];
            if(opponent != null && !opponent.StandBy && !opponent.Dead && !opponent.inState(CState.STAR_KO) && !opponent.inState(CState.SCREEN_KO) && !opponent.inState(CState.REVIVAL))
            {
               InteractiveSprite.hitTest(this,opponent,HitBoxSprite.ATTACK,HitBoxSprite.SHIELD,this.reactionShield,STAGEDATA.HitBoxProcessorInstance);
               if(InteractiveSprite.hitTest(this,opponent,HitBoxSprite.MASTER,HitBoxSprite.MASTER,reactionMaster).length)
               {
                  InteractiveSprite.hitTest(this,opponent,HitBoxSprite.ATTACK,HitBoxSprite.ATTACK,this.reactionClank,STAGEDATA.HitBoxProcessorInstance);
                  InteractiveSprite.hitTest(this,opponent,HitBoxSprite.ATTACK,HitBoxSprite.ABSORB,this.reactionAbsorb,STAGEDATA.HitBoxProcessorInstance);
                  InteractiveSprite.hitTest(this,opponent,HitBoxSprite.ATTACK,HitBoxSprite.HIT,this.reactionHit,STAGEDATA.HitBoxProcessorInstance);
                  InteractiveSprite.hitTest(this,opponent,HitBoxSprite.ATTACK,HitBoxSprite.EGG,this.reactionHit,STAGEDATA.HitBoxProcessorInstance);
                  InteractiveSprite.hitTest(this,opponent,HitBoxSprite.ATTACK,HitBoxSprite.FREEZE,this.reactionHit,STAGEDATA.HitBoxProcessorInstance);
                  InteractiveSprite.hitTest(this,opponent,HitBoxSprite.COUNTER,HitBoxSprite.ATTACK,this.reactionCounter,STAGEDATA.HitBoxProcessorInstance);
                  InteractiveSprite.hitTest(this,opponent,HitBoxSprite.HIT,HitBoxSprite.HIT,this.reactionTouch,STAGEDATA.HitBoxProcessorInstance);
                  InteractiveSprite.hitTest(opponent,this,HitBoxSprite.CATCH,HitBoxSprite.HIT,opponent.reactionCatch,STAGEDATA.HitBoxProcessorInstance);
                  InteractiveSprite.hitTest(opponent,this,HitBoxSprite.CATCH,HitBoxSprite.CATCH,opponent.reactionCatch,STAGEDATA.HitBoxProcessorInstance);
               }
            }
            i++;
         }
         if(Boolean(this.m_currentHolder))
         {
            InteractiveSprite.hitTest(this,this.m_currentHolder,HitBoxSprite.ATTACK,HitBoxSprite.SHIELD,this.reactionShield,STAGEDATA.HitBoxProcessorInstance);
            InteractiveSprite.hitTest(this,this.m_currentHolder,HitBoxSprite.ATTACK,HitBoxSprite.HIT,this.reactionHit,STAGEDATA.HitBoxProcessorInstance);
            InteractiveSprite.hitTest(this,this.m_currentHolder,HitBoxSprite.HIT,HitBoxSprite.HIT,this.reactionTouch,STAGEDATA.HitBoxProcessorInstance);
         }
         i = 0;
         while(i < STAGEDATA.Projectiles.length && !inState(IState.DEAD))
         {
            projectile = STAGEDATA.Projectiles[i];
            if(projectile != null)
            {
               if(InteractiveSprite.hitTest(this,projectile,HitBoxSprite.MASTER,HitBoxSprite.MASTER,reactionMaster).length)
               {
                  InteractiveSprite.hitTest(this,projectile,HitBoxSprite.ATTACK,HitBoxSprite.ATTACK,this.reactionAttackReverse,STAGEDATA.HitBoxProcessorInstance);
                  InteractiveSprite.hitTest(this,projectile,HitBoxSprite.ATTACK,HitBoxSprite.ATTACK,this.reactionClank,STAGEDATA.HitBoxProcessorInstance);
                  InteractiveSprite.hitTest(this,projectile,HitBoxSprite.REVERSE,HitBoxSprite.ATTACK,this.reactionReverse,STAGEDATA.HitBoxProcessorInstance);
                  InteractiveSprite.hitTest(this,projectile,HitBoxSprite.REVERSE,HitBoxSprite.HIT,this.reactionReverse,STAGEDATA.HitBoxProcessorInstance);
                  InteractiveSprite.hitTest(this,projectile,HitBoxSprite.HIT,HitBoxSprite.HIT,this.reactionTouch,STAGEDATA.HitBoxProcessorInstance);
               }
            }
            i++;
         }
         i = 0;
         while(i < STAGEDATA.Enemies.length && !inState(IState.DEAD))
         {
            enemy = STAGEDATA.Enemies[i];
            if(enemy != null)
            {
               if(InteractiveSprite.hitTest(this,enemy,HitBoxSprite.MASTER,HitBoxSprite.MASTER,reactionMaster).length)
               {
                  InteractiveSprite.hitTest(this,enemy,HitBoxSprite.ATTACK,HitBoxSprite.HIT,this.reactionHit,STAGEDATA.HitBoxProcessorInstance);
                  InteractiveSprite.hitTest(this,enemy,HitBoxSprite.HIT,HitBoxSprite.HIT,this.reactionTouch,STAGEDATA.HitBoxProcessorInstance);
                  InteractiveSprite.hitTest(this,enemy,HitBoxSprite.REVERSE,HitBoxSprite.ATTACK,this.reactionReverse,STAGEDATA.HitBoxProcessorInstance);
               }
            }
            i++;
         }
         i = 0;
         while(i < STAGEDATA.ItemsRef.MAXITEMS && !inState(IState.DEAD))
         {
            item = STAGEDATA.ItemsRef.getItemData(i);
            if(item != null && item != this)
            {
               if(InteractiveSprite.hitTest(this,item,HitBoxSprite.MASTER,HitBoxSprite.MASTER,reactionMaster).length)
               {
                  InteractiveSprite.hitTest(this,item,HitBoxSprite.ATTACK,HitBoxSprite.ATTACK,this.reactionAttackReverse,STAGEDATA.HitBoxProcessorInstance);
                  InteractiveSprite.hitTest(this,item,HitBoxSprite.ATTACK,HitBoxSprite.ATTACK,this.reactionClank,STAGEDATA.HitBoxProcessorInstance);
                  InteractiveSprite.hitTest(this,item,HitBoxSprite.REVERSE,HitBoxSprite.ATTACK,this.reactionReverse,STAGEDATA.HitBoxProcessorInstance);
                  InteractiveSprite.hitTest(this,item,HitBoxSprite.REVERSE,HitBoxSprite.HIT,this.reactionReverse,STAGEDATA.HitBoxProcessorInstance);
                  InteractiveSprite.hitTest(this,item,HitBoxSprite.ATTACK,HitBoxSprite.HIT,this.reactionHit,STAGEDATA.HitBoxProcessorInstance);
                  InteractiveSprite.hitTest(this,item,HitBoxSprite.HIT,HitBoxSprite.HIT,this.reactionTouch,STAGEDATA.HitBoxProcessorInstance);
               }
            }
            i++;
         }
         i = 0;
         while(i < STAGEDATA.Targets.length && !inState(IState.DEAD))
         {
            target = STAGEDATA.Targets[i];
            if(target != null)
            {
               if(InteractiveSprite.hitTest(this,target,HitBoxSprite.MASTER,HitBoxSprite.MASTER,reactionMaster).length)
               {
                  InteractiveSprite.hitTest(this,target,HitBoxSprite.ATTACK,HitBoxSprite.HIT,this.reactionHit,STAGEDATA.HitBoxProcessorInstance);
                  InteractiveSprite.hitTest(this,target,HitBoxSprite.HIT,HitBoxSprite.HIT,this.reactionTouch,STAGEDATA.HitBoxProcessorInstance);
               }
            }
            i++;
         }
         if(HasMC)
         {
            m_sprite.stop();
            Utils.recursiveMovieClipPlay(m_sprite,false);
         }
      }
      
      protected function m_checkDeathBounds() : void
      {
         if(Boolean(!inState(IState.DEAD) && !this.m_itemStats.SurviveDeathBounds) && Boolean(STAGEDATA.DeathBounds) && (m_sprite.x < STAGEDATA.DeathBounds.x || m_sprite.x > STAGEDATA.DeathBounds.x + STAGEDATA.DeathBounds.width || m_sprite.y < STAGEDATA.DeathBounds.y || m_sprite.y > STAGEDATA.DeathBounds.y + STAGEDATA.DeathBounds.height))
         {
            STAGEDATA.ItemsRef.killItem(this.m_slot);
         }
      }
      
      override public function reverse(pid:int, team_id:int, isForward:Boolean) : Boolean
      {
         if(this.m_reverseTimer <= 0 && this.m_itemStats.CanBeReversed && inState(IState.TOSS) && this.m_reverse_id !== pid && !(!this.m_wasReversed && pid === m_player_id) && !(team_id == m_team_id && m_team_id > 0 && !STAGEDATA.TeamDamage))
         {
            if(isForward)
            {
               m_attack.IsForward = true;
               this.m_faceRight();
            }
            else
            {
               m_attack.IsForward = false;
               this.m_faceLeft();
            }
            this.m_reverseTimer = 5;
            this.m_reverse_id = pid;
            m_team_id = team_id;
            m_player_id = pid;
            this.m_wasReversed = true;
            m_xSpeed *= -1;
            m_ySpeed *= -1;
            if(Boolean(this.m_owner))
            {
               this.setOwnerAPI(STAGEDATA.getPlayerByID(pid));
            }
            return true;
         }
         return false;
      }
      
      protected function m_checkDead() : void
      {
         this.checkDeadProjectiles();
         if(this.m_itemStats.TimeMax > 0 && !inState(IState.DEAD) && !this.m_pickedUp)
         {
            ++this.m_time;
            if(this.m_time >= this.m_itemStats.TimeMax && !this.m_pickedUp && m_collision.ground)
            {
               this.destroy();
            }
         }
      }
      
      private function m_calcFlyingAngle() : void
      {
         var angle:Number = NaN;
         if(this.m_itemStats.Rotate && !(m_xSpeed == 0 && m_ySpeed == 0))
         {
            angle = Utils.getAngleBetween(new Point(0,0),new Point(m_xSpeed,m_ySpeed));
            angle = Utils.forceBase360(m_facingForward ? -angle : -angle + 180);
            m_sprite.rotation = angle;
         }
      }
      
      protected function setVar(varName:String, varValue:*) : void
      {
         m_sprite[varName] = varValue;
      }
      
      protected function getVar(varName:String, varValue:*) : Boolean
      {
         if(m_sprite[varName] == varValue)
         {
            return true;
         }
         return false;
      }
      
      public function get Dangerous() : Boolean
      {
         return this.m_itemStats.Dangerous;
      }
      
      public function get InheritPalette() : Boolean
      {
         return this.m_itemStats.InheritPalette;
      }
      
      public function get ItemInstance() : MovieClip
      {
         return m_sprite;
      }
      
      public function get SlideDecay() : Number
      {
         return this.m_itemStats.SlideDecay;
      }
      
      public function get TossSpeed() : Number
      {
         return this.m_itemStats.TossSpeed;
      }
      
      public function get Slot() : Number
      {
         return this.m_slot;
      }
      
      public function get OriginalPlayerID() : int
      {
         return this.m_originalPlayerID;
      }
      
      public function set OriginalPlayerID(value:int) : void
      {
         this.m_originalPlayerID = value;
      }
      
      public function get PlayerID() : int
      {
         return m_player_id;
      }
      
      public function set PlayerID(value:int) : void
      {
         m_player_id = value;
      }
      
      public function get TeamID() : int
      {
         return m_team_id;
      }
      
      public function set TeamID(value:int) : void
      {
         m_team_id = value;
      }
      
      public function get Dead() : Boolean
      {
         return inState(IState.DEAD);
      }
      
      public function get ItemStats() : ItemData
      {
         return this.m_itemStats;
      }
      
      public function get PickedUp() : Boolean
      {
         return this.m_pickedUp;
      }
      
      public function set PickedUp(value:Boolean) : void
      {
         if(value)
         {
            this.m_bounce_remaining = 0;
         }
         this.m_pickedUp = value;
         if(this.m_pickedUp)
         {
            stopActionShot();
            this.m_lastReleaseTimer = 999;
            this.toHeld();
         }
         else
         {
            this.m_previousHolder = this.m_currentHolder;
            this.m_currentHolder = null;
            this.m_lastReleaseTimer = 0;
            m_sprite.alpha = 1;
            this.toIdle();
            resetRotation();
         }
      }
      
      public function get CurrentAttackState() : AttackState
      {
         return m_attack;
      }
      
      public function get EffectSound() : String
      {
         return this.m_effectSound;
      }
      
      public function get LinkageID() : String
      {
         return this.m_linkage_id;
      }
      
      public function get CanPickup() : Boolean
      {
         return this.m_itemStats.CanPickup;
      }
      
      public function get CanBeReversed() : Boolean
      {
         return this.m_itemStats.CanBeReversed;
      }
      
      public function get CanBackToss() : Boolean
      {
         return this.m_itemStats.CanBackToss;
      }
      
      public function get CanJumpWith() : Boolean
      {
         return this.m_itemStats.CanJumpWith;
      }
      
      public function get CanAttackWith() : Boolean
      {
         return this.m_itemStats.CanAttackWith;
      }
      
      public function get CanHangWith() : Boolean
      {
         return this.m_itemStats.CanHangWith;
      }
      
      public function get CanShieldWith() : Boolean
      {
         return this.m_itemStats.CanShieldWith;
      }
      
      public function get LastProjectile() : Projectile
      {
         return this.getCurrentProjectile();
      }
      
      public function get IsSmashBall() : Boolean
      {
         return this.m_itemStats.LinkageID === "smashball";
      }
      
      public function get WasReversed() : Boolean
      {
         return this.m_wasReversed;
      }
      
      public function get JustReversed() : Boolean
      {
         return Boolean(this.m_reverseTimer > 0);
      }
      
      public function set LetGo(value:Boolean) : void
      {
         m_attack.LetGo = value;
      }
      
      public function get ClassID() : String
      {
         return this.m_itemStats.ClassID;
      }
      
      public function get DisableFlip() : Boolean
      {
         return this.m_itemStats.DisableFlip;
      }
      
      public function get ReleaseTimer() : int
      {
         return this.m_lastReleaseTimer;
      }
      
      public function get WasZDropped() : Boolean
      {
         return this.m_wasZDropped;
      }
      
      public function get FrameInterrupt() : Function
      {
         return this.m_frameInterrupt;
      }
      
      public function set FrameInterrupt(fn:Function) : void
      {
         this.m_frameInterrupt = fn;
      }
      
      public function get PreviousHolder() : Character
      {
         return this.m_previousHolder;
      }
      
      public function getOwner() : InteractiveSprite
      {
         return this.m_owner;
      }
      
      public function resetTime() : void
      {
         this.m_time = 0;
      }
      
      public function getDangerous() : Boolean
      {
         return this.m_itemStats.Dangerous;
      }
      
      public function getItemStat(statName:String) : *
      {
         return this.m_itemStats.getVar(statName);
      }
      
      public function updateItemStats(statValues:Object) : void
      {
         this.m_itemStats.importData(statValues);
         this.syncStats();
      }
      
      override protected function syncStats() : void
      {
         m_gravity = this.m_itemStats.Gravity;
         m_max_ySpeed = this.m_itemStats.MaxGravity;
         m_width = this.m_itemStats.Width;
         m_height = this.m_itemStats.Height;
      }
      
      override public function getLinkageID() : String
      {
         return this.m_linkage_id;
      }
      
      public function activate(atkObj:AttackDamage, caller:Class = null) : void
      {
      }
      
      public function reactivate(atkObj:AttackDamage, caller:Class = null) : void
      {
      }
      
      public function SetPlayer(uid:Number) : void
      {
         this.m_currentHolder = STAGEDATA.getCharacterByUID(uid);
         this.m_owner = this.m_currentHolder;
         if(Boolean(this.m_currentHolder))
         {
            m_player_id = this.m_currentHolder.ID;
            this.m_previousHolder = this.m_currentHolder;
            this.m_wasReversed = false;
            m_team_id = this.m_currentHolder.Team;
            m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.ITEM_PICKUP,{
               "caller":this.APIInstance.instance,
               "holder":this.m_currentHolder.APIInstance.instance
            }));
         }
      }
      
      public function inheritPalette() : void
      {
         if(this.m_itemStats.InheritPalette && Boolean(this.m_currentHolder))
         {
            this.m_currentHolder.applyPalette(m_sprite);
            setPaletteSwap(this.m_currentHolder.PaletteSwapData,this.m_currentHolder.PaletteSwapPAData);
         }
      }
      
      protected function findClosestOpponent(excludeID:Number = -1, excludeTeam:Number = 0) : Target
      {
         var opponent:Character = null;
         var dis:Number = NaN;
         var tmpTarget:Target = new Target();
         var found:Boolean = false;
         var currNum:Number = 0;
         for(var i:int = 0; i < STAGEDATA.Characters.length; i++)
         {
            opponent = STAGEDATA.Characters[i];
            if(excludeTeam != opponent.Team && excludeID != opponent.ID && !opponent.StandBy && opponent.MC.parent != null)
            {
               dis = this.getDistanceFrom(opponent.X,opponent.Y);
               if(tmpTarget.CurrentTarget == null || dis < tmpTarget.Distance)
               {
                  tmpTarget.CurrentTarget = opponent;
                  tmpTarget.setDistance(new Point(m_sprite.x,m_sprite.y));
               }
            }
         }
         if(tmpTarget.CurrentTarget == null)
         {
            return null;
         }
         return tmpTarget;
      }
      
      public function Toss(x:Number, y:Number, speed:Number, angle:Number, zdropped:Boolean = false) : void
      {
         this.m_wasZDropped = zdropped;
         this.PickedUp = false;
         m_sprite.x = x;
         m_sprite.y = y;
         m_xSpeed = Utils.calculateXSpeed(speed,angle);
         m_ySpeed = -Utils.calculateYSpeed(speed,angle);
         unnattachFromGround();
         this.Attack(Item.ATTACK_TOSS,m_facingForward);
         m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.ITEM_TOSSED,{
            "caller":this.APIInstance.instance,
            "opponent":(Boolean(this.m_currentHolder) ? this.m_currentHolder.APIInstance.instance : null)
         }));
      }
      
      public function Drop(zDropped:Boolean = false) : void
      {
         m_xSpeed = 0;
         m_ySpeed = 0;
         this.m_wasZDropped = zDropped;
         this.PickedUp = false;
         this.playGlobalSound("itemdrop");
      }
      
      override protected function validateBypass(attackObj:AttackDamage) : Boolean
      {
         if(attackObj.BypassItems)
         {
            return false;
         }
         if(attackObj.BypassNonGrabbed)
         {
            return false;
         }
         if(Boolean(attackObj.Owner as Projectile && attackObj.BypassNonLatched) && Boolean(Projectile(attackObj.Owner).Latched) && Projectile(attackObj.Owner).LatchID == this)
         {
            return false;
         }
         return true;
      }
      
      override public function validateHit(attackObj:AttackDamage, ignoreInvincible:Boolean = false, ignoreIntangible:Boolean = false) : Boolean
      {
         if(!super.validateHit(attackObj,ignoreInvincible,ignoreIntangible) || inState(IState.DEAD))
         {
            return false;
         }
         return true;
      }
      
      override public function takeDamage(attackObj:AttackDamage, collisionHitBox:HitBoxSprite = null) : Boolean
      {
         var angle:Number = NaN;
         var tempDamage:Number = NaN;
         var xVelocity:Number = NaN;
         var yVelocity:Number = NaN;
         var flyingRight:Boolean = false;
         var flyingUp:Boolean = false;
         var effect1MC:MovieClip = null;
         if(!this.validateHit(attackObj,false,true))
         {
            return false;
         }
         var oldDamage:Number = m_damage;
         var preDamage:Number = attackObj.Damage <= 0 ? 0 : Utils.calculateChargeDamage(attackObj);
         var sizeMultiplier:Number = attackObj.SizeStatus == 0 ? 1 : (attackObj.SizeStatus > 0 ? 2 : 0.5);
         var tempVelocity:Number = 0;
         var tempKnockback:Number = 0;
         if(attackObj.HasEffect || !attackObj.HasEffect && !(isIntangible() && attackObj.Damage > 0))
         {
            if(m_hurtInterrupt != null && Boolean(m_hurtInterrupt({
               "target":(Boolean(attackObj.Owner) && Boolean(attackObj.Owner.APIInstance) ? attackObj.Owner.APIInstance.instance : null),
               "attackBoxData":attackObj.exportAttackDamageData(),
               "collisionRect":(Boolean(collisionHitBox) ? collisionHitBox.BoundingBox : null)
            })))
            {
               return false;
            }
            initDelayPlayback(false);
            angle = 0;
            if(m_attack.ChargeRetain)
            {
               m_attack.ChargeTime = 0;
            }
            tempDamage = attackObj.Damage <= 0 ? 0 : Utils.calculateChargeDamage(attackObj);
            tempDamage *= attackObj.StaleMultiplier;
            if(attackObj.Damage > 0 && tempDamage <= 0)
            {
               tempDamage = 1;
            }
            stackAttackID(attackObj.AttackID);
            if(attackObj.Power >= 0)
            {
               if(Boolean(attackObj.Owner as Projectile) && attackObj.ChargeTimeMax > 0)
               {
                  tempVelocity = attackObj.ChargeTimeMax > 0 ? (0.25 + 1 * (attackObj.ChargeTime / attackObj.ChargeTimeMax)) * attackObj.Power + 10 * attackObj.KBConstant * 1 / 1 : attackObj.Power + 10 * attackObj.KBConstant * 1 / 1;
               }
               else
               {
                  tempVelocity = attackObj.ChargeTimeMax > 0 ? (0.85 + 0.25 * (attackObj.ChargeTime / attackObj.ChargeTimeMax)) * attackObj.Power + 10 * attackObj.KBConstant * 1 / 1 : attackObj.Power + 10 * attackObj.KBConstant * 1 / 1;
               }
               if(tempVelocity < 2550)
               {
               }
               tempVelocity = tempVelocity;
            }
            else
            {
               tempVelocity = -attackObj.Power;
            }
            tempVelocity /= 100;
            if(m_collision.ground)
            {
               if(angle > 180 && angle < 360)
               {
                  angle = 360 - angle;
               }
            }
            if(!attackObj.IsForward)
            {
               angle = 180 - angle;
            }
            angle = Utils.forceBase360(angle);
            xVelocity = Math.abs(tempVelocity * Math.cos(angle * Math.PI / 180));
            yVelocity = Math.abs(tempVelocity * Math.sin(angle * Math.PI / 180));
            flyingRight = angle >= 0 && angle < 90 || angle >= 270 && angle < 360 ? true : false;
            flyingUp = angle >= 0 && angle < 180 ? true : false;
            if(yVelocity > 50 && !flyingUp)
            {
               yVelocity = 50;
            }
            if(!this.IsSmashBall)
            {
               angle = Utils.calculateReversedAngle(Utils.calculateAttackDirection(attackObj,this),attackObj,this);
               if(attackObj.EffectID != null && attackObj.EffectID != null && Boolean(STAGEDATA.getQualitySettings().hit_effects))
               {
                  effect1MC = attachHurtEffect(attackObj.EffectID,collisionHitBox,{
                     "scaleX":(0.25 + 0.75 * Math.min(attackObj.Damage / 16,1)) * sizeMultiplier,
                     "scaleY":(0.25 + 0.75 * Math.min(attackObj.Damage / 16,1)) * sizeMultiplier
                  });
                  if(Boolean(effect1MC))
                  {
                     effect1MC.rotation = attackObj.IsForward ? 180 - angle : -angle;
                  }
               }
               if(attackObj.EffectSound != null)
               {
                  this.playGlobalSound(attackObj.EffectSound);
               }
               if(attackObj.HasEffect)
               {
                  if(m_paralysis)
                  {
                     stopActionShot(false,true);
                     m_paralysisHitCount = 3;
                     startActionShot(Utils.calculateHitStun(attackObj.HitStun,tempDamage,attackObj.Shock,false));
                  }
                  else
                  {
                     startActionShot(Utils.calculateHitStun(attackObj.HitStun,tempDamage,attackObj.Shock,false),attackObj.Paralysis);
                  }
               }
               else
               {
                  startActionShot(-1,attackObj.Paralysis);
               }
            }
            if(this.m_itemStats.Stamina > 0)
            {
               tempKnockback = Utils.calculateKnockback(attackObj.KBConstant,attackObj.Power,attackObj.WeightKB,0,0,this.m_itemStats.Weight1,false,STAGEDATA.GameRef.LevelData.damageRatio,attackObj.AttackRatio);
            }
            else
            {
               tempKnockback = Utils.calculateKnockback(attackObj.KBConstant,attackObj.Power,attackObj.WeightKB,preDamage,oldDamage,this.m_itemStats.Weight1,false,STAGEDATA.GameRef.LevelData.damageRatio,attackObj.AttackRatio);
            }
            tempVelocity = Utils.calculateVelocity(tempKnockback);
            if(this.m_itemStats.CanReceiveKnockback)
            {
               applyKnockbackSpeed(tempVelocity,angle);
               if(m_yKnockback < 0)
               {
                  unnattachFromGround();
               }
            }
            if(this.m_itemStats.CanReceiveDamage)
            {
               setDamage(this.m_itemStats.Stamina > 0 ? m_damage - tempDamage : m_damage + tempDamage);
            }
            if(tempVelocity < Character.HEAVY_KNOCKBACK_THRESHOLD || Utils.calculateHitlag(tempKnockback,attackObj.HitLag) < Character.HEAVY_KNOCKBACK_HITLAG_THRESHOLD)
            {
               if(attackObj.Power >= 1000)
               {
                  CAM.shake(6);
               }
            }
            else
            {
               if(tempVelocity > 35)
               {
                  STAGEDATA.lightFlash(false);
               }
               CAM.shake(12);
            }
            if(attackObj.CamShake > 0)
            {
               CAM.shake(attackObj.CamShake);
            }
            if(!m_attack.DisableLastHitUpdate)
            {
               m_lastHitID = attackObj.PlayerID;
               m_lastHitObject = attackObj;
            }
            m_eventManager.dispatchEvent(new SSF2Event(attackObj.HasEffect ? SSF2Event.ITEM_HURT : SSF2Event.ITEM_WIND,{
               "caller":this.APIInstance.instance,
               "opponent":(Boolean(attackObj.Owner) ? attackObj.Owner.APIInstance.instance : null),
               "attackBoxData":attackObj.exportAttackDamageData(),
               "collisionRect":(Boolean(collisionHitBox) ? collisionHitBox.BoundingBox : null)
            }));
            return true;
         }
         return false;
      }
      
      public function destroy(e:* = null) : void
      {
         this.kill();
      }
      
      public function getHolder() : Character
      {
         return this.m_currentHolder;
      }
      
      public function getOwnerAPI() : *
      {
         if(Boolean(this.m_owner))
         {
            return this.m_owner.APIInstance.instance;
         }
         return null;
      }
      
      public function setOwnerAPI(owner:InteractiveSprite) : void
      {
         this.m_owner = owner;
         m_player_id = Boolean(owner) ? owner.ID : -1;
         if(!owner)
         {
            m_player_id = -1;
            m_team_id = -1;
         }
      }
      
      public function getHolderAPI() : *
      {
         if(Boolean(this.m_currentHolder) && this.m_pickedUp)
         {
            return this.m_currentHolder.APIInstance.instance;
         }
         return null;
      }
      
      public function setHolderAPI(character:Character) : void
      {
         if(Boolean(character) && Boolean(!character.ItemObj) && !this.m_pickedUp)
         {
            m_player_id = character.ID;
            m_team_id = character.Team;
            this.PickedUp = true;
            this.SetPlayer(character.UID);
         }
      }
      
      public function toIdle(e:* = null) : void
      {
         disableDelayPlayback();
         this.Attack(Item.ATTACK_IDLE,m_facingForward);
      }
      
      public function toHeld(e:* = null) : void
      {
         disableDelayPlayback();
         this.Attack(Item.ATTACK_HOLD,m_facingForward);
      }
      
      public function toToss(e:* = null) : void
      {
         if(!this.m_itemStats.CanToss)
         {
            return;
         }
         disableDelayPlayback();
         this.Attack(Item.ATTACK_TOSS,m_facingForward);
      }
      
      private function kill() : void
      {
         if(!inState(IState.DEAD))
         {
            m_skipAttackCollisionTests = true;
            m_skipAttackProcessing = true;
            if(this.m_itemStats.StatsName === "cucco")
            {
               --STAGEDATA.CuccoCount;
            }
            if(this.m_itemStats.StatsName === "assistTrophy")
            {
               --STAGEDATA.AssistCount;
            }
            if(this.m_itemStats.StatsName === "pokeball")
            {
               --STAGEDATA.PokemonCount;
            }
            STAGEDATA.CamRef.deleteTarget(m_sprite);
            STAGEDATA.EventManagerObj.dispatchEvent(new SSF2Event(SSF2Event.GAME_ITEM_DESTROYED,{"item":this.APIInstance.instance}));
            m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.ITEM_DESTROYED,{"caller":this.APIInstance.instance}));
            if(Boolean(this.m_pickedUp) && Boolean(this.m_currentHolder) && Boolean(this.m_currentHolder.ItemObj))
            {
               this.m_currentHolder.dropItem();
            }
            removeFromCamera();
            if(m_sprite != null && m_sprite.parent != null)
            {
               m_sprite.parent.removeChild(m_sprite);
            }
            this.setState(IState.DEAD);
            m_eventManager.removeAllEvents();
            STAGEDATA.ItemsRef.checkDeadItems();
            if(Boolean(m_shadowEffect) && Boolean(m_shadowEffect.parent))
            {
               m_shadowEffect.parent.removeChild(m_shadowEffect);
            }
            m_shadowEffect = null;
            if(Boolean(m_reflectionEffect) && Boolean(m_reflectionEffect.parent))
            {
               m_reflectionEffect.parent.removeChild(m_reflectionEffect);
            }
            m_reflectionEffect = null;
            if(Boolean(this.m_itemStats.DeathEffect))
            {
               attachEffect(this.m_itemStats.DeathEffect);
            }
         }
      }
      
      protected function m_itemFall() : void
      {
         if(!this.m_pickedUp && !m_collision.ground && !this.IsSmashBall && !isHitStunOrParalysis())
         {
            if(m_ySpeed < m_max_ySpeed)
            {
               m_ySpeed += m_gravity;
            }
            if(this.m_itemStats.Ghost)
            {
               m_sprite.y += m_ySpeed;
            }
            else
            {
               m_attemptToMove(0,m_ySpeed);
            }
         }
      }
      
      protected function m_itemMove() : void
      {
         var tmpAngle:Number = NaN;
         var tmpYSpeed:Number = NaN;
         if(!isHitStunOrParalysis() && !this.IsSmashBall)
         {
            applyGroundInfluence();
            tmpAngle = calcGroundAngle();
            tmpYSpeed = 0;
            if(tmpAngle > 20 && m_collision.ground)
            {
               tmpYSpeed = 8;
            }
            else if(tmpAngle < -20 && m_collision.ground)
            {
               tmpYSpeed = -8;
            }
            if(this.m_itemStats.Ghost)
            {
               m_sprite.x += m_xSpeed;
            }
            else if(tmpYSpeed < 0)
            {
               m_attemptToMove(0,tmpYSpeed);
               m_attemptToMove(m_xSpeed,0);
            }
            else if(tmpYSpeed > 0)
            {
               m_attemptToMove(m_xSpeed,0);
               m_attemptToMove(0,tmpYSpeed);
            }
            else
            {
               m_attemptToMove(m_xSpeed,tmpYSpeed);
            }
         }
      }
      
      private function getBounceHeight(ySpeed:int) : Number
      {
         var total:Number = 0;
         while(ySpeed < 0 && m_gravity > 0)
         {
            total -= ySpeed;
            ySpeed += m_gravity;
         }
         return total;
      }
      
      protected function getDistanceFrom(x:Number, y:Number) : Number
      {
         return Math.sqrt(Math.pow(x - m_sprite.x,2) + Math.pow(y - m_sprite.y,2));
      }
      
      protected function checkRichochetTimer() : void
      {
         var num:Number = NaN;
         if(!isHitStunOrParalysis() && inState(IState.TOSS))
         {
            num = 15;
            m_collision.leftSide = m_xSpeed < 0 && Boolean(testTerrainWithCoord(m_sprite.x - num,m_sprite.y - 25));
            m_collision.rightSide = m_xSpeed > 0 && Boolean(testTerrainWithCoord(m_sprite.x + num,m_sprite.y - 25));
            if(!m_collision.ground && (m_collision.rightSide || m_collision.leftSide))
            {
               m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.HIT_WALL,{
                  "caller":this.APIInstance.instance,
                  "left":m_collision.leftSide,
                  "right":m_collision.rightSide,
                  "top":false
               }));
            }
            this.m_richochetTimer.tick();
            if(this.m_richochetTimer.IsComplete)
            {
               this.m_richochetTimer.reset();
               if(!m_collision.ground && m_sprite.y == this.m_richochetY && m_ySpeed < 0 && Boolean(testGroundWithCoord(m_sprite.x,m_sprite.y - this.m_itemStats.Height - 1)))
               {
                  m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.HIT_WALL,{
                     "caller":this.APIInstance.instance,
                     "left":m_xSpeed < 0,
                     "right":m_xSpeed > 0,
                     "top":true
                  }));
               }
            }
            this.m_richochetX = m_sprite.x;
            this.m_richochetY = m_sprite.y;
         }
         else if(isHitStunOrParalysis())
         {
            this.m_richochetTimer.reset();
         }
      }
      
      protected function m_checkBounce() : void
      {
         if(!this.m_pickedUp && this.m_bounce_remaining > 0 && inState(IState.IDLE) && m_collision.ground)
         {
            m_ySpeed *= -0.6;
            unnattachFromGround();
            --this.m_bounce_remaining;
         }
         else if(m_collision.ground && this.m_itemStats.Bounce > 0 && m_ySpeed >= 0 && inState(IState.TOSS))
         {
            if(!(this.m_bounce_limit.IsComplete && this.m_bounce_total < this.m_bounce_limit.MaxTime))
            {
               m_ySpeed = -this.m_itemStats.Bounce;
               this.m_itemStats.Bounce *= this.m_itemStats.BounceDecay;
               while(this.m_itemStats.BounceMaxHeight > 0 && this.getBounceHeight(m_ySpeed) > this.m_itemStats.BounceMaxHeight)
               {
                  ++m_ySpeed;
               }
               this.m_bounce_limit.tick();
               unnattachFromGround();
               m_collision.ground = false;
            }
         }
      }
      
      override protected function m_groundCollisionTest() : void
      {
         var m_wasHittingGround:Boolean = false;
         var wasFalling:Boolean = false;
         var onGround:Boolean = false;
         var wasRight:Boolean = false;
         if(!this.IsSmashBall && !this.m_itemStats.Ghost)
         {
            m_wasHittingGround = Boolean(m_collision.ground);
            wasFalling = m_ySpeed > 0;
            if(m_collision.ground && netYSpeed() >= 0)
            {
               attachToGround();
            }
            onGround = (m_currentPlatform = testGroundWithCoord(m_sprite.x,m_sprite.y + 1)) != null;
            m_collision.ground = onGround;
            this.m_checkBounce();
            if(m_collision.ground)
            {
               attachToGround();
            }
            if(!m_wasHittingGround && wasFalling && netYSpeed() < 0)
            {
               STAGEDATA.playSpecificSound(this.m_landSound);
               onGround = false;
               m_currentPlatform = null;
               m_collision.ground = false;
            }
            if(!inState(IState.DEAD) && m_collision.ground && !m_wasHittingGround)
            {
               m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.GROUND_TOUCH,{"caller":this.APIInstance.instance}));
            }
            else if(!inState(IState.DEAD) && !m_collision.ground && m_wasHittingGround)
            {
               m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.GROUND_LEAVE,{"caller":this.APIInstance.instance}));
            }
            if(m_collision.ground && !this.m_pickedUp && !inState(IState.TOSS))
            {
               if(!m_wasHittingGround)
               {
                  STAGEDATA.playSpecificSound(this.m_landSound);
               }
               if(this.m_itemStats.SlideDecay >= 0)
               {
                  m_xSpeed = m_xSpeed < 0 ? -Math.abs(-m_xSpeed * this.m_itemStats.SlideDecay) : m_xSpeed * this.m_itemStats.SlideDecay;
               }
               else if(m_xSpeed != 0)
               {
                  wasRight = m_xSpeed > 0;
                  m_xSpeed -= m_xSpeed > 0 ? Utils.fastAbs(this.m_itemStats.SlideDecay) : -Utils.fastAbs(this.m_itemStats.SlideDecay);
                  if(wasRight && m_xSpeed < 0 || !wasRight && m_xSpeed > 0)
                  {
                     m_xSpeed = 0;
                  }
                  if(Utils.fastAbs(m_xSpeed) <= 0.5)
                  {
                     m_xSpeed = 0;
                  }
               }
            }
         }
      }
      
      override public function currentStanceFrameIs(s:String) : Boolean
      {
         return m_sprite.stance.frame == s ? true : false;
      }
      
      public function pushAway(toTheRight:Boolean, speed:int = 1) : void
      {
         if(!isHitStunOrParalysis() && this.m_itemStats.CanBePushed && !this.m_itemStats.Ghost)
         {
            if(m_collision.ground && m_xSpeed == 0)
            {
               if(toTheRight && !m_collision.rightSide)
               {
                  m_attemptToMove(speed,0);
                  attachToGround();
               }
               else if(!toTheRight && !m_collision.leftSide)
               {
                  m_attemptToMove(-speed,0);
                  attachToGround();
               }
            }
         }
      }
      
      protected function m_pushAwayOpponents() : void
      {
         var i:int = 0;
         var opponent:Character = null;
         var theirRect:Rectangle = null;
         var myRect:Rectangle = null;
         if(this.m_itemStats.PushCharacters && m_collision.ground && !this.m_pickedUp && this.m_itemStats.PushCharacters && !inState(IState.DEAD))
         {
            for(i = 0; i < STAGEDATA.Characters.length; i++)
            {
               opponent = STAGEDATA.Characters[i];
               if(!(!m_collision.ground || !opponent || !opponent.CollisionObj.ground || !InteractiveSprite.hitTest(this,opponent,HitBoxSprite.MASTER,HitBoxSprite.MASTER,reactionMaster).length))
               {
                  theirRect = opponent.BoundsRect;
                  myRect = BoundsRect;
                  theirRect.x += opponent.X;
                  theirRect.y += opponent.Y;
                  myRect.x += m_sprite.x;
                  myRect.y += m_sprite.y;
                  if(theirRect.intersects(myRect))
                  {
                     if(m_sprite.x < opponent.X)
                     {
                        opponent.pushAway(true);
                     }
                     else
                     {
                        opponent.pushAway(false);
                     }
                  }
               }
            }
         }
      }
      
      protected function m_pushAwayItems() : void
      {
         var i:int = 0;
         var collisionRect:Vector.<HitBoxCollisionResult> = null;
         var item:Item = null;
         var theirRect:Rectangle = null;
         var myRect:Rectangle = null;
         if(m_collision.ground && !this.m_pickedUp && !this.IsSmashBall && !inState(IState.DEAD))
         {
            for(i = 0; i < STAGEDATA.ItemsRef.ItemsInUse.length; i++)
            {
               collisionRect = null;
               item = STAGEDATA.ItemsRef.ItemsInUse[i];
               if(!(!item || i === this.m_slot || item.Dead || item.PickedUp || !item.Ground || !item.ItemStats.CanBePushed))
               {
                  theirRect = item.BoundsRect;
                  myRect = BoundsRect;
                  theirRect.x += item.X;
                  theirRect.y += item.Y;
                  myRect.x += m_sprite.x;
                  myRect.y += m_sprite.y;
                  if(theirRect.intersects(myRect))
                  {
                     if(m_sprite.x > item.X)
                     {
                        item.pushAway(false);
                     }
                     else if(m_sprite.x < item.X)
                     {
                        item.pushAway(true);
                     }
                     else if(m_sprite.x == item.X)
                     {
                        item.pushAway(true);
                        this.pushAway(false);
                     }
                  }
               }
            }
         }
      }
      
      override public function setState(state:uint) : void
      {
         var changedStates:Boolean = state != m_state;
         var oldState:uint = m_state;
         m_state = state;
         if(changedStates)
         {
            m_framesSinceLastState = 0;
            m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.STATE_CHANGE,{
               "caller":this.APIInstance.instance,
               "fromState":oldState,
               "toState":m_state
            }));
            flushTimers();
            removeAllTempEvents();
            this.m_controlFrames();
         }
      }
      
      public function playGlobalSound(soundID:String) : int
      {
         return STAGEDATA.SoundQueueRef.playSoundEffect(soundID);
      }
      
      override protected function m_faceRight() : void
      {
         if(m_delayPlayback)
         {
            m_delayPlayBackFacingRight = true;
         }
         if(!this.m_itemStats.DisableFlip && !m_delayPlayback)
         {
            m_sprite.scaleX = Math.abs(m_sprite.scaleX);
         }
         m_facingForward = true;
      }
      
      override protected function m_faceLeft() : void
      {
         if(m_delayPlayback)
         {
            m_delayPlayBackFacingRight = false;
         }
         if(!this.m_itemStats.DisableFlip && !m_delayPlayback)
         {
            m_sprite.scaleX = -Math.abs(m_sprite.scaleX);
         }
         m_facingForward = false;
      }
      
      override protected function m_controlFrames() : void
      {
         if(m_state == IState.IDLE)
         {
            playFrame(m_attack.Frame);
         }
         else if(m_state == IState.HOLD)
         {
            playFrame(m_attack.Frame);
         }
         else if(m_state == IState.TOSS)
         {
            playFrame(m_attack.Frame);
         }
         else if(m_state == IState.DEAD)
         {
         }
      }
      
      override protected function checkTimers() : void
      {
         super.checkTimers();
         if(this.m_pickedUp)
         {
            this.m_lastReleaseTimer = 999;
         }
         else if(Boolean(this.m_previousHolder))
         {
            ++this.m_lastReleaseTimer;
         }
      }
      
      override public function PERFORMALL() : void
      {
         this.PREPERFORM();
         if(!STAGEDATA.FSCutscene && STAGEDATA.FSCutins <= 0)
         {
            if(this.m_pickedUp && !inState(IState.DEAD))
            {
               this.checkTimers();
               this.m_itemAttack();
               checkReflection();
               this.m_checkDead();
            }
            else if(!this.m_pickedUp && !inState(IState.DEAD))
            {
               this.checkTimers();
               this.m_pushAwayItems();
               this.m_groundCollisionTest();
               this.m_calcFlyingAngle();
               this.m_itemAttack();
               this.m_checkReverse();
               this.m_itemFall();
               this.m_itemMove();
               m_forces();
               this.m_pushAwayOpponents();
               checkReflection();
               checkShadow();
               this.checkRichochetTimer();
               checkHitStun();
               updateCamerBox();
               this.m_checkDeathBounds();
               this.m_checkDead();
            }
            updateSelfPlatform();
         }
         this.POSTPERFORM();
      }
      
      override protected function PREPERFORM() : void
      {
         m_actionTimerUpdatedOnFrame = false;
         if(!STAGEDATA.FSCutscene && STAGEDATA.FSCutins <= 0)
         {
            if(m_started && HasStance && !inState(IState.DEAD) && !isHitStunOrParalysis() && !m_delayPlayback)
            {
               Utils.advanceFrame(m_sprite.stance);
               Utils.recursiveMovieClipPlay(m_sprite.stance,true);
            }
            else
            {
               handleDelayPlayback();
            }
         }
      }
      
      override protected function POSTPERFORM() : void
      {
         if(!STAGEDATA.FSCutscene && STAGEDATA.FSCutins <= 0)
         {
            super.POSTPERFORM();
            m_apiInstance.update();
         }
      }
   }
}

