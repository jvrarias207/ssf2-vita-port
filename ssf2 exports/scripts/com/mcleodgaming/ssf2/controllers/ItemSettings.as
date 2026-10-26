package com.mcleodgaming.ssf2.controllers
{
   public class ItemSettings
   {
      
      public static const FREQUENCY_OFF:int = 0;
      
      public static const FREQUENCY_VERY_LOW:int = 1;
      
      public static const FREQUENCY_LOW:int = 2;
      
      public static const FREQUENCY_MEDIUM:int = 3;
      
      public static const FREQUENCY_HIGH:int = 4;
      
      public static const FREQUENCY_VERY_HIGH:int = 5;
      
      public static const FREQUENCY_SUPER_HIGH:int = 6;
      
      public static const FREQUENCY_ULTRA_HIGH:int = 7;
      
      public static const FREQUENCY_MAX:int = 8;
      
      public var frequency:int;
      
      public var items:Object;
      
      public function ItemSettings()
      {
         super();
         this.frequency = ItemSettings.FREQUENCY_HIGH;
         this.items = {};
      }
      
      public function setAllItemStatuses(status:Boolean) : void
      {
         var i:* = undefined;
         for(i in this.items)
         {
            this.items[i] = status;
         }
      }
      
      public function exportSettings() : Object
      {
         return {
            "frequency":this.frequency,
            "items":JSON.parse(JSON.stringify(this.items))
         };
      }
      
      public function importSettings(data:Object) : void
      {
         var obj:* = undefined;
         for(obj in data)
         {
            if(this[obj] !== undefined)
            {
               this[obj] = data[obj];
            }
            else
            {
               trace("You tried to set \"" + obj + "\" but it doesn\'t exist in the GameSetting class.");
            }
         }
      }
   }
}

