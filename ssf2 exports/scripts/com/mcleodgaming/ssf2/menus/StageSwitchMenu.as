package com.mcleodgaming.ssf2.menus
{
   import com.mcleodgaming.ssf2.Main;
   import com.mcleodgaming.ssf2.audio.*;
   import com.mcleodgaming.ssf2.controllers.*;
   import com.mcleodgaming.ssf2.engine.*;
   import com.mcleodgaming.ssf2.util.*;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   
   public class StageSwitchMenu extends Menu
   {
      
      private var selectHand:StageSwitchHand;
      
      private var stageButtonsMaster:Vector.<StageSwitchButton>;
      
      private var stageButtonsNormal:Vector.<StageSwitchButton>;
      
      private var stageButtonsPast:Vector.<StageSwitchButton>;
      
      private var lastClickedNormal:StageSwitchButton;
      
      private var lastClickedPast:StageSwitchButton;
      
      protected var normalTable:DisplayObjectTable;
      
      protected var pastTable:DisplayObjectTable;
      
      protected var m_stageMCHash:Object;
      
      public function StageSwitchMenu()
      {
         var i:int = 0;
         var j:int = 0;
         var child:MovieClip = null;
         super();
         m_subMenu = ResourceManager.getLibraryMC("menu_stageswitch");
         m_backgroundID = "space";
         this.stageButtonsMaster = new Vector.<StageSwitchButton>();
         this.stageButtonsNormal = new Vector.<StageSwitchButton>();
         this.stageButtonsPast = new Vector.<StageSwitchButton>();
         this.lastClickedNormal = null;
         this.lastClickedPast = null;
         var mappings:Object = ResourceManager.getResourceByID("mappings").getProp("metadata");
         var normalStagesObj:Object = mappings.stage_switch_screen.normal;
         var pastStagesObj:Object = mappings.stage_switch_screen.past;
         var randomStagesObj:Array = mappings.random_stages.stages;
         var stageTypes:Array = ["normal","past"];
         this.m_stageMCHash = {};
         for(i = 0; i < this.StageSwitchIconsMC.numChildren; i++)
         {
            if(this.StageSwitchIconsMC.getChildAt(i) is MovieClip)
            {
               child = MovieClip(this.StageSwitchIconsMC.getChildAt(i));
               child.parent.removeChild(child);
               i--;
            }
         }
         for(i = 0; i < randomStagesObj.length; i++)
         {
            if(Boolean(mappings.stage[randomStagesObj[i]]))
            {
               child = MovieClip(ResourceManager.getLibraryMC(randomStagesObj[i] + "_switch"));
               child.gotoAndStop(1);
               child.stageID = child.stageID || randomStagesObj[i];
               if(stageTypes.indexOf(child.stageType) >= 0)
               {
                  this.m_stageMCHash[child.stageID] = child;
                  this.StageSwitchIconsMC.addChild(child);
                  this.stageButtonsMaster.push(new StageSwitchButton(this.m_stageMCHash[child.stageID],child.stageID));
                  if(child.stageType === "normal")
                  {
                     this.stageButtonsNormal.push(new StageSwitchButton(this.m_stageMCHash[child.stageID],child.stageID));
                  }
                  else if(child.stageType === "past")
                  {
                     this.stageButtonsPast.push(new StageSwitchButton(this.m_stageMCHash[child.stageID],child.stageID));
                  }
               }
            }
         }
         this.normalTable = new DisplayObjectTable(new Rectangle(normalStagesObj.position.x,normalStagesObj.position.y,normalStagesObj.icon_size.width,normalStagesObj.icon_size.height));
         this.pastTable = new DisplayObjectTable(new Rectangle(pastStagesObj.position.x,pastStagesObj.position.y,pastStagesObj.icon_size.width,pastStagesObj.icon_size.height));
         for(i = 0; i < normalStagesObj.rows.length; i++)
         {
            for(j = 0; j < normalStagesObj.rows[i].length; j++)
            {
               this.normalTable.insertObject(i,this.m_stageMCHash[normalStagesObj.rows[i][j]]);
            }
         }
         for(i = 0; i < pastStagesObj.rows.length; i++)
         {
            for(j = 0; j < pastStagesObj.rows[i].length; j++)
            {
               this.pastTable.insertObject(i,this.m_stageMCHash[pastStagesObj.rows[i][j]]);
            }
         }
         this.updateStages();
         this.checkAllBtn();
         this.selectHand = new StageSwitchHand(m_subMenu,this.stageButtonsMaster,this.back_CLICK);
         this.selectHand.addClickEventClipCheckBounds(m_subMenu.allNormal_btn);
         this.selectHand.addClickEventClipCheckBounds(m_subMenu.allPast_btn);
         this.selectHand.addClickEventClipHitTest(m_subMenu.bg_top.back_btn);
         this.selectHand.addClickEventClipHitTest(m_subMenu.bg_top.home_btn);
         m_container.addChild(m_subMenu);
         m_subMenu.x = Main.Width / 2;
         m_subMenu.y = Main.Height / 2;
      }
      
      public function get StageSwitchIconsMC() : MovieClip
      {
         return m_subMenu.stageButtons;
      }
      
      override public function makeEvents() : void
      {
         if(m_showCount == 0)
         {
            findSubMenuButtons();
            findSpecificMenuButtons(m_subMenu.bg_top);
         }
         super.makeEvents();
         this.selectHand.makeEvents();
         m_subMenu.bg_top.back_btn.addEventListener(MouseEvent.CLICK,this.back_CLICK);
         m_subMenu.bg_top.back_btn.addEventListener(MouseEvent.CLICK,this.back_ROLL_OVER);
         m_subMenu.allNormal_btn.addEventListener(MouseEvent.CLICK,this.allNormal_CLICK);
         m_subMenu.allNormal_btn.addEventListener(MouseEvent.MOUSE_OVER,this.allNormal_MOUSE_OVER);
         m_subMenu.allPast_btn.addEventListener(MouseEvent.CLICK,this.allPast_CLICK);
         m_subMenu.allPast_btn.addEventListener(MouseEvent.MOUSE_OVER,this.allPast_MOUSE_OVER);
         m_subMenu.bg_top.home_btn.addEventListener(MouseEvent.CLICK,this.home_CLICK);
         var i:int = 0;
         for(i = 0; i < this.stageButtonsNormal.length; i++)
         {
            this.stageButtonsNormal[i].setClickFunc(this.checkAllBtn);
            this.stageButtonsNormal[i].makeEvents();
            if(this.lastClickedNormal == null && this.stageButtonsNormal[i].getStatus() && this.stageButtonsNormal[i].ButtonInstance.visible)
            {
               this.lastClickedNormal = this.stageButtonsNormal[i];
            }
         }
         for(i = 0; i < this.stageButtonsPast.length; i++)
         {
            this.stageButtonsPast[i].makeEvents();
            this.stageButtonsPast[i].setClickFunc(this.checkAllBtn);
            if(this.lastClickedPast == null && this.stageButtonsPast[i].getStatus() && this.stageButtonsPast[i].ButtonInstance.visible)
            {
               this.lastClickedPast = this.stageButtonsPast[i];
            }
         }
      }
      
      override public function killEvents() : void
      {
         var i:int = 0;
         super.killEvents();
         this.selectHand.killEvents();
         m_subMenu.bg_top.back_btn.removeEventListener(MouseEvent.CLICK,this.back_CLICK);
         m_subMenu.bg_top.back_btn.removeEventListener(MouseEvent.CLICK,this.back_ROLL_OVER);
         m_subMenu.allNormal_btn.removeEventListener(MouseEvent.CLICK,this.allNormal_CLICK);
         m_subMenu.allNormal_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.allNormal_MOUSE_OVER);
         m_subMenu.allPast_btn.removeEventListener(MouseEvent.CLICK,this.allPast_CLICK);
         m_subMenu.allPast_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.allPast_MOUSE_OVER);
         m_subMenu.bg_top.home_btn.removeEventListener(MouseEvent.CLICK,this.home_CLICK);
         for(i = 0; i < this.stageButtonsNormal.length; i++)
         {
            this.stageButtonsNormal[i].killEvents();
         }
         for(i = 0; i < this.stageButtonsPast.length; i++)
         {
            this.stageButtonsPast[i].killEvents();
         }
      }
      
      override public function show() : void
      {
         var k:* = undefined;
         if(!Main.DEBUG)
         {
            for(k in this.m_stageMCHash)
            {
               if(SaveData.Unlocks[k] === false)
               {
                  this.m_stageMCHash[k].visible = false;
               }
            }
         }
         this.pastTable.spaceObjects();
         this.normalTable.spaceObjects();
         this.checkAllBtn();
         super.show();
      }
      
      private function back_CLICK(e:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_back");
         removeSelf();
      }
      
      private function back_ROLL_OVER(e:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
      }
      
      private function updateStages() : void
      {
         var i:int = 0;
         for(i = 0; i < this.stageButtonsNormal.length; i++)
         {
            this.stageButtonsNormal[i].ButtonInstance.gotoAndStop(SaveData.getStageStatus(this.stageButtonsNormal[i].ID) ? "on" : "off");
         }
         for(i = 0; i < this.stageButtonsPast.length; i++)
         {
            this.stageButtonsPast[i].ButtonInstance.gotoAndStop(SaveData.getStageStatus(this.stageButtonsPast[i].ID) ? "on" : "off");
         }
      }
      
      private function allNormal_CLICK(e:MouseEvent) : void
      {
         var i:int = 0;
         var totalOn:int = 0;
         SoundQueue.instance.playSoundEffect("menu_select");
         var wasOn:Boolean = m_subMenu.allNormal_btn.currentFrameLabel == "on";
         m_subMenu.allNormal_btn.gotoAndStop(wasOn ? "off" : "on");
         for(i = 0; i < this.stageButtonsNormal.length; i++)
         {
            if(this.stageButtonsNormal[i].ButtonInstance.visible)
            {
               this.stageButtonsNormal[i].setStatus(wasOn);
            }
         }
         for(i = 0; i < this.stageButtonsPast.length; i++)
         {
            if(this.stageButtonsPast[i].ButtonInstance.visible && this.stageButtonsPast[i].getStatus())
            {
               totalOn++;
            }
         }
         if(totalOn == 0)
         {
            if(!this.lastClickedNormal)
            {
               this.lastClickedNormal = this.stageButtonsNormal[0];
               this.lastClickedNormal.setStatus(true);
            }
            else
            {
               this.lastClickedNormal.setStatus(true);
            }
         }
      }
      
      private function allNormal_MOUSE_OVER(e:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
      }
      
      private function allPast_CLICK(e:MouseEvent) : void
      {
         var i:int = 0;
         var totalOn:int = 0;
         SoundQueue.instance.playSoundEffect("menu_select");
         var wasOn:Boolean = m_subMenu.allPast_btn.currentFrameLabel == "on";
         m_subMenu.allPast_btn.gotoAndStop(wasOn ? "off" : "on");
         for(i = 0; i < this.stageButtonsPast.length; i++)
         {
            if(this.stageButtonsPast[i].ButtonInstance.visible)
            {
               this.stageButtonsPast[i].setStatus(wasOn);
            }
         }
         for(i = 0; i < this.stageButtonsNormal.length; i++)
         {
            if(this.stageButtonsNormal[i].ButtonInstance.visible && this.stageButtonsNormal[i].getStatus())
            {
               totalOn++;
            }
         }
         if(totalOn == 0)
         {
            if(!this.lastClickedPast)
            {
               this.lastClickedPast = this.stageButtonsPast[1];
               this.lastClickedPast.setStatus(true);
            }
            else
            {
               this.lastClickedPast.setStatus(true);
            }
         }
      }
      
      private function allPast_MOUSE_OVER(e:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
      }
      
      private function checkAllBtn(e:StageSwitchButton = null) : void
      {
         var i:int = 0;
         var total1:int = 0;
         var total2:int = 0;
         var sub1:int = 0;
         var sub2:int = 0;
         var bType:int = 0;
         if(this.stageButtonsNormal.indexOf(e) >= 0)
         {
            bType = 0;
            this.lastClickedNormal = e;
         }
         else if(this.stageButtonsPast.indexOf(e) >= 0)
         {
            bType = 1;
            this.lastClickedPast = e;
         }
         for(i = 0; i < this.stageButtonsNormal.length; i++)
         {
            if(this.stageButtonsNormal[i].ButtonInstance.visible && this.stageButtonsNormal[i].getStatus())
            {
               total1++;
            }
            else if(!this.stageButtonsNormal[i].ButtonInstance.visible)
            {
               sub1++;
            }
         }
         for(i = 0; i < this.stageButtonsPast.length; i++)
         {
            if(this.stageButtonsPast[i].ButtonInstance.visible && this.stageButtonsPast[i].getStatus())
            {
               total2++;
            }
            else if(!this.stageButtonsPast[i].ButtonInstance.visible)
            {
               sub2++;
            }
         }
         if(bType == 0)
         {
            m_subMenu.allNormal_btn.gotoAndStop(total1 == this.stageButtonsNormal.length - sub1 ? "off" : "on");
            if(total1 == 0 && total2 == 0 && Boolean(this.lastClickedNormal))
            {
               this.lastClickedNormal.setStatus(true);
            }
         }
         if(bType == 1)
         {
            m_subMenu.allPast_btn.gotoAndStop(total2 == this.stageButtonsPast.length - sub2 ? "off" : "on");
            if(total1 == 0 && total2 == 0 && Boolean(this.lastClickedPast))
            {
               this.lastClickedPast.setStatus(true);
            }
         }
      }
      
      private function home_CLICK(e:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_back");
         SoundQueue.instance.stopMusic();
         if(Boolean(MenuController.CurrentCharacterSelectMenu))
         {
            MenuController.CurrentCharacterSelectMenu.resetScreen();
         }
         GameController.currentGame = null;
         MenuController.removeAllMenus();
         MenuController.titleMenu.show();
      }
   }
}

