package com.smartfoxserver.v2.entities.data
{
   import flash.utils.ByteArray;
   
   public interface ISFSArray
   {
       
      
      function contains(param1:*) : Boolean;
      
      function getElementAt(param1:int) : *;
      
      function getWrappedElementAt(param1:int) : SFSDataWrapper;
      
      function removeElementAt(param1:int) : *;
      
      function size() : int;
      
      function toBinary() : ByteArray;
      
      function getDump(param1:Boolean = true) : String;
      
      function getHexDump() : String;
      
      function addNull() : void;
      
      function addBool(param1:Boolean) : void;
      
      function addByte(param1:int) : void;
      
      function addShort(param1:int) : void;
      
      function addInt(param1:int) : void;
      
      function addLong(param1:Number) : void;
      
      function addFloat(param1:Number) : void;
      
      function addDouble(param1:Number) : void;
      
      function addUtfString(param1:String) : void;
      
      function addBoolArray(param1:Array) : void;
      
      function addByteArray(param1:ByteArray) : void;
      
      function addShortArray(param1:Array) : void;
      
      function addIntArray(param1:Array) : void;
      
      function addLongArray(param1:Array) : void;
      
      function addFloatArray(param1:Array) : void;
      
      function addDoubleArray(param1:Array) : void;
      
      function addUtfStringArray(param1:Array) : void;
      
      function addSFSArray(param1:ISFSArray) : void;
      
      function addSFSObject(param1:ISFSObject) : void;
      
      function addClass(param1:*) : void;
      
      function add(param1:SFSDataWrapper) : void;
      
      function isNull(param1:int) : Boolean;
      
      function getBool(param1:int) : Boolean;
      
      function getByte(param1:int) : int;
      
      function getUnsignedByte(param1:int) : int;
      
      function getShort(param1:int) : int;
      
      function getInt(param1:int) : int;
      
      function getLong(param1:int) : Number;
      
      function getFloat(param1:int) : Number;
      
      function getDouble(param1:int) : Number;
      
      function getUtfString(param1:int) : String;
      
      function getBoolArray(param1:int) : Array;
      
      function getByteArray(param1:int) : ByteArray;
      
      function getUnsignedByteArray(param1:int) : Array;
      
      function getShortArray(param1:int) : Array;
      
      function getIntArray(param1:int) : Array;
      
      function getLongArray(param1:int) : Array;
      
      function getFloatArray(param1:int) : Array;
      
      function getDoubleArray(param1:int) : Array;
      
      function getUtfStringArray(param1:int) : Array;
      
      function getSFSArray(param1:int) : ISFSArray;
      
      function getSFSObject(param1:int) : ISFSObject;
      
      function getClass(param1:int) : *;
   }
}
