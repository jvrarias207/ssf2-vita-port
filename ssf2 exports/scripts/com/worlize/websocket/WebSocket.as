package com.worlize.websocket
{
   import com.adobe.net.URI;
   import com.adobe.net.URIEncodingBitmap;
   import com.adobe.utils.StringUtil;
   import com.hurlant.crypto.hash.SHA1;
   import com.hurlant.util.Base64;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.events.TimerEvent;
   import flash.net.SecureSocket;
   import flash.net.Socket;
   import flash.utils.ByteArray;
   import flash.utils.Timer;
   
   [Event(name="connectionFail",type="com.worlize.websocket.WebSocketErrorEvent")]
   [Event(name="ioError",type="flash.events.IOErrorEvent")]
   [Event(name="abnormalClose",type="com.worlize.websocket.WebSocketErrorEvent")]
   [Event(name="message",type="com.worlize.websocket.WebSocketEvent")]
   [Event(name="frame",type="com.worlize.websocket.WebSocketEvent")]
   [Event(name="ping",type="com.worlize.websocket.WebSocketEvent")]
   [Event(name="pong",type="com.worlize.websocket.WebSocketEvent")]
   [Event(name="open",type="com.worlize.websocket.WebSocketEvent")]
   [Event(name="closed",type="com.worlize.websocket.WebSocketEvent")]
   public class WebSocket extends EventDispatcher
   {
      
      private static const MODE_UTF8:int = 0;
      
      private static const MODE_BINARY:int = 0;
      
      private static const MAX_HANDSHAKE_BYTES:int = 10240;
      
      public static function logger(text:String):void
      {
         trace(text);
      }
      private var _bufferedAmount:int = 0;
      
      private var _readyState:int;
      
      private var _uri:URI;
      
      private var _protocols:Array;
      
      private var _serverProtocol:String;
      
      private var _host:String;
      
      private var _port:uint;
      
      private var _resource:String;
      
      private var _secure:Boolean;
      
      private var _origin:String;
      
      private var _useNullMask:Boolean = false;
      
      private var socket:Socket;
      
      private var timeout:uint;
      
      private var fatalError:Boolean = false;
      
      private var nonce:ByteArray;
      
      private var base64nonce:String;
      
      private var serverHandshakeResponse:String;
      
      private var serverExtensions:Array;
      
      private var serverSupportsDeflate:Boolean;
      
      private var currentFrame:WebSocketFrame;
      
      private var frameQueue:Vector.<WebSocketFrame>;
      
      private var fragmentationOpcode:int = 0;
      
      private var fragmentationSize:uint = 0;
      
      private var waitingForServerClose:Boolean = false;
      
      private var closeTimeout:int = 5000;
      
      private var closeTimer:Timer;
      
      private var handshakeBytesReceived:int;
      
      private var handshakeTimer:Timer;
      
      private var handshakeTimeout:int = 10000;
      
      private var URIpathExcludedBitmap:URIEncodingBitmap = new URIEncodingBitmap(URI.URIpathEscape);
      
      public var config:WebSocketConfig = new WebSocketConfig();
      
      public var debug:Boolean = false;
      
      public function WebSocket(uri:String, origin:String, protocols:* = null, timeout:uint = 10000)
      {
         var i:int = 0;
         super(null);
         _uri = new URI(uri);
         if(protocols is String)
         {
            _protocols = [protocols];
         }
         else
         {
            _protocols = protocols;
         }
         if(_protocols)
         {
            for(i = 0; i < _protocols.length; )
            {
               _protocols[i] = StringUtil.trim(_protocols[i]);
               i++;
            }
         }
         _origin = origin;
         this.timeout = timeout;
         this.handshakeTimeout = timeout;
         init();
      }
      
      private function init() : void
      {
         parseUrl();
         validateProtocol();
         frameQueue = new Vector.<WebSocketFrame>();
         fragmentationOpcode = 0;
         fragmentationSize = 0;
         currentFrame = new WebSocketFrame();
         fatalError = false;
         closeTimer = new Timer(closeTimeout,1);
         closeTimer.addEventListener("timer",handleCloseTimer);
         handshakeTimer = new Timer(handshakeTimeout,1);
         handshakeTimer.addEventListener("timer",handleHandshakeTimer);
         socket = secure ? new SecureSocket() : new Socket();
         socket.endian = "bigEndian";
         socket.timeout = timeout;
         socket.addEventListener("connect",handleSocketConnect);
         socket.addEventListener("ioError",handleSocketIOError);
         socket.addEventListener("securityError",handleSocketSecurityError);
         socket.addEventListener("close",handleSocketClose);
         socket.addEventListener("socketData",handleSocketData);
         _readyState = 3;
      }
      
      private function validateProtocol() : void
      {
         var separators:Array = null;
         var p:int = 0;
         var protocol:String = null;
         var i:int = 0;
         var charCode:int = 0;
         var char:String = null;
         if(_protocols)
         {
            separators = ["(",")","<",">","@",",",";",":","\\","\"","/","[","]","?","=","{","}"," ",String.fromCharCode(9)];
            loop0:
            for(p = 0; p < _protocols.length; )
            {
               protocol = _protocols[p];
               i = 0;
               while(true)
               {
                  if(i >= protocol.length)
                  {
                     p++;
                     continue loop0;
                  }
                  charCode = protocol.charCodeAt(i);
                  char = protocol.charAt(i);
                  if(charCode < 33 || charCode > 126 || separators.indexOf(char) !== -1)
                  {
                     break;
                  }
                  i++;
               }
               throw new WebSocketError("Illegal character \'" + String.fromCharCode(char) + "\' in subprotocol.");
            }
         }
      }
      
      public function connect() : void
      {
         if(_readyState === 3 || _readyState === 2)
         {
            _readyState = 0;
            generateNonce();
            handshakeBytesReceived = 0;
            socket.connect(_host,_port);
            if(debug)
            {
               logger("Connecting to " + _host + " on port " + _port);
            }
         }
      }
      
      public function addBinaryChainBuildingCertificate(certificate:ByteArray, trusted:Boolean) : void
      {
         if(!secure)
         {
            throw new Error("addBinaryChainBuildingCertificate only available for secure websockets");
         }
         (socket as SecureSocket).addBinaryChainBuildingCertificate(certificate,trusted);
      }
      
      private function parseUrl() : void
      {
         _host = _uri.authority;
         var scheme:String = _uri.scheme.toLocaleLowerCase();
         if(scheme === "wss")
         {
            _secure = true;
            _port = 443;
         }
         else
         {
            if(scheme !== "ws")
            {
               throw new Error("Unsupported scheme: " + scheme);
            }
            _secure = false;
            _port = 80;
         }
         var tempPort:uint = parseInt(_uri.port,10);
         if(!isNaN(tempPort) && tempPort !== 0)
         {
            _port = tempPort;
         }
         var path:String = URI.fastEscapeChars(_uri.path,URIpathExcludedBitmap);
         if(path.length === 0)
         {
            path = "/";
         }
         var query:String = _uri.queryRaw;
         if(query.length > 0)
         {
            query = "?" + query;
         }
         _resource = path + query;
      }
      
      private function generateNonce() : void
      {
         var i:int = 0;
         nonce = new ByteArray();
         for(i = 0; i < 16; )
         {
            nonce.writeByte(Math.round(Math.random() * 255));
            i++;
         }
         nonce.position = 0;
         base64nonce = Base64.encodeByteArray(nonce);
      }
      
      public function get readyState() : int
      {
         return _readyState;
      }
      
      public function get bufferedAmount() : int
      {
         return _bufferedAmount;
      }
      
      public function get uri() : String
      {
         var uri:String = null;
         uri = _secure ? "wss://" : "ws://";
         uri += _host;
         if(_secure && _port !== 443 || !_secure && _port !== 80)
         {
            uri += ":" + _port.toString();
         }
         return uri + _resource;
      }
      
      public function get protocol() : String
      {
         return _serverProtocol;
      }
      
      public function get extensions() : Array
      {
         return [];
      }
      
      public function get host() : String
      {
         return _host;
      }
      
      public function get port() : uint
      {
         return _port;
      }
      
      public function get resource() : String
      {
         return _resource;
      }
      
      public function get secure() : Boolean
      {
         return _secure;
      }
      
      public function get connected() : Boolean
      {
         return readyState === 1;
      }
      
      public function set useNullMask(val:Boolean) : void
      {
         _useNullMask = val;
      }
      
      public function get useNullMask() : Boolean
      {
         return _useNullMask;
      }
      
      private function verifyConnectionForSend() : void
      {
         if(_readyState === 0)
         {
            throw new WebSocketError("Invalid State: Cannot send data before connected.");
         }
      }
      
      public function sendUTF(data:String) : void
      {
         verifyConnectionForSend();
         var frame:WebSocketFrame = new WebSocketFrame();
         frame.opcode = 1;
         frame.binaryPayload = new ByteArray();
         frame.binaryPayload.writeMultiByte(data,"utf-8");
         fragmentAndSend(frame);
      }
      
      public function sendBytes(data:ByteArray) : void
      {
         verifyConnectionForSend();
         var frame:WebSocketFrame = new WebSocketFrame();
         frame.opcode = 2;
         frame.binaryPayload = data;
         fragmentAndSend(frame);
      }
      
      public function ping(payload:ByteArray = null) : void
      {
         verifyConnectionForSend();
         var frame:WebSocketFrame = new WebSocketFrame();
         frame.fin = true;
         frame.opcode = 9;
         if(payload)
         {
            frame.binaryPayload = payload;
         }
         sendFrame(frame);
      }
      
      private function pong(binaryPayload:ByteArray = null) : void
      {
         verifyConnectionForSend();
         var frame:WebSocketFrame = new WebSocketFrame();
         frame.fin = true;
         frame.opcode = 10;
         frame.binaryPayload = binaryPayload;
         sendFrame(frame);
      }
      
      private function fragmentAndSend(frame:WebSocketFrame) : void
      {
         var length:int = 0;
         var numFragments:int = 0;
         var i:int = 0;
         var currentFrame:WebSocketFrame = null;
         var currentLength:int = 0;
         if(frame.opcode > 7)
         {
            throw new WebSocketError("You cannot fragment control frames.");
         }
         var threshold:uint = config.fragmentationThreshold;
         if(config.fragmentOutgoingMessages && frame.binaryPayload && frame.binaryPayload.length > threshold)
         {
            frame.binaryPayload.position = 0;
            length = int(frame.binaryPayload.length);
            numFragments = Math.ceil(length / threshold);
            for(i = 1; i <= numFragments; )
            {
               currentFrame = new WebSocketFrame();
               currentFrame.opcode = i === 1 ? frame.opcode : 0;
               currentFrame.fin = i === numFragments;
               currentLength = int(i === numFragments ? length - threshold * (i - 1) : threshold);
               frame.binaryPayload.position = threshold * (i - 1);
               currentFrame.binaryPayload = new ByteArray();
               frame.binaryPayload.readBytes(currentFrame.binaryPayload,0,currentLength);
               sendFrame(currentFrame);
               i++;
            }
         }
         else
         {
            frame.fin = true;
            sendFrame(frame);
         }
      }
      
      private function sendFrame(frame:WebSocketFrame, force:Boolean = false) : void
      {
         frame.mask = true;
         frame.useNullMask = _useNullMask;
         var buffer:ByteArray = new ByteArray();
         frame.send(buffer);
         sendData(buffer);
      }
      
      private function sendData(data:ByteArray, fullFlush:Boolean = false) : void
      {
         if(!connected)
         {
            return;
         }
         data.position = 0;
         socket.writeBytes(data,0,data.bytesAvailable);
         socket.flush();
         data.clear();
      }
      
      public function close(waitForServer:Boolean = true) : void
      {
         var frame:WebSocketFrame = null;
         var buffer:ByteArray = null;
         if(!socket.connected && _readyState === 0)
         {
            _readyState = 2;
            try
            {
               socket.close();
            }
            catch(e:Error)
            {
            }
         }
         if(socket.connected)
         {
            frame = new WebSocketFrame();
            frame.rsv1 = frame.rsv2 = frame.rsv3 = frame.mask = false;
            frame.fin = true;
            frame.opcode = 8;
            frame.closeStatus = 1000;
            buffer = new ByteArray();
            frame.mask = true;
            frame.send(buffer);
            sendData(buffer,true);
            if(waitForServer)
            {
               waitingForServerClose = true;
               closeTimer.stop();
               closeTimer.reset();
               closeTimer.start();
            }
            dispatchClosedEvent();
         }
      }
      
      private function handleCloseTimer(event:TimerEvent) : void
      {
         if(waitingForServerClose)
         {
            if(socket.connected)
            {
               socket.close();
            }
         }
      }
      
      private function handleSocketConnect(event:Event) : void
      {
         if(debug)
         {
            logger("Socket Connected");
         }
         sendHandshake();
      }
      
      private function handleSocketClose(event:Event) : void
      {
         if(debug)
         {
            logger("Socket Disconnected");
         }
         dispatchClosedEvent();
      }
      
      private function handleSocketData(event:ProgressEvent = null) : void
      {
         var frameEvent:WebSocketEvent = null;
         if(_readyState === 0)
         {
            readServerHandshake();
            return;
         }
         while(socket.connected && currentFrame.addData(socket,fragmentationOpcode,config) && !fatalError)
         {
            if(currentFrame.protocolError)
            {
               drop(1002,currentFrame.dropReason);
               return;
            }
            if(currentFrame.frameTooLarge)
            {
               drop(1009,currentFrame.dropReason);
               return;
            }
            if(!config.assembleFragments)
            {
               frameEvent = new WebSocketEvent("frame");
               frameEvent.frame = currentFrame;
               dispatchEvent(frameEvent);
            }
            processFrame(currentFrame);
            currentFrame = new WebSocketFrame();
         }
      }
      
      private function inflate(data:ByteArray) : void
      {
         data.position = data.length;
         data.writeUnsignedInt(65535);
         data[0] |= 1;
         data.inflate();
      }
      
      private function processFrame(frame:WebSocketFrame) : void
      {
         var event:WebSocketEvent = null;
         var i:int = 0;
         var currentFrame:WebSocketFrame = null;
         var messageOpcode:int = 0;
         var binaryData:ByteArray = null;
         var totalLength:int = 0;
         var pingEvent:WebSocketEvent = null;
         var pongEvent:WebSocketEvent = null;
         if(frame.rsv1 && !serverSupportsDeflate)
         {
            drop(1002,"Received frame with rsv1 set without permessage-deflate negotiated.");
         }
         if(frame.rsv2 || frame.rsv3)
         {
            drop(1002,"Received frame with reserved bit set without a negotiated extension.");
            return;
         }
         switch(frame.opcode)
         {
            case 0:
               if(config.assembleFragments)
               {
                  if(fragmentationOpcode === 0 && frame.opcode === 0)
                  {
                     drop(1002,"Unexpected continuation frame.");
                     return;
                  }
                  fragmentationSize += frame.length;
                  if(fragmentationSize > config.maxMessageSize)
                  {
                     drop(1009,"Maximum message size exceeded.");
                     return;
                  }
                  frameQueue.push(frame);
                  if(frame.fin)
                  {
                     event = new WebSocketEvent("message");
                     event.message = new WebSocketMessage();
                     messageOpcode = frameQueue[0].opcode;
                     binaryData = new ByteArray();
                     totalLength = 0;
                     for(i = 0; i < frameQueue.length; )
                     {
                        totalLength += frameQueue[i].length;
                        i++;
                     }
                     if(totalLength > config.maxMessageSize)
                     {
                        drop(1009,"Message size of " + totalLength + " bytes exceeds maximum accepted message size of " + config.maxMessageSize + " bytes.");
                        return;
                     }
                     for(i = 0; i < frameQueue.length; )
                     {
                        currentFrame = frameQueue[i];
                        binaryData.writeBytes(currentFrame.binaryPayload,0,currentFrame.binaryPayload.length);
                        currentFrame.binaryPayload.clear();
                        i++;
                     }
                     if(frameQueue[0].rsv1)
                     {
                        inflate(binaryData);
                     }
                     binaryData.position = 0;
                     switch(messageOpcode - 1)
                     {
                        case 0:
                           event.message.type = "utf8";
                           event.message.utf8Data = binaryData.readMultiByte(binaryData.length,"utf-8");
                           break;
                        case 1:
                           event.message.type = "binary";
                           event.message.binaryData = binaryData;
                           break;
                        default:
                           drop(1002,"Unexpected first opcode in fragmentation sequence: 0x" + messageOpcode.toString(16));
                           return;
                     }
                     frameQueue = new Vector.<WebSocketFrame>();
                     fragmentationOpcode = 0;
                     fragmentationSize = 0;
                     dispatchEvent(event);
                  }
               }
               break;
            case 1:
               if(config.assembleFragments)
               {
                  if(frameQueue.length !== 0)
                  {
                     drop(1002,"Illegal TEXT_FRAME received in the middle of a fragmented message.  Expected a continuation or control frame.");
                     return;
                  }
                  if(frame.fin)
                  {
                     event = new WebSocketEvent("message");
                     event.message = new WebSocketMessage();
                     event.message.type = "utf8";
                     if(frame.rsv1)
                     {
                        inflate(frame.binaryPayload);
                     }
                     event.message.utf8Data = frame.binaryPayload.readMultiByte(frame.binaryPayload.length,"utf-8");
                     dispatchEvent(event);
                  }
                  else
                  {
                     frameQueue.push(frame);
                     fragmentationOpcode = frame.opcode;
                  }
               }
               break;
            case 2:
               if(config.assembleFragments)
               {
                  if(frameQueue.length !== 0)
                  {
                     drop(1002,"Illegal BINARY_FRAME received in the middle of a fragmented message.  Expected a continuation or control frame.");
                     return;
                  }
                  if(frame.fin)
                  {
                     event = new WebSocketEvent("message");
                     event.message = new WebSocketMessage();
                     event.message.type = "binary";
                     if(frame.rsv1)
                     {
                        inflate(frame.binaryPayload);
                     }
                     event.message.binaryData = frame.binaryPayload;
                     dispatchEvent(event);
                  }
                  else if(frameQueue.length === 0)
                  {
                     frameQueue.push(frame);
                     fragmentationOpcode = frame.opcode;
                  }
               }
               break;
            case 8:
               if(debug)
               {
                  logger("Received close frame");
               }
               if(waitingForServerClose)
               {
                  if(debug)
                  {
                     logger("Got close confirmation from server.");
                  }
                  closeTimer.stop();
                  waitingForServerClose = false;
                  socket.close();
               }
               else
               {
                  if(debug)
                  {
                     logger("Sending close response to server.");
                  }
                  close(false);
                  socket.close();
               }
               break;
            case 9:
               if(debug)
               {
                  logger("Received Ping");
               }
               pingEvent = new WebSocketEvent("ping",false,true);
               pingEvent.frame = frame;
               if(dispatchEvent(pingEvent))
               {
                  pong(frame.binaryPayload);
               }
               break;
            case 10:
               if(debug)
               {
                  logger("Received Pong");
               }
               pongEvent = new WebSocketEvent("pong");
               pongEvent.frame = frame;
               dispatchEvent(pongEvent);
               break;
            default:
               if(debug)
               {
                  logger("Unrecognized Opcode: 0x" + frame.opcode.toString(16));
               }
               drop(1002,"Unrecognized Opcode: 0x" + frame.opcode.toString(16));
         }
      }
      
      private function handleSocketIOError(event:IOErrorEvent) : void
      {
         if(debug)
         {
            logger("IO Error: " + event);
         }
         dispatchEvent(event);
         dispatchClosedEvent();
      }
      
      private function handleSocketSecurityError(event:SecurityErrorEvent) : void
      {
         if(debug)
         {
            logger("Security Error: " + event);
         }
         dispatchEvent(event.clone());
         dispatchClosedEvent();
      }
      
      private function sendHandshake() : void
      {
         var protosList:String = null;
         serverHandshakeResponse = "";
         var hostValue:String = host;
         if(_secure && _port !== 443 || !_secure && _port !== 80)
         {
            hostValue += ":" + _port.toString();
         }
         var text:String = "";
         text += "GET " + resource + " HTTP/1.1\r\n";
         text += "Host: " + hostValue + "\r\n";
         text += "Upgrade: websocket\r\n";
         text += "Connection: Upgrade\r\n";
         text += "Sec-WebSocket-Key: " + base64nonce + "\r\n";
         if(_origin)
         {
            text += "Origin: " + _origin + "\r\n";
         }
         text += "Sec-WebSocket-Version: 13\r\n";
         if(_protocols)
         {
            protosList = _protocols.join(", ");
            text += "Sec-WebSocket-Protocol: " + protosList + "\r\n";
         }
         text += "Sec-WebSocket-Extensions: permessage-deflate; server_no_context_takeover\r\n";
         text += "\r\n";
         if(debug)
         {
            logger(text);
         }
         socket.writeMultiByte(text,"us-ascii");
         handshakeTimer.stop();
         handshakeTimer.reset();
         handshakeTimer.start();
      }
      
      private function failHandshake(message:String = "Unable to complete websocket handshake.") : void
      {
         if(debug)
         {
            logger(message);
         }
         _readyState = 2;
         if(socket.connected)
         {
            socket.close();
         }
         handshakeTimer.stop();
         handshakeTimer.reset();
         var errorEvent:WebSocketErrorEvent = new WebSocketErrorEvent("connectionFail");
         errorEvent.text = message;
         dispatchEvent(errorEvent);
         var event:WebSocketEvent = new WebSocketEvent("closed");
         dispatchEvent(event);
      }
      
      private function failConnection(message:String) : void
      {
         _readyState = 2;
         if(socket.connected)
         {
            socket.close();
         }
         var errorEvent:WebSocketErrorEvent = new WebSocketErrorEvent("connectionFail");
         errorEvent.text = message;
         dispatchEvent(errorEvent);
         var event:WebSocketEvent = new WebSocketEvent("closed");
         dispatchEvent(event);
      }
      
      private function drop(closeReason:uint = 1002, reasonText:String = null) : void
      {
         var errorEvent:WebSocketErrorEvent = null;
         if(!connected)
         {
            return;
         }
         fatalError = true;
         var logText:String = "WebSocket: Dropping Connection. Code: " + closeReason.toString(10);
         if(reasonText)
         {
            logText += " - " + reasonText;
         }
         logger(logText);
         frameQueue = new Vector.<WebSocketFrame>();
         fragmentationSize = 0;
         if(closeReason !== 1000)
         {
            errorEvent = new WebSocketErrorEvent("abnormalClose");
            errorEvent.text = "Close reason: " + closeReason;
            dispatchEvent(errorEvent);
         }
         sendCloseFrame(closeReason,reasonText,true);
         dispatchClosedEvent();
         socket.close();
      }
      
      private function sendCloseFrame(reasonCode:uint = 1000, reasonText:String = null, force:Boolean = false) : void
      {
         var frame:WebSocketFrame = new WebSocketFrame();
         frame.fin = true;
         frame.opcode = 8;
         frame.closeStatus = reasonCode;
         if(reasonText)
         {
            frame.binaryPayload = new ByteArray();
            frame.binaryPayload.writeUTFBytes(reasonText);
         }
         sendFrame(frame,force);
      }
      
      private function readServerHandshake() : void
      {
         var header:Object = null;
         var lcName:String = null;
         var lcValue:String = null;
         var extensionsThisLine:Array = null;
         var byteArray:ByteArray = null;
         var expectedKey:String = null;
         var upgradeHeader:Boolean = false;
         var connectionHeader:Boolean = false;
         var serverProtocolHeaderMatch:Boolean = false;
         var keyValidated:Boolean = false;
         var headersTerminatorIndex:int = -1;
         while(headersTerminatorIndex === -1 && readHandshakeLine())
         {
            if(handshakeBytesReceived > 10240)
            {
               failHandshake("Received more than 10240 bytes during handshake.");
               return;
            }
            headersTerminatorIndex = serverHandshakeResponse.search(/\r?\n\r?\n/);
         }
         if(headersTerminatorIndex === -1)
         {
            return;
         }
         if(debug)
         {
            logger("Server Response Headers:\n" + serverHandshakeResponse);
         }
         serverHandshakeResponse = serverHandshakeResponse.slice(0,headersTerminatorIndex);
         var lines:Array = serverHandshakeResponse.split(/\r?\n/);
         var responseLine:String = lines.shift();
         var responseLineMatch:Array = responseLine.match(/^(HTTP\/\d\.\d) (\d{3}) ?(.*)$/i);
         if(responseLineMatch.length === 0)
         {
            failHandshake("Unable to find correctly-formed HTTP status line.");
            return;
         }
         var httpVersion:String = responseLineMatch[1];
         var statusCode:int = parseInt(responseLineMatch[2],10);
         var statusDescription:String = responseLineMatch[3];
         if(debug)
         {
            logger("HTTP Status Received: " + statusCode + " " + statusDescription);
         }
         if(statusCode !== 101)
         {
            failHandshake("An HTTP response code other than 101 was received.  Actual Response Code: " + statusCode + " " + statusDescription);
            return;
         }
         serverExtensions = [];
         try
         {
            while(lines.length > 0)
            {
               responseLine = lines.shift();
               header = parseHTTPHeader(responseLine);
               lcName = header.name.toLocaleLowerCase();
               lcValue = header.value.toLocaleLowerCase();
               if(lcName === "upgrade" && lcValue === "websocket")
               {
                  upgradeHeader = true;
                  continue;
               }
               if(lcName === "connection" && lcValue === "upgrade")
               {
                  connectionHeader = true;
                  continue;
               }
               if(lcName === "sec-websocket-extensions" && header.value)
               {
                  extensionsThisLine = header.value.split(",");
                  serverExtensions = serverExtensions.concat(extensionsThisLine);
                  continue;
               }
               switch(lcName)
               {
                  case "sec-websocket-accept":
                     byteArray = new ByteArray();
                     byteArray.writeUTFBytes(base64nonce + "258EAFA5-E914-47DA-95CA-C5AB0DC85B11");
                     expectedKey = Base64.encodeByteArray(new SHA1().hash(byteArray));
                     if(debug)
                     {
                        logger("Expected Sec-WebSocket-Accept value: " + expectedKey);
                     }
                     if(header.value === expectedKey)
                     {
                        keyValidated = true;
                     }
                     break;
                  case "sec-websocket-protocol":
                     if(_protocols)
                     {
                        for each(var protocol:String in _protocols)
                        {
                           if(protocol == header.value)
                           {
                              _serverProtocol = protocol;
                           }
                        }
                     }
               }
            }
         }
         catch(e:Error)
         {
            failHandshake("There was an error while parsing the following HTTP Header line:\n" + responseLine);
            return;
         }
         if(!upgradeHeader)
         {
            failHandshake("The server response did not include a valid Upgrade: websocket header.");
            return;
         }
         if(!connectionHeader)
         {
            failHandshake("The server response did not include a valid Connection: upgrade header.");
            return;
         }
         if(!keyValidated)
         {
            failHandshake("Unable to validate server response for Sec-Websocket-Accept header.");
            return;
         }
         if(_protocols && !_serverProtocol)
         {
            failHandshake("The server can not respond in any of our requested protocols");
            return;
         }
         if(debug)
         {
            logger("Server Extensions: " + serverExtensions.join(" | "));
         }
         serverSupportsDeflate = false;
         for each(var ext:String in serverExtensions)
         {
            if(ext.indexOf("permessage-deflate") != -1)
            {
               serverSupportsDeflate = true;
            }
         }
         handshakeTimer.stop();
         handshakeTimer.reset();
         serverHandshakeResponse = null;
         _readyState = 1;
         currentFrame = new WebSocketFrame();
         frameQueue = new Vector.<WebSocketFrame>();
         dispatchEvent(new WebSocketEvent("open"));
         handleSocketData();
      }
      
      private function handleHandshakeTimer(event:TimerEvent) : void
      {
         failHandshake("Timed out waiting for server response.");
      }
      
      private function parseHTTPHeader(line:String) : Object
      {
         var header:Array = line.split(/\: +/);
         return header.length === 2 ? {
            "name":header[0],
            "value":header[1]
         } : null;
      }
      
      private function readHandshakeLine() : Boolean
      {
         var char:String = null;
         while(socket.bytesAvailable)
         {
            char = socket.readMultiByte(1,"us-ascii");
            handshakeBytesReceived++;
            serverHandshakeResponse += char;
            if(char == "\n")
            {
               return true;
            }
         }
         return false;
      }
      
      private function dispatchClosedEvent() : void
      {
         var event:WebSocketEvent = null;
         if(handshakeTimer.running)
         {
            handshakeTimer.stop();
         }
         if(_readyState !== 2)
         {
            _readyState = 2;
            event = new WebSocketEvent("closed");
            dispatchEvent(event);
         }
      }
   }
}

