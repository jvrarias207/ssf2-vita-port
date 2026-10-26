package com.mcleodgaming.ssf2.api
{
   import com.mcleodgaming.ssf2.engine.AttackDamage;
   import com.mcleodgaming.ssf2.engine.HitBoxSprite;
   import com.mcleodgaming.ssf2.engine.InteractiveSprite;
   import com.mcleodgaming.ssf2.platforms.MovingPlatform;
   import com.mcleodgaming.ssf2.platforms.Platform;
   import com.mcleodgaming.ssf2.util.Utils;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class SSF2GameObject extends SSF2BaseAPIObject
   {
      
      protected var _ownerCastedBase:InteractiveSprite;
      
      public function SSF2GameObject(api:Class, owner:InteractiveSprite)
      {
         super(api,owner);
         this._ownerCastedBase = InteractiveSprite(owner);
      }
      
      public function getOwnStats() : Object
      {
         if(Boolean(_api) && "getOwnStats" in _api)
         {
            return _api.getOwnStats();
         }
         return {};
      }
      
      public function getAttackStats() : Object
      {
         if(Boolean(_api) && "getAttackStats" in _api)
         {
            return _api.getAttackStats();
         }
         return {};
      }
      
      public function getProjectileStats() : Object
      {
         if(Boolean(_api) && "getProjectileStats" in _api)
         {
            return _api.getProjectileStats();
         }
         return {};
      }
      
      public function getItemStats() : Object
      {
         if(Boolean(_api) && "getItemStats" in _api)
         {
            return _api.getItemStats();
         }
         return {};
      }
      
      public function playSound(linkage:*, vfx:Boolean = false) : int
      {
         return this._ownerCastedBase.playSound(linkage,vfx);
      }
      
      public function stopSound(id:int) : void
      {
         this._ownerCastedBase.stopSound(id);
      }
      
      public function addToCamera() : void
      {
         this._ownerCastedBase.addToCamera();
      }
      
      public function addEventListener(type:String, func:Function, options:Object = null) : void
      {
         this._ownerCastedBase.addEventListener(type,func,options);
      }
      
      public function hasEventListener(type:String, func:Function = null) : Boolean
      {
         return this._ownerCastedBase.hasEventListener(type,func);
      }
      
      public function removeEventListener(type:String, func:Function) : void
      {
         this._ownerCastedBase.removeEventListener(type,func);
      }
      
      public function attachEffect(id:*, options:Object = null) : MovieClip
      {
         return this._ownerCastedBase.attachEffect(id,options);
      }
      
      public function attachEffectOverlay(id:*, options:Object = null) : MovieClip
      {
         return this._ownerCastedBase.attachEffectOverlay(id,options);
      }
      
      public function camFocus(length:int) : void
      {
         this._ownerCastedBase.camFocus(length);
      }
      
      public function camUnfocus() : void
      {
         this._ownerCastedBase.camUnfocus();
      }
      
      public function createTimer(interval:int, repeats:int, func:Function, options:Object = null) : void
      {
         this._ownerCastedBase.createTimer(interval,repeats,func,options);
      }
      
      public function destroyTimer(func:Function) : void
      {
         this._ownerCastedBase.destroyTimer(func);
      }
      
      public function faceLeft() : void
      {
         this._ownerCastedBase.faceLeft();
      }
      
      public function faceRight() : void
      {
         this._ownerCastedBase.faceRight();
      }
      
      public function flip(e:* = null) : void
      {
         this._ownerCastedBase.flip(e);
      }
      
      public function forceHitStun(amount:int, sdiDistance:Number = -1) : void
      {
         this._ownerCastedBase.forceHitStun(amount,sdiDistance);
      }
      
      public function getGameObjectStat(statName:String) : *
      {
         return this._ownerCastedBase.getGameObjectStat(statName);
      }
      
      public function getAttackBoxStat(id:int, statName:String) : *
      {
         return this._ownerCastedBase.getAttackBoxStat(id,statName);
      }
      
      public function exportAttackBoxStats(id:int, frame:String) : Object
      {
         return this._ownerCastedBase.exportAttackBoxStats(id,frame);
      }
      
      public function getAttackStat(statName:String) : *
      {
         return this._ownerCastedBase.getAttackStat(statName);
      }
      
      public function getCounterAttackBoxStats() : Object
      {
         return this._ownerCastedBase.getCounterAttackBoxStats();
      }
      
      public function getGlobalVariable(vName:String) : *
      {
         return this._ownerCastedBase.getGlobalVariable(vName);
      }
      
      public function getHeight() : Number
      {
         return this._ownerCastedBase.getHeight();
      }
      
      public function getHitBox(name:String) : Object
      {
         return this._ownerCastedBase.getHitBox(name);
      }
      
      public function getHomingTarget() : *
      {
         return this._ownerCastedBase.getHomingTargetAPI();
      }
      
      public function getID() : int
      {
         return this._ownerCastedBase.getID();
      }
      
      public function getTeamID() : int
      {
         return this._ownerCastedBase.Team;
      }
      
      public function setTeamID(value:int) : void
      {
         this._ownerCastedBase.Team = value;
      }
      
      public function getLinkageID() : String
      {
         return this._ownerCastedBase.getLinkageID();
      }
      
      public function getMC() : MovieClip
      {
         return this._ownerCastedBase.getMC();
      }
      
      public function getRotation() : Number
      {
         return this._ownerCastedBase.getRotation();
      }
      
      public function getScale() : Point
      {
         return this._ownerCastedBase.getScale();
      }
      
      public function getStanceMC() : MovieClip
      {
         return this._ownerCastedBase.getStanceMC();
      }
      
      public function getUID() : int
      {
         return this._ownerCastedBase.UID;
      }
      
      public function getWidth() : Number
      {
         return this._ownerCastedBase.getWidth();
      }
      
      public function getX() : Number
      {
         return this._ownerCastedBase.getX();
      }
      
      public function getXScale() : Number
      {
         return this._ownerCastedBase.getXScale();
      }
      
      public function getXSpeed() : Number
      {
         return this._ownerCastedBase.getXSpeed();
      }
      
      public function getY() : Number
      {
         return this._ownerCastedBase.getY();
      }
      
      public function getYScale() : Number
      {
         return this._ownerCastedBase.getYScale();
      }
      
      public function getYSpeed() : Number
      {
         return this._ownerCastedBase.getYSpeed();
      }
      
      public function getNearest(type:String, skipSameTeam:Boolean = true, skipOwner:Boolean = true) : *
      {
         var nearest:InteractiveSprite = this._ownerCastedBase.getNearest(type,skipSameTeam,skipOwner);
         return Boolean(nearest) && Boolean(nearest.APIInstance) ? nearest.APIInstance.instance : null;
      }
      
      public function getNearestPath(type:String, skipSameTeam:Boolean = true, skipOwner:Boolean = true) : Array
      {
         var nearest:Array = this._ownerCastedBase.getNearestPath(type,skipSameTeam,skipOwner);
         var instances:Array = [];
         for(var i:int = 0; i < nearest.length; i++)
         {
            if(nearest[i] is InteractiveSprite && Boolean(InteractiveSprite(nearest[i]).APIInstance))
            {
               instances.push(nearest[i].APIInstance.instance);
            }
         }
         return instances;
      }
      
      public function getCurrentPlatform() : *
      {
         var platform:Platform = this._ownerCastedBase.CurrentPlatform;
         return Boolean(platform) && Boolean(platform.APIInstance) ? platform.APIInstance.instance : null;
      }
      
      public function getStageParentPosition() : Point
      {
         return new Point(this._ownerCastedBase.OverlayX,this._ownerCastedBase.OverlayY);
      }
      
      public function homeTowardsTarget(speed:Number, target:*) : void
      {
         this._ownerCastedBase.homeTowardsTargetAPI(speed,Boolean(target) ? target.$ext.getAPI().owner : null);
      }
      
      public function isFacingRight() : Boolean
      {
         return this._ownerCastedBase.isFacingRight();
      }
      
      public function isOnGround() : Boolean
      {
         return this._ownerCastedBase.isOnGround();
      }
      
      public function netSpeed(ignoreNormal:Boolean = false, ignoreKnockback:Boolean = false) : Number
      {
         return this._ownerCastedBase.netSpeed(ignoreNormal,ignoreKnockback);
      }
      
      public function netXSpeed(ignoreNormal:Boolean = false, ignoreKnockback:Boolean = false) : Number
      {
         return this._ownerCastedBase.netXSpeed(ignoreNormal,ignoreKnockback);
      }
      
      public function netYSpeed(ignoreNormal:Boolean = false, ignoreKnockback:Boolean = false) : Number
      {
         return this._ownerCastedBase.netYSpeed(ignoreNormal,ignoreKnockback);
      }
      
      public function removeFromCamera() : void
      {
         this._ownerCastedBase.removeFromCamera();
      }
      
      public function refreshAttackID() : void
      {
         this._ownerCastedBase.refreshAttackID();
      }
      
      public function refreshStaleID() : void
      {
         this._ownerCastedBase.refreshStaleID();
      }
      
      public function resetRotation() : void
      {
         this._ownerCastedBase.resetRotation();
      }
      
      public function resetKnockback() : void
      {
         this._ownerCastedBase.resetKnockback();
      }
      
      public function resetKnockbackDecay() : void
      {
         this._ownerCastedBase.resetKnockbackDecay();
      }
      
      public function getKnockbackDecay() : Object
      {
         return this._ownerCastedBase.getKnockbackDecay();
      }
      
      public function setKnockbackDecay(xDecay:Number, yDecay:Number) : void
      {
         this._ownerCastedBase.setKnockbackDecay(xDecay,yDecay);
      }
      
      public function safeMove(x:Number, y:Number) : Boolean
      {
         return this._ownerCastedBase.safeMove(x,y);
      }
      
      public function setCamBoxSize(width:Number, height:Number, x_offset:Number = 0, y_offset:Number = 0) : void
      {
         this._ownerCastedBase.setCamBoxSize(width,height,x_offset,y_offset);
      }
      
      public function setGlobalVariable(vName:String, value:*) : void
      {
         this._ownerCastedBase.setGlobalVariable(vName,value);
      }
      
      public function setPosition(x:Number, y:Number) : void
      {
         this._ownerCastedBase.setPosition(x,y);
      }
      
      public function setRotation(value:Number) : void
      {
         this._ownerCastedBase.setRotation(value);
      }
      
      public function setScale(xScale:Number, yScale:Number) : void
      {
         this._ownerCastedBase.setScale(xScale,yScale);
      }
      
      public function setX(value:Number) : void
      {
         this._ownerCastedBase.setX(value);
      }
      
      public function setXSpeed(value:Number, absolute:Boolean = true) : void
      {
         this._ownerCastedBase.setXSpeed(value,absolute);
      }
      
      public function setY(value:Number) : void
      {
         this._ownerCastedBase.setY(value);
      }
      
      public function setYSpeed(value:Number) : void
      {
         this._ownerCastedBase.setYSpeed(value);
      }
      
      public function stancePlayFrame(frame:*) : void
      {
         if(frame === "backflip" && this._ownerCastedBase.HasStance && !Utils.hasLabel(this._ownerCastedBase.Stance,"backflip"))
         {
            return;
         }
         this._ownerCastedBase.stancePlayFrame(frame);
      }
      
      public function swapDepths(object:*) : void
      {
         this._ownerCastedBase.swapDepths(Boolean(object) ? object.$ext.getAPI().owner : null);
      }
      
      public function bringBehind(object:*) : void
      {
         this._ownerCastedBase.bringBehindAPI(Boolean(object) ? object.$ext.getAPI().owner : null);
      }
      
      public function bringInFront(object:*) : void
      {
         this._ownerCastedBase.bringInFrontAPI(Boolean(object) ? object.$ext.getAPI().owner : null);
      }
      
      public function attachToGround() : void
      {
         this._ownerCastedBase.attachToGround();
      }
      
      public function unnattachFromGround() : void
      {
         this._ownerCastedBase.unnattachFromGround();
      }
      
      public function updateAttackBoxStats(id:int, statValues:Object) : void
      {
         this._ownerCastedBase.updateAttackBoxStats(id,statValues);
      }
      
      public function updateAttackStats(statValues:Object) : void
      {
         this._ownerCastedBase.updateAttackStats(statValues);
      }
      
      public function replaceAttackStats(attackName:String, statValues:Object) : void
      {
         this._ownerCastedBase.replaceAttackStats(attackName,statValues);
      }
      
      public function replaceAttackBoxStats(attackName:String, attackBoxID:int, statValues:Object) : void
      {
         this._ownerCastedBase.replaceAttackBoxStats(attackName,attackBoxID,statValues);
      }
      
      public function inState(state:uint) : Boolean
      {
         return this._ownerCastedBase.inState(state);
      }
      
      public function getState() : uint
      {
         return this._ownerCastedBase.getState();
      }
      
      public function setState(state:uint) : void
      {
         this._ownerCastedBase.setState(state);
      }
      
      public function extraHitTests(x_offset:Number, y_offset:Number, caller:InteractiveSprite) : Boolean
      {
         if(Boolean(caller.APIInstance) && Boolean(_api) && "extraHitTests" in _api)
         {
            return _api.extraHitTests(x_offset,y_offset,caller.APIInstance.instance);
         }
         return false;
      }
      
      public function takeDamage(attackBox:Object, owner:*, collisionHitBox:Rectangle = null) : Boolean
      {
         var actualOwner:InteractiveSprite = Boolean(owner) ? owner.$ext.getAPI().owner : null;
         var hitBoxSprite:HitBoxSprite = Boolean(collisionHitBox) ? new HitBoxSprite(HitBoxSprite.ATTACK,collisionHitBox) : null;
         var player_id:int = -1;
         var team_id:int = -1;
         if(Boolean(attackBox.player_id))
         {
            player_id = int(attackBox.player_id);
         }
         else if(Boolean(actualOwner))
         {
            player_id = actualOwner.getID();
         }
         if(Boolean(attackBox.team_id))
         {
            team_id = int(attackBox.team_id);
         }
         else if(Boolean(actualOwner))
         {
            team_id = actualOwner.Team;
         }
         var attackDamage:AttackDamage = new AttackDamage(player_id,actualOwner);
         attackDamage.TeamID = team_id;
         if(!attackBox.atk_id)
         {
            attackDamage.AttackID = Utils.getUID();
         }
         attackDamage.importAttackDamageData(attackBox);
         return this._ownerCastedBase.takeDamage(attackDamage,hitBoxSprite);
      }
      
      public function getBoundsRect() : Rectangle
      {
         return this._ownerCastedBase.BoundsRect;
      }
      
      public function getCurrentAnimation() : String
      {
         return this._ownerCastedBase.CurrentFrame;
      }
      
      public function applyKnockback(knockback:Number, angle:Number) : void
      {
         this._ownerCastedBase.applyKnockback(knockback,angle);
      }
      
      public function applyKnockbackSpeed(speed:Number, angle:Number) : void
      {
         this._ownerCastedBase.applyKnockbackSpeed(speed,angle);
      }
      
      public function resetFade(duration:int = 15) : void
      {
         this._ownerCastedBase.resetFade(duration);
      }
      
      public function fadeIn() : void
      {
         this._ownerCastedBase.fadeIn();
      }
      
      public function fadeOut() : void
      {
         this._ownerCastedBase.fadeOut();
      }
      
      public function inHitStun() : Boolean
      {
         return this._ownerCastedBase.inHitStun();
      }
      
      public function inParalysis() : Boolean
      {
         return this._ownerCastedBase.inParalysis();
      }
      
      public function getWarningCollisions() : Boolean
      {
         return this._ownerCastedBase.inParalysis();
      }
      
      public function inLowerLeftWarningBounds() : Boolean
      {
         return this._ownerCastedBase.inLowerLeftWarningBounds();
      }
      
      public function inUpperLeftWarningBounds() : Boolean
      {
         return this._ownerCastedBase.inUpperLeftWarningBounds();
      }
      
      public function inLowerRightWarningBounds() : Boolean
      {
         return this._ownerCastedBase.inLowerRightWarningBounds();
      }
      
      public function inUpperRightWarningBounds() : Boolean
      {
         return this._ownerCastedBase.inUpperRightWarningBounds();
      }
      
      public function setTargetInterrupt(fn:Function) : void
      {
         this._ownerCastedBase.TargetInterrupt = fn;
      }
      
      public function createSelfPlatform(x:Number, y:Number, width:Number, height:Number, terrain:Boolean = true, platformClass:Class = null) : *
      {
         var platform:MovingPlatform = this._ownerCastedBase.createSelfPlatform(x,y,width,height,terrain,platformClass);
         return Boolean(platform.APIInstance) ? platform.APIInstance.instance : null;
      }
      
      public function createSelfPlatformWithMC(mc:MovieClip, terrain:Boolean = true, platformClass:Class = null) : *
      {
         var platform:MovingPlatform = this._ownerCastedBase.createSelfPlatformWithMC(mc,terrain,platformClass);
         return Boolean(platform.APIInstance) ? platform.APIInstance.instance : null;
      }
      
      public function removeSelfPlatform() : void
      {
         this._ownerCastedBase.removeSelfPlatform();
      }
      
      public function setDamage(value:Number) : void
      {
         this._ownerCastedBase.setDamage(value);
      }
      
      public function getDamage() : Number
      {
         return this._ownerCastedBase.getDamage();
      }
      
      public function dealDamage(value:Number) : void
      {
         this._ownerCastedBase.dealDamage(value);
      }
      
      public function healDamage(value:Number) : void
      {
         this._ownerCastedBase.healDamage(value);
      }
      
      public function isFading() : Boolean
      {
         return this._ownerCastedBase.isFading();
      }
      
      public function forceOnGround(threshold:Number = 200) : void
      {
         this._ownerCastedBase.forceOnGroundAPI(threshold);
      }
      
      public function getSizeRatio() : Number
      {
         return this._ownerCastedBase.SizeRatio;
      }
      
      public function setSizeRatio(value:Number) : void
      {
         this._ownerCastedBase.SizeRatio = value;
      }
      
      public function setVisibility(value:Boolean) : void
      {
         this._ownerCastedBase.setVisibility(value);
      }
      
      public function getPreviousAnimation() : String
      {
         return this._ownerCastedBase.PreviousAnimation;
      }
      
      public function getWeight2() : Number
      {
         return this._ownerCastedBase.Weight2;
      }
      
      public function setWeight2(value:Number) : void
      {
         this._ownerCastedBase.Weight2 = value;
      }
      
      public function getLastHurtAttackBoxStats() : Object
      {
         var attackDamage:Object = null;
         var sprite:InteractiveSprite = null;
         if(Boolean(this._ownerCastedBase.LastHitObject))
         {
            attackDamage = this._ownerCastedBase.LastHitObject.exportAttackDamageData();
            sprite = this._ownerCastedBase.LastHitObject.Owner;
            if(Boolean(sprite) && Boolean(sprite.APIInstance) && Boolean(sprite.APIInstance.instance))
            {
               attackDamage.owner = sprite.APIInstance.instance;
            }
            else
            {
               delete attackDamage.owner;
            }
            return attackDamage;
         }
         return null;
      }
      
      public function attachHealthBox(name:String, thumbnail:String, seriesIcon:String, teamID:int = -1, costumeName:String = null, costumeIndex:int = -1) : void
      {
         this._ownerCastedBase.attachHealthBox(name,thumbnail,seriesIcon,teamID,costumeName,costumeIndex);
      }
      
      public function detachHealthBox() : void
      {
         this._ownerCastedBase.detachHealthBox();
      }
      
      public function setColorFilters(settings:Object) : void
      {
         return this._ownerCastedBase.updateColorFilterAPI(settings);
      }
      
      public function applyPalette(mc:MovieClip) : void
      {
         this._ownerCastedBase.applyPalette(mc);
      }
      
      public function throbDamageCounter() : void
      {
         this._ownerCastedBase.throbDamageCounter();
      }
      
      public function getInvincibility() : Boolean
      {
         return this._ownerCastedBase.Invincible;
      }
      
      public function getIntangibility() : Boolean
      {
         return this._ownerCastedBase.Intangible;
      }
      
      public function setIntangibility(value:Boolean) : void
      {
         this._ownerCastedBase.setIntangibility(value);
      }
      
      public function setInvincibility(value:Boolean) : void
      {
         this._ownerCastedBase.setInvincibility(value);
      }
      
      public function getNearestLedge() : MovieClip
      {
         return this._ownerCastedBase.getNearestLedge();
      }
      
      public function getHealthBox() : MovieClip
      {
         return this._ownerCastedBase.HealthBox;
      }
      
      public function forceAttack(attackName:String, toFrame:* = null, isSpecial:Boolean = false) : Boolean
      {
         return this._ownerCastedBase.forceAttack(attackName,toFrame,isSpecial);
      }
      
      public function getPaletteSwapData() : Object
      {
         return {
            "paletteSwap":this._ownerCastedBase.PaletteSwapData,
            "paletteSwapPA":this._ownerCastedBase.PaletteSwapPAData
         };
      }
      
      public function setPaletteSwapData(data:Object) : void
      {
         if(data.paletteSwap === null)
         {
            this._ownerCastedBase.PaletteSwapData = null;
         }
         else if(Boolean(data.paletteSwap))
         {
            this._ownerCastedBase.PaletteSwapData = data.paletteSwap;
         }
         if(data.paletteSwapPA === null)
         {
            this._ownerCastedBase.PaletteSwapPAData = null;
         }
         else if(Boolean(data.paletteSwapPA))
         {
            this._ownerCastedBase.PaletteSwapPAData = data.paletteSwapPA;
         }
      }
   }
}

