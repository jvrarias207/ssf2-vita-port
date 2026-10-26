package com.mcleodgaming.ssf2.menus
{
   import com.mcleodgaming.ssf2.Main;
   import com.mcleodgaming.ssf2.audio.*;
   import com.mcleodgaming.ssf2.controllers.*;
   import com.mcleodgaming.ssf2.events.GamepadEvent;
   import com.mcleodgaming.ssf2.input.Gamepad;
   import com.mcleodgaming.ssf2.input.GamepadManager;
   import com.mcleodgaming.ssf2.net.MultiplayerManager;
   import com.mcleodgaming.ssf2.util.*;
   import fl.controls.CheckBox;
   import fl.controls.ComboBox;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class ControlsMenu extends Menu
   {
      
      public var playNum:int;
      
      public var selectHand:ControlsSelectHand;
      
      private var controlsButtons:Vector.<ControlsButton>;
      
      private var m_tapJumpCheckBox:CheckBox;
      
      private var m_autoDashCheckBox:CheckBox;
      
      private var m_dtDashCheckBox:CheckBox;
      
      private var m_autoDashTxt:TextField;
      
      private var m_dtDashTxt:TextField;
      
      private var m_gamepadDropdown:ComboBox;
      
      public var controlStickDashZone:Number;
      
      public var controlStickDeadZone:Number;
      
      public var cStickDashZone:Number;
      
      public var cStickDeadZone:Number;
      
      public function ControlsMenu()
      {
         super();
         m_subMenu = ResourceManager.getLibraryMC("menu_controls");
         m_backgroundID = "space";
         this.m_tapJumpCheckBox = m_subMenu.tapJump;
         this.m_autoDashCheckBox = m_subMenu.autoDash;
         this.m_autoDashTxt = m_subMenu.autoDashTxt;
         this.m_dtDashCheckBox = m_subMenu.dtapDash;
         this.m_dtDashTxt = m_subMenu.dtapDashTxt;
         this.m_gamepadDropdown = m_subMenu.gamepadDropdown;
         m_subMenu.keySetter.visible = false;
         this.controlStickDashZone = Gamepad.DASHZONE_DEFAULT * 100;
         this.controlStickDeadZone = Gamepad.DEADZONE_DEFAULT * 100;
         this.cStickDashZone = Gamepad.DASHZONE_DEFAULT * 100;
         this.cStickDeadZone = Gamepad.DEADZONE_DEFAULT * 100;
         this.playNum = 1;
         this.controlsButtons = new Vector.<ControlsButton>();
         this.controlsButtons.push(new ControlsButton(m_subMenu,m_subMenu.k1,"Up","UP",this.playNum));
         this.controlsButtons.push(new ControlsButton(m_subMenu,m_subMenu.k2,"Jump","JUMP",this.playNum));
         this.controlsButtons.push(new ControlsButton(m_subMenu,m_subMenu.k3,"Pause","START",this.playNum));
         this.controlsButtons.push(new ControlsButton(m_subMenu,m_subMenu.k4,"Grab","GRAB",this.playNum));
         this.controlsButtons.push(new ControlsButton(m_subMenu,m_subMenu.k5,"Shield","SHIELD",this.playNum));
         this.controlsButtons.push(new ControlsButton(m_subMenu,m_subMenu.k6,"Left","LEFT",this.playNum));
         this.controlsButtons.push(new ControlsButton(m_subMenu,m_subMenu.k7,"Right","RIGHT",this.playNum));
         this.controlsButtons.push(new ControlsButton(m_subMenu,m_subMenu.k8,"Taunt","TAUNT",this.playNum));
         this.controlsButtons.push(new ControlsButton(m_subMenu,m_subMenu.k9,"Standard Attack","BUTTON2",this.playNum));
         this.controlsButtons.push(new ControlsButton(m_subMenu,m_subMenu.k10,"Down","DOWN",this.playNum));
         this.controlsButtons.push(new ControlsButton(m_subMenu,m_subMenu.k11,"Special Attack","BUTTON1",this.playNum));
         this.controlsButtons.push(new ControlsButton(m_subMenu,m_subMenu.k12,"Jump","JUMP2",this.playNum));
         this.controlsButtons.push(new ControlsButton(m_subMenu,m_subMenu.k13,"C-Stick Up","C_UP",this.playNum));
         this.controlsButtons.push(new ControlsButton(m_subMenu,m_subMenu.k14,"C-Stick Down","C_DOWN",this.playNum));
         this.controlsButtons.push(new ControlsButton(m_subMenu,m_subMenu.k15,"C-Stick Left","C_LEFT",this.playNum));
         this.controlsButtons.push(new ControlsButton(m_subMenu,m_subMenu.k16,"C-Stick Right","C_RIGHT",this.playNum));
         this.controlsButtons.push(new ControlsButton(m_subMenu,m_subMenu.k17,"Dash Button","DASH",this.playNum));
         this.controlsButtons.push(new ControlsButton(m_subMenu,m_subMenu.k18,"Shield Button","SHIELD2",this.playNum));
         m_subMenu.key_up.mouseEnabled = false;
         m_subMenu.key_down.mouseEnabled = false;
         m_subMenu.key_left.mouseEnabled = false;
         m_subMenu.key_right.mouseEnabled = false;
         m_subMenu.key_jump.mouseEnabled = false;
         m_subMenu.key_a.mouseEnabled = false;
         m_subMenu.key_b.mouseEnabled = false;
         m_subMenu.key_grab.mouseEnabled = false;
         m_subMenu.key_shield.mouseEnabled = false;
         m_subMenu.key_taunt.mouseEnabled = false;
         m_subMenu.key_pause.mouseEnabled = false;
         m_subMenu.key_jump2.mouseEnabled = false;
         m_subMenu.key_cup.mouseEnabled = false;
         m_subMenu.key_cdown.mouseEnabled = false;
         m_subMenu.key_cleft.mouseEnabled = false;
         m_subMenu.key_cright.mouseEnabled = false;
         m_subMenu.key_dash.mouseEnabled = false;
         m_subMenu.key_shield2.mouseEnabled = false;
         this.updateControls();
         this.updateCurrPlayer();
         m_container.addChild(m_subMenu);
         this.selectHand = new ControlsSelectHand(m_subMenu,this.controlsButtons,this.back_CLICK);
         this.selectHand.addClickEventClipCheckBounds(m_subMenu.p1Controls_btn);
         this.selectHand.addClickEventClipCheckBounds(m_subMenu.p2Controls_btn);
         this.selectHand.addClickEventClipCheckBounds(m_subMenu.p3Controls_btn);
         this.selectHand.addClickEventClipCheckBounds(m_subMenu.p4Controls_btn);
         this.selectHand.addClickEventClipHitTest(m_subMenu.bg_top.back_btn);
         this.selectHand.addClickEventClipHitTest(m_subMenu.bg_top.home_btn);
         initMenuMappings();
         m_subMenu.x = Main.Width / 2;
         m_subMenu.y = Main.Height / 2;
      }
      
      private static function shortenInputID(id:String, inverse:Boolean = false) : String
      {
         if(Boolean(id.match(/AXIS_(\d+)/)))
         {
            return "AX" + id.match(/AXIS_(\d+)/)[1] + (!inverse ? "+" : "-");
         }
         if(Boolean(id.match(/BUTTON_(\d+)/)))
         {
            return "BN" + id.match(/BUTTON_(\d+)/)[1];
         }
         return id;
      }
      
      public static function getGamepadInputName(playNum:int, control:String) : String
      {
         var i:* = undefined;
         var data:Object = null;
         var results:Vector.<String> = new Vector.<String>();
         var gamepad:Gamepad = SaveData.Controllers[playNum - 1].GamepadInstance;
         var playerTag:String = Boolean(MenuController.CurrentCharacterSelectMenu) && Boolean(MenuController.CurrentCharacterSelectMenu.GameObj) ? MenuController.CurrentCharacterSelectMenu.GameObj.PlayerSettings[playNum - 1].name : null;
         var index:int = 0;
         for(i in gamepad.ControlState)
         {
            data = SaveData.getGamepadInputData(gamepad.Name,Boolean(playerTag) ? 0 : gamepad.Port,Boolean(playerTag) ? playerTag : "port" + gamepad.Port,i);
            index = int(data.inputs.indexOf(control));
            if(index >= 0)
            {
               results.push(ControlsMenu.shortenInputID(i));
            }
            index = int(data.inputsInverse.indexOf(control));
            if(index >= 0)
            {
               results.push(ControlsMenu.shortenInputID(i,true));
            }
         }
         return results.join(", ");
      }
      
      public function get AutoDashCheckBox() : CheckBox
      {
         return this.m_autoDashCheckBox;
      }
      
      public function get DTDashCheckBox() : CheckBox
      {
         return this.m_dtDashCheckBox;
      }
      
      public function get TapJumpCheckBox() : CheckBox
      {
         return this.m_tapJumpCheckBox;
      }
      
      override public function show() : void
      {
         this.updateControls();
         super.show();
      }
      
      override public function makeEvents() : void
      {
         var i:int = 0;
         if(m_showCount == 0)
         {
            findSubMenuButtons();
            findSpecificMenuButtons(m_subMenu.bg_top);
         }
         super.makeEvents();
         m_subMenu.p1Controls_btn.addEventListener(MouseEvent.CLICK,this.p1Controls_CLICK);
         m_subMenu.p2Controls_btn.addEventListener(MouseEvent.CLICK,this.p2Controls_CLICK);
         m_subMenu.p3Controls_btn.addEventListener(MouseEvent.CLICK,this.p3Controls_CLICK);
         m_subMenu.p4Controls_btn.addEventListener(MouseEvent.CLICK,this.p4Controls_CLICK);
         m_subMenu.p1Controls_btn.addEventListener(MouseEvent.ROLL_OVER,this.pControls_ROLL_OVER);
         m_subMenu.p2Controls_btn.addEventListener(MouseEvent.ROLL_OVER,this.pControls_ROLL_OVER);
         m_subMenu.p3Controls_btn.addEventListener(MouseEvent.ROLL_OVER,this.pControls_ROLL_OVER);
         m_subMenu.p4Controls_btn.addEventListener(MouseEvent.ROLL_OVER,this.pControls_ROLL_OVER);
         for(i = 0; i < this.controlsButtons.length; i++)
         {
            this.controlsButtons[i].makeEvents();
         }
         this.m_tapJumpCheckBox.addEventListener(Event.CHANGE,this.tapJump_CHANGE);
         this.m_autoDashCheckBox.addEventListener(Event.CHANGE,this.autoDash_CHANGE);
         this.m_dtDashCheckBox.addEventListener(Event.CHANGE,this.dtDash_CHANGE);
         m_subMenu.bg_top.back_btn.addEventListener(MouseEvent.CLICK,this.back_CLICK);
         m_subMenu.bg_top.back_btn.addEventListener(MouseEvent.ROLL_OVER,this.back_ROLL_OVER);
         m_subMenu.bg_top.home_btn.addEventListener(MouseEvent.CLICK,this.home_CLICK);
         m_subMenu.controllerConfig.addEventListener(MouseEvent.CLICK,this.gamepad_CLICK);
         this.selectHand.makeEvents();
         this.playNum = 1;
         this.setPlayer(this.playNum);
         this.extractDeadAndDashZones();
         this.updateCurrPlayer();
         this.updateControls();
         this.m_gamepadDropdown.addEventListener(Event.CHANGE,this.inputTypeChanged);
         this.redrawGamepadList();
         if(Boolean(SaveData.Controllers[this.playNum - 1].GamepadInstance))
         {
            SaveData.Controllers[this.playNum - 1].GamepadInstance.addEventListener(GamepadEvent.AXIS_CHANGED,this.onAxisChanged);
            m_subMenu.controlStickConfig.visible = true;
            m_subMenu.cStickConfig.visible = true;
         }
         else
         {
            m_subMenu.controlStickConfig.visible = false;
            m_subMenu.cStickConfig.visible = false;
         }
         m_subMenu.cStickConfig.gotoAndStop("cStick");
         m_subMenu.controlStickConfig.radiusTxt.addEventListener(Event.CHANGE,this.onControlStickRadiusChanged);
         m_subMenu.controlStickConfig.deadZoneTxt.addEventListener(Event.CHANGE,this.onControlStickDeadZoneChanged);
         m_subMenu.cStickConfig.radiusTxt.addEventListener(Event.CHANGE,this.onCStickRadiusChanged);
         m_subMenu.cStickConfig.deadZoneTxt.addEventListener(Event.CHANGE,this.onCStickDeadZoneChanged);
      }
      
      override public function killEvents() : void
      {
         super.killEvents();
         m_subMenu.p1Controls_btn.removeEventListener(MouseEvent.CLICK,this.p1Controls_CLICK);
         m_subMenu.p2Controls_btn.removeEventListener(MouseEvent.CLICK,this.p2Controls_CLICK);
         m_subMenu.p3Controls_btn.removeEventListener(MouseEvent.CLICK,this.p3Controls_CLICK);
         m_subMenu.p4Controls_btn.removeEventListener(MouseEvent.CLICK,this.p4Controls_CLICK);
         m_subMenu.p1Controls_btn.removeEventListener(MouseEvent.ROLL_OVER,this.pControls_ROLL_OVER);
         m_subMenu.p2Controls_btn.removeEventListener(MouseEvent.ROLL_OVER,this.pControls_ROLL_OVER);
         m_subMenu.p3Controls_btn.removeEventListener(MouseEvent.ROLL_OVER,this.pControls_ROLL_OVER);
         m_subMenu.p4Controls_btn.removeEventListener(MouseEvent.ROLL_OVER,this.pControls_ROLL_OVER);
         for(var i:int = 0; i < this.controlsButtons.length; i++)
         {
            this.controlsButtons[i].killEvents();
         }
         this.m_tapJumpCheckBox.removeEventListener(Event.CHANGE,this.tapJump_CHANGE);
         this.m_autoDashCheckBox.removeEventListener(Event.CHANGE,this.autoDash_CHANGE);
         this.m_dtDashCheckBox.removeEventListener(Event.CHANGE,this.dtDash_CHANGE);
         m_subMenu.bg_top.back_btn.removeEventListener(MouseEvent.CLICK,this.back_CLICK);
         m_subMenu.bg_top.back_btn.removeEventListener(MouseEvent.ROLL_OVER,this.back_ROLL_OVER);
         m_subMenu.bg_top.home_btn.removeEventListener(MouseEvent.CLICK,this.home_CLICK);
         m_subMenu.controllerConfig.removeEventListener(MouseEvent.CLICK,this.gamepad_CLICK);
         this.selectHand.killEvents();
         this.m_gamepadDropdown.removeEventListener(Event.CHANGE,this.inputTypeChanged);
         if(Boolean(SaveData.Controllers[this.playNum - 1].GamepadInstance))
         {
            SaveData.Controllers[this.playNum - 1].GamepadInstance.removeEventListener(GamepadEvent.AXIS_CHANGED,this.onAxisChanged);
         }
         m_subMenu.controlStickConfig.radiusTxt.removeEventListener(Event.CHANGE,this.onControlStickRadiusChanged);
         m_subMenu.controlStickConfig.deadZoneTxt.removeEventListener(Event.CHANGE,this.onControlStickDeadZoneChanged);
         m_subMenu.cStickConfig.radiusTxt.removeEventListener(Event.CHANGE,this.onCStickRadiusChanged);
         m_subMenu.cStickConfig.deadZoneTxt.removeEventListener(Event.CHANGE,this.onCStickDeadZoneChanged);
      }
      
      private function redrawGamepadList() : void
      {
         var alreadyChosen:Boolean = false;
         var j:int = 0;
         this.m_gamepadDropdown.removeAll();
         var gamepads:Vector.<Gamepad> = GamepadManager.getGamepads();
         this.m_gamepadDropdown.addItem({
            "label":"Keyboard",
            "gamepad":null
         });
         this.m_gamepadDropdown.selectedIndex = 0;
         for(var i:int = 0; i < gamepads.length; i++)
         {
            alreadyChosen = false;
            for(j = 0; j < SaveData.Controllers.length; j++)
            {
               if(gamepads[i] === SaveData.Controllers[j].GamepadInstance && this.playNum !== j + 1)
               {
                  alreadyChosen = true;
                  break;
               }
            }
            if(!alreadyChosen)
            {
               this.m_gamepadDropdown.addItem({
                  "label":gamepads[i].Name + " " + gamepads[i].Port,
                  "gamepad":gamepads[i]
               });
            }
            if(SaveData.Controllers[this.playNum - 1].GamepadInstance === gamepads[i])
            {
               this.m_gamepadDropdown.selectedIndex = this.m_gamepadDropdown.length - 1;
            }
         }
      }
      
      public function inputTypeChanged(e:Event) : void
      {
         var gamepad:Gamepad = this.m_gamepadDropdown.selectedItem.gamepad;
         var player:PlayerSetting = Boolean(MenuController.CurrentCharacterSelectMenu) && Boolean(MenuController.CurrentCharacterSelectMenu.GameObj) ? MenuController.CurrentCharacterSelectMenu.GameObj.PlayerSettings[this.playNum - 1] : null;
         var oldGamepad:Gamepad = SaveData.Controllers[this.playNum - 1].GamepadInstance;
         SaveData.Controllers[this.playNum - 1].GamepadInstance = gamepad;
         if(Boolean(oldGamepad))
         {
            oldGamepad.removeEventListener(GamepadEvent.AXIS_CHANGED,this.onAxisChanged);
            if(Boolean(MenuController.CurrentCharacterSelectMenu))
            {
               oldGamepad.removeEventListener(GamepadEvent.BUTTON_DOWN,MenuController.CurrentCharacterSelectMenu.onGamepadButtonPressed);
            }
         }
         if(Boolean(gamepad))
         {
            SaveData.PortInputs[this.playNum] = gamepad.Name + " " + gamepad.Port;
            SaveData.Gamepads[gamepad.Name] = SaveData.Gamepads[gamepad.Name] || {
               "names":{},
               "ports":{}
            };
            gamepad.addEventListener(GamepadEvent.AXIS_CHANGED,this.onAxisChanged);
            if(Boolean(MenuController.CurrentCharacterSelectMenu))
            {
               gamepad.addEventListener(GamepadEvent.BUTTON_DOWN,MenuController.CurrentCharacterSelectMenu.onGamepadButtonPressed);
            }
            if(Boolean(player) && Boolean(player.human) && Boolean(player.name))
            {
               SaveData.Gamepads[gamepad.Name].names[player.name] = SaveData.Gamepads[gamepad.Name].names[player.name] || {};
               SaveData.reimportNamedPlayerControls(this.playNum,player.name);
            }
            else
            {
               SaveData.Gamepads[gamepad.Name].ports["port" + gamepad.Port] = SaveData.Gamepads[gamepad.Name].ports["port" + gamepad.Port] || {};
               SaveData.reimportSlottedPlayerControls(this.playNum);
            }
            m_subMenu.controlStickConfig.visible = true;
            m_subMenu.cStickConfig.visible = true;
            this.extractDeadAndDashZones();
         }
         else
         {
            SaveData.PortInputs[this.playNum] = null;
            m_subMenu.controlStickConfig.visible = false;
            m_subMenu.cStickConfig.visible = false;
         }
         this.updateControls();
      }
      
      private function getAxisPressure(controlState:Object, direction:String) : Number
      {
         if(controlState.inputs.indexOf(direction) >= 0)
         {
            if(direction === "UP" || direction === "LEFT" || direction === "C_UP" || direction === "C_LEFT")
            {
               return -controlState.value;
            }
            if(direction === "DOWN" || direction === "RIGHT" || direction === "C_DOWN" || direction === "C_RIGHT")
            {
               return controlState.value;
            }
         }
         if(controlState.inputsInverse.indexOf(direction) >= 0)
         {
            if(direction === "UP" || direction === "LEFT" || direction === "C_UP" || direction === "C_LEFT")
            {
               return controlState.value;
            }
            if(direction === "DOWN" || direction === "RIGHT" || direction === "C_DOWN" || direction === "C_RIGHT")
            {
               return -controlState.value;
            }
         }
         return 0;
      }
      
      private function onAxisChanged(e:GamepadEvent) : void
      {
         var controlStickUp:Number = this.getAxisPressure(e.controlState,"UP");
         var controlStickDown:Number = this.getAxisPressure(e.controlState,"DOWN");
         var controlStickLeft:Number = this.getAxisPressure(e.controlState,"LEFT");
         var controlStickRight:Number = this.getAxisPressure(e.controlState,"RIGHT");
         if(Boolean(controlStickUp) || Boolean(controlStickDown) || Boolean(controlStickLeft) || Boolean(controlStickRight))
         {
            if(Boolean(controlStickUp))
            {
               m_subMenu.controlStickConfig.dot.y = controlStickUp * 20;
            }
            if(Boolean(controlStickDown))
            {
               m_subMenu.controlStickConfig.dot.y = controlStickDown * 20;
            }
            if(Boolean(controlStickLeft))
            {
               m_subMenu.controlStickConfig.dot.x = controlStickLeft * 20;
            }
            if(Boolean(controlStickRight))
            {
               m_subMenu.controlStickConfig.dot.x = controlStickRight * 20;
            }
         }
         else
         {
            m_subMenu.controlStickConfig.dot.x = 0;
            m_subMenu.controlStickConfig.dot.y = 0;
         }
         var cStickUp:Number = this.getAxisPressure(e.controlState,"C_UP");
         var cStickDown:Number = this.getAxisPressure(e.controlState,"C_DOWN");
         var cStickLeft:Number = this.getAxisPressure(e.controlState,"C_LEFT");
         var cStickRight:Number = this.getAxisPressure(e.controlState,"C_RIGHT");
         if(Boolean(cStickUp) || Boolean(cStickDown) || Boolean(cStickLeft) || Boolean(cStickRight))
         {
            if(Boolean(cStickUp))
            {
               m_subMenu.cStickConfig.dot.y = cStickUp * 20;
            }
            if(Boolean(cStickDown))
            {
               m_subMenu.cStickConfig.dot.y = cStickDown * 20;
            }
            if(Boolean(cStickLeft))
            {
               m_subMenu.cStickConfig.dot.x = cStickLeft * 20;
            }
            if(Boolean(cStickRight))
            {
               m_subMenu.cStickConfig.dot.x = cStickRight * 20;
            }
         }
         else
         {
            m_subMenu.cStickConfig.dot.x = 0;
            m_subMenu.cStickConfig.dot.y = 0;
         }
      }
      
      private function onControlStickRadiusChanged(e:Event) : void
      {
         var playerTag:String = null;
         var portType:String = null;
         var i:* = undefined;
         var data:Object = null;
         var gamepad:Gamepad = SaveData.Controllers[this.playNum - 1].GamepadInstance;
         var value:Number = parseFloat(m_subMenu.controlStickConfig.radiusTxt.text);
         if(Boolean(gamepad) && !isNaN(value))
         {
            value = Math.min(Math.max(0,value / 100),1);
            m_subMenu.controlStickConfig.radius.scaleX = value;
            m_subMenu.controlStickConfig.radius.scaleY = value;
            this.controlStickDashZone = value * 100;
            playerTag = Boolean(MenuController.CurrentCharacterSelectMenu) && Boolean(MenuController.CurrentCharacterSelectMenu.GameObj) ? MenuController.CurrentCharacterSelectMenu.GameObj.PlayerSettings[this.playNum - 1].name : null;
            portType = Boolean(playerTag) ? "names" : "ports";
            for(i in gamepad.ControlState)
            {
               if(gamepad.ControlState[i].inputs.indexOf("UP") >= 0 || gamepad.ControlState[i].inputs.indexOf("DOWN") >= 0 || gamepad.ControlState[i].inputs.indexOf("LEFT") >= 0 || gamepad.ControlState[i].inputs.indexOf("RIGHT") >= 0)
               {
                  data = SaveData.getGamepadInputData(gamepad.Name,Boolean(playerTag) ? 0 : gamepad.Port,Boolean(playerTag) ? playerTag : "port" + gamepad.Port,i);
                  data.dashZone = value;
               }
            }
            gamepad.importControls(SaveData.Gamepads[gamepad.Name][portType][playerTag || "port" + gamepad.Port]);
         }
      }
      
      private function onControlStickDeadZoneChanged(e:Event) : void
      {
         var playerTag:String = null;
         var portType:String = null;
         var i:* = undefined;
         var data:Object = null;
         var gamepad:Gamepad = SaveData.Controllers[this.playNum - 1].GamepadInstance;
         var value:Number = parseFloat(m_subMenu.controlStickConfig.deadZoneTxt.text);
         if(Boolean(gamepad) && !isNaN(value))
         {
            value = Math.min(Math.max(0,value / 100),1);
            m_subMenu.controlStickConfig.deadZone.scaleX = value;
            m_subMenu.controlStickConfig.deadZone.scaleY = value;
            this.controlStickDeadZone = value * 100;
            playerTag = Boolean(MenuController.CurrentCharacterSelectMenu) && Boolean(MenuController.CurrentCharacterSelectMenu.GameObj) ? MenuController.CurrentCharacterSelectMenu.GameObj.PlayerSettings[this.playNum - 1].name : null;
            portType = Boolean(playerTag) ? "names" : "ports";
            for(i in gamepad.ControlState)
            {
               if(gamepad.ControlState[i].inputs.indexOf("UP") >= 0 || gamepad.ControlState[i].inputs.indexOf("DOWN") >= 0 || gamepad.ControlState[i].inputs.indexOf("LEFT") >= 0 || gamepad.ControlState[i].inputs.indexOf("RIGHT") >= 0)
               {
                  data = SaveData.getGamepadInputData(gamepad.Name,Boolean(playerTag) ? 0 : gamepad.Port,Boolean(playerTag) ? playerTag : "port" + gamepad.Port,i);
                  data.deadZone = value;
               }
            }
            gamepad.importControls(SaveData.Gamepads[gamepad.Name][portType][playerTag || "port" + gamepad.Port]);
         }
      }
      
      private function onCStickRadiusChanged(e:Event) : void
      {
         var playerTag:String = null;
         var portType:String = null;
         var i:* = undefined;
         var data:Object = null;
         var gamepad:Gamepad = SaveData.Controllers[this.playNum - 1].GamepadInstance;
         var value:Number = parseFloat(m_subMenu.cStickConfig.radiusTxt.text);
         if(Boolean(gamepad) && !isNaN(value))
         {
            value = Math.min(Math.max(0,value / 100),1);
            m_subMenu.cStickConfig.radius.scaleX = value;
            m_subMenu.cStickConfig.radius.scaleY = value;
            this.cStickDashZone = value * 100;
            playerTag = Boolean(MenuController.CurrentCharacterSelectMenu) && Boolean(MenuController.CurrentCharacterSelectMenu.GameObj) ? MenuController.CurrentCharacterSelectMenu.GameObj.PlayerSettings[this.playNum - 1].name : null;
            portType = Boolean(playerTag) ? "names" : "ports";
            for(i in gamepad.ControlState)
            {
               if(gamepad.ControlState[i].inputs.indexOf("C_UP") >= 0 || gamepad.ControlState[i].inputs.indexOf("C_DOWN") >= 0 || gamepad.ControlState[i].inputs.indexOf("C_LEFT") >= 0 || gamepad.ControlState[i].inputs.indexOf("C_RIGHT") >= 0)
               {
                  data = SaveData.getGamepadInputData(gamepad.Name,Boolean(playerTag) ? 0 : gamepad.Port,Boolean(playerTag) ? playerTag : "port" + gamepad.Port,i);
                  data.dashZone = value;
               }
            }
            gamepad.importControls(SaveData.Gamepads[gamepad.Name][portType][playerTag || "port" + gamepad.Port]);
         }
      }
      
      private function onCStickDeadZoneChanged(e:Event) : void
      {
         var playerTag:String = null;
         var portType:String = null;
         var i:* = undefined;
         var data:Object = null;
         var gamepad:Gamepad = SaveData.Controllers[this.playNum - 1].GamepadInstance;
         var value:Number = parseFloat(m_subMenu.cStickConfig.deadZoneTxt.text);
         if(Boolean(gamepad) && !isNaN(value))
         {
            value = Math.min(Math.max(0,value / 100),1);
            m_subMenu.cStickConfig.deadZone.scaleX = value;
            m_subMenu.cStickConfig.deadZone.scaleY = value;
            this.cStickDeadZone = value * 100;
            playerTag = Boolean(MenuController.CurrentCharacterSelectMenu) && Boolean(MenuController.CurrentCharacterSelectMenu.GameObj) ? MenuController.CurrentCharacterSelectMenu.GameObj.PlayerSettings[this.playNum - 1].name : null;
            portType = Boolean(playerTag) ? "names" : "ports";
            for(i in gamepad.ControlState)
            {
               if(gamepad.ControlState[i].inputs.indexOf("C_UP") >= 0 || gamepad.ControlState[i].inputs.indexOf("C_DOWN") >= 0 || gamepad.ControlState[i].inputs.indexOf("C_LEFT") >= 0 || gamepad.ControlState[i].inputs.indexOf("C_RIGHT") >= 0)
               {
                  data = SaveData.getGamepadInputData(gamepad.Name,Boolean(playerTag) ? 0 : gamepad.Port,Boolean(playerTag) ? playerTag : "port" + gamepad.Port,i);
                  data.deadZone = value;
               }
            }
            gamepad.importControls(SaveData.Gamepads[gamepad.Name][portType][playerTag || "port" + gamepad.Port]);
         }
      }
      
      public function updateControls() : void
      {
         var controller:Controller = SaveData.Controllers[this.playNum - 1];
         if(Boolean(controller.GamepadInstance))
         {
            m_subMenu.key_up.text = ControlsMenu.getGamepadInputName(this.playNum,controller._UP);
            m_subMenu.key_down.text = ControlsMenu.getGamepadInputName(this.playNum,controller._DOWN);
            m_subMenu.key_left.text = ControlsMenu.getGamepadInputName(this.playNum,controller._LEFT);
            m_subMenu.key_right.text = ControlsMenu.getGamepadInputName(this.playNum,controller._RIGHT);
            m_subMenu.key_jump.text = ControlsMenu.getGamepadInputName(this.playNum,controller._JUMP);
            m_subMenu.key_a.text = ControlsMenu.getGamepadInputName(this.playNum,controller._BUTTON2);
            m_subMenu.key_b.text = ControlsMenu.getGamepadInputName(this.playNum,controller._BUTTON1);
            m_subMenu.key_grab.text = ControlsMenu.getGamepadInputName(this.playNum,controller._GRAB);
            m_subMenu.key_shield.text = ControlsMenu.getGamepadInputName(this.playNum,controller._SHIELD);
            m_subMenu.key_taunt.text = ControlsMenu.getGamepadInputName(this.playNum,controller._TAUNT);
            m_subMenu.key_pause.text = ControlsMenu.getGamepadInputName(this.playNum,controller._START);
            m_subMenu.key_jump2.text = ControlsMenu.getGamepadInputName(this.playNum,controller._JUMP2);
            m_subMenu.key_cup.text = ControlsMenu.getGamepadInputName(this.playNum,controller._C_UP);
            m_subMenu.key_cdown.text = ControlsMenu.getGamepadInputName(this.playNum,controller._C_DOWN);
            m_subMenu.key_cleft.text = ControlsMenu.getGamepadInputName(this.playNum,controller._C_LEFT);
            m_subMenu.key_cright.text = ControlsMenu.getGamepadInputName(this.playNum,controller._C_RIGHT);
            m_subMenu.key_dash.text = ControlsMenu.getGamepadInputName(this.playNum,controller._DASH);
            m_subMenu.key_shield2.text = ControlsMenu.getGamepadInputName(this.playNum,controller._SHIELD2);
            m_subMenu.controlStickConfig.visible = true;
            m_subMenu.cStickConfig.visible = true;
            if(isNaN(this.controlStickDashZone))
            {
               trace(this.controlStickDashZone);
            }
            m_subMenu.controlStickConfig.radiusTxt.text = this.controlStickDashZone;
            m_subMenu.controlStickConfig.deadZoneTxt.text = this.controlStickDeadZone;
            m_subMenu.cStickConfig.radiusTxt.text = this.cStickDashZone;
            m_subMenu.cStickConfig.deadZoneTxt.text = this.cStickDeadZone;
            controller.GamepadInstance.ControlsMap["TAP_JUMP"] = controller._TAP_JUMP;
            controller.GamepadInstance.ControlsMap["AUTO_DASH"] = controller._AUTO_DASH;
            controller.GamepadInstance.ControlsMap["DT_DASH"] = controller._DT_DASH;
         }
         else
         {
            m_subMenu.key_up.text = Utils.KEY_ARR_SHORT[controller.KeyboardInstance.ControlsMap[controller._UP]];
            m_subMenu.key_down.text = Utils.KEY_ARR_SHORT[controller.KeyboardInstance.ControlsMap[controller._DOWN]];
            m_subMenu.key_left.text = Utils.KEY_ARR_SHORT[controller.KeyboardInstance.ControlsMap[controller._LEFT]];
            m_subMenu.key_right.text = Utils.KEY_ARR_SHORT[controller.KeyboardInstance.ControlsMap[controller._RIGHT]];
            m_subMenu.key_jump.text = Utils.KEY_ARR_SHORT[controller.KeyboardInstance.ControlsMap[controller._JUMP]];
            m_subMenu.key_a.text = Utils.KEY_ARR_SHORT[controller.KeyboardInstance.ControlsMap[controller._BUTTON2]];
            m_subMenu.key_b.text = Utils.KEY_ARR_SHORT[controller.KeyboardInstance.ControlsMap[controller._BUTTON1]];
            m_subMenu.key_grab.text = Utils.KEY_ARR_SHORT[controller.KeyboardInstance.ControlsMap[controller._GRAB]];
            m_subMenu.key_shield.text = Utils.KEY_ARR_SHORT[controller.KeyboardInstance.ControlsMap[controller._SHIELD]];
            m_subMenu.key_taunt.text = Utils.KEY_ARR_SHORT[controller.KeyboardInstance.ControlsMap[controller._TAUNT]];
            m_subMenu.key_pause.text = Utils.KEY_ARR_SHORT[controller.KeyboardInstance.ControlsMap[controller._START]];
            m_subMenu.key_jump2.text = Utils.KEY_ARR_SHORT[controller.KeyboardInstance.ControlsMap[controller._JUMP2]];
            m_subMenu.key_cup.text = Utils.KEY_ARR_SHORT[controller.KeyboardInstance.ControlsMap[controller._C_UP]];
            m_subMenu.key_cdown.text = Utils.KEY_ARR_SHORT[controller.KeyboardInstance.ControlsMap[controller._C_DOWN]];
            m_subMenu.key_cleft.text = Utils.KEY_ARR_SHORT[controller.KeyboardInstance.ControlsMap[controller._C_LEFT]];
            m_subMenu.key_cright.text = Utils.KEY_ARR_SHORT[controller.KeyboardInstance.ControlsMap[controller._C_RIGHT]];
            m_subMenu.key_dash.text = Utils.KEY_ARR_SHORT[controller.KeyboardInstance.ControlsMap[controller._DASH]];
            m_subMenu.key_shield2.text = Utils.KEY_ARR_SHORT[controller.KeyboardInstance.ControlsMap[controller._SHIELD2]];
            m_subMenu.controlStickConfig.visible = false;
            m_subMenu.cStickConfig.visible = false;
         }
         this.m_tapJumpCheckBox.selected = controller._TAP_JUMP == 1;
         this.m_autoDashCheckBox.selected = controller._AUTO_DASH == 1;
         this.m_dtDashCheckBox.selected = controller._DT_DASH == 1;
         if(this.m_autoDashCheckBox.selected)
         {
            this.m_dtDashCheckBox.selected = false;
            this.m_dtDashCheckBox.enabled = false;
            this.m_dtDashTxt.alpha = 0.5;
            controller._DT_DASH = 0;
         }
         else
         {
            this.m_dtDashTxt.alpha = 1;
            this.m_dtDashCheckBox.enabled = true;
         }
         m_subMenu.t17.text = this.m_autoDashCheckBox.selected ? "WALK" : "DASH";
         this.updateDefaultData();
         this.updateNameData();
         this.redrawGamepadList();
      }
      
      private function gamepad_CLICK(e:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_select");
         removeSelf();
         MenuController.gamepadMenu.show();
      }
      
      private function back_CLICK(e:MouseEvent) : void
      {
         var i:int = 0;
         if(MenuController.CurrentCharacterSelectMenu != null && Boolean(MenuController.CurrentCharacterSelectMenu.GameObj))
         {
            for(i = 0; i < MenuController.CurrentCharacterSelectMenu.PlayerChips.length; i++)
            {
               MenuController.CurrentCharacterSelectMenu.PlayerChips[i].resetLetGo();
            }
         }
         this.updateControls();
         SaveData.saveGame();
         SoundQueue.instance.playSoundEffect("menu_back");
         if(Boolean(MenuController.CurrentCharacterSelectMenu) && MenuController.CurrentCharacterSelectMenu.isOnscreen())
         {
            removeSelf();
         }
         else if(Boolean(MenuController.groupMenu) && MenuController.groupMenu.isOnscreen())
         {
            removeSelf();
         }
         else if(Boolean(MenuController.rulesMenu) && MenuController.rulesMenu.isOnscreen())
         {
            removeSelf();
         }
         else
         {
            removeSelf();
            MenuController.optionsMenu.show();
         }
      }
      
      private function back_ROLL_OVER(e:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
      }
      
      private function pControls_ROLL_OVER(e:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
      }
      
      private function p1Controls_CLICK(e:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_select");
         this.playNum = 1;
         this.setPlayer(this.playNum);
         this.extractDeadAndDashZones();
         this.updateCurrPlayer();
         this.updateControls();
      }
      
      private function p2Controls_CLICK(e:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_select");
         this.playNum = 2;
         this.setPlayer(this.playNum);
         this.extractDeadAndDashZones();
         this.updateCurrPlayer();
         this.updateControls();
      }
      
      private function p3Controls_CLICK(e:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_select");
         this.playNum = 3;
         this.setPlayer(this.playNum);
         this.updateCurrPlayer();
         this.extractDeadAndDashZones();
         this.updateControls();
      }
      
      private function extractDeadAndDashZones() : void
      {
         var i:* = undefined;
         var gamepad:Gamepad = SaveData.Controllers[this.playNum - 1].GamepadInstance;
         if(Boolean(gamepad))
         {
            for(i in gamepad.ControlState)
            {
               if(gamepad.ControlState[i].inputs.indexOf("UP") >= 0 || gamepad.ControlState[i].inputs.indexOf("DOWN") >= 0 || gamepad.ControlState[i].inputs.indexOf("LEFT") >= 0 || gamepad.ControlState[i].inputs.indexOf("RIGHT") >= 0)
               {
                  this.controlStickDashZone = gamepad.ControlState[i].dashZone * 100;
                  this.controlStickDeadZone = gamepad.ControlState[i].deadZone * 100;
                  break;
               }
            }
            for(i in gamepad.ControlState)
            {
               if(gamepad.ControlState[i].inputs.indexOf("C_UP") >= 0 || gamepad.ControlState[i].inputs.indexOf("C_DOWN") >= 0 || gamepad.ControlState[i].inputs.indexOf("C_LEFT") >= 0 || gamepad.ControlState[i].inputs.indexOf("C_RIGHT") >= 0)
               {
                  this.cStickDashZone = gamepad.ControlState[i].dashZone * 100;
                  this.cStickDeadZone = gamepad.ControlState[i].deadZone * 100;
                  break;
               }
            }
         }
      }
      
      private function p4Controls_CLICK(e:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_select");
         this.playNum = 4;
         this.setPlayer(this.playNum);
         this.extractDeadAndDashZones();
         this.updateCurrPlayer();
         this.updateControls();
      }
      
      private function setPlayer(num:int) : void
      {
         var cb:ControlsButton = null;
         var i:int = 0;
         for(i = 0; i < this.controlsButtons.length; i++)
         {
            cb = this.controlsButtons[i];
            cb.setPlayer(num);
         }
      }
      
      private function updateCurrPlayer() : void
      {
         m_subMenu.p1Controls_btn.bnshadow.visible = this.playNum != 1;
         m_subMenu.p2Controls_btn.bnshadow.visible = this.playNum != 2;
         m_subMenu.p3Controls_btn.bnshadow.visible = this.playNum != 3;
         m_subMenu.p4Controls_btn.bnshadow.visible = this.playNum != 4;
      }
      
      private function updateDefaultData() : void
      {
         var gamepad:Gamepad = null;
         var player:PlayerSetting = null;
         for(var i:int = 1; i <= SaveData.Controllers.length; i++)
         {
            gamepad = SaveData.Controllers[i - 1].GamepadInstance;
            if(Boolean(gamepad && MenuController.CurrentCharacterSelectMenu && MenuController.CurrentCharacterSelectMenu.GameObj && i - 1 < MenuController.CurrentCharacterSelectMenu.GameObj.PlayerSettings.length) && Boolean(MenuController.CurrentCharacterSelectMenu.GameObj.PlayerSettings[i - 1].human) && Boolean(MenuController.CurrentCharacterSelectMenu.GameObj.PlayerSettings[i - 1].name))
            {
               player = MenuController.CurrentCharacterSelectMenu.GameObj.PlayerSettings[i - 1];
               SaveData.Gamepads[gamepad.Name].names[player.name].TAP_JUMP = SaveData.Controllers[i - 1]._TAP_JUMP;
               SaveData.Gamepads[gamepad.Name].names[player.name].DT_DASH = SaveData.Controllers[i - 1]._DT_DASH;
               SaveData.Gamepads[gamepad.Name].names[player.name].AUTO_DASH = SaveData.Controllers[i - 1]._AUTO_DASH;
               gamepad.importControls(SaveData.Gamepads[gamepad.Name].names[player.name]);
            }
            else
            {
               SaveData.ControlSettings["player" + i] = SaveData.Controllers[i - 1].getControls();
            }
         }
      }
      
      private function updateNameData() : void
      {
         var _loc2_:Object = null;
      }
      
      private function tapJump_CHANGE(e:Event) : void
      {
         SaveData.Controllers[this.playNum - 1]._TAP_JUMP = this.m_tapJumpCheckBox.selected ? 1 : 0;
         Main.fixFocus();
      }
      
      private function autoDash_CHANGE(e:Event) : void
      {
         SaveData.Controllers[this.playNum - 1]._AUTO_DASH = this.m_autoDashCheckBox.selected ? 1 : 0;
         if(this.m_autoDashCheckBox.selected)
         {
            this.m_dtDashCheckBox.selected = false;
            this.m_dtDashCheckBox.enabled = false;
            this.m_dtDashTxt.alpha = 0.5;
            SaveData.Controllers[this.playNum - 1]._DT_DASH = 0;
         }
         else
         {
            this.m_dtDashTxt.alpha = 1;
            this.m_dtDashCheckBox.enabled = true;
         }
         m_subMenu.t17.text = this.m_autoDashCheckBox.selected ? "WALK" : "DASH";
         Main.fixFocus();
      }
      
      private function dtDash_CHANGE(e:Event) : void
      {
         SaveData.Controllers[this.playNum - 1]._DT_DASH = this.m_dtDashCheckBox.selected ? 1 : 0;
         Main.fixFocus();
      }
      
      private function home_CLICK(e:MouseEvent) : void
      {
         if(MultiplayerManager.Connected)
         {
            MultiplayerManager.disconnect();
         }
         SoundQueue.instance.playSoundEffect("menu_back");
         SoundQueue.instance.stopMusic();
         if(Boolean(MenuController.CurrentCharacterSelectMenu))
         {
            MenuController.CurrentCharacterSelectMenu.resetScreen();
         }
         GameController.currentGame = null;
         MenuController.disposeAllMenus(true);
         MenuController.titleMenu.show();
      }
   }
}

