package com.mcleodgaming.ssf2.util
{
   public class DataSettings
   {
      
      public var controls:Boolean;
      
      public var options:Boolean;
      
      public var records:Boolean;
      
      public var unlocks:Boolean;
      
      public var saveFileVersion:String;
      
      public function DataSettings(controls:Boolean = true, options:Boolean = true, records:Boolean = true, unlocks:Boolean = true)
      {
         super();
         this.controls = controls;
         this.options = options;
         this.records = records;
         this.unlocks = unlocks;
         this.saveFileVersion = null;
      }
   }
}

