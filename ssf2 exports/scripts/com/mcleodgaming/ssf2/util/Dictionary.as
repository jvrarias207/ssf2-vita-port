package com.mcleodgaming.ssf2.util
{
   public class Dictionary
   {
      
      private var m_keys:Array;
      
      private var m_values:Array;
      
      private var m_type:Class;
      
      public function Dictionary(type:Class)
      {
         super();
         this.m_keys = new Array();
         this.m_values = new Array();
         if(type == null)
         {
            this.m_type = Object;
         }
         else
         {
            this.m_type = type;
         }
      }
      
      public function get length() : int
      {
         return this.m_keys.length;
      }
      
      public function get Keys() : Array
      {
         var arr:Array = new Array();
         for(var i:int = 0; i < this.m_keys.length; i++)
         {
            arr.push(this.m_keys[i]);
         }
         return arr;
      }
      
      public function get Values() : Array
      {
         var arr:Array = new Array();
         for(var i:int = 0; i < this.m_values.length; i++)
         {
            arr.push(this.m_values[i]);
         }
         return arr;
      }
      
      public function push(name:String, obj:*) : Boolean
      {
         if(!(obj is Object))
         {
            trace("Error, attempt to add an Object that does not match the defined type: " + this.m_type);
            return false;
         }
         if(!this.containsKey(name))
         {
            this.m_keys.push(name);
            this.m_values.push(obj);
         }
         else
         {
            trace("Warning, attempted to provide a duplicate key \"" + name + "\". This key\'s value has been replaced by the new Object.");
            this.m_values[this.m_keys.indexOf(name)] = obj;
         }
         return true;
      }
      
      public function pop() : *
      {
         if(this.m_keys.length > 0)
         {
            return this.remove(this.m_keys[this.m_keys.length - 1]);
         }
         return null;
      }
      
      public function remove(name:String) : *
      {
         var index:int = this.m_keys.indexOf(name);
         if(index < 0)
         {
            trace("Error removing key: " + name);
            return null;
         }
         var obj:* = this.m_values[index];
         this.m_values[index] = null;
         this.m_values.splice(index,1);
         this.m_keys.splice(index,1);
         return obj;
      }
      
      public function getValue(value:*) : String
      {
         if(value == null)
         {
            return null;
         }
         var index:int = this.m_values.indexOf(value);
         if(index < 0)
         {
            return null;
         }
         return this.m_keys[index];
      }
      
      public function getKey(key:String) : *
      {
         for(var i:int = 0; i < this.m_keys.length; i++)
         {
            if(this.m_keys[i] == key)
            {
               return this.m_values[i];
            }
         }
         return null;
      }
      
      public function setKey(key:String, obj:*) : void
      {
         var index:int = 0;
         if(this.containsKey(key))
         {
            index = this.m_keys.indexOf(key);
            if(!(obj is this.m_type))
            {
               trace("Error, attempt to add an Object that does not match the defined type: " + this.m_type);
               return;
            }
            this.m_values[index] = null;
            this.m_values[index] = obj;
         }
         else
         {
            this.push(key,obj);
         }
      }
      
      public function containsKey(name:String) : Boolean
      {
         return this.getKey(name) != null;
      }
      
      public function containsValue(value:*) : Boolean
      {
         return this.getValue(value) != null;
      }
      
      public function clear() : void
      {
         this.m_keys.splice(0);
         this.m_values.splice(0);
      }
   }
}

