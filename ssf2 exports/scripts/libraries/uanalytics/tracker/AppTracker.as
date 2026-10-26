package libraries.uanalytics.tracker
{
   import flash.events.NetStatusEvent;
   import flash.net.SharedObject;
   import flash.net.SharedObjectFlushStatus;
   import flash.system.ApplicationDomain;
   import libraries.uanalytics.tracker.senders.LoaderHitSender;
   import libraries.uanalytics.tracking.Configuration;
   import libraries.uanalytics.tracking.HitModel;
   import libraries.uanalytics.tracking.RateLimiter;
   import libraries.uanalytics.tracking.Tracker;
   import libraries.uanalytics.utils.generateUUID;
   
   public class AppTracker extends DefaultTracker
   {
      
      protected var _storage:SharedObject;
      
      public function AppTracker(trackingId:String = "", config:Configuration = null)
      {
         super(trackingId,config);
      }
      
      override protected function _ctor(trackingId:String = "") : void
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
         _limiter = new RateLimiter(20,2,1);
         if(trackingId != "")
         {
            set(TRACKING_ID,trackingId);
         }
         var cid:String = this._getClientID();
         if(cid != "")
         {
            set(CLIENT_ID,cid);
         }
         set(Tracker.DATA_SOURCE,DataSource.APP);
      }
      
      override protected function _getClientID() : String
      {
         var cid:String = null;
         var flushStatus:String = null;
         this._storage = SharedObject.getLocal(_config.storageName);
         if(!this._storage.data.clientid)
         {
            cid = generateUUID();
            this._storage.data.clientid = cid;
            flushStatus = null;
            try
            {
               flushStatus = this._storage.flush(1024);
            }
            catch(e:Error)
            {
            }
            if(flushStatus != null)
            {
               switch(flushStatus)
               {
                  case SharedObjectFlushStatus.PENDING:
                     this._storage.addEventListener(NetStatusEvent.NET_STATUS,this.onFlushStatus);
                     break;
                  case SharedObjectFlushStatus.FLUSHED:
               }
            }
         }
         else
         {
            cid = this._storage.data.clientid;
         }
         return cid;
      }
      
      protected function onFlushStatus(event:NetStatusEvent) : void
      {
         this._storage.removeEventListener(NetStatusEvent.NET_STATUS,this.onFlushStatus);
         switch(event.info.code)
         {
            case "SharedObject.Flush.Success":
            case "SharedObject.Flush.Failed":
         }
      }
   }
}

