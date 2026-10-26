package libraries.uanalytics.tracking
{
   public class HitSender implements AnalyticsSender
   {
      
      public function HitSender()
      {
         super();
      }
      
      protected function _addParameter(name:String, value:String) : String
      {
         var str:String = "";
         str += "&";
         str += this._appendEncoded(name.substring(1));
         str += "=";
         return str + this._appendEncoded(value);
      }
      
      protected function _appendEncoded(value:String) : String
      {
         return encodeURIComponent(value);
      }
      
      protected function _buildHit(model:HitModel) : String
      {
         var name:String = null;
         var value:String = null;
         var i:uint = 0;
         var str:String = "";
         str += "v=1";
         if(Configuration.SDKversion != "")
         {
            str += this._addParameter("&_v",Configuration.SDKversion);
         }
         var names:Vector.<String> = model.getFieldNames();
         names.sort(Array.CASEINSENSITIVE);
         for(i = 0; i < names.length; i++)
         {
            name = names[i];
            if(name.length > 0 && name.charAt(0) == Metadata.FIELD_PREFIX)
            {
               value = model.get(name);
               if(value != null)
               {
                  str += this._addParameter(name,value);
               }
            }
         }
         return str;
      }
      
      public function send(model:HitModel) : void
      {
      }
   }
}

