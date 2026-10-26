package mario_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1122")]
   public dynamic class NSpecialAir_33 extends MovieClip
   {
      
      public var hitBox:MovieClip;
      
      public var hitBox2:MovieClip;
      
      public var hitBox3:MovieClip;
      
      public var hitBox4:MovieClip;
      
      public var hitBox5:MovieClip;
      
      public var itemBox:MovieClip;
      
      public var self:MarioExt;
      
      public function NSpecialAir_33()
      {
         super();
         addFrameScript(0,this.frame1,8,this.frame9,17,this.frame18);
      }
      
      public function grounded(param1:* = null) : *
      {
         this.self.setGlobalVariable("canStartRise",true);
         this.self.setGlobalVariable("MarioNSpecFrame",currentFrame);
         this.self.forceAttack("b",null,true);
      }
      
      internal function frame1() : *
      {
         this.self = SSF2API.getCharacter(this) as MarioExt;
         if(Boolean(this.self) && SSF2API.isReady())
         {
            this.self.addEventListener(SSF2Event.GROUND_TOUCH,this.grounded);
         }
      }
      
      internal function frame9() : *
      {
         this.self.fireProjectile("mario_fireball",22,-20);
         this.self.attachEffect("nSpecWave",{
            "x":this.self.flipX(10),
            "y":-25,
            "rotation":this.self.flipX(20)
         });
         this.self.attachEffect("global_dust_heavy",{
            "x":this.self.flipX(5),
            "y":1,
            "scaleX":-0.5,
            "scaleY":-0.5,
            "parentLock":true
         });
         this.self.playSound("mario_fireballspawn");
         this.self.playSound("mario_fireballsfx");
      }
      
      internal function frame18() : *
      {
         this.self.setAttackEnabled(false,"b_air");
         this.self.setAttackEnabled(false,"b");
         this.self.endAttack();
      }
   }
}

