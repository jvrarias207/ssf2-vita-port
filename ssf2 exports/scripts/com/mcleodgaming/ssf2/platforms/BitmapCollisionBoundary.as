package com.mcleodgaming.ssf2.platforms
{
   import com.mcleodgaming.ssf2.api.*;
   import com.mcleodgaming.ssf2.enemies.*;
   import com.mcleodgaming.ssf2.engine.*;
   import com.mcleodgaming.ssf2.util.*;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.PixelSnapping;
   import flash.display.StageQuality;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class BitmapCollisionBoundary
   {
      
      public static const TRANS_COLOR:uint = 1127270;
      
      protected var STAGEDATA:StageData;
      
      protected var m_collisionClip:MovieClip;
      
      protected var m_collisionClipContainer:MovieClip;
      
      protected var m_bitmapData:Bitmap;
      
      protected var m_offset:Point;
      
      protected var m_originalLocation:Point;
      
      protected var m_useRectangle:Boolean;
      
      protected var m_apiInstance:SSF2CollisionBoundary;
      
      protected var m_dead:Boolean;
      
      private var __hitTestRectAPIRectCache:Rectangle = new Rectangle();
      
      private var __hitTestRectAPIPointCache:Point = new Point();
      
      private var __hitTestPointAPIRectCache:Rectangle = new Rectangle();
      
      private var __hitTestPointAPIPointCache:Point = new Point();
      
      private var __hitTestPointAPIPointCache2:Point = new Point();
      
      public function BitmapCollisionBoundary(mc:MovieClip, stageData:StageData, instance:String = "ground", useRectangle:Boolean = false, stats:Object = null)
      {
         var bmpData:BitmapData = null;
         var locRec:Rectangle = null;
         var shapeRec:Rectangle = null;
         var offset:Matrix = null;
         var prevOffset:Point = null;
         var flipMat:Matrix = null;
         super();
         if(!stats)
         {
            stats = {};
         }
         if(!stats.classAPI)
         {
            stats.classAPI = stageData.BASE_CLASSES.SSF2CollisionBoundary;
         }
         if(!this.m_apiInstance)
         {
            this.m_apiInstance = new SSF2CollisionBoundary(stats.classAPI,this);
            if(!mc)
            {
               mc = ResourceManager.getLibraryMC(this.m_apiInstance.getOwnStats().linkage_id);
               stageData.StageRef.addChild(mc);
            }
         }
         this.m_dead = false;
         this.STAGEDATA = stageData;
         this.m_collisionClip = Boolean(mc[instance]) ? mc[instance] : mc;
         this.m_collisionClipContainer = mc;
         this.m_originalLocation = new Point(this.m_collisionClipContainer.x,this.m_collisionClipContainer.y);
         this.m_useRectangle = useRectangle;
         if(!this.m_useRectangle)
         {
            bmpData = null;
            locRec = null;
            shapeRec = null;
            if(Boolean(mc[instance]))
            {
               locRec = mc[instance].getBounds(mc.parent);
               shapeRec = mc[instance].getBounds(mc[instance]);
            }
            else
            {
               locRec = mc.getBounds(mc.parent);
               shapeRec = mc.getBounds(mc);
            }
            this.m_bitmapData = new Bitmap(null,PixelSnapping.ALWAYS,false);
            this.m_bitmapData.x = locRec.x;
            this.m_bitmapData.y = locRec.y;
            this.m_offset = new Point(locRec.x - mc.x,locRec.y - mc.y);
            offset = new Matrix();
            prevOffset = new Point();
            prevOffset.x = shapeRec.x;
            prevOffset.y = shapeRec.y;
            offset.tx = -prevOffset.x;
            offset.ty = -prevOffset.y;
            if(Boolean(mc[instance]))
            {
               offset.scale(mc.scaleX * mc[instance].scaleX,mc.scaleY * mc[instance].scaleY);
            }
            else
            {
               offset.scale(mc.scaleX,mc.scaleY);
            }
            if(mc.transform.matrix.a < 0 || mc.transform.matrix.d < 0)
            {
               flipMat = new Matrix();
               flipMat.a = mc.transform.matrix.a < 0 ? -1 : 1;
               flipMat.d = mc.transform.matrix.d < 0 ? -1 : 1;
               flipMat.translate(flipMat.a < 0 ? locRec.width : 0,flipMat.d < 0 ? locRec.height : 0);
               offset.concat(flipMat);
            }
            bmpData = new BitmapData(Math.round(locRec.width + 0.5),Math.round(locRec.height + 0.5),true,TRANS_COLOR);
            bmpData.drawWithQuality(this.m_collisionClip,offset,this.m_collisionClip.transform.colorTransform,null,null,false,StageQuality.BEST);
            this.m_bitmapData.bitmapData = bmpData;
         }
      }
      
      public function get APIInstance() : SSF2CollisionBoundary
      {
         return this.m_apiInstance;
      }
      
      public function set APIInstance(value:SSF2CollisionBoundary) : void
      {
         this.m_apiInstance = value;
      }
      
      public function get X() : Number
      {
         return this.m_collisionClipContainer.x;
      }
      
      public function set X(value:Number) : void
      {
         this.m_collisionClipContainer.x = value;
      }
      
      public function get Y() : Number
      {
         return this.m_collisionClipContainer.y;
      }
      
      public function set Y(value:Number) : void
      {
         this.m_collisionClipContainer.y = value;
      }
      
      public function get Width() : Number
      {
         return this.m_bitmapData.width;
      }
      
      public function get Height() : Number
      {
         return this.m_bitmapData.height;
      }
      
      public function get Container() : MovieClip
      {
         return this.m_collisionClipContainer;
      }
      
      public function get CollisionClip() : MovieClip
      {
         return this.m_collisionClip;
      }
      
      public function get Offset() : Point
      {
         return this.m_offset;
      }
      
      public function get BMPData() : Bitmap
      {
         return this.m_bitmapData;
      }
      
      public function stop() : void
      {
         this.m_collisionClipContainer.stop();
      }
      
      public function play() : void
      {
         this.m_collisionClipContainer.play();
      }
      
      public function hitTestRect(rect:Rectangle, shapeFlag:Boolean = true) : Boolean
      {
         if(Boolean(this.m_apiInstance) && Boolean(this.m_apiInstance.instance))
         {
            return this.m_apiInstance.hitTestRectAPIOverride(rect,shapeFlag);
         }
         return this.hitTestRectAPI(rect,shapeFlag);
      }
      
      public function hitTestPoint(x:Number, y:Number, shapeFlag:Boolean = true) : Boolean
      {
         if(Boolean(this.m_apiInstance) && Boolean(this.m_apiInstance.instance))
         {
            return this.m_apiInstance.hitTestPointAPIOverride(x,y,shapeFlag);
         }
         return this.hitTestPointAPI(x,y,shapeFlag);
      }
      
      public function hitTestRectAPI(rect:Rectangle, shapeFlag:Boolean = true) : Boolean
      {
         if(this.m_useRectangle)
         {
            this.__hitTestRectAPIRectCache.setTo(this.m_collisionClipContainer.x,this.m_collisionClipContainer.y,this.m_collisionClipContainer.width,this.m_collisionClipContainer.height);
            return this.__hitTestRectAPIRectCache.containsRect(rect);
         }
         if(shapeFlag)
         {
            this.__hitTestRectAPIPointCache.setTo(this.m_collisionClipContainer.x + this.m_offset.x,this.m_collisionClipContainer.y + this.m_offset.y);
            return this.m_bitmapData.bitmapData.hitTest(this.__hitTestRectAPIPointCache,0,rect);
         }
         this.__hitTestRectAPIRectCache.setTo(this.m_collisionClipContainer.x + this.m_offset.x,this.m_collisionClipContainer.y + this.m_offset.y,this.m_bitmapData.width,this.m_bitmapData.height);
         return this.__hitTestRectAPIRectCache.containsRect(rect);
      }
      
      public function hitTestPointAPI(x:Number, y:Number, shapeFlag:Boolean = true) : Boolean
      {
         if(this.m_useRectangle)
         {
            this.__hitTestPointAPIRectCache.setTo(this.m_collisionClipContainer.x,this.m_collisionClipContainer.y,this.m_collisionClipContainer.width,this.m_collisionClipContainer.height);
            this.__hitTestPointAPIPointCache.setTo(x,y);
            return this.__hitTestPointAPIRectCache.containsPoint(this.__hitTestPointAPIPointCache);
         }
         if(x < this.m_collisionClipContainer.x + this.m_offset.x || x > this.m_collisionClipContainer.x + this.m_collisionClipContainer.width + this.m_offset.x || y < this.m_collisionClipContainer.y + this.m_offset.y || y > this.m_collisionClipContainer.y + this.m_collisionClipContainer.height + this.m_offset.y)
         {
            return false;
         }
         if(shapeFlag)
         {
            this.__hitTestPointAPIPointCache.setTo(this.m_collisionClipContainer.x + this.m_offset.x,this.m_collisionClipContainer.y + this.m_offset.y);
            this.__hitTestPointAPIPointCache2.setTo(x,y);
            return this.m_bitmapData.bitmapData.hitTest(this.__hitTestPointAPIPointCache,0,this.__hitTestPointAPIPointCache2);
         }
         this.__hitTestPointAPIRectCache.setTo(this.m_collisionClipContainer.x + this.m_offset.x,this.m_collisionClipContainer.y + this.m_offset.y,this.m_bitmapData.width,this.m_bitmapData.height);
         this.__hitTestPointAPIPointCache.setTo(x,y);
         return this.__hitTestPointAPIRectCache.containsPoint(this.__hitTestPointAPIPointCache);
      }
      
      public function destroy() : void
      {
         this.m_dead = true;
         this.STAGEDATA.removeCollisionBoundary(this);
      }
      
      public function dispose() : void
      {
         if(Boolean(this.m_bitmapData) && Boolean(this.m_bitmapData.bitmapData))
         {
            this.m_bitmapData.bitmapData.dispose();
            this.m_bitmapData.bitmapData = null;
         }
         if(Boolean(this.m_apiInstance))
         {
            this.m_apiInstance.dispose();
            this.m_apiInstance = null;
         }
      }
      
      public function PERFORMALL() : void
      {
         if(Boolean(this.m_apiInstance) && !this.m_dead)
         {
            this.m_apiInstance.update();
         }
      }
   }
}

