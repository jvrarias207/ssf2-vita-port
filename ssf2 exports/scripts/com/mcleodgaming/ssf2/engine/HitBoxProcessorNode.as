package com.mcleodgaming.ssf2.engine
{
   public class HitBoxProcessorNode
   {
      
      private var m_selfSprite:InteractiveSprite;
      
      private var m_otherSprite:InteractiveSprite;
      
      private var m_hboxResult:HitBoxCollisionResult;
      
      private var m_callback:Function;
      
      private var m_handled:Boolean;
      
      public function HitBoxProcessorNode(selfSprite:InteractiveSprite, otherSprite:InteractiveSprite, hBoxResult:HitBoxCollisionResult, callback:Function)
      {
         super();
         this.m_selfSprite = selfSprite;
         this.m_otherSprite = otherSprite;
         this.m_hboxResult = hBoxResult;
         this.m_callback = callback;
         this.m_handled = false;
      }
      
      public function run() : void
      {
         if(!this.m_handled && !this.m_selfSprite.SkipAttackProcessing)
         {
            this.m_callback(this.m_otherSprite,this.m_hboxResult);
            this.m_handled = true;
         }
      }
   }
}

