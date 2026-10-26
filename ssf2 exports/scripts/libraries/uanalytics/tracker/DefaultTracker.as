package libraries.uanalytics.tracker
{
   import flash.system.ApplicationDomain;
   import flash.utils.Dictionary;
   import libraries.uanalytics.tracker.senders.LoaderHitSender;
   import libraries.uanalytics.tracking.Configuration;
   import libraries.uanalytics.tracking.HitModel;
   import libraries.uanalytics.tracking.HitSampler;
   import libraries.uanalytics.tracking.RateLimitError;
   import libraries.uanalytics.tracking.RateLimiter;
   import libraries.uanalytics.tracking.Tracker;
   import libraries.uanalytics.utils.generateUUID;
   import libraries.uanalytics.utils.getHostname;
   
   public class DefaultTracker extends Tracker
   {
      
      public function DefaultTracker(trackingId:String = "", config:Configuration = null)
      {
         super();
         if(!config)
         {
            config = new Configuration();
         }
         _config = config;
         this._ctor(trackingId);
      }
      
      protected function _ctor(trackingId:String = "") : void
      {
         var S:Class = null;
         _model = new HitModel();
         _temporary = new HitModel();
         if(_config.senderType != "")
         {
            S = ApplicationDomain.currentDomain.getDefinition(_config.senderType) as Class;
            _sender = new S(this);
         }
         else
         {
            _sender = new LoaderHitSender(this);
         }
         _limiter = new RateLimiter(100,10);
         if(trackingId != "")
         {
            set(TRACKING_ID,trackingId);
         }
         var cid:String = this._getClientID();
         if(cid != "")
         {
            set(CLIENT_ID,cid);
         }
      }
      
      protected function _getClientID() : String
      {
         return generateUUID();
      }
      
      protected function _getCacheBuster() : String
      {
         var d:Date = new Date();
         var rnd:Number = Math.random();
         return String(d.valueOf() + rnd);
      }
      
      override public function send(hitType:String = null, tempValues:Dictionary = null) : Boolean
      {
         var copy:HitModel;
         var err:Error;
         var entry:String = null;
         if(trackingId == "" || trackingId == null)
         {
            if(Boolean(_config) && _config.enableErrorChecking)
            {
               throw new ArgumentError("tracking id is missing.");
            }
            return false;
         }
         if(clientId == "" || clientId == null)
         {
            if(Boolean(_config) && _config.enableErrorChecking)
            {
               throw new ArgumentError("client id is missing.");
            }
            return false;
         }
         copy = _model.clone();
         copy.add(_temporary);
         _temporary.clear();
         if(tempValues != null)
         {
            for(entry in tempValues)
            {
               copy.set(entry,tempValues[entry]);
            }
         }
         if((hitType != "" || hitType != null) && HitType.isValid(hitType))
         {
            copy.set(HIT_TYPE,hitType);
            if(Boolean(_config) && _config.enableSampling)
            {
               if(HitSampler.isSampled(copy,String(_config.sampleRate)))
               {
                  return false;
               }
            }
            if(Boolean(_config) && _config.enableThrottling)
            {
               if(!_limiter.consumeToken())
               {
                  if(Boolean(_config) && _config.enableErrorChecking)
                  {
                     throw new RateLimitError();
                  }
                  return false;
               }
            }
            if(Boolean(_config) && _config.enableCacheBusting)
            {
               copy.set(CACHE_BUSTER,this._getCacheBuster());
            }
            if(Boolean(_config) && _config.anonymizeIp)
            {
               copy.set(ANON_IP,"1");
            }
            if(Boolean(_config) && _config.overrideIpAddress != "")
            {
               copy.set(IP_OVERRIDE,_config.overrideIpAddress);
            }
            if(Boolean(_config) && _config.overrideUserAgent != "")
            {
               copy.set(USER_AGENT_OVERRIDE,_config.overrideUserAgent);
            }
            if(Boolean(_config) && _config.overrideGeographicalId != "")
            {
               copy.set(GEOGRAPHICAL_OVERRIDE,_config.overrideGeographicalId);
            }
            err = null;
            try
            {
               _sender.send(copy);
            }
            catch(e:Error)
            {
               err = e;
            }
            if(Boolean(_config) && Boolean(_config.enableErrorChecking) && Boolean(err))
            {
               throw err;
            }
            if(Boolean(err))
            {
               return false;
            }
            return true;
         }
         if(Boolean(_config) && _config.enableErrorChecking)
         {
            throw new ArgumentError("hit type \"" + hitType + "\" is not valid.");
         }
         return false;
      }
      
      override public function pageview(path:String, title:String = "") : Boolean
      {
         if(path == null || path == "")
         {
            if(Boolean(_config) && _config.enableErrorChecking)
            {
               throw new ArgumentError("path is empty");
            }
            return false;
         }
         var values:Dictionary = new Dictionary();
         values[Tracker.DOCUMENT_PATH] = path;
         if(Boolean(title) && title.length > 0)
         {
            if(title.length > 1500)
            {
               if(Boolean(_config) && _config.enableErrorChecking)
               {
                  throw new ArgumentError("Title is bigger than 1500 bytes.");
               }
               return false;
            }
            values[Tracker.DOCUMENT_TITLE] = title;
         }
         var hostname:String = get(Tracker.DOCUMENT_HOSTNAME);
         if(hostname == null)
         {
            if(!(Tracker.DOCUMENT_HOSTNAME in values))
            {
               hostname = getHostname();
               if(hostname == "")
               {
                  if(Boolean(_config) && _config.enableErrorChecking)
                  {
                     throw new ArgumentError("hostname is not defined.");
                  }
                  return false;
               }
               values[Tracker.DOCUMENT_HOSTNAME] = hostname;
            }
         }
         return this.send(HitType.PAGEVIEW,values);
      }
      
      override public function screenview(name:String, appinfo:Dictionary = null) : Boolean
      {
         var entry:String = null;
         if(name == null || name == "")
         {
            if(Boolean(_config) && _config.enableErrorChecking)
            {
               throw new ArgumentError("name is empty");
            }
            return false;
         }
         var values:Dictionary = new Dictionary();
         if(appinfo != null)
         {
            for(entry in appinfo)
            {
               values[entry] = appinfo[entry];
            }
         }
         var app_name:String = get(Tracker.APP_NAME);
         if(app_name == null)
         {
            if(!(Tracker.APP_NAME in values))
            {
               if(Boolean(_config) && _config.enableErrorChecking)
               {
                  throw new ArgumentError("Application name is not defined.");
               }
               return false;
            }
         }
         values[Tracker.SCREEN_NAME] = name;
         return this.send(HitType.SCREENVIEW,values);
      }
      
      override public function event(category:String, action:String, label:String = "", value:int = -1) : Boolean
      {
         if(category == null || category == "")
         {
            if(Boolean(_config) && _config.enableErrorChecking)
            {
               throw new ArgumentError("category is empty");
            }
            return false;
         }
         if(action == null || action == "")
         {
            if(Boolean(_config) && _config.enableErrorChecking)
            {
               throw new ArgumentError("action is empty");
            }
            return false;
         }
         var values:Dictionary = new Dictionary();
         values[Tracker.EVENT_CATEGORY] = category;
         values[Tracker.EVENT_ACTION] = action;
         if(label != "")
         {
            values[Tracker.EVENT_LABEL] = label;
         }
         if(value > -1)
         {
            values[Tracker.EVENT_VALUE] = value;
         }
         return this.send(HitType.EVENT,values);
      }
      
      override public function transaction(id:String, affiliation:String = "", revenue:Number = 0, shipping:Number = 0, tax:Number = 0, currency:String = "") : Boolean
      {
         if(id == null || id == "")
         {
            if(Boolean(_config) && _config.enableErrorChecking)
            {
               throw new ArgumentError("id is empty");
            }
            return false;
         }
         var values:Dictionary = new Dictionary();
         values[Tracker.TRANSACTION_ID] = id;
         if(affiliation != "")
         {
            values[Tracker.TRANSACTION_AFFILIATION] = affiliation;
         }
         values[Tracker.TRANSACTION_REVENUE] = revenue;
         values[Tracker.TRANSACTION_SHIPPING] = shipping;
         values[Tracker.TRANSACTION_TAX] = tax;
         if(currency != "")
         {
            values[Tracker.CURRENCY_CODE] = currency;
         }
         return this.send(HitType.TRANSACTION,values);
      }
      
      override public function item(transactionId:String, name:String, price:Number = 0, quantity:int = 0, code:String = "", category:String = "", currency:String = "") : Boolean
      {
         if(transactionId == null || transactionId == "")
         {
            if(Boolean(_config) && _config.enableErrorChecking)
            {
               throw new ArgumentError("transaction id is empty");
            }
            return false;
         }
         if(name == null || name == "")
         {
            if(Boolean(_config) && _config.enableErrorChecking)
            {
               throw new ArgumentError("name is empty");
            }
            return false;
         }
         var values:Dictionary = new Dictionary();
         values[Tracker.TRANSACTION_ID] = transactionId;
         values[Tracker.ITEM_NAME] = name;
         values[Tracker.ITEM_PRICE] = price;
         values[Tracker.ITEM_QUANTITY] = quantity;
         if(code != "")
         {
            values[Tracker.ITEM_CODE] = code;
         }
         if(category != "")
         {
            values[Tracker.ITEM_CATEGORY] = category;
         }
         if(currency != "")
         {
            values[Tracker.CURRENCY_CODE] = currency;
         }
         return this.send(HitType.ITEM,values);
      }
      
      override public function social(network:String, action:String, target:String) : Boolean
      {
         if(network == null || network == "")
         {
            if(Boolean(_config) && _config.enableErrorChecking)
            {
               throw new ArgumentError("network is empty");
            }
            return false;
         }
         if(action == null || action == "")
         {
            if(Boolean(_config) && _config.enableErrorChecking)
            {
               throw new ArgumentError("action is empty");
            }
            return false;
         }
         if(target == null || target == "")
         {
            if(Boolean(_config) && _config.enableErrorChecking)
            {
               throw new ArgumentError("target is empty");
            }
            return false;
         }
         var values:Dictionary = new Dictionary();
         values[Tracker.SOCIAL_NETWORK] = network;
         values[Tracker.SOCIAL_ACTION] = action;
         values[Tracker.SOCIAL_TARGET] = target;
         return this.send(HitType.SOCIAL,values);
      }
      
      override public function exception(description:String = "", isFatal:Boolean = true) : Boolean
      {
         var values:Dictionary = new Dictionary();
         if(description != "")
         {
            values[Tracker.EXCEPT_DESCRIPTION] = description;
         }
         if(isFatal)
         {
            values[Tracker.EXCEPT_FATAL] = "1";
         }
         else
         {
            values[Tracker.EXCEPT_FATAL] = "0";
         }
         return this.send(HitType.EXCEPTION,values);
      }
      
      override public function timing(category:String, name:String, value:int, label:String = "", timinginfo:Dictionary = null) : Boolean
      {
         var entry:String = null;
         if(category == null || category == "")
         {
            if(Boolean(_config) && _config.enableErrorChecking)
            {
               throw new ArgumentError("category is empty");
            }
            return false;
         }
         if(name == null || name == "")
         {
            if(Boolean(_config) && _config.enableErrorChecking)
            {
               throw new ArgumentError("name is empty");
            }
            return false;
         }
         if(value < 0)
         {
            if(Boolean(_config) && _config.enableErrorChecking)
            {
               throw new ArgumentError("value is empty");
            }
            return false;
         }
         var values:Dictionary = new Dictionary();
         values[Tracker.USER_TIMING_CATEGORY] = category;
         values[Tracker.USER_TIMING_VAR] = name;
         values[Tracker.USER_TIMING_TIME] = value;
         if(label != "")
         {
            values[Tracker.USER_TIMING_LABEL] = label;
         }
         if(timinginfo != null)
         {
            for(entry in timinginfo)
            {
               values[entry] = timinginfo[entry];
            }
         }
         return this.send(HitType.TIMING,values);
      }
   }
}

