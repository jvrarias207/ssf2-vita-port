package libraries.uanalytics.tracking
{
   public class RateLimitError extends Error
   {
      
      prototype.name = "RateLimitError";
      
      public function RateLimitError(message:String = "", id:int = 0)
      {
         super(message,id);
         this.name = prototype.name;
      }
   }
}

