package com.smartfoxserver.v2.entities.data
{
   import flash.utils.ByteArray;
   
   public interface ISFSObject
   {
       
      
      function isNull(param1:String) : Boolean;
      
      function containsKey(param1:String) : Boolean;
      
      function removeElement(param1:String) : void;
      
      function getKeys() : Array;
      
      function size() : int;
      
      function toBinary() : ByteArray;
      
      function toObject() : Object;
      
      function getDump(param1:Boolean = true) : String;
      
      function getHexDump() : String;
      
      function getData(param1:String) : SFSDataWrapper;
      
      function getBool(param1:String) : Boolean;
      
      function getByte(param1:String) : int;
      
      function getUnsignedByte(param1:String) : int;
      
      function getShort(param1:String) : int;
      
      function getInt(param1:String) : int;
      
      function getLong(param1:String) : Number;
      
      function getFloat(param1:String) : Number;
      
      function getDouble(param1:String) : Number;
      
      function getUtfString(param1:String) : String;
      
      function getBoolArray(param1:String) : Array;
      
      function getByteArray(param1:String) : ByteArray;
      
      function getUnsignedByteArray(param1:String) : Array;
      
      function getShortArray(param1:String) : Array;
      
      function getIntArray(param1:String) : Array;
      
      function getLongArray(param1:String) : Array;
      
      function getFloatArray(param1:String) : Array;
      
      function getDoubleArray(param1:String) : Array;
      
      function getUtfStringArray(param1:String) : Array;
      
      function getSFSArray(param1:String) : ISFSArray;
      
      function getSFSObject(param1:String) : ISFSObject;
      
      function getClass(param1:String) : *;
      
      function putNull(param1:String) : void;
      
      function putBool(param1:String, param2:Boolean) : void;
      
      function putByte(param1:String, param2:int) : void;
      
      function putShort(param1:String, param2:int) : void;
      
      function putInt(param1:String, param2:int) : void;
      
      function putLong(param1:String, param2:Number) : void;
      
      function putFloat(param1:String, param2:Number) : void;
      
      function putDouble(param1:String, param2:Number) : void;
      
      function putUtfString(param1:String, param2:String) : void;
      
      function putBoolArray(param1:String, param2:Array) : void;
      
      function putByteArray(param1:String, param2:ByteArray) : void;
      
      function putShortArray(param1:String, param2:Array) : void;
      
      function putIntArray(param1:String, param2:Array) : void;
      
      function putLongArray(param1:String, param2:Array) : void;
      
      function putFloatArray(param1:String, param2:Array) : void;
      
      function putDoubleArray(param1:String, param2:Array) : void;
      
      function putUtfStringArray(param1:String, param2:Array) : void;
      
      function putSFSArray(param1:String, param2:ISFSArray) : void;
      
      function putSFSObject(param1:String, param2:ISFSObject) : void;
      
      function putClass(param1:String, param2:*) : void;
      
      function put(param1:String, param2:SFSDataWrapper) : void;
   }
}
