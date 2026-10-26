package com.mcleodgaming.ssf2.engine
{
   import com.mcleodgaming.ssf2.Version;
   import com.mcleodgaming.ssf2.enums.Mode;
   
   public class ReplayData
   {
      
      public static var COMPATIBLE_VERSIONS:Array = [];
      
      private var m_frameCount:int;
      
      private var m_name:String;
      
      private var m_version:String;
      
      private var m_gameMode:int;
      
      private var m_randSeed:Number;
      
      private var m_matchSettings:Object;
      
      private var m_itemSettings:Object;
      
      private var m_playerData:Array;
      
      private var m_controlsData:Array;
      
      private var m_controlsPointers:Array;
      
      private var m_timestamp:Date;
      
      public function ReplayData(playerSize:int)
      {
         super();
         var i:int = 0;
         this.m_frameCount = 0;
         this.m_name = "Untitled Replay";
         this.m_version = Version.getVersion();
         this.m_gameMode = Mode.VS;
         this.m_randSeed = 0;
         this.m_matchSettings = new Object();
         this.m_itemSettings = new Object();
         this.m_playerData = new Array();
         this.m_controlsData = [];
         this.m_timestamp = new Date();
         for(i = 0; i < playerSize; i++)
         {
            this.m_controlsData.push([]);
         }
         this.m_controlsPointers = null;
      }
      
      public function get FrameCount() : int
      {
         return this.m_frameCount;
      }
      
      public function set FrameCount(value:int) : void
      {
         this.m_frameCount = value;
      }
      
      public function get Name() : String
      {
         return this.m_name;
      }
      
      public function set Name(value:String) : void
      {
         this.m_name = value;
      }
      
      public function get VersionNumber() : String
      {
         return this.m_version;
      }
      
      public function get GameMode() : int
      {
         return this.m_gameMode;
      }
      
      public function set GameMode(value:int) : void
      {
         this.m_gameMode = value;
      }
      
      public function get MatchSettings() : Object
      {
         return this.m_matchSettings;
      }
      
      public function set MatchSettings(value:Object) : void
      {
         this.m_matchSettings = value;
      }
      
      public function get ItemSettingsObj() : Object
      {
         return this.m_itemSettings;
      }
      
      public function set ItemSettingsObj(value:Object) : void
      {
         this.m_itemSettings = value;
      }
      
      public function get PlayerData() : Array
      {
         return this.m_playerData;
      }
      
      public function set PlayerData(value:Array) : void
      {
         this.m_playerData = value;
      }
      
      public function get ControlsData() : Array
      {
         return this.m_controlsData;
      }
      
      public function get Timestamp() : Date
      {
         return this.m_timestamp;
      }
      
      public function set Timestamp(value:Date) : void
      {
         this.m_timestamp = value;
      }
      
      public function resetPointers() : void
      {
         this.m_controlsPointers = new Array();
         for(var i:int = 0; i < this.m_controlsData.length; i++)
         {
            this.m_controlsPointers.push({
               "index":0,
               "total":(Boolean(this.m_controlsData[i].length) ? this.m_controlsData[i][1] : 0)
            });
         }
      }
      
      public function pushControls(pid:int, controls:int) : void
      {
         if(this.m_controlsData[pid - 1].length <= 0 || controls != this.m_controlsData[pid - 1][this.m_controlsData[pid - 1].length - 2])
         {
            this.m_controlsData[pid - 1].push(controls);
            this.m_controlsData[pid - 1].push(1);
         }
         else
         {
            ++this.m_controlsData[pid - 1][this.m_controlsData[pid - 1].length - 1];
         }
      }
      
      public function retrieveControls(pid:int) : int
      {
         return this.m_controlsData[pid - 1][this.m_controlsPointers[pid - 1].index];
      }
      
      public function nextControls() : void
      {
         for(var i:int = 0; i < this.m_controlsPointers.length; i++)
         {
            if(Boolean(this.m_controlsData[i].length))
            {
               --this.m_controlsPointers[i].total;
               if(this.m_controlsPointers[i].total <= 0)
               {
                  this.m_controlsPointers[i].index += 2;
                  if(this.m_controlsPointers[i].index < this.m_controlsData[i].length)
                  {
                     this.m_controlsPointers[i].total = this.m_controlsData[i][this.m_controlsPointers[i].index + 1];
                  }
               }
            }
         }
      }
      
      public function exportReplay() : String
      {
         var obj:Object = new Object();
         obj.version = this.m_version;
         obj.compatibleVersions = [];
         obj.frameCount = this.m_frameCount;
         obj.name = this.m_name;
         obj.gameMode = this.m_gameMode;
         obj.randSeed = this.m_randSeed;
         obj.matchSettings = this.m_matchSettings;
         obj.itemSettings = this.m_itemSettings;
         obj.playerSettings = this.m_playerData;
         obj.timestamp = this.m_timestamp;
         var uncompressedData:Array = this.unoptimizeData(this.m_controlsData);
         var i:int = 0;
         var optimizedTotal:int = 0;
         var rawTotal:int = 0;
         rawTotal = JSON.stringify(uncompressedData).length;
         optimizedTotal = JSON.stringify(this.m_controlsData).length;
         if(rawTotal < optimizedTotal)
         {
            obj.optimized = false;
            obj.controlsData = uncompressedData;
         }
         else
         {
            obj.optimized = true;
            obj.controlsData = this.m_controlsData;
         }
         return JSON.stringify(obj);
      }
      
      private function unoptimizeData(data:Array) : Array
      {
         var total:int = 0;
         var i:int = 0;
         var j:int = 0;
         var rawData:Array = [];
         for(i = 0; i < this.m_controlsData.length; i++)
         {
            rawData.push([]);
         }
         for(i = 0; i < this.m_controlsData.length; i++)
         {
            for(j = 0; j < this.m_controlsData[i].length; j += 2)
            {
               total = int(this.m_controlsData[i][j + 1]);
               while(total > 0)
               {
                  rawData[i].push(this.m_controlsData[i][j]);
                  total--;
               }
            }
         }
         return rawData;
      }
      
      public function importReplay(str:String) : void
      {
         var rawArr:Array = null;
         var i:int = 0;
         var j:int = 0;
         var obj:Object = JSON.parse(str);
         this.m_version = obj.version;
         this.m_frameCount = obj.frameCount;
         this.m_name = obj.name;
         this.m_gameMode = obj.gameMode;
         this.m_randSeed = obj.randSeed;
         this.m_matchSettings = obj.matchSettings;
         this.m_itemSettings = obj.itemSettings;
         this.m_playerData = obj.playerSettings;
         this.m_controlsData = obj.controlsData;
         this.m_timestamp = new Date(obj.timestamp);
         if(!obj.optimized)
         {
            rawArr = this.m_controlsData;
            this.m_controlsData = new Array();
            for(i = 0; i < this.m_playerData.length; i++)
            {
               this.m_controlsData.push([]);
            }
            for(j = 0; i < rawArr.length; i++)
            {
               for(j = 0; j < rawArr[i].length; j++)
               {
                  this.pushControls(i + 1,rawArr[i][j]);
               }
            }
         }
      }
   }
}

