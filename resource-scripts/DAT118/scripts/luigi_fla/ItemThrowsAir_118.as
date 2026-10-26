package luigi_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1434")]
   public dynamic class ItemThrowsAir_118 extends MovieClip
   {
      
      public var hitBox:MovieClip;
      
      public var hitBox2:MovieClip;
      
      public var hitBox3:MovieClip;
      
      public var itemBox:MovieClip;
      
      public var self:LuigiExt;
      
      public function ItemThrowsAir_118()
      {
         super();
         addFrameScript(0,this.frame1,1,this.frame2,3,this.frame4,10,this.frame11,11,this.frame12,12,this.frame13,14,this.frame15,22,this.frame23,23,this.frame24,24,this.frame25,26,this.frame27,34,this.frame35,35,this.frame36,36,this.frame37,38,this.frame39,46,this.frame47);
      }
      
      internal function frame1() : *
      {
         this.self = SSF2API.getCharacter(this) as LuigiExt;
         if(Boolean(this.self) && SSF2API.isReady())
         {
            this.self.addEventListener(SSF2Event.GROUND_TOUCH,this.self.toLand);
         }
      }
      
      internal function frame2() : *
      {
         this.self.attachEffect("global_dust_swirl");
      }
      
      internal function frame4() : *
      {
         this.self.tossItem(158);
      }
      
      internal function frame11() : *
      {
         this.self.endAttack();
      }
      
      internal function frame12() : *
      {
         this.self.addEventListener(SSF2Event.GROUND_TOUCH,this.self.toLand);
      }
      
      internal function frame13() : *
      {
         this.self.attachEffect("global_dust_swirl");
      }
      
      internal function frame15() : *
      {
         this.self.tossItem(270);
      }
      
      internal function frame23() : *
      {
         this.self.endAttack();
      }
      
      internal function frame24() : *
      {
         this.self.addEventListener(SSF2Event.GROUND_TOUCH,this.self.toLand);
      }
      
      internal function frame25() : *
      {
         this.self.attachEffect("global_dust_swirl");
      }
      
      internal function frame27() : *
      {
         this.self.tossItem(90);
      }
      
      internal function frame35() : *
      {
         this.self.endAttack();
      }
      
      internal function frame36() : *
      {
         this.self.addEventListener(SSF2Event.GROUND_TOUCH,this.self.toLand);
      }
      
      internal function frame37() : *
      {
         this.self.attachEffect("global_dust_swirl");
      }
      
      internal function frame39() : *
      {
         this.self.tossItem(12);
      }
      
      internal function frame47() : *
      {
         this.self.endAttack();
      }
   }
}

