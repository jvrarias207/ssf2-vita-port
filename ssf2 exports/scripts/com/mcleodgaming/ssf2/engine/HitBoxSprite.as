package com.mcleodgaming.ssf2.engine
{
   import com.mcleodgaming.ssf2.util.*;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class HitBoxSprite
   {
      
      public static const ATTACK:uint = 0;
      
      public static const HIT:uint = 1;
      
      public static const GRAB:uint = 2;
      
      public static const TOUCH:uint = 3;
      
      public static const HAND:uint = 4;
      
      public static const RANGE:uint = 5;
      
      public static const ABSORB:uint = 6;
      
      public static const COUNTER:uint = 7;
      
      public static const SHIELDATTACK:uint = 8;
      
      public static const SHIELDPROJECTILE:uint = 9;
      
      public static const REVERSE:uint = 10;
      
      public static const CATCH:uint = 11;
      
      public static const LEDGE:uint = 12;
      
      public static const CAM:uint = 13;
      
      public static const HOMING:uint = 14;
      
      public static const PLOCK:uint = 15;
      
      public static const ITEM:uint = 16;
      
      public static const HAT:uint = 17;
      
      public static const SHIELD:uint = 18;
      
      public static const EGG:uint = 19;
      
      public static const FREEZE:uint = 20;
      
      public static const STAR:uint = 21;
      
      public static const CUSTOM:uint = 22;
      
      public static const PICKUP:uint = 23;
      
      public static const MASTER:uint = 24;
      
      private var m_name:String;
      
      private var m_type:uint;
      
      private var m_rectangle:Rectangle;
      
      private var m_flippedRectangle:Rectangle;
      
      private var m_rotation:Number;
      
      private var m_transform:Matrix;
      
      private var m_regPoint:Point;
      
      private var m_scale:Point;
      
      private var m_depth:int;
      
      private var m_circular:Boolean;
      
      private var m_customData:Object;
      
      private var m_order:int;
      
      private var m_rect1Temp:Rectangle;
      
      private var m_rect2Temp:Rectangle;
      
      private var m_rect3Temp:Rectangle;
      
      private var m_rect4Temp:Rectangle;
      
      public function HitBoxSprite(type:uint, rectangle:Rectangle, circular:Boolean = false, customData:Object = null, regPoint:Point = null, scale:Point = null, rotation:Number = 0, transform:Matrix = null, depth:int = 0, order:int = -1)
      {
         super();
         this.m_name = null;
         this.m_type = type;
         this.m_rectangle = rectangle;
         this.m_circular = circular;
         this.m_customData = customData;
         this.m_flippedRectangle = new Rectangle(-rectangle.x - rectangle.width,rectangle.y,rectangle.width,rectangle.height);
         this.m_rotation = rotation;
         this.m_regPoint = Boolean(regPoint) ? regPoint : new Point(rectangle.x,rectangle.y);
         this.m_scale = Boolean(scale) ? scale : new Point(1,1);
         this.m_transform = Boolean(transform) ? transform : new Matrix();
         this.m_depth = depth;
         this.m_order = order;
         this.m_rect1Temp = new Rectangle();
         this.m_rect2Temp = new Rectangle();
         this.m_rect3Temp = new Rectangle();
         this.m_rect4Temp = new Rectangle();
      }
      
      public static function hitTestArray(arr1:Array, arr2:Array, selfLocation:Point, thatLocation:Point, selfFlipped:Boolean, thatFlipped:Boolean, selfScale:Point, thatScale:Point, selfRotation:Number, thatRotation:Number) : Vector.<HitBoxCollisionResult>
      {
         var j:int = 0;
         var rect:Rectangle = null;
         var results:Vector.<HitBoxCollisionResult> = new Vector.<HitBoxCollisionResult>();
         if(arr1 == null || arr2 == null)
         {
            return results;
         }
         for(var i:int = 0; i < arr1.length; i++)
         {
            for(j = 0; j < arr2.length; j++)
            {
               rect = arr1[i].hitTest(arr2[j],selfLocation,thatLocation,selfFlipped,thatFlipped,selfScale,thatScale,selfRotation,thatRotation);
               if(Boolean(rect))
               {
                  results.push(new HitBoxCollisionResult(arr1[i],arr2[j],new HitBoxSprite(arr1[i].Type,rect,arr1[i].Circular,arr1[i].CustomData)));
               }
            }
         }
         return results;
      }
      
      public function get x() : Number
      {
         return this.m_rectangle.x;
      }
      
      public function get y() : Number
      {
         return this.m_rectangle.y;
      }
      
      public function get xreg() : Number
      {
         return this.m_regPoint.x;
      }
      
      public function get yreg() : Number
      {
         return this.m_regPoint.y;
      }
      
      public function get width() : Number
      {
         return this.m_rectangle.width;
      }
      
      public function get height() : Number
      {
         return this.m_rectangle.height;
      }
      
      public function get scaleX() : Number
      {
         return this.m_scale.x;
      }
      
      public function get scaleY() : Number
      {
         return this.m_scale.y;
      }
      
      public function get rotation() : Number
      {
         return this.m_rotation;
      }
      
      public function get transform() : Matrix
      {
         return this.m_transform;
      }
      
      public function get depth() : int
      {
         return this.m_depth;
      }
      
      public function get Order() : int
      {
         return this.m_order;
      }
      
      public function get centerx() : Number
      {
         return this.m_rectangle.x + this.m_rectangle.width / 2;
      }
      
      public function get centery() : Number
      {
         return this.m_rectangle.y + this.m_rectangle.height / 2;
      }
      
      public function get Name() : String
      {
         return this.m_name;
      }
      
      public function set Name(value:String) : void
      {
         this.m_name = value;
      }
      
      public function get Type() : uint
      {
         return this.m_type;
      }
      
      public function get BoundingBox() : Rectangle
      {
         return this.m_rectangle;
      }
      
      public function get FlippedBoundingBox() : Rectangle
      {
         return this.m_flippedRectangle;
      }
      
      public function get CustomData() : Object
      {
         return this.m_customData;
      }
      
      public function set CustomData(value:Object) : void
      {
         this.m_customData = value;
      }
      
      public function get Circular() : Boolean
      {
         return this.m_circular;
      }
      
      public function equals(hitBox:HitBoxSprite) : Boolean
      {
         return this.m_type == hitBox.Type && this.m_rectangle.equals(hitBox.BoundingBox) && this.m_circular == hitBox.Circular && this.m_regPoint.equals(hitBox.m_regPoint) && this.m_scale.equals(hitBox.m_scale) && this.m_rotation == hitBox.rotation && this.m_transform.a == hitBox.transform.a && this.m_transform.b == hitBox.transform.b && this.m_transform.c == hitBox.transform.c && this.m_transform.d == hitBox.transform.d && this.m_transform.tx == hitBox.transform.tx && this.m_transform.ty == hitBox.transform.ty && this.m_depth == hitBox.depth && this.m_order == hitBox.Order;
      }
      
      public function hitTest(theirHitBox:HitBoxSprite, selfLocation:Point, thatLocation:Point, selfFlipped:Boolean, thatFlipped:Boolean, selfScale:Point, thatScale:Point, selfRotation:Number, thatRotation:Number) : Rectangle
      {
         var points1:Vector.<Point> = null;
         var points2:Vector.<Point> = null;
         var center1:Point = null;
         var center2:Point = null;
         var radius1:Number = NaN;
         var radius2:Number = NaN;
         var points:Vector.<Point> = null;
         var rect1:Rectangle = this.m_rect1Temp;
         var rect2:Rectangle = this.m_rect2Temp;
         rect1.copyFrom(selfFlipped ? this.m_flippedRectangle : this.m_rectangle);
         rect2.copyFrom(thatFlipped ? theirHitBox.FlippedBoundingBox : theirHitBox.BoundingBox);
         var rect1_copy:Rectangle = this.m_rect3Temp;
         var rect2_copy:Rectangle = this.m_rect4Temp;
         this.m_rect3Temp.copyFrom(rect1);
         this.m_rect4Temp.copyFrom(rect2);
         rect1 = Utils.rotateRectangleAroundOrigin(rect1,selfRotation);
         rect2 = Utils.rotateRectangleAroundOrigin(rect2,thatRotation);
         rect1.x *= selfScale.x;
         rect1.y *= selfScale.y;
         rect1.width *= selfScale.x;
         rect1.height *= selfScale.y;
         rect2.x *= thatScale.x;
         rect2.y *= thatScale.y;
         rect2.width *= thatScale.x;
         rect2.height *= thatScale.y;
         rect1.x += selfLocation.x;
         rect1.y += selfLocation.y;
         rect2.x += thatLocation.x;
         rect2.y += thatLocation.y;
         var collisionRect:Rectangle = rect1.intersection(rect2);
         if(collisionRect.isEmpty())
         {
            return null;
         }
         if(selfRotation == 0 && thatRotation == 0 && !this.m_circular && !theirHitBox.Circular)
         {
            return collisionRect;
         }
         if(!this.m_circular && !theirHitBox.Circular)
         {
            points1 = Utils.rotateRectangleAroundOriginPoints(rect1_copy,selfRotation,selfScale,selfLocation);
            points2 = Utils.rotateRectangleAroundOriginPoints(rect2_copy,thatRotation,thatScale,thatLocation);
            if(FastCollisions.rectangles(points1[0].x,points1[0].y,points1[1].x,points1[1].y,points1[2].x,points1[2].y,points1[3].x,points1[3].y,points2[0].x,points2[0].y,points2[1].x,points2[1].y,points2[2].x,points2[2].y,points2[3].x,points2[3].y))
            {
               return collisionRect;
            }
            return null;
         }
         center1 = new Point(rect1_copy.x + rect1_copy.width / 2,rect1_copy.y + rect1_copy.height / 2);
         center2 = new Point(rect2_copy.x + rect2_copy.width / 2,rect2_copy.y + rect2_copy.height / 2);
         center1 = Utils.rotatePointAroundOrigin(center1,selfRotation);
         center1.x *= selfScale.x;
         center1.y *= selfScale.y;
         center2 = Utils.rotatePointAroundOrigin(center2,thatRotation);
         center2.x *= thatScale.x;
         center2.y *= thatScale.y;
         radius1 = Math.min(rect1_copy.width / 2 * selfScale.x,rect1_copy.height / 2 * selfScale.y);
         radius2 = Math.min(rect2_copy.width / 2 * thatScale.x,rect2_copy.height / 2 * thatScale.y);
         center1.x += selfLocation.x;
         center1.y += selfLocation.y;
         center2.x += thatLocation.x;
         center2.y += thatLocation.y;
         if(this.m_circular && !theirHitBox.Circular)
         {
            points = Utils.rotateRectangleAroundOriginPoints(rect2_copy,thatRotation,thatScale,thatLocation);
            if(Utils.testRectangleToCircle(points,rect2_copy.width * thatScale.x,rect2_copy.height * thatScale.y,center2.x,center2.y,center1.x,center1.y,radius1))
            {
               return collisionRect;
            }
            return null;
         }
         if(!this.m_circular && theirHitBox.Circular)
         {
            points = Utils.rotateRectangleAroundOriginPoints(rect1_copy,selfRotation,selfScale,selfLocation);
            if(Utils.testRectangleToCircle(points,rect1_copy.width * selfScale.x,rect1_copy.height * selfScale.y,center1.x,center1.y,center2.x,center2.y,radius2))
            {
               return collisionRect;
            }
            return null;
         }
         if(Point.distance(center1,center2) <= radius1 + radius2)
         {
            return collisionRect;
         }
         return null;
      }
      
      public function hitTestPoint(location:Point, selfLocation:Point, selfFlipped:Boolean, selfScale:Point, selfRotation:Number, circular:Boolean = false) : Boolean
      {
         var rect1:Rectangle = selfFlipped ? this.m_flippedRectangle.clone() : this.m_rectangle.clone();
         rect1 = Utils.rotateRectangleAroundOrigin(rect1,selfRotation);
         rect1.x *= selfScale.x;
         rect1.y *= selfScale.y;
         rect1.width *= selfScale.x;
         rect1.height *= selfScale.y;
         rect1.x += selfLocation.x;
         rect1.y += selfLocation.y;
         trace("Call to HitBoxSprite.hitTestPoint(), please check");
         return circular ? Point.distance(location,new Point(rect1.x + rect1.width / 2,rect1.y + rect1.height / 2)) < Math.min(rect1.width / 2,rect1.height / 2) : rect1.containsPoint(location);
      }
   }
}

