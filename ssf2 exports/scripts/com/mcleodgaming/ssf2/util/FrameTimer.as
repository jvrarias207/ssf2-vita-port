package com.mcleodgaming.ssf2.util
{
   public class FrameTimer
   {
      
      private var m_initTime:int;
      
      private var m_currentTime:int;
      
      public function FrameTimer(length:int)
      {
         super();
         this.m_initTime = length;
         this.m_currentTime = 0;
      }
      
      public function get IsComplete() : Boolean
      {
         return Boolean(this.m_currentTime >= this.m_initTime);
      }
      
      public function get MaxTime() : int
      {
         return this.m_initTime;
      }
      
      public function set MaxTime(value:int) : void
      {
         if(value < 0)
         {
            this.m_initTime = 0;
         }
         else
         {
            this.m_initTime = value;
            if(this.m_currentTime > this.m_initTime)
            {
               this.m_currentTime = this.m_initTime;
            }
         }
      }
      
      public function get CurrentTime() : int
      {
         return this.m_currentTime;
      }
      
      public function set CurrentTime(value:int) : void
      {
         if(value < 0)
         {
            this.m_currentTime = 0;
         }
         else
         {
            this.m_currentTime = value > this.MaxTime ? this.MaxTime : value;
         }
      }
      
      public function tick(amount:int = 1) : void
      {
         this.CurrentTime = this.m_currentTime + amount;
      }
      
      public function finish() : void
      {
         this.m_currentTime = this.m_initTime;
      }
      
      public function reset() : void
      {
         this.m_currentTime = 0;
      }
   }
}

