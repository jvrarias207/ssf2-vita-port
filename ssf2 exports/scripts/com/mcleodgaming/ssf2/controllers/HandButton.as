package com.mcleodgaming.ssf2.controllers
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class HandButton
   {
      
      protected var m_button:MovieClip;
      
      public function HandButton(button:MovieClip)
      {
         super();
         this.m_button = button;
      }
      
      public function get ButtonInstance() : MovieClip
      {
         return this.m_button;
      }
      
      public function makeEvents() : void
      {
         this.m_button.addEventListener(MouseEvent.ROLL_OVER,this.button_ROLLOVER);
         this.m_button.addEventListener(MouseEvent.CLICK,this.button_CLICK);
         this.m_button.addEventListener(MouseEvent.ROLL_OUT,this.button_ROLLOUT);
         this.m_button.addEventListener(MouseEvent.MOUSE_OVER,this.button_MOUSEOVER);
         this.m_button.addEventListener(MouseEvent.MOUSE_OUT,this.button_MOUSEOUT);
      }
      
      public function killEvents() : void
      {
         this.m_button.removeEventListener(MouseEvent.ROLL_OVER,this.button_ROLLOVER);
         this.m_button.removeEventListener(MouseEvent.CLICK,this.button_CLICK);
         this.m_button.removeEventListener(MouseEvent.ROLL_OUT,this.button_ROLLOUT);
         this.m_button.removeEventListener(MouseEvent.MOUSE_OVER,this.button_MOUSEOVER);
         this.m_button.removeEventListener(MouseEvent.MOUSE_OUT,this.button_MOUSEOUT);
      }
      
      public function rollover() : void
      {
         this.button_ROLLOVER(null);
      }
      
      public function click() : void
      {
         this.button_CLICK(null);
      }
      
      public function rollout() : void
      {
         this.button_ROLLOUT(null);
      }
      
      public function mouseover() : void
      {
         this.button_MOUSEOVER(null);
      }
      
      public function mouseout() : void
      {
         this.button_MOUSEOUT(null);
      }
      
      protected function button_ROLLOVER(e:MouseEvent) : void
      {
      }
      
      protected function button_CLICK(e:MouseEvent) : void
      {
      }
      
      protected function button_ROLLOUT(e:MouseEvent) : void
      {
      }
      
      protected function button_MOUSEOVER(e:MouseEvent) : void
      {
      }
      
      protected function button_MOUSEOUT(e:MouseEvent) : void
      {
      }
   }
}

