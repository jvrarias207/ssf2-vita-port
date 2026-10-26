package com.mcleodgaming.ssf2.menus
{
   import com.mcleodgaming.ssf2.Main;
   import com.mcleodgaming.ssf2.audio.*;
   import com.mcleodgaming.ssf2.controllers.*;
   import com.mcleodgaming.ssf2.engine.*;
   import com.mcleodgaming.ssf2.enums.Mode;
   import com.mcleodgaming.ssf2.enums.ModeFeatures;
   import com.mcleodgaming.ssf2.net.MultiplayerManager;
   import com.mcleodgaming.ssf2.util.*;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   
   public class HudMenu extends Menu
   {
      
      private var m_hudDectionMCs:Vector.<MovieClip>;
      
      private var m_currentItem:int;
      
      private var m_currentSpeed:String;
      
      private var m_cpuNum:int;
      
      private var m_cpuAction:int;
      
      private var m_cpuDamage:Number;
      
      private var m_cpuDamageTimer:FrameTimer;
      
      private var m_cpuDamageMouseDown:Boolean;
      
      private var m_cpuDamageInc:Boolean;
      
      private var m_cpuDamageDiff:Number;
      
      private var m_healthBoxes:Vector.<MovieClip>;
      
      private var m_damageCounterContainer:MovieClip;
      
      private var m_hudMode:int;
      
      private var m_speedNode:MenuMapperNode;
      
      private var m_itemNode:MenuMapperNode;
      
      private var m_cpuCountNode:MenuMapperNode;
      
      private var m_cpuActionNode:MenuMapperNode;
      
      private var m_cpuDamageNode:MenuMapperNode;
      
      private var m_showHitboxesNode:MenuMapperNode;
      
      private var m_cameraNode:MenuMapperNode;
      
      private var m_hudNode:MenuMapperNode;
      
      private var m_resetNode:MenuMapperNode;
      
      private var m_finishNode:MenuMapperNode;
      
      public function HudMenu()
      {
         super();
         m_subMenu = ResourceManager.getLibraryMC("menu_hud");
         m_container.addChild(m_subMenu);
         m_subMenu.x = Main.Width / 2;
         m_subMenu.y = Main.Height / 2;
         m_subMenu.hrc_counter.visible = false;
         m_subMenu.training_menu.visible = false;
         m_subMenu.help_menu.visible = false;
         m_subMenu.pause_menu.visible = false;
         m_subMenu.camIcon.visible = false;
         m_subMenu.tabChildren = false;
         m_subMenu.tabEnabled = false;
         this.m_damageCounterContainer = m_subMenu.getChildByName("damageCounters") as MovieClip;
         this.m_damageCounterContainer.removeChildren();
         this.m_damageCounterContainer.visible = false;
         this.m_healthBoxes = new Vector.<MovieClip>();
         this.toggleMainDisplay(false);
         this.m_currentItem = 0;
         this.m_currentSpeed = "1.0";
         this.m_cpuNum = 1;
         this.m_cpuAction = 0;
         this.m_cpuDamage = 0;
         this.m_cpuDamageTimer = new FrameTimer(5);
         this.m_cpuDamageMouseDown = false;
         this.m_cpuDamageDiff = 0;
         this.m_cpuDamageInc = true;
         this.m_hudMode = 0;
         this.m_hudDectionMCs = new Vector.<MovieClip>();
         MovieClip(m_subMenu.getChildByName("red_score")).visible = false;
         MovieClip(m_subMenu.getChildByName("blue_score")).visible = false;
         m_disablePauseMapping = true;
      }
      
      public function get CpuDamage() : Number
      {
         return this.m_cpuDamage;
      }
      
      public function get HudMode() : int
      {
         return this.m_hudMode;
      }
      
      public function get CurrentItem() : int
      {
         return this.m_currentItem;
      }
      
      public function get CurrentSpeed() : String
      {
         return this.m_currentSpeed;
      }
      
      public function get CpuAction() : int
      {
         return this.m_cpuAction;
      }
      
      public function toggleMainDisplay(visible:Boolean) : void
      {
         this.m_damageCounterContainer.visible = visible;
      }
      
      public function addHUDDetection(mc:MovieClip) : void
      {
         if(Boolean(mc) && this.m_hudDectionMCs.indexOf(mc) < 0)
         {
            this.m_hudDectionMCs.push(mc);
         }
      }
      
      public function removeHUDDetection(mc:MovieClip) : void
      {
         var index:int = this.m_hudDectionMCs.indexOf(mc);
         if(index >= 0)
         {
            this.m_hudDectionMCs.splice(index,1);
         }
      }
      
      override public function manageMenuMappings(e:Event) : void
      {
         if(Boolean(GameController.stageData && GameController.stageData.FreezeKeys) && Boolean(GameController.stageData.GameRef.GameMode == Mode.TRAINING) && this.m_speedNode != null)
         {
            super.manageMenuMappings(e);
            return;
         }
      }
      
      override public function initMenuMappings() : void
      {
         if(!GameController.stageData || this.m_speedNode != null || GameController.stageData.GameRef.GameMode != Mode.TRAINING)
         {
            return;
         }
         this.m_speedNode = new MenuMapperNode(m_subMenu.training_menu.btn_speed);
         this.m_itemNode = new MenuMapperNode(m_subMenu.training_menu.make_item);
         this.m_cpuCountNode = new MenuMapperNode(m_subMenu.training_menu.btn_cpuCount);
         this.m_cpuActionNode = new MenuMapperNode(m_subMenu.training_menu.btn_cpuAction);
         this.m_cpuDamageNode = new MenuMapperNode(m_subMenu.training_menu.btn_cpuDamage);
         this.m_cameraNode = new MenuMapperNode(m_subMenu.training_menu.btn_camera);
         this.m_showHitboxesNode = new MenuMapperNode(m_subMenu.training_menu.btn_hitBoxes);
         this.m_hudNode = new MenuMapperNode(m_subMenu.training_menu.btn_hud);
         this.m_resetNode = new MenuMapperNode(m_subMenu.training_menu.reset_btn);
         this.m_finishNode = new MenuMapperNode(m_subMenu.training_menu.finish_btn);
         this.m_speedNode.updateNodes([this.m_finishNode,this.m_resetNode],[this.m_itemNode],null,null,this.generic_ROLL_OVER,null,null,this.unpauseGame,null,null,this.prev_speed_CLICK,this.next_speed_CLICK);
         this.m_itemNode.updateNodes([this.m_speedNode],[this.m_cpuCountNode],null,null,this.generic_ROLL_OVER,null,this.make_item_CLICK,this.unpauseGame,null,null,this.prev_item_CLICK,this.next_item_CLICK);
         this.m_cpuCountNode.updateNodes([this.m_itemNode],[this.m_cpuActionNode],null,null,this.generic_ROLL_OVER,null,null,this.unpauseGame,null,null,this.prev_cpuNum_CLICK,this.next_cpuNum_CLICK);
         this.m_cpuActionNode.updateNodes([this.m_cpuCountNode],[this.m_cpuDamageNode],null,null,this.generic_ROLL_OVER,null,null,this.unpauseGame,null,null,this.prev_cpuAction_CLICK,this.next_cpuAction_CLICK);
         this.m_cpuDamageNode.updateNodes([this.m_cpuActionNode],[this.m_showHitboxesNode],null,null,this.generic_ROLL_OVER,null,null,this.unpauseGame,null,null,this.dec_cpuDamage,this.inc_cpuDamage);
         this.m_showHitboxesNode.updateNodes([this.m_cpuDamageNode],[this.m_cameraNode],null,null,this.generic_ROLL_OVER,null,null,this.unpauseGame,null,null,this.prev_showHitboxes_CLICK,this.next_showHitboxes_CLICK);
         this.m_cameraNode.updateNodes([this.m_showHitboxesNode],[this.m_hudNode],null,null,this.generic_ROLL_OVER,null,null,this.unpauseGame,null,null,this.prev_camMode_CLICK,this.next_camMode_CLICK);
         this.m_hudNode.updateNodes([this.m_cameraNode],[this.m_resetNode],null,null,this.generic_ROLL_OVER,null,null,this.unpauseGame,null,null,this.prev_HUD_CLICK,this.next_HUD_CLICK);
         this.m_resetNode.updateNodes([this.m_hudNode],[this.m_speedNode],[this.m_finishNode],[this.m_finishNode],null,null,this.reset_CLICK,this.unpauseGame);
         this.m_finishNode.updateNodes([this.m_hudNode],[this.m_speedNode],[this.m_resetNode],[this.m_resetNode],null,null,this.finish_CLICK,this.unpauseGame);
         m_menuMapper = new MenuMapper(this.m_speedNode);
         m_menuMapper.init();
      }
      
      public function addHealthBox(mc:MovieClip) : void
      {
         if(this.m_healthBoxes.indexOf(mc) < 0)
         {
            this.m_healthBoxes.push(mc);
            this.spaceHealthBoxes();
         }
      }
      
      public function removeHealthBox(mc:MovieClip) : void
      {
         var index:int = this.m_healthBoxes.indexOf(mc);
         if(index >= 0)
         {
            if(Boolean(this.m_healthBoxes[index].parent))
            {
               this.m_healthBoxes[index].parent.removeChild(this.m_healthBoxes[index]);
            }
            this.m_healthBoxes.splice(index,1);
            this.spaceHealthBoxes();
         }
      }
      
      public function displayMusicInfo(text:String) : void
      {
         m_subMenu.music_info.gotoAndPlay(2);
         m_subMenu.music_info.visible = true;
         m_subMenu.music_info.music_info_bar.music_info_txt.text = text;
      }
      
      private function spaceHealthBoxes() : void
      {
         var i:int = 0;
         var leftMost:Number = -275;
         var rightMost:Number = 300;
         var spacing:Number = 150;
         var scale:Number = 1;
         var currentIndex:Number = 0;
         if(this.m_healthBoxes.length > 4)
         {
            spacing = (rightMost - leftMost) / this.m_healthBoxes.length;
            scale = 1 - 0.4 * ((this.m_healthBoxes.length - 4) / 4);
         }
         for(i = 0; i < this.m_healthBoxes.length; i++)
         {
            this.m_healthBoxes[i].x = leftMost + currentIndex * spacing;
            this.m_healthBoxes[i].y = 133.5;
            this.m_healthBoxes[i].scaleX = scale;
            this.m_healthBoxes[i].scaleY = scale;
            this.m_damageCounterContainer.addChild(this.m_healthBoxes[i]);
            currentIndex++;
         }
      }
      
      public function removeHealthBoxes() : void
      {
         this.m_damageCounterContainer.removeChildren();
         this.m_healthBoxes.splice(0,this.m_healthBoxes.length);
      }
      
      private function unpauseGame(e:Event) : void
      {
         if(Boolean(GameController.stageData))
         {
            GameController.stageData.Paused = false;
         }
      }
      
      public function showTrainingDisplay() : void
      {
         if(!GameController.stageData)
         {
            return;
         }
         m_subMenu.training_menu.item_txt.text = GameController.stageData.ItemsRef.ItemsList.length > 0 ? GameController.stageData.ItemsRef.ItemsList[GameController.hud.CurrentItem].DisplayName : "--";
         this.formatTextField(m_subMenu.training_menu.item_txt);
         m_subMenu.training_menu.speed_txt.text = "x " + this.m_currentSpeed;
         m_subMenu.training_menu.cpuNum_txt.text = "" + this.m_cpuNum;
         m_subMenu.training_menu.cpuAction_txt.text = "" + this.formatCPUAction(this.m_cpuAction);
         m_subMenu.training_menu.camMode_txt.text = this.formatCameraMode(GameController.stageData.CamRef.Mode);
         m_subMenu.training_menu.cpuDamage_txt.text = this.m_cpuDamage;
         m_subMenu.training_menu.hitBoxes_txt.text = this.formatShowHitboxes(InteractiveSprite.SHOW_HITBOXES);
         m_subMenu.training_menu.visible = true;
         m_subMenu.training_menu.HUD_txt.text = this.m_hudMode == 0 ? "Normal" : (this.m_hudMode == 1 ? "Advanced" : "None");
      }
      
      public function hideTrainingDisplay() : void
      {
         m_subMenu.training_menu.visible = false;
         this.m_cpuDamageMouseDown = false;
         if(this.m_hudMode != 2)
         {
            this.toggleMainDisplay(true);
         }
      }
      
      public function showHRCDisplay() : void
      {
         m_subMenu.hrc_counter.visible = true;
      }
      
      public function updateHRCDisplay(text:String) : void
      {
         m_subMenu.hrc_counter.total.text = text;
      }
      
      public function hideHRCDisplay() : void
      {
         m_subMenu.hrc_counter.visible = false;
      }
      
      override public function makeEvents() : void
      {
         var pl:int = 0;
         var controller:Controller = null;
         this.initMenuMappings();
         if(m_showCount == 0)
         {
            findSubMenuButtons();
         }
         super.makeEvents();
         resetAllButtons();
         m_subMenu.pause_menu.addEventListener(MouseEvent.CLICK,this.pausemenu_CLICK);
         m_subMenu.camIcon.addEventListener(MouseEvent.CLICK,this.camIcon_CLICK);
         if(m_menuMapper != null)
         {
            setMenuMappingFocus();
         }
         if(Boolean(GameController.stageData) && GameController.stageData.GameRef.GameMode == Mode.TRAINING)
         {
            m_subMenu.training_menu.prev_item.addEventListener(MouseEvent.CLICK,this.prev_item_CLICK);
            m_subMenu.training_menu.next_item.addEventListener(MouseEvent.CLICK,this.next_item_CLICK);
            m_subMenu.training_menu.make_item.addEventListener(MouseEvent.CLICK,this.make_item_CLICK);
            m_subMenu.training_menu.prev_speed.addEventListener(MouseEvent.CLICK,this.prev_speed_CLICK);
            m_subMenu.training_menu.next_speed.addEventListener(MouseEvent.CLICK,this.next_speed_CLICK);
            m_subMenu.training_menu.prev_cpuNum.addEventListener(MouseEvent.CLICK,this.prev_cpuNum_CLICK);
            m_subMenu.training_menu.next_cpuNum.addEventListener(MouseEvent.CLICK,this.next_cpuNum_CLICK);
            m_subMenu.training_menu.prev_cpuAction.addEventListener(MouseEvent.CLICK,this.prev_cpuAction_CLICK);
            m_subMenu.training_menu.next_cpuAction.addEventListener(MouseEvent.CLICK,this.next_cpuAction_CLICK);
            m_subMenu.training_menu.prev_cpuDamage.addEventListener(MouseEvent.MOUSE_DOWN,this.prev_cpuDamage_DOWN);
            m_subMenu.training_menu.next_cpuDamage.addEventListener(MouseEvent.MOUSE_DOWN,this.next_cpuDamage_DOWN);
            m_subMenu.training_menu.prev_cpuDamage.addEventListener(MouseEvent.MOUSE_UP,this.prev_cpuDamage_UP);
            m_subMenu.training_menu.next_cpuDamage.addEventListener(MouseEvent.MOUSE_UP,this.next_cpuDamage_UP);
            m_subMenu.training_menu.prev_cpuDamage.addEventListener(MouseEvent.MOUSE_OUT,this.prev_cpuDamage_UP);
            m_subMenu.training_menu.next_cpuDamage.addEventListener(MouseEvent.MOUSE_OUT,this.next_cpuDamage_UP);
            m_subMenu.training_menu.prev_hitBoxes.addEventListener(MouseEvent.CLICK,this.prev_showHitboxes_CLICK);
            m_subMenu.training_menu.next_hitBoxes.addEventListener(MouseEvent.CLICK,this.next_showHitboxes_CLICK);
            m_subMenu.training_menu.prev_HUD.addEventListener(MouseEvent.CLICK,this.prev_HUD_CLICK);
            m_subMenu.training_menu.next_HUD.addEventListener(MouseEvent.CLICK,this.next_HUD_CLICK);
            m_subMenu.training_menu.finish_btn.addEventListener(MouseEvent.CLICK,this.finish_CLICK);
            m_subMenu.training_menu.reset_btn.addEventListener(MouseEvent.CLICK,this.reset_CLICK);
            m_subMenu.training_menu.prev_camMode.addEventListener(MouseEvent.CLICK,this.prev_camMode_CLICK);
            m_subMenu.training_menu.next_camMode.addEventListener(MouseEvent.CLICK,this.next_camMode_CLICK);
            for(pl = 1; pl < GameController.stageData.Players.length; pl++)
            {
               if(Boolean(GameController.stageData.Players[pl]))
               {
                  GameController.stageData.Players[pl].setHumanControl(false,GameController.stageData.GameRef.PlayerSettings[pl].level);
                  GameController.stageData.Players[pl].getAI().ActionText = this.formatCPUActionShorthand(this.m_cpuAction);
               }
            }
         }
         if(Boolean(MultiplayerManager.Connected) && Boolean(GameController.stageData) && GameController.stageData.GameRef.GameMode === Mode.ONLINE_WAITING_ROOM)
         {
            m_subMenu.onlineStartButton.visible = MultiplayerManager.IsHost;
            m_subMenu.onlineQuitButtons.visible = true;
            controller = SaveData.Controllers[0];
            if(Boolean(m_subMenu.onlineQuitButtons.key_a))
            {
               m_subMenu.onlineQuitButtons.key_a.text = Utils.KEY_ARR_SHORT[controller.KeyboardInstance.ControlsMap[controller._BUTTON1]];
            }
            if(Boolean(m_subMenu.onlineQuitButtons.key_b))
            {
               m_subMenu.onlineQuitButtons.key_b.text = Utils.KEY_ARR_SHORT[controller.KeyboardInstance.ControlsMap[controller._BUTTON2]];
            }
            if(Boolean(m_subMenu.onlineQuitButtons.key_pause))
            {
               m_subMenu.onlineQuitButtons.key_pause.text = Utils.KEY_ARR_SHORT[controller.KeyboardInstance.ControlsMap[controller._START]];
            }
            m_subMenu.onlineStartButton.play();
            m_subMenu.onlineStartButton.addEventListener(MouseEvent.CLICK,this.onOnlineStartButtonClicked);
         }
         if(m_menuMapper != null)
         {
            Main.Root.stage.addEventListener(Event.ENTER_FRAME,this.manageMenuMappings);
         }
         if(Boolean(GameController.stageData) && Boolean(GameController.stageData.GameRef.CustomModeObj))
         {
            m_subMenu.pause_menu.retry_btn.visible = ModeFeatures.hasFeature(ModeFeatures.HAS_RETRY_BUTTON,GameController.currentGame.GameMode);
         }
         else
         {
            m_subMenu.pause_menu.retry_btn.visible = false;
         }
      }
      
      override public function killEvents() : void
      {
         super.killEvents();
         m_subMenu.pause_menu.removeEventListener(MouseEvent.CLICK,this.pausemenu_CLICK);
         m_subMenu.camIcon.removeEventListener(MouseEvent.CLICK,this.camIcon_CLICK);
         if(m_menuMapper != null)
         {
            Main.Root.stage.removeEventListener(Event.ENTER_FRAME,this.manageMenuMappings);
         }
         if(Boolean(GameController.stageData) && GameController.stageData.GameRef.GameMode == Mode.TRAINING)
         {
            m_subMenu.training_menu.prev_item.removeEventListener(MouseEvent.CLICK,this.prev_item_CLICK);
            m_subMenu.training_menu.next_item.removeEventListener(MouseEvent.CLICK,this.next_item_CLICK);
            m_subMenu.training_menu.make_item.removeEventListener(MouseEvent.CLICK,this.make_item_CLICK);
            m_subMenu.training_menu.prev_speed.removeEventListener(MouseEvent.CLICK,this.prev_speed_CLICK);
            m_subMenu.training_menu.next_speed.removeEventListener(MouseEvent.CLICK,this.next_speed_CLICK);
            m_subMenu.training_menu.prev_cpuNum.removeEventListener(MouseEvent.CLICK,this.prev_cpuNum_CLICK);
            m_subMenu.training_menu.next_cpuNum.removeEventListener(MouseEvent.CLICK,this.next_cpuNum_CLICK);
            m_subMenu.training_menu.prev_cpuAction.removeEventListener(MouseEvent.CLICK,this.prev_cpuAction_CLICK);
            m_subMenu.training_menu.next_cpuAction.removeEventListener(MouseEvent.CLICK,this.next_cpuAction_CLICK);
            m_subMenu.training_menu.prev_cpuDamage.removeEventListener(MouseEvent.MOUSE_DOWN,this.prev_cpuDamage_DOWN);
            m_subMenu.training_menu.next_cpuDamage.removeEventListener(MouseEvent.MOUSE_DOWN,this.next_cpuDamage_DOWN);
            m_subMenu.training_menu.prev_cpuDamage.removeEventListener(MouseEvent.MOUSE_UP,this.prev_cpuDamage_UP);
            m_subMenu.training_menu.next_cpuDamage.removeEventListener(MouseEvent.MOUSE_UP,this.next_cpuDamage_UP);
            m_subMenu.training_menu.prev_cpuDamage.removeEventListener(MouseEvent.MOUSE_OUT,this.prev_cpuDamage_UP);
            m_subMenu.training_menu.next_cpuDamage.removeEventListener(MouseEvent.MOUSE_OUT,this.next_cpuDamage_UP);
            m_subMenu.training_menu.prev_hitBoxes.removeEventListener(MouseEvent.CLICK,this.prev_showHitboxes_CLICK);
            m_subMenu.training_menu.next_hitBoxes.removeEventListener(MouseEvent.CLICK,this.next_showHitboxes_CLICK);
            m_subMenu.training_menu.prev_HUD.removeEventListener(MouseEvent.CLICK,this.prev_HUD_CLICK);
            m_subMenu.training_menu.next_HUD.removeEventListener(MouseEvent.CLICK,this.next_HUD_CLICK);
            m_subMenu.training_menu.finish_btn.removeEventListener(MouseEvent.CLICK,this.finish_CLICK);
            m_subMenu.training_menu.reset_btn.removeEventListener(MouseEvent.CLICK,this.reset_CLICK);
            m_subMenu.training_menu.prev_camMode.removeEventListener(MouseEvent.CLICK,this.prev_camMode_CLICK);
            m_subMenu.training_menu.next_camMode.removeEventListener(MouseEvent.CLICK,this.next_camMode_CLICK);
         }
         if(Boolean(GameController.stageData) && GameController.stageData.GameRef.GameMode === Mode.ONLINE_WAITING_ROOM)
         {
            m_subMenu.onlineStartButton.visible = false;
            m_subMenu.onlineStartButton.stop();
         }
         m_subMenu.onlineStartButton.removeEventListener(MouseEvent.CLICK,this.onOnlineStartButtonClicked);
      }
      
      private function generic_ROLL_OVER(e:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
      }
      
      private function pausemenu_CLICK(e:MouseEvent) : void
      {
         m_subMenu.pause_menu.visible = false;
         m_subMenu.camIcon.gotoAndStop(1);
      }
      
      private function camIcon_CLICK(e:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_camera");
         var i:int = 0;
         var turnDebuggerBackOn:Boolean = false;
         var turnControlsBackOn:Boolean = false;
         m_subMenu.camIcon.visible = false;
         if(Boolean(m_subMenu.pause_menu.visible))
         {
            turnControlsBackOn = true;
            m_subMenu.pause_menu.visible = false;
         }
         if(Main.DEBUG)
         {
            turnDebuggerBackOn = true;
            GameController.constantDebugger.SubMenu.visible = false;
         }
         for(i = 0; i < this.m_healthBoxes.length; i++)
         {
            this.m_healthBoxes[i].wasVisible = this.m_healthBoxes[i].visible;
            this.m_healthBoxes[i].visible = false;
         }
         Main.Root.graphics.beginFill(0,1);
         Main.Root.graphics.drawRect(0,0,Main.Width,Main.Height);
         Utils.saveSnapShot(Main.Root);
         Main.Root.graphics.clear();
         for(i = 0; i < this.m_healthBoxes.length; i++)
         {
            this.m_healthBoxes[i].visible = this.m_healthBoxes[i].wasVisible;
            delete this.m_healthBoxes[i].wasVisible;
         }
         m_subMenu.camIcon.visible = true;
         m_subMenu.camIcon.gotoAndPlay("snapshot");
         if(turnDebuggerBackOn && Main.DEBUG)
         {
            GameController.constantDebugger.SubMenu.visible = true;
         }
         if(turnControlsBackOn)
         {
            m_subMenu.pause_menu.visible = true;
         }
      }
      
      public function prev_item_CLICK(e:MouseEvent) : void
      {
         if(!GameController.stageData)
         {
            return;
         }
         --this.m_currentItem;
         if(this.m_currentItem < 0)
         {
            this.m_currentItem = GameController.stageData.ItemsRef.ItemsList.length - 1;
         }
         m_subMenu.training_menu.item_txt.text = GameController.stageData.ItemsRef.ItemsList.length > 0 ? GameController.stageData.ItemsRef.ItemsList[this.m_currentItem].DisplayName : "--";
         this.formatTextField(m_subMenu.training_menu.item_txt);
      }
      
      public function next_item_CLICK(e:MouseEvent) : void
      {
         if(!GameController.stageData)
         {
            return;
         }
         ++this.m_currentItem;
         if(this.m_currentItem >= GameController.stageData.ItemsRef.ItemsList.length)
         {
            this.m_currentItem = 0;
         }
         m_subMenu.training_menu.item_txt.text = GameController.stageData.ItemsRef.ItemsList.length > 0 ? GameController.stageData.ItemsRef.ItemsList[this.m_currentItem].DisplayName : "--";
         this.formatTextField(m_subMenu.training_menu.item_txt);
      }
      
      public function make_item_CLICK(e:MouseEvent) : void
      {
         var x_loc:Number = NaN;
         var y_loc:Number = NaN;
         var angle:Number = NaN;
         if(!GameController.stageData || GameController.stageData.ItemsRef.ItemsList.length <= 0)
         {
            return;
         }
         GameController.stageData.SoundQueueRef.playSoundEffect("item_spawntraining");
         if(Boolean(GameController.stageData.getPlayerByID(1)) && GameController.stageData.getPlayerByID(1).CollisionObj.ground)
         {
            x_loc = GameController.stageData.getPlayerByID(1).X + (GameController.stageData.getPlayerByID(1).FacingForward ? GameController.stageData.getPlayerByID(1).Width : -GameController.stageData.getPlayerByID(1).Width);
            y_loc = GameController.stageData.getPlayerByID(1).Y - GameController.stageData.getPlayerByID(1).Height * 2;
            angle = 0;
            while(Boolean(GameController.stageData.getPlayerByID(1).testTerrainWithCoord(x_loc,y_loc)) && angle < 360)
            {
               x_loc += Utils.calculateXSpeed(10,angle);
               y_loc += Utils.calculateYSpeed(10,angle);
               angle += 10;
            }
            if(angle >= 360 && Boolean(GameController.stageData.getPlayerByID(1).testTerrainWithCoord(x_loc,y_loc)))
            {
               x_loc = GameController.stageData.getPlayerByID(1).X;
               y_loc = GameController.stageData.getPlayerByID(1).Y - 10;
            }
            GameController.stageData.ItemsRef.generateItemObj(GameController.stageData.ItemsRef.ItemsList[this.m_currentItem],x_loc,y_loc);
         }
         else
         {
            GameController.stageData.ItemsRef.generateItemObj(GameController.stageData.ItemsRef.ItemsList[this.m_currentItem]);
         }
      }
      
      public function prev_speed_CLICK(e:MouseEvent) : void
      {
         if(!GameController.stageData)
         {
            return;
         }
         if(this.m_currentSpeed == "2.0")
         {
            this.m_currentSpeed = "1.5";
            Main.Root.stage.frameRate = Main.FRAMERATE * 1.5;
         }
         else if(this.m_currentSpeed == "1.5")
         {
            this.m_currentSpeed = "1.0";
            Main.Root.stage.frameRate = Main.FRAMERATE * 1;
         }
         else if(this.m_currentSpeed == "1.0")
         {
            this.m_currentSpeed = "2/3";
            Main.Root.stage.frameRate = Math.round(Main.FRAMERATE * 2 / 3);
         }
         else
         {
            this.m_currentSpeed = "1/3";
            Main.Root.stage.frameRate = Math.round(Main.FRAMERATE * 1 / 3);
         }
         m_subMenu.training_menu.speed_txt.text = "x " + this.m_currentSpeed;
      }
      
      public function next_speed_CLICK(e:MouseEvent) : void
      {
         if(!GameController.stageData)
         {
            return;
         }
         if(this.m_currentSpeed == "1/3")
         {
            this.m_currentSpeed = "2/3";
            Main.Root.stage.frameRate = Math.round(Main.FRAMERATE * 2 / 3);
         }
         else if(this.m_currentSpeed == "2/3")
         {
            this.m_currentSpeed = "1.0";
            Main.Root.stage.frameRate = Main.FRAMERATE * 1;
         }
         else if(this.m_currentSpeed == "1.0")
         {
            this.m_currentSpeed = "1.5";
            Main.Root.stage.frameRate = Main.FRAMERATE * 1.5;
         }
         else
         {
            this.m_currentSpeed = "2.0";
            Main.Root.stage.frameRate = Main.FRAMERATE * 2;
         }
         m_subMenu.training_menu.speed_txt.text = "x " + this.m_currentSpeed;
      }
      
      public function prev_cpuNum_CLICK(e:MouseEvent) : void
      {
         if(!GameController.stageData)
         {
            return;
         }
         if(Boolean(GameController.stageData.ItemsRef.PlayerUsingSmashBall) || Boolean(GameController.stageData.ItemsRef.PlayerHasSmashBall))
         {
            SoundQueue.instance.playSoundEffect("menu_error");
            return;
         }
         --this.m_cpuNum;
         if(this.m_cpuNum < 0)
         {
            this.m_cpuNum = 0;
         }
         else
         {
            m_subMenu.training_menu.cpuNum_txt.text = "" + this.m_cpuNum;
            if(Boolean(GameController.stageData.getPlayerByID(this.m_cpuNum + 2)))
            {
               GameController.stageData.getPlayerByID(this.m_cpuNum + 2).StandBy = true;
            }
         }
      }
      
      public function next_cpuNum_CLICK(e:MouseEvent) : void
      {
         if(!GameController.stageData)
         {
            return;
         }
         if(Boolean(GameController.stageData.ItemsRef.PlayerUsingSmashBall) || Boolean(GameController.stageData.ItemsRef.PlayerHasSmashBall))
         {
            SoundQueue.instance.playSoundEffect("menu_error");
            return;
         }
         ++this.m_cpuNum;
         if(this.m_cpuNum > GameController.stageData.Players.length - 1)
         {
            this.m_cpuNum = GameController.stageData.Players.length - 1;
         }
         else
         {
            m_subMenu.training_menu.cpuNum_txt.text = "" + this.m_cpuNum;
            if(Boolean(GameController.stageData.getPlayerByID(this.m_cpuNum + 1)))
            {
               GameController.stageData.getPlayerByID(this.m_cpuNum + 1).StandBy = false;
            }
            if(this.m_hudMode == 2)
            {
               this.setHealthBoxVisibility(false);
            }
         }
      }
      
      public function prev_cpuAction_CLICK(e:MouseEvent) : void
      {
         if(!GameController.stageData)
         {
            return;
         }
         --this.m_cpuAction;
         if(this.m_cpuAction < -2)
         {
            this.m_cpuAction = 5;
         }
         for(var p:int = 1; p < GameController.stageData.Players.length; p++)
         {
            if(GameController.stageData.Players[p] != null)
            {
               if(this.m_cpuAction == -2)
               {
                  GameController.stageData.Players[p].setHumanControl(true,GameController.stageData.GameRef.PlayerSettings[p].level);
               }
               else
               {
                  GameController.stageData.Players[p].setHumanControl(false,GameController.stageData.GameRef.PlayerSettings[p].level);
                  GameController.stageData.Players[p].getAI().ActionText = this.formatCPUActionShorthand(this.m_cpuAction);
               }
            }
         }
         m_subMenu.training_menu.cpuAction_txt.text = this.formatCPUAction(this.m_cpuAction);
      }
      
      public function next_cpuAction_CLICK(e:MouseEvent) : void
      {
         ++this.m_cpuAction;
         if(this.m_cpuAction > 5)
         {
            this.m_cpuAction = -2;
         }
         for(var p:int = 1; p < GameController.stageData.Players.length; p++)
         {
            if(GameController.stageData.Players[p] != null)
            {
               if(this.m_cpuAction == -2)
               {
                  GameController.stageData.Players[p].setHumanControl(true,GameController.stageData.GameRef.PlayerSettings[p].level);
               }
               else
               {
                  GameController.stageData.Players[p].setHumanControl(false,GameController.stageData.GameRef.PlayerSettings[p].level);
                  GameController.stageData.Players[p].getAI().ActionText = this.formatCPUActionShorthand(this.m_cpuAction);
               }
            }
         }
         m_subMenu.training_menu.cpuAction_txt.text = this.formatCPUAction(this.m_cpuAction);
      }
      
      public function next_cpuDamage_DOWN(e:MouseEvent) : void
      {
         this.m_cpuDamageMouseDown = true;
         this.m_cpuDamageInc = true;
         this.m_cpuDamageDiff = 0;
         this.m_cpuDamageTimer.CurrentTime = this.m_cpuDamageTimer.MaxTime;
      }
      
      public function prev_cpuDamage_DOWN(e:MouseEvent) : void
      {
         this.m_cpuDamageMouseDown = true;
         this.m_cpuDamageInc = false;
         this.m_cpuDamageDiff = 0;
         this.m_cpuDamageTimer.CurrentTime = this.m_cpuDamageTimer.MaxTime;
      }
      
      public function next_cpuDamage_UP(e:MouseEvent) : void
      {
         this.m_cpuDamageMouseDown = false;
         this.m_cpuDamageInc = true;
      }
      
      public function prev_cpuDamage_UP(e:MouseEvent) : void
      {
         this.m_cpuDamageMouseDown = false;
         this.m_cpuDamageInc = false;
      }
      
      public function inc_cpuDamage(e:MouseEvent) : void
      {
         ++this.m_cpuDamage;
         if(this.m_cpuDamage > 999)
         {
            this.m_cpuDamage = 0;
         }
         m_subMenu.training_menu.cpuDamage_txt.text = this.m_cpuDamage;
      }
      
      public function dec_cpuDamage(e:MouseEvent) : void
      {
         --this.m_cpuDamage;
         if(this.m_cpuDamage < 0)
         {
            this.m_cpuDamage = 999;
         }
         m_subMenu.training_menu.cpuDamage_txt.text = this.m_cpuDamage;
      }
      
      public function next_showHitboxes_CLICK(e:MouseEvent) : void
      {
         if(!GameController.stageData)
         {
            return;
         }
         InteractiveSprite.SHOW_HITBOXES = !InteractiveSprite.SHOW_HITBOXES;
         m_subMenu.training_menu.hitBoxes_txt.text = this.formatShowHitboxes(InteractiveSprite.SHOW_HITBOXES);
      }
      
      public function prev_showHitboxes_CLICK(e:MouseEvent) : void
      {
         if(!GameController.stageData)
         {
            return;
         }
         InteractiveSprite.SHOW_HITBOXES = !InteractiveSprite.SHOW_HITBOXES;
         m_subMenu.training_menu.hitBoxes_txt.text = this.formatShowHitboxes(InteractiveSprite.SHOW_HITBOXES);
      }
      
      public function next_camMode_CLICK(e:MouseEvent) : void
      {
         var list:Vector.<MovieClip> = null;
         var p:int = 0;
         if(!GameController.stageData)
         {
            return;
         }
         ++GameController.stageData.CamRef.Mode;
         m_subMenu.training_menu.camMode_txt.text = this.formatCameraMode(GameController.stageData.CamRef.Mode);
         if(GameController.stageData.CamRef.Mode == Vcam.ZOOM_MODE && GameController.stageData.CamRef.Targets.length > 1)
         {
            list = new Vector.<MovieClip>();
            for(p = 0; p < GameController.stageData.Players.length; p++)
            {
               if(GameController.stageData.Players[p] != null && !GameController.stageData.Players[p].StandBy)
               {
                  list.push(GameController.stageData.Players[p].MC);
               }
            }
            if(GameController.stageData.ItemsRef.CurrentSmashBall != null)
            {
               list.push(GameController.stageData.ItemsRef.CurrentSmashBall.ItemInstance);
            }
            GameController.stageData.CamRef.deleteTargets(list);
            list = list.slice(0,1);
            GameController.stageData.CamRef.addTargets(list);
         }
         else if(GameController.stageData.CamRef.Mode == Vcam.STAGE_MODE)
         {
            GameController.stageData.CamRef.fixBG();
         }
      }
      
      public function prev_camMode_CLICK(e:MouseEvent) : void
      {
         var list:Vector.<MovieClip> = null;
         var p:int = 0;
         if(!GameController.stageData)
         {
            return;
         }
         --GameController.stageData.CamRef.Mode;
         m_subMenu.training_menu.camMode_txt.text = this.formatCameraMode(GameController.stageData.CamRef.Mode);
         if(GameController.stageData.CamRef.Mode == Vcam.ZOOM_MODE && GameController.stageData.CamRef.Targets.length > 1)
         {
            list = new Vector.<MovieClip>();
            for(p = 0; p < GameController.stageData.Players.length; p++)
            {
               if(GameController.stageData.Players[p] != null && !GameController.stageData.Players[p].StandBy)
               {
                  list.push(GameController.stageData.Players[p].MC);
               }
            }
            if(GameController.stageData.ItemsRef.CurrentSmashBall != null)
            {
               list.push(GameController.stageData.ItemsRef.CurrentSmashBall.ItemInstance);
            }
            GameController.stageData.CamRef.deleteTargets(list);
            list = list.slice(0,1);
            GameController.stageData.CamRef.addTargets(list);
         }
         else if(GameController.stageData.CamRef.Mode == Vcam.STAGE_MODE)
         {
            GameController.stageData.CamRef.fixBG();
         }
      }
      
      public function next_HUD_CLICK(e:MouseEvent) : void
      {
         GameController.stageData.SoundQueueRef.playSoundEffect("menu_select");
         ++this.m_hudMode;
         if(this.m_hudMode > 2)
         {
            this.m_hudMode = 0;
         }
         switch(this.m_hudMode)
         {
            case 0:
               m_subMenu.training_menu.HUD_txt.text = "Normal";
               this.setHealthBoxVisibility(true);
               break;
            case 1:
               m_subMenu.help_menu.visible = true;
               m_subMenu.training_menu.HUD_txt.text = "Advanced";
               break;
            case 2:
               m_subMenu.help_menu.visible = false;
               m_subMenu.training_menu.HUD_txt.text = "None";
               this.setHealthBoxVisibility(false);
         }
      }
      
      public function prev_HUD_CLICK(e:MouseEvent) : void
      {
         GameController.stageData.SoundQueueRef.playSoundEffect("menu_select");
         --this.m_hudMode;
         if(this.m_hudMode < 0)
         {
            this.m_hudMode = 2;
         }
         switch(this.m_hudMode)
         {
            case 0:
               m_subMenu.help_menu.visible = false;
               m_subMenu.training_menu.HUD_txt.text = "Normal";
               break;
            case 1:
               m_subMenu.help_menu.visible = true;
               m_subMenu.training_menu.HUD_txt.text = "Advanced";
               this.setHealthBoxVisibility(true);
               break;
            case 2:
               m_subMenu.training_menu.HUD_txt.text = "None";
               this.setHealthBoxVisibility(false);
         }
      }
      
      public function reset_CLICK(e:MouseEvent) : void
      {
         if(!GameController.stageData)
         {
            return;
         }
         if(Boolean(GameController.stageData.ItemsRef.PlayerUsingSmashBall) || Boolean(GameController.stageData.ItemsRef.PlayerHasSmashBall))
         {
            SoundQueue.instance.playSoundEffect("menu_error");
            return;
         }
         var p:int = 0;
         GameController.stageData.SoundQueueRef.playSoundEffect("menu_back");
         this.m_currentItem = 0;
         this.m_currentSpeed = "1.0";
         Main.Root.stage.frameRate = Main.FRAMERATE * 1;
         this.m_cpuNum = 1;
         m_subMenu.training_menu.cpuNum_txt.text = "" + this.m_cpuNum;
         if(Boolean(GameController.stageData.getPlayerByID(1)))
         {
            GameController.stageData.getPlayerByID(1).StandBy = false;
         }
         for(p = 2; p < GameController.stageData.Players.length; p++)
         {
            if(Boolean(GameController.stageData.Players[p]))
            {
               GameController.stageData.Players[p].StandBy = true;
            }
         }
         if(Boolean(GameController.stageData.getPlayerByID(2)))
         {
            GameController.stageData.getPlayerByID(2).StandBy = false;
         }
         this.m_cpuAction = 0;
         for(p = 1; p < GameController.stageData.Players.length; p++)
         {
            if(GameController.stageData.Players[p] != null)
            {
               GameController.stageData.Players[p].setHumanControl(false,GameController.stageData.GameRef.PlayerSettings[p].level);
               GameController.stageData.Players[p].getAI().ActionText = this.formatCPUActionShorthand(this.m_cpuAction);
            }
         }
         GameController.stageData.CamRef.Mode = Vcam.NORMAL_MODE;
         InteractiveSprite.SHOW_HITBOXES = false;
         this.m_cpuDamage = 0;
         m_subMenu.training_menu.item_txt.text = GameController.stageData.ItemsRef.ItemsList[this.m_currentItem].DisplayName;
         this.formatTextField(m_subMenu.training_menu.item_txt);
         m_subMenu.training_menu.speed_txt.text = "x " + this.m_currentSpeed;
         m_subMenu.training_menu.cpuNum_txt.text = "" + this.m_cpuNum;
         m_subMenu.training_menu.cpuAction_txt.text = "" + this.formatCPUAction(this.m_cpuAction);
         m_subMenu.training_menu.camMode_txt.text = this.formatCameraMode(GameController.stageData.CamRef.Mode);
         m_subMenu.training_menu.hitBoxes_txt.text = this.formatShowHitboxes(InteractiveSprite.SHOW_HITBOXES);
         m_subMenu.training_menu.cpuDamage_txt.text = this.m_cpuDamage;
         this.m_hudMode = 0;
         m_subMenu.help_menu.visible = false;
         m_subMenu.training_menu.HUD_txt.text = "Normal";
      }
      
      public function finish_CLICK(e:MouseEvent) : void
      {
         GameController.stageData.SoundQueueRef.playSoundEffect("menu_back");
         GameController.stageData.endGame();
      }
      
      private function formatTextField(t:TextField) : void
      {
         t = m_subMenu.training_menu.item_txt;
         t.autoSize = TextFieldAutoSize.CENTER;
         var tFormat:TextFormat = t.getTextFormat();
         while(t.numLines > 1)
         {
            tFormat.size = Number(tFormat.size) - 1;
            t.setTextFormat(tFormat);
         }
         while(t.numLines < 2)
         {
            tFormat.size = Number(tFormat.size) + 1;
            t.setTextFormat(tFormat);
         }
         tFormat.size = Number(tFormat.size) - 1;
         if(Number(tFormat.size) > 14)
         {
            tFormat.size = Number(14);
         }
         t.setTextFormat(tFormat);
      }
      
      private function formatShowHitboxes(value:Boolean) : String
      {
         return value ? "On" : "Off";
      }
      
      private function formatCameraMode(num:int) : String
      {
         var str:String = "???";
         switch(num)
         {
            case Vcam.NORMAL_MODE:
               str = "Normal";
               break;
            case Vcam.ZOOM_MODE:
               str = "Zoom";
               break;
            case Vcam.STAGE_MODE:
               str = "Stage";
         }
         return str;
      }
      
      private function formatCPUAction(num:int) : String
      {
         var str:String = "???";
         switch(num)
         {
            case -2:
               str = "Human";
               break;
            case -1:
               str = "Attack";
               break;
            case 0:
               str = "Idle";
               break;
            case 1:
               str = "Chase";
               break;
            case 2:
               str = "Evade";
               break;
            case 3:
               str = "Jump";
               break;
            case 4:
               str = "Walk";
               break;
            case 5:
               str = "Run";
         }
         return str;
      }
      
      private function formatCPUActionShorthand(num:int) : String
      {
         var str:String = "???";
         switch(num)
         {
            case -2:
               str = "human";
               break;
            case -1:
               str = "attack";
               break;
            case 0:
               str = "idle";
               break;
            case 1:
               str = "chase";
               break;
            case 2:
               str = "evade";
               break;
            case 3:
               str = "jump";
               break;
            case 4:
               str = "walk";
               break;
            case 5:
               str = "run";
         }
         return str;
      }
      
      public function updateCPUDamage() : void
      {
         if(GameController.stageData.GameRef.GameMode == Mode.TRAINING && this.m_cpuDamageMouseDown)
         {
            this.m_cpuDamageTimer.tick();
            if(this.m_cpuDamageTimer.IsComplete)
            {
               this.m_cpuDamageTimer.reset();
               ++this.m_cpuDamageDiff;
               if(this.m_cpuDamageDiff >= 5)
               {
                  this.m_cpuDamageTimer.MaxTime = 1;
               }
               else if(this.m_cpuDamageDiff < 5)
               {
                  this.m_cpuDamageTimer.MaxTime = 5;
               }
               if(this.m_cpuDamageInc)
               {
                  this.m_cpuDamage += this.m_cpuDamageDiff >= 60 ? 6 : 1;
               }
               else
               {
                  this.m_cpuDamage -= this.m_cpuDamageDiff >= 60 ? 6 : 1;
               }
               if(this.m_cpuDamage < 0)
               {
                  this.m_cpuDamage = 999;
               }
               else if(this.m_cpuDamage > 999)
               {
                  this.m_cpuDamage = 0;
               }
            }
            m_subMenu.training_menu.cpuDamage_txt.text = this.m_cpuDamage;
         }
      }
      
      public function updateHelpMenu() : void
      {
         if(Boolean(GameController.stageData.getPlayerByID(1)))
         {
            m_subMenu.help_menu.speed_txt.text = "x " + this.m_currentSpeed;
            m_subMenu.help_menu.enemy_txt.text = "" + this.formatCPUAction(this.m_cpuAction);
            m_subMenu.help_menu.comboCount_txt.text = "" + GameController.stageData.getPlayerByID(1).Combo;
            m_subMenu.help_menu.comboCount_txt.text = "" + GameController.stageData.getPlayerByID(1).Combo;
            m_subMenu.help_menu.comboDamageCount_txt.text = "" + Math.ceil(GameController.stageData.getPlayerByID(1).ComboDamage);
            m_subMenu.help_menu.comboDamageTotalCount_txt.text = "" + Math.ceil(GameController.stageData.getPlayerByID(1).ComboDamageTotal);
         }
      }
      
      public function getHealthBox(pid:int) : MovieClip
      {
         return Boolean(m_subMenu["p" + pid + "health"]) ? m_subMenu["p" + pid + "health"].display : null;
      }
      
      private function setHealthBoxVisibility(value:Boolean) : void
      {
         var hBox:MovieClip = null;
         var i:int = 0;
         for(i = 0; i < GameController.stageData.Characters.length; i++)
         {
            hBox = GameController.stageData.Characters[i].HealthBox;
            if(hBox != null)
            {
               if(!GameController.stageData.Characters[i].Dead && !GameController.stageData.Characters[i].StandBy)
               {
                  hBox.visible = value;
               }
               else
               {
                  hBox.visible = false;
               }
            }
         }
      }
      
      public function forceHitBoxVisiblity(value:Boolean) : void
      {
         var hBox:MovieClip = null;
         for(var i:int = 0; i < GameController.stageData.Players.length; i++)
         {
            hBox = GameController.stageData.Players[i] == null ? null : this.getHealthBox(GameController.stageData.Players[i].ID);
            if(hBox != null)
            {
               hBox.visible = value;
            }
         }
      }
      
      public function updateHealthBoxVisibility() : void
      {
         var hBox:MovieClip = null;
         var collision:Boolean = false;
         var masterToggle:Boolean = false;
         var i:int = 0;
         var j:int = 0;
         var k:int = 0;
         for(i = 0; i < GameController.stageData.Players.length; i++)
         {
            if(GameController.stageData.Players[i] != null && GameController.stageData.Players[i].UsingFinalSmash && (GameController.stageData.Players[i].SpecialType == 4 || GameController.stageData.Players[i].SpecialType == 5))
            {
               masterToggle = true;
            }
         }
         for(i = 0; i < this.m_healthBoxes.length; i++)
         {
            hBox = this.m_healthBoxes[i];
            if(hBox != null)
            {
               collision = false;
               j = 0;
               while(j < GameController.stageData.Players.length && !collision)
               {
                  if(Boolean(GameController.stageData.Players[j] != null && !GameController.stageData.Players[j].Dead && !GameController.stageData.Players[j].StandBy && GameController.stageData.Players[j].HasHitBox) && Boolean(GameController.stageData.Players[j].HitBox) && GameController.stageData.Players[j].HitBox.hitTestObject(hBox))
                  {
                     collision = true;
                  }
                  j++;
               }
               for(j = 0; j < this.m_hudDectionMCs.length; j++)
               {
                  if(Boolean(this.m_hudDectionMCs[j]) && this.m_hudDectionMCs[j].hitTestObject(hBox))
                  {
                     collision = true;
                  }
               }
               if(Boolean(GameController.stageData.getQualitySettings().hud_alpha))
               {
                  if((masterToggle || collision) && hBox.alpha > 0.4)
                  {
                     hBox.alpha -= 0.05;
                  }
                  else if(!collision && !masterToggle && hBox.alpha < 1)
                  {
                     hBox.alpha += 0.05;
                  }
               }
               else if((masterToggle || collision) && hBox.alpha > 0.4)
               {
                  hBox.alpha = 0;
               }
               else if(!collision && !masterToggle && hBox.alpha < 1)
               {
                  hBox.alpha = 1;
               }
            }
         }
      }
      
      public function darkenCamera() : void
      {
         var tmpMC:MovieClip = null;
         if(m_container.getChildByName("darkener") == null)
         {
            tmpMC = ResourceManager.getLibraryMC("darkening");
            tmpMC.name = "darkener";
            m_container.addChild(tmpMC);
            m_container.swapChildren(m_subMenu,tmpMC);
         }
      }
      
      public function killCameraDarkener() : void
      {
         if(m_container.getChildByName("darkener") != null)
         {
            MovieClip(m_container.getChildByName("darkener")).stop();
            m_container.swapChildren(m_subMenu,m_container.getChildByName("darkener"));
            m_container.removeChild(MovieClip(m_container.getChildByName("darkener")));
         }
      }
      
      public function brightenCamera() : void
      {
         if(m_container.getChildByName("darkener") != null)
         {
            if(Boolean(MovieClip(m_container.getChildByName("darkener")).finished))
            {
               MovieClip(m_container.getChildByName("darkener")).play();
            }
            else
            {
               MovieClip(m_container.getChildByName("darkener")).shouldStop = false;
            }
         }
      }
      
      public function togglePauseIcons(visible:Boolean) : void
      {
         m_subMenu.pause_menu.visible = visible;
         m_subMenu.camIcon.visible = visible;
      }
      
      public function updatePauseKeyboardDisplay(controller:Controller) : void
      {
         m_subMenu.pause_menu.key_up.text = Utils.KEY_ARR_SHORT[controller.KeyboardInstance.ControlsMap[controller._UP]];
         m_subMenu.pause_menu.key_down.text = Utils.KEY_ARR_SHORT[controller.KeyboardInstance.ControlsMap[controller._DOWN]];
         m_subMenu.pause_menu.key_left.text = Utils.KEY_ARR_SHORT[controller.KeyboardInstance.ControlsMap[controller._LEFT]];
         m_subMenu.pause_menu.key_right.text = Utils.KEY_ARR_SHORT[controller.KeyboardInstance.ControlsMap[controller._RIGHT]];
         m_subMenu.pause_menu.key_pause.text = Utils.KEY_ARR_SHORT[controller.KeyboardInstance.ControlsMap[controller._START]];
         m_subMenu.pause_menu.key_a.text = Utils.KEY_ARR_SHORT[controller.KeyboardInstance.ControlsMap[controller._BUTTON1]];
         m_subMenu.pause_menu.key_b.text = Utils.KEY_ARR_SHORT[controller.KeyboardInstance.ControlsMap[controller._BUTTON2]];
         m_subMenu.pause_menu.key_pause2.text = Utils.KEY_ARR_SHORT[controller.KeyboardInstance.ControlsMap[controller._START]];
         m_subMenu.pause_menu.key_a2.text = Utils.KEY_ARR_SHORT[controller.KeyboardInstance.ControlsMap[controller._BUTTON1]];
         m_subMenu.pause_menu.key_b2.text = Utils.KEY_ARR_SHORT[controller.KeyboardInstance.ControlsMap[controller._BUTTON2]];
         m_subMenu.pause_menu.retry_btn.key_grab.text = Utils.KEY_ARR_SHORT[controller.KeyboardInstance.ControlsMap[controller._GRAB]];
         m_subMenu.pause_menu.p_pause.text = "P" + controller.ID + " PAUSE";
      }
      
      private function onOnlineStartButtonClicked(e:MouseEvent) : void
      {
         if(Boolean(GameController.stageData) && GameController.stageData.startOnlineMatch())
         {
            m_subMenu.onlineStartButton.visible = false;
            m_subMenu.onlineStartButton.stop();
         }
      }
   }
}

