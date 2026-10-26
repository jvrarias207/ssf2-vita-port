package com.mcleodgaming.ssf2.menus
{
   import com.mcleodgaming.ssf2.interfaces.IDebugConsole;
   
   public class DebugConsole extends Menu implements IDebugConsole
   {
      
      public static var DISABLE_OFFSCREEN_BUBBLE:Boolean = false;
      
      public static var globalHash:Object = {};
      
      public function DebugConsole()
      {
         super();
      }
      
      public function get ControlsCapture() : Boolean
      {
         return false;
      }
      
      public function get OnlineCapture() : Boolean
      {
         return false;
      }
      
      public function get PingCapture() : Boolean
      {
         return false;
      }
      
      public function get AttackStateCapture() : Boolean
      {
         return false;
      }
      
      public function get KnockbackCapture() : Boolean
      {
         return false;
      }
      
      public function get Alerts() : Boolean
      {
         return false;
      }
      
      public function set Alerts(value:Boolean) : void
      {
      }
      
      public function get DisableKeyCapture() : Boolean
      {
         return false;
      }
      
      public function forceShow() : void
      {
      }
      
      public function alert(str:String) : void
      {
      }
      
      public function writeEndAttackControls(str:String) : void
      {
      }
      
      public function writeTextData(str:String) : void
      {
      }
   }
}

