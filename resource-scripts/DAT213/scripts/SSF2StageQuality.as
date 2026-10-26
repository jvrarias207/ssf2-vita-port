package
{
   public class SSF2StageQuality
   {
      
      public function SSF2StageQuality()
      {
         super();
      }
      
      public static function init(param1:Array = null, param2:Array = null, param3:Array = null, param4:Array = null, param5:Array = null, param6:Array = null) : void
      {
         var _loc9_:Array = null;
         var _loc10_:Array = null;
         var _loc11_:Array = null;
         var _loc12_:* = undefined;
         var _loc13_:* = undefined;
         var _loc14_:* = undefined;
         var _loc15_:* = undefined;
         var _loc7_:String = SSF2API.getQualitySettings().stage_effects;
         var _loc8_:String = SSF2API.getQualitySettings().ambient_lighting;
         SSF2API.print("Applying stage effects quality setting: " + _loc7_ + ".");
         if(_loc7_ == "disabled")
         {
            _loc9_ = null;
            _loc10_ = param2;
            _loc11_ = param3;
         }
         else if(_loc7_ == "simple")
         {
            _loc10_ = param4;
            _loc11_ = param5;
         }
         if(_loc7_ != "enabled" && _loc7_ != null)
         {
            if(_loc9_ != null)
            {
               _loc12_ = 0;
               while(_loc12_ < _loc9_.length)
               {
                  if(_loc9_[_loc12_] != null)
                  {
                     SSF2Utils.setTint(_loc9_[_loc12_],0.7,0.7,0.7,1,0,0,0,0);
                  }
                  else
                  {
                     SSF2API.print("*****ERROR***** The tintedMC in position " + _loc12_ + " is inaccessible!!!");
                  }
                  _loc12_++;
               }
               SSF2API.print("" + _loc12_ + " MC\'s tinted successfully.");
            }
            if(_loc10_ != null)
            {
               _loc13_ = 0;
               while(_loc13_ < _loc10_.length)
               {
                  if(_loc10_[_loc13_] != null)
                  {
                     _loc10_[_loc13_].visible = false;
                  }
                  else
                  {
                     SSF2API.print("*****ERROR***** The hiddenMC in position " + _loc13_ + " is inaccessible!!!");
                  }
                  _loc13_++;
               }
               SSF2API.print("" + _loc13_ + " MC\'s hidden successfully.");
            }
            if(_loc11_ != null)
            {
               _loc14_ = 0;
               while(_loc14_ < _loc11_.length)
               {
                  if(_loc11_[_loc14_] != null)
                  {
                     _loc11_[_loc14_].visible = false;
                  }
                  else
                  {
                     SSF2API.print("*****ERROR***** The hiddenCamBG in position " + _loc14_ + " is inaccessible!!!");
                  }
                  _loc14_++;
               }
               SSF2API.print("" + _loc14_ + " BG MC\'s hidden successfully.");
            }
         }
         if(_loc8_ != "enabled" && _loc8_ != null)
         {
            if(param6 != null)
            {
               _loc15_ = 0;
               while(_loc15_ < param6.length)
               {
                  if(param6[_loc15_] != null)
                  {
                     param6[_loc15_].visible = false;
                  }
                  else
                  {
                     SSF2API.print("*****ERROR***** The ambientLightMC in position " + _loc15_ + " is inaccessible!!!");
                  }
                  _loc15_++;
               }
               SSF2API.print("" + _loc15_ + " ambient light MC\'s hidden successfully.");
            }
         }
         SSF2API.print("Done applying quality settings!");
      }
   }
}

