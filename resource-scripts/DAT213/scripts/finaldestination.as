package
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.geom.ColorTransform;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class finaldestination extends SSF2Stage
   {
      
      public var frames:int;
      
      private var phase3Ready:Boolean;
      
      private var sparkbits:Array;
      
      private var sparkrect:Rectangle;
      
      private var tempbit:BitmapData;
      
      private var temppoint:Point;
      
      private var alphatrans:ColorTransform;
      
      private var sparkles:Array;
      
      private var bitmap:Bitmap;
      
      public function finaldestination(param1:*)
      {
         super(param1);
      }
      
      override public function initialize() : void
      {
         var _loc1_:Array = [this.getBackground(),this.getForeground()];
         var _loc2_:Array = null;
         var _loc3_:Array = [this.getCameraBackgrounds()[0].mc];
         var _loc4_:Array = null;
         var _loc5_:Array = null;
         var _loc6_:Array = [this.getForeground().fd_ambient];
         SSF2StageQuality.init(_loc1_,_loc2_,_loc3_,_loc4_,_loc5_,_loc6_);
         this.frames = 0;
         this.phase3Ready = false;
         this.sparkbits = new Array();
         this.sparkbits.push(new fdsparkle0());
         this.sparkbits.push(new fdsparkle1());
         this.sparkbits.push(new fdsparkle2());
         this.sparkbits.push(new fdsparkle3());
         this.sparkbits.push(new fdsparkle4());
         this.sparkbits.push(new fdsparkle5());
         this.sparkbits.push(new fdsparkle6());
         this.sparkbits.push(new fdsparkle7());
         this.sparkbits.push(new fdsparkle8());
         this.sparkbits.push(new fdsparkle9());
         this.sparkbits.push(new fdsparkle10());
         this.sparkbits.push(new fdsparkle11());
         this.sparkrect = new Rectangle(0,0,this.sparkbits[0].width,this.sparkbits[0].height);
         this.tempbit = new BitmapData(this.sparkrect.width,this.sparkrect.height,true,0);
         this.temppoint = new Point();
         this.alphatrans = new ColorTransform();
         this.sparkles = new Array();
         this.bitmap = new Bitmap(new BitmapData(1000,640,true,0));
      }
      
      override public function update() : void
      {
         var _loc1_:* = undefined;
         if(this.frames < 3600 && SSF2API.getCurrentMusicInfo().linkage != "bgm_finaldestination")
         {
            ++this.frames;
         }
         else
         {
            this.frames = 0;
         }
         if(this.phase3Ready)
         {
            if(SSF2API.getQualitySettings().stage_effects == "enabled")
            {
               ++this.getCameraBackgrounds()[0].mc.spinny.rotation;
            }
            this.bitmap.bitmapData.fillRect(new Rectangle(0,0,1010,640),0);
            this.addSparkle();
            this.addSparkle();
            if(SSF2API.getQualitySettings().stage_effects == "enabled")
            {
               this.addSparkle();
            }
            _loc1_ = 0;
            while(_loc1_ < this.sparkles.length)
            {
               this.temppoint.x = 0;
               this.temppoint.y = 0;
               this.tempbit.copyPixels(this.sparkbits[this.sparkles[_loc1_].spark],this.sparkrect,this.temppoint);
               this.alphatrans.alphaMultiplier = Math.min((this.sparkles[_loc1_].speed - 4) / 10,1);
               this.tempbit.colorTransform(this.sparkrect,this.alphatrans);
               this.temppoint.x = this.sparkles[_loc1_].x - this.sparkrect.width / 2;
               this.temppoint.y = this.sparkles[_loc1_].y - this.sparkrect.height / 2;
               this.bitmap.bitmapData.copyPixels(this.tempbit,this.sparkrect,this.temppoint,null,null,true);
               this.sparkles[_loc1_].x += this.sparkles[_loc1_].speed * Math.cos(this.sparkles[_loc1_].angle);
               this.sparkles[_loc1_].y += this.sparkles[_loc1_].speed * Math.sin(this.sparkles[_loc1_].angle);
               this.sparkles[_loc1_].speed *= 1.1;
               if(this.sparkles[_loc1_].x < -10 || this.sparkles[_loc1_].x >= 1010 || this.sparkles[_loc1_].y < -10 || this.sparkles[_loc1_].y > 650)
               {
                  this.sparkles.splice(_loc1_,1);
                  _loc1_--;
               }
               _loc1_++;
            }
         }
      }
      
      private function addSparkle() : *
      {
         var _loc1_:* = Math.random() * Math.PI * 2;
         var _loc2_:* = int((_loc1_ * 180 / Math.PI + 5) % 180 / 15);
         this.sparkles.push({
            "angle":_loc1_,
            "x":500,
            "y":320,
            "speed":3,
            "spark":_loc2_
         });
      }
      
      public function startPhase3() : *
      {
         this.getCameraBackgrounds()[0].mc.container.addChild(this.bitmap);
         this.phase3Ready = true;
      }
      
      public function killPhase3() : *
      {
         this.getCameraBackgrounds()[0].mc.container.removeChild(this.bitmap);
         this.sparkles = new Array();
         this.phase3Ready = false;
      }
   }
}

