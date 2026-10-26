package mario_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1116")]
   public dynamic class FTilt_25 extends MovieClip
   {
      
      public var attackBox:MovieClip;
      
      public var hitBox:MovieClip;
      
      public var hitBox2:MovieClip;
      
      public var hitBox3:MovieClip;
      
      public var hitBox4:MovieClip;
      
      public var hitBox5:MovieClip;
      
      public var itemBox:MovieClip;
      
      public var self:MarioExt;
      
      public var playsound:Number;
      
      public var audio:Number;
      
      public function FTilt_25()
      {
         super();
         addFrameScript(0,this.frame1,1,this.frame2,2,this.frame3,13,this.frame14);
      }
      
      internal function frame1() : *
      {
         this.self = SSF2API.getCharacter(this) as MarioExt;
         if(Boolean(parent) && Boolean(SSF2API.isReady()) && Boolean(this.self))
         {
            this.playsound = SSF2API.random();
            this.audio = this.self.getGlobalVariable("audio");
         }
      }
      
      internal function frame2() : *
      {
         if(this.playsound > 0.2 && this.playsound <= 0.4 && this.audio != 1)
         {
            this.self.playVoiceSound(1);
            this.self.setGlobalVariable("audio",1);
         }
         if(this.playsound > 0.4 && this.playsound <= 0.6 && this.audio != 2)
         {
            this.self.playVoiceSound(2);
            this.self.setGlobalVariable("audio",2);
         }
         if(this.playsound > 0.6 && this.playsound <= 0.8 && this.audio != 3)
         {
            this.self.playVoiceSound(3);
            this.self.setGlobalVariable("audio",3);
         }
         if(this.playsound > 0.8 && this.playsound <= 1 && this.audio != 4)
         {
            this.self.playVoiceSound(4);
            this.self.setGlobalVariable("audio",4);
         }
      }
      
      internal function frame3() : *
      {
         this.self.playSound("brawl_swing_m");
         this.self.attachEffect("global_dust_heavy",{
            "x":this.self.flipX(10),
            "y":1,
            "scaleX":-0.5,
            "scaleY":-0.5
         });
      }
      
      internal function frame14() : *
      {
         this.self.endAttack();
      }
   }
}

