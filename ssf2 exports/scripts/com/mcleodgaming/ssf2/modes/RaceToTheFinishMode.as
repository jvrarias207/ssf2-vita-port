package com.mcleodgaming.ssf2.modes
{
   import com.mcleodgaming.ssf2.controllers.*;
   import com.mcleodgaming.ssf2.enums.*;
   import com.mcleodgaming.ssf2.util.*;
   
   public class RaceToTheFinishMode extends CustomMode
   {
      
      public function RaceToTheFinishMode(game:Game, modeSettings:Object, stats:Object = null, stub:Boolean = false)
      {
         super(game,modeSettings,stats,stub);
      }
      
      override public function saveModeData(data:Object) : Boolean
      {
         var i:int = 0;
         var score:int = 0;
         var fps:Number = NaN;
         if(Boolean(GameInstance.ReplayDataObj))
         {
            return false;
         }
         var wasRecord:Boolean = false;
         var oldRecord:Object = null;
         if(Boolean(data))
         {
            if(data.type !== "racetothefinish")
            {
               throw new Error("Error, expected type to equal \'racetothefinish\'");
            }
            if(!data.matchData)
            {
               throw new Error("Error, matchData was not provided to endMode() for race to the finish match");
            }
            if(!data.matchData.fps)
            {
               throw new Error("Error, race to the finish match was missing fps value");
            }
            if(!data.matchData.time)
            {
               throw new Error("Error, race to the finish match time value is required");
            }
            if(!data.matchData.character)
            {
               throw new Error("Error, race to the finish match character value is required");
            }
            oldRecord = SaveData.getRaceToTheFinishData("level0",data.matchData.character);
            score = int(data.matchData.time);
            fps = Number(data.matchData.fps);
            if(!oldRecord || score < oldRecord.score)
            {
               wasRecord = true;
               SaveData.setRaceToTheFinishData("level0",data.matchData.character,{
                  "score":score,
                  "score_fps":fps
               });
            }
         }
         SaveData.saveGame();
         return wasRecord;
      }
   }
}

