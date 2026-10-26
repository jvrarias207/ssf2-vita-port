package libraries.uanalytics.utils
{
   import flash.net.LocalConnection;
   
   public function getHostname() : String
   {
      var lc:LocalConnection = null;
      var hostname:String = "";
      if(LocalConnection.isSupported)
      {
         lc = new LocalConnection();
         hostname = lc.domain;
      }
      if(hostname.substr(0,4) == "app#" || hostname == "")
      {
         hostname = "localhost";
      }
      return hostname;
   }
}

