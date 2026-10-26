package com.hurlant.util
{
   import flash.utils.ByteArray;
   
   public class Base64
   {
      
      private static const _encodeChars:Vector.<int> = InitEncoreChar();
      
      private static const _decodeChars:Vector.<int> = InitDecodeChar();
      
      public function Base64()
      {
         super();
      }
      
      public static function encodeByteArray(data:ByteArray) : String
      {
         var c:int = 0;
         var out:ByteArray = new ByteArray();
         out.length = (2 + data.length - (data.length + 2) % 3) * 4 / 3;
         var i:int = 0;
         var r:int = data.length % 3;
         var len:int = data.length - r;
         while(i < len)
         {
            c = data[i++] << 16 | data[i++] << 8 | data[i++];
            c = _encodeChars[c >>> 18] << 24 | _encodeChars[c >>> 12 & 0x3F] << 16 | _encodeChars[c >>> 6 & 0x3F] << 8 | _encodeChars[c & 0x3F];
            out.writeInt(c);
         }
         if(r == 1)
         {
            c = int(data[i]);
            c = _encodeChars[c >>> 2] << 24 | _encodeChars[(c & 3) << 4] << 16 | 0x3D00 | 0x3D;
            out.writeInt(c);
         }
         else if(r == 2)
         {
            c = data[i++] << 8 | data[i];
            c = _encodeChars[c >>> 10] << 24 | _encodeChars[c >>> 4 & 0x3F] << 16 | _encodeChars[(c & 0x0F) << 2] << 8 | 0x3D;
            out.writeInt(c);
         }
         out.position = 0;
         return out.readUTFBytes(out.length);
      }
      
      public static function decodeToByteArray(str:String) : ByteArray
      {
         var c1:int = 0;
         var c2:int = 0;
         var c3:int = 0;
         var c4:int = 0;
         var i:int = 0;
         var len:int = 0;
         var out:ByteArray = null;
         len = str.length;
         i = 0;
         out = new ByteArray();
         var byteString:ByteArray = new ByteArray();
         byteString.writeUTFBytes(str);
         loop0:
         while(i < len)
         {
            do
            {
               c1 = _decodeChars[byteString[i++]];
            }
            while(i < len && c1 == -1);
            if(c1 == -1)
            {
               break;
            }
            do
            {
               c2 = _decodeChars[byteString[i++]];
            }
            while(i < len && c2 == -1);
            if(c2 != -1)
            {
               out.writeByte(c1 << 2 | (c2 & 0x30) >> 4);
               while(true)
               {
                  c3 = int(byteString[i++]);
                  if(c3 == 61)
                  {
                     break;
                  }
                  c3 = _decodeChars[c3];
                  if(!(i < len && c3 == -1))
                  {
                     if(c3 != -1)
                     {
                        out.writeByte((c2 & 0x0F) << 4 | (c3 & 0x3C) >> 2);
                        while(true)
                        {
                           c4 = int(byteString[i++]);
                           if(c4 == 61)
                           {
                              break;
                           }
                           c4 = _decodeChars[c4];
                           if(!(i < len && c4 == -1))
                           {
                              if(c4 == -1)
                              {
                                 break loop0;
                              }
                              out.writeByte((c3 & 3) << 6 | c4);
                              continue loop0;
                           }
                        }
                        return out;
                     }
                     break loop0;
                  }
               }
               return out;
            }
            break;
         }
         out.position = 0;
         return out;
      }
      
      public static function encode(data:String) : String
      {
         var bytes:ByteArray = new ByteArray();
         bytes.writeUTFBytes(data);
         return encodeByteArray(bytes);
      }
      
      public static function decode(data:String) : String
      {
         var bytes:ByteArray = decodeToByteArray(data);
         return bytes.readUTFBytes(bytes.length);
      }
      
      public static function InitEncoreChar() : Vector.<int>
      {
         var i:int = 0;
         var encodeChars:Vector.<int> = new Vector.<int>();
         var chars:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
         for(i = 0; i < 64; )
         {
            encodeChars.push(chars.charCodeAt(i));
            i++;
         }
         return encodeChars;
      }
      
      public static function InitDecodeChar() : Vector.<int>
      {
         var decodeChars:Vector.<int> = new Vector.<int>();
         decodeChars.push(-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,62,-1,-1,-1,63,52,53,54,55,56,57,58,59,60,61,-1,-1,-1,-1,-1,-1,-1,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,-1,-1,-1,-1,-1,-1,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,-1,-1,-1,-1,-2,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1);
         return decodeChars;
      }
   }
}

