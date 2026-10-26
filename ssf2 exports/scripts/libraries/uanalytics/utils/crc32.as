package libraries.uanalytics.utils
{
   import flash.utils.ByteArray;
   import flash.utils.Endian;
   
   public final class crc32
   {
      
      private static var lookup:Vector.<uint> = make_crc_table();
      
      private static var _poly:uint = 3988292384;
      
      private static var _init:uint = 4294967295;
      
      private var _crc:uint;
      
      private var _length:uint;
      
      private var _endian:String;
      
      public function crc32()
      {
         super();
         this._length = 4294967295;
         this._endian = Endian.LITTLE_ENDIAN;
         this.reset();
      }
      
      private static function make_crc_table() : Vector.<uint>
      {
         var c:uint = 0;
         var i:uint = 0;
         var j:uint = 0;
         var table:Vector.<uint> = new Vector.<uint>();
         for(i = 0; i < 256; i++)
         {
            c = i;
            for(j = 0; j < 8; j++)
            {
               if((c & 1) != 0)
               {
                  c = uint(c >>> 1 ^ _poly);
               }
               else
               {
                  c >>>= 1;
               }
            }
            table[i] = c;
         }
         return table;
      }
      
      public function get endian() : String
      {
         return this._endian;
      }
      
      public function get length() : uint
      {
         return this._length;
      }
      
      public function update(bytes:ByteArray, offset:uint = 0, length:uint = 0) : void
      {
         var i:uint = 0;
         var c:uint = 0;
         if(length == 0)
         {
            length = bytes.length;
         }
         bytes.position = offset;
         var crc:uint = uint(this._length & this._crc);
         for(i = offset; i < length; i++)
         {
            c = uint(bytes[i]);
            crc = uint(crc >>> 8 ^ lookup[(crc ^ c) & 0xFF]);
         }
         this._crc = ~crc;
      }
      
      public function reset() : void
      {
         this._crc = _init;
      }
      
      public function valueOf() : uint
      {
         return this._crc;
      }
      
      public function toString(radix:Number = 16) : String
      {
         return this._crc.toString(radix);
      }
   }
}

