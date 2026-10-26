package com.mcleodgaming.ssf2
{
   import flash.desktop.NativeApplication;
   
   public final class Version
   {
      
      public static const appXML:XML = NativeApplication.nativeApplication.applicationDescriptor;
      
      public static const ns:Namespace = appXML.namespace();
      
      public static const Major:int = parseInt(String(appXML.ns::versionNumber).replace(/(\d)(\d)(\d)\.(\d)(\d)(\d)\.(\d)(\d)(\d)/g,"$1$2$3"));
      
      public static const Minor:int = parseInt(String(appXML.ns::versionNumber).replace(/(\d)(\d)(\d)\.(\d)(\d)(\d)\.(\d)(\d)(\d)/g,"$4"));
      
      public static const Build:int = parseInt(String(appXML.ns::versionNumber).replace(/(\d)(\d)(\d)\.(\d)(\d)(\d)\.(\d)(\d)(\d)/g,"$5"));
      
      public static const Revision:int = parseInt(String(appXML.ns::versionNumber).replace(/(\d)(\d)(\d)\.(\d)(\d)(\d)\.(\d)(\d)(\d)/g,"$6$7$8$9"));
      
      public static const supportedProfiles:String = String(appXML.ns::supportedProfiles);
      
      public function Version()
      {
         super();
      }
      
      public static function getVersion() : String
      {
         return Version.Major + "." + Version.Minor + "." + Version.Build + "." + Version.Revision;
      }
      
      public static function compare(currentMajor:int, currentMinor:int, currentRevision:int, updateMajor:int, updateMinor:int, updateRevision:int) : int
      {
         if(currentMajor > updateMajor)
         {
            return 1;
         }
         if(currentMajor < updateMajor)
         {
            return -1;
         }
         if(currentMinor > updateMinor)
         {
            return 1;
         }
         if(currentMinor < updateMinor)
         {
            return -1;
         }
         if(currentRevision > updateRevision)
         {
            return 1;
         }
         if(currentRevision < updateRevision)
         {
            return -1;
         }
         return 0;
      }
      
      public static function getAIRFormattedVersion() : String
      {
         var major:String = ("00" + Version.Major).replace(/\d*(\d\d\d)/g,"$1");
         var minor:String = ("00" + Version.Minor).replace(/\d*(\d\d\d)/g,"$1");
         var build:String = ("00" + Version.Build).replace(/\d*(\d\d\d)/g,"$1");
         var revision:String = ("00" + Version.Revision).replace(/\d*(\d\d\d)/g,"$1");
         return major + minor + build + revision;
      }
   }
}

