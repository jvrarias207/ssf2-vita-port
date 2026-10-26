package com.mcleodgaming.ssf2.api
{
   import com.mcleodgaming.ssf2.engine.CustomMatch;
   import com.mcleodgaming.ssf2.modes.CustomMode;
   
   public class SSF2CustomMode extends SSF2BaseAPIObject
   {
      
      protected var _ownerCasted:CustomMode;
      
      public function SSF2CustomMode(api:Class, owner:CustomMode)
      {
         super(api,owner);
         this._ownerCasted = owner;
      }
      
      public function getInitialGameSettings() : *
      {
         return JSON.parse(JSON.stringify(this._ownerCasted.InitialGameSettings.exportSettings()));
      }
      
      public function getModeSettings() : Object
      {
         return JSON.parse(JSON.stringify(this._ownerCasted.ModeSettings));
      }
      
      final public function startMatch(match:*) : void
      {
         this._ownerCasted.startMatch(CustomMatch(match.$ext.getAPI().owner));
      }
      
      public function handleMatchComplete() : void
      {
         _api.handleMatchComplete();
      }
      
      public function getSummary() : String
      {
         if("getSummary" in _api)
         {
            return _api.getSummary();
         }
         return "Custom Mode";
      }
      
      final public function endMode(data:Object) : void
      {
         this._ownerCasted.endMode(data);
      }
      
      final public function saveModeData(data:Object) : Boolean
      {
         return this._ownerCasted.saveModeData(data);
      }
   }
}

