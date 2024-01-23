package com.smartfoxserver.v2.bitswarm
{
   import com.smartfoxserver.v2.protocol.IProtocolCodec;
   import flash.utils.ByteArray;
   
   public interface IoHandler
   {
       
      
      function onDataRead(param1:ByteArray) : void;
      
      function onDataWrite(param1:IMessage) : void;
      
      function get codec() : IProtocolCodec;
   }
}
