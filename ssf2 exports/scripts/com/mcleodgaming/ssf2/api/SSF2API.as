package com.mcleodgaming.ssf2.api
{
   import com.mcleodgaming.ssf2.Main;
   import com.mcleodgaming.ssf2.audio.SoundObject;
   import com.mcleodgaming.ssf2.audio.SoundQueue;
   import com.mcleodgaming.ssf2.controllers.Game;
   import com.mcleodgaming.ssf2.controllers.ItemSettings;
   import com.mcleodgaming.ssf2.controllers.MenuController;
   import com.mcleodgaming.ssf2.controllers.UnlockController;
   import com.mcleodgaming.ssf2.controllers.Unlockable;
   import com.mcleodgaming.ssf2.enemies.Enemy;
   import com.mcleodgaming.ssf2.engine.*;
   import com.mcleodgaming.ssf2.enums.Mode;
   import com.mcleodgaming.ssf2.enums.ModeFeatures;
   import com.mcleodgaming.ssf2.items.Item;
   import com.mcleodgaming.ssf2.items.ItemsListData;
   import com.mcleodgaming.ssf2.menus.CustomAPIMenu;
   import com.mcleodgaming.ssf2.menus.DebugConsole;
   import com.mcleodgaming.ssf2.modes.CustomMode;
   import com.mcleodgaming.ssf2.platforms.BitmapCollisionBoundary;
   import com.mcleodgaming.ssf2.platforms.Platform;
   import com.mcleodgaming.ssf2.util.ResourceManager;
   import com.mcleodgaming.ssf2.util.SaveData;
   import com.mcleodgaming.ssf2.util.Utils;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.geom.Point;
   
   public class SSF2API
   {
      
      private static var _api:StageData;
      
      public static const VERSION_MAJOR:int = 0;
      
      public static const VERSION_MINOR:int = 56;
      
      public static const VERSION_REVISION:int = 0;
      
      public function SSF2API()
      {
         super();
      }
      
      public static function init(api:StageData) : void
      {
         _api = api;
         trace("SSF2 API Interface Version " + SSF2API.VERSION_MAJOR + "." + SSF2API.VERSION_MINOR + "." + SSF2API.VERSION_REVISION + " has been initialized.");
      }
      
      public static function deinit() : void
      {
         _api = null;
         trace("SSF2 API Interface deactivated.");
      }
      
      public static function getAPIVersion() : String
      {
         return VERSION_MAJOR + "." + VERSION_MINOR + "." + VERSION_REVISION;
      }
      
      public static function signal(signal:int, data:Object = null) : void
      {
      }
      
      public static function getUID() : int
      {
         return Utils.getUID();
      }
      
      public static function getPlayer(subject:*) : *
      {
         var subject_mc:MovieClip = null;
         if(!isReady())
         {
            return null;
         }
         var gameObject:SSF2GameObject = null;
         var instance:InteractiveSprite = null;
         var id:int = -1;
         if(subject is MovieClip)
         {
            subject_mc = MovieClip(subject);
            if(subject_mc.player_id != undefined)
            {
               id = int(subject_mc.player_id);
            }
            else if(Boolean(subject_mc.parent) && Boolean(subject_mc.parent is MovieClip) && MovieClip(subject_mc.parent).player_id != undefined)
            {
               id = int(MovieClip(subject_mc.parent).player_id);
            }
            else
            {
               instance = _api.getPlayerByMC(subject_mc);
            }
            if(Boolean(instance))
            {
               gameObject = instance.APIInstance;
            }
         }
         else if(subject is int || subject is Number)
         {
            id = subject;
         }
         else if(subject is Character)
         {
            id = Character(subject).ID;
         }
         if(id > -1)
         {
            gameObject = _api.getPlayerByID(id).APIInstance;
         }
         return Boolean(gameObject) ? gameObject.instance : null;
      }
      
      public static function getCharacter(subject:*) : *
      {
         var subject_mc:MovieClip = null;
         if(!isReady())
         {
            return null;
         }
         var gameObject:SSF2GameObject = null;
         var instance:InteractiveSprite = null;
         var id:int = -1;
         if(subject is MovieClip)
         {
            subject_mc = MovieClip(subject);
            if(subject_mc.uid != undefined)
            {
               id = int(subject_mc.uid);
            }
            else if(Boolean(subject_mc.parent) && Boolean(subject_mc.parent is MovieClip) && MovieClip(subject_mc.parent).uid != undefined)
            {
               id = int(MovieClip(subject_mc.parent).uid);
            }
            else
            {
               instance = _api.getCharacterByMC(subject_mc);
            }
            if(Boolean(instance))
            {
               gameObject = instance.APIInstance;
            }
         }
         else if(subject is int || subject is Number)
         {
            id = subject;
         }
         else if(subject is Character)
         {
            id = Character(subject).UID;
         }
         if(id > -1)
         {
            instance = _api.getCharacterByUID(id);
            if(Boolean(instance))
            {
               gameObject = instance.APIInstance;
            }
         }
         return Boolean(gameObject) ? gameObject.instance : null;
      }
      
      public static function getPlayers() : Array
      {
         if(!isReady())
         {
            return [];
         }
         var players:Array = [];
         for(var i:int = 0; i < _api.Players.length; i++)
         {
            if(Boolean(_api.Players[i]))
            {
               players.push(_api.Players[i].APIInstance.instance);
            }
         }
         return players;
      }
      
      public static function getCharacters() : Array
      {
         if(!isReady())
         {
            return [];
         }
         var characters:Array = [];
         for(var i:int = 0; i < _api.Characters.length; i++)
         {
            characters.push(_api.Characters[i].APIInstance.instance);
         }
         return characters;
      }
      
      public static function getProjectile(subject:*) : *
      {
         var subject_mc:MovieClip = null;
         if(!isReady())
         {
            return null;
         }
         var gameObject:SSF2GameObject = null;
         var instance:InteractiveSprite = null;
         var id:int = -1;
         if(subject is MovieClip)
         {
            subject_mc = MovieClip(subject);
            if(subject_mc.uid != undefined)
            {
               id = int(subject_mc.uid);
            }
            else if(Boolean(subject_mc.parent) && Boolean(subject_mc.parent is MovieClip) && MovieClip(subject_mc.parent).uid != undefined)
            {
               id = int(MovieClip(subject_mc.parent).uid);
            }
            else
            {
               instance = _api.getProjectileByMC(subject_mc);
            }
            if(Boolean(instance))
            {
               gameObject = instance.APIInstance;
            }
         }
         else if(subject is int || subject is Number)
         {
            id = subject;
         }
         else if(subject is Projectile)
         {
            id = Projectile(subject).UID;
         }
         if(id > -1)
         {
            instance = _api.getProjectile(id);
            if(Boolean(instance))
            {
               gameObject = instance.APIInstance;
            }
         }
         return Boolean(gameObject) ? gameObject.instance : null;
      }
      
      public static function getProjectiles() : Array
      {
         if(!isReady())
         {
            return [];
         }
         var projectiles:Array = new Array();
         var fullList:Vector.<Projectile> = _api.getProjectiles();
         for(var i:int = 0; i < fullList.length; i++)
         {
            if(Boolean(fullList[i]) && Boolean(fullList[i].APIInstance) && Boolean(fullList[i].APIInstance.instance))
            {
               projectiles.push(fullList[i].APIInstance.instance);
            }
         }
         return projectiles;
      }
      
      public static function getItem(subject:*) : *
      {
         var subject_mc:MovieClip = null;
         if(!isReady())
         {
            return null;
         }
         var gameObject:SSF2GameObject = null;
         var instance:InteractiveSprite = null;
         var id:int = -1;
         if(subject is MovieClip)
         {
            subject_mc = MovieClip(subject);
            if(subject_mc.uid != undefined)
            {
               id = int(subject_mc.uid);
            }
            else if(Boolean(subject_mc.parent) && Boolean(subject_mc.parent is MovieClip) && MovieClip(subject_mc.parent).uid != undefined)
            {
               id = int(MovieClip(subject_mc.parent).uid);
            }
            else
            {
               instance = _api.getItemByMC(subject_mc);
            }
            if(Boolean(instance))
            {
               gameObject = instance.APIInstance;
            }
         }
         else if(subject is int || subject is Number)
         {
            id = subject;
         }
         else if(subject is Item)
         {
            id = Item(subject).UID;
         }
         if(id > -1)
         {
            instance = _api.getItem(id);
            if(Boolean(instance))
            {
               gameObject = instance.APIInstance;
            }
         }
         return Boolean(gameObject) ? gameObject.instance : null;
      }
      
      public static function getItems() : Array
      {
         if(!isReady())
         {
            return [];
         }
         var itemInstances:Array = [];
         for(var i:int = 0; i < _api.ItemsRef.ItemsInUse.length; i++)
         {
            if(Boolean(_api.ItemsRef.ItemsInUse[i]) && Boolean(_api.ItemsRef.ItemsInUse[i].APIInstance))
            {
               itemInstances.push(_api.ItemsRef.ItemsInUse[i].APIInstance.instance);
            }
         }
         return itemInstances;
      }
      
      public static function getEnemy(subject:*) : *
      {
         var subject_mc:MovieClip = null;
         if(!isReady())
         {
            return null;
         }
         var gameObject:SSF2GameObject = null;
         var instance:InteractiveSprite = null;
         var id:int = -1;
         if(subject is MovieClip)
         {
            subject_mc = MovieClip(subject);
            if(subject_mc.uid != undefined)
            {
               id = int(subject_mc.uid);
            }
            else if(Boolean(subject_mc.parent) && Boolean(subject_mc.parent is MovieClip) && MovieClip(subject_mc.parent).uid != undefined)
            {
               id = int(MovieClip(subject_mc.parent).uid);
            }
            else
            {
               instance = _api.getEnemyByMC(subject_mc);
            }
            if(Boolean(instance))
            {
               gameObject = instance.APIInstance;
            }
         }
         else if(subject is int || subject is Number)
         {
            id = subject;
         }
         else if(subject is Enemy)
         {
            id = Enemy(subject).UID;
         }
         else if(subject is String)
         {
            instance = _api.getEnemyByInstanceName(subject);
            if(Boolean(instance))
            {
               gameObject = instance.APIInstance;
            }
         }
         if(id > -1)
         {
            instance = _api.getEnemy(id);
            if(Boolean(instance))
            {
               gameObject = instance.APIInstance;
            }
         }
         return Boolean(gameObject) ? gameObject.instance : null;
      }
      
      public static function getEnemies() : Array
      {
         var arr:Array = new Array();
         for(var i:int = 0; i < _api.Enemies.length; i++)
         {
            arr.push(_api.Enemies[i].APIInstance.instance);
         }
         return arr;
      }
      
      public static function getTarget(subject:*) : *
      {
         var subject_mc:MovieClip = null;
         if(!isReady())
         {
            return null;
         }
         var gameObject:SSF2GameObject = null;
         var instance:InteractiveSprite = null;
         var id:int = -1;
         if(subject is MovieClip)
         {
            subject_mc = MovieClip(subject);
            if(subject_mc.uid != undefined)
            {
               id = int(subject_mc.uid);
            }
            else if(Boolean(subject_mc.parent) && Boolean(subject_mc.parent is MovieClip) && MovieClip(subject_mc.parent).uid != undefined)
            {
               id = int(MovieClip(subject_mc.parent).uid);
            }
            else
            {
               instance = _api.getTargetByMC(subject_mc);
            }
            if(Boolean(instance))
            {
               gameObject = instance.APIInstance;
            }
         }
         else if(subject is int || subject is Number)
         {
            id = subject;
         }
         else if(subject is TargetTestTarget)
         {
            id = TargetTestTarget(subject).UID;
         }
         if(id > -1)
         {
            instance = _api.getTargetByUID(id);
            if(Boolean(instance))
            {
               gameObject = instance.APIInstance;
            }
         }
         return Boolean(gameObject) ? gameObject.instance : null;
      }
      
      public static function getTargets() : Array
      {
         if(!isReady())
         {
            return [];
         }
         var targetInstances:Array = [];
         for(var i:int = 0; i < _api.Targets.length; i++)
         {
            if(Boolean(_api.Targets[i]) && Boolean(_api.Targets[i].APIInstance))
            {
               targetInstances.push(_api.Targets[i].APIInstance.instance);
            }
         }
         return targetInstances;
      }
      
      public static function getStage() : *
      {
         if(!isReady())
         {
            return null;
         }
         return _api.APIInstance.instance;
      }
      
      public static function getCollisionBoundary(subject:*) : *
      {
         if(!isReady())
         {
            return null;
         }
         var collisionBoundary:BitmapCollisionBoundary = null;
         if(subject is MovieClip)
         {
            collisionBoundary = _api.getCollisionBoundaryByMC(subject);
         }
         else if(subject is String)
         {
            collisionBoundary = _api.getCollisionBoundaryByInstanceName(subject);
         }
         return Boolean(collisionBoundary) && Boolean(collisionBoundary.APIInstance) ? collisionBoundary.APIInstance.instance : null;
      }
      
      public static function getPlatform(subject:*) : *
      {
         if(!isReady())
         {
            return null;
         }
         var platform:Platform = null;
         if(subject is MovieClip)
         {
            platform = _api.getPlatformByMC(subject);
         }
         else if(subject is String)
         {
            platform = _api.getPlatformByInstanceName(subject);
         }
         return Boolean(platform) && Boolean(platform.APIInstance) ? platform.APIInstance.instance : null;
      }
      
      public static function getPlatforms(options:Object = null) : Array
      {
         options ||= {};
         options.terrains = typeof options.terrains !== "undefined" ? options.terrains : true;
         options.platforms = typeof options.platforms !== "undefined" ? options.platforms : true;
         if(!isReady())
         {
            return [];
         }
         var arr:Array = [];
         var i:int = 0;
         if(Boolean(options.terrains))
         {
            for(i = 0; i < _api.Terrains.length; i++)
            {
               if(Boolean(_api.Terrains[i].APIInstance))
               {
                  arr.push(_api.Terrains[i].APIInstance.instance);
               }
            }
         }
         if(Boolean(options.platforms))
         {
            for(i = 0; i < _api.Platforms.length; i++)
            {
               if(Boolean(_api.Platforms[i].APIInstance))
               {
                  arr.push(_api.Platforms[i].APIInstance.instance);
               }
            }
         }
         return arr;
      }
      
      public static function getPlatformBetweenPoints(p1:Point, p2:Point, options:Object) : *
      {
         var platform:Platform = _api.getPlatformBetweenPoints(p1,p2,options);
         return Boolean(platform) && Boolean(platform.APIInstance) ? platform.APIInstance.instance : null;
      }
      
      public static function getCamBounds() : MovieClip
      {
         if(!isReady())
         {
            return null;
         }
         return _api.getCamBounds();
      }
      
      public static function getDeathBounds() : MovieClip
      {
         if(!isReady())
         {
            return null;
         }
         return _api.getDeathBounds();
      }
      
      public static function hitTestGround(x:Number, y:Number, options:Object = null) : *
      {
         var platform:Platform;
         if(!isReady())
         {
            return null;
         }
         options ||= {};
         options.terrain = typeof options.terrain !== "undefined" ? options.terrain : true;
         options.platforms = typeof options.platforms !== "undefined" ? options.platforms : true;
         options.ignoreFallthrough = typeof options.ignoreFallthrough !== "undefined" ? options.ignoreFallthrough : false;
         options.ignoreList = options.ignoreList || [];
         if(Boolean(options.ignoreList))
         {
            options.ignoreList = options.ignoreList.map(function(item:*, index:int, array:Array):*
            {
               return item.$ext.getAPI().owner;
            });
         }
         else
         {
            options.ignoreList = [];
         }
         platform = _api.testGroundWithCoord(x,y,options);
         if(Boolean(platform) && Boolean(platform.APIInstance))
         {
            return platform.APIInstance.instance;
         }
         return null;
      }
      
      public static function hitTestGroundBetweenPoints(p1:Point, p2:Point, options:Object = null) : *
      {
         var platform:Platform;
         if(!isReady())
         {
            return null;
         }
         options ||= {};
         options.terrain = typeof options.terrain !== "undefined" ? options.terrain : true;
         options.platforms = typeof options.platforms !== "undefined" ? options.platforms : true;
         options.ignoreFallthrough = typeof options.ignoreFallthrough !== "undefined" ? options.ignoreFallthrough : false;
         options.ignoreList = options.ignoreList || [];
         if(Boolean(options.ignoreList))
         {
            options.ignoreList = options.ignoreList.map(function(item:*, index:int, array:Array):*
            {
               return item.$ext.getAPI().owner;
            });
         }
         else
         {
            options.ignoreList = [];
         }
         platform = _api.checkLinearPathBetweenPoints(p1,p2,options);
         if(Boolean(platform) && Boolean(platform.APIInstance))
         {
            return platform.APIInstance.instance;
         }
         return null;
      }
      
      public static function lightFlash(fade:Boolean = true) : void
      {
         if(!isReady())
         {
            return;
         }
         _api.lightFlash(fade);
      }
      
      public static function setCamStageFocus(length:int) : void
      {
         if(!isReady())
         {
            return;
         }
         _api.CamRef.setStageFocus(length);
      }
      
      public static function removeCamStageFocus() : void
      {
         if(!isReady())
         {
            return;
         }
         _api.CamRef.removeStageFocus();
      }
      
      public static function print(text:String) : void
      {
         if(Main.DEBUG && Boolean(MenuController.debugConsole))
         {
            MenuController.debugConsole.writeTextData(text);
         }
      }
      
      public static function addEventListener(type:String, func:Function, options:Object = null) : void
      {
         if(!isReady())
         {
            return;
         }
         _api.addEventListener(type,func,options);
      }
      
      public static function hasEventListener(type:String, func:Function = null) : Boolean
      {
         return _api.hasEventListener(type,func);
      }
      
      public static function removeEventListener(type:String, func:Function) : void
      {
         if(!isReady())
         {
            return;
         }
         _api.removeEventListener(type,func);
      }
      
      public static function playMusic(linkage:String, loop:int) : void
      {
         SoundQueue.instance.playMusic(linkage,loop);
      }
      
      public static function stopMusic() : void
      {
         SoundQueue.instance.stopMusic();
      }
      
      public static function getCurrentMusicInfo() : Object
      {
         return {
            "linkage":SoundQueue.instance.CurrentSongID,
            "loop":SoundQueue.instance.LoopLocation,
            "position":(Boolean(SoundQueue.instance.CurrentSong) ? SoundQueue.instance.CurrentSong.position : -1)
         };
      }
      
      public static function playSound(linkage:*, vfx:Boolean = false) : int
      {
         var i:int = 0;
         var soundID:int = 0;
         var soundObj:SoundObject = null;
         if(linkage is Array)
         {
            return SoundQueue.instance.playChainedAudio(linkage,vfx);
         }
         if(vfx)
         {
            return SoundQueue.instance.playVoiceEffect(linkage);
         }
         return SoundQueue.instance.playSoundEffect(linkage);
      }
      
      public static function stopSound(id:int) : void
      {
         SoundQueue.instance.stopSound(id);
      }
      
      public static function shakeCamera(num:int) : void
      {
         if(!isReady())
         {
            return;
         }
         _api.shakeCamera(num);
      }
      
      public static function matchGo() : void
      {
         if(!isReady())
         {
            return;
         }
         if(_api.StageEvent)
         {
            _api.StageEvent = false;
            if(_api.GameRef.UsingTime)
            {
               _api.TimerRef.Start();
            }
         }
      }
      
      public static function matchGoComplete() : void
      {
         if(!isReady())
         {
            return;
         }
         if(Boolean(_api.HudRef) && _api.GameRef.HudDisplay)
         {
            _api.HudRef.toggleMainDisplay(true);
         }
         if(_api.GameRef.UsingTime)
         {
            _api.TimerRef.TimeMC.visible = true;
         }
      }
      
      public static function random() : Number
      {
         if(!isReady())
         {
            return 0;
         }
         return Utils.random();
      }
      
      public static function randomInteger(min:int, max:int) : int
      {
         if(!isReady())
         {
            return 0;
         }
         return Utils.randomInteger(min,max);
      }
      
      public static function safeRandom() : Number
      {
         if(!isReady())
         {
            return 0;
         }
         return Utils.safeRandom();
      }
      
      public static function safeRandomInteger(min:int, max:int) : int
      {
         if(!isReady())
         {
            return 0;
         }
         return Utils.safeRandomInteger(min,max);
      }
      
      public static function fixBG() : void
      {
         if(!isReady())
         {
            return;
         }
         _api.fixBG();
      }
      
      public static function attachEffect(id:*, options:Object = null) : MovieClip
      {
         return _api.attachEffect(id,options);
      }
      
      public static function attachEffectOverlay(id:*, options:Object = null) : MovieClip
      {
         return _api.attachEffectOverlay(id,options);
      }
      
      public static function calculateChargeDamage(obj:Object) : Number
      {
         return _api.calculateChargeDamage(obj);
      }
      
      public static function calculateSelfHitStun(selfHitStun:Number, damage:Number) : Number
      {
         return Utils.calculateSelfHitStun(selfHitStun,damage);
      }
      
      public static function calculateKnockback(kb:Number, power:Number, wdsk:Number, attackdamage:Number, victimdamage:Number, weight1:Number, charging:Boolean) : Number
      {
         return Utils.calculateKnockback(kb,power,wdsk,attackdamage,victimdamage,weight1,charging,_api.GameRef.DamageRatio,1);
      }
      
      public static function calculateKnockbackVelocity(knockback:Number) : Number
      {
         return Utils.calculateVelocity(knockback);
      }
      
      public static function getTimestamp() : Date
      {
         return _api.getTimestamp();
      }
      
      public static function isHazardsOn() : Boolean
      {
         return Boolean(_api) && _api.HazardsOn;
      }
      
      public static function generateItem(id:String, x:Number, y:Number, forceGenerate:Boolean = false) : *
      {
         if(!isReady())
         {
            return null;
         }
         return _api.generateItemAPI(id,x,y,forceGenerate);
      }
      
      public static function getRandomAssist() : Class
      {
         if(!isReady())
         {
            return null;
         }
         return _api.getRandomAssist();
      }
      
      public static function getRandomPokemon() : Class
      {
         if(!isReady())
         {
            return null;
         }
         return _api.getRandomPokemon();
      }
      
      public static function spawnAssist(cls:Class, owner:* = null) : *
      {
         if(!cls)
         {
            throw new Error("Error, could not spawn unspecified Assist class");
         }
         if(!isReady())
         {
            return null;
         }
         return _api.spawnAssistAPI(cls,Boolean(owner) ? owner.$ext.getAPI().owner : null).APIInstance.instance;
      }
      
      public static function spawnPokemon(cls:Class, owner:* = null) : *
      {
         if(!cls)
         {
            throw new Error("Error, could not spawn unspecified Pokemon class");
         }
         if(!isReady())
         {
            return null;
         }
         return _api.spawnPokemonAPI(cls,Boolean(owner) ? owner.$ext.getAPI().owner : null).APIInstance.instance;
      }
      
      public static function spawnCharacter(character:Class) : *
      {
         if(!character)
         {
            throw new Error("Error, could not spawn unspecified Character class");
         }
         return _api.spawnCharacterAPI(character).APIInstance.instance;
      }
      
      public static function spawnEnemy(enemy:*) : *
      {
         var list:Array = null;
         var i:int = 0;
         if(!enemy)
         {
            throw new Error("Error, could not spawn unspecified Enemy class");
         }
         if(enemy is Class)
         {
            return _api.spawnEnemyAPI(enemy).APIInstance.instance;
         }
         if(enemy is String)
         {
            list = ResourceManager.getResourceByID("enemies").getProp("metadata").enemy_list;
            for(i = 0; i < list.length; i++)
            {
               if(list[i].name === enemy)
               {
                  return _api.spawnEnemyAPI(list[i].classAPI).APIInstance.instance;
               }
            }
         }
         return null;
      }
      
      public static function spawnItem(item:Class) : *
      {
         if(!item)
         {
            throw new Error("Error, could not spawn unspecified Item class");
         }
         return _api.spawnItemAPI(item).APIInstance.instance;
      }
      
      public static function spawnProjectile(projectile:Class, owner:* = null) : *
      {
         if(!projectile)
         {
            throw new Error("Error, could not spawn unspecified Projectile class");
         }
         return _api.spawnProjectileAPI(projectile,Boolean(owner) ? owner.$ext.getAPI().owner : null).APIInstance.instance;
      }
      
      public static function spawnCollisionBoundary(collisionBoundary:Class) : *
      {
         if(!collisionBoundary)
         {
            throw new Error("Error, could not spawn unspecified CollisionBoundary class");
         }
         return _api.spawnCollisionBoundaryAPI(collisionBoundary).APIInstance.instance;
      }
      
      public static function spawnPlatform(platform:Class, solidTerrain:Boolean = true) : *
      {
         if(!platform)
         {
            throw new Error("Error, could not spawn unspecified Platform class");
         }
         return _api.spawnPlatformAPI(platform,solidTerrain).APIInstance.instance;
      }
      
      public static function hitboxTest(firstObject:*, firstObjectType:uint, secondObject:*, secondObjectType:uint) : Array
      {
         var i:int = 0;
         var firstSprite:InteractiveSprite = Boolean(firstObject) ? firstObject.$ext.getAPI().owner : null;
         var secondSprite:InteractiveSprite = Boolean(secondObject) ? secondObject.$ext.getAPI().owner : null;
         var hitboxes:Vector.<HitBoxCollisionResult> = InteractiveSprite.hitTest(firstSprite,secondSprite,firstObjectType,secondObjectType);
         var results:Array = [];
         if(Boolean(hitboxes))
         {
            for(i = 0; i < hitboxes.length; i++)
            {
               results.push(hitboxes[i].OverlapHitBox.BoundingBox.clone());
            }
         }
         return results;
      }
      
      public static function getQualitySettings() : Object
      {
         return _api.getQualitySettings();
      }
      
      public static function isReady() : Boolean
      {
         return Boolean(_api) && _api.ActiveScripts;
      }
      
      public static function currentActiveFinalSmash() : *
      {
         var character:Character = _api.ItemsRef.PlayerUsingSmashBall;
         return Boolean(character) && Boolean(character.APIInstance) ? character.APIInstance.instance : null;
      }
      
      public static function getSmashBallInstance() : *
      {
         var item:Item = _api.ItemsRef.CurrentSmashBall;
         return Boolean(item) && Boolean(item.APIInstance) ? item.APIInstance.instance : null;
      }
      
      public static function enableSmashBallSpawn(value:Boolean) : void
      {
         _api.ItemsRef.SmashBallDisabled = value;
      }
      
      public static function isSmashBallSpawnEnabled() : Boolean
      {
         return _api.ItemsRef.SmashBallDisabled;
      }
      
      public static function isDebug() : Boolean
      {
         return Main.DEBUG;
      }
      
      public static function addHUDDetection(mc:MovieClip) : void
      {
         _api.HudRef.addHUDDetection(mc);
      }
      
      public static function removeHUDDetection(mc:MovieClip) : void
      {
         _api.HudRef.removeHUDDetection(mc);
      }
      
      public static function addTimedCameraTarget(subject:*, length:int) : void
      {
         if(subject is MovieClip)
         {
            _api.CamRef.addTimedTarget(subject,length);
         }
         else if(subject is Point)
         {
            _api.CamRef.addTimedTargetPoint(subject,length);
         }
         else if("$ext" in subject && subject.$ext.getAPI().owner is InteractiveSprite)
         {
            _api.CamRef.addTimedTarget(InteractiveSprite(subject).MC,length);
         }
      }
      
      public static function removeTimedCameraTarget(subject:*) : void
      {
         if(subject is MovieClip)
         {
            _api.CamRef.deleteTimedTarget(subject);
         }
         else if(subject is Point)
         {
            _api.CamRef.deleteTimedTargetPoint(subject);
         }
         else if("$ext" in subject && subject.$ext.getAPI().owner is InteractiveSprite)
         {
            _api.CamRef.deleteTimedTarget(InteractiveSprite(subject).MC);
         }
      }
      
      public static function hasFeature(featureID:uint) : Boolean
      {
         if(!isReady())
         {
            return false;
         }
         return ModeFeatures.hasFeature(featureID,_api.GameRef.GameMode);
      }
      
      public static function getItemFrequency() : int
      {
         if(!isReady())
         {
            return ItemSettings.FREQUENCY_OFF;
         }
         return _api.ItemsRef.Frequency;
      }
      
      public static function setItemFrequency(value:int) : void
      {
         if(!isReady())
         {
            return;
         }
         _api.ItemsRef.Frequency = value;
      }
      
      public static function addCustomItem(itemData:Object) : void
      {
         if(!isReady())
         {
            return;
         }
         var item:ItemData = new ItemData();
         item.importData(itemData);
         _api.ItemsRef.addCustomItem(item);
      }
      
      public static function getAvailableItemList() : Array
      {
         var list:Vector.<ItemData> = _api.ItemsRef.ItemsList;
         var output:Array = [];
         for(var i:int = 0; i < list.length; i++)
         {
            if(Boolean(list[i]) && Boolean(list[i].ClassAPI))
            {
               output.push(list[i].ClassAPI);
            }
         }
         return output;
      }
      
      public static function getMatchSettings() : Object
      {
         if(!isReady())
         {
            return {};
         }
         return _api.GameRef.LevelData.exportSettings();
      }
      
      public static function getGameSettings() : Object
      {
         if(!isReady())
         {
            return null;
         }
         return _api.GameRef.exportSettings();
      }
      
      public static function getElapsedFrames() : int
      {
         if(!isReady())
         {
            return 0;
         }
         return _api.ElapsedPlayableFrames;
      }
      
      public static function generateUID() : int
      {
         if(!isReady())
         {
            return 0;
         }
         return Utils.getUID();
      }
      
      public static function getRandomItemSpawnLocation() : Point
      {
         if(!isReady())
         {
            return null;
         }
         return _api.ItemsRef.getRandomLocation();
      }
      
      public static function isFSCutscenePlaying() : Boolean
      {
         if(!isReady())
         {
            return false;
         }
         return Boolean(_api.FSCutscene) ? true : false;
      }
      
      public static function createCustomMatch(cls:Class, customMode:*, settings:Object) : *
      {
         var game:Game = new Game();
         game.importSettings(settings);
         game.CustomModeObj = customMode.$ext.getAPI().owner;
         var customMatch:CustomMatch = new CustomMatch(game,{"classAPI":cls});
         return customMatch.APIInstance.instance;
      }
      
      public static function createCustomMenu(cls:Class) : *
      {
         var customMatch:CustomAPIMenu = new CustomAPIMenu({"classAPI":cls});
         return customMatch.APIInstance.instance;
      }
      
      public static function getRandomCharacterID(hideLocked:Boolean = true) : String
      {
         return Stats.getRandomCharacter(hideLocked).StatsName;
      }
      
      public static function getRandomStageID(hideLocked:Boolean = true, hideDisabled:Boolean = true) : String
      {
         return StageSetting.getRandomStage(false,!hideDisabled);
      }
      
      public static function isGameStarted() : Boolean
      {
         if(!isReady())
         {
            return false;
         }
         return !_api.StageEvent;
      }
      
      public static function isGameEnded() : Boolean
      {
         return _api.GameEnded;
      }
      
      public static function endGame(options:Object = null) : void
      {
         if(!isReady())
         {
            return;
         }
         _api.prepareEndGameCustom(options);
      }
      
      public static function getMCByLinkageName(linkage:String) : MovieClip
      {
         return ResourceManager.getLibraryMC(linkage);
      }
      
      public static function getCharacterStats(statsName:String) : Object
      {
         var stats:CharacterData = Stats.getStats(statsName);
         if(Boolean(stats))
         {
            return stats.exportData();
         }
         return null;
      }
      
      public static function queueResources(resources:Array) : void
      {
         ResourceManager.queueResources(resources);
      }
      
      public static function loadResources(options:Object) : void
      {
         ResourceManager.load(options);
      }
      
      public static function getGameTimer() : *
      {
         return _api.TimerRef.APIInstance;
      }
      
      public static function getCamera() : *
      {
         return _api.CamRef.APIInstance;
      }
      
      public static function freezeInputs(frozenStatus:Boolean) : void
      {
         _api.FreezeKeys = frozenStatus;
      }
      
      public static function getItemStatsList(includeHidden:Boolean = true, includeDisabled:Boolean = true) : Array
      {
         return ItemsListData.getItemStatsList(includeHidden,includeDisabled);
      }
      
      public static function getRandomItemStats(includeHidden:Boolean = true, includeDisabled:Boolean = true) : Object
      {
         return ItemsListData.getRandomItemStats(includeHidden,includeDisabled);
      }
      
      public static function getAverageFPS() : Number
      {
         if(!isReady())
         {
            return 0;
         }
         return _api.getFPS();
      }
      
      public static function setFrameRate(frameRate:Number) : void
      {
         if(!isReady() || _api.GameEnded)
         {
            return;
         }
         Main.Root.stage.frameRate = frameRate;
      }
      
      public static function getAssistTrophyStatsList(type:String = "common") : Array
      {
         var list:Array = ResourceManager.getAssistStatsData()[type];
         var clonedList:Array = [];
         for(var i:int = 0; i < list.length; i++)
         {
            clonedList.push(list[i]);
         }
         return clonedList;
      }
      
      public static function getPokemonStatsList(type:String = "common") : Array
      {
         var list:Array = ResourceManager.getPokemonStatsData()[type];
         var clonedList:Array = [];
         for(var i:int = 0; i < list.length; i++)
         {
            clonedList.push(list[i]);
         }
         return clonedList;
      }
      
      public static function getGlobalVar(name:String) : *
      {
         return DebugConsole.globalHash[name];
      }
      
      public static function setGlobalVar(name:String, value:*) : void
      {
         DebugConsole.globalHash[name] = value;
      }
      
      public static function getSnapshot(options:Object = null) : BitmapData
      {
         Main.Root.graphics.beginFill(0,1);
         Main.Root.graphics.drawRect(0,0,Main.Width,Main.Height);
         _api.HudRef.Container.alpha = 0;
         var result:BitmapData = _api.getSnapshot(options);
         _api.HudRef.Container.alpha = 1;
         Main.Root.graphics.clear();
         return result;
      }
      
      public static function getTargetTestSaveData(stageID:String, statsName:String) : Object
      {
         return SaveData.getTargetTestData(stageID,statsName);
      }
      
      public static function getManifest() : Object
      {
         return Utils.cloneObject(ResourceManager.manifestJSONData);
      }
      
      public static function getCustomMode() : *
      {
         var mode:CustomMode = _api.GameRef.CustomModeObj;
         if(Boolean(mode))
         {
            return mode.APIInstance.instance;
         }
         return null;
      }
      
      public static function getGameMode() : int
      {
         if(!isReady())
         {
            return Mode.NULL;
         }
         return _api.GameRef.GameMode;
      }
      
      public static function getCustomMatch() : *
      {
         var match:CustomMatch = _api.GameRef.CustomMatchObj;
         if(Boolean(match))
         {
            return match.APIInstance.instance;
         }
         return null;
      }
      
      public static function getUnlockableData() : Object
      {
         return isReady() ? Utils.cloneObject(_api.GameRef.LevelData.unlocks) : Utils.cloneObject(SaveData.Unlocks);
      }
      
      public static function triggerUnlock(id:String) : Boolean
      {
         var unlockable:Unlockable = UnlockController.getUnlockableByID(id);
         if(Boolean(unlockable))
         {
            unlockable.TriggerUnlock = true;
            return true;
         }
         return false;
      }
      
      public static function getCostumeData(statsName:String, team:int, num:int = -1) : Object
      {
         return ResourceManager.getCostume(statsName,Utils.getColorString(team),num);
      }
      
      public static function getMetalCostume(statsName:String) : Object
      {
         return ResourceManager.getMetalCostume(statsName);
      }
      
      public static function getWinners() : Array
      {
         if(!isReady())
         {
            return null;
         }
         return _api.getWinners();
      }
      
      public static function getLosers() : Array
      {
         if(!isReady())
         {
            return null;
         }
         return _api.getLosers();
      }
   }
}

