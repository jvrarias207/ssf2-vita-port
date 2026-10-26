package com.mcleodgaming.ssf2.menus
{
   import com.mcleodgaming.ssf2.Main;
   import com.mcleodgaming.ssf2.audio.*;
   import com.mcleodgaming.ssf2.controllers.*;
   import com.mcleodgaming.ssf2.engine.*;
   import com.mcleodgaming.ssf2.enums.Mode;
   import com.mcleodgaming.ssf2.modes.EventMode;
   import com.mcleodgaming.ssf2.util.*;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class EventMenu extends Menu
   {
      
      private var m_isDragging:Boolean;
      
      private var m_currentEvent:Object;
      
      private var m_eventContainer:MovieClip;
      
      private var m_eventMask:MovieClip;
      
      private var m_eventButtons:Vector.<EventButton>;
      
      private var m_listLocation:Point;
      
      private var m_scrollTop:Point;
      
      private var m_scrollHeight:Number;
      
      private var eventSelectHand:EventMenuHand;
      
      private var m_events:Array;
      
      private var m_game:Game;
      
      private var m_modeInstance:EventMode;
      
      private var m_unlockIcon:MovieClip;
      
      public function EventMenu()
      {
         super();
         var i:int = 0;
         m_subMenu = ResourceManager.getLibraryMC("menu_event");
         m_backgroundID = "space";
         m_container.addChild(m_subMenu);
         m_subMenu.x = Main.Width / 2;
         m_subMenu.y = Main.Height / 2;
         this.m_game = null;
         this.m_modeInstance = null;
         this.m_currentEvent = null;
         this.m_listLocation = new Point(-235.1,-120.2);
         this.m_eventMask = new MovieClip();
         this.m_eventMask.x = -286.35;
         this.m_eventMask.y = -125.85;
         this.m_eventMask.graphics.beginFill(16711680,1);
         this.m_eventMask.graphics.drawRect(0,0,500,255);
         this.m_eventMask.graphics.endFill();
         this.m_eventMask.visible = false;
         this.m_eventContainer = new MovieClip();
         this.m_eventContainer.x = this.m_listLocation.x;
         this.m_eventContainer.y = this.m_listLocation.y;
         this.m_events = ResourceManager.getResourceByID("event_mode").getProp("eventList");
         this.m_unlockIcon = ResourceManager.getLibraryMC("eventIconMC");
         this.m_unlockIcon.alpha = 0.75;
         this.m_unlockIcon.complete.visible = false;
         this.m_eventButtons = new Vector.<EventButton>();
         for(i = 0; i < this.m_events.length; i++)
         {
            this.m_eventButtons.push(new EventButton(ResourceManager.getLibraryMC("eventIconMC")));
            this.m_eventContainer.addChild(this.m_eventButtons[i].ButtonInstance);
         }
         this.reset();
         m_subMenu.addChild(this.m_eventContainer);
         m_subMenu.addChild(this.m_eventMask);
         this.m_eventContainer.mask = this.m_eventMask;
         this.m_scrollTop = new Point(m_subMenu.scroller.x,m_subMenu.scroller.y);
         this.m_scrollHeight = 213;
         m_subMenu.sample.visible = false;
         this.m_isDragging = false;
         this.eventSelectHand = new EventMenuHand(m_subMenu,this.m_eventButtons,this.backMain_CLICK);
         this.eventSelectHand.topBoundPush = this.handPushListUpHelper;
         this.eventSelectHand.bottomBoundPush = this.handPushListDownHelper;
         m_subMenu.setChildIndex(this.eventSelectHand.HandMC,m_subMenu.numChildren - 1);
         this.eventSelectHand.addClickEventClipHitTest(m_subMenu.bg_top.back_btn);
      }
      
      public function get CurrentEvent() : Object
      {
         return this.m_currentEvent;
      }
      
      public function reset() : void
      {
         this.m_currentEvent = null;
         this.updateDisplay();
      }
      
      private function getEventNumString(event:Object) : String
      {
         var normalNum:int = 1;
         var allStarNum:int = 1;
         for(var i:int = 0; i < this.m_events.length; i++)
         {
            if(this.m_events[i] === event)
            {
               return Boolean(this.m_events[i].allStar) ? "All-Star # " + allStarNum : "#" + normalNum;
            }
            if(Boolean(this.m_events[i].allStar))
            {
               allStarNum++;
            }
            else
            {
               normalNum++;
            }
         }
         return "---";
      }
      
      public function updateDisplay() : void
      {
         if(this.m_eventButtons.length > 0 && Boolean(this.m_currentEvent))
         {
            m_subMenu.eventNum.text = this.getEventNumString(this.m_currentEvent);
            m_subMenu.eventName.text = this.m_currentEvent.name;
            m_subMenu.eventDesc.text = this.m_currentEvent.description;
            if(Boolean(SaveData.Records.events.wins[this.m_currentEvent.id]))
            {
               m_subMenu.rank_txt.text = SaveData.Records.events.wins[this.m_currentEvent.id].rank;
               if(SaveData.Records.events.wins[this.m_currentEvent.id].scoreType === "time")
               {
                  m_subMenu.desc_txt.text = Utils.framesToTimeString(SaveData.Records.events.wins[this.m_currentEvent.id].score) + " (Avg. FPS: " + SaveData.Records.events.wins[this.m_currentEvent.id].fps + ")";
               }
               else if(SaveData.Records.events.wins[this.m_currentEvent.id].scoreType === "points")
               {
                  m_subMenu.desc_txt.text = SaveData.Records.events.wins[this.m_currentEvent.id].score + " Points (Avg. FPS: " + SaveData.Records.events.wins[this.m_currentEvent.id].fps + ")";
               }
               else if(SaveData.Records.events.wins[this.m_currentEvent.id].scoreType === "damage")
               {
                  m_subMenu.desc_txt.text = Math.round(SaveData.Records.events.wins[this.m_currentEvent.id].score) + " % (Avg. FPS: " + SaveData.Records.events.wins[this.m_currentEvent.id].fps + ")";
               }
               else if(SaveData.Records.events.wins[this.m_currentEvent.id].scoreType === "stamina")
               {
                  m_subMenu.desc_txt.text = Math.round(SaveData.Records.events.wins[this.m_currentEvent.id].score) + " % (Avg. FPS: " + SaveData.Records.events.wins[this.m_currentEvent.id].fps + ")";
               }
               else if(SaveData.Records.events.wins[this.m_currentEvent.id].scoreType === "kos")
               {
                  m_subMenu.desc_txt.text = SaveData.Records.events.wins[this.m_currentEvent.id].score + " KOs (Avg. FPS: " + SaveData.Records.events.wins[this.m_currentEvent.id].fps + ")";
               }
               else
               {
                  m_subMenu.desc_txt.text = "[ Invalid Score Type ]";
               }
            }
            else
            {
               m_subMenu.rank_txt.text = "--";
               m_subMenu.desc_txt.text = "[ Incomplete ]";
            }
            Utils.tryToGotoAndStop(m_subMenu.previewer,this.m_currentEvent.id);
         }
         else
         {
            m_subMenu.eventNum.text = "";
            m_subMenu.eventName.text = "";
            m_subMenu.eventDesc.text = "";
            m_subMenu.previewer.gotoAndStop(1);
            m_subMenu.desc_txt.text = "";
         }
      }
      
      override public function makeEvents() : void
      {
         if(m_showCount == 0)
         {
            findSubMenuButtons();
            findSpecificMenuButtons(m_subMenu.bg_top);
         }
         super.makeEvents();
         m_subMenu.bg_top.back_btn.addEventListener(MouseEvent.CLICK,this.backMain_CLICK);
         m_subMenu.scroller.addEventListener(MouseEvent.MOUSE_DOWN,this.scroll_CLICK);
         m_subMenu.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.scroll_MOVE);
         m_subMenu.addEventListener(MouseEvent.MOUSE_UP,this.scroll_RELEASE);
         this.eventSelectHand.makeEvents();
         var allStarNumber:int = 0;
         var eventNumber:int = 0;
         var y_offset:Number = 0;
         var madeUnlockIcon:Boolean = false;
         this.m_unlockIcon.visible = false;
         for(var i:int = 0; i < this.m_events.length; i++)
         {
            this.m_eventButtons[i].ButtonInstance.complete.visible = SaveData.Records.events.wins[this.m_events[i].id];
            this.m_eventButtons[i].ButtonInstance.eventName.text = this.m_events[i].name;
            this.m_eventButtons[i].ButtonInstance.name = "e" + i;
            this.m_eventButtons[i].ButtonInstance.y = y_offset * 23;
            this.m_eventButtons[i].ButtonInstance.addEventListener(MouseEvent.CLICK,this.event_CLICK);
            this.m_eventButtons[i].ButtonInstance.addEventListener(MouseEvent.MOUSE_OVER,this.event_MOUSE_OVER);
            this.m_eventButtons[i].ButtonInstance.addEventListener(MouseEvent.MOUSE_OUT,this.event_MOUSE_OUT);
            this.m_eventButtons[i].makeEvents();
            this.m_eventButtons[i].ButtonInstance.visible = true;
            if(Boolean(SaveData.Records.events.wins[this.m_events[i].id]))
            {
               this.m_eventButtons[i].ButtonInstance.complete.gotoAndStop(SaveData.Records.events.wins[this.m_events[i].id].rank.toUpperCase());
               this.m_eventButtons[i].ButtonInstance.complete.visible = true;
            }
            else
            {
               this.m_eventButtons[i].ButtonInstance.complete.visible = false;
            }
            if(Boolean(this.m_events[i].dev) && !Main.DEBUG)
            {
               this.m_eventButtons[i].ButtonInstance.visible = false;
            }
            else
            {
               if(Boolean(this.m_events[i].dev) && Main.DEBUG)
               {
                  this.m_eventButtons[i].ButtonInstance.eventName.text += " (dev)";
               }
               y_offset++;
            }
            if(Boolean(this.m_events[i].allStar))
            {
               allStarNumber++;
               if(allStarNumber === 1 && !SaveData.Unlocks[Unlockable.EVENT_ALL_STAR_01] || allStarNumber === 2 && !SaveData.Unlocks[Unlockable.EVENT_ALL_STAR_06] || allStarNumber === 3 && !SaveData.Unlocks[Unlockable.EVENT_ALL_STAR_07] || allStarNumber === 4 && !SaveData.Unlocks[Unlockable.EVENT_ALL_STAR_08] || allStarNumber === 5 && !SaveData.Unlocks[Unlockable.EVENT_ALL_STAR_09] || allStarNumber === 6 && !SaveData.Unlocks[Unlockable.EVENT_ALL_STAR_BETA])
               {
                  if(Main.DEBUG)
                  {
                     this.m_eventButtons[i].ButtonInstance.eventName.text += " (*)";
                  }
                  else
                  {
                     this.m_eventButtons[i].ButtonInstance.visible = false;
                  }
               }
            }
            else
            {
               eventNumber++;
               if(eventNumber >= 11 && eventNumber <= 20 && !SaveData.Unlocks[Unlockable.EVENTS_11_20] || eventNumber >= 21 && eventNumber <= 30 && !SaveData.Unlocks[Unlockable.EVENTS_21_30] || eventNumber >= 31 && eventNumber <= 36 && !SaveData.Unlocks[Unlockable.EVENTS_31_36] || eventNumber >= 37 && eventNumber <= 44 && !SaveData.Unlocks[Unlockable.EVENTS_37_44] || eventNumber >= 45 && eventNumber <= 50 && !SaveData.Unlocks[Unlockable.EVENTS_45_50] || eventNumber >= 51 && eventNumber <= 51 && !SaveData.Unlocks[Unlockable.EVENTS_51])
               {
                  if(Main.DEBUG)
                  {
                     this.m_eventButtons[i].ButtonInstance.eventName.text += " (*)";
                  }
                  else
                  {
                     this.m_eventButtons[i].ButtonInstance.visible = false;
                  }
               }
            }
            if(!madeUnlockIcon)
            {
               if(!SaveData.Unlocks[Unlockable.EVENT_ALL_STAR_01] && eventNumber === 10)
               {
                  madeUnlockIcon = true;
                  this.m_unlockIcon.eventName.text = "Must complete events 1-10";
               }
               else if(!SaveData.Unlocks[Unlockable.EVENTS_11_20] && allStarNumber === 1)
               {
                  madeUnlockIcon = true;
                  this.m_unlockIcon.eventName.text = "Must complete All Star v0.1";
               }
               else if(!SaveData.Unlocks[Unlockable.EVENT_ALL_STAR_06] && eventNumber === 20)
               {
                  madeUnlockIcon = true;
                  this.m_unlockIcon.eventName.text = "Must complete events 11-20";
               }
               else if(!SaveData.Unlocks[Unlockable.EVENTS_21_30] && allStarNumber === 2)
               {
                  madeUnlockIcon = true;
                  this.m_unlockIcon.eventName.text = "Must complete All Star v0.6";
               }
               else if(!SaveData.Unlocks[Unlockable.EVENT_ALL_STAR_07] && eventNumber === 30)
               {
                  madeUnlockIcon = true;
                  this.m_unlockIcon.eventName.text = "Must complete events 21-30";
               }
               else if(!SaveData.Unlocks[Unlockable.EVENTS_31_36] && allStarNumber === 3)
               {
                  madeUnlockIcon = true;
                  this.m_unlockIcon.eventName.text = "Must complete All Star v0.7";
               }
               else if(!SaveData.Unlocks[Unlockable.EVENT_ALL_STAR_08] && eventNumber === 36)
               {
                  madeUnlockIcon = true;
                  this.m_unlockIcon.eventName.text = "Must complete events 31-36";
               }
               else if(!SaveData.Unlocks[Unlockable.EVENTS_37_44] && allStarNumber === 4)
               {
                  madeUnlockIcon = true;
                  this.m_unlockIcon.eventName.text = "Must complete All Star v0.8";
               }
               else if(!SaveData.Unlocks[Unlockable.EVENT_ALL_STAR_09] && eventNumber === 44)
               {
                  madeUnlockIcon = true;
                  this.m_unlockIcon.eventName.text = "Must complete events 37-44";
               }
               else if(!SaveData.Unlocks[Unlockable.EVENTS_45_50] && allStarNumber === 5)
               {
                  madeUnlockIcon = true;
                  this.m_unlockIcon.eventName.text = "Must complete All Star v0.9";
               }
               else if(!SaveData.Unlocks[Unlockable.EVENT_ALL_STAR_BETA] && eventNumber === 50)
               {
                  madeUnlockIcon = true;
                  this.m_unlockIcon.eventName.text = "Must complete events 45-50";
               }
               else if(!SaveData.Records.events.wins["AllStarBattleBeta"] && !SaveData.Unlocks[Unlockable.EVENTS_51] && allStarNumber === 6)
               {
                  madeUnlockIcon = true;
                  this.m_unlockIcon.eventName.text = "Must complete All Star Beta";
               }
               else if(Boolean(SaveData.Records.events.wins["AllStarBattleBeta"] && !SaveData.Unlocks[Unlockable.EVENT_ARANK]) && Boolean(!SaveData.Unlocks[Unlockable.EVENTS_51]) && allStarNumber === 6)
               {
                  madeUnlockIcon = true;
                  this.m_unlockIcon.eventName.text = "Must A-rank or above every event";
               }
               if(madeUnlockIcon)
               {
                  this.m_unlockIcon.visible = true;
                  this.m_eventContainer.addChild(this.m_unlockIcon);
                  this.m_unlockIcon.y = y_offset * 23;
                  y_offset++;
                  madeUnlockIcon = true;
               }
            }
         }
      }
      
      override public function killEvents() : void
      {
         super.killEvents();
         m_subMenu.bg_top.back_btn.removeEventListener(MouseEvent.CLICK,this.backMain_CLICK);
         m_subMenu.scroller.removeEventListener(MouseEvent.MOUSE_DOWN,this.scroll_CLICK);
         m_subMenu.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.scroll_MOVE);
         m_subMenu.removeEventListener(MouseEvent.MOUSE_UP,this.scroll_RELEASE);
         for(var i:int = 0; i < this.m_events.length; i++)
         {
            this.m_eventButtons[i].ButtonInstance.visible = true;
            this.m_eventButtons[i].killEvents();
            this.m_eventButtons[i].ButtonInstance.removeEventListener(MouseEvent.CLICK,this.event_CLICK);
            this.m_eventButtons[i].ButtonInstance.removeEventListener(MouseEvent.MOUSE_OVER,this.event_MOUSE_OVER);
            this.m_eventButtons[i].ButtonInstance.removeEventListener(MouseEvent.MOUSE_OUT,this.event_MOUSE_OUT);
         }
         this.eventSelectHand.killEvents();
         MovieClip(m_subMenu.scroller).stopDrag();
      }
      
      override public function show() : void
      {
         this.reset();
         super.show();
         SoundQueue.instance.playMusic("menumusic",0);
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
         var eventHeight:Number = 30;
         this.m_eventContainer.y = this.m_listLocation.y - percentScrolled * (eventHeight * Math.max(0,this.m_events.length - 21));
      }
      
      private function handPushListUpHelper() : void
      {
         m_subMenu.scroller.y -= 2;
         if(m_subMenu.scroller.y < this.m_scrollTop.y)
         {
            m_subMenu.scroller.y = this.m_scrollTop.y;
         }
         this.repositionList();
      }
      
      private function handPushListDownHelper() : void
      {
         m_subMenu.scroller.y += 2;
         if(m_subMenu.scroller.y > this.m_scrollTop.y + this.m_scrollHeight)
         {
            m_subMenu.scroller.y = this.m_scrollTop.y + this.m_scrollHeight;
         }
         this.repositionList();
      }
      
      private function findEvent(e:MovieClip) : int
      {
         if(Boolean(e) && !e.visible)
         {
            return -1;
         }
         for(var i:int = 0; i < this.m_eventButtons.length; i++)
         {
            if(this.m_eventButtons[i].ButtonInstance == e)
            {
               return i;
            }
         }
         return -1;
      }
      
      public function event_CLICK(e:MouseEvent) : void
      {
         var index:int = this.findEvent(e.target as MovieClip);
         if(index >= 0 && index < this.m_events.length)
         {
            this.m_currentEvent = this.m_events[index];
            removeSelf();
            if(Boolean(this.m_currentEvent.chooseCharacter))
            {
               SoundQueue.instance.playSoundEffect("menu_selectstage");
               MenuController.eventMatchCharacterMenu.reset();
               if(!MenuController.eventMatchCharacterMenu.isOnscreen())
               {
                  MenuController.eventMatchCharacterMenu.show();
               }
            }
            else
            {
               SoundQueue.instance.playSoundEffect("menu_selectstage");
               SoundQueue.instance.playSoundEffect("menu_crowd");
               this.m_game = new Game(Main.MAXPLAYERS,Mode.EVENT);
               this.m_modeInstance = new EventMode(this.m_game,{"eventMatchID":this.m_currentEvent.id},{"classAPI":ResourceManager.getResourceByID("event_mode").getProp("mode")});
               this.m_modeInstance.PreviousMenu = this;
            }
         }
      }
      
      public function event_MOUSE_OVER(e:MouseEvent) : void
      {
         var index:int = this.findEvent(e.target as MovieClip);
         if(index >= 0 && index < this.m_events.length)
         {
            SoundQueue.instance.playSoundEffect("menu_hover");
            this.m_currentEvent = this.m_events[index];
            this.updateDisplay();
         }
      }
      
      public function event_MOUSE_OUT(e:MouseEvent) : void
      {
         var index:int = this.findEvent(e.target as MovieClip);
         if(index >= 0)
         {
            this.m_currentEvent = null;
            this.updateDisplay();
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
      
      public function backMain_CLICK(e:MouseEvent) : void
      {
         removeSelf();
         SoundQueue.instance.playSoundEffect("menu_back");
         MenuController.soloMenu.show();
      }
   }
}

