package com.mcleodgaming.ssf2.items
{
   import com.mcleodgaming.ssf2.engine.*;
   import com.mcleodgaming.ssf2.util.*;
   
   public class ItemsListData
   {
      
      public static var OBJECTS:Object;
      
      public static var DATA:Array = null;
      
      public function ItemsListData()
      {
         super();
      }
      
      public static function init() : void
      {
         DATA = ResourceManager.getItemStats();
         OBJECTS = {};
         for(var i:int = 0; i < DATA.length; i++)
         {
            OBJECTS[DATA[i].statsName] = DATA[i];
         }
      }
      
      public static function getItemByID(id:String) : Object
      {
         return Boolean(OBJECTS[id]) ? OBJECTS[id] : null;
      }
      
      public static function getItemStatsList(includeHidden:Boolean = true, includeDisabled:Boolean = true) : Array
      {
         var list:Array = [];
         var statsCopy:Array = ResourceManager.getItemStats();
         for(var i:int = 0; i < statsCopy.length; i++)
         {
            if((includeDisabled || SaveData.ItemDataObj[statsCopy[i].statsName] === undefined) && (includeHidden || SaveData.Unlocks[statsCopy[i].statsName] !== false))
            {
               list.push(statsCopy[i]);
            }
         }
         return list;
      }
      
      public static function getRandomItemStats(includeHidden:Boolean = true, includeDisabled:Boolean = true) : Object
      {
         var list:Array = ItemsListData.getItemStatsList(includeHidden,includeDisabled);
         return list.length === 0 ? null : list[Utils.randomInteger(0,list.length)];
      }
   }
}

