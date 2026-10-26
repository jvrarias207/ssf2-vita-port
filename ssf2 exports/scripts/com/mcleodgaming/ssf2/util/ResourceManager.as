package com.mcleodgaming.ssf2.util
{
   import com.mcleodgaming.ssf2.Main;
   import com.mcleodgaming.ssf2.Version;
   import com.mcleodgaming.ssf2.api.SSF2API;
   import com.mcleodgaming.ssf2.controllers.MenuController;
   import com.mcleodgaming.ssf2.engine.Stats;
   import flash.display.MovieClip;
   import flash.media.Sound;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   import flash.utils.setTimeout;
   
   public class ResourceManager
   {
      
      private static var _isFinishedInterval:uint;
      
      private static var _loadOptions:Object;
      
      private static var _loadIndex:int;
      
      public static const FN_PATTERN:RegExp = /(.*?)\((.*?)\)/g;
      
      public static const LOAD_DELAY:int = 50;
      
      public static var pool:Vector.<Resource> = new Vector.<Resource>();
      
      public static var poolHash:Object = {};
      
      public static var resources:Vector.<Resource> = new Vector.<Resource>();
      
      public static var resourcesHash:Object = {};
      
      public static var queue:Vector.<Resource> = new Vector.<Resource>();
      
      public static var queueHash:Object = {};
      
      public static var multimode:Boolean = true;
      
      public static var optimizeMemory:Boolean = true;
      
      public static var FORCE_ENABLE_ALT_TRACKS:Boolean = false;
      
      public static var resourceCache:Object = {};
      
      private static var m_expansionData:Vector.<Vector.<Function>> = new Vector.<Vector.<Function>>();
      
      private static const manifestJSON:Class = ResourceManager_manifestJSON;
      
      public static const manifestJSONData:Object = JSON.parse(Base64.decode(Utils.d(new String(new ResourceManager.manifestJSON()),"cedbe0e0-b9de-4e16-92cc-d32781a0bfe0")));
      
      public function ResourceManager()
      {
         super();
      }
      
      public static function init() : void
      {
         var i:* = undefined;
         var randString:String = null;
         var data:Object = ResourceManager.manifestJSONData;
         var obj:Object = null;
         var newsResource:Resource = new Resource("menu_news",null,null,"dfc43fc4-2d45-49c3-bb3c-8c05be73ec81",Resource.MENU);
         addResource(newsResource);
         for(i in data.character)
         {
            obj = data.character[i];
            addResource(new Resource(i,obj.file,obj.file_pub,obj.guid,Resource.CHARACTER));
         }
         for(i in data.stage)
         {
            obj = data.stage[i];
            addResource(new Resource(i,obj.file,obj.file_pub,obj.guid,Resource.STAGE));
         }
         for(i in data.misc)
         {
            obj = data.misc[i];
            addResource(new Resource(i,obj.file,obj.file_pub,obj.guid,Resource.MISC));
         }
         for(i in data.extra)
         {
            obj = data.extra[i];
            addResource(new Resource(i,obj.file,obj.file_pub,obj.guid,Resource.EXTRA));
         }
         for(i in data.menu)
         {
            obj = data.menu[i];
            addResource(new Resource(i,obj.file,obj.file_pub,obj.guid,Resource.MENU));
         }
         for(i in data.audio)
         {
            obj = data.audio[i];
            addResource(new Resource(i,obj.file,obj.file_pub,obj.guid,Resource.AUDIO));
         }
         for(i in data.music)
         {
            obj = data.music[i];
            addResource(new Resource(i,obj.file,obj.file_pub,obj.guid,Resource.MUSIC));
         }
         for(i in data.modes)
         {
            obj = data.modes[i];
            addResource(new Resource(i,obj.file,obj.file_pub,obj.guid,Resource.MODE));
         }
         randString = Math.random().toString().replace(/\./g,"");
         newsResource.SoftFail = true;
         newsResource.UrlOverride = "https://www.supersmashflash.com/flash?f=games/ssf2news121.swf&" + randString;
      }
      
      public static function get TotalExpansions() : Number
      {
         return m_expansionData.length;
      }
      
      public static function clearResourceCache() : void
      {
         ResourceManager.resourceCache = {};
      }
      
      private static function cacheLibrary(res:Resource) : void
      {
         var resources:Object = res.getProp("resources");
         var i:int = 0;
         if(Boolean(res.getProp("audio")))
         {
         }
         if(Boolean(resources))
         {
            if(Boolean(resources.movieclips))
            {
               for(i = 0; i < resources.movieclips.length; i++)
               {
                  ResourceManager.getLibraryClass(resources.movieclips[i]);
               }
            }
            if(Boolean(resources.sounds))
            {
               for(i = 0; i < resources.sounds.length; i++)
               {
                  ResourceManager.getLibraryClass(resources.sounds[i]);
               }
            }
         }
      }
      
      public static function isRequiredResourceType(type:int) : Boolean
      {
         return type === Resource.MENU || type === Resource.MISC || type === Resource.AUDIO || type === Resource.MODE;
      }
      
      public static function addResource(resource:Resource) : void
      {
         if(resource.ID === "put_id_here")
         {
            return;
         }
         if(!resource)
         {
            trace("[ResourceManager] Null resource provided!!!.");
         }
         else if(!resource.ID)
         {
            trace("[ResourceManager] Error, resource requires an ID in order to be stored.");
         }
         else if(Boolean(ResourceManager.poolHash[resource.ID]))
         {
            trace("[ResourceManager] Error, resource " + resource.ID + " has already been added");
         }
         else
         {
            ResourceManager.poolHash[resource.ID] = resource;
            ResourceManager.pool.push(resource);
            trace("[ResourceManager] Added resource: " + resource.ID);
            if(resource.Loaded && !resourcesHash[resource.ID])
            {
               ResourceManager.resourcesHash[resource.ID] = resource;
               ResourceManager.resources.push(resource);
            }
         }
      }
      
      public static function queueResources(resourceList:Array) : void
      {
         var i:int = 0;
         for(i = 0; i < resourceList.length; i++)
         {
            if(!ResourceManager.poolHash[resourceList[i]])
            {
               trace("[ResourceManager] Resource could not be found: " + resourceList[i]);
            }
            else if(!ResourceManager.queueHash[resourceList[i]])
            {
               if(resourceList[i] === "sheik")
               {
                  if(!ResourceManager.queueHash["zelda"])
                  {
                     queueResources(["zelda"]);
                  }
                  return;
               }
               ResourceManager.queueHash[resourceList[i]] = ResourceManager.poolHash[resourceList[i]];
               ResourceManager.queue.push(ResourceManager.poolHash[resourceList[i]]);
               trace("[ResourceManager] Queued resource: " + resourceList[i]);
            }
         }
      }
      
      public static function queueRequiredResources() : void
      {
         var resource:Resource = null;
         for(var i:int = 0; i < ResourceManager.pool.length; i++)
         {
            resource = ResourceManager.pool[i];
            if(ResourceManager.isRequiredResourceType(resource.Type) && !ResourceManager.resourcesHash[resource.ID] && !ResourceManager.queueHash[resource.ID])
            {
               ResourceManager.queueHash[resource.ID] = resource;
               ResourceManager.queue.push(resource);
               trace("[ResourceManager] Queued resource: " + resource.ID);
            }
         }
      }
      
      public static function flushAllResources(forceUnload:Boolean = false) : void
      {
         var resource:Resource = null;
         for(var i:int = 0; i < ResourceManager.resources.length; i++)
         {
            resource = ResourceManager.resources[i];
            if(!ResourceManager.isRequiredResourceType(resource.Type) || forceUnload)
            {
               unloadResource(resource);
               i--;
               trace("[ResourceManager] Unloaded resource: " + resource.ID);
            }
         }
      }
      
      public static function flushUnusedResources() : void
      {
         var resource:Resource = null;
         for(var i:int = 0; i < ResourceManager.resources.length; i++)
         {
            resource = ResourceManager.resources[i];
            if(!ResourceManager.isRequiredResourceType(resource.Type) && !ResourceManager.queueHash[resource.ID])
            {
               unloadResource(resource);
               i--;
               trace("[ResourceManager] Unloaded resource: " + resource.ID);
            }
         }
      }
      
      public static function flushLoadQueue() : void
      {
         var resource:Resource = null;
         for(var i:int = 0; i < ResourceManager.queue.length; i++)
         {
            resource = ResourceManager.queue[i];
            ResourceManager.queueHash[resource.ID] = null;
            ResourceManager.queue[i] = null;
            ResourceManager.queue.splice(i--,1);
            trace("[ResourceManager] Removed resource from loading queue: " + resource.ID);
         }
      }
      
      public static function pruneLoadQueue() : void
      {
         var resource:Resource = null;
         for(var i:int = 0; i < ResourceManager.queue.length; i++)
         {
            resource = ResourceManager.queue[i];
            if(resource.Loaded)
            {
               if(!ResourceManager.resourcesHash[resource.ID])
               {
                  ResourceManager.resourcesHash[resource.ID] = resource;
                  ResourceManager.resources.push(resource);
               }
               ResourceManager.queueHash[resource.ID] = null;
               ResourceManager.queue[i] = null;
               ResourceManager.queue.splice(i--,1);
               trace("[ResourceManager] Removed already loaded resource from loading queue: " + resource.ID);
            }
         }
      }
      
      public static function load(options:Object) : void
      {
         var checkFinished:Function = null;
         var i:int = 0;
         var checkProgress:Function = null;
         ResourceManager.unloadOldResources();
         if(Boolean(ResourceManager._isFinishedInterval))
         {
            if(Boolean(ResourceManager._loadOptions.onerror))
            {
               ResourceManager._loadOptions.onerror();
            }
            clearInterval(ResourceManager._isFinishedInterval);
            ResourceManager._isFinishedInterval = 0;
         }
         ResourceManager._loadOptions = options || {};
         ResourceManager._loadIndex = 0;
         if(ResourceManager.multimode)
         {
            checkFinished = function():void
            {
               if(typeof ResourceManager._loadOptions.onprogress == "function")
               {
                  ResourceManager._loadOptions.onprogress(ResourceManager.getLoadPercentage());
               }
               if(ResourceManager.isFullyLoaded())
               {
                  ResourceManager.flushLoadQueue();
                  clearInterval(ResourceManager._isFinishedInterval);
                  ResourceManager._isFinishedInterval = 0;
                  if(typeof ResourceManager._loadOptions.oncomplete == "function")
                  {
                     ResourceManager._loadOptions.oncomplete();
                  }
                  trace("[ResourceManager] Finished loading all resources.");
               }
            };
            for(i = 0; i < ResourceManager.queue.length; i++)
            {
               trace("[ResourceManager] Started loading resource: ",ResourceManager.queue[i].ID);
               if(ResourceManager.queue[i].Loaded && ResourceManager.queue[i].Type === Resource.STAGE)
               {
                  ResourceManager.checkMusicToLoad(ResourceManager.queue[i]);
               }
               ResourceManager.queue[i].load(handleLoaded,handleLoaded);
            }
            ResourceManager._isFinishedInterval = setInterval(checkFinished,100);
         }
         else
         {
            checkProgress = function():void
            {
               if(typeof ResourceManager._loadOptions.onprogress == "function")
               {
                  ResourceManager._loadOptions.onprogress(ResourceManager.getLoadPercentage());
               }
            };
            ResourceManager._isFinishedInterval = setInterval(checkProgress,100);
            setTimeout(function():void
            {
               ResourceManager.loadNext();
            },LOAD_DELAY);
         }
      }
      
      public static function checkMusicToLoad(res:Resource) : void
      {
         var debugMusicID:String = null;
         var music_id:String = null;
         var i:int = 0;
         if(res.Type === Resource.STAGE)
         {
            if(Boolean(res.getProp("music")) && Boolean(res.getProp("music").length))
            {
               Main.prepRandomMusic(Utils.safeRandomInteger(0,res.getProp("music").length - 1));
               music_id = res.getProp("music")[Main.RandMusicIndex].id;
               if(Boolean(ResourceManager.getResourceByID(music_id)) && Boolean(!ResourceManager.getResourceByID(music_id,true)) && !ResourceManager.queueHash[music_id])
               {
                  ResourceManager.queueResources([music_id]);
                  if(ResourceManager.multimode)
                  {
                     Resource(ResourceManager.queueHash[music_id]).load(handleLoaded,handleLoaded);
                  }
               }
               if(false && Boolean(res.EncryptedFileName))
               {
                  for(i = 0; i < res.getProp("music").length; i++)
                  {
                     debugMusicID = res.getProp("music")[i].id;
                     if(!ResourceManager.getResourceByID(debugMusicID).EncryptedFileName)
                     {
                        throw new Error("Error, music \'" + debugMusicID + "\' is missing public file ID");
                     }
                     if(debugMusicID !== music_id)
                     {
                        if(Boolean(ResourceManager.getResourceByID(debugMusicID)) && Boolean(!ResourceManager.getResourceByID(debugMusicID,true)) && !ResourceManager.queueHash[debugMusicID])
                        {
                           ResourceManager.queueResources([debugMusicID]);
                           if(ResourceManager.multimode)
                           {
                              Resource(ResourceManager.queueHash[debugMusicID]).load(handleLoaded,handleLoaded);
                           }
                        }
                     }
                  }
               }
            }
         }
      }
      
      private static function handleLoaded(res:Resource) : void
      {
         if(ResourceManager.multimode)
         {
            if(res.Loaded)
            {
               ResourceManager.resources.push(res);
               ResourceManager.resourcesHash[res.ID] = res;
               ResourceManager.cacheLibrary(res);
               trace("[ResourceManager] Loaded: ",res.ID);
               if(!ResourceManager.validateResource(res))
               {
                  unloadResource(res);
               }
               else
               {
                  checkMusicToLoad(res);
               }
            }
            else if(res.HasError && res.SoftFail)
            {
               unloadResource(res);
            }
            else if(res.HasError)
            {
               if(typeof ResourceManager._loadOptions.onerror == "function")
               {
                  ResourceManager._loadOptions.onerror();
               }
               trace("[ResourceManager] An error has occured while loading resource: ",res.ID);
            }
         }
         else if(ResourceManager.queue[ResourceManager._loadIndex].Loaded)
         {
            ResourceManager.resources.push(res);
            ResourceManager.resourcesHash[res.ID] = res;
            ResourceManager.cacheLibrary(res);
            trace("[ResourceManager] Loaded: ",res);
            ++ResourceManager._loadIndex;
            if(!ResourceManager.validateResource(res))
            {
               unloadResource(res);
            }
            else
            {
               checkMusicToLoad(res);
            }
            setTimeout(function():void
            {
               ResourceManager.loadNext();
            },LOAD_DELAY);
         }
         else if(ResourceManager.queue[ResourceManager._loadIndex].HasError && ResourceManager.queue[ResourceManager._loadIndex].SoftFail)
         {
            unloadResource(ResourceManager.queue[ResourceManager._loadIndex]);
            ++ResourceManager._loadIndex;
            ResourceManager.loadNext();
         }
         else if(ResourceManager.queue[ResourceManager._loadIndex].HasError)
         {
            if(typeof ResourceManager._loadOptions.onerror == "function")
            {
               ResourceManager._loadOptions.onerror();
            }
            trace("[ResourceManager] An error has occured while loading resource: ",ResourceManager.queue[ResourceManager._loadIndex].ID);
            ++ResourceManager._loadIndex;
            ResourceManager.loadNext();
         }
      }
      
      private static function loadNext() : void
      {
         if(ResourceManager._loadIndex < ResourceManager.queue.length)
         {
            trace("[ResourceManager] Started loading resource: ",ResourceManager.queue[ResourceManager._loadIndex].ID);
            if(ResourceManager.queue[ResourceManager._loadIndex].Loaded && ResourceManager.queue[ResourceManager._loadIndex].Type === Resource.STAGE)
            {
               ResourceManager.checkMusicToLoad(ResourceManager.queue[ResourceManager._loadIndex]);
            }
            if(ResourceManager.queue[ResourceManager._loadIndex].Loaded)
            {
               ++ResourceManager._loadIndex;
               loadNext();
            }
            else
            {
               ResourceManager.queue[ResourceManager._loadIndex].load(handleLoaded,handleLoaded);
            }
         }
         else
         {
            clearInterval(ResourceManager._isFinishedInterval);
            ResourceManager._isFinishedInterval = 0;
            if(ResourceManager.isFullyLoaded())
            {
               ResourceManager.flushLoadQueue();
               if(typeof ResourceManager._loadOptions.oncomplete == "function")
               {
                  ResourceManager._loadOptions.oncomplete();
               }
               trace("[ResourceManager] Finished loading all resources.");
            }
            else
            {
               trace("[ResourceManager] Unable to load all resources.");
            }
         }
      }
      
      public static function getLoadPercentage() : Number
      {
         var total:int = 0;
         var extra:int = 0;
         for(var i:int = 0; i < ResourceManager.queue.length; i++)
         {
            if(ResourceManager.queue[i].HasError && ResourceManager.queue[i].SoftFail)
            {
               total += 100;
            }
            else
            {
               total += ResourceManager.queue[i].PercentLoaded;
            }
         }
         return ResourceManager.queue.length <= 0 ? 100 : total / (ResourceManager.queue.length - extra);
      }
      
      public static function isFullyLoaded() : Boolean
      {
         for(var i:int = 0; i < ResourceManager.queue.length; i++)
         {
            if(!ResourceManager.queue[i].Loaded && !(ResourceManager.queue[i].HasError && ResourceManager.queue[i].SoftFail))
            {
               return false;
            }
         }
         return true;
      }
      
      private static function validateResource(resource:Resource) : Boolean
      {
         var apiFunc:Function = null;
         var cls:Class = null;
         var diff:int = 0;
         var versionStr:String = null;
         var characters:Array = null;
         var expansionChars:Array = null;
         var j:int = 0;
         if(Boolean(resource.MC) && "initAPI" in resource.MC)
         {
            apiFunc = resource.MC["initAPI"] as Function;
            cls = apiFunc(SSF2API);
            if("BASE_CLASSES" in cls)
            {
               resource.MetaData.BASE_CLASSES = cls.BASE_CLASSES;
            }
            else
            {
               resource.MetaData.BASE_CLASSES = {};
            }
            diff = Version.compare(SSF2API.VERSION_MAJOR,SSF2API.VERSION_MINOR,SSF2API.VERSION_REVISION,cls.VERSION_MAJOR,cls.VERSION_MINOR,cls.VERSION_REVISION);
            versionStr = Boolean(cls["getAPIVersion"] as Function) ? (cls["getAPIVersion"] as Function)() : "(unknown)";
            if(diff > 0)
            {
               if(SSF2API.VERSION_MAJOR !== cls.VERSION_MAJOR || SSF2API.VERSION_MINOR !== cls.VERSION_MINOR || cls.VERSION_MAJOR === 0 && cls.VERSION_MINOR === 3 && cls.VERSION_REVISION < 22)
               {
                  if(Boolean(Main.DEBUG) && Boolean(MenuController.debugConsole) && MenuController.debugConsole.Alerts)
                  {
                     MenuController.debugConsole.alert("[Warning] API for resource \"" + resource.FileName + "\" is older than the game engine\'s API Interface. Please recompile resource. (v" + versionStr + " < v" + SSF2API.getAPIVersion() + ")");
                  }
               }
            }
            else if(diff < 0)
            {
               if(Boolean(Main.DEBUG) && Boolean(MenuController.debugConsole) && MenuController.debugConsole.Alerts)
               {
                  MenuController.debugConsole.alert("[Warning] API for resource \"" + resource.FileName + "\" is newer than the engine\'s API Interface. Please update game engine. (v" + versionStr + " > v" + SSF2API.getAPIVersion() + ")");
               }
            }
         }
         if(Boolean(resource.getProp("id")))
         {
            if(ResourceManager.getResourceByID(resource.getProp("id")) == null)
            {
               trace("ERROR, no matching ID for global " + resource.getProp("id"));
               unloadResource(resource);
               return false;
            }
            if(!Boolean(resource.getProp("guid")))
            {
               trace("ERROR, no GUID for " + resource.getProp("id"));
               return false;
            }
            if(resource.getProp("guid") != ResourceManager.getResourceByID(resource.getProp("id")).PassKey)
            {
               trace("ERROR in validation for " + resource.getProp("id") + " with key " + resource.getProp("guid"));
               return false;
            }
            resource.Type = ResourceManager.getResourceByID(resource.getProp("id")).Type;
            if(resource.Type != Resource.STAGE)
            {
               if(resource.Type == Resource.CHARACTER)
               {
                  characters = resource.getProp("characters") || null;
                  if(!Boolean(characters))
                  {
                     trace("ERROR writing stats for " + resource.getProp("id") + " with key " + resource.getProp("guid"));
                     return false;
                  }
                  for(j = 0; j < characters.length; j++)
                  {
                     Stats.writeStats(characters[j]);
                  }
               }
            }
         }
         else if(Boolean(resource.getProp("expansion")))
         {
            expansionChars = resource.getProp("characters");
            if(Boolean(expansionChars) && resource.FileName.indexOf("test") == 0)
            {
               m_expansionData.push(new Vector.<Function>());
               for(j = 0; j < expansionChars.length; j++)
               {
                  m_expansionData[m_expansionData.length - 1].push(expansionChars[j]);
               }
            }
            else if(!Boolean(resource.getProp("stage")))
            {
               trace("ERROR, no association for " + resource.Location);
               unloadResource(resource);
               return false;
            }
         }
         return true;
      }
      
      public static function unloadResource(res:Resource) : void
      {
         var key:* = undefined;
         var apiFunc:Function = null;
         var i:int = ResourceManager.resources.indexOf(res);
         if(i >= 0)
         {
            if(Boolean(res.MC) && "deinitAPI" in res.MC)
            {
               apiFunc = res.MC["deinitAPI"] as Function;
               apiFunc();
            }
            res.unload();
            ResourceManager.resourcesHash[res.ID] = null;
            ResourceManager.resources[i] = null;
            ResourceManager.resources.splice(i,1);
            for(key in ResourceManager.resourceCache)
            {
               if(Boolean(ResourceManager.resourceCache[key]) && ResourceManager.resourceCache[key].src === res.ID)
               {
                  ResourceManager.resourceCache[key] = null;
               }
            }
            if(res.Type === Resource.CHARACTER)
            {
               Stats.clearStats(res.ID);
            }
         }
      }
      
      private static function getOldestResourceByType(type:int) : Resource
      {
         for(var i:int = 0; i < ResourceManager.resources.length; i++)
         {
            if(ResourceManager.resources[i].Type === type)
            {
               return ResourceManager.resources[i];
            }
         }
         return null;
      }
      
      private static function unloadOldResources() : void
      {
         var key:* = undefined;
         var CHARACTER_LIMIT:int = !Main.LOCALHOST ? 12 : 2;
         var STAGE_LIMIT:int = !Main.LOCALHOST ? 10 : 1;
         var MUSIC_LIMIT:int = !Main.LOCALHOST ? 16 : (Main.DEBUG ? 6 : 1);
         var totals:Object = {};
         for(var i:int = 0; i < ResourceManager.resources.length; i++)
         {
            if(!totals[ResourceManager.resources[i].Type])
            {
               totals[ResourceManager.resources[i].Type] = 0;
            }
            ++totals[ResourceManager.resources[i].Type];
         }
         for(key in totals)
         {
            switch(key)
            {
               case Resource.CHARACTER:
                  while(totals[key] > CHARACTER_LIMIT)
                  {
                     ResourceManager.unloadResource(ResourceManager.getOldestResourceByType(Resource.CHARACTER));
                     --totals[key];
                  }
                  break;
               case Resource.STAGE:
                  if(totals[key] > STAGE_LIMIT)
                  {
                     ResourceManager.unloadResource(ResourceManager.getOldestResourceByType(Resource.STAGE));
                     --totals[key];
                  }
                  break;
               case Resource.MUSIC:
                  if(totals[key] > MUSIC_LIMIT)
                  {
                     ResourceManager.unloadResource(ResourceManager.getOldestResourceByType(Resource.MUSIC));
                     --totals[key];
                  }
            }
         }
      }
      
      private static function promoteResource(res:Resource) : void
      {
         var index:int = -1;
         for(var i:int = 0; i < ResourceManager.resources.length; i++)
         {
            if(ResourceManager.resources[i] === res)
            {
               index = i;
               return;
            }
         }
         if(index >= 0)
         {
            ResourceManager.resources.splice(index,1);
            ResourceManager.resources.push(res);
         }
      }
      
      public static function getResourceByID(id:String, mustBeLoaded:Boolean = false) : Resource
      {
         if(Boolean(ResourceManager.poolHash[id]) && !(mustBeLoaded && !ResourceManager.poolHash[id].Loaded))
         {
            return ResourceManager.poolHash[id];
         }
         return null;
      }
      
      public static function getLibraryMC(mcName:String) : MovieClip
      {
         var myClass:Class = ResourceManager.getLibraryClass(mcName);
         if(Boolean(myClass))
         {
            return new myClass() as MovieClip;
         }
         return null;
      }
      
      public static function getLibraryClass(className:String) : Class
      {
         var retClass:Class = null;
         var retResourceID:String = "root";
         var i:Number = 0;
         if(Boolean(ResourceManager.resourceCache[className]))
         {
            return resourceCache[className].ref;
         }
         if(Main.Root.loaderInfo.applicationDomain.hasDefinition(className))
         {
            retClass = Main.Root.loaderInfo.applicationDomain.getDefinition(className) as Class;
         }
         else
         {
            for(i = 0; i < ResourceManager.resources.length; i++)
            {
               if(Boolean(ResourceManager.resources[i].Loaded) && Boolean(ResourceManager.resources[i]) && Boolean(ResourceManager.resources[i].MC))
               {
                  if(ResourceManager.resources[i].MC.loaderInfo.applicationDomain.hasDefinition(className))
                  {
                     retClass = ResourceManager.resources[i].MC.loaderInfo.applicationDomain.getDefinition(className) as Class;
                     retResourceID = resources[i].ID;
                     break;
                  }
                  if(Boolean(ResourceManager.resources[i].MC[className]))
                  {
                     retClass = ResourceManager.resources[i].MC[className] as Class;
                     retResourceID = resources[i].ID;
                     break;
                  }
               }
            }
         }
         if(Boolean(retClass))
         {
            ResourceManager.resourceCache[className] = {
               "ref":retClass,
               "src":retResourceID
            };
         }
         return retClass;
      }
      
      public static function getLibrarySound(soundName:String) : Sound
      {
         var myClass:Class = ResourceManager.getLibraryClass(soundName);
         if(Boolean(myClass))
         {
            return new myClass() as Sound;
         }
         return null;
      }
      
      public static function getPokemonStatsData() : Object
      {
         return getResourceByID("pokemon").getProp("pokemon");
      }
      
      public static function getAssistStatsData() : Object
      {
         return getResourceByID("assists").getProp("assists");
      }
      
      public static function getItemStats() : Array
      {
         var obj:Array = getResourceByID("items").MC.getItemStats();
         return obj || null;
      }
      
      public static function getAllCostumes(charName:String, teamColor:String, includeBase:Boolean = false) : Array
      {
         var obj:Object = null;
         var i:int = 0;
         var results:Array = [];
         var costumeList:Array = getResourceByID("misc").getProp("metadata").costume_data;
         if(costumeList != null)
         {
            if(Boolean(costumeList) && costumeList[charName] != null)
            {
               obj = null;
               for(i = 0; i < costumeList[charName].length; i++)
               {
                  if(teamColor != null)
                  {
                     if(Boolean(costumeList[charName][i]) && Boolean(costumeList[charName][i]["team"]) && costumeList[charName][i]["team"] == teamColor)
                     {
                        results.push(costumeList[charName][i]);
                        break;
                     }
                  }
                  else if(!Boolean(costumeList[charName][i]["team"]))
                  {
                     if(!(Boolean(costumeList[charName][i]["base"]) && !includeBase))
                     {
                        results.push(costumeList[charName][i]);
                     }
                  }
               }
            }
         }
         return results;
      }
      
      public static function getCostumeCount(charName:String) : int
      {
         var i:int = 0;
         var costumeLength:int = 0;
         var costumeList:Array = getResourceByID("misc").getProp("metadata").costume_data;
         if(costumeList != null)
         {
            if(Boolean(costumeList) && costumeList[charName] != null)
            {
               costumeLength = int(costumeList[charName].length);
               for(i = 0; i < costumeList[charName].length; i++)
               {
                  if(Boolean(costumeList[charName][i]["base"]) || Boolean(costumeList[charName][i]["team"]))
                  {
                     costumeLength--;
                  }
               }
            }
         }
         return int(costumeLength + 1);
      }
      
      public static function getCostume(charName:String, teamColor:String, num:int = -1) : Object
      {
         var obj:Object = null;
         var i:int = 0;
         var costumeList:Array = getResourceByID("misc").getProp("metadata").costume_data;
         var current:int = 0;
         var costumeObj:Object = null;
         var costumeLength:int = getCostumeCount(charName);
         if(costumeList != null)
         {
            if(Boolean(costumeList) && costumeList[charName] != null)
            {
               obj = null;
               if(num >= costumeLength - 1)
               {
                  num = -1;
               }
               for(i = 0; i < costumeList[charName].length; i++)
               {
                  if(teamColor != null)
                  {
                     if(Boolean(costumeList[charName][i]) && Boolean(costumeList[charName][i]["team"]) && costumeList[charName][i]["team"] == teamColor)
                     {
                        costumeObj = costumeList[charName][i];
                        break;
                     }
                  }
                  else if(!Boolean(costumeList[charName][i]["team"]))
                  {
                     if(!(num >= 0 && Boolean(costumeList[charName][i]["base"])))
                     {
                        if(num == current)
                        {
                           costumeObj = costumeList[charName][i];
                           break;
                        }
                        if(num === -1 && Boolean(costumeList[charName][i]["base"]))
                        {
                           costumeObj = costumeList[charName][i];
                           break;
                        }
                        current++;
                     }
                  }
               }
            }
         }
         return Utils.cloneObject(costumeObj);
      }
      
      public static function getMetalCostume(charName:String) : Object
      {
         var costumeObj:Object = getResourceByID("misc").getProp("metadata").metal_costume_data;
         if(Boolean(costumeObj) && Boolean(costumeObj[charName]))
         {
            return costumeObj[charName];
         }
         if(Boolean(costumeObj.§default§))
         {
            return costumeObj.§default§;
         }
         return null;
      }
      
      public static function getExpansionCharacter(idNum:int) : Vector.<Function>
      {
         return idNum >= 0 && idNum < m_expansionData.length && m_expansionData.length > 0 ? m_expansionData[idNum] : null;
      }
      
      public static function getExpansionCharacterObject(idNum:int, objIndex:Number) : Object
      {
         return idNum >= 0 && idNum < m_expansionData.length && m_expansionData.length > 0 && objIndex >= 0 && objIndex < m_expansionData[idNum].length ? m_expansionData[idNum][objIndex] : null;
      }
      
      public static function getNextExpansionCharacter(idNumber:Number) : Number
      {
         idNumber += 1;
         if(idNumber >= m_expansionData.length)
         {
            idNumber = 0;
         }
         return idNumber;
      }
      
      public static function getPrevExpansionCharacter(idNumber:Number) : Number
      {
         idNumber -= 1;
         if(idNumber < m_expansionData.length)
         {
            idNumber = m_expansionData.length - 1;
         }
         return idNumber;
      }
   }
}

