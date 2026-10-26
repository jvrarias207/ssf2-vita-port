package com.mcleodgaming.ssf2.engine
{
   import com.adobe.images.*;
   import com.mcleodgaming.mgn.events.MGNEvent;
   import com.mcleodgaming.mgn.events.MGNEventManager;
   import com.mcleodgaming.mgn.net.ProtocolSetting;
   import com.mcleodgaming.ssf2.Config;
   import com.mcleodgaming.ssf2.Main;
   import com.mcleodgaming.ssf2.Version;
   import com.mcleodgaming.ssf2.api.SSF2API;
   import com.mcleodgaming.ssf2.api.SSF2Event;
   import com.mcleodgaming.ssf2.api.SSF2Stage;
   import com.mcleodgaming.ssf2.assists.*;
   import com.mcleodgaming.ssf2.audio.*;
   import com.mcleodgaming.ssf2.controllers.*;
   import com.mcleodgaming.ssf2.enemies.*;
   import com.mcleodgaming.ssf2.enums.*;
   import com.mcleodgaming.ssf2.events.EventManager;
   import com.mcleodgaming.ssf2.items.*;
   import com.mcleodgaming.ssf2.menus.*;
   import com.mcleodgaming.ssf2.net.*;
   import com.mcleodgaming.ssf2.platforms.*;
   import com.mcleodgaming.ssf2.pokemon.*;
   import com.mcleodgaming.ssf2.util.*;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import flash.geom.Point;
   import flash.media.Sound;
   import flash.utils.ByteArray;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   
   public class StageData
   {
      
      private var m_apiInstance:SSF2Stage;
      
      private var EFFECT_LIMIT:int = 60;
      
      private var EFFECT_LIMIT_SECONDARY:int = 10;
      
      private var ROOT:MovieClip;
      
      private var STAGE:MovieClip;
      
      private var STAGEPARENT:MovieClip;
      
      private var STAGEBACKGROUND:MovieClip;
      
      private var STAGEFOREGROUND:MovieClip;
      
      private var STAGEEFFECTS:MovieClip;
      
      private var WEATHER:MovieClip;
      
      private var WEATHERMASK:MovieClip;
      
      private var TAGS:MovieClip;
      
      private var REFLECTIONS:MovieClip;
      
      private var REFLECTIONSMASK:MovieClip;
      
      private var SHADOWS:MovieClip;
      
      private var SHADOWMASK:MovieClip;
      
      private var LIGHTSOURCE:MovieClip;
      
      private var CUTSCENE:MovieClip;
      
      private var HUD:HudMenu;
      
      private var HUDFOREGROUND:MovieClip;
      
      private var HUDOVERLAY:MovieClip;
      
      private var HUDTEXT:MovieClip;
      
      private var CAM:Vcam;
      
      private var ITEMS:ItemGenerator;
      
      private var GAME:Game;
      
      private var SOUNDQUEUE:SoundQueue;
      
      private var TIMER:GameTimer;
      
      private var CONTROLLERS:Vector.<Controller>;
      
      private var CAMBOUNDS:MovieClip;
      
      private var SMASHBALLBOUNDS:MovieClip;
      
      private var DEATHBOUNDS:MovieClip;
      
      private var TERRAINS:Vector.<Platform>;
      
      private var PLATFORMS:Vector.<Platform>;
      
      private var COLLISION_BOUNDARIES:Vector.<BitmapCollisionBoundary>;
      
      private var MOVINGPLATFORMS:Vector.<MovingPlatform>;
      
      private var TARGETS:Vector.<TargetTestTarget>;
      
      private var ITEMGENS:Vector.<MovieClip>;
      
      private var WARNINGBOUNDS_UL:Vector.<BitmapCollisionBoundary>;
      
      private var WARNINGBOUNDS_UR:Vector.<BitmapCollisionBoundary>;
      
      private var WARNINGBOUNDS_LL:Vector.<BitmapCollisionBoundary>;
      
      private var WARNINGBOUNDS_LR:Vector.<BitmapCollisionBoundary>;
      
      private var LEDGES_L:Vector.<MovieClip>;
      
      private var LEDGES_R:Vector.<MovieClip>;
      
      private var START_POSITIONS:Vector.<MovieClip>;
      
      private var SPAWN_POSITIONS:Vector.<MovieClip>;
      
      private var WALLS:Vector.<BitmapCollisionBoundary>;
      
      private var BEACONS:Vector.<Beacon>;
      
      private var ADJMATRIX:Array;
      
      private var m_eventManager:EventManager;
      
      private var READY:Boolean;
      
      private var ONLINEMODE:Boolean;
      
      private var REPLAYMODE:Boolean;
      
      private var m_apiDisposeList:Array;
      
      private var m_hitBoxProcessor:HitBoxProcessor;
      
      private var m_countdownTimer:MovieClip;
      
      private var m_onlineFrameBuffer:FrameTimer;
      
      private var m_onlineMatchDowngradeTimeout:Timer;
      
      private var m_onlineMatchStartTimeout:Timer;
      
      private var m_onlineMatchEndTimeout:Timer;
      
      private var m_onlineLockPending:Boolean;
      
      private var m_onlineModeLastPing:Number;
      
      private var m_onlineMatchControlsTimer:Timer;
      
      private var m_activeScripts:Boolean;
      
      private var m_fpsTimer:Debug_fps;
      
      private var m_noContest:Boolean;
      
      private var m_retryMatch:Boolean;
      
      private var m_pokemonCount:int;
      
      private var m_assistCount:int;
      
      private var m_cuccoCount:int;
      
      private var m_entranceZoomTimer:FrameTimer;
      
      private var m_entranceZoomMode:int;
      
      private var m_currentEntrance:int;
      
      private var m_airDodge:String;
      
      private var m_paused:Boolean;
      
      private var m_pausedLetGo:Boolean;
      
      private var m_pauseCamHeight:Number;
      
      private var m_replayFrameStep:Boolean;
      
      private var m_zLetGo:Boolean;
      
      private var m_paused_id:int;
      
      private var m_fsCutscene:MovieClip;
      
      private var m_fsCutins:int;
      
      private var m_hazardsOn:Boolean;
      
      private var m_justPaused:Boolean;
      
      private var m_event:Boolean;
      
      private var m_music:String;
      
      private var m_loopLoc:Number;
      
      private var PLAYERS:Vector.<Character>;
      
      private var CHARACTERS:Vector.<Character>;
      
      private var ENEMY:Vector.<Enemy>;
      
      private var PROJECTILES:Vector.<Projectile>;
      
      private var m_effectList:Vector.<MovieClip>;
      
      private var m_effectIndex:int;
      
      private var m_effectOverlayList:Vector.<MovieClip>;
      
      private var m_effectOverlayIndex:int;
      
      private var m_effectHUDList:Vector.<MovieClip>;
      
      private var m_effectHUDIndex:int;
      
      private var m_effectHUDOverlayList:Vector.<MovieClip>;
      
      private var m_effectHUDOverlayIndex:int;
      
      private var m_effectBGList:Vector.<MovieClip>;
      
      private var m_effectBGIndex:int;
      
      private var m_effectWeatherList:Vector.<MovieClip>;
      
      private var m_effectWeatherIndex:int;
      
      private var m_wasReset:Boolean;
      
      private var m_gravityMultiplier:Number;
      
      private var m_disableCeilingDeath:Boolean;
      
      private var m_disableFallDeath:Boolean;
      
      private var m_freezeKeys:Boolean;
      
      private var m_endGameTimer:FrameTimer;
      
      private var m_canSuddenDeath:Boolean;
      
      private var m_suddenDeath:Boolean;
      
      private var m_suddenDeathIDs:Array;
      
      private var m_gameEnded:Boolean;
      
      private var m_gameEndedExit:Boolean;
      
      private var m_slowFrameRate:Boolean;
      
      private var m_endTrigger:Boolean;
      
      private var m_endGameOptions:Object;
      
      private var m_nullPlayers:Array;
      
      private var m_crowdChantDelay:FrameTimer;
      
      private var m_crowdChantTimer:FrameTimer;
      
      private var m_crowdChantID:int;
      
      private var m_crowdChantSound:SoundObject;
      
      protected var m_pokemon:Vector.<Class>;
      
      protected var m_assists:Vector.<Class>;
      
      protected var m_pokemonRare:Vector.<Class>;
      
      protected var m_assistsRare:Vector.<Class>;
      
      protected var m_narratorSpeech:SoundObject;
      
      private var m_startDelayTimer:FrameTimer;
      
      private var m_startTime:int;
      
      private var m_endTime:int;
      
      private var m_elapsedFrames:int;
      
      private var m_elapsedPlayableFrames:int;
      
      private var m_pausedTimestamp:int;
      
      private var m_totalPausedTime:int;
      
      private var m_soundMemory:Dictionary;
      
      private var m_qualitySettings:Object;
      
      private var m_replayData:ReplayData;
      
      private var m_replayFrameRateMultiplier:Number;
      
      private var m_queuedAutoSave:Boolean;
      
      private var m_timers:Vector.<IntervalTimer>;
      
      private var m_playerStartIndices:Array;
      
      private var m_starKOEnabled:Boolean;
      
      private var m_screenKOEnabled:Boolean;
      
      private var m_logText:String;
      
      private var m_collisionsEnabled:Boolean;
      
      public function StageData(controllers:Vector.<Controller>, root:MovieClip, stageAPI:Class, stageMC:MovieClip, hud:HudMenu, camParam:VcamSettings, game:Game, soundQueue:SoundQueue, music:String, loopLoc:Number)
      {
         var j:* = undefined;
         var ps:int = 0;
         var firstChar:String = null;
         var firstCharID:int = 0;
         var firstExpansion:int = 0;
         var playerSettings:Object = null;
         super();
         SSF2API.init(this);
         this.m_apiInstance = Boolean(stageAPI) ? new SSF2Stage(stageAPI,this) : null;
         Utils.resetUID();
         var i:int = 0;
         this.m_wasReset = false;
         this.m_startDelayTimer = new FrameTimer(2);
         this.GAME = game;
         this.m_qualitySettings = {
            "stage_effects":SaveData.Quality.stage_effects,
            "fullscreen_quality":SaveData.Quality.fullscreen_quality,
            "global_effects":(Boolean(SaveData.Quality.global_effects) ? true : false),
            "hit_effects":(Boolean(SaveData.Quality.hit_effects) ? true : false),
            "hud_alpha":(Boolean(SaveData.Quality.hud_alpha) ? true : false),
            "knockback_smoke":(Boolean(SaveData.Quality.knockback_smoke) ? true : false),
            "screen_flash":(Boolean(SaveData.Quality.screen_flash) ? true : false),
            "shadows":(Boolean(SaveData.Quality.shadows) ? true : false),
            "display_quality":SaveData.Quality.display_quality,
            "weather":(Boolean(SaveData.Quality.weather) ? true : false),
            "ambient_lighting":(Boolean(SaveData.Quality.ambient_lighting) ? true : false),
            "menu_bg":(Boolean(SaveData.Quality.menu_bg) ? true : false)
         };
         this.m_canSuddenDeath = !this.GAME.SuddenDeath;
         this.m_collisionsEnabled = true;
         this.m_suddenDeath = false;
         this.m_suddenDeathIDs = null;
         this.ONLINEMODE = ModeFeatures.hasFeature(ModeFeatures.MULTIPLAYER_MANAGER,this.GAME.GameMode);
         this.m_onlineFrameBuffer = new FrameTimer(MultiplayerManager.INPUT_BUFFER);
         if(SpecialMode.modeEnabled(this.GAME.LevelData.specialModes,SpecialMode.SLOW))
         {
            MultiplayerManager.NORMAL_FPS = Main.FRAMERATE / 2;
            MultiplayerManager.MAX_FPS = 20;
         }
         else if(SpecialMode.modeEnabled(this.GAME.LevelData.specialModes,SpecialMode.LIGHTNING))
         {
            MultiplayerManager.NORMAL_FPS = Main.FRAMERATE * 2;
            MultiplayerManager.MAX_FPS = 70;
         }
         else
         {
            MultiplayerManager.NORMAL_FPS = Main.FRAMERATE;
            MultiplayerManager.MAX_FPS = 35;
         }
         this.m_onlineMatchDowngradeTimeout = new Timer(15000,1);
         this.m_onlineMatchDowngradeTimeout.addEventListener(TimerEvent.TIMER_COMPLETE,this.onlineModeMatchDowngradeTimeout);
         this.m_onlineMatchStartTimeout = new Timer(30000,1);
         this.m_onlineMatchStartTimeout.addEventListener(TimerEvent.TIMER_COMPLETE,this.onlineModeMatchStartTimeout);
         this.m_onlineMatchEndTimeout = new Timer(10000,1);
         this.m_onlineMatchEndTimeout.addEventListener(TimerEvent.TIMER_COMPLETE,this.onlineModeMatchEndTimeout);
         this.m_onlineLockPending = false;
         this.m_onlineModeLastPing = new Date().getTime();
         this.m_onlineMatchControlsTimer = new Timer(Math.floor(1000 / MultiplayerManager.NORMAL_FPS));
         this.m_onlineMatchControlsTimer.addEventListener(TimerEvent.TIMER,this.onlineModeSendControls);
         this.m_effectList = new Vector.<MovieClip>();
         this.m_effectOverlayList = new Vector.<MovieClip>();
         this.m_effectHUDList = new Vector.<MovieClip>();
         this.m_effectHUDOverlayList = new Vector.<MovieClip>();
         this.m_effectBGList = new Vector.<MovieClip>();
         this.m_effectWeatherList = new Vector.<MovieClip>();
         for(i = 0; i < this.EFFECT_LIMIT; i++)
         {
            this.m_effectList.push(null);
            this.m_effectOverlayList.push(null);
            this.m_effectHUDList.push(null);
            this.m_effectHUDOverlayList.push(null);
            this.m_effectBGList.push(null);
            this.m_effectWeatherList.push(null);
         }
         this.m_effectIndex = 0;
         this.m_effectOverlayIndex = 0;
         this.m_effectHUDIndex = 0;
         this.m_effectHUDIndex = 0;
         this.m_effectBGIndex = 0;
         this.m_effectWeatherIndex = 0;
         this.m_apiDisposeList = new Array();
         this.m_hitBoxProcessor = new HitBoxProcessor();
         this.m_soundMemory = new Dictionary(String);
         this.m_timers = new Vector.<IntervalTimer>();
         this.m_replayData = new ReplayData(this.GAME.PlayerSettings.length);
         this.m_replayFrameRateMultiplier = 1;
         this.m_queuedAutoSave = false;
         if(!this.GAME.ReplayDataObj && ModeFeatures.hasFeature(ModeFeatures.ALLOW_REPLAY_RECORD,this.GAME.GameMode))
         {
            this.REPLAYMODE = false;
            if(this.GAME.SuddenDeath)
            {
               this.m_replayData = GameController.tmpStageData.ReplayDataObj;
            }
            else
            {
               this.m_replayData.MatchSettings = this.GAME.LevelData.exportSettings();
               this.m_replayData.ItemSettingsObj = this.GAME.Items.exportSettings();
               this.m_replayData.GameMode = this.GAME.GameMode;
               for(ps = 0; ps < this.GAME.PlayerSettings.length; ps++)
               {
                  this.m_replayData.PlayerData[ps] = this.GAME.PlayerSettings[ps].exportSettings();
                  if(this.GAME.PlayerSettings[ps].character == "random")
                  {
                  }
               }
            }
         }
         else if(Boolean(this.GAME.ReplayDataObj) && ModeFeatures.hasFeature(ModeFeatures.ALLOW_REPLAY_RECORD,this.GAME.GameMode))
         {
            this.REPLAYMODE = true;
            if(this.GAME.SuddenDeath)
            {
               this.m_replayData = GameController.tmpStageData.ReplayDataObj;
            }
            else
            {
               this.m_replayData.importReplay(this.GAME.ReplayDataObj.exportReplay());
               this.m_replayData.resetPointers();
            }
         }
         if(this.GAME.SuddenDeath)
         {
            Utils.shuffleRandom();
         }
         if(ModeFeatures.hasFeature(ModeFeatures.FORCE_NO_TEAM_DAMAGE,this.GAME.GameMode))
         {
            this.GAME.LevelData.teamDamage = false;
         }
         if(Config.enable_hazards)
         {
            this.m_hazardsOn = this.GAME.LevelData.hazards;
         }
         else
         {
            this.m_hazardsOn = false;
         }
         this.READY = false;
         this.ROOT = root;
         this.STAGEPARENT = stageMC;
         this.STAGE = stageMC.terrain;
         this.HUD = hud;
         this.HUDFOREGROUND = hud.SubMenu.foreground;
         this.HUDOVERLAY = new MovieClip();
         this.HUDTEXT = new MovieClip();
         hud.SubMenu.addChild(this.HUDOVERLAY);
         hud.SubMenu.addChild(this.HUDTEXT);
         this.WEATHER = GameController.weather;
         this.CUTSCENE = GameController.cutscene;
         this.WEATHERMASK = Boolean(this.STAGEPARENT.weatherMask) ? this.STAGEPARENT.weatherMask : null;
         if(Boolean(this.WEATHERMASK))
         {
            this.WEATHER.mask = this.WEATHERMASK;
         }
         this.TAGS = GameController.tags;
         this.REFLECTIONS = new MovieClip();
         this.REFLECTIONS.x = this.STAGE.x;
         this.REFLECTIONS.y = this.STAGE.y;
         this.STAGEPARENT.addChildAt(this.REFLECTIONS,this.STAGEPARENT.getChildIndex(this.STAGE));
         this.REFLECTIONSMASK = this.STAGEPARENT["reflectionMask"];
         if(Boolean(this.REFLECTIONSMASK))
         {
            this.REFLECTIONS.mask = this.REFLECTIONSMASK;
            this.REFLECTIONSMASK.visible = false;
         }
         this.SHADOWS = new MovieClip();
         this.SHADOWS.x = this.STAGE.x;
         this.SHADOWS.y = this.STAGE.y;
         this.STAGEPARENT.addChildAt(this.SHADOWS,this.STAGEPARENT.getChildIndex(this.STAGE));
         this.SHADOWMASK = this.STAGEPARENT["shadowMask"];
         if(Boolean(this.SHADOWMASK))
         {
            this.SHADOWS.mask = this.SHADOWMASK;
            this.SHADOWMASK.visible = false;
         }
         this.STAGEEFFECTS = MovieClip(this.STAGEPARENT.addChild(new MovieClip()));
         this.LIGHTSOURCE = null;
         this.SOUNDQUEUE = soundQueue;
         this.CONTROLLERS = controllers;
         this.CAMBOUNDS = this.STAGE["camBoundary"];
         this.SMASHBALLBOUNDS = this.STAGE["smashBallBoundary"];
         this.DEATHBOUNDS = this.STAGE["deathBoundary"];
         camParam.mainTerrain = this.CAMBOUNDS;
         this.CAM = new Vcam(camParam,this.STAGE,Main.Root);
         this.TIMER = new GameTimer({
            "instanceName":"clock",
            "countdown":this.GAME.CountDown,
            "startAt":this.GAME.Time
         },this);
         if(ModeFeatures.hasFeature(ModeFeatures.INVERTED_TIMER,this.GAME.GameMode))
         {
            this.TIMER.CountDown = false;
            this.TIMER.setCurrentTime(0);
         }
         this.TIMER.TimeMC.visible = false;
         this.TERRAINS = new Vector.<Platform>();
         this.PLATFORMS = new Vector.<Platform>();
         this.COLLISION_BOUNDARIES = new Vector.<BitmapCollisionBoundary>();
         this.MOVINGPLATFORMS = new Vector.<MovingPlatform>();
         this.TARGETS = new Vector.<TargetTestTarget>();
         this.WARNINGBOUNDS_UL = new Vector.<BitmapCollisionBoundary>();
         this.WARNINGBOUNDS_UR = new Vector.<BitmapCollisionBoundary>();
         this.WARNINGBOUNDS_LL = new Vector.<BitmapCollisionBoundary>();
         this.WARNINGBOUNDS_LR = new Vector.<BitmapCollisionBoundary>();
         this.LEDGES_L = new Vector.<MovieClip>();
         this.LEDGES_R = new Vector.<MovieClip>();
         this.START_POSITIONS = new Vector.<MovieClip>();
         this.SPAWN_POSITIONS = new Vector.<MovieClip>();
         this.WALLS = new Vector.<BitmapCollisionBoundary>();
         this.BEACONS = new Vector.<Beacon>();
         this.PLAYERS = new Vector.<Character>();
         this.CHARACTERS = new Vector.<Character>();
         this.ENEMY = new Vector.<Enemy>();
         this.PROJECTILES = new Vector.<Projectile>();
         this.m_activeScripts = false;
         this.m_eventManager = new EventManager();
         this.m_entranceZoomTimer = new FrameTimer(15 * this.GAME.PlayerSettings.length);
         this.m_entranceZoomMode = Utils.random() > 0.5 ? 1 : 2;
         this.m_currentEntrance = 0;
         this.m_airDodge = SaveData.AirDodge;
         this.m_narratorSpeech = null;
         this.m_endGameTimer = new FrameTimer(ModeFeatures.hasFeature(ModeFeatures.EXTENDED_ENDTIMER,this.GAME.GameMode) ? int(32 * 4) : 32);
         this.m_gameEnded = false;
         this.m_gameEndedExit = true;
         this.m_slowFrameRate = false;
         this.m_endTrigger = false;
         this.m_endGameOptions = null;
         this.m_music = music;
         this.m_loopLoc = loopLoc;
         this.m_noContest = false;
         this.m_retryMatch = false;
         this.m_freezeKeys = false;
         this.m_pokemonCount = 0;
         this.m_assistCount = 0;
         this.m_cuccoCount = 0;
         this.m_startTime = getTimer();
         this.m_endTime = this.m_startTime;
         this.m_elapsedFrames = 0;
         this.m_elapsedPlayableFrames = 0;
         this.m_pausedTimestamp = 0;
         this.m_totalPausedTime = 0;
         this.m_starKOEnabled = true;
         this.m_screenKOEnabled = true;
         this.ITEMGENS = new Vector.<MovieClip>();
         this.m_nullPlayers = new Array();
         if(ModeFeatures.hasFeature(ModeFeatures.FILL_PLAYER_SLOTS,this.GAME.GameMode))
         {
            firstChar = null;
            firstCharID = -1;
            firstExpansion = -1;
            for(i = 2; i <= this.GAME.PlayerSettings.length; i++)
            {
               if(this.GAME.PlayerSettings[i - 1].character != null)
               {
                  firstChar = this.GAME.PlayerSettings[i - 1].character;
                  firstCharID = i;
                  firstExpansion = this.GAME.PlayerSettings[i - 1].expansion;
                  break;
               }
            }
            for(i = 2; i <= this.GAME.PlayerSettings.length; i++)
            {
               if(this.GAME.PlayerSettings[i - 1].character == null)
               {
                  this.GAME.PlayerSettings[i - 1].character = firstChar;
                  this.GAME.PlayerSettings[i - 1].expansion = firstExpansion;
                  Main.RandCharList[i - 1] = Main.RandCharList[firstCharID - 1];
                  this.m_nullPlayers.push(i - 1);
               }
            }
         }
         var tmpArr:Array = new Array();
         i = 0;
         j = 0;
         while(i < this.GAME.PlayerSettings.length)
         {
            if(this.GAME.PlayerSettings[i].exist && Boolean(this.GAME.PlayerSettings[i].character))
            {
               tmpArr.push(j++);
            }
            i++;
         }
         if(j > 2)
         {
            Utils.randomizeArray(tmpArr);
         }
         this.m_playerStartIndices = new Array();
         i = 0;
         j = 0;
         while(i < this.GAME.PlayerSettings.length)
         {
            if(this.GAME.PlayerSettings[i].exist && Boolean(this.GAME.PlayerSettings[i].character))
            {
               this.m_playerStartIndices.push(tmpArr.splice(0,1)[0]);
            }
            else
            {
               this.m_playerStartIndices.push(null);
            }
            i++;
         }
         this.findObjects(this.STAGE);
         if(Boolean(this.STAGEPARENT.foreground))
         {
            this.STAGEFOREGROUND = this.STAGEPARENT.foreground;
            this.findObjects(this.STAGEPARENT.foreground);
         }
         else
         {
            this.STAGEFOREGROUND = new MovieClip();
            this.STAGEPARENT.addChild(this.STAGEFOREGROUND);
         }
         if(Boolean(this.STAGEPARENT.background))
         {
            this.STAGEBACKGROUND = this.STAGEPARENT.background;
            this.findObjects(this.STAGEPARENT.background);
         }
         else
         {
            this.STAGEBACKGROUND = new MovieClip();
            this.STAGEPARENT.addChildAt(this.STAGEBACKGROUND,0);
         }
         this.createBeaconData();
         for(i = 0; i < this.MOVINGPLATFORMS.length; i++)
         {
            this.MOVINGPLATFORMS[i].findForegroundPieces();
            this.MOVINGPLATFORMS[i].findLedges();
         }
         this.ITEMS = new ItemGenerator({
            "sizeRatio":this.GAME.SizeRatio,
            "frequency":(this.GAME.SuddenDeath ? 0 : this.GAME.Items.frequency),
            "itemData":this.GAME.Items.items
         },this);
         for(i = 0; i < this.GameRef.PlayerSettings.length; i++)
         {
            this.PLAYERS.push(null);
         }
         this.m_pausedLetGo = true;
         this.m_pauseCamHeight = 0;
         this.m_replayFrameStep = false;
         this.m_zLetGo = true;
         this.m_paused = false;
         this.m_paused_id = 0;
         this.m_fsCutscene = null;
         this.m_fsCutins = 0;
         this.m_justPaused = false;
         this.m_event = true;
         if(ModeFeatures.hasFeature(ModeFeatures.FORCE_NO_ITEM_AUTO_SPAWN,this.GAME.GameMode))
         {
            this.ItemsRef.Frequency = ItemSettings.FREQUENCY_OFF;
         }
         this.m_pokemon = new Vector.<Class>();
         for each(j in ResourceManager.getPokemonStatsData().common)
         {
            this.m_pokemon.push(j);
         }
         this.m_pokemonRare = new Vector.<Class>();
         for each(j in ResourceManager.getPokemonStatsData().rare)
         {
            this.m_pokemonRare.push(j);
         }
         this.m_assists = new Vector.<Class>();
         for each(j in ResourceManager.getAssistStatsData().common)
         {
            this.m_assists.push(j);
         }
         this.m_assistsRare = new Vector.<Class>();
         for each(j in ResourceManager.getAssistStatsData().rare)
         {
            this.m_assistsRare.push(j);
         }
         this.m_disableCeilingDeath = false;
         this.m_disableFallDeath = false;
         this.m_gravityMultiplier = 1;
         this.m_crowdChantDelay = new FrameTimer(30 * 20);
         this.m_crowdChantTimer = new FrameTimer(30 * 20);
         this.m_crowdChantID = -1;
         this.m_crowdChantSound = null;
         this.m_crowdChantTimer.finish();
         this.m_logText = "";
         if(this.GAME.GameMode === Mode.ONLINE_WAITING_ROOM)
         {
            Main.Root.stage.addEventListener(Event.ENTER_FRAME,this.waitForPlayers);
            if(!MultiplayerManager.IsHost)
            {
               playerSettings = Utils.cloneObject(GameController.onlineModeMatchSettings.playerSettings[0]);
               if(playerSettings.character === "random")
               {
                  playerSettings.character = this.PLAYERS[0].StatsName;
               }
               MultiplayerManager.sendMatchReadySignal({"playerSettings":playerSettings});
            }
         }
         for(i = 1; i <= this.GAME.PlayerSettings.length; i++)
         {
            if(this.GAME.PlayerSettings[i - 1].character != null)
            {
               this.makePlayer(i);
            }
         }
      }
      
      public function get BASE_CLASSES() : Object
      {
         return ResourceManager.getResourceByID(this.GAME.LevelData.stage).MetaData.BASE_CLASSES;
      }
      
      private function findObjects(mc:MovieClip) : void
      {
         var tmpPlayerSetting:PlayerSetting = null;
         var curObject:MovieClip = null;
         var tmpX:Number = NaN;
         var tmpY:Number = NaN;
         var tmpClass:Class = null;
         var enemyStats:EnemyStats = null;
         var playerStartIndex:int = 0;
         var playerSpawnIndex:int = 0;
         var teamStartColor:String = null;
         var teamPlayerStartIndex:int = 0;
         var teamSpawnColor:String = null;
         var teamPlayerRespawnIndex:int = 0;
         var e:int = 0;
         var list:Vector.<*> = new Vector.<*>();
         var teamMap:Object = {
            "red":1,
            "green":2,
            "blue":3,
            "yellow":4
         };
         for(e = 0; e < mc.numChildren; e++)
         {
            list.push(mc.getChildAt(e));
         }
         for(e = 0; e < list.length; e++)
         {
            if(list[e] is MovieClip)
            {
               curObject = MovieClip(list[e]);
               try
               {
                  if(!curObject.type)
                  {
                     continue;
                  }
               }
               catch(error:*)
               {
                  continue;
               }
               if(curObject.type == "enemy")
               {
                  tmpX = curObject.x;
                  tmpY = curObject.y;
                  if(Boolean(curObject.className) && Boolean(Main.getClassByName(curObject.className)))
                  {
                     tmpClass = curObject.className is Class ? curObject.className : Main.getClassByName(curObject.className);
                     curObject.parent.removeChild(curObject);
                     this.ENEMY.unshift(new tmpClass(this,tmpX,tmpY,-1));
                  }
                  else if(Boolean(curObject.classAPI))
                  {
                     enemyStats = new EnemyStats();
                     enemyStats.importData({"classAPI":curObject.classAPI});
                     this.ENEMY.unshift(new Enemy(enemyStats,this,tmpX,tmpY,-1,curObject));
                  }
               }
               else if(curObject.type == "terrain")
               {
                  if(Boolean(curObject.className) && Boolean(Main.getClassByName(curObject.className)) || Boolean(curObject.classAPI))
                  {
                     if(Boolean(curObject.classAPI))
                     {
                        this.MOVINGPLATFORMS.unshift(new MovingPlatform(curObject,this,"ground",{"classAPI":curObject.classAPI}));
                     }
                     else if(curObject.className is Class)
                     {
                        this.MOVINGPLATFORMS.unshift(new curObject.className(curObject,this));
                     }
                     else
                     {
                        this.MOVINGPLATFORMS.unshift(new (Main.getClassByName(curObject.className))(curObject,this));
                     }
                     this.TERRAINS.unshift(this.MOVINGPLATFORMS[0]);
                  }
                  else
                  {
                     this.TERRAINS.unshift(new MovingPlatform(curObject,this));
                  }
                  this.TERRAINS[0].BMPData.rotation = 80;
               }
               else if(curObject.type == "platform")
               {
                  if(Boolean(curObject.ground) && Boolean(curObject.noDropThrough))
                  {
                     curObject.ground.noDropThrough = true;
                  }
                  if(Boolean(curObject.className) && Boolean(Main.getClassByName(curObject.className)) || Boolean(curObject.classAPI))
                  {
                     if(Boolean(curObject.classAPI))
                     {
                        this.MOVINGPLATFORMS.unshift(new MovingPlatform(curObject,this,"ground",{"classAPI":curObject.classAPI}));
                     }
                     else if(curObject.className is Class)
                     {
                        this.MOVINGPLATFORMS.unshift(new curObject.className(curObject,this));
                     }
                     else
                     {
                        this.MOVINGPLATFORMS.unshift(new (Main.getClassByName(curObject.className))(curObject,this));
                     }
                     this.PLATFORMS.unshift(this.MOVINGPLATFORMS[0]);
                  }
                  else
                  {
                     this.PLATFORMS.unshift(new MovingPlatform(curObject,this));
                  }
               }
               else if(curObject.type == "collision")
               {
                  if(Boolean(curObject.className) && Boolean(Main.getClassByName(curObject.className)) || Boolean(curObject.classAPI))
                  {
                     if(Boolean(curObject.classAPI))
                     {
                        this.COLLISION_BOUNDARIES.unshift(new BitmapCollisionBoundary(curObject,this,"ground",false,{"classAPI":curObject.classAPI}));
                     }
                     else if(curObject.className is Class)
                     {
                        this.COLLISION_BOUNDARIES.unshift(new curObject.className(curObject,this));
                     }
                     else
                     {
                        this.COLLISION_BOUNDARIES.unshift(new (Main.getClassByName(curObject.className))(curObject,this));
                     }
                  }
                  else
                  {
                     this.COLLISION_BOUNDARIES.unshift(new BitmapCollisionBoundary(curObject,this));
                  }
               }
               else if(curObject.type == "itemGen")
               {
                  this.ITEMGENS.push(curObject);
               }
               else if(curObject.type == "l_bound_upper")
               {
                  this.WARNINGBOUNDS_UL.push(new BitmapCollisionBoundary(curObject,this,"ground",true));
                  this.COLLISION_BOUNDARIES.push(this.WARNINGBOUNDS_UL[this.WARNINGBOUNDS_UL.length - 1]);
               }
               else if(curObject.type == "r_bound_upper")
               {
                  this.WARNINGBOUNDS_UR.push(new BitmapCollisionBoundary(curObject,this,"ground",true));
                  this.COLLISION_BOUNDARIES.push(this.WARNINGBOUNDS_UR[this.WARNINGBOUNDS_UR.length - 1]);
               }
               else if(curObject.type == "l_bound_lower")
               {
                  this.WARNINGBOUNDS_LL.push(new BitmapCollisionBoundary(curObject,this,"ground",true));
                  this.COLLISION_BOUNDARIES.push(this.WARNINGBOUNDS_LL[this.WARNINGBOUNDS_LL.length - 1]);
               }
               else if(curObject.type == "r_bound_lower")
               {
                  this.WARNINGBOUNDS_LR.push(new BitmapCollisionBoundary(curObject,this,"ground",true));
                  this.COLLISION_BOUNDARIES.push(this.WARNINGBOUNDS_LR[this.WARNINGBOUNDS_LR.length - 1]);
               }
               else if(curObject.type == "l_ledge")
               {
                  this.LEDGES_L.push(curObject);
                  if(Boolean(HitBoxAnimation.AnimationsList["_ledge_"]))
                  {
                     curObject.hitBoxAnim = HitBoxAnimation.AnimationsList["_ledge_"];
                  }
                  else
                  {
                     curObject.hitBoxAnim = new HitBoxAnimation("_ledge_");
                     HitBoxAnimation(curObject.hitBoxAnim).addHitBox(1,new HitBoxSprite(HitBoxSprite.LEDGE,curObject.getBounds(curObject)));
                  }
               }
               else if(curObject.type == "r_ledge")
               {
                  this.LEDGES_R.push(curObject);
                  if(Boolean(HitBoxAnimation.AnimationsList["_ledge_"]))
                  {
                     curObject.hitBoxAnim = HitBoxAnimation.AnimationsList["_ledge_"];
                  }
                  else
                  {
                     curObject.hitBoxAnim = new HitBoxAnimation("_ledge_");
                     HitBoxAnimation(curObject.hitBoxAnim).addHitBox(1,new HitBoxSprite(HitBoxSprite.LEDGE,curObject.getBounds(curObject)));
                  }
               }
               else if(curObject.type == "beacon")
               {
                  this.BEACONS.push(new Beacon(curObject,this,this.BEACONS.length));
               }
               else if(curObject.type == "wallstick")
               {
                  this.WALLS.push(new BitmapCollisionBoundary(curObject,this));
               }
               else if(curObject.type == "target")
               {
                  if(Boolean(curObject.classAPI))
                  {
                     this.TARGETS.unshift(new TargetTestTarget(curObject,this,{"classAPI":curObject.classAPI}));
                  }
                  else
                  {
                     this.TARGETS.unshift(new TargetTestTarget(curObject,this));
                  }
               }
               else if(Boolean(curObject.type) && curObject.type.match(/^p(\d+)_start$/) != null)
               {
                  this.START_POSITIONS.push(curObject);
                  playerStartIndex = parseInt(curObject.type.match(/p(\d+)_start/)[1]) - 1;
                  if(this.m_playerStartIndices.indexOf(playerStartIndex) >= 0)
                  {
                     this.GAME.PlayerSettings[this.m_playerStartIndices.indexOf(playerStartIndex)].x_start = curObject.x;
                     this.GAME.PlayerSettings[this.m_playerStartIndices.indexOf(playerStartIndex)].y_start = curObject.y;
                     this.GAME.PlayerSettings[this.m_playerStartIndices.indexOf(playerStartIndex)].facingRight = curObject.transform.matrix.a >= 0;
                  }
               }
               else if(Boolean(curObject.type) && curObject.type.match(/^p(\d+)_spawn$/) != null)
               {
                  this.SPAWN_POSITIONS.push(curObject);
                  playerSpawnIndex = parseInt(curObject.type.match(/^p(\d+)_spawn$/)[1]) - 1;
                  if(this.m_playerStartIndices.indexOf(playerSpawnIndex) >= 0)
                  {
                     this.GAME.PlayerSettings[this.m_playerStartIndices.indexOf(playerSpawnIndex)].x_respawn = curObject.x;
                     this.GAME.PlayerSettings[this.m_playerStartIndices.indexOf(playerSpawnIndex)].y_respawn = curObject.y;
                  }
               }
               else if(Boolean(curObject.type) && curObject.type.match(/^(red|blue|green|yellow)(\d+)_start$/) != null)
               {
                  this.START_POSITIONS.push(curObject);
                  teamStartColor = curObject.type.match(/(red|blue|green|yellow)(\d+)_start/)[1];
                  teamPlayerStartIndex = parseInt(curObject.type.match(/(red|blue|green|yellow)(\d+)_start/)[2]);
                  tmpPlayerSetting = this.getNthPlayerOfTeam(teamPlayerStartIndex,teamMap[teamStartColor]);
                  if(Boolean(tmpPlayerSetting))
                  {
                     tmpPlayerSetting.x_start = curObject.x;
                     tmpPlayerSetting.y_start = curObject.y;
                     tmpPlayerSetting.facingRight = curObject.transform.matrix.a >= 0;
                  }
               }
               else if(Boolean(curObject.type) && curObject.type.match(/^(red|blue|green|yellow)(\d+)_spawn$/) != null)
               {
                  this.SPAWN_POSITIONS.push(curObject);
                  teamSpawnColor = curObject.type.match(/(red|blue|green|yellow)(\d+)_spawn$/)[1];
                  teamPlayerRespawnIndex = parseInt(curObject.type.match(/(red|blue|green|yellow)(\d+)_spawn$/)[2]);
                  tmpPlayerSetting = this.getNthPlayerOfTeam(teamPlayerRespawnIndex,teamMap[teamStartColor]);
                  if(Boolean(tmpPlayerSetting))
                  {
                     tmpPlayerSetting.x_respawn = curObject.x;
                     tmpPlayerSetting.y_respawn = curObject.y;
                  }
               }
               else if(curObject.type == "light_source")
               {
                  this.LIGHTSOURCE = curObject;
               }
            }
         }
      }
      
      public function getNthPlayerOfTeam(pnum:int, team:int) : PlayerSetting
      {
         var num:int = 0;
         for(var i:int = 0; i < this.GAME.PlayerSettings.length; i++)
         {
            if(Boolean(this.GAME.PlayerSettings[i]) && Boolean(this.GAME.PlayerSettings[i].exist) && this.GAME.PlayerSettings[i].team === team)
            {
               num++;
               if(pnum === num)
               {
                  return this.GAME.PlayerSettings[i];
               }
            }
         }
         return null;
      }
      
      private function createBeaconData() : void
      {
         if(this.BEACONS.length <= 0)
         {
            return;
         }
         var i:int = 0;
         var j:int = 0;
         var k:int = 0;
         var m:int = 0;
         this.ADJMATRIX = this.newAdjacencyMatrix(this.BEACONS.length);
         this.populateAdjMatrix(this.BEACONS);
         for(i = 0; i < this.BEACONS.length; i++)
         {
            for(j = 0; j < this.BEACONS[i].Neighbors.length; j++)
            {
               for(k = 0; k < this.BEACONS[i].Neighbors[j].Neighbors.length; k++)
               {
                  if(this.BEACONS[i] != this.BEACONS[i].Neighbors[j].Neighbors[k])
                  {
                     for(m = 0; m < this.BEACONS[i].Neighbors.length; m++)
                     {
                        if(this.BEACONS[i].Neighbors[j] != this.BEACONS[i].Neighbors[m])
                        {
                           if(this.BEACONS[i].Neighbors[m] == this.BEACONS[i].Neighbors[j].Neighbors[k])
                           {
                              if(this.ADJMATRIX[i][this.BEACONS[i].Neighbors[m].BID] > this.ADJMATRIX[this.BEACONS[i].Neighbors[j].BID][this.BEACONS[i].Neighbors[m].BID])
                              {
                                 this.ADJMATRIX[i][this.BEACONS[i].Neighbors[m].BID] = int.MAX_VALUE;
                              }
                           }
                        }
                     }
                  }
               }
            }
         }
         for(i = 0; i < this.ADJMATRIX.length; i++)
         {
            for(j = 0; j < this.ADJMATRIX[i].length; j++)
            {
               if(this.ADJMATRIX[i][j] != int.MAX_VALUE)
               {
                  this.ADJMATRIX[j][i] = this.ADJMATRIX[i][j];
               }
            }
         }
      }
      
      private function newAdjacencyMatrix(n:Number) : Array
      {
         var j:int = 0;
         var am:Array = new Array(n);
         for(var i:int = 0; i < n; i++)
         {
            am[i] = new Array(n);
            for(j = 0; j < n; j++)
            {
               am[i][j] = int.MAX_VALUE;
            }
         }
         return am;
      }
      
      private function populateAdjMatrix(b:Vector.<Beacon>) : void
      {
         var j:int = 0;
         var i:int = 0;
         for(i = 0; i < b.length; i++)
         {
            for(j = 0; j < b.length; j++)
            {
               if(i != j && b[i].addPotentialNeighbor(b[j]))
               {
                  this.ADJMATRIX[i][j] = Utils.getDistanceFrom(b[i],b[j]);
               }
            }
         }
      }
      
      public function beaconNeighborCount(bid:int) : int
      {
         var total:int = 0;
         for(var i:int = 0; i < this.ADJMATRIX[bid].length; i++)
         {
            if(this.ADJMATRIX[bid][i] != int.MAX_VALUE)
            {
               total++;
            }
         }
         return total;
      }
      
      public function markBeaconsUnvisited() : void
      {
         for(var i:int = 0; i < this.BEACONS.length; i++)
         {
            this.BEACONS[i].Visited = false;
         }
      }
      
      public function touchingLowerWarningBounds(x:int, y:int) : Boolean
      {
         var i:int = 0;
         for(i = 0; i < this.WARNINGBOUNDS_LL.length; i++)
         {
            if(this.WARNINGBOUNDS_LL[i].hitTestPoint(x,y,true))
            {
               return true;
            }
         }
         for(i = 0; i < this.WARNINGBOUNDS_LR.length; i++)
         {
            if(this.WARNINGBOUNDS_LR[i].hitTestPoint(x,y,true))
            {
               return true;
            }
         }
         return false;
      }
      
      public function touchingUpperWarningBounds(x:int, y:int) : Boolean
      {
         var i:int = 0;
         for(i = 0; i < this.WARNINGBOUNDS_UL.length; i++)
         {
            if(this.WARNINGBOUNDS_UL[i].hitTestPoint(x,y,true))
            {
               return true;
            }
         }
         for(i = 0; i < this.WARNINGBOUNDS_UR.length; i++)
         {
            if(this.WARNINGBOUNDS_UR[i].hitTestPoint(x,y,true))
            {
               return true;
            }
         }
         return false;
      }
      
      public function lightFlash(fade:Boolean = true) : void
      {
         var mc:MovieClip = null;
         if(Boolean(this.getQualitySettings().screen_flash))
         {
            mc = this.attachUniqueMovieHUD(fade ? "flashOfLight" : "flashOfLightQuick");
         }
      }
      
      public function darkenCamera() : void
      {
         this.HUD.darkenCamera();
      }
      
      private function killCameraDarkener() : void
      {
         this.HUD.darkenCamera();
      }
      
      public function getSnapshot(options:Object = null) : BitmapData
      {
         return Utils.getSnapshot(Main.Root);
      }
      
      public function checkLinearPathBetweenPoints(p1:Point, p2:Point, options:Object = null) : Platform
      {
         options ||= {};
         options.terrain = typeof options.terrain !== "undefined" ? options.terrain : true;
         options.platforms = typeof options.platforms !== "undefined" ? options.platforms : true;
         options.ignoreFallthrough = typeof options.ignoreFallthrough !== "undefined" ? options.ignoreFallthrough : true;
         options.ignoreList = options.ignoreList || [];
         return this.getPlatformBetweenPoints(p1,p2,options);
      }
      
      public function getPlatformBetweenPoints(p1:Point, p2:Point, options:Object = null) : Platform
      {
         var currentX:Number = p1.x;
         var currentY:Number = p1.y;
         var xDis:Number = p2.x - p1.x;
         var yDis:Number = p2.y - p1.y;
         var repeats:Number = (Math.abs(xDis) + Math.abs(yDis)) / 10;
         var ground:Platform = null;
         if(repeats < 1)
         {
            repeats = 1;
         }
         for(var i:int = 0; i < Math.floor(repeats); i++)
         {
            ground = this.testGroundWithCoord(currentX + xDis / repeats,currentY + yDis / repeats,options);
            if(ground !== null)
            {
               return ground;
            }
            currentX += xDis / repeats;
            currentY += yDis / repeats;
         }
         return null;
      }
      
      public function getPlatformBetweenPointsAsPoint(p1:Point, p2:Point, options:Object = null) : Point
      {
         var currentX:Number = p1.x;
         var currentY:Number = p1.y;
         var xDis:Number = p2.x - p1.x;
         var yDis:Number = p2.y - p1.y;
         var repeats:Number = (Math.abs(xDis) + Math.abs(yDis)) / 10;
         var ground:Platform = null;
         if(repeats < 1)
         {
            repeats = 1;
         }
         for(var i:int = 0; i < Math.floor(repeats); i++)
         {
            ground = this.testGroundWithCoord(currentX + xDis / repeats,currentY + yDis / repeats,options);
            if(ground !== null)
            {
               return new Point(currentX + xDis / repeats,currentY + yDis / repeats);
            }
            currentX += xDis / repeats;
            currentY += yDis / repeats;
         }
         return null;
      }
      
      public function testTerrainWithCoord(xpos:Number, ypos:Number) : Platform
      {
         var i:int = 0;
         i = 0;
         while(i < this.TERRAINS.length && (!this.TERRAINS[i].hitTestPoint(xpos,ypos,true) || this.TERRAINS[i].fallthrough == true))
         {
            i++;
         }
         if(i < this.TERRAINS.length && this.TERRAINS[i].hitTestPoint(xpos,ypos,true))
         {
            return this.TERRAINS[i];
         }
         return null;
      }
      
      public function testGroundWithCoord(xpos:Number, ypos:Number, options:Object = null) : Platform
      {
         options ||= {};
         options.terrain = typeof options.terrain !== "undefined" ? options.terrain : true;
         options.platforms = typeof options.platforms !== "undefined" ? options.platforms : true;
         options.ignoreFallthrough = typeof options.ignoreFallthrough !== "undefined" ? options.ignoreFallthrough : true;
         options.ignoreList = options.ignoreList || [];
         var i:int = 0;
         var hitTerrain:Boolean = false;
         i = 0;
         while(true)
         {
            hitTerrain = this.TERRAINS[i].hitTestPoint(xpos,ypos,true);
            if(!(Boolean(options.terrain) && Boolean(i < this.TERRAINS.length) && (!hitTerrain || this.TERRAINS[i].fallthrough == true && !options.ignoreFallthrough || options.ignoreList.indexOf(this.TERRAINS[i]) >= 0)))
            {
               break;
            }
            i++;
         }
         if(i < this.TERRAINS.length && hitTerrain)
         {
            return this.TERRAINS[i];
         }
         if(Boolean(options.platforms))
         {
            i = 0;
            while(true)
            {
               hitTerrain = this.PLATFORMS[i].hitTestPoint(xpos,ypos,true);
               if(!(i < this.PLATFORMS.length && (!hitTerrain || this.PLATFORMS[i].fallthrough == true && !options.ignoreFallthrough || options.ignoreList.indexOf(this.PLATFORMS[i]) >= 0)))
               {
                  break;
               }
               i++;
            }
            if(i < this.PLATFORMS.length && hitTerrain)
            {
               return this.PLATFORMS[i];
            }
            return null;
         }
         return null;
      }
      
      public function shakeCamera(num:int) : void
      {
         this.CAM.shake(num);
      }
      
      public function brightenCamera() : void
      {
         this.HUD.brightenCamera();
      }
      
      private function makePlayer(num:int) : void
      {
         var characterStats:CharacterData = null;
         var playerSettings:PlayerSetting = this.GAME.PlayerSettings[num - 1];
         if(playerSettings.character == "random")
         {
            characterStats = Stats.getStats(Main.RandCharList[num - 1].StatsName);
         }
         else
         {
            characterStats = Stats.getStats(playerSettings.character,playerSettings.expansion);
         }
         characterStats.importData({
            "player_id":num,
            "shieldType":(!playerSettings.human ? "shieldcpu" : "shield" + Utils.convertTeamToColor(num,this.GAME.GameMode == Mode.TRAINING ? -1 : int(playerSettings.team))),
            "stamina":(this.GAME.LevelData.usingStamina ? this.GAME.LevelData.startStamina : 0)
         });
         this.deactivateCharacters();
         if(this.ONLINEMODE && Boolean(playerSettings.name))
         {
            playerSettings.name = ProfanityFilter.instance.clean(playerSettings.name);
         }
         var character:Character = new Character(characterStats,this.GAME.PlayerSettings[num - 1],this);
         this.activateCharacters();
         character.attachHealthBox(Boolean(playerSettings.name) ? playerSettings.name : characterStats.DisplayName.toUpperCase(),characterStats.Thumbnail,characterStats.SeriesIcon,character.Team,character.CostumeName,character.CostumeID);
      }
      
      public function activateCharacters() : void
      {
         this.m_activeScripts = true;
      }
      
      public function deactivateCharacters() : void
      {
         this.m_activeScripts = false;
      }
      
      public function startGame() : void
      {
         Main.Root.stage.addEventListener(Event.ENTER_FRAME,this.startGame2);
      }
      
      private function startGame2(e:Event) : void
      {
         var i:int = 0;
         this.m_startDelayTimer.tick();
         if(!this.m_startDelayTimer.IsComplete)
         {
            return;
         }
         this.ROOT.stage.removeEventListener(Event.ENTER_FRAME,this.startGame2);
         this.SOUNDQUEUE.playMusic(this.m_music,this.m_loopLoc);
         this.STAGEPARENT.stage.focus = this.STAGEPARENT;
         this.activateCharacters();
         this.m_countdownTimer = ResourceManager.getLibraryMC("countdownTimer");
         this.m_countdownTimer.stop();
         this.HUDTEXT.addChild(this.m_countdownTimer);
         this.ROOT.addEventListener(Event.RENDER,this.renderComplete);
         this.ROOT.addEventListener(Event.ENTER_FRAME,this.performAllEvents);
         if(ModeFeatures.hasFeature(ModeFeatures.ALLOW_SUDDEN_DEATH,this.GAME.GameMode) && this.GAME.SuddenDeath)
         {
            if(this.GAME.SuddenDeath)
            {
               this.m_countdownTimer.gotoAndStop("suddendeath");
               this.playSpecificVoice("narrator_suddendeath");
               this.playSpecificVoice("crowd_suddendeath");
            }
         }
         else if(!this.GAME.LevelData.showEntrances)
         {
            if(this.GAME.LevelData.showCountdown)
            {
               this.m_countdownTimer.showCountdownType = this.GAME.LevelData.showCountdownType;
               if(this.GAME.LevelData.showCountdownType === 1 || this.GAME.LevelData.showCountdownType === 3)
               {
                  this.m_countdownTimer.gotoAndStop("ready");
               }
               else
               {
                  this.m_countdownTimer.gotoAndStop("go");
               }
            }
            else
            {
               this.m_event = false;
               if(this.GAME.UsingTime)
               {
                  this.TIMER.Restart();
                  this.TIMER.Start();
                  this.TIMER.TimeMC.visible = true;
               }
               this.m_countdownTimer.stop();
               if(Boolean(this.m_countdownTimer.parent))
               {
                  this.m_countdownTimer.parent.removeChild(this.m_countdownTimer);
               }
            }
         }
         else
         {
            this.m_countdownTimer.gotoAndStop(2);
         }
         if(Main.DEBUG && false)
         {
            this.m_fpsTimer = new Debug_fps(this.STAGE.stage,new Point());
         }
         if(SpecialMode.modeEnabled(this.GAME.LevelData.specialModes,SpecialMode.SLOW))
         {
            Main.Root.stage.frameRate = Main.FRAMERATE / 2;
         }
         else if(SpecialMode.modeEnabled(this.GAME.LevelData.specialModes,SpecialMode.LIGHTNING))
         {
            Main.Root.stage.frameRate = Main.FRAMERATE * 2;
         }
         this.CAM.forceTarget();
         this.CAM.PERFORMALL();
         for(i = this.MOVINGPLATFORMS.length - 1; i >= 0; i--)
         {
            if(Boolean(this.MOVINGPLATFORMS[i].APIInstance))
            {
               this.MOVINGPLATFORMS[i].APIInstance.initialize();
            }
         }
         for(i = this.COLLISION_BOUNDARIES.length - 1; i >= 0; i--)
         {
            if(Boolean(this.COLLISION_BOUNDARIES[i].APIInstance))
            {
               this.COLLISION_BOUNDARIES[i].APIInstance.initialize();
            }
         }
         for(i = this.ENEMY.length - 1; i >= 0; i--)
         {
            if(Boolean(this.ENEMY[i].APIInstance))
            {
               this.ENEMY[i].APIInstance.initialize();
            }
         }
         for(i = 1; i <= this.GAME.PlayerSettings.length; i++)
         {
            if(this.GAME.PlayerSettings[i - 1].character != null)
            {
               this.getPlayerByID(i).APIInstance.initialize();
               if(this.GAME.LevelData.showEntrances && !SpecialMode.modeEnabled(this.GAME.LevelData.specialModes,SpecialMode.SSF1))
               {
                  this.getPlayerByID(i).setState(CState.ENTRANCE);
               }
               else
               {
                  this.deactivateCharacters();
                  this.getPlayerByID(i).setState(CState.ENTRANCE);
                  this.activateCharacters();
                  this.getPlayerByID(i).setState(CState.IDLE);
               }
            }
         }
         if(this.GAME.GameMode == Mode.TRAINING)
         {
            for(i = 1; i <= this.PLAYERS.length; i++)
            {
               if(Boolean(this.getPlayerByID(i)))
               {
                  if(i == 1)
                  {
                     this.getPlayerByID(i).Team = 1;
                  }
                  else if(i == 2)
                  {
                     this.getPlayerByID(i).StandBy = false;
                     this.getPlayerByID(i).Team = 2;
                  }
                  else
                  {
                     this.getPlayerByID(i).StandBy = true;
                     this.getPlayerByID(i).Team = 2;
                  }
               }
            }
         }
         this.HUD.makeEvents();
         var targets:Vector.<MovieClip> = new Vector.<MovieClip>();
         var tmpNum:Number = 0;
         while(tmpNum < this.PLAYERS.length)
         {
            if(this.PLAYERS[tmpNum] != null && this.PLAYERS[tmpNum].MC != null && !this.PLAYERS[tmpNum].StandBy)
            {
               targets.push(MovieClip(this.PLAYERS[tmpNum].MC));
            }
            tmpNum++;
         }
         this.CAM.addTargets(targets);
         this.CAM.forceTarget();
         for(i = 0; i < this.PLAYERS.length; i++)
         {
            if(Boolean(this.PLAYERS[i]))
            {
               this.PLAYERS[i].forceOnGround();
            }
         }
         this.m_currentEntrance = 0;
         var first:Boolean = true;
         if(this.GAME.LevelData.showEntrances)
         {
            for(i = 0; i < this.PLAYERS.length; i++)
            {
               if(Boolean(this.PLAYERS[i]))
               {
                  if(first)
                  {
                     this.CAM.addZoomFocus(this.PLAYERS[i].MC,20);
                     first = false;
                  }
                  else
                  {
                     this.PLAYERS[i].FreezePlayback = true;
                     this.PLAYERS[i].setVisibility(false);
                  }
               }
            }
         }
         Main.Root.visible = true;
         if(this.GAME.HudDisplay)
         {
            this.HUD.toggleMainDisplay(true);
         }
         if(Boolean(this.m_apiInstance))
         {
            this.m_apiInstance.initialize();
         }
         if(ModeFeatures.hasFeature(ModeFeatures.IS_CUSTOM,this.GAME.GameMode))
         {
            this.GAME.CustomMatchObj.APIInstance.initialize();
         }
         this.stopAllStageFrames();
         this.PERFORMALL();
         if(this.ONLINEMODE && MultiplayerManager.INPUT_BUFFER === 0)
         {
            this.m_onlineMatchControlsTimer.start();
         }
      }
      
      public function prepareEndGameCharacter(slowFrameRate:Boolean = false) : void
      {
         this.m_slowFrameRate = slowFrameRate;
         this.m_endTrigger = true;
      }
      
      public function getEndGameDefaults(options:Object = null) : Object
      {
         options ||= {};
         options.exit = options.exit === undefined ? true : options.exit;
         options.slowMo = options.slowMo === undefined ? false : options.slowMo;
         options.immediate = options.immediate === undefined ? true : options.immediate;
         options.silent = options.silent === undefined ? false : options.silent;
         options.matchResults = options.matchResults === undefined ? false : options.matchResults;
         options.forceNoContest = options.forceNoContest === undefined ? false : options.forceNoContest;
         options.replaySave = options.replaySave === undefined ? false : options.replaySave;
         return options;
      }
      
      private function setupRetryButtons(container:MovieClip) : void
      {
         if(Boolean(container) && Boolean(container.stadiumMenuBar))
         {
            container.stadiumMenuBar.visible = false;
            if(!this.REPLAYMODE && ModeFeatures.hasFeature(ModeFeatures.ALLOW_REPLAY_RECORD,this.GAME.GameMode))
            {
               container.stadiumMenuBar.visible = true;
               container.stadiumMenuBar.replaySave_btn.addEventListener(MouseEvent.CLICK,this.onReplaySaveClicked);
            }
            else
            {
               container.stadiumMenuBar.replaySave_btn.visible = false;
            }
            if(!this.REPLAYMODE && ModeFeatures.hasFeature(ModeFeatures.HAS_RETRY_BUTTON,this.GAME.GameMode))
            {
               container.stadiumMenuBar.visible = true;
               if(Boolean(SaveData.Controllers[0].GamepadInstance))
               {
                  container.stadiumMenuBar.key_back.text = ControlsMenu.getGamepadInputName(1,SaveData.Controllers[0]._BUTTON1);
                  container.stadiumMenuBar.key_retry.text = ControlsMenu.getGamepadInputName(1,SaveData.Controllers[0]._GRAB);
               }
               else
               {
                  container.stadiumMenuBar.key_back.text = Utils.KEY_ARR_SHORT[SaveData.Controllers[0].KeyboardInstance.ControlsMap[SaveData.Controllers[0]._BUTTON1]];
                  container.stadiumMenuBar.key_retry.text = Utils.KEY_ARR_SHORT[SaveData.Controllers[0].KeyboardInstance.ControlsMap[SaveData.Controllers[0]._GRAB]];
               }
            }
         }
      }
      
      public function prepareEndGameCustom(options:Object = null) : void
      {
         if(!this.m_endTrigger)
         {
            this.m_endGameOptions = this.getEndGameDefaults(options);
            this.m_endTrigger = true;
         }
      }
      
      public function prepareEndGame(options:Object = null) : void
      {
         var successMCLinkage:String = null;
         var successMC:MovieClip = null;
         var failureMC:MovieClip = null;
         SoundQueue.instance.stopMusic();
         options = this.getEndGameDefaults(options);
         this.m_gameEndedExit = options.exit;
         if(!this.m_gameEnded || Boolean(this.m_gameEndedExit) && (Boolean(options.immediate || options.replaySave)))
         {
            if(!this.m_gameEnded)
            {
               this.m_gameEnded = true;
               this.m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.GAME_ENDED,{}));
            }
            if(Boolean(options.immediate) && this.m_gameEndedExit)
            {
               this.endGame(options.forceNoContest);
               return;
            }
            this.updateEndTimer();
            if(ModeFeatures.hasFeature(ModeFeatures.IS_CUSTOM,this.GAME.GameMode))
            {
               if(options.success === true)
               {
                  this.m_countdownTimer.stop();
                  this.m_countdownTimer.visible = false;
                  this.m_endGameTimer.MaxTime = 32;
                  successMCLinkage = "success_mc";
                  if(!options.silent)
                  {
                     if(options.record === true)
                     {
                        this.playSpecificVoice("narrator_record");
                        successMCLinkage = "newrecord_mc";
                     }
                     else
                     {
                        this.playSpecificVoice("narrator_success");
                     }
                  }
                  successMC = this.attachUniqueMovieHUD(successMCLinkage);
                  this.HUDTEXT.addChild(successMC);
                  this.setupRetryButtons(successMC);
                  if(!this.REPLAYMODE && ModeFeatures.hasFeature(ModeFeatures.ALLOW_REPLAY_RECORD,this.GAME.GameMode))
                  {
                     this.m_queuedAutoSave = true;
                  }
               }
               else if(options.success === false)
               {
                  this.m_countdownTimer.stop();
                  this.m_countdownTimer.visible = false;
                  if(!options.silent)
                  {
                     this.playSpecificVoice("narrator_failure");
                     this.playSpecificVoice("crowd_dissapoint");
                  }
                  failureMC = this.attachUniqueMovieHUD("failure_mc");
                  this.HUDTEXT.addChild(failureMC);
                  this.setupRetryButtons(failureMC);
                  if(!this.REPLAYMODE && ModeFeatures.hasFeature(ModeFeatures.ALLOW_REPLAY_RECORD,this.GAME.GameMode))
                  {
                     this.m_queuedAutoSave = true;
                  }
               }
               else if(!options.silent)
               {
                  this.m_countdownTimer.gotoAndStop(!this.GAME.UsingTime || this.TIMER.CurrentTime > 0 ? "game" : "time");
                  this.playSpecificVoice(!this.GAME.UsingTime || this.TIMER.CurrentTime > 0 ? "narrator_game" : "narrator_time");
                  this.HUDTEXT.addChild(this.m_countdownTimer);
               }
            }
            else
            {
               this.m_countdownTimer.gotoAndStop(!this.GAME.UsingTime || this.TIMER.CurrentTime > 0 ? "game" : "time");
               this.HUDTEXT.addChild(this.m_countdownTimer);
               if(!this.REPLAYMODE && ModeFeatures.hasFeature(ModeFeatures.ALLOW_REPLAY_RECORD,this.GAME.GameMode))
               {
                  this.m_queuedAutoSave = true;
               }
            }
            if(!options.slowMo)
            {
               this.m_endGameTimer.MaxTime = Main.FRAMERATE * 3;
            }
            if(Boolean(options.slowMo))
            {
               Main.Root.stage.frameRate = 8;
            }
            this.TIMER.Stop();
            if(ModeFeatures.hasFeature(ModeFeatures.REMOVE_TIMER,this.GAME.GameMode))
            {
               if(Boolean(this.TIMER.TimeMC.parent))
               {
                  this.TIMER.TimeMC.parent.removeChild(this.TIMER.TimeMC);
               }
            }
         }
      }
      
      public function autoSaveReplay(modeOverride:int = -1, customFileName:String = null) : void
      {
         var replaysFolder:File = null;
         var versionFolderName:String = null;
         var versionFolder:File = null;
         var replayData:ByteArray = null;
         var duplicateNum:int = 0;
         var replayFile:File = null;
         var fileWriter:FileStream = null;
         if(ModeFeatures.hasFeature(ModeFeatures.ALLOW_REPLAY_RECORD,this.GAME.GameMode) && !this.REPLAYMODE && SaveData.ReplayAutoSave)
         {
            try
            {
               replaysFolder = File.userDirectory.resolvePath("SSF2Replays");
               if(!replaysFolder.exists)
               {
                  replaysFolder.createDirectory();
               }
               if(replaysFolder.isDirectory)
               {
                  versionFolderName = Version.getVersion();
                  versionFolder = replaysFolder.resolvePath(versionFolderName);
                  if(!versionFolder.exists)
                  {
                     versionFolder.createDirectory();
                  }
                  if(versionFolder.isDirectory)
                  {
                     this.m_replayData.Name = Boolean(customFileName) ? customFileName : Utils.generateReplaySaveFileName(this);
                     if(modeOverride >= 0)
                     {
                        this.m_replayData.GameMode = modeOverride;
                     }
                     replayData = new ByteArray();
                     replayData.writeUTF(this.m_replayData.exportReplay());
                     replayData.compress();
                     duplicateNum = 1;
                     replayFile = versionFolder.resolvePath(this.m_replayData.Name + ".ssfrec");
                     while(replayFile.exists)
                     {
                        duplicateNum++;
                        replayFile = versionFolder.resolvePath(this.m_replayData.Name + " (" + duplicateNum + ").ssfrec");
                     }
                     fileWriter = new FileStream();
                     fileWriter.open(replayFile,FileMode.WRITE);
                     fileWriter.writeBytes(replayData);
                     fileWriter.close();
                  }
               }
            }
            catch(e:*)
            {
               trace("An error occured while attempting replay auto-save: " + e);
            }
         }
      }
      
      public function onReplaySaveClicked(e:MouseEvent) : void
      {
         this.saveReplay();
      }
      
      public function saveReplay(modeOverride:int = -1, customFileName:String = null) : void
      {
         this.m_replayData.Name = Boolean(customFileName) ? customFileName : Utils.generateReplaySaveFileName(this);
         if(modeOverride >= 0)
         {
            this.m_replayData.GameMode = modeOverride;
         }
         var replayData:ByteArray = new ByteArray();
         replayData.writeUTF(this.m_replayData.exportReplay());
         replayData.compress();
         Utils.saveFile(replayData,GameController.stageData.ReplayDataObj.Name + ".ssfrec");
      }
      
      public function updateEndTimer() : void
      {
         this.m_endTime = getTimer();
      }
      
      public function startCountdown() : void
      {
         this.m_countdownTimer.gotoAndStop("countdown");
         this.HUDTEXT.addChild(this.m_countdownTimer);
      }
      
      public function startCrowdChant(id:int) : void
      {
         var testSound:Sound = null;
         var index:int = 0;
         if(false && this.m_crowdChantID < 0 && this.m_crowdChantDelay.IsComplete && ModeFeatures.hasFeature(ModeFeatures.ALLOW_CROWD_CHANTS,this.GAME.GameMode))
         {
            testSound = ResourceManager.getLibrarySound("crowdcheer_" + this.getPlayerByID(id).StatsName);
            if(Boolean(testSound))
            {
               index = this.playSpecificVoice("crowdcheer_" + this.getPlayerByID(id).StatsName);
               this.m_crowdChantSound = this.SOUNDQUEUE.getSoundObject(index);
               this.m_crowdChantSound.LoopFunction = this.m_crowdChantSound.restart;
               this.m_crowdChantSound.Channel.addEventListener(Event.SOUND_COMPLETE,this.m_crowdChantSound.LoopFunction);
               this.m_crowdChantTimer.reset();
               this.m_crowdChantID = id;
            }
         }
      }
      
      public function stopCrowdChant() : void
      {
         if(Boolean(this.m_crowdChantSound))
         {
            this.m_crowdChantSound.Channel.removeEventListener(Event.SOUND_COMPLETE,this.m_crowdChantSound.LoopFunction);
            this.m_crowdChantSound.stop();
            this.m_crowdChantSound.LoopFunction = null;
            this.m_crowdChantSound = null;
         }
         this.m_crowdChantID = -1;
         this.m_crowdChantTimer.reset();
         this.m_crowdChantDelay.reset();
      }
      
      public function endGame(noContest:Boolean = false) : void
      {
         var i:int;
         var j:int;
         var goBack:Boolean;
         var topRank:Array = null;
         var already:Boolean = false;
         InteractiveSprite.SHOW_HITBOXES = false;
         if(this.ONLINEMODE && MultiplayerManager.INPUT_BUFFER === 0)
         {
            this.m_onlineMatchControlsTimer.stop();
         }
         if(!this.SOUNDQUEUE.MusicIsMuted)
         {
            this.SOUNDQUEUE.setMusicVolume(SaveData.BGVolumeLevel);
         }
         this.m_endGameOptions = this.m_endGameOptions || this.getEndGameDefaults();
         if(this.GAME.GameMode === Mode.ONLINE_WAITING_ROOM)
         {
            MGNEventManager.dispatcher.removeEventListener(MGNEvent.MATCH_END,this.prematureMatchEnd);
            MGNEventManager.dispatcher.removeEventListener(MGNEvent.ROOM_DATA,this.onRoomDataSet);
            MGNEventManager.dispatcher.removeEventListener(MGNEvent.ERROR_ROOM_DATA,this.onRoomDataSet);
         }
         i = 0;
         j = 0;
         if(this.GAME.GameMode === Mode.TARGET_TEST)
         {
            SaveData.Records.targets.playTime += this.m_elapsedPlayableFrames;
         }
         else if(this.GAME.GameMode === Mode.TARGET_TEST)
         {
            SaveData.Records.targets.playTime += this.m_elapsedPlayableFrames;
         }
         else if(this.GAME.GameMode === Mode.CRYSTAL_SMASH)
         {
            SaveData.Records.crystals.playTime += this.m_elapsedPlayableFrames;
         }
         else if(this.GAME.GameMode === Mode.CLASSIC)
         {
            SaveData.Records.classic.playTime += this.m_elapsedPlayableFrames;
            if(this.GAME.UsingTime && Boolean(Utils.framesToSecondsString(this.TIMER.CurrentTime).match(/(1|3|6)$/)))
            {
               SaveData.Unlocks.mk64Condition = true;
            }
            if(this.TARGETS.length > 0)
            {
               SaveData.Records.targets.playTime += this.m_elapsedPlayableFrames;
            }
         }
         else if(this.GAME.GameMode === Mode.ARENA || this.GAME.GameMode === Mode.ONLINE_ARENA)
         {
            SaveData.Records.arena.playTime += this.m_elapsedPlayableFrames;
            SaveData.Records.arena.stages[this.GAME.LevelData.stage] = SaveData.Records.arena.stages[this.GAME.LevelData.stage] || 0;
            ++SaveData.Records.arena.stages[this.GAME.LevelData.stage];
         }
         else if(this.GAME.GameMode === Mode.MULTIMAN)
         {
            SaveData.Records.multiman.playTime += this.m_elapsedPlayableFrames;
         }
         else if(this.GAME.GameMode === Mode.HOME_RUN_CONTEST)
         {
            SaveData.Records.hrc.playTime += this.m_elapsedPlayableFrames;
         }
         SaveData.PlayTime += this.m_elapsedPlayableFrames;
         SoundQueue.instance.stopMusic();
         if(this.m_onlineMatchDowngradeTimeout.running)
         {
            this.m_onlineMatchDowngradeTimeout.reset();
         }
         if(this.m_onlineMatchStartTimeout.running)
         {
            this.m_onlineMatchStartTimeout.reset();
         }
         if(this.m_onlineMatchEndTimeout.running)
         {
            this.m_onlineMatchEndTimeout.reset();
         }
         for(i = 0; i < this.CHARACTERS.length; i++)
         {
            if(Boolean(this.CHARACTERS[i]))
            {
               this.CHARACTERS[i].flushTimers(true);
               this.CHARACTERS[i].EventManagerObj.removeAllEvents();
            }
         }
         Main.Root.stage.removeEventListener(Event.ENTER_FRAME,this.waitForPlayers);
         this.deactivateCharacters();
         SSF2API.deinit();
         this.stopCrowdChant();
         this.m_gameEnded = true;
         this.m_gameEndedExit = true;
         if(Boolean(this.m_fpsTimer))
         {
            this.m_fpsTimer.kill();
         }
         for(i = 0; i < this.PLAYERS.length; i++)
         {
            if(this.PLAYERS[i] != null)
            {
               this.PLAYERS[i].resetDroughtTimer();
            }
         }
         if(ModeFeatures.hasFeature(ModeFeatures.ALLOW_SUDDEN_DEATH,this.GAME.GameMode))
         {
            topRank = new Array();
            this.updateRanks(true);
            i = 0;
            while(i < this.PLAYERS.length && !noContest && this.m_canSuddenDeath)
            {
               if(this.PLAYERS[i] != null && this.PLAYERS[i].getMatchResults().Rank == 1)
               {
                  already = false;
                  for(j = 0; j < topRank.length; j++)
                  {
                     if(this.getPlayerByID(topRank[j]).getMatchResults().Rank == this.PLAYERS[i].getMatchResults().Rank && this.PLAYERS[i].Team == this.getPlayerByID(topRank[j]).Team && this.getPlayerByID(topRank[j]).Team > 0)
                     {
                        already = true;
                     }
                  }
                  if(!already)
                  {
                     topRank.push(this.PLAYERS[i].ID);
                  }
               }
               i++;
            }
            if(topRank.length > 1)
            {
               topRank = new Array();
               this.m_suddenDeath = true;
               for(i = 0; i < this.PLAYERS.length; i++)
               {
                  if(this.PLAYERS[i] != null && this.PLAYERS[i].getMatchResults().Rank == 1)
                  {
                     topRank.push(this.PLAYERS[i].ID);
                  }
               }
               this.m_suddenDeathIDs = topRank;
            }
         }
         if(this.ONLINEMODE && MultiplayerManager.Connected && !this.m_suddenDeath)
         {
            MultiplayerManager.sendMatchEndSignal();
            if(MultiplayerManager.DowngradedConnection)
            {
               MultiplayerManager.Protocol = ProtocolSetting.CLIENT_SERVER_TCP;
            }
         }
         this.m_noContest = noContest;
         if(!this.m_noContest && !this.m_suddenDeath && this.m_queuedAutoSave)
         {
            this.autoSaveReplay();
         }
         if(ModeFeatures.hasFeature(ModeFeatures.REMOVE_TIMER,this.GAME.GameMode))
         {
            this.TIMER.TimeMC.visible = false;
            this.HUD.SubMenu.visible = false;
         }
         this.HUD.killCameraDarkener();
         this.m_wasReset = true;
         Main.Root.stage.frameRate = Main.FRAMERATE;
         for(i = 2; i <= this.GAME.PlayerSettings.length; i++)
         {
            if(this.m_nullPlayers.indexOf(i - 1) >= 0)
            {
               this.GAME.PlayerSettings[i - 1].character = null;
            }
         }
         for(j = 0; j < this.m_effectHUDList.length; j++)
         {
            if(Boolean(this.m_effectHUDList[j]) && this.m_effectHUDList[j].parent != null)
            {
               this.m_effectHUDList[j].parent.removeChild(this.m_effectHUDList[j]);
            }
         }
         this.SOUNDQUEUE.stopAllSounds();
         this.HUD.forceHitBoxVisiblity(false);
         if(MultiplayerManager.Connected)
         {
            MultiplayerManager.Active = false;
         }
         this.STAGE = null;
         this.STAGEPARENT = null;
         GameController.endMatch();
         this.ROOT.removeEventListener(Event.RENDER,this.renderComplete);
         this.ROOT.removeEventListener(Event.ENTER_FRAME,this.performAllEvents);
         goBack = false;
         if(this.ONLINEMODE && this.GAME.GameMode === Mode.ONLINE && !SaveData.Unlocks.beatDevOnline && !this.m_noContest)
         {
            if(this.getPlayerByID(MultiplayerManager.PlayerID).getMatchResults().Rank === 1)
            {
               for(i = 0; i < this.PLAYERS.length; i++)
               {
                  if(Boolean(this.PLAYERS[i] && this.PLAYERS[i].ID !== MultiplayerManager.PlayerID) && Boolean(this.PLAYERS[i].getMatchResults().Rank > 1) && Boolean(this.PLAYERS[i].getPlayerSettings().name))
                  {
                     if(this.PLAYERS[i].getPlayerSettings().beatDevOnline || this.PLAYERS[i].ID - 1 < MultiplayerManager.Players.length && MultiplayerManager.Players[this.PLAYERS[i].ID - 1].is_dev)
                     {
                        SaveData.Unlocks.beatDevOnline = true;
                     }
                  }
               }
            }
         }
         if(this.GAME.GameMode === Mode.ONLINE)
         {
            UnlockController.checkUnlocks();
         }
         if(this.GAME.GameMode == Mode.TRAINING)
         {
            UnlockController.nextMenuFunc = function():void
            {
               GameController.destroyStageData();
               MenuController.trainingMenu.show();
            };
         }
         else if(ModeFeatures.hasFeature(ModeFeatures.IS_CUSTOM,this.GAME.GameMode))
         {
            UnlockController.nextMenuFunc = function():void
            {
               if(Boolean(GAME.CustomModeObj))
               {
                  if(m_noContest)
                  {
                     if(m_retryMatch)
                     {
                        if(m_queuedAutoSave)
                        {
                           autoSaveReplay();
                        }
                        GameController.destroyStageData();
                        GAME.CustomModeObj.retry();
                     }
                     else if(Boolean(m_endGameOptions.matchResults))
                     {
                        showMatchResults();
                     }
                     else
                     {
                        GAME.CustomModeObj.endMode(null);
                        GameController.destroyStageData();
                     }
                  }
                  else if(Boolean(m_endGameOptions.matchResults))
                  {
                     showMatchResults();
                  }
                  else
                  {
                     GAME.CustomModeObj.APIInstance.handleMatchComplete();
                  }
                  return;
               }
               throw new Error("CustomMode object is undefined");
            };
         }
         else if(this.GAME.GameMode != Mode.VS_UNLOCK)
         {
            if(this.GAME.GameMode == Mode.ONLINE_WAITING_ROOM)
            {
               if(this.m_noContest)
               {
                  if(!MultiplayerManager.Connected)
                  {
                     UnlockController.nextMenuFunc = function():void
                     {
                        GameController.destroyStageData();
                        MenuController.mainMenu.show();
                     };
                  }
                  else
                  {
                     GameController.destroyStageData();
                     UnlockController.nextMenuFunc = function():void
                     {
                        MultiplayerManager.resetMasterFrame();
                        MultiplayerManager.restoreOriginalGameSettings(MenuController.CurrentCharacterSelectMenu.GameObj);
                        if(Boolean(MultiplayerManager.RoomKey))
                        {
                           MenuController.onlineCharacterMenu.show();
                        }
                        else
                        {
                           MenuController.onlineMenu.show();
                        }
                     };
                  }
               }
               else
               {
                  UnlockController.nextMenuFunc = null;
               }
            }
            else
            {
               UnlockController.nextMenuFunc = this.showMatchResults;
            }
         }
         if(this.GAME.GameMode == Mode.VS_UNLOCK)
         {
            if(!this.m_noContest && this.getFirstWinner().ID == 1)
            {
               UnlockController.pendingUnlockScreens.unshift(UnlockController.pendingUnlockFights[0]);
               UnlockController.pendingUnlockFights.shift();
               MenuController.postUnlockMenu.show();
               GameController.currentGame = null;
               GameController.currentGame = GameController.tmpGame;
            }
            else
            {
               GameController.currentGame = null;
               GameController.currentGame = GameController.tmpGame;
               UnlockController.pendingUnlockFights.shift();
               if(UnlockController.pendingUnlockFights.length > 0)
               {
                  MenuController.preUnlockMenu.show();
               }
               else if(UnlockController.pendingUnlockScreens.length > 0)
               {
                  MenuController.postUnlockMenu.show();
               }
               else
               {
                  goBack = true;
               }
            }
         }
         else if(this.checkSuddenDeath())
         {
            GameController.startMatch();
         }
         else
         {
            GameController.tmpStageData = null;
            GameController.tmpGame = null;
            if(ModeFeatures.hasFeature(ModeFeatures.IS_CUSTOM,this.GAME.GameMode) && UnlockController.pendingUnlockFights.length > 0)
            {
               MenuController.preUnlockMenu.show();
            }
            else if(ModeFeatures.hasFeature(ModeFeatures.IS_CUSTOM,this.GAME.GameMode) && UnlockController.pendingUnlockScreens.length > 0)
            {
               MenuController.postUnlockMenu.show();
            }
            else
            {
               goBack = true;
            }
         }
         if(goBack)
         {
            if(this.GAME.GameMode === Mode.ONLINE && UnlockController.pendingUnlockScreens.length > 0)
            {
               MenuController.postUnlockMenu.show();
            }
            else if(UnlockController.nextMenuFunc != null)
            {
               UnlockController.nextMenuFunc();
            }
         }
      }
      
      private function showMatchResults() : void
      {
         if(Boolean(MenuController.matchResultsMenu))
         {
            MenuController.matchResultsMenu.removeSelf();
         }
         MenuController.matchResultsMenu = new MatchResultsMenu();
         MenuController.matchResultsMenu.show();
      }
      
      private function checkSuddenDeath() : Boolean
      {
         var j:int = 0;
         var p:int = 0;
         var num:int = 0;
         if(!ModeFeatures.hasFeature(ModeFeatures.ALLOW_SUDDEN_DEATH,this.GAME.GameMode))
         {
            return false;
         }
         if(!GameController.stageData.SuddenDeath)
         {
            if(GameController.currentGame.SuddenDeath)
            {
               for(j = 1; j <= this.PLAYERS.length; j++)
               {
                  if(GameController.stageData.getPlayerByID(j) != null)
                  {
                     if(GameController.stageData.getPlayerByID(j).getMatchResults().Rank != 1)
                     {
                        ++GameController.tmpStageData.getPlayerByID(j).getMatchResults().Rank;
                     }
                  }
                  else if(GameController.tmpStageData.getPlayerByID(j) != null)
                  {
                     ++GameController.tmpStageData.getPlayerByID(j).getMatchResults().Rank;
                  }
               }
               GameController.currentGame = GameController.tmpGame;
               GameController.stageData = GameController.tmpStageData;
               GameController.tmpStageData = null;
               GameController.tmpGame = null;
               if(this.m_noContest)
               {
                  GameController.stageData.NoContest = true;
               }
            }
            return false;
         }
         GameController.tmpStageData = GameController.stageData;
         GameController.tmpGame = GameController.currentGame;
         GameController.currentGame = new Game(GameController.tmpGame.PlayerSettings.length,GameController.tmpGame.GameMode);
         GameController.currentGame.LevelData.randSeed = GameController.tmpGame.LevelData.randSeed;
         if(this.REPLAYMODE)
         {
            GameController.currentGame.ReplayDataObj = GameController.tmpStageData.ReplayDataObj;
         }
         for(p = 0; p < GameController.stageData.SuddenDeathIDs.length; p++)
         {
            num = int(GameController.stageData.SuddenDeathIDs[p]);
            GameController.currentGame.PlayerSettings[num - 1].character = GameController.tmpGame.PlayerSettings[num - 1].character == "xp" ? "xp" : GameController.stageData.getPlayerByID(num).StatsName;
            GameController.currentGame.PlayerSettings[num - 1].damageRatio = 1;
            GameController.currentGame.PlayerSettings[num - 1].finalSmashMeter = false;
            GameController.currentGame.PlayerSettings[num - 1].lives = 1;
            GameController.currentGame.PlayerSettings[num - 1].startDamage = 300;
            GameController.currentGame.PlayerSettings[num - 1].human = GameController.tmpGame.PlayerSettings[num - 1].human;
            GameController.currentGame.PlayerSettings[num - 1].team = GameController.tmpGame.PlayerSettings[num - 1].team;
            GameController.currentGame.PlayerSettings[num - 1].costume = GameController.tmpGame.PlayerSettings[num - 1].costume;
            GameController.currentGame.PlayerSettings[num - 1].level = GameController.tmpGame.PlayerSettings[num - 1].level;
            GameController.currentGame.PlayerSettings[num - 1].expansion = GameController.tmpGame.PlayerSettings[num - 1].expansion;
            GameController.currentGame.PlayerSettings[num - 1].exist = GameController.stageData.SuddenDeathIDs.indexOf(num) >= 0;
         }
         GameController.currentGame.LevelData.showPlayerID = GameController.tmpGame.LevelData.showPlayerID;
         GameController.currentGame.LevelData.startDamage = 300;
         GameController.currentGame.LevelData.usingLives = true;
         GameController.currentGame.LevelData.usingTime = false;
         GameController.currentGame.LevelData.usingStamina = false;
         GameController.currentGame.LevelData.lives = 1;
         GameController.currentGame.LevelData.specialModes = GameController.tmpGame.LevelData.specialModes;
         GameController.currentGame.SuddenDeath = true;
         GameController.currentGame.LevelData.stage = GameController.tmpGame.LevelData.stage;
         GameController.currentGame.Items.frequency = 0;
         SoundQueue.instance.stopMusic();
         SoundQueue.instance.stopAllSounds();
         SoundQueue.instance.setLoopFunction(SoundQueue.instance.loopMusic);
         return true;
      }
      
      private function performAllEvents(e:Event) : void
      {
         this.ROOT.stage.invalidate();
      }
      
      private function renderComplete(e:Event) : void
      {
         this.PERFORMALL();
      }
      
      private function onRoomDataSet(e:MGNEvent) : void
      {
         MGNEventManager.dispatcher.removeEventListener(MGNEvent.ROOM_DATA,this.onRoomDataSet);
         MGNEventManager.dispatcher.removeEventListener(MGNEvent.ERROR_ROOM_DATA,this.onRoomDataSet);
         if(e.type === MGNEvent.ROOM_DATA)
         {
            MultiplayerManager.lockRoom();
         }
         else if(e.type === MGNEvent.ERROR_ROOM_DATA)
         {
            MultiplayerManager.notify("Error setting room data, server may be unavailable at this time");
         }
      }
      
      public function startOnlineMatch() : Boolean
      {
         var playerSettings:Object = null;
         if(this.m_onlineLockPending)
         {
            return false;
         }
         if(MultiplayerManager.Players.length <= 1)
         {
            SoundQueue.instance.playSoundEffect("menu_error");
            MultiplayerManager.notify("Host player must allow other players to join before proceeding.");
            return false;
         }
         SoundQueue.instance.playSoundEffect("menu_selectstage");
         this.m_onlineLockPending = true;
         MGNEventManager.dispatcher.addEventListener(MGNEvent.ROOM_DATA,this.onRoomDataSet);
         MGNEventManager.dispatcher.addEventListener(MGNEvent.ERROR_ROOM_DATA,this.onRoomDataSet);
         playerSettings = Utils.cloneObject(GameController.onlineModeMatchSettings.playerSettings[0]);
         if(playerSettings.character === "random")
         {
            playerSettings.character = this.PLAYERS[0].StatsName;
         }
         MultiplayerManager.sendMatchReadySignal({"playerSettings":playerSettings});
         MultiplayerManager.sendMatchSettings({
            "version":Version.getVersion(),
            "protocol":MultiplayerManager.Protocol,
            "matchSettings":GameController.onlineModeMatchSettings
         });
         return true;
      }
      
      private function waitForPlayers(e:Event) : void
      {
         var controls:Object = this.PLAYERS[0].getControls(false);
         if(MultiplayerManager.IsHost && !this.m_onlineLockPending && !MultiplayerManager.RoomLocked)
         {
            if(!this.HUD.SubMenu.onlineStartButton.visible)
            {
               this.HUD.SubMenu.onlineStartButton.visible = true;
               this.HUD.SubMenu.onlineStartButton.play();
               MultiplayerManager.resetMasterFrame();
            }
            if(Boolean(this.PLAYERS[0].getControls(true)["START"]))
            {
               if((Boolean(controls["BUTTON1"]) || Boolean(controls["SHIELD"]) && Boolean(controls["SHIELD2"])) && Boolean(controls["BUTTON2"]))
               {
                  this.endGame(true);
               }
               else
               {
                  this.HUD.SubMenu.onlineQuitButtons.visible = false;
                  this.HUD.SubMenu.onlineStartButton.visible = false;
                  this.HUD.SubMenu.onlineStartButton.stop();
                  this.startOnlineMatch();
               }
            }
         }
         else if(Boolean(!MultiplayerManager.IsHost) && Boolean(this.PLAYERS[0].getControls(true)["START"]) && (Boolean(controls["BUTTON1"]) || Boolean(controls["SHIELD"]) && Boolean(controls["SHIELD2"])) && Boolean(controls["BUTTON2"]))
         {
            MultiplayerManager.leaveRoom();
         }
         else if(!(MultiplayerManager.IsHost && this.m_onlineLockPending && !MultiplayerManager.RoomLocked))
         {
            this.m_onlineLockPending = false;
            if(!MultiplayerManager.RoomKey && !MultiplayerManager.IsHost)
            {
               this.endGame(true);
               return;
            }
            if(MultiplayerManager.MatchReady)
            {
               if(MultiplayerManager.MasterFrame < 4 && !this.m_onlineMatchStartTimeout.running && !this.m_gameEnded)
               {
                  this.m_onlineMatchStartTimeout.start();
                  if(MultiplayerManager.IsHost && Boolean(MultiplayerManager.Protocol))
                  {
                     this.m_onlineMatchDowngradeTimeout.start();
                  }
                  MGNEventManager.dispatcher.addEventListener(MGNEvent.MATCH_END,this.prematureMatchEnd);
               }
               MultiplayerManager.Active = true;
               if(MultiplayerManager.MasterFrame < 4)
               {
                  MultiplayerManager.sendMyDataFrame(MultiplayerManager.MasterFrame,{"controls":SaveData.Controllers[0].getControlStatus().controls});
                  ++MultiplayerManager.MasterFrame;
               }
               MultiplayerManager.PromotionTimer.reset();
               MultiplayerManager.PERFORMALL();
               if(MultiplayerManager.PlayerSyncStream.Pointer > 2)
               {
                  Main.Root.stage.removeEventListener(Event.ENTER_FRAME,this.waitForPlayers);
                  if(!this.m_gameEnded)
                  {
                     this.endGame(false);
                  }
                  GameController.startMatch(MultiplayerManager.GameInstance);
               }
            }
            else
            {
               if(this.m_onlineMatchStartTimeout.running)
               {
                  this.m_onlineMatchStartTimeout.reset();
               }
               if(this.m_onlineMatchDowngradeTimeout.running)
               {
                  this.m_onlineMatchDowngradeTimeout.reset();
               }
            }
         }
      }
      
      private function waitForPlayersSuddenDeath(e:Event) : void
      {
         var playerSettings:Object = null;
         if(!MultiplayerManager.MatchReady)
         {
            MultiplayerManager.resetMasterFrame();
            this.m_onlineLockPending = true;
            Main.Root.stage.removeEventListener(Event.ENTER_FRAME,this.waitForPlayersSuddenDeath);
            Main.Root.stage.addEventListener(Event.ENTER_FRAME,this.waitForPlayers);
            playerSettings = Utils.cloneObject(GameController.onlineModeMatchSettings.playerSettings[0]);
            if(playerSettings.character === "random")
            {
               playerSettings.character = this.PLAYERS[MultiplayerManager.PlayerID - 1].StatsName;
            }
            MultiplayerManager.sendMatchReadySignal({"playerSettings":playerSettings});
         }
      }
      
      private function onlineModeMatchEndTimeout(e:TimerEvent) : void
      {
         MultiplayerManager.notify("Error, match was desynced. Please reconnect");
         MultiplayerManager.disconnect();
         this.endGame(true);
      }
      
      private function onlineModeMatchStartTimeout(e:TimerEvent) : void
      {
         var code:String = "001";
         try
         {
            if(MultiplayerManager.PlayerID <= 0)
            {
               code = "002";
            }
            else if(MultiplayerManager.Players.length <= 1)
            {
               code = "003-" + MultiplayerManager.Players.length;
            }
            else if(MultiplayerManager.Players[MultiplayerManager.PlayerID - 1].username !== MultiplayerManager.Username)
            {
               code = "004-" + MultiplayerManager.Players[MultiplayerManager.PlayerID - 1].username + "->" + MultiplayerManager.Username;
            }
            else if(MultiplayerManager.Players[MultiplayerManager.PlayerID - 1].socket_id !== MultiplayerManager.SocketID)
            {
               code = "005";
            }
            else if(!MultiplayerManager.PlayerSyncStream.getDataFrameGroup(1).getDataFrameFor(MultiplayerManager.PlayerID - 1).isReady())
            {
               code = "006";
            }
            else if(!MultiplayerManager.PlayerSyncStream.getDataFrameGroup(1).Complete && (MultiplayerManager.PlayerSyncStream.getDataFrameGroup(2).Complete || MultiplayerManager.PlayerSyncStream.getDataFrameGroup(3).Complete))
            {
               code = "007";
            }
            else if(MultiplayerManager.PlayerSyncStream.getDataFrameGroup(1).Complete && !MultiplayerManager.PlayerSyncStream.getDataFrameGroup(2).Complete && MultiplayerManager.PlayerSyncStream.getDataFrameGroup(3).Complete)
            {
               code = "008";
            }
            else if(!MultiplayerManager.PlayerSyncStream.getDataFrameGroup(1).Complete && !MultiplayerManager.PlayerSyncStream.getDataFrameGroup(2).Complete && !MultiplayerManager.PlayerSyncStream.getDataFrameGroup(3).Complete)
            {
               code = "009";
            }
         }
         catch(e:*)
         {
            code = "000";
         }
         MultiplayerManager.notify("Error starting match. ERR CODE: " + code);
         this.endGame(true);
      }
      
      private function onlineModeMatchDowngradeTimeout(e:TimerEvent) : void
      {
         if(MultiplayerManager.IsHost)
         {
            MultiplayerManager.notify("P2P Connection failed. Falling back to server-server communication...");
            MultiplayerManager.downgradeP2P();
         }
      }
      
      private function prematureMatchEnd(e:MGNEvent) : void
      {
         if(MultiplayerManager.IsHost)
         {
            MultiplayerManager.unlockRoom();
         }
         MultiplayerManager.notify("Error, match was forced to end by host.");
         this.endGame(true);
      }
      
      private function checkOnlineSync() : void
      {
         var i:int = 0;
         if(this.ONLINEMODE)
         {
            MultiplayerManager.Active = true;
            if(MultiplayerManager.IsHost && new Date().getTime() - this.m_onlineModeLastPing > 30000)
            {
               MultiplayerManager.notify("Error, match timed out.");
               this.endGame(true);
               return;
            }
            if(MultiplayerManager.MatchEnded && !this.m_onlineMatchEndTimeout.running)
            {
               this.m_onlineMatchEndTimeout.start();
            }
            if(MultiplayerManager.MasterFrame < 4 && !this.m_onlineMatchStartTimeout.running)
            {
               this.m_onlineMatchStartTimeout.start();
            }
            else if(MultiplayerManager.MasterFrame >= 4 && this.m_onlineMatchStartTimeout.running)
            {
               this.m_onlineMatchStartTimeout.reset();
            }
            if(MultiplayerManager.Controllers[0].ControlsQueue.length > 0)
            {
               this.READY = true;
               --this.m_onlineFrameBuffer.CurrentTime;
               this.m_onlineModeLastPing = new Date().getTime();
               for(i = 0; i < this.PLAYERS.length; i++)
               {
                  if(this.PLAYERS[i] != null && Boolean(this.PLAYERS[i].ControlSettings))
                  {
                     this.PLAYERS[i].ControlSettings.setControlsObject(new ControlsObject(MultiplayerManager.Controllers[this.PLAYERS[i].ID - 1].nextControlBits()));
                  }
               }
            }
            else
            {
               this.READY = false;
            }
            if(MultiplayerManager.Players.length !== this.GAME.PlayerSettings.length)
            {
               this.endGame(true);
            }
         }
         else if(this.m_event)
         {
            this.READY = true;
            MultiplayerManager.Active = false;
         }
         else
         {
            this.READY = true;
         }
      }
      
      private function runOnlineLog() : void
      {
         if(Boolean(Main.DEBUG) && Boolean(MenuController.debugConsole) && MenuController.debugConsole.OnlineCapture)
         {
            this.m_logText += "Frame#: " + this.m_elapsedFrames + "\n";
            this.m_logText += "Cam State: {" + "x: " + this.CAM.X + ", y: " + this.CAM.Y + ", w: " + this.CAM.Width + ", h" + this.CAM.Height + "}\n";
            this.m_logText += "Rand: " + Utils.LastRandom + "\n";
            if(Boolean(this.getPlayerByID(1)))
            {
               this.m_logText += "P1: " + this.getPlayerByID(1).getStateInfo() + "\n";
            }
            if(Boolean(this.getPlayerByID(2)))
            {
               this.m_logText += "P2: " + this.getPlayerByID(2).getStateInfo() + "\n";
            }
            if(Boolean(this.getPlayerByID(3)))
            {
               this.m_logText += "P3: " + this.getPlayerByID(3).getStateInfo() + "\n";
            }
            if(Boolean(this.getPlayerByID(4)))
            {
               this.m_logText += "P4: " + this.getPlayerByID(4).getStateInfo() + "\n";
            }
            this.m_logText += "\n\n";
         }
      }
      
      private function entranceCheck() : void
      {
         if(!this.m_entranceZoomTimer.IsComplete && this.GAME.LevelData.showEntrances)
         {
            this.m_entranceZoomTimer.tick();
            if(this.m_entranceZoomTimer.CurrentTime % 15 === 0)
            {
               if(this.m_entranceZoomMode == 1)
               {
                  this.CAM.removeAllZoomFocus();
               }
               ++this.m_currentEntrance;
               while(this.m_currentEntrance < this.PLAYERS.length && !this.PLAYERS[this.m_currentEntrance])
               {
                  ++this.m_currentEntrance;
               }
               if(this.m_currentEntrance < this.PLAYERS.length)
               {
                  this.PLAYERS[this.m_currentEntrance].FreezePlayback = false;
                  this.PLAYERS[this.m_currentEntrance].setVisibility(true);
                  this.CAM.addZoomFocus(this.PLAYERS[this.m_currentEntrance].MC,999);
                  if(this.m_currentEntrance + 1 >= this.PLAYERS.length)
                  {
                     this.CAM.removeAllZoomFocus();
                  }
               }
            }
            if(this.m_entranceZoomTimer.IsComplete)
            {
               this.CAM.removeAllZoomFocus();
            }
         }
      }
      
      private function pauseCheck() : void
      {
         var aliveHumanPlayer:Boolean = false;
         var humanPause:Boolean = false;
         var pausedID:int = 0;
         var pauseLetGo:Boolean = false;
         var zLetGo:Boolean = false;
         var i:int = 0;
         var j:int = 0;
         if(!this.m_gameEnded && !this.m_event && ModeFeatures.hasFeature(ModeFeatures.ALLOW_PAUSE,this.GAME.GameMode) && (this.GAME.LevelData.pauseEnabled || this.REPLAYMODE))
         {
            aliveHumanPlayer = false;
            for(i = 1; i <= this.PLAYERS.length; i++)
            {
               if(Boolean(this.getPlayerByID(i)) && Boolean(this.getPlayerByID(i).IsHuman) && !this.getPlayerByID(i).Dead)
               {
                  aliveHumanPlayer = true;
               }
            }
            if(this.Paused)
            {
               humanPause = Boolean(this.getPlayerByID(this.PausedID)) && this.getPlayerByID(this.PausedID).IsHuman;
               pausedID = humanPause ? this.PausedID : 1;
               pauseLetGo = humanPause ? this.getPlayerByID(pausedID).PauseLetGo : this.m_pausedLetGo;
               zLetGo = humanPause ? this.getPlayerByID(pausedID).ZLetGo : this.m_zLetGo;
               if(!humanPause && !this.getControllerNum(pausedID).IsDown(this.getControllerNum(pausedID)._START))
               {
                  this.m_pausedLetGo = true;
               }
               if(this.getControllerNum(pausedID).IsDown(this.getControllerNum(pausedID)._GRAB) && zLetGo && ModeFeatures.hasFeature(ModeFeatures.HAS_RETRY_BUTTON,this.GAME.GameMode))
               {
                  this.m_retryMatch = true;
                  this.endGame(true);
               }
               else if((this.getControllerNum(pausedID).IsDown(this.getControllerNum(pausedID)._BUTTON1) || this.getControllerNum(pausedID).IsDown(this.getControllerNum(pausedID)._SHIELD) && this.getControllerNum(pausedID).IsDown(this.getControllerNum(pausedID)._SHIELD2)) && this.getControllerNum(pausedID).IsDown(this.getControllerNum(pausedID)._BUTTON2) && this.getControllerNum(pausedID).IsDown(this.getControllerNum(pausedID)._START) && pauseLetGo)
               {
                  if(this.GAME.GameMode == Mode.ONLINE_WAITING_ROOM)
                  {
                     MultiplayerManager.notify("You have disconnected.");
                     MultiplayerManager.disconnect();
                  }
                  this.endGame(true);
               }
               else if(pauseLetGo && this.getControllerNum(pausedID).IsDown(this.getControllerNum(pausedID)._START))
               {
                  if(humanPause)
                  {
                     this.getPlayerByID(pausedID).PauseLetGo = false;
                  }
                  else
                  {
                     this.m_pausedLetGo = false;
                  }
                  this.Paused = false;
                  if(this.GAME.GameMode != Mode.TRAINING)
                  {
                     Main.Root.stage.frameRate = Main.FRAMERATE;
                     if(SpecialMode.modeEnabled(this.GAME.LevelData.specialModes,SpecialMode.SLOW))
                     {
                        Main.Root.stage.frameRate = Main.FRAMERATE / 2;
                     }
                     else if(SpecialMode.modeEnabled(this.GAME.LevelData.specialModes,SpecialMode.LIGHTNING))
                     {
                        Main.Root.stage.frameRate = Main.FRAMERATE * 2;
                     }
                  }
                  if(this.GAME.GameMode != Mode.TRAINING)
                  {
                     for(j = 1; j <= this.PLAYERS.length; j++)
                     {
                        if(this.getPlayerByID(j) != null)
                        {
                           this.getPlayerByID(j).playAllEffects();
                        }
                     }
                  }
               }
            }
            else
            {
               if(!this.getControllerNum(1).IsDown(this.getControllerNum(1)._START))
               {
                  this.m_pausedLetGo = true;
               }
               if(!this.getControllerNum(1).IsDown(this.getControllerNum(1)._GRAB))
               {
                  zLetGo = true;
               }
               i = 1;
               while(i <= this.PLAYERS.length && !this.m_wasReset && this.READY)
               {
                  if(this.getPlayerByID(i) != null && !(this.getPlayerByID(i).inState(CState.DEAD) && this.getPlayerByID(i).IsHuman && aliveHumanPlayer))
                  {
                     if(this.getPlayerByID(i).IsHuman && this.getPlayerByID(i).PauseLetGo && this.getPlayerByID(i).ControlSettings.IsDown(this.getPlayerByID(i).ControlSettings._START) || !this.getPlayerByID(i).IsHuman && this.m_pausedLetGo && this.getControllerNum(1).IsDown(this.getControllerNum(1)._START))
                     {
                        this.m_pausedLetGo = false;
                        this.m_paused = false;
                        this.getPlayerByID(i).PauseLetGo = false;
                        this.Paused = true;
                        if(this.GAME.GameMode != Mode.TRAINING)
                        {
                           Main.Root.stage.frameRate = Main.FRAMERATE;
                        }
                        this.PausedID = this.getPlayerByID(i).ID;
                        if(this.GAME.GameMode != Mode.TRAINING)
                        {
                           for(j = 0; j < this.CHARACTERS.length; j++)
                           {
                              if(this.CHARACTERS[j] != null)
                              {
                                 this.CHARACTERS[j].pauseAllEffects();
                              }
                           }
                        }
                        if(this.GAME.GameMode === Mode.TARGET_TEST || this.GAME.GameMode === Mode.CRYSTAL_SMASH)
                        {
                           this.CAM.maxZoomOut();
                           this.CAM.forceTarget();
                           this.CAM.forceInBounds();
                           this.CAM.camControl();
                        }
                        break;
                     }
                  }
                  i++;
               }
            }
         }
      }
      
      private function advanceAllStageFrames() : void
      {
         if(Boolean(this.m_fsCutscene) || this.m_fsCutins > 0)
         {
            return;
         }
         if(this.STAGE.root != null)
         {
            Utils.advanceFrame(this.STAGE);
         }
         if(Boolean(this.StageFG) && this.StageFG.root != null)
         {
            Utils.advanceFrame(this.StageFG);
            Utils.recursiveMovieClipPlay(this.StageFG,true);
         }
         if(Boolean(this.StageBG) && this.StageBG.root != null)
         {
            Utils.advanceFrame(this.StageBG);
            Utils.recursiveMovieClipPlay(this.StageBG,true);
         }
         if(Boolean(this.ShadowMaskRef) && this.ShadowMaskRef.root != null)
         {
            Utils.advanceFrame(this.ShadowMaskRef);
         }
         if(Boolean(this.ReflectionsMaskRef) && this.ReflectionsMaskRef.root != null)
         {
            Utils.advanceFrame(this.ReflectionsMaskRef);
         }
         this.CAM.nextFrameBG();
      }
      
      private function stopAllStageFrames() : void
      {
         if(Boolean(this.STAGE.root))
         {
            this.STAGE.stop();
         }
         if(Boolean(this.StageFG) && this.StageFG.root != null)
         {
            this.StageFG.stop();
            Utils.recursiveMovieClipPlay(this.StageFG,false);
         }
         if(Boolean(this.StageBG) && this.StageBG.root != null)
         {
            this.StageBG.stop();
            Utils.recursiveMovieClipPlay(this.StageBG,false);
         }
         if(Boolean(this.ShadowMaskRef) && this.ShadowMaskRef.root != null)
         {
            this.ShadowMaskRef.stop();
         }
         if(Boolean(this.ReflectionsMaskRef) && this.ReflectionsMaskRef.root != null)
         {
            this.ReflectionsMaskRef.stop();
         }
         this.CAM.pauseBG();
      }
      
      public function setCollisionsEnabled(value:Boolean) : void
      {
         this.m_collisionsEnabled = value;
      }
      
      private function flushDisposeBuffer() : void
      {
         for(var i:int = 0; i < this.m_apiDisposeList.length; i++)
         {
            this.m_apiDisposeList[i].dispose();
         }
         if(this.m_apiDisposeList.length > 0)
         {
            this.m_apiDisposeList.splice(0,this.m_apiDisposeList.length);
         }
      }
      
      private function disposeObjects(objects:*) : void
      {
         var i:int = objects.length - 1;
         while(i < objects.length && i >= 0)
         {
            if(Boolean(objects.length) && Boolean(objects[i]))
            {
               objects[i].dispose();
            }
            i--;
         }
      }
      
      private function tickObjects(objects:*) : void
      {
         var i:int = objects.length - 1;
         while(i < objects.length && i >= 0)
         {
            if(Boolean(objects.length) && Boolean(objects[i]))
            {
               objects[i].PERFORMALL();
            }
            i--;
         }
      }
      
      private function runAttackCollisionTests(objects:*) : void
      {
         var i:int = objects.length - 1;
         while(i < objects.length && i >= 0)
         {
            if(Boolean(objects.length) && Boolean(objects[i]))
            {
               objects[i].attackCollisionTest();
            }
            i--;
         }
      }
      
      private function cleanupAttackCollisionTests(objects:*) : void
      {
         var i:int = objects.length - 1;
         while(i < objects.length && i >= 0)
         {
            if(Boolean(objects.length) && Boolean(objects[i]))
            {
               objects[i].attackCollisionTestsCompleted();
            }
            i--;
         }
      }
      
      private function updateCharacterMatchResults() : void
      {
         for(var i:int = 0; i < this.CHARACTERS.length; i++)
         {
            this.CHARACTERS[i].updateMatchResults();
         }
      }
      
      private function PERFORMALL() : void
      {
         var p1Controls:ControlsObject = null;
         var i:int = 0;
         var j:int = 0;
         var mp:int = 0;
         var enemy:Enemy = null;
         var projectile:Projectile = null;
         this.checkOnlineSync();
         this.pauseCheck();
         if(this.REPLAYMODE && !this.Paused)
         {
            if(SaveData.Controllers[0].IsDown(SaveData.Controllers[0]._BUTTON1))
            {
               if(SaveData.Controllers[0].IsDown(SaveData.Controllers[0]._GRAB))
               {
                  if(this.m_replayFrameStep)
                  {
                     return;
                  }
                  this.m_replayFrameStep = true;
               }
               else
               {
                  this.m_replayFrameStep = false;
               }
               if(!this.m_replayFrameStep && !(SaveData.Controllers[0].IsDown(SaveData.Controllers[0]._SHIELD) || SaveData.Controllers[0].IsDown(SaveData.Controllers[0]._SHIELD2)))
               {
                  return;
               }
            }
         }
         if(!this.m_wasReset && this.READY)
         {
            if(this.Paused)
            {
               for(i = 0; i < this.CHARACTERS.length; i++)
               {
                  this.CHARACTERS[i].pauseControlChecks();
               }
            }
            else if(this.m_gameEnded && !this.m_slowFrameRate && this.m_gameEndedExit)
            {
               Utils.recursiveMovieClipPlay(this.HUDTEXT,true);
               this.m_endGameTimer.tick();
               if(this.m_endGameTimer.IsComplete)
               {
                  p1Controls = null;
                  if(!this.ReplayMode && ModeFeatures.hasFeature(ModeFeatures.HAS_RETRY_BUTTON,this.GAME.GameMode))
                  {
                     p1Controls = SaveData.Controllers[0].getControlStatus();
                     if(p1Controls.GRAB)
                     {
                        this.m_retryMatch = true;
                        this.endGame(true);
                     }
                     else if(p1Controls.BUTTON1 || p1Controls.BUTTON2 || p1Controls.START)
                     {
                        this.playSpecificSound("menu_select");
                        this.endGame();
                     }
                  }
                  else
                  {
                     this.endGame();
                  }
                  return;
               }
               if(Boolean(!this.ReplayMode && this.m_endGameOptions) && Boolean(this.m_endGameOptions.success === false) && ModeFeatures.hasFeature(ModeFeatures.HAS_RETRY_BUTTON,this.GAME.GameMode))
               {
                  p1Controls = SaveData.Controllers[0].getControlStatus();
                  if(p1Controls.GRAB)
                  {
                     this.m_retryMatch = true;
                     this.endGame(true);
                  }
               }
            }
            else
            {
               ++this.m_elapsedFrames;
               if(!this.m_event && !this.m_fsCutscene && this.m_fsCutins <= 0)
               {
                  ++this.m_elapsedPlayableFrames;
               }
               if(!this.REPLAYMODE)
               {
                  ++this.m_replayData.FrameCount;
               }
               this.runOnlineLog();
               i = 0;
               j = 0;
               mp = 0;
               if(this.REPLAYMODE)
               {
                  if(SaveData.Controllers[0].IsDown(SaveData.Controllers[0]._LEFT) !== SaveData.Controllers[0].IsDown(SaveData.Controllers[0]._RIGHT))
                  {
                     if(SaveData.Controllers[0].IsDown(SaveData.Controllers[0]._LEFT) && this.m_replayFrameRateMultiplier !== 0.5)
                     {
                        this.m_replayFrameRateMultiplier = 0.5;
                        if(SpecialMode.modeEnabled(this.GAME.LevelData.specialModes,SpecialMode.SLOW))
                        {
                           Main.Root.stage.frameRate = Main.FRAMERATE / 2 * this.m_replayFrameRateMultiplier;
                        }
                        else if(SpecialMode.modeEnabled(this.GAME.LevelData.specialModes,SpecialMode.LIGHTNING))
                        {
                           Main.Root.stage.frameRate = Main.FRAMERATE * 2 * this.m_replayFrameRateMultiplier;
                        }
                        else
                        {
                           Main.Root.stage.frameRate = Main.FRAMERATE * this.m_replayFrameRateMultiplier;
                        }
                     }
                     else if(SaveData.Controllers[0].IsDown(SaveData.Controllers[0]._RIGHT) && this.m_replayFrameRateMultiplier !== 2)
                     {
                        this.m_replayFrameRateMultiplier = 2;
                        if(SpecialMode.modeEnabled(this.GAME.LevelData.specialModes,SpecialMode.SLOW))
                        {
                           Main.Root.stage.frameRate = Main.FRAMERATE / 2 * this.m_replayFrameRateMultiplier;
                        }
                        else if(SpecialMode.modeEnabled(this.GAME.LevelData.specialModes,SpecialMode.LIGHTNING))
                        {
                           Main.Root.stage.frameRate = Main.FRAMERATE * this.m_replayFrameRateMultiplier;
                        }
                        else
                        {
                           Main.Root.stage.frameRate = Main.FRAMERATE * this.m_replayFrameRateMultiplier;
                        }
                     }
                  }
                  else if(this.m_replayFrameRateMultiplier !== 1)
                  {
                     this.m_replayFrameRateMultiplier = 1;
                     if(SpecialMode.modeEnabled(this.GAME.LevelData.specialModes,SpecialMode.SLOW))
                     {
                        Main.Root.stage.frameRate = Main.FRAMERATE / 2 * this.m_replayFrameRateMultiplier;
                     }
                     else if(SpecialMode.modeEnabled(this.GAME.LevelData.specialModes,SpecialMode.LIGHTNING))
                     {
                        Main.Root.stage.frameRate = Main.FRAMERATE * 2 * this.m_replayFrameRateMultiplier;
                     }
                     else
                     {
                        Main.Root.stage.frameRate = Main.FRAMERATE * this.m_replayFrameRateMultiplier;
                     }
                  }
                  for(i = 0; i < this.PLAYERS.length; i++)
                  {
                     if(this.PLAYERS[i] != null && this.PLAYERS[i].IsHuman)
                     {
                        this.PLAYERS[i].ControlSettings.setControlsObject(new ControlsObject(this.m_replayData.retrieveControls(i + 1)));
                     }
                  }
                  this.m_replayData.nextControls();
               }
               this.m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.GAME_TICK_START,{}));
               this.entranceCheck();
               if(this.GAME.UsingTime && !this.m_event && !this.m_fsCutscene && this.m_fsCutins <= 0)
               {
                  this.TIMER.PERFORMALL();
               }
               this.HUD.updateHealthBoxVisibility();
               this.HUD.updateCPUDamage();
               this.m_crowdChantTimer.tick();
               if(this.m_crowdChantTimer.IsComplete && this.m_crowdChantID > 0)
               {
                  this.stopCrowdChant();
                  this.playSpecificVoice(["crowd_clap_s","crowd_clap_m","crowd_clap_l"][Utils.safeRandomInteger(0,2)]);
               }
               if(this.m_crowdChantID < 0)
               {
                  this.m_crowdChantDelay.tick();
               }
               if(!this.m_fsCutscene && this.m_fsCutins <= 0)
               {
                  this.tickObjects(this.TARGETS);
               }
               if(!this.m_fsCutscene && this.m_fsCutins <= 0)
               {
                  this.tickObjects(this.MOVINGPLATFORMS);
               }
               if(!this.m_fsCutscene && this.m_fsCutins <= 0)
               {
                  this.tickObjects(this.COLLISION_BOUNDARIES);
               }
               if(Boolean(this.m_apiInstance) && Boolean(!this.m_fsCutscene) && this.m_fsCutins <= 0)
               {
                  this.m_apiInstance.update();
               }
               this.tickObjects(this.CHARACTERS);
               this.nextFrameAllEffects();
               this.advanceAllStageFrames();
               Utils.recursiveMovieClipPlay(this.CUTSCENE,true);
               this.tickObjects(this.ENEMY);
               this.tickObjects(this.PROJECTILES);
               this.ITEMS.PERFORMALL();
               this.tickObjects(this.ITEMS.ItemsInUse);
               if(this.m_collisionsEnabled)
               {
                  this.runAttackCollisionTests(this.CHARACTERS);
                  this.runAttackCollisionTests(this.ENEMY);
                  this.runAttackCollisionTests(this.PROJECTILES);
                  this.runAttackCollisionTests(this.ITEMS.ItemsInUse);
                  this.m_hitBoxProcessor.process();
                  this.cleanupAttackCollisionTests(this.CHARACTERS);
                  this.cleanupAttackCollisionTests(this.ENEMY);
                  this.cleanupAttackCollisionTests(this.PROJECTILES);
                  this.cleanupAttackCollisionTests(this.ITEMS.ItemsInUse);
               }
               if(!this.m_fsCutscene && this.m_fsCutins <= 0)
               {
                  this.tickTimers();
               }
               this.CAM.PERFORMALL();
               if(this.GAME.GameMode == Mode.TRAINING)
               {
                  this.HUD.updateHelpMenu();
               }
               if(ModeFeatures.hasFeature(ModeFeatures.IS_CUSTOM,this.GAME.GameMode))
               {
                  this.GAME.CustomMatchObj.update();
               }
               this.m_soundMemory.clear();
               this.updateCharacterMatchResults();
               this.m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.GAME_TICK_END,{}));
               if(this.m_gameEnded && this.m_gameEndedExit)
               {
                  this.m_endGameTimer.tick();
                  if(this.m_endGameTimer.IsComplete)
                  {
                     this.endGame();
                     return;
                  }
               }
               this.m_justPaused = false;
               if(this.m_endTrigger)
               {
                  this.m_endTrigger = false;
                  this.prepareEndGame(this.m_endGameOptions || {
                     "slowMo":this.m_slowFrameRate,
                     "immediate":false
                  });
               }
               if(this.REPLAYMODE && this.m_elapsedFrames > this.m_replayData.FrameCount && (this.GAME.GameMode === Mode.VS || this.GAME.GameMode === Mode.ONLINE || this.GAME.GameMode === Mode.ARENA || this.GAME.GameMode === Mode.ONLINE_ARENA))
               {
                  this.prepareEndGame({"forceNoContest":true});
               }
               this.flushDisposeBuffer();
            }
         }
         if(!this.m_wasReset && this.ONLINEMODE)
         {
            if(MultiplayerManager.INPUT_BUFFER != 0)
            {
               if(!this.m_onlineFrameBuffer.IsComplete)
               {
                  this.onlineModeSendControls();
                  this.m_onlineFrameBuffer.tick();
                  this.m_onlineFrameBuffer.MaxTime = MultiplayerManager.INPUT_BUFFER;
               }
            }
            MultiplayerManager.PERFORMALL();
         }
      }
      
      private function onlineModeSendControls(e:TimerEvent = null) : void
      {
         MultiplayerManager.sendMyDataFrame(MultiplayerManager.MasterFrame,{"controls":SaveData.Controllers[0].getControlStatus().controls});
         ++MultiplayerManager.MasterFrame;
      }
      
      public function createTimer(interval:int, repeats:int, func:Function, options:Object = null) : void
      {
         this.m_timers.push(new IntervalTimer(interval,repeats,func,options));
      }
      
      public function flushTimers() : void
      {
         this.m_timers.splice(0,this.m_timers.length);
      }
      
      private function tickTimers() : void
      {
         var i:int = 0;
         var batchTimers:Vector.<IntervalTimer> = null;
         var index:int = 0;
         if(Boolean(this.m_timers.length))
         {
            batchTimers = new Vector.<IntervalTimer>();
            for(i = 0; i < this.m_timers.length; i++)
            {
               this.m_timers[i].tick();
               if(this.m_timers[i].ReadyToProcess)
               {
                  batchTimers.push(this.m_timers[i]);
               }
            }
            for(i = 0; i < batchTimers.length; i++)
            {
               batchTimers[i].process();
               if(!batchTimers[i].Active)
               {
                  index = this.m_timers.indexOf(batchTimers[i]);
                  if(index >= 0)
                  {
                     this.m_timers.splice(index,1);
                  }
               }
            }
         }
      }
      
      public function destroyTimer(func:Function) : void
      {
         for(var i:int = 0; i < this.m_timers.length; i++)
         {
            if(this.m_timers[i].Callback == func)
            {
               this.m_timers.splice(i--,1);
            }
         }
      }
      
      public function addEventListener(type:String, func:Function, options:Object = null) : void
      {
         this.m_eventManager.addEventListener(type,func);
      }
      
      public function hasEventListener(type:String, func:Function = null) : Boolean
      {
         return this.m_eventManager.hasEvent(type,func);
      }
      
      public function removeEventListener(type:String, func:Function) : void
      {
         this.m_eventManager.removeEventListener(type,func);
      }
      
      public function getGameObjectByUID(uid:int) : InteractiveSprite
      {
         var result:InteractiveSprite = null;
         result = this.getCharacterByUID(uid);
         if(!result)
         {
            result = this.getProjectile(uid);
         }
         if(!result)
         {
            result = this.getEnemy(uid);
         }
         return result;
      }
      
      public function getPlayerByID(pnum:int) : Character
      {
         if(pnum <= 0 || pnum > this.PLAYERS.length || this.PLAYERS[pnum - 1] == null)
         {
            return null;
         }
         return this.PLAYERS[pnum - 1] as Character;
      }
      
      public function getPlayerByMC(mc:MovieClip) : Character
      {
         for(var i:int = 0; i < this.PLAYERS.length; i++)
         {
            if(Boolean(this.PLAYERS[i]) && (this.PLAYERS[i].MC == mc || this.PLAYERS[i].Stance != null && this.PLAYERS[i].Stance == mc))
            {
               return this.PLAYERS[i];
            }
            if(Boolean(this.PLAYERS[i]) && (Boolean(mc.player_id && mc.player_id > 0) && Boolean(this.PLAYERS[i].ID === mc.player_id) || Boolean(mc.parent && MovieClip(mc.parent).player_id && MovieClip(mc.parent).player_id > 0) && Boolean(this.PLAYERS[i].ID === MovieClip(mc.parent).player_id)))
            {
               return this.PLAYERS[i];
            }
         }
         return null;
      }
      
      public function getCharacterByUID(num:int) : Character
      {
         for(var i:int = 0; i < this.CHARACTERS.length; i++)
         {
            if(Boolean(this.CHARACTERS[i]) && this.CHARACTERS[i].UID == num)
            {
               return this.CHARACTERS[i];
            }
         }
         return null;
      }
      
      public function getCharacterByMC(mc:MovieClip) : Character
      {
         for(var i:int = 0; i < this.CHARACTERS.length; i++)
         {
            if(this.CHARACTERS[i].MC == mc || this.CHARACTERS[i].Stance != null && this.CHARACTERS[i].Stance == mc)
            {
               return this.CHARACTERS[i];
            }
         }
         return null;
      }
      
      public function hasEnemy(className:Class) : Boolean
      {
         for(var i:int = 0; i < this.ENEMY.length; i++)
         {
            if(this.ENEMY[i] is className)
            {
               return true;
            }
         }
         return false;
      }
      
      public function getEnemy(num:int) : Enemy
      {
         for(var i:int = 0; i < this.ENEMY.length; i++)
         {
            if(Boolean(this.ENEMY[i]) && this.ENEMY[i].UID == num)
            {
               return this.ENEMY[i];
            }
         }
         return null;
      }
      
      public function getEnemyByInstanceName(name:String) : Enemy
      {
         for(var i:int = 0; i < this.ENEMY.length; i++)
         {
            if(Boolean(this.ENEMY[i]) && this.ENEMY[i].getMC().name === name)
            {
               return this.ENEMY[i];
            }
         }
         return null;
      }
      
      public function getCollisionBoundaryByInstanceName(name:String) : BitmapCollisionBoundary
      {
         var i:int = 0;
         for(i = 0; i < this.COLLISION_BOUNDARIES.length; i++)
         {
            if(this.COLLISION_BOUNDARIES[i].Container.name === name)
            {
               return this.COLLISION_BOUNDARIES[i];
            }
         }
         for(i = 0; i < this.COLLISION_BOUNDARIES.length; i++)
         {
            if(this.COLLISION_BOUNDARIES[i].Container.name === name)
            {
               return this.COLLISION_BOUNDARIES[i];
            }
         }
         return null;
      }
      
      public function getCollisionBoundaryByMC(mc:MovieClip) : BitmapCollisionBoundary
      {
         var i:int = 0;
         for(i = 0; i < this.COLLISION_BOUNDARIES.length; i++)
         {
            if(this.COLLISION_BOUNDARIES[i].Container === mc || this.COLLISION_BOUNDARIES[i].CollisionClip === mc)
            {
               return this.COLLISION_BOUNDARIES[i];
            }
         }
         for(i = 0; i < this.COLLISION_BOUNDARIES.length; i++)
         {
            if(this.COLLISION_BOUNDARIES[i].Container === mc || this.COLLISION_BOUNDARIES[i].CollisionClip === mc)
            {
               return this.PLATFORMS[i];
            }
         }
         return null;
      }
      
      public function getPlatformByInstanceName(name:String) : Platform
      {
         var i:int = 0;
         for(i = 0; i < this.TERRAINS.length; i++)
         {
            if(this.TERRAINS[i].Container.name === name)
            {
               return this.TERRAINS[i];
            }
         }
         for(i = 0; i < this.PLATFORMS.length; i++)
         {
            if(this.PLATFORMS[i].Container.name === name)
            {
               return this.PLATFORMS[i];
            }
         }
         return null;
      }
      
      public function getPlatformByMC(mc:MovieClip) : Platform
      {
         var i:int = 0;
         for(i = 0; i < this.TERRAINS.length; i++)
         {
            if(this.TERRAINS[i].Container === mc || this.TERRAINS[i].CollisionClip === mc)
            {
               return this.TERRAINS[i];
            }
         }
         for(i = 0; i < this.PLATFORMS.length; i++)
         {
            if(this.PLATFORMS[i].Container === mc || this.PLATFORMS[i].CollisionClip === mc)
            {
               return this.PLATFORMS[i];
            }
         }
         return null;
      }
      
      public function getEnemyByMC(mc:MovieClip) : Enemy
      {
         for(var i:int = 0; i < this.ENEMY.length; i++)
         {
            if(Boolean(this.ENEMY[i]) && (this.ENEMY[i].MC == mc || this.ENEMY[i].Stance != null && this.ENEMY[i].Stance == mc))
            {
               return this.ENEMY[i];
            }
         }
         return null;
      }
      
      public function getControllerNum(cnum:int) : Controller
      {
         if(cnum > this.CONTROLLERS.length || cnum - 1 < 0 || this.CONTROLLERS[cnum - 1] == null)
         {
            return null;
         }
         return this.CONTROLLERS[cnum - 1] as Controller;
      }
      
      public function getPlayerArray() : Array
      {
         var x:* = undefined;
         var arr:Array = new Array();
         for(x in this.PLAYERS)
         {
            if(this.PLAYERS[x] != null)
            {
               arr.push(this.PLAYERS[x]);
            }
         }
         return arr;
      }
      
      public function getEnemyArray() : Array
      {
         var x:* = undefined;
         var arr:Array = new Array();
         for(x in this.ENEMY)
         {
            if(this.ENEMY[x] != null)
            {
               arr.push(this.ENEMY[x]);
            }
         }
         return arr;
      }
      
      public function getWalls() : Vector.<BitmapCollisionBoundary>
      {
         return this.WALLS;
      }
      
      public function getWarningBounds_UL() : Vector.<BitmapCollisionBoundary>
      {
         return this.WARNINGBOUNDS_UL;
      }
      
      public function getWarningBounds_UR() : Vector.<BitmapCollisionBoundary>
      {
         return this.WARNINGBOUNDS_UR;
      }
      
      public function getWarningBounds_LL() : Vector.<BitmapCollisionBoundary>
      {
         return this.WARNINGBOUNDS_LL;
      }
      
      public function getWarningBounds_LR() : Vector.<BitmapCollisionBoundary>
      {
         return this.WARNINGBOUNDS_LR;
      }
      
      public function getLedges_L() : Vector.<MovieClip>
      {
         return this.LEDGES_L;
      }
      
      public function getLedges_R() : Vector.<MovieClip>
      {
         return this.LEDGES_R;
      }
      
      public function getLedgesAPI() : Array
      {
         var ledges:Array = [];
         var leftLedges:Vector.<MovieClip> = this.getLedges_L();
         var rightLedges:Vector.<MovieClip> = this.getLedges_R();
         var i:int = 0;
         for(i = 0; i < leftLedges.length; i++)
         {
            ledges.push(leftLedges[i]);
         }
         for(i = 0; i < rightLedges.length; i++)
         {
            ledges.push(rightLedges[i]);
         }
         return ledges;
      }
      
      public function getBeacons() : Vector.<Beacon>
      {
         return this.BEACONS;
      }
      
      public function getAdjMatrix() : Array
      {
         return this.ADJMATRIX;
      }
      
      public function getRandomPokemon() : Class
      {
         var cls:Class = null;
         if(Boolean(this.ITEMS.PokemonClass))
         {
            cls = this.ITEMS.PokemonClass;
            this.ITEMS.PokemonClass = null;
            return cls;
         }
         return Utils.random() < 0.025 && this.m_pokemonRare.length > 0 ? this.m_pokemonRare[Utils.randomInteger(0,this.m_pokemonRare.length - 1)] : this.m_pokemon[Utils.randomInteger(0,this.m_pokemon.length - 1)];
      }
      
      public function getRandomAssist() : Class
      {
         var cls:Class = null;
         if(Boolean(this.ITEMS.AssistClass))
         {
            cls = this.ITEMS.AssistClass;
            this.ITEMS.AssistClass = null;
            return cls;
         }
         return Utils.random() < 0.025 && this.m_assistsRare.length > 0 ? this.m_assistsRare[Utils.randomInteger(0,this.m_assistsRare.length - 1)] : this.m_assists[Utils.randomInteger(0,this.m_assists.length - 1)];
      }
      
      public function getItem(id:int) : Item
      {
         return this.ITEMS.getItemByUID(id);
      }
      
      public function getItemByMC(mc:MovieClip) : Item
      {
         return this.ITEMS.getItemByMC(mc);
      }
      
      public function getItemGens() : Vector.<MovieClip>
      {
         return this.ITEMGENS;
      }
      
      public function getTargetByUID(num:int) : TargetTestTarget
      {
         for(var i:int = 0; i < this.TARGETS.length; i++)
         {
            if(Boolean(this.TARGETS[i]) && this.TARGETS[i].UID == num)
            {
               return this.TARGETS[i];
            }
         }
         return null;
      }
      
      public function getTargetByMC(mc:MovieClip) : TargetTestTarget
      {
         for(var i:int = 0; i < this.TARGETS.length; i++)
         {
            if(Boolean(this.TARGETS[i]) && (this.TARGETS[i].MC == mc || this.TARGETS[i].Stance != null && this.TARGETS[i].Stance == mc))
            {
               return this.TARGETS[i];
            }
         }
         return null;
      }
      
      public function spawnAssistAPI(assist:Class, owner:InteractiveSprite = null) : Enemy
      {
         if(Boolean(this.ITEMS.AssistClass))
         {
            assist = this.ITEMS.AssistClass;
            this.ITEMS.AssistClass = null;
         }
         return this.spawnEnemyAPI(assist,0,0,-1,null,owner);
      }
      
      public function spawnPokemonAPI(pokemon:Class, owner:InteractiveSprite = null) : Enemy
      {
         if(Boolean(this.ITEMS.PokemonClass))
         {
            pokemon = this.ITEMS.PokemonClass;
            this.ITEMS.PokemonClass = null;
         }
         return this.spawnEnemyAPI(pokemon,0,0,-1,null,owner);
      }
      
      public function spawnAssist(assist:Class, locx:Number, locy:Number, id:int = -1) : AssistTrophy
      {
         var tmp:Enemy = this.spawnEnemy(assist,locx,locy,id);
         if(tmp == null)
         {
            return null;
         }
         return tmp as AssistTrophy;
      }
      
      public function spawnEnemy(enemy:Class, locx:Number, locy:Number, id:int = -1) : Enemy
      {
         var instance:Enemy = new enemy(this,locx,locy,id);
         instance.APIInstance.initialize();
         return instance;
      }
      
      public function spawnEnemyAPI(enemy:Class, locx:Number = 0, locy:Number = 0, id:int = -1, mc:MovieClip = null, owner:InteractiveSprite = null) : Enemy
      {
         var data:EnemyStats = new EnemyStats();
         data.importData({"classAPI":enemy});
         var instance:Enemy = new Enemy(data,this,locx,locy,id,mc,owner);
         instance.APIInstance.initialize();
         return instance;
      }
      
      public function spawnCharacterAPI(character:Class) : Character
      {
         var data:CharacterData = new CharacterData();
         data.importData({"classAPI":character});
         var playerSettings:PlayerSetting = new PlayerSetting();
         this.deactivateCharacters();
         var instance:Character = new Character(data,playerSettings,this);
         instance.setState(CState.ENTRANCE);
         this.activateCharacters();
         instance.setState(CState.IDLE);
         instance.APIInstance.initialize();
         return instance;
      }
      
      public function spawnItemAPI(item:Class) : Item
      {
         var data:ItemData = new ItemData();
         data.importData({"classAPI":item});
         return this.ITEMS.generateItemObj(data,1337,1337,true);
      }
      
      public function spawnProjectileAPI(projectile:Class, owner:InteractiveSprite = null) : Projectile
      {
         var data:ProjectileAttack = new ProjectileAttack();
         data.importData({"classAPI":projectile});
         var params:Object = {
            "owner":owner,
            "player_id":(Boolean(owner) ? owner.ID : -1),
            "x_start":(Boolean(owner) ? owner.X : 0),
            "y_start":(Boolean(owner) ? owner.Y : 0),
            "sizeRatio":(Boolean(owner) ? owner.SizeRatio : 1),
            "facingForward":(Boolean(owner) ? owner.FacingForward : true),
            "chargetime":(Boolean(owner) ? owner.AttackStateData.ChargeTime : 0),
            "chargetime_max":(Boolean(owner) ? owner.AttackStateData.ChargeTimeMax : 0),
            "frame":"todo",
            "staleMultiplier":(Boolean(owner) && owner is Character ? Character(owner).totalMoveDecay("todo") : 1),
            "sizeStatus":(Boolean(owner) && owner is Character ? Character(owner).SizeStatus : 0),
            "terrains":this.TERRAINS,
            "platforms":this.PLATFORMS,
            "team_id":(Boolean(owner) ? owner.Team : -1),
            "volume_sfx":(Boolean(owner) && owner is Character ? Character(owner).getCharacterStat("volume_sfx") : 1),
            "volume_vfx":(Boolean(owner) && owner is Character ? Character(owner).getCharacterStat("volume_vfx") : 1)
         };
         var instance:Projectile = new Projectile(params,data,this);
         instance.X += Boolean(params.facingForward) ? instance.getProjectileStat("xoffset") * params.sizeRatio : -instance.getProjectileStat("xoffset") * params.sizeRatio;
         instance.Y += instance.getProjectileStat("yoffset") * params.sizeRatio;
         return instance;
      }
      
      public function spawnCollisionBoundaryAPI(boundary:Class) : BitmapCollisionBoundary
      {
         var instance:BitmapCollisionBoundary = new BitmapCollisionBoundary(null,this,"ground",false,{"classAPI":boundary});
         this.COLLISION_BOUNDARIES.unshift(instance);
         return instance;
      }
      
      public function spawnPlatformAPI(platform:Class, solidTerrain:Boolean = true) : Platform
      {
         var instance:MovingPlatform = new MovingPlatform(null,this,"ground",{"classAPI":platform});
         this.MOVINGPLATFORMS.unshift(instance);
         if(solidTerrain)
         {
            this.TERRAINS.unshift(instance);
         }
         else
         {
            this.PLATFORMS.unshift(instance);
         }
         instance.APIInstance.initialize();
         return instance;
      }
      
      public function addPlayer(num:int, character:Character) : Character
      {
         if(Boolean(this.PLAYERS[num - 1]))
         {
            throw new Error("Attempted to overwrite player slot!");
         }
         this.PLAYERS[num - 1] = character;
         return character;
      }
      
      public function addCharacter(character:Character) : Character
      {
         this.CHARACTERS.unshift(character);
         return character;
      }
      
      public function addEnemy(enemy:Enemy) : Enemy
      {
         this.ENEMY.unshift(enemy);
         return enemy;
      }
      
      public function addProjectile(projectile:Projectile) : Projectile
      {
         this.PROJECTILES.unshift(projectile);
         return projectile;
      }
      
      public function getProjectile(id:int) : Projectile
      {
         for(var i:int = 0; i < this.PROJECTILES.length; i++)
         {
            if(this.PROJECTILES[i].UID == id)
            {
               return this.PROJECTILES[i];
            }
         }
         return null;
      }
      
      public function getProjectiles() : Vector.<Projectile>
      {
         return this.PROJECTILES;
      }
      
      public function generateItemAPI(id:String, x:Number, y:Number, forceGenerate:Boolean = false) : *
      {
         var item:Item = null;
         if(id === "random")
         {
            item = this.ITEMS.makeItem(x,y,!forceGenerate,false);
         }
         else
         {
            item = this.ITEMS.generateItemObj(this.ITEMS.getItemByLinkage(id,!forceGenerate),x,y,false,false);
         }
         return Boolean(item) ? item.APIInstance.instance : null;
      }
      
      public function getProjectileByMC(mc:MovieClip) : Projectile
      {
         for(var i:int = 0; i < this.PROJECTILES.length; i++)
         {
            if(Boolean(this.PROJECTILES[i]) && (this.PROJECTILES[i].MC == mc || this.PROJECTILES[i].Stance != null && this.PROJECTILES[i].Stance == mc))
            {
               return this.PROJECTILES[i];
            }
         }
         return null;
      }
      
      public function removeEnemy(enemy:Enemy) : void
      {
         this.m_apiDisposeList.push(enemy);
         var index:int = this.ENEMY.indexOf(enemy);
         if(index >= 0)
         {
            this.ENEMY.splice(index,1);
         }
      }
      
      public function removeProjectile(projectile:Projectile) : void
      {
         this.m_apiDisposeList.push(projectile);
         var index:int = this.PROJECTILES.indexOf(projectile);
         if(index >= 0)
         {
            this.PROJECTILES.splice(index,1);
         }
      }
      
      public function removeCharacter(character:Character) : void
      {
         this.m_apiDisposeList.push(character);
         var index:int = this.CHARACTERS.indexOf(character);
         if(index >= 0)
         {
            this.CHARACTERS.splice(index,1);
         }
         index = this.PLAYERS.indexOf(character);
         if(index >= 0)
         {
            this.PLAYERS[index] = null;
         }
      }
      
      public function removeTarget(target:TargetTestTarget) : void
      {
         this.m_apiDisposeList.push(target);
         var index:int = this.TARGETS.indexOf(target);
         if(index >= 0)
         {
            this.TARGETS.splice(index,1);
         }
      }
      
      public function removeCollisionBoundary(boundary:BitmapCollisionBoundary) : void
      {
         this.m_apiDisposeList.push(boundary);
         var index:int = this.COLLISION_BOUNDARIES.indexOf(boundary);
         if(index >= 0)
         {
            this.COLLISION_BOUNDARIES.splice(index,1);
         }
      }
      
      public function removePlatform(platform:Platform) : void
      {
         this.m_apiDisposeList.push(platform);
         var index:int = this.MOVINGPLATFORMS.indexOf(platform);
         if(index >= 0)
         {
            this.MOVINGPLATFORMS.splice(index,1);
         }
         index = this.TERRAINS.indexOf(platform);
         if(index >= 0)
         {
            this.TERRAINS.splice(index,1);
         }
         else
         {
            index = this.PLATFORMS.indexOf(platform);
            if(index >= 0)
            {
               this.PLATFORMS.splice(index,1);
            }
         }
      }
      
      public function getQualitySettings() : Object
      {
         return this.m_qualitySettings;
      }
      
      public function getTeams() : Array
      {
         var teams:Array = new Array();
         for(var i:int = 0; i < this.PLAYERS.length; i++)
         {
            if(this.PLAYERS[i] != null && teams.indexOf(this.PLAYERS[i].Team) < 0)
            {
               teams.push(this.PLAYERS[i].Team);
            }
         }
         return teams;
      }
      
      public function setTeamRanks(team:int, rank:int) : void
      {
         for(var i:int = 0; i < this.PLAYERS.length; i++)
         {
            if(this.PLAYERS[i] != null && this.PLAYERS[i].Team == team)
            {
               this.PLAYERS[i].getMatchResults().Rank = rank;
            }
         }
      }
      
      public function updateRanks(force:Boolean = false) : void
      {
         if(ModeFeatures.hasFeature(ModeFeatures.IS_CUSTOM,this.GAME.GameMode))
         {
            return;
         }
         if(!force && this.m_gameEnded)
         {
            return;
         }
         var i:int = 0;
         var currentRank:int = 1;
         var matchResults:Vector.<MatchResults> = new Vector.<MatchResults>();
         var teams:Array = this.getTeams();
         if(teams.length > 1)
         {
            if(this.GAME.UsingLives)
            {
               for(i = 0; i < teams.length; i++)
               {
                  matchResults.push(new MatchResults(teams[i]));
               }
               for(i = 0; i < this.PLAYERS.length; i++)
               {
                  if(this.PLAYERS[i] != null)
                  {
                     matchResults[teams.indexOf(this.PLAYERS[i].Team)].StockRemaining = matchResults[teams.indexOf(this.PLAYERS[i].Team)].StockRemaining + this.PLAYERS[i].getMatchResults().StockRemaining;
                     matchResults[teams.indexOf(this.PLAYERS[i].Team)].SurvivalTime = matchResults[teams.indexOf(this.PLAYERS[i].Team)].SurvivalTime + this.PLAYERS[i].getMatchResults().SurvivalTime;
                  }
               }
               matchResults.sort(this.compareMatchResultsForStock);
               i = 0;
               while(i < matchResults.length)
               {
                  this.setTeamRanks(matchResults[i].Owner,currentRank);
                  while(true)
                  {
                     if(i >= matchResults.length)
                     {
                        break;
                     }
                     if(i + 1 >= matchResults.length)
                     {
                        break;
                     }
                     if(matchResults[i + 1].StockRemaining != matchResults[i].StockRemaining)
                     {
                        break;
                     }
                     if(matchResults[i].StockRemaining <= 0)
                     {
                        if(!(this.GAME.UsingTime && matchResults[i + 1].SurvivalTime == matchResults[i].SurvivalTime))
                        {
                           break;
                        }
                        this.setTeamRanks(matchResults[++i].Owner,currentRank);
                     }
                     else
                     {
                        if(matchResults[i + 1].DamageRemaining != matchResults[i].DamageRemaining)
                        {
                           break;
                        }
                        this.setTeamRanks(matchResults[++i].Owner,currentRank);
                     }
                     i++;
                  }
                  i++;
                  currentRank++;
               }
            }
            else
            {
               for(i = 0; i < teams.length; i++)
               {
                  matchResults.push(new MatchResults(teams[i]));
               }
               for(i = 0; i < this.PLAYERS.length; i++)
               {
                  if(this.PLAYERS[i] != null)
                  {
                     matchResults[teams.indexOf(this.PLAYERS[i].Team)].Score = matchResults[teams.indexOf(this.PLAYERS[i].Team)].Score + this.PLAYERS[i].getMatchResults().Score;
                  }
               }
               matchResults.sort(this.compareMatchResultsForTime);
               i = 0;
               while(i < matchResults.length)
               {
                  this.setTeamRanks(matchResults[i].Owner,currentRank);
                  while(i < matchResults.length)
                  {
                     if(!(i + 1 < matchResults.length && matchResults[i + 1].Score == matchResults[i].Score))
                     {
                        break;
                     }
                     this.setTeamRanks(matchResults[++i].Owner,currentRank);
                  }
                  i++;
                  currentRank++;
               }
            }
         }
         else if(this.GAME.UsingLives)
         {
            for(i = 0; i < this.PLAYERS.length; i++)
            {
               if(this.PLAYERS[i] != null)
               {
                  matchResults.push(this.PLAYERS[i].getMatchResults());
               }
            }
            matchResults.sort(this.compareMatchResultsForStock);
            i = 0;
            while(i < matchResults.length)
            {
               this.getPlayerByID(matchResults[i].Owner).getMatchResults().Rank = currentRank;
               while(true)
               {
                  if(i >= matchResults.length)
                  {
                     break;
                  }
                  if(i + 1 >= matchResults.length)
                  {
                     break;
                  }
                  if(matchResults[i + 1].StockRemaining != matchResults[i].StockRemaining)
                  {
                     break;
                  }
                  if(matchResults[i].StockRemaining == 0)
                  {
                     if(!(this.GAME.UsingTime && matchResults[i + 1].SurvivalTime == matchResults[i].SurvivalTime))
                     {
                        break;
                     }
                     this.getPlayerByID(matchResults[i + 1].Owner).getMatchResults().Rank = currentRank;
                  }
                  else
                  {
                     if(matchResults[i + 1].DamageRemaining != matchResults[i].DamageRemaining)
                     {
                        break;
                     }
                     this.getPlayerByID(matchResults[i + 1].Owner).getMatchResults().Rank = currentRank;
                  }
                  i++;
               }
               i++;
               currentRank++;
            }
         }
         else
         {
            for(i = 0; i < this.PLAYERS.length; i++)
            {
               if(this.PLAYERS[i] != null)
               {
                  matchResults.push(this.PLAYERS[i].getMatchResults());
               }
            }
            matchResults.sort(this.compareMatchResultsForTime);
            i = 0;
            while(i < matchResults.length)
            {
               this.getPlayerByID(matchResults[i].Owner).getMatchResults().Rank = currentRank;
               while(i < matchResults.length)
               {
                  if(!(i + 1 < matchResults.length && matchResults[i + 1].Score == matchResults[i].Score))
                  {
                     break;
                  }
                  this.getPlayerByID(matchResults[++i].Owner).getMatchResults().Rank = currentRank;
               }
               i++;
               currentRank++;
            }
         }
      }
      
      public function getFirstWinner() : Character
      {
         for(var i:int = 0; i < this.PLAYERS.length; i++)
         {
            if(this.PLAYERS[i] != null && this.PLAYERS[i].getMatchResults().Rank == 1)
            {
               return this.PLAYERS[i];
            }
         }
         return null;
      }
      
      public function getWinners() : Array
      {
         this.updateRanks();
         var results:Array = [];
         var i:int = 0;
         while(Boolean(this.PLAYERS) && i < this.PLAYERS.length)
         {
            if(this.PLAYERS[i] != null && this.PLAYERS[i].getMatchResults().Rank == 1)
            {
               results.push(this.PLAYERS[i]);
            }
            i++;
         }
         return results;
      }
      
      public function getLosers() : Array
      {
         this.updateRanks();
         var results:Array = [];
         var i:int = 0;
         while(Boolean(this.PLAYERS) && i < this.PLAYERS.length)
         {
            if(this.PLAYERS[i] != null && this.PLAYERS[i].getMatchResults().Rank !== 1)
            {
               results.push(this.PLAYERS[i]);
            }
            i++;
         }
         return results;
      }
      
      private function compareMatchResultsForTime(m1:MatchResults, m2:MatchResults) : Number
      {
         return m2.Score - m1.Score;
      }
      
      private function compareMatchResultsForStock(m1:MatchResults, m2:MatchResults) : Number
      {
         if(m1.StockRemaining == m2.StockRemaining)
         {
            if(m1.StockRemaining <= 0)
            {
               return m2.SurvivalTime - m1.SurvivalTime;
            }
            if(m1.DamageRemaining == m2.DamageRemaining)
            {
               return 0;
            }
            return this.GAME.UsingStamina ? m2.DamageRemaining - m1.DamageRemaining : m1.DamageRemaining - m2.DamageRemaining;
         }
         return m2.StockRemaining - m1.StockRemaining;
      }
      
      public function getFPS() : Number
      {
         return Math.round(this.m_elapsedFrames / (getTimer() - (this.m_startTime + this.m_totalPausedTime)) * 10000) / 10;
      }
      
      public function restartMusic() : void
      {
         this.SOUNDQUEUE.playMusic(this.m_music,this.m_loopLoc);
      }
      
      public function dispose() : void
      {
         this.flushDisposeBuffer();
         this.disposeObjects(this.WARNINGBOUNDS_LL);
         this.disposeObjects(this.WARNINGBOUNDS_LR);
         this.disposeObjects(this.WARNINGBOUNDS_UL);
         this.disposeObjects(this.WARNINGBOUNDS_UR);
         this.disposeObjects(this.WALLS);
         this.disposeObjects(this.TARGETS);
         this.disposeObjects(this.MOVINGPLATFORMS);
         this.disposeObjects(this.COLLISION_BOUNDARIES);
         this.disposeObjects(this.CHARACTERS);
         this.disposeObjects(this.ENEMY);
         this.disposeObjects(this.PROJECTILES);
         this.disposeObjects(this.ITEMS.ItemsInUse);
         this.m_eventManager.removeAllEvents();
         this.flushTimers();
      }
      
      public function get APIInstance() : SSF2Stage
      {
         return this.m_apiInstance;
      }
      
      public function get StarKOEnabled() : Boolean
      {
         return this.m_starKOEnabled;
      }
      
      public function set StarKOEnabled(value:Boolean) : void
      {
         this.m_starKOEnabled = value;
      }
      
      public function get ScreenKOEnabled() : Boolean
      {
         return this.m_screenKOEnabled;
      }
      
      public function set ScreenKOEnabled(value:Boolean) : void
      {
         this.m_screenKOEnabled = value;
      }
      
      public function get HitBoxProcessorInstance() : HitBoxProcessor
      {
         return this.m_hitBoxProcessor;
      }
      
      public function get FPSTimer() : Debug_fps
      {
         return this.m_fpsTimer;
      }
      
      public function get EndGameOptions() : Object
      {
         return this.m_endGameOptions;
      }
      
      public function get ElapsedFrames() : int
      {
         return this.m_elapsedFrames;
      }
      
      public function get ElapsedPlayableFrames() : int
      {
         return this.m_elapsedPlayableFrames;
      }
      
      public function get ActiveScripts() : Boolean
      {
         return this.m_activeScripts;
      }
      
      public function get CrowdChantID() : int
      {
         return this.m_crowdChantID;
      }
      
      public function get ReplayDataObj() : ReplayData
      {
         return this.m_replayData;
      }
      
      public function get HazardsOn() : Boolean
      {
         return this.m_hazardsOn;
      }
      
      public function get AirDodge() : String
      {
         return "brawl";
      }
      
      public function set AirDodge(value:String) : void
      {
         this.m_airDodge = value;
      }
      
      public function get GravityMultiplier() : Number
      {
         return this.m_gravityMultiplier;
      }
      
      public function get DisableCeilingDeath() : Boolean
      {
         return this.m_disableCeilingDeath;
      }
      
      public function set DisableCeilingDeath(value:Boolean) : void
      {
         this.m_disableCeilingDeath = value;
      }
      
      public function get DisableFallDeath() : Boolean
      {
         return this.m_disableFallDeath;
      }
      
      public function set DisableFallDeath(value:Boolean) : void
      {
         this.m_disableFallDeath = value;
      }
      
      public function get MatchMilliseconds() : Number
      {
         return this.m_endTime - this.m_startTime;
      }
      
      public function get Terrains() : Vector.<Platform>
      {
         return this.TERRAINS;
      }
      
      public function get Platforms() : Vector.<Platform>
      {
         return this.PLATFORMS;
      }
      
      public function get MovingPlatforms() : Vector.<MovingPlatform>
      {
         return this.MOVINGPLATFORMS;
      }
      
      public function get LogText() : String
      {
         return this.m_logText;
      }
      
      public function set LogText(value:String) : void
      {
         this.m_logText = value;
      }
      
      public function get Ready() : Boolean
      {
         return this.READY;
      }
      
      public function get OnlineMode() : Boolean
      {
         return this.ONLINEMODE;
      }
      
      public function set OnlineMode(value:Boolean) : void
      {
         this.ONLINEMODE = value;
      }
      
      public function get ReplayMode() : Boolean
      {
         return this.REPLAYMODE;
      }
      
      public function set ReplayMode(value:Boolean) : void
      {
         this.REPLAYMODE = value;
      }
      
      public function get NoContest() : Boolean
      {
         return this.m_noContest;
      }
      
      public function set NoContest(value:Boolean) : void
      {
         this.m_noContest = value;
      }
      
      public function get NoHumans() : Boolean
      {
         var noHumans:Boolean = true;
         for(var c:int = 0; c < this.PLAYERS.length; c++)
         {
            if(this.PLAYERS[c] != null && this.PLAYERS[c].IsHuman)
            {
               noHumans = false;
            }
         }
         return noHumans;
      }
      
      public function get StageEvent() : Boolean
      {
         return this.m_event;
      }
      
      public function get EventManagerObj() : EventManager
      {
         return this.m_eventManager;
      }
      
      public function get RootRef() : MovieClip
      {
         return this.ROOT;
      }
      
      public function get LightSource() : MovieClip
      {
         return this.LIGHTSOURCE;
      }
      
      public function get StageRef() : MovieClip
      {
         return this.STAGE;
      }
      
      public function get StageParentRef() : MovieClip
      {
         return this.STAGEPARENT;
      }
      
      public function get StageEffectsRef() : MovieClip
      {
         return this.STAGEEFFECTS;
      }
      
      public function get HudRef() : HudMenu
      {
         return this.HUD;
      }
      
      public function get HudForegroundRef() : MovieClip
      {
         return this.HUDFOREGROUND;
      }
      
      public function get HudOverlayRef() : MovieClip
      {
         return this.HUDOVERLAY;
      }
      
      public function get CamRef() : Vcam
      {
         return this.CAM;
      }
      
      public function get CamBounds() : MovieClip
      {
         return this.CAMBOUNDS;
      }
      
      public function get SmashBallBounds() : MovieClip
      {
         return this.SMASHBALLBOUNDS;
      }
      
      public function get DeathBounds() : MovieClip
      {
         return this.DEATHBOUNDS;
      }
      
      public function get ItemsRef() : ItemGenerator
      {
         return this.ITEMS;
      }
      
      public function get GameRef() : Game
      {
         return this.GAME;
      }
      
      public function get SoundQueueRef() : SoundQueue
      {
         return this.SOUNDQUEUE;
      }
      
      public function get TimerRef() : GameTimer
      {
         return this.TIMER;
      }
      
      public function get FSCutscene() : MovieClip
      {
         return this.m_fsCutscene;
      }
      
      public function set FSCutscene(value:MovieClip) : void
      {
         this.m_fsCutscene = value;
         if(this.GAME.HudDisplay)
         {
            this.HUD.toggleMainDisplay(Boolean(value) ? false : true);
         }
      }
      
      public function get FSCutins() : int
      {
         return this.m_fsCutins;
      }
      
      public function set FSCutins(value:int) : void
      {
         this.m_fsCutins = value;
         if(this.m_fsCutins < 0)
         {
            this.m_fsCutins = 0;
         }
      }
      
      public function get PauseCamHeight() : Number
      {
         return this.m_pauseCamHeight;
      }
      
      public function get JustPaused() : Boolean
      {
         return this.m_justPaused;
      }
      
      public function get Paused() : Boolean
      {
         return this.m_paused;
      }
      
      public function set Paused(value:Boolean) : void
      {
         var i:int = 0;
         var list:Vector.<MovieClip> = null;
         var p:int = 0;
         var list2:Vector.<MovieClip> = null;
         var p2:int = 0;
         var e:* = undefined;
         var pp:* = undefined;
         var e2:* = undefined;
         this.m_justPaused = true;
         if(this.GAME.GameMode == Mode.TRAINING)
         {
            this.m_freezeKeys = !this.m_freezeKeys;
            if(this.m_freezeKeys)
            {
               this.HUD.showTrainingDisplay();
               list = new Vector.<MovieClip>();
               for(p = 0; p < this.PLAYERS.length; p++)
               {
                  if(this.PLAYERS[p] != null && !this.PLAYERS[p].StandBy)
                  {
                     list.push(this.PLAYERS[p].MC);
                  }
               }
               if(this.ItemsRef.CurrentSmashBall != null)
               {
                  list.push(this.ItemsRef.CurrentSmashBall.ItemInstance);
               }
               this.CAM.deleteTargets(list);
               list = list.slice(0,1);
               this.CAM.addTargets(list);
               SoundQueue.instance.playSoundEffect("menu_pause");
            }
            else
            {
               SoundQueue.instance.playSoundEffect("menu_back");
               this.HUD.hideTrainingDisplay();
               for(i = 1; i < this.PLAYERS.length; i++)
               {
                  if(this.PLAYERS[i] != null)
                  {
                     this.PLAYERS[i].setDamage(this.HUD.CpuDamage);
                  }
               }
               list2 = new Vector.<MovieClip>();
               for(p2 = 0; p2 < this.PLAYERS.length; p2++)
               {
                  if(this.PLAYERS[p2] != null && !this.PLAYERS[p2].StandBy)
                  {
                     list2.push(this.PLAYERS[p2].MC);
                  }
               }
               list2.splice(0,1);
               if(this.ItemsRef.CurrentSmashBall != null && this.CAM.Mode != Vcam.ZOOM_MODE)
               {
                  list2.push(this.ItemsRef.CurrentSmashBall.ItemInstance);
               }
               if(list2.length > 0 && this.CAM.Mode != Vcam.ZOOM_MODE)
               {
                  this.CAM.addTargets(list2);
               }
            }
         }
         else
         {
            this.m_paused = value;
            if(!this.m_paused)
            {
               if(!this.SOUNDQUEUE.MusicIsMuted)
               {
                  this.SOUNDQUEUE.setMusicVolume(SaveData.BGVolumeLevel);
               }
               this.HUDFOREGROUND.visible = true;
               this.HUDTEXT.visible = true;
               this.HUD.togglePauseIcons(false);
               if(!this.m_fsCutscene && this.GAME.HudDisplay)
               {
                  this.HUD.toggleMainDisplay(true);
               }
               for(e in this.ENEMY)
               {
                  if(this.ENEMY[e] != null && !this.ENEMY[e].Dead)
                  {
                     this.ENEMY[e].unpause();
                  }
               }
               if(this.GAME.UsingTime)
               {
                  this.TIMER.TimeMC.visible = true;
               }
               this.SOUNDQUEUE.unpauseAllSounds();
               SoundQueue.instance.playSoundEffect("menu_back");
               this.m_totalPausedTime += getTimer() - this.m_pausedTimestamp;
               this.m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.GAME_UNPAUSED,{}));
            }
            else
            {
               if(!this.SOUNDQUEUE.MusicIsMuted)
               {
                  this.SOUNDQUEUE.setMusicVolume(SaveData.BGVolumeLevel / 2);
               }
               this.HUDFOREGROUND.visible = false;
               this.HUDTEXT.visible = false;
               this.HUD.togglePauseIcons(true);
               if(this.GAME.HudDisplay)
               {
                  this.HUD.toggleMainDisplay(false);
               }
               for(pp in this.CHARACTERS)
               {
                  if(this.CHARACTERS[pp] != null)
                  {
                     Utils.recursiveMovieClipPlay(this.CHARACTERS[pp].MC.stance,false);
                  }
               }
               for(e2 in this.ENEMY)
               {
                  if(this.ENEMY[e2] != null && !this.ENEMY[e2].Dead)
                  {
                     this.ENEMY[e2].pause();
                  }
               }
               this.TIMER.TimeMC.visible = false;
               this.SOUNDQUEUE.pauseAllSounds();
               SoundQueue.instance.playSoundEffect("menu_pause");
               this.m_pausedTimestamp = getTimer();
               this.m_eventManager.dispatchEvent(new SSF2Event(SSF2Event.GAME_PAUSED,{}));
            }
         }
      }
      
      public function get PausedID() : int
      {
         return this.m_paused_id;
      }
      
      public function set PausedID(value:int) : void
      {
         this.m_paused_id = value;
         if(this.m_paused && this.GAME.GameMode != Mode.TRAINING)
         {
            this.HUD.updatePauseKeyboardDisplay(this.getControllerNum(this.m_paused_id));
            this.CAM.CamMC.width = this.CAM.OriginalWidth / 3;
            this.CAM.CamMC.height = this.CAM.OriginalHeight / 3;
            if(this.getPlayerByID(this.m_paused_id) != null && this.getPlayerByID(this.m_paused_id).Dead)
            {
               this.CAM.CamMC.height = this.CAM.MainTerrain.height;
               this.CAM.CamMC.width = this.CAM.MainTerrain.height * (Main.Width / Main.Height);
               this.CAM.forceInBounds();
            }
            else if(this.getPlayerByID(this.m_paused_id) != null)
            {
               this.CAM.CamMC.x = this.getPlayerByID(this.m_paused_id).OverlayX;
               this.CAM.CamMC.y = this.getPlayerByID(this.m_paused_id).OverlayY;
               this.CAM.syncPositions();
               this.CAM.camControl();
            }
            this.CAM.forceInBounds();
            this.CAM.camControl();
            this.m_pauseCamHeight = this.CAM.Height;
         }
      }
      
      public function set StageEvent(value:Boolean) : void
      {
         if(this.ONLINEMODE && !value)
         {
            this.STAGE.stage.frameRate = 30;
         }
         this.m_event = value;
      }
      
      public function set RootRef(value:MovieClip) : void
      {
         this.ROOT = value;
      }
      
      public function set StageRef(value:MovieClip) : void
      {
         this.STAGE = value;
      }
      
      public function set StageParentRef(value:MovieClip) : void
      {
         this.STAGEPARENT = value;
      }
      
      public function set CamRef(value:Vcam) : void
      {
         this.CAM = value;
      }
      
      public function set ItemsRef(value:ItemGenerator) : void
      {
         this.ITEMS = value;
      }
      
      public function set GameRef(value:Game) : void
      {
         this.GAME = value;
      }
      
      public function set SoundQueueRef(value:SoundQueue) : void
      {
         this.SOUNDQUEUE = value;
      }
      
      public function set TimerRef(value:GameTimer) : void
      {
         this.TIMER = value;
      }
      
      public function get Targets() : Vector.<TargetTestTarget>
      {
         return this.TARGETS;
      }
      
      public function get FreezeKeys() : Boolean
      {
         return this.m_freezeKeys;
      }
      
      public function set FreezeKeys(value:Boolean) : void
      {
         this.m_freezeKeys = value;
      }
      
      public function get PokemonCount() : int
      {
         return this.m_pokemonCount;
      }
      
      public function set PokemonCount(value:int) : void
      {
         this.m_pokemonCount = value;
      }
      
      public function get Pokemons() : Vector.<Class>
      {
         return this.m_pokemon;
      }
      
      public function get PokemonsRare() : Vector.<Class>
      {
         return this.m_pokemonRare;
      }
      
      public function get AssistCount() : int
      {
         return this.m_assistCount;
      }
      
      public function set AssistCount(value:int) : void
      {
         this.m_assistCount = value;
      }
      
      public function get Assists() : Vector.<Class>
      {
         return this.m_assists;
      }
      
      public function get AssistsRare() : Vector.<Class>
      {
         return this.m_assistsRare;
      }
      
      public function get CuccoCount() : int
      {
         return this.m_cuccoCount;
      }
      
      public function set CuccoCount(value:int) : void
      {
         this.m_cuccoCount = value;
      }
      
      public function get EndTrigger() : Boolean
      {
         return this.m_endTrigger;
      }
      
      public function get GameEndedExit() : Boolean
      {
         return this.m_gameEndedExit;
      }
      
      public function set GameEndedExit(value:Boolean) : void
      {
         this.m_gameEndedExit = value;
      }
      
      public function get GameEnded() : Boolean
      {
         return this.m_gameEnded;
      }
      
      public function get WasReset() : Boolean
      {
         return this.m_wasReset;
      }
      
      public function set GameEnded(value:Boolean) : void
      {
         this.m_gameEnded = value;
      }
      
      public function get SizeRatio() : Number
      {
         return this.GAME.SizeRatio;
      }
      
      public function get Projectiles() : Vector.<Projectile>
      {
         return this.PROJECTILES;
      }
      
      public function get Enemies() : Vector.<Enemy>
      {
         return this.ENEMY;
      }
      
      public function get Players() : Vector.<Character>
      {
         return this.PLAYERS;
      }
      
      public function get Characters() : Vector.<Character>
      {
         return this.CHARACTERS;
      }
      
      public function get StageBG() : MovieClip
      {
         return this.STAGEBACKGROUND;
      }
      
      public function get StageFG() : MovieClip
      {
         return this.STAGEFOREGROUND;
      }
      
      public function get WeatherRef() : MovieClip
      {
         return this.WEATHER;
      }
      
      public function get WeatherMaskRef() : MovieClip
      {
         return this.WEATHERMASK;
      }
      
      public function get CutsceneRef() : MovieClip
      {
         return this.CUTSCENE;
      }
      
      public function get TagsRef() : MovieClip
      {
         return this.TAGS;
      }
      
      public function get ShadowsRef() : MovieClip
      {
         return this.SHADOWS;
      }
      
      public function get ShadowMaskRef() : MovieClip
      {
         return this.SHADOWMASK;
      }
      
      public function get ReflectionsRef() : MovieClip
      {
         return this.REFLECTIONS;
      }
      
      public function get ReflectionsMaskRef() : MovieClip
      {
         return this.REFLECTIONSMASK;
      }
      
      public function get TeamDamage() : Boolean
      {
         return this.GAME.LevelData.teamDamage;
      }
      
      public function get CanSuddenDeath() : Boolean
      {
         return this.m_canSuddenDeath;
      }
      
      public function set CanSuddenDeath(value:Boolean) : void
      {
         this.m_canSuddenDeath = value;
      }
      
      public function get SuddenDeath() : Boolean
      {
         return this.m_suddenDeath;
      }
      
      public function get SuddenDeathIDs() : Array
      {
         return this.m_suddenDeathIDs;
      }
      
      public function getTimestamp() : Date
      {
         return this.m_replayData.Timestamp;
      }
      
      public function get StartPositionMCs() : Vector.<MovieClip>
      {
         return this.START_POSITIONS;
      }
      
      public function get SpawnPositionMCs() : Vector.<MovieClip>
      {
         return this.SPAWN_POSITIONS;
      }
      
      public function fixBG() : void
      {
         this.CAM.fixBG();
      }
      
      public function playNarratorSpeech(speechArr:Array) : void
      {
         var index:int = 0;
         var i:int = 0;
         if(speechArr != null && speechArr.length > 0 && !(this.GAME.UsingTime && this.TIMER.CurrentTime < Main.FRAMERATE * 5) && (this.m_narratorSpeech == null || this.m_narratorSpeech.IsFinished))
         {
            this.m_narratorSpeech = null;
            index = this.SOUNDQUEUE.playVoiceEffect(speechArr[i]);
            if(index >= 0)
            {
               this.m_narratorSpeech = this.SOUNDQUEUE.getSoundObject(index);
               for(i = 1; i < speechArr.length; i++)
               {
                  this.m_narratorSpeech.queueSound(ResourceManager.getLibrarySound(speechArr[i]),SaveData.VAVolumeLevel,speechArr[i]);
               }
            }
         }
      }
      
      public function stopNarratorSpeech() : void
      {
         if(this.m_narratorSpeech != null)
         {
            this.m_narratorSpeech.stop();
         }
         this.m_narratorSpeech = null;
      }
      
      public function playSpecificSound(sound:String, scale:Number = 1) : int
      {
         if(this.m_soundMemory.containsKey(sound))
         {
            return -1;
         }
         this.m_soundMemory.setKey(sound,true);
         return this.SOUNDQUEUE.playSoundEffect(sound,scale);
      }
      
      public function playSpecificVoice(sound:String, scale:Number = 1) : int
      {
         if(this.m_soundMemory.containsKey(sound))
         {
            return -1;
         }
         this.m_soundMemory.setKey(sound,true);
         return this.SOUNDQUEUE.playVoiceEffect(sound,scale);
      }
      
      public function stopSound(loc:int) : void
      {
         this.SOUNDQUEUE.stopSound(loc);
      }
      
      public function setCamStageFocus(length:int) : void
      {
         this.CAM.setStageFocus(length);
      }
      
      public function removeCamStageFocus() : void
      {
         this.CAM.removeStageFocus();
      }
      
      public function getCamBounds() : MovieClip
      {
         return this.CAMBOUNDS;
      }
      
      public function getDeathBounds() : MovieClip
      {
         return this.DEATHBOUNDS;
      }
      
      public function calculateChargeDamage(obj:Object) : Number
      {
         var attackDamage:AttackDamage = new AttackDamage(0);
         attackDamage.importAttackDamageData(obj);
         return Utils.calculateChargeDamage(attackDamage);
      }
      
      public function attachEffect(id:*, options:Object = null) : MovieClip
      {
         var x:Number = 0;
         var y:Number = 0;
         var scaleX:Number = 1;
         var scaleY:Number = 1;
         var rotation:Number = 0;
         var force:Boolean = false;
         if(options != null)
         {
            x = options.x !== undefined ? Number(options.x) : x;
            y = options.y !== undefined ? Number(options.y) : y;
            scaleX = options.scaleX !== undefined ? Number(options.scaleX) : scaleX;
            scaleY = options.scaleY !== undefined ? Number(options.scaleY) : scaleY;
            rotation = options.rotation !== undefined ? Number(options.rotation) : 0;
            force = options.force !== undefined ? Boolean(options.force) : force;
         }
         if(Boolean(id is String && id.match(/^global_/)) && Boolean(!this.getQualitySettings().global_effects) && !force)
         {
            return new MovieClip();
         }
         var tmpMC:MovieClip = null;
         if(id != null)
         {
            tmpMC = this.attachUniqueMovie(id);
            if(tmpMC != null)
            {
               tmpMC.stop();
               Utils.recursiveMovieClipPlay(tmpMC,false);
               tmpMC.x = x;
               tmpMC.y = y;
               tmpMC.scaleX *= scaleX;
               tmpMC.scaleY *= scaleY;
               tmpMC.rotation = rotation;
            }
         }
         return tmpMC;
      }
      
      public function attachEffectOverlay(id:*, options:Object = null) : MovieClip
      {
         var x:Number = 0;
         var y:Number = 0;
         var scaleX:Number = 1;
         var scaleY:Number = 1;
         var rotation:Number = 0;
         var force:Boolean = false;
         if(options != null)
         {
            x = options.x !== undefined ? Number(options.x) : x;
            y = options.y !== undefined ? Number(options.y) : y;
            scaleX = options.scaleX !== undefined ? Number(options.scaleX) : scaleX;
            scaleY = options.scaleY !== undefined ? Number(options.scaleY) : scaleY;
            rotation = options.rotation !== undefined ? Number(options.rotation) : 0;
            force = options.force !== undefined ? Boolean(options.force) : force;
         }
         if(Boolean(id is String && id.match(/^global_/)) && Boolean(!this.getQualitySettings().global_effects) && !force)
         {
            return new MovieClip();
         }
         var tmpMC:MovieClip = null;
         if(id != null)
         {
            tmpMC = this.attachUniqueMovieOverlay(id);
            if(tmpMC != null)
            {
               tmpMC.stop();
               Utils.recursiveMovieClipPlay(tmpMC,false);
               tmpMC.x = x;
               tmpMC.y = y;
               tmpMC.scaleX *= scaleX;
               tmpMC.scaleY *= scaleY;
               tmpMC.rotation = rotation;
            }
         }
         return tmpMC;
      }
      
      private function attachUniqueMovie(linkageID:*) : MovieClip
      {
         if(Boolean(linkageID is String) && Boolean(linkageID.match(/^global_/)) && !this.getQualitySettings().global_effects)
         {
            return new MovieClip();
         }
         var tmpMC:MovieClip = linkageID is Class ? new linkageID() : ResourceManager.getLibraryMC(linkageID);
         if(tmpMC != null)
         {
            tmpMC.stop();
            Utils.recursiveMovieClipPlay(tmpMC,false);
            this.STAGE.addChild(tmpMC);
            if(this.m_effectIndex >= this.EFFECT_LIMIT)
            {
               this.m_effectIndex = 0;
            }
            if(this.m_effectList[this.m_effectIndex] != null && Boolean(this.m_effectList[this.m_effectIndex].parent))
            {
               this.m_effectList[this.m_effectIndex].parent.removeChild(this.m_effectList[this.m_effectIndex]);
               this.m_effectList[this.m_effectIndex] = null;
            }
            this.m_effectList[this.m_effectIndex] = tmpMC;
            ++this.m_effectIndex;
         }
         return tmpMC;
      }
      
      private function attachUniqueMovieOverlay(linkageID:*) : MovieClip
      {
         if(Boolean(linkageID is String) && Boolean(linkageID.match(/^global_/)) && !this.getQualitySettings().global_effects)
         {
            return new MovieClip();
         }
         var tmpMC:MovieClip = linkageID is Class ? new linkageID() : ResourceManager.getLibraryMC(linkageID);
         if(tmpMC != null)
         {
            tmpMC.stop();
            Utils.recursiveMovieClipPlay(tmpMC,false);
            this.STAGEEFFECTS.addChild(tmpMC);
            if(this.m_effectOverlayIndex >= this.EFFECT_LIMIT)
            {
               this.m_effectOverlayIndex = 0;
            }
            if(this.m_effectOverlayList[this.m_effectOverlayIndex] != null && Boolean(this.m_effectOverlayList[this.m_effectOverlayIndex].parent))
            {
               this.m_effectOverlayList[this.m_effectOverlayIndex].parent.removeChild(this.m_effectOverlayList[this.m_effectOverlayIndex]);
               this.m_effectOverlayList[this.m_effectOverlayIndex] = null;
            }
            this.m_effectOverlayList[this.m_effectOverlayIndex] = tmpMC;
            ++this.m_effectOverlayIndex;
         }
         return tmpMC;
      }
      
      public function attachUniqueMovieHUD(linkageID:*) : MovieClip
      {
         if(Boolean(linkageID is String) && Boolean(linkageID.match(/^global_/)) && !this.getQualitySettings().global_effects)
         {
            return new MovieClip();
         }
         var tmpMC:MovieClip = linkageID is Class ? new linkageID() : ResourceManager.getLibraryMC(linkageID);
         if(tmpMC != null)
         {
            tmpMC.stop();
            Utils.recursiveMovieClipPlay(tmpMC,false);
            this.HUDFOREGROUND.addChild(tmpMC);
            if(this.m_effectHUDIndex >= this.EFFECT_LIMIT_SECONDARY)
            {
               this.m_effectHUDIndex = 0;
            }
            if(this.m_effectHUDList[this.m_effectHUDIndex] != null && Boolean(this.m_effectHUDList[this.m_effectHUDIndex].parent))
            {
               this.m_effectHUDList[this.m_effectHUDIndex].parent.removeChild(this.m_effectHUDList[this.m_effectHUDIndex]);
               this.m_effectHUDList[this.m_effectHUDIndex] = null;
            }
            this.m_effectHUDList[this.m_effectHUDIndex] = tmpMC;
            ++this.m_effectHUDIndex;
         }
         return tmpMC;
      }
      
      public function attachUniqueMovieHUDOverlay(linkageID:*) : MovieClip
      {
         if(Boolean(linkageID is String) && Boolean(linkageID.match(/^global_/)) && !this.getQualitySettings().global_effects)
         {
            return new MovieClip();
         }
         var tmpMC:MovieClip = linkageID is Class ? new linkageID() : ResourceManager.getLibraryMC(linkageID);
         if(tmpMC != null)
         {
            tmpMC.stop();
            Utils.recursiveMovieClipPlay(tmpMC,false);
            this.HUDOVERLAY.addChild(tmpMC);
            if(this.m_effectHUDOverlayIndex >= this.EFFECT_LIMIT_SECONDARY)
            {
               this.m_effectHUDOverlayIndex = 0;
            }
            if(this.m_effectHUDOverlayList[this.m_effectHUDOverlayIndex] != null && Boolean(this.m_effectHUDOverlayList[this.m_effectHUDOverlayIndex].parent))
            {
               this.m_effectHUDOverlayList[this.m_effectHUDOverlayIndex].parent.removeChild(this.m_effectHUDOverlayList[this.m_effectHUDOverlayIndex]);
               this.m_effectHUDOverlayList[this.m_effectHUDOverlayIndex] = null;
            }
            this.m_effectHUDOverlayList[this.m_effectHUDOverlayIndex] = tmpMC;
            ++this.m_effectHUDOverlayIndex;
         }
         return tmpMC;
      }
      
      public function attachUniqueMovieBG(linkageID:*) : MovieClip
      {
         if(Boolean(linkageID is String) && Boolean(linkageID.match(/^global_/)) && !this.getQualitySettings().global_effects)
         {
            return new MovieClip();
         }
         var tmpMC:MovieClip = linkageID is Class ? new linkageID() : ResourceManager.getLibraryMC(linkageID);
         if(tmpMC != null)
         {
            tmpMC.stop();
            Utils.recursiveMovieClipPlay(tmpMC,false);
            this.STAGEBACKGROUND.addChild(tmpMC);
            if(this.m_effectBGIndex >= this.EFFECT_LIMIT_SECONDARY)
            {
               this.m_effectBGIndex = 0;
            }
            if(this.m_effectBGList[this.m_effectBGIndex] != null && Boolean(this.m_effectBGList[this.m_effectBGIndex].parent))
            {
               this.m_effectBGList[this.m_effectBGIndex].parent.removeChild(this.m_effectBGList[this.m_effectBGIndex]);
               this.m_effectBGList[this.m_effectBGIndex] = null;
            }
            this.m_effectBGList[this.m_effectBGIndex] = tmpMC;
            ++this.m_effectBGIndex;
         }
         return tmpMC;
      }
      
      public function attachUniqueMovieWeather(linkageID:*) : MovieClip
      {
         if(Boolean(linkageID is String) && Boolean(linkageID.match(/^global_/)) && !this.getQualitySettings().global_effects)
         {
            return new MovieClip();
         }
         var tmpMC:MovieClip = linkageID is Class ? new linkageID() : ResourceManager.getLibraryMC(linkageID);
         if(tmpMC != null && this.WEATHER != null)
         {
            tmpMC.stop();
            Utils.recursiveMovieClipPlay(tmpMC,false);
            this.WEATHER.addChild(tmpMC);
            if(this.m_effectWeatherIndex >= this.EFFECT_LIMIT_SECONDARY)
            {
               this.m_effectWeatherIndex = 0;
            }
            if(this.m_effectWeatherList[this.m_effectWeatherIndex] != null && Boolean(this.m_effectWeatherList[this.m_effectWeatherIndex].parent))
            {
               this.m_effectWeatherList[this.m_effectWeatherIndex].parent.removeChild(this.m_effectWeatherList[this.m_effectWeatherIndex]);
               this.m_effectWeatherList[this.m_effectWeatherIndex] = null;
            }
            this.m_effectWeatherList[this.m_effectWeatherIndex] = tmpMC;
            ++this.m_effectWeatherIndex;
         }
         return tmpMC;
      }
      
      private function nextFrameAllEffects() : void
      {
         var i:int = 0;
         if(!this.m_fsCutscene)
         {
            i = 0;
            for(i = 0; i < this.m_effectList.length; i++)
            {
               if(Boolean(this.m_effectList[i]))
               {
                  Utils.advanceFrame(this.m_effectList[i]);
                  Utils.recursiveMovieClipPlay(this.m_effectList[i],true);
                  if(!this.m_effectList[i].parent)
                  {
                     this.m_effectList[i--] = null;
                  }
               }
            }
            for(i = 0; i < this.m_effectBGList.length; i++)
            {
               if(Boolean(this.m_effectBGList[i]))
               {
                  Utils.advanceFrame(this.m_effectBGList[i]);
                  Utils.recursiveMovieClipPlay(this.m_effectBGList[i],true);
                  if(!this.m_effectBGList[i].parent)
                  {
                     this.m_effectBGList[i--] = null;
                  }
               }
            }
            Utils.recursiveMovieClipPlay(this.STAGEEFFECTS,true);
            Utils.recursiveMovieClipPlay(this.WEATHER,true);
         }
         Utils.recursiveMovieClipPlay(this.HUDFOREGROUND,true);
         Utils.recursiveMovieClipPlay(this.HUDTEXT,true);
         Utils.recursiveMovieClipPlay(this.HUDOVERLAY,true);
      }
   }
}

