package com.mcleodgaming.ssf2.menus
{
   import flash.display.MovieClip;
   
   public class MenuMapperNode
   {
      
      private var m_up:Array;
      
      private var m_down:Array;
      
      private var m_left:Array;
      
      private var m_right:Array;
      
      private var m_pressFunction:Function;
      
      private var m_hoverFunction:Function;
      
      private var m_outFunction:Function;
      
      private var m_backFunction:Function;
      
      private var m_upFunction:Function;
      
      private var m_downFunction:Function;
      
      private var m_leftFunction:Function;
      
      private var m_rightFunction:Function;
      
      public var preFunctionMode:Boolean;
      
      public var clip:MovieClip;
      
      public function MenuMapperNode(mc:MovieClip, up:Array = null, down:Array = null, left:Array = null, right:Array = null, hoverFunc:Function = null, outFunc:Function = null, pressFunc:Function = null, backFunc:Function = null, upFunc:Function = null, downFunc:Function = null, leftFunc:Function = null, rightFunc:Function = null)
      {
         super();
         this.clip = mc;
         this.m_up = up;
         this.m_down = down;
         this.m_left = left;
         this.m_right = right;
         this.m_hoverFunction = hoverFunc;
         this.m_outFunction = outFunc;
         this.m_upFunction = upFunc;
         this.m_downFunction = downFunc;
         this.m_leftFunction = leftFunc;
         this.m_rightFunction = rightFunc;
         this.m_pressFunction = pressFunc;
         this.m_backFunction = backFunc;
         this.preFunctionMode = true;
      }
      
      public function get Up() : Array
      {
         return this.m_up;
      }
      
      public function set Up(node:Array) : void
      {
         this.m_up = node;
      }
      
      public function get Down() : Array
      {
         return this.m_down;
      }
      
      public function set Down(node:Array) : void
      {
         this.m_down = node;
      }
      
      public function get Left() : Array
      {
         return this.m_left;
      }
      
      public function set Left(node:Array) : void
      {
         this.m_left = node;
      }
      
      public function get Right() : Array
      {
         return this.m_right;
      }
      
      public function set Right(node:Array) : void
      {
         this.m_right = node;
      }
      
      public function hoverFunction() : void
      {
         if(this.m_hoverFunction != null)
         {
            this.m_hoverFunction(null);
         }
      }
      
      public function outFunction() : void
      {
         if(this.m_outFunction != null)
         {
            this.m_outFunction(null);
         }
      }
      
      public function pressFunction() : void
      {
         if(this.m_pressFunction != null)
         {
            this.m_pressFunction(null);
         }
      }
      
      public function backFunction() : void
      {
         if(this.m_backFunction != null)
         {
            this.m_backFunction(null);
         }
      }
      
      public function upFunction() : void
      {
         if(this.m_upFunction != null)
         {
            this.m_upFunction(null);
         }
      }
      
      public function downFunction() : void
      {
         if(this.m_downFunction != null)
         {
            this.m_downFunction(null);
         }
      }
      
      public function leftFunction() : void
      {
         if(this.m_leftFunction != null)
         {
            this.m_leftFunction(null);
         }
      }
      
      public function rightFunction() : void
      {
         if(this.m_rightFunction != null)
         {
            this.m_rightFunction(null);
         }
      }
      
      public function pushToFront(node:MenuMapperNode) : void
      {
         if(node == null)
         {
            return;
         }
         var index:int = 0;
         if(Boolean(this.m_up))
         {
            index = this.m_up.indexOf(node);
            if(index >= 0)
            {
               node = this.m_up[index];
               this.m_up.splice(index,1);
               this.m_up.unshift(node);
            }
         }
         if(Boolean(this.m_down))
         {
            index = this.m_down.indexOf(node);
            if(index >= 0)
            {
               node = this.m_down[index];
               this.m_down.splice(index,1);
               this.m_down.unshift(node);
            }
         }
         if(Boolean(this.m_left))
         {
            index = this.m_left.indexOf(node);
            if(index >= 0)
            {
               node = this.m_left[index];
               this.m_left.splice(index,1);
               this.m_left.unshift(node);
            }
         }
         if(Boolean(this.m_right))
         {
            index = this.m_right.indexOf(node);
            if(index >= 0)
            {
               node = this.m_right[index];
               this.m_right.splice(index,1);
               this.m_right.unshift(node);
            }
         }
      }
      
      public function updateNodes(up:Array = null, down:Array = null, left:Array = null, right:Array = null, hoverFunc:Function = null, outFunc:Function = null, pressFunc:Function = null, backFunc:Function = null, upFunc:Function = null, downFunc:Function = null, leftFunc:Function = null, rightFunc:Function = null) : void
      {
         this.m_up = null;
         this.m_down = null;
         this.m_left = null;
         this.m_right = null;
         this.m_up = up;
         this.m_down = down;
         this.m_left = left;
         this.m_right = right;
         this.m_hoverFunction = hoverFunc;
         this.m_outFunction = outFunc;
         this.m_upFunction = upFunc;
         this.m_downFunction = downFunc;
         this.m_leftFunction = leftFunc;
         this.m_rightFunction = rightFunc;
         this.m_pressFunction = pressFunc;
         this.m_backFunction = backFunc;
      }
      
      public function dispose() : void
      {
         this.m_up = null;
         this.m_down = null;
         this.m_left = null;
         this.m_right = null;
      }
   }
}

