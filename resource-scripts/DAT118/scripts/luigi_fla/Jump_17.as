package luigi_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1299")]
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
      
      public var self:LuigiExt;
      
      public var xframe:*;
      
      public var done:*;
      
      public function Jump_17()
      {
         super();
         addFrameScript(0,this.frame1,24,this.frame25,34,this.frame35,48,this.frame49);
      }
      
      internal function frame1() : *
      {
         this.self = SSF2API.getCharacter(this) as LuigiExt;
         this.xframe = "midair";
         this.done = false;
         if(SSF2API.isReady() && Boolean(this.self))
         {
            if(this.self.getGlobalVariable("screwAttackOn"))
            {
               this.self.endAttack();
               this.self.forceAttack("item_screw");
            }
            else
            {
               this.self.playSound("luigi_jumpsfx");
            }
            this.self.setGlobalVariable("canStartRise",true);
         }
      }
      
      internal function frame25() : *
      {
         this.self.endAttack();
      }
      
      internal function frame35() : *
      {
         this.self.playSound("luigi_backjump");
      }
      
      internal function frame49() : *
      {
         this.self.endAttack();
      }
   }
}

