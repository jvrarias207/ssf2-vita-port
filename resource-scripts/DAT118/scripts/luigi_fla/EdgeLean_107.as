package luigi_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1410")]
   public dynamic class EdgeLean_107 extends MovieClip
   {
      
      public var hitBox:MovieClip;
      
      public var hitBox2:MovieClip;
      
      public var hitBox3:MovieClip;
      
      public var hitBox4:MovieClip;
      
      public var hitBox5:MovieClip;
      
      public var itemBox:MovieClip;
      
      public var self:LuigiExt;
      
      public var rand:int;
      
      public function EdgeLean_107()
      {
         super();
         addFrameScript(0,this.frame1,1,this.frame2,42,this.frame43);
      }
      
      internal function frame1() : *
      {
         this.self = SSF2API.getCharacter(this) as LuigiExt;
      }
      
      internal function frame2() : *
      {
         this.rand = 10 * SSF2API.random();
         if(this.rand >= 8 && !this.self.getMetalStatus())
         {
            this.self.playSound("luigi_otto",true);
         }
      }
      
      internal function frame43() : *
      {
         this.self.stancePlayFrame("loop");
      }
   }
}

