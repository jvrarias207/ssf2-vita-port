package com.mcleodgaming.ssf2.modes
{
   import com.mcleodgaming.ssf2.controllers.*;
   import com.mcleodgaming.ssf2.enums.*;
   import com.mcleodgaming.ssf2.util.*;
   
   public class CrystalSmashMode extends CustomMode
   {
      
      public function CrystalSmashMode(game:Game, modeSettings:Object, stats:Object = null, stub:Boolean = false)
      {
         super(game,modeSettings,stats,stub);
      }
      
      override public function saveModeData(data:Object) : Boolean
      {
         var i:int = 0;
         var id:String = null;
         var score:int = 0;
         var fps:Number = NaN;
         var crystalMatches:Array = null;
         if(Boolean(GameInstance.ReplayDataObj))
         {
            return false;
         }
         var wasRecord:Boolean = false;
         var oldRecord:Object = null;
         if(Boolean(data))
         {
            if(data.type !== "crystalSmash")
            {
               throw new Error("Error, expected type to equal \'crystalSmash\'");
            }
            if(!data.matchData)
            {
               throw new Error("Error, matchData was not provided to endMode() for crystal smash match");
            }
            if(!data.matchData.crystalMatchID)
            {
               throw new Error("Error, crystal smash match was missing crystalMatchID value");
            }
            if(!data.matchData.fps)
            {
               throw new Error("Error, crystal smash match was missing fps value");
            }
            if(!data.matchData.time)
            {
               throw new Error("Error, crystal smash match time value is required");
            }
            if(!data.matchData.character)
            {
               throw new Error("Error, crystal smash match character value is required");
            }
            id = null;
            crystalMatches = ResourceManager.getResourceByID("crystals_mode").getProp("crystalStageList");
            for(i = 0; i < crystalMatches.length; i++)
            {
               if(crystalMatches[i].id === data.matchData.crystalMatchID)
               {
                  id = crystalMatches[i].id;
               }
            }
            if(!id)
            {
               throw new Error("Error, crystal smash match was missing an ID");
            }
            oldRecord = SaveData.getCrystalSmashData(data.matchData.crystalMatchID,data.matchData.character);
            score = int(data.matchData.time);
            fps = Number(data.matchData.fps);
            if(!oldRecord || score < oldRecord.score)
            {
               wasRecord = true;
               SaveData.setCrystalSmashData(data.matchData.crystalMatchID,data.matchData.character,{
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

