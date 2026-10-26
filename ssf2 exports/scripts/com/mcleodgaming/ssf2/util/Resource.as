package com.mcleodgaming.ssf2.util
{
   import com.mcleodgaming.ssf2.Main;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.utils.ByteArray;
   import flash.utils.CompressionAlgorithm;
   import flash.utils.setTimeout;
   
   public class Resource
   {
      
      private static const DIRECTORY_CHAR:String = "data/character/";
      
      private static const DIRECTORY_STAGE:String = "data/stage/";
      
      private static const DIRECTORY_MENU:String = "data/menu/";
      
      private static const DIRECTORY_AUDIO:String = "data/sound/";
      
      private static const DIRECTORY_MISC:String = "data/misc/";
      
      private static const DIRECTORY_MODES:String = "data/modes/";
      
      private static const DIRECTORY_CHAR_ENCRYPTED:String = "data/";
      
      private static const DIRECTORY_STAGE_ENCRYPTED:String = "data/";
      
      private static const DIRECTORY_MENU_ENCRYPTED:String = "data/";
      
      private static const DIRECTORY_AUDIO_ENCRYPTED:String = "data/";
      
      private static const DIRECTORY_MISC_ENCRYPTED:String = "data/";
      
      private static const DIRECTORY_MODES_ENCRYPTED:String = "data/";
      
      private static const URL_PROTOCOL:String = "https://";
      
      private static const URL_HOST:String = "cdn.supersmashflash.com";
      
      private static const URL_DIRECTORY:String = "/ssf2/433c66e550884701aad475c2ff8a27fb7/";
      
      public static const NULL:int = -1;
      
      public static const MISC:int = 0;
      
      public static const CHARACTER:int = 1;
      
      public static const STAGE:int = 2;
      
      public static const AUDIO:int = 3;
      
      public static const MENU:int = 4;
      
      public static const CHARACTER_EXPANSION:int = 5;
      
      public static const STAGE_EXPANSION:int = 6;
      
      public static const EXTRA:int = 7;
      
      public static const MUSIC:int = 8;
      
      public static const MODE:int = 9;
      
      private var m_id:String;
      
      private var m_fileName:String;
      
      private var m_encryptedFileName:String;
      
      private var m_passKey:String;
      
      private var m_loader:Loader;
      
      private var m_loaderContext:LoaderContext;
      
      private var m_urlRequest:URLRequest;
      
      private var m_urlLoader:URLLoader;
      
      private var m_type:int;
      
      private var m_loaded:Boolean;
      
      private var m_softFail:Boolean;
      
      private var m_percentLoaded:Number;
      
      private var m_loadFunction:Function;
      
      private var m_errorFunction:Function;
      
      private var m_startDelay:FrameTimer;
      
      private var m_metadata:Object;
      
      private var m_errored:Boolean;
      
      private var m_movie:MovieClip;
      
      private var m_urlOverride:String;
      
      public function Resource(id:String, file:String, encryptedFile:String, passKey:String, type:int)
      {
         super();
         if(type < -1 || type > 9)
         {
            trace("Error importing type...");
            this.m_type = -1;
         }
         else
         {
            this.m_type = type;
         }
         this.m_id = id;
         this.m_fileName = file;
         this.m_encryptedFileName = encryptedFile;
         this.m_passKey = passKey;
         this.m_type = type;
         this.m_loadFunction = null;
         this.m_errorFunction = null;
         this.m_percentLoaded = 0;
         this.m_softFail = false;
         this.m_loaded = false;
         this.m_loader = new Loader();
         this.m_loaderContext = null;
         this.m_urlRequest = null;
         this.m_urlLoader = null;
         this.m_movie = null;
         this.m_startDelay = new FrameTimer(3);
         this.m_metadata = {};
         this.m_errored = false;
         this.m_urlOverride = null;
      }
      
      public function get ID() : String
      {
         return this.m_id;
      }
      
      public function get CurrentFileName() : String
      {
         return Main.ENCRYPTED ? this.m_encryptedFileName : this.m_fileName;
      }
      
      public function get FileName() : String
      {
         return this.m_fileName;
      }
      
      public function get Location() : String
      {
         if(Boolean(this.m_urlOverride))
         {
            return this.m_urlOverride;
         }
         var prefix:String = "";
         if(!Main.LOCALHOST)
         {
            prefix = Resource.URL_PROTOCOL + Resource.URL_HOST + Resource.URL_DIRECTORY;
         }
         if(this.m_type == Resource.MISC || this.m_type == Resource.EXTRA)
         {
            if(Main.ENCRYPTED)
            {
               return prefix + Resource.DIRECTORY_MISC_ENCRYPTED + this.m_encryptedFileName;
            }
            return prefix + Resource.DIRECTORY_MISC + this.m_fileName;
         }
         if(this.m_type == Resource.AUDIO || this.m_type == Resource.MUSIC)
         {
            if(Main.ENCRYPTED)
            {
               return prefix + Resource.DIRECTORY_AUDIO_ENCRYPTED + this.m_encryptedFileName;
            }
            return prefix + Resource.DIRECTORY_AUDIO + this.m_fileName;
         }
         if(this.m_type == Resource.CHARACTER || this.m_type == Resource.CHARACTER_EXPANSION)
         {
            if(Main.ENCRYPTED)
            {
               return prefix + Resource.DIRECTORY_CHAR_ENCRYPTED + this.m_encryptedFileName;
            }
            return prefix + Resource.DIRECTORY_CHAR + this.m_fileName;
         }
         if(this.m_type == Resource.STAGE || this.m_type == Resource.STAGE_EXPANSION)
         {
            if(Main.ENCRYPTED)
            {
               return prefix + Resource.DIRECTORY_STAGE_ENCRYPTED + this.m_encryptedFileName;
            }
            return prefix + Resource.DIRECTORY_STAGE + this.m_fileName;
         }
         if(this.m_type == Resource.MENU)
         {
            if(Main.ENCRYPTED)
            {
               return prefix + Resource.DIRECTORY_MENU_ENCRYPTED + this.m_encryptedFileName;
            }
            return prefix + Resource.DIRECTORY_MENU + this.m_fileName;
         }
         if(this.m_type == Resource.MODE)
         {
            if(Main.ENCRYPTED)
            {
               return prefix + Resource.DIRECTORY_MODES_ENCRYPTED + this.m_encryptedFileName;
            }
            return prefix + Resource.DIRECTORY_MODES + this.m_fileName;
         }
         return null;
      }
      
      public function get EncryptedFileName() : String
      {
         return this.m_encryptedFileName;
      }
      
      public function get PassKey() : String
      {
         return this.m_passKey;
      }
      
      public function get Type() : int
      {
         return this.m_type;
      }
      
      public function set Type(value:int) : void
      {
         this.m_type = value;
      }
      
      public function get MetaData() : Object
      {
         return this.m_metadata;
      }
      
      public function get MC() : MovieClip
      {
         return this.m_movie;
      }
      
      public function get Loaded() : Boolean
      {
         return this.m_loaded;
      }
      
      public function set Loaded(value:Boolean) : void
      {
         this.m_loaded = value;
         if(this.m_loaded)
         {
            this.m_startDelay.finish();
            this.m_percentLoaded = 100;
         }
         else
         {
            this.m_percentLoaded = 0;
         }
      }
      
      public function get SoftFail() : Boolean
      {
         return this.m_softFail;
      }
      
      public function set SoftFail(value:Boolean) : void
      {
         this.m_softFail = value;
      }
      
      public function get UrlOverride() : String
      {
         return this.m_urlOverride;
      }
      
      public function set UrlOverride(value:String) : void
      {
         this.m_urlOverride = value;
      }
      
      public function get PercentLoaded() : Number
      {
         return this.m_percentLoaded;
      }
      
      public function get HasError() : Boolean
      {
         return this.m_errored;
      }
      
      public function getProp(propName:String) : *
      {
         if(Boolean(this.MC) && "getProp" in this.MC)
         {
            if(this.m_id === "mappings" && Boolean(propName.match(/metadata|metadata_original|metadata_dev/)))
            {
               if(Boolean(this.m_metadata["mp" + propName]))
               {
                  return this.m_metadata["mp" + propName];
               }
               this.m_metadata["mp" + propName] = JSON.parse(Base64.decode(Utils.d(this.MC.getProp(propName),"b7d60849-fa99-4514-b41e-16693ce7acc0")));
               return this.m_metadata["mp" + propName];
            }
            return this.MC.getProp(propName);
         }
         return null;
      }
      
      public function load(loadFunc:Function = null, errorFunc:Function = null) : void
      {
         this.m_startDelay.reset();
         this.m_loadFunction = loadFunc;
         this.m_errorFunction = errorFunc;
         if(!this.m_loaded)
         {
            this.m_urlRequest = new URLRequest(this.Location);
            this.m_urlLoader = new URLLoader();
            this.m_urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
            if(this.m_loadFunction == null)
            {
               this.m_startDelay.finish();
            }
            this.m_urlLoader.addEventListener(Event.COMPLETE,this.initialLoadComplete);
            this.m_urlLoader.addEventListener(ProgressEvent.PROGRESS,this.loadProgress);
            this.m_urlLoader.addEventListener(IOErrorEvent.IO_ERROR,this.initialLoadError);
            this.m_urlLoader.load(this.m_urlRequest);
         }
         else if(this.m_loadFunction == null)
         {
            this.m_startDelay.finish();
            Main.Root.addEventListener(Event.ENTER_FRAME,this.finalFuncs);
         }
      }
      
      private function loadProgress(e:ProgressEvent) : void
      {
         this.m_percentLoaded = e.bytesLoaded / e.bytesTotal * 100;
         if(this.m_percentLoaded > 100 || isNaN(this.m_percentLoaded))
         {
            this.m_percentLoaded = 0;
         }
      }
      
      private function initialLoadError(e:IOErrorEvent) : void
      {
         trace("Failed to load resource in " + this.Location);
         this.m_urlLoader.removeEventListener(Event.COMPLETE,this.initialLoadComplete);
         this.m_urlLoader.removeEventListener(ProgressEvent.PROGRESS,this.loadProgress);
         this.m_urlLoader.removeEventListener(IOErrorEvent.IO_ERROR,this.initialLoadError);
         this.m_errored = true;
         if(this.m_errorFunction != null)
         {
            this.m_errorFunction(this);
         }
         this.m_loadFunction = null;
         this.m_errorFunction = null;
      }
      
      private function loadError(e:IOErrorEvent) : void
      {
         this.m_errored = true;
         trace("Failed to read resource in " + this.Location);
         this.m_loader.unloadAndStop(true);
         this.m_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.loadError);
         this.m_loader.contentLoaderInfo.removeEventListener(Event.INIT,this.loadComplete);
         this.m_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.loadComplete);
         if(this.m_errorFunction != null)
         {
            this.m_errorFunction(this);
         }
         this.m_loadFunction = null;
         this.m_errorFunction = null;
      }
      
      private function initialLoadComplete(e:Event) : void
      {
         this.m_urlLoader.removeEventListener(Event.COMPLETE,this.initialLoadComplete);
         this.m_urlLoader.removeEventListener(ProgressEvent.PROGRESS,this.loadProgress);
         this.m_urlLoader.removeEventListener(IOErrorEvent.IO_ERROR,this.initialLoadError);
         setTimeout(function():void
         {
            var c:ByteArray = null;
            var l:int = 0;
            var n:int = 0;
            var x:int = 0;
            var b:ByteArray = m_urlLoader.data as ByteArray;
            c = new ByteArray();
            try
            {
               b.uncompress(CompressionAlgorithm.ZLIB);
               l = b.readInt();
               n = b.readInt();
               for(x = 0; x < n; x++)
               {
                  b.readInt();
               }
               c.writeBytes(b,b.position,l);
               b = c;
               c = null;
            }
            catch(err:*)
            {
               if(m_id !== "menu_news")
               {
                  return;
               }
            }
            m_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,loadError);
            m_loader.contentLoaderInfo.addEventListener(Event.INIT,loadComplete);
            m_loader.contentLoaderInfo.addEventListener(Event.COMPLETE,loadComplete);
            m_loaderContext = new LoaderContext(false,new ApplicationDomain(ApplicationDomain.currentDomain));
            m_loaderContext.allowCodeImport = true;
            m_loader.loadBytes(b,m_loaderContext);
         },50);
      }
      
      private function loadComplete(e:Event) : void
      {
         this.m_movie = this.m_loader.content as MovieClip;
         this.m_movie.visible = false;
         Utils.recursiveMovieClipPlay(this.MC,false);
         trace("Successfully loaded " + this.Location);
         this.m_loaded = true;
         this.m_percentLoaded = 100;
         this.m_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.loadError);
         this.m_loader.contentLoaderInfo.removeEventListener(Event.INIT,this.loadComplete);
         this.m_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.loadComplete);
         if(this.m_loadFunction != null)
         {
            this.m_loadFunction(this);
            this.m_loadFunction = null;
         }
      }
      
      private function finalFuncs(e:*) : void
      {
         this.m_startDelay.tick();
         if(this.m_startDelay.IsComplete)
         {
            if(this.m_loadFunction != null)
            {
               this.m_loadFunction(e);
               this.m_loadFunction = null;
            }
            Main.Root.removeEventListener(Event.ENTER_FRAME,this.finalFuncs);
         }
      }
      
      public function getLoader() : Loader
      {
         return this.m_loader;
      }
      
      public function unload(withError:Boolean = false) : void
      {
         if(this.m_loaded)
         {
            if(this.m_type != Resource.STAGE_EXPANSION && this.m_type != Resource.CHARACTER_EXPANSION)
            {
               trace("[Unloaded SWF] " + this.FileName);
               this.m_errored = withError;
               this.m_loaded = false;
               this.m_loader.unloadAndStop(true);
               this.m_loader = new Loader();
               this.m_loaderContext = null;
               this.m_movie = null;
               this.m_percentLoaded = 0;
               this.m_loadFunction = null;
               this.m_errorFunction = null;
               this.m_urlRequest = null;
               this.m_urlLoader = null;
               this.m_metadata = {};
            }
         }
      }
   }
}

