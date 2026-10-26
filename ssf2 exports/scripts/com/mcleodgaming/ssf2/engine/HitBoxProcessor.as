package com.mcleodgaming.ssf2.engine
{
   public class HitBoxProcessor
   {
      
      protected var m_reactions:Vector.<Vector.<HitBoxProcessorNode>> = new Vector.<Vector.<HitBoxProcessorNode>>();
      
      public function HitBoxProcessor()
      {
         super();
         this.m_reactions = new Vector.<Vector.<HitBoxProcessorNode>>();
      }
      
      public function process() : void
      {
         var j:int = 0;
         for(var i:int = 0; i < this.m_reactions.length; i++)
         {
            for(j = 0; j < this.m_reactions[i].length; j++)
            {
               this.m_reactions[i][j].run();
            }
            this.m_reactions[i].splice(0,this.m_reactions[i].length);
         }
      }
      
      public function queue(node:HitBoxProcessorNode, priority:int) : void
      {
         if(priority >= this.m_reactions.length)
         {
            while(priority >= this.m_reactions.length)
            {
               this.m_reactions.push(new Vector.<HitBoxProcessorNode>());
            }
         }
         this.m_reactions[priority].push(node);
      }
   }
}

