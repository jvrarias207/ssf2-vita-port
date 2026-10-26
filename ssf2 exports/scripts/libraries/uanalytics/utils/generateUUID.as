package libraries.uanalytics.utils
{
   import flash.crypto.generateRandomBytes;
   import flash.utils.ByteArray;
   
   public function generateUUID() : String
   {
      var toHex:Function;
      var str:String;
      var l:uint;
      var uuid:String;
      var i:uint = 0;
      var byte:uint = 0;
      var randomBytes:ByteArray = generateRandomBytes(16);
      randomBytes[6] &= 15;
      randomBytes[6] |= 64;
      randomBytes[8] &= 63;
      randomBytes[8] |= 128;
      toHex = function(n:uint):String
      {
         var h:String = n.toString(16);
         return h.length > 1 ? h : "0" + h;
      };
      str = "";
      l = randomBytes.length;
      randomBytes.position = 0;
      for(i = 0; i < l; i++)
      {
         byte = uint(randomBytes[i]);
         str += toHex(byte);
      }
      uuid = "";
      uuid += str.substr(0,8);
      uuid += "-";
      uuid += str.substr(8,4);
      uuid += "-";
      uuid += str.substr(12,4);
      uuid += "-";
      uuid += str.substr(16,4);
      uuid += "-";
      uuid += str.substr(20,12);
      return uuid;
   }
}

