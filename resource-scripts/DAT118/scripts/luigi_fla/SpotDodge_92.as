package luigi_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1393")]
   public dynamic class SpotDodge_92 extends MovieClip
   {
      
      public var hitBox:MovieClip;
      
      public var hitBox2:MovieClip;
      
      public var hitBox4:MovieClip;
      
      public var itemBox:MovieClip;
      
      public var self:LuigiExt;
      
      public function SpotDodge_92()
      {
         super();
         addFrameScript(0,this.frame1,1,this.frame2,8,this.frame9,13,this.frame14);
      }
      
      internal function frame1() : *
      {
         this.self = SSF2API.getCharacter(this) as LuigiExt;
      }
      
      internal function frame2() : *
      {
         this.self.setIntangibility(true);
         this.self.attachEffect("global_dust_cloud",{
            "scaleX":0.8,
            "scaleY":0.8
         });
      }
      
      internal function frame9() : *
      {
         this.self.setIntangibility(false);
      }
      
      internal function frame14() : *
      {
         this.self.endAttack();
      }
   }
}

