package com.mcleodgaming.mgn.net
{
   import com.mcleodgaming.mgn.events.MGNEvent;
   import com.mcleodgaming.ssf2.util.Base64;
   import flash.events.EventDispatcher;
   import flash.events.NetStatusEvent;
   import flash.events.TimerEvent;
   import flash.net.GroupSpecifier;
   import flash.net.NetConnection;
   import flash.net.NetGroup;
   import flash.utils.ByteArray;
   import flash.utils.Timer;
   
   public class P2PRTMFP extends EventDispatcher implements IP2PSocket
   {
      
      protected const RTMFP_SERVER:String = "rtmfp://rtmfp.supersmashflash.com:1935/";
      
      protected const RTMFP_DEVKEY:String = "games/ssf2";
      
      protected var LOCAL_MODE:Boolean = false;
      
      private var _socket:IWebSocket;
      
      private var _isHost:Boolean;
      
      private var _playerGuid:String;
      
      private var _roomGuid:String;
      
      private var _initialized:Boolean;
      
      protected var m_netConnection:NetConnection;
      
      protected var m_netConnectionReady:Boolean;
      
      protected var m_netGroup:NetGroup;
      
      protected var m_netGroupConnected:Boolean;
      
      protected var m_netGroupTimer:Timer;
      
      protected var m_groupSpec:GroupSpecifier;
      
      public function P2PRTMFP(socket:IWebSocket, isHost:Boolean, ipAddress:String)
      {
         super();
         this._socket = socket;
         this._isHost = isHost;
         this._playerGuid = Base64.encode(Math.random() + "");
         this._roomGuid = null;
         this._initialized = false;
         this.m_netConnection = null;
         this.m_netConnectionReady = false;
         this.m_netGroup = null;
         this.m_netGroupConnected = false;
         this.m_netGroupTimer = new Timer(10000,1);
         this.m_groupSpec = null;
         this.m_netGroupTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.checkNetGroup);
      }
      
      public function get connected() : Boolean
      {
         return this.m_netGroupConnected;
      }
      
      public function getAckObj() : Object
      {
         return {
            "type":"p2pinit",
            "roomGuid":this._roomGuid,
            "playerGuid":this._playerGuid
         };
      }
      
      private function onSocketMessage(e:MGNEvent) : void
      {
         var data:* = e.data.data;
         if(!(data is ByteArray))
         {
            if(data.type == "directMessage" || data.type == "broadcast")
            {
               data = data.data;
            }
            if(data.type === "p2pinit")
            {
               this._roomGuid = data.roomGuid;
               if(this.m_netConnectionReady)
               {
                  this.setupGroup();
               }
            }
         }
      }
      
      private function netStatus(event:NetStatusEvent) : void
      {
         switch(event.info.code)
         {
            case "NetConnection.Connect.Success":
               trace("NetConnection successful!!!");
               this.m_netConnectionReady = true;
               if(this._isHost)
               {
                  this._roomGuid = Base64.encode(Math.random() + "");
                  this.setupGroup();
               }
               else if(Boolean(this._roomGuid))
               {
                  this.setupGroup();
               }
               break;
            case "NetConnection.Connect.Failed":
               dispatchEvent(new MGNEvent(MGNEvent.P2P_ERROR,{"message":"Warning, could not connect to RTMFP server. Gameplay may be slower than usual."}));
               this.close();
               break;
            case "NetConnection.Connect.Closed":
               if(this._initialized)
               {
                  this.close();
               }
               break;
            case "NetGroup.Connect.Success":
               this.m_netGroupTimer.stop();
               this.m_netGroupConnected = true;
               dispatchEvent(new MGNEvent(MGNEvent.P2P_CONNECT));
               break;
            case "NetConnection.Connect.Rejected":
               dispatchEvent(new MGNEvent(MGNEvent.P2P_ERROR,{"message":"NetConnection connection request was rejected."}));
               this.close();
               break;
            case "NetGroup.Neighbor.Connect":
            case "NetGroup.Neighbor.Disconnect":
               break;
            case "NetGroup.SendTo.Notify":
               this.onUdpMessage(event);
         }
      }
      
      private function checkNetGroup(e:TimerEvent) : void
      {
         if(!this.m_netGroupConnected)
         {
            this.close();
            dispatchEvent(new MGNEvent(MGNEvent.P2P_ERROR,{"message":"P2P connection failed, will fallback to sockets"}));
         }
         else
         {
            trace("P2P NetGroup connection verified");
         }
      }
      
      private function onUdpMessage(event:NetStatusEvent) : void
      {
         dispatchEvent(new MGNEvent(MGNEvent.P2P_MESSAGE,{"data":event.info.message}));
      }
      
      public function connect() : void
      {
         if(this._initialized)
         {
            throw new Error("Error, cannot initialized P2P more than once!");
         }
         this._initialized = true;
         this.m_netConnection = new NetConnection();
         this.m_netConnection.addEventListener(NetStatusEvent.NET_STATUS,this.netStatus);
         this.m_netConnection.connect(this.LOCAL_MODE ? "rtmfp:" : this.RTMFP_SERVER + this.RTMFP_DEVKEY);
         this._socket.addEventListener(MGNEvent.SOCKET_MESSAGE,this.onSocketMessage);
      }
      
      private function setupGroup() : void
      {
         this.m_groupSpec = new GroupSpecifier(this._roomGuid);
         this.m_groupSpec.serverChannelEnabled = true;
         this.m_groupSpec.routingEnabled = true;
         this.m_groupSpec.ipMulticastMemberUpdatesEnabled = true;
         this.m_groupSpec.postingEnabled = true;
         this.m_netGroup = new NetGroup(this.m_netConnection,this.m_groupSpec.groupspecWithAuthorizations());
         this.m_netGroup.addEventListener(NetStatusEvent.NET_STATUS,this.netStatus);
         this.m_netGroupTimer.start();
      }
      
      public function sendToAll(data:Object) : void
      {
         if(this.m_netGroup !== null)
         {
            this.m_netGroup.sendToAllNeighbors(data);
         }
      }
      
      public function close() : void
      {
         if(this._initialized)
         {
            this._initialized = false;
            this.m_netGroupTimer.stop();
            this._socket.removeEventListener(MGNEvent.SOCKET_MESSAGE,this.onSocketMessage);
            if(Boolean(this.m_netGroup))
            {
               this.m_netGroup.removeEventListener(NetStatusEvent.NET_STATUS,this.netStatus);
               this.m_netGroup.close();
               this.m_netConnection.close();
            }
            this.m_netGroup = null;
            this.m_netConnection = null;
            this.m_netGroupConnected = false;
            dispatchEvent(new MGNEvent(MGNEvent.P2P_CLOSE));
         }
      }
   }
}

