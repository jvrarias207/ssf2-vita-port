package com.mcleodgaming.ssf2.util
{
   public class ProfanityFilter
   {
      
      private static var _instance:ProfanityFilter;
      
      private static const wordfilter:Class = ProfanityFilter_wordfilter;
      
      public static const wordfilterData:Object = JSON.parse(new String(new ProfanityFilter.wordfilter())) as Object;
      
      private var list:Array;
      
      private var placeHolder:String;
      
      public function ProfanityFilter(options:* = null)
      {
         super();
         options ||= {};
         this.placeHolder = options.placeHolder || "***";
         this.list = JSON.parse(JSON.stringify(wordfilterData.words)) as Array;
         for(var i:int = 0; i < this.list.length; i++)
         {
            this.list[i] = this.list[i].replace(/i/gi,"(i|l|1|!|¡|\\|)+");
         }
      }
      
      public static function get instance() : ProfanityFilter
      {
         if(!_instance)
         {
            _instance = new ProfanityFilter();
         }
         return _instance;
      }
      
      public function isProfane(text:String) : Boolean
      {
         return Boolean(this.clean(text)) ? true : false;
      }
      
      public function clean(text:String) : String
      {
         for(var i:int = 0; i < this.list.length; i++)
         {
            text = text.replace(new RegExp(this.list[i],"ig"),this.placeHolder);
         }
         return text;
      }
   }
}

