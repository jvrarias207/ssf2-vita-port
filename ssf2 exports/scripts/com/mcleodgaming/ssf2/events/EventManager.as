package com.mcleodgaming.ssf2.events
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class EventManager
   {
      
      private var _eventDispatcher:EventDispatcher;
      
      private var _eventList:Vector.<String>;
      
      private var _functionList:Vector.<Function>;
      
      private var _useCaptureList:Vector.<Boolean>;
      
      public function EventManager()
      {
         super();
         this._eventDispatcher = new EventDispatcher();
         this._eventList = new Vector.<String>();
         this._functionList = new Vector.<Function>();
         this._useCaptureList = new Vector.<Boolean>();
      }
      
      public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void
      {
         this._eventDispatcher.addEventListener(type,listener,useCapture,priority,useWeakReference);
         this._eventList.push(type);
         this._functionList.push(listener);
         this._useCaptureList.push(useCapture);
      }
      
      public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false) : void
      {
         for(var i:int = 0; i < this._eventList.length; i++)
         {
            if(type == this._eventList[i] && listener == this._functionList[i] && this.hasEvent(type,listener))
            {
               this._eventList.splice(i,1);
               this._functionList.splice(i,1);
               this._useCaptureList.splice(i,1);
               this._eventDispatcher.removeEventListener(type,listener,useCapture);
               i--;
            }
         }
      }
      
      public function dispatchEvent(event:Event) : void
      {
         this._eventDispatcher.dispatchEvent(event);
      }
      
      public function hasEvent(type:String, listener:Function) : Boolean
      {
         for(var i:int = 0; i < this._eventList.length; i++)
         {
            if(type == this._eventList[i] && (listener == null || listener == this._functionList[i]))
            {
               return true;
            }
         }
         return false;
      }
      
      public function removeAllEvents() : void
      {
         while(this.Count > 0)
         {
            this.removeEventListener(this._eventList[0],this._functionList[0],this._useCaptureList[0]);
            this._eventList.splice(0,1);
            this._functionList.splice(0,1);
            this._useCaptureList.splice(0,1);
         }
      }
      
      public function get Count() : int
      {
         return this._eventList.length;
      }
   }
}

