package
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol210")]
   public dynamic class countdownTimer extends MovieClip
   {
      
      public var showCountdownType:int;
      
      public function countdownTimer()
      {
         super();
         addFrameScript(0,this.frame1,2,this.frame3,29,this.frame30,59,this.frame60,90,this.frame91,109,this.frame110,165,this.frame166,189,this.frame190,194,this.frame195,235,this.frame236,265,this.frame266,466,this.frame467,530,this.frame531);
      }
      
      internal function frame1() : *
      {
         this.showCountdownType = 0;
         stop();
      }
      
      internal function frame3() : *
      {
         SSF2API.playSound("narrator_3",true);
      }
      
      internal function frame30() : *
      {
         SSF2API.playSound("narrator_2",true);
      }
      
      internal function frame60() : *
      {
         SSF2API.playSound("narrator_1",true);
      }
      
      internal function frame91() : *
      {
         SSF2API.playSound("narrator_go",true);
         SSF2API.matchGo();
      }
      
      internal function frame110() : *
      {
         SSF2API.matchGoComplete();
         stop();
         if(root != null && parent != null)
         {
            parent.removeChild(this);
         }
      }
      
      internal function frame166() : *
      {
         SSF2API.playSound("narrator_go",true);
         SSF2API.matchGo();
      }
      
      internal function frame190() : *
      {
         SSF2API.matchGoComplete();
         stop();
         if(root != null && parent != null)
         {
            parent.removeChild(this);
         }
      }
      
      internal function frame195() : *
      {
         SSF2API.playSound("narrator_ready",true);
      }
      
      internal function frame236() : *
      {
         if(this.showCountdownType == 3)
         {
            gotoAndStop("go");
         }
         else
         {
            SSF2API.matchGo();
            SSF2API.playSound("narrator_go",true);
         }
      }
      
      internal function frame266() : *
      {
         SSF2API.matchGoComplete();
         stop();
         if(root != null && parent != null)
         {
            parent.removeChild(this);
         }
      }
      
      internal function frame467() : *
      {
         stop();
         if(root != null && parent != null)
         {
            parent.removeChild(this);
         }
      }
      
      internal function frame531() : *
      {
         stop();
         if(root != null && parent != null)
         {
            parent.removeChild(this);
         }
      }
   }
}

