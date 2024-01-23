package com.smartfoxserver.v2.core
{
   import com.smartfoxserver.v2.bitswarm.BitSwarmClient;
   import com.smartfoxserver.v2.bitswarm.IMessage;
   import com.smartfoxserver.v2.bitswarm.IoHandler;
   import com.smartfoxserver.v2.bitswarm.PacketReadState;
   import com.smartfoxserver.v2.bitswarm.PendingPacket;
   import com.smartfoxserver.v2.exceptions.SFSCodecError;
   import com.smartfoxserver.v2.exceptions.SFSError;
   import com.smartfoxserver.v2.logging.Logger;
   import com.smartfoxserver.v2.protocol.IProtocolCodec;
   import com.smartfoxserver.v2.protocol.serialization.DefaultObjectDumpFormatter;
   import flash.errors.IOError;
   import flash.utils.ByteArray;
   
   public class SFSIOHandler implements IoHandler
   {
      
      public static const SHORT_BYTE_SIZE:int = 2;
      
      public static const INT_BYTE_SIZE:int = 4;
       
      
      private var bitSwarm:BitSwarmClient;
      
      private var log:Logger;
      
      private var readState:int;
      
      private var pendingPacket:PendingPacket;
      
      private var protocolCodec:IProtocolCodec;
      
      private const EMPTY_BUFFER:ByteArray = new ByteArray();
      
      public function SFSIOHandler(param1:BitSwarmClient)
      {
         super();
         this.bitSwarm = param1;
         this.log = Logger.getInstance();
         this.readState = PacketReadState.WAIT_NEW_PACKET;
         this.protocolCodec = new SFSProtocolCodec(this,param1);
      }
      
      public function get codec() : IProtocolCodec
      {
         return this.protocolCodec;
      }
      
      public function set codec(param1:IProtocolCodec) : void
      {
         this.protocolCodec = param1;
      }
      
      public function onDataRead(param1:ByteArray) : void
      {
         if(param1.length == 0)
         {
            throw new SFSError("Unexpected empty packet data: no readable bytes available!");
         }
         if(this.bitSwarm != null && this.bitSwarm.sfs.debug)
         {
            if(param1.length > 1024)
            {
               this.log.info("Data Read: Size > 1024, dump omitted");
            }
            else
            {
               this.log.info("Data Read: " + DefaultObjectDumpFormatter.hexDump(param1));
            }
         }
         param1.position = 0;
         while(param1.length > 0)
         {
            if(this.readState == PacketReadState.WAIT_NEW_PACKET)
            {
               param1 = this.handleNewPacket(param1);
            }
            if(this.readState == PacketReadState.WAIT_DATA_SIZE)
            {
               param1 = this.handleDataSize(param1);
            }
            if(this.readState == PacketReadState.WAIT_DATA_SIZE_FRAGMENT)
            {
               param1 = this.handleDataSizeFragment(param1);
            }
            if(this.readState == PacketReadState.WAIT_DATA)
            {
               param1 = this.handlePacketData(param1);
            }
         }
      }
      
      private function handleNewPacket(param1:ByteArray) : ByteArray
      {
         this.log.debug("Handling New Packet");
         var _loc2_:int = param1.readByte();
         if(!(_loc2_ & 128) > 0)
         {
            throw new SFSError("Unexpected header byte: " + _loc2_ + "\n" + DefaultObjectDumpFormatter.hexDump(param1));
         }
         var _loc3_:PacketHeader = PacketHeader.fromBinary(_loc2_);
         this.pendingPacket = new PendingPacket(_loc3_);
         this.readState = PacketReadState.WAIT_DATA_SIZE;
         return this.resizeByteArray(param1,1,length - 1);
      }
      
      private function handleDataSize(param1:ByteArray) : ByteArray
      {
         this.log.debug("Handling Header Size. Size: " + param1.length + " (" + (this.pendingPacket.header.bigSized ? "big" : "small") + ")");
         var _loc2_:int = -1;
         var _loc3_:int = 2;
         if(this.pendingPacket.header.bigSized)
         {
            if(param1.length >= 4)
            {
               _loc2_ = int(param1.readUnsignedInt());
            }
            _loc3_ = 4;
         }
         else if(param1.length >= 2)
         {
            _loc2_ = int(param1.readUnsignedShort());
         }
         if(_loc2_ != -1)
         {
            this.pendingPacket.header.expectedLen = _loc2_;
            param1 = this.resizeByteArray(param1,_loc3_,param1.length - _loc3_);
            this.readState = PacketReadState.WAIT_DATA;
         }
         else
         {
            this.readState = PacketReadState.WAIT_DATA_SIZE_FRAGMENT;
            this.pendingPacket.buffer.writeBytes(param1);
            param1 = this.EMPTY_BUFFER;
         }
         return param1;
      }
      
      private function handleDataSizeFragment(param1:ByteArray) : ByteArray
      {
         var _loc3_:int = 0;
         this.log.debug("Handling Size fragment. Data: " + param1.length);
         var _loc2_:int = this.pendingPacket.header.bigSized ? 4 - this.pendingPacket.buffer.position : 2 - this.pendingPacket.buffer.position;
         if(param1.length >= _loc2_)
         {
            this.pendingPacket.buffer.writeBytes(param1,0,_loc2_);
            this.pendingPacket.buffer.position = 0;
            _loc3_ = this.pendingPacket.header.bigSized ? this.pendingPacket.buffer.readInt() : this.pendingPacket.buffer.readShort();
            this.log.debug("DataSize is ready:",_loc3_,"bytes");
            this.pendingPacket.header.expectedLen = _loc3_;
            this.pendingPacket.buffer = new ByteArray();
            this.readState = PacketReadState.WAIT_DATA;
            if(param1.length > _loc2_)
            {
               param1 = this.resizeByteArray(param1,_loc2_,param1.length - _loc2_);
            }
            else
            {
               param1 = this.EMPTY_BUFFER;
            }
         }
         else
         {
            this.pendingPacket.buffer.writeBytes(param1);
            param1 = this.EMPTY_BUFFER;
         }
         return param1;
      }
      
      private function handlePacketData(param1:ByteArray) : ByteArray
      {
         var _loc2_:int = this.pendingPacket.header.expectedLen - this.pendingPacket.buffer.length;
         var _loc3_:* = param1.length > _loc2_;
         this.log.debug("Handling Data: " + param1.length + ", previous state: " + this.pendingPacket.buffer.length + "/" + this.pendingPacket.header.expectedLen);
         if(param1.length >= _loc2_)
         {
            this.pendingPacket.buffer.writeBytes(param1,0,_loc2_);
            this.log.debug("<<< Packet Complete >>>");
            if(this.pendingPacket.header.compressed)
            {
               this.pendingPacket.buffer.uncompress();
            }
            this.protocolCodec.onPacketRead(this.pendingPacket.buffer);
            this.readState = PacketReadState.WAIT_NEW_PACKET;
         }
         else
         {
            this.pendingPacket.buffer.writeBytes(param1);
         }
         if(_loc3_)
         {
            param1 = this.resizeByteArray(param1,_loc2_,param1.length - _loc2_);
         }
         else
         {
            param1 = this.EMPTY_BUFFER;
         }
         return param1;
      }
      
      private function resizeByteArray(param1:ByteArray, param2:int, param3:int) : ByteArray
      {
         var _loc4_:ByteArray;
         (_loc4_ = new ByteArray()).writeBytes(param1,param2,param3);
         _loc4_.position = 0;
         return _loc4_;
      }
      
      public function onDataWrite(param1:IMessage) : void
      {
         var _loc2_:ByteArray = new ByteArray();
         var _loc3_:ByteArray = param1.content.toBinary();
         var _loc4_:Boolean = false;
         if(_loc3_.length > this.bitSwarm.compressionThreshold)
         {
            _loc3_.compress();
            _loc4_ = true;
         }
         if(_loc3_.length > this.bitSwarm.maxMessageSize)
         {
            throw new SFSCodecError("Message size is too big: " + _loc3_.length + ", the server limit is: " + this.bitSwarm.maxMessageSize);
         }
         var _loc5_:int = SHORT_BYTE_SIZE;
         if(_loc3_.length > 65535)
         {
            _loc5_ = INT_BYTE_SIZE;
         }
         var _loc6_:PacketHeader = new PacketHeader(param1.isEncrypted,_loc4_,false,_loc5_ == INT_BYTE_SIZE);
         _loc2_.writeByte(_loc6_.encode());
         if(_loc5_ > SHORT_BYTE_SIZE)
         {
            _loc2_.writeInt(_loc3_.length);
         }
         else
         {
            _loc2_.writeShort(_loc3_.length);
         }
         _loc2_.writeBytes(_loc3_);
         if(this.bitSwarm.useBlueBox)
         {
            this.bitSwarm.httpSocket.send(_loc2_);
         }
         else if(this.bitSwarm.socket.connected)
         {
            if(param1.isUDP)
            {
               this.writeUDP(param1,_loc2_);
            }
            else
            {
               this.writeTCP(param1,_loc2_);
            }
         }
      }
      
      private function writeTCP(param1:IMessage, param2:ByteArray) : void
      {
         var message:IMessage = param1;
         var writeBuffer:ByteArray = param2;
         try
         {
            this.bitSwarm.socket.writeBytes(writeBuffer);
            this.bitSwarm.socket.flush();
            if(this.bitSwarm.sfs.debug)
            {
               this.log.info("Data written: " + message.content.getHexDump());
            }
         }
         catch(error:IOError)
         {
            log.warn("WriteTCP operation failed due to I/O Error: " + error.toString());
         }
      }
      
      private function writeUDP(param1:IMessage, param2:ByteArray) : void
      {
         this.bitSwarm.udpManager.send(param2);
      }
   }
}
