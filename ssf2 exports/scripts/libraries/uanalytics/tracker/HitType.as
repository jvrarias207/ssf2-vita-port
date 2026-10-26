package libraries.uanalytics.tracker
{
   import flash.system.System;
   import flash.utils.describeType;
   
   public class HitType
   {
      
      public static const PAGEVIEW:String = "pageview";
      
      public static const SCREENVIEW:String = "screenview";
      
      public static const EVENT:String = "event";
      
      public static const TRANSACTION:String = "transaction";
      
      public static const ITEM:String = "item";
      
      public static const SOCIAL:String = "social";
      
      public static const EXCEPTION:String = "exception";
      
      public static const TIMING:String = "timing";
      
      public function HitType()
      {
         super();
      }
      
      public static function isValid(type:String) : Boolean
      {
         var property:String = null;
         var member:XML = null;
         var _class:XML = describeType(HitType);
         var found:Boolean = false;
         for each(member in _class.constant)
         {
            property = String(member.@name);
            if(HitType[property] == type)
            {
               found = true;
               break;
            }
         }
         System.disposeXML(_class);
         if(found)
         {
            return true;
         }
         return false;
      }
   }
}

