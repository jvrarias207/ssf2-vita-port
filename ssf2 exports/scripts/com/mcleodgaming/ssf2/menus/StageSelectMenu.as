package com.mcleodgaming.ssf2.menus
{
   import com.mcleodgaming.ssf2.Main;
   import com.mcleodgaming.ssf2.audio.*;
   import com.mcleodgaming.ssf2.controllers.*;
   import com.mcleodgaming.ssf2.engine.*;
   import com.mcleodgaming.ssf2.enums.Mode;
   import com.mcleodgaming.ssf2.net.*;
   import com.mcleodgaming.ssf2.util.*;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   
   public class StageSelectMenu extends Menu
   {
      
      private var m_currentGame:Game;
      
      private var stageButtons:Vector.<StageButton>;
      
      private var previewer:MovieClip;
      
      private var selectHand:StageSelectHand;
      
      protected var normalStageTable:DisplayObjectTable;
      
      protected var pastStageTable:DisplayObjectTable;
      
      protected var m_stageMCHash:Object;
      
      private var m_normal_btn:MovieClip;
      
      private var m_past_btn:MovieClip;
      
      private var m_unlockable_btn:MovieClip;
      
      private var m_other_btn:MovieClip;
      
      public function StageSelectMenu()
      {
         var i:int = 0;
         var j:int = 0;
         var child:MovieClip = null;
         super();
         m_subMenu = ResourceManager.getLibraryMC("menu_stageselect");
         m_backgroundID = "space";
         this.stageButtons = new Vector.<StageButton>();
         this.previewer = MovieClip(m_subMenu.stage_sample.previewer.addChild(ResourceManager.getLibraryMC("stagePreviewer")));
         this.previewer.name = "mc";
         var mappings:Object = ResourceManager.getResourceByID("mappings").getProp("metadata");
         var normalStagesObj:Object = mappings.stage_select_screen.normal;
         var pastStagesObj:Object = mappings.stage_select_screen.past;
         var allStages:Array = Utils.union(Utils.flatten(Utils.flatten(normalStagesObj.rows as Array).concat(Utils.flatten(pastStagesObj.rows as Array))));
         this.m_stageMCHash = {};
         for(i = 0; i < this.StageSelectionIconsMC.numChildren; i++)
         {
            if(this.StageSelectionIconsMC.getChildAt(i) is MovieClip)
            {
               child = MovieClip(this.StageSelectionIconsMC.getChildAt(i));
               child.parent.removeChild(child);
               i--;
            }
         }
         this.m_stageMCHash["xpstage"] = m_subMenu.sxp;
         for(i = 0; i < allStages.length; i++)
         {
            if(Boolean(mappings.stage[allStages[i]]) || Boolean(allStages[i] === "xpstage") || allStages[i] === "random")
            {
               child = MovieClip(ResourceManager.getLibraryMC(allStages[i] + "_stage_select"));
               child.gotoAndStop(1);
               child.stageID = child.stageID || allStages[i];
               this.m_stageMCHash[child.stageID] = child;
               this.StageSelectionIconsMC.addChild(child);
               this.stageButtons.push(new StageButton(GameController.currentGame,child,child.stageID));
            }
         }
         for(i = 0; i < m_subMenu.numChildren; i++)
         {
            if(m_subMenu.getChildAt(i) is MovieClip)
            {
               child = MovieClip(m_subMenu.getChildAt(i));
               if(child.name === "normal_btn" || child.name === "past_btn")
               {
                  this.m_stageMCHash[child.name] = child;
               }
            }
         }
         this.selectHand = new StageSelectHand(m_subMenu,this.stageButtons,this.backCharSelect_CLICK);
         this.selectHand.addClickEventClipCheckBounds(m_subMenu.normal_btn);
         this.selectHand.addClickEventClipCheckBounds(m_subMenu.past_btn);
         this.selectHand.addClickEventClipHitTest(m_subMenu.bg_top.back_btn);
         this.selectHand.addClickEventClipHitTest(m_subMenu.hazardsbut);
         this.normalStageTable = new DisplayObjectTable(new Rectangle(normalStagesObj.position.x,normalStagesObj.position.y,normalStagesObj.icon_size.width,normalStagesObj.icon_size.height));
         this.pastStageTable = new DisplayObjectTable(new Rectangle(mappings.stage_select_screen.past.position.x,mappings.stage_select_screen.past.position.y,mappings.stage_select_screen.past.icon_size.width,mappings.stage_select_screen.past.icon_size.height));
         for(i = 0; i < normalStagesObj.rows.length; i++)
         {
            for(j = 0; j < normalStagesObj.rows[i].length; j++)
            {
               this.normalStageTable.insertObject(i,this.m_stageMCHash[normalStagesObj.rows[i][j]]);
            }
         }
         for(i = 0; i < pastStagesObj.rows.length; i++)
         {
            for(j = 0; j < pastStagesObj.rows[i].length; j++)
            {
               this.pastStageTable.insertObject(i,this.m_stageMCHash[pastStagesObj.rows[i][j]]);
            }
         }
         this.m_normal_btn = m_subMenu.normal_btn;
         this.m_past_btn = m_subMenu.past_btn;
         this.m_unlockable_btn = m_subMenu.unlockable_btn;
         this.m_other_btn = m_subMenu.other_btn;
         this.m_normal_btn.visible = false;
         this.m_past_btn.visible = false;
         this.m_unlockable_btn.visible = false;
         this.m_other_btn.visible = false;
         this.m_normal_btn.gotoAndStop("on");
         this.m_past_btn.gotoAndStop("off");
         this.m_unlockable_btn.gotoAndStop("off");
         this.m_other_btn.gotoAndStop("off");
         m_container.addChild(m_subMenu);
         m_subMenu.x = Main.Width / 2;
         m_subMenu.y = Main.Height / 2;
         this.m_stageMCHash["xpstage"].visible = false;
         this.pastStageTable.hideAll();
         this.normalStageTable.showAll();
      }
      
      public function get StageSelectionIconsMC() : MovieClip
      {
         return m_subMenu.stageSelect;
      }
      
      override public function makeEvents() : void
      {
         if(m_showCount == 0)
         {
            findSubMenuButtons();
            findSpecificMenuButtons(m_subMenu.bg_top);
            findSpecificMenuButtons(m_subMenu);
         }
         super.makeEvents();
         m_subMenu.bg_top.back_btn.addEventListener(MouseEvent.CLICK,this.backCharSelect_CLICK);
         m_subMenu.bg_top.back_btn.addEventListener(MouseEvent.MOUSE_OVER,this.backCharSelect_OVER);
         m_subMenu.hazardsbut.addEventListener(MouseEvent.CLICK,this.hazards_CLICK);
         this.m_normal_btn.addEventListener(MouseEvent.CLICK,this.showNormalStages);
         this.m_past_btn.addEventListener(MouseEvent.CLICK,this.showPastStages);
         this.m_other_btn.addEventListener(MouseEvent.CLICK,this.showOtherStages);
         this.selectHand.makeEvents();
         for(var i:int = 0; i < this.stageButtons.length; i++)
         {
            this.stageButtons[i].makeEvents();
         }
         this.updateFields();
      }
      
      override public function killEvents() : void
      {
         super.killEvents();
         m_subMenu.bg_top.back_btn.removeEventListener(MouseEvent.CLICK,this.backCharSelect_CLICK);
         m_subMenu.bg_top.back_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.backCharSelect_OVER);
         m_subMenu.hazardsbut.removeEventListener(MouseEvent.CLICK,this.hazards_CLICK);
         this.m_normal_btn.removeEventListener(MouseEvent.CLICK,this.showNormalStages);
         this.m_past_btn.removeEventListener(MouseEvent.CLICK,this.showPastStages);
         this.m_other_btn.removeEventListener(MouseEvent.CLICK,this.showOtherStages);
         this.selectHand.killEvents();
         for(var i:int = 0; i < this.stageButtons.length; i++)
         {
            this.stageButtons[i].killEvents();
         }
      }
      
      private function updateFields() : void
      {
         if(!SaveData.Hazards)
         {
            m_subMenu.hazardsbut.gotoAndStop("off");
         }
         else
         {
            m_subMenu.hazardsbut.gotoAndStop("on");
         }
      }
      
      public function setCurrentGame(game:Game) : void
      {
         this.m_currentGame = game;
         for(var i:int = 0; i < this.stageButtons.length; i++)
         {
            this.stageButtons[i].setCurrentGame(game);
         }
      }
      
      private function showNormalStages(e:MouseEvent) : void
      {
      }
      
      private function showPastStages(e:MouseEvent) : void
      {
      }
      
      private function showUnlockableStages(e:MouseEvent) : void
      {
      }
      
      private function showOtherStages(e:MouseEvent) : void
      {
      }
      
      private function resetAll() : void
      {
         this.normalStageTable.hideAll();
         this.pastStageTable.hideAll();
         this.m_normal_btn.gotoAndStop("off");
         this.m_past_btn.gotoAndStop("off");
         this.m_unlockable_btn.gotoAndStop("off");
         this.m_other_btn.gotoAndStop("off");
      }
      
      private function updateIcons() : void
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
         else
         {
            this.m_stageMCHash["xpstage"].visible = ResourceManager.getResourceByID("xpstage",true) != null;
         }
         Utils.setBrightness(this.m_unlockable_btn,-100);
         Utils.setBrightness(this.m_other_btn,-100);
         this.m_stageMCHash["xpstage"].visible = Main.DEBUG;
         var mappings:Object = ResourceManager.getResourceByID("mappings").getProp("metadata");
         for(k in this.m_stageMCHash)
         {
            if(Boolean(mappings.stage[k]) && Boolean(this.m_currentGame.GameMode !== Mode.TRAINING) && Boolean(mappings.stage[k].training_only))
            {
               this.m_stageMCHash[k].visible = false;
            }
         }
      }
      
      override public function show() : void
      {
         this.resetAll();
         this.pastStageTable.hideAll();
         this.normalStageTable.showAll();
         this.updateIcons();
         this.normalStageTable.spaceObjects();
         this.m_normal_btn.gotoAndStop("on");
         MovieClip(m_subMenu.stage_sample.previewer.getChildByName("mc")).gotoAndStop("paused");
         m_subMenu.stage_sample.stage_txt.text = "";
         this.selectHand.resetPosition();
         GameController.isStarted = false;
         super.show();
      }
      
      private function backCharSelect_CLICK(e:MouseEvent) : void
      {
         removeSelf();
         SoundQueue.instance.playSoundEffect("menu_back");
         MenuController.CurrentCharacterSelectMenu.show();
      }
      
      private function backCharSelect_OVER(e:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
      }
      
      private function hazards_CLICK(e:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         SaveData.toggleHazards();
         if(Boolean(MenuController.CurrentCharacterSelectMenu) && Boolean(MenuController.CurrentCharacterSelectMenu.GameObj))
         {
            MenuController.CurrentCharacterSelectMenu.GameObj.LevelData.hazards = SaveData.Hazards;
         }
         this.updateFields();
      }
   }
}

