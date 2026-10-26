package com.mcleodgaming.ssf2.api
{
   import com.mcleodgaming.ssf2.engine.Beacon;
   
   public class SSF2Beacon extends SSF2GameObject
   {
      
      protected var _ownerCasted:Beacon;
      
      public function SSF2Beacon(api:Class, owner:Beacon)
      {
         super(api,owner);
         this._ownerCasted = owner;
      }
   }
}

