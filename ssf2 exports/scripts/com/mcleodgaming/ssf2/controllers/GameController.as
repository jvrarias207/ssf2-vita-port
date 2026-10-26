package com.mcleodgaming.ssf2.controllers
{
   import com.mcleodgaming.ssf2.Main;
   import com.mcleodgaming.ssf2.audio.*;
   import com.mcleodgaming.ssf2.engine.*;
   import com.mcleodgaming.ssf2.enums.Mode;
   import com.mcleodgaming.ssf2.enums.ModeFeatures;
   import com.mcleodgaming.ssf2.items.ItemsListData;
   import com.mcleodgaming.ssf2.menus.ConstantDebuggerMenu;
   import com.mcleodgaming.ssf2.menus.HudMenu;
   import com.mcleodgaming.ssf2.menus.Menu;
   import com.mcleodgaming.ssf2.net.MultiplayerManager;
   import com.mcleodgaming.ssf2.util.*;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.system.System;
   
   public class GameController
   {
      
      public static var stageData:StageData;
      
      public static var tmpStageData:StageData;
      
      public static var currentGame:Game;
      
      public static var onlineModeMatchSettings:Object;
      
      public static var tmpGame:Game;
      
      public static var weather:MovieClip;
      
      public static var cutscene:MovieClip;
      
      public static var tags:MovieClip;
      
      public static var hud:HudMenu;
      
      public static var constantDebugger:ConstantDebuggerMenu;
      
      public static var stage:MovieClip;
      
      public static var background:MovieClip;
      
      public static var stageMusic:String;
      
      public static var loopLoc:Number;
      
      public static var cameraParameters:VcamSettings;
      
      public static var isStarted:Boolean;
      
      private static var matchStarted:Boolean;
      
      private static var m_prepped:Boolean = false;
      
      init();
      
      public function GameController()
      {
         super();
      }
      
      public static function init() : void
      {
         weather = null;
         cutscene = null;
         tags = null;
         hud = null;
         constantDebugger = null;
         stage = null;
         background = null;
         stageMusic = null;
         loopLoc = 0;
         cameraParameters = null;
         matchStarted = false;
      }
      
      private static function getStatsNameForPlayer(id:int, playerSettings:Vector.<PlayerSetting>) : String
      {
         var i:int = 0;
         var statsName:String = playerSettings[id].character;
         if(!statsName)
         {
            for(i = id - 1; i >= 0; i--)
            {
               if(Boolean(playerSettings[i].character))
               {
                  statsName = playerSettings[i].character === "random" ? Main.RandCharList[i].StatsName : playerSettings[i].character;
                  break;
               }
            }
         }
         else if(statsName === "random")
         {
            statsName = Main.RandCharList[id].StatsName;
         }
         return statsName;
      }
      
      private static function setupRandomCostumes() : void
      {
         var costumeNum:int = 0;
         var randCostumeArr:Array = null;
         var found:Boolean = false;
         var i:int = 0;
         var j:int = 0;
         var statsName:String = null;
         var altStatsName:String = null;
         for(var k:int = 0; k < currentGame.PlayerSettings.length; k++)
         {
            if(!currentGame.SuddenDeath && !currentGame.LevelData.teams && (currentGame.PlayerSettings[k].character == "random" || currentGame.PlayerSettings[k].isRandom) || currentGame.GameMode == Mode.TRAINING && !currentGame.PlayerSettings[k].character)
            {
               costumeNum = 0;
               randCostumeArr = new Array();
               found = false;
               i = 0;
               j = 0;
               statsName = GameController.getStatsNameForPlayer(k,currentGame.PlayerSettings);
               for(i = 0; i < currentGame.PlayerSettings.length; i++)
               {
                  if(Boolean(currentGame.PlayerSettings[i].exist && currentGame.PlayerSettings[i].character) && Boolean(currentGame.PlayerSettings[i].costume == -1) && i != k)
                  {
                     found = true;
                  }
               }
               if(!found)
               {
                  randCostumeArr.push(-1);
               }
               while(costumeNum < ResourceManager.getCostumeCount(statsName) - 2)
               {
                  found = false;
                  for(i = 0; i < currentGame.PlayerSettings.length; i++)
                  {
                     altStatsName = GameController.getStatsNameForPlayer(i,currentGame.PlayerSettings);
                     if(Boolean(currentGame.PlayerSettings[i].exist && altStatsName) && Boolean(currentGame.PlayerSettings[i].costume == costumeNum) && i != k)
                     {
                        found = true;
                     }
                  }
                  if(!found)
                  {
                     randCostumeArr.push(costumeNum);
                  }
                  costumeNum++;
               }
               currentGame.PlayerSettings[k].costume = randCostumeArr[Utils.randomInteger(0,randCostumeArr.length - 1)];
            }
            else
            {
               Utils.random();
            }
         }
      }
      
      public static function startMatch(game:Game = null) : void
      {
         var currStage:Resource = null;
         var hasMusic:Boolean = false;
         var musicID:String = null;
         var musicResource:Resource = null;
         var id3:* = undefined;
         if(Boolean(game))
         {
            GameController.currentGame = game;
         }
         if(!matchStarted)
         {
            if(ModeFeatures.hasFeature(ModeFeatures.MULTIPLAYER_MANAGER,GameController.currentGame.GameMode) && !GameController.currentGame.SuddenDeath)
            {
               if(MultiplayerManager.RoomData.matchSettings.gameMode === Mode.ONLINE_ARENA)
               {
                  GameController.currentGame.CustomModeObj.PreviousMenu = MultiplayerManager.IsHost ? MenuController.arenaCharacterSelectMenu : MenuController.onlineCharacterMenu;
               }
            }
            Main.Root.visible = false;
            matchStarted = true;
            weather = new MovieClip();
            cutscene = new MovieClip();
            tags = new MovieClip();
            background = new MovieClip();
            hud = new HudMenu();
            constantDebugger = new ConstantDebuggerMenu();
            if(Main.DEBUG)
            {
               hud.Container.addChild(constantDebugger.Container);
            }
            stage = ResourceManager.getLibraryMC(GameController.currentGame.LevelData.stage == "xpstage" ? "xpstage" : "stage_" + GameController.currentGame.LevelData.stage);
            stage.name = "stageMC";
            Main.Root.addChild(background);
            Main.Root.addChild(stage);
            Main.Root.addChild(tags);
            Main.Root.addChild(weather);
            Main.Root.addChild(cutscene);
            Main.Root.addChild(hud.Container);
            currStage = ResourceManager.getResourceByID(GameController.currentGame.LevelData.stage);
            hasMusic = Boolean(GameController.currentGame.LevelData.musicOverride) ? true : Boolean(currStage.getProp("music")) && Boolean(currStage.getProp("music").length);
            musicID = hasMusic ? GameController.currentGame.LevelData.musicOverride || currStage.getProp("music")[Main.RandMusicIndex].id : null;
            musicResource = Boolean(musicID) ? ResourceManager.getResourceByID(musicID) : null;
            if(Boolean(hasMusic) && Boolean(musicResource) && Boolean(musicResource.getProp("id3")))
            {
               id3 = musicResource.getProp("id3");
               if(Boolean(id3.songName))
               {
                  hud.displayMusicInfo(id3.songName);
               }
            }
            stageMusic = null;
            loopLoc = 0;
            if(Boolean(musicResource))
            {
               stageMusic = musicResource.getProp("music") || null;
               loopLoc = Number(musicResource.getProp("musicLoop")) || 0;
            }
            cameraParameters = new VcamSettings(currStage.getProp("camera"));
            prepOtherHitBoxStuff();
            Main.Root.stage.addEventListener(Event.ENTER_FRAME,actuallyStartMatch);
         }
      }
      
      public static function prepOtherHitBoxStuff() : void
      {
         if(m_prepped)
         {
            return;
         }
         m_prepped = true;
         var i:int = 0;
         var j:int = 0;
         var tmpMC:MovieClip = null;
         var m_managerList:Vector.<String> = new Vector.<String>();
         for(i = 0; i < ItemsListData.DATA.length; i++)
         {
            m_managerList.push(ItemsListData.DATA[i].linkage_id);
         }
         for(j = 0; j < m_managerList.length; j++)
         {
            if(!Boolean(HitBoxManager.HitBoxManageList[m_managerList[j]]))
            {
               tmpMC = ResourceManager.getLibraryMC(m_managerList[j]);
               if(Boolean(tmpMC))
               {
                  for(i = 0; i < tmpMC.totalFrames; i++)
                  {
                     tmpMC.gotoAndStop(i + 1);
                     if(Boolean(tmpMC.stance))
                     {
                        Utils.removeActionScript(tmpMC.stance);
                        HitBoxAnimation.createHitBoxAnimation(m_managerList[j] + "_" + tmpMC.currentLabel,tmpMC.stance,tmpMC);
                     }
                  }
                  tmpMC = null;
               }
            }
         }
      }
      
      private static function actuallyStartMatch(e:Event) : void
      {
         Main.Root.stage.removeEventListener(Event.ENTER_FRAME,actuallyStartMatch);
         SaveData.Unlocks.ghostNessSDs = 0;
         var stageAPI:Class = null;
         var currStage:Resource = ResourceManager.getResourceByID(GameController.currentGame.LevelData.stage);
         if(Boolean(currStage))
         {
            stageAPI = currStage.getProp("stage") || currStage.MetaData.BASE_CLASSES.SSF2Stage || null;
         }
         var i:int = 0;
         Utils.setRandSeed(currentGame.LevelData.randSeed);
         Utils.shuffleRandom();
         Main.prepRandomCharacters(currentGame.PlayerSettings.length);
         if(GameController.currentGame.GameMode === Mode.ONLINE_WAITING_ROOM && GameController.currentGame.PlayerSettings[0].character == "random")
         {
            Main.RandCharList[0] = Main.RandCharList[MultiplayerManager.PlayerID - 1];
         }
         GameController.setupRandomCostumes();
         if(ModeFeatures.hasFeature(ModeFeatures.MULTIPLAYER_MANAGER,GameController.currentGame.GameMode))
         {
            GameController.currentGame.fixDuplicateCostumes();
         }
         var controllers:Vector.<Controller> = ModeFeatures.hasFeature(ModeFeatures.MULTIPLAYER_MANAGER,GameController.currentGame.GameMode) ? MultiplayerManager.Controllers : SaveData.Controllers;
         GameController.stageData = new StageData(controllers,Main.Root,stageAPI,stage,hud,cameraParameters,GameController.currentGame,SoundQueue.instance,stageMusic,loopLoc);
         constantDebugger.makeEvents();
         GameController.stageData.startGame();
      }
      
      public static function endMatch() : void
      {
         if(matchStarted)
         {
            GameController.stageData.CamRef.die();
            weather.parent.removeChild(weather);
            cutscene.parent.removeChild(cutscene);
            tags.parent.removeChild(tags);
            stage.parent.removeChild(stage);
            background.parent.removeChild(background);
            hud.removeSelf();
            constantDebugger.killEvents();
            init();
            trace("Game graphics and stage data disposed");
         }
      }
      
      public static function destroyStageData() : void
      {
         if(Boolean(GameController.stageData))
         {
            GameController.stageData.dispose();
         }
         GameController.stage = null;
         GameController.stageData = null;
         GameController.tmpStageData = null;
         GameController.tmpGame = null;
         Main.clearRandomCharacterPrep();
         SoundQueue.instance.setLoopFunction(SoundQueue.instance.loopMusic);
         System.gc();
      }
   }
}

