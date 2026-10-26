package mario_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1104")]
   public dynamic class Jump_17 extends MovieClip
   {
      
      public var hand:MovieClip;
      
      public var hitBox:MovieClip;
      
      public var hitBox2:MovieClip;
      
      public var hitBox3:MovieClip;
      
      public var hitBox4:MovieClip;
      
      public var hitBox5:MovieClip;
      
      public var hitBox6:MovieClip;
      
      public var itemBox:MovieClip;
      
      public var self:MarioExt;
      
      public var xframe:*;
      
      public function Jump_17()
      {
         super();
         addFrameScript(0,this.frame1,27,this.frame28,50,this.frame51);
      }
      
      internal function frame1() : *
      {
         this.self = SSF2API.getCharacter(this) as MarioExt;
         this.xframe = "midair";
         if(SSF2API.isReady() && Boolean(this.self))
         {
            if(this.self.getGlobalVariable("screwAttackOn"))
            {
               this.self.endAttack();
               this.self.forceAttack("item_screw");
            }
            else
            {
               this.self.playSound("mario_jumpsfx");
               this.self.playSound("jump_common");
            }
            this.self.setGlobalVariable("canStartRise",true);
         }
      }
      
      internal function frame28() : *
      {
         this.self.endAttack();
      }
      
      internal function frame51() : *
      {
         this.self.endAttack();
      }
   }
}

