package com.mcleodgaming.ssf2.modes
{
   import com.mcleodgaming.ssf2.controllers.*;
   import com.mcleodgaming.ssf2.enums.*;
   import com.mcleodgaming.ssf2.util.*;
   
   public class TargetTestMode extends CustomMode
   {
      
      public function TargetTestMode(game:Game, modeSettings:Object, stats:Object = null, stub:Boolean = false)
      {
         super(game,modeSettings,stats,stub);
      }
      
      override public function saveModeData(data:Object) : Boolean
      {
         var i:int = 0;
         var id:String = null;
         var score:int = 0;
         var fps:Number = NaN;
         var targetMatches:Array = null;
         if(Boolean(GameInstance.ReplayDataObj))
         {
            return false;
         }
         var wasRecord:Boolean = false;
         var oldRecord:Object = null;
         if(Boolean(data))
         {
            if(data.type !== "targetTest")
            {
               throw new Error("Error, expected type to equal \'targetTest\'");
            }
            if(!data.matchData)
            {
               throw new Error("Error, matchData was not provided to endMode() for target test match");
            }
            if(!data.matchData.targetMatchID)
            {
               throw new Error("Error, target test match was missing targetMatchID value");
            }
            if(!data.matchData.fps)
            {
               throw new Error("Error, target test match was missing fps value");
            }
            if(!data.matchData.time)
            {
               throw new Error("Error, target test match time value is required");
            }
            if(!data.matchData.character)
            {
               throw new Error("Error, target test match character value is required");
            }
            id = null;
            targetMatches = ResourceManager.getResourceByID("targets_mode").getProp("targetStageList");
            for(i = 0; i < targetMatches.length; i++)
            {
               if(targetMatches[i].id === data.matchData.targetMatchID)
               {
                  id = targetMatches[i].id;
               }
            }
            if(!id)
            {
               throw new Error("Error, target test match was missing an ID");
            }
            oldRecord = SaveData.getTargetTestData(data.matchData.targetMatchID,data.matchData.character);
            score = int(data.matchData.time);
            fps = Number(data.matchData.fps);
            if(!oldRecord || score < oldRecord.score)
            {
               wasRecord = true;
               SaveData.setTargetTestData(data.matchData.targetMatchID,data.matchData.character,{
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

