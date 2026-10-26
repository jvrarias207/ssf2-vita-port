package com.mcleodgaming.ssf2.menus
{
   import com.mcleodgaming.ssf2.Main;
   import com.mcleodgaming.ssf2.audio.*;
   import com.mcleodgaming.ssf2.controllers.*;
   import com.mcleodgaming.ssf2.engine.*;
   import com.mcleodgaming.ssf2.enums.Mode;
   import com.mcleodgaming.ssf2.enums.ModeFeatures;
   import com.mcleodgaming.ssf2.events.GamepadEvent;
   import com.mcleodgaming.ssf2.modes.CustomMode;
   import com.mcleodgaming.ssf2.net.MultiplayerManager;
   import com.mcleodgaming.ssf2.util.*;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.utils.Timer;
   
   public class CharacterSelectMenu extends Menu
   {
      
      protected var m_game:Game;
      
      protected var m_playerLimit:Number;
      
      protected var m_playerChips:Vector.<Chip>;
      
      protected var draggingMC:MovieClip;
      
      protected var gameMode:uint;
      
      protected var displayObjectTable:DisplayObjectTable;
      
      protected var keyPadMapping:Array;
      
      protected var m_charSelectionMC:MovieClip;
      
      protected var m_charSelectionBoxes:Vector.<MovieClip>;
      
      protected var m_charMCHash:Object;
      
      protected var m_unlockMCHash:Object;
      
      private var m_nextScreenDelay:Timer;
      
      private var m_nextScreenEnabled:Boolean;
      
      protected var m_loadingMask:MovieClip;
      
      private var m_readyDelay:FrameTimer;
      
      protected var m_modeInstance:CustomMode;
      
      public function CharacterSelectMenu(linkage:String)
      {
         var i:int = 0;
         var j:int = 0;
         var child:MovieClip = null;
         super();
         this.m_playerLimit = Main.MAXPLAYERS;
         m_subMenu = ResourceManager.getLibraryMC(linkage);
         m_backgroundID = "space";
         m_container.addChild(m_subMenu);
         this.draggingMC = null;
         this.gameMode = Mode.VS;
         this.m_charSelectionMC = m_subMenu.charSelection;
         this.m_charSelectionBoxes = new Vector.<MovieClip>();
         this.m_playerChips = new Vector.<Chip>();
         this.keyPadMapping = new Array();
         this.keyPadMapping["btn_abc"] = ["A","B","C","a","b","c"];
         this.keyPadMapping["btn_def"] = ["D","E","F","d","e","f"];
         this.keyPadMapping["btn_ghi"] = ["G","H","I","g","h","i"];
         this.keyPadMapping["btn_jkl"] = ["J","K","L","j","k","l"];
         this.keyPadMapping["btn_mno"] = ["M","N","O","m","n","o"];
         this.keyPadMapping["btn_pqrs"] = ["P","Q","R","S","p","q","r","s"];
         this.keyPadMapping["btn_tuv"] = ["T","U","V","t","u","v"];
         this.keyPadMapping["btn_wxyz"] = ["W","X","Y","Z","w","x","y","z"];
         this.keyPadMapping["btn_misc"] = ["\"","#","$","%","&","\'","(",")","*","+",",","-",".","/","0","1","2","3","4","5","6","7","8","9",":",";","<","=",">","?","@","[","\\","]","^","_","`","{","|","}","~"];
         var mappings:Object = ResourceManager.getResourceByID("mappings").getProp("metadata");
         var charactersObj:Object = mappings.character_select_screen.rows;
         var allCharacters:Array = Utils.flatten(charactersObj as Array);
         this.m_charMCHash = {};
         this.m_unlockMCHash = {};
         for(i = 0; i < this.CharSelectionIconsMC.numChildren; i++)
         {
            if(this.CharSelectionIconsMC.getChildAt(i) is MovieClip)
            {
               child = MovieClip(this.CharSelectionIconsMC.getChildAt(i));
               child.parent.removeChild(child);
               i--;
            }
         }
         for(i = 0; i < allCharacters.length; i++)
         {
            if(Boolean(mappings.character[allCharacters[i]]) || Boolean(allCharacters[i] === "cxp") || allCharacters[i] === "random")
            {
               child = ResourceManager.getLibraryMC(allCharacters[i] + "_select");
               if(child)
               {
                  child.characterID = child.characterID || allCharacters[i];
                  child.gotoAndStop(1);
                  this.CharSelectionIconsMC.addChild(child);
                  if(Boolean(child.characterID))
                  {
                     this.m_charMCHash[child.characterID] = child;
                  }
                  else
                  {
                     this.m_charMCHash[allCharacters[i]] = child;
                  }
               }
            }
         }
         this.displayObjectTable = new DisplayObjectTable(new Rectangle(mappings.character_select_screen.position.x,mappings.character_select_screen.position.y,mappings.character_select_screen.icon_size.width,mappings.character_select_screen.icon_size.height));
         this.displayObjectTable.fixDepths();
         m_subMenu.x = Main.Width / 2;
         m_subMenu.y = Main.Height / 2;
         this.m_nextScreenEnabled = false;
         this.m_nextScreenDelay = new Timer(30,1);
         this.m_loadingMask = ResourceManager.getLibraryMC("loadingMask");
         this.m_loadingMask.x = Main.Width / 2;
         this.m_loadingMask.y = Main.Height / 2;
         this.m_readyDelay = new FrameTimer(10);
      }
      
      public function get ReadyDelay() : FrameTimer
      {
         return this.m_readyDelay;
      }
      
      public function get PlayerLimit() : int
      {
         return this.m_playerLimit;
      }
      
      public function get CharMCHash() : Object
      {
         return this.m_charMCHash;
      }
      
      public function get CharSelectionMC() : MovieClip
      {
         return this.m_charSelectionMC;
      }
      
      public function get CharSelectionIconsMC() : MovieClip
      {
         return this.m_charSelectionMC.charSelect;
      }
      
      public function get CharSelectionBoxes() : Vector.<MovieClip>
      {
         return this.m_charSelectionBoxes;
      }
      
      public function get PlayerChips() : Vector.<Chip>
      {
         return this.m_playerChips;
      }
      
      public function get GameObj() : Game
      {
         return this.m_game;
      }
      
      override public function makeEvents() : void
      {
         var i:int = 0;
         var j:int = 0;
         if(m_showCount == 0)
         {
            findSubMenuButtons();
            findSpecificMenuButtons(m_subMenu.bg_top);
         }
         super.makeEvents();
         m_subMenu.bg_top.back_btn.addEventListener(MouseEvent.CLICK,this.backMain_CLICK);
         m_subMenu.bg_top.back_btn.addEventListener(MouseEvent.MOUSE_OVER,this.backMain_OVER);
         for(i = 0; i < this.m_charSelectionBoxes.length; i++)
         {
            this.m_charSelectionBoxes[i].levelDisplay.levelHandle.addEventListener(MouseEvent.MOUSE_DOWN,this.levelHandle_MOUSE_DOWN);
            this.m_charSelectionBoxes[i].flag.addEventListener(MouseEvent.CLICK,this.flag_MOUSE_CLICK);
            this.m_charSelectionBoxes[i].controlType.addEventListener(MouseEvent.CLICK,this.controlType_CLICK);
            this.m_charSelectionBoxes[i].nextExp.addEventListener(MouseEvent.CLICK,this.nextExp_CLICK);
            this.m_charSelectionBoxes[i].nameDisplay.btn_keypad.addEventListener(MouseEvent.CLICK,this.namesDisplay_CLICK);
            this.m_charSelectionBoxes[i].nameDisplay.nameKeyPad.btn_abc.addEventListener(MouseEvent.CLICK,this.namesKeypad_CLICK);
            this.m_charSelectionBoxes[i].nameDisplay.nameKeyPad.btn_def.addEventListener(MouseEvent.CLICK,this.namesKeypad_CLICK);
            this.m_charSelectionBoxes[i].nameDisplay.nameKeyPad.btn_ghi.addEventListener(MouseEvent.CLICK,this.namesKeypad_CLICK);
            this.m_charSelectionBoxes[i].nameDisplay.nameKeyPad.btn_jkl.addEventListener(MouseEvent.CLICK,this.namesKeypad_CLICK);
            this.m_charSelectionBoxes[i].nameDisplay.nameKeyPad.btn_mno.addEventListener(MouseEvent.CLICK,this.namesKeypad_CLICK);
            this.m_charSelectionBoxes[i].nameDisplay.nameKeyPad.btn_pqrs.addEventListener(MouseEvent.CLICK,this.namesKeypad_CLICK);
            this.m_charSelectionBoxes[i].nameDisplay.nameKeyPad.btn_tuv.addEventListener(MouseEvent.CLICK,this.namesKeypad_CLICK);
            this.m_charSelectionBoxes[i].nameDisplay.nameKeyPad.btn_wxyz.addEventListener(MouseEvent.CLICK,this.namesKeypad_CLICK);
            this.m_charSelectionBoxes[i].nameDisplay.nameKeyPad.btn_misc.addEventListener(MouseEvent.CLICK,this.namesKeypad_CLICK);
            this.m_charSelectionBoxes[i].nameDisplay.nameKeyPad.btn_done.addEventListener(MouseEvent.CLICK,this.namesDisplayDone_CLICK);
            this.m_charSelectionBoxes[i].nameDisplay.addEventListener(Event.ENTER_FRAME,this.runKeyPadDelayTimer);
            this.m_charSelectionBoxes[i].charPortrait.addEventListener(MouseEvent.CLICK,this.nextCostume_CLICK);
            Main.Root.stage.addEventListener(MouseEvent.MOUSE_UP,this.levelHandle_MOUSE_UP);
            Main.Root.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.levelHandle_MOUSE_MOVE);
         }
         for(j = 0; j < this.m_playerChips.length; j++)
         {
            this.m_playerChips[j].makeEvents();
         }
         if(Boolean(m_subMenu.controls_btn))
         {
            m_subMenu.controls_btn.addEventListener(MouseEvent.CLICK,this.controls_btn_CLICK);
            m_subMenu.controls_btn.addEventListener(MouseEvent.ROLL_OVER,this.controls_btn_ROLL_OVER);
         }
         this.m_nextScreenEnabled = false;
         this.m_nextScreenDelay.reset();
         Main.Root.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyPressed);
         for(i = 0; i < SaveData.Controllers.length; i++)
         {
            if(Boolean(SaveData.Controllers[i].GamepadInstance))
            {
               SaveData.Controllers[i].GamepadInstance.addEventListener(GamepadEvent.BUTTON_DOWN,this.onGamepadButtonPressed);
            }
         }
         this.m_nextScreenDelay.addEventListener(TimerEvent.TIMER_COMPLETE,this.enableNextScreen);
         this.m_nextScreenDelay.start();
      }
      
      override public function killEvents() : void
      {
         var i:int = 0;
         var j:int = 0;
         super.killEvents();
         m_subMenu.bg_top.back_btn.removeEventListener(MouseEvent.CLICK,this.backMain_CLICK);
         m_subMenu.bg_top.back_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.backMain_OVER);
         for(i = 0; i < this.m_charSelectionBoxes.length; i++)
         {
            this.m_charSelectionBoxes[i].levelDisplay.levelHandle.removeEventListener(MouseEvent.MOUSE_DOWN,this.levelHandle_MOUSE_DOWN);
            this.m_charSelectionBoxes[i].flag.removeEventListener(MouseEvent.CLICK,this.flag_MOUSE_CLICK);
            this.m_charSelectionBoxes[i].controlType.removeEventListener(MouseEvent.CLICK,this.controlType_CLICK);
            this.m_charSelectionBoxes[i].nextExp.removeEventListener(MouseEvent.CLICK,this.nextExp_CLICK);
            this.m_charSelectionBoxes[i].nameDisplay.btn_keypad.removeEventListener(MouseEvent.CLICK,this.namesDisplay_CLICK);
            this.m_charSelectionBoxes[i].nameDisplay.nameKeyPad.btn_abc.removeEventListener(MouseEvent.CLICK,this.namesKeypad_CLICK);
            this.m_charSelectionBoxes[i].nameDisplay.nameKeyPad.btn_def.removeEventListener(MouseEvent.CLICK,this.namesKeypad_CLICK);
            this.m_charSelectionBoxes[i].nameDisplay.nameKeyPad.btn_ghi.removeEventListener(MouseEvent.CLICK,this.namesKeypad_CLICK);
            this.m_charSelectionBoxes[i].nameDisplay.nameKeyPad.btn_jkl.removeEventListener(MouseEvent.CLICK,this.namesKeypad_CLICK);
            this.m_charSelectionBoxes[i].nameDisplay.nameKeyPad.btn_mno.removeEventListener(MouseEvent.CLICK,this.namesKeypad_CLICK);
            this.m_charSelectionBoxes[i].nameDisplay.nameKeyPad.btn_pqrs.removeEventListener(MouseEvent.CLICK,this.namesKeypad_CLICK);
            this.m_charSelectionBoxes[i].nameDisplay.nameKeyPad.btn_tuv.removeEventListener(MouseEvent.CLICK,this.namesKeypad_CLICK);
            this.m_charSelectionBoxes[i].nameDisplay.nameKeyPad.btn_wxyz.removeEventListener(MouseEvent.CLICK,this.namesKeypad_CLICK);
            this.m_charSelectionBoxes[i].nameDisplay.nameKeyPad.btn_misc.removeEventListener(MouseEvent.CLICK,this.namesKeypad_CLICK);
            this.m_charSelectionBoxes[i].nameDisplay.nameKeyPad.btn_done.removeEventListener(MouseEvent.CLICK,this.namesDisplayDone_CLICK);
            this.m_charSelectionBoxes[i].nameDisplay.removeEventListener(Event.ENTER_FRAME,this.runKeyPadDelayTimer);
            this.m_charSelectionBoxes[i].charPortrait.removeEventListener(MouseEvent.CLICK,this.nextCostume_CLICK);
            Main.Root.stage.removeEventListener(MouseEvent.MOUSE_UP,this.levelHandle_MOUSE_UP);
            Main.Root.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.levelHandle_MOUSE_MOVE);
         }
         for(j = 0; j < this.m_playerChips.length; j++)
         {
            this.m_playerChips[j].killEvents();
         }
         if(Boolean(m_subMenu.controls_btn))
         {
            m_subMenu.controls_btn.removeEventListener(MouseEvent.CLICK,this.controls_btn_CLICK);
            m_subMenu.controls_btn.removeEventListener(MouseEvent.ROLL_OVER,this.controls_btn_ROLL_OVER);
         }
         this.m_nextScreenEnabled = false;
         Main.Root.stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyPressed);
         for(i = 0; i < SaveData.Controllers.length; i++)
         {
            if(Boolean(SaveData.Controllers[i].GamepadInstance))
            {
               SaveData.Controllers[i].GamepadInstance.removeEventListener(GamepadEvent.BUTTON_DOWN,this.onGamepadButtonPressed);
            }
         }
         if(this.m_nextScreenDelay.running)
         {
            this.m_nextScreenDelay.removeEventListener(TimerEvent.TIMER_COMPLETE,this.enableNextScreen);
         }
      }
      
      override public function show() : void
      {
         this.updateIcons();
         super.show();
         SoundQueue.instance.playMusic("menumusic",0);
      }
      
      protected function updateIcons() : void
      {
         var i:int = 0;
         var j:int = 0;
         var k:* = undefined;
         var mappings:Object = ResourceManager.getResourceByID("mappings").getProp("metadata");
         this.displayObjectTable.empty();
         var rows:Object = mappings.character_select_screen.rows;
         for(i = 0; i < rows.length; i++)
         {
            for(j = 0; j < rows[i].length; j++)
            {
               if(Boolean(this.m_charMCHash[rows[i][j]]))
               {
                  m_subMenu.charSelection.charSelect.addChild(this.m_charMCHash[rows[i][j]]);
                  this.displayObjectTable.insertObject(i,this.m_charMCHash[rows[i][j]]);
               }
            }
         }
         if(!Main.DEBUG)
         {
            for(k in this.m_charMCHash)
            {
               if(SaveData.Unlocks[k] === false)
               {
                  this.m_charMCHash[k].visible = false;
               }
               else if(SaveData.Unlocks[k] === true)
               {
                  this.m_charMCHash[k].visible = true;
               }
            }
         }
         this.displayObjectTable.fixDepths();
         this.displayObjectTable.spaceObjects();
      }
      
      public function reset() : void
      {
         m_subMenu.readyToFight.visible = false;
         this.updateIcons();
         if(Boolean(this.m_game))
         {
            trace("ROGUE GAME IN EXISTENCE IN CHARSELECTMENU");
         }
         this.m_game = new Game(this.m_playerLimit,this.gameMode);
         this.initSelectionBoxes();
         this.m_game.loadSavedVSOptions();
         this.updateDisplay();
      }
      
      public function initSelectionBoxes() : void
      {
         var i:int = 0;
         var tmpMC:MovieClip = null;
         var tmpX:Number = 7.85;
         var mappings:Object = ResourceManager.getResourceByID("mappings").getProp("metadata");
         while(this.m_charSelectionBoxes.length > 0)
         {
            if(Boolean(this.m_charSelectionBoxes[0].parent))
            {
               this.m_charSelectionBoxes[0].parent.removeChild(this.m_charSelectionBoxes[0]);
            }
            this.m_charSelectionBoxes.splice(0,1);
         }
         tmpX = 7.85 + mappings.character_select_screen.portrait_offset.x;
         for(i = 1; i <= this.m_playerLimit; i++)
         {
            tmpMC = ResourceManager.getLibraryMC("CharacterSelectBox");
            tmpMC.pid = i;
            tmpMC.levelDisplay.dragging = false;
            tmpMC.pic.mouseChildren = false;
            tmpMC.pic.mouseEnabled = false;
            tmpMC.flag.mouseChildren = false;
            tmpMC.flag.visible = false;
            tmpMC.nameDisplay.nameKeyPad.visible = false;
            tmpMC.nameDisplay.nameTxt.text = "P" + i;
            tmpMC.nameDisplay.delayTimer = 0;
            tmpMC.x = tmpX;
            tmpMC.y = 182 + mappings.character_select_screen.portrait_offset.y;
            tmpMC.name = "display" + i;
            tmpMC.visible = true;
            this.m_charSelectionMC["display" + i] = tmpMC;
            tmpX += mappings.character_select_screen.portrait_spacing || 130;
            this.m_charSelectionMC.addChildAt(tmpMC,0);
            this.m_charSelectionBoxes.push(tmpMC);
         }
         while(this.m_playerChips.length > 0)
         {
            this.m_playerChips[0].destroy();
            this.m_playerChips.splice(0,1);
         }
         this.m_playerChips = new Vector.<Chip>();
         for(i = 0; i < this.m_game.PlayerSettings.length; i++)
         {
            tmpMC = ResourceManager.getLibraryMC("CharacterSelectChip");
            tmpMC.name = "chip" + (i + 1);
            tmpMC.x = this.m_charSelectionMC["display" + (i + 1)].x - this.m_charSelectionMC.charSelect.x + mappings.character_select_screen.chip_offset.x;
            tmpMC.y = this.m_charSelectionMC["display" + (i + 1)].y + this.m_charSelectionMC.charSelect.y + mappings.character_select_screen.chip_offset.y;
            this.m_charSelectionMC.charSelect.addChild(tmpMC);
            this.m_charSelectionMC.charSelect["chip" + (i + 1)] = tmpMC;
            this.m_playerChips.push(new Chip(this,tmpMC,i + 1));
         }
         for(i = 0; i < this.m_playerChips.length; i++)
         {
            this.m_charSelectionMC.charSelect.addChild(this.m_playerChips[i].HandMC);
         }
      }
      
      public function resetScreen() : void
      {
         var i:int = 0;
         if(Boolean(this.m_game))
         {
            for(i = 1; i <= this.m_game.PlayerSettings.length; i++)
            {
               this.resetChipPosition(i);
               this.removePic(i);
            }
         }
      }
      
      public function backMain_CLICK(e:MouseEvent) : void
      {
         this.resetScreen();
         this.m_game = null;
         SoundQueue.instance.playSoundEffect("menu_back");
         removeSelf();
         MenuController.disposeAllMenus(true);
      }
      
      public function backMain_OVER(e:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
      }
      
      protected function levelHandle_MOUSE_DOWN(e:MouseEvent) : void
      {
         if(this.draggingMC != null)
         {
            return;
         }
         var clickedMC:MovieClip = null;
         for(var i:int = 0; i < this.m_charSelectionBoxes.length; i++)
         {
            if(e.currentTarget == this.m_charSelectionBoxes[i].levelDisplay.levelHandle)
            {
               clickedMC = MovieClip(e.currentTarget);
               break;
            }
         }
         if(clickedMC != null)
         {
            clickedMC.dragging = true;
            clickedMC.startDrag(true,new Rectangle(clickedMC.x,-54,0,50));
            this.draggingMC = clickedMC;
         }
      }
      
      protected function levelHandle_MOUSE_UP(e:MouseEvent) : void
      {
         if(this.draggingMC != null && Boolean(this.draggingMC.dragging))
         {
            this.draggingMC.dragging = false;
            this.draggingMC.stopDrag();
            this.setLevel(MovieClip(this.draggingMC.parent.parent).pid,Math.round(-(this.draggingMC.y + 4) / 50 * 8) + 1);
            SaveData.saveGame();
         }
         else
         {
            this.draggingMC = null;
         }
      }
      
      protected function levelHandle_MOUSE_MOVE(e:MouseEvent) : void
      {
         if(Boolean(this.draggingMC != null) && Boolean(this.draggingMC.dragging) && Boolean(m_subMenu.root))
         {
            this.setLevel(MovieClip(this.draggingMC.parent.parent).pid,Math.round(-(this.draggingMC.y + 4) / 50 * 8) + 1);
         }
         else
         {
            this.draggingMC = null;
         }
      }
      
      public function incLevel(id:int) : void
      {
         this.setLevel(id,this.m_game.PlayerSettings[id - 1].level + 1);
      }
      
      protected function flag_MOUSE_CLICK(e:MouseEvent) : void
      {
         var clickedMC:MovieClip = null;
         for(var i:int = 0; i < this.m_charSelectionBoxes.length; i++)
         {
            if(e.currentTarget.parent == this.m_charSelectionBoxes[i])
            {
               clickedMC = MovieClip(e.currentTarget.parent);
               break;
            }
         }
         if(clickedMC != null)
         {
            SoundQueue.instance.playSoundEffect("menu_hover");
            this.toggleTeam(clickedMC.pid);
         }
      }
      
      protected function controlType_CLICK(e:MouseEvent) : void
      {
         if(!ModeFeatures.hasFeature(ModeFeatures.ALLOW_CONROL_TYPE,this.gameMode))
         {
            return;
         }
         var clickedMC:MovieClip = null;
         for(var i:int = 0; i < this.m_charSelectionBoxes.length; i++)
         {
            if(e.currentTarget.parent == this.m_charSelectionBoxes[i])
            {
               clickedMC = MovieClip(e.currentTarget.parent);
               break;
            }
         }
         if(clickedMC != null)
         {
            SoundQueue.instance.playSoundEffect("menu_hover");
            this.toggleControl(clickedMC.pid);
         }
      }
      
      protected function namesKeypad_CLICK(e:MouseEvent) : void
      {
         var currentMapping:Array = null;
         var currentField:TextField = null;
         var lastChar:String = null;
         var previousMapping:Array = null;
         var nextChar:String = null;
         var j:* = undefined;
         var clickedMC:MovieClip = null;
         for(var i:int = 0; i < this.m_charSelectionBoxes.length; i++)
         {
            if(e.currentTarget.parent.parent.parent == this.m_charSelectionBoxes[i])
            {
               clickedMC = MovieClip(e.currentTarget.parent.parent.parent);
               break;
            }
         }
         if(Boolean(clickedMC != null) && Boolean(e.currentTarget.name) && Boolean(this.keyPadMapping[e.currentTarget.name]))
         {
            currentMapping = this.keyPadMapping[e.currentTarget.name];
            currentField = clickedMC.nameDisplay.nameTxt;
            lastChar = currentField.text == "" ? null : currentField.text.charAt(currentField.text.length - 1);
            previousMapping = null;
            if(lastChar != null)
            {
               for(j in this.keyPadMapping)
               {
                  if(this.keyPadMapping[j].indexOf(lastChar) >= 0)
                  {
                     if(currentMapping == this.keyPadMapping[j])
                     {
                        previousMapping = this.keyPadMapping[j];
                     }
                     else
                     {
                        lastChar = null;
                     }
                  }
               }
            }
            if(currentField.textColor != 16711680)
            {
               lastChar = null;
               previousMapping = null;
            }
            nextChar = !lastChar ? currentMapping[0] : currentMapping[(currentMapping.indexOf(lastChar) + 1) % currentMapping.length];
            if(Boolean(previousMapping) || currentField.length >= 10)
            {
               currentField.text = currentField.text.substr(0,currentField.length - 1) + nextChar;
            }
            else
            {
               currentField.appendText(nextChar);
            }
            currentField.textColor = 16711680;
            clickedMC.nameDisplay.delayTimer = 25;
            SoundQueue.instance.playSoundEffect("menu_hover");
         }
      }
      
      protected function namesDisplay_CLICK(e:MouseEvent) : void
      {
         var clickedMC:MovieClip = null;
         for(var i:int = 0; i < this.m_charSelectionBoxes.length; i++)
         {
            if(e.currentTarget.parent.parent == this.m_charSelectionBoxes[i])
            {
               clickedMC = MovieClip(e.currentTarget.parent.parent);
               break;
            }
         }
         if(clickedMC != null)
         {
            SoundQueue.instance.playSoundEffect("menu_hover");
            this.showNamesKeypad(clickedMC.pid);
         }
      }
      
      protected function namesDisplayDone_CLICK(e:MouseEvent) : void
      {
         var clickedMC:MovieClip = null;
         for(var i:int = 0; i < this.m_charSelectionBoxes.length; i++)
         {
            if(e.currentTarget.parent.parent.parent == this.m_charSelectionBoxes[i])
            {
               clickedMC = MovieClip(e.currentTarget.parent.parent.parent);
               break;
            }
         }
         if(clickedMC != null)
         {
            SoundQueue.instance.playSoundEffect("menu_hover");
            this.hideNamesKeypad(clickedMC.pid);
         }
      }
      
      protected function runKeyPadDelayTimer(e:Event) : void
      {
         var clickedMC:MovieClip = null;
         for(var i:int = 0; i < this.m_charSelectionBoxes.length; i++)
         {
            if(e.currentTarget.parent == this.m_charSelectionBoxes[i])
            {
               clickedMC = MovieClip(e.currentTarget.parent);
               break;
            }
         }
         if(clickedMC != null)
         {
            --clickedMC.nameDisplay.delayTimer;
            if(clickedMC.nameDisplay.delayTimer <= 0)
            {
               TextField(clickedMC.nameDisplay.nameTxt).textColor = 15658734;
            }
         }
      }
      
      protected function nextCostume_CLICK(e:MouseEvent) : void
      {
         var clickedMC:MovieClip = null;
         for(var i:int = 0; i < this.m_charSelectionBoxes.length; i++)
         {
            if(e.currentTarget.parent == this.m_charSelectionBoxes[i])
            {
               clickedMC = MovieClip(e.currentTarget.parent);
               break;
            }
         }
         if(clickedMC != null)
         {
            this.nextCostume(clickedMC.pid,true);
         }
      }
      
      protected function nextExp_CLICK(e:MouseEvent) : void
      {
         var clickedMC:MovieClip = null;
         for(var i:int = 0; i < this.m_charSelectionBoxes.length; i++)
         {
            if(e.currentTarget.parent == this.m_charSelectionBoxes[i])
            {
               clickedMC = MovieClip(e.currentTarget.parent);
               break;
            }
         }
         if(clickedMC != null)
         {
            SoundQueue.instance.playSoundEffect("menu_hover");
            this.incrementExpansion(clickedMC.pid);
         }
      }
      
      public function controls_btn_CLICK(e:MouseEvent) : void
      {
         if(this.hasVisibleKeypad())
         {
            SoundQueue.instance.playSoundEffect("menu_error");
            return;
         }
         SoundQueue.instance.playSoundEffect("menu_select");
         MenuController.controlsMenu.show();
      }
      
      public function controls_btn_ROLL_OVER(e:MouseEvent) : void
      {
         SoundQueue.instance.playSoundEffect("menu_hover");
      }
      
      public function incrementExpansion(id:Number) : void
      {
         this.m_playerChips[id - 1].incrementExpansionNum();
      }
      
      private function enableNextScreen(e:TimerEvent) : void
      {
         if(!Key.isDown(32))
         {
            this.m_nextScreenEnabled = true;
         }
         else
         {
            this.m_nextScreenDelay.reset();
            this.m_nextScreenDelay.start();
         }
      }
      
      public function onGamepadButtonPressed(event:GamepadEvent) : void
      {
         if(this.m_nextScreenEnabled && !MenuController.rulesMenu.isOnscreen() && !MenuController.controlsMenu.isOnscreen() && event.controlState.inputs.indexOf("START") >= 0)
         {
            this.readyConfirm();
         }
      }
      
      private function onKeyPressed(event:KeyboardEvent) : void
      {
         if(this.m_nextScreenEnabled && !MenuController.rulesMenu.isOnscreen() && !MenuController.controlsMenu.isOnscreen() && (event.keyCode == 32 || this.controllerStart()) && !(Boolean(MenuController.debugConsole) && MenuController.debugConsole.isOnscreen() && MenuController.debugConsole.DisableKeyCapture))
         {
            this.readyConfirm();
         }
      }
      
      private function controllerStart() : Boolean
      {
         for(var i:int = 1; i <= SaveData.Controllers.length; i++)
         {
            if(SaveData.Controllers[i - 1] != null && SaveData.Controllers[i - 1].IsDown(SaveData.Controllers[i - 1]._START))
            {
               return true;
            }
         }
         return false;
      }
      
      private function readyConfirm() : void
      {
         if(this.gameIsReady())
         {
            this.killEvents();
            this.initMatch();
         }
         else
         {
            SoundQueue.instance.playSoundEffect("menu_error");
         }
      }
      
      public function initMatch() : void
      {
      }
      
      public function startReplay(e:* = null) : void
      {
         if(this.m_loadingMask.parent != null)
         {
            Main.Root.removeChild(this.m_loadingMask);
         }
         MenuController.disposeAllMenus(true);
         GameController.startMatch(this.m_game);
      }
      
      public function initReplay() : void
      {
         this.m_game.importSettings({
            "levelData":this.m_game.ReplayDataObj.MatchSettings,
            "items":this.m_game.ReplayDataObj.ItemSettingsObj,
            "playerSettings":this.m_game.ReplayDataObj.PlayerData
         });
         this.m_game.HudDisplay = SaveData.HudDisplay;
         this.m_game.ScoreDisplay = SaveData.ScoreDisplay;
         this.m_game.PauseEnabled = false;
         this.m_game.ShowPlayerID = SaveData.ShowPlayerID;
         SoundQueue.instance.playSoundEffect("menu_crowd");
         GameController.isStarted = true;
         if(this.m_game.LevelData.unlocks.alternate_tracks === true)
         {
            ResourceManager.FORCE_ENABLE_ALT_TRACKS = true;
         }
         this.m_game.LevelData.randSeed = this.m_game.ReplayDataObj.MatchSettings.randSeed;
         Utils.setRandSeed(this.m_game.LevelData.randSeed);
         Utils.shuffleRandom();
         Main.prepRandomCharacters(this.m_game.PlayerSettings.length);
         ResourceManager.queueResources([this.m_game.LevelData.stage]);
         for(var i:int = 0; i < this.m_game.PlayerSettings.length; i++)
         {
            if(Boolean(this.m_game.PlayerSettings[i] && this.m_game.PlayerSettings[i].exist) && Boolean(this.m_game.PlayerSettings[i].character != null) && this.m_game.PlayerSettings[i].character != "xp")
            {
               ResourceManager.queueResources([this.m_game.PlayerSettings[i].character == "random" ? Main.RandCharList[i].StatsName : this.m_game.PlayerSettings[i].character]);
            }
         }
         Main.Root.addChild(this.m_loadingMask);
         ResourceManager.load({"oncomplete":this.startReplay});
      }
      
      public function startArena(e:* = null) : void
      {
         if(this.m_loadingMask.parent != null)
         {
            Main.Root.removeChild(this.m_loadingMask);
         }
         MenuController.disposeAllMenus();
         GameController.startMatch(this.m_game);
      }
      
      public function removePic(num:Number) : void
      {
         var charMC:MovieClip = null;
         if(num <= 0 || num > this.m_charSelectionBoxes.length)
         {
            return;
         }
         var charDisplay:MovieClip = this.m_charSelectionBoxes[num - 1];
         if(MovieClip(charDisplay.getChildByName("pic")).numChildren > 0)
         {
            MovieClip(charDisplay.getChildByName("pic")).removeChild(MovieClip(charDisplay.getChildByName("pic")).getChildByName("mc"));
            charMC = MovieClip(charDisplay.getChildByName("pic")).addChild(ResourceManager.getLibraryMC("blankmc")) as MovieClip;
            charMC.name = "mc";
            if(MovieClip(charDisplay.getChildByName("icon")).numChildren > 0)
            {
               MovieClip(charDisplay.getChildByName("icon")).removeChild(MovieClip(charDisplay.getChildByName("icon")).getChildByName("mc"));
               charMC = MovieClip(charDisplay.getChildByName("icon")).addChild(ResourceManager.getLibraryMC("blankmc")) as MovieClip;
               charMC.name = "mc";
            }
            charDisplay.nextExp.visible = false;
            charDisplay.playerTxt.text = "";
         }
      }
      
      public function changePic(num:Number, character:String, expansionNum:Number = -1) : void
      {
         var charMC:MovieClip = null;
         var charDisplay:MovieClip = this.m_charSelectionBoxes[num - 1];
         if(character == "xp" && ResourceManager.TotalExpansions > 0)
         {
            character = Stats.getStats(character,expansionNum).StatsName;
            charDisplay.nextExp.visible = true;
            charDisplay.playerTxt.text = Stats.getStats(character,expansionNum).DisplayName != null ? Stats.getStats(character,expansionNum).DisplayName : "";
         }
         else
         {
            expansionNum = -1;
            charDisplay.nextExp.visible = false;
            charDisplay.playerTxt.text = character == "random" ? "Random" : Stats.getStats(character,expansionNum).DisplayName;
         }
         Utils.fitText(charDisplay.playerTxt,20,1);
         if(MovieClip(charDisplay.getChildByName("pic")).numChildren > 0)
         {
            MovieClip(charDisplay.getChildByName("pic")).removeChild(MovieClip(charDisplay.getChildByName("pic")).getChildByName("mc"));
         }
         if(character == "random")
         {
            charMC = ResourceManager.getLibraryMC("rand_mc");
         }
         else if(expansionNum < 0)
         {
            if(ResourceManager.getLibraryMC(Stats.getStats(character,-1).StatsName + "_charselect") != null)
            {
               charMC = ResourceManager.getLibraryMC(Stats.getStats(character,expansionNum).StatsName + "_charselect");
            }
            else
            {
               charMC = ResourceManager.getLibraryMC("mario_charselect");
            }
         }
         else
         {
            charMC = ResourceManager.getLibraryMC(Stats.getStats(character,expansionNum).StatsName);
         }
         MovieClip(charDisplay.getChildByName("pic")).addChild(charMC);
         charMC.mouseChildren = false;
         charMC.mouseEnabled = false;
         charMC.name = "mc";
         charMC.filters = null;
         Utils.setColorFilterCharacter(charMC,this.m_game.PlayerSettings[num - 1].team,character,this.m_game.PlayerSettings[num - 1].costume,true,true);
         if(MovieClip(charDisplay.getChildByName("icon")).numChildren > 0)
         {
            MovieClip(charDisplay.getChildByName("icon")).removeChild(MovieClip(charDisplay.getChildByName("icon")).getChildByName("mc"));
         }
         charMC = character == "random" ? null : ResourceManager.getLibraryMC(Stats.getStats(character,expansionNum).SeriesIcon);
         if(charMC != null)
         {
            charMC = MovieClip(charDisplay.getChildByName("icon")).addChild(charMC) as MovieClip;
            charMC.name = "mc";
            if(this.m_game.PlayerSettings[num - 1].human && this.m_game.PlayerSettings[num - 1].team > 0)
            {
               switch(this.m_game.PlayerSettings[num - 1].team)
               {
                  case 1:
                     Utils.setTint(charMC,1,1,1,1,90,0,0,0);
                     break;
                  case 2:
                     Utils.setTint(charMC,1,1,1,1,0,90,0,0);
                     break;
                  case 3:
                     Utils.setTint(charMC,1,1,1,1,0,0,90,0);
                     break;
                  case 4:
                     Utils.setTint(charMC,1,1,1,1,90,72,0,0);
               }
            }
            else if(this.m_game.PlayerSettings[num - 1].human)
            {
               switch(num)
               {
                  case 1:
                     Utils.setTint(charMC,1,1,1,1,90,0,0,0);
                     break;
                  case 2:
                     Utils.setTint(charMC,1,1,1,1,0,0,90,0);
                     break;
                  case 3:
                     Utils.setTint(charMC,1,1,1,1,90,90,0,0);
                     break;
                  case 4:
                     Utils.setTint(charMC,1,1,1,1,0,90,0,0);
               }
            }
            else
            {
               Utils.setTint(charMC,1,1,1,1,0,0,0,0);
            }
         }
      }
      
      public function setLevel(num:Number, level:Number) : void
      {
         var display:MovieClip = this.m_charSelectionBoxes[num - 1];
         if(level > 9)
         {
            level = 1;
         }
         else if(level < 1)
         {
            level = 9;
         }
         if(this.m_game.PlayerSettings[num - 1].level != level)
         {
            this.m_game.PlayerSettings[num - 1].level = level;
            display.levelDisplay.levelTxt.text = "" + level;
            SaveData["VSCPULevel" + num] = level;
         }
         this.updateLevelDisplay();
      }
      
      public function toggleGameMode() : void
      {
         this.m_game.LevelData.teams = !this.m_game.LevelData.teams;
         this.updateGameMode();
      }
      
      private function updateGameMode() : void
      {
         var i:int = 0;
         if(this.m_game.LevelData.teams)
         {
            for(i = 0; i < this.m_game.PlayerSettings.length; i++)
            {
               this.m_charSelectionBoxes[i].flag.visible = this.m_game.PlayerSettings[i].exist;
               this.m_game.PlayerSettings[i].team = this.m_game.PlayerSettings[i].team_prev;
               this.updatePlayerInfo(i + 1);
            }
         }
         else
         {
            for(i = 0; i < this.m_game.PlayerSettings.length; i++)
            {
               this.m_charSelectionBoxes[i].flag.visible = false;
               this.m_game.PlayerSettings[i].team_prev = this.m_game.PlayerSettings[i].team;
               this.m_game.PlayerSettings[i].team = -1;
               this.m_game.PlayerSettings[i].costume = -1;
               this.updatePlayerInfo(i + 1);
               if(i != 0 && this.costumeExistsElsewhere(this.m_game.PlayerSettings[i].costume,i + 1))
               {
                  this.nextCostume(i + 1);
               }
            }
         }
         if(ModeFeatures.hasFeature(ModeFeatures.ALLOW_FFA_TEAM_TOGGLE,this.m_game.GameMode) && ModeFeatures.hasFeature(ModeFeatures.ALLOW_FFA_TEAM_TOGGLE,this.m_game.GameMode))
         {
            m_subMenu.bnGameMode.gameModeTxt.gotoAndStop(this.m_game.LevelData.teams ? "team" : "ffa");
         }
         this.updateGameIsReady();
         this.updateSeriesIconColors();
      }
      
      private function updateSeriesIconColors() : void
      {
         var charDisplay:MovieClip = null;
         var charMC:MovieClip = null;
         for(var t:int = 1; t <= this.m_charSelectionBoxes.length; t++)
         {
            charDisplay = this.m_charSelectionBoxes[t - 1];
            if(Boolean(charDisplay.getChildByName("pic")) && MovieClip(charDisplay.getChildByName("pic")).getChildByName("mc") != null)
            {
               Utils.setColorFilterCharacter(MovieClip(MovieClip(charDisplay.getChildByName("pic")).getChildByName("mc")),this.m_game.PlayerSettings[t - 1].team,this.m_game.PlayerSettings[t - 1].character,this.m_game.PlayerSettings[t - 1].costume,true,true);
            }
            if(charDisplay.getChildByName("icon") != null && MovieClip(charDisplay.getChildByName("icon")).getChildByName("mc") != null)
            {
               charMC = MovieClip(MovieClip(charDisplay.getChildByName("icon")).getChildByName("mc"));
               if(this.m_game.PlayerSettings[t - 1].team > 0 && this.m_game.PlayerSettings[t - 1].human)
               {
                  switch(this.m_game.PlayerSettings[t - 1].team)
                  {
                     case 1:
                        Utils.setTint(charMC,1,1,1,1,90,0,0,0);
                        break;
                     case 2:
                        Utils.setTint(charMC,1,1,1,1,0,90,0,0);
                        break;
                     case 3:
                        Utils.setTint(charMC,1,1,1,1,0,0,90,0);
                        break;
                     case 4:
                        Utils.setTint(charMC,1,1,1,1,90,72,0,0);
                  }
               }
               else if(this.m_game.PlayerSettings[t - 1].human)
               {
                  switch(t)
                  {
                     case 1:
                        Utils.setTint(charMC,1,1,1,1,90,0,0,0);
                        break;
                     case 2:
                        Utils.setTint(charMC,1,1,1,1,0,0,90,0);
                        break;
                     case 3:
                        Utils.setTint(charMC,1,1,1,1,90,90,0,0);
                        break;
                     case 4:
                        Utils.setTint(charMC,1,1,1,1,0,90,0,0);
                  }
               }
               else
               {
                  Utils.setTint(charMC,1,1,1,1,0,0,0,0);
               }
            }
         }
      }
      
      public function prevCostume(num:int) : void
      {
         var obj:Object = null;
         var originalCostume:int = this.m_game.PlayerSettings[num - 1].costume;
         if(!this.m_game.LevelData.teams && this.m_game.PlayerSettings[num - 1].character != null)
         {
            while(true)
            {
               --this.m_game.PlayerSettings[num - 1].costume;
               if(this.m_game.PlayerSettings[num - 1].costume < -1)
               {
                  this.m_game.PlayerSettings[num - 1].costume = ResourceManager.getCostumeCount(this.m_game.PlayerSettings[num - 1].character) - 2;
               }
               obj = ResourceManager.getCostume(this.m_game.PlayerSettings[num - 1].character,null,this.m_game.PlayerSettings[num - 1].costume);
               if(!this.costumeExistsElsewhere(this.m_game.PlayerSettings[num - 1].costume,num) || originalCostume == this.m_game.PlayerSettings[num - 1].costume)
               {
                  break;
               }
            }
            this.updateSeriesIconColors();
         }
      }
      
      public function nextCostume(num:int, sfxIfPossible:Boolean = false) : void
      {
         var originalCostume:int = 0;
         var obj:Object = null;
         var charDisplay:MovieClip = this.m_charSelectionBoxes[num - 1];
         if(!this.m_game.PlayerSettings[num - 1].character || this.m_game.PlayerSettings[num - 1].character === "random")
         {
            return;
         }
         if(Boolean(charDisplay && charDisplay.pic) && Boolean(MovieClip(charDisplay.pic).numChildren > 0) && Boolean(MovieClip(MovieClip(charDisplay.pic).getChildAt(0)).alternateStatsName))
         {
            if(sfxIfPossible)
            {
               SoundQueue.instance.playSoundEffect("menu_hover");
            }
            this.setPlayer(num,MovieClip(MovieClip(charDisplay.pic).getChildAt(0)).alternateStatsName,this.m_game.PlayerSettings[num - 1].expansion);
         }
         else
         {
            originalCostume = this.m_game.PlayerSettings[num - 1].costume;
            if(!this.m_game.LevelData.teams)
            {
               while(true)
               {
                  ++this.m_game.PlayerSettings[num - 1].costume;
                  if(this.m_game.PlayerSettings[num - 1].costume >= ResourceManager.getCostumeCount(this.m_game.PlayerSettings[num - 1].character) - 1)
                  {
                     this.m_game.PlayerSettings[num - 1].costume = -1;
                  }
                  obj = ResourceManager.getCostume(this.m_game.PlayerSettings[num - 1].character,null,this.m_game.PlayerSettings[num - 1].costume);
                  if(!this.costumeExistsElsewhere(this.m_game.PlayerSettings[num - 1].costume,num) || originalCostume == this.m_game.PlayerSettings[num - 1].costume)
                  {
                     if(sfxIfPossible)
                     {
                        SoundQueue.instance.playSoundEffect("menu_hover");
                     }
                     break;
                  }
               }
               this.updateSeriesIconColors();
            }
         }
      }
      
      public function costumeExistsElsewhere(costume:int, excludePID:int) : Boolean
      {
         for(var i:int = 0; i < this.m_game.PlayerSettings.length; i++)
         {
            if(this.m_game.PlayerSettings[i] != this.m_game.PlayerSettings[excludePID - 1])
            {
               if(this.m_game.PlayerSettings[i].costume == costume && this.m_game.PlayerSettings[excludePID - 1].character == this.m_game.PlayerSettings[i].character)
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      public function toggleTeam(num:int) : void
      {
         if(!ModeFeatures.hasFeature(ModeFeatures.ALLOW_TEAM_TOGGLE,this.gameMode))
         {
            return;
         }
         var display:MovieClip = this.m_charSelectionBoxes[num - 1];
         ++this.m_game.PlayerSettings[num - 1].team;
         if((this.gameMode === Mode.ARENA || this.gameMode === Mode.ONLINE_ARENA) && this.m_game.PlayerSettings[num - 1].team === 2)
         {
            ++this.m_game.PlayerSettings[num - 1].team;
         }
         if(this.m_game.PlayerSettings[num - 1].team > 3)
         {
            this.m_game.PlayerSettings[num - 1].team = 1;
         }
         this.m_game.PlayerSettings[num - 1].team_prev = this.m_game.PlayerSettings[num - 1].team;
         display.flag.gotoAndStop("team" + this.m_game.PlayerSettings[num - 1].team);
         display.charPortrait.gotoAndStop(this.m_game.PlayerSettings[num - 1].human ? "team" + this.m_game.PlayerSettings[num - 1].team : "cpu");
         display.playerTitle.gotoAndStop(this.m_game.PlayerSettings[num - 1].human ? "player" + this.m_game.PlayerSettings[num - 1].team : "cpu");
         this.updateGameIsReady();
         this.updateSeriesIconColors();
      }
      
      public function toggleControl(num:int) : void
      {
         this.hideNamesKeypad(num);
         var display:String = "display" + num;
         if(this.m_game.PlayerSettings[num - 1].exist)
         {
            if(this.m_game.PlayerSettings[num - 1].human)
            {
               this.m_game.PlayerSettings[num - 1].human = false;
               this.m_game.PlayerSettings[num - 1].name = null;
            }
            else
            {
               this.m_game.PlayerSettings[num - 1].exist = false;
               this.m_game.PlayerSettings[num - 1].name = null;
               this.setPlayer(num,null);
            }
         }
         else
         {
            this.resetChipPosition(num);
            this.m_game.PlayerSettings[num - 1].exist = true;
            this.m_game.PlayerSettings[num - 1].human = true;
            this.m_game.PlayerSettings[num - 1].name = null;
         }
         this.updateControl(num);
         this.updatePlayerInfo(num);
         this.updateNamesDisplay();
         this.updateGameIsReady();
      }
      
      private function updateControl(num:int) : void
      {
         var display:MovieClip = this.m_charSelectionBoxes[num - 1];
         var chip:Chip = this.m_playerChips[num - 1];
         if(this.m_game.PlayerSettings[num - 1].exist)
         {
            display.gotoAndStop("on");
            if(this.m_game.PlayerSettings[num - 1].human)
            {
               display.playerTxt.visible = true;
               display.playerTitle.visible = true;
               display.levelDisplay.visible = false;
               display.nameDisplay.visible = true;
               chip.Visible = true;
               chip.MC.gotoAndStop("human" + num);
               display.playerTitle.nameTxt.text = "PLAYER" + num;
               display.controlType.gotoAndStop("human");
            }
            else
            {
               display.playerTxt.visible = true;
               display.playerTitle.visible = true;
               display.levelDisplay.visible = true;
               display.nameDisplay.visible = false;
               display.controlType.gotoAndStop("cpu");
               display.flag.visible = this.m_game.LevelData.teams;
               display.playerTitle.nameTxt.text = "PLAYER" + num;
               if(MovieClip(display.icon).getChildByName("mc") != null)
               {
                  Utils.setTint(MovieClip(display.icon).getChildByName("mc") as MovieClip,1,1,1,1,0,0,0,0);
               }
               chip.MC.gotoAndStop("cpu");
            }
         }
         else
         {
            display.playerTxt.visible = false;
            display.playerTitle.visible = false;
            display.controlType.gotoAndStop("na");
            display.levelDisplay.visible = false;
            display.nameDisplay.visible = false;
            display.flag.visible = false;
            display.playerTitle.nameTxt.text = "PLAYER" + num;
            chip.Visible = false;
            chip.LastHit = null;
            chip.MC.gotoAndStop("human" + num);
            display.gotoAndStop("off");
         }
      }
      
      public function showNamesKeypad(pid:int) : void
      {
         var display:MovieClip = this.m_charSelectionBoxes[pid - 1];
         var txt:String = display.nameDisplay.nameTxt.text;
         if(!display.nameDisplay.nameKeyPad.visible)
         {
            display.nameDisplay.nameKeyPad.visible = true;
            display.nameDisplay.nameTxt.text = "";
         }
         this.updateGameIsReady();
      }
      
      public function hideNamesKeypad(pid:int) : void
      {
         var i:int = 0;
         var display:MovieClip = this.m_charSelectionBoxes[pid - 1];
         var txt:String = display.nameDisplay.nameTxt.text;
         if(Boolean(display.nameDisplay.nameKeyPad.visible))
         {
            for(i = 0; i < this.m_game.PlayerSettings.length; i++)
            {
               if(Boolean(i + 1 !== pid) && Boolean(txt) && this.m_game.PlayerSettings[i].name === txt)
               {
                  SoundQueue.instance.playSoundEffect("menu_error");
                  return;
               }
            }
            this.m_game.PlayerSettings[pid - 1].name = txt == "" ? null : display.nameDisplay.nameTxt.text;
            display.nameDisplay.nameKeyPad.visible = false;
            if(!this.m_game.PlayerSettings[pid - 1].name)
            {
               display.nameDisplay.nameTxt.text = "P" + pid;
            }
            TextField(display.nameDisplay.nameTxt).textColor = 15658734;
            if(Boolean(SaveData.Controllers[pid - 1].GamepadInstance))
            {
               if(Boolean(this.m_game.PlayerSettings[pid - 1].name))
               {
                  SaveData.reimportNamedPlayerControls(pid,this.m_game.PlayerSettings[pid - 1].name);
               }
               else
               {
                  SaveData.reimportSlottedPlayerControls(pid);
               }
            }
         }
         this.updateGameIsReady();
      }
      
      private function updatePlayerInfo(num:int) : void
      {
         var display:MovieClip = this.m_charSelectionBoxes[num - 1];
         if(this.m_game.LevelData.teams && this.m_game.PlayerSettings[num - 1].exist)
         {
            display.charPortrait.gotoAndStop(this.m_game.PlayerSettings[num - 1].human ? "team" + this.m_game.PlayerSettings[num - 1].team : "cpu");
            display.playerTitle.gotoAndStop(this.m_game.PlayerSettings[num - 1].human ? "player" + this.m_game.PlayerSettings[num - 1].team : "cpu");
            display.flag.visible = this.m_game.LevelData.teams;
            display.flag.gotoAndStop(this.m_game.PlayerSettings[num - 1].team);
            display.playerTitle.nameTxt.text = "PLAYER" + num;
         }
         else if(this.m_game.PlayerSettings[num - 1].exist)
         {
            switch(num)
            {
               case 1:
                  display.charPortrait.gotoAndStop(this.m_game.PlayerSettings[num - 1].human ? "team1" : "cpu");
                  display.playerTitle.gotoAndStop(this.m_game.PlayerSettings[num - 1].human ? "player1" : "cpu");
                  break;
               case 2:
                  display.charPortrait.gotoAndStop(this.m_game.PlayerSettings[num - 1].human ? "team3" : "cpu");
                  display.playerTitle.gotoAndStop(this.m_game.PlayerSettings[num - 1].human ? "player3" : "cpu");
                  break;
               case 3:
                  display.charPortrait.gotoAndStop(this.m_game.PlayerSettings[num - 1].human ? "team4" : "cpu");
                  display.playerTitle.gotoAndStop(this.m_game.PlayerSettings[num - 1].human ? "player4" : "cpu");
                  break;
               case 4:
                  display.charPortrait.gotoAndStop(this.m_game.PlayerSettings[num - 1].human ? "team2" : "cpu");
                  display.playerTitle.gotoAndStop(this.m_game.PlayerSettings[num - 1].human ? "player2" : "cpu");
            }
            display.flag.visible = this.m_game.LevelData.teams;
            display.playerTitle.nameTxt.text = "PLAYER" + num;
         }
         else
         {
            display.playerTitle.visible = false;
            display.flag.visible = false;
         }
      }
      
      public function resetChipPosition(num:int) : void
      {
         if(num >= 0 && num < this.m_playerChips.length)
         {
            this.m_playerChips[num - 1].X = this.m_playerChips[num - 1].OriginalPosition.x;
            this.m_playerChips[num - 1].Y = this.m_playerChips[num - 1].OriginalPosition.y;
         }
      }
      
      public function updateLevelDisplay() : void
      {
         var display:MovieClip = null;
         for(var i:int = 0; i < this.m_charSelectionBoxes.length; i++)
         {
            display = this.m_charSelectionBoxes[i];
            display.levelDisplay.visible = !this.m_game.PlayerSettings[i].human && this.m_game.PlayerSettings[i].exist ? true : false;
            display.levelDisplay.levelHandle.y = -4 - 50 * ((this.m_game.PlayerSettings[i].level - 1) / 10);
            display.levelDisplay.levelTxt.text = this.m_game.PlayerSettings[i].level;
         }
      }
      
      public function updateNamesDisplay() : void
      {
         var display:MovieClip = null;
         for(var i:int = 0; i < this.m_charSelectionBoxes.length; i++)
         {
            display = this.m_charSelectionBoxes[i];
            display.nameDisplay.visible = this.m_game.PlayerSettings[i].human && this.m_game.PlayerSettings[i].exist ? true : false;
            display.nameDisplay.nameTxt.text = Boolean(this.m_game.PlayerSettings[i].name) ? this.m_game.PlayerSettings[i].name : "P" + (i + 1);
         }
      }
      
      public function setPlayerRandom(num:int) : void
      {
         this.setPlayer(num,null,-1);
         this.m_game.PlayerSettings[num - 1].character = Stats.getCharacterList()[Utils.randomInteger(0,Stats.getCharacterList().length - 1)];
         this.m_game.PlayerSettings[num - 1].exist = true;
         this.m_game.PlayerSettings[num - 1].expansion = -1;
         var correctIcon:MovieClip = null;
         if(Boolean(this.m_charMCHash[this.m_game.PlayerSettings[num - 1].character]))
         {
            correctIcon = this.m_charMCHash[this.m_game.PlayerSettings[num - 1].character];
         }
         else
         {
            this.m_game.PlayerSettings[num - 1].character = "random";
            correctIcon = this.m_charMCHash["random"];
         }
         if(Boolean(correctIcon))
         {
            this.m_playerChips[num - 1].MC.x = correctIcon.x;
            this.m_playerChips[num - 1].MC.y = correctIcon.y;
         }
      }
      
      public function updateDisplay() : void
      {
         var character:String = null;
         var display:MovieClip = null;
         var i:int = 0;
         if(this.m_game.GameMode == Mode.TRAINING)
         {
            this.setPlayerRandom(2);
         }
         this.updateLevelDisplay();
         this.updateNamesDisplay();
         for(i = 0; i < this.m_playerChips.length; i++)
         {
            this.m_playerChips[i].ExpansionNum = this.m_game.PlayerSettings[i].expansion;
            this.m_playerChips[i].Visible = this.m_game.PlayerSettings[i].exist ? true : false;
            this.m_playerChips[i].MC.gotoAndStop(this.m_game.PlayerSettings[i].human ? "human" + (i + 1) : "cpu");
            character = this.m_game.PlayerSettings[i].character;
            display = this.m_charSelectionBoxes[i];
            if(character != null)
            {
               this.changePic(i + 1,character,this.m_game.PlayerSettings[i].expansion);
               this.m_playerChips[i].LastHit = character;
            }
            else
            {
               display.playerTxt.text = "";
               this.removePic(i + 1);
               this.resetChipPosition(i + 1);
            }
            Utils.fitText(display.playerTxt,20,1);
            display.gotoAndStop(this.m_game.PlayerSettings[i].exist ? "on" : "off");
            display.nextExp.visible = this.m_game.PlayerSettings[i].character == "xp";
            this.updatePlayerInfo(i + 1);
            if(!this.m_game.PlayerSettings[i].exist)
            {
               display.controlType.gotoAndStop("na");
               display.gotoAndStop("off");
            }
            else if(!this.m_game.PlayerSettings[i].human)
            {
               display.controlType.gotoAndStop("cpu");
            }
            else
            {
               display.controlType.gotoAndStop("human");
            }
            this.updateControl(i + 1);
         }
         if(ModeFeatures.hasFeature(ModeFeatures.ALLOW_FFA_TEAM_TOGGLE,this.m_game.GameMode) && ModeFeatures.hasFeature(ModeFeatures.ALLOW_FFA_TEAM_TOGGLE,this.m_game.GameMode) && Boolean(m_subMenu.bnGameMode))
         {
            m_subMenu.bnGameMode.gameModeTxt.gotoAndStop(this.m_game.LevelData.teams ? "team" : "ffa");
         }
         if(ModeFeatures.hasFeature(ModeFeatures.ALLOW_FFA_TEAM_TOGGLE,this.m_game.GameMode) && ModeFeatures.hasFeature(ModeFeatures.ALLOW_FFA_TEAM_TOGGLE,this.m_game.GameMode) && Boolean(m_subMenu.bnGameMode))
         {
            this.updateIncDecDisplay();
         }
         this.updateGameIsReady();
         this.updateSeriesIconColors();
      }
      
      public function hasVisibleKeypad() : Boolean
      {
         for(var j:int = 1; j <= this.m_charSelectionBoxes.length; j++)
         {
            if(Boolean(this.m_charSelectionBoxes[j - 1].nameDisplay.nameKeyPad.visible))
            {
               return true;
            }
         }
         return false;
      }
      
      public function gameIsReady() : Boolean
      {
         if(MultiplayerManager.Connected || ModeFeatures.hasFeature(ModeFeatures.ALLOW_SINGLE_PLAYER,this.m_game.GameMode))
         {
            return this.singlePlayerReady();
         }
         var count:Number = 0;
         var minimum:int = 2;
         var lastTeam:Number = 999;
         var nameEntry:Boolean = false;
         for(var i:int = 0; i < this.m_game.PlayerSettings.length; i++)
         {
            if(count < minimum)
            {
               if(this.m_game.PlayerSettings[i].character != null && this.m_game.PlayerSettings[i].team != lastTeam || this.m_game.PlayerSettings[i].character != null && this.m_game.PlayerSettings[i].team == -1)
               {
                  lastTeam = this.m_game.PlayerSettings[i].team;
                  count++;
               }
            }
         }
         if(this.hasVisibleKeypad())
         {
            nameEntry = true;
         }
         if(count >= minimum && this.m_readyDelay.IsComplete && !(this.m_game.GameMode == Mode.TRAINING && this.m_game.PlayerSettings[0].character == null) && !nameEntry)
         {
            return true;
         }
         return false;
      }
      
      private function singlePlayerReady() : Boolean
      {
         if(this.m_game.PlayerSettings[0].character != null)
         {
            return true;
         }
         return false;
      }
      
      public function incrementShortcut() : void
      {
         if(this.m_game.UsingLives)
         {
            SaveData.toggleStock(true);
            this.m_game.LevelData.lives = SaveData.Lives;
         }
         else
         {
            SaveData.toggleTime(true);
            this.m_game.LevelData.time = SaveData.Time;
         }
         this.m_game.loadSavedVSOptions();
         this.updateIncDecDisplay();
      }
      
      public function decrementShortcut() : void
      {
         if(this.m_game.UsingLives)
         {
            SaveData.toggleStock(false);
         }
         else
         {
            SaveData.toggleTime(false);
         }
         this.m_game.loadSavedVSOptions();
         this.updateIncDecDisplay();
      }
      
      private function updateIncDecDisplay() : void
      {
         if(this.m_game.UsingLives)
         {
            m_subMenu.match_desc.text = "-man survival fest!";
            m_subMenu.opCount.text = this.m_game.Lives;
         }
         else
         {
            m_subMenu.match_desc.text = "-minute KO test!";
            m_subMenu.opCount.text = this.m_game.Time;
         }
      }
      
      public function setPlayer(num:int, character:String, expansionNum:Number = -1) : void
      {
         if(character == null && this.m_game.PlayerSettings[num - 1].character != null)
         {
            this.removePic(num);
            this.m_game.PlayerSettings[num - 1].character = null;
            this.m_game.PlayerSettings[num - 1].costume = -1;
         }
         else if(character != null && this.m_game.PlayerSettings[num - 1].exist)
         {
            if(this.m_game.PlayerSettings[num - 1].character != character || character == "xp" && ResourceManager.TotalExpansions != 0)
            {
               this.m_game.PlayerSettings[num - 1].costume = -1;
               this.m_game.PlayerSettings[num - 1].character = character;
               this.m_game.PlayerSettings[num - 1].expansion = expansionNum;
               this.changePic(num,character,expansionNum);
               if(this.costumeExistsElsewhere(this.m_game.PlayerSettings[num - 1].costume,num))
               {
                  this.nextCostume(num);
               }
            }
         }
         this.updateGameIsReady();
      }
      
      public function updateGameIsReady() : void
      {
         if(this.gameIsReady() && !MenuController.CurrentCharacterSelectMenu.SubMenu.readyToFight.visible)
         {
            MenuController.CurrentCharacterSelectMenu.SubMenu.readyToFight.gotoAndPlay(2);
            MenuController.CurrentCharacterSelectMenu.SubMenu.readyToFight.visible = true;
         }
         else if(!this.gameIsReady() && Boolean(MenuController.CurrentCharacterSelectMenu.SubMenu.readyToFight.visible))
         {
            MenuController.CurrentCharacterSelectMenu.SubMenu.readyToFight.gotoAndStop(1);
            MenuController.CurrentCharacterSelectMenu.SubMenu.readyToFight.visible = false;
         }
      }
   }
}

