package com.mcleodgaming.ssf2.audio
{
   import flash.events.Event;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.media.SoundTransform;
   
   public class SoundObject
   {
      
      private var m_name:String;
      
      private var m_sound:Sound;
      
      private var m_channel:SoundChannel;
      
      private var m_volume:Number;
      
      private var m_isPlaying:Boolean;
      
      private var m_isFinished:Boolean;
      
      private var m_currentPosition:Number;
      
      private var m_error:Boolean;
      
      private var m_queuedObjects:Vector.<Object>;
      
      private var m_loopFunction:Function;
      
      public function SoundObject()
      {
         super();
         this.m_name = null;
         this.m_channel = null;
         this.m_sound = null;
         this.m_isPlaying = false;
         this.m_isFinished = false;
         this.m_currentPosition = 0;
         this.m_error = false;
         this.m_queuedObjects = new Vector.<Object>();
         this.m_loopFunction = null;
      }
      
      public function get Channel() : SoundChannel
      {
         return this.m_channel;
      }
      
      public function get SoundInstance() : Sound
      {
         return this.m_sound;
      }
      
      public function get LoopFunction() : Function
      {
         return this.m_loopFunction;
      }
      
      public function set LoopFunction(value:Function) : void
      {
         this.m_loopFunction = value;
      }
      
      public function get Volume() : Number
      {
         return this.m_volume;
      }
      
      public function get IsPlaying() : Boolean
      {
         return this.m_isPlaying;
      }
      
      public function get IsFinished() : Boolean
      {
         return this.m_isFinished;
      }
      
      public function get CurrentPosition() : Number
      {
         return this.m_currentPosition;
      }
      
      public function get IsError() : Boolean
      {
         return this.m_error;
      }
      
      public function get Name() : String
      {
         return this.m_name;
      }
      
      public function play(sound:Sound, volume:Number, name:String) : void
      {
         if(sound != null)
         {
            volume = Math.min(1,volume);
            volume = Math.max(0,volume);
            if(Boolean(this.m_channel))
            {
               this.m_channel.stop();
            }
            this.m_sound = null;
            this.m_sound = sound;
            this.m_volume = volume;
            this.m_name = name;
            this.m_channel = this.m_sound.play(0,0,new SoundTransform(this.m_volume));
            if(this.m_channel == null)
            {
               this.m_error = true;
               this.m_isFinished = true;
            }
            else
            {
               this.m_channel.addEventListener(Event.SOUND_COMPLETE,this.finish);
               this.m_isPlaying = true;
            }
         }
      }
      
      public function restart(e:Event = null) : void
      {
         if(this.m_loopFunction != null)
         {
            this.m_channel.removeEventListener(Event.SOUND_COMPLETE,this.m_loopFunction);
         }
         if(Boolean(this.m_channel))
         {
            this.m_channel.stop();
         }
         this.m_channel = this.m_sound.play(0,0,new SoundTransform(this.m_volume));
         this.m_channel.addEventListener(Event.SOUND_COMPLETE,this.m_loopFunction);
         this.m_isPlaying = true;
         this.m_isFinished = false;
      }
      
      public function pause() : void
      {
         if(this.m_isPlaying)
         {
            this.m_channel.removeEventListener(Event.SOUND_COMPLETE,this.finish);
            this.m_isPlaying = false;
            this.m_currentPosition = this.m_channel.position;
            this.m_channel.stop();
         }
      }
      
      public function unpause() : void
      {
         if(!this.m_isFinished)
         {
            if(this.m_loopFunction != null)
            {
               this.m_channel.removeEventListener(Event.SOUND_COMPLETE,this.m_loopFunction);
            }
            this.m_channel = this.m_sound.play(this.m_currentPosition,0,new SoundTransform(this.m_volume));
            if(this.m_channel != null)
            {
               this.m_channel.addEventListener(Event.SOUND_COMPLETE,this.finish);
               if(this.m_loopFunction != null)
               {
                  this.m_channel.addEventListener(Event.SOUND_COMPLETE,this.m_loopFunction);
               }
               this.m_isPlaying = true;
            }
            else
            {
               this.m_isFinished = true;
            }
         }
      }
      
      public function stop() : void
      {
         if(this.m_isPlaying)
         {
            this.m_channel.removeEventListener(Event.SOUND_COMPLETE,this.finish);
            this.m_channel.stop();
            this.m_isPlaying = false;
            this.m_isFinished = true;
         }
      }
      
      private function finish(e:Event) : void
      {
         this.m_channel.removeEventListener(Event.SOUND_COMPLETE,this.finish);
         this.m_isFinished = true;
         this.m_isPlaying = false;
         if(this.m_queuedObjects.length > 0)
         {
            if(this.m_queuedObjects[0].sound is Function)
            {
               this.m_queuedObjects[0].sound();
            }
            else if(this.m_queuedObjects[0].sound is Sound)
            {
               this.play(this.m_queuedObjects[0].sound,this.m_queuedObjects[0].volume,this.m_queuedObjects[0].name);
            }
            this.m_queuedObjects.splice(0,1);
         }
      }
      
      public function queueSound(sound:Sound, volume:Number, name:String) : void
      {
         var obj:Object = new Object();
         obj.sound = sound;
         obj.volume = volume;
         obj.name = name;
         this.m_queuedObjects.push(obj);
      }
      
      public function queueFunction(fn:Function) : void
      {
         var obj:Object = new Object();
         obj.sound = fn;
         this.m_queuedObjects.push(obj);
      }
   }
}

