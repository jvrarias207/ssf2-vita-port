package com.mcleodgaming.ssf2.api
{
   import com.mcleodgaming.ssf2.engine.Character;
   import com.mcleodgaming.ssf2.engine.Projectile;
   import com.mcleodgaming.ssf2.enums.CState;
   import com.mcleodgaming.ssf2.items.Item;
   import com.mcleodgaming.ssf2.util.Utils;
   import flash.display.MovieClip;
   import flash.geom.Point;
   
   public class SSF2Character extends SSF2GameObject
   {
      
      protected var _ownerCasted:Character;
      
      public function SSF2Character(api:Class, owner:Character)
      {
         super(api,owner);
         this._ownerCasted = Character(owner);
      }
      
      public function get KirbyPower() : String
      {
         return this._ownerCasted.KirbyPower;
      }
      
      public function set KirbyPower(value:String) : void
      {
         this._ownerCasted.KirbyPower = value;
      }
      
      public function getCurrentKirbyPower() : String
      {
         return this._ownerCasted.getCurrentKirbyPower();
      }
      
      public function shootOutOpponent() : void
      {
         this._ownerCasted.shootOutOpponent();
      }
      
      public function activateFinalForm() : void
      {
         this._ownerCasted.activateFinalForm();
      }
      
      public function dropItem(zDropped:Boolean = false) : void
      {
         this._ownerCasted.dropItem(zDropped);
      }
      
      public function endAttack(targetFrame:String = null, targetFrameLabel:String = null) : void
      {
         this._ownerCasted.endAttack(targetFrame,targetFrameLabel);
      }
      
      public function endFinalForm() : void
      {
         this._ownerCasted.endFinalForm();
      }
      
      public function fireProjectile(projData:*, xOverride:Number = 0, yOverride:Number = 0, absolute:Boolean = false, options:Object = null) : *
      {
         var proj:Projectile = this._ownerCasted.fireProjectile(projData,xOverride,yOverride,absolute,options);
         return Boolean(proj) && Boolean(proj.APIInstance) ? proj.APIInstance.instance : null;
      }
      
      public function rocketCharacter(speed:Number, angle:Number, decay:Number, rotate:Boolean) : void
      {
         this._ownerCasted.rocketCharacter(speed,angle,decay,rotate);
      }
      
      public function forceGrabbedHurtFrame(frame:String) : void
      {
         this._ownerCasted.forceGrabbedHurtFrame(frame);
      }
      
      public function generateItem(itemID:String, hold:Boolean = false, isCustom:Boolean = true, forceGenerate:Boolean = false) : *
      {
         var item:Item = this._ownerCasted.generateItem(itemID,hold,isCustom,forceGenerate);
         if(Boolean(item) && Boolean(item.APIInstance))
         {
            return item.APIInstance.instance;
         }
         return null;
      }
      
      public function generateCharacterItem(itemID:String, itemChar:String, hold:Boolean = false) : *
      {
         var item:Item = this._ownerCasted.generateCharacterItem(itemID,itemChar,hold);
         if(Boolean(item) && Boolean(item.APIInstance))
         {
            return item.APIInstance.instance;
         }
         return null;
      }
      
      public function getCharacterStat(statName:String) : *
      {
         return this._ownerCasted.getCharacterStat(statName);
      }
      
      public function getPlayerSetting(setting:String) : *
      {
         return this._ownerCasted.getPlayerSetting(setting);
      }
      
      public function getControls(inputsOnly:Boolean = false) : Object
      {
         return this._ownerCasted.getControls(inputsOnly);
      }
      
      public function getControlBits(inputsOnly:Boolean = false) : int
      {
         return this._ownerCasted.getControlBitsAPI(inputsOnly);
      }
      
      public function getCostume() : int
      {
         return this._ownerCasted.CostumeID;
      }
      
      public function setCostume(value:int, team_id:int = -1) : void
      {
         this._ownerCasted.setCostumeAPI(value,team_id);
      }
      
      public function getCPUAction() : int
      {
         return this._ownerCasted.getCPUAction();
      }
      
      public function getCPUForcedAction() : int
      {
         return this._ownerCasted.getCPUForcedAction();
      }
      
      public function setCPUForcedAction(action:int) : void
      {
         this._ownerCasted.getAI().ForcedAction = action;
      }
      
      public function getCPULevel() : int
      {
         return this._ownerCasted.getCPULevel();
      }
      
      public function getCPUTarget() : *
      {
         return this._ownerCasted.getCPUTargetAPI();
      }
      
      public function getCurrentAttackFrame() : String
      {
         return this._ownerCasted.getCurrentAttackFrame();
      }
      
      public function getCurrentProjectile() : *
      {
         return this._ownerCasted.getCurrentProjectileAPI();
      }
      
      public function getExecTime() : int
      {
         return this._ownerCasted.getExecTime();
      }
      
      public function getHitsDealtCounter() : int
      {
         return this._ownerCasted.getHitsDealtCounter();
      }
      
      public function getHitsReceivedCounter() : int
      {
         return this._ownerCasted.getHitsReceivedCounter();
      }
      
      public function getGrabbedOpponent() : *
      {
         return this._ownerCasted.getGrabbedOpponentAPI();
      }
      
      public function getGrabbedOpponents() : Array
      {
         var opponents:Vector.<Character> = this._ownerCasted.Grabbed;
         var results:Array = [];
         for(var i:int = 0; i < opponents.length; i++)
         {
            results.push(opponents[i].APIInstance.instance);
         }
         return results;
      }
      
      public function getGrabber() : *
      {
         var grabber:Character = this._ownerCasted.inState(CState.CAUGHT) ? SSF2API.getCharacter(this._ownerCasted.GrabberID) : null;
         if(Boolean(grabber))
         {
            return grabber.APIInstance.instance;
         }
         return null;
      }
      
      public function getItem() : *
      {
         return this._ownerCasted.getItemAPI();
      }
      
      public function getLastUsed(str:String = null) : int
      {
         return this._ownerCasted.getLastUsed(str);
      }
      
      public function getLives() : int
      {
         return this._ownerCasted.getLives();
      }
      
      public function getShieldPower() : Number
      {
         return this._ownerCasted.getShieldPower();
      }
      
      public function getSizeStatus() : int
      {
         return this._ownerCasted.getSizeStatus();
      }
      
      public function getSmashTimer() : int
      {
         return this._ownerCasted.getSmashTimer();
      }
      
      public function getTeammates() : Array
      {
         return this._ownerCasted.getTeammatesAPI();
      }
      
      public function getTetherCount() : int
      {
         return this._ownerCasted.getTetherCount();
      }
      
      public function gotoGrabbedCharacter() : void
      {
         this._ownerCasted.gotoGrabbedCharacter();
      }
      
      public function grabRelease() : void
      {
         this._ownerCasted.grabRelease();
      }
      
      public function grabReleaseOpponent() : void
      {
         this._ownerCasted.grabReleaseOpponent();
      }
      
      public function importCPUControls(array:Array) : void
      {
         this._ownerCasted.importCPUControls(array);
      }
      
      public function initiateCrash() : void
      {
         this._ownerCasted.initiateCrash();
      }
      
      public function isCPU() : Boolean
      {
         return this._ownerCasted.isCPU();
      }
      
      public function isForcedCrash() : Boolean
      {
         return this._ownerCasted.isForcedCrash();
      }
      
      public function isGrabbing() : Boolean
      {
         return this._ownerCasted.Grabbing;
      }
      
      public function isRecovering() : Boolean
      {
         return this._ownerCasted.isRecovering();
      }
      
      public function isCPURecovering() : Boolean
      {
         if(!this._ownerCasted.CpuAI)
         {
            return false;
         }
         return this._ownerCasted.CpuAI.Recovering;
      }
      
      public function isStandby() : Boolean
      {
         return this._ownerCasted.isStandby();
      }
      
      public function confuseAI(duration:int) : void
      {
         if(Boolean(this._ownerCasted) && Boolean(this._ownerCasted.isCPU()) && Boolean(this._ownerCasted.CpuAI))
         {
            this._ownerCasted.CpuAI.beginConfusion(duration);
         }
      }
      
      public function jumpFullyReleased() : Boolean
      {
         return this._ownerCasted.jumpFullyReleased();
      }
      
      public function maxOutJumps() : void
      {
         this._ownerCasted.maxOutJumps();
      }
      
      public function playCharacterSound(soundID:String) : int
      {
         return this._ownerCasted.playCharacterSound(soundID);
      }
      
      public function playAttackSound(soundID:Number = -1) : int
      {
         return this._ownerCasted.playAttackSound(soundID);
      }
      
      public function playVoiceSound(soundID:Number = -1) : int
      {
         return this._ownerCasted.playVoiceSound(soundID);
      }
      
      public function recover(amount:int) : Boolean
      {
         return this._ownerCasted.recover(amount);
      }
      
      public function releaseLedge() : void
      {
         this._ownerCasted.releaseLedge();
      }
      
      public function releaseOpponent() : void
      {
         this._ownerCasted.releaseOpponent();
      }
      
      public function removeItem() : void
      {
         this._ownerCasted.removeItem();
      }
      
      public function replaceCharacter(statsName:String, frame:String = null, jumpFrame:String = null) : void
      {
         this._ownerCasted.replaceCharacter(statsName,frame,jumpFrame);
      }
      
      public function resetCPUControls() : void
      {
         this._ownerCasted.resetCPUControls();
      }
      
      public function resetHitsDealtCounter() : void
      {
         this._ownerCasted.resetHitsDealtCounter();
      }
      
      public function resetHitsReceivedCounter() : void
      {
         this._ownerCasted.resetHitsReceivedCounter();
      }
      
      public function resetJumps() : void
      {
         this._ownerCasted.resetJumps();
      }
      
      public function resetMovement(e:* = null) : void
      {
         this._ownerCasted.resetMovement(e);
      }
      
      public function resetStaleMoves() : void
      {
         this._ownerCasted.resetStaleMoves();
      }
      
      public function setAttackEnabled(enabled:Boolean, attackName:String = null, reenableTimer:int = -1) : void
      {
         this._ownerCasted.setAttackEnabled(enabled,attackName,reenableTimer);
      }
      
      public function setCPUAttackQueue(str:String) : void
      {
         this._ownerCasted.setCPUAttackQueue(str);
      }
      
      public function setInvisibilityTimer(value:int) : void
      {
         this._ownerCasted.setInvisibilityTimer(value);
      }
      
      public function setLastUsed(attackName:String, frames:int) : void
      {
         this._ownerCasted.setLastUsed(attackName,frames);
      }
      
      public function setSizeStatus(value:int) : void
      {
         this._ownerCasted.setSizeStatus(value);
      }
      
      public function swapDepthsWithGrabbedOpponent(onTop:Boolean) : void
      {
         this._ownerCasted.swapDepthsWithGrabbedOpponent(onTop);
      }
      
      public function switchAttack(targetFrame:String, toFrame:* = null) : void
      {
         this._ownerCasted.switchAttack(targetFrame,toFrame);
      }
      
      public function switchAttackData(attackName:String, nextSwitchID:String) : void
      {
         this._ownerCasted.switchAttackData(attackName,nextSwitchID);
      }
      
      public function toBounce(e:* = null) : void
      {
         this._ownerCasted.toBounce(e);
      }
      
      public function toCrashLand(e:* = null) : void
      {
         this._ownerCasted.toCrashLand(e);
      }
      
      public function toHeavyLand(e:* = null) : void
      {
         this._ownerCasted.toHeavyLand(e);
      }
      
      public function toHelpless(e:* = null) : void
      {
         this._ownerCasted.toHelpless(e);
      }
      
      public function toIdle(e:* = null) : void
      {
         this._ownerCasted.toIdle(e);
      }
      
      public function toLand(e:* = null) : void
      {
         this._ownerCasted.toLand(e);
      }
      
      public function toToss(e:* = null) : void
      {
         this._ownerCasted.toToss(e);
      }
      
      public function toFlying(e:* = null) : void
      {
         this._ownerCasted.toFlying(e);
      }
      
      public function toBarrel(e:* = null) : void
      {
         this._ownerCasted.toBarrel(e);
      }
      
      public function toGrabbing(e:* = null) : void
      {
         this._ownerCasted.toGrabbing(e);
      }
      
      public function toRoll(e:* = null) : void
      {
         this._ownerCasted.initRoll(this._ownerCasted.isFacingRight());
      }
      
      public function toDodgeRoll(e:* = null) : void
      {
         this._ownerCasted.initDodgeRoll(this._ownerCasted.isFacingRight());
      }
      
      public function toJumpChamber(e:* = null) : void
      {
         this._ownerCasted.jumpChamber();
      }
      
      public function toJump(e:* = null) : void
      {
         this._ownerCasted.initGroundJump();
      }
      
      public function toDoubleJump(e:* = null) : void
      {
         this._ownerCasted.initMidairJump();
      }
      
      public function tossItem(angle:Number) : void
      {
         this._ownerCasted.tossItem(angle);
      }
      
      public function pickupItem() : Boolean
      {
         return this._ownerCasted.pickupItem();
      }
      
      public function updateCharacterStats(statValues:Object) : void
      {
         this._ownerCasted.updateCharacterStats(statValues);
      }
      
      public function updatePlayerSettings(settings:Object) : void
      {
         this._ownerCasted.updatePlayerSettings(settings);
      }
      
      public function usingCPUControls() : Boolean
      {
         return this._ownerCasted.usingCPUControls();
      }
      
      public function getRank() : int
      {
         this._ownerCasted.updateRanksProxy();
         return this._ownerCasted.getMatchResults().Rank;
      }
      
      public function setRank(rank:int) : void
      {
         this._ownerCasted.getMatchResults().Rank = rank;
      }
      
      public function getForceTransformTime() : int
      {
         return this._ownerCasted.getForceTransformTime();
      }
      
      public function setStarmanInvincibility(length:int) : void
      {
         this._ownerCasted.starmanEffect(length);
      }
      
      public function setHurtInterrupt(fn:Function) : void
      {
         _ownerCastedBase.HurtInterrupt = fn;
      }
      
      public function forceTaunt() : void
      {
         this._ownerCasted.forceTaunt();
      }
      
      public function warioWareEffect(win:Boolean, effect:Boolean) : void
      {
         this._ownerCasted.warioWareEffect(win,effect);
      }
      
      public function isUsingFinalSmash() : Boolean
      {
         return this._ownerCasted.UsingFinalSmash;
      }
      
      public function grab(grabberID:int = -1, hitForceVisible:Boolean = true, invincibility:Boolean = false, grabLock:Boolean = false) : Boolean
      {
         return this._ownerCasted.grabAPI(grabberID,hitForceVisible,invincibility,grabLock);
      }
      
      public function release() : void
      {
         this._ownerCasted.Uncapture();
      }
      
      public function triggerFSCutscene() : void
      {
         this._ownerCasted.triggerFSCutscene();
      }
      
      public function killFSCutscene() : void
      {
         this._ownerCasted.killFSCutscene();
      }
      
      public function getOriginalSizeRatio() : Number
      {
         return this._ownerCasted.OriginalSizeRatio;
      }
      
      public function setOriginalSizeRatio(value:Number) : void
      {
         this._ownerCasted.OriginalSizeRatio = value;
      }
      
      public function lockSizeStatus(value:Boolean) : void
      {
         this._ownerCasted.lockSizeStatus(value);
      }
      
      public function getStartPosition() : Point
      {
         return new Point(this._ownerCasted.getPlayerSettings().x_start,this._ownerCasted.getPlayerSettings().y_start);
      }
      
      public function setStartPosition(point:Point) : void
      {
         this._ownerCasted.getPlayerSettings().x_start = point.x;
         this._ownerCasted.getPlayerSettings().y_start = point.y;
      }
      
      public function getSpawnPosition() : Point
      {
         return new Point(this._ownerCasted.getPlayerSettings().x_respawn,this._ownerCasted.getPlayerSettings().y_respawn);
      }
      
      public function setSpawnPosition(point:Point) : void
      {
         this._ownerCasted.getPlayerSettings().x_respawn = point.x;
         this._ownerCasted.getPlayerSettings().y_respawn = point.y;
      }
      
      public function setOffScreenIndicatorEnabled(value:Boolean) : void
      {
         this._ownerCasted.OffScreenIndicatorEnabled = value;
      }
      
      public function setHumanControl(value:Boolean, level:int = 1) : void
      {
         this._ownerCasted.setHumanControl(value,level);
      }
      
      public function getStandby() : Boolean
      {
         return this._ownerCasted.isStandby();
      }
      
      public function setStandby(value:Boolean) : void
      {
         this._ownerCasted.StandBy = value;
      }
      
      public function getHitLag() : int
      {
         return this._ownerCasted.HitLag;
      }
      
      public function setHitLag(value:int) : void
      {
         this._ownerCasted.HitLag = value;
      }
      
      public function grantFinalSmash(smashball:* = null) : Boolean
      {
         var smashballInstance:Item = Boolean(smashball) ? smashball.$ext.getAPI().owner : null;
         if(Boolean(smashballInstance))
         {
            return this._ownerCasted.grantSmashBall(smashballInstance);
         }
         if(!this._ownerCasted.HasSmashBall)
         {
            return this._ownerCasted.grantFinalSmash();
         }
         return false;
      }
      
      public function releaseSmashBall() : Boolean
      {
         return this._ownerCasted.releaseSmashBall();
      }
      
      public function setLivesEnabled(enabled:Boolean) : void
      {
         this._ownerCasted.setLivesEnabled(enabled);
      }
      
      public function setLives(lives:int) : void
      {
         this._ownerCasted.setLives(lives);
      }
      
      public function setMetalStatus(status:Boolean) : void
      {
         this._ownerCasted.setMetalStatus(status);
      }
      
      public function getMetalStatus() : Boolean
      {
         return this._ownerCasted.getMetalStatus();
      }
      
      public function getPoison() : Object
      {
         return this._ownerCasted.getPoison();
      }
      
      public function setPoison(damage:int, interval:int = 15, length:int = 300) : void
      {
         this._ownerCasted.setPoison(damage,interval,length);
      }
      
      public function hasSmashBallAura() : Boolean
      {
         return this._ownerCasted.HasFinalSmash ? true : false;
      }
      
      public function getFinalSmashCutscene() : MovieClip
      {
         return this._ownerCasted.AttachedFSCutscene;
      }
      
      public function getFinalSmashReticule() : MovieClip
      {
         return this._ownerCasted.AttachedReticule;
      }
      
      public function getMatchStatistics() : Object
      {
         var data:Object = this._ownerCasted.getMatchResults().exportData();
         delete data.rank;
         delete data.swimTime;
         delete data.transformationTime;
         delete data.finalSmashCount;
         return Utils.cloneObject(data);
      }
      
      public function destroy() : void
      {
         return this._ownerCasted.destroy();
      }
      
      public function getKirbyHatMC() : MovieClip
      {
         return this._ownerCasted.KirbyHatMC;
      }
      
      public function getMidairJumpCount() : int
      {
         return this._ownerCasted.JumpCount;
      }
      
      public function setMidairJumpCount(value:int) : void
      {
         this._ownerCasted.JumpCount = value;
      }
      
      public function setIASA(value:Boolean) : void
      {
         this._ownerCasted.updateAttackStats({"IASA":value});
      }
      
      public function getFinalSmashMeterCharge() : Number
      {
         return this._ownerCasted.FinalSmashMeterCharge;
      }
      
      public function setFinalSmashMeterCharge(value:Number) : void
      {
         this._ownerCasted.FinalSmashMeterCharge = value;
      }
   }
}

