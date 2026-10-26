package com.mcleodgaming.ssf2.controllers
{
   public class MatchResults
   {
      
      private var m_owner:int;
      
      private var m_rank:int;
      
      private var m_score:int;
      
      private var m_kos:int;
      
      private var m_falls:int;
      
      private var m_selfDestructs:int;
      
      private var m_damageGiven:Number;
      
      private var m_damageRemaining:Number;
      
      private var m_damageTaken:Number;
      
      private var m_peakDamage:Number;
      
      private var m_fastestPitch:Number;
      
      private var m_topSpeed:Number;
      
      private var m_swimTime:int;
      
      private var m_longestDrought:int;
      
      private var m_transformationTime:int;
      
      private var m_finalSmashCount:int;
      
      private var m_stockRemaining:int;
      
      private var m_survivalTime:int;
      
      private var m_koList:Array;
      
      private var m_killerList:Array;
      
      public function MatchResults(owner:int)
      {
         super();
         this.m_owner = owner;
         this.m_rank = 1;
         this.m_score = 0;
         this.m_kos = 0;
         this.m_falls = 0;
         this.m_selfDestructs = 0;
         this.m_damageGiven = 0;
         this.m_damageRemaining = 0;
         this.m_damageTaken = 0;
         this.m_peakDamage = 0;
         this.m_fastestPitch = 0;
         this.m_topSpeed = 0;
         this.m_swimTime = 0;
         this.m_longestDrought = 0;
         this.m_transformationTime = 0;
         this.m_finalSmashCount = 0;
         this.m_koList = new Array();
         this.m_killerList = new Array();
         this.m_stockRemaining = 0;
         this.m_survivalTime = 0;
      }
      
      public function get Owner() : Number
      {
         return this.m_owner;
      }
      
      public function get Rank() : int
      {
         return this.m_rank;
      }
      
      public function set Rank(value:int) : void
      {
         this.m_rank = value;
      }
      
      public function get Score() : int
      {
         return this.m_score;
      }
      
      public function set Score(value:int) : void
      {
         this.m_score = value;
      }
      
      public function get KOs() : int
      {
         return this.m_kos;
      }
      
      public function set KOs(value:int) : void
      {
         this.m_kos = value;
      }
      
      public function get Falls() : int
      {
         return this.m_falls;
      }
      
      public function set Falls(value:int) : void
      {
         this.m_falls = value;
      }
      
      public function get SelfDestructs() : int
      {
         return this.m_selfDestructs;
      }
      
      public function set SelfDestructs(value:int) : void
      {
         this.m_selfDestructs = value;
      }
      
      public function get DamageRemaining() : Number
      {
         return this.m_damageRemaining;
      }
      
      public function set DamageRemaining(value:Number) : void
      {
         this.m_damageRemaining = value;
      }
      
      public function get DamageGiven() : Number
      {
         return this.m_damageGiven;
      }
      
      public function set DamageGiven(value:Number) : void
      {
         this.m_damageGiven = value;
      }
      
      public function get DamageTaken() : Number
      {
         return this.m_damageTaken;
      }
      
      public function set DamageTaken(value:Number) : void
      {
         this.m_damageTaken = value;
      }
      
      public function get PeakDamage() : Number
      {
         return this.m_peakDamage;
      }
      
      public function set PeakDamage(value:Number) : void
      {
         this.m_peakDamage = value;
      }
      
      public function get FastestPitch() : Number
      {
         return this.m_fastestPitch;
      }
      
      public function set FastestPitch(value:Number) : void
      {
         this.m_fastestPitch = value;
      }
      
      public function get TopSpeed() : Number
      {
         return this.m_topSpeed;
      }
      
      public function set TopSpeed(value:Number) : void
      {
         this.m_topSpeed = value;
      }
      
      public function get SwimTime() : int
      {
         return this.m_swimTime;
      }
      
      public function set SwimTime(value:int) : void
      {
         this.m_swimTime = value;
      }
      
      public function get LongestDrought() : int
      {
         return this.m_longestDrought;
      }
      
      public function set LongestDrought(value:int) : void
      {
         this.m_longestDrought = value;
      }
      
      public function get TransformationTime() : int
      {
         return this.m_transformationTime;
      }
      
      public function set TransformationTime(value:int) : void
      {
         this.m_transformationTime = value;
      }
      
      public function get FinalSmashCount() : int
      {
         return this.m_finalSmashCount;
      }
      
      public function set FinalSmashCount(value:int) : void
      {
         this.m_finalSmashCount = value;
      }
      
      public function get StockRemaining() : int
      {
         return this.m_stockRemaining;
      }
      
      public function set StockRemaining(value:int) : void
      {
         this.m_stockRemaining = value;
      }
      
      public function get SurvivalTime() : int
      {
         return this.m_survivalTime;
      }
      
      public function set SurvivalTime(value:int) : void
      {
         this.m_survivalTime = value;
      }
      
      public function get KOList() : Array
      {
         return this.m_koList;
      }
      
      public function set KOList(value:Array) : void
      {
         this.m_koList = value;
      }
      
      public function get KillerList() : Array
      {
         return this.m_killerList;
      }
      
      public function set KillerList(value:Array) : void
      {
         this.m_killerList = value;
      }
      
      public function exportData() : Object
      {
         return {
            "owner":this.m_owner,
            "rank":this.m_rank,
            "score":this.m_score,
            "kos":this.m_kos,
            "falls":this.m_falls,
            "selfDestructs":this.m_selfDestructs,
            "damageGiven":this.m_damageGiven,
            "damageRemaining":this.m_damageRemaining,
            "damageTaken":this.m_damageTaken,
            "peakDamage":this.m_peakDamage,
            "fastestPitch":this.m_fastestPitch,
            "topSpeed":this.m_topSpeed,
            "swimTime":this.m_swimTime,
            "longestDrought":this.m_longestDrought,
            "transformationTime":this.m_transformationTime,
            "finalSmashCount":this.m_finalSmashCount,
            "stockRemaining":this.m_stockRemaining,
            "survivalTime":this.m_survivalTime,
            "koList":this.m_koList,
            "killerList":this.m_killerList
         };
      }
   }
}

