package luigi_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1326")]
   public dynamic class NSpecialAir_42 extends MovieClip
   {
      
      public var hitBox:MovieClip;
      
      public var hitBox2:MovieClip;
      
      public var hitBox3:MovieClip;
      
      public var hitBox4:MovieClip;
      
      public var hitBox5:MovieClip;
      
      public var itemBox:MovieClip;
      
      public var self:LuigiExt;
      
      public function NSpecialAir_42()
      {
         super();
         addFrameScript(0,this.frame1,8,this.frame9,16,this.frame17);
      }
      
      public function grounded(param1:* = null) : *
      {
         this.self.setGlobalVariable("canStartRise",true);
         this.self.setGlobalVariable("LuigiNSpecFrame",currentFrame);
         this.self.forceAttack("b",null,true);
      }
      
      internal function frame1() : *
      {
         this.self = SSF2API.getCharacter(this) as LuigiExt;
         if(Boolean(this.self) && SSF2API.isReady())
         {
            this.self.addEventListener(SSF2Event.GROUND_TOUCH,this.grounded);
         }
      }
      
      internal function frame9() : *
      {
         this.self.fireProjectile("luigi_fireball",22,-20);
         this.self.attachEffect("nSpecWaveG",{
            "x":this.self.flipX(10),
            "y":-25
         });
         this.self.attachEffect("global_dust_heavy",{
            "x":this.self.flipX(5),
            "y":1,
            "scaleX":-0.5,
            "scaleY":-0.5
         });
         this.self.playSound("luigi_fireball_sfx");
      }
      
      internal function frame17() : *
      {
         this.self.setAttackEnabled(false,"b_air");
         this.self.setAttackEnabled(false,"b");
         this.self.endAttack();
      }
   }
}

