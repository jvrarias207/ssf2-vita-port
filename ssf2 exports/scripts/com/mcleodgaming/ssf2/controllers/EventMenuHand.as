package com.mcleodgaming.ssf2.controllers
{
   import com.mcleodgaming.ssf2.util.*;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class EventMenuHand extends SelectHand
   {
      
      public var topBoundPush:Function;
      
      public var bottomBoundPush:Function;
      
      public function EventMenuHand(targetMC:MovieClip, buttons:Vector.<EventButton>, backFunc:Function)
      {
         var convertedButtons:Vector.<HandButton> = new Vector.<HandButton>();
         for(var i:int = 0; i < buttons.length; i++)
         {
            convertedButtons.push(buttons[i]);
         }
         super(targetMC,convertedButtons,backFunc);
         START_POSITION.x = -246;
         START_POSITION.y = -115;
         BOUNDS_RECT.x = -287;
         BOUNDS_RECT.y = -115;
         BOUNDS_RECT.width = 585;
         BOUNDS_RECT.height = 240;
         resetPosition();
      }
      
      override protected function checkControls(e:Event) : void
      {
         var i:int = 0;
         if(m_hand.y <= BOUNDS_RECT.y && this.topBoundPush !== null)
         {
            for(i = 0; i < m_players.length; i++)
            {
               if(m_players[i].IsDown(m_players[i]._UP))
               {
                  this.topBoundPush();
                  break;
               }
            }
         }
         else if(m_hand.y >= BOUNDS_RECT.y + BOUNDS_RECT.height && this.bottomBoundPush !== null)
         {
            for(i = 0; i < m_players.length; i++)
            {
               if(m_players[i].IsDown(m_players[i]._DOWN))
               {
                  this.bottomBoundPush();
                  break;
               }
            }
         }
         super.checkControls(e);
      }
      
      override protected function checkBounds(mc:DisplayObject, coordinateSpaceOverride:DisplayObject = null) : Boolean
      {
         return super.checkBounds(mc,mc.parent.parent);
      }
   }
}

