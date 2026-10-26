package com.mcleodgaming.ssf2.api
{
   import com.mcleodgaming.ssf2.menus.CustomAPIMenu;
   import flash.display.MovieClip;
   
   public class SSF2CustomMenu extends SSF2BaseAPIObject
   {
      
      protected var _ownerCasted:CustomAPIMenu;
      
      public function SSF2CustomMenu(api:Class, owner:CustomAPIMenu)
      {
         super(api,owner);
         this._ownerCasted = owner;
      }
      
      public function getMC() : MovieClip
      {
         return this._ownerCasted.Container;
      }
      
      public function show() : void
      {
         this._ownerCasted.show();
      }
      
      public function remove() : void
      {
         this._ownerCasted.removeSelf();
      }
      
      public function setCustomInputMapping(value:Object) : void
      {
         this._ownerCasted.CustomInputMapping = value;
      }
   }
}

