package com.smartfoxserver.v2.entities.variables
{
   import com.smartfoxserver.v2.entities.data.ISFSArray;
   import com.smartfoxserver.v2.entities.data.ISFSObject;
   
   public interface UserVariable
   {
       
      
      function get name() : String;
      
      function get type() : String;
      
      function getValue() : *;
      
      function getBoolValue() : Boolean;
      
      function getIntValue() : int;
      
      function getDoubleValue() : Number;
      
      function getStringValue() : String;
      
      function getSFSObjectValue() : ISFSObject;
      
      function getSFSArrayValue() : ISFSArray;
      
      function isNull() : Boolean;
      
      function toSFSArray() : ISFSArray;
   }
}
