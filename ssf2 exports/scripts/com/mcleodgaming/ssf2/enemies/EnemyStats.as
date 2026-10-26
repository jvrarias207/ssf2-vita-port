package com.mcleodgaming.ssf2.enemies
{
   import com.mcleodgaming.ssf2.engine.InteractiveSpriteStats;
   
   public class EnemyStats extends InteractiveSpriteStats
   {
      
      public function EnemyStats()
      {
         super();
      }
      
      public function Clone() : EnemyStats
      {
         var obj:Object = exportData();
         var enemy:EnemyStats = new EnemyStats();
         enemy.importData(obj);
         return enemy;
      }
      
      override public function getVar(varName:String) : *
      {
         if(this["m_" + varName] !== undefined)
         {
            return this["m_" + varName];
         }
         return null;
      }
   }
}

