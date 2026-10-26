package libraries.uanalytics.tracking
{
   import flash.utils.Dictionary;
   
   public class Tracker implements AnalyticsTracker
   {
      
      public static const PROTOCOL_VERSION:String = "protocolVersion";
      
      public static const TRACKING_ID:String = "trackingId";
      
      public static const ANON_IP:String = "anonymizeIp";
      
      public static const DATA_SOURCE:String = "dataSource";
      
      public static const QUEUE_TIME:String = "queueTime";
      
      public static const CACHE_BUSTER:String = "cacheBuster";
      
      public static const CLIENT_ID:String = "clientId";
      
      public static const USER_ID:String = "userId";
      
      public static const SESSION_CONTROL:String = "sessionControl";
      
      public static const IP_OVERRIDE:String = "ipOverride";
      
      public static const USER_AGENT_OVERRIDE:String = "userAgentOverride";
      
      public static const GEOGRAPHICAL_OVERRIDE:String = "geographicalOverride";
      
      public static const DOCUMENT_REFERRER:String = "documentReferrer";
      
      public static const CAMPAIGN_NAME:String = "campaignName";
      
      public static const CAMPAIGN_SOURCE:String = "campaignSource";
      
      public static const CAMPAIGN_MEDIUM:String = "campaignMedium";
      
      public static const CAMPAIGN_KEYWORD:String = "campaignKeyword";
      
      public static const CAMPAIGN_CONTENT:String = "campaignContent";
      
      public static const CAMPAIGN_ID:String = "campaignId";
      
      public static const GOOGLE_ADWORDS_ID:String = "googleAdwordsId";
      
      public static const GOOGLE_DISPLAY_ADS_ID:String = "googleDisplayAdsId";
      
      public static const SCREEN_RESOLUTION:String = "screenResolution";
      
      public static const VIEWPORT_SIZE:String = "viewportSize";
      
      public static const DOCUMENT_ENCODING:String = "documentEncoding";
      
      public static const SCREEN_COLORS:String = "screenColors";
      
      public static const USER_LANGUAGE:String = "userLanguage";
      
      public static const JAVA_ENABLED:String = "javaEnabled";
      
      public static const FLASH_VERSION:String = "flashVersion";
      
      public static const HIT_TYPE:String = "hitType";
      
      public static const NON_INTERACTION:String = "nonInteraction";
      
      public static const DOCUMENT_LOCATION:String = "documentLocation";
      
      public static const DOCUMENT_HOSTNAME:String = "documentHostname";
      
      public static const DOCUMENT_PATH:String = "documentPath";
      
      public static const DOCUMENT_TITLE:String = "documentTitle";
      
      public static const SCREEN_NAME:String = "screenName";
      
      public static const LINK_ID:String = "linkId";
      
      public static const APP_NAME:String = "appName";
      
      public static const APP_ID:String = "appId";
      
      public static const APP_VERSION:String = "appVersion";
      
      public static const APP_INSTALLER_ID:String = "appInstallerId";
      
      public static const EVENT_CATEGORY:String = "eventCategory";
      
      public static const EVENT_ACTION:String = "eventAction";
      
      public static const EVENT_LABEL:String = "eventLabel";
      
      public static const EVENT_VALUE:String = "eventValue";
      
      public static const TRANSACTION_ID:String = "transactionId";
      
      public static const TRANSACTION_AFFILIATION:String = "transactionAffiliation";
      
      public static const TRANSACTION_REVENUE:String = "transactionRevenue";
      
      public static const TRANSACTION_SHIPPING:String = "transactionShipping";
      
      public static const TRANSACTION_TAX:String = "transactionTax";
      
      public static const ITEM_NAME:String = "itemName";
      
      public static const ITEM_PRICE:String = "itemPrice";
      
      public static const ITEM_QUANTITY:String = "itemQuantity";
      
      public static const ITEM_CODE:String = "itemCode";
      
      public static const ITEM_CATEGORY:String = "itemCategory";
      
      public static const CURRENCY_CODE:String = "currencyCode";
      
      public static const PRODUCT_ACTION:String = "productAction";
      
      public static const COUPON_CODE:String = "couponCode";
      
      public static const PRODUCT_ACTION_LIST:String = "productActionList";
      
      public static const CHECKOUT_STEP:String = "checkoutStep";
      
      public static const CHECKOUT_STEP_OPTION:String = "checkoutStepOption";
      
      public static const PROMOTION_ACTION:String = "promotionAction";
      
      public static const SOCIAL_NETWORK:String = "socialNetwork";
      
      public static const SOCIAL_ACTION:String = "socialAction";
      
      public static const SOCIAL_TARGET:String = "socialTarget";
      
      public static const USER_TIMING_CATEGORY:String = "userTimingCategory";
      
      public static const USER_TIMING_VAR:String = "userTimingVar";
      
      public static const USER_TIMING_TIME:String = "userTimingTime";
      
      public static const USER_TIMING_LABEL:String = "userTimingLabel";
      
      public static const PAGE_LOAD_TIME:String = "pageLoadTime";
      
      public static const DNS_TIME:String = "dnsTime";
      
      public static const PAGE_DOWNLOAD_TIME:String = "pageDownloadTime";
      
      public static const REDIRECT_RESPONSE_TIME:String = "redirectResponseTime";
      
      public static const TCP_CONNECT_TIME:String = "tcpConnectTime";
      
      public static const SERVER_RESPONSE_TIME:String = "serverResponseTime";
      
      public static const DOM_INTERACTIVE_TIME:String = "domInteractiveTime";
      
      public static const CONTENT_LOAD_TIME:String = "contentLoadTime";
      
      public static const EXCEPT_DESCRIPTION:String = "exceptionDescription";
      
      public static const EXCEPT_FATAL:String = "exceptionFatal";
      
      protected var _model:HitModel;
      
      protected var _temporary:HitModel;
      
      protected var _sender:HitSender;
      
      protected var _limiter:RateLimiter;
      
      protected var _config:Configuration;
      
      public function Tracker()
      {
         super();
      }
      
      public static function CUSTOM_DIMENSION(index:uint = 0) : String
      {
         if(index < 1)
         {
            index = 1;
         }
         if(index > 200)
         {
            index = 200;
         }
         return "dimension" + index;
      }
      
      public static function CUSTOM_METRIC(index:uint = 0) : String
      {
         if(index < 1)
         {
            index = 1;
         }
         if(index > 200)
         {
            index = 200;
         }
         return "metric" + index;
      }
      
      public function get trackingId() : String
      {
         return this.get(TRACKING_ID);
      }
      
      public function get clientId() : String
      {
         return this.get(CLIENT_ID);
      }
      
      public function get config() : Configuration
      {
         return this._config;
      }
      
      public function set(field:String, value:String) : void
      {
         if(Boolean(this._model))
         {
            this._model.set(field,value);
         }
      }
      
      public function setOneTime(field:String, value:String) : void
      {
         if(Boolean(this._temporary))
         {
            this._temporary.set(field,value);
         }
      }
      
      public function get(field:String) : String
      {
         if(Boolean(this._model))
         {
            return this._model.get(field);
         }
         return null;
      }
      
      public function add(values:Dictionary) : void
      {
         var entry:String = null;
         if(Boolean(this._model))
         {
            for(entry in values)
            {
               this.set(entry,values[entry]);
            }
         }
      }
      
      public function send(hitType:String = null, tempValues:Dictionary = null) : Boolean
      {
         return false;
      }
      
      public function pageview(path:String, title:String = "") : Boolean
      {
         return false;
      }
      
      public function screenview(name:String, appinfo:Dictionary = null) : Boolean
      {
         return false;
      }
      
      public function event(category:String, action:String, label:String = "", value:int = -1) : Boolean
      {
         return false;
      }
      
      public function transaction(id:String, affiliation:String = "", revenue:Number = 0, shipping:Number = 0, tax:Number = 0, currency:String = "") : Boolean
      {
         return false;
      }
      
      public function item(transactionId:String, name:String, price:Number = 0, quantity:int = 0, code:String = "", category:String = "", currency:String = "") : Boolean
      {
         return false;
      }
      
      public function social(network:String, action:String, target:String) : Boolean
      {
         return false;
      }
      
      public function exception(description:String = "", isFatal:Boolean = true) : Boolean
      {
         return false;
      }
      
      public function timing(category:String, name:String, value:int, label:String = "", timinginfo:Dictionary = null) : Boolean
      {
         return false;
      }
   }
}

