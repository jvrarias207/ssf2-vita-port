package com.mcleodgaming.mgn.net
{
   import com.mcleodgaming.mgn.events.MGNEvent;
   import com.mcleodgaming.ssf2.util.Base64;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.events.ServerSocketConnectEvent;
   import flash.net.ServerSocket;
   import flash.net.Socket;
   import flash.utils.ByteArray;
   
   public class P2PServerSocket extends EventDispatcher implements IP2PSocket
   {
      
      public static var hostIP:String = "192.168.1.1";
      
      public static var hostPort:int = 27500;
      
      private var _socket:IWebSocket;
      
      private var _guid:String;
      
      private var _initialized:Boolean;
      
      private var _p2pGroup:Object;
      
      private var _serverSocket:ServerSocket;
      
      private var _clients:Vector.<Socket>;
      
      private var _ip:String;
      
      private var _port:int;
      
      public function P2PServerSocket(socket:IWebSocket, ipAddress:String)
      {
         super();
         this._socket = socket;
         this._ip = ipAddress;
         this._port = 0;
         this._clients = new Vector.<Socket>();
         this._guid = Base64.encode(Math.random() + "");
         this._initialized = false;
         this._p2pGroup = {};
      }
      
      public function get connected() : Boolean
      {
         var key:String = null;
         var peer:Object = null;
         var foundOne:Boolean = false;
         var success:Boolean = true;
         for(key in this._p2pGroup)
         {
            peer = this._p2pGroup[key];
            if(!peer.ackin || !peer.ackout)
            {
               success = false;
            }
            foundOne = true;
         }
         return foundOne;
      }
      
      public function getAckObj() : Object
      {
         return {
            "type":"p2pinit",
            "guid":this._guid,
            "ip":this._ip,
            "port":this._port,
            "ackin":false,
            "ackout":false
         };
      }
      
      private function onSocketMessage(e:MGNEvent) : void
      {
         var socket:Socket = null;
         var data:* = e.data.data;
         var bytes:ByteArray = null;
         if(!(data is ByteArray))
         {
            if(data.type == "directMessage" || data.type == "broadcast")
            {
               data = data.data;
            }
            if(data.type === "p2pinit")
            {
               this._socket.sendString(JSON.stringify({
                  "type":"broadcast",
                  "data":{
                     "type":"p2pjoin",
                     "guid":this._guid,
                     "ip":this._ip,
                     "port":this._port
                  }
               }));
            }
            else if(data.type === "p2pjoin")
            {
               socket = new Socket();
               this._clients.push(socket);
               this._p2pGroup[data.guid] = {
                  "ip":data.ip,
                  "port":data.port,
                  "ackin":false,
                  "ackout":false,
                  "client":socket
               };
               socket.addEventListener(Event.CLOSE,this.onClientClose);
               socket.addEventListener(Event.CONNECT,this.onClientConnect);
               socket.addEventListener(ProgressEvent.SOCKET_DATA,this.onTcpMessage);
               socket.addEventListener(IOErrorEvent.IO_ERROR,this.onClientError);
               socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onClientError);
               socket.connect(data.ip,data.port);
            }
         }
      }
      
      private function onClientClose(event:Event) : void
      {
         trace("Client disconnected");
      }
      
      private function onClientConnect(event:Event) : void
      {
         var socket:Socket = event.currentTarget as Socket;
         var bytes:ByteArray = new ByteArray();
         bytes.writeShort(MGNClient.PACKET_JSON);
         bytes.writeUTF(JSON.stringify({
            "type":"p2pholepunch",
            "guid":this._guid
         }));
         socket.writeBytes(bytes);
         socket.flush();
         trace("Sending p2pholepunch");
      }
      
      private function onClientError(event:Event) : void
      {
         trace("Client error occured");
         this.close();
      }
      
      private function onTcpMessage(event:ProgressEvent) : void
      {
         var text:String = null;
         var data:Object = null;
         var bytes:ByteArray = null;
         var buffer:ByteArray = new ByteArray();
         var socket:Socket = Socket(event.currentTarget);
         socket.readBytes(buffer,0,socket.bytesAvailable);
         var id:int = buffer.readShort();
         if(id == MGNClient.PACKET_JSON)
         {
            text = buffer.readUTF();
            data = JSON.parse(text);
            if(Boolean(this._p2pGroup[data.guid]))
            {
               if(data.type === "ackin")
               {
                  if(!this._p2pGroup[data.guid].ackin)
                  {
                     this._p2pGroup[data.guid].ackin = true;
                     trace("Successfully inbound acked peer: " + socket.remoteAddress + ":" + socket.remotePort);
                  }
                  bytes = new ByteArray();
                  bytes.writeShort(MGNClient.PACKET_JSON);
                  bytes.writeUTF(JSON.stringify({
                     "type":"ackout",
                     "guid":this._guid,
                     "ip":data.ip,
                     "port":data.port
                  }));
                  socket.writeBytes(bytes);
                  socket.flush();
               }
               else if(data.type === "ackout")
               {
                  if(!this._p2pGroup[data.guid].ackout)
                  {
                     this._p2pGroup[data.guid].ackout = true;
                     trace("Successfully outbound acked peer: " + socket.remoteAddress + ":" + socket.remotePort);
                  }
               }
               else if(data.type === "p2pholepunch")
               {
                  trace("got hole punch");
               }
               else
               {
                  dispatchEvent(new MGNEvent(MGNEvent.P2P_MESSAGE,{"data":data}));
               }
            }
            else
            {
               trace("Error, received UDP message from a non-registered peer" + socket.remoteAddress + ":" + socket.remotePort + "> " + text);
            }
         }
         else
         {
            buffer.position = 0;
            dispatchEvent(new MGNEvent(MGNEvent.P2P_MESSAGE,{"data":buffer}));
         }
      }
      
      private function onClientConnected(event:ServerSocketConnectEvent) : void
      {
         trace("client connected");
         this._clients.push(event.socket);
         event.socket.addEventListener(Event.CLOSE,this.onClientClose);
         event.socket.addEventListener(ProgressEvent.SOCKET_DATA,this.onTcpMessage);
         event.socket.addEventListener(IOErrorEvent.IO_ERROR,this.onClientError);
         event.socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onClientError);
         var bytes:ByteArray = new ByteArray();
         bytes.writeShort(MGNClient.PACKET_JSON);
         bytes.writeUTF(JSON.stringify({
            "type":"p2pholepunch",
            "guid":this._guid
         }));
         event.socket.writeBytes(bytes);
         event.socket.flush();
         trace("Sending p2pholepunch in return");
      }
      
      public function connect() : void
      {
         if(this._initialized)
         {
            throw new Error("Error, cannot initialized P2P more than once!");
         }
         this._initialized = true;
         this._serverSocket = new ServerSocket();
         this._port = ProtocolSetting.tcpPort;
         this._serverSocket.bind(this._port,ProtocolSetting.tcpIP);
         this._socket.addEventListener(MGNEvent.SOCKET_MESSAGE,this.onSocketMessage);
         this._serverSocket.addEventListener(ServerSocketConnectEvent.CONNECT,this.onClientConnected);
         this._serverSocket.listen();
         dispatchEvent(new MGNEvent(MGNEvent.P2P_CONNECT));
      }
      
      public function sendToAll(data:Object) : void
      {
         var i:int = 0;
         var bytes:ByteArray = null;
         if(data is ByteArray)
         {
            bytes = data as ByteArray;
         }
         else
         {
            bytes = new ByteArray();
            bytes.writeShort(MGNClient.PACKET_JSON);
            data.guid = this._guid;
            bytes.writeUTF(JSON.stringify(data));
         }
         if(Boolean(this._clients))
         {
            for(i = 0; i < this._clients.length; i++)
            {
               if(this._clients[i].connected)
               {
                  this._clients[i].writeBytes(bytes);
                  this._clients[i].flush();
               }
               bytes.position = 0;
            }
         }
      }
      
      public function close() : void
      {
         var j:int = 0;
         if(this._initialized)
         {
            this._socket.removeEventListener(MGNEvent.SOCKET_MESSAGE,this.onSocketMessage);
            this._serverSocket.removeEventListener(ProgressEvent.SOCKET_DATA,this.onTcpMessage);
            this._serverSocket.close();
            for(j = 0; j < this._clients.length; j++)
            {
               this._clients[j].removeEventListener(Event.CLOSE,this.onClientClose);
               this._clients[j].removeEventListener(ProgressEvent.SOCKET_DATA,this.onTcpMessage);
               this._clients[j].removeEventListener(IOErrorEvent.IO_ERROR,this.onClientError);
               this._clients[j].removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onClientError);
               if(this._clients[j].connected)
               {
                  this._clients[j].close();
               }
            }
            this._clients = null;
            this._p2pGroup = null;
            this._initialized = false;
            this._serverSocket = null;
            dispatchEvent(new MGNEvent(MGNEvent.P2P_CLOSE));
         }
      }
   }
}

