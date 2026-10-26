package com.mcleodgaming.ssf2.enums
{
   public class ModeFeatures
   {
      
      public static const MULTIPLAYER_MANAGER:uint = 0;
      
      public static const FILL_PLAYER_SLOTS:uint = 1;
      
      public static const INVERTED_TIMER:uint = 3;
      
      public static const EXTENDED_ENDTIMER:uint = 4;
      
      public static const FORCE_NO_ITEM_AUTO_SPAWN:uint = 5;
      
      public static const ALLOW_STOCK_STEAL:uint = 6;
      
      public static const ALLOW_SUDDEN_DEATH:uint = 7;
      
      public static const REMOVE_TIMER:uint = 9;
      
      public static const CHECK_UNLOCKS:uint = 12;
      
      public static const IGNORE_TEAM_COSTUME:uint = 14;
      
      public static const IGNORE_STALE_DECAY:uint = 15;
      
      public static const FORCE_ITEM_AVAILABILITY:uint = 17;
      
      public static const ALLOW_SAVE_VS_OPTIONS:uint = 18;
      
      public static const FORCE_NO_TEAM_DAMAGE:uint = 19;
      
      public static const ALLOW_FFA_TEAM_TOGGLE:uint = 20;
      
      public static const FORCE_SINGLE_PLAYER:uint = 21;
      
      public static const HAS_HOME_BUTTON:uint = 22;
      
      public static const ALLOW_CONROL_TYPE:uint = 23;
      
      public static const ALLOW_SINGLE_PLAYER:uint = 24;
      
      public static const ALLOW_PAUSE:uint = 25;
      
      public static const ALLOW_CROWD_CHANTS:uint = 26;
      
      public static const ALLOW_NARRATOR_GAME:uint = 27;
      
      public static const ALLOW_NARRATOR_CPU_DEFEATED:uint = 28;
      
      public static const ALLOW_REPLAY_RECORD:uint = 29;
      
      public static const SAVE_RECORDS:uint = 30;
      
      public static const OFFSCREEN_DAMAGE:uint = 31;
      
      public static const OFFSCREEN_BUBBLE:uint = 32;
      
      public static const FORCE_TWO_PLAYER:uint = 33;
      
      public static const ALLOW_TEAM_TOGGLE:uint = 34;
      
      public static const IS_CUSTOM:uint = 35;
      
      public static const HAS_RETRY_BUTTON:uint = 36;
      
      public function ModeFeatures()
      {
         super();
      }
      
      public static function hasFeature(feature:uint, mode:uint) : Boolean
      {
         if(feature == MULTIPLAYER_MANAGER)
         {
            return mode == Mode.ONLINE || mode == Mode.ONLINE_ARENA;
         }
         if(feature == FILL_PLAYER_SLOTS)
         {
            return mode == Mode.TRAINING;
         }
         if(feature == INVERTED_TIMER)
         {
            return mode == Mode.TARGET_TEST || mode == Mode.CRYSTAL_SMASH || mode == Mode.RACE_TO_THE_FINISH;
         }
         if(feature == EXTENDED_ENDTIMER)
         {
            return mode == Mode.TARGET_TEST || mode == Mode.CRYSTAL_SMASH || mode == Mode.RACE_TO_THE_FINISH;
         }
         if(feature == FORCE_NO_ITEM_AUTO_SPAWN)
         {
            return mode == Mode.TRAINING || mode == Mode.TARGET_TEST || mode === Mode.ONLINE_WAITING_ROOM || mode === Mode.ARENA || mode == Mode.CRYSTAL_SMASH || mode == Mode.ONLINE_ARENA || mode == Mode.RACE_TO_THE_FINISH;
         }
         if(feature == ALLOW_SUDDEN_DEATH)
         {
            return mode == Mode.VS || mode == Mode.VS_UNLOCK || mode == Mode.ONLINE;
         }
         if(feature == REMOVE_TIMER)
         {
            return mode == Mode.VS || mode == Mode.VS_UNLOCK || mode == Mode.ONLINE || mode === Mode.ONLINE_WAITING_ROOM || mode === Mode.ARENA || mode == Mode.ONLINE_ARENA;
         }
         if(feature == CHECK_UNLOCKS)
         {
            return mode == Mode.VS || mode == Mode.TARGET_TEST || mode == Mode.CRYSTAL_SMASH || mode == Mode.RACE_TO_THE_FINISH;
         }
         if(feature == IGNORE_TEAM_COSTUME)
         {
            return mode == Mode.TRAINING || mode == Mode.CLASSIC || mode == Mode.EVENT;
         }
         if(feature == IGNORE_STALE_DECAY)
         {
            return mode == Mode.TRAINING;
         }
         if(feature == ALLOW_STOCK_STEAL)
         {
            return mode == Mode.VS || mode == Mode.VS_UNLOCK || mode == Mode.ONLINE || mode == Mode.CLASSIC;
         }
         if(feature == FORCE_ITEM_AVAILABILITY)
         {
            return mode == Mode.TRAINING || mode == Mode.TARGET_TEST;
         }
         if(feature == ALLOW_SAVE_VS_OPTIONS)
         {
            return mode == Mode.VS;
         }
         if(feature == FORCE_NO_TEAM_DAMAGE)
         {
            return mode == Mode.TRAINING || mode == Mode.CLASSIC || mode == Mode.ALL_STAR;
         }
         if(feature == ALLOW_FFA_TEAM_TOGGLE)
         {
            return mode == Mode.VS || mode == Mode.ONLINE;
         }
         if(feature == FORCE_SINGLE_PLAYER)
         {
            return mode == Mode.TARGET_TEST || mode == Mode.CLASSIC || mode === Mode.ONLINE_WAITING_ROOM || mode == Mode.CRYSTAL_SMASH || mode == Mode.ALL_STAR || mode == Mode.RACE_TO_THE_FINISH;
         }
         if(feature == HAS_HOME_BUTTON)
         {
            return mode == Mode.TARGET_TEST || mode == Mode.TRAINING || mode == Mode.CLASSIC || mode == Mode.CRYSTAL_SMASH || mode == Mode.ALL_STAR;
         }
         if(feature == ALLOW_CONROL_TYPE)
         {
            return mode == Mode.VS || mode == Mode.ARENA;
         }
         if(feature == ALLOW_SINGLE_PLAYER)
         {
            return mode == Mode.ONLINE || mode === Mode.ONLINE_WAITING_ROOM || mode == Mode.TARGET_TEST || mode == Mode.CLASSIC || mode == Mode.EVENT || mode == Mode.HOME_RUN_CONTEST || mode == Mode.MULTIMAN || mode == Mode.CUSTOM || mode == Mode.CRYSTAL_SMASH || mode == Mode.ONLINE_ARENA || mode == Mode.ALL_STAR || mode == Mode.RACE_TO_THE_FINISH;
         }
         if(feature == ALLOW_PAUSE)
         {
            return mode == Mode.VS || mode == Mode.VS_UNLOCK || mode == Mode.TRAINING || mode == Mode.TARGET_TEST || mode == Mode.CLASSIC || mode == Mode.EVENT || mode == Mode.HOME_RUN_CONTEST || mode == Mode.MULTIMAN || mode == Mode.ARENA || mode == Mode.CUSTOM || mode == Mode.CRYSTAL_SMASH || mode == Mode.ALL_STAR || mode == Mode.RACE_TO_THE_FINISH;
         }
         if(feature == ALLOW_CROWD_CHANTS)
         {
            return mode == Mode.VS || mode === Mode.ONLINE;
         }
         if(feature == ALLOW_NARRATOR_GAME)
         {
            return mode == Mode.VS || mode == Mode.VS_UNLOCK || mode == Mode.CLASSIC || mode == Mode.TARGET_TEST || mode == Mode.CLASSIC || mode == Mode.EVENT || mode == Mode.HOME_RUN_CONTEST || mode == Mode.MULTIMAN || mode == Mode.CUSTOM || mode == Mode.CRYSTAL_SMASH || mode == Mode.ALL_STAR || mode == Mode.RACE_TO_THE_FINISH;
         }
         if(feature == ALLOW_NARRATOR_CPU_DEFEATED)
         {
            return mode == Mode.VS || mode == Mode.VS_UNLOCK || mode == Mode.CLASSIC || mode == Mode.ALL_STAR;
         }
         if(feature == ALLOW_REPLAY_RECORD)
         {
            return mode == Mode.VS || mode == Mode.ONLINE || mode == Mode.ONLINE_ARENA || mode == Mode.ARENA || mode == Mode.TARGET_TEST || mode == Mode.HOME_RUN_CONTEST || mode == Mode.MULTIMAN || mode == Mode.CRYSTAL_SMASH || mode == Mode.RACE_TO_THE_FINISH;
         }
         if(feature == SAVE_RECORDS)
         {
            return mode == Mode.VS || mode == Mode.ONLINE || mode == Mode.ONLINE_ARENA;
         }
         if(feature == OFFSCREEN_DAMAGE)
         {
            return mode == Mode.VS || mode == Mode.VS_UNLOCK || mode == Mode.ONLINE || mode === Mode.ONLINE_WAITING_ROOM;
         }
         if(feature == OFFSCREEN_BUBBLE)
         {
            return mode == Mode.VS || mode == Mode.VS_UNLOCK || mode == Mode.ONLINE || mode === Mode.ONLINE_WAITING_ROOM || mode === Mode.TRAINING || mode === Mode.TARGET_TEST || mode === Mode.EVENT;
         }
         if(feature == FORCE_TWO_PLAYER)
         {
            return false;
         }
         if(feature == IS_CUSTOM)
         {
            return mode == Mode.TARGET_TEST || mode == Mode.CLASSIC || mode == Mode.EVENT || mode == Mode.HOME_RUN_CONTEST || mode == Mode.ARENA || mode == Mode.MULTIMAN || mode == Mode.CUSTOM || mode == Mode.CRYSTAL_SMASH || mode == Mode.ONLINE_ARENA || mode == Mode.ALL_STAR || mode == Mode.RACE_TO_THE_FINISH;
         }
         if(feature == HAS_RETRY_BUTTON)
         {
            return mode == Mode.TARGET_TEST || mode == Mode.EVENT || mode == Mode.HOME_RUN_CONTEST || mode == Mode.MULTIMAN || mode == Mode.CRYSTAL_SMASH || mode == Mode.RACE_TO_THE_FINISH;
         }
         if(feature == ALLOW_TEAM_TOGGLE)
         {
            return mode == Mode.VS || mode == Mode.ONLINE || mode === Mode.ARENA || mode === Mode.ONLINE_ARENA;
         }
         return false;
      }
   }
}

