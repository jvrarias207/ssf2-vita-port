package com.mcleodgaming.ssf2.modes
{
   import com.mcleodgaming.ssf2.controllers.*;
   import com.mcleodgaming.ssf2.enums.*;
   import com.mcleodgaming.ssf2.util.*;
   
   public class AllStarMode extends CustomMode
   {
      
      public function AllStarMode(game:Game, modeSettings:Object, stats:Object = null, stub:Boolean = false)
      {
         super(game,modeSettings,stats,stub);
      }
      
      override public function saveModeData(data:Object) : Boolean
      {
         var i:int = 0;
         var id:String = null;
         var score:int = 0;
         var success:Boolean = false;
         var time:int = 0;
         var modeStub:CustomMode = null;
         if(Boolean(GameInstance.ReplayDataObj))
         {
            return false;
         }
         var wasRecord:Boolean = false;
         var oldRecord:Object = null;
         if(Boolean(data))
         {
            if(data.type !== "allstarMode")
            {
               throw new Error("Error, expected type to equal \'allstarMode\'");
            }
            if(!data.matchData)
            {
               throw new Error("Error, matchData was not provided to saveModeData() for all-star mode");
            }
            if(typeof data.matchData.score === "undefined")
            {
               throw new Error("Error, all-star mode was missing score value");
            }
            if(typeof data.matchData.success === "undefined")
            {
               throw new Error("Error, all-star mode was missing success value");
            }
            score = int(data.matchData.score);
            success = Boolean(data.matchData.success);
            time = int(data.matchData.time);
            oldRecord = SaveData.getAllStarModeData(m_initialGameSettings.PlayerSettings[0].character);
            if(!oldRecord || score > oldRecord.score)
            {
               wasRecord = true;
               SaveData.setAllStarModeData(m_initialGameSettings.PlayerSettings[0].character,{
                  "score":score,
                  "success":success,
                  "time":time
               });
            }
         }
         SaveData.saveGame();
         return wasRecord;
      }
   }
}

