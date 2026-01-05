package com.smartfoxserver.v2.protocol.serialization
{
   import com.smartfoxserver.v2.entities.data.ISFSArray;
   import com.smartfoxserver.v2.entities.data.ISFSObject;
   import flash.utils.ByteArray;
   
   public interface ISFSDataSerializer
   {
       
      
      function object2binary(param1:ISFSObject) : ByteArray;
      
      function array2binary(param1:ISFSArray) : ByteArray;
      
      function binary2object(param1:ByteArray) : ISFSObject;
      
      function binary2array(param1:ByteArray) : ISFSArray;
   }
}
