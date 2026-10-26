package com.mcleodgaming.ssf2.menus
{
   import com.mcleodgaming.ssf2.audio.*;
   import com.mcleodgaming.ssf2.controllers.*;
   import com.mcleodgaming.ssf2.engine.*;
   import com.mcleodgaming.ssf2.enums.Mode;
   import flash.events.MouseEvent;
   
   public class TrainingMenu extends CharacterSelectMenu
   {
      
      public function TrainingMenu(linkage:String)
      {
         super(linkage);
      }
      
      override public function reset() : void
      {
         gameMode = Mode.TRAINING;
         super.reset();
      }
      
      override public function makeEvents() : void
      {
         if(m_showCount == 0)
         {
            findSubMenuButtons();
            findSpecificMenuButtons(m_subMenu.bg_top);
         }
         super.makeEvents();
         if(Boolean(m_game))
         {
            m_game.UsingLives = false;
            m_game.UsingTime = false;
            m_game.UsingStamina = false;
            m_game.DamageRatio = 1;
            m_game.StartDamage = 0;
            m_game.FinalSmashMeter = false;
            m_game.ScoreDisplay = false;
            m_game.HudDisplay = true;
            m_game.PauseEnabled = true;
            m_game.LevelData.showEntrances = false;
            m_game.LevelData.showCountdownType = 2;
         }
         m_subMenu.bg_top.home_btn.addEventListener(MouseEvent.CLICK,this.home_CLICK);
      }
      
      override public function killEvents() : void
      {
         super.killEvents();
         m_subMenu.bg_top.home_btn.removeEventListener(MouseEvent.CLICK,this.home_CLICK);
      }
      
      override public function initMatch() : void
      {
         m_game.StartDamage = m_game.StartDamage;
         SoundQueue.instance.playSoundEffect("menu_selectstage");
         MenuController.CurrentCharacterSelectMenu.removeSelf();
         MenuController.stageSelectMenu.setCurrentGame(m_game);
         MenuController.stageSelectMenu.show();
      }
      
      override public function backMain_CLICK(e:MouseEvent) : void
      {
         super.backMain_CLICK(e);
         MenuController.soloMenu.show();
      }
      
      private function home_CLICK(e:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_back");
         SoundQueue.instance.stopMusic();
         resetScreen();
         m_game = null;
         MenuController.disposeAllMenus(true);
         MenuController.titleMenu.show();
      }
   }
}

