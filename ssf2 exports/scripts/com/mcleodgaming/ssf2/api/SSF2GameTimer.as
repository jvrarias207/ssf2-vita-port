package com.mcleodgaming.ssf2.api
{
   import com.mcleodgaming.ssf2.engine.GameTimer;
   import flash.display.MovieClip;
   
   public class SSF2GameTimer extends SSF2BaseAPIObject
   {
      
      protected var _ownerCasted:GameTimer;
      
      public function SSF2GameTimer(api:Class, owner:GameTimer)
      {
         super(api,owner);
         this._ownerCasted = owner;
      }
      
      public function getCurrentTime() : int
      {
         return this._ownerCasted.CurrentTime;
      }
      
      public function setCurrentTime(frames:int) : void
      {
         this._ownerCasted.setCurrentTime(frames);
      }
      
      public function start() : void
      {
         this._ownerCasted.Start();
      }
      
      public function restart() : void
      {
         this._ownerCasted.Restart();
      }
      
      public function stop() : void
      {
         this._ownerCasted.Stop();
      }
      
      public function getMC() : MovieClip
      {
         return this._ownerCasted.TimeMC;
      }
      
      public function setEndGameOptions(options:Object) : void
      {
         this._ownerCasted.setEndGameOptions(options);
      }
   }
}

