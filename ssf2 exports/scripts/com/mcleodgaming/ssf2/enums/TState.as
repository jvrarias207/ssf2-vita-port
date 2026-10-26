package com.mcleodgaming.ssf2.enums
{
   public class TState
   {
      
      public static const IDLE:uint = 0;
      
      public static const BROKEN:uint = 1;
      
      public static const DEAD:uint = 2;
      
      private static var statesArr:Array = new Array();
      
      statesArr.push("IDLE");
      statesArr.push("BROKEN");
      statesArr.push("DEAD");
      
      public function TState()
      {
         super();
      }
      
      public static function toString(state:uint) : String
      {
         return state >= 0 && state < statesArr.length ? statesArr[state] : "null";
      }
   }
}

