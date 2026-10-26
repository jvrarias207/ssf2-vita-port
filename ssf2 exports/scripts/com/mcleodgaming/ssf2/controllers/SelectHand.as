package com.mcleodgaming.ssf2.controllers
{
   import com.mcleodgaming.ssf2.Main;
   import com.mcleodgaming.ssf2.events.GamepadEvent;
   import com.mcleodgaming.ssf2.util.*;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class SelectHand
   {
      
      protected var BOUNDS_RECT:Rectangle = new Rectangle();
      
      protected var START_POSITION:Point = new Point();
      
      protected var HAND_SPEED:Number = 10;
      
      protected var HAND_ACCEL:Number = 1.5;
      
      protected var m_targetMC:MovieClip;
      
      protected var m_hand:MovieClip;
      
      protected var m_hand_xSpeed:Number;
      
      protected var m_hand_ySpeed:Number;
      
      protected var m_players:Vector.<Controller>;
      
      protected var m_leftRightID:int;
      
      protected var m_upDownID:int;
      
      protected var m_buttons:Vector.<HandButton>;
      
      protected var m_rollOverID:int;
      
      protected var m_backFunc:Function;
      
      protected var m_autoKillEvents:Boolean;
      
      protected var m_clickEventClipsCheckBounds:Vector.<DisplayObject>;
      
      protected var m_clickEventClipsHitTest:Vector.<DisplayObject>;
      
      protected var m_selectLetGo:Object;
      
      protected var m_backLetGo:Object;
      
      public function SelectHand(targetMC:MovieClip, buttons:Vector.<HandButton>, backFunc:Function)
      {
         super();
         this.m_targetMC = targetMC;
         this.m_backFunc = backFunc;
         this.m_hand = MovieClip(this.m_targetMC.addChild(ResourceManager.getLibraryMC("stageselect_hand")));
         this.m_hand.visible = false;
         this.m_hand_xSpeed = 0;
         this.m_hand_ySpeed = 0;
         this.m_selectLetGo = {};
         this.m_backLetGo = {};
         this.m_players = new Vector.<Controller>();
         for(var i:int = 1; i <= SaveData.Controllers.length; i++)
         {
            this.m_players.push(Controller(SaveData.Controllers[i - 1]));
         }
         this.m_leftRightID = -1;
         this.m_upDownID = -1;
         this.m_buttons = buttons;
         this.m_rollOverID = -1;
         this.m_autoKillEvents = true;
         this.BOUNDS_RECT = new Rectangle();
         this.START_POSITION = new Point();
         this.START_POSITION.x = -246;
         this.START_POSITION.y = -132;
         this.BOUNDS_RECT.x = -303;
         this.BOUNDS_RECT.y = -145;
         this.BOUNDS_RECT.width = 600;
         this.BOUNDS_RECT.height = 320;
         this.HAND_SPEED = 10;
         this.HAND_ACCEL = 3;
         this.m_clickEventClipsCheckBounds = new Vector.<DisplayObject>();
         this.m_clickEventClipsHitTest = new Vector.<DisplayObject>();
      }
      
      public function setBackFunction(backFunc:Function) : void
      {
         this.m_backFunc = backFunc;
      }
      
      public function setAutoKillEvents(autoKill:Boolean) : void
      {
         this.m_autoKillEvents = autoKill;
      }
      
      public function addClickEventClipCheckBounds(obj:DisplayObject) : void
      {
         if(this.m_clickEventClipsCheckBounds.indexOf(obj) < 0)
         {
            this.m_clickEventClipsCheckBounds.push(obj);
         }
      }
      
      public function removeClickEventClipCheckBounds(obj:DisplayObject) : void
      {
         var index:int = this.m_clickEventClipsCheckBounds.indexOf(obj);
         if(index >= 0)
         {
            this.m_clickEventClipsCheckBounds.splice(index,1);
         }
      }
      
      public function addClickEventClipHitTest(obj:DisplayObject) : void
      {
         if(this.m_clickEventClipsHitTest.indexOf(obj) < 0)
         {
            this.m_clickEventClipsHitTest.push(obj);
         }
      }
      
      public function removeClickEventClipHitTest(obj:DisplayObject) : void
      {
         var index:int = this.m_clickEventClipsHitTest.indexOf(obj);
         if(index >= 0)
         {
            this.m_clickEventClipsHitTest.splice(index,1);
         }
      }
      
      public function makeEvents() : void
      {
         Main.Root.stage.addEventListener(Event.ENTER_FRAME,this.checkControls);
         Main.Root.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.checkHit);
         for(var i:int = 0; i < SaveData.Controllers.length; i++)
         {
            if(Boolean(SaveData.Controllers[i].GamepadInstance))
            {
               SaveData.Controllers[i].GamepadInstance.addEventListener(GamepadEvent.BUTTON_DOWN,this.checkHit);
            }
         }
         this.resetPosition();
         this.resetLetGo();
      }
      
      public function killEvents() : void
      {
         Main.Root.stage.removeEventListener(Event.ENTER_FRAME,this.checkControls);
         Main.Root.stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.checkHit);
         for(var i:int = 0; i < SaveData.Controllers.length; i++)
         {
            if(Boolean(SaveData.Controllers[i].GamepadInstance))
            {
               SaveData.Controllers[i].GamepadInstance.removeEventListener(GamepadEvent.BUTTON_DOWN,this.checkHit);
            }
         }
      }
      
      public function resetLetGo() : void
      {
         this.m_backLetGo = {};
         this.m_selectLetGo = {};
      }
      
      public function get HandMC() : MovieClip
      {
         return this.m_hand;
      }
      
      public function resetPosition(startPosition:Point = null, bounds:Rectangle = null) : void
      {
         if(Boolean(startPosition))
         {
            this.START_POSITION.x = startPosition.x;
            this.START_POSITION.y = startPosition.y;
         }
         if(Boolean(bounds))
         {
            this.BOUNDS_RECT.x = bounds.x;
            this.BOUNDS_RECT.y = bounds.y;
            this.BOUNDS_RECT.width = bounds.width;
            this.BOUNDS_RECT.height = bounds.height;
         }
         this.m_hand.x = this.START_POSITION.x;
         this.m_hand.y = this.START_POSITION.y;
      }
      
      protected function validateLeftRightID(i:int) : Boolean
      {
         return i == this.m_leftRightID || this.m_leftRightID == -1;
      }
      
      protected function validateUpDownID(i:int) : Boolean
      {
         return i == this.m_upDownID || this.m_upDownID == -1;
      }
      
      protected function move() : void
      {
         this.m_hand.x += this.m_hand_xSpeed;
         this.m_hand.y += this.m_hand_ySpeed;
         this.checkHit(new Event(Event.ENTER_FRAME));
      }
      
      protected function checkControls(e:Event) : void
      {
         var foundStart:Boolean = false;
         var foundSelect:Boolean = false;
         var foundBack:Boolean = false;
         for(var i:int = 0; i < this.m_players.length; i++)
         {
            if(this.m_players[i].IsDown(this.m_players[i]._START))
            {
               foundStart = true;
            }
            if(this.m_players[i].IsDown(this.m_players[i]._BUTTON2))
            {
               foundSelect = true;
            }
            if(this.m_players[i].IsDown(this.m_players[i]._BUTTON1))
            {
               foundBack = true;
            }
            if(this.validateUpDownID(i) && this.m_players[i].IsDown(this.m_players[i]._UP) && !this.m_players[i].IsDown(this.m_players[i]._DOWN))
            {
               this.m_hand.visible = true;
               this.m_hand_ySpeed -= this.m_hand_ySpeed > -this.HAND_SPEED && this.m_hand.y > this.BOUNDS_RECT.y ? this.HAND_ACCEL : 0;
               this.m_upDownID = i;
               if(this.m_hand.y <= this.BOUNDS_RECT.y || this.m_hand_ySpeed > 0)
               {
                  this.m_hand_ySpeed = 0;
               }
            }
            else if(this.validateUpDownID(i) && this.m_players[i].IsDown(this.m_players[i]._DOWN) && !this.m_players[i].IsDown(this.m_players[i]._UP))
            {
               this.m_hand.visible = true;
               this.m_hand_ySpeed += this.m_hand_ySpeed < this.HAND_SPEED && this.m_hand.y < this.BOUNDS_RECT.y + this.BOUNDS_RECT.height ? this.HAND_ACCEL : 0;
               this.m_upDownID = i;
               if(this.m_hand.y >= this.BOUNDS_RECT.y + this.BOUNDS_RECT.height || this.m_hand_ySpeed < 0)
               {
                  this.m_hand_ySpeed = 0;
               }
            }
            else if(this.m_upDownID == i && this.m_upDownID != -1)
            {
               this.m_hand_ySpeed = 0;
               this.m_upDownID = -1;
            }
            if(this.validateLeftRightID(i) && this.m_players[i].IsDown(this.m_players[i]._LEFT) && !this.m_players[i].IsDown(this.m_players[i]._RIGHT))
            {
               this.m_hand.visible = true;
               this.m_hand_xSpeed -= this.m_hand_xSpeed > -this.HAND_SPEED && this.m_hand.x > this.BOUNDS_RECT.x ? this.HAND_ACCEL : 0;
               this.m_leftRightID = i;
               if(this.m_hand.x <= this.BOUNDS_RECT.x || this.m_hand_xSpeed > 0)
               {
                  this.m_hand_xSpeed = 0;
               }
            }
            else if(this.validateLeftRightID(i) && this.m_players[i].IsDown(this.m_players[i]._RIGHT) && !this.m_players[i].IsDown(this.m_players[i]._LEFT))
            {
               this.m_hand.visible = true;
               this.m_hand_xSpeed += this.m_hand_xSpeed < this.HAND_SPEED && this.m_hand.x < this.BOUNDS_RECT.x + this.BOUNDS_RECT.width ? this.HAND_ACCEL : 0;
               this.m_leftRightID = i;
               if(this.m_hand.x >= this.BOUNDS_RECT.x + this.BOUNDS_RECT.width || this.m_hand_xSpeed < 0)
               {
                  this.m_hand_xSpeed = 0;
               }
            }
            else if(this.m_leftRightID == i && this.m_leftRightID != -1)
            {
               this.m_hand_xSpeed = 0;
               this.m_leftRightID = -1;
            }
         }
         this.move();
      }
      
      protected function checkHit(e:Event) : void
      {
         var j:int = 0;
         var found:Boolean = false;
         var isInputEvent:Boolean = e is KeyboardEvent || e is GamepadEvent;
         for(j = 0; j < this.m_players.length; j++)
         {
            if(!this.m_players[j].IsDown(this.m_players[j]._BUTTON2) && !this.m_players[j].IsDown(this.m_players[j]._START))
            {
               this.m_selectLetGo[j] = true;
            }
            if(!this.m_players[j].IsDown(this.m_players[j]._BUTTON1))
            {
               this.m_backLetGo[j] = true;
            }
         }
         var i:int = 0;
         j = 0;
         if(this.m_targetMC.root == null)
         {
            this.killEvents();
         }
         else
         {
            found = false;
            for(j = 0; j < this.m_players.length; j++)
            {
               if(Boolean(this.m_backLetGo[j]) && this.m_players[j].IsDown(this.m_players[j]._BUTTON1))
               {
                  if(this.m_backFunc != null)
                  {
                     this.m_backLetGo[j] = false;
                     if(this.m_autoKillEvents)
                     {
                        this.killEvents();
                     }
                     this.m_backFunc(null);
                     return;
                  }
               }
            }
            i = 0;
            for(; i < this.m_buttons.length && !found; i++)
            {
               if(this.checkBounds(this.m_buttons[i].ButtonInstance) && this.m_hand.visible)
               {
                  if(this.m_rollOverID != i)
                  {
                     if(this.m_rollOverID != -1)
                     {
                        this.m_buttons[this.m_rollOverID].rollout();
                        this.m_buttons[this.m_rollOverID].mouseout();
                     }
                     this.m_buttons[i].rollover();
                     this.m_buttons[i].mouseover();
                  }
                  this.m_rollOverID = i;
                  found = true;
                  j = 0;
                  while(j < this.m_players.length && isInputEvent)
                  {
                     if(this.m_players[j].IsDown(this.m_players[j]._BUTTON2) || this.m_players[j].IsDown(this.m_players[j]._START))
                     {
                        this.m_buttons[i].click();
                        return;
                     }
                     j++;
                  }
               }
            }
            if(isInputEvent)
            {
               this.evaluateExtraButtons();
            }
            if(!found)
            {
               if(this.m_rollOverID != -1)
               {
                  this.m_buttons[this.m_rollOverID].rollout();
               }
               this.m_rollOverID = -1;
            }
         }
      }
      
      protected function evaluateExtraButtons() : void
      {
         var i:int = 0;
         var j:int = 0;
         for(i = 0; i < this.m_clickEventClipsCheckBounds.length; i++)
         {
            if(this.checkBounds(this.m_clickEventClipsCheckBounds[i]) && this.m_hand.visible)
            {
               for(j = 0; j < this.m_players.length; j++)
               {
                  if(Boolean(this.m_selectLetGo[j]) && this.m_players[j].IsDown(this.m_players[j]._BUTTON2))
                  {
                     this.m_selectLetGo[j] = false;
                     this.m_clickEventClipsCheckBounds[i].dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                  }
               }
            }
         }
         for(i = 0; i < this.m_clickEventClipsHitTest.length; i++)
         {
            if(this.m_hand.hitTestObject(this.m_clickEventClipsHitTest[i]) && this.m_hand.visible)
            {
               for(j = 0; j < this.m_players.length; j++)
               {
                  if(Boolean(this.m_selectLetGo[j]) && this.m_players[j].IsDown(this.m_players[j]._BUTTON2))
                  {
                     this.m_selectLetGo[j] = false;
                     this.m_clickEventClipsHitTest[i].dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                  }
               }
            }
         }
      }
      
      protected function checkBounds(mc:DisplayObject, coordinateSpaceOverride:DisplayObject = null) : Boolean
      {
         var rectangle1:Rectangle = mc.getBounds(Boolean(coordinateSpaceOverride) ? coordinateSpaceOverride : mc.parent);
         return mc.visible && rectangle1.containsPoint(new Point(this.m_hand.x,this.m_hand.y));
      }
   }
}

