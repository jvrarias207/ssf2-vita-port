package luigi_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1432")]
   public dynamic class TechRoll_116 extends MovieClip
   {
      
      public var hitBox:MovieClip;
      
      public var hitBox2:MovieClip;
      
      public var hitBox3:MovieClip;
      
      public var hitBox4:MovieClip;
      
      public var itemBox:MovieClip;
      
      public var self:LuigiExt;
      
      public function TechRoll_116()
      {
         super();
         addFrameScript(0,this.frame1,10,this.frame11,20,this.frame21);
      }
      
      internal function frame1() : *
      {
         this.self = SSF2API.getCharacter(this) as LuigiExt;
         if(SSF2API.isReady() && Boolean(this.self))
         {
            this.self.setIntangibility(true);
            this.self.setGlobalVariable("canStartRise",true);
            if(!this.self.getMetalStatus())
            {
               this.self.playSound("luigi_grunt1",true);
            }
         }
      }
      
      internal function frame11() : *
      {
         this.self.setIntangibility(false);
      }
      
      internal function frame21() : *
      {
         this.self.endAttack();
      }
   }
}

