package com.mcleodgaming.ssf2.util
{
   import com.mcleodgaming.ssf2.input.Gamepad;
   import com.mcleodgaming.ssf2.input.Keyboard;
   
   public class Controller
   {
      
      public const _UP:String = "UP";
      
      public const _DOWN:String = "DOWN";
      
      public const _LEFT:String = "LEFT";
      
      public const _RIGHT:String = "RIGHT";
      
      public const _JUMP:String = "JUMP";
      
      public const _BUTTON1:String = "BUTTON1";
      
      public const _BUTTON2:String = "BUTTON2";
      
      public const _GRAB:String = "GRAB";
      
      public const _START:String = "START";
      
      public const _TAUNT:String = "TAUNT";
      
      public const _SHIELD:String = "SHIELD";
      
      public const _SHIELD2:String = "SHIELD2";
      
      public const _JUMP2:String = "JUMP2";
      
      public const _C_UP:String = "C_UP";
      
      public const _C_DOWN:String = "C_DOWN";
      
      public const _C_LEFT:String = "C_LEFT";
      
      public const _C_RIGHT:String = "C_RIGHT";
      
      public const _DASH:String = "DASH";
      
      public const _JUMP3:String = "JUMP3";
      
      public var _TAP_JUMP:int;
      
      public var _AUTO_DASH:int;
      
      public var _DT_DASH:int;
      
      private var m_controlsObject:ControlsObject;
      
      private var _ID:int;
      
      private var m_controlBitsQueue:Vector.<int>;
      
      private var m_objQueue:Vector.<Object>;
      
      private var m_keyboard:Keyboard;
      
      private var m_gamepad:Gamepad;
      
      public function Controller(tempID:int, controls:Object)
      {
         var key:String = null;
         super();
         this._ID = tempID;
         this.m_keyboard = new Keyboard();
         this.m_gamepad = null;
         this.setControls(controls);
         this.m_controlsObject = new ControlsObject();
         this.m_controlBitsQueue = new Vector.<int>();
         this.m_objQueue = new Vector.<Object>();
      }
      
      public function get ID() : int
      {
         return this._ID;
      }
      
      public function get ControlsQueue() : Vector.<int>
      {
         return this.m_controlBitsQueue;
      }
      
      public function get KeyboardInstance() : Keyboard
      {
         return this.m_keyboard;
      }
      
      public function get GamepadInstance() : Gamepad
      {
         return this.m_gamepad;
      }
      
      public function set GamepadInstance(gamepad:Gamepad) : void
      {
         this.m_gamepad = gamepad;
         if(Boolean(this.m_gamepad))
         {
            this.m_gamepad.ControlsMap["TAP_JUMP"] = this._TAP_JUMP;
            this.m_gamepad.ControlsMap["AUTO_DASH"] = this._AUTO_DASH;
            this.m_gamepad.ControlsMap["DT_DASH"] = this._DT_DASH;
         }
      }
      
      public function getControls() : Object
      {
         var controls:Object = this.m_keyboard.exportControls();
         controls["TAP_JUMP"] = this._TAP_JUMP;
         controls["AUTO_DASH"] = this._AUTO_DASH;
         controls["DT_DASH"] = this._DT_DASH;
         return controls;
      }
      
      public function getControlStatus() : ControlsObject
      {
         var controls:ControlsObject = new ControlsObject();
         controls.UP = this.IsDown(this._UP);
         controls.DOWN = this.IsDown(this._DOWN);
         controls.LEFT = this.IsDown(this._LEFT);
         controls.RIGHT = this.IsDown(this._RIGHT);
         controls.JUMP = this.IsDown(this._JUMP);
         controls.BUTTON1 = this.IsDown(this._BUTTON1);
         controls.BUTTON2 = this.IsDown(this._BUTTON2);
         controls.GRAB = this.IsDown(this._GRAB);
         controls.START = this.IsDown(this._START);
         controls.TAUNT = this.IsDown(this._TAUNT);
         controls.SHIELD = this.IsDown(this._SHIELD);
         controls.JUMP2 = this.IsDown(this._JUMP2);
         controls.C_UP = this.IsDown(this._C_UP);
         controls.C_DOWN = this.IsDown(this._C_DOWN);
         controls.C_LEFT = this.IsDown(this._C_LEFT);
         controls.C_RIGHT = this.IsDown(this._C_RIGHT);
         controls.DASH = this.IsDown(this._DASH);
         controls.TAP_JUMP = this._TAP_JUMP == 1;
         controls.AUTO_DASH = this._AUTO_DASH == 1;
         controls.DT_DASH = this._DT_DASH == 1;
         controls.SHIELD2 = this.IsDown(this._SHIELD2);
         controls.JUMP3 = controls.TAP_JUMP && this.IsDown(this._UP);
         return controls;
      }
      
      public function queueControlBits(num:int) : void
      {
         this.m_controlBitsQueue.push(num);
      }
      
      public function nextControlBits() : int
      {
         var tmp:int = this.m_controlBitsQueue.length > 0 ? this.m_controlBitsQueue[0] : 0;
         this.m_controlBitsQueue.splice(0,1);
         return tmp;
      }
      
      public function flushControlBits() : Vector.<int>
      {
         return this.m_controlBitsQueue.splice(0,this.m_controlBitsQueue.length);
      }
      
      public function getControlsObject() : ControlsObject
      {
         return this.m_controlsObject;
      }
      
      public function setControlsObject(controlsObj:ControlsObject) : void
      {
         this.m_controlsObject.controls = controlsObj.controls;
      }
      
      public function setControls(controls:Object) : void
      {
         var key:String = null;
         if(controls != null)
         {
            for(key in controls)
            {
               try
               {
                  if(key in this.m_keyboard.ControlsMap)
                  {
                     this.m_keyboard.ControlsMap[key] = controls[key];
                  }
                  else if(["_TAP_JUMP","_AUTO_DASH","_DT_DASH"].indexOf("_" + key) >= 0)
                  {
                     this["_" + key] = controls[key];
                  }
                  else
                  {
                     trace(key + " [in Controller.as] does not exist!!");
                  }
               }
               catch(e:*)
               {
                  trace("A control wasn\'t set somewhere (" + key + ")");
               }
            }
         }
      }
      
      public function IsDown(keyNum:String) : Boolean
      {
         if(Boolean(this.m_gamepad))
         {
            return this.m_gamepad.isPressed(keyNum);
         }
         return this.m_keyboard.isPressed(keyNum);
      }
   }
}

