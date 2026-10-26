package com.mcleodgaming.ssf2.menus
{
   import com.mcleodgaming.ssf2.audio.*;
   import com.mcleodgaming.ssf2.controllers.*;
   import com.mcleodgaming.ssf2.engine.*;
   import com.mcleodgaming.ssf2.enums.Mode;
   import com.mcleodgaming.ssf2.modes.CrystalSmashMode;
   import com.mcleodgaming.ssf2.util.ResourceManager;
   import com.mcleodgaming.ssf2.util.SaveData;
   import com.mcleodgaming.ssf2.util.Utils;
   import flash.events.MouseEvent;
   
   public class CrystalSmashCharacterMenu extends CharacterSelectMenu
   {
      
      private var m_stage_id:int = 0;
      
      public function CrystalSmashCharacterMenu(linkage:String)
      {
         super(linkage);
         m_playerLimit = 1;
         gameMode = Mode.CRYSTAL_SMASH;
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
            m_game.UsingTime = true;
            m_game.UsingStamina = false;
            m_game.CountDown = false;
            m_game.StartDamage = 0;
            m_game.DamageRatio = 1;
            m_game.FinalSmashMeter = false;
            m_game.ScoreDisplay = false;
            m_game.HudDisplay = true;
            m_game.PauseEnabled = true;
         }
         m_subMenu.decLevel.addEventListener(MouseEvent.CLICK,this.decLevel_CLICK);
         m_subMenu.incLevel.addEventListener(MouseEvent.CLICK,this.incLevel_CLICK);
         m_subMenu.bg_top.home_btn.addEventListener(MouseEvent.CLICK,this.home_CLICK);
      }
      
      override public function killEvents() : void
      {
         super.killEvents();
         m_subMenu.decLevel.removeEventListener(MouseEvent.CLICK,this.decLevel_CLICK);
         m_subMenu.incLevel.removeEventListener(MouseEvent.CLICK,this.incLevel_CLICK);
         m_subMenu.bg_top.home_btn.removeEventListener(MouseEvent.CLICK,this.home_CLICK);
      }
      
      override public function initMatch() : void
      {
         SoundQueue.instance.playSoundEffect("menu_selectstage");
         SoundQueue.instance.playSoundEffect("menu_crowd");
         removeSelf();
         m_game.LevelData.customModeID = ResourceManager.getResourceByID("crystals_mode").getProp("crystalStageList")[this.m_stage_id].id;
         m_game.LevelData.scoreDisplay = false;
         m_modeInstance = new CrystalSmashMode(m_game,{"crystalMatchID":m_game.LevelData.customModeID},{"classAPI":ResourceManager.getResourceByID("crystals_mode").getProp("mode")});
         m_modeInstance.PreviousMenu = MenuController.crystalSmashCharacterMenu;
      }
      
      override public function initReplay() : void
      {
         m_game.importSettings({
            "levelData":m_game.ReplayDataObj.MatchSettings,
            "items":m_game.ReplayDataObj.ItemSettingsObj,
            "playerSettings":m_game.ReplayDataObj.PlayerData
         });
         SoundQueue.instance.playSoundEffect("menu_crowd");
         m_modeInstance = new CrystalSmashMode(m_game,{"crystalMatchID":m_game.LevelData.customModeID},{"classAPI":ResourceManager.getResourceByID("crystals_mode").getProp("mode")});
         m_modeInstance.PreviousMenu = MenuController.vaultMenu;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.updateCrystalSmashDisplay();
      }
      
      override public function show() : void
      {
         SoundQueue.instance.playMusic("menumusic",0);
         this.updateCrystalSmashDisplay();
         super.show();
         this.updateText();
      }
      
      override public function backMain_CLICK(e:MouseEvent) : void
      {
         super.backMain_CLICK(e);
         MenuController.stadiumMenu.show();
      }
      
      public function updateText() : void
      {
         m_subMenu.level_txt.text = ResourceManager.getResourceByID("crystals_mode").getProp("crystalStageList")[this.m_stage_id].name;
      }
      
      override public function updateGameIsReady() : void
      {
         super.updateGameIsReady();
         this.updateCrystalSmashDisplay();
      }
      
      private function decLevel_CLICK(e:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         --this.m_stage_id;
         if(this.m_stage_id < 0)
         {
            this.m_stage_id = ResourceManager.getResourceByID("crystals_mode").getProp("crystalStageList").length - 1;
         }
         this.updateText();
         this.updateCrystalSmashDisplay();
      }
      
      private function incLevel_CLICK(e:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         ++this.m_stage_id;
         if(this.m_stage_id > ResourceManager.getResourceByID("crystals_mode").getProp("crystalStageList").length - 1)
         {
            this.m_stage_id = 0;
         }
         this.updateText();
         this.updateCrystalSmashDisplay();
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
      
      public function updateCrystalSmashDisplay() : void
      {
         var minutes:String = "-:--";
         var millis:String = "";
         var fps:String = "";
         var stageID:String = ResourceManager.getResourceByID("crystals_mode").getProp("crystalStageList")[this.m_stage_id].id;
         if(m_game.PlayerSettings[0].character != null)
         {
            if(SaveData.getCrystalSmashData(stageID,m_game.PlayerSettings[0].character) != null)
            {
               if(SaveData.getCrystalSmashData(stageID,m_game.PlayerSettings[0].character).score > 0)
               {
                  minutes = Utils.framesToMinutesString(SaveData.getCrystalSmashData(stageID,m_game.PlayerSettings[0].character).score) + ":" + Utils.framesToSecondsString(SaveData.getCrystalSmashData(stageID,m_game.PlayerSettings[0].character).score);
                  millis = "\'" + Utils.framesToMillisecondsString(SaveData.getCrystalSmashData(stageID,m_game.PlayerSettings[0].character).score);
                  fps = SaveData.getCrystalSmashData(stageID,m_game.PlayerSettings[0].character).score_fps;
               }
            }
            m_subMenu.minutes_txt.text = minutes;
            m_subMenu.millis_txt.text = millis;
            m_subMenu.fps_txt.text = fps;
         }
         else
         {
            m_subMenu.minutes_txt.text = minutes;
            m_subMenu.millis_txt.text = millis;
            m_subMenu.fps_txt.text = fps;
         }
         minutes = "-:--";
         millis = "";
         var allGood:Boolean = true;
         var charList:Array = Stats.getCharacterList(false);
         var total:int = 0;
         for(var i:int = 0; i < charList.length; i++)
         {
            if(SaveData.getCrystalSmashData(stageID,charList[i]) != null)
            {
               if(SaveData.getCrystalSmashData(stageID,charList[i]).score <= 0)
               {
                  allGood = false;
                  break;
               }
               total += SaveData.getCrystalSmashData(stageID,charList[i]).score;
            }
            else
            {
               allGood = false;
            }
         }
         if(allGood)
         {
            minutes = Utils.framesToMinutesString(total) + ":" + Utils.framesToSecondsString(total);
            millis = "\'" + Utils.framesToMillisecondsString(total);
         }
         m_subMenu.total_minutes_txt.text = minutes;
         m_subMenu.total_millis_txt.text = millis;
      }
   }
}

