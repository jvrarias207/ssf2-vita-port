package com.mcleodgaming.ssf2.net
{
   import com.mcleodgaming.mgn.events.MGNEvent;
   import com.mcleodgaming.mgn.events.MGNEventManager;
   import com.mcleodgaming.mgn.net.MGNClient;
   import com.mcleodgaming.mgn.net.PlayerConnectionInfo;
   import com.mcleodgaming.mgn.net.PlayerDataSyncStream;
   import com.mcleodgaming.ssf2.Main;
   import com.mcleodgaming.ssf2.audio.*;
   import com.mcleodgaming.ssf2.controllers.Game;
   import com.mcleodgaming.ssf2.controllers.GameController;
   import com.mcleodgaming.ssf2.controllers.MenuController;
   import com.mcleodgaming.ssf2.controllers.PlayerSetting;
   import com.mcleodgaming.ssf2.engine.*;
   import com.mcleodgaming.ssf2.enums.Mode;
   import com.mcleodgaming.ssf2.menus.ArenaModeMenu;
   import com.mcleodgaming.ssf2.modes.ArenaMode;
   import com.mcleodgaming.ssf2.util.*;
   import flash.display.MovieClip;
   import flash.net.*;
   import flash.text.TextField;
   import flash.utils.setTimeout;
   
   public class MultiplayerManager
   {
      
      private static var m_controllers:Vector.<Controller>;
      
      private static var m_notifier:MovieClip;
      
      private static var m_notifierText:TextField;
      
      private static var m_permanentBox:Boolean;
      
      private static var m_frameRateTimer:FrameTimer;
      
      private static var m_lastUpdate:Date;
      
      private static var m_pingCount:Number;
      
      private static var m_pingTotal:Number;
      
      private static var m_averagePing:Number;
      
      private static var m_frameRateIncremented:Boolean;
      
      private static var m_randomSeed:Number;
      
      private static var m_matchReady:Boolean;
      
      private static var m_matchEnded:Boolean;
      
      private static var m_roomData:Object;
      
      private static var m_promotionTimer:FrameTimer;
      
      private static var m_readyToLock:Boolean;
      
      private static var m_game:Game;
      
      private static var m_onlineInterface:MGNClient;
      
      private static const FPS_THRESHOLD:int = 5;
      
      private static const FRAME_RATE_ADJUSTER:Boolean = false;
      
      public static var NORMAL_FPS:int = 30;
      
      public static var MAX_FPS:int = 35;
      
      public static var INPUT_BUFFER:int = 3;
      
      public static var joinRequestPlayerInfoQueue:Vector.<PlayerConnectionInfo> = new Vector.<PlayerConnectionInfo>();
      
      public static var ROOM_CAPACITY:int = 4;
      
      public function MultiplayerManager()
      {
         super();
      }
      
      public static function init() : void
      {
         MGNEventManager.dispatcher.addEventListener(MGNEvent.NOTIFY,handlemgn_NOTIFY);
         MGNEventManager.dispatcher.addEventListener(MGNEvent.PLAYER_JOINED,handlemgn_PLAYER_JOINED);
         MGNEventManager.dispatcher.addEventListener(MGNEvent.PLAYER_LEFT,handlemgn_PLAYER_LEFT);
         MGNEventManager.dispatcher.addEventListener(MGNEvent.DATA,handlemgn_DATA);
         MGNEventManager.dispatcher.addEventListener(MGNEvent.MATCH_READY_STATUS,onMatchReadyStatus);
         MGNEventManager.dispatcher.addEventListener(MGNEvent.MATCH_START,handlemgn_MATCH_START);
         MGNEventManager.dispatcher.addEventListener(MGNEvent.MATCH_FINISHED,handlemgn_MATCH_FINISHED);
         MGNEventManager.dispatcher.addEventListener(MGNEvent.MATCH_END,handlemgn_MATCH_END);
         MGNEventManager.dispatcher.addEventListener(MGNEvent.DISCONNECT,handlemgn_DISCONNECT);
         MGNEventManager.dispatcher.addEventListener(MGNEvent.ROOM_JOIN_REQUEST,onRoomJoinRequestReceived);
         MGNEventManager.dispatcher.addEventListener(MGNEvent.ROOM_DATA,roomDataSet);
         MGNEventManager.dispatcher.addEventListener(MGNEvent.ERROR_ROOM_DATA,roomDataSetError);
         MGNEventManager.dispatcher.addEventListener(MGNEvent.LOCK_ROOM,onRoomLocked);
         MGNEventManager.dispatcher.addEventListener(MGNEvent.ERROR_LOCK_ROOM,onRoomLockedError);
         MGNEventManager.dispatcher.addEventListener(MGNEvent.UNLOCK_ROOM,onRoomUnlocked);
         MGNEventManager.dispatcher.addEventListener(MGNEvent.ERROR_UNLOCK_ROOM,onRoomUnlockedError);
         MGNEventManager.dispatcher.addEventListener(MGNEvent.ERROR_PING,onPingError);
         MGNEventManager.dispatcher.addEventListener(MGNEvent.LEAVE_ROOM,onLeaveRoom);
         initializeMultiplayerManager();
         trace("MultiplayerManager initialized");
      }
      
      private static function initializeMultiplayerManager() : void
      {
         m_matchReady = false;
         m_matchEnded = false;
         m_roomData = null;
         m_permanentBox = false;
         m_controllers = new Vector.<Controller>();
         for(var i:int = 0; i < Main.MAXPLAYERS; i++)
         {
            m_controllers.push(new Controller(i + 1,SaveData.Controllers[i].getControls()));
         }
         m_notifier = null;
         m_notifierText = null;
         m_onlineInterface = new MGNClient(Main.MAXPLAYERS);
         m_frameRateTimer = new FrameTimer(30);
         m_promotionTimer = new FrameTimer(30 * 5);
         m_lastUpdate = null;
         m_pingCount = 0;
         m_pingTotal = 0;
         m_averagePing = 0;
         m_frameRateIncremented = true;
         m_randomSeed = 0;
         m_readyToLock = false;
         resetMasterFrame();
      }
      
      public static function get CurrentHostID() : String
      {
         return m_onlineInterface.CurrentHostID;
      }
      
      public static function get Username() : String
      {
         return m_onlineInterface.Username;
      }
      
      public static function get SocketID() : String
      {
         return m_onlineInterface.SocketID;
      }
      
      public static function get RoomList() : Array
      {
         return m_onlineInterface.RoomList;
      }
      
      public static function get MatchReady() : Boolean
      {
         return m_matchReady;
      }
      
      public static function get MatchEnded() : Boolean
      {
         return m_matchEnded;
      }
      
      public static function get RoomKey() : String
      {
         return m_onlineInterface.RoomKey;
      }
      
      public static function get RoomData() : Object
      {
         return m_roomData;
      }
      
      public static function get GameInstance() : Game
      {
         return m_game;
      }
      
      public static function get Controllers() : Vector.<Controller>
      {
         return m_controllers;
      }
      
      public static function get Ping() : Number
      {
         return Math.round(m_averagePing);
      }
      
      public static function get Connected() : Boolean
      {
         return m_onlineInterface.Connected;
      }
      
      public static function get Active() : Boolean
      {
         return m_onlineInterface.Active;
      }
      
      public static function set Active(value:Boolean) : void
      {
         m_onlineInterface.Active = value;
      }
      
      public static function get MasterFrame() : int
      {
         return m_onlineInterface.MasterFrame;
      }
      
      public static function set MasterFrame(value:int) : void
      {
         m_onlineInterface.MasterFrame = value;
      }
      
      public static function get PlayerID() : int
      {
         return m_onlineInterface.PlayerID;
      }
      
      public static function get RoomLocked() : Boolean
      {
         return m_onlineInterface.RoomLocked;
      }
      
      public static function get IsHost() : Boolean
      {
         return m_onlineInterface.IsHost;
      }
      
      public static function get Protocol() : String
      {
         return m_onlineInterface.Protocol;
      }
      
      public static function set Protocol(value:String) : void
      {
         m_onlineInterface.Protocol = value;
      }
      
      public static function get DowngradedConnection() : Boolean
      {
         return m_onlineInterface.DowngradedConnection;
      }
      
      public static function downgradeP2P() : void
      {
         m_onlineInterface.downgradeP2P();
      }
      
      public static function get PromotionTimer() : FrameTimer
      {
         return m_promotionTimer;
      }
      
      public static function get Players() : Vector.<PlayerConnectionInfo>
      {
         return m_onlineInterface.Players;
      }
      
      public static function get PlayerSyncStream() : PlayerDataSyncStream
      {
         return m_onlineInterface.PlayerSyncStream;
      }
      
      public static function reset() : void
      {
         m_roomData = null;
         m_matchReady = false;
         m_matchEnded = false;
         joinRequestPlayerInfoQueue.splice(0,joinRequestPlayerInfoQueue.length);
         m_onlineInterface.disconnect();
         initializeMultiplayerManager();
      }
      
      public static function resetMasterFrame() : void
      {
         m_onlineInterface.resetMasterFrame();
         for(var i:int = 0; i < m_onlineInterface.Players.length; i++)
         {
            m_controllers[i].flushControlBits();
         }
      }
      
      public static function restoreOriginalGameSettings(game:Game) : void
      {
         game.importSettings(GameController.onlineModeMatchSettings);
         game.GameMode = GameController.onlineModeMatchSettings.gameMode;
         var wasRandom:Boolean = game.PlayerSettings[0].isRandom;
         for(var i:int = 0; i < game.PlayerSettings.length; i++)
         {
            game.PlayerSettings[i].isRandom = false;
         }
         if(wasRandom)
         {
            game.PlayerSettings[0].character = "random";
         }
      }
      
      public static function resetSeed() : void
      {
         m_randomSeed = Utils.random();
      }
      
      public static function setSeed(seed:Number) : void
      {
         m_randomSeed = seed;
      }
      
      public static function notify(msg:String, permanentBox:Boolean = false) : void
      {
         if(m_notifier != null)
         {
            if(m_notifier.currentFrame === 1)
            {
               m_notifierText.text = "";
            }
            m_notifierText.appendText(" > " + msg + "\n");
            m_notifierText.scrollV = m_notifierText.numLines;
            m_notifier.gotoAndPlay("showmsg");
            if(m_permanentBox || permanentBox)
            {
               m_permanentBox = true;
               m_notifier.stop();
            }
         }
         trace(msg);
      }
      
      public static function makeNotifier() : void
      {
         if(m_notifier == null)
         {
            m_notifier = ResourceManager.getLibraryMC("onlineplay_notify");
            m_notifierText = m_notifier.txt_mc.txtbox;
            Main.Root.stage.addChild(m_notifier);
            m_notifier.x = Main.Width / 2;
            m_notifier.y = Main.Height;
         }
      }
      
      public static function connect(userName:String, password:String, version:String) : void
      {
         m_onlineInterface.connect(userName,password,version);
         MultiplayerManager.makeNotifier();
      }
      
      public static function disconnect() : void
      {
         m_onlineInterface.disconnect();
      }
      
      public static function ping() : void
      {
         m_onlineInterface.ping();
      }
      
      public static function createRoom(roomName:String, roomPassword:String, roomCapacity:int, roomData:Object) : void
      {
         ROOM_CAPACITY = roomCapacity;
         m_onlineInterface.createRoom(roomName,roomPassword,roomCapacity,roomData);
      }
      
      public static function requestToJoinRoom(roomKey:String, roomPassword:String) : void
      {
         m_onlineInterface.requestToJoinRoom(roomKey,roomPassword);
      }
      
      public static function createJoinRoom(roomName:String, roomPassword:String, roomCapacity:int, roomData:Object) : void
      {
         ROOM_CAPACITY = roomCapacity;
         m_onlineInterface.createJoinRoom(roomName,roomPassword,roomCapacity,roomData);
      }
      
      public static function lockRoom() : void
      {
         m_onlineInterface.lockRoom();
      }
      
      public static function unlockRoom() : void
      {
         m_onlineInterface.unlockRoom();
      }
      
      public static function leaveRoom() : void
      {
         m_onlineInterface.leaveRoom();
      }
      
      private static function roomDataSet(e:MGNEvent) : void
      {
         trace("Room data updated");
      }
      
      private static function roomDataSetError(e:MGNEvent) : void
      {
         trace("Error, problem updating room data");
      }
      
      private static function onRoomLocked(e:MGNEvent) : void
      {
         trace("Room locked successfully.");
         m_readyToLock = false;
      }
      
      private static function onRoomLockedError(e:MGNEvent) : void
      {
         MultiplayerManager.notify("There was a problem locking the room.");
         m_readyToLock = false;
      }
      
      private static function onRoomUnlocked(e:MGNEvent) : void
      {
         trace("Room unlocked successfully.");
         m_readyToLock = false;
      }
      
      private static function onRoomUnlockedError(e:MGNEvent) : void
      {
         MultiplayerManager.notify("There was a problem unlocking the room.");
         m_readyToLock = false;
      }
      
      private static function onPingError(e:MGNEvent) : void
      {
         reset();
         MenuController.removeAllMenus();
         MenuController.onlineMenu.show();
         SoundQueue.instance.playMusic("menumusic",0);
      }
      
      private static function onLeaveRoom(e:MGNEvent) : void
      {
         m_roomData = null;
         m_matchReady = false;
         m_matchEnded = false;
      }
      
      public static function refreshRoomList(friendsOnly:Boolean = false) : void
      {
         m_onlineInterface.refreshRoomList(friendsOnly);
      }
      
      public static function sendMyDataFrame(frame:int, data:Object) : void
      {
         m_onlineInterface.sendMyDataFrame(frame,data);
      }
      
      public static function sendMatchReadySignal(data:Object) : void
      {
         m_onlineInterface.sendMatchReadySignal(data);
      }
      
      public static function sendMatchFinishedSignal(data:Object) : void
      {
         m_onlineInterface.sendMatchFinishedSignal(data);
      }
      
      public static function sendMatchEndSignal() : void
      {
         m_onlineInterface.sendMatchEndSignal();
      }
      
      public static function sendMatchSettings(data:Object) : void
      {
         m_onlineInterface.sendMatchSettings(data);
      }
      
      public static function onRoomJoinRequestReceived(e:MGNEvent) : void
      {
         MultiplayerManager.handleRoomJoinRequest(e.data.playerConnectionInfo);
      }
      
      public static function handleRoomJoinRequest(playerInfo:PlayerConnectionInfo) : void
      {
         var username:String = null;
         if(RoomLocked || m_onlineInterface.Players.length >= MultiplayerManager.ROOM_CAPACITY)
         {
            m_onlineInterface.declineRoomJoinRequest(playerInfo);
         }
         else if(MenuController.onlinePromptMenu.isOnscreen())
         {
            MultiplayerManager.joinRequestPlayerInfoQueue.push(playerInfo);
         }
         else
         {
            SoundQueue.instance.playSoundEffect("menu_unlock");
            username = playerInfo.is_dev ? "+ " + playerInfo.username : playerInfo.username;
            MenuController.onlinePromptMenu.message = username + "\n" + "wants to join the match.\n\n" + "Accept?";
            MenuController.onlinePromptMenu.data = playerInfo;
            MenuController.onlinePromptMenu.onAccept = acceptRoomJoinRequest;
            MenuController.onlinePromptMenu.onDismiss = declineRoomJoinRequest;
            MenuController.onlinePromptMenu.show();
         }
      }
      
      public static function acceptRoomJoinRequest() : void
      {
         m_onlineInterface.acceptRoomJoinRequest(MenuController.onlinePromptMenu.data as PlayerConnectionInfo);
         MenuController.onlinePromptMenu.removeSelf();
         if(MultiplayerManager.joinRequestPlayerInfoQueue.length > 0)
         {
            setTimeout(function():void
            {
               MultiplayerManager.handleRoomJoinRequest(MultiplayerManager.joinRequestPlayerInfoQueue.splice(0,1)[0]);
            },2000);
         }
      }
      
      public static function declineRoomJoinRequest() : void
      {
         m_onlineInterface.declineRoomJoinRequest(MenuController.onlinePromptMenu.data as PlayerConnectionInfo);
         MenuController.onlinePromptMenu.removeSelf();
         if(MultiplayerManager.joinRequestPlayerInfoQueue.length > 0)
         {
            setTimeout(function():void
            {
               MultiplayerManager.handleRoomJoinRequest(MultiplayerManager.joinRequestPlayerInfoQueue.splice(0,1)[0]);
            },2000);
         }
      }
      
      private static function updateControls() : void
      {
         var updated:Boolean = false;
         var i:int = 0;
         var currentUpdate:Date = null;
         var updatedPing:Number = NaN;
         var averagePing:Number = NaN;
         if(m_onlineInterface.Active && m_onlineInterface.Connected)
         {
            updated = false;
            while(m_onlineInterface.ControlBits[0].length > 0)
            {
               updated = true;
               for(i = 0; i < m_onlineInterface.Players.length; i++)
               {
                  m_controllers[i].queueControlBits(m_onlineInterface.ControlBits[i][0]);
                  m_onlineInterface.ControlBits[i].splice(0,1);
               }
            }
            m_frameRateTimer.tick();
            m_promotionTimer.tick();
            if(updated)
            {
               if(MultiplayerManager.INPUT_BUFFER === 0)
               {
                  if(MultiplayerManager.IsHost)
                  {
                     if(Main.Root.stage.frameRate != 60)
                     {
                        Main.Root.stage.frameRate = 60;
                     }
                  }
                  else if(Main.Root.stage.frameRate != 60)
                  {
                     Main.Root.stage.frameRate = 60;
                  }
               }
               if(!m_lastUpdate)
               {
                  m_lastUpdate = new Date();
                  m_averagePing = 1000 / MultiplayerManager.NORMAL_FPS;
                  m_pingTotal = m_averagePing;
                  m_pingCount = 1;
               }
               else
               {
                  currentUpdate = new Date();
                  updatedPing = currentUpdate.time - m_lastUpdate.time;
                  m_lastUpdate.setTime(currentUpdate.getTime());
                  ++m_pingCount;
                  m_pingTotal += updatedPing;
                  if(m_frameRateTimer.IsComplete)
                  {
                     m_frameRateTimer.reset();
                     averagePing = m_pingTotal / m_pingCount;
                     if(MultiplayerManager.FRAME_RATE_ADJUSTER)
                     {
                        if(averagePing > 1000 / MultiplayerManager.NORMAL_FPS)
                        {
                           if(averagePing < 1000 / (MultiplayerManager.NORMAL_FPS + MultiplayerManager.FPS_THRESHOLD) && Main.Root.stage.frameRate > MultiplayerManager.NORMAL_FPS)
                           {
                              m_frameRateIncremented = false;
                              --Main.Root.stage.frameRate;
                           }
                           else if(averagePing < m_averagePing + 2)
                           {
                              if(m_frameRateIncremented && Main.Root.stage.frameRate < MultiplayerManager.MAX_FPS)
                              {
                                 ++Main.Root.stage.frameRate;
                              }
                              else if(!m_frameRateIncremented && Main.Root.stage.frameRate > MultiplayerManager.NORMAL_FPS)
                              {
                                 --Main.Root.stage.frameRate;
                              }
                           }
                           else
                           {
                              m_frameRateIncremented = !m_frameRateIncremented;
                              if(m_frameRateIncremented && Main.Root.stage.frameRate < MultiplayerManager.MAX_FPS)
                              {
                                 ++Main.Root.stage.frameRate;
                              }
                              else if(!m_frameRateIncremented && Main.Root.stage.frameRate > MultiplayerManager.NORMAL_FPS)
                              {
                                 --Main.Root.stage.frameRate;
                              }
                           }
                        }
                     }
                     if(Boolean(Main.DEBUG) && Boolean(MenuController.debugConsole) && MenuController.debugConsole.PingCapture)
                     {
                        MultiplayerManager.notify(Ping + " ms (" + m_onlineInterface.getFrameDelay() + ")");
                     }
                     m_averagePing = averagePing;
                     m_pingCount = 0;
                     m_pingTotal = 0;
                  }
               }
            }
         }
      }
      
      private static function handlemgn_PLAYER_JOINED(e:MGNEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_unlock");
         if(Boolean(e.data.is_dev))
         {
            MultiplayerManager.notify("+ " + e.data.username + " has joined the match.");
         }
         else
         {
            MultiplayerManager.notify(e.data.username + " has joined the match.");
         }
      }
      
      private static function handlemgn_PLAYER_LEFT(e:MGNEvent) : void
      {
         if(Boolean(e.data.is_dev))
         {
            MultiplayerManager.notify("+ " + e.data.username + " has disconnected.");
         }
         else
         {
            MultiplayerManager.notify(e.data.username + " has disconnected.");
         }
         m_matchReady = false;
         if(Boolean(e.data.host))
         {
            MultiplayerManager.leaveRoom();
         }
         else if(MultiplayerManager.RoomLocked && m_onlineInterface.IsHost)
         {
            MultiplayerManager.unlockRoom();
         }
      }
      
      private static function handlemgn_NOTIFY(e:MGNEvent) : void
      {
         MultiplayerManager.notify(e.data.message);
      }
      
      private static function handlemgn_DATA(e:MGNEvent) : void
      {
      }
      
      private static function onMatchReadyStatus(e:MGNEvent) : void
      {
      }
      
      private static function handlemgn_MATCH_START(e:MGNEvent) : void
      {
         var lastTeam:int = 0;
         var foundTeams:Array = null;
         var numTeams:int = 0;
         var possibleTeams:Array = null;
         m_matchEnded = false;
         if(Boolean(GameController.currentGame) && GameController.currentGame.SuddenDeath)
         {
            m_matchReady = true;
            return;
         }
         var i:int = 0;
         var j:int = 0;
         var k:int = 0;
         m_roomData = {};
         m_roomData.matchSettings = e.data.room_data.matchSettings;
         m_roomData.matchSettings.playerSettings = [];
         var playerSettings:Array = m_roomData.matchSettings.playerSettings;
         MultiplayerManager.INPUT_BUFFER = m_roomData.matchSettings.levelData.inputBuffer;
         if(MultiplayerManager.INPUT_BUFFER === 0)
         {
            MultiplayerManager.notify("Automated input buffer enabled.");
         }
         m_onlineInterface.PlayerID = 0;
         var playerData:Array = e.data.player_data;
         for(i = 0; i < playerData.length; i++)
         {
            playerSettings.push(playerData[i].data.playerSettings);
            if(playerData[i].data.playerSettings.socket_id === m_onlineInterface.SocketID)
            {
               m_onlineInterface.PlayerID = i + 1;
            }
         }
         if(Boolean(m_roomData.matchSettings.levelData.unlocks.alternate_tracks))
         {
            ResourceManager.FORCE_ENABLE_ALT_TRACKS = true;
         }
         Utils.setRandSeed(m_roomData.matchSettings.levelData.randSeed);
         Utils.shuffleRandom();
         Main.prepRandomCharacters(playerSettings.length);
         ResourceManager.queueResources([m_roomData.matchSettings.levelData.stage]);
         if(Boolean(m_roomData.matchSettings.levelData.teams))
         {
            lastTeam = -1;
            foundTeams = new Array();
            numTeams = 0;
            possibleTeams = m_roomData.matchSettings.gameMode === Mode.ONLINE_ARENA ? [1,3] : [1,2,3];
            for(i = 0; i < playerSettings.length; i++)
            {
               if(possibleTeams.indexOf(playerSettings[i].team) < 0)
               {
                  if(lastTeam < 0)
                  {
                     playerSettings[i].team = 1;
                     lastTeam = 1;
                     foundTeams[lastTeam] = true;
                     numTeams++;
                  }
                  else
                  {
                     playerSettings[i].team = lastTeam;
                     if(!foundTeams[lastTeam])
                     {
                        numTeams++;
                     }
                     foundTeams[lastTeam] = true;
                  }
               }
               else
               {
                  if(!foundTeams[playerSettings[i].team])
                  {
                     numTeams++;
                  }
                  lastTeam = int(playerSettings[i].team);
                  foundTeams[lastTeam] = true;
               }
            }
            if(numTeams <= 1)
            {
               for(i = 0; i < playerSettings.length; i++)
               {
                  if(possibleTeams.indexOf(playerSettings[i].team) >= 0)
                  {
                     possibleTeams.splice(possibleTeams.indexOf(playerSettings[i].team),1);
                  }
                  if(i == playerSettings.length - 1)
                  {
                     playerSettings[i].team = possibleTeams[0];
                  }
               }
            }
         }
         for(i = 0; i < playerSettings.length; i++)
         {
            playerSettings[i].lives = m_roomData.matchSettings.levelData.lives;
            playerSettings[i].damageRatio = m_roomData.matchSettings.levelData.damageRatio;
            playerSettings[i].finalSmashMeter = m_roomData.matchSettings.levelData.finalSmashMeter;
            playerSettings[i].startDamage = m_roomData.matchSettings.levelData.startDamage;
            if(playerSettings[i].character != null && playerSettings[i].character != "xp")
            {
               ResourceManager.queueResources([playerSettings[i].character == "random" ? Main.RandCharList[i].StatsName : playerSettings[i].character]);
            }
         }
         MultiplayerManager.m_game = new Game();
         MultiplayerManager.GameInstance.GameMode = Mode.ONLINE;
         MultiplayerManager.GameInstance.importSettings(MultiplayerManager.RoomData.matchSettings);
         if(m_roomData.matchSettings.gameMode === Mode.ONLINE_ARENA)
         {
            MultiplayerManager.GameInstance.GameMode = Mode.ONLINE_ARENA;
            MultiplayerManager.GameInstance.CustomModeObj = new ArenaMode(MultiplayerManager.GameInstance,{"arenaModeID":m_roomData.matchSettings.arenaModeID},{"classAPI":ResourceManager.getResourceByID("arena_mode").getProp("mode")});
            MultiplayerManager.m_game = MultiplayerManager.GameInstance.CustomModeObj.GameInstance;
            ResourceManager.queueResources([MultiplayerManager.GameInstance.LevelData.stage]);
         }
         if(Boolean(m_roomData.matchSettings.levelData.musicOverride))
         {
            ResourceManager.queueResources([m_roomData.matchSettings.levelData.musicOverride]);
         }
         ResourceManager.load({"oncomplete":onMatchReady});
      }
      
      private static function onMatchReady() : void
      {
         m_matchReady = true;
      }
      
      private static function handlemgn_MATCH_END(e:MGNEvent) : void
      {
         m_matchEnded = true;
      }
      
      private static function handlemgn_DISCONNECT(e:MGNEvent) : void
      {
         reset();
      }
      
      private static function handlemgn_MATCH_FINISHED(e:MGNEvent) : void
      {
         m_matchReady = false;
         trace("Match end signal received from other player.");
      }
      
      public static function toWaitingRoom(game:Game, callback:Function) : void
      {
         game.LevelData.randSeed = Math.round(Math.random() * 1000000 + 1);
         game.PlayerSettings[0].socket_id = m_onlineInterface.SocketID;
         GameController.onlineModeMatchSettings = game.exportSettings();
         GameController.onlineModeMatchSettings.gameMode = game.GameMode;
         GameController.onlineModeMatchSettings.arenaModeID = ArenaModeMenu.SELECTED_ARENA_MODE;
         game.GameMode = Mode.ONLINE_WAITING_ROOM;
         game.LevelData.stage = "waitingroom";
         game.LevelData.usingLives = false;
         game.LevelData.usingTime = false;
         game.LevelData.usingStamina = false;
         game.LevelData.teams = false;
         game.LevelData.showEntrances = false;
         game.PlayerSettings.push(new PlayerSetting());
         game.PlayerSettings[1].exist = true;
         game.PlayerSettings[1].character = "sandbag";
         game.PlayerSettings[0].team = -1;
         game.PlayerSettings[1].team = -1;
         Utils.setRandSeed(game.LevelData.randSeed);
         Utils.shuffleRandom();
         Main.prepRandomCharacters(game.PlayerSettings.length);
         if(game.PlayerSettings[0].character == "random")
         {
            GameController.onlineModeMatchSettings.playerSettings[0].character = Main.RandCharList[0].StatsName;
            game.PlayerSettings[0].character = GameController.onlineModeMatchSettings.playerSettings[0].character;
            game.PlayerSettings[0].isRandom = true;
            GameController.onlineModeMatchSettings.playerSettings[0].isRandom = true;
         }
         ResourceManager.queueResources([game.LevelData.stage]);
         ResourceManager.queueResources(["sandbag"]);
         for(var i:int = 1; i <= game.PlayerSettings.length; i++)
         {
            if(Boolean(game.PlayerSettings[i - 1] && game.PlayerSettings[i - 1].exist) && Boolean(game.PlayerSettings[i - 1].character != null) && game.PlayerSettings[i - 1].character != "xp")
            {
               ResourceManager.queueResources([game.PlayerSettings[i - 1].character == "random" ? Main.RandCharList[i - 1].StatsName : game.PlayerSettings[i - 1].character]);
            }
         }
         ResourceManager.load({"oncomplete":callback});
      }
      
      public static function PERFORMALL() : void
      {
         if(Active)
         {
            m_onlineInterface.PERFORMALL();
            updateControls();
         }
      }
   }
}

