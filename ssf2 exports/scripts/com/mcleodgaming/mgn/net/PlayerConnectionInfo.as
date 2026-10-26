package com.mcleodgaming.mgn.net
{
   public class PlayerConnectionInfo
   {
      
      public var socket_id:String;
      
      public var username:String;
      
      public var user_key:String;
      
      public var is_dev:Boolean;
      
      public function PlayerConnectionInfo(data:Object = null)
      {
         super();
         this.socket_id = "";
         this.username = "";
         this.user_key = "";
         this.is_dev = false;
         if(Boolean(data))
         {
            this.importPlayerConnectionInfo(data);
         }
      }
      
      public function importPlayerConnectionInfo(data:Object) : void
      {
         var i:* = undefined;
         for(i in data)
         {
            if(i in this)
            {
               this[i] = data[i];
            }
         }
      }
      
      public function exportPlayerConnectionInfo() : Object
      {
         return {
            "socket_id":this.socket_id,
            "username":this.username,
            "user_key":this.user_key,
            "is_dev":this.is_dev
         };
      }
   }
}

