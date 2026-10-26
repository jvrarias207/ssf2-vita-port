package luigi_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1302")]
   public dynamic class SpecialFall_20 extends MovieClip
   {
      
      public var hand:MovieClip;
      
      public var hitBox:MovieClip;
      
      public var hitBox2:MovieClip;
      
      public var hitBox3:MovieClip;
      
      public var hitBox4:MovieClip;
      
      public var hitBox5:MovieClip;
      
      public var itemBox:MovieClip;
      
      public var self:LuigiExt;
      
      public function SpecialFall_20()
      {
         super();
         addFrameScript(0,this.frame1,7,this.frame8);
      }
      
      internal function frame1() : *
      {
         this.self = SSF2API.getCharacter(this) as LuigiExt;
         if(SSF2API.isReady() && Boolean(this.self))
         {
            if(this.self.getGlobalVariable("usedUpB"))
            {
               this.self.setGlobalVariable("usedUpB",false);
               this.self.stancePlayFrame("up");
            }
            else
            {
               this.self.stancePlayFrame("reg");
            }
         }
      }
      
      internal function frame8() : *
      {
         this.self.stancePlayFrame("up");
      }
   }
}

