package com.mcleodgaming.ssf2.menus
{
   import com.mcleodgaming.mgn.events.MGNEvent;
   import com.mcleodgaming.mgn.events.MGNEventManager;
   import com.mcleodgaming.ssf2.audio.*;
   import com.mcleodgaming.ssf2.controllers.*;
   import com.mcleodgaming.ssf2.engine.*;
   import com.mcleodgaming.ssf2.enums.Mode;
   import com.mcleodgaming.ssf2.net.MultiplayerManager;
   import com.mcleodgaming.ssf2.util.SaveData;
   import flash.events.MouseEvent;
   
   public class OnlineCharacterMenu extends CharacterSelectMenu
   {
      
      public function OnlineCharacterMenu(linkage:String)
      {
         super(linkage);
         m_playerLimit = 1;
         gameMode = Mode.ONLINE;
      }
      
      override public function reset() : void
      {
         super.reset();
         for(var i:int = 1; i < m_game.PlayerSettings.length; i++)
         {
            m_game.PlayerSettings[i].exist = false;
         }
         m_game.PlayerSettings[0].name = m_game.PlayerSettings[0].name || MultiplayerManager.Username.substr(0,10) || null;
         if(Boolean(SaveData.Controllers[0].GamepadInstance) && Boolean(m_game.PlayerSettings[0].name))
         {
            SaveData.reimportNamedPlayerControls(1,m_game.PlayerSettings[0].name);
         }
         if(MultiplayerManager.Connected)
         {
            m_game.LevelData.inputBuffer = MultiplayerManager.INPUT_BUFFER;
         }
         updateDisplay();
      }
      
      override public function show() : void
      {
         super.show();
         if(Boolean(m_game))
         {
            m_game.GameMode = Mode.ONLINE;
            updateDisplay();
         }
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
         m_subMenu.menu_open.addEventListener(MouseEvent.CLICK,this.menu_open_CLICK);
         m_subMenu.menu_open.addEventListener(MouseEvent.ROLL_OVER,this.menu_open_ROLL_OVER);
         m_subMenu.bnGameMode.addEventListener(MouseEvent.CLICK,this.gameMode_CLICK);
         m_subMenu.incShortcut.addEventListener(MouseEvent.CLICK,this.inc_CLICK);
         m_subMenu.decShortcut.addEventListener(MouseEvent.CLICK,this.dec_CLICK);
         MGNEventManager.dispatcher.addEventListener(MGNEvent.LEAVE_ROOM,this.onLeaveRoom);
         MGNEventManager.dispatcher.addEventListener(MGNEvent.ERROR_LEAVE_ROOM,this.onLeaveRoomError);
      }
      
      override public function killEvents() : void
      {
         super.killEvents();
         m_subMenu.menu_open.removeEventListener(MouseEvent.CLICK,this.menu_open_CLICK);
         m_subMenu.menu_open.removeEventListener(MouseEvent.ROLL_OVER,this.menu_open_ROLL_OVER);
         m_subMenu.bnGameMode.removeEventListener(MouseEvent.CLICK,this.gameMode_CLICK);
         m_subMenu.incShortcut.removeEventListener(MouseEvent.CLICK,this.inc_CLICK);
         m_subMenu.decShortcut.removeEventListener(MouseEvent.CLICK,this.dec_CLICK);
         MGNEventManager.dispatcher.removeEventListener(MGNEvent.LEAVE_ROOM,this.onLeaveRoom);
         MGNEventManager.dispatcher.removeEventListener(MGNEvent.ERROR_LEAVE_ROOM,this.onLeaveRoomError);
      }
      
      override public function initMatch() : void
      {
         SoundQueue.instance.playSoundEffect("menu_selectstage");
         MenuController.CurrentCharacterSelectMenu.removeSelf();
         if(MultiplayerManager.IsHost)
         {
            MenuController.stageSelectMenu.setCurrentGame(MenuController.CurrentCharacterSelectMenu.GameObj);
            MenuController.stageSelectMenu.show();
         }
         else
         {
            MenuController.pleaseWaitMenu.show();
            MultiplayerManager.toWaitingRoom(m_game,this.waitingRoomReady);
         }
      }
      
      private function waitingRoomReady(e:* = null) : void
      {
         MenuController.disposeAllMenus();
         GameController.startMatch(m_game);
      }
      
      override public function backMain_CLICK(e:MouseEvent) : void
      {
         if(MultiplayerManager.IsHost)
         {
            super.backMain_CLICK(e);
            MenuController.onlineGroupMenu.show();
         }
         else
         {
            MultiplayerManager.leaveRoom();
            m_container.visible = false;
         }
      }
      
      private function onLeaveRoom(e:MGNEvent) : void
      {
         m_container.visible = true;
         super.backMain_CLICK(null);
         MenuController.onlineMenu.show();
         MenuController.onlineMenu.refreshRoomsList();
      }
      
      private function onLeaveRoomError(e:MGNEvent) : void
      {
         m_container.visible = true;
      }
      
      public function menu_open_CLICK(e:MouseEvent) : void
      {
         if(hasVisibleKeypad())
         {
            SoundQueue.instance.playSoundEffect("menu_error");
            return;
         }
         SoundQueue.instance.playSoundEffect("menu_select");
         MenuController.rulesMenu.show();
      }
      
      public function menu_open_ROLL_OVER(e:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
      }
      
      public function gameMode_CLICK(e:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         toggleGameMode();
      }
      
      protected function inc_CLICK(e:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         incrementShortcut();
      }
      
      protected function dec_CLICK(e:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         decrementShortcut();
      }
   }
}

