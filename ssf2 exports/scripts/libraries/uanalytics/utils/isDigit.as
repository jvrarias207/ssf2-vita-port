package libraries.uanalytics.utils
{
   public function isDigit(c:String, index:uint = 0) : Boolean
   {
      if(index > 0)
      {
         c = c.charAt(index);
      }
      return "0" <= c && c <= "9";
   }
}

