package com.mcleodgaming.ssf2.util
{
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.utils.getTimer;
   
   public class Debug_fps
   {
      
      private var fpsSymbol:Class = Debug_fps_fpsSymbol;
      
      private var fpsHolder:Sprite;
      
      private var pos:Point;
      
      private var stage:Stage;
      
      private var lowest:int;
      
      private var highest:int;
      
      private var checkCounter:int;
      
      private var checkRate:int;
      
      private var lowestResetCnt:int;
      
      private var startTime:Number;
      
      public function Debug_fps(currentStage:Stage, posArg:Point)
      {
         super();
         this.stage = currentStage;
         this.pos = posArg;
         this.lowest = this.stage.frameRate;
         this.highest = 0;
         this.checkCounter = 1;
         this.checkRate = 8;
         this.lowestResetCnt = this.lowest * 5;
         this.startTime = getTimer();
         this.fpsHolder = new this.fpsSymbol();
         this.stage.addChild(this.fpsHolder);
         this.fpsHolder.x = this.pos.x;
         this.fpsHolder.y = this.pos.y;
         this.fpsHolder.addEventListener(Event.ENTER_FRAME,this.mainloop);
      }
      
      public function toString() : String
      {
         return "Debug_fps";
      }
      
      public function get FrameRate() : Number
      {
         return this.fpsHolder.stage.frameRate;
      }
      
      public function set FrameRate(value:Number) : void
      {
         trace("Frame rate set disabled");
      }
      
      public function get MC() : Sprite
      {
         return this.fpsHolder;
      }
      
      public function kill() : void
      {
         this.fpsHolder.removeEventListener(Event.ENTER_FRAME,this.mainloop);
         if(Boolean(this.fpsHolder.parent))
         {
            this.fpsHolder.parent.removeChild(this.fpsHolder);
         }
      }
      
      private function mainloop(event:Event) : void
      {
         var fr:Number = NaN;
         if(--this.checkCounter == 0)
         {
            fr = this.checkRate / ((getTimer() - this.startTime) / 1000);
            fr = Math.round(fr * 10 / 10 * 10) / 10;
            if(fr > this.fpsHolder.stage.frameRate)
            {
               fr = this.fpsHolder.stage.frameRate;
            }
            this.fpsHolder["fps"].text = fr;
            if(fr < this.lowest)
            {
               this.lowest = this.fpsHolder["lowestValue"].text = fr;
            }
            if(fr > this.highest)
            {
               this.highest = fr;
            }
            this.startTime = getTimer();
            this.checkCounter = this.checkRate;
         }
         if(--this.lowestResetCnt == 0)
         {
            this.lowest = this.fpsHolder["lowestValue"].text = this.highest;
            this.lowestResetCnt = this.fpsHolder.stage.frameRate * 6;
         }
         this.fpsHolder["bar"].height = this.fpsHolder["fps"].text / this.fpsHolder.stage.frameRate * 100 / 4;
         var depth:int = this.stage.numChildren - 1;
         if(this.stage.getChildIndex(this.fpsHolder) < depth)
         {
            this.stage.setChildIndex(this.fpsHolder,depth);
         }
      }
   }
}

