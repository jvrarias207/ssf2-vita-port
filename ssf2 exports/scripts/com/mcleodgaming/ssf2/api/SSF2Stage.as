package com.mcleodgaming.ssf2.api
{
   import com.mcleodgaming.ssf2.engine.StageData;
   import com.mcleodgaming.ssf2.util.VcamBG;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.geom.Point;
   
   public class SSF2Stage extends SSF2BaseAPIObject
   {
      
      protected var _ownerCasted:StageData;
      
      public function SSF2Stage(api:Class, owner:StageData)
      {
         super(api,owner);
         this._ownerCasted = StageData(owner);
      }
      
      public function getForeground() : MovieClip
      {
         return this._ownerCasted.StageFG;
      }
      
      public function getMidground() : MovieClip
      {
         return this._ownerCasted.StageRef;
      }
      
      public function getBackground() : MovieClip
      {
         return this._ownerCasted.StageBG;
      }
      
      public function getCameraBackgrounds() : Array
      {
         var j:int = 0;
         var mc:MovieClip = null;
         var horizontalScrollPair:Array = null;
         var verticalScrollPair:Array = null;
         var camBgs:Vector.<VcamBG> = this._ownerCasted.CamRef.BGs;
         var bgArray:Array = new Array();
         for(var i:int = 0; i < camBgs.length; i++)
         {
            mc = camBgs[i].sprite;
            horizontalScrollPair = [];
            verticalScrollPair = [];
            j = 0;
            while(Boolean(camBgs[i].horizontalScrollPair) && j < camBgs[i].horizontalScrollPair.length)
            {
               horizontalScrollPair.push(camBgs[i].horizontalScrollPair[j]);
               j++;
            }
            j = 0;
            while(Boolean(camBgs[i].verticalScrollPair) && j < camBgs[i].verticalScrollPair.length)
            {
               verticalScrollPair.push(camBgs[i].verticalScrollPair[j]);
               j++;
            }
            bgArray.push({
               "mc":mc,
               "horizontalScrollPair":horizontalScrollPair,
               "verticalScrollPair":verticalScrollPair
            });
         }
         return bgArray;
      }
      
      public function getWeatherMC() : MovieClip
      {
         return this._ownerCasted.WeatherRef;
      }
      
      public function getWeatherMaskMC() : MovieClip
      {
         return this._ownerCasted.WeatherMaskRef;
      }
      
      public function getShadowMC() : MovieClip
      {
         return this._ownerCasted.ShadowsRef;
      }
      
      public function getShadowMaskMC() : MovieClip
      {
         return this._ownerCasted.ShadowMaskRef;
      }
      
      public function getHUDBackgroundMC() : MovieClip
      {
         return this._ownerCasted.HudForegroundRef;
      }
      
      public function getHUDForegroundMC() : MovieClip
      {
         return this._ownerCasted.HudOverlayRef;
      }
      
      public function enableCeilingDeath(value:Boolean = true) : void
      {
         this._ownerCasted.DisableCeilingDeath = !value;
      }
      
      public function enableFallDeath(value:Boolean = true) : void
      {
         this._ownerCasted.DisableFallDeath = !value;
      }
      
      public function isCeilingDeathEnabled() : Boolean
      {
         return !this._ownerCasted.DisableCeilingDeath;
      }
      
      public function isFallDeathEnabled() : Boolean
      {
         return !this._ownerCasted.DisableFallDeath;
      }
      
      public function createTimer(interval:int, repeats:int, func:Function, options:Object = null) : void
      {
         this._ownerCasted.createTimer(interval,repeats,func,options);
      }
      
      public function destroyTimer(func:Function) : void
      {
         this._ownerCasted.destroyTimer(func);
      }
      
      public function toLocalPoint(displayObject:DisplayObject) : Point
      {
         return this.getMidground().globalToLocal(displayObject.localToGlobal(new Point(0,0)));
      }
      
      public function getStartingPositionMCs() : Array
      {
         var results:Array = new Array();
         for(var i:int = 0; i < this._ownerCasted.StartPositionMCs.length; i++)
         {
            results.push(this._ownerCasted.StartPositionMCs[i]);
         }
         return results;
      }
      
      public function getSpawnPositionMCs() : Array
      {
         var results:Array = new Array();
         for(var i:int = 0; i < this._ownerCasted.SpawnPositionMCs.length; i++)
         {
            results.push(this._ownerCasted.SpawnPositionMCs[i]);
         }
         return results;
      }
      
      public function getLightSourceMC() : MovieClip
      {
         return this._ownerCasted.LightSource;
      }
      
      public function getLedges() : Array
      {
         return this._ownerCasted.getLedgesAPI();
      }
      
      public function getCameraBounds() : MovieClip
      {
         return this._ownerCasted.getCamBounds();
      }
      
      public function getDeathBounds() : MovieClip
      {
         return this._ownerCasted.getDeathBounds();
      }
      
      public function getSmashBallBounds() : MovieClip
      {
         return this._ownerCasted.SmashBallBounds;
      }
      
      public function getItemSpawnBoundsList() : Array
      {
         var arr:Array = [];
         var itemGens:Vector.<MovieClip> = this._ownerCasted.getItemGens();
         for(var i:int = 0; i < itemGens.length; i++)
         {
            arr.push(itemGens[i]);
         }
         return arr;
      }
      
      public function getStarKOEnabled() : Boolean
      {
         return this._ownerCasted.StarKOEnabled;
      }
      
      public function setStarKOEnabled(value:Boolean) : void
      {
         this._ownerCasted.StarKOEnabled = value;
      }
      
      public function getScreenKOEnabled() : Boolean
      {
         return this._ownerCasted.ScreenKOEnabled;
      }
      
      public function setScreenKOEnabled(value:Boolean) : void
      {
         this._ownerCasted.ScreenKOEnabled = value;
      }
   }
}

