package com.mcleodgaming.ssf2.engine
{
   import com.mcleodgaming.ssf2.Main;
   import com.mcleodgaming.ssf2.util.*;
   
   public class Stats
   {
      
      private static var m_expansions:Vector.<Vector.<CharacterData>>;
      
      private static var m_statObjects:Object = new Object();
      
      public function Stats()
      {
         super();
      }
      
      public static function init() : void
      {
         var k:* = undefined;
         var i:int = 0;
         var j:int = 0;
         var mappings:Object = ResourceManager.getResourceByID("mappings").getProp("metadata");
         for(k in mappings.character)
         {
            Stats.writeStats({"cData":{
               "statsName":k,
               "displayName":mappings.character[k].name,
               "seriesIcon":mappings.character[k].seriesIcon || null
            }});
         }
         for(k in mappings.character)
         {
            ResourceManager.addResource(new Resource(k,mappings.character[k].file,mappings.character[k].file_pub,mappings.character[k].guid,Resource.CHARACTER));
            ResourceManager.manifestJSONData.character[k] = mappings.character[k];
         }
         for(k in mappings.stage)
         {
            ResourceManager.addResource(new Resource(k,mappings.stage[k].file,mappings.stage[k].file_pub,mappings.stage[k].guid,Resource.STAGE));
            ResourceManager.manifestJSONData.stage[k] = mappings.stage[k];
         }
         for(k in mappings.music)
         {
            ResourceManager.addResource(new Resource(k,mappings.music[k].file,mappings.music[k].file_pub,mappings.music[k].guid,Resource.MUSIC));
            ResourceManager.manifestJSONData.music[k] = mappings.music[k];
         }
         for(k in mappings.extra)
         {
            ResourceManager.addResource(new Resource(k,mappings.extra[k].file,mappings.extra[k].file_pub,mappings.extra[k].guid,Resource.EXTRA));
            ResourceManager.manifestJSONData.extra[k] = mappings.extra[k];
         }
         Stats.m_expansions = new Vector.<Vector.<CharacterData>>();
         while(ResourceManager.getExpansionCharacter(i) != null)
         {
            j = 0;
            m_expansions[i] = new Vector.<CharacterData>();
            while(ResourceManager.getExpansionCharacterObject(i,j) != null)
            {
               if(!Stats.loadExpansionData(i,ResourceManager.getExpansionCharacterObject(i,j)))
               {
                  trace("Failed loading expansion id No. " + i);
               }
               j++;
            }
            i++;
         }
      }
      
      public static function writeStats(data:Object) : void
      {
         data ||= {};
         var charName:String = Boolean(data.cData) ? data.cData.statsName : null;
         if(Boolean(charName))
         {
            if(Stats.m_statObjects[charName] == undefined)
            {
               Stats.m_statObjects[charName] = new Object();
            }
            if(Boolean(data.cData))
            {
               Stats.m_statObjects[charName].cData = data.cData;
            }
            if(Boolean(data.aData))
            {
               Stats.m_statObjects[charName].aData = data.aData;
            }
            if(Boolean(data.pData))
            {
               Stats.m_statObjects[charName].pData = data.pData;
            }
            if(Boolean(data.iData))
            {
               Stats.m_statObjects[charName].iData = data.iData;
            }
         }
      }
      
      public static function getStats(charName:String, expansionID:Number = -1) : CharacterData
      {
         if(expansionID >= 0)
         {
            return Stats.getExpansionData(expansionID,charName);
         }
         return createCharacterDataFrom(Stats.m_statObjects[charName]);
      }
      
      public static function clearStats(charName:String) : void
      {
         m_statObjects[charName] = {"cData":{
            "displayName":m_statObjects[charName].cData.displayName,
            "seriesIcon":m_statObjects[charName].cData.seriesIcon,
            "statsName":m_statObjects[charName].cData.statsName
         }};
      }
      
      private static function loadExpansionData(id:int, expObj:Object) : Boolean
      {
         var parameters:Object = null;
         var exp:CharacterData = null;
         try
         {
            parameters = expObj;
            exp = Stats.createCharacterDataFrom({
               "cData":parameters.cData,
               "aData":parameters.aData,
               "pData":parameters.pData,
               "iData":parameters.iData
            });
            Stats.m_expansions[id].push(exp);
         }
         catch(error:Error)
         {
            trace("Error loading expansion data");
            return false;
         }
         return true;
      }
      
      private static function createCharacterDataFrom(data:Object) : CharacterData
      {
         var obj:Object = null;
         var tmp:CharacterData = new CharacterData();
         data ||= {};
         var cData:Object = data.cData || {};
         var aData:Object = data.aData || {};
         var pData:Object = data.pData || {};
         var iData:Object = data.iData || {};
         if(Stats.m_statObjects[cData.statsName] != null)
         {
            obj = Stats.m_statObjects[cData.statsName];
            tmp.importData(obj.cData);
            tmp.importAttacks(obj.aData);
            tmp.addProjectiles(obj.pData);
            tmp.addItems(obj.iData);
         }
         else if(data.aData != null)
         {
            tmp.importData(cData);
            tmp.importAttacks(aData);
            tmp.addProjectiles(pData);
            tmp.addItems(iData);
         }
         else
         {
            tmp.importData(cData);
         }
         return tmp;
      }
      
      private static function getExpansionData(idNum:Number, charName:String = null) : CharacterData
      {
         var i:Number = NaN;
         if(idNum < 0 || idNum >= Stats.m_expansions.length || Stats.m_expansions.length == 0)
         {
            return null;
         }
         if(charName != null && charName != "xp")
         {
            for(i = idNum; i < Stats.m_expansions.length; i++)
            {
               if(Stats.m_expansions[i][0].StatsName == charName)
               {
                  return Stats.m_expansions[i][0];
               }
            }
            return null;
         }
         return Stats.m_expansions[idNum][0];
      }
      
      public static function getRandomCharacter(hideLocked:Boolean = true) : CharacterData
      {
         var chars:Array = getCharacterList(hideLocked);
         var charName:String = chars[Utils.randomInteger(0,chars.length - 1)];
         return Stats.getStats(charName);
      }
      
      public static function getCharacterList(hideLocked:Boolean = true, hideDebug:Boolean = true) : Array
      {
         var chars:Array = new Array();
         var mappings:Object = ResourceManager.getResourceByID("mappings").getProp("metadata");
         var charactersObj:Array = mappings.random_characters.characters;
         for(var i:int = 0; i < charactersObj.length; i++)
         {
            if(Main.DEBUG || !hideLocked || hideLocked && SaveData.Unlocks[charactersObj[i]] !== false)
            {
               chars.push(charactersObj[i]);
            }
         }
         return chars;
      }
   }
}

