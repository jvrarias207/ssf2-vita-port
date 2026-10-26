package com.mcleodgaming.ssf2.modes
{
   import com.mcleodgaming.ssf2.controllers.*;
   import com.mcleodgaming.ssf2.enums.*;
   import com.mcleodgaming.ssf2.util.*;
   
   public class EventMode extends CustomMode
   {
      
      private const rankings:Array = ["S","A","B","C","D","E","F"];
      
      public function EventMode(game:Game, modeSettings:Object, stats:Object = null, stub:Boolean = false)
      {
         super(game,modeSettings,stats,stub);
      }
      
      override public function saveModeData(data:Object) : Boolean
      {
         var i:int = 0;
         var id:String = null;
         var score:int = 0;
         var scoreType:String = null;
         var rank:String = null;
         var fps:Number = NaN;
         var eventMatches:Array = null;
         var wasRecord:Boolean = false;
         var oldRecord:Object = null;
         if(Boolean(data))
         {
            if(data.type !== "eventMatch")
            {
               throw new Error("Error, expected type to equal \'eventMatch\'");
            }
            if(!data.matchData)
            {
               throw new Error("Error, matchData was not provided to saveModeData() for event match");
            }
            if(!data.eventMatchID)
            {
               throw new Error("Error, eventMatchID was not provided to saveModeData() for event match");
            }
            if(!data.matchData.fps)
            {
               throw new Error("Error, event match was missing fps value");
            }
            if(!data.matchData.rank)
            {
               throw new Error("Error, event match rank value was undefined and is required");
            }
            if(!data.matchData.rank.match(/^(s|a|b|c|d|e|f)$/i))
            {
               throw new Error("Error, invalid match ranking, should be valued S, A, B, C, D, E, or F");
            }
            if(typeof data.matchData.score === "undefined")
            {
               throw new Error("Error, event match was missing score value");
            }
            if(typeof data.matchData.scoreType === "undefined")
            {
               throw new Error("Error, event match was missing scoreType value");
            }
            if(!data.matchData.scoreType.match(/^(time|points|damage|stamina|kos)$/))
            {
               throw new Error("Error, event match scoreType value must be \'time\', \'points\', \'damage\', \'stamina\', or \'kos\'");
            }
            id = null;
            eventMatches = ResourceManager.getResourceByID("event_mode").getProp("eventList");
            for(i = 0; i < eventMatches.length; i++)
            {
               if(eventMatches[i].id === data.eventMatchID)
               {
                  id = eventMatches[i].id;
               }
            }
            if(!id)
            {
               throw new Error("Error, event match ID not found");
            }
            rank = data.matchData.rank.toUpperCase();
            score = int(data.matchData.score);
            scoreType = data.matchData.scoreType;
            fps = Number(data.matchData.fps);
            if(!SaveData.Records.events.wins[id])
            {
               SaveData.Records.events.wins[id] = new Object();
               SaveData.Records.events.wins[id].rank = rank;
               SaveData.Records.events.wins[id].score = score;
               SaveData.Records.events.wins[id].scoreType = scoreType;
               SaveData.Records.events.wins[id].fps = fps;
               wasRecord = true;
            }
            else if(this.rankings.indexOf(rank) < this.rankings.indexOf(SaveData.Records.events.wins[id].rank) || Boolean(rank === SaveData.Records.events.wins[id].rank) && (Boolean(scoreType.match(/points|stamina|kos/) && score > SaveData.Records.events.wins[id].score || scoreType.match(/time|damage/) && score < SaveData.Records.events.wins[id].score)))
            {
               SaveData.Records.events.wins[id].rank = rank;
               SaveData.Records.events.wins[id].score = score;
               SaveData.Records.events.wins[id].scoreType = scoreType;
               SaveData.Records.events.wins[id].fps = fps;
               wasRecord = true;
            }
            if(this.verifyMatchesBefore(true,1,"F"))
            {
               UnlockController.getUnlockableByID(Unlockable.EVENT_ALL_STAR_01).TriggerUnlock = true;
            }
            if(this.verifyMatchesBefore(true,2,"F"))
            {
               UnlockController.getUnlockableByID(Unlockable.EVENT_ALL_STAR_06).TriggerUnlock = true;
            }
            if(this.verifyMatchesBefore(true,3,"F"))
            {
               UnlockController.getUnlockableByID(Unlockable.EVENT_ALL_STAR_07).TriggerUnlock = true;
            }
            if(this.verifyMatchesBefore(true,4,"F"))
            {
               UnlockController.getUnlockableByID(Unlockable.EVENT_ALL_STAR_08).TriggerUnlock = true;
            }
            if(this.verifyMatchesBefore(true,5,"F"))
            {
               UnlockController.getUnlockableByID(Unlockable.EVENT_ALL_STAR_09).TriggerUnlock = true;
            }
            if(this.verifyMatchesBefore(true,6,"F"))
            {
               UnlockController.getUnlockableByID(Unlockable.EVENT_ALL_STAR_BETA).TriggerUnlock = true;
            }
            if(this.verifyMatchesBefore(false,11,"F"))
            {
               UnlockController.getUnlockableByID(Unlockable.EVENTS_11_20).TriggerUnlock = true;
            }
            if(this.verifyMatchesBefore(false,21,"F"))
            {
               UnlockController.getUnlockableByID(Unlockable.EVENTS_21_30).TriggerUnlock = true;
            }
            if(this.verifyMatchesBefore(false,31,"F"))
            {
               UnlockController.getUnlockableByID(Unlockable.EVENTS_31_36).TriggerUnlock = true;
            }
            if(this.verifyMatchesBefore(false,37,"F"))
            {
               UnlockController.getUnlockableByID(Unlockable.EVENTS_37_44).TriggerUnlock = true;
            }
            if(this.verifyMatchesBefore(false,45,"F"))
            {
               UnlockController.getUnlockableByID(Unlockable.EVENTS_45_50).TriggerUnlock = true;
            }
            if(this.verifyMatchesBefore(false,51,"A"))
            {
               UnlockController.getUnlockableByID(Unlockable.EVENT_ARANK).TriggerUnlock = true;
               UnlockController.getUnlockableByID(Unlockable.EVENTS_51).TriggerUnlock = true;
            }
            if(this.verifyMatchesBefore(false,52,"S"))
            {
               UnlockController.getUnlockableByID(Unlockable.EVENT_SRANK).TriggerUnlock = true;
            }
         }
         SaveData.saveGame();
         return wasRecord;
      }
      
      protected function verifyMatchesBefore(allStar:Boolean, number:int, atLeastRank:String) : Boolean
      {
         atLeastRank = atLeastRank.toUpperCase();
         var events:Array = ResourceManager.getResourceByID("event_mode").getProp("eventList");
         var allStarNumber:int = 0;
         var eventNumber:int = 0;
         for(var i:int = 0; i < events.length; i++)
         {
            if(Boolean(events[i].allStar))
            {
               allStarNumber++;
               if(allStar && number === allStarNumber)
               {
                  return true;
               }
               if(!SaveData.Records.events.wins[events[i].id] || this.rankings.indexOf(SaveData.Records.events.wins[events[i].id].rank) > this.rankings.indexOf(atLeastRank))
               {
                  return false;
               }
            }
            else
            {
               eventNumber++;
               if(!allStar && number === eventNumber)
               {
                  return true;
               }
               if(!SaveData.Records.events.wins[events[i].id] || this.rankings.indexOf(SaveData.Records.events.wins[events[i].id].rank) > this.rankings.indexOf(atLeastRank))
               {
                  return false;
               }
            }
         }
         return true;
      }
   }
}

