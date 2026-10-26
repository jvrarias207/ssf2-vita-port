package com.mcleodgaming.ssf2.input
{
   import com.mcleodgaming.ssf2.util.Key;
   
   public class Keyboard
   {
      
      protected var m_controlState:Object;
      
      protected var m_controlsMap:Object;
      
      public function Keyboard()
      {
         super();
         this.m_controlState = {};
         this.m_controlsMap = {};
         this.resetControlsMap();
      }
      
      public function get ControlsMap() : Object
      {
         return this.m_controlsMap;
      }
      
      private function resetControlsMap() : void
      {
         this.m_controlsMap["SHIELD"] = 0;
         this.m_controlsMap["TAUNT"] = 0;
         this.m_controlsMap["START"] = 0;
         this.m_controlsMap["GRAB"] = 0;
         this.m_controlsMap["BUTTON2"] = 0;
         this.m_controlsMap["BUTTON1"] = 0;
         this.m_controlsMap["JUMP"] = 0;
         this.m_controlsMap["RIGHT"] = 0;
         this.m_controlsMap["LEFT"] = 0;
         this.m_controlsMap["DOWN"] = 0;
         this.m_controlsMap["UP"] = 0;
         this.m_controlsMap["DASH"] = 0;
         this.m_controlsMap["C_RIGHT"] = 0;
         this.m_controlsMap["C_LEFT"] = 0;
         this.m_controlsMap["C_DOWN"] = 0;
         this.m_controlsMap["C_UP"] = 0;
         this.m_controlsMap["JUMP2"] = 0;
         this.m_controlsMap["SHIELD2"] = 0;
      }
      
      public function isPressed(id:String) : Boolean
      {
         return Boolean(this.getState(id)) ? true : false;
      }
      
      public function getState(id:String) : Number
      {
         return this.m_controlsMap[id] === 0 ? 0 : (Key.isDown(this.m_controlsMap[id]) ? 1 : 0);
      }
      
      public function getValue(id:String) : Number
      {
         if(Boolean(this.m_controlState[id]))
         {
            if(this.m_controlState[id].type === "axis")
            {
               if(this.m_controlState[id].value > Math.abs(this.m_controlState[id].maxValue) * this.m_controlState[id].deadZone)
               {
                  return this.m_controlState[id].value;
               }
               return 0;
            }
            return this.m_controlState[id].value;
         }
         return 0;
      }
      
      public function exportControls() : Object
      {
         var i:* = undefined;
         var controls:Object = {};
         for(i in this.m_controlsMap)
         {
            controls[i] = this.m_controlsMap[i];
         }
         return controls;
      }
      
      public function importControls(obj:Object) : void
      {
         var i:* = undefined;
         this.resetControlsMap();
         for(i in obj)
         {
            if(this.m_controlsMap[i] is Number)
            {
               this.m_controlsMap[i] = obj[i];
            }
         }
      }
   }
}

