package mario_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1121")]
   public dynamic class NSpecial_32 extends MovieClip
   {
      
      public var hitBox:MovieClip;
      
      public var hitBox2:MovieClip;
      
      public var hitBox3:MovieClip;
      
      public var hitBox4:MovieClip;
      
      public var hitBox5:MovieClip;
      
      public var itemBox:MovieClip;
      
      public var self:MarioExt;
      
      public var curFrame:int;
      
      public function NSpecial_32()
      {
         super();
         addFrameScript(0,this.frame1,8,this.frame9,17,this.frame18);
      }
      
      internal function frame1() : *
      {
         this.self = SSF2API.getCharacter(this) as MarioExt;
         if(SSF2API.isReady() && Boolean(this.self))
         {
            this.curFrame = this.self.getGlobalVariable("MarioNSpecFrame");
            this.self.setGlobalVariable("MarioNSpecFrame",0);
            if(this.curFrame > 1)
            {
               this.self.stancePlayFrame(this.curFrame);
            }
         }
      }
      
      internal function frame9() : *
      {
         if(this.curFrame != currentFrame)
         {
            this.self.fireProjectile("mario_fireball",22,-20);
            this.self.attachEffect("nSpecWave",{
               "x":this.self.flipX(25),
               "y":-25
            });
            this.self.attachEffect("global_dust_heavy",{
               "x":this.self.flipX(5),
               "y":1,
               "scaleX":-0.5,
               "scaleY":-0.5
            });
            this.self.playSound("mario_fireballspawn");
            this.self.playSound("mario_fireballsfx");
         }
      }
      
      internal function frame18() : *
      {
         this.self.setAttackEnabled(false,"b_air");
         this.self.setAttackEnabled(false,"b");
         this.self.endAttack();
      }
   }
}

