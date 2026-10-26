package com.mcleodgaming.ssf2.controllers
{
   import com.mcleodgaming.ssf2.util.SaveData;
   
   public class UnlockController
   {
      
      public static var unlockList:Vector.<Unlockable>;
      
      public static var pendingUnlockFights:Vector.<Unlockable>;
      
      public static var pendingUnlockScreens:Vector.<Unlockable>;
      
      public static var nextMenuFunc:Function = null;
      
      public function UnlockController()
      {
         super();
      }
      
      public static function init() : void
      {
         UnlockController.nextMenuFunc = null;
         UnlockController.unlockList = new Vector.<Unlockable>();
         UnlockController.pendingUnlockFights = new Vector.<Unlockable>();
         UnlockController.pendingUnlockScreens = new Vector.<Unlockable>();
         UnlockController.unlockList.push(new Unlockable(Unlockable.FINAL_VALLEY));
         UnlockController.unlockList.push(new Unlockable(Unlockable.WORLD_TOURNAMENT));
         UnlockController.unlockList.push(new Unlockable(Unlockable.STEEL_DIVER));
         UnlockController.unlockList.push(new Unlockable(Unlockable.SAFFRON_CITY));
         UnlockController.unlockList.push(new Unlockable(Unlockable.HYRULE_CASTLE_64));
         UnlockController.unlockList.push(new Unlockable(Unlockable.DEVILS_MACHINE));
         UnlockController.unlockList.push(new Unlockable(Unlockable.METAL_CAVERN));
         UnlockController.unlockList.push(new Unlockable(Unlockable.MUSHROOM_KINGDOM_64));
         UnlockController.unlockList.push(new Unlockable(Unlockable.WAITING_ROOM));
         UnlockController.unlockList.push(new Unlockable(Unlockable.THE_WORLD_THAT_NEVER_WAS));
         UnlockController.unlockList.push(new Unlockable(Unlockable.SKY_PILLAR));
         UnlockController.unlockList.push(new Unlockable(Unlockable.KRAZOA_PALACE));
         UnlockController.unlockList.push(new Unlockable(Unlockable.URBAN_CHAMPION));
         UnlockController.unlockList.push(new Unlockable(Unlockable.ALTERNATE_TRACKS));
         UnlockController.unlockList.push(new Unlockable(Unlockable.EVENT_ALL_STAR_01));
         UnlockController.unlockList.push(new Unlockable(Unlockable.EVENTS_11_20));
         UnlockController.unlockList.push(new Unlockable(Unlockable.EVENT_ALL_STAR_06));
         UnlockController.unlockList.push(new Unlockable(Unlockable.EVENTS_21_30));
         UnlockController.unlockList.push(new Unlockable(Unlockable.EVENT_ALL_STAR_07));
         UnlockController.unlockList.push(new Unlockable(Unlockable.EVENTS_31_36));
         UnlockController.unlockList.push(new Unlockable(Unlockable.EVENT_ALL_STAR_08));
         UnlockController.unlockList.push(new Unlockable(Unlockable.EVENTS_37_44));
         UnlockController.unlockList.push(new Unlockable(Unlockable.EVENT_ALL_STAR_09));
         UnlockController.unlockList.push(new Unlockable(Unlockable.EVENTS_45_50));
         UnlockController.unlockList.push(new Unlockable(Unlockable.EVENT_ALL_STAR_BETA));
         UnlockController.unlockList.push(new Unlockable(Unlockable.EVENTS_51));
         UnlockController.unlockList.push(new Unlockable(Unlockable.EVENT_ARANK));
         UnlockController.unlockList.push(new Unlockable(Unlockable.EVENT_SRANK));
         trace("UnlockController class initialized");
      }
      
      public static function getUnlockableByID(id:String) : Unlockable
      {
         for(var i:int = 0; i < UnlockController.unlockList.length; i++)
         {
            if(UnlockController.unlockList[i].ID === id)
            {
               return UnlockController.unlockList[i];
            }
         }
         return null;
      }
      
      public static function checkUnlocked(unlockable:Unlockable) : Boolean
      {
         var totals:int = 0;
         var i:* = undefined;
         var canUnlock:Boolean = true;
         if(unlockable.ID == Unlockable.FINAL_VALLEY)
         {
            if(Boolean(SaveData.Records.events.wins["ShadowCloneShowdown"]) && !SaveData.Unlocks[Unlockable.FINAL_VALLEY])
            {
               return true;
            }
         }
         else if(unlockable.ID == Unlockable.WORLD_TOURNAMENT)
         {
            if((unlockable.TriggerUnlock || SaveData.Records.vs.ffaMatchTotal >= 15) && !SaveData.Unlocks[Unlockable.WORLD_TOURNAMENT])
            {
               return true;
            }
         }
         else if(unlockable.ID == Unlockable.STEEL_DIVER)
         {
            if(SaveData.Unlocks.waterKOs >= 20 && !SaveData.Unlocks[Unlockable.STEEL_DIVER])
            {
               return true;
            }
         }
         else if(unlockable.ID == Unlockable.SAFFRON_CITY)
         {
            if(Boolean(SaveData.Records.classic.wins.jigglypuff) && !SaveData.Unlocks[Unlockable.SAFFRON_CITY])
            {
               return true;
            }
         }
         else if(unlockable.ID == Unlockable.HYRULE_CASTLE_64)
         {
            if(Boolean(SaveData.Unlocks.linkHyrule64Condition) && Boolean(SaveData.Unlocks.zeldaHyrule64Condition) && !SaveData.Unlocks[Unlockable.HYRULE_CASTLE_64])
            {
               return true;
            }
         }
         else if(unlockable.ID == Unlockable.DEVILS_MACHINE)
         {
            if(SaveData.Unlocks.ghostNessSDs >= 3 && !SaveData.Unlocks[Unlockable.DEVILS_MACHINE])
            {
               return true;
            }
         }
         else if(unlockable.ID == Unlockable.METAL_CAVERN)
         {
            if(unlockable.TriggerUnlock && !SaveData.Unlocks[Unlockable.METAL_CAVERN])
            {
               return true;
            }
         }
         else if(unlockable.ID == Unlockable.MUSHROOM_KINGDOM_64)
         {
            if(unlockable.TriggerUnlock && !SaveData.Unlocks[Unlockable.MUSHROOM_KINGDOM_64])
            {
               return true;
            }
         }
         else if(unlockable.ID == Unlockable.WAITING_ROOM)
         {
            if(Boolean(SaveData.Records.vs.matches.sandbag) && !SaveData.Unlocks[Unlockable.WAITING_ROOM])
            {
               return true;
            }
         }
         else if(unlockable.ID == Unlockable.THE_WORLD_THAT_NEVER_WAS)
         {
            if(unlockable.TriggerUnlock && !SaveData.Unlocks[Unlockable.THE_WORLD_THAT_NEVER_WAS])
            {
               return true;
            }
         }
         else if(unlockable.ID == Unlockable.SKY_PILLAR)
         {
            if(unlockable.TriggerUnlock && !SaveData.Unlocks[Unlockable.SKY_PILLAR])
            {
               return true;
            }
         }
         else if(unlockable.ID == Unlockable.KRAZOA_PALACE)
         {
            if(unlockable.TriggerUnlock && !SaveData.Unlocks[Unlockable.KRAZOA_PALACE])
            {
               return true;
            }
         }
         else if(unlockable.ID == Unlockable.URBAN_CHAMPION)
         {
            if(unlockable.TriggerUnlock && !SaveData.Unlocks[Unlockable.URBAN_CHAMPION])
            {
               return true;
            }
         }
         else if(unlockable.ID === Unlockable.ALTERNATE_TRACKS)
         {
            if(SaveData.PowerCount >= 10 && !SaveData.Unlocks[Unlockable.ALTERNATE_TRACKS])
            {
               return true;
            }
         }
         else if(unlockable.ID === Unlockable.EVENT_ALL_STAR_01)
         {
            if(unlockable.TriggerUnlock && !SaveData.Unlocks[Unlockable.EVENT_ALL_STAR_01])
            {
               return true;
            }
         }
         else if(unlockable.ID === Unlockable.EVENTS_11_20)
         {
            if(unlockable.TriggerUnlock && !SaveData.Unlocks[Unlockable.EVENTS_11_20])
            {
               return true;
            }
         }
         else if(unlockable.ID === Unlockable.EVENT_ALL_STAR_06)
         {
            if(unlockable.TriggerUnlock && !SaveData.Unlocks[Unlockable.EVENT_ALL_STAR_06])
            {
               return true;
            }
         }
         else if(unlockable.ID === Unlockable.EVENTS_21_30)
         {
            if(unlockable.TriggerUnlock && !SaveData.Unlocks[Unlockable.EVENTS_21_30])
            {
               return true;
            }
         }
         else if(unlockable.ID === Unlockable.EVENT_ALL_STAR_07)
         {
            if(unlockable.TriggerUnlock && !SaveData.Unlocks[Unlockable.EVENT_ALL_STAR_07])
            {
               return true;
            }
         }
         else if(unlockable.ID === Unlockable.EVENTS_31_36)
         {
            if(unlockable.TriggerUnlock && !SaveData.Unlocks[Unlockable.EVENTS_31_36])
            {
               return true;
            }
         }
         else if(unlockable.ID === Unlockable.EVENT_ALL_STAR_08)
         {
            if(unlockable.TriggerUnlock && !SaveData.Unlocks[Unlockable.EVENT_ALL_STAR_08])
            {
               return true;
            }
         }
         else if(unlockable.ID === Unlockable.EVENTS_37_44)
         {
            if(unlockable.TriggerUnlock && !SaveData.Unlocks[Unlockable.EVENTS_37_44])
            {
               return true;
            }
         }
         else if(unlockable.ID === Unlockable.EVENT_ALL_STAR_09)
         {
            if(unlockable.TriggerUnlock && !SaveData.Unlocks[Unlockable.EVENT_ALL_STAR_09])
            {
               return true;
            }
         }
         else if(unlockable.ID === Unlockable.EVENTS_45_50)
         {
            if(unlockable.TriggerUnlock && !SaveData.Unlocks[Unlockable.EVENTS_45_50])
            {
               return true;
            }
         }
         else if(unlockable.ID === Unlockable.EVENT_ALL_STAR_BETA)
         {
            if(unlockable.TriggerUnlock && !SaveData.Unlocks[Unlockable.EVENT_ALL_STAR_BETA])
            {
               return true;
            }
         }
         else if(unlockable.ID === Unlockable.EVENTS_51)
         {
            if(unlockable.TriggerUnlock && !SaveData.Unlocks[Unlockable.EVENTS_51])
            {
               return true;
            }
         }
         else if(unlockable.ID === Unlockable.EVENT_ARANK)
         {
            if(unlockable.TriggerUnlock && !SaveData.Unlocks[Unlockable.EVENT_ARANK])
            {
               return true;
            }
         }
         else if(unlockable.ID === Unlockable.EVENT_SRANK)
         {
            if(unlockable.TriggerUnlock && !SaveData.Unlocks[Unlockable.EVENT_SRANK])
            {
               return true;
            }
         }
         return false;
      }
      
      public static function matchSetup(unlockable:Unlockable) : Game
      {
         var tmpGame:Game = null;
         if(Boolean(tmpGame))
         {
            tmpGame.LevelData.randSeed = Math.round(Math.random() * 1000000 + 1);
         }
         return tmpGame;
      }
      
      public static function checkUnlocks() : void
      {
         while(UnlockController.pendingUnlockFights.length > 0)
         {
            UnlockController.pendingUnlockFights.splice(0,1);
         }
         while(UnlockController.pendingUnlockScreens.length > 0)
         {
            UnlockController.pendingUnlockScreens.splice(0,1);
         }
         for(var i:int = 0; i < UnlockController.unlockList.length; i++)
         {
            if(UnlockController.checkUnlocked(UnlockController.unlockList[i]))
            {
               if(Boolean(UnlockController.matchSetup(UnlockController.unlockList[i])))
               {
                  UnlockController.pendingUnlockFights.push(UnlockController.unlockList[i]);
               }
               else
               {
                  UnlockController.pendingUnlockScreens.push(UnlockController.unlockList[i]);
               }
            }
         }
      }
   }
}

