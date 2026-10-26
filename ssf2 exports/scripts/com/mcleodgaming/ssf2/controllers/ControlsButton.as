package com.mcleodgaming.ssf2.controllers
{
   import com.mcleodgaming.ssf2.Main;
   import com.mcleodgaming.ssf2.audio.*;
   import com.mcleodgaming.ssf2.events.GamepadEvent;
   import com.mcleodgaming.ssf2.input.Gamepad;
   import com.mcleodgaming.ssf2.menus.*;
   import com.mcleodgaming.ssf2.util.*;
   import flash.display.MovieClip;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   
   public class ControlsButton extends HandButton
   {
      
      private var m_currentMC:MovieClip;
      
      private var m_keyVar:String;
      
      private var m_keyName:String;
      
      private var m_playerNum:Number;
      
      private var currKey:String = "";
      
      private var currKeyNum:Number = 0;
      
      public function ControlsButton(currentMC:MovieClip, button:MovieClip, kname:String, kvar:String, playerNum:Number)
      {
         super(button);
         this.m_currentMC = currentMC;
         this.m_keyName = kname;
         this.m_keyVar = kvar;
         this.m_playerNum = playerNum;
      }
      
      private function setInput(input:String, control:String, inversed:Boolean) : void
      {
         var gamepad:Gamepad = SaveData.Controllers[this.m_playerNum - 1].GamepadInstance;
         var playerTag:String = Boolean(MenuController.CurrentCharacterSelectMenu) && Boolean(MenuController.CurrentCharacterSelectMenu.GameObj) ? MenuController.CurrentCharacterSelectMenu.GameObj.PlayerSettings[this.m_playerNum - 1].name : null;
         var portType:String = Boolean(playerTag) ? "names" : "ports";
         this.unsetInput(input,control);
         var data:Object = SaveData.getGamepadInputData(gamepad.Name,Boolean(playerTag) ? 0 : gamepad.Port,Boolean(playerTag) ? playerTag : "port" + gamepad.Port,input);
         if(inversed)
         {
            data.inputsInverse.push(control);
         }
         else
         {
            data.inputs.push(control);
         }
         if(input === "UP" || input === "DOWN" || input === "LEFT" || input === "RIGHT")
         {
            data.deadZone = MenuController.controlsMenu.controlStickDeadZone / 100;
            data.dashZone = MenuController.controlsMenu.controlStickDashZone / 100;
         }
         if(input === "C_UP" || input === "C_DOWN" || input === "C_LEFT" || input === "C_RIGHT")
         {
            data.deadZone = MenuController.controlsMenu.cStickDeadZone / 100;
            data.dashZone = MenuController.controlsMenu.cStickDashZone / 100;
         }
      }
      
      private function unsetInput(input:String, control:String) : void
      {
         var index:int = 0;
         var gamepad:Gamepad = SaveData.Controllers[this.m_playerNum - 1].GamepadInstance;
         var playerTag:String = Boolean(MenuController.CurrentCharacterSelectMenu) && Boolean(MenuController.CurrentCharacterSelectMenu.GameObj) ? MenuController.CurrentCharacterSelectMenu.GameObj.PlayerSettings[this.m_playerNum - 1].name : null;
         var portType:String = Boolean(playerTag) ? "names" : "ports";
         var data:Object = SaveData.getGamepadInputData(gamepad.Name,Boolean(playerTag) ? 0 : gamepad.Port,Boolean(playerTag) ? playerTag : "port" + gamepad.Port,input);
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
         data.deadZone = Gamepad.DEADZONE_DEFAULT;
         data.dashZone = Gamepad.DASHZONE_DEFAULT;
      }
      
      public function setPlayer(num:Number) : void
      {
         this.m_playerNum = num;
      }
      
      override protected function button_ROLLOVER(e:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
         m_button.gotoAndStop("_over");
      }
      
      override protected function button_ROLLOUT(e:MouseEvent) : void
      {
         m_button.gotoAndStop("_up");
      }
      
      override protected function button_CLICK(e:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_select");
         this.m_currentMC.keySetter.currKey = this.m_keyName;
         this.m_currentMC.keySetter.currKeyNum = SaveData.Controllers[this.m_playerNum - 1].KeyboardInstance.ControlsMap[this.m_keyVar];
         this.m_currentMC.keySetter.visible = true;
         this.m_currentMC.keySetter.blocker.useHandCursor = false;
         this.m_currentMC.keySetter.keyVal.text = Utils.KEY_ARR[this.currKeyNum];
         this.m_currentMC.keySetter.currKey_txt.text = this.currKey;
         Main.Root.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.keyListener);
         Main.fixFocus();
         MenuController.controlsMenu.selectHand.enabled = false;
         if(Boolean(SaveData.Controllers[this.m_playerNum - 1].GamepadInstance))
         {
            SaveData.Controllers[this.m_playerNum - 1].GamepadInstance.addEventListener(GamepadEvent.BUTTON_DOWN,this.onButtonDown);
            SaveData.Controllers[this.m_playerNum - 1].GamepadInstance.addEventListener(GamepadEvent.AXIS_CHANGED,this.onAxisChanged);
         }
      }
      
      private function exitScreen() : void
      {
         var gamepad:Gamepad = null;
         var playerTag:String = null;
         var portType:String = null;
         Main.Root.stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.keyListener);
         if(Boolean(SaveData.Controllers[this.m_playerNum - 1].GamepadInstance))
         {
            gamepad = SaveData.Controllers[this.m_playerNum - 1].GamepadInstance;
            playerTag = Boolean(MenuController.CurrentCharacterSelectMenu) && Boolean(MenuController.CurrentCharacterSelectMenu.GameObj) ? MenuController.CurrentCharacterSelectMenu.GameObj.PlayerSettings[this.m_playerNum - 1].name : null;
            portType = Boolean(playerTag) ? "names" : "ports";
            SaveData.Controllers[this.m_playerNum - 1].GamepadInstance.removeEventListener(GamepadEvent.BUTTON_DOWN,this.onButtonDown);
            SaveData.Controllers[this.m_playerNum - 1].GamepadInstance.removeEventListener(GamepadEvent.AXIS_CHANGED,this.onAxisChanged);
            SaveData.Controllers[this.m_playerNum - 1].GamepadInstance.importControls(SaveData.Gamepads[gamepad.Name][portType][playerTag || "port" + gamepad.Port]);
         }
         MenuController.controlsMenu.updateControls();
         this.m_currentMC.keySetter.visible = false;
         MenuController.controlsMenu.resetControlsLetGo();
         MenuController.controlsMenu.selectHand.enabled = true;
         MenuController.controlsMenu.selectHand.resetLetGo();
      }
      
      private function onButtonDown(e:GamepadEvent) : void
      {
         var index:int = 0;
         var i:* = undefined;
         var gamepad:Gamepad = SaveData.Controllers[this.m_playerNum - 1].GamepadInstance;
         var playerTag:String = Boolean(MenuController.CurrentCharacterSelectMenu) && Boolean(MenuController.CurrentCharacterSelectMenu.GameObj) ? MenuController.CurrentCharacterSelectMenu.GameObj.PlayerSettings[this.m_playerNum - 1].name : null;
         var portType:String = Boolean(playerTag) ? "names" : "ports";
         var data:Object = SaveData.getGamepadInputData(gamepad.Name,Boolean(playerTag) ? 0 : gamepad.Port,Boolean(playerTag) ? playerTag : "port" + gamepad.Port,e.controlState.id);
         for(i in e.gamepad.ControlState)
         {
            this.unsetInput(i,this.m_keyVar);
         }
         data.inputs.splice(0,data.inputs.length);
         this.setInput(e.controlState.id,this.m_keyVar,false);
         this.exitScreen();
      }
      
      private function onAxisChanged(e:GamepadEvent) : void
      {
         var gamepad:Gamepad = null;
         var playerTag:String = null;
         var portType:String = null;
         var index:int = 0;
         var data:Object = null;
         var i:* = undefined;
         if(Utils.fastAbs(e.controlState.value) >= e.controlState.deadZone)
         {
            gamepad = SaveData.Controllers[this.m_playerNum - 1].GamepadInstance;
            playerTag = Boolean(MenuController.CurrentCharacterSelectMenu) && Boolean(MenuController.CurrentCharacterSelectMenu.GameObj) ? MenuController.CurrentCharacterSelectMenu.GameObj.PlayerSettings[this.m_playerNum - 1].name : null;
            portType = Boolean(playerTag) ? "names" : "ports";
            data = SaveData.getGamepadInputData(gamepad.Name,Boolean(playerTag) ? 0 : gamepad.Port,Boolean(playerTag) ? playerTag : "port" + gamepad.Port,e.controlState.id);
            for(i in e.gamepad.ControlState)
            {
               this.unsetInput(i,this.m_keyVar);
            }
            if(e.controlState.value < 0)
            {
               data.inputsInverse.splice(0,data.inputsInverse.length);
            }
            else
            {
               data.inputs.splice(0,data.inputs.length);
            }
            this.setInput(e.controlState.id,this.m_keyVar,e.controlState.value < 0);
            this.exitScreen();
         }
      }
      
      private function keyListener(e:KeyboardEvent) : void
      {
         var tmpArr:Array = null;
         var k:* = undefined;
         var i:int = 0;
         var j:int = 0;
         var newKey:Number = e.keyCode;
         var controller:Controller = SaveData.Controllers[this.m_playerNum - 1];
         if(Utils.KEY_ARR[newKey] != undefined && Utils.KEY_ARR[newKey] != null)
         {
            tmpArr = new Array("UP","DOWN","LEFT","RIGHT","JUMP","BUTTON1","BUTTON2","SHIELD","SHIELD2","TAUNT","START","GRAB","JUMP2","C_UP","C_DOWN","C_LEFT","C_RIGHT","DASH");
            if(newKey != 27)
            {
               if(newKey == 46)
               {
                  if(Boolean(SaveData.Controllers[this.m_playerNum - 1].GamepadInstance))
                  {
                     for(k in SaveData.Controllers[this.m_playerNum - 1].GamepadInstance.ControlState)
                     {
                        this.unsetInput(k,this.m_keyVar);
                     }
                  }
                  else
                  {
                     controller.KeyboardInstance.ControlsMap[this.m_keyVar] = 0;
                  }
               }
               else
               {
                  if(Boolean(SaveData.Controllers[this.m_playerNum - 1].GamepadInstance))
                  {
                     return;
                  }
                  controller.KeyboardInstance.ControlsMap[this.m_keyVar] = newKey;
                  for(i = 1; i <= SaveData.Controllers.length; i++)
                  {
                     for(j = 0; j < tmpArr.length; j++)
                     {
                        if(i != this.m_playerNum || i == this.m_playerNum && this.m_keyVar != tmpArr[j])
                        {
                           if(SaveData.Controllers[i - 1].KeyboardInstance.ControlsMap[tmpArr[j]] == newKey)
                           {
                              SaveData.Controllers[i - 1].KeyboardInstance.ControlsMap[tmpArr[j]] = 0;
                           }
                        }
                     }
                  }
               }
            }
            this.exitScreen();
         }
      }
   }
}

