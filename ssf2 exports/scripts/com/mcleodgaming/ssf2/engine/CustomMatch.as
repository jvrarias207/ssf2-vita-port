package com.mcleodgaming.ssf2.engine
{
   import com.mcleodgaming.ssf2.api.SSF2CustomMatch;
   import com.mcleodgaming.ssf2.controllers.Game;
   
   public class CustomMatch
   {
      
      private var m_apiInstance:SSF2CustomMatch;
      
      private var m_game:Game;
      
      public function CustomMatch(game:Game, stats:Object = null)
      {
         super();
         if(!stats)
         {
            stats = {};
         }
         this.m_apiInstance = new SSF2CustomMatch(stats.classAPI,this);
         this.m_game = this.m_apiInstance.matchSetup(game);
         this.m_game.CustomMatchObj = this;
         this.m_game.CustomModeObj = game.CustomModeObj;
         this.m_game.ReplayDataObj = game.CustomModeObj.InitialGameSettings.ReplayDataObj;
         if(Boolean(this.m_game.ReplayDataObj))
         {
            this.m_game.LevelData.randSeed = this.m_game.ReplayDataObj.MatchSettings.randSeed;
         }
      }
      
      public function get APIInstance() : SSF2CustomMatch
      {
         return this.m_apiInstance;
      }
      
      public function getGameSettings() : Game
      {
         return this.m_game;
      }
      
      public function update() : void
      {
         if(Boolean(this.m_apiInstance))
         {
            this.m_apiInstance.update();
         }
      }
   }
}

