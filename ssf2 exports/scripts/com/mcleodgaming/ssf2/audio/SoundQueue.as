package com.mcleodgaming.ssf2.audio
{
   import com.mcleodgaming.ssf2.util.*;
   import flash.events.Event;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.media.SoundTransform;
   
   public class SoundQueue
   {
      
      public static var instance:SoundQueue = new SoundQueue();
      
      private var m_sounds:Vector.<SoundObject>;
      
      private var m_index:int;
      
      private var m_musicIsPlaying:Boolean;
      
      private var m_musicIsOgg:Boolean;
      
      private var m_musicIsMuted:Boolean;
      
      private var m_currentSong:SoundChannel;
      
      private var m_currentSongID:String;
      
      private var m_queueSize:int;
      
      private var m_nextSongID:String;
      
      private var m_loopLocation:Number;
      
      private var m_loopFunction:Function;
      
      private var m_nextSongLoopLocation:Number;
      
      private var m_suppressorEnabled:Boolean;
      
      private var m_suppressorHash:Object;
      
      public function SoundQueue()
      {
         super();
         this.m_queueSize = 60;
         this.m_sounds = new Vector.<SoundObject>(this.m_queueSize,true);
         this.m_index = 0;
         this.m_musicIsPlaying = false;
         this.m_musicIsMuted = false;
         this.m_musicIsOgg = false;
         this.m_currentSong = null;
         this.m_currentSongID = null;
         this.m_nextSongID = null;
         this.m_nextSongLoopLocation = 0;
         this.m_loopLocation = 0;
         this.m_loopFunction = this.loopMusic;
         this.m_suppressorEnabled = false;
         this.m_suppressorHash = null;
      }
      
      public function enableDuplicateSupressor() : void
      {
         if(!this.m_suppressorEnabled)
         {
            this.m_suppressorEnabled = true;
         }
      }
      
      public function disableDuplicateSupressor() : void
      {
         if(this.m_suppressorEnabled)
         {
            this.m_suppressorEnabled = false;
            this.m_suppressorHash = null;
         }
      }
      
      public function clearSurpressor() : void
      {
         this.m_suppressorHash = null;
      }
      
      public function nextMusic(event:Event) : void
      {
         var oggFormat:Boolean = false;
         if(this.m_nextSongID.indexOf(".ogg|") == 0)
         {
            oggFormat = true;
         }
         var tempSound:* = null;
         if(oggFormat)
         {
            tempSound = new (ResourceManager.getLibraryClass(this.m_nextSongID.substr(5)))();
            this.m_musicIsOgg = true;
         }
         else
         {
            tempSound = ResourceManager.getLibrarySound(this.m_nextSongID);
            this.m_musicIsOgg = false;
         }
         if(tempSound != null)
         {
            if(!this.m_musicIsOgg)
            {
               this.m_currentSong.removeEventListener(Event.SOUND_COMPLETE,this.nextMusic);
               this.m_currentSong = tempSound.play(0,0,new SoundTransform(this.m_musicIsMuted ? 0 : SaveData.BGVolumeLevel));
               this.m_currentSongID = this.m_nextSongID;
               this.m_loopLocation = this.m_nextSongLoopLocation;
               this.m_loopFunction = this.loopMusic;
               if(this.m_currentSong != null)
               {
                  this.m_currentSong.addEventListener(Event.SOUND_COMPLETE,this.m_loopFunction);
                  this.m_musicIsPlaying = true;
               }
            }
         }
      }
      
      public function setNextMusic(id:String, loopLoc:Number) : void
      {
         this.m_nextSongID = id;
         this.m_nextSongLoopLocation = loopLoc;
      }
      
      public function get LoopLocation() : Number
      {
         return this.m_loopLocation;
      }
      
      public function get NextSongLoopLocation() : Number
      {
         return this.m_loopLocation;
      }
      
      public function get CurrentSong() : SoundChannel
      {
         return this.m_currentSong;
      }
      
      public function get CurrentSongID() : String
      {
         return this.m_currentSongID;
      }
      
      public function get MusicIsMuted() : Boolean
      {
         return this.m_musicIsMuted;
      }
      
      public function set MusicIsMuted(value:Boolean) : void
      {
         this.m_musicIsMuted = value;
         if(this.m_musicIsPlaying)
         {
            this.setMusicVolume(this.m_musicIsMuted ? 0 : SaveData.BGVolumeLevel);
         }
      }
      
      public function setLoopFunction(func:Function) : void
      {
         this.m_loopFunction = func;
      }
      
      public function getSoundObject(loc:int) : SoundObject
      {
         return loc >= 0 && loc < this.m_sounds.length && this.m_sounds[loc] != null ? this.m_sounds[loc] : null;
      }
      
      public function playMusic(soundName:String, loopLoc:Number) : void
      {
         var songChoices:Array = null;
         var tempSound:* = undefined;
         if(!soundName)
         {
            this.stopMusic();
            return;
         }
         if(soundName === "menumusic")
         {
            if(this.m_currentSongID === "menumusic1" || this.m_currentSongID === "menumusic2" || this.m_currentSongID === "meleemenu2")
            {
               soundName = this.m_currentSongID;
            }
            else
            {
               songChoices = ["menumusic1","menumusic2","meleemenu2"];
               soundName = "menumusic1";
               this.m_loopLocation = 0;
               if(Boolean(SaveData.Unlocks.alternate_tracks))
               {
                  soundName = songChoices[Utils.safeRandomInteger(0,2)];
                  if(soundName === "meleemenu2")
                  {
                     this.m_loopLocation = 173;
                  }
               }
            }
         }
         var oggFormat:Boolean = false;
         if(soundName.indexOf(".ogg|") == 0)
         {
            oggFormat = true;
         }
         if(soundName == this.m_currentSongID)
         {
            return;
         }
         this.m_loopLocation = loopLoc;
         if(this.m_musicIsPlaying)
         {
            this.stopMusic();
         }
         if(soundName != null)
         {
            tempSound = null;
            if(oggFormat)
            {
               tempSound = new (ResourceManager.getLibraryClass(soundName.substr(5)))();
               this.m_musicIsOgg = true;
            }
            else
            {
               tempSound = ResourceManager.getLibrarySound(soundName);
               this.m_musicIsOgg = false;
            }
            if(tempSound != null)
            {
               if(!this.m_musicIsOgg)
               {
                  this.m_currentSong = tempSound.play(0,0,new SoundTransform(this.m_musicIsMuted ? 0 : SaveData.BGVolumeLevel));
                  if(this.m_currentSong != null)
                  {
                     this.m_currentSongID = soundName;
                     this.m_currentSong.addEventListener(Event.SOUND_COMPLETE,this.m_loopFunction);
                     this.m_musicIsPlaying = true;
                  }
               }
            }
         }
      }
      
      public function loopMusic(event:Event) : void
      {
         var tempSoundOgg:* = undefined;
         var tempSound:Sound = null;
         if(this.m_musicIsOgg)
         {
            tempSoundOgg = new (ResourceManager.getLibraryClass(this.m_currentSongID.substr(5)))();
            if(tempSoundOgg != null)
            {
            }
         }
         else if(this.m_loopLocation >= 0)
         {
            tempSound = ResourceManager.getLibrarySound(this.m_currentSongID);
            if(tempSound != null)
            {
               this.m_currentSong.removeEventListener(Event.SOUND_COMPLETE,this.loopMusic);
               this.m_currentSong = tempSound.play(this.m_loopLocation,0,new SoundTransform(this.m_musicIsMuted ? 0 : this.m_currentSong.soundTransform.volume));
               if(this.m_currentSong != null)
               {
                  this.m_currentSong.addEventListener(Event.SOUND_COMPLETE,this.m_loopFunction);
                  this.m_musicIsPlaying = true;
               }
            }
         }
         else
         {
            this.m_musicIsPlaying = false;
         }
      }
      
      public function setMusicVolume(num:Number) : void
      {
         if(!this.m_musicIsOgg)
         {
            if(Boolean(this.m_currentSong))
            {
               this.m_currentSong.soundTransform = new SoundTransform(num);
            }
         }
      }
      
      public function stopMusic() : void
      {
         if(this.m_musicIsPlaying)
         {
            if(!this.m_musicIsOgg)
            {
               if(Boolean(this.m_currentSong))
               {
                  this.m_currentSong.removeEventListener(Event.SOUND_COMPLETE,this.m_loopFunction);
                  this.m_currentSong.stop();
                  this.m_currentSong = null;
               }
            }
            this.m_currentSongID = null;
            this.m_musicIsPlaying = false;
         }
      }
      
      public function playSoundEffect(sound:String, scaleVolume:Number = 1) : int
      {
         var sc:SoundObject = null;
         var oldIndex:Number = NaN;
         if(Boolean(this.m_suppressorHash) && Boolean(this.m_suppressorHash[sound]))
         {
            return -1;
         }
         if(this.m_suppressorEnabled)
         {
            this.m_suppressorHash = this.m_suppressorHash || {};
            this.m_suppressorHash[sound] = true;
         }
         var tempSound:Sound = ResourceManager.getLibrarySound(sound);
         if(tempSound == null)
         {
            tempSound = ResourceManager.getLibrarySound(sound);
         }
         if(tempSound != null)
         {
            if(this.m_sounds[this.m_index] != null && this.m_sounds[this.m_index] != undefined)
            {
               this.m_sounds[this.m_index].stop();
            }
            if(tempSound != null)
            {
               if(this.m_sounds[this.m_index] != null)
               {
                  if(!this.m_sounds[this.m_index].IsFinished)
                  {
                     this.m_sounds[this.m_index].stop();
                  }
                  this.m_sounds[this.m_index] = null;
               }
               sc = new SoundObject();
               sc.play(tempSound,SaveData.SEVolumeLevel * scaleVolume,sound);
               if(!sc.IsError)
               {
                  this.m_sounds[this.m_index] = sc;
                  oldIndex = this.m_index;
                  ++this.m_index;
                  if(this.m_index > this.m_queueSize - 1)
                  {
                     this.m_index = 0;
                  }
                  return oldIndex;
               }
               return -1;
            }
            return -1;
         }
         return -1;
      }
      
      public function playVoiceEffect(sound:String, scaleVolume:Number = 1) : int
      {
         var sc:SoundObject = null;
         var oldIndex:Number = NaN;
         if(Boolean(this.m_suppressorHash) && Boolean(this.m_suppressorHash[sound]))
         {
            return -1;
         }
         if(this.m_suppressorEnabled)
         {
            this.m_suppressorHash = this.m_suppressorHash || {};
            this.m_suppressorHash[sound] = true;
         }
         var tempSound:Sound = ResourceManager.getLibrarySound(sound);
         if(tempSound == null)
         {
            tempSound = ResourceManager.getLibrarySound(sound);
         }
         if(tempSound != null)
         {
            if(this.m_sounds[this.m_index] != null && this.m_sounds[this.m_index] != undefined)
            {
               this.m_sounds[this.m_index].stop();
            }
            if(tempSound != null)
            {
               if(this.m_sounds[this.m_index] != null)
               {
                  if(!this.m_sounds[this.m_index].IsFinished)
                  {
                     this.m_sounds[this.m_index].stop();
                  }
                  this.m_sounds[this.m_index] = null;
               }
               sc = new SoundObject();
               sc.play(tempSound,SaveData.VAVolumeLevel * scaleVolume,sound);
               if(!sc.IsError)
               {
                  this.m_sounds[this.m_index] = sc;
                  oldIndex = this.m_index;
                  ++this.m_index;
                  if(this.m_index > this.m_queueSize - 1)
                  {
                     this.m_index = 0;
                  }
                  return oldIndex;
               }
               return -1;
            }
            return -1;
         }
         return -1;
      }
      
      public function updateVolumeLevel() : void
      {
         if(Boolean(this.m_currentSong))
         {
            this.m_currentSong.soundTransform = new SoundTransform(this.m_musicIsMuted ? 0 : SaveData.BGVolumeLevel);
         }
      }
      
      public function stopSound(loc:int) : void
      {
         if(loc >= 0 && this.m_sounds[loc] != null)
         {
            this.m_sounds[loc].stop();
         }
      }
      
      public function stopAllSounds() : void
      {
         for(var i:int = 0; i < this.m_sounds.length; i++)
         {
            if(this.m_sounds[i] != null)
            {
               this.m_sounds[i].stop();
               this.m_sounds[i] = null;
            }
         }
      }
      
      public function pauseAllSounds() : void
      {
         for(var i:int = 0; i < this.m_sounds.length; i++)
         {
            if(this.m_sounds[i] != null && !this.m_sounds[i].IsFinished)
            {
               this.m_sounds[i].pause();
            }
         }
      }
      
      public function unpauseAllSounds() : void
      {
         for(var i:int = 0; i < this.m_sounds.length; i++)
         {
            if(this.m_sounds[i] != null && !this.m_sounds[i].IsFinished)
            {
               this.m_sounds[i].unpause();
            }
         }
      }
      
      public function playChainedAudio(audioArr:Array, isVFX:Boolean = false) : int
      {
         var index:int = 0;
         var soundObj:SoundObject = null;
         var i:int = 0;
         if(audioArr != null && audioArr.length > 0)
         {
            index = isVFX ? this.playVoiceEffect(audioArr[0]) : this.playSoundEffect(audioArr[0]);
            if(index >= 0)
            {
               soundObj = this.getSoundObject(index);
               for(i = 1; i < audioArr.length; i++)
               {
                  if(audioArr[i] is Function)
                  {
                     soundObj.queueFunction(audioArr[i]);
                  }
                  else
                  {
                     soundObj.queueSound(ResourceManager.getLibrarySound(audioArr[i]),isVFX ? SaveData.VAVolumeLevel : SaveData.SEVolumeLevel,audioArr[i]);
                  }
               }
               return index;
            }
         }
         return -1;
      }
   }
}

