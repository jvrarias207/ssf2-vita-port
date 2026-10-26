package libraries.uanalytics.tracking
{
   import flash.utils.ByteArray;
   import libraries.uanalytics.utils.crc32;
   import libraries.uanalytics.utils.isDigit;
   
   public class HitSampler
   {
      
      public function HitSampler()
      {
         super();
      }
      
      private static function _hashString(source:String) : Number
      {
         var crc:crc32 = new crc32();
         var bytes:ByteArray = new ByteArray();
         bytes.writeUTFBytes(source);
         crc.update(bytes);
         return crc.valueOf();
      }
      
      private static function _parseNumber(str:String) : Number
      {
         var i:uint = 0;
         if(str == "")
         {
            return NaN;
         }
         var l:uint = uint(str.length);
         var dot:uint = 0;
         for(i = 0; i < l; i++)
         {
            if(str.charAt(i) == "." && dot == 0)
            {
               dot++;
            }
            else if(!isDigit(str,i))
            {
               return NaN;
            }
         }
         return parseFloat(str);
      }
      
      public static function isSampled(model:HitModel, samplerate:String = "") : Boolean
      {
         var sampleRate:Number = getSampleRate(samplerate);
         return sampleRate < 100 && _hashString(model.get(Tracker.CLIENT_ID)) % 10000 >= 100 * sampleRate;
      }
      
      public static function getSampleRate(rate:String) : Number
      {
         if(rate == null || rate == "")
         {
            return 100;
         }
         var result:Number = Math.max(0,Math.min(100,Math.round(_parseNumber(rate) * 100) / 100));
         if(isNaN(result))
         {
            return 0;
         }
         return result;
      }
   }
}

