package com.hurlant.crypto.hash
{
   import flash.utils.ByteArray;
   
   public class SHABase implements IHash
   {
      
      public var pad_size:int = 40;
      
      public function SHABase()
      {
         super();
      }
      
      public function getInputSize() : uint
      {
         return 64;
      }
      
      public function getHashSize() : uint
      {
         return 0;
      }
      
      public function getPadSize() : int
      {
         return pad_size;
      }
      
      public function hash(src:ByteArray) : ByteArray
      {
         var i:* = 0;
         var savedLength:uint = src.length;
         var savedEndian:String = src.endian;
         src.endian = "bigEndian";
         var len:uint = savedLength * 8;
         while(src.length % 4 != 0)
         {
            src[src.length] = 0;
         }
         src.position = 0;
         var a:Array = [];
         for(i = 0; i < src.length; )
         {
            a.push(src.readUnsignedInt());
            i += 4;
         }
         var h:Array = core(a,len);
         var out:ByteArray = new ByteArray();
         var words:uint = getHashSize() / 4;
         for(i = 0; i < words; )
         {
            out.writeUnsignedInt(h[i]);
            i++;
         }
         src.length = savedLength;
         src.endian = savedEndian;
         return out;
      }
      
      protected function core(x:Array, len:uint) : Array
      {
         return null;
      }
      
      public function toString() : String
      {
         return "sha";
      }
   }
}

