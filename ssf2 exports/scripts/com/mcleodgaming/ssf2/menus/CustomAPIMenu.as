package com.mcleodgaming.ssf2.menus
{
   import com.mcleodgaming.ssf2.Main;
   import com.mcleodgaming.ssf2.api.SSF2CustomMenu;
   import com.mcleodgaming.ssf2.audio.*;
   import com.mcleodgaming.ssf2.controllers.*;
   import com.mcleodgaming.ssf2.util.*;
   import flash.events.Event;
   
   public class CustomAPIMenu extends Menu
   {
      
      private var m_apiInstance:SSF2CustomMenu;
      
      private var m_menuInputNodes:Object;
      
      private var m_customMenuInputMapping:Object;
      
      public function CustomAPIMenu(stats:Object = null)
      {
         super();
         if(!stats)
         {
            stats = {};
         }
         this.m_menuInputNodes = {};
         this.m_customMenuInputMapping = null;
         this.m_apiInstance = new SSF2CustomMenu(stats.classAPI,this);
         this.m_apiInstance.initialize();
      }
      
      public function get APIInstance() : SSF2CustomMenu
      {
         return this.m_apiInstance;
      }
      
      public function set CustomInputMapping(value:Object) : void
      {
         this.m_customMenuInputMapping = value;
      }
      
      private function menuNodeHelper(availableNodes:Object, nodeNames:Array) : Array
      {
         var results:Array = [];
         availableNodes ||= [];
         nodeNames ||= [];
         for(var i:int = 0; i < nodeNames.length; i++)
         {
            if(Boolean(availableNodes[nodeNames[i]]))
            {
               results.push(availableNodes[nodeNames[i]]);
            }
         }
         return results;
      }
      
      override public function show() : void
      {
         var i:* = undefined;
         var defaultSelectedNode:MenuMapperNode = null;
         if(m_showCount == 0)
         {
            findSubMenuButtons();
         }
         super.show();
         resetAllButtons();
         if(Boolean(this.m_customMenuInputMapping))
         {
            this.m_menuInputNodes = {};
            defaultSelectedNode = null;
            for(i in this.m_customMenuInputMapping)
            {
               this.m_menuInputNodes[i] = new MenuMapperNode(this.m_customMenuInputMapping[i].button);
            }
            for(i in this.m_customMenuInputMapping)
            {
               (this.m_menuInputNodes[i] as MenuMapperNode).updateNodes(this.menuNodeHelper(this.m_menuInputNodes,this.m_customMenuInputMapping[i].upNodes),this.menuNodeHelper(this.m_menuInputNodes,this.m_customMenuInputMapping[i].downNodes),this.menuNodeHelper(this.m_menuInputNodes,this.m_customMenuInputMapping[i].leftNodes),this.menuNodeHelper(this.m_menuInputNodes,this.m_customMenuInputMapping[i].rightNodes),this.m_customMenuInputMapping[i].onOver || null,this.m_customMenuInputMapping[i].onOut || null,this.m_customMenuInputMapping[i].onPress || null,this.m_customMenuInputMapping[i].onBack || null,this.m_customMenuInputMapping[i].onUp || null,this.m_customMenuInputMapping[i].onDown || null,this.m_customMenuInputMapping[i].onLeft || null,this.m_customMenuInputMapping[i].onRight || null);
               if(Boolean(this.m_customMenuInputMapping[i].selected))
               {
                  defaultSelectedNode = this.m_menuInputNodes[i];
               }
            }
            m_menuMapper = new MenuMapper(defaultSelectedNode);
            m_menuMapper.init();
            setMenuMappingFocus();
         }
         Main.Root.stage.addEventListener(Event.ENTER_FRAME,manageMenuMappings);
         MenuController.customMenus.push(this);
      }
      
      override public function removeSelf() : void
      {
         super.removeSelf();
         var index:int = MenuController.customMenus.indexOf(this);
         if(index >= 0)
         {
            MenuController.customMenus.splice(index,1);
         }
         Main.Root.stage.removeEventListener(Event.ENTER_FRAME,manageMenuMappings);
         this.m_menuInputNodes = null;
         m_menuMapper = null;
      }
   }
}

