package com.mcleodgaming.mgn.net
{
   public class PlayerDataSyncStream
   {
      
      private static const BUFFER:int = 30;
      
      private var _history:Vector.<DataFrameGroup>;
      
      private var _pointer:int;
      
      private var _size:int;
      
      public function PlayerDataSyncStream()
      {
         super();
         this._history = new Vector.<DataFrameGroup>();
         this._size = 0;
         this._pointer = 0;
      }
      
      public function get Pointer() : int
      {
         return this._pointer;
      }
      
      public function init(size:int) : void
      {
         this._pointer = 0;
         this._history = null;
         this._history = new Vector.<DataFrameGroup>();
         this._size = size;
         while(this._history.length < BUFFER)
         {
            this._history.push(new DataFrameGroup(this._history.length + 1,this._size));
         }
      }
      
      public function updateDataFrame(frame:uint, index:int, data:Object) : void
      {
         if(frame > this._history.length)
         {
            while(this._history.length < frame + BUFFER)
            {
               this._history.push(new DataFrameGroup(this._history.length + 1,this._size));
            }
         }
         this._history[frame - 1].updateDataFrameFor(index,data);
      }
      
      public function getDataFrameGroup(frame:uint) : DataFrameGroup
      {
         return frame > this._history.length ? null : this._history[frame - 1];
      }
      
      public function getFilledDataFrameGroups() : Vector.<DataFrameGroup>
      {
         var queue:Vector.<DataFrameGroup> = new Vector.<DataFrameGroup>();
         var i:int = this._pointer;
         while(i < this._history.length && this._history[i].Complete)
         {
            queue.push(this._history[i]);
            i++;
            ++this._pointer;
         }
         return queue;
      }
      
      public function getSurroundingDataFrames(behind:int, front:int) : Vector.<DataFrameGroup>
      {
         var queue:Vector.<DataFrameGroup> = new Vector.<DataFrameGroup>();
         var i:int = Math.max(0,this._pointer - behind);
         while(i < this._history.length && i < this._pointer + front)
         {
            queue.push(this._history[i]);
            i++;
         }
         return queue;
      }
      
      public function flushFilled() : void
      {
         var i:int = 0;
         var frame:uint = 1;
         i = this._pointer;
         while(i < this._history.length)
         {
            this._history[i].Frame = frame;
            i++;
            frame++;
         }
         this._history.splice(0,this._pointer);
         this._pointer = 0;
      }
   }
}

