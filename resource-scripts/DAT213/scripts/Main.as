package
{
   [SWF(width="550", height="400", backgroundColor="#000000", frameRate="30")]
   public dynamic class Main extends SSF2Asset
   {
      
      public var stageMC:stage_finaldestination;
      
      public function Main()
      {
         super();
         register("id","finaldestination");
         register("guid","1fd1576f-0b77-4c6f-9a7d-3fe6ac0e6ce0");
         register("resources",{
            "movieclips":["finaldestination_bg","stage_finaldestination"],
            "sounds":[]
         });
         register("music",[{"id":"bgm_finaldestination"},{"id":"bgm_vsmasterhand"}]);
         register("stage",finaldestination);
         register("camera",{
            "x_start":275,
            "y_start":340,
            "backgrounds":[{"linkage_id":"finaldestination_bg"}]
         });
      }
   }
}

