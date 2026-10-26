package com.mcleodgaming.ssf2.menus
{
   import com.mcleodgaming.ssf2.Main;
   import com.mcleodgaming.ssf2.Version;
   import com.mcleodgaming.ssf2.audio.*;
   import com.mcleodgaming.ssf2.controllers.*;
   import com.mcleodgaming.ssf2.util.*;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class TitleMenu extends Menu
   {
      
      private var m_playNode:MenuMapperNode;
      
      private var m_started:Boolean;
      
      public function TitleMenu()
      {
         super();
         m_subMenu = ResourceManager.getLibraryMC("menu_title");
         m_backgroundID = "space";
         this.m_started = false;
         this.initMenuMappings();
         m_container.addChild(m_subMenu);
         m_subMenu.x = Main.Width / 2;
         m_subMenu.y = Main.Height / 2;
         var version:String = Version.getVersion().split(".").splice(0,3).join(".");
         var revision:String = Version.getVersion().split(".")[3];
         m_subMenu.build_txt.text = revision !== "0" ? version + "." + revision + " Beta" : version + " Beta";
         m_subMenu.stop();
         m_subMenu.play_btn2.useHandCursor = true;
         m_subMenu.play_btn2.buttonMode = true;
      }
      
      override public function initMenuMappings() : void
      {
         this.m_playNode = new MenuMapperNode(m_subMenu.play_btn2);
         this.m_playNode.updateNodes(null,null,null,null,null,null,this.play_btn_CLICK,null);
         m_menuMapper = new MenuMapper(this.m_playNode);
         m_menuMapper.init();
      }
      
      override public function show() : void
      {
         super.show();
         m_subMenu.gotoAndPlay(1);
         m_subMenu.gotoAndPlay(2);
      }
      
      override public function makeEvents() : void
      {
         if(m_showCount == 0)
         {
            findSubMenuButtons();
         }
         super.makeEvents();
         resetAllButtons();
         m_subMenu.play_btn2.addEventListener(MouseEvent.CLICK,this.play_btn_CLICK);
         m_subMenu.mglink.addEventListener(MouseEvent.CLICK,this.callLink);
         m_subMenu.yt.addEventListener(MouseEvent.CLICK,this.ytLink);
         m_subMenu.twit.addEventListener(MouseEvent.CLICK,this.twitLink);
         m_subMenu.dsc.addEventListener(MouseEvent.CLICK,this.dscLink);
         m_subMenu.cred.addEventListener(MouseEvent.CLICK,this.cred_CLICK);
         Main.Root.stage.addEventListener(Event.ENTER_FRAME,manageMenuMappings);
         setMenuMappingFocus();
      }
      
      override public function killEvents() : void
      {
         super.killEvents();
         m_subMenu.play_btn2.removeEventListener(MouseEvent.CLICK,this.play_btn_CLICK);
         m_subMenu.mglink.removeEventListener(MouseEvent.CLICK,this.callLink);
         m_subMenu.yt.removeEventListener(MouseEvent.CLICK,this.ytLink);
         m_subMenu.twit.removeEventListener(MouseEvent.CLICK,this.twitLink);
         m_subMenu.dsc.removeEventListener(MouseEvent.CLICK,this.dscLink);
         m_subMenu.cred.removeEventListener(MouseEvent.CLICK,this.cred_CLICK);
         Main.Root.stage.removeEventListener(Event.ENTER_FRAME,manageMenuMappings);
      }
      
      override public function removeSelf() : void
      {
         super.removeSelf();
         m_subMenu.gotoAndStop(1);
      }
      
      private function cred_CLICK(e:MouseEvent) : void
      {
         MenuController.creditsMenu.show();
      }
      
      private function callLink(e:MouseEvent) : void
      {
         var url:String = "https://www.supersmashflash.com";
         try
         {
            Main.getURL(url,"_blank");
         }
         catch(err:Error)
         {
            trace("Error occurred!");
         }
      }
      
      private function ytLink(e:MouseEvent) : void
      {
         var url:String = "https://www.youtube.com/c/SmashFlashDevs";
         try
         {
            Main.getURL(url,"_blank");
         }
         catch(err:Error)
         {
            trace("Error occurred!");
         }
      }
      
      private function twitLink(e:MouseEvent) : void
      {
         var url:String = "https://twitter.com/SmashFlashDevs/";
         try
         {
            Main.getURL(url,"_blank");
         }
         catch(err:Error)
         {
            trace("Error occurred!");
         }
      }
      
      private function dscLink(e:MouseEvent) : void
      {
         var url:String = "https://discord.gg/mcleodgaming";
         try
         {
            Main.getURL(url,"_blank");
         }
         catch(err:Error)
         {
            trace("Error occurred!");
         }
      }
      
      private function play_btn_CLICK(e:MouseEvent) : void
      {
         if(!this.m_started)
         {
            this.m_started = true;
            SoundQueue.instance.playSoundEffect("menu_selectstage");
            Main.Root.stage.addEventListener(Event.ENTER_FRAME,this.play_btn_ENTER_FRAME);
            m_subMenu.starter.play();
         }
      }
      
      private function play_btn_ENTER_FRAME(e:Event) : void
      {
         if(this.m_started && m_subMenu.starter.currentFrame >= m_subMenu.starter.totalFrames)
         {
            this.removeSelf();
            this.m_started = false;
            Main.Root.stage.removeEventListener(Event.ENTER_FRAME,this.play_btn_ENTER_FRAME);
            m_subMenu.starter.gotoAndStop(1);
            if(Main.AUTHORIZED)
            {
               MenuController.mainMenu.show();
            }
            else
            {
               MenuController.blockedMenu.show();
            }
         }
      }
   }
}

