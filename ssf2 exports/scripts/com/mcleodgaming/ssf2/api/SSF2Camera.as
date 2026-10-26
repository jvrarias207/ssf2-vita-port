package com.mcleodgaming.ssf2.api
{
   import com.mcleodgaming.ssf2.util.Vcam;
   import flash.display.MovieClip;
   import flash.geom.Point;
   
   public class SSF2Camera extends SSF2BaseAPIObject
   {
      
      protected var _ownerCasted:Vcam;
      
      public function SSF2Camera(api:Class, owner:Vcam)
      {
         super(api,owner);
         this._ownerCasted = owner;
      }
      
      public function getCameraParameter(name:String) : *
      {
         var settings:Object = this._ownerCasted.Settings.exportSettings();
         return settings[name] !== undefined ? settings[name] : null;
      }
      
      public function updateCameraParameters(settings:Object) : void
      {
         this._ownerCasted.Settings.importSettings(settings);
         if(Boolean(settings.backgrounds))
         {
            this._ownerCasted.changeBG(this._ownerCasted.Settings.backgrounds);
         }
      }
      
      public function addTarget(mc:MovieClip) : void
      {
         this._ownerCasted.addTarget(mc);
      }
      
      public function deleteTarget(mc:MovieClip) : void
      {
         this._ownerCasted.deleteTarget(mc);
      }
      
      public function getTopLeftPoint() : Point
      {
         return new Point(this._ownerCasted.CornerX,this._ownerCasted.CornerY);
      }
      
      public function getMC() : MovieClip
      {
         return this._ownerCasted.CamMC;
      }
      
      public function maxZoomOut() : void
      {
         this._ownerCasted.maxZoomOut();
         this._ownerCasted.camControl();
      }
      
      public function targetCenterStage() : void
      {
         this._ownerCasted.targetCenterStage();
         this._ownerCasted.camControl();
      }
      
      public function forceTarget() : void
      {
         this._ownerCasted.forceTarget();
         this._ownerCasted.camControl();
      }
      
      public function forceInBounds() : void
      {
         this._ownerCasted.forceInBounds();
         this._ownerCasted.camControl();
      }
      
      public function darken() : void
      {
         this._ownerCasted.darken();
      }
      
      public function killDarkener(immediate:Boolean = false) : void
      {
         this._ownerCasted.killDarkener(immediate);
      }
      
      public function addTimedTarget(mc:MovieClip, length:int) : void
      {
         this._ownerCasted.addTimedTarget(mc,length);
      }
      
      public function deleteTimedTarget(mc:MovieClip) : void
      {
         this._ownerCasted.deleteTimedTarget(mc);
      }
      
      public function addTimedTargetPoint(point:Point, length:int) : void
      {
         this._ownerCasted.addTimedTargetPoint(point,length);
      }
      
      public function deleteTimedTargetPoint(point:Point) : void
      {
         this._ownerCasted.deleteTimedTargetPoint(point);
      }
      
      public function addForcedTarget(mc:MovieClip) : void
      {
         this._ownerCasted.addForcedTarget(mc);
      }
      
      public function deleteForcedTarget(mc:MovieClip) : void
      {
         this._ownerCasted.deleteForcedTarget(mc);
      }
      
      public function lightFlash(fade:Boolean = true) : void
      {
         this._ownerCasted.lightFlash(fade);
      }
      
      public function setStageFocus(length:int) : void
      {
         this._ownerCasted.setStageFocus(length);
      }
      
      public function removeStageFocus() : void
      {
         this._ownerCasted.removeStageFocus();
      }
      
      public function shake(num:int) : void
      {
         this._ownerCasted.shake(num);
      }
      
      public function getMode() : int
      {
         return this._ownerCasted.Mode;
      }
      
      public function setMode(num:int) : void
      {
         this._ownerCasted.Mode = num;
      }
   }
}

