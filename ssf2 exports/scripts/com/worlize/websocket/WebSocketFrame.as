package com.worlize.websocket
{
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class WebSocketFrame
   {
      
      private static const NEW_FRAME:int = 0;
      
      private static const WAITING_FOR_16_BIT_LENGTH:int = 1;
      
      private static const WAITING_FOR_64_BIT_LENGTH:int = 2;
      
      private static const WAITING_FOR_PAYLOAD:int = 3;
      
      private static const COMPLETE:int = 4;
      
      private static var _tempMaskBytes:Vector.<uint> = new Vector.<uint>(4);
      
      public var fin:Boolean;
      
      public var rsv1:Boolean;
      
      public var rsv2:Boolean;
      
      public var rsv3:Boolean;
      
      public var opcode:int;
      
      public var mask:Boolean;
      
      public var useNullMask:Boolean;
      
      private var _length:int;
      
      public var binaryPayload:ByteArray;
      
      public var closeStatus:int;
      
      public var protocolError:Boolean = false;
      
      public var frameTooLarge:Boolean = false;
      
      public var dropReason:String;
      
      private var parseState:int = 0;
      
      public function WebSocketFrame()
      {
         super();
      }
      
      public function get length() : int
      {
         return _length;
      }
      
      public function addData(input:IDataInput, fragmentationType:int, config:WebSocketConfig) : Boolean
      {
         var firstByte:int = 0;
         var secondByte:int = 0;
         var firstHalf:* = 0;
         if(input.bytesAvailable >= 2)
         {
            if(parseState === 0)
            {
               firstByte = input.readByte();
               secondByte = input.readByte();
               fin = Boolean(firstByte & 0x80);
               rsv1 = Boolean(firstByte & 0x40);
               rsv2 = Boolean(firstByte & 0x20);
               rsv3 = Boolean(firstByte & 0x10);
               mask = Boolean(secondByte & 0x80);
               opcode = firstByte & 0x0F;
               _length = secondByte & 0x7F;
               if(mask)
               {
                  protocolError = true;
                  dropReason = "Received an illegal masked frame from the server.";
                  return true;
               }
               if(opcode > 7)
               {
                  if(_length > 125)
                  {
                     protocolError = true;
                     dropReason = "Illegal control frame larger than 125 bytes.";
                     return true;
                  }
                  if(!fin)
                  {
                     protocolError = true;
                     dropReason = "Received illegal fragmented control message.";
                     return true;
                  }
               }
               if(_length === 126)
               {
                  parseState = 1;
               }
               else if(_length === 127)
               {
                  parseState = 2;
               }
               else
               {
                  parseState = 3;
               }
            }
            if(parseState === 1)
            {
               if(input.bytesAvailable >= 2)
               {
                  _length = input.readUnsignedShort();
                  parseState = 3;
               }
            }
            else if(parseState === 2)
            {
               if(input.bytesAvailable >= 8)
               {
                  firstHalf = input.readUnsignedInt();
                  if(firstHalf > 0)
                  {
                     frameTooLarge = true;
                     dropReason = "Unsupported 64-bit length frame received.";
                     return true;
                  }
                  _length = input.readUnsignedInt();
                  parseState = 3;
               }
            }
            if(parseState === 3)
            {
               if(_length > config.maxReceivedFrameSize)
               {
                  frameTooLarge = true;
                  dropReason = "Received frame size of " + _length + "exceeds maximum accepted frame size of " + config.maxReceivedFrameSize;
                  return true;
               }
               if(_length === 0)
               {
                  binaryPayload = new ByteArray();
                  parseState = 4;
                  return true;
               }
               if(input.bytesAvailable >= _length)
               {
                  binaryPayload = new ByteArray();
                  binaryPayload.endian = "bigEndian";
                  input.readBytes(binaryPayload,0,_length);
                  binaryPayload.position = 0;
                  parseState = 4;
                  return true;
               }
            }
         }
         return false;
      }
      
      private function throwAwayPayload(input:IDataInput) : void
      {
         var i:int = 0;
         if(input.bytesAvailable >= _length)
         {
            for(i = 0; i < _length; )
            {
               input.readByte();
               i++;
            }
            parseState = 4;
         }
      }
      
      public function send(output:IDataOutput) : void
      {
         var maskKey:* = 0;
         var data:ByteArray = null;
         var j:int = 0;
         var remaining:* = 0;
         if(this.mask && !this.useNullMask)
         {
            maskKey = uint(Math.ceil(Math.random() * 4294967295));
            _tempMaskBytes[0] = maskKey >> 24 & 0xFF;
            _tempMaskBytes[1] = maskKey >> 16 & 0xFF;
            _tempMaskBytes[2] = maskKey >> 8 & 0xFF;
            _tempMaskBytes[3] = maskKey & 0xFF;
         }
         var firstByte:int = 0;
         var secondByte:int = 0;
         if(fin)
         {
            firstByte |= 128;
         }
         if(rsv1)
         {
            firstByte |= 64;
         }
         if(rsv2)
         {
            firstByte |= 32;
         }
         if(rsv3)
         {
            firstByte |= 16;
         }
         if(mask)
         {
            secondByte |= 128;
         }
         firstByte |= opcode & 0x0F;
         if(opcode === 8)
         {
            data = new ByteArray();
            data.endian = "bigEndian";
            data.writeShort(closeStatus);
            if(binaryPayload)
            {
               binaryPayload.position = 0;
               data.writeBytes(binaryPayload);
            }
            data.position = 0;
            _length = data.length;
         }
         else if(binaryPayload)
         {
            data = binaryPayload;
            data.endian = "bigEndian";
            data.position = 0;
            _length = data.length;
         }
         else
         {
            data = new ByteArray();
            _length = 0;
         }
         if(opcode >= 8)
         {
            if(_length > 125)
            {
               throw new Error("Illegal control frame longer than 125 bytes");
            }
            if(!fin)
            {
               throw new Error("Control frames must not be fragmented.");
            }
         }
         if(_length <= 125)
         {
            secondByte |= _length & 0x7F;
         }
         else if(_length > 125 && _length <= 65535)
         {
            secondByte |= 126;
         }
         else if(_length > 65535)
         {
            secondByte |= 127;
         }
         output.writeByte(firstByte);
         output.writeByte(secondByte);
         if(_length > 125 && _length <= 65535)
         {
            output.writeShort(_length);
         }
         else if(_length > 65535)
         {
            output.writeUnsignedInt(0);
            output.writeUnsignedInt(_length);
         }
         if(this.mask)
         {
            if(this.useNullMask)
            {
               output.writeUnsignedInt(0);
               output.writeBytes(data,0,data.length);
            }
            else
            {
               output.writeUnsignedInt(maskKey);
               j = 0;
               remaining = data.bytesAvailable;
               while(remaining >= 4)
               {
                  output.writeUnsignedInt(data.readUnsignedInt() ^ maskKey);
                  remaining -= 4;
               }
               while(remaining > 0)
               {
                  output.writeByte(data.readByte() ^ _tempMaskBytes[j]);
                  j += 1;
                  remaining -= 1;
               }
            }
         }
         else
         {
            output.writeBytes(data,0,data.length);
         }
      }
   }
}

