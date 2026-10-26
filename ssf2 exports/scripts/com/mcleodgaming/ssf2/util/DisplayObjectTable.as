package com.mcleodgaming.ssf2.util
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.geom.Rectangle;
   
   public class DisplayObjectTable
   {
      
      private var m_displayObjects:Vector.<Vector.<DisplayObject>>;
      
      private var m_spaceRect:Rectangle;
      
      public function DisplayObjectTable(spaceRect:Rectangle)
      {
         super();
         if(spaceRect == null)
         {
            trace("Error creating DisplayObjectTable, cannot have null spacing rectangle");
            return;
         }
         this.m_displayObjects = new Vector.<Vector.<DisplayObject>>();
         this.m_spaceRect = spaceRect;
      }
      
      public function get RowCount() : int
      {
         return this.m_displayObjects.length;
      }
      
      public function maxPerRow() : int
      {
         var max:int = 0;
         for(var i:int = 0; i < this.m_displayObjects.length; i++)
         {
            max = Math.max(max,this.m_displayObjects[i].length);
         }
         return max;
      }
      
      public function insertObject(rowIndex:int, object:DisplayObject) : void
      {
         while(rowIndex >= this.m_displayObjects.length)
         {
            this.m_displayObjects.push(new Vector.<DisplayObject>());
         }
         this.m_displayObjects[rowIndex].push(object);
      }
      
      public function hideAll() : void
      {
         var j:int = 0;
         for(var i:int = 0; i < this.m_displayObjects.length; i++)
         {
            for(j = 0; j < this.m_displayObjects[i].length; j++)
            {
               this.m_displayObjects[i][j].visible = false;
            }
         }
      }
      
      public function showAll() : void
      {
         var j:int = 0;
         for(var i:int = 0; i < this.m_displayObjects.length; i++)
         {
            for(j = 0; j < this.m_displayObjects[i].length; j++)
            {
               this.m_displayObjects[i][j].visible = true;
            }
         }
      }
      
      public function scaleAll(scaleX:Number, scaleY:Number) : void
      {
         var j:int = 0;
         for(var i:int = 0; i < this.m_displayObjects.length; i++)
         {
            for(j = 0; j < this.m_displayObjects[i].length; j++)
            {
               this.m_displayObjects[i][j].scaleX = scaleX;
               this.m_displayObjects[i][j].scaleY = scaleY;
            }
         }
      }
      
      public function fixDepths() : void
      {
         var j:int = 0;
         for(var i:int = this.m_displayObjects.length - 1; i >= 0; i--)
         {
            for(j = this.m_displayObjects[i].length - 1; j >= 0; j--)
            {
               if(Boolean(this.m_displayObjects[i][j].parent) && Boolean(this.m_displayObjects[i][j].parent as MovieClip))
               {
                  MovieClip(this.m_displayObjects[i][j].parent).setChildIndex(this.m_displayObjects[i][j],0);
               }
            }
         }
      }
      
      public function spaceObjects() : void
      {
         var shift:Number = NaN;
         var x_multiplier:Number = NaN;
         var diff:int = 0;
         var i:int = 0;
         var j:int = 0;
         var y_multiplier:Number = 0;
         for(i = 0; i < this.m_displayObjects.length; i++)
         {
            shift = 0;
            x_multiplier = 0;
            for(j = 0; j < this.m_displayObjects[i].length; j++)
            {
               if(!this.m_displayObjects[i][j].visible)
               {
                  shift += this.m_spaceRect.width / 2;
               }
            }
            diff = this.maxPerRow() - this.m_displayObjects[i].length;
            shift += diff * this.m_spaceRect.width / 2;
            for(j = 0; j < this.m_displayObjects[i].length; j++)
            {
               if(this.m_displayObjects[i][j].visible)
               {
                  this.m_displayObjects[i][j].x = this.m_spaceRect.x + this.m_spaceRect.width * x_multiplier + shift;
                  this.m_displayObjects[i][j].y = this.m_spaceRect.y + this.m_spaceRect.height * y_multiplier;
                  x_multiplier++;
               }
            }
            y_multiplier++;
         }
      }
      
      public function empty() : void
      {
         this.m_displayObjects = new Vector.<Vector.<DisplayObject>>();
      }
   }
}

