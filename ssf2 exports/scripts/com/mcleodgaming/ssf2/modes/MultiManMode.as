package com.mcleodgaming.ssf2.modes
{
   import com.mcleodgaming.ssf2.controllers.*;
   import com.mcleodgaming.ssf2.enums.*;
   import com.mcleodgaming.ssf2.menus.MultiManMenu;
   import com.mcleodgaming.ssf2.util.*;
   
   public class MultiManMode extends CustomMode
   {
      
      public function MultiManMode(game:Game, modeSettings:Object, stats:Object = null, stub:Boolean = false)
      {
         super(game,modeSettings,stats,stub);
      }
      
      override public function saveModeData(data:Object) : Boolean
      {
         var i:int = 0;
         var id:String = null;
         var score:int = 0;
         var scoreType:String = null;
         if(Boolean(GameInstance.ReplayDataObj))
         {
            return false;
         }
         var wasRecord:Boolean = false;
         var oldRecord:Object = null;
         if(Boolean(data))
         {
            if(data.type !== "multiman")
            {
               throw new Error("Error, expected type to equal \'multiman\'");
            }
            if(!data.matchData)
            {
               throw new Error("Error, matchData was not provided to saveModeData() for multi-man mode");
            }
            if(typeof data.matchData.score === "undefined")
            {
               throw new Error("Error, multi-man mode was missing score value");
            }
            if(typeof data.matchData.scoreType === "undefined")
            {
               throw new Error("Error, multi-man match was missing scoreType value");
            }
            if(!data.matchData.scoreType.match(/^(time|kos)$/))
            {
               throw new Error("Error, multi-man match scoreType value must be \'time\' or \'kos\'");
            }
            score = int(data.matchData.score);
            scoreType = data.matchData.scoreType;
            oldRecord = SaveData.getMultiManModeData(MultiManMenu.SELECTED_MULTI_MAN_MODE,m_initialGameSettings.PlayerSettings[0].character);
            if(!oldRecord)
            {
               wasRecord = true;
               SaveData.setMultiManModeData(MultiManMenu.SELECTED_MULTI_MAN_MODE,m_initialGameSettings.PlayerSettings[0].character,{
                  "score":score,
                  "scoreType":scoreType
               });
            }
            else
            {
               switch(scoreType)
               {
                  case "kos":
                     if(oldRecord.scoreType !== "time" && score > oldRecord.score)
                     {
                        wasRecord = true;
                        SaveData.setMultiManModeData(MultiManMenu.SELECTED_MULTI_MAN_MODE,m_initialGameSettings.PlayerSettings[0].character,{
                           "score":score,
                           "scoreType":scoreType
                        });
                     }
                     break;
                  case "time":
                     if(oldRecord.scoreType === "kos" || score < oldRecord.score)
                     {
                        wasRecord = true;
                        SaveData.setMultiManModeData(MultiManMenu.SELECTED_MULTI_MAN_MODE,m_initialGameSettings.PlayerSettings[0].character,{
                           "score":score,
                           "scoreType":scoreType
                        });
                     }
               }
            }
         }
         SaveData.saveGame();
         return wasRecord;
      }
   }
}

