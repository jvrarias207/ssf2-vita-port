package com.mcleodgaming.ssf2.util
{
   public class CountryRegionData
   {
      
      private static const countryRegionDataJSON:Class = CountryRegionData_countryRegionDataJSON;
      
      public static const data:Object = JSON.parse(new String(new CountryRegionData.countryRegionDataJSON())) as Object;
      
      public function CountryRegionData()
      {
         super();
      }
      
      public static function getCountryName(countryCode:String) : String
      {
         var country:Object = null;
         for(var i:int = 0; i < CountryRegionData.data.length; i++)
         {
            country = CountryRegionData.data[i];
            if(country.countryShortCode === countryCode)
            {
               return country.countryName;
            }
         }
         return "";
      }
      
      public static function getRegionName(countryCode:String, regionCode:String) : String
      {
         var country:Object = null;
         var j:int = 0;
         var region:Object = null;
         for(var i:int = 0; i < CountryRegionData.data.length; i++)
         {
            country = CountryRegionData.data[i];
            if(country.countryShortCode === countryCode)
            {
               for(j = 0; j < country.regions.length; j++)
               {
                  region = country.regions[j];
                  if(region.shortCode === regionCode)
                  {
                     return region.name;
                  }
               }
               break;
            }
         }
         return "";
      }
      
      public static function getLocationClean(countryCode:String, regionCode:String) : String
      {
         var countryName:String = getCountryName(countryCode);
         var regionName:String = getRegionName(countryCode,regionCode);
         if(!countryName)
         {
            return "Unknown";
         }
         if(!regionName)
         {
            return countryName;
         }
         return countryName + "/" + regionName;
      }
   }
}

