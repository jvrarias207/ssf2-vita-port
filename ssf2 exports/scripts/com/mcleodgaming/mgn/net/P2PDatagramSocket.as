package com.mcleodgaming.mgn.net
{
   import com.mcleodgaming.mgn.events.MGNEvent;
   import com.mcleodgaming.ssf2.util.Base64;
   import flash.events.DatagramSocketDataEvent;
   import flash.events.EventDispatcher;
   import flash.net.DatagramSocket;
   import flash.utils.ByteArray;
   
   public class P2PDatagramSocket extends EventDispatcher implements IP2PSocket
   {
      
      public static var hostIP:String = "192.168.1.1";
      
      public static var hostPort:int = 27300;
      
      private var _socket:IWebSocket;
      
      private var _guid:String;
      
      private var _initialized:Boolean;
      
      private var _p2pGroup:Object;
      
      private var _datagramSocket:DatagramSocket;
      
      private var _ip:String;
      
      private var _port:int;
      
      public function P2PDatagramSocket(socket:IWebSocket, ipAddress:String)
      {
         super();
         this._socket = socket;
         this._ip = ipAddress;
         this._port = 0;
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
               this._p2pGroup[data.guid] = {
                  "ip":data.ip,
                  "port":data.port,
                  "ackin":false,
                  "ackout":false
               };
               this._socket.sendString(JSON.stringify({
                  "type":"broadcast",
                  "data":{
                     "type":"p2presponse",
                     "guid":this._guid,
                     "ip":this._ip,
                     "port":this._port
                  }
               }));
               bytes = new ByteArray();
               bytes.writeShort(MGNClient.PACKET_JSON);
               bytes.writeUTF(JSON.stringify({
                  "type":"p2pholepunch",
                  "guid":this._guid
               }));
               this._datagramSocket.send(bytes,0,0,data.ip,data.port);
            }
            else if(data.type === "p2presponse")
            {
               this._p2pGroup[data.guid] = {
                  "ip":data.ip,
                  "port":data.port,
                  "ackin":false,
                  "ackout":false
               };
               bytes = new ByteArray();
               bytes.writeShort(MGNClient.PACKET_JSON);
               bytes.writeUTF(JSON.stringify({
                  "type":"p2pholepunch",
                  "guid":this._guid
               }));
               this._datagramSocket.send(bytes,0,0,data.ip,data.port);
            }
         }
      }
      
      private function onUdpMessage(event:DatagramSocketDataEvent) : void
      {
         var text:String = null;
         var data:Object = null;
         var bytes:ByteArray = null;
         var id:int = int(event.data.readShort());
         if(id == MGNClient.PACKET_JSON)
         {
            text = event.data.readUTF();
            data = JSON.parse(text);
            if(Boolean(this._p2pGroup[data.guid]))
            {
               if(data.type === "ackin")
               {
                  if(!this._p2pGroup[data.guid].ackin)
                  {
                     this._p2pGroup[data.guid].ackin = true;
                     trace("Successfully inbound acked peer: " + event.srcAddress + ":" + event.srcPort);
                  }
                  bytes = new ByteArray();
                  bytes.writeShort(MGNClient.PACKET_JSON);
                  bytes.writeUTF(JSON.stringify({
                     "type":"ackout",
                     "guid":this._guid,
                     "ip":data.ip,
                     "port":data.port
                  }));
                  this._datagramSocket.send(bytes,0,0,data.ip,data.port);
               }
               else if(data.type === "ackout")
               {
                  if(!this._p2pGroup[data.guid].ackout)
                  {
                     this._p2pGroup[data.guid].ackout = true;
                     trace("Successfully outbound acked peer: " + event.srcAddress + ":" + event.srcPort);
                  }
               }
               else
               {
                  dispatchEvent(new MGNEvent(MGNEvent.P2P_MESSAGE,{"data":data}));
               }
            }
            else
            {
               trace("Error, received UDP message from a non-registered peer" + event.srcAddress + ":" + event.srcPort + "> " + text);
            }
         }
         else
         {
            event.data.position = 0;
            dispatchEvent(new MGNEvent(MGNEvent.P2P_MESSAGE,{"data":event.data}));
         }
      }
      
      public function connect() : void
      {
         if(this._initialized)
         {
            throw new Error("Error, cannot initialized P2P more than once!");
         }
         this._initialized = true;
         this._datagramSocket = new DatagramSocket();
         this._port = ProtocolSetting.udpPort;
         this._datagramSocket.bind(this._port,ProtocolSetting.udpIP);
         this._socket.addEventListener(MGNEvent.SOCKET_MESSAGE,this.onSocketMessage);
         this._datagramSocket.addEventListener(DatagramSocketDataEvent.DATA,this.onUdpMessage);
         this._datagramSocket.receive();
         dispatchEvent(new MGNEvent(MGNEvent.P2P_CONNECT));
      }
      
      public function sendToAll(data:Object) : void
      {
         var key:String = null;
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
         for(key in this._p2pGroup)
         {
            this._datagramSocket.send(bytes,0,0,this._p2pGroup[key].ip,this._p2pGroup[key].port);
         }
      }
      
      public function close() : void
      {
         if(this._initialized)
         {
            this._socket.removeEventListener(MGNEvent.SOCKET_MESSAGE,this.onSocketMessage);
            this._datagramSocket.removeEventListener(DatagramSocketDataEvent.DATA,this.onUdpMessage);
            this._datagramSocket.close();
            this._p2pGroup = null;
            this._initialized = false;
            this._datagramSocket = null;
            dispatchEvent(new MGNEvent(MGNEvent.P2P_CLOSE));
         }
      }
   }
}

