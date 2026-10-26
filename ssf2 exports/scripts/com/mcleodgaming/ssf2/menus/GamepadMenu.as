package com.mcleodgaming.ssf2.menus
{
   import com.mcleodgaming.ssf2.Main;
   import com.mcleodgaming.ssf2.audio.*;
   import com.mcleodgaming.ssf2.controllers.*;
   import com.mcleodgaming.ssf2.events.GamepadEvent;
   import com.mcleodgaming.ssf2.input.Gamepad;
   import com.mcleodgaming.ssf2.input.GamepadManager;
   import com.mcleodgaming.ssf2.util.*;
   import fl.controls.ComboBox;
   import fl.controls.Slider;
   import fl.events.SliderEvent;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class GamepadMenu extends Menu
   {
      
      private var selectHand:SelectHand;
      
      private var m_userDropdown:ComboBox;
      
      private var m_gamepadDropdown:ComboBox;
      
      private var m_selectedDropdown:ComboBox;
      
      private var m_deadZoneDropdown:ComboBox;
      
      private var m_deadZoneSlider:Slider;
      
      private var m_dashZoneSlider:Slider;
      
      private var m_deadZoneText:TextField;
      
      private var m_dashZoneText:TextField;
      
      private var m_axisValueText:TextField;
      
      private var m_currentDeadZoneID:String;
      
      private var m_activeGamepads:Vector.<Gamepad>;
      
      private var m_buttonDropdowns:Vector.<MovieClip>;
      
      private var m_inputs:Array;
      
      private var m_currentGamepad:String;
      
      private var m_currentPortType:String;
      
      private var m_currentPortName:String;
      
      public function GamepadMenu()
      {
         super();
         m_subMenu = ResourceManager.getLibraryMC("menu_gamepad");
         m_backgroundID = "space";
         m_container.addChild(m_subMenu);
         m_subMenu.x = Main.Width / 2;
         m_subMenu.y = Main.Height / 2;
         this.m_userDropdown = m_subMenu.userDropdown;
         this.m_gamepadDropdown = m_subMenu.gamepadDropdown;
         this.m_deadZoneDropdown = m_subMenu.deadZoneDropdown;
         this.m_deadZoneSlider = m_subMenu.deadZoneSlider;
         this.m_dashZoneSlider = m_subMenu.dashZoneSlider;
         this.m_deadZoneText = m_subMenu.deadZoneText;
         this.m_dashZoneText = m_subMenu.dashZoneText;
         this.m_axisValueText = m_subMenu.axisValueText;
         this.m_axisValueText.text = "0";
         this.m_currentDeadZoneID = null;
         var buttons:Vector.<HandButton> = new Vector.<HandButton>();
         this.m_activeGamepads = new Vector.<Gamepad>();
         this.m_buttonDropdowns = new Vector.<MovieClip>();
         this.m_currentGamepad = null;
         this.m_currentPortType = null;
         this.m_currentPortName = null;
         this.m_inputs = [];
         this.m_inputs.push({
            "label":"Up",
            "id":"UP"
         });
         this.m_inputs.push({
            "label":"Down",
            "id":"DOWN"
         });
         this.m_inputs.push({
            "label":"Left",
            "id":"LEFT"
         });
         this.m_inputs.push({
            "label":"Right",
            "id":"RIGHT"
         });
         this.m_inputs.push({
            "label":"Jump 1",
            "id":"JUMP"
         });
         this.m_inputs.push({
            "label":"Jump 2",
            "id":"JUMP2"
         });
         this.m_inputs.push({
            "label":"A Attack",
            "id":"BUTTON2"
         });
         this.m_inputs.push({
            "label":"B Attack",
            "id":"BUTTON1"
         });
         this.m_inputs.push({
            "label":"Grab",
            "id":"GRAB"
         });
         this.m_inputs.push({
            "label":"Shield 1",
            "id":"SHIELD"
         });
         this.m_inputs.push({
            "label":"Shield 2",
            "id":"SHIELD2"
         });
         this.m_inputs.push({
            "label":"Taunt",
            "id":"TAUNT"
         });
         this.m_inputs.push({
            "label":"C-Stick Up",
            "id":"C_UP"
         });
         this.m_inputs.push({
            "label":"C-Stick Down",
            "id":"C_DOWN"
         });
         this.m_inputs.push({
            "label":"C-Stick Left",
            "id":"C_LEFT"
         });
         this.m_inputs.push({
            "label":"C-Stick Right",
            "id":"C_RIGHT"
         });
         this.m_inputs.push({
            "label":"Pause",
            "id":"START"
         });
         this.m_inputs.push({
            "label":"Dash Button",
            "id":"DASH"
         });
      }
      
      override public function makeEvents() : void
      {
         var i:int = 0;
         var player:PlayerSetting = null;
         if(m_showCount == 0)
         {
            findSubMenuButtons();
            findSpecificMenuButtons(m_subMenu.bg_top);
         }
         super.makeEvents();
         resetAllButtons();
         m_subMenu.bg_top.back_btn.addEventListener(MouseEvent.CLICK,this.back_CLICK);
         m_subMenu.bg_top.back_btn.addEventListener(MouseEvent.MOUSE_OVER,this.back_ROLL_OVER);
         m_subMenu.bg_top.home_btn.addEventListener(MouseEvent.CLICK,this.home_CLICK);
         Main.Root.stage.addEventListener(Event.ENTER_FRAME,manageMenuMappings);
         this.m_gamepadDropdown.removeAll();
         var gamepads:Vector.<Gamepad> = GamepadManager.getGamepads();
         this.m_gamepadDropdown.addItem({
            "label":"Choose gamepad",
            "gamepad":null
         });
         this.m_gamepadDropdown.selectedIndex = 0;
         var gamepadTypeHash:Object = {};
         for(i = 0; i < gamepads.length; i++)
         {
            if(!gamepadTypeHash[gamepads[i].Name])
            {
               gamepadTypeHash[gamepads[i].Name] = true;
               this.m_gamepadDropdown.addItem({
                  "label":gamepads[i].Name,
                  "gamepad":gamepads[i]
               });
               if(!SaveData.Gamepads[gamepads[i].Name])
               {
                  SaveData.Gamepads[gamepads[i].Name] = {
                     "names":{},
                     "ports":{}
                  };
               }
            }
         }
         this.m_gamepadDropdown.addEventListener(Event.CHANGE,this.gamepadChanged);
         this.m_deadZoneDropdown.addEventListener(Event.CHANGE,this.deadZoneChanged);
         this.m_deadZoneText.addEventListener(Event.CHANGE,this.deadZoneTextChanged);
         this.m_dashZoneText.addEventListener(Event.CHANGE,this.dashZoneTextChanged);
         this.m_deadZoneSlider.addEventListener(SliderEvent.CHANGE,this.deadZoneSliderChanged);
         this.m_dashZoneSlider.addEventListener(SliderEvent.CHANGE,this.dashZoneSliderChanged);
         this.m_userDropdown.removeAll();
         for(i = 0; i < Main.MAXPLAYERS; i++)
         {
            this.m_userDropdown.addItem({
               "label":"Port " + (i + 1),
               "port":i + 1
            });
         }
         if(Boolean(MenuController.CurrentCharacterSelectMenu) && Boolean(MenuController.CurrentCharacterSelectMenu.GameObj))
         {
            player = MenuController.CurrentCharacterSelectMenu.GameObj.PlayerSettings[MenuController.controlsMenu.playNum - 1];
            if(Boolean(player))
            {
               if(player.human && Boolean(player.name))
               {
                  this.m_userDropdown.addItem({
                     "label":player.name,
                     "playerSetting":player
                  });
                  this.m_userDropdown.selectedIndex = this.m_userDropdown.length - 1;
               }
               else
               {
                  this.m_userDropdown.selectedIndex = MenuController.controlsMenu.playNum - 1;
               }
            }
         }
         this.m_userDropdown.addEventListener(Event.CHANGE,this.userChanged);
         this.gamepadChanged();
      }
      
      override public function killEvents() : void
      {
         super.killEvents();
         m_subMenu.bg_top.back_btn.removeEventListener(MouseEvent.CLICK,this.back_CLICK);
         m_subMenu.bg_top.back_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.back_ROLL_OVER);
         m_subMenu.bg_top.home_btn.removeEventListener(MouseEvent.CLICK,this.home_CLICK);
         this.m_gamepadDropdown.removeEventListener(Event.CHANGE,this.gamepadChanged);
         this.m_deadZoneText.removeEventListener(Event.CHANGE,this.deadZoneTextChanged);
         this.m_dashZoneText.removeEventListener(Event.CHANGE,this.dashZoneTextChanged);
         this.m_deadZoneSlider.removeEventListener(SliderEvent.CHANGE,this.deadZoneSliderChanged);
         this.m_dashZoneSlider.removeEventListener(SliderEvent.CHANGE,this.dashZoneSliderChanged);
         Main.Root.stage.removeEventListener(Event.ENTER_FRAME,manageMenuMappings);
         MenuController.controlsMenu.inputTypeChanged(null);
      }
      
      private function getInputData(input:String) : Object
      {
         SaveData.Gamepads[this.m_currentGamepad][this.m_currentPortType][this.m_currentPortName][input] = SaveData.Gamepads[this.m_currentGamepad][this.m_currentPortType][this.m_currentPortName][input] || {
            "inputs":[],
            "inputsInverse":[],
            "deadZone":Gamepad.DEADZONE_DEFAULT,
            "dashZone":Gamepad.DASHZONE_DEFAULT
         };
         return SaveData.Gamepads[this.m_currentGamepad][this.m_currentPortType][this.m_currentPortName][input];
      }
      
      private function setInput(input:String, control:String, inversed:Boolean) : void
      {
         this.unsetInput(input,control);
         var data:Object = this.getInputData(input);
         if(inversed)
         {
            data.inputsInverse.push(control);
         }
         else
         {
            data.inputs.push(control);
         }
         this.updateNamedPlayers();
      }
      
      private function unsetInput(input:String, control:String) : void
      {
         var index:int = 0;
         var data:Object = this.getInputData(input);
         index = int(data.inputs.indexOf(control));
         if(index >= 0)
         {
            data.inputs.splice(index,1);
         }
         index = int(data.inputsInverse.indexOf(control));
         if(index >= 0)
         {
            data.inputsInverse.splice(index,1);
         }
         this.updateNamedPlayers();
      }
      
      private function updateNamedPlayers() : void
      {
         var game:Game = null;
         var i:int = 0;
         if(Boolean(this.m_currentPortType === "names") && Boolean(MenuController.CurrentCharacterSelectMenu) && Boolean(MenuController.CurrentCharacterSelectMenu.GameObj))
         {
            game = MenuController.CurrentCharacterSelectMenu.GameObj;
            for(i = 0; i < game.PlayerSettings.length; i++)
            {
               if(game.PlayerSettings[i].name === this.m_currentPortName)
               {
                  SaveData.reimportNamedPlayerControls(i + 1,game.PlayerSettings[i].name);
               }
            }
         }
      }
      
      private function gamepadChanged(e:Event = null) : void
      {
         var i:int = 0;
         var mc:MovieClip = null;
         while(this.m_buttonDropdowns.length > 0)
         {
            this.m_buttonDropdowns[0].removeEventListener(Event.CHANGE,this.onInputDropdownChanged);
            this.m_buttonDropdowns[0].parent.removeChild(this.m_buttonDropdowns[0]);
            this.m_buttonDropdowns.splice(0,1);
         }
         while(this.m_deadZoneDropdown.length > 0)
         {
            this.m_deadZoneDropdown.removeAll();
         }
         if(!this.m_gamepadDropdown.selectedItem.gamepad)
         {
            return;
         }
         this.m_currentGamepad = this.m_gamepadDropdown.selectedItem.gamepad.Name;
         this.m_currentPortType = Boolean(this.m_userDropdown.selectedItem.playerSetting) && Boolean(this.m_userDropdown.selectedItem.playerSetting.name) ? "names" : "ports";
         this.m_currentPortName = this.m_currentPortType === "names" ? this.m_userDropdown.selectedItem.playerSetting.name : "port" + this.m_userDropdown.selectedItem.port;
         SaveData.Gamepads[this.m_currentGamepad] = SaveData.Gamepads[this.m_currentGamepad] || {
            "names":{},
            "ports":{}
         };
         SaveData.Gamepads[this.m_currentGamepad][this.m_currentPortType][this.m_currentPortName] = SaveData.Gamepads[this.m_currentGamepad][this.m_currentPortType][this.m_currentPortName] || {};
         for(i = 0; i < this.m_activeGamepads.length; i++)
         {
            this.m_activeGamepads[i].removeEventListener(GamepadEvent.AXIS_CHANGED,this.onDeadZoneAxisChanged);
         }
         this.m_activeGamepads.splice(0,this.m_activeGamepads.length);
         var gamepads:Vector.<Gamepad> = GamepadManager.getGamepads();
         for(i = 0; i < gamepads.length; i++)
         {
            if(gamepads[i].Name === this.m_gamepadDropdown.selectedItem.gamepad.Name)
            {
               this.m_activeGamepads.push(gamepads[i]);
            }
         }
         this.m_deadZoneDropdown.addItem({"label":""});
         for(i = 0; i < this.m_activeGamepads[0].ControlsList.length; i++)
         {
            if(this.m_activeGamepads[0].ControlsList[i].type === "axis")
            {
               this.m_deadZoneDropdown.addItem({
                  "label":this.m_activeGamepads[0].ControlsList[i].id.replace(/_/g," "),
                  "id":this.m_activeGamepads[0].ControlsList[i].id
               });
            }
         }
         this.m_deadZoneSlider.value = 0;
         this.m_deadZoneText.text = "";
         this.m_dashZoneText.text = "";
         var mc_x:int = -300;
         var mc_y:int = -70;
         for(var k:int = 0; k < this.m_inputs.length; k++)
         {
            mc = ResourceManager.getLibraryMC("ControlInputSelection");
            mc.id = this.m_inputs[k].id;
            mc.actionText.text = this.m_inputs[k].label;
            mc.buttonDropdown.addItem({
               "label":"-",
               "controls":null,
               "previous":null
            });
            for(i = 0; i < this.m_activeGamepads[0].ControlsList.length; i++)
            {
               if(this.m_activeGamepads[0].ControlsList[i].type === "axis")
               {
                  mc.buttonDropdown.addItem({
                     "label":this.m_activeGamepads[0].ControlsList[i].id.replace(/_/g," ") + "-",
                     "controls":this.m_activeGamepads[0].ControlsList[i],
                     "input":this.m_inputs[k],
                     "inverse":true
                  });
                  if(this.getInputData(this.m_activeGamepads[0].ControlsList[i].id).inputsInverse.indexOf(this.m_inputs[k].id) >= 0)
                  {
                     mc.buttonDropdown.selectedIndex = mc.buttonDropdown.length - 1;
                  }
                  mc.buttonDropdown.addItem({
                     "label":this.m_activeGamepads[0].ControlsList[i].id.replace(/_/g," ") + "+",
                     "controls":this.m_activeGamepads[0].ControlsList[i],
                     "input":this.m_inputs[k],
                     "inverse":false
                  });
                  if(this.getInputData(this.m_activeGamepads[0].ControlsList[i].id).inputs.indexOf(this.m_inputs[k].id) >= 0)
                  {
                     mc.buttonDropdown.selectedIndex = mc.buttonDropdown.length - 1;
                  }
               }
               else
               {
                  mc.buttonDropdown.addItem({
                     "label":this.m_activeGamepads[0].ControlsList[i].id,
                     "controls":this.m_activeGamepads[0].ControlsList[i],
                     "input":this.m_inputs[k],
                     "inverse":false
                  });
                  if(this.getInputData(this.m_activeGamepads[0].ControlsList[i].id).inputs.indexOf(this.m_inputs[k].id) >= 0)
                  {
                     mc.buttonDropdown.selectedIndex = mc.buttonDropdown.length - 1;
                  }
               }
               if(mc.buttonDropdown.selectedIndex >= 0)
               {
                  mc.buttonDropdown.getItemAt(0).previous = mc.buttonDropdown.selectedItem;
               }
            }
            mc.buttonDropdown.addEventListener(Event.CHANGE,this.onInputDropdownChanged);
            mc.buttonDropdown.addEventListener(Event.OPEN,this.openDropdown);
            mc.buttonDropdown.addEventListener(Event.CLOSE,this.closeDropdown);
            mc.x = mc_x;
            mc.y = mc_y;
            mc_y += 30;
            if(mc_y > 130)
            {
               mc_x += 200;
               mc_y = -70;
            }
            m_subMenu.addChild(mc);
            this.m_buttonDropdowns.push(mc);
         }
      }
      
      private function onInputDropdownChanged(e:Event) : void
      {
         var controls:Object = e.currentTarget.selectedItem.controls;
         var input:Object = e.currentTarget.selectedItem.input;
         var inverse:Boolean = Boolean(e.currentTarget.selectedItem.inverse);
         var previous:Object = e.currentTarget.getItemAt(0).previous;
         var current:Object = null;
         if(Boolean(controls))
         {
            this.setInput(controls.id,input.id,inverse);
            current = e.currentTarget.selectedItem;
         }
         if(Boolean(previous))
         {
            this.unsetInput(previous.controls.id,previous.input.id);
         }
         e.currentTarget.getItemAt(0).previous = current;
      }
      
      private function openDropdown(e:Event) : void
      {
         this.m_selectedDropdown = e.currentTarget as ComboBox;
         for(var i:int = 0; i < this.m_activeGamepads.length; i++)
         {
            this.m_activeGamepads[i].addEventListener(GamepadEvent.BUTTON_DOWN,this.onDropdownButtonPressed);
            this.m_activeGamepads[i].addEventListener(GamepadEvent.AXIS_CHANGED,this.onDropdownAxisChanged);
         }
      }
      
      private function closeDropdown(e:Event) : void
      {
         this.m_selectedDropdown = null;
         for(var i:int = 0; i < this.m_activeGamepads.length; i++)
         {
            this.m_activeGamepads[i].removeEventListener(GamepadEvent.BUTTON_DOWN,this.onDropdownButtonPressed);
            this.m_activeGamepads[i].removeEventListener(GamepadEvent.AXIS_CHANGED,this.onDropdownAxisChanged);
         }
      }
      
      private function onDropdownButtonPressed(e:GamepadEvent) : void
      {
         var item:Object = null;
         for(var i:int = 0; i < this.m_selectedDropdown.length; i++)
         {
            item = this.m_selectedDropdown.getItemAt(i);
            if(Boolean(item.controls) && item.controls.id === e.controlState.id)
            {
               this.m_selectedDropdown.selectedIndex = i;
               this.m_selectedDropdown.dispatchEvent(new Event(Event.CHANGE));
               break;
            }
         }
         this.m_selectedDropdown.close();
      }
      
      private function onDropdownAxisChanged(e:GamepadEvent) : void
      {
         var item:Object = null;
         for(var i:int = 0; i < this.m_selectedDropdown.length; i++)
         {
            item = this.m_selectedDropdown.getItemAt(i);
            if(Boolean(item.controls) && Boolean(item.controls.id === e.controlState.id) && (Boolean(e.controlState.value < 0 && item.inverse) || Boolean(e.controlState.value > 0 && !item.inverse)))
            {
               this.m_selectedDropdown.selectedIndex = i;
               this.m_selectedDropdown.dispatchEvent(new Event(Event.CHANGE));
               break;
            }
         }
         this.m_selectedDropdown.close();
      }
      
      private function deadZoneChanged(e:Event) : void
      {
         var i:int = 0;
         for(i = 0; i < this.m_activeGamepads.length; i++)
         {
            this.m_activeGamepads[i].removeEventListener(GamepadEvent.AXIS_CHANGED,this.onDeadZoneAxisChanged);
         }
         if(!e.currentTarget.selectedItem.id)
         {
            return;
         }
         this.m_currentDeadZoneID = e.currentTarget.selectedItem.id;
         for(i = 0; i < this.m_activeGamepads.length; i++)
         {
            this.m_activeGamepads[i].addEventListener(GamepadEvent.AXIS_CHANGED,this.onDeadZoneAxisChanged);
         }
         for(i = 0; i < this.m_activeGamepads[0].ControlsList.length; i++)
         {
            if(this.m_activeGamepads[0].ControlsList[i].id === this.m_currentDeadZoneID)
            {
               this.m_deadZoneText.text = "" + this.m_activeGamepads[0].ControlsList[i].deadZone;
               this.m_deadZoneSlider.value = this.m_activeGamepads[0].ControlsList[i].deadZone * 100;
               this.m_dashZoneText.text = "" + this.m_activeGamepads[0].ControlsList[i].dashZone;
               this.m_dashZoneSlider.value = this.m_activeGamepads[0].ControlsList[i].dashZone * 100;
               break;
            }
         }
      }
      
      private function deadZoneTextChanged(e:Event) : void
      {
         var num:Number = Number((e.currentTarget as TextField).text);
         if(!isNaN(num))
         {
            this.setDeadZoneValue(num);
         }
      }
      
      private function dashZoneTextChanged(e:Event) : void
      {
         var num:Number = Number((e.currentTarget as TextField).text);
         if(!isNaN(num))
         {
            this.setDashZoneValue(num);
         }
      }
      
      private function deadZoneSliderChanged(e:Event) : void
      {
         var num:Number = (e.currentTarget as Slider).value;
         this.setDeadZoneValue(Math.round(num) / 100);
      }
      
      private function dashZoneSliderChanged(e:Event) : void
      {
         var num:Number = (e.currentTarget as Slider).value;
         this.setDashZoneValue(Math.round(num) / 100);
      }
      
      private function setDeadZoneValue(value:Number) : void
      {
         var j:int = 0;
         var i:int = 0;
         if(Boolean(this.m_currentDeadZoneID))
         {
            this.m_deadZoneText.text = "" + value;
            this.m_deadZoneSlider.value = value * 100;
            SaveData.Gamepads[this.m_currentGamepad][this.m_currentPortType][this.m_currentPortName][this.m_currentDeadZoneID].deadZone = value;
            for(j = 0; j < this.m_activeGamepads.length; j++)
            {
               for(i = 0; i < this.m_activeGamepads[j].ControlsList.length; i++)
               {
                  if(this.m_activeGamepads[j].ControlsList[i].id === this.m_currentDeadZoneID)
                  {
                     this.m_activeGamepads[j].ControlsList[i].deadZone = value;
                     break;
                  }
               }
            }
         }
      }
      
      private function setDashZoneValue(value:Number) : void
      {
         var j:int = 0;
         var i:int = 0;
         if(Boolean(this.m_currentDeadZoneID))
         {
            this.m_dashZoneText.text = "" + value;
            this.m_dashZoneSlider.value = value * 100;
            SaveData.Gamepads[this.m_currentGamepad][this.m_currentPortType][this.m_currentPortName][this.m_currentDeadZoneID].dashZone = value;
            for(j = 0; j < this.m_activeGamepads.length; j++)
            {
               for(i = 0; i < this.m_activeGamepads[j].ControlsList.length; i++)
               {
                  if(this.m_activeGamepads[j].ControlsList[i].id === this.m_currentDeadZoneID)
                  {
                     this.m_activeGamepads[j].ControlsList[i].dashZone = value;
                     break;
                  }
               }
            }
         }
      }
      
      private function onDeadZoneAxisChanged(e:GamepadEvent) : void
      {
         if(this.m_currentDeadZoneID === e.controlState.id)
         {
            this.m_axisValueText.text = "" + Math.round(e.controlState.value * 1000000) / 1000000;
            if(Utils.fastAbs(e.controlState.value) < e.controlState.deadZone)
            {
               this.m_axisValueText.textColor = 0;
               this.m_axisValueText.alpha = 0.5;
            }
            else if(Utils.fastAbs(e.controlState.value) < e.controlState.dashZone)
            {
               this.m_axisValueText.textColor = 0;
               this.m_axisValueText.alpha = 1;
            }
            else
            {
               this.m_axisValueText.textColor = 255;
               this.m_axisValueText.alpha = 1;
            }
         }
      }
      
      private function userChanged(e:Event) : void
      {
         this.gamepadChanged();
      }
      
      private function back_ROLL_OVER(e:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
      }
      
      private function back_CLICK(e:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_back");
         removeSelf();
         MenuController.controlsMenu.show();
      }
      
      private function home_CLICK(e:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_back");
         SoundQueue.instance.stopMusic();
         MenuController.disposeAllMenus(true);
         MenuController.titleMenu.show();
      }
   }
}

