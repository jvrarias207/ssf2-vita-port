package com.mcleodgaming.ssf2.controllers
{
   import com.mcleodgaming.ssf2.events.GamepadEvent;
   import fl.controls.ComboBox;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   
   public class QualitySelectHand extends SelectHand
   {
      
      public function QualitySelectHand(targetMC:MovieClip, buttons:Vector.<HandButton>, backFunc:Function)
      {
         super(targetMC,buttons,backFunc);
         START_POSITION.x = -295;
         START_POSITION.y = 113;
         BOUNDS_RECT.x = -300;
         BOUNDS_RECT.y = -165;
         BOUNDS_RECT.width = 580;
         BOUNDS_RECT.height = 360;
      }
      
      override protected function checkHit(e:Event) : void
      {
         var length:int = 0;
         var index:int = 0;
         var isInputEvent:Boolean = e is KeyboardEvent || e is GamepadEvent;
         var j:int = 0;
         var comboBoxes:Vector.<ComboBox> = new Vector.<ComboBox>();
         comboBoxes.push(MenuController.qualityMenu.FullScreenQualityComboBox);
         comboBoxes.push(MenuController.qualityMenu.DisplayQualityComboBox);
         comboBoxes.push(MenuController.qualityMenu.StageEffectsQualityComboBox);
         comboBoxes.push(MenuController.qualityMenu.GlobalEffectsQualityComboBox);
         comboBoxes.push(MenuController.qualityMenu.HitEffectsComboBox);
         comboBoxes.push(MenuController.qualityMenu.HUDAlphaQualityComboBox);
         comboBoxes.push(MenuController.qualityMenu.KnockbackSmokeQualityComboBox);
         comboBoxes.push(MenuController.qualityMenu.ScreenFlashQualityComboBox);
         comboBoxes.push(MenuController.qualityMenu.ShadowsQualityComboBox);
         comboBoxes.push(MenuController.qualityMenu.WeatherQualityComboBox);
         comboBoxes.push(MenuController.qualityMenu.AmbientLightingQualityComboBox);
         comboBoxes.push(MenuController.qualityMenu.MenuBGQualityComboBox);
         for(var i:int = 0; i < comboBoxes.length; i++)
         {
            if(checkBounds(comboBoxes[i],comboBoxes[i].parent.parent) && m_hand.visible && isInputEvent)
            {
               length = comboBoxes[i].length;
               index = comboBoxes[i].selectedIndex + 1 < length ? int(comboBoxes[i].selectedIndex + 1) : 0;
               for(j = 0; j < m_players.length; j++)
               {
                  if(m_players[j].IsDown(m_players[j]._BUTTON2))
                  {
                     comboBoxes[i].selectedIndex = index;
                     comboBoxes[i].dispatchEvent(new Event(Event.CHANGE));
                  }
               }
            }
         }
         super.checkHit(e);
      }
   }
}

