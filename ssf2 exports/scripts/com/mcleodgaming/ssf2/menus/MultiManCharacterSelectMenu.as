package com.mcleodgaming.ssf2.menus
{
   import com.mcleodgaming.ssf2.Config;
   import com.mcleodgaming.ssf2.audio.*;
   import com.mcleodgaming.ssf2.controllers.*;
   import com.mcleodgaming.ssf2.engine.*;
   import com.mcleodgaming.ssf2.enums.Mode;
   import com.mcleodgaming.ssf2.modes.MultiManMode;
   import com.mcleodgaming.ssf2.util.ResourceManager;
   import com.mcleodgaming.ssf2.util.SaveData;
   import com.mcleodgaming.ssf2.util.Utils;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class MultiManCharacterSelectMenu extends CharacterSelectMenu
   {
      
      public function MultiManCharacterSelectMenu(linkage:String)
      {
         super(linkage);
         m_playerLimit = 1;
         gameMode = Mode.MULTIMAN;
      }
      
      override public function makeEvents() : void
      {
         if(m_showCount == 0)
         {
            findSubMenuButtons();
            findSpecificMenuButtons(m_subMenu.bg_top);
         }
         super.makeEvents();
         m_subMenu.bg_top.home_btn.addEventListener(MouseEvent.CLICK,this.home_CLICK);
      }
      
      override public function killEvents() : void
      {
         super.killEvents();
         m_subMenu.bg_top.home_btn.removeEventListener(MouseEvent.CLICK,this.home_CLICK);
      }
      
      override public function initMatch() : void
      {
         SoundQueue.instance.playSoundEffect("menu_selectstage");
         SoundQueue.instance.playSoundEffect("menu_crowd");
         removeSelf();
         m_game.LevelData.customModeID = MultiManMenu.SELECTED_MULTI_MAN_MODE;
         m_game.LevelData.lives = 1;
         m_game.LevelData.usingStamina = false;
         m_game.LevelData.scoreDisplay = false;
         m_game.FinalSmashMeter = false;
         m_game.ScoreDisplay = false;
         m_game.HudDisplay = true;
         m_game.PauseEnabled = true;
         m_modeInstance = new MultiManMode(m_game,{"multiManModeID":m_game.LevelData.customModeID},{"classAPI":ResourceManager.getResourceByID("multiman_mode").getProp("mode")});
         m_modeInstance.PreviousMenu = this;
      }
      
      override public function initReplay() : void
      {
         m_game.importSettings({
            "levelData":m_game.ReplayDataObj.MatchSettings,
            "items":m_game.ReplayDataObj.ItemSettingsObj,
            "playerSettings":m_game.ReplayDataObj.PlayerData
         });
         SoundQueue.instance.playSoundEffect("menu_crowd");
         m_modeInstance = new MultiManMode(m_game,{"multiManModeID":m_game.LevelData.customModeID},{"classAPI":ResourceManager.getResourceByID("multiman_mode").getProp("mode")});
         m_modeInstance.PreviousMenu = MenuController.vaultMenu;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.updateMultiManScoreDisplay();
      }
      
      override public function updateGameIsReady() : void
      {
         super.updateGameIsReady();
         this.updateMultiManScoreDisplay();
      }
      
      override public function show() : void
      {
         super.show();
         this.updateMultiManScoreDisplay();
         SoundQueue.instance.playMusic("menumusic",0);
      }
      
      override public function backMain_CLICK(e:MouseEvent) : void
      {
         super.backMain_CLICK(e);
         MenuController.multimanMenu.show();
      }
      
      private function home_CLICK(e:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_back");
         SoundQueue.instance.stopMusic();
         resetScreen();
         m_game = null;
         MenuController.removeAllMenus();
         MenuController.titleMenu.show();
      }
      
      protected function updateMultiManScoreDisplay() : void
      {
         var i:* = undefined;
         var myScore:Object = null;
         var stockIcon:MovieClip = null;
         var bestScore:Object = null;
         var bestID:String = null;
         var modeRecords:Object = SaveData.Records.multiman.modes[MultiManMenu.SELECTED_MULTI_MAN_MODE];
         m_subMenu.record.record_minutes_txt.text = "----------";
         m_subMenu.record.record_millis_txt.text = "";
         m_subMenu.record.minutes_txt.text = "----------";
         m_subMenu.record.millis_txt.text = "";
         while(m_subMenu.record.best_icon.numChildren > 0)
         {
            m_subMenu.record.best_icon.removeChild(m_subMenu.record.best_icon.getChildAt(0));
         }
         while(m_subMenu.record.high_icon.numChildren > 0)
         {
            m_subMenu.record.high_icon.removeChild(m_subMenu.record.high_icon.getChildAt(0));
         }
         for(i in modeRecords)
         {
            if(!bestScore)
            {
               bestScore = modeRecords[i];
               bestID = i;
            }
            else if(bestScore.scoreType === "kos" && modeRecords[i].scoreType === "time")
            {
               bestScore = modeRecords[i];
               bestID = i;
            }
            else if(bestScore.scoreType === "time" && modeRecords[i].scoreType === "time" && bestScore.score > modeRecords[i].score)
            {
               bestScore = modeRecords[i];
               bestID = i;
            }
            else if(bestScore.scoreType === "kos" && modeRecords[i].scoreType === "kos" && bestScore.score < modeRecords[i].score)
            {
               bestScore = modeRecords[i];
               bestID = i;
            }
         }
         if(Boolean(bestScore))
         {
            if(bestScore.scoreType === "time")
            {
               m_subMenu.record.record_minutes_txt.text = Utils.framesToMinutesString(bestScore.score) + ":" + Utils.framesToSecondsString(bestScore.score);
               m_subMenu.record.record_millis_txt.text = Utils.framesToMillisecondsString(bestScore.score);
            }
            else if(bestScore.scoreType === "kos")
            {
               m_subMenu.record.record_minutes_txt.text = "" + bestScore.score;
               m_subMenu.record.record_millis_txt.text = "KOs";
            }
            stockIcon = ResourceManager.getLibraryMC(bestID + "_stock");
            if(Boolean(stockIcon))
            {
               if(Config.enable_new_stock_counter)
               {
                  Utils.setColorFilterCharacter(stockIcon,-1,bestID,-1,false,true);
               }
               m_subMenu.record.best_icon.addChild(stockIcon);
            }
         }
         if(Boolean(m_game.PlayerSettings[0].character))
         {
            myScore = SaveData.getMultiManModeData(MultiManMenu.SELECTED_MULTI_MAN_MODE,m_game.PlayerSettings[0].character);
            if(Boolean(myScore))
            {
               if(myScore.scoreType === "time")
               {
                  m_subMenu.record.minutes_txt.text = Utils.framesToMinutesString(myScore.score) + ":" + Utils.framesToSecondsString(myScore.score);
                  m_subMenu.record.millis_txt.text = Utils.framesToMillisecondsString(myScore.score);
               }
               else if(myScore.scoreType === "kos")
               {
                  m_subMenu.record.minutes_txt.text = "" + myScore.score;
                  m_subMenu.record.millis_txt.text = "KOs";
               }
            }
            stockIcon = ResourceManager.getLibraryMC(m_game.PlayerSettings[0].character + "_stock");
            if(Boolean(stockIcon))
            {
               if(Config.enable_new_stock_counter)
               {
                  Utils.setColorFilterCharacter(stockIcon,-1,m_game.PlayerSettings[0].character,-1,false,true);
               }
               m_subMenu.record.high_icon.addChild(stockIcon);
            }
         }
      }
   }
}

