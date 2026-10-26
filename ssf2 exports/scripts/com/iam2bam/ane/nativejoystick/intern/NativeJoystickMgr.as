package com.iam2bam.ane.nativejoystick.intern
{
   import com.iam2bam.ane.nativejoystick.NativeJoystick;
   import com.iam2bam.ane.nativejoystick.event.NativeJoystickEvent;
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.external.ExtensionContext;
   import flash.utils.Timer;
   
   public class NativeJoystickMgr extends EventDispatcher
   {
      
      public static const TRACE_SILENT:uint = 0;
      
      public static const TRACE_NORMAL:uint = 1;
      
      public static const TRACE_VERBOSE:uint = 2;
      
      public static const TRACE_DIAGNOSE:uint = 3;
      
      private static var _mgr:NativeJoystickMgr;
      
      public static const DEF_POLL_INTERVAL:Number = 33;
      
      private static const VERSION:String = "1.11";
      
      public var dispatchAlreadyPlugged:Boolean = true;
      
      private var _ectx:ExtensionContext;
      
      private var _pollInterval:Number;
      
      private var _traceLevel:uint;
      
      private var _detectIntervalMillis:uint;
      
      private var _tmrPoll:Timer;
      
      private var _data:Vector.<NativeJoystickData>;
      
      private var _maxDevs:int;
      
      private var _analogThreshold:Number = 0.1;
      
      private const STR_UPDATEJOYSTICKS:String = "updateJoysticks";
      
      public function NativeJoystickMgr()
      {
         super();
         try
         {
            _traceLevel = 1;
            _maxDevs = -1;
            _pollInterval = 33;
            _ectx = ExtensionContext.createExtensionContext("com.iam2bam.ane.nativejoystick",null);
            _maxDevs = int(_ectx.call("getMaxDevices"));
            _data = new Vector.<NativeJoystickData>(_maxDevs,true);
            trace("NativeJoystick extension by 2bam.com - v" + version);
            if("1.11" != version)
            {
               trace("NativeJoystick dll/ane version mismatch: DLL v" + version + " ANE v" + "1.11");
            }
            detectIntervalMillis = 300;
            _tmrPoll = new Timer(_pollInterval);
            _tmrPoll.addEventListener("timer",onTimerPoll,false,0,true);
            _tmrPoll.start();
            updateJoysticks();
         }
         catch(error:Error)
         {
            trace("NativeJoystickMgr: error creating extension context");
            trace(error.errorID,error.name,error.message);
         }
      }
      
      public static function instance() : NativeJoystickMgr
      {
         if(!_mgr)
         {
            _mgr = new NativeJoystickMgr();
         }
         return _mgr;
      }
      
      public static function dispose() : void
      {
         if(_mgr)
         {
            _mgr._ectx.dispose();
            _mgr._tmrPoll.stop();
            _mgr = null;
         }
      }
      
      public function isPlugged(param1:uint) : Boolean
      {
         if(param1 < 0 || param1 >= _maxDevs)
         {
            return false;
         }
         return _data[param1] != null ? _data[param1].detected && _data[param1].curr.plugged : false;
      }
      
      public function getData(param1:uint) : NativeJoystickData
      {
         if(param1 > _maxDevs)
         {
            return null;
         }
         var _loc2_:NativeJoystickData = _data[param1];
         if(!_loc2_)
         {
            _data[param1] = _loc2_ = new NativeJoystickData(param1);
         }
         return _loc2_;
      }
      
      public function get pollInterval() : Number
      {
         return _pollInterval;
      }
      
      override public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         var _loc6_:NativeJoystickEvent = null;
         var _loc8_:int = 0;
         var _loc7_:NativeJoystickData = null;
         super.addEventListener(param1,param2,param3,param4,param5);
         if(dispatchAlreadyPlugged && param1 == "NJOYPlugged")
         {
            _loc8_ = _maxDevs - 1;
            while(_loc8_ >= 0)
            {
               _loc7_ = _data[_loc8_];
               if(!(!_loc7_ || !_loc7_.curr.plugged))
               {
                  _ectx.call("getCapabilities",_loc8_,_loc7_.caps);
                  _loc7_.curr.reset(_loc7_.caps,true);
                  _loc7_.prev.reset(_loc7_.caps,false);
                  if(!_loc6_)
                  {
                     _loc6_ = new NativeJoystickEvent("NJOYPlugged");
                  }
                  _loc6_.index = _loc8_;
                  if(!_loc7_.joystick)
                  {
                     _loc7_.joystick = new NativeJoystick(_loc8_);
                  }
                  _loc6_.joystick = _loc7_.joystick;
                  param2(_loc6_);
               }
               _loc8_--;
            }
         }
      }
      
      public function set pollInterval(param1:Number) : void
      {
         _pollInterval = param1;
         if(param1 <= 0)
         {
            if(_tmrPoll)
            {
               _tmrPoll.stop();
            }
         }
         else
         {
            if(param1 < 20)
            {
               trace("RadNativeJoystickMgr: A pollInterval of less than 20 ms is not recommended (default and suggested value is 33 ms)");
            }
            if(_tmrPoll)
            {
               _tmrPoll.delay = param1;
               if(!_tmrPoll.running)
               {
                  _tmrPoll.start();
                  updateJoysticks();
               }
            }
         }
      }
      
      public function reloadDriverConfig() : void
      {
         _ectx.call("reloadDriverConfig");
      }
      
      private function createEvent(param1:String, param2:NativeJoystickData) : NativeJoystickEvent
      {
         var _loc3_:NativeJoystickEvent = new NativeJoystickEvent(param1);
         _loc3_.index = param2.index;
         if(!param2.joystick)
         {
            param2.joystick = new NativeJoystick(param2.index);
         }
         _loc3_.joystick = param2.joystick;
         return _loc3_;
      }
      
      private function onTimerPoll(param1:TimerEvent) : void
      {
         var _loc11_:int = 0;
         var _loc6_:NativeJoystickData = null;
         var _loc18_:NativeJoystickCaps = null;
         var _loc5_:* = 0;
         var _loc3_:* = 0;
         var _loc20_:* = 0;
         var _loc19_:* = 0;
         var _loc10_:int = 0;
         var _loc15_:NativeJoystickEvent = null;
         var _loc14_:int = 0;
         var _loc12_:int = 0;
         var _loc8_:int = 0;
         var _loc23_:* = undefined;
         var _loc25_:* = undefined;
         var _loc13_:* = undefined;
         var _loc9_:* = undefined;
         var _loc17_:* = undefined;
         var _loc7_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc24_:String = null;
         updateJoysticks();
         var _loc22_:Boolean = hasEventListener("NJOYButtonDown");
         var _loc21_:Boolean = hasEventListener("NJOYButtonUp");
         var _loc16_:Boolean = hasEventListener("NJOYAxisMove");
         _loc11_ = _maxDevs - 1;
         while(_loc11_ >= 0)
         {
            _loc6_ = _data[_loc11_];
            if(!(!_loc6_ || !_loc6_.detected))
            {
               _loc18_ = _loc6_.caps;
               if(_loc18_)
               {
                  _loc5_ = _loc6_.curr.buttons;
                  _loc3_ = _loc6_.prev.buttons;
                  _loc20_ = _loc6_.buttonsJP = _loc5_ & ~_loc3_;
                  _loc19_ = _loc6_.buttonsJR = ~_loc5_ & _loc3_;
                  if(_loc22_ || _loc21_)
                  {
                     if(!_loc22_)
                     {
                        _loc20_ = 0;
                     }
                     if(!_loc21_)
                     {
                        _loc19_ = 0;
                     }
                     _loc14_ = 1;
                     _loc12_ = int(_loc18_.numButtons);
                     _loc10_ = 0;
                     while(_loc10_ < _loc12_)
                     {
                        if(_loc20_ & _loc14_)
                        {
                           _loc15_ = createEvent("NJOYButtonDown",_loc6_);
                           _loc15_.buttonIndex = _loc10_;
                           dispatchEvent(_loc15_);
                        }
                        else if(_loc19_ & _loc14_)
                        {
                           _loc15_ = createEvent("NJOYButtonUp",_loc6_);
                           _loc15_.buttonIndex = _loc10_;
                           dispatchEvent(_loc15_);
                        }
                        _loc14_ <<= 1;
                        _loc10_++;
                     }
                  }
                  _loc8_ = 8;
                  _loc23_ = _loc6_.curr.axes;
                  _loc25_ = _loc6_.prev.axes;
                  _loc13_ = _loc18_.axesRange;
                  _loc9_ = _loc18_.hasAxis;
                  _loc17_ = _loc6_.curr.axesRaw;
                  _loc10_ = 0;
                  while(_loc10_ < _loc8_)
                  {
                     _loc2_ = _loc25_[_loc10_];
                     if(_loc9_[_loc10_])
                     {
                        _loc23_[_loc10_] = _loc7_ = 2 * _loc17_[_loc10_] / _loc13_[_loc10_] - 1;
                        if(-_analogThreshold < _loc7_ && _loc7_ < _analogThreshold)
                        {
                           _loc7_ = 0;
                        }
                        if(-_analogThreshold < _loc2_ && _loc2_ < _analogThreshold)
                        {
                           _loc2_ = 0;
                        }
                        _loc4_ = _loc7_ - _loc2_;
                        if(_loc16_ && _loc4_ != 0)
                        {
                           _loc15_ = createEvent("NJOYAxisMove",_loc6_);
                           _loc15_.axisIndex = _loc10_;
                           _loc15_.axisValue = _loc7_;
                           _loc15_.axisDelta = _loc4_;
                           dispatchEvent(_loc15_);
                        }
                     }
                     _loc10_++;
                  }
                  if(_loc6_.curr.plugged != _loc6_.prev.plugged)
                  {
                     if(_loc6_.curr.plugged)
                     {
                        _loc24_ = "NJOYPlugged";
                        _ectx.call("getCapabilities",_loc11_,_loc6_.caps);
                        _loc6_.curr.reset(_loc6_.caps,true);
                        _loc6_.prev.reset(_loc6_.caps,false);
                        if(_traceLevel >= 1)
                        {
                           trace("[NJOY] Joystick #" + _loc6_.index + " plugged.");
                        }
                        if(_traceLevel >= 2)
                        {
                           trace("[NJOY] Caps for joystick #" + _loc11_);
                           trace(_loc6_.caps + "\n");
                        }
                     }
                     else if(!_loc6_.detected)
                     {
                        _loc24_ = "NJOYUnplugged";
                        if(_traceLevel >= 2)
                        {
                           trace("[NJOY] Joystick #" + _loc6_.index + " unplugged w/errors");
                        }
                     }
                     else
                     {
                        _loc24_ = "NJOYUnplugged";
                        if(_traceLevel >= 2)
                        {
                           trace("[NJOY] Joystick #" + _loc6_.index + " unplugged");
                        }
                     }
                     if(hasEventListener(_loc24_))
                     {
                        dispatchEvent(createEvent(_loc24_,_loc6_));
                     }
                  }
               }
            }
            _loc11_--;
         }
      }
      
      public function get traceLevel() : uint
      {
         return _traceLevel;
      }
      
      public function set traceLevel(param1:uint) : void
      {
         if(_traceLevel != param1)
         {
            _traceLevel = param1;
            _ectx.call("setTraceLevel",param1);
         }
      }
      
      public function get detectIntervalMillis() : uint
      {
         return _detectIntervalMillis;
      }
      
      public function set detectIntervalMillis(param1:uint) : void
      {
         if(_detectIntervalMillis != param1)
         {
            _detectIntervalMillis = param1;
            _ectx.call("setDetectDelay",param1);
         }
      }
      
      public function get version() : String
      {
         return String(_ectx.call("getVersion"));
      }
      
      public function getCapabilities(param1:uint, param2:NativeJoystickCaps) : void
      {
         _ectx.call("getCapabilities",param1,param2);
      }
      
      public function updateJoysticks() : void
      {
         _ectx.call("updateJoysticks",_data);
      }
      
      public function get maxJoysticks() : int
      {
         return _maxDevs;
      }
      
      public function get analogThreshold() : Number
      {
         return _analogThreshold;
      }
      
      public function set analogThreshold(param1:Number) : void
      {
         if(param1 < 0)
         {
            param1 = 0;
         }
         if(param1 > 1)
         {
            param1 = 1;
         }
         _analogThreshold = param1;
      }
   }
}

