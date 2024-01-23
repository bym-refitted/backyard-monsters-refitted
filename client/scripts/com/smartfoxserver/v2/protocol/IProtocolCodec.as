package com.smartfoxserver.v2.protocol
{
   import com.smartfoxserver.v2.bitswarm.IMessage;
   import com.smartfoxserver.v2.bitswarm.IoHandler;
   
   public interface IProtocolCodec
   {
       
      
      function onPacketRead(param1:*) : void;
      
      function onPacketWrite(param1:IMessage) : void;
      
      function get ioHandler() : IoHandler;
      
      function set ioHandler(param1:IoHandler) : void;
   }
}
