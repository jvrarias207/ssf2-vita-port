package luigi_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1324")]
   public dynamic class DSmash_38 extends MovieClip
   {
      
      public var attackBox:MovieClip;
      
      public var hitBox:MovieClip;
      
      public var hitBox2:MovieClip;
      
      public var hitBox3:MovieClip;
      
      public var hitBox4:MovieClip;
      
      public var hitBox5:MovieClip;
      
      public var itemBox:MovieClip;
      
      public var self:LuigiExt;
      
      public var xframe:String;
      
      public function DSmash_38()
      {
         super();
         addFrameScript(0,this.frame1,1,this.frame2,41,this.frame42,42,this.frame43,43,this.frame44,47,this.frame48,48,this.frame49,60,this.frame61);
      }
      
      public function effects() : void
      {
         this.self.attachEffect("global_dust_heavy",{
            "x":this.self.flipX(5),
            "y":3,
            "scaleX":-0.5,
            "scaleY":-0.5
         });
      }
      
      internal function frame1() : *
      {
         this.self = SSF2API.getCharacter(this) as LuigiExt;
         this.xframe = null;
      }
      
      internal function frame2() : *
      {
         this.xframe = "charging";
         this.self.createTimer(4,-1,this.effects);
      }
      
      internal function frame42() : *
      {
         this.self.stancePlayFrame("charging");
      }
      
      internal function frame43() : *
      {
         this.xframe = "attack";
         this.self.destroyTimer(this.effects);
      }
      
      internal function frame44() : *
      {
         this.self.playSound("brawl_swing_s");
         this.self.playSound("luigi_kickswing");
         this.self.playVoiceSound(1);
         this.self.attachEffect("global_dust_heavy");
         this.self.attachEffect("global_dust_swirl");
      }
      
      internal function frame48() : *
      {
         this.self.updateAttackBoxStats(1,{
            "damage":10,
            "power":35,
            "kbConstant":75,
            "effectSound":"brawl_kick_m"
         });
      }
      
      internal function frame49() : *
      {
         this.self.playSound("brawl_swing_l");
         this.self.playSound("luigi_kickswing");
      }
      
      internal function frame61() : *
      {
         this.self.endAttack();
      }
   }
}

