package com.mcleodgaming.ssf2.modes
{
   import com.mcleodgaming.ssf2.controllers.*;
   import com.mcleodgaming.ssf2.enums.*;
   import com.mcleodgaming.ssf2.util.*;
   
   public class HomeRunContestMode extends CustomMode
   {
      
      public function HomeRunContestMode(game:Game, modeSettings:Object, stats:Object = null, stub:Boolean = false)
      {
         super(game,modeSettings,stats,stub);
      }
      
      override public function saveModeData(data:Object) : Boolean
      {
         var i:int = 0;
         var id:String = null;
         var score:Number = NaN;
         if(Boolean(GameInstance.ReplayDataObj))
         {
            return false;
         }
         var wasRecord:Boolean = false;
         var oldRecord:Object = null;
         if(Boolean(data))
         {
            if(data.type !== "hrc")
            {
               throw new Error("Error, expected type to equal \'hrc\'");
            }
            if(!data.matchData)
            {
               throw new Error("Error, matchData was not provided to saveModeData() for home run contest mode");
            }
            if(typeof data.matchData.score === "undefined")
            {
               throw new Error("Error, home run contest mode was missing score value");
            }
            if(!data.matchData.hrcMatchID)
            {
               throw new Error("Error, home run contest match was missing hrcMatchID value");
            }
            id = data.matchData.hrcMatchID;
            score = Number(data.matchData.score);
            oldRecord = SaveData.getHRCModeData(id,m_initialGameSettings.PlayerSettings[0].character);
            if(!oldRecord || score > oldRecord.score)
            {
               if(score > 0)
               {
                  wasRecord = true;
               }
               SaveData.setHRCModeData(id,m_initialGameSettings.PlayerSettings[0].character,{"score":score});
            }
         }
         SaveData.saveGame();
         return wasRecord;
      }
   }
}

