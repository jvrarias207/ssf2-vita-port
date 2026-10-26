package com.mcleodgaming.ssf2.controllers
{
   import com.mcleodgaming.ssf2.Main;
   import com.mcleodgaming.ssf2.audio.*;
   import com.mcleodgaming.ssf2.engine.*;
   import com.mcleodgaming.ssf2.enums.Mode;
   import com.mcleodgaming.ssf2.net.*;
   import com.mcleodgaming.ssf2.util.*;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class StageButton extends HandButton
   {
      
      protected var m_currentGame:Game;
      
      protected var m_stageID:String;
      
      protected var m_hiddenStagesList:Vector.<String>;
      
      protected var m_loadingMask:MovieClip;
      
      public function StageButton(game:Game, button:MovieClip, stageID:String)
      {
         super(button);
         this.m_currentGame = game;
         this.m_stageID = stageID;
         this.m_hiddenStagesList = new Vector.<String>();
         this.m_hiddenStagesList.push("xpstage");
         this.m_hiddenStagesList.push("mushroomkingdom3");
         this.m_hiddenStagesList.push("skyworld");
         this.m_hiddenStagesList.push("castlesiege");
         for(var i:int = 0; i < this.m_hiddenStagesList.length; i++)
         {
            if(!Main.DEBUG && stageID == this.m_hiddenStagesList[i])
            {
               m_button.visible = false;
               break;
            }
         }
         this.m_loadingMask = ResourceManager.getLibraryMC("loadingMask");
         this.m_loadingMask.x = Main.Width / 2;
         this.m_loadingMask.y = Main.Height / 2;
      }
      
      public function get StageID() : String
      {
         return this.m_stageID;
      }
      
      public function setCurrentGame(game:Game) : void
      {
         this.m_currentGame = game;
      }
      
      override protected function button_ROLLOVER(e:MouseEvent) : void
      {
         var displayName:String = null;
         var stageInfo:Object = null;
         SoundQueue.instance.playSoundEffect("menu_hover");
         if(MenuController.stageSelectMenu.SubMenu.stage_sample.previewer.getChildByName("mc") != null)
         {
            Utils.tryToGotoAndStop(MovieClip(MenuController.stageSelectMenu.SubMenu.stage_sample.previewer.getChildByName("mc")),this.m_stageID == "random" ? "random" : this.m_stageID);
            displayName = "Untitled";
            if(this.m_stageID === "random")
            {
               displayName = "Random";
            }
            else if(this.m_stageID === "xpstage")
            {
               displayName = "Expansion Stage";
            }
            else
            {
               stageInfo = ResourceManager.getResourceByID("mappings").getProp("metadata").stage;
               if(Boolean(stageInfo[this.m_stageID]))
               {
                  displayName = stageInfo[this.m_stageID].name || "";
               }
               else
               {
                  displayName = "Untitled";
               }
            }
            MenuController.stageSelectMenu.SubMenu.stage_sample.stage_txt.text = displayName;
         }
      }
      
      override protected function button_CLICK(e:MouseEvent) : void
      {
         var i:int = 0;
         if(!GameController.isStarted)
         {
            if(this.m_stageID !== "random" && !ResourceManager.getResourceByID(this.m_stageID).FileName)
            {
               SoundQueue.instance.playSoundEffect("menu_error");
               return;
            }
            SoundQueue.instance.playSoundEffect("menu_crowd");
            SoundQueue.instance.playSoundEffect("menu_selectstage");
            GameController.isStarted = true;
            this.m_currentGame.LevelData.stage = this.m_stageID === "random" ? StageSetting.getRandomStage(false,false,this.m_currentGame.GameMode !== Mode.TRAINING) : this.m_stageID;
            m_button.removeEventListener(MouseEvent.ROLL_OVER,this.button_ROLLOVER);
            m_button.removeEventListener(MouseEvent.CLICK,this.button_CLICK);
            m_button.removeEventListener(MouseEvent.ROLL_OUT,this.button_ROLLOUT);
            if(this.m_currentGame.GameMode === Mode.ONLINE)
            {
               MultiplayerManager.toWaitingRoom(this.m_currentGame,this.startGame);
            }
            else
            {
               Main.Root.addChild(this.m_loadingMask);
               this.m_currentGame.LevelData.randSeed = Utils.randomInteger(1,1000);
               Utils.setRandSeed(this.m_currentGame.LevelData.randSeed);
               Utils.shuffleRandom();
               Main.prepRandomCharacters(this.m_currentGame.PlayerSettings.length);
               ResourceManager.queueResources([this.m_currentGame.LevelData.stage]);
               for(i = 1; i <= this.m_currentGame.PlayerSettings.length; i++)
               {
                  if(Boolean(this.m_currentGame.PlayerSettings[i - 1] && this.m_currentGame.PlayerSettings[i - 1].exist) && Boolean(this.m_currentGame.PlayerSettings[i - 1].character != null) && this.m_currentGame.PlayerSettings[i - 1].character != "xp")
                  {
                     ResourceManager.queueResources([this.m_currentGame.PlayerSettings[i - 1].character == "random" ? Main.RandCharList[i - 1].StatsName : this.m_currentGame.PlayerSettings[i - 1].character]);
                  }
               }
               ResourceManager.load({"oncomplete":this.startGame});
            }
         }
      }
      
      override protected function button_ROLLOUT(e:MouseEvent) : void
      {
         if(!GameController.isStarted)
         {
            Utils.tryToGotoAndStop(MovieClip(MenuController.stageSelectMenu.SubMenu.stage_sample.previewer.getChildByName("mc")),"paused");
            MenuController.stageSelectMenu.SubMenu.stage_sample.stage_txt.text = "";
         }
      }
      
      public function startGame(e:* = null) : void
      {
         if(this.m_loadingMask.parent != null)
         {
            Main.Root.removeChild(this.m_loadingMask);
         }
         MenuController.disposeAllMenus();
         GameController.startMatch(this.m_currentGame);
      }
   }
}

