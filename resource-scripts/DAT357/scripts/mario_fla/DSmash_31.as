package mario_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1120")]
   public dynamic class DSmash_31 extends MovieClip
   {
      
      public var attackBox:MovieClip;
      
      public var hitBox:MovieClip;
      
      public var hitBox2:MovieClip;
      
      public var hitBox3:MovieClip;
      
      public var hitBox4:MovieClip;
      
      public var hitBox5:MovieClip;
      
      public var itemBox:MovieClip;
      
      public var self:MarioExt;
      
      public var xframe:String;
      
      public function DSmash_31()
      {
         super();
         addFrameScript(0,this.frame1,2,this.frame3,41,this.frame42,42,this.frame43,43,this.frame44,46,this.frame47,64,this.frame65);
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
         this.self = SSF2API.getCharacter(this) as MarioExt;
         this.xframe = null;
      }
      
      internal function frame3() : *
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
         this.self.attachEffect("global_dust_heavy",{
            "x":this.self.flipX(10),
            "y":1,
            "scaleX":-0.5,
            "scaleY":-0.5
         });
         this.self.attachEffect("global_dust_swirl");
         this.self.playVoiceSound(1);
      }
      
      internal function frame44() : *
      {
         this.self.playSound("brawl_swing_l");
         this.self.playSound("mario_kickswing");
      }
      
      internal function frame47() : *
      {
         this.self.updateAttackBoxStats(1,{
            "damage":10,
            "power":35,
            "kbConstant":75
         });
         this.self.attachEffect("global_dust_heavy_rv",{
            "x":this.self.flipX(-5),
            "y":1,
            "scaleX":-0.5,
            "scaleY":-0.5
         });
         this.self.playSound("brawl_swing_s");
         this.self.playSound("mario_kickswing");
      }
      
      internal function frame65() : *
      {
         this.self.endAttack();
      }
   }
}

