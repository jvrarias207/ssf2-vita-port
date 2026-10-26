package com.mcleodgaming.ssf2.engine
{
   public class HitBoxCollisionResult
   {
      
      private var m_firstHitBox:HitBoxSprite;
      
      private var m_secondHitBox:HitBoxSprite;
      
      private var m_overlapHitBox:HitBoxSprite;
      
      public function HitBoxCollisionResult(hitBox1:HitBoxSprite, hitBox2:HitBoxSprite, overlapBox:HitBoxSprite)
      {
         super();
         this.m_firstHitBox = hitBox1;
         this.m_secondHitBox = hitBox2;
         this.m_overlapHitBox = overlapBox;
      }
      
      public function get FirstHitBox() : HitBoxSprite
      {
         return this.m_firstHitBox;
      }
      
      public function get SecondHitBox() : HitBoxSprite
      {
         return this.m_secondHitBox;
      }
      
      public function get OverlapHitBox() : HitBoxSprite
      {
         return this.m_overlapHitBox;
      }
   }
}

