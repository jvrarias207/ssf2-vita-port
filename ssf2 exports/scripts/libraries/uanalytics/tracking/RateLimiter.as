package libraries.uanalytics.tracking
{
   import flash.utils.getTimer;
   
   public class RateLimiter
   {
      
      private var _capacity:int;
      
      private var _rate:int;
      
      private var _span:Number;
      
      private var _lastTime:int;
      
      private var _tokenCount:int;
      
      public function RateLimiter(capacity:int, rate:int, span:Number = 1)
      {
         super();
         this._capacity = capacity;
         this._rate = rate;
         this._span = span;
         this._tokenCount = capacity;
         this._lastTime = this.now();
      }
      
      protected function now() : int
      {
         return getTimer();
      }
      
      public function consumeToken() : Boolean
      {
         var now:int = this.now();
         var newTokens:int = Math.max(0,(now - this._lastTime) * (this._rate * this._span / 1000));
         this._tokenCount = Math.min(this._tokenCount + newTokens,this._capacity);
         if(this._tokenCount > 0)
         {
            --this._tokenCount;
            this._lastTime = now;
            return true;
         }
         return false;
      }
   }
}

