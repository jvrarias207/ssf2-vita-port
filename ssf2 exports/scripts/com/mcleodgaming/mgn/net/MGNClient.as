package com.mcleodgaming.mgn.net
{
   import com.mcleodgaming.mgn.events.MGNEvent;
   import com.mcleodgaming.mgn.events.MGNEventManager;
   import flash.events.TimerEvent;
   import flash.net.*;
   import flash.utils.ByteArray;
   import flash.utils.Timer;
   
   public class MGNClient
   {
      
      public static const POLICY_FILE:String = "xmlsocket://xmlp.supersmashflash.com:843";
      
      public static const MODE_CLIENT_JOINED:int = 0;
      
      public static const MODE_DATAFRAME_RECEIVED:int = 1;
      
      public static const MODE_RESEND_DATAFRAME:int = 2;
      
      public static const MODE_ACK_REQUEST:int = 3;
      
      public static const MODE_ACK_RESPONSE:int = 4;
      
      public static const MODE_CLIENT_JOINED_RESPONSE:int = 5;
      
      public static const MODE_MATCH_END:int = 6;
      
      public static const MODE_DOWNGRADE_P2P:int = 7;
      
      public static const PACKET_CONTROLS:int = 0;
      
      public static const PACKET_JSON:int = 1;
      
      protected const LOBBY_SERVER:String = "wss://prod1.mgn.supersmashflash.com/";
      
      protected var RESEND_TIME:int = 90;
      
      protected var m_protocol:String;
      
      protected var m_ipAddress:String;
      
      protected var m_lobbySocket:IWebSocket;
      
      protected var m_lobbyLoginToken:String;
      
      protected var m_lobbySocketID:String;
      
      protected var m_gameSocket:IWebSocket;
      
      protected var m_gameSocketID:String;
      
      protected var m_gameSocketUrl:String;
      
      protected var m_maxPlayers:int;
      
      protected var m_players:Vector.<PlayerConnectionInfo>;
      
      protected var m_userName:String;
      
      protected var m_userKey:String;
      
      protected var m_version:String;
      
      protected var m_playerID:int;
      
      protected var m_active:Boolean;
      
      protected var m_isHost:Boolean;
      
      protected var m_resendTimer:int;
      
      protected var m_matchStarted:Boolean;
      
      protected var m_currentHostID:String;
      
      protected var m_isDev:Boolean;
      
      protected var m_lastSentPing:int;
      
      protected var m_pingRoundTripTime:int;
      
      private var m_password:String;
      
      protected var m_roomList:Array;
      
      protected var m_currentRoomKey:String;
      
      protected var m_currentRoomName:String;
      
      protected var m_currentRoomCode:String;
      
      protected var m_roomData:Object;
      
      protected var m_roomLocked:Boolean;
      
      protected var m_playerData:Array;
      
      protected var m_playerSyncStream:PlayerDataSyncStream;
      
      protected var m_controlBits:Vector.<Vector.<int>>;
      
      protected var m_masterFrame:int;
      
      protected var m_p2pSocket:IP2PSocket;
      
      protected var m_pingTimer:Timer;
      
      protected var m_timeoutTimer:Timer;
      
      protected var m_gameSocketTimeout:Timer;
      
      protected var m_downgradedConnection:Boolean;
      
      public function MGNClient(maxPlayers:int)
      {
         super();
         this.m_maxPlayers = maxPlayers;
         this.init();
         this.m_pingTimer = new Timer(30 * 1000);
         this.m_pingTimer.addEventListener(TimerEvent.TIMER,this.onPingInterval);
         this.m_timeoutTimer = new Timer(30 * 1000,1);
         this.m_gameSocketTimeout = new Timer(10 * 1000,1);
         this.m_timeoutTimer.addEventListener(TimerEvent.TIMER_COMPLETE,function(e:TimerEvent):void
         {
            MGNEventManager.dispatcher.dispatchEvent(new MGNEvent(MGNEvent.NOTIFY,{"message":"Connection timeout."}));
            disconnect();
         });
         this.m_gameSocketTimeout.addEventListener(TimerEvent.TIMER_COMPLETE,function(e:TimerEvent):void
         {
            disconnectGameServer();
            m_gameSocketTimeout.stop();
         });
      }
      
      public function get SocketID() : String
      {
         return this.m_lobbySocketID;
      }
      
      public function get CurrentHostID() : String
      {
         return this.m_currentHostID;
      }
      
      public function get UserKey() : String
      {
         return this.m_userKey;
      }
      
      public function get Username() : String
      {
         return this.m_userName;
      }
      
      public function get RoomList() : Array
      {
         return this.m_roomList;
      }
      
      public function get ControlBits() : Vector.<Vector.<int>>
      {
         return this.m_controlBits;
      }
      
      public function get Connected() : Boolean
      {
         return Boolean(this.m_lobbySocket) && this.m_lobbySocket.connected;
      }
      
      public function get Active() : Boolean
      {
         return this.m_active;
      }
      
      public function set Active(value:Boolean) : void
      {
         this.m_active = value;
      }
      
      public function get MaxPlayers() : int
      {
         return this.m_maxPlayers;
      }
      
      public function get MasterFrame() : int
      {
         return this.m_masterFrame;
      }
      
      public function set MasterFrame(value:int) : void
      {
         this.m_masterFrame = value;
      }
      
      public function get Protocol() : String
      {
         return this.m_protocol;
      }
      
      public function set Protocol(value:String) : void
      {
         this.m_protocol = value;
      }
      
      public function get DowngradedConnection() : Boolean
      {
         return this.m_downgradedConnection;
      }
      
      public function get PlayerID() : int
      {
         return this.m_playerID;
      }
      
      public function set PlayerID(value:int) : void
      {
         this.m_playerID = value;
      }
      
      public function get Players() : Vector.<PlayerConnectionInfo>
      {
         return this.m_players;
      }
      
      public function get RoomKey() : String
      {
         return this.m_currentRoomKey;
      }
      
      public function get RoomName() : String
      {
         return this.m_currentRoomCode;
      }
      
      public function get RoomLocked() : Boolean
      {
         return this.m_roomLocked;
      }
      
      public function get IsHost() : Boolean
      {
         return this.m_isHost;
      }
      
      public function get PlayerConnectionInfoList() : Vector.<PlayerConnectionInfo>
      {
         return this.m_players;
      }
      
      public function get PlayerSyncStream() : PlayerDataSyncStream
      {
         return this.m_playerSyncStream;
      }
      
      protected function init(soft:Boolean = false) : void
      {
         if(!soft)
         {
            this.m_userName = "";
         }
         this.m_userKey = null;
         this.m_playerID = 0;
         this.m_masterFrame = 1;
         this.m_roomData = null;
         this.m_playerData = null;
         this.m_roomList = new Array();
         this.m_active = false;
         this.m_isHost = true;
         this.m_resendTimer = this.RESEND_TIME;
         this.m_matchStarted = false;
         this.m_currentHostID = null;
         this.m_isDev = false;
         this.m_lastSentPing = 0;
         this.m_pingRoundTripTime = 0;
         this.m_downgradedConnection = false;
         this.m_protocol = ProtocolSetting.P2P_UDP;
         this.m_controlBits = new Vector.<Vector.<int>>();
         for(var i:int = 0; i < this.m_maxPlayers; i++)
         {
            this.m_controlBits.push(new Vector.<int>());
         }
         this.m_lobbySocket = null;
         this.m_gameSocket = null;
         this.m_gameSocketID = null;
         this.m_gameSocketUrl = null;
         this.m_currentRoomCode = null;
         this.m_currentRoomKey = "";
         this.m_currentRoomName = "";
         this.m_roomLocked = false;
         this.m_lobbySocketID = null;
         this.m_playerSyncStream = new PlayerDataSyncStream();
         this.m_players = new Vector.<PlayerConnectionInfo>();
      }
      
      public function resetMasterFrame() : void
      {
         this.m_masterFrame = 1;
         this.m_playerSyncStream.init(this.m_players.length);
         this.m_controlBits = new Vector.<Vector.<int>>();
         for(var i:int = 0; i < this.m_maxPlayers; i++)
         {
            this.m_controlBits.push(new Vector.<int>());
         }
      }
      
      public function getFrameDelay() : int
      {
         return this.m_playerSyncStream.Pointer - this.m_masterFrame;
      }
      
      public function connect(userName:String, password:String, version:String) : void
      {
         if(!this.m_lobbySocket)
         {
            this.m_userName = userName;
            this.m_password = password;
            this.m_version = version;
            this.m_lobbySocket = new WebSocketWorlize(this.LOBBY_SERVER);
            this.m_lobbySocket.addEventListener(MGNEvent.SOCKET_CONNECT,this.handleLobbyConnect);
            this.m_lobbySocket.addEventListener(MGNEvent.SOCKET_CLOSE,this.handleLobbyDisconnect);
            this.m_lobbySocket.addEventListener(MGNEvent.SOCKET_MESSAGE,this.onLobbySocketMessage);
            this.m_lobbySocket.addEventListener(MGNEvent.SOCKET_ERROR,this.handleLobbyConnectError);
            this.m_lobbySocket.connect();
            this.m_timeoutTimer.start();
         }
      }
      
      private function connectGameServer(url:String) : void
      {
         if(Boolean(this.m_gameSocket))
         {
            this.m_gameSocket.removeEventListener(MGNEvent.SOCKET_CONNECT,this.handleGameConnect);
            this.m_gameSocket.removeEventListener(MGNEvent.SOCKET_CLOSE,this.handleGameDisconnect);
            this.m_gameSocket.removeEventListener(MGNEvent.SOCKET_MESSAGE,this.onGameSocketMessage);
            this.m_gameSocket.removeEventListener(MGNEvent.SOCKET_ERROR,this.handleGameConnectError);
            this.m_gameSocket.close();
            this.m_gameSocket = null;
         }
         this.m_gameSocket = new WebSocketWorlize(url);
         this.m_gameSocket.addEventListener(MGNEvent.SOCKET_CONNECT,this.handleGameConnect);
         this.m_gameSocket.addEventListener(MGNEvent.SOCKET_CLOSE,this.handleGameDisconnect);
         this.m_gameSocket.addEventListener(MGNEvent.SOCKET_MESSAGE,this.onGameSocketMessage);
         this.m_gameSocket.addEventListener(MGNEvent.SOCKET_ERROR,this.handleGameConnectError);
         this.m_gameSocket.connect();
         this.m_gameSocketTimeout.start();
      }
      
      public function disconnect(soft:Boolean = false) : void
      {
         if(Boolean(this.m_lobbySocket))
         {
            this.m_timeoutTimer.stop();
            this.m_pingTimer.stop();
            this.disconnectGameServer();
            this.disconnectP2PServer();
            if(Boolean(this.m_lobbySocket))
            {
               this.m_lobbySocket.removeEventListener(MGNEvent.SOCKET_CONNECT,this.handleLobbyConnect);
               this.m_lobbySocket.removeEventListener(MGNEvent.SOCKET_CLOSE,this.handleLobbyDisconnect);
               this.m_lobbySocket.removeEventListener(MGNEvent.SOCKET_MESSAGE,this.onLobbySocketMessage);
               this.m_lobbySocket.removeEventListener(MGNEvent.SOCKET_ERROR,this.handleLobbyConnectError);
               if(this.m_lobbySocket.connected)
               {
                  this.m_lobbySocket.close();
               }
            }
            this.m_lobbySocket = null;
            this.init(soft);
            if(!soft)
            {
               MGNEventManager.dispatcher.dispatchEvent(new MGNEvent(MGNEvent.DISCONNECT,{}));
            }
         }
         trace("Disconnected from lobby server. (Purposefully)");
      }
      
      private function disconnectGameServer() : void
      {
         if(Boolean(this.m_gameSocket))
         {
            this.m_gameSocket.removeEventListener(MGNEvent.SOCKET_CONNECT,this.handleGameConnect);
            this.m_gameSocket.removeEventListener(MGNEvent.SOCKET_CLOSE,this.handleGameDisconnect);
            this.m_gameSocket.removeEventListener(MGNEvent.SOCKET_MESSAGE,this.onGameSocketMessage);
            this.m_gameSocket.removeEventListener(MGNEvent.SOCKET_ERROR,this.handleGameConnectError);
            if(this.m_gameSocket.connected)
            {
               this.m_gameSocket.close();
            }
            trace("Disconnected from game server. (Purposefully)");
         }
         this.m_gameSocket = null;
      }
      
      private function disconnectP2PServer() : void
      {
         if(Boolean(this.m_p2pSocket))
         {
            this.m_p2pSocket.close();
         }
         trace("Disconnected from P2P server. (Purposefully)");
      }
      
      private function socketHelper(socket:IWebSocket, data:*, type:String) : void
      {
         var str:String = null;
         if(type == "binary")
         {
            socket.sendBytes(data as ByteArray);
         }
         else if(type == "string")
         {
            socket.sendString(data);
         }
         else
         {
            if(type != "object")
            {
               throw new Error("Error, socket data type not supported: " + type);
            }
            socket.sendString(JSON.stringify(data));
         }
      }
      
      private function handleLobbyConnect(e:MGNEvent) : void
      {
         this.socketHelper(this.m_lobbySocket,{
            "type":"login",
            "username":this.m_userName,
            "password":this.m_password,
            "version":this.m_version
         },"object");
      }
      
      private function handleLobbyConnectError(error:MGNEvent) : void
      {
         this.m_timeoutTimer.stop();
         trace("Got error ",error);
         MGNEventManager.dispatcher.dispatchEvent(new MGNEvent(MGNEvent.NOTIFY,{"message":"Could not connect to server."}));
         MGNEventManager.dispatcher.dispatchEvent(new MGNEvent(MGNEvent.ERROR_CONNECT,{}));
         this.disconnect();
      }
      
      private function handleLobbyDisconnect(e:MGNEvent = null) : void
      {
         this.m_timeoutTimer.stop();
         this.m_pingTimer.stop();
         trace("Disconnected from lobby server. (Lost Connection)");
         this.disconnect();
      }
      
      private function handleGameConnect(e:MGNEvent) : void
      {
         this.socketHelper(this.m_gameSocket,{
            "type":"validateRoom",
            "room_key":this.m_currentRoomKey,
            "room_code":this.m_currentRoomCode
         },"object");
      }
      
      private function handleGameConnectError(error:MGNEvent) : void
      {
         trace("Got error ",error);
         MGNEventManager.dispatcher.dispatchEvent(new MGNEvent(MGNEvent.ERROR_CONNECT_GAME,{"message":"Problem connecting to game server."}));
      }
      
      private function handleGameDisconnect(e:MGNEvent = null) : void
      {
         trace("Disconnected from game server. (Lost Connection)");
         this.disconnect();
      }
      
      private function onGameSocketMessage(e:MGNEvent) : void
      {
         var data:Object = e.data.data;
         if(data is ByteArray)
         {
            this.receiveMessage(this.readBinaryPacket(data as ByteArray));
         }
         else if(data.type == "broadcast" || data.type == "directMessage")
         {
            switch(data.data.type)
            {
               case "neighborLeave":
                  this.participantDisconnected(data.data.id);
                  break;
               case "broadcast":
                  this.receiveMessage(data.data);
                  break;
               case "directMessage":
                  this.receiveMessage(data.data);
            }
         }
         else if(data.type == "validateRoomSuccess")
         {
            this.m_gameSocketID = data.sid;
            this.m_matchStarted = true;
            this.m_gameSocketTimeout.stop();
            trace("Room validated successfully, we can start match communication.");
            if(!this.m_downgradedConnection)
            {
               MGNEventManager.dispatcher.dispatchEvent(new MGNEvent(MGNEvent.MATCH_START,{
                  "room_data":this.m_roomData,
                  "player_data":this.m_playerData
               }));
            }
            else
            {
               MGNEventManager.dispatcher.dispatchEvent(new MGNEvent(MGNEvent.NOTIFY,{"message":"Successfully downgraded P2P connection"}));
            }
         }
         else if(data.type == "validateRoomError")
         {
            trace("Error, there was a problem validating the room data.");
         }
      }
      
      private function onLobbySocketMessage(e:MGNEvent) : void
      {
         var i:int = 0;
         var data:Object = e.data.data;
         if(data.type == "directMessage" || data.type == "broadcast")
         {
            data = data.data;
         }
         if(Boolean(data.message) && data.type !== "loginSuccess")
         {
            MGNEventManager.dispatcher.dispatchEvent(new MGNEvent(MGNEvent.NOTIFY,{"message":data.message}));
         }
         if(data.type == "connectSuccess")
         {
            MGNEventManager.dispatcher.dispatchEvent(new MGNEvent(MGNEvent.CONNECT,{}));
         }
         else if(data.type == "loginSuccess")
         {
            this.m_lobbyLoginToken = data.login_token;
            this.m_ipAddress = data.ip;
            this.socketHelper(this.m_lobbySocket,{
               "type":"loginValidate",
               "username":this.m_userName,
               "login_token":this.m_lobbyLoginToken
            },"object");
         }
         else if(data.type == "loginValidateSuccess")
         {
            this.m_timeoutTimer.stop();
            this.m_userName = data.username;
            this.m_userKey = data.user_key;
            this.m_lobbySocketID = data.sid;
            this.m_isDev = data.is_dev;
            this.m_password = null;
            this.m_pingTimer.reset();
            this.m_pingTimer.start();
            MGNEventManager.dispatcher.dispatchEvent(new MGNEvent(MGNEvent.LOGIN,{}));
         }
         else if(data.type == "listRoomsSuccess")
         {
            this.getRoomList(data.rooms);
         }
         else if(data.type == "getRoomUsersSuccess")
         {
            trace("Got room user list");
         }
         else if(data.type == "roomJoinRequest")
         {
            if(this.m_players.length >= this.m_maxPlayers)
            {
               this.socketHelper(this.m_lobbySocket,{
                  "type":"directMessage",
                  "target":data.sid,
                  "data":{
                     "type":"requestToJoinRoomError",
                     "message":"Could not join, room is full."
                  }
               },"object");
            }
            else if(this.m_roomLocked)
            {
               this.socketHelper(this.m_lobbySocket,{
                  "type":"directMessage",
                  "target":data.sid,
                  "data":{
                     "type":"requestToJoinRoomError",
                     "message":"Could not join, room was locked."
                  }
               },"object");
            }
            else
            {
               MGNEventManager.dispatcher.dispatchEvent(new MGNEvent(MGNEvent.ROOM_JOIN_REQUEST,{"playerConnectionInfo":new PlayerConnectionInfo({
                  "username":data.username,
                  "user_key":data.user_key,
                  "socket_id":data.sid,
                  "is_dev":data.is_dev
               })}));
            }
         }
         else if(data.type == "requestToJoinRoomSuccess")
         {
            this.m_players = new Vector.<PlayerConnectionInfo>();
            this.m_currentHostID = data.sid;
            this.m_protocol = data.protocol;
            this.joinRoom(data.room_key,data.room_code);
         }
         else if(data.type == "joinRoomSuccess")
         {
            this.m_isHost = false;
            this.handleJoin(data);
            MGNEventManager.dispatcher.dispatchEvent(new MGNEvent(MGNEvent.ROOM_JOINED,{}));
         }
         else if(data.type == "createRoomSuccess")
         {
            this.m_isHost = true;
            this.handleJoin(data);
            MGNEventManager.dispatcher.dispatchEvent(new MGNEvent(MGNEvent.ROOM_CREATED,{}));
         }
         else if(data.type == "startMatch")
         {
            this.m_currentRoomCode = data.room_code;
            this.m_gameSocketUrl = data.url;
            this.initMatch(data);
         }
         else if(data.type == "setRoomDataSuccess")
         {
            MGNEventManager.dispatcher.dispatchEvent(new MGNEvent(MGNEvent.ROOM_DATA,{}));
         }
         else if(data.type == "lockRoomSuccess")
         {
            this.m_roomLocked = true;
            MGNEventManager.dispatcher.dispatchEvent(new MGNEvent(MGNEvent.LOCK_ROOM,{}));
         }
         else if(data.type == "unlockRoomSuccess")
         {
            this.m_roomLocked = false;
            this.m_matchStarted = false;
            MGNEventManager.dispatcher.dispatchEvent(new MGNEvent(MGNEvent.UNLOCK_ROOM,{}));
         }
         else if(data.type == "leaveRoomSuccess")
         {
            this.m_roomData = null;
            this.m_currentRoomCode = null;
            this.m_currentRoomKey = "";
            this.m_currentRoomName = "";
            this.m_players = new Vector.<PlayerConnectionInfo>();
            if(Boolean(this.m_p2pSocket))
            {
               this.m_p2pSocket.close();
            }
            MGNEventManager.dispatcher.dispatchEvent(new MGNEvent(MGNEvent.LEAVE_ROOM,{}));
         }
         else if(data.type == "neighborLeave")
         {
            this.participantDisconnected(data.id);
         }
         else if(data.type == "broadcast" || data.type == "directMessage")
         {
            this.receiveMessage(data);
         }
         else if(data.type == "setReadySuccess")
         {
            trace("Received match ready success");
            MGNEventManager.dispatcher.dispatchEvent(new MGNEvent(MGNEvent.MATCH_READY_STATUS,{}));
         }
         else if(data.type == "finishMatch")
         {
            trace("Received match finish signal");
            MGNEventManager.dispatcher.dispatchEvent(new MGNEvent(MGNEvent.MATCH_FINISHED,{}));
            this.m_matchStarted = false;
            this.disconnectGameServer();
         }
         else if(data.type == "pingSuccess")
         {
            if(!this.m_pingRoundTripTime)
            {
               this.m_pingRoundTripTime = new Date().getTime() - this.m_lastSentPing;
               this.ping();
            }
            else
            {
               this.m_pingRoundTripTime = new Date().getTime() - this.m_lastSentPing;
            }
         }
         else if(data.type == "connectError")
         {
            trace("Error, problem logging in");
            MGNEventManager.dispatcher.dispatchEvent(new MGNEvent(MGNEvent.NOTIFY,{"message":"Could not communicate with server."}));
            MGNEventManager.dispatcher.dispatchEvent(new MGNEvent(MGNEvent.ERROR_OFFLINE,{}));
            this.disconnect();
         }
         else if(data.type == "loginError")
         {
            trace("Error, problem logging in");
            this.m_timeoutTimer.stop();
            this.disconnect();
            MGNEventManager.dispatcher.dispatchEvent(new MGNEvent(MGNEvent.ERROR_LOGIN,{"message":data.message || null}));
         }
         else if(data.type == "listRoomsError")
         {
            trace("Error, could not retrieve rooms list");
         }
         else if(data.type == "getRoomUsersError")
         {
            trace("Error, could not retrieve room user list");
         }
         else if(data.type == "requestToJoinRoomError")
         {
            trace("Error, there was a problem trying to join the room.");
            MGNEventManager.dispatcher.dispatchEvent(new MGNEvent(MGNEvent.ERROR_REQUEST_TO_JOIN_ROOM,{"message":data.message || null}));
         }
         else if(data.type == "joinRoomError")
         {
            trace("Error, there was a problem trying to join the room.");
            MGNEventManager.dispatcher.dispatchEvent(new MGNEvent(MGNEvent.ERROR_CREATE_ROOM,{}));
         }
         else if(data.type == "createRoomError")
         {
            trace("Error, there was a problem trying to create a room.");
            MGNEventManager.dispatcher.dispatchEvent(new MGNEvent(MGNEvent.ERROR_JOIN_ROOM,{}));
         }
         else if(data.type == "lockRoomError")
         {
            trace("Error, there was a problem trying to lock the room.");
            MGNEventManager.dispatcher.dispatchEvent(new MGNEvent(MGNEvent.ERROR_LOCK_ROOM,{}));
         }
         else if(data.type == "unlockRoomError")
         {
            trace("Error, there was a problem trying to unlock the room.");
            MGNEventManager.dispatcher.dispatchEvent(new MGNEvent(MGNEvent.ERROR_UNLOCK_ROOM,{}));
         }
         else if(data.type == "leaveRoomError")
         {
            trace("Error, there was a problem trying to leave the room.");
            MGNEventManager.dispatcher.dispatchEvent(new MGNEvent(MGNEvent.ERROR_LEAVE_ROOM,{}));
         }
         else if(data.type == "setReadyError")
         {
            trace("Error, there was a problem trying to set ready status on the room.");
            MGNEventManager.dispatcher.dispatchEvent(new MGNEvent(MGNEvent.ERROR_MATCH_READY_STATUS,{}));
         }
         else if(data.type == "setRoomDataError")
         {
            trace("Error, there was a problem trying to update the room data.");
            MGNEventManager.dispatcher.dispatchEvent(new MGNEvent(MGNEvent.ERROR_ROOM_DATA,{}));
         }
         else if(data.type == "startMatchError")
         {
            trace("Error, there was a problem starting the match");
         }
         else if(data.type == "finishMatchError")
         {
            trace("Error, there was a problem ending the match");
         }
         else if(data.type == "pingError")
         {
            MGNEventManager.dispatcher.dispatchEvent(new MGNEvent(MGNEvent.ERROR_PING,{}));
         }
      }
      
      public function sendMatchReadySignal(data:Object) : void
      {
         this.socketHelper(this.m_lobbySocket,{
            "type":"setReady",
            "player_data":{
               "data":data,
               "protocol":this.m_protocol
            }
         },"object");
      }
      
      public function sendMatchFinishedSignal(data:Object) : void
      {
         this.socketHelper(this.m_lobbySocket,{
            "type":"setFinish",
            "player_data":{
               "data":data,
               "protocol":this.m_protocol
            }
         },"object");
      }
      
      public function sendMatchEndSignal() : void
      {
         this.broadcast({
            "type":"broadcast",
            "mode":MODE_MATCH_END,
            "sender":this.m_lobbySocketID
         });
      }
      
      public function sendMatchSettings(data:Object) : void
      {
         this.socketHelper(this.m_lobbySocket,{
            "type":"setRoomData",
            "room_data":data
         },"object");
      }
      
      public function createRoom(roomName:String, roomPassword:String, room_capacity:int, roomData:Object) : void
      {
         this.createJoinRoom(roomName,roomPassword,room_capacity,roomData);
      }
      
      public function requestToJoinRoom(roomKey:String, roomPassword:String) : void
      {
         if(Boolean(this.m_lobbySocket) && this.m_lobbySocket.connected)
         {
            this.socketHelper(this.m_lobbySocket,{
               "type":"requestToJoinRoom",
               "room_key":roomKey,
               "room_password":roomPassword
            },"object");
         }
      }
      
      public function acceptRoomJoinRequest(playerConnectionInfo:PlayerConnectionInfo) : void
      {
         if(Boolean(this.m_lobbySocket) && this.m_lobbySocket.connected)
         {
            if(this.m_players.length < this.m_maxPlayers)
            {
               this.m_players.push(playerConnectionInfo);
               this.socketHelper(this.m_lobbySocket,{
                  "type":"directMessage",
                  "target":playerConnectionInfo.socket_id,
                  "data":{
                     "type":"requestToJoinRoomSuccess",
                     "message":"Request accepted by host.",
                     "room_key":this.m_currentRoomKey,
                     "room_code":this.m_currentRoomCode,
                     "player_index":this.m_players.length - 1,
                     "sid":this.m_lobbySocketID,
                     "protocol":this.m_protocol
                  }
               },"object");
            }
            else
            {
               this.socketHelper(this.m_lobbySocket,{
                  "type":"directMessage",
                  "target":playerConnectionInfo.socket_id,
                  "data":{
                     "type":"requestToJoinRoomError",
                     "message":"Room is full."
                  }
               },"object");
            }
         }
      }
      
      public function declineRoomJoinRequest(playerConnectionInfo:PlayerConnectionInfo) : void
      {
         if(Boolean(this.m_lobbySocket) && this.m_lobbySocket.connected)
         {
            this.socketHelper(this.m_lobbySocket,{
               "type":"directMessage",
               "target":playerConnectionInfo.socket_id,
               "data":{
                  "type":"requestToJoinRoomError",
                  "message":"Request denied by room host."
               }
            },"object");
         }
      }
      
      public function joinRoom(roomKey:String, roomCode:String) : void
      {
         if(Boolean(this.m_lobbySocket) && this.m_lobbySocket.connected)
         {
            this.socketHelper(this.m_lobbySocket,{
               "type":"joinRoom",
               "room_key":roomKey,
               "room_code":roomCode
            },"object");
         }
      }
      
      public function createJoinRoom(roomName:String, roomPassword:String, roomCapacity:int, roomData:Object) : void
      {
         if(Boolean(this.m_lobbySocket) && this.m_lobbySocket.connected)
         {
            this.socketHelper(this.m_lobbySocket,{
               "type":"createRoom",
               "room_name":roomName,
               "room_password":roomPassword,
               "room_capacity":roomCapacity,
               "room_data":roomData
            },"object");
         }
      }
      
      public function refreshRoomList(friendsOnly:Boolean = false) : void
      {
         if(this.m_lobbySocket.connected)
         {
            this.socketHelper(this.m_lobbySocket,{
               "type":"listRooms",
               "friendsOnly":friendsOnly
            },"object");
         }
      }
      
      private function getRoomList(rooms:Array) : void
      {
         this.m_roomList.splice(0,this.m_roomList.length);
         trace("Found: " + rooms.length + " other rooms");
         for(var i:int = 0; i < rooms.length; i++)
         {
            this.m_roomList.push(rooms[i]);
         }
         MGNEventManager.dispatcher.dispatchEvent(new MGNEvent(MGNEvent.ROOM_LIST,{
            "rooms":this.m_roomList,
            "message":"Room listing refresh complete."
         }));
      }
      
      public function lockRoom() : void
      {
         this.socketHelper(this.m_lobbySocket,{"type":"lockRoom"},"object");
      }
      
      public function unlockRoom() : void
      {
         this.socketHelper(this.m_lobbySocket,{"type":"unlockRoom"},"object");
      }
      
      public function leaveRoom() : void
      {
         this.socketHelper(this.m_lobbySocket,{"type":"leaveRoom"},"object");
      }
      
      public function sendMyDataFrame(frame:int, data:Object) : void
      {
         var i:int = 0;
         var obj:Object = null;
         var mostRecentFrames:Vector.<DataFrameGroup> = null;
         var dataFrameGroup:DataFrameGroup = null;
         if(this.m_active)
         {
            obj = new Object();
            obj.playerID = this.m_playerID;
            obj.mode = MODE_DATAFRAME_RECEIVED;
            obj.dataList = [];
            obj.type = "broadcast";
            this.m_playerSyncStream.updateDataFrame(frame,this.m_playerID - 1,data);
            mostRecentFrames = this.m_playerSyncStream.getSurroundingDataFrames(3,4);
            for(i = 0; i < mostRecentFrames.length; i++)
            {
               dataFrameGroup = mostRecentFrames[i];
               if(!dataFrameGroup.getDataFrameFor(this.m_playerID - 1).isReady())
               {
                  break;
               }
               obj.dataList.push({
                  "masterFrame":dataFrameGroup.Frame,
                  "data":dataFrameGroup.getDataFrameFor(this.m_playerID - 1).getData()
               });
            }
            this.updateControls();
            this.broadcast(this.writeBinaryPacket(PACKET_CONTROLS,obj));
         }
      }
      
      public function checkResend() : void
      {
         --this.m_resendTimer;
         if(this.m_resendTimer < 0)
         {
            this.tryToRetrieve(this.m_playerSyncStream.Pointer + 1);
            this.m_resendTimer = this.RESEND_TIME;
         }
      }
      
      private function tryToRetrieve(frame:int) : void
      {
         var i:int = 0;
         var targetDataFrameGroup:DataFrameGroup = this.m_playerSyncStream.getDataFrameGroup(frame);
         if(Boolean(targetDataFrameGroup) && !targetDataFrameGroup.Complete)
         {
            trace("Too long of a delay, attempting to retrieve frame " + frame + " data from another player.");
            for(i = 0; i < targetDataFrameGroup.Size; i++)
            {
               if(i + 1 != this.m_playerID && !targetDataFrameGroup.getDataFrameFor(i).isReady())
               {
                  this.resendRequest({
                     "frame":frame,
                     "playerID":i + 1
                  });
               }
            }
         }
      }
      
      public function resendRequest(data:Object) : void
      {
         var obj:Object = new Object();
         obj.playerID = data.playerID;
         obj.mode = MODE_RESEND_DATAFRAME;
         obj.masterFrame = data.frame;
         obj.type = "broadcast";
         this.broadcast(obj);
      }
      
      public function broadcast(data:Object) : void
      {
         if(this.m_protocol !== ProtocolSetting.CLIENT_SERVER_TCP && Boolean(this.m_p2pSocket))
         {
            this.m_p2pSocket.sendToAll(data);
         }
         else if(Boolean(this.m_protocol == ProtocolSetting.CLIENT_SERVER_TCP) && Boolean(this.m_gameSocket) && this.m_gameSocket.connected)
         {
            if(data is ByteArray)
            {
               this.socketHelper(this.m_gameSocket,data,"binary");
            }
            else
            {
               this.socketHelper(this.m_gameSocket,{
                  "type":"broadcast",
                  "data":data
               },"object");
            }
         }
      }
      
      private function handleJoin(data:Object) : void
      {
         var selfObj:Object = null;
         if(this.m_lobbySocket.connected)
         {
            this.m_lobbySocketID = data.sid;
            this.m_currentRoomKey = data.room_key;
            this.m_currentRoomCode = data.room_code;
            this.m_currentRoomName = data.room_name;
            this.m_players.push(new PlayerConnectionInfo({
               "username":this.m_userName,
               "user_key":this.m_userKey,
               "socket_id":this.m_lobbySocketID,
               "host":this.m_isHost,
               "is_dev":this.m_isDev
            }));
            trace("Sucessfully joined room: " + data.room_name + " w/ player index " + this.m_playerID);
            if(Boolean(this.m_p2pSocket))
            {
               this.m_p2pSocket.removeEventListener(MGNEvent.P2P_CONNECT,this.onP2PConnect);
               this.m_p2pSocket.removeEventListener(MGNEvent.P2P_ERROR,this.onP2PError);
               this.m_p2pSocket.removeEventListener(MGNEvent.P2P_CLOSE,this.onP2PClose);
               this.m_p2pSocket.removeEventListener(MGNEvent.P2P_MESSAGE,this.onP2PMessage);
               this.m_p2pSocket.close();
               this.m_p2pSocket = null;
            }
            if(this.m_protocol !== ProtocolSetting.CLIENT_SERVER_TCP)
            {
               this.m_p2pSocket = this.m_protocol === ProtocolSetting.P2P_UDP ? new P2PDatagramSocket(this.m_lobbySocket,this.m_ipAddress) : (this.m_protocol === ProtocolSetting.P2P_RTMFP ? new P2PRTMFP(this.m_lobbySocket,this.m_isHost,this.m_ipAddress) : new P2PServerSocket(this.m_lobbySocket,this.m_ipAddress));
               this.m_p2pSocket.addEventListener(MGNEvent.P2P_CONNECT,this.onP2PConnect);
               this.m_p2pSocket.addEventListener(MGNEvent.P2P_ERROR,this.onP2PError);
               this.m_p2pSocket.addEventListener(MGNEvent.P2P_CLOSE,this.onP2PClose);
               this.m_p2pSocket.addEventListener(MGNEvent.P2P_MESSAGE,this.onP2PMessage);
               this.m_p2pSocket.connect();
            }
            selfObj = new Object();
            selfObj.mode = MODE_CLIENT_JOINED;
            selfObj.username = this.m_userName;
            selfObj.user_key = this.m_userKey;
            selfObj.sender = this.m_lobbySocketID;
            selfObj.playerID = this.m_playerID;
            selfObj.type = "broadcast";
            selfObj.is_dev = this.m_isDev;
            this.socketHelper(this.m_lobbySocket,{
               "type":"broadcast",
               "data":selfObj
            },"object");
         }
      }
      
      private function receiveControls(obj:Object) : void
      {
         for(var i:int = 0; i < this.m_players.length; i++)
         {
            this.m_controlBits[i].push(obj["player" + (i + 1)].controls);
         }
      }
      
      public function ping() : void
      {
         if(Boolean(this.m_lobbySocket) && this.m_lobbySocket.connected)
         {
            this.m_lastSentPing = new Date().getTime();
            this.socketHelper(this.m_lobbySocket,{
               "type":"ping",
               "ping_average":this.m_pingRoundTripTime
            },"object");
         }
         else
         {
            trace("Cannot ping with disconnected lobby");
         }
      }
      
      private function onPingInterval(e:TimerEvent) : void
      {
         this.ping();
      }
      
      private function writeBinaryPacket(type:int, obj:Object) : ByteArray
      {
         var binaryData:ByteArray = null;
         var i:int = 0;
         if(type === PACKET_CONTROLS)
         {
            binaryData = new ByteArray();
            binaryData.writeShort(PACKET_CONTROLS);
            binaryData.writeShort(this.m_playerID);
            binaryData.writeShort(MODE_DATAFRAME_RECEIVED);
            binaryData.writeShort(obj.dataList.length);
            for(i = 0; i < obj.dataList.length; i++)
            {
               binaryData.writeInt(obj.dataList[i].masterFrame);
               binaryData.writeInt(obj.dataList[i].data.controls);
            }
            return binaryData;
         }
         return new ByteArray();
      }
      
      private function readBinaryPacket(bytes:ByteArray) : Object
      {
         var obj:Object = null;
         var packetCount:int = 0;
         var dataObj:Object = null;
         var byteArrayType:int = bytes.readShort();
         if(byteArrayType === PACKET_CONTROLS)
         {
            obj = {"type":"broadcast"};
            obj.playerID = bytes.readShort();
            obj.mode = bytes.readShort();
            obj.dataList = [];
            packetCount = bytes.readShort();
            while(packetCount > 0)
            {
               dataObj = {};
               dataObj.masterFrame = bytes.readInt();
               dataObj.data = {"controls":bytes.readInt()};
               obj.dataList.push(dataObj);
               packetCount--;
            }
            return obj;
         }
         return {};
      }
      
      private function receiveMessage(msg:Object) : void
      {
         var i:int = 0;
         var selfObj:Object = null;
         var missingDataFrame:DataFrame = null;
         var obj:Object = msg;
         if(obj.mode == MODE_CLIENT_JOINED)
         {
            if(!this.m_isHost)
            {
               this.m_players.push(new PlayerConnectionInfo({
                  "username":obj.username,
                  "user_key":obj.user_key,
                  "socket_id":obj.sender,
                  "is_dev":obj.is_dev
               }));
            }
            this.resetMasterFrame();
            MGNEventManager.dispatcher.dispatchEvent(new MGNEvent(MGNEvent.PLAYER_JOINED,{
               "username":obj.username,
               "is_dev":obj.is_dev
            }));
            selfObj = new Object();
            selfObj.mode = MODE_CLIENT_JOINED_RESPONSE;
            selfObj.username = this.m_userName;
            selfObj.user_key = this.m_userKey;
            selfObj.sender = this.m_lobbySocketID;
            selfObj.playerID = this.m_playerID;
            selfObj.is_dev = this.m_isDev;
            selfObj.type = "directMessage";
            this.socketHelper(this.m_lobbySocket,{
               "type":"directMessage",
               "target":obj.sender,
               "data":selfObj
            },"object");
            if(this.m_isHost && Boolean(this.m_p2pSocket))
            {
               this.socketHelper(this.m_lobbySocket,{
                  "type":"directMessage",
                  "target":obj.sender,
                  "data":this.m_p2pSocket.getAckObj()
               },"object");
            }
         }
         else if(obj.mode == MODE_CLIENT_JOINED_RESPONSE)
         {
            this.m_players.push(new PlayerConnectionInfo({
               "username":obj.username,
               "user_key":obj.user_key,
               "socket_id":obj.sender,
               "is_dev":obj.is_dev
            }));
            this.resetMasterFrame();
            MGNEventManager.dispatcher.dispatchEvent(new MGNEvent(MGNEvent.PLAYER_JOINED,{
               "username":obj.username,
               "is_dev":obj.is_dev
            }));
         }
         else if(obj.mode == MODE_DATAFRAME_RECEIVED && obj.playerID != this.m_playerID)
         {
            for(i = 0; i < obj.dataList.length; i++)
            {
               this.m_playerSyncStream.updateDataFrame(obj.dataList[i].masterFrame,obj.playerID - 1,obj.dataList[i].data);
            }
            this.updateControls();
            this.m_resendTimer = this.RESEND_TIME;
         }
         else if(obj.mode == MODE_RESEND_DATAFRAME)
         {
            trace("Recieved resend request for player " + obj.playerID);
            missingDataFrame = this.m_playerSyncStream.getDataFrameGroup(obj.masterFrame).getDataFrameFor(obj.playerID - 1);
            if(missingDataFrame.isReady())
            {
               this.broadcast({
                  "type":"broadcast",
                  "mode":MODE_DATAFRAME_RECEIVED,
                  "sender":this.m_lobbySocketID,
                  "playerID":obj.playerID,
                  "dataList":[{
                     "masterFrame":obj.masterFrame,
                     "data":missingDataFrame.getData()
                  }]
               });
               trace("Sent a manually requested data packet back to player.");
            }
         }
         else if(obj.mode != MODE_ACK_REQUEST)
         {
            if(obj.mode != MODE_ACK_RESPONSE)
            {
               if(obj.mode == MODE_MATCH_END)
               {
                  MGNEventManager.dispatcher.dispatchEvent(new MGNEvent(MGNEvent.MATCH_END,{}));
               }
               else if(obj.mode == MODE_DOWNGRADE_P2P)
               {
                  this.m_protocol = ProtocolSetting.CLIENT_SERVER_TCP;
                  this.m_downgradedConnection = true;
                  this.connectGameServer(this.m_gameSocketUrl);
                  MGNEventManager.dispatcher.dispatchEvent(new MGNEvent(MGNEvent.NOTIFY,{"message":"P2P Connection failed. Downgrading to client-server communication per host\'s request..."}));
               }
            }
         }
         MGNEventManager.dispatcher.dispatchEvent(new MGNEvent(MGNEvent.DATA,obj));
      }
      
      private function participantDisconnected(id:String) : void
      {
         var i:int = 0;
         for(var participantIndex:int = -1; i < this.m_players.length; )
         {
            if(this.m_players[i].socket_id === id)
            {
               participantIndex = i;
               break;
            }
            i++;
         }
         if(participantIndex >= 0)
         {
            MGNEventManager.dispatcher.dispatchEvent(new MGNEvent(MGNEvent.PLAYER_LEFT,{
               "username":this.m_players[participantIndex].username,
               "host":this.m_players[participantIndex].socket_id === this.m_currentHostID,
               "is_dev":this.m_players[participantIndex].is_dev
            }));
            this.m_players.splice(participantIndex,1);
            this.resetMasterFrame();
         }
      }
      
      private function onP2PConnect(event:MGNEvent) : void
      {
         MGNEventManager.dispatcher.dispatchEvent(new MGNEvent(MGNEvent.NOTIFY,{"message":"Sucessfully connected to P2P Group."}));
      }
      
      private function onP2PError(event:MGNEvent) : void
      {
         MGNEventManager.dispatcher.dispatchEvent(new MGNEvent(MGNEvent.NOTIFY,{"message":event.data.message}));
      }
      
      private function onP2PClose(event:MGNEvent) : void
      {
         MGNEventManager.dispatcher.dispatchEvent(new MGNEvent(MGNEvent.NOTIFY,{"message":"P2P connection was closed."}));
      }
      
      private function onP2PMessage(event:MGNEvent) : void
      {
         if(event.data.data is ByteArray)
         {
            this.receiveMessage(this.readBinaryPacket(event.data.data));
         }
         else
         {
            this.receiveMessage(event.data.data);
         }
      }
      
      private function updateControls() : void
      {
         var groupIndex:int = 0;
         var playerData:Object = null;
         var playerIndex:int = 0;
         var tmpObj:Object = null;
         var tmpID:int = 0;
         var fulfilledFrames:Vector.<DataFrameGroup> = this.m_playerSyncStream.getFilledDataFrameGroups();
         if(fulfilledFrames.length > 0)
         {
            for(groupIndex = 0; groupIndex < fulfilledFrames.length; groupIndex++)
            {
               playerData = new Object();
               for(playerIndex = 0; playerIndex < fulfilledFrames[groupIndex].Size; playerIndex++)
               {
                  tmpObj = fulfilledFrames[groupIndex].getDataFrameFor(playerIndex).getData();
                  tmpID = playerIndex + 1;
                  playerData["player" + tmpID] = new Object();
                  playerData["player" + tmpID].playerID = tmpID;
                  playerData["player" + tmpID].controls = tmpObj.controls;
               }
               this.receiveControls(playerData);
            }
         }
      }
      
      private function initMatch(data:Object) : void
      {
         if(this.m_matchStarted)
         {
            return;
         }
         this.m_roomData = data.room_data;
         this.m_playerData = data.player_data;
         this.m_downgradedConnection = false;
         if(!this.m_isHost)
         {
            this.m_protocol = this.m_playerData[0].protocol;
         }
         if(this.m_protocol !== ProtocolSetting.CLIENT_SERVER_TCP)
         {
            this.m_matchStarted = true;
            MGNEventManager.dispatcher.dispatchEvent(new MGNEvent(MGNEvent.MATCH_START,{
               "room_data":this.m_roomData,
               "player_data":this.m_playerData
            }));
         }
         else if(!this.m_gameSocket)
         {
            this.connectGameServer(this.m_gameSocketUrl);
         }
      }
      
      public function downgradeP2P() : void
      {
         var selfObj:Object = null;
         if(this.m_protocol !== ProtocolSetting.CLIENT_SERVER_TCP)
         {
            this.m_protocol = ProtocolSetting.CLIENT_SERVER_TCP;
            this.m_downgradedConnection = true;
            selfObj = new Object();
            selfObj.mode = MODE_DOWNGRADE_P2P;
            selfObj.sender = this.m_lobbySocketID;
            selfObj.type = "broadcast";
            this.socketHelper(this.m_lobbySocket,{
               "type":"broadcast",
               "data":selfObj
            },"object");
            this.connectGameServer(this.m_gameSocketUrl);
         }
      }
      
      public function PERFORMALL() : void
      {
         if(this.m_active)
         {
            this.checkResend();
         }
      }
   }
}

