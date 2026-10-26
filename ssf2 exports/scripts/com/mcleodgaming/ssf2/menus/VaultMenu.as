package com.mcleodgaming.ssf2.menus
{
   import com.mcleodgaming.ssf2.Main;
   import com.mcleodgaming.ssf2.Version;
   import com.mcleodgaming.ssf2.audio.*;
   import com.mcleodgaming.ssf2.controllers.*;
   import com.mcleodgaming.ssf2.engine.ReplayData;
   import com.mcleodgaming.ssf2.enums.Mode;
   import com.mcleodgaming.ssf2.enums.ModeFeatures;
   import com.mcleodgaming.ssf2.net.MultiplayerManager;
   import com.mcleodgaming.ssf2.util.ResourceManager;
   import com.mcleodgaming.ssf2.util.Utils;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.ByteArray;
   import flash.utils.Timer;
   
   public class VaultMenu extends Menu
   {
      
      private var m_replayNode:MenuMapperNode;
      
      private var m_introNode:MenuMapperNode;
      
      private var m_intro2Node:MenuMapperNode;
      
      private var m_intro3Node:MenuMapperNode;
      
      protected var m_loadingMask:MovieClip;
      
      public function VaultMenu()
      {
         super();
         m_subMenu = ResourceManager.getLibraryMC("menu_vault");
         m_backgroundID = "space";
         m_container.addChild(m_subMenu);
         this.initMenuMappings();
         m_subMenu.x = Main.Width / 2;
         m_subMenu.y = Main.Height / 2;
         this.m_loadingMask = ResourceManager.getLibraryMC("loadingMask");
         this.m_loadingMask.x = Main.Width / 2;
         this.m_loadingMask.y = Main.Height / 2;
      }
      
      override public function initMenuMappings() : void
      {
         this.m_replayNode = new MenuMapperNode(m_subMenu.replays_btn);
         this.m_introNode = new MenuMapperNode(m_subMenu.intro_btn);
         this.m_intro2Node = new MenuMapperNode(m_subMenu.intro2_btn);
         this.m_intro3Node = new MenuMapperNode(m_subMenu.intro3_btn);
         this.m_replayNode.updateNodes(null,null,[this.m_intro3Node],[this.m_introNode],this.replay_MOUSE_OVER,null,this.replay_CLICK,this.back_CLICK_vault,null,null);
         this.m_introNode.updateNodes(null,null,[this.m_replayNode],[this.m_intro2Node],this.intro_MOUSE_OVER,null,this.play_intro,this.back_CLICK_vault,null,null);
         this.m_intro2Node.updateNodes(null,null,[this.m_introNode],[this.m_intro3Node],this.intro2_MOUSE_OVER,null,this.play_intro2,this.back_CLICK_vault,null,null);
         this.m_intro3Node.updateNodes(null,null,[this.m_intro2Node],[this.m_replayNode],this.intro3_MOUSE_OVER,null,this.play_intro3,this.back_CLICK_vault,null,null);
         m_menuMapper = new MenuMapper(this.m_replayNode);
         m_menuMapper.init();
      }
      
      override public function show() : void
      {
         super.show();
         SoundQueue.instance.playMusic("menumusic",0);
      }
      
      override public function makeEvents() : void
      {
         if(m_showCount == 0)
         {
            findSubMenuButtons();
            findSpecificMenuButtons(m_subMenu.bg_top);
         }
         super.makeEvents();
         resetAllButtons();
         m_subMenu.bg_top.back_btn.addEventListener(MouseEvent.CLICK,this.back_CLICK_vault);
         m_subMenu.bg_top.back_btn.addEventListener(MouseEvent.ROLL_OVER,this.back_ROLL_OVER_vault);
         m_subMenu.intro_btn.addEventListener(MouseEvent.CLICK,this.play_intro);
         m_subMenu.intro2_btn.addEventListener(MouseEvent.CLICK,this.play_intro2);
         m_subMenu.intro3_btn.addEventListener(MouseEvent.CLICK,this.play_intro3);
         m_subMenu.intro_btn.addEventListener(MouseEvent.MOUSE_OVER,this.intro_MOUSE_OVER);
         m_subMenu.intro2_btn.addEventListener(MouseEvent.MOUSE_OVER,this.intro2_MOUSE_OVER);
         m_subMenu.intro3_btn.addEventListener(MouseEvent.MOUSE_OVER,this.intro3_MOUSE_OVER);
         m_subMenu.intro_btn.addEventListener(MouseEvent.MOUSE_OUT,this.intro_MOUSE_OUT);
         m_subMenu.intro2_btn.addEventListener(MouseEvent.MOUSE_OUT,this.intro_MOUSE_OUT);
         m_subMenu.intro3_btn.addEventListener(MouseEvent.MOUSE_OUT,this.intro_MOUSE_OUT);
         m_subMenu.replays_btn.addEventListener(MouseEvent.CLICK,this.replay_CLICK);
         m_subMenu.replays_btn.addEventListener(MouseEvent.MOUSE_OVER,this.replay_MOUSE_OVER);
         m_subMenu.replays_btn.addEventListener(MouseEvent.MOUSE_OUT,this.replay_MOUSE_OUT);
         m_subMenu.bg_top.home_btn.addEventListener(MouseEvent.CLICK,this.home_CLICK);
         Main.Root.stage.addEventListener(Event.ENTER_FRAME,manageMenuMappings);
         setMenuMappingFocus();
      }
      
      override public function killEvents() : void
      {
         super.killEvents();
         m_subMenu.bg_top.back_btn.removeEventListener(MouseEvent.CLICK,this.back_CLICK_vault);
         m_subMenu.bg_top.back_btn.removeEventListener(MouseEvent.ROLL_OVER,this.back_ROLL_OVER_vault);
         m_subMenu.intro_btn.removeEventListener(MouseEvent.CLICK,this.play_intro);
         m_subMenu.intro2_btn.removeEventListener(MouseEvent.CLICK,this.play_intro2);
         m_subMenu.intro3_btn.removeEventListener(MouseEvent.CLICK,this.play_intro3);
         m_subMenu.intro_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.intro_MOUSE_OVER);
         m_subMenu.intro2_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.intro2_MOUSE_OVER);
         m_subMenu.intro3_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.intro3_MOUSE_OVER);
         m_subMenu.intro_btn.removeEventListener(MouseEvent.MOUSE_OUT,this.intro_MOUSE_OUT);
         m_subMenu.intro2_btn.removeEventListener(MouseEvent.MOUSE_OUT,this.intro_MOUSE_OUT);
         m_subMenu.intro3_btn.removeEventListener(MouseEvent.MOUSE_OUT,this.intro_MOUSE_OUT);
         m_subMenu.replays_btn.removeEventListener(MouseEvent.CLICK,this.replay_CLICK);
         m_subMenu.replays_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.replay_MOUSE_OVER);
         m_subMenu.replays_btn.removeEventListener(MouseEvent.MOUSE_OUT,this.replay_MOUSE_OUT);
         m_subMenu.bg_top.home_btn.removeEventListener(MouseEvent.CLICK,this.home_CLICK);
         Main.Root.stage.removeEventListener(Event.ENTER_FRAME,manageMenuMappings);
      }
      
      private function play_intro(e:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_selectstage");
         if(ResourceManager.getResourceByID("ssf2intro_v8").Loaded)
         {
            SoundQueue.instance.stopMusic();
            removeSelf();
            if(!MenuController.introMenu)
            {
               MenuController.introMenu = new IntroMenu();
            }
            MenuController.introMenu.show();
         }
         else
         {
            Main.Root.addChild(this.m_loadingMask);
            ResourceManager.queueResources(["ssf2intro_v8"]);
            ResourceManager.load({"oncomplete":this.introLoaded});
         }
      }
      
      private function introLoaded(e:Event = null) : void
      {
         SoundQueue.instance.stopMusic();
         removeSelf();
         Main.Root.removeChild(this.m_loadingMask);
         if(!MenuController.introMenu)
         {
            MenuController.introMenu = new IntroMenu();
         }
         MenuController.introMenu.show();
      }
      
      private function play_intro2(e:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_selectstage");
         if(ResourceManager.getResourceByID("ssf2intro_v9").Loaded)
         {
            SoundQueue.instance.stopMusic();
            removeSelf();
            if(!MenuController.intro2Menu)
            {
               MenuController.intro2Menu = new Intro2Menu();
            }
            MenuController.intro2Menu.show();
         }
         else
         {
            Main.Root.addChild(this.m_loadingMask);
            ResourceManager.queueResources(["ssf2intro_v9"]);
            ResourceManager.load({"oncomplete":this.intro2Loaded});
         }
      }
      
      private function intro2Loaded(e:Event = null) : void
      {
         SoundQueue.instance.stopMusic();
         removeSelf();
         Main.Root.removeChild(this.m_loadingMask);
         if(!MenuController.intro2Menu)
         {
            MenuController.intro2Menu = new Intro2Menu();
         }
         MenuController.intro2Menu.show();
      }
      
      private function play_intro3(e:MouseEvent) : void
      {
         removeSelf();
         SoundQueue.instance.playSoundEffect("menu_selectstage");
         SoundQueue.instance.stopMusic();
         MenuController.intro3Menu.setVault(true);
         MenuController.intro3Menu.show();
      }
      
      private function intro_MOUSE_OVER(e:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         m_subMenu.desc_txt.text = "Watch the SSF2 v0.8 Intro.";
      }
      
      private function intro2_MOUSE_OVER(e:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         m_subMenu.desc_txt.text = "Watch the SSF2 v0.9 Intro.";
      }
      
      private function intro3_MOUSE_OVER(e:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         m_subMenu.desc_txt.text = "Watch the SSF2 Beta Intro.";
      }
      
      private function intro_MOUSE_OUT(e:MouseEvent) : void
      {
         if(m_subMenu.desc_txt != null)
         {
            m_subMenu.desc_txt.text = "";
         }
      }
      
      private function replay_CLICK(e:MouseEvent) : void
      {
         var replayTimer:Timer = null;
         var replayFunc:Function = null;
         SoundQueue.instance.playSoundEffect("menu_select");
         Utils.openFile("SSF2 Replay File (*.ssfrec)","*.ssfrec");
         replayTimer = new Timer(20);
         MultiplayerManager.makeNotifier();
         replayFunc = function(e:TimerEvent):void
         {
            var loadedReplayFile:ByteArray = null;
            var loadedReplayData:ReplayData = null;
            if(Utils.finishedLoading)
            {
               replayTimer.removeEventListener(TimerEvent.TIMER,replayFunc);
               replayTimer.stop();
               makeEvents();
               if(Utils.openSuccess)
               {
                  loadedReplayFile = Utils.fileRef.data;
                  loadedReplayFile.uncompress();
                  loadedReplayData = new ReplayData(Main.MAXPLAYERS);
                  loadedReplayData.importReplay(loadedReplayFile.readUTF());
                  if(loadedReplayData.VersionNumber != Version.getVersion() && ReplayData.COMPATIBLE_VERSIONS.indexOf(loadedReplayData.VersionNumber) < 0)
                  {
                     MultiplayerManager.notify("Error, incompatible version number. Received version\t" + loadedReplayData.VersionNumber + " (Expecting " + Version.getVersion() + ")");
                  }
                  else if(ModeFeatures.hasFeature(ModeFeatures.ALLOW_REPLAY_RECORD,loadedReplayData.GameMode) && loadedReplayData.GameMode !== Mode.CLASSIC)
                  {
                     if(false && loadedReplayData.VersionNumber != Version.getVersion() && ReplayData.COMPATIBLE_VERSIONS.indexOf(loadedReplayData.VersionNumber) < 0)
                     {
                        MultiplayerManager.notify("WARNING: Incompatible version number. Received version\t" + loadedReplayData.VersionNumber + " (Expecting " + Version.getVersion() + ")");
                     }
                     MenuController.removeAllMenus();
                     if(loadedReplayData.GameMode === Mode.ONLINE)
                     {
                        MenuController.vsMenu.reset();
                        MenuController.CurrentCharacterSelectMenu = MenuController.vsMenu;
                        GameController.currentGame = new Game(loadedReplayData.PlayerData.length,Mode.VS);
                     }
                     else if(loadedReplayData.GameMode === Mode.ONLINE_ARENA || loadedReplayData.GameMode === Mode.ARENA)
                     {
                        MenuController.arenaCharacterSelectMenu.reset();
                        MenuController.CurrentCharacterSelectMenu = MenuController.arenaCharacterSelectMenu;
                        GameController.currentGame = new Game(loadedReplayData.PlayerData.length,Mode.ARENA);
                     }
                     else if(loadedReplayData.GameMode === Mode.TARGET_TEST)
                     {
                        MenuController.targetTestMenu.reset();
                        MenuController.CurrentCharacterSelectMenu = MenuController.targetTestMenu;
                        GameController.currentGame = new Game(loadedReplayData.PlayerData.length,Mode.TARGET_TEST);
                     }
                     else if(loadedReplayData.GameMode === Mode.HOME_RUN_CONTEST)
                     {
                        MenuController.homeRunContestMenu.reset();
                        MenuController.CurrentCharacterSelectMenu = MenuController.homeRunContestMenu;
                        GameController.currentGame = new Game(loadedReplayData.PlayerData.length,Mode.HOME_RUN_CONTEST);
                     }
                     else if(loadedReplayData.GameMode === Mode.MULTIMAN)
                     {
                        MenuController.multimanCharacterSelectMenu.reset();
                        MenuController.CurrentCharacterSelectMenu = MenuController.multimanCharacterSelectMenu;
                        GameController.currentGame = new Game(loadedReplayData.PlayerData.length,Mode.MULTIMAN);
                     }
                     else if(loadedReplayData.GameMode === Mode.CRYSTAL_SMASH)
                     {
                        MenuController.crystalSmashCharacterMenu.reset();
                        MenuController.CurrentCharacterSelectMenu = MenuController.crystalSmashCharacterMenu;
                        GameController.currentGame = new Game(loadedReplayData.PlayerData.length,Mode.CRYSTAL_SMASH);
                     }
                     else if(loadedReplayData.GameMode === Mode.RACE_TO_THE_FINISH)
                     {
                        MenuController.raceToTheFinishCharacterMenu.reset();
                        MenuController.CurrentCharacterSelectMenu = MenuController.raceToTheFinishCharacterMenu;
                        GameController.currentGame = new Game(loadedReplayData.PlayerData.length,Mode.RACE_TO_THE_FINISH);
                     }
                     else
                     {
                        MenuController.vsMenu.reset();
                        MenuController.CurrentCharacterSelectMenu = MenuController.vsMenu;
                        GameController.currentGame = new Game(loadedReplayData.PlayerData.length,loadedReplayData.GameMode);
                     }
                     MenuController.CurrentCharacterSelectMenu.GameObj.ReplayDataObj = loadedReplayData;
                     MenuController.CurrentCharacterSelectMenu.initReplay();
                  }
                  else
                  {
                     MultiplayerManager.notify("Replay file was not playable.");
                  }
               }
               else
               {
                  MultiplayerManager.notify("Replay file could not be loaded.");
               }
            }
         };
         this.killEvents();
         replayTimer.addEventListener(TimerEvent.TIMER,replayFunc);
         replayTimer.start();
      }
      
      private function replay_MOUSE_OVER(e:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         m_subMenu.desc_txt.text = "Re-watch all the action!";
      }
      
      private function replay_MOUSE_OUT(e:MouseEvent) : void
      {
         if(m_subMenu.desc_txt != null)
         {
            m_subMenu.desc_txt.text = "";
         }
      }
      
      private function back_CLICK_vault(e:MouseEvent) : void
      {
         removeSelf();
         SoundQueue.instance.playSoundEffect("menu_back");
         MenuController.mainMenu.show();
      }
      
      private function back_ROLL_OVER_vault(e:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
      }
      
      private function home_CLICK(e:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_back");
         SoundQueue.instance.stopMusic();
         MenuController.removeAllMenus();
         MenuController.titleMenu.show();
      }
   }
}

