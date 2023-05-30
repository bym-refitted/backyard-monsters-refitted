package com.smartfoxserver.v2.core
{
   import com.smartfoxserver.v2.bitswarm.BitSwarmClient;
   import com.smartfoxserver.v2.bitswarm.IController;
   import com.smartfoxserver.v2.bitswarm.IMessage;
   import com.smartfoxserver.v2.bitswarm.IoHandler;
   import com.smartfoxserver.v2.bitswarm.Message;
   import com.smartfoxserver.v2.entities.data.ISFSObject;
   import com.smartfoxserver.v2.entities.data.SFSObject;
   import com.smartfoxserver.v2.exceptions.SFSCodecError;
   import com.smartfoxserver.v2.exceptions.SFSError;
   import com.smartfoxserver.v2.logging.Logger;
   import com.smartfoxserver.v2.protocol.IProtocolCodec;
   import flash.utils.ByteArray;
   
   public class SFSProtocolCodec implements IProtocolCodec
   {
      
      private static const CONTROLLER_ID:String = "c";
      
      private static const ACTION_ID:String = "a";
      
      private static const PARAM_ID:String = "p";
      
      private static const USER_ID:String = "u";
      
      private static const UDP_PACKET_ID:String = "i";
       
      
      private var _ioHandler:IoHandler;
      
      private var log:Logger;
      
      private var bitSwarm:BitSwarmClient;
      
      public function SFSProtocolCodec(param1:IoHandler, param2:BitSwarmClient)
      {
         super();
         this._ioHandler = param1;
         this.log = Logger.getInstance();
         this.bitSwarm = param2;
      }
      
      public function onPacketRead(param1:*) : void
      {
         var _loc2_:ISFSObject = null;
         if(param1 is ByteArray)
         {
            _loc2_ = SFSObject.newFromBinaryData(param1);
         }
         else
         {
            _loc2_ = param1 as ISFSObject;
         }
         this.dispatchRequest(_loc2_);
      }
      
      public function onPacketWrite(param1:IMessage) : void
      {
         var _loc2_:ISFSObject = null;
         if(param1.isUDP)
         {
            _loc2_ = this.prepareUDPPacket(param1);
         }
         else
         {
            _loc2_ = this.prepareTCPPacket(param1);
         }
         param1.content = _loc2_;
         if(this.bitSwarm.sfs.debug)
         {
            this.log.info("Object going out: " + param1.content.getDump());
         }
         this.ioHandler.onDataWrite(param1);
      }
      
      private function prepareTCPPacket(param1:IMessage) : ISFSObject
      {
         var _loc2_:ISFSObject = new SFSObject();
         _loc2_.putByte(CONTROLLER_ID,param1.targetController);
         _loc2_.putShort(ACTION_ID,param1.id);
         _loc2_.putSFSObject(PARAM_ID,param1.content);
         return _loc2_;
      }
      
      private function prepareUDPPacket(param1:IMessage) : ISFSObject
      {
         var _loc2_:ISFSObject = new SFSObject();
         _loc2_.putByte(CONTROLLER_ID,param1.targetController);
         _loc2_.putInt(USER_ID,this.bitSwarm.sfs.mySelf != null ? this.bitSwarm.sfs.mySelf.id : -1);
         _loc2_.putLong(UDP_PACKET_ID,this.bitSwarm.nextUdpPacketId());
         _loc2_.putSFSObject(PARAM_ID,param1.content);
         return _loc2_;
      }
      
      public function get ioHandler() : IoHandler
      {
         return this._ioHandler;
      }
      
      public function set ioHandler(param1:IoHandler) : void
      {
         if(this._ioHandler != null)
         {
            throw new SFSError("IOHandler is already defined for thir ProtocolHandler instance: " + this);
         }
         this._ioHandler = this.ioHandler;
      }
      
      private function dispatchRequest(param1:ISFSObject) : void
      {
         var _loc2_:IMessage = new Message();
         if(param1.isNull(CONTROLLER_ID))
         {
            throw new SFSCodecError("Request rejected: No Controller ID in request!");
         }
         if(param1.isNull(ACTION_ID))
         {
            throw new SFSCodecError("Request rejected: No Action ID in request!");
         }
         _loc2_.id = param1.getByte(ACTION_ID);
         _loc2_.content = param1.getSFSObject(PARAM_ID);
         _loc2_.isUDP = param1.containsKey(UDP_PACKET_ID);
         if(_loc2_.isUDP)
         {
            _loc2_.packetId = param1.getLong(UDP_PACKET_ID);
         }
         var _loc3_:int = param1.getByte(CONTROLLER_ID);
         var _loc4_:IController;
         if((_loc4_ = this.bitSwarm.getController(_loc3_)) == null)
         {
            throw new SFSError("Cannot handle server response. Unknown controller, id: " + _loc3_);
         }
         _loc4_.handleMessage(_loc2_);
      }
   }
}
