package com.iam2bam.ane.nativejoystick.intern
{
   import com.iam2bam.ane.nativejoystick.NativeJoystick;
   
   public class NativeJoystickCaps
   {
      
      public var oemName:String;
      
      public var hasAxis:Vector.<Boolean>;
      
      public var axesRange:Vector.<uint>;
      
      public var hasPOV4Dir:Boolean;
      
      public var hasPOV4Cont:Boolean;
      
      public var numAxes:uint;
      
      public var numButtons:uint;
      
      public var miscProductName:String;
      
      public var miscProductID:uint;
      
      public var miscManufacturerID:uint;
      
      public var miscOSDriver:String;
      
      public var miscOSRegKey:String;
      
      public function NativeJoystickCaps()
      {
         var _loc1_:int = 0;
         super();
         hasAxis = new Vector.<Boolean>(8,true);
         axesRange = new Vector.<uint>(8,true);
         _loc1_ = 0;
         while(_loc1_ < 8)
         {
            axesRange[_loc1_] = 1;
            hasAxis[_loc1_] = false;
            _loc1_++;
         }
      }
      
      public function get hasX() : Boolean
      {
         return hasAxis[0];
      }
      
      public function get hasY() : Boolean
      {
         return hasAxis[1];
      }
      
      public function get hasZ() : Boolean
      {
         return hasAxis[2];
      }
      
      public function get hasR() : Boolean
      {
         return hasAxis[3];
      }
      
      public function get hasU() : Boolean
      {
         return hasAxis[4];
      }
      
      public function get hasV() : Boolean
      {
         return hasAxis[5];
      }
      
      public function get hasPOV() : Boolean
      {
         return hasPOV4Dir || hasPOV4Cont;
      }
      
      private function varToString(param1:String) : String
      {
         return "\t" + param1 + "=" + this[param1] + "/" + String(this[param1]).length + "\n";
      }
      
      public function toString() : String
      {
         var _loc2_:int = 0;
         var _loc1_:String = "";
         _loc2_ = 0;
         while(_loc2_ < 8)
         {
            if(hasAxis[_loc2_])
            {
               _loc1_ += "\t\tAxis #" + _loc2_ + " " + NativeJoystick.AXIS_NAMES[_loc2_] + " (0.." + axesRange[_loc2_] + ")\n";
            }
            _loc2_++;
         }
         return "[RadNativeJoystickCaps(\n" + varToString("oemName") + varToString("hasPOV4Dir") + varToString("hasPOV4Cont") + varToString("numButtons") + varToString("numAxes") + _loc1_ + varToString("miscProductName") + varToString("miscProductID") + varToString("miscManufacturerID") + varToString("miscOSDriver") + varToString("miscOSRegKey") + "]";
      }
   }
}

