package com.mcleodgaming.ssf2.engine
{
   import com.mcleodgaming.ssf2.Main;
   import com.mcleodgaming.ssf2.util.*;
   
   public class StageSetting
   {
      
      public function StageSetting()
      {
         super();
      }
      
      private static function getStagesArray(includeHidden:Boolean = false, hideTraining:Boolean = true) : Vector.<String>
      {
         var settingsArray:Vector.<String> = new Vector.<String>();
         var mappings:Object = ResourceManager.getResourceByID("mappings").getProp("metadata");
         var stagesObj:Array = mappings.random_stages.stages;
         for(var i:int = 0; i < stagesObj.length; i++)
         {
            if((Boolean(Main.DEBUG || includeHidden || !includeHidden && SaveData.Unlocks[stagesObj[i]] !== false)) && Boolean(mappings.stage[stagesObj[i]]) && !(hideTraining && mappings.stage[stagesObj[i]].training_only))
            {
               settingsArray.push(stagesObj[i]);
            }
         }
         return settingsArray;
      }
      
      public static function getRandomStage(includeHidden:Boolean = false, includeDisabled:Boolean = false, hideTraining:Boolean = true) : String
      {
         var settingsArray:Vector.<String> = getStagesArray(includeHidden,hideTraining);
         var i:int = settingsArray.length - 1;
         while(i >= 0 && !includeDisabled)
         {
            if(SaveData.VSStageDataObj[settingsArray[i]] === false)
            {
               settingsArray.splice(i,1);
            }
            i--;
         }
         if(settingsArray.length == 0)
         {
            return "battlefield";
         }
         return settingsArray[Utils.randomInteger(0,settingsArray.length - 1)];
      }
   }
}

