package com.iam2bam.ane.nativejoystick.intern
{
   public class NativeJoystickState
   {
      
      public var plugged:Boolean;
      
      public var axesRaw:Vector.<uint>;
      
      public var axes:Vector.<Number>;
      
      public var buttons:uint;
      
      public var povAngle:Number;
      
      public var povPressed:Number;
      
      public function NativeJoystickState()
      {
         super();
         var _loc1_:uint = 8;
         axesRaw = new Vector.<uint>(_loc1_,true);
         axes = new Vector.<Number>(_loc1_,true);
         reset(null,false);
      }
      
      public function reset(param1:NativeJoystickCaps, param2:Boolean) : void
      {
         var _loc4_:int = 0;
         var _loc3_:uint = 8;
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            axesRaw[_loc4_] = param1 == null ? 0 : param1.axesRange[_loc4_] / 2;
            axes[_loc4_] = 0;
            _loc4_++;
         }
         povAngle = 0;
         buttons = 0;
         plugged = param2;
      }
   }
}

