package com.mcleodgaming.ssf2.menus
{
   import com.mcleodgaming.ssf2.Main;
   import com.mcleodgaming.ssf2.audio.*;
   import com.mcleodgaming.ssf2.controllers.*;
   import com.mcleodgaming.ssf2.items.ItemsListData;
   import com.mcleodgaming.ssf2.util.*;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   
   public class ItemSwitchMenu extends Menu
   {
      
      private var selectHand:ItemSwitchHand;
      
      private var buttonList:Vector.<ItemButton> = new Vector.<ItemButton>();
      
      private var m_itemMCHash:Object;
      
      private var m_disabledItemHash:Object;
      
      private var m_itemTable:DisplayObjectTable;
      
      public function ItemSwitchMenu()
      {
         var child:MovieClip = null;
         var mc:MovieClip = null;
         super();
         m_subMenu = ResourceManager.getLibraryMC("menu_itemswitch");
         m_backgroundID = "space";
         this.buttonList = new Vector.<ItemButton>();
         var i:int = 0;
         var j:int = 0;
         var itemObjects:Object = ItemsListData.OBJECTS;
         var mappings:Object = ResourceManager.getResourceByID("mappings").getProp("metadata");
         var itemsArr:Array = mappings.item_switch_screen.rows;
         var allItems:Array = Utils.flatten(itemsArr as Array);
         this.m_itemMCHash = {};
         this.m_disabledItemHash = {};
         for(i = 0; i < this.ItemSwitchIconsMC.numChildren; i++)
         {
            if(this.ItemSwitchIconsMC.getChildAt(i) is MovieClip)
            {
               child = MovieClip(this.ItemSwitchIconsMC.getChildAt(i));
               child.parent.removeChild(child);
               i--;
            }
         }
         for(i = 0; i < allItems.length; i++)
         {
            child = MovieClip(ResourceManager.getLibraryMC(allItems[i] + "_item_switch"));
            child.gotoAndStop(1);
            child.itemID = child.itemID || allItems[i];
            if(Boolean(itemObjects[child.itemID]))
            {
               this.m_itemMCHash[child.itemID] = child;
               this.ItemSwitchIconsMC.addChild(child);
               this.buttonList.push(new ItemButton(child,child.itemID));
            }
            else if(allItems[i] === "allitems")
            {
               m_subMenu.allitems_btn = child;
               this.ItemSwitchIconsMC.addChild(child);
            }
            else
            {
               child.visible = false;
               this.ItemSwitchIconsMC.addChild(child);
               this.m_disabledItemHash[child.itemID] = child;
            }
         }
         this.selectHand = new ItemSwitchHand(m_subMenu,this.buttonList,this.back_CLICK);
         this.selectHand.addClickEventClipCheckBounds(m_subMenu.allitems_btn);
         this.selectHand.addClickEventClipHitTest(m_subMenu.bg_top.back_btn);
         this.selectHand.addClickEventClipHitTest(m_subMenu.bg_top.home_btn);
         this.selectHand.addClickEventClipHitTest(m_subMenu.iarrow_l);
         this.selectHand.addClickEventClipHitTest(m_subMenu.iarrow_r);
         m_container.addChild(m_subMenu);
         m_subMenu.x = Main.Width / 2;
         m_subMenu.y = Main.Height / 2;
         this.m_itemTable = new DisplayObjectTable(new Rectangle(mappings.item_switch_screen.position.x,mappings.item_switch_screen.position.y,mappings.item_switch_screen.icon_size.width,mappings.item_switch_screen.icon_size.height));
         this.m_itemTable.insertObject(0,m_subMenu.allitems_btn);
         for(i = 0; i < itemsArr.length; i++)
         {
            for(j = 0; j < itemsArr[i].length; j++)
            {
               mc = this.m_itemMCHash[itemsArr[i][j]] || this.m_disabledItemHash[itemsArr[i][j]] || null;
               if(Boolean(mc))
               {
                  this.m_itemTable.insertObject(i,mc);
               }
            }
         }
         this.updateItems();
         this.checkAllBtn();
      }
      
      public function get ItemSwitchIconsMC() : MovieClip
      {
         return m_subMenu.itemButtons;
      }
      
      private function itemInMappings(arrToSearch:Array, itemStatsName:String) : Boolean
      {
         for(var i:int = 0; i < arrToSearch.length; i++)
         {
            if(arrToSearch[i].indexOf(itemStatsName) >= 0)
            {
               return true;
            }
         }
         return false;
      }
      
      override public function makeEvents() : void
      {
         var i:* = undefined;
         var k:* = undefined;
         if(m_showCount == 0)
         {
            findSubMenuButtons();
            findSpecificMenuButtons(m_subMenu.bg_top);
         }
         super.makeEvents();
         m_subMenu.bg_top.back_btn.addEventListener(MouseEvent.CLICK,this.back_CLICK);
         m_subMenu.bg_top.back_btn.addEventListener(MouseEvent.CLICK,this.back_ROLL_OVER);
         for(i in this.buttonList)
         {
            this.buttonList[i].makeEvents();
            this.buttonList[i].ButtonInstance.addEventListener(MouseEvent.MOUSE_OVER,this.i_MOUSE_OVER);
            this.buttonList[i].ButtonInstance.addEventListener(MouseEvent.MOUSE_OUT,this.clearDesc);
            this.buttonList[i].ButtonInstance.addEventListener(MouseEvent.CLICK,this.checkAllBtn);
         }
         m_subMenu.allitems_btn.addEventListener(MouseEvent.CLICK,this.allitems_CLICK);
         m_subMenu.allitems_btn.addEventListener(MouseEvent.MOUSE_OVER,this.allitems_MOUSE_OVER);
         if(Boolean(m_subMenu.iarrow_l) && Boolean(m_subMenu.iarrow_r))
         {
            m_subMenu.iarrow_l.addEventListener(MouseEvent.CLICK,this.iarrow_l_CLICK);
            m_subMenu.iarrow_r.addEventListener(MouseEvent.CLICK,this.iarrow_r_CLICK);
            m_subMenu.iarrow_l.addEventListener(MouseEvent.MOUSE_OVER,this.iarrow_l_MOUSE_OVER);
            m_subMenu.iarrow_r.addEventListener(MouseEvent.MOUSE_OVER,this.iarrow_r_MOUSE_OVER);
         }
         m_subMenu.bg_top.home_btn.addEventListener(MouseEvent.CLICK,this.home_CLICK);
         this.selectHand.makeEvents();
         if(!Main.DEBUG)
         {
            for(k in this.m_itemMCHash)
            {
               if(SaveData.Unlocks[k] === false)
               {
                  this.m_itemMCHash[k].visible = false;
               }
            }
         }
         this.m_itemTable.spaceObjects();
         this.updateFields();
      }
      
      override public function killEvents() : void
      {
         var i:* = undefined;
         super.killEvents();
         m_subMenu.bg_top.back_btn.removeEventListener(MouseEvent.CLICK,this.back_CLICK);
         m_subMenu.bg_top.back_btn.removeEventListener(MouseEvent.CLICK,this.back_ROLL_OVER);
         for(i in this.buttonList)
         {
            this.buttonList[i].ButtonInstance.removeEventListener(MouseEvent.MOUSE_OVER,this.i_MOUSE_OVER);
            this.buttonList[i].ButtonInstance.removeEventListener(MouseEvent.MOUSE_OUT,this.clearDesc);
            this.buttonList[i].ButtonInstance.removeEventListener(MouseEvent.CLICK,this.checkAllBtn);
            this.buttonList[i].killEvents();
         }
         m_subMenu.allitems_btn.removeEventListener(MouseEvent.CLICK,this.allitems_CLICK);
         m_subMenu.allitems_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.allitems_MOUSE_OVER);
         if(Boolean(m_subMenu.iarrow_l) && Boolean(m_subMenu.iarrow_r))
         {
            m_subMenu.iarrow_l.removeEventListener(MouseEvent.CLICK,this.iarrow_l_CLICK);
            m_subMenu.iarrow_r.removeEventListener(MouseEvent.CLICK,this.iarrow_r_CLICK);
            m_subMenu.iarrow_l.removeEventListener(MouseEvent.MOUSE_OVER,this.iarrow_l_MOUSE_OVER);
            m_subMenu.iarrow_r.removeEventListener(MouseEvent.MOUSE_OVER,this.iarrow_r_MOUSE_OVER);
         }
         m_subMenu.bg_top.home_btn.removeEventListener(MouseEvent.CLICK,this.home_CLICK);
         this.selectHand.killEvents();
      }
      
      private function back_CLICK(e:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_back");
         removeSelf();
      }
      
      private function back_ROLL_OVER(e:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
      }
      
      private function updateItems() : void
      {
         var i:* = undefined;
         for(i in this.m_itemMCHash)
         {
            this.m_itemMCHash[i].gotoAndStop(SaveData.getItemStatus(i) ? "on" : "off");
         }
      }
      
      private function clearDesc(e:MouseEvent) : void
      {
         m_subMenu.item_name.text = "";
         m_subMenu.item_desc.text = "";
      }
      
      private function i_MOUSE_OVER(e:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         var mc:MovieClip = e.currentTarget as MovieClip;
         m_subMenu.item_name.text = mc.itemName || "";
         m_subMenu.item_desc.text = mc.itemDescription || "";
         Utils.fitText(m_subMenu.item_name,14);
      }
      
      private function allitems_CLICK(e:MouseEvent) : void
      {
         var i:* = undefined;
         SoundQueue.instance.playSoundEffect("menu_select");
         var wasOn:Boolean = m_subMenu.allitems_btn.currentFrameLabel == "on";
         m_subMenu.allitems_btn.gotoAndStop(wasOn ? "off" : "on");
         for(i in this.buttonList)
         {
            this.buttonList[i].setStatus(wasOn);
         }
         if(wasOn)
         {
            SaveData.ItemDataObj = {};
            for(i in this.m_disabledItemHash)
            {
               SaveData.ItemDataObj[i] = false;
            }
         }
         else
         {
            SaveData.ItemDataObj = {};
            for(i in this.m_itemMCHash)
            {
               SaveData.ItemDataObj[i] = false;
            }
            for(i in this.m_disabledItemHash)
            {
               SaveData.ItemDataObj[i] = false;
            }
         }
      }
      
      private function allitems_MOUSE_OVER(e:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
      }
      
      public function checkAllBtn(e:Event = null) : void
      {
         var i:* = undefined;
         var flag:Boolean = false;
         for(i in this.buttonList)
         {
            if(!this.buttonList[i].getStatus())
            {
               flag = true;
            }
         }
         m_subMenu.allitems_btn.gotoAndStop(!flag ? "off" : "on");
      }
      
      private function iarrow_l_CLICK(e:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         SaveData.toggleItemFrequency(false);
         this.updateFields();
      }
      
      private function iarrow_r_CLICK(e:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         SaveData.toggleItemFrequency(true);
         this.updateFields();
      }
      
      private function updateFields() : void
      {
         if(Boolean(m_subMenu.itemFreqTxt))
         {
            switch(SaveData.ItemFrequency)
            {
               case 1:
                  m_subMenu.itemFreqTxt.text = "Very Low";
                  break;
               case 2:
                  m_subMenu.itemFreqTxt.text = "Low";
                  break;
               case 3:
                  m_subMenu.itemFreqTxt.text = "Medium";
                  break;
               case 4:
                  m_subMenu.itemFreqTxt.text = "High";
                  break;
               case 5:
                  m_subMenu.itemFreqTxt.text = "Very High";
                  break;
               default:
                  m_subMenu.itemFreqTxt.text = "Off";
            }
         }
      }
      
      private function iarrow_l_MOUSE_OVER(e:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
      }
      
      private function iarrow_r_MOUSE_OVER(e:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
      }
      
      private function home_CLICK(e:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_back");
         SoundQueue.instance.stopMusic();
         if(Boolean(MenuController.CurrentCharacterSelectMenu))
         {
            MenuController.CurrentCharacterSelectMenu.resetScreen();
         }
         GameController.currentGame = null;
         MenuController.disposeAllMenus(true);
         MenuController.titleMenu.show();
      }
   }
}

