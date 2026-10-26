package com.mcleodgaming.ssf2.engine
{
   import com.mcleodgaming.ssf2.util.ResourceManager;
   import com.mcleodgaming.ssf2.util.Utils;
   import flash.desktop.Clipboard;
   import flash.desktop.ClipboardFormats;
   import flash.display.MovieClip;
   
   public class HitBoxManager
   {
      
      private static var m_hitBoxManagerList:Object = {};
      
      private var m_name:String;
      
      private var m_hitBoxAnimationList:Vector.<HitBoxAnimation>;
      
      private var m_hitBoxAnimationIndexes:Array;
      
      private var m_hasHitBoxes:Boolean;
      
      public function HitBoxManager(name:String)
      {
         super();
         this.m_name = name;
         m_hitBoxManagerList[name] = this;
         this.m_hasHitBoxes = false;
         this.m_hitBoxAnimationList = new Vector.<HitBoxAnimation>();
         this.m_hitBoxAnimationIndexes = new Array();
      }
      
      public static function getOrCreate(linkageID:String) : HitBoxManager
      {
         var hitBoxManager:HitBoxManager = null;
         var i:int = 0;
         var j:int = 0;
         var tmpMC:MovieClip = null;
         if(HitBoxManager.HitBoxManageList[linkageID] != null)
         {
            return HitBoxManager.HitBoxManageList[linkageID];
         }
         hitBoxManager = new HitBoxManager(linkageID);
         i = 0;
         j = 0;
         tmpMC = ResourceManager.getLibraryMC(linkageID);
         i = 0;
         while(Boolean(tmpMC) && i < tmpMC.totalFrames)
         {
            tmpMC.gotoAndStop(i + 1);
            if(Boolean(tmpMC))
            {
               if(Boolean(tmpMC.stance))
               {
                  Utils.removeActionScript(tmpMC.stance);
                  hitBoxManager.addHitBoxAnimation(HitBoxAnimation.createHitBoxAnimation(linkageID + "_" + tmpMC.currentLabel,tmpMC.stance,tmpMC));
               }
            }
            i++;
         }
         return hitBoxManager;
      }
      
      public static function clearCache() : void
      {
         m_hitBoxManagerList = {};
         HitBoxAnimation.AnimationsList.splice(0,HitBoxAnimation.AnimationsList.length);
      }
      
      public static function get HitBoxManageList() : Object
      {
         return m_hitBoxManagerList;
      }
      
      public static function dump() : String
      {
         var i:* = undefined;
         var manager:HitBoxManager = null;
         var j:int = 0;
         var k:int = 0;
         var hitBoxes:Vector.<HitBoxSprite> = null;
         var l:int = 0;
         var result:String = "";
         var hitBoxTypes:Vector.<Object> = HitBoxAnimation.HitBoxTypes;
         for(i in m_hitBoxManagerList)
         {
            result += "Manager " + i + ":\r\n";
            result += "--------------------------------";
            manager = m_hitBoxManagerList[i];
            for(j = 0; j < manager.HitBoxAnimationList.length; j++)
            {
               result += "Animation " + manager.HitBoxAnimationList[j].Name + ":\r\n";
               for(k = 0; k < hitBoxTypes.length; k++)
               {
                  hitBoxes = manager.HitBoxAnimationList[j].getAllHitBoxesOfType(hitBoxTypes[k].type);
                  for(l = 0; l < hitBoxes.length; l++)
                  {
                     result += "Hitbox { name:" + hitBoxTypes[k].name + " rect: " + hitBoxes[l].BoundingBox + " }\r\n";
                  }
               }
            }
         }
         Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT,result);
         return result;
      }
      
      public function get HasHitBoxes() : Boolean
      {
         return this.m_hasHitBoxes;
      }
      
      public function get HitBoxAnimationList() : Vector.<HitBoxAnimation>
      {
         return this.m_hitBoxAnimationList;
      }
      
      public function addHitBoxAnimation(hitBoxAnimation:HitBoxAnimation) : void
      {
         this.m_hitBoxAnimationList.push(hitBoxAnimation);
         this.m_hitBoxAnimationIndexes[hitBoxAnimation.Name] = this.m_hitBoxAnimationList.length - 1;
         if(Boolean(hitBoxAnimation.TotalHitboxes))
         {
            this.m_hasHitBoxes = true;
         }
      }
      
      public function getHitBoxAnimation(name:String) : HitBoxAnimation
      {
         return this.m_hitBoxAnimationIndexes[name] !== undefined ? this.m_hitBoxAnimationList[this.m_hitBoxAnimationIndexes[name]] : null;
      }
   }
}

