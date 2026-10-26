package com.mcleodgaming.ssf2.enemies
{
   import com.mcleodgaming.ssf2.Main;
   import com.mcleodgaming.ssf2.api.*;
   import com.mcleodgaming.ssf2.controllers.MenuController;
   import com.mcleodgaming.ssf2.engine.*;
   import com.mcleodgaming.ssf2.enums.CState;
   import com.mcleodgaming.ssf2.enums.EState;
   import com.mcleodgaming.ssf2.enums.PState;
   import com.mcleodgaming.ssf2.items.Item;
   import com.mcleodgaming.ssf2.platforms.*;
   import com.mcleodgaming.ssf2.util.*;
   import flash.display.MovieClip;
   import flash.geom.Point;
   
   public class Enemy extends InteractiveSprite
   {
      
      protected var m_owner:InteractiveSprite;
      
      protected var m_linkage_id:String;
      
      protected var m_dead:Boolean;
      
      protected var m_x_start:Number;
      
      protected var m_y_start:Number;
      
      protected var m_projectile:Vector.<Projectile>;
      
      protected var m_lastProjectile:int;
      
      protected var m_didDamage:Boolean;
      
      protected var m_didDamageList:Vector.<InteractiveSprite>;
      
      protected var m_beaconTimer:FrameTimer;
      
      protected var m_findTimer:FrameTimer;
      
      protected var m_enemyStats:EnemyStats;
      
      public function Enemy(enemyStats:EnemyStats, stageData:StageData, x_start:Number, y_start:Number, pid:int = -1, mc:MovieClip = null, owner:InteractiveSprite = null)
      {
         m_baseStats = this.m_enemyStats = enemyStats;
         if(!this.m_enemyStats.ClassAPI)
         {
            this.m_enemyStats.importData({"classAPI":stageData.BASE_CLASSES.SSF2Enemy});
         }
         m_apiInstance = new SSF2Enemy(this.m_enemyStats.ClassAPI,this);
         this.m_enemyStats.importData(m_apiInstance.getOwnStats());
         this.m_x_start = x_start;
         this.m_y_start = y_start;
         this.m_linkage_id = this.m_enemyStats.LinkageID;
         stageData.addEnemy(this);
         var tmpMC:MovieClip = Boolean(mc) ? mc : ResourceManager.getLibraryMC(this.m_enemyStats.LinkageID);
         tmpMC.ACTIVE = true;
         super(tmpMC,stageData);
         m_player_id = pid;
         if(m_player_id > 0)
         {
            m_team_id = STAGEDATA.getPlayerByID(m_player_id).Team;
         }
         else
         {
            m_team_id = -1;
         }
         if(pid > 0)
         {
            this.setOwnerAPI(STAGEDATA.getPlayerByID(pid));
         }
         else
         {
            this.setOwnerAPI(owner);
         }
         m_sprite.x = this.m_x_start;
         m_sprite.y = this.m_y_start;
         m_sprite.uid = m_uid;
         this.m_dead = false;
         m_state = EState.IDLE;
         this.m_linkage_id = this.m_enemyStats.LinkageID;
         this.m_projectile = new Vector.<Projectile>();
         var i:Number = 0;
         for(i = 0; i < this.m_enemyStats.MaxProjectile; i++)
         {
            this.m_projectile.push(null);
         }
         this.m_lastProjectile = 0;
         m_attackData = new AttackData(this);
         this.m_beaconTimer = new FrameTimer(150);
         this.m_findTimer = new FrameTimer(5);
         this.m_didDamage = false;
         this.m_didDamageList = new Vector.<InteractiveSprite>();
         m_actionShot = false;
         m_actionTimer = 0;
         m_lastHitID = 0;
         m_lastAttackID = new Array(15);
         m_lastAttackIndex = 0;
         buildHitBoxData(this.m_linkage_id);
         if(Main.DEBUG)
         {
            verifiyHitBoxData();
         }
         this.syncStats();
         m_attackData.importAttacks(m_apiInstance.getAttackStats());
         m_attackData.importItems(m_apiInstance.getItemStats());
         m_attackData.importProjectiles(m_apiInstance.getProjectileStats());
      }
      
      override public function get CurrentAnimation() : HitBoxAnimation
      {
         return m_hitBoxManager == null ? null : (m_hitBoxManager.HitBoxAnimationList.length <= 0 || !m_sprite.currentLabel ? null : m_hitBoxManager.getHitBoxAnimation(this.m_linkage_id + "_" + m_sprite.currentLabel));
      }
      
      public function get Dead() : Boolean
      {
         return this.m_dead;
      }
      
      public function get ProjectileList() : Vector.<Projectile>
      {
         return this.m_projectile;
      }
      
      public function get LinkageID() : String
      {
         return this.m_linkage_id;
      }
      
      public function get PlayerID() : int
      {
         return m_player_id;
      }
      
      public function get TeamID() : int
      {
         return m_team_id;
      }
      
      public function get ProjectileArray() : Vector.<Projectile>
      {
         return this.m_projectile;
      }
      
      public function getOwner() : InteractiveSprite
      {
         return this.m_owner;
      }
      
      override public function getLinkageID() : String
      {
         return this.m_linkage_id;
      }
      
      public function getEnemyStat(statName:String) : *
      {
         return this.m_enemyStats.getVar(statName);
      }
      
      public function updateEnemyStats(statValues:Object) : void
      {
         this.m_enemyStats.importData(statValues);
         this.syncStats();
      }
      
      override protected function syncStats() : void
      {
         m_gravity = this.m_enemyStats.Gravity;
         m_max_ySpeed = this.m_enemyStats.MaxYSpeed;
         m_width = this.m_enemyStats.Width;
         m_height = this.m_enemyStats.Height;
         m_bypassCollisionTesting = this.m_enemyStats.BypassCollisionTesting;
      }
      
      protected function checkDeath() : void
      {
         if(Boolean(!this.m_enemyStats.SurviveDeathBounds) && Boolean(STAGEDATA.DeathBounds) && (m_sprite.x < STAGEDATA.DeathBounds.x || m_sprite.x > STAGEDATA.DeathBounds.x + STAGEDATA.DeathBounds.width || m_sprite.y < STAGEDATA.DeathBounds.y || m_sprite.y > STAGEDATA.DeathBounds.y + STAGEDATA.DeathBounds.height))
         {
            this.destroy();
         }
      }
      
      public function setPlayerID(id:Number) : void
      {
         m_player_id = id;
      }
      
      public function setTeamID(id:Number) : void
      {
         m_team_id = id;
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
         if(Boolean(this.m_owner))
         {
            m_player_id = this.m_owner.ID;
            m_team_id = this.m_owner.Team;
         }
         else
         {
            m_player_id = -1;
            m_team_id = -1;
         }
      }
      
      public function pause() : void
      {
         if(HasStance)
         {
            m_sprite.stance.stop();
            Utils.recursiveMovieClipPlay(m_sprite.stance,false);
         }
      }
      
      public function unpause() : void
      {
         if(HasStance)
         {
            m_sprite.stance.play();
            Utils.recursiveMovieClipPlay(m_sprite.stance,true);
         }
      }
      
      public function destroy() : void
      {
         if(!inState(EState.DEAD))
         {
            m_skipAttackCollisionTests = true;
            m_skipAttackProcessing = true;
            this.m_didDamageList.splice(0,this.m_didDamageList.length);
            m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.ENEMY_DESTROYED,{"caller":this.APIInstance.instance}));
            if(m_sprite.parent != null)
            {
               STAGE.removeChild(m_sprite);
            }
            this.m_dead = true;
            STAGEDATA.removeEnemy(this);
            removeSelfPlatform();
            m_state = EState.DEAD;
            if(Boolean(m_shadowEffect) && Boolean(m_shadowEffect.parent))
            {
               m_shadowEffect.parent.removeChild(m_shadowEffect);
            }
            m_shadowEffect = null;
            if(Boolean(m_reflectionEffect) && Boolean(m_reflectionEffect.parent))
            {
               m_reflectionEffect.parent.removeChild(m_reflectionEffect);
            }
            removeFromCamera();
            m_reflectionEffect = null;
         }
      }
      
      public function destroyInterruptedProjectiles() : void
      {
         for(var k:int = 0; k < this.m_projectile.length; k++)
         {
            if(this.m_projectile[k] != null && !this.m_projectile[k].Visible)
            {
               this.m_projectile[k].destroy();
               this.m_projectile[k] = null;
            }
         }
      }
      
      private function getIndexOfOldestProjectile(statsName:String) : int
      {
         var oldest:int = -1;
         var i:int = 0;
         while(i < this.m_enemyStats.MaxProjectile && i < this.m_projectile.length)
         {
            if(this.m_projectile[i] != null && this.m_projectile[i].ProjectileAttackObj.StatsName == statsName && (oldest < 0 || this.m_projectile[i].Time > this.m_projectile[oldest].Time))
            {
               oldest = i;
            }
            i++;
         }
         return oldest;
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
      
      public function fireProjectile(projData:*, xOverride:Number = 0, yOverride:Number = 0, absolute:Boolean = false, options:Object = null) : Projectile
      {
         var i:int = 0;
         var old:int = 0;
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
            while(i < this.m_enemyStats.MaxProjectile && i < this.m_projectile.length && !success)
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
                     i = this.getIndexOfOldestProjectile(n.LinkageID);
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
                  this.m_projectile[i] = new Projectile({
                     "owner":this,
                     "player_id":m_player_id,
                     "x_start":m_sprite.x,
                     "y_start":m_sprite.y,
                     "sizeRatio":m_sizeRatio,
                     "facingForward":m_facingForward,
                     "chargetime":options.chargetime || 0,
                     "chargetime_max":options.chargetime_max || 0,
                     "frame":n.StatsName + "_proj",
                     "staleMultiplier":1,
                     "sizeStatus":0,
                     "terrains":m_terrains,
                     "platforms":m_platforms,
                     "team_id":m_team_id
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
      
      public function getActiveProjectiles(ignorePID:int, ignoreTeamID:int) : Vector.<Projectile>
      {
         var projectilesArr:Vector.<Projectile> = new Vector.<Projectile>();
         for(var i:int = 0; i < this.m_projectile.length; i++)
         {
            if(this.m_projectile[i] != null && !this.m_projectile[i].Dead && (this.m_projectile[i].ID != ignorePID && !(ignoreTeamID > 0 && this.m_projectile[i].TeamID > 0 && this.m_projectile[i].TeamID == ignoreTeamID) || this.m_projectile[i].WasReversed))
            {
               projectilesArr.push(this.m_projectile[i]);
            }
         }
         return projectilesArr;
      }
      
      public function destroyAllProjectiles() : void
      {
         for(var i:* = 0; i < this.m_projectile.length; i++)
         {
            if(this.m_projectile[i] != null)
            {
               this.m_projectile[i].destroy();
               this.m_projectile[i] = null;
            }
         }
      }
      
      protected function runBeaconTimer() : void
      {
         this.m_beaconTimer.tick();
         if(this.m_beaconTimer.IsComplete)
         {
            if(Boolean(m_currentTarget.BeaconSprite))
            {
               m_shortestPath = null;
               getNearestOpponent("character",true);
            }
            this.m_beaconTimer.reset();
         }
      }
      
      protected function runTargetTimer() : void
      {
         getNearestOpponent("character",true);
         this.m_findTimer.tick();
         if(this.m_findTimer.IsComplete)
         {
            checkPotentialBeaconPath("character",true);
            this.m_findTimer.reset();
         }
      }
      
      protected function performAttackChecks() : void
      {
         var rangle:Number = NaN;
         if(!isHitStunOrParalysis())
         {
            ++m_attack.ExecTime;
            ++m_attack.RefreshRateTimer;
            if(m_attack.RefreshRate > 0 && m_attack.RefreshRateReady && m_attack.RefreshRateTimer % m_attack.RefreshRate == 0)
            {
               m_attack.AttackID = Utils.getUID();
            }
            if(m_attack.Rotate)
            {
               rangle = Utils.getAngleBetween(new Point(),new Point(m_xSpeed,m_ySpeed));
               rangle = Utils.forceBase360(m_facingForward ? -rangle : -rangle + 180);
               m_sprite.rotation = rangle;
            }
         }
         m_attack.XLoc = m_sprite.x;
         m_attack.YLoc = m_sprite.y;
      }
      
      override public function forceAttack(value:String, toFrame:* = null, isSpecial:Boolean = false) : Boolean
      {
         if(value === m_attack.Frame)
         {
            if(Boolean(Main.DEBUG) && Boolean(MenuController.debugConsole) && MenuController.debugConsole.Alerts)
            {
               MenuController.debugConsole.alert("[Warning] forceAttack(\"" + value + "\") was called when the SSF2Enemy object was already using that attack. Call has been aborted");
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
            this.Attack(value);
            if(toFrame !== null)
            {
               stancePlayFrame(toFrame);
            }
            return true;
         }
         return false;
      }
      
      protected function Attack(frame:String) : void
      {
         var atkObj:AttackObject = m_attackData.getAttack(frame);
         if(!atkObj)
         {
            m_attack.Frame = null;
            if(Boolean(frame))
            {
               playFrame(frame);
            }
            return;
         }
         m_attack.IsAttacking = true;
         m_attack.IsAirAttack = !m_collision.ground;
         m_attack.IsForward = m_facingForward;
         m_attack.ExecTime = 0;
         m_attack.HasClanked = false;
         if(m_attack.ResetMovement)
         {
            m_xSpeed = 0;
            m_ySpeed = 0;
         }
         m_attack.RefreshRate = atkObj.RefreshRate;
         m_attack.SuperArmor = atkObj.SuperArmor;
         m_attack.HeavyArmor = atkObj.HeavyArmor;
         m_attack.LaunchResistance = atkObj.LaunchResistance;
         m_attack.Rotate = atkObj.Rotate;
         m_attack.Frame = frame;
         m_attack.AttackID = Utils.getUID();
         m_attack.ID = Utils.getUID();
         playFrame(frame);
      }
      
      override public function reactionShield(otherSprite:InteractiveSprite, hBoxResult:HitBoxCollisionResult) : Boolean
      {
         var opponent:Character = Boolean(otherSprite as Character) ? Character(otherSprite) : null;
         var attackDamage1:AttackDamage = m_attackData.getAttackBoxData(m_attackCache.Frame,hBoxResult.FirstHitBox.Name).syncState(m_attackCache);
         var hBoxArray:Array = null;
         if(Boolean(opponent))
         {
            if(attackDamage1.BypassShield && otherSprite.takeDamage(attackDamage1,hBoxResult.OverlapHitBox))
            {
               m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.ATTACK_CONNECT_SHIELD,{
                  "caller":this.APIInstance.instance,
                  "receiver":otherSprite.APIInstance.instance,
                  "attackBoxData":attackDamage1.exportAttackDamageData()
               }));
               this.handleHit(otherSprite,attackDamage1,hBoxResult);
               return true;
            }
            if(opponent.takeShieldDamage(m_attackData.getAttackBoxData(m_attackCache.Frame,hBoxResult.FirstHitBox.Name).syncState(m_attackCache),hBoxResult.OverlapHitBox))
            {
               m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.ATTACK_CONNECT_SHIELD,{
                  "caller":this.APIInstance.instance,
                  "receiver":otherSprite.APIInstance.instance,
                  "attackBoxData":attackDamage1.exportAttackDamageData()
               }));
               startActionShot(Utils.calculateSelfHitStun(attackDamage1.SelfHitStun,Utils.calculateChargeDamage(attackDamage1)));
               m_eventManager.dispatchEvent(new SSF2Event(Character(otherSprite).PerfectShield ? SSF2Event.ATTACK_HIT_POWER_SHIELD : SSF2Event.ATTACK_HIT_SHIELD,{
                  "caller":this.APIInstance.instance,
                  "receiver":otherSprite.APIInstance.instance,
                  "attackBoxData":attackDamage1.exportAttackDamageData()
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
      
      override public function reactionCounter(otherSprite:InteractiveSprite, hBoxResult:HitBoxCollisionResult) : Boolean
      {
         var attackDamage2:AttackDamage = otherSprite.AttackDataObj.getAttackBoxData(otherSprite.AttackStateData.Frame,hBoxResult.SecondHitBox.Name).syncState(otherSprite.AttackCache);
         if(!this.m_dead && this.validateHit(attackDamage2,true))
         {
            return true;
         }
         return false;
      }
      
      override public function reactionHit(otherSprite:InteractiveSprite, hBoxResult:HitBoxCollisionResult) : Boolean
      {
         var attackDamage:AttackDamage = m_attackData.getAttackBoxData(m_attackCache.Frame,hBoxResult.FirstHitBox.Name).syncState(m_attackCache);
         if(otherSprite.takeDamage(attackDamage,hBoxResult.OverlapHitBox))
         {
            m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.ATTACK_CONNECT,{
               "caller":this.APIInstance.instance,
               "receiver":otherSprite.APIInstance.instance,
               "attackBoxData":attackDamage.exportAttackDamageData()
            }));
            startActionShot(Utils.calculateSelfHitStun(attackDamage.SelfHitStun,Utils.calculateChargeDamage(attackDamage)));
            m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.ATTACK_HIT,{
               "caller":this.APIInstance.instance,
               "receiver":otherSprite.APIInstance.instance,
               "attackBoxData":attackDamage.exportAttackDamageData()
            }));
            this.m_didDamage = true;
            if(this.m_didDamageList.indexOf(otherSprite) < 0)
            {
               this.m_didDamageList.push(otherSprite);
            }
            return true;
         }
         if(otherSprite.validateHit(attackDamage,true) && otherSprite.isInvincible())
         {
            m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.ATTACK_CONNECT,{
               "caller":this.APIInstance.instance,
               "receiver":otherSprite.APIInstance.instance,
               "attackBoxData":attackDamage.exportAttackDamageData()
            }));
            if(Boolean(otherSprite as Character))
            {
               otherSprite.attachEffect("effect_cancel",Boolean(hBoxResult) && Boolean(hBoxResult.OverlapHitBox) ? {
                  "x":hBoxResult.OverlapHitBox.centerx,
                  "y":hBoxResult.OverlapHitBox.centery,
                  "absolute":true
               } : null);
            }
         }
         return false;
      }
      
      override public function handleHit(otherSprite:InteractiveSprite, attackBoxData:AttackDamage, hBoxResult:HitBoxCollisionResult) : void
      {
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
      
      override public function attackCollisionTest() : void
      {
         if(m_bypassCollisionTesting || !m_hitBoxManager.HasHitBoxes || m_attackCollisionTestsPreProcessed)
         {
            return;
         }
         var i:int = 0;
         var opponent:Character = null;
         var enemy:Enemy = null;
         var item:Item = null;
         var projectile:Projectile = null;
         var target:TargetTestTarget = null;
         var collisionRect:Vector.<HitBoxCollisionResult> = null;
         var hBoxArr:Array = null;
         if(!this.m_dead)
         {
            m_attackCache.syncState(m_attack);
            for(i = 0; i < STAGEDATA.Characters.length; i++)
            {
               opponent = STAGEDATA.Characters[i];
               if(opponent != null && !opponent.StandBy && !opponent.Dead && !opponent.inState(CState.STAR_KO) && !opponent.inState(CState.SCREEN_KO) && !opponent.inState(CState.REVIVAL))
               {
                  InteractiveSprite.hitTest(this,opponent,HitBoxSprite.ATTACK,HitBoxSprite.SHIELD,this.reactionShield,STAGEDATA.HitBoxProcessorInstance);
                  if(InteractiveSprite.hitTest(this,opponent,HitBoxSprite.MASTER,HitBoxSprite.MASTER,reactionMaster).length)
                  {
                     InteractiveSprite.hitTest(this,opponent,HitBoxSprite.ATTACK,HitBoxSprite.ABSORB,this.reactionAbsorb,STAGEDATA.HitBoxProcessorInstance);
                     InteractiveSprite.hitTest(this,opponent,HitBoxSprite.ATTACK,HitBoxSprite.HIT,this.reactionHit,STAGEDATA.HitBoxProcessorInstance);
                     InteractiveSprite.hitTest(this,opponent,HitBoxSprite.ATTACK,HitBoxSprite.EGG,this.reactionHit,STAGEDATA.HitBoxProcessorInstance);
                     InteractiveSprite.hitTest(this,opponent,HitBoxSprite.ATTACK,HitBoxSprite.FREEZE,this.reactionHit,STAGEDATA.HitBoxProcessorInstance);
                     InteractiveSprite.hitTest(this,opponent,HitBoxSprite.ATTACK,HitBoxSprite.STAR,this.reactionHit,STAGEDATA.HitBoxProcessorInstance);
                     InteractiveSprite.hitTest(this,opponent,HitBoxSprite.COUNTER,HitBoxSprite.ATTACK,this.reactionCounter,STAGEDATA.HitBoxProcessorInstance);
                  }
               }
            }
            i = 0;
            while(i < STAGEDATA.Projectiles.length && !inState(EState.DEAD))
            {
               projectile = STAGEDATA.Projectiles[i];
               if(projectile != null)
               {
                  if(InteractiveSprite.hitTest(this,projectile,HitBoxSprite.MASTER,HitBoxSprite.MASTER,reactionMaster).length)
                  {
                     InteractiveSprite.hitTest(this,projectile,HitBoxSprite.ATTACK,HitBoxSprite.ATTACK,this.reactionAttackReverse,STAGEDATA.HitBoxProcessorInstance);
                     InteractiveSprite.hitTest(this,projectile,HitBoxSprite.REVERSE,HitBoxSprite.ATTACK,this.reactionReverse,STAGEDATA.HitBoxProcessorInstance);
                     InteractiveSprite.hitTest(this,projectile,HitBoxSprite.REVERSE,HitBoxSprite.HIT,this.reactionReverse,STAGEDATA.HitBoxProcessorInstance);
                  }
               }
               i++;
            }
            for(i = 0; i < STAGEDATA.Enemies.length; i++)
            {
               enemy = STAGEDATA.Enemies[i];
               if(enemy != null && enemy != this)
               {
                  if(InteractiveSprite.hitTest(this,enemy,HitBoxSprite.MASTER,HitBoxSprite.MASTER,reactionMaster).length)
                  {
                     InteractiveSprite.hitTest(this,enemy,HitBoxSprite.ATTACK,HitBoxSprite.HIT,this.reactionHit,STAGEDATA.HitBoxProcessorInstance);
                  }
               }
            }
            for(i = 0; i < STAGEDATA.ItemsRef.MAXITEMS; i++)
            {
               item = STAGEDATA.ItemsRef.getItemData(i);
               if(item != null)
               {
                  if(InteractiveSprite.hitTest(this,item,HitBoxSprite.MASTER,HitBoxSprite.MASTER,reactionMaster).length)
                  {
                     InteractiveSprite.hitTest(this,item,HitBoxSprite.REVERSE,HitBoxSprite.HIT,this.reactionReverse,STAGEDATA.HitBoxProcessorInstance);
                     InteractiveSprite.hitTest(this,item,HitBoxSprite.REVERSE,HitBoxSprite.ATTACK,this.reactionReverse,STAGEDATA.HitBoxProcessorInstance);
                     InteractiveSprite.hitTest(this,item,HitBoxSprite.ATTACK,HitBoxSprite.HIT,this.reactionHit,STAGEDATA.HitBoxProcessorInstance);
                  }
               }
            }
            for(i = 0; i < STAGEDATA.Targets.length; i++)
            {
               target = STAGEDATA.Targets[i];
               if(target != null)
               {
                  if(InteractiveSprite.hitTest(this,target,HitBoxSprite.MASTER,HitBoxSprite.MASTER,reactionMaster).length)
                  {
                     InteractiveSprite.hitTest(this,target,HitBoxSprite.ATTACK,HitBoxSprite.HIT,this.reactionHit,STAGEDATA.HitBoxProcessorInstance);
                  }
               }
            }
         }
         if(HasMC)
         {
            m_sprite.stop();
            Utils.recursiveMovieClipPlay(m_sprite,false);
         }
      }
      
      override protected function validateBypass(attackObj:AttackDamage) : Boolean
      {
         if(attackObj.BypassEnemies)
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
         if(!super.validateHit(attackObj,ignoreInvincible,ignoreIntangible) || inState(EState.DEAD))
         {
            return false;
         }
         return true;
      }
      
      override public function takeDamage(attackObj:AttackDamage, collisionHitBox:HitBoxSprite = null) : Boolean
      {
         var weight1Multiplier:Number = NaN;
         var angle:Number = NaN;
         var tempDamage:Number = NaN;
         var effect1MC:MovieClip = null;
         if(!this.validateHit(attackObj,false,true))
         {
            return false;
         }
         var oldDamage:Number = m_damage;
         var preDamage:Number = attackObj.Damage <= 0 ? 0 : Utils.calculateChargeDamage(attackObj);
         var preKBVelocity:Number = m_baseStats.Stamina > 0 ? Utils.calculateVelocity(Utils.calculateKnockback(attackObj.KBConstant,attackObj.Power,attackObj.WeightKB,0,0,this.m_enemyStats.Weight1 * weight1Multiplier,false,1,attackObj.AttackRatio)) : Utils.calculateVelocity(Utils.calculateKnockback(attackObj.KBConstant,attackObj.Power,attackObj.WeightKB,preDamage,oldDamage,this.m_enemyStats.Weight1 * weight1Multiplier,false,1,attackObj.AttackRatio));
         var tempVelocity:Number = 0;
         var tempKnockback:Number = 0;
         var sizeMultiplier:Number = 1;
         weight1Multiplier = 1;
         var flipSuperArmor:Boolean = false;
         var tmpHasEffect:Boolean = true;
         var tmpPower:Number = 0;
         var tmpKB:Number = 0;
         var tmpLaunchResistance:Number = attackObj.BypassLaunchResistance ? 0 : (m_attack.LaunchResistance > 0 ? m_attack.LaunchResistance : 0);
         var tmpLaunchResistanceDiff:Number = tmpLaunchResistance > 0 ? preKBVelocity - tmpLaunchResistance : 0;
         var tmpHeavyArmor:Number = tmpLaunchResistance > 0 ? -tmpLaunchResistance : 0;
         if(inState(CState.ATTACKING) && (m_attack.SuperArmor && !attackObj.BypassSuperArmor || m_attack.HeavyArmor != 0 && !attackObj.BypassHeavyArmor && (m_attack.HeavyArmor > 0 && preDamage <= m_attack.HeavyArmor || m_attack.HeavyArmor < 0 && preKBVelocity <= -m_attack.HeavyArmor) || tmpHeavyArmor != 0 && !attackObj.BypassHeavyArmor && (tmpHeavyArmor > 0 && preDamage <= tmpHeavyArmor || tmpHeavyArmor < 0 && preKBVelocity <= -tmpHeavyArmor)))
         {
            if(tmpLaunchResistance <= 0 || tmpLaunchResistance > 0 && tmpLaunchResistanceDiff <= 0)
            {
               flipSuperArmor = true;
               tmpHasEffect = attackObj.HasEffect;
               tmpPower = attackObj.Power;
               tmpKB = attackObj.KBConstant;
               attackObj.Power = 0;
               attackObj.KBConstant = 0;
               attackObj.HasEffect = false;
            }
         }
         if(attackObj.HasEffect || !attackObj.HasEffect && !(isIntangible() && attackObj.Damage > 0))
         {
            if(m_hurtInterrupt != null && Boolean(m_hurtInterrupt({
               "target":(Boolean(attackObj.Owner) && Boolean(attackObj.Owner.APIInstance) ? attackObj.Owner.APIInstance.instance : null),
               "attackBoxData":attackObj.exportAttackDamageData(),
               "collisionRect":(Boolean(collisionHitBox) ? collisionHitBox.BoundingBox : null)
            })))
            {
               if(flipSuperArmor)
               {
                  attackObj.HasEffect = tmpHasEffect;
                  attackObj.Power = tmpPower;
                  attackObj.KBConstant = tmpKB;
               }
               return false;
            }
            if(attackObj.HasEffect)
            {
               initDelayPlayback(false);
            }
            stackAttackID(attackObj.AttackID);
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
               STAGEDATA.playSpecificSound(attackObj.EffectSound);
            }
            tempDamage = attackObj.Damage <= 0 ? 0 : Utils.calculateChargeDamage(attackObj);
            tempDamage *= attackObj.StaleMultiplier;
            if(attackObj.Damage > 0 && tempDamage <= 0)
            {
               tempDamage = 1;
            }
            if(this.m_enemyStats.Stamina > 0)
            {
               tempKnockback = Utils.calculateKnockback(attackObj.KBConstant,attackObj.Power,attackObj.WeightKB,0,0,this.m_enemyStats.Weight1,false,STAGEDATA.GameRef.LevelData.damageRatio,attackObj.AttackRatio);
            }
            else
            {
               tempKnockback = Utils.calculateKnockback(attackObj.KBConstant,attackObj.Power,attackObj.WeightKB,preDamage,oldDamage,this.m_enemyStats.Weight1,false,STAGEDATA.GameRef.LevelData.damageRatio,attackObj.AttackRatio);
            }
            tempVelocity = tmpLaunchResistanceDiff > 0 ? tmpLaunchResistanceDiff : Utils.calculateVelocity(tempKnockback);
            if(this.m_enemyStats.CanReceiveKnockback)
            {
               applyKnockbackSpeed(tempVelocity,angle);
            }
            if(this.m_enemyStats.CanReceiveDamage)
            {
               setDamage(this.m_enemyStats.Stamina > 0 ? m_damage - tempDamage : m_damage + tempDamage);
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
            else if(!flipSuperArmor)
            {
               startActionShot(-1,attackObj.Paralysis);
            }
            if(!m_attack.DisableLastHitUpdate)
            {
               m_lastHitID = attackObj.PlayerID;
               m_lastHitObject = attackObj;
            }
            m_eventManager.dispatchEvent(new SSF2Event(attackObj.HasEffect ? SSF2Event.ENEMY_HURT : SSF2Event.ENEMY_WIND,{
               "caller":this.APIInstance.instance,
               "opponent":(Boolean(attackObj.Owner) ? attackObj.Owner.APIInstance.instance : null),
               "attackBoxData":attackObj.exportAttackDamageData(),
               "collisionRect":(Boolean(collisionHitBox) ? collisionHitBox.BoundingBox : null)
            }));
            if(flipSuperArmor)
            {
               attackObj.HasEffect = tmpHasEffect;
               attackObj.Power = tmpPower;
               attackObj.KBConstant = tmpKB;
            }
            return true;
         }
         return false;
      }
      
      protected function forceOnGround(threshold:Number = 200) : void
      {
         var startY:Number = m_sprite.y;
         var tmpDistance:Number = 0;
         if(Boolean(m_currentPlatform))
         {
            return;
         }
         while(!(m_currentPlatform = testGroundWithCoord(m_sprite.x,m_sprite.y + 1)) && tmpDistance < threshold)
         {
            ++m_sprite.y;
            tmpDistance++;
         }
         if(!m_currentPlatform)
         {
            m_sprite.y = startY;
         }
         else
         {
            attachToGround();
         }
      }
      
      override protected function move() : void
      {
         if(!isHitStunOrParalysis())
         {
            if(this.m_enemyStats.Ghost)
            {
               m_sprite.x += m_xSpeed;
               m_sprite.y += m_ySpeed;
            }
            else
            {
               m_attemptToMove(m_xSpeed,0);
               m_attemptToMove(0,m_ySpeed);
               applyGroundInfluence();
            }
         }
      }
      
      override protected function PREPERFORM() : void
      {
         m_actionTimerUpdatedOnFrame = false;
         if(!STAGEDATA.FSCutscene && STAGEDATA.FSCutins <= 0)
         {
            if(m_started && HasStance && !inState(EState.DEAD) && !isHitStunOrParalysis() && !m_delayPlayback)
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
      
      override public function PERFORMALL() : void
      {
         this.PREPERFORM();
         if(m_started && !this.m_dead && !inState(EState.DEAD) && !STAGEDATA.FSCutscene && STAGEDATA.FSCutins <= 0)
         {
            checkTimers();
            this.performAttackChecks();
            this.move();
            m_forces();
            gravity();
            if(!this.m_enemyStats.Ghost)
            {
               m_groundCollisionTest();
            }
            updateSelfPlatform();
            checkReflection();
            checkShadow();
            checkHitStun();
            updateCamerBox();
            this.checkDeath();
         }
         this.POSTPERFORM();
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

