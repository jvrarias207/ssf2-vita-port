package luigi_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1409")]
   public dynamic class GetUpAttack_106 extends MovieClip
   {
      
      public var attackBox:MovieClip;
      
      public var hitBox:MovieClip;
      
      public var hitBox2:MovieClip;
      
      public var hitBox3:MovieClip;
      
      public var hitBox4:MovieClip;
      
      public var itemBox:MovieClip;
      
      public var self:LuigiExt;
      
      public var xframe:String;
      
      public function GetUpAttack_106()
      {
         super();
         addFrameScript(0,this.frame1,3,this.frame4,8,this.frame9,10,this.frame11,11,this.frame12,12,this.frame13,14,this.frame15,24,this.frame25);
      }
      
      internal function frame1() : *
      {
         this.self = SSF2API.getCharacter(this) as LuigiExt;
         this.xframe = null;
         if(SSF2API.isReady() && Boolean(this.self))
         {
            this.self.setIntangibility(true);
         }
      }
      
      internal function frame4() : *
      {
         this.xframe = "attack";
      }
      
      internal function frame9() : *
      {
         this.self.playSound("brawl_swing_s");
      }
      
      internal function frame11() : *
      {
         this.self.attachEffect("global_dust_swirl");
      }
      
      internal function frame12() : *
      {
         this.self.updateAttackBoxStats(1,{
            "damage":12,
            "direction":45
         });
      }
      
      internal function frame13() : *
      {
         this.self.playSound("brawl_swing_l");
      }
      
      internal function frame15() : *
      {
         this.self.setIntangibility(false);
      }
      
      internal function frame25() : *
      {
         this.self.endAttack();
      }
   }
}

