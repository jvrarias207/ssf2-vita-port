package com.mcleodgaming.ssf2.menus
{
   import com.mcleodgaming.ssf2.Main;
   import com.mcleodgaming.ssf2.audio.SoundQueue;
   import com.mcleodgaming.ssf2.controllers.MenuController;
   import com.mcleodgaming.ssf2.util.ResourceManager;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class Intro2Menu extends Menu
   {
      
      private var waitASec:Boolean;
      
      private var m_skipNode:MenuMapperNode;
      
      public function Intro2Menu()
      {
         super();
         m_subMenu = ResourceManager.getLibraryMC("ssf2intro_v9");
         if(Boolean(m_subMenu))
         {
            m_subMenu.stop();
            m_container.addChild(m_subMenu);
            this.initMenuMappings();
         }
         this.waitASec = true;
      }
      
      override public function initMenuMappings() : void
      {
         this.m_skipNode = new MenuMapperNode(m_subMenu);
         this.m_skipNode.updateNodes(null,null,null,null,null,null,this.endIntro,this.endIntro);
         m_menuMapper = new MenuMapper(this.m_skipNode);
         m_menuMapper.init();
      }
      
      override public function makeEvents() : void
      {
         if(m_showCount == 0)
         {
            findSubMenuButtons();
         }
         super.makeEvents();
         if(m_subMenu == null)
         {
            removeSelf();
            MenuController.disposeAllMenus(true);
            MenuController.titleMenu.show();
         }
         else
         {
            Main.Root.stage.addEventListener(MouseEvent.CLICK,this.endIntro);
            Main.Root.stage.addEventListener(Event.ENTER_FRAME,this.checkIntro);
            Main.Root.stage.addEventListener(Event.ENTER_FRAME,manageMenuMappings);
         }
      }
      
      override public function killEvents() : void
      {
         super.killEvents();
         if(Boolean(m_subMenu))
         {
            Main.Root.stage.removeEventListener(MouseEvent.CLICK,this.endIntro);
            Main.Root.stage.removeEventListener(Event.ENTER_FRAME,this.checkIntro);
            Main.Root.stage.removeEventListener(Event.ENTER_FRAME,manageMenuMappings);
         }
      }
      
      private function endIntro(e:MouseEvent) : void
      {
         if(!this.waitASec)
         {
            m_subMenu.stop();
            SoundQueue.instance.playSoundEffect("menu_back");
            this.toTitle();
         }
      }
      
      private function toTitle() : void
      {
         removeSelf();
         if(Boolean(m_subMenu))
         {
            m_subMenu.stop();
         }
         MenuController.vaultMenu.show();
      }
      
      private function checkIntro(e:Event) : void
      {
         if(m_subMenu.currentFrame >= m_subMenu.totalFrames - 1)
         {
            m_subMenu.stop();
            MenuController.vaultMenu.show();
            removeSelf();
         }
         this.waitASec = false;
      }
      
      override public function show() : void
      {
         this.waitASec = true;
         if(Boolean(m_subMenu))
         {
            m_subMenu.gotoAndPlay(1);
            super.show();
         }
         else
         {
            this.toTitle();
         }
      }
   }
}

