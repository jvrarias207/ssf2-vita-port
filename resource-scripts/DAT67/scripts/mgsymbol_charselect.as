package
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol557")]
   public dynamic class mgsymbol_charselect extends MovieClip
   {
      
      public function mgsymbol_charselect()
      {
         super();
         addFrameScript(0,this.frame1,9,this.frame10);
      }
      
      internal function frame1() : *
      {
         this.mouseEnabled = false;
      }
      
      internal function frame10() : *
      {
         stop();
         if(parent != null)
         {
            parent.removeChild(this);
         }
      }
   }
}

