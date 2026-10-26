package com.mcleodgaming.ssf2.util
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.ui.Mouse;
   
   public class MouseTracker
   {
      
      private static var m_disabled:Boolean = false;
      
      private static var m_targetObject:DisplayObject = null;
      
      private static var m_captureStarted:Boolean = false;
      
      private static var m_leftClick:Boolean = false;
      
      private static var m_autoHide:Boolean = false;
      
      private static var m_autoHideTimer:int = 30 * 1;
      
      private static var m_targetHideObject:DisplayObject = null;
      
      init();
      
      public function MouseTracker()
      {
         super();
      }
      
      public static function init() : void
      {
      }
      
      public static function initializeMouseClass() : void
      {
         trace("Mouse class initialized");
      }
      
      public static function setAutoHide(targetObject:DisplayObject, value:Boolean) : void
      {
         if(m_autoHide != value)
         {
            if(m_autoHide)
            {
               m_targetHideObject.removeEventListener(Event.ENTER_FRAME,checkShow);
               m_targetHideObject.removeEventListener(MouseEvent.MOUSE_MOVE,checkHide);
               m_targetHideObject = null;
               m_autoHide = false;
            }
            else
            {
               m_targetHideObject = targetObject;
               m_targetHideObject.addEventListener(Event.ENTER_FRAME,checkShow);
               m_targetHideObject.addEventListener(MouseEvent.MOUSE_MOVE,checkHide);
               m_autoHide = true;
               m_autoHideTimer = 30 * 1;
            }
            m_autoHide = value;
         }
      }
      
      private static function checkHide(e:MouseEvent) : void
      {
         if(m_autoHide)
         {
            m_autoHideTimer = 30 * 1;
            Mouse.show();
         }
      }
      
      private static function checkShow(e:Event) : void
      {
         if(m_autoHideTimer > 0)
         {
            --m_autoHideTimer;
            if(m_autoHideTimer <= 0)
            {
               Mouse.hide();
            }
         }
      }
      
      public static function beginCapture(targetObject:DisplayObject) : void
      {
         if(targetObject != null)
         {
            if(m_captureStarted)
            {
               endCapture();
            }
            m_targetObject = targetObject;
            m_targetObject.addEventListener(MouseEvent.MOUSE_DOWN,MouseTracker.mouseDown);
            m_targetObject.addEventListener(MouseEvent.MOUSE_UP,MouseTracker.mouseUp);
            m_targetObject.addEventListener(MouseEvent.MOUSE_MOVE,MouseTracker.mouseMove);
            m_targetObject.addEventListener(Event.DEACTIVATE,MouseTracker.disable);
            m_targetObject.addEventListener(Event.ACTIVATE,MouseTracker.enable);
            m_captureStarted = true;
            trace("Mouse class activated");
         }
         else
         {
            trace("Error, null target passed to Mouse.as");
         }
      }
      
      public static function endCapture() : void
      {
         if(m_captureStarted)
         {
            m_targetObject.removeEventListener(MouseEvent.MOUSE_DOWN,MouseTracker.mouseDown);
            m_targetObject.removeEventListener(MouseEvent.MOUSE_UP,MouseTracker.mouseUp);
            m_targetObject.removeEventListener(MouseEvent.MOUSE_MOVE,MouseTracker.mouseMove);
            m_targetObject.removeEventListener(Event.DEACTIVATE,MouseTracker.disable);
            m_targetObject.removeEventListener(Event.ACTIVATE,MouseTracker.enable);
            m_targetObject = null;
            m_captureStarted = false;
            m_leftClick = false;
            trace("Mouse class deactivated");
         }
         else
         {
            trace("Warning, attempt to end capture when it was never started");
         }
      }
      
      public static function mouseDown(e:MouseEvent) : void
      {
         m_leftClick = true;
      }
      
      public static function mouseUp(e:MouseEvent) : void
      {
         m_leftClick = false;
      }
      
      public static function mouseMove(e:MouseEvent) : void
      {
      }
      
      public static function disable(e:Event) : void
      {
         m_disabled = true;
      }
      
      public static function enable(e:Event) : void
      {
         m_disabled = false;
      }
      
      public static function get CaptureStarted() : Boolean
      {
         return m_captureStarted;
      }
      
      public static function get IsDown() : Boolean
      {
         return m_leftClick;
      }
      
      public static function get X() : Number
      {
         return m_targetObject.mouseX;
      }
      
      public static function get Y() : Number
      {
         return m_targetObject.mouseY;
      }
      
      public static function getAngle(globalX:Number, globalY:Number) : Number
      {
         var angle:Number = 0;
         var temp:Number = 0;
         if(MouseTracker.X > globalX && MouseTracker.Y < globalY)
         {
            temp = Math.atan2(Math.abs(MouseTracker.Y - globalY),Math.abs(MouseTracker.X - globalX));
            angle = 90 - temp * 180 / Math.PI;
         }
         else if(MouseTracker.X < globalX && MouseTracker.Y < globalY)
         {
            temp = Math.atan2(Math.abs(MouseTracker.Y - globalY),Math.abs(MouseTracker.X - globalX));
            angle = 270 + temp * 180 / Math.PI;
         }
         else if(MouseTracker.X < globalX && MouseTracker.Y > globalY)
         {
            temp = Math.atan2(Math.abs(MouseTracker.Y - globalY),Math.abs(MouseTracker.X - globalX));
            angle = 270 - temp * 180 / Math.PI;
         }
         else if(MouseTracker.X > globalX && MouseTracker.Y > globalY)
         {
            temp = Math.atan2(Math.abs(MouseTracker.Y - globalY),Math.abs(MouseTracker.X - globalX));
            angle = 90 + temp * 180 / Math.PI;
         }
         return angle;
      }
   }
}

