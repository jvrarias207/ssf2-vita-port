package com.mcleodgaming.ssf2.controllers
{
   import com.mcleodgaming.ssf2.util.*;
   import flash.display.MovieClip;
   
   public class StageSwitchHand extends SelectHand
   {
      
      public function StageSwitchHand(targetMC:MovieClip, buttons:Vector.<StageSwitchButton>, backFunc:Function)
      {
         var convertedButtons:Vector.<HandButton> = new Vector.<HandButton>();
         for(var i:int = 0; i < buttons.length; i++)
         {
            convertedButtons.push(buttons[i]);
         }
         super(targetMC,convertedButtons,backFunc);
         var mappings:Object = ResourceManager.getResourceByID("mappings").getProp("metadata");
         var screen:Object = mappings.stage_switch_screen;
         START_POSITION.x = screen.hand_start.x;
         START_POSITION.y = screen.hand_start.y;
         BOUNDS_RECT.x = screen.hand_bounds.x;
         BOUNDS_RECT.y = screen.hand_bounds.y;
         BOUNDS_RECT.width = screen.hand_bounds.width;
         BOUNDS_RECT.height = screen.hand_bounds.height;
      }
   }
}

