package luigi_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1317")]
   public dynamic class FSmash_29 extends MovieClip
   {
      
      public var attackBox:MovieClip;
      
      public var attackBox2:MovieClip;
      
      public var hitBox:MovieClip;
      
      public var hitBox2:MovieClip;
      
      public var hitBox3:MovieClip;
      
      public var hitBox4:MovieClip;
      
      public var hitBox5:MovieClip;
      
      public var itemBox:MovieClip;
      
      public var self:LuigiExt;
      
      public var xframe:String;
      
      public var customData:Object;
      
      public function FSmash_29()
      {
         super();
         addFrameScript(0,this.frame1,2,this.frame3,42,this.frame43,43,this.frame44,44,this.frame45,47,this.frame48,62,this.frame63);
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
         this.customData = {
            "attackBox":{},
            "attackBox2":{
               "damage":14,
               "power":30,
               "kbConstant":93,
               "hitStun":5,
               "selfHitStun":2,
               "priority":5
            }
         };
      }
      
      internal function frame3() : *
      {
         this.xframe = "charging";
         this.self.createTimer(4,-1,this.effects);
      }
      
      internal function frame43() : *
      {
         this.self.stancePlayFrame("charging");
      }
      
      internal function frame44() : *
      {
         this.xframe = "attack";
         this.self.destroyTimer(this.effects);
      }
      
      internal function frame45() : *
      {
         this.self.playVoiceSound(1);
      }
      
      internal function frame48() : *
      {
         this.self.playSound("brawl_swing_l");
         this.self.playSound("luigi_kickswing");
         this.self.attachEffect("global_dust_heavy");
         this.self.attachEffect("global_dust_blast",{
            "x":this.self.flipX(45),
            "y":-21.5,
            "parentLock":true
         });
      }
      
      internal function frame63() : *
      {
         this.self.endAttack();
      }
   }
}

