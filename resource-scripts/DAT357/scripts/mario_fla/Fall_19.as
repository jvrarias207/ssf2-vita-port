package mario_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1106")]
   public dynamic class Fall_19 extends MovieClip
   {
      
      public var hand:MovieClip;
      
      public var hitBox:MovieClip;
      
      public var hitBox2:MovieClip;
      
      public var hitBox3:MovieClip;
      
      public var hitBox4:MovieClip;
      
      public var itemBox:MovieClip;
      
      public var self:MarioExt;
      
      public function Fall_19()
      {
         super();
         addFrameScript(0,this.frame1,13,this.frame14);
      }
      
      internal function frame1() : *
      {
         this.self = SSF2API.getCharacter(this) as MarioExt;
         if(SSF2API.isReady() && Boolean(this.self))
         {
            this.self.stancePlayFrame("again");
         }
      }
      
      internal function frame14() : *
      {
         this.self.stancePlayFrame("again");
      }
   }
}

