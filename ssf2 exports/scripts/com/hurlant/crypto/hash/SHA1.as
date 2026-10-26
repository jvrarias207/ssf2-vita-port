package com.hurlant.crypto.hash
{
   public class SHA1 extends SHABase implements IHash
   {
      
      public static const HASH_SIZE:int = 20;
      
      public function SHA1()
      {
         super();
      }
      
      override public function getHashSize() : uint
      {
         return 20;
      }
      
      override protected function core(x:Array, len:uint) : Array
      {
         var i:* = 0;
         var olda:* = 0;
         var oldb:* = 0;
         var oldc:* = 0;
         var oldd:* = 0;
         var olde:* = 0;
         var j:* = 0;
         var t:* = 0;
         x[len >> 5] |= 128 << 24 - len % 32;
         x[(len + 64 >> 9 << 4) + 15] = len;
         var w:Array = [];
         var a:* = 1732584193;
         var b:* = 4023233417;
         var c:* = 2562383102;
         var d:* = 271733878;
         var e:* = 3285377520;
         for(i = 0; i < x.length; )
         {
            olda = a;
            oldb = b;
            oldc = c;
            oldd = d;
            olde = e;
            for(j = 0; j < 80; )
            {
               if(j < 16)
               {
                  w[j] = x[i + j] || 0;
               }
               else
               {
                  w[j] = rol(w[j - 3] ^ w[j - 8] ^ w[j - 14] ^ w[j - 16],1);
               }
               t = uint(rol(a,5) + ft(j,b,c,d) + e + w[j] + kt(j));
               e = d;
               d = c;
               c = rol(b,30);
               b = a;
               a = t;
               j++;
            }
            a += olda;
            b += oldb;
            c += oldc;
            d += oldd;
            e += olde;
            i += 16;
         }
         return [a,b,c,d,e];
      }
      
      private function rol(num:uint, cnt:uint) : uint
      {
         return num << cnt | num >>> 32 - cnt;
      }
      
      private function ft(t:uint, b:uint, c:uint, d:uint) : uint
      {
         if(t < 20)
         {
            return b & c | ~b & d;
         }
         if(t < 40)
         {
            return b ^ c ^ d;
         }
         if(t < 60)
         {
            return b & c | b & d | c & d;
         }
         return b ^ c ^ d;
      }
      
      private function kt(t:uint) : uint
      {
         return t < 20 ? 1518500249 : (t < 40 ? 1859775393 : (t < 60 ? 2400959708 : 3395469782));
      }
      
      override public function toString() : String
      {
         return "sha1";
      }
   }
}

