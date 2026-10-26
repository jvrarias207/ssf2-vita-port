package com.mcleodgaming.ssf2.menus
{
   import com.mcleodgaming.ssf2.Main;
   import com.mcleodgaming.ssf2.audio.*;
   import com.mcleodgaming.ssf2.controllers.*;
   import com.mcleodgaming.ssf2.util.ResourceManager;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class NewsArticleMenu extends Menu
   {
      
      private var m_customMenu:CustomAPIMenu;
      
      private var selectHand:SelectHand;
      
      public function NewsArticleMenu()
      {
         super();
         m_subMenu = ResourceManager.getLibraryMC("menu_newsarticle");
         m_backgroundID = "space";
         m_container.addChild(m_subMenu);
         initMenuMappings();
         m_subMenu.x = Main.Width / 2;
         m_subMenu.y = Main.Height / 2;
      }
      
      override public function makeEvents() : void
      {
         var customContainerChild:MovieClip = null;
         var j:int = 0;
         if(m_showCount == 0)
         {
            findSubMenuButtons();
            findSpecificMenuButtons(m_subMenu.bg_top);
         }
         super.makeEvents();
         resetAllButtons();
         m_subMenu.bg_top.back_btn.addEventListener(MouseEvent.CLICK,this.back_CLICK);
         m_subMenu.bg_top.back_btn.addEventListener(MouseEvent.ROLL_OVER,this.back_ROLL_OVER);
         Main.Root.stage.addEventListener(Event.ENTER_FRAME,manageMenuMappings);
         setMenuMappingFocus();
         this.m_customMenu = new CustomAPIMenu({"classAPI":MenuController.newsMenu.CurrentNewsArticle.menuClass});
         this.m_customMenu.show();
         this.selectHand = new SelectHand(this.m_customMenu.Container,new Vector.<HandButton>(),this.back_CLICK);
         this.selectHand.addClickEventClipHitTest(m_subMenu.bg_top.back_btn);
         this.selectHand.makeEvents();
         for(var i:int = 0; i < this.m_customMenu.Container.numChildren; i++)
         {
            if(this.m_customMenu.Container.getChildAt(i) is MovieClip)
            {
               customContainerChild = MovieClip(this.m_customMenu.Container.getChildAt(i));
               for(j = 0; j < customContainerChild.numChildren; j++)
               {
                  if(customContainerChild.getChildAt(j) is MovieClip && MovieClip(customContainerChild.getChildAt(j)).buttonMode || customContainerChild.getChildAt(j) is SimpleButton)
                  {
                     this.selectHand.addClickEventClipHitTest(customContainerChild.getChildAt(j));
                  }
               }
            }
         }
         this.selectHand.resetPosition(new Point(320,240),new Rectangle(10,10,630,350));
      }
      
      override public function killEvents() : void
      {
         super.killEvents();
         this.selectHand.killEvents();
         this.selectHand = null;
         m_subMenu.bg_top.back_btn.removeEventListener(MouseEvent.CLICK,this.back_CLICK);
         m_subMenu.bg_top.back_btn.removeEventListener(MouseEvent.ROLL_OVER,this.back_ROLL_OVER);
         Main.Root.stage.removeEventListener(Event.ENTER_FRAME,manageMenuMappings);
         this.m_customMenu.removeSelf();
         this.m_customMenu.APIInstance.dispose();
      }
      
      private function back_CLICK(e:MouseEvent) : void
      {
         removeSelf();
         SoundQueue.instance.playSoundEffect("menu_back");
         MenuController.newsMenu.show();
      }
      
      private function back_ROLL_OVER(e:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
      }
   }
}

