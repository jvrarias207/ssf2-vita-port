package com.mcleodgaming.ssf2.api
{
   import com.mcleodgaming.ssf2.platforms.BitmapCollisionBoundary;
   import flash.display.MovieClip;
   import flash.geom.Rectangle;
   
   public class SSF2CollisionBoundary extends SSF2BaseAPIObject
   {
      
      private var _ownerCasted:BitmapCollisionBoundary;
      
      public function SSF2CollisionBoundary(api:Class, owner:BitmapCollisionBoundary)
      {
         super(api,owner);
         this._ownerCasted = BitmapCollisionBoundary(owner);
      }
      
      public function getOwnStats() : Object
      {
         if(Boolean(_api) && "getOwnStats" in _api)
         {
            return _api.getOwnStats();
         }
         return {};
      }
      
      public function getMC() : MovieClip
      {
         return this._ownerCasted.Container;
      }
      
      public function destroy() : void
      {
         return this._ownerCasted.destroy();
      }
      
      public function getX() : Number
      {
         return this._ownerCasted.X;
      }
      
      public function setX(value:Number) : void
      {
         this._ownerCasted.X = value;
      }
      
      public function getY() : Number
      {
         return this._ownerCasted.Y;
      }
      
      public function setY(value:Number) : void
      {
         this._ownerCasted.Y = value;
      }
      
      public function hitTestPoint(x:Number, y:Number, shapeFlag:Boolean = true) : Boolean
      {
         return this._ownerCasted.hitTestPointAPI(x,y,shapeFlag);
      }
      
      public function hitTestRect(rect:Rectangle, shapeFlag:Boolean = true) : Boolean
      {
         return this._ownerCasted.hitTestRectAPI(rect,shapeFlag);
      }
      
      public function hitTestRectAPIOverride(rect:Rectangle, shapeFlag:Boolean = true) : Boolean
      {
         return _api.hitTestRect(rect,shapeFlag);
      }
      
      public function hitTestPointAPIOverride(x:Number, y:Number, shapeFlag:Boolean = true) : Boolean
      {
         return _api.hitTestPoint(x,y,shapeFlag);
      }
   }
}

