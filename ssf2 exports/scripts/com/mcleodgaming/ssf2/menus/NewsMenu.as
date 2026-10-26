package com.mcleodgaming.ssf2.menus
{
   import com.mcleodgaming.ssf2.Main;
   import com.mcleodgaming.ssf2.audio.*;
   import com.mcleodgaming.ssf2.controllers.*;
   import com.mcleodgaming.ssf2.util.ResourceManager;
   import com.mcleodgaming.ssf2.util.SaveData;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class NewsMenu extends Menu
   {
      
      private var m_currentEntry:Object;
      
      private var m_entries:Array;
      
      private var m_newsButtons:Vector.<NewsButton>;
      
      private var newsSelectHand:NewsMenuHand;
      
      private var m_listLocation:Point;
      
      private var m_newsContainer:MovieClip;
      
      private var m_newsMask:MovieClip;
      
      private var m_isDragging:Boolean;
      
      private var m_scrollTop:Point;
      
      private var m_scrollHeight:Number;
      
      public function NewsMenu()
      {
         super();
         m_subMenu = ResourceManager.getLibraryMC("menu_news");
         m_backgroundID = "space";
         m_container.addChild(m_subMenu);
         this.m_currentEntry = null;
         initMenuMappings();
         m_subMenu.x = Main.Width / 2;
         m_subMenu.y = Main.Height / 2;
         this.m_scrollTop = new Point(m_subMenu.scroller.x,m_subMenu.scroller.y);
         this.m_scrollHeight = 197 - m_subMenu.scroller.height;
         this.m_isDragging = false;
         this.m_listLocation = new Point(-260,-30);
         this.m_newsMask = new MovieClip();
         this.m_newsMask.x = this.m_listLocation.x - 10;
         this.m_newsMask.y = this.m_listLocation.y - 10;
         this.m_newsMask.graphics.beginFill(16711680,1);
         this.m_newsMask.graphics.drawRect(0,0,576 + 20,190 + 20);
         this.m_newsMask.graphics.endFill();
         this.m_newsMask.visible = false;
         this.m_newsContainer = new MovieClip();
         this.m_newsContainer.x = this.m_listLocation.x;
         this.m_newsContainer.y = this.m_listLocation.y;
         this.m_entries = new Array();
         if(ResourceManager.getResourceByID("menu_news").Loaded)
         {
            this.m_entries = ResourceManager.getResourceByID("menu_news").getProp("entries") || new Array();
         }
         this.m_newsButtons = new Vector.<NewsButton>();
         for(var i:int = 0; i < this.m_entries.length; i++)
         {
            this.m_newsButtons.push(new NewsButton(ResourceManager.getLibraryMC("newsItemMC")));
            this.m_newsContainer.addChildAt(this.m_newsButtons[i].ButtonInstance,0);
         }
         m_subMenu.addChild(this.m_newsContainer);
         m_subMenu.addChild(this.m_newsMask);
         this.m_newsContainer.mask = this.m_newsMask;
         this.newsSelectHand = new NewsMenuHand(m_subMenu,this.m_newsButtons,this.back_CLICK);
         this.newsSelectHand.topBoundPush = this.handPushListUpHelper;
         this.newsSelectHand.bottomBoundPush = this.handPushListDownHelper;
         this.newsSelectHand.addClickEventClipHitTest(m_subMenu.bg_top.back_btn);
      }
      
      public static function getLatestHeadline() : Object
      {
         var entries:Array = null;
         var i:int = 0;
         var headline:String = null;
         var unread:Boolean = false;
         if(ResourceManager.getResourceByID("menu_news").Loaded)
         {
            entries = ResourceManager.getResourceByID("menu_news").getProp("entries") || new Array();
            for(i = 0; i < entries.length; i++)
            {
               if(!headline)
               {
                  headline = entries[i].title || "Problem loading latest headline";
                  unread = !SaveData.Once.newsRead[entries[i].id];
               }
               else if(!SaveData.Once.newsRead[entries[i].id])
               {
                  headline = entries[i].title || "Problem loading latest headline";
                  unread = !SaveData.Once.newsRead[entries[i].id];
                  break;
               }
            }
         }
         return {
            "text":headline || "No news currently available",
            "unread":unread
         };
      }
      
      public function get CurrentNewsArticle() : Object
      {
         return this.m_currentEntry;
      }
      
      override public function show() : void
      {
         super.show();
         SoundQueue.instance.playMusic("menumusic",0);
      }
      
      override public function makeEvents() : void
      {
         if(m_showCount == 0)
         {
            findSubMenuButtons();
            findSpecificMenuButtons(m_subMenu.bg_top);
         }
         super.makeEvents();
         resetAllButtons();
         m_subMenu.bg_top.back_btn.addEventListener(MouseEvent.CLICK,this.back_CLICK);
         m_subMenu.bg_top.back_btn.addEventListener(MouseEvent.ROLL_OVER,this.back_ROLL_OVER);
         m_subMenu.scroller.addEventListener(MouseEvent.MOUSE_DOWN,this.scroll_CLICK);
         m_subMenu.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.scroll_MOVE);
         m_subMenu.addEventListener(MouseEvent.MOUSE_UP,this.scroll_RELEASE);
         this.newsSelectHand.makeEvents();
         var y_offset:Number = 0;
         var i:int = 0;
         while(i < this.m_entries.length)
         {
            this.m_newsButtons[i].ButtonInstance.status.gotoAndStop(Boolean(SaveData.Once.newsRead[this.m_entries[i].id]) ? "read" : "new");
            this.m_newsButtons[i].ButtonInstance.title.text = this.m_entries[i].title;
            this.m_newsButtons[i].ButtonInstance.y = y_offset * 23;
            this.m_newsButtons[i].ButtonInstance.addEventListener(MouseEvent.CLICK,this.news_CLICK);
            this.m_newsButtons[i].ButtonInstance.addEventListener(MouseEvent.MOUSE_OVER,this.news_MOUSE_OVER);
            this.m_newsButtons[i].ButtonInstance.addEventListener(MouseEvent.MOUSE_OUT,this.news_MOUSE_OUT);
            this.m_newsButtons[i].makeEvents();
            i++;
            y_offset++;
         }
         Main.Root.stage.addEventListener(Event.ENTER_FRAME,manageMenuMappings);
         setMenuMappingFocus();
      }
      
      override public function killEvents() : void
      {
         super.killEvents();
         m_subMenu.bg_top.back_btn.removeEventListener(MouseEvent.CLICK,this.back_CLICK);
         m_subMenu.bg_top.back_btn.removeEventListener(MouseEvent.ROLL_OVER,this.back_ROLL_OVER);
         m_subMenu.scroller.removeEventListener(MouseEvent.MOUSE_DOWN,this.scroll_CLICK);
         m_subMenu.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.scroll_MOVE);
         m_subMenu.removeEventListener(MouseEvent.MOUSE_UP,this.scroll_RELEASE);
         this.newsSelectHand.killEvents();
         for(var i:int = 0; i < this.m_entries.length; i++)
         {
            this.m_newsButtons[i].ButtonInstance.visible = true;
            this.m_newsButtons[i].killEvents();
            this.m_newsButtons[i].ButtonInstance.removeEventListener(MouseEvent.CLICK,this.news_CLICK);
            this.m_newsButtons[i].ButtonInstance.removeEventListener(MouseEvent.MOUSE_OVER,this.news_MOUSE_OVER);
            this.m_newsButtons[i].ButtonInstance.removeEventListener(MouseEvent.MOUSE_OUT,this.news_MOUSE_OUT);
         }
         Main.Root.stage.removeEventListener(Event.ENTER_FRAME,manageMenuMappings);
      }
      
      private function findNewsArticle(e:MovieClip) : int
      {
         for(var i:int = 0; i < this.m_newsButtons.length; i++)
         {
            if(this.m_newsButtons[i].ButtonInstance == e)
            {
               return i;
            }
         }
         return -1;
      }
      
      public function news_CLICK(e:MouseEvent) : void
      {
         var index:int = this.findNewsArticle(e.target as MovieClip);
         if(index >= 0 && index < this.m_entries.length)
         {
            this.m_currentEntry = this.m_entries[index];
            removeSelf();
            SoundQueue.instance.playSoundEffect("menu_select");
            MenuController.newsArticleMenu.show();
            MenuController.newsArticleMenu.SubMenu.shortTitle.text = this.m_currentEntry.shortTitle.toUpperCase();
            SaveData.Once.newsRead[this.m_currentEntry.id] = true;
         }
      }
      
      public function news_MOUSE_OVER(e:MouseEvent) : void
      {
         var index:int = this.findNewsArticle(e.target as MovieClip);
         if(index >= 0 && index < this.m_entries.length)
         {
            SoundQueue.instance.playSoundEffect("menu_hover");
            this.m_currentEntry = this.m_entries[index];
            while(m_subMenu.thumbnail.contents.numChildren > 0)
            {
               m_subMenu.thumbnail.contents.removeChildAt(0);
            }
            if(Boolean(this.m_currentEntry.thumbnailMC))
            {
               m_subMenu.thumbnail.contents.addChild(new this.m_currentEntry.thumbnailMC());
            }
            m_subMenu.thumbnail.title.text = this.m_currentEntry.title;
         }
      }
      
      public function news_MOUSE_OUT(e:MouseEvent) : void
      {
         var index:int = this.findNewsArticle(e.target as MovieClip);
         if(index >= 0)
         {
            this.m_currentEntry = null;
            while(m_subMenu.thumbnail.contents.numChildren > 0)
            {
               m_subMenu.thumbnail.contents.removeChildAt(0);
            }
            m_subMenu.thumbnail.title.text = "";
         }
      }
      
      public function scroll_CLICK(e:MouseEvent) : void
      {
         if(!this.m_isDragging)
         {
            MovieClip(m_subMenu.scroller).startDrag(false,new Rectangle(this.m_scrollTop.x,this.m_scrollTop.y,0,this.m_scrollHeight));
            this.m_isDragging = true;
         }
      }
      
      public function scroll_MOVE(e:MouseEvent) : void
      {
         if(this.m_isDragging)
         {
            this.repositionList();
         }
      }
      
      public function scroll_RELEASE(e:MouseEvent) : void
      {
         if(this.m_isDragging)
         {
            MovieClip(m_subMenu.scroller).stopDrag();
            this.m_isDragging = false;
         }
      }
      
      private function repositionList() : void
      {
         var percentScrolled:Number = (m_subMenu.scroller.y - this.m_scrollTop.y) / this.m_scrollHeight;
         if(percentScrolled < 0.01)
         {
            percentScrolled = 0;
         }
         else if(percentScrolled > 0.99)
         {
            percentScrolled = 1;
         }
         var entryHeight:Number = 23;
         this.m_newsContainer.y = this.m_listLocation.y - percentScrolled * (entryHeight * Math.max(0,this.m_entries.length - 5));
      }
      
      private function handPushListUpHelper() : void
      {
         m_subMenu.scroller.y -= 4;
         if(m_subMenu.scroller.y < this.m_scrollTop.y)
         {
            m_subMenu.scroller.y = this.m_scrollTop.y;
         }
         this.repositionList();
      }
      
      private function handPushListDownHelper() : void
      {
         m_subMenu.scroller.y += 4;
         if(m_subMenu.scroller.y > this.m_scrollTop.y + this.m_scrollHeight)
         {
            m_subMenu.scroller.y = this.m_scrollTop.y + this.m_scrollHeight;
         }
         this.repositionList();
      }
      
      private function back_CLICK(e:MouseEvent) : void
      {
         removeSelf();
         SoundQueue.instance.playSoundEffect("menu_back");
         MenuController.mainMenu.show();
         SaveData.saveGame();
      }
      
      private function back_ROLL_OVER(e:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
      }
   }
}

