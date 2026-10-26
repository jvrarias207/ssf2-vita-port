package com.mcleodgaming.ssf2.modes
{
   import com.mcleodgaming.ssf2.Main;
   import com.mcleodgaming.ssf2.api.SSF2CustomMode;
   import com.mcleodgaming.ssf2.controllers.Game;
   import com.mcleodgaming.ssf2.controllers.GameController;
   import com.mcleodgaming.ssf2.controllers.MenuController;
   import com.mcleodgaming.ssf2.controllers.UnlockController;
   import com.mcleodgaming.ssf2.engine.CustomMatch;
   import com.mcleodgaming.ssf2.menus.Menu;
   import com.mcleodgaming.ssf2.menus.VaultMenu;
   import com.mcleodgaming.ssf2.net.MultiplayerManager;
   import com.mcleodgaming.ssf2.util.ResourceManager;
   import com.mcleodgaming.ssf2.util.Utils;
   
   public class CustomMode
   {
      
      protected var m_initialGameSettings:Game;
      
      protected var m_currentGame:Game;
      
      protected var m_apiInstance:SSF2CustomMode;
      
      protected var m_previousMenu:Menu;
      
      protected var m_modeSettings:Object;
      
      protected var m_stats:Object;
      
      protected var m_stub:Boolean;
      
      public function CustomMode(game:Game, modeSettings:Object, stats:Object = null, stub:Boolean = false)
      {
         super();
         this.m_initialGameSettings = game;
         this.m_modeSettings = modeSettings;
         this.m_stats = stats;
         this.m_stub = stub;
         if(!this.m_stats)
         {
            this.m_stats = {};
         }
         this.m_apiInstance = new SSF2CustomMode(this.m_stats.classAPI,this);
         this.m_apiInstance.initialize();
      }
      
      public function get APIInstance() : SSF2CustomMode
      {
         return this.m_apiInstance;
      }
      
      public function get ModeSettings() : Object
      {
         return this.m_modeSettings;
      }
      
      public function get InitialGameSettings() : Game
      {
         return this.m_initialGameSettings;
      }
      
      public function get GameInstance() : Game
      {
         return this.m_currentGame;
      }
      
      public function get PreviousMenu() : Menu
      {
         return this.m_previousMenu;
      }
      
      public function set PreviousMenu(menu:Menu) : void
      {
         this.m_previousMenu = menu;
      }
      
      public function retry() : void
      {
         this.m_apiInstance = new SSF2CustomMode(this.m_stats.classAPI,this);
         this.m_apiInstance.initialize();
      }
      
      public function startMatch(match:CustomMatch) : void
      {
         this.m_currentGame = match.getGameSettings();
         this.m_currentGame.GameMode = this.m_initialGameSettings.GameMode;
         if(this.m_stub)
         {
            return;
         }
         if(MultiplayerManager.Connected)
         {
            return;
         }
         GameController.isStarted = true;
         this.m_currentGame.LevelData.randSeed = Boolean(this.m_currentGame.ReplayDataObj) ? Number(this.m_currentGame.ReplayDataObj.MatchSettings.randSeed) : Utils.randomInteger(1,1000);
         Utils.setRandSeed(this.m_currentGame.LevelData.randSeed);
         Utils.shuffleRandom();
         Main.prepRandomCharacters(this.m_currentGame.PlayerSettings.length);
         ResourceManager.queueResources([this.m_currentGame.LevelData.stage]);
         if(Boolean(match.getGameSettings().LevelData.musicOverride))
         {
            ResourceManager.queueResources([match.getGameSettings().LevelData.musicOverride]);
         }
         for(var i:int = 0; i < this.m_currentGame.PlayerSettings.length; i++)
         {
            if(Boolean(this.m_currentGame.PlayerSettings[i] && this.m_currentGame.PlayerSettings[i].exist) && Boolean(this.m_currentGame.PlayerSettings[i].character != null) && this.m_currentGame.PlayerSettings[i].character != "xp")
            {
               ResourceManager.queueResources([this.m_currentGame.PlayerSettings[i].character == "random" ? Main.RandCharList[i].StatsName : this.m_currentGame.PlayerSettings[i].character]);
            }
         }
         MenuController.loadingMenu.show();
         ResourceManager.load({"oncomplete":this.startCustomMatch});
      }
      
      public function startCustomMatch(e:* = null) : void
      {
         MenuController.disposeAllMenus();
         GameController.startMatch(this.m_currentGame);
      }
      
      public function saveModeData(data:Object) : Boolean
      {
         return false;
      }
      
      public function endMode(data:Object) : void
      {
         MenuController.removeAllMenus();
         UnlockController.checkUnlocks();
         UnlockController.nextMenuFunc = function():void
         {
            if(Boolean(m_previousMenu))
            {
               if(m_previousMenu is VaultMenu)
               {
                  MenuController.vaultMenu.show();
               }
               else
               {
                  m_previousMenu.show();
               }
            }
            else
            {
               MenuController.titleMenu.show();
            }
         };
         if(UnlockController.pendingUnlockFights.length > 0)
         {
            MenuController.preUnlockMenu.show();
         }
         else if(UnlockController.pendingUnlockScreens.length > 0)
         {
            MenuController.postUnlockMenu.show();
         }
         else if(Boolean(this.m_previousMenu))
         {
            if(this.m_previousMenu is VaultMenu)
            {
               MenuController.vaultMenu.show();
            }
            else
            {
               this.m_previousMenu.show();
            }
         }
         else
         {
            MenuController.titleMenu.show();
         }
      }
   }
}

