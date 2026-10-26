package com.mcleodgaming.ssf2.engine
{
   import com.mcleodgaming.ssf2.Main;
   import com.mcleodgaming.ssf2.controllers.MenuController;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class HitBoxAnimation
   {
      
      private static var m_animationsList:Array = new Array();
      
      public static const HIT_BOX_MAP:Object = {
         "attackBox":HitBoxSprite.ATTACK,
         "hitBox":HitBoxSprite.HIT,
         "grabBox":HitBoxSprite.GRAB,
         "touchBox":HitBoxSprite.TOUCH,
         "hand":HitBoxSprite.HAND,
         "range":HitBoxSprite.RANGE,
         "absorbBox":HitBoxSprite.ABSORB,
         "counterBox":HitBoxSprite.COUNTER,
         "shieldBox":HitBoxSprite.SHIELD,
         "shieldAttackBox":HitBoxSprite.SHIELDATTACK,
         "shieldProjectileBox":HitBoxSprite.SHIELDPROJECTILE,
         "reverseBox":HitBoxSprite.REVERSE,
         "catchBox":HitBoxSprite.CATCH,
         "ledgeBox":HitBoxSprite.LEDGE,
         "camBox":HitBoxSprite.CAM,
         "homing":HitBoxSprite.HOMING,
         "pLockBox":HitBoxSprite.PLOCK,
         "hatBox":HitBoxSprite.HAT,
         "itemBox":HitBoxSprite.ITEM,
         "eggBox":HitBoxSprite.EGG,
         "freezeBox":HitBoxSprite.FREEZE,
         "starBox":HitBoxSprite.STAR,
         "customBox":HitBoxSprite.CUSTOM
      };
      
      private var m_name:String;
      
      private var m_totalHitboxes:int;
      
      private var m_attackBoxes:Vector.<HitBoxSprite>;
      
      private var m_hitBoxes:Vector.<HitBoxSprite>;
      
      private var m_grabBoxes:Vector.<HitBoxSprite>;
      
      private var m_touchBoxes:Vector.<HitBoxSprite>;
      
      private var m_handBoxes:Vector.<HitBoxSprite>;
      
      private var m_rangeBoxes:Vector.<HitBoxSprite>;
      
      private var m_absorbBoxes:Vector.<HitBoxSprite>;
      
      private var m_counterBoxes:Vector.<HitBoxSprite>;
      
      private var m_shieldBoxes:Vector.<HitBoxSprite>;
      
      private var m_shieldAttackBoxes:Vector.<HitBoxSprite>;
      
      private var m_shieldProjectileBoxes:Vector.<HitBoxSprite>;
      
      private var m_reverseBoxes:Vector.<HitBoxSprite>;
      
      private var m_catchBoxes:Vector.<HitBoxSprite>;
      
      private var m_ledgeBoxes:Vector.<HitBoxSprite>;
      
      private var m_camBoxes:Vector.<HitBoxSprite>;
      
      private var m_homingBoxes:Vector.<HitBoxSprite>;
      
      private var m_pLockBoxes:Vector.<HitBoxSprite>;
      
      private var m_itemBoxes:Vector.<HitBoxSprite>;
      
      private var m_hatBoxes:Vector.<HitBoxSprite>;
      
      private var m_eggBoxes:Vector.<HitBoxSprite>;
      
      private var m_freezeBoxes:Vector.<HitBoxSprite>;
      
      private var m_starBoxes:Vector.<HitBoxSprite>;
      
      private var m_customBoxes:Vector.<HitBoxSprite>;
      
      private var m_masterBoxes:Vector.<HitBoxSprite>;
      
      private var m_attackFrames:Array;
      
      private var m_hitFrames:Array;
      
      private var m_grabFrames:Array;
      
      private var m_touchFrames:Array;
      
      private var m_handFrames:Array;
      
      private var m_rangeFrames:Array;
      
      private var m_absorbFrames:Array;
      
      private var m_counterFrames:Array;
      
      private var m_shieldFrames:Array;
      
      private var m_shieldAttackFrames:Array;
      
      private var m_shieldProjectileFrames:Array;
      
      private var m_reverseFrames:Array;
      
      private var m_catchFrames:Array;
      
      private var m_ledgeFrames:Array;
      
      private var m_camFrames:Array;
      
      private var m_homingFrames:Array;
      
      private var m_pLockFrames:Array;
      
      private var m_itemFrames:Array;
      
      private var m_hatFrames:Array;
      
      private var m_eggFrames:Array;
      
      private var m_freezeFrames:Array;
      
      private var m_starFrames:Array;
      
      private var m_customFrames:Array;
      
      private var m_masterFrames:Array;
      
      private var m_totalFrames:int;
      
      public function HitBoxAnimation(name:String)
      {
         super();
         this.m_name = name;
         m_animationsList[name] = this;
         this.m_totalHitboxes = 0;
         this.m_attackBoxes = new Vector.<HitBoxSprite>();
         this.m_hitBoxes = new Vector.<HitBoxSprite>();
         this.m_grabBoxes = new Vector.<HitBoxSprite>();
         this.m_touchBoxes = new Vector.<HitBoxSprite>();
         this.m_handBoxes = new Vector.<HitBoxSprite>();
         this.m_rangeBoxes = new Vector.<HitBoxSprite>();
         this.m_absorbBoxes = new Vector.<HitBoxSprite>();
         this.m_counterBoxes = new Vector.<HitBoxSprite>();
         this.m_shieldBoxes = new Vector.<HitBoxSprite>();
         this.m_shieldAttackBoxes = new Vector.<HitBoxSprite>();
         this.m_shieldProjectileBoxes = new Vector.<HitBoxSprite>();
         this.m_reverseBoxes = new Vector.<HitBoxSprite>();
         this.m_catchBoxes = new Vector.<HitBoxSprite>();
         this.m_ledgeBoxes = new Vector.<HitBoxSprite>();
         this.m_camBoxes = new Vector.<HitBoxSprite>();
         this.m_homingBoxes = new Vector.<HitBoxSprite>();
         this.m_pLockBoxes = new Vector.<HitBoxSprite>();
         this.m_itemBoxes = new Vector.<HitBoxSprite>();
         this.m_hatBoxes = new Vector.<HitBoxSprite>();
         this.m_eggBoxes = new Vector.<HitBoxSprite>();
         this.m_freezeBoxes = new Vector.<HitBoxSprite>();
         this.m_starBoxes = new Vector.<HitBoxSprite>();
         this.m_customBoxes = new Vector.<HitBoxSprite>();
         this.m_masterBoxes = new Vector.<HitBoxSprite>();
         this.m_attackFrames = new Array();
         this.m_hitFrames = new Array();
         this.m_grabFrames = new Array();
         this.m_touchFrames = new Array();
         this.m_handFrames = new Array();
         this.m_rangeFrames = new Array();
         this.m_absorbFrames = new Array();
         this.m_counterFrames = new Array();
         this.m_shieldFrames = new Array();
         this.m_shieldAttackFrames = new Array();
         this.m_shieldProjectileFrames = new Array();
         this.m_reverseFrames = new Array();
         this.m_catchFrames = new Array();
         this.m_ledgeFrames = new Array();
         this.m_camFrames = new Array();
         this.m_homingFrames = new Array();
         this.m_pLockFrames = new Array();
         this.m_itemFrames = new Array();
         this.m_hatFrames = new Array();
         this.m_eggFrames = new Array();
         this.m_freezeFrames = new Array();
         this.m_starFrames = new Array();
         this.m_customFrames = new Array();
         this.m_masterFrames = new Array();
      }
      
      public static function get AnimationsList() : Array
      {
         return m_animationsList;
      }
      
      public static function get HitBoxTypes() : Vector.<Object>
      {
         var types:Vector.<Object> = new Vector.<Object>();
         types.push({
            "type":HitBoxSprite.ATTACK,
            "name":"attackBox"
         });
         types.push({
            "type":HitBoxSprite.HIT,
            "name":"hitBox"
         });
         types.push({
            "type":HitBoxSprite.GRAB,
            "name":"grabBox"
         });
         types.push({
            "type":HitBoxSprite.TOUCH,
            "name":"touchBox"
         });
         types.push({
            "type":HitBoxSprite.HAND,
            "name":"hand"
         });
         types.push({
            "type":HitBoxSprite.RANGE,
            "name":"range"
         });
         types.push({
            "type":HitBoxSprite.ABSORB,
            "name":"absorbBox"
         });
         types.push({
            "type":HitBoxSprite.COUNTER,
            "name":"counterBox"
         });
         types.push({
            "type":HitBoxSprite.SHIELD,
            "name":"shieldBox"
         });
         types.push({
            "type":HitBoxSprite.SHIELDATTACK,
            "name":"shieldAttackBox"
         });
         types.push({
            "type":HitBoxSprite.SHIELDPROJECTILE,
            "name":"shieldProjectileBox"
         });
         types.push({
            "type":HitBoxSprite.REVERSE,
            "name":"reverseBox"
         });
         types.push({
            "type":HitBoxSprite.CATCH,
            "name":"catchBox"
         });
         types.push({
            "type":HitBoxSprite.LEDGE,
            "name":"ledgeBox"
         });
         types.push({
            "type":HitBoxSprite.CAM,
            "name":"camBox"
         });
         types.push({
            "type":HitBoxSprite.HOMING,
            "name":"homing"
         });
         types.push({
            "type":HitBoxSprite.PLOCK,
            "name":"pLockBox"
         });
         types.push({
            "type":HitBoxSprite.HAT,
            "name":"hatBox"
         });
         types.push({
            "type":HitBoxSprite.ITEM,
            "name":"itemBox"
         });
         types.push({
            "type":HitBoxSprite.EGG,
            "name":"eggBox"
         });
         types.push({
            "type":HitBoxSprite.FREEZE,
            "name":"freezeBox"
         });
         types.push({
            "type":HitBoxSprite.STAR,
            "name":"starBox"
         });
         types.push({
            "type":HitBoxSprite.CUSTOM,
            "name":"customBox"
         });
         return types;
      }
      
      public static function createHitBoxAnimation(mc_name:String, mc:MovieClip, coordinateSpace:DisplayObject, customData:Object = null) : HitBoxAnimation
      {
         var str:* = undefined;
         var custDataObj:Object = null;
         var regPoint:Rectangle = null;
         var hbox:HitBoxSprite = null;
         if(Boolean(m_animationsList[mc_name]))
         {
            return m_animationsList[mc_name];
         }
         var hitBoxAnim:HitBoxAnimation = new HitBoxAnimation(mc_name);
         var i:int = 0;
         var j:int = 0;
         var k:int = 0;
         var name:String = null;
         var type:String = null;
         var matches:Array = null;
         var child:MovieClip = null;
         var tmpMC:MovieClip = new MovieClip();
         tmpMC.graphics.beginFill(16711680,0);
         tmpMC.graphics.drawCircle(0,0,1);
         tmpMC.graphics.endFill();
         var customDataArr:Vector.<String> = new Vector.<String>();
         var minMaxes:Rectangle = null;
         for(str in customData)
         {
            customDataArr.push(str);
         }
         for(i = 0; i < mc.totalFrames; i++)
         {
            minMaxes = null;
            mc.gotoAndStop(i + 1);
            for(j = 0; j < mc.numChildren; j++)
            {
               child = mc.getChildAt(j) as MovieClip;
               if(Boolean(child) && Boolean(child.name) && Boolean(child.name.match(/^[a-zA-Z]+(?:\d+)?$/i)))
               {
                  name = child.name;
                  matches = name.match(/^[a-zA-Z]+/i);
                  type = Boolean(matches) ? matches[0] : "";
                  if(Boolean(type) && HIT_BOX_MAP[type] !== undefined)
                  {
                     matches = name.match(/(?:\d+)$/i);
                     k = Boolean(matches) ? int(parseInt(matches[0])) : 1;
                     if(k > 0)
                     {
                        if(Main.DEBUG)
                        {
                           if(!mc.getChildByName(type))
                           {
                              MenuController.debugConsole.alert("Warning! A hit box was found in " + mc_name + " named " + name + " without a preceeding " + type);
                           }
                        }
                        custDataObj = customDataArr.indexOf(name) >= 0 ? customData[name] : null;
                        mc.addChild(tmpMC);
                        tmpMC.x = child.x;
                        tmpMC.y = child.y;
                        regPoint = tmpMC.getRect(coordinateSpace);
                        hbox = new HitBoxSprite(HIT_BOX_MAP[type],child.getBounds(coordinateSpace),child.circular == true,custDataObj,new Point(regPoint.x,regPoint.y),new Point(child.scaleX,child.scaleY),child.rotation,child.transform.matrix.clone(),mc.getChildIndex(child),k);
                        mc.removeChild(tmpMC);
                        if(hitBoxAnim.addHitBox(i + 1,hbox))
                        {
                           hbox.Name = name;
                        }
                        if(!minMaxes)
                        {
                           minMaxes = hbox.BoundingBox.clone();
                           minMaxes.width = minMaxes.x + minMaxes.width;
                           minMaxes.height = minMaxes.y + minMaxes.height;
                        }
                        else
                        {
                           minMaxes.x = Math.min(minMaxes.x,hbox.x);
                           minMaxes.y = Math.min(minMaxes.y,hbox.y);
                           minMaxes.width = Math.max(minMaxes.width,hbox.x + hbox.width);
                           minMaxes.height = Math.max(minMaxes.height,hbox.y + hbox.height);
                        }
                     }
                  }
               }
            }
            if(Boolean(minMaxes))
            {
               hitBoxAnim.addHitBox(i + 1,new HitBoxSprite(HitBoxSprite.MASTER,new Rectangle(minMaxes.x,minMaxes.y,minMaxes.width - minMaxes.x,minMaxes.height - minMaxes.y)));
            }
         }
         if(Boolean(tmpMC.parent))
         {
            tmpMC.parent.removeChild(tmpMC);
         }
         tmpMC.graphics.clear();
         tmpMC = null;
         return hitBoxAnim;
      }
      
      public function get Name() : String
      {
         return this.m_name;
      }
      
      public function get TotalHitboxes() : int
      {
         return this.m_totalHitboxes;
      }
      
      public function get AttackBoxes() : Vector.<HitBoxSprite>
      {
         return this.m_attackBoxes;
      }
      
      public function addHitBox(frame:int, hitBox:HitBoxSprite) : Boolean
      {
         var success:Boolean = true;
         var i:int = 0;
         var index:int = -1;
         var targetBoxList:Vector.<HitBoxSprite> = null;
         var targetFramesList:Array = null;
         if(hitBox.Type == HitBoxSprite.ATTACK)
         {
            targetBoxList = this.m_attackBoxes;
            targetFramesList = this.m_attackFrames;
         }
         else if(hitBox.Type == HitBoxSprite.HIT)
         {
            targetBoxList = this.m_hitBoxes;
            targetFramesList = this.m_hitFrames;
         }
         else if(hitBox.Type == HitBoxSprite.GRAB)
         {
            targetBoxList = this.m_grabBoxes;
            targetFramesList = this.m_grabFrames;
         }
         else if(hitBox.Type == HitBoxSprite.TOUCH)
         {
            targetBoxList = this.m_touchBoxes;
            targetFramesList = this.m_touchFrames;
         }
         else if(hitBox.Type == HitBoxSprite.HAND)
         {
            targetBoxList = this.m_handBoxes;
            targetFramesList = this.m_handFrames;
         }
         else if(hitBox.Type == HitBoxSprite.RANGE)
         {
            targetBoxList = this.m_rangeBoxes;
            targetFramesList = this.m_rangeFrames;
         }
         else if(hitBox.Type == HitBoxSprite.ABSORB)
         {
            targetBoxList = this.m_absorbBoxes;
            targetFramesList = this.m_absorbFrames;
         }
         else if(hitBox.Type == HitBoxSprite.COUNTER)
         {
            targetBoxList = this.m_counterBoxes;
            targetFramesList = this.m_counterFrames;
         }
         else if(hitBox.Type == HitBoxSprite.SHIELD)
         {
            targetBoxList = this.m_shieldBoxes;
            targetFramesList = this.m_shieldFrames;
         }
         else if(hitBox.Type == HitBoxSprite.SHIELDATTACK)
         {
            targetBoxList = this.m_shieldAttackBoxes;
            targetFramesList = this.m_shieldAttackFrames;
         }
         else if(hitBox.Type == HitBoxSprite.SHIELDPROJECTILE)
         {
            targetBoxList = this.m_shieldProjectileBoxes;
            targetFramesList = this.m_shieldProjectileFrames;
         }
         else if(hitBox.Type == HitBoxSprite.REVERSE)
         {
            targetBoxList = this.m_reverseBoxes;
            targetFramesList = this.m_reverseFrames;
         }
         else if(hitBox.Type == HitBoxSprite.CATCH)
         {
            targetBoxList = this.m_catchBoxes;
            targetFramesList = this.m_catchFrames;
         }
         else if(hitBox.Type == HitBoxSprite.LEDGE)
         {
            targetBoxList = this.m_ledgeBoxes;
            targetFramesList = this.m_ledgeFrames;
         }
         else if(hitBox.Type == HitBoxSprite.CAM)
         {
            targetBoxList = this.m_camBoxes;
            targetFramesList = this.m_camFrames;
         }
         else if(hitBox.Type == HitBoxSprite.HOMING)
         {
            targetBoxList = this.m_homingBoxes;
            targetFramesList = this.m_homingFrames;
         }
         else if(hitBox.Type == HitBoxSprite.PLOCK)
         {
            targetBoxList = this.m_pLockBoxes;
            targetFramesList = this.m_pLockFrames;
         }
         else if(hitBox.Type == HitBoxSprite.ITEM)
         {
            targetBoxList = this.m_itemBoxes;
            targetFramesList = this.m_itemFrames;
         }
         else if(hitBox.Type == HitBoxSprite.HAT)
         {
            targetBoxList = this.m_hatBoxes;
            targetFramesList = this.m_hatFrames;
         }
         else if(hitBox.Type == HitBoxSprite.EGG)
         {
            targetBoxList = this.m_eggBoxes;
            targetFramesList = this.m_eggFrames;
         }
         else if(hitBox.Type == HitBoxSprite.FREEZE)
         {
            targetBoxList = this.m_freezeBoxes;
            targetFramesList = this.m_freezeFrames;
         }
         else if(hitBox.Type == HitBoxSprite.STAR)
         {
            targetBoxList = this.m_starBoxes;
            targetFramesList = this.m_starFrames;
         }
         else if(hitBox.Type == HitBoxSprite.CUSTOM)
         {
            targetBoxList = this.m_customBoxes;
            targetFramesList = this.m_customFrames;
         }
         else if(hitBox.Type == HitBoxSprite.MASTER)
         {
            targetBoxList = this.m_masterBoxes;
            targetFramesList = this.m_masterFrames;
         }
         for(i = 0; i < targetBoxList.length; i++)
         {
            if(targetBoxList[i].equals(hitBox))
            {
               index = i;
               success = false;
               break;
            }
         }
         if(index < 0)
         {
            targetBoxList.push(hitBox);
            index = targetBoxList.length - 1;
         }
         if(!targetFramesList[frame])
         {
            targetFramesList[frame] = new Array();
         }
         if(hitBox.Order < 0 || targetFramesList[frame].length <= 0)
         {
            targetFramesList[frame].push(targetBoxList[index]);
         }
         else
         {
            for(i = 0; i < targetFramesList[frame].length; i++)
            {
               if(targetFramesList[frame][i].Order > targetBoxList[index].Order)
               {
                  targetFramesList[frame].splice(i,0,targetBoxList[index]);
                  i = -1;
                  break;
               }
            }
            if(i >= 0)
            {
               targetFramesList[frame].push(targetBoxList[index]);
            }
         }
         if(success)
         {
            ++this.m_totalHitboxes;
         }
         return success;
      }
      
      public function getHitBoxes(frame:int, type:uint) : Array
      {
         if(type == HitBoxSprite.ATTACK)
         {
            if(!this.m_attackFrames[frame])
            {
               return null;
            }
            return this.m_attackFrames[frame];
         }
         if(type == HitBoxSprite.HIT)
         {
            if(!this.m_hitFrames[frame])
            {
               return null;
            }
            return this.m_hitFrames[frame];
         }
         if(type == HitBoxSprite.GRAB)
         {
            if(!this.m_grabFrames[frame])
            {
               return null;
            }
            return this.m_grabFrames[frame];
         }
         if(type == HitBoxSprite.TOUCH)
         {
            if(!this.m_touchFrames[frame])
            {
               return null;
            }
            return this.m_touchFrames[frame];
         }
         if(type == HitBoxSprite.HAND)
         {
            if(!this.m_handFrames[frame])
            {
               return null;
            }
            return this.m_handFrames[frame];
         }
         if(type == HitBoxSprite.RANGE)
         {
            if(!this.m_rangeFrames[frame])
            {
               return null;
            }
            return this.m_rangeFrames[frame];
         }
         if(type == HitBoxSprite.ABSORB)
         {
            if(!this.m_absorbFrames[frame])
            {
               return null;
            }
            return this.m_absorbFrames[frame];
         }
         if(type == HitBoxSprite.COUNTER)
         {
            if(!this.m_counterFrames[frame])
            {
               return null;
            }
            return this.m_counterFrames[frame];
         }
         if(type == HitBoxSprite.SHIELD)
         {
            if(!this.m_shieldFrames[frame])
            {
               return null;
            }
            return this.m_shieldFrames[frame];
         }
         if(type == HitBoxSprite.SHIELDATTACK)
         {
            if(!this.m_shieldAttackFrames[frame])
            {
               return null;
            }
            return this.m_shieldAttackFrames[frame];
         }
         if(type == HitBoxSprite.SHIELDPROJECTILE)
         {
            if(!this.m_shieldProjectileFrames[frame])
            {
               return null;
            }
            return this.m_shieldProjectileFrames[frame];
         }
         if(type == HitBoxSprite.REVERSE)
         {
            if(!this.m_reverseFrames[frame])
            {
               return null;
            }
            return this.m_reverseFrames[frame];
         }
         if(type == HitBoxSprite.CATCH)
         {
            if(!this.m_catchFrames[frame])
            {
               return null;
            }
            return this.m_catchFrames[frame];
         }
         if(type == HitBoxSprite.LEDGE)
         {
            if(!this.m_ledgeFrames[frame])
            {
               return null;
            }
            return this.m_ledgeFrames[frame];
         }
         if(type == HitBoxSprite.CAM)
         {
            if(!this.m_camFrames[frame])
            {
               return null;
            }
            return this.m_camFrames[frame];
         }
         if(type == HitBoxSprite.HOMING)
         {
            if(!this.m_homingFrames[frame])
            {
               return null;
            }
            return this.m_homingFrames[frame];
         }
         if(type == HitBoxSprite.PLOCK)
         {
            if(!this.m_pLockFrames[frame])
            {
               return null;
            }
            return this.m_pLockFrames[frame];
         }
         if(type == HitBoxSprite.ITEM)
         {
            if(!this.m_itemFrames[frame])
            {
               return null;
            }
            return this.m_itemFrames[frame];
         }
         if(type == HitBoxSprite.HAT)
         {
            if(!this.m_hatFrames[frame])
            {
               return null;
            }
            return this.m_hatFrames[frame];
         }
         if(type == HitBoxSprite.EGG)
         {
            if(!this.m_eggFrames[frame])
            {
               return null;
            }
            return this.m_eggFrames[frame];
         }
         if(type == HitBoxSprite.FREEZE)
         {
            if(!this.m_freezeFrames[frame])
            {
               return null;
            }
            return this.m_freezeFrames[frame];
         }
         if(type == HitBoxSprite.STAR)
         {
            if(!this.m_starFrames[frame])
            {
               return null;
            }
            return this.m_starFrames[frame];
         }
         if(type == HitBoxSprite.CUSTOM)
         {
            if(!this.m_customFrames[frame])
            {
               return null;
            }
            return this.m_customFrames[frame];
         }
         if(type == HitBoxSprite.MASTER)
         {
            if(!this.m_masterFrames[frame])
            {
               return null;
            }
            return this.m_masterFrames[frame];
         }
         return null;
      }
      
      public function getAllHitBoxesOfType(type:uint) : Vector.<HitBoxSprite>
      {
         if(type == HitBoxSprite.ATTACK)
         {
            return this.m_attackBoxes;
         }
         if(type == HitBoxSprite.HIT)
         {
            return this.m_hitBoxes;
         }
         if(type == HitBoxSprite.GRAB)
         {
            return this.m_grabBoxes;
         }
         if(type == HitBoxSprite.TOUCH)
         {
            return this.m_touchBoxes;
         }
         if(type == HitBoxSprite.HAND)
         {
            return this.m_handBoxes;
         }
         if(type == HitBoxSprite.RANGE)
         {
            return this.m_rangeBoxes;
         }
         if(type == HitBoxSprite.ABSORB)
         {
            return this.m_absorbBoxes;
         }
         if(type == HitBoxSprite.COUNTER)
         {
            return this.m_counterBoxes;
         }
         if(type == HitBoxSprite.SHIELD)
         {
            return this.m_shieldBoxes;
         }
         if(type == HitBoxSprite.SHIELDATTACK)
         {
            return this.m_shieldAttackBoxes;
         }
         if(type == HitBoxSprite.SHIELDPROJECTILE)
         {
            return this.m_shieldProjectileBoxes;
         }
         if(type == HitBoxSprite.REVERSE)
         {
            return this.m_reverseBoxes;
         }
         if(type == HitBoxSprite.CATCH)
         {
            return this.m_catchBoxes;
         }
         if(type == HitBoxSprite.LEDGE)
         {
            return this.m_ledgeBoxes;
         }
         if(type == HitBoxSprite.CAM)
         {
            return this.m_camBoxes;
         }
         if(type == HitBoxSprite.HOMING)
         {
            return this.m_homingBoxes;
         }
         if(type == HitBoxSprite.PLOCK)
         {
            return this.m_pLockBoxes;
         }
         if(type == HitBoxSprite.ITEM)
         {
            return this.m_itemBoxes;
         }
         if(type == HitBoxSprite.HAT)
         {
            return this.m_hatBoxes;
         }
         if(type == HitBoxSprite.EGG)
         {
            return this.m_eggBoxes;
         }
         if(type == HitBoxSprite.FREEZE)
         {
            return this.m_freezeBoxes;
         }
         if(type == HitBoxSprite.STAR)
         {
            return this.m_starBoxes;
         }
         if(type == HitBoxSprite.CUSTOM)
         {
            return this.m_customBoxes;
         }
         if(type == HitBoxSprite.MASTER)
         {
            return this.m_masterBoxes;
         }
         return new Vector.<HitBoxSprite>();
      }
   }
}

