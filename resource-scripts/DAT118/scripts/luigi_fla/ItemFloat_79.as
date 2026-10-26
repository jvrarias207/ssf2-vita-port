package luigi_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1363")]
   public dynamic class ItemFloat_79 extends MovieClip
   {
      
      public var hitBox:MovieClip;
      
      public var itemBox:MovieClip;
      
      public var self:LuigiExt;
      
      public function ItemFloat_79()
      {
         super();
         addFrameScript(0,this.frame1,2,this.frame3);
      }
      
      internal function frame1() : *
      {
         this.self = SSF2API.getCharacter(this) as LuigiExt;
      }
      
      internal function frame3() : *
      {
         this.self.endAttack();
      }
   }
}

