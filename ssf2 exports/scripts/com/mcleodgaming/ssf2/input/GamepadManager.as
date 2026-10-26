package com.mcleodgaming.ssf2.input
{
   import com.iam2bam.ane.nativejoystick.NativeJoystick;
   import com.iam2bam.ane.nativejoystick.event.NativeJoystickEvent;
   import com.iam2bam.ane.nativejoystick.intern.NativeJoystickMgr;
   import com.mcleodgaming.ssf2.Version;
   import flash.events.Event;
   import flash.events.GameInputEvent;
   import flash.system.Capabilities;
   import flash.ui.GameInput;
   import flash.ui.GameInputControl;
   import flash.ui.GameInputDevice;
   
   public class GamepadManager
   {
      
      protected static var m_nativeJoystick:NativeJoystickMgr;
      
      protected static var m_gameInput:GameInput;
      
      protected static var m_gamepadDeviceMap:Object;
      
      protected static var m_gamepadInstanceMap:Object;
      
      protected static var m_gamepadInstanceList:Vector.<Gamepad>;
      
      public function GamepadManager()
      {
         super();
      }
      
      public static function init() : void
      {
         GamepadManager.m_gamepadDeviceMap = {};
         GamepadManager.m_gamepadInstanceMap = {};
         GamepadManager.m_gamepadInstanceList = new Vector.<Gamepad>();
         if(Version.supportedProfiles.indexOf("extendedDesktop") >= 0 && Capabilities.os.indexOf("Mac") < 0)
         {
            GamepadManager.setupGameInputNative();
         }
         else
         {
            GamepadManager.setupGameInput();
         }
      }
      
      protected static function setupGameInput() : void
      {
         GamepadManager.m_gameInput = new GameInput();
         GamepadManager.m_gameInput.addEventListener(GameInputEvent.DEVICE_ADDED,GamepadManager.onDeviceAttached);
         GamepadManager.m_gameInput.addEventListener(GameInputEvent.DEVICE_REMOVED,GamepadManager.onDeviceRemoved);
         GamepadManager.m_gameInput.addEventListener(GameInputEvent.DEVICE_UNUSABLE,GamepadManager.onDeviceError);
      }
      
      protected static function onDeviceAttached(e:GameInputEvent) : void
      {
         var i:int = 0;
         var control:GameInputControl = null;
         var device:GameInputDevice = e.device;
         var identifier:String = device.id + device.name;
         GamepadManager.m_gamepadDeviceMap[identifier] = device;
         var oldGamepads:Vector.<Gamepad> = getGamepads();
         var targetPort:int = 1;
         for(i = 0; i < oldGamepads.length; i++)
         {
            if(oldGamepads[i].Name === device.name && oldGamepads[i].Port === targetPort)
            {
               targetPort++;
               i = -1;
            }
         }
         var gamepad:Gamepad = Boolean(m_gamepadInstanceMap[identifier]) ? m_gamepadInstanceMap[identifier] : new Gamepad(device.name,targetPort);
         m_gamepadInstanceMap[identifier] = gamepad;
         m_gamepadInstanceList.push(gamepad);
         device.enabled = true;
         for(i = 0; i < device.numControls; i++)
         {
            control = device.getControlAt(i);
            control.addEventListener(Event.CHANGE,GamepadManager.onDeviceInput);
            Gamepad(m_gamepadInstanceMap[identifier]).registerInput(control.id,control.minValue,control.maxValue,control.value);
         }
      }
      
      protected static function onDeviceInput(e:Event) : void
      {
         var control:GameInputControl = GameInputControl(e.currentTarget);
         var device:GameInputDevice = control.device;
         var identifier:String = device.id + device.name;
         var gamepad:Gamepad = Gamepad(m_gamepadInstanceMap[identifier]);
         if(Boolean(gamepad))
         {
            gamepad.onDeviceInput(control.id,control.value);
         }
      }
      
      protected static function onDeviceRemoved(e:GameInputEvent) : void
      {
         var control:GameInputControl = null;
         var device:GameInputDevice = e.device;
         var identifier:String = device.id + device.name;
         for(var i:int = 0; i < device.numControls; i++)
         {
            control = device.getControlAt(i);
            control.removeEventListener(Event.CHANGE,Gamepad(m_gamepadInstanceMap[identifier]).onDeviceInput);
         }
         m_gamepadInstanceList.splice(m_gamepadInstanceList.indexOf(m_gamepadDeviceMap[identifier]),1);
         delete m_gamepadDeviceMap[device.id + device.name];
      }
      
      protected static function onDeviceError(e:GameInputEvent) : void
      {
         trace("Device errroed");
      }
      
      public static function getGamepads() : Vector.<Gamepad>
      {
         var gamepads:Vector.<Gamepad> = new Vector.<Gamepad>();
         for(var i:int = 0; i < m_gamepadInstanceList.length; i++)
         {
            gamepads.push(m_gamepadInstanceList[i]);
         }
         return gamepads;
      }
      
      protected static function setupGameInputNative() : void
      {
         GamepadManager.m_nativeJoystick = new NativeJoystickMgr();
         GamepadManager.m_nativeJoystick.pollInterval = 20;
         GamepadManager.m_nativeJoystick.detectIntervalMillis = 500;
         GamepadManager.m_nativeJoystick.addEventListener(NativeJoystickEvent.JOY_PLUGGED,onDeviceAttachedNative);
         GamepadManager.m_nativeJoystick.addEventListener(NativeJoystickEvent.JOY_UNPLUGGED,onDeviceRemovedNative);
      }
      
      protected static function onDeviceAttachedNative(e:NativeJoystickEvent) : void
      {
         var getCaps:Function = function():void
         {
            var joyStick:NativeJoystick = null;
            var identifier:String = null;
            var i:int = 0;
            var oldGamepads:Vector.<Gamepad> = null;
            var targetPort:int = 0;
            var gamepad:Gamepad = null;
            try
            {
               GamepadManager.m_nativeJoystick.getCapabilities(e.joystick.index,e.joystick.capabilities);
            }
            catch(err:*)
            {
               return;
            }
            if(e.joystick.capabilities.numButtons)
            {
               joyStick = e.joystick;
               identifier = (joyStick.capabilities.oemName || "Generic Device") + joyStick.index;
               GamepadManager.m_gamepadDeviceMap[identifier] = joyStick;
               oldGamepads = getGamepads();
               targetPort = 1;
               for(i = 0; i < oldGamepads.length; i++)
               {
                  if(oldGamepads[i].Name === (joyStick.capabilities.oemName || "Generic Device") && oldGamepads[i].Port === targetPort)
                  {
                     targetPort++;
                     i = -1;
                  }
               }
               gamepad = Boolean(m_gamepadInstanceMap[identifier]) ? m_gamepadInstanceMap[identifier] : new Gamepad(joyStick.capabilities.oemName || "Generic Device",targetPort);
               m_gamepadInstanceMap[identifier] = gamepad;
               m_gamepadInstanceList.unshift(gamepad);
               GamepadManager.m_nativeJoystick.addEventListener(NativeJoystickEvent.BUTTON_DOWN,onNativeDeviceInput);
               GamepadManager.m_nativeJoystick.addEventListener(NativeJoystickEvent.BUTTON_UP,onNativeDeviceInput);
               GamepadManager.m_nativeJoystick.addEventListener(NativeJoystickEvent.AXIS_MOVE,onNativeDeviceInput);
               for(i = 0; i < joyStick.numButtons; i++)
               {
                  Gamepad(m_gamepadInstanceMap[identifier]).registerInput("BUTTON_" + i,0,1,0);
               }
               try
               {
                  for(i = 0; i < e.joystick.capabilities.axesRange.length; i++)
                  {
                     if(e.joystick.hasAxis(i))
                     {
                        Gamepad(m_gamepadInstanceMap[identifier]).registerInput("AXIS_" + i,-1,1,0);
                     }
                  }
               }
               catch(e:RangeError)
               {
               }
               catch(e:Error)
               {
                  trace(e);
               }
               fixNativePortOrder();
            }
         };
         getCaps();
      }
      
      protected static function fixNativePortOrder() : void
      {
         var ports:Object = {};
         for(var i:int = 0; i < m_gamepadInstanceList.length; i++)
         {
            ports[m_gamepadInstanceList[i].Name] = ports[m_gamepadInstanceList[i].Name] || 0;
            ++ports[m_gamepadInstanceList[i].Name];
            m_gamepadInstanceList[i].Port = ports[m_gamepadInstanceList[i].Name];
         }
      }
      
      protected static function onNativeDeviceInput(e:NativeJoystickEvent) : void
      {
         var gamepad:Gamepad = null;
         var joyStick:NativeJoystick = e.joystick;
         var identifier:String = (joyStick.capabilities.oemName || "Generic Device") + joyStick.index;
         if(Boolean(m_gamepadDeviceMap[identifier]))
         {
            gamepad = m_gamepadInstanceMap[identifier];
            if(e.type === NativeJoystickEvent.BUTTON_DOWN)
            {
               gamepad.onDeviceInput("BUTTON_" + e.buttonIndex,1);
            }
            else if(e.type === NativeJoystickEvent.BUTTON_UP)
            {
               gamepad.onDeviceInput("BUTTON_" + e.buttonIndex,0);
            }
            else if(e.type === NativeJoystickEvent.AXIS_MOVE)
            {
               gamepad.onDeviceInput("AXIS_" + e.axisIndex,e.axisValue);
            }
         }
      }
      
      protected static function onDeviceRemovedNative(e:NativeJoystickEvent) : void
      {
         var joyStick:NativeJoystick = e.joystick;
         var identifier:String = (joyStick.capabilities.oemName || "Generic Device") + joyStick.index;
         GamepadManager.m_nativeJoystick.removeEventListener(NativeJoystickEvent.BUTTON_DOWN,onNativeDeviceInput);
         GamepadManager.m_nativeJoystick.removeEventListener(NativeJoystickEvent.BUTTON_UP,onNativeDeviceInput);
         GamepadManager.m_nativeJoystick.removeEventListener(NativeJoystickEvent.AXIS_MOVE,onNativeDeviceInput);
         m_gamepadInstanceList.splice(m_gamepadInstanceList.indexOf(m_gamepadDeviceMap[identifier]),1);
         delete m_gamepadDeviceMap[identifier];
      }
   }
}

