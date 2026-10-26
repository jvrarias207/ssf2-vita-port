package com.mcleodgaming.ssf2.menus
{
   import com.mcleodgaming.mgn.events.MGNEvent;
   import com.mcleodgaming.mgn.events.MGNEventManager;
   import com.mcleodgaming.ssf2.Config;
   import com.mcleodgaming.ssf2.Main;
   import com.mcleodgaming.ssf2.api.SSF2API;
   import com.mcleodgaming.ssf2.audio.*;
   import com.mcleodgaming.ssf2.controllers.*;
   import com.mcleodgaming.ssf2.engine.*;
   import com.mcleodgaming.ssf2.enums.Mode;
   import com.mcleodgaming.ssf2.enums.ModeFeatures;
   import com.mcleodgaming.ssf2.net.MultiplayerManager;
   import com.mcleodgaming.ssf2.util.*;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.media.SoundChannel;
   import flash.utils.ByteArray;
   
   public class MatchResultsMenu extends Menu
   {
      
      private var skipLevel:int;
      
      private var winnerIs:SoundChannel;
      
      private var winnerChar:Character;
      
      private var m_backKey:Boolean;
      
      private var m_backKeyLetGo:Boolean;
      
      private var m_onlineFinishResendTimer:FrameTimer;
      
      private var m_playerSymbols:Array;
      
      public function MatchResultsMenu()
      {
         super();
         m_subMenu = ResourceManager.getLibraryMC("menu_matchresults");
         m_subMenu.stop();
         this.skipLevel = 0;
         this.winnerIs = null;
         this.winnerChar = null;
         this.m_onlineFinishResendTimer = new FrameTimer(30 * 10);
         this.m_playerSymbols = new Array();
         m_container.addChild(m_subMenu);
         m_subMenu.x = Main.Width / 2;
         m_subMenu.y = Main.Height / 2;
         this.m_backKey = false;
         this.m_backKeyLetGo = false;
         this.reset();
      }
      
      override public function show() : void
      {
         var data:Object = null;
         super.show();
         if(Config.enable_match_results)
         {
            this.displayMatchResults();
         }
         else
         {
            if(GameController.stageData.OnlineMode && MultiplayerManager.Connected)
            {
               data = GameController.stageData.getPlayerByID(MultiplayerManager.PlayerID).getPlayerSettings().exportSettings();
               data.results = GameController.stageData.getPlayerByID(MultiplayerManager.PlayerID).getMatchResults().exportData();
               MultiplayerManager.sendMatchFinishedSignal({"player_data":data});
            }
            this.gotoCharScreen(null);
         }
      }
      
      override public function makeEvents() : void
      {
         if(m_showCount == 0)
         {
            findSubMenuButtons();
         }
         m_subMenu.replaySave_btn.buttonMode = true;
         m_subMenu.replaySave_btn.useHandCursor = true;
         m_subMenu.replaySave_btn.visible = !GameController.stageData.ReplayMode;
         super.makeEvents();
         m_subMenu.back_btn.addEventListener(MouseEvent.CLICK,this.gotoCharScreen);
         m_subMenu.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         m_subMenu.stage.addEventListener(MouseEvent.CLICK,this.checkClick);
         m_subMenu.replaySave_btn.addEventListener(MouseEvent.CLICK,this.saveReplay);
         this.m_backKey = false;
         this.m_backKeyLetGo = false;
         SoundQueue.instance.enableDuplicateSupressor();
      }
      
      override public function killEvents() : void
      {
         super.killEvents();
         m_subMenu.back_btn.removeEventListener(MouseEvent.CLICK,this.gotoCharScreen);
         m_subMenu.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         m_subMenu.stage.removeEventListener(MouseEvent.CLICK,this.checkClick);
         m_subMenu.replaySave_btn.removeEventListener(MouseEvent.CLICK,this.saveReplay);
         SoundQueue.instance.disableDuplicateSupressor();
      }
      
      public function reset() : void
      {
         this.skipLevel = 0;
         m_subMenu.gotoAndPlay(1);
         SaveData.saveGame();
      }
      
      private function saveReplay(e:MouseEvent) : void
      {
         GameController.stageData.ReplayDataObj.Name = Utils.generateReplaySaveFileName(GameController.stageData);
         var replayData:ByteArray = new ByteArray();
         replayData.writeUTF(GameController.stageData.ReplayDataObj.exportReplay());
         replayData.compress();
         Utils.saveFile(replayData,GameController.stageData.ReplayDataObj.Name + ".ssfrec");
      }
      
      private function skipAhead() : Boolean
      {
         var i:int = 0;
         if(this.skipLevel == 0)
         {
            m_subMenu.gotoAndPlay(GameController.stageData.NoContest && Utils.hasLabel(m_subMenu,"skipNoContest") ? "skipNoContest" : "skip");
            this.skipLevel = 1;
            for(i = 0; i < this.m_playerSymbols.length; i++)
            {
               if(Boolean(this.m_playerSymbols[i].mc) && Boolean(this.m_playerSymbols[i].mc.stance))
               {
                  if(Boolean(this.m_playerSymbols[i].shadow) && Boolean(this.m_playerSymbols[i].shadow.stance))
                  {
                     Utils.tryToGotoAndStop(this.m_playerSymbols[i].shadow.stance,"skip");
                  }
                  if(Boolean(this.m_playerSymbols[i].charMC) && Boolean(this.m_playerSymbols[i].charMC.stance))
                  {
                     Utils.tryToGotoAndStop(this.m_playerSymbols[i].charMC.stance,"skip");
                  }
               }
            }
            return true;
         }
         if(this.skipLevel == 1)
         {
            m_subMenu.gotoAndStop(GameController.stageData.NoContest && Utils.hasLabel(m_subMenu,"skipNoContest2") ? "skipNoContest2" : "skip2");
            this.skipLevel = 2;
            return true;
         }
         return false;
      }
      
      private function checkClick(e:MouseEvent) : void
      {
         this.skipAhead();
      }
      
      private function updatePalettes() : void
      {
         var mc:MovieClip = null;
         var player:Character = null;
         var colorObj:Object = null;
         for(var i:int = 0; i < this.m_playerSymbols.length; i++)
         {
            mc = this.m_playerSymbols[i].mc;
            player = this.m_playerSymbols[i].player;
            colorObj = ResourceManager.getCostume(player.StatsName,Utils.getColorString(player.Team),player.getPlayerSetting("costume"));
            Utils.recursiveMovieClipPlay(mc,true,false);
            if(Boolean(colorObj))
            {
               Utils.replacePalette(mc,colorObj.paletteSwap,2);
               if(Boolean(this.m_playerSymbols[i].charMC))
               {
                  Utils.replacePalette(this.m_playerSymbols[i].charMC,colorObj.paletteSwap,2);
               }
            }
         }
      }
      
      private function onEnterFrame(e:Event) : void
      {
         var i:int = 0;
         var found:Boolean = false;
         if(m_subMenu.currentLabel === "skip2" || m_subMenu.currentLabel === "skipNoContest2")
         {
            this.skipLevel = 2;
         }
         else if(m_subMenu.currentLabel === "skip" || m_subMenu.currentLabel === "skipNoContest")
         {
            this.skipLevel = 1;
         }
         for(i = 0; i < SaveData.Controllers.length; i++)
         {
            if(SaveData.Controllers[i] != null)
            {
               if(SaveData.Controllers[i].IsDown(SaveData.Controllers[i]._BUTTON2))
               {
                  this.m_backKey = true;
                  if(this.m_backKeyLetGo)
                  {
                     this.m_backKeyLetGo = false;
                     if(!this.skipAhead())
                     {
                        this.gotoCharScreen(null);
                     }
                  }
                  found = true;
               }
            }
         }
         if(!found)
         {
            this.m_backKeyLetGo = true;
            this.m_backKey = false;
         }
         SoundQueue.instance.clearSurpressor();
         for(i = 0; i < this.m_playerSymbols.length; i++)
         {
            if(Boolean(this.m_playerSymbols[i].mc) && Boolean(this.m_playerSymbols[i].mc.stance))
            {
               if(Boolean(this.m_playerSymbols[i].shadow) && Boolean(this.m_playerSymbols[i].shadow.stance) && this.m_playerSymbols[i].mc.stance.currentFrame !== this.m_playerSymbols[i].shadow.stance.currentFrame)
               {
                  this.m_playerSymbols[i].shadow.stance.gotoAndStop(this.m_playerSymbols[i].mc.stance.currentFrame);
               }
               if(Boolean(this.m_playerSymbols[i].charMC) && Boolean(this.m_playerSymbols[i].charMC.stance) && this.m_playerSymbols[i].mc.stance.currentFrame !== this.m_playerSymbols[i].charMC.stance.currentFrame)
               {
                  this.m_playerSymbols[i].charMC.stance.gotoAndStop(this.m_playerSymbols[i].mc.stance.currentFrame);
               }
            }
         }
         this.updatePalettes();
      }
      
      private function gotoCharScreen(e:MouseEvent) : void
      {
         SoundQueue.instance.stopMusic();
         SoundQueue.instance.setLoopFunction(SoundQueue.instance.loopMusic);
         this.killEvents();
         if(this.winnerIs != null && this.winnerIs.hasEventListener(Event.SOUND_COMPLETE))
         {
            this.winnerIs.removeEventListener(Event.SOUND_COMPLETE,this.sayWinner);
         }
         removeSelf();
         m_subMenu.gotoAndStop(1);
         if(GameController.stageData.OnlineMode || GameController.currentGame.GameMode === Mode.ONLINE_WAITING_ROOM)
         {
            removeSelf();
            m_subMenu.gotoAndStop(1);
            if(MultiplayerManager.Connected)
            {
               MenuController.pleaseWaitMenu.show();
               Main.Root.stage.addEventListener(Event.ENTER_FRAME,this.waitForPlayers);
            }
            else
            {
               GameController.stageData.deactivateCharacters();
               GameController.destroyStageData();
               SSF2API.deinit();
               removeSelf();
               MenuController.mainMenu.show();
            }
         }
         else
         {
            GameController.stageData.deactivateCharacters();
            SSF2API.deinit();
            UnlockController.checkUnlocks();
            UnlockController.nextMenuFunc = function():void
            {
               if(ModeFeatures.hasFeature(ModeFeatures.IS_CUSTOM,GameController.stageData.GameRef.GameMode))
               {
                  GameController.currentGame.CustomModeObj.endMode(null);
               }
               else
               {
                  MenuController.vsMenu.show();
               }
            };
            if(GameController.stageData.ReplayMode)
            {
               removeSelf();
               m_subMenu.gotoAndStop(1);
               GameController.destroyStageData();
               MenuController.vaultMenu.show();
            }
            else if(UnlockController.pendingUnlockFights.length > 0)
            {
               MenuController.preUnlockMenu.show();
            }
            else if(UnlockController.pendingUnlockScreens.length > 0)
            {
               MenuController.postUnlockMenu.show();
            }
            else
            {
               removeSelf();
               m_subMenu.gotoAndStop(1);
               if(ModeFeatures.hasFeature(ModeFeatures.IS_CUSTOM,GameController.stageData.GameRef.GameMode))
               {
                  GameController.currentGame.CustomModeObj.endMode(null);
                  GameController.destroyStageData();
               }
               else
               {
                  GameController.destroyStageData();
                  MenuController.vsMenu.show();
               }
            }
         }
      }
      
      private function waitForPlayers(e:Event) : void
      {
         if(!MultiplayerManager.RoomKey)
         {
            Main.Root.stage.removeEventListener(Event.ENTER_FRAME,this.waitForPlayers);
            MenuController.pleaseWaitMenu.removeSelf();
            GameController.stageData.deactivateCharacters();
            GameController.destroyStageData();
            SSF2API.deinit();
            MultiplayerManager.resetMasterFrame();
            MultiplayerManager.restoreOriginalGameSettings(MenuController.CurrentCharacterSelectMenu.GameObj);
            MenuController.onlineMenu.show();
            SoundQueue.instance.playMusic("menumusic",0);
         }
         else if(!MultiplayerManager.MatchReady)
         {
            Main.Root.stage.removeEventListener(Event.ENTER_FRAME,this.waitForPlayers);
            if(MultiplayerManager.IsHost)
            {
               MGNEventManager.dispatcher.addEventListener(MGNEvent.UNLOCK_ROOM,this.onlineModeReady);
               MGNEventManager.dispatcher.addEventListener(MGNEvent.ERROR_UNLOCK_ROOM,this.onlineModeReady);
               MultiplayerManager.unlockRoom();
            }
            else
            {
               this.onlineModeReady();
            }
         }
      }
      
      private function onlineModeReady(e:* = null) : void
      {
         MGNEventManager.dispatcher.removeEventListener(MGNEvent.UNLOCK_ROOM,this.onlineModeReady);
         MGNEventManager.dispatcher.removeEventListener(MGNEvent.ERROR_UNLOCK_ROOM,this.onlineModeReady);
         MenuController.pleaseWaitMenu.removeSelf();
         GameController.stageData.deactivateCharacters();
         GameController.destroyStageData();
         SSF2API.deinit();
         MultiplayerManager.resetMasterFrame();
         MultiplayerManager.restoreOriginalGameSettings(MenuController.CurrentCharacterSelectMenu.GameObj);
         if(MultiplayerManager.IsHost && MultiplayerManager.RoomData.matchSettings.gameMode === Mode.ONLINE_ARENA)
         {
            MenuController.arenaCharacterSelectMenu.show();
         }
         else
         {
            MenuController.onlineCharacterMenu.show();
         }
      }
      
      private function sayWinner(e:Event) : void
      {
         this.winnerChar = GameController.stageData.getFirstWinner();
         switch(this.winnerChar.Team)
         {
            case -1:
               SoundQueue.instance.playVoiceEffect("narrator_" + this.winnerChar.StatsName);
               break;
            case 1:
               SoundQueue.instance.playVoiceEffect("narrator_redteam");
               break;
            case 2:
               SoundQueue.instance.playVoiceEffect("narrator_greenteam");
               break;
            case 3:
               SoundQueue.instance.playVoiceEffect("narrator_blueteam");
         }
      }
      
      private function saveRecords() : void
      {
         var didArr:Array = null;
         var j:int = 0;
         if(GameController.stageData.NoContest)
         {
            ++SaveData.MatchResets;
         }
         else
         {
            if(GameController.stageData.GameRef.UsingTime)
            {
               ++SaveData.TimeMatchTotal;
            }
            else
            {
               ++SaveData.StockMatchTotal;
            }
            didArr = new Array();
            for(j = 1; j <= GameController.stageData.Players.length; j++)
            {
               if(GameController.stageData.getPlayerByID(j) != null && didArr.indexOf(GameController.stageData.getPlayerByID(j).StatsName) < 0)
               {
                  SaveData.Records.vs.matches[GameController.stageData.getPlayerByID(j).StatsName] = SaveData.Records.vs.matches[GameController.stageData.getPlayerByID(j).StatsName] || 0;
                  ++SaveData.Records.vs.matches[GameController.stageData.getPlayerByID(j).StatsName];
                  didArr.push(GameController.stageData.getPlayerByID(j).StatsName);
               }
            }
            SaveData.Records.vs.playContestants += didArr.length;
            didArr = new Array();
            for(j = 1; j <= GameController.stageData.Players.length; j++)
            {
               if(GameController.stageData.getPlayerByID(j) != null && GameController.stageData.getPlayerByID(j).getMatchResults().Rank == 1 && didArr.indexOf(GameController.stageData.getPlayerByID(j).StatsName) < 0)
               {
                  SaveData.Records.vs.wins[GameController.stageData.getPlayerByID(j).StatsName] = SaveData.Records.vs.wins[GameController.stageData.getPlayerByID(j).StatsName] || 0;
                  ++SaveData.Records.vs.wins[GameController.stageData.getPlayerByID(j).StatsName];
                  didArr.push(GameController.stageData.getPlayerByID(j).StatsName);
               }
            }
            SaveData.Records.vs.stages[GameController.stageData.GameRef.LevelData.stage] = SaveData.Records.vs.stages[GameController.stageData.GameRef.LevelData.stage] || 0;
            ++SaveData.Records.vs.stages[GameController.stageData.GameRef.LevelData.stage];
            SaveData.VSPlayTime += GameController.stageData.ElapsedFrames;
            ++SaveData.Records.vs.matchTotal;
            if(GameController.stageData.GameRef.LevelData.teams)
            {
               ++SaveData.Records.vs.teamMatchTotal;
            }
            else
            {
               ++SaveData.Records.vs.ffaMatchTotal;
            }
         }
      }
      
      private function drawPlayer(pid:int) : void
      {
         var player:Character = null;
         var rank:int = 0;
         var resultsMC:MovieClip = null;
         var poseMC:MovieClip = null;
         var charMC:MovieClip = null;
         var charAnim:MovieClip = null;
         var teamSlot:int = 0;
         var divisor:Number = NaN;
         var charShadow:MovieClip = null;
         if(Boolean(ResourceManager.getResourceByID("mappings").getProp("metadata").match_results_screen))
         {
            this.drawPlayerV2(pid);
            return;
         }
         if(Boolean(m_subMenu["p" + pid + "Pose"]))
         {
            player = GameController.stageData.getPlayerByID(pid);
            rank = player.getMatchResults().Rank;
            resultsMC = m_subMenu["p" + pid + "Results"] as MovieClip;
            poseMC = null;
            charMC = ResourceManager.getLibraryMC(player.LinkageName);
            charAnim = resultsMC["charAnim"].addChild(charMC);
            charAnim.player_id = player.ID;
            charAnim.gotoAndStop(rank == 1 && !GameController.stageData.NoContest ? "win" : "lose");
            resultsMC.charName.text = player.DisplayName;
            resultsMC.placeNum.text = GameController.stageData.NoContest ? "-" : rank;
            player.updateColorFilter(charAnim,player.Team,player.CostumeName,player.CostumeID);
            if(GameController.stageData.NoContest)
            {
               this.m_playerSymbols.push({
                  "mc":charAnim,
                  "player":player,
                  "shadow":null,
                  "charMC":null
               });
            }
            else if(rank === 1 && !GameController.stageData.NoContest)
            {
               teamSlot = this.getTeamSlot(pid,player.Team);
               divisor = 1;
               charShadow = null;
               if(GameController.stageData.GameRef.LevelData.teams)
               {
                  divisor = teamSlot;
                  charShadow = m_subMenu["p" + teamSlot + "Pose"].addChild(ResourceManager.getLibraryMC(player.LinkageName));
                  charShadow.player_id = player.ID;
                  Utils.setColorFilter(charShadow,{
                     "brightness":-1000,
                     "alphaMultiplier":0.25
                  });
                  charShadow.transform.matrix.c = Math.tan(Utils.toRadians(30));
                  poseMC = m_subMenu["p" + teamSlot + "Pose"].addChild(ResourceManager.getLibraryMC(player.LinkageName));
                  poseMC.player_id = player.ID;
               }
               else
               {
                  divisor = 1;
                  charShadow = m_subMenu["p" + teamSlot + "Pose"].addChild(ResourceManager.getLibraryMC(player.LinkageName));
                  charShadow.player_id = player.ID;
                  Utils.setColorFilter(charShadow,{
                     "brightness":-1000,
                     "alphaMultiplier":0.25
                  });
                  charShadow.transform.matrix.c = Math.tan(Utils.toRadians(30));
                  poseMC = m_subMenu["p" + teamSlot + "Pose"].addChild(ResourceManager.getLibraryMC(player.LinkageName));
                  poseMC.player_id = player.ID;
               }
               poseMC.gotoAndStop("win");
               poseMC.scaleX = 2.5 * (1 / divisor);
               poseMC.scaleY = 2.5 * (1 / divisor);
               this.m_playerSymbols.push({
                  "mc":charAnim,
                  "player":player,
                  "shadow":charShadow,
                  "charMC":poseMC
               });
               charShadow.gotoAndStop("win");
               charShadow.scaleX = 2.5 * (1 / divisor);
               charShadow.scaleY = -0.3 * 2.5 * (1 / divisor);
               player.updateColorFilter(poseMC,player.Team,player.CostumeName,player.CostumeID);
               if(Boolean(poseMC.stance))
               {
                  Utils.removeActionScript(poseMC.stance);
               }
               if(Boolean(charShadow.stance))
               {
                  Utils.removeActionScript(charShadow.stance);
               }
            }
            else
            {
               this.m_playerSymbols.push({
                  "mc":charAnim,
                  "player":player,
                  "shadow":null,
                  "charMC":null
               });
            }
         }
      }
      
      private function drawPlayerV2(pid:int) : void
      {
         var i:int = 0;
         var match_results_screen:Object = ResourceManager.getResourceByID("mappings").getProp("metadata").match_results_screen;
         var player:Character = GameController.stageData.getPlayerByID(pid);
         var rank:int = player.getMatchResults().Rank;
         var other_player:Character = null;
         var teamSlot:int = 1;
         i = 1;
         while(i <= GameController.stageData.Players.length && !GameController.stageData.NoContest)
         {
            other_player = GameController.stageData.getPlayerByID(i);
            if(Boolean(other_player) && Boolean(other_player != player) && other_player.getMatchResults().Rank < rank)
            {
               teamSlot++;
            }
            i++;
         }
         for(i = 1; i <= GameController.stageData.Players.length; i++)
         {
            other_player = GameController.stageData.getPlayerByID(i);
            if(Boolean(other_player) && (GameController.stageData.NoContest || other_player.getMatchResults().Rank == rank))
            {
               if(other_player === player)
               {
                  break;
               }
               teamSlot++;
            }
         }
         var resultsMC:MovieClip = m_subMenu["p" + pid + "Results"] as MovieClip;
         var poseMC:MovieClip = m_subMenu.playerContainer["p" + teamSlot + "Pose"] as MovieClip;
         var animationToPlay:String = rank == 1 && !GameController.stageData.NoContest ? "win" : "lose";
         var positionInfo:Object = GameController.stageData.NoContest ? match_results_screen["no_contest_" + teamSlot] : (GameController.stageData.GameRef.LevelData.teams ? match_results_screen["teammate_" + teamSlot] : match_results_screen["rank_" + teamSlot]);
         resultsMC.charName.text = player.DisplayName;
         resultsMC.placeNum.text = GameController.stageData.NoContest ? "-" : rank;
         var charResultsMC:MovieClip = ResourceManager.getLibraryMC(player.LinkageName);
         var charAnim:MovieClip = resultsMC["charAnim"].addChild(charResultsMC);
         charAnim.player_id = player.ID;
         charAnim.gotoAndStop(animationToPlay);
         player.updateColorFilter(charAnim,player.Team,player.CostumeName,player.CostumeID);
         if(!GameController.stageData.NoContest && GameController.stageData.GameRef.LevelData.teams && rank !== 1 && !match_results_screen.show_losing_team)
         {
            this.m_playerSymbols.push({
               "mc":charAnim,
               "player":player,
               "shadow":null,
               "charMC":null
            });
            return;
         }
         var charMC:MovieClip = poseMC.addChild(ResourceManager.getLibraryMC(player.LinkageName)) as MovieClip;
         charMC.player_id = player.ID;
         charMC.gotoAndStop(animationToPlay);
         player.updateColorFilter(charMC,player.Team,player.CostumeName,player.CostumeID);
         var charShadow:MovieClip = poseMC.addChild(ResourceManager.getLibraryMC(player.LinkageName)) as MovieClip;
         charShadow.player_id = player.ID;
         Utils.setColorFilter(charShadow,{
            "brightness":-1000,
            "alphaMultiplier":0.25
         });
         charShadow.transform.matrix.c = Math.tan(Utils.toRadians(30));
         charShadow.gotoAndStop(animationToPlay);
         this.m_playerSymbols.push({
            "mc":charAnim,
            "player":player,
            "shadow":charShadow,
            "charMC":charMC
         });
         poseMC.x = positionInfo.x;
         poseMC.y = positionInfo.y;
         poseMC.scaleX = positionInfo.scaleX;
         poseMC.scaleY = positionInfo.scaleY;
         charShadow.scaleY = -0.3;
         if("visible" in positionInfo)
         {
            poseMC.visible = positionInfo.visible;
         }
         if(Boolean(charMC.stance))
         {
            Utils.removeActionScript(charMC.stance);
         }
         if(Boolean(charShadow.stance))
         {
            Utils.removeActionScript(charShadow.stance);
         }
      }
      
      private function getTeamSlot(pid:int, team:int) : int
      {
         var slot:int = 1;
         for(var i:int = 0; i < GameController.stageData.Players.length; i++)
         {
            if(Boolean(GameController.stageData.getPlayerByID(i)) && Boolean(GameController.stageData.getPlayerByID(i).Team === team) && GameController.stageData.getPlayerByID(i).ID === pid)
            {
               break;
            }
            if(Boolean(GameController.stageData.getPlayerByID(i)) && Boolean(GameController.stageData.getPlayerByID(i).Team === team) && GameController.stageData.getPlayerByID(i).ID !== pid)
            {
               slot++;
            }
         }
         return slot;
      }
      
      private function displayMatchResults() : void
      {
         var theme:String = null;
         var k:Number = NaN;
         var data:Object = null;
         var game:Game = GameController.stageData.GameRef;
         GameController.stageData.activateCharacters();
         SSF2API.init(GameController.stageData);
         var i:int = 0;
         var j:int = 0;
         var tmpMC:MovieClip = null;
         SoundQueue.instance.stopMusic();
         m_subMenu.matchInfo.modeDetails.text = GameController.stageData.NoContest ? "NO CONTEST" : "VERSUS";
         Utils.fitText(m_subMenu.matchInfo.modeDetails,20);
         var detailText:String = "";
         if(ModeFeatures.hasFeature(ModeFeatures.IS_CUSTOM,GameController.stageData.GameRef.GameMode))
         {
            detailText = GameController.stageData.GameRef.CustomModeObj.APIInstance.getSummary();
         }
         else
         {
            detailText = game.UsingLives ? game.Lives + "-stock" : "Timed Match";
            detailText += " / " + ResourceManager.getResourceByID("mappings").getProp("metadata").stage[game.LevelData.stage].name;
         }
         m_subMenu.matchInfo.matchDetails.text = detailText;
         if(!GameController.stageData.NoContest)
         {
            if(ModeFeatures.hasFeature(ModeFeatures.SAVE_RECORDS,game.GameMode))
            {
               this.saveRecords();
            }
            this.winnerIs = SoundQueue.instance.getSoundObject(SoundQueue.instance.playVoiceEffect("narrator_winner")).Channel;
            this.winnerIs.addEventListener(Event.SOUND_COMPLETE,this.sayWinner);
            theme = GameController.stageData.getFirstWinner().SoundData["winTheme"];
            if(ResourceManager.getLibrarySound(theme) != null)
            {
               SoundQueue.instance.setNextMusic("battle_results",2140);
               SoundQueue.instance.setLoopFunction(SoundQueue.instance.nextMusic);
               SoundQueue.instance.playMusic(theme,0);
            }
            else
            {
               SoundQueue.instance.stopMusic();
               SoundQueue.instance.playMusic("battle_results",2140);
            }
            for(i = 1; i <= GameController.stageData.Players.length; i++)
            {
               this.populateMatchResults(i);
            }
            j = 1;
            if(GameController.stageData.getTeams().length == 1)
            {
               for(j = 1; j <= GameController.stageData.Players.length; j++)
               {
                  if(GameController.stageData.getPlayerByID(j) != null)
                  {
                     trace("Place No. " + GameController.stageData.getPlayerByID(j).getMatchResults().Rank + " is player #" + j);
                     this.drawPlayer(j);
                  }
               }
            }
            else
            {
               for(j = 1; j <= GameController.stageData.Players.length; j++)
               {
                  if(GameController.stageData.getPlayerByID(j) != null)
                  {
                     trace("Player #" + j + " who is on Team " + GameController.stageData.getPlayerByID(j).Team + "is in Place No. " + GameController.stageData.getPlayerByID(j).getMatchResults().Rank);
                     this.drawPlayer(j);
                  }
               }
            }
         }
         else
         {
            m_subMenu.gotoAndPlay(Utils.hasLabel(m_subMenu,"noContest") ? "noContest" : "skip");
            if(Boolean(m_subMenu["winnerText"]))
            {
               m_subMenu["winnerText"].visible = false;
            }
            this.skipLevel = 1;
            for(k = 1; k <= GameController.stageData.Players.length; k++)
            {
               this.populateMatchResults(k);
            }
            SoundQueue.instance.playVoiceEffect("narrator_nocontest");
            for(j = 1; j <= GameController.stageData.Players.length; j++)
            {
               if(GameController.stageData.getPlayerByID(j) != null)
               {
                  trace("Player #" + j + " who is on Team " + GameController.stageData.getPlayerByID(j).Team + "is in Place No. " + GameController.stageData.getPlayerByID(j).getMatchResults().Rank);
                  this.drawPlayer(j);
               }
            }
         }
         if(GameController.stageData.OnlineMode && MultiplayerManager.Connected)
         {
            data = GameController.stageData.getPlayerByID(MultiplayerManager.PlayerID).getPlayerSettings().exportSettings();
            data.results = GameController.stageData.getPlayerByID(MultiplayerManager.PlayerID).getMatchResults().exportData();
            MultiplayerManager.sendMatchFinishedSignal({"player_data":data});
         }
         this.updatePalettes();
      }
      
      public function populateMatchResults(pNum:int) : void
      {
         var tmp:String = null;
         var i:int = 0;
         var j:int = 0;
         var mc:MovieClip = null;
         if(GameController.stageData.getPlayerByID(pNum) != null)
         {
            tmp = "KO List for player " + pNum + ": ";
            for(i = 0; i < GameController.stageData.getPlayerByID(pNum).getMatchResults().KOList.length; i++)
            {
               tmp += GameController.stageData.getPlayerByID(pNum).getMatchResults().KOList[i] + " ";
            }
            trace(tmp);
            tmp = "Killer List for player " + pNum + ": ";
            for(j = 0; j < GameController.stageData.getPlayerByID(pNum).getMatchResults().KillerList.length; j++)
            {
               tmp += GameController.stageData.getPlayerByID(pNum).getMatchResults().KillerList[j] + " ";
            }
            trace(tmp);
            if(!m_subMenu["p" + pNum + "Results"])
            {
               return;
            }
            mc = m_subMenu["p" + pNum + "Results"] as MovieClip;
            if(!GameController.stageData.getPlayerByID(pNum).IsHuman)
            {
               mc.gotoAndStop("cpu");
            }
            else if(GameController.stageData.GameRef.LevelData.teams)
            {
               mc.gotoAndStop("p" + Utils.convertTeamToColor(pNum,GameController.stageData.getPlayerByID(pNum).Team));
            }
            else
            {
               mc.gotoAndStop("p" + pNum);
            }
            mc.playerNum.text = "P" + pNum;
            mc.score.text = GameController.stageData.getPlayerByID(pNum).getMatchResults().Score >= 0 ? "+" + GameController.stageData.getPlayerByID(pNum).getMatchResults().Score : GameController.stageData.getPlayerByID(pNum).getMatchResults().Score;
            mc.kos.text = GameController.stageData.getPlayerByID(pNum).getMatchResults().KOs;
            mc.falls.text = GameController.stageData.getPlayerByID(pNum).getMatchResults().Falls;
            mc.sds.text = GameController.stageData.getPlayerByID(pNum).getMatchResults().SelfDestructs;
            mc.dmgGiven.text = Math.floor(GameController.stageData.getPlayerByID(pNum).getMatchResults().DamageGiven) + "%";
            mc.dmgTaken.text = Math.floor(GameController.stageData.getPlayerByID(pNum).getMatchResults().DamageTaken) + "%";
            mc.pitch.text = Math.floor(GameController.stageData.getPlayerByID(pNum).getMatchResults().FastestPitch) + "pps";
            mc.speed.text = Math.floor(GameController.stageData.getPlayerByID(pNum).getMatchResults().TopSpeed) + "pps";
            mc.drought.text = Math.floor(GameController.stageData.getPlayerByID(pNum).getMatchResults().LongestDrought / 30) + "s";
            mc.visible = true;
         }
      }
   }
}

