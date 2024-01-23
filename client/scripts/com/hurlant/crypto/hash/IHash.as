package com.hurlant.crypto.hash
{
   import flash.utils.ByteArray;
   
   public interface IHash
   {
       
      
      function toString() : String;
      
      function getHashSize() : uint;
      
      function getInputSize() : uint;
      
      function hash(param1:ByteArray) : ByteArray;
   }
}
