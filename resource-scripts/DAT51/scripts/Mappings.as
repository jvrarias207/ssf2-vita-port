package
{
   [SWF(width="550", height="400", backgroundColor="#ffffff", frameRate="30")]
   public dynamic class Mappings extends SSF2Asset
   {
      
      private static const mappingsJSON:Class = Mappings_mappingsJSON;
      
      public function Mappings()
      {
         super();
         register("id","mappings");
         register("guid","d21861d9-0d6b-4ae7-a636-539fcd1d25c8");
         var _loc1_:String = new String(new mappingsJSON());
         var _loc2_:String = _loc1_;
         register("metadata",_loc1_);
         register("metadata_original",_loc2_);
      }
   }
}

