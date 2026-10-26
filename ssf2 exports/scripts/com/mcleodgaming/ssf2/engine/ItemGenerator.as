package com.mcleodgaming.ssf2.engine
{
   import com.mcleodgaming.ssf2.Config;
   import com.mcleodgaming.ssf2.Main;
   import com.mcleodgaming.ssf2.api.SSF2Event;
   import com.mcleodgaming.ssf2.controllers.ItemSettings;
   import com.mcleodgaming.ssf2.enums.*;
   import com.mcleodgaming.ssf2.events.*;
   import com.mcleodgaming.ssf2.items.*;
   import com.mcleodgaming.ssf2.platforms.*;
   import com.mcleodgaming.ssf2.util.*;
   import flash.display.MovieClip;
   import flash.geom.Point;
   
   public class ItemGenerator
   {
      
      private var ROOT:MovieClip;
      
      private var STAGE:MovieClip;
      
      private var STAGEPARENT:MovieClip;
      
      private var STAGEDATA:StageData;
      
      private var m_frequency:int;
      
      private var m_checkEvery:Number;
      
      private var m_chance:Number;
      
      private var m_timer:Number;
      
      private var m_itemsInUse:Vector.<Item>;
      
      private var m_itemIndex:Number;
      
      private var m_item:Vector.<ItemData>;
      
      private var m_itemID:Number;
      
      private var m_sizeRatio:Number;
      
      private var m_lastItem:Item;
      
      private var m_initTimer:Number;
      
      private var m_terrains:Vector.<Platform>;
      
      private var m_platforms:Vector.<Platform>;
      
      private var m_itemGens:Vector.<MovieClip>;
      
      private var m_itemsList:Vector.<ItemData>;
      
      private var m_fullItemsList:Vector.<ItemData>;
      
      private var m_itemCount:int;
      
      private var m_hiddenItemsList:Vector.<String>;
      
      private var m_smashBallReady:FrameTimer;
      
      private var m_suddenDeathBombTimer:FrameTimer;
      
      private var m_smashBallDisabled:Boolean;
      
      private var m_pokemonClass:Class;
      
      private var m_assistClass:Class;
      
      public function ItemGenerator(parameters:Object, stageData:StageData)
      {
         var m:ItemData = null;
         var l:ItemData = null;
         super();
         this.STAGEDATA = stageData;
         this.ROOT = this.STAGEDATA.RootRef;
         this.STAGE = this.STAGEDATA.StageRef;
         this.STAGEPARENT = this.STAGEDATA.StageParentRef;
         this.m_sizeRatio = parameters["sizeRatio"];
         this.m_itemGens = stageData.getItemGens();
         this.m_itemsInUse = new Vector.<Item>();
         if(!Config.enable_items)
         {
            this.Frequency = ItemSettings.FREQUENCY_OFF;
         }
         else
         {
            this.Frequency = parameters["frequency"];
         }
         for(var j:int = 0; j < this.MAXITEMS; j++)
         {
            this.m_itemsInUse[j] = null;
         }
         var sr:Number = this.m_sizeRatio;
         var obj:Array = ItemsListData.DATA;
         var mappings:Object = ResourceManager.getResourceByID("mappings").getProp("metadata");
         var itemsArr:Array = mappings.item_switch_screen.rows;
         var allItems:Array = Utils.flatten(itemsArr as Array);
         var tmpMC:MovieClip = null;
         this.m_hiddenItemsList = new Vector.<String>();
         this.m_itemsList = new Vector.<ItemData>();
         this.m_fullItemsList = new Vector.<ItemData>();
         for(var k:int = 0; k < obj.length; k++)
         {
            if(this.m_hiddenItemsList.indexOf(obj[k].statsName) < 0)
            {
               if(!(!ItemsListData.getItemByID(obj[k].statsName) || allItems.indexOf(obj[k].statsName) < 0 || this.STAGEDATA.GameRef.LevelData.unlocks[obj[k].statsName] === false && (!Main.DEBUG || this.STAGEDATA.ReplayMode || this.STAGEDATA.OnlineMode)))
               {
                  if((this.STAGEDATA.GameRef.Items.items[obj[k].statsName] === undefined || ModeFeatures.hasFeature(ModeFeatures.FORCE_ITEM_AVAILABILITY,this.STAGEDATA.GameRef.GameMode)) && Config.enable_items)
                  {
                     l = new ItemData();
                     l.importData(obj[k]);
                     this.m_itemsList.push(l);
                  }
                  m = new ItemData();
                  m.importData(obj[k]);
                  this.m_fullItemsList.push(m);
                  if(!HitBoxAnimation.AnimationsList[m.LinkageID])
                  {
                     tmpMC = ResourceManager.getLibraryMC(m.LinkageID);
                     if(Boolean(tmpMC))
                     {
                        Utils.removeActionScript(tmpMC);
                        HitBoxAnimation.createHitBoxAnimation(m.LinkageID,tmpMC,tmpMC);
                     }
                  }
               }
            }
         }
         this.m_item = this.getItemTypes(parameters["itemData"]);
         this.m_lastItem = null;
         this.m_itemIndex = 0;
         this.m_itemID = 0;
         this.m_timer = 0;
         this.m_initTimer = 0;
         this.m_itemCount = 0;
         this.m_terrains = this.STAGEDATA.Terrains;
         this.m_platforms = this.STAGEDATA.Platforms;
         this.m_smashBallDisabled = true;
         this.getTerrainData();
         this.m_smashBallReady = new FrameTimer(5);
         this.m_smashBallReady.CurrentTime = this.m_smashBallReady.MaxTime;
         this.m_suddenDeathBombTimer = new FrameTimer(15);
         this.m_pokemonClass = null;
         this.m_assistClass = null;
      }
      
      public function getTerrainData() : void
      {
      }
      
      public function testTerrainWithCoord(xpos:Number, ypos:Number) : Platform
      {
         var i:int = 0;
         i = 0;
         while(i < this.m_terrains.length && this.m_terrains[i].hitTestPoint(xpos,ypos,true))
         {
            i++;
         }
         if(i < this.m_terrains.length && this.m_terrains[i].hitTestPoint(xpos,ypos,true))
         {
            return this.m_terrains[i];
         }
         return null;
      }
      
      private function checkItem() : void
      {
         this.m_smashBallReady.tick();
         this.checkDeadItems();
         if(this.m_chance > 0)
         {
            ++this.m_timer;
            if(this.m_timer > this.m_checkEvery * 30)
            {
               this.m_timer = 0;
               if(Utils.random() < this.m_chance)
               {
                  this.generateItem();
               }
            }
         }
      }
      
      public function checkDeadItems() : void
      {
         for(var i:int = 0; i < this.m_itemsInUse.length; i++)
         {
            if(this.m_itemsInUse[i] != null && this.m_itemsInUse[i].Dead)
            {
               this.killItem(i);
            }
            else if(this.m_itemsInUse[i] != null && this.m_itemsInUse[i].LinkageID == "smashball")
            {
            }
         }
      }
      
      public function totalOfItemName(linkage:String) : int
      {
         var total:int = 0;
         for(var i:int = 0; i < this.m_itemsInUse.length; i++)
         {
            if(Boolean(this.m_itemsInUse[i]) && this.m_itemsInUse[i].LinkageID == linkage)
            {
               total++;
            }
         }
         return total;
      }
      
      public function totalOfItemStatsName(statsName:String) : int
      {
         var total:int = 0;
         for(var i:int = 0; i < this.m_itemsInUse.length; i++)
         {
            if(Boolean(this.m_itemsInUse[i]) && this.m_itemsInUse[i].ItemStats.StatsName == statsName)
            {
               total++;
            }
         }
         return total;
      }
      
      public function totalOfItem(itemType:Class) : int
      {
         var total:int = 0;
         for(var i:int = 0; i < this.m_itemsInUse.length; i++)
         {
            if(Boolean(this.m_itemsInUse[i]) && this.m_itemsInUse[i] is itemType)
            {
               total++;
            }
         }
         return total;
      }
      
      public function makeItem(x:Number, y:Number, mustBeAvailable:Boolean = false, showSparkle:Boolean = true) : Item
      {
         var i:int = 0;
         var availableItemObjs:Array = new Array();
         if(mustBeAvailable)
         {
            for(i = 0; i < this.m_itemsList.length; i++)
            {
               availableItemObjs.push(this.m_itemsList[i]);
            }
         }
         else
         {
            for(i = 0; i < this.m_fullItemsList.length; i++)
            {
               availableItemObjs.push(this.m_fullItemsList[i]);
            }
         }
         if(availableItemObjs.length > 0 && Boolean(this.generateItemObj(availableItemObjs[Utils.randomInteger(0,availableItemObjs.length - 1)],1337,1337,false,showSparkle)))
         {
            this.m_lastItem.ItemInstance.x = x;
            this.m_lastItem.ItemInstance.y = y;
            if(this.m_lastItem.ItemStats.StatsName !== "smashball")
            {
               this.m_lastItem.setYSpeed(-8);
            }
            return this.m_lastItem;
         }
         return null;
      }
      
      private function generateItem() : Boolean
      {
         if(this.generateItemNum(Utils.randomInteger(0,this.m_item.length - 1)))
         {
            this.playGlobalSound("item_spawn");
            return true;
         }
         return false;
      }
      
      public function getItemByLinkage(linkage:String, mustBeAvailable:Boolean = false) : ItemData
      {
         var i:int = 0;
         if(mustBeAvailable)
         {
            for(i = 0; i < this.m_itemsList.length; i++)
            {
               if(this.m_itemsList[i].LinkageID == linkage || this.m_itemsList[i].StatsName == linkage)
               {
                  return this.m_itemsList[i];
               }
            }
         }
         else
         {
            for(i = 0; i < this.m_fullItemsList.length; i++)
            {
               if(this.m_fullItemsList[i].LinkageID == linkage || this.m_fullItemsList[i].StatsName == linkage)
               {
                  return this.m_fullItemsList[i];
               }
            }
         }
         return null;
      }
      
      public function generateItemObj(itemObj:ItemData, xloc:Number = 1337, yloc:Number = -1337, isCustom:Boolean = false, showSparkle:Boolean = true) : Item
      {
         var classType:Class = null;
         var genLocation:MovieClip = null;
         if(Boolean(itemObj && this.m_itemIndex < this.m_itemsInUse.length) && (Boolean(this.m_itemGens.length > 0 || xloc != 1337 && yloc != -1337)) && (this.validateItemObj(itemObj) || isCustom))
         {
            this.killItem(this.m_itemIndex);
            ++this.m_itemCount;
            classType = itemObj.ClassID != null ? Main.getClassByName(itemObj.ClassID) : Item;
            this.m_lastItem = new classType(itemObj,this.m_itemIndex,this.STAGEDATA);
            ++this.m_itemID;
            this.m_itemsInUse[this.m_itemIndex] = this.m_lastItem;
            this.STAGEDATA.EventManagerObj.dispatchEvent(new SSF2Event(SSF2Event.GAME_ITEM_CREATED,{
               "item":this.m_lastItem.APIInstance.instance,
               "auto":false
            }));
            if(xloc != 1337 && yloc != -1337)
            {
               this.m_lastItem.ItemInstance.x = xloc;
               this.m_lastItem.ItemInstance.y = yloc;
               while(Boolean(this.testTerrainWithCoord(this.m_lastItem.ItemInstance.x,this.m_lastItem.ItemInstance.y)))
               {
                  --this.m_lastItem.ItemInstance.y;
               }
            }
            else if(!this.m_lastItem.IsSmashBall)
            {
               genLocation = this.m_itemGens[Math.round(Utils.random() * (this.m_itemGens.length - 1))];
               this.m_lastItem.ItemInstance.x = Utils.random() * (genLocation.x + genLocation.width - genLocation.x) + genLocation.x;
               this.m_lastItem.ItemInstance.y = genLocation.y;
               while(Boolean(this.testTerrainWithCoord(this.m_lastItem.ItemInstance.x,this.m_lastItem.ItemInstance.y)))
               {
                  --this.m_lastItem.ItemInstance.y;
               }
            }
            if(showSparkle)
            {
               this.m_lastItem.attachEffect(this.m_lastItem.ItemStats.SpawnEffect);
            }
            this.incrementItemSlot();
            return this.m_lastItem;
         }
         return null;
      }
      
      public function generateItemNum(itemNum:Number, xloc:Number = 1337, yloc:Number = -1337, isCustom:Boolean = false) : Boolean
      {
         var tempObj:ItemData = null;
         var classType:Class = null;
         var genLocation:MovieClip = null;
         if(this.m_itemIndex < this.m_itemsInUse.length && (this.m_itemGens.length > 0 || xloc != 1337 && yloc != -1337) && (this.validateItemNum(itemNum) || isCustom))
         {
            tempObj = this.m_item[itemNum];
            if(tempObj.LinkageID == "capsule_ex" && Utils.random() > 0.25)
            {
               tempObj = this.getItemByLinkage("capsule");
            }
            classType = tempObj.ClassID != null ? Main.getClassByName(tempObj.ClassID) : Item;
            ++this.m_itemCount;
            this.m_lastItem = new classType(tempObj,this.m_itemIndex,this.STAGEDATA);
            this.STAGEDATA.EventManagerObj.dispatchEvent(new SSF2Event(SSF2Event.GAME_ITEM_CREATED,{
               "item":this.m_lastItem.APIInstance.instance,
               "auto":true
            }));
            ++this.m_itemID;
            if(xloc != 1337 && yloc != -1337)
            {
               this.m_lastItem.ItemInstance.x = xloc;
               this.m_lastItem.ItemInstance.y = yloc;
               while(Boolean(this.testTerrainWithCoord(this.m_lastItem.ItemInstance.x,this.m_lastItem.ItemInstance.y)))
               {
                  --this.m_lastItem.ItemInstance.y;
               }
            }
            else if(!this.m_lastItem.IsSmashBall)
            {
               genLocation = this.m_itemGens[Math.round(Utils.random() * (this.m_itemGens.length - 1))];
               this.m_lastItem.ItemInstance.x = Utils.random() * (genLocation.x + genLocation.width - genLocation.x) + genLocation.x;
               this.m_lastItem.ItemInstance.y = genLocation.y;
               while(Boolean(this.testTerrainWithCoord(this.m_lastItem.ItemInstance.x,this.m_lastItem.ItemInstance.y)))
               {
                  --this.m_lastItem.ItemInstance.y;
               }
            }
            this.m_lastItem.attachEffect(this.m_lastItem.ItemStats.SpawnEffect);
            this.m_itemsInUse[this.m_itemIndex] = this.m_lastItem;
            this.incrementItemSlot();
            return true;
         }
         return false;
      }
      
      public function getRandomLocation() : Point
      {
         return new Point(Utils.random() * (this.STAGEDATA.SmashBallBounds.x + this.STAGEDATA.SmashBallBounds.width - this.STAGEDATA.SmashBallBounds.x) + this.STAGEDATA.SmashBallBounds.x,Utils.random() * (this.STAGEDATA.SmashBallBounds.y + this.STAGEDATA.SmashBallBounds.height - this.STAGEDATA.SmashBallBounds.y) + this.STAGEDATA.SmashBallBounds.y);
      }
      
      private function incrementItemSlot() : void
      {
         ++this.m_itemIndex;
         if(this.m_itemIndex >= this.MAXITEMS)
         {
            this.m_itemIndex = 0;
         }
         if(this.m_itemIndex < this.m_item.length && this.m_item[this.m_itemIndex] != null && this.m_item[this.m_itemIndex].LinkageID == "smashball")
         {
            ++this.m_itemIndex;
            if(this.m_itemIndex >= this.MAXITEMS)
            {
               this.m_itemIndex = 0;
            }
         }
      }
      
      private function validateItemNum(num:Number) : Boolean
      {
         return num >= 0 && num < this.m_item.length && this.validateItemObj(this.m_item[num]);
      }
      
      private function validateItemObj(obj:ItemData) : Boolean
      {
         var i:* = undefined;
         var j:int = 0;
         var index:Number = NaN;
         var flag:Boolean = true;
         if(obj == null || obj.SpawnLimit >= 0 && this.totalOfItemStatsName(obj.StatsName) >= obj.SpawnLimit)
         {
            return false;
         }
         if(obj.LinkageID == "smashball")
         {
            for(i in this.m_itemsInUse)
            {
               if(this.m_itemsInUse[i] != null && this.m_itemsInUse[i].ItemStats.StatsName == "smashball")
               {
                  flag = false;
               }
            }
            for(j = 0; j < this.STAGEDATA.Characters.length; j++)
            {
               if(this.STAGEDATA.Characters[j].UsingFinalSmash || this.STAGEDATA.Characters[j].HasFinalSmash)
               {
                  flag = false;
               }
            }
            if(!this.m_smashBallReady.IsComplete)
            {
               flag = false;
            }
            if(!this.m_smashBallDisabled)
            {
               flag = false;
            }
         }
         if(flag && this.m_itemsInUse[this.m_itemIndex] != null)
         {
            index = this.m_itemIndex + 1;
            if(index >= this.MAXITEMS)
            {
               index = 0;
            }
            while(this.m_itemIndex != index && this.m_itemsInUse[index] != null)
            {
               index++;
               if(index >= this.MAXITEMS)
               {
                  index = 0;
               }
            }
            if(this.m_itemIndex == index)
            {
               flag = false;
            }
            else
            {
               this.m_itemIndex = index;
            }
         }
         return flag;
      }
      
      public function get SmashBallDisabled() : Boolean
      {
         return this.m_smashBallDisabled;
      }
      
      public function set SmashBallDisabled(value:Boolean) : void
      {
         this.m_smashBallDisabled = value;
      }
      
      public function get Frequency() : int
      {
         return this.m_chance;
      }
      
      public function set Frequency(value:int) : void
      {
         this.m_frequency = value;
         switch(value)
         {
            case 1:
               this.m_checkEvery = 10;
               this.m_chance = 0.1;
               break;
            case 2:
               this.m_checkEvery = 10;
               this.m_chance = 0.25;
               break;
            case 3:
               this.m_checkEvery = 10;
               this.m_chance = 0.5;
               break;
            case 4:
               this.m_checkEvery = 5;
               this.m_chance = 0.25;
               break;
            case 5:
               this.m_checkEvery = 5;
               this.m_chance = 0.5;
               break;
            case 6:
               this.m_checkEvery = 4;
               this.m_chance = 0.65;
               break;
            case 7:
               this.m_checkEvery = 4;
               this.m_chance = 0.75;
               break;
            case 8:
               this.m_checkEvery = 3;
               this.m_chance = 1;
               break;
            default:
               this.m_checkEvery = 0;
               this.m_chance = 0;
         }
      }
      
      public function get MAXITEMS() : Number
      {
         return 30;
      }
      
      public function get ItemsList() : Vector.<ItemData>
      {
         return this.m_itemsList;
      }
      
      public function get FullItemsList() : Vector.<ItemData>
      {
         return this.m_fullItemsList;
      }
      
      public function get ItemsInUse() : Vector.<Item>
      {
         return this.m_itemsInUse;
      }
      
      public function get CanMakeItem() : Boolean
      {
         return this.m_itemCount < this.MAXITEMS;
      }
      
      public function get SmashBallReady() : FrameTimer
      {
         return this.m_smashBallReady;
      }
      
      public function get CurrentSmashBall() : Item
      {
         var j:* = undefined;
         for(var i:int = 0; i < this.STAGEDATA.Characters.length; i++)
         {
            if(this.STAGEDATA.Characters[i].UsingFinalSmash || this.STAGEDATA.Characters[i].HasFinalSmash)
            {
               return null;
            }
         }
         for(j in this.m_itemsInUse)
         {
            if(this.m_itemsInUse[j] != null && this.m_itemsInUse[j].ItemStats.StatsName == "smashball")
            {
               return this.m_itemsInUse[j];
            }
         }
         return null;
      }
      
      public function get PlayerUsingSmashBall() : Character
      {
         for(var i:int = 0; i < this.STAGEDATA.Characters.length; i++)
         {
            if(this.STAGEDATA.Characters[i].UsingFinalSmash)
            {
               return this.STAGEDATA.Characters[i];
            }
         }
         return null;
      }
      
      public function get PlayerHasSmashBall() : Character
      {
         for(var i:int = 0; i < this.STAGEDATA.Characters.length; i++)
         {
            if(this.STAGEDATA.Characters[i].HasFinalSmash)
            {
               return this.STAGEDATA.Characters[i];
            }
         }
         return null;
      }
      
      public function get AssistClass() : Class
      {
         return this.m_assistClass;
      }
      
      public function set AssistClass(assist:Class) : void
      {
         this.m_assistClass = assist;
      }
      
      public function get PokemonClass() : Class
      {
         return this.m_pokemonClass;
      }
      
      public function set PokemonClass(pokemon:Class) : void
      {
         this.m_pokemonClass = pokemon;
      }
      
      public function addCustomItem(itemData:ItemData) : void
      {
         this.m_itemsList.push(itemData);
         this.m_fullItemsList.push(itemData);
      }
      
      public function getItemData(index:int) : Item
      {
         if(index >= 0 && index < this.MAXITEMS)
         {
            return this.m_itemsInUse[index];
         }
         return null;
      }
      
      public function getItemByUID(id:int) : Item
      {
         for(var i:int = 0; i < this.m_itemsInUse.length; i++)
         {
            if(Boolean(this.m_itemsInUse[i]) && this.m_itemsInUse[i].UID == id)
            {
               return this.m_itemsInUse[i];
            }
         }
         return null;
      }
      
      public function getItemByMC(mc:MovieClip) : Item
      {
         for(var i:int = 0; i < this.m_itemsInUse.length; i++)
         {
            if(Boolean(this.m_itemsInUse[i]) && (this.m_itemsInUse[i].MC == mc || this.m_itemsInUse[i].Stance != null && this.m_itemsInUse[i].Stance == mc))
            {
               return this.m_itemsInUse[i];
            }
         }
         return null;
      }
      
      public function killItem(index:Number) : void
      {
         if(this.m_itemsInUse[index] != null)
         {
            this.m_itemsInUse[index].destroy();
            this.m_itemsInUse[index] = null;
            --this.m_itemCount;
         }
      }
      
      public function killAllItems() : void
      {
         for(var i:int = 0; i < this.m_itemsInUse.length; i++)
         {
            if(this.m_itemsInUse[i] != null)
            {
               this.m_itemsInUse[i].destroy();
               this.m_itemsInUse[i] = null;
            }
         }
      }
      
      private function getItemTypes(itemData:Object) : Vector.<ItemData>
      {
         return this.m_itemsList;
      }
      
      public function playGlobalSound(soundID:String) : void
      {
         this.STAGEDATA.SoundQueueRef.playSoundEffect(soundID);
      }
      
      private function checkSuddenDeathBombs() : void
      {
         var itemData:ItemData = null;
         var item:Item = null;
         if(this.STAGEDATA.GameRef.SuddenDeath && this.STAGEDATA.ElapsedFrames >= 60 * 10)
         {
            this.m_suddenDeathBombTimer.tick();
            if(this.m_suddenDeathBombTimer.IsComplete)
            {
               this.m_suddenDeathBombTimer.reset();
               itemData = new ItemData();
               itemData.importData(ItemsListData.getItemByID("bobomb"));
               item = this.generateItemObj(itemData);
               item.Toss(item.X,item.Y,0,0);
            }
         }
      }
      
      public function PERFORMALL() : void
      {
         this.checkSuddenDeathBombs();
         this.checkItem();
      }
   }
}

