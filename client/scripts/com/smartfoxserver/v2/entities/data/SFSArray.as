package com.smartfoxserver.v2.entities.data
{
   import com.smartfoxserver.v2.exceptions.SFSError;
   import com.smartfoxserver.v2.protocol.serialization.DefaultObjectDumpFormatter;
   import com.smartfoxserver.v2.protocol.serialization.DefaultSFSDataSerializer;
   import com.smartfoxserver.v2.protocol.serialization.ISFSDataSerializer;
   import flash.utils.ByteArray;
   
   public class SFSArray implements ISFSArray
   {
       
      
      private var serializer:ISFSDataSerializer;
      
      private var dataHolder:Array;
      
      public function SFSArray()
      {
         super();
         this.dataHolder = [];
         this.serializer = DefaultSFSDataSerializer.getInstance();
      }
      
      public static function newFromArray(param1:Array, param2:Boolean = false) : SFSArray
      {
         return DefaultSFSDataSerializer.getInstance().genericArrayToSFSArray(param1,param2);
      }
      
      public static function newFromBinaryData(param1:ByteArray) : SFSArray
      {
         return DefaultSFSDataSerializer.getInstance().binary2array(param1) as SFSArray;
      }
      
      public static function newInstance() : SFSArray
      {
         return new SFSArray();
      }
      
      public function contains(param1:*) : Boolean
      {
         var _loc4_:* = undefined;
         if(param1 is ISFSArray || param1 is ISFSObject)
         {
            throw new SFSError("ISFSArray and ISFSObject are not supported by this method.");
         }
         var _loc2_:Boolean = false;
         var _loc3_:int = 0;
         while(_loc3_ < this.size())
         {
            if((_loc4_ = this.getElementAt(_loc3_)) != null && _loc4_ == param1)
            {
               _loc2_ = true;
               break;
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function getWrappedElementAt(param1:int) : SFSDataWrapper
      {
         return this.dataHolder[param1];
      }
      
      public function getElementAt(param1:int) : *
      {
         var _loc2_:* = null;
         if(this.dataHolder[param1] != null)
         {
            _loc2_ = this.dataHolder[param1].data;
         }
         return _loc2_;
      }
      
      public function removeElementAt(param1:int) : *
      {
         this.dataHolder.splice(param1,1);
      }
      
      public function size() : int
      {
         var _loc2_:String = null;
         var _loc1_:int = 0;
         for(_loc2_ in this.dataHolder)
         {
            _loc1_++;
         }
         return _loc1_;
      }
      
      public function toBinary() : ByteArray
      {
         return this.serializer.array2binary(this);
      }
      
      public function toArray() : Array
      {
         return DefaultSFSDataSerializer.getInstance().sfsArrayToGenericArray(this);
      }
      
      public function getDump(param1:Boolean = true) : String
      {
         var prettyDump:String = null;
         var format:Boolean = param1;
         if(!format)
         {
            return this.dump();
         }
         try
         {
            prettyDump = DefaultObjectDumpFormatter.prettyPrintDump(this.dump());
         }
         catch(err:Error)
         {
            prettyDump = "Unable to provide a dump of this object";
         }
         return prettyDump;
      }
      
      private function dump() : String
      {
         var _loc2_:SFSDataWrapper = null;
         var _loc3_:* = null;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc1_:String = DefaultObjectDumpFormatter.TOKEN_INDENT_OPEN;
         for(_loc5_ in this.dataHolder)
         {
            _loc2_ = this.dataHolder[_loc5_];
            if((_loc4_ = _loc2_.type) == SFSDataType.SFS_OBJECT)
            {
               _loc3_ = (_loc2_.data as SFSObject).getDump(false);
            }
            else if(_loc4_ == SFSDataType.SFS_ARRAY)
            {
               _loc3_ = (_loc2_.data as SFSArray).getDump(false);
            }
            else if(_loc4_ > SFSDataType.UTF_STRING && _loc4_ < SFSDataType.CLASS)
            {
               _loc3_ = "[" + _loc2_.data + "]";
            }
            else if(_loc4_ == SFSDataType.BYTE_ARRAY)
            {
               _loc3_ = DefaultObjectDumpFormatter.prettyPrintByteArray(_loc2_.data as ByteArray);
            }
            else
            {
               _loc3_ = _loc2_.data;
            }
            _loc1_ += "(" + SFSDataType.fromId(_loc2_.type).toLowerCase() + ") ";
            _loc1_ += _loc3_;
            _loc1_ += DefaultObjectDumpFormatter.TOKEN_DIVIDER;
         }
         if(this.size() > 0)
         {
            _loc1_ = _loc1_.slice(0,_loc1_.length - 1);
         }
         return _loc1_ + DefaultObjectDumpFormatter.TOKEN_INDENT_CLOSE;
      }
      
      public function getHexDump() : String
      {
         return DefaultObjectDumpFormatter.hexDump(this.toBinary());
      }
      
      public function addNull() : void
      {
         this.addObject(null,SFSDataType.NULL);
      }
      
      public function addBool(param1:Boolean) : void
      {
         this.addObject(param1,SFSDataType.BOOL);
      }
      
      public function addByte(param1:int) : void
      {
         this.addObject(param1,SFSDataType.BYTE);
      }
      
      public function addShort(param1:int) : void
      {
         this.addObject(param1,SFSDataType.SHORT);
      }
      
      public function addInt(param1:int) : void
      {
         this.addObject(param1,SFSDataType.INT);
      }
      
      public function addLong(param1:Number) : void
      {
         this.addObject(param1,SFSDataType.LONG);
      }
      
      public function addFloat(param1:Number) : void
      {
         this.addObject(param1,SFSDataType.FLOAT);
      }
      
      public function addDouble(param1:Number) : void
      {
         this.addObject(param1,SFSDataType.DOUBLE);
      }
      
      public function addUtfString(param1:String) : void
      {
         this.addObject(param1,SFSDataType.UTF_STRING);
      }
      
      public function addBoolArray(param1:Array) : void
      {
         this.addObject(param1,SFSDataType.BOOL_ARRAY);
      }
      
      public function addByteArray(param1:ByteArray) : void
      {
         this.addObject(param1,SFSDataType.BYTE_ARRAY);
      }
      
      public function addShortArray(param1:Array) : void
      {
         this.addObject(param1,SFSDataType.SHORT_ARRAY);
      }
      
      public function addIntArray(param1:Array) : void
      {
         this.addObject(param1,SFSDataType.INT_ARRAY);
      }
      
      public function addLongArray(param1:Array) : void
      {
         this.addObject(param1,SFSDataType.LONG_ARRAY);
      }
      
      public function addFloatArray(param1:Array) : void
      {
         this.addObject(param1,SFSDataType.FLOAT_ARRAY);
      }
      
      public function addDoubleArray(param1:Array) : void
      {
         this.addObject(param1,SFSDataType.DOUBLE_ARRAY);
      }
      
      public function addUtfStringArray(param1:Array) : void
      {
         this.addObject(param1,SFSDataType.UTF_STRING_ARRAY);
      }
      
      public function addSFSArray(param1:ISFSArray) : void
      {
         this.addObject(param1,SFSDataType.SFS_ARRAY);
      }
      
      public function addSFSObject(param1:ISFSObject) : void
      {
         this.addObject(param1,SFSDataType.SFS_OBJECT);
      }
      
      public function addClass(param1:*) : void
      {
         this.addObject(param1,SFSDataType.CLASS);
      }
      
      public function add(param1:SFSDataWrapper) : void
      {
         this.dataHolder.push(param1);
      }
      
      private function addObject(param1:*, param2:int) : void
      {
         this.add(new SFSDataWrapper(param2,param1));
      }
      
      public function isNull(param1:int) : Boolean
      {
         var _loc2_:Boolean = false;
         var _loc3_:SFSDataWrapper = this.dataHolder[param1];
         if(_loc3_ == null || _loc3_.type == SFSDataType.NULL)
         {
            _loc2_ = true;
         }
         return _loc2_;
      }
      
      public function getBool(param1:int) : Boolean
      {
         var _loc2_:SFSDataWrapper = this.dataHolder[param1];
         return _loc2_ != null ? _loc2_.data as Boolean : undefined;
      }
      
      public function getByte(param1:int) : int
      {
         return this.getInt(param1);
      }
      
      public function getUnsignedByte(param1:int) : int
      {
         return this.getInt(param1) & 255;
      }
      
      public function getShort(param1:int) : int
      {
         return this.getInt(param1);
      }
      
      public function getInt(param1:int) : int
      {
         var _loc2_:SFSDataWrapper = this.dataHolder[param1];
         return _loc2_ != null ? _loc2_.data as int : undefined;
      }
      
      public function getLong(param1:int) : Number
      {
         return this.getDouble(param1);
      }
      
      public function getFloat(param1:int) : Number
      {
         return this.getDouble(param1);
      }
      
      public function getDouble(param1:int) : Number
      {
         var _loc2_:SFSDataWrapper = this.dataHolder[param1];
         return _loc2_ != null ? _loc2_.data as Number : undefined;
      }
      
      public function getUtfString(param1:int) : String
      {
         var _loc2_:SFSDataWrapper = this.dataHolder[param1];
         return _loc2_ != null ? _loc2_.data as String : null;
      }
      
      private function getArray(param1:int) : Array
      {
         var _loc2_:SFSDataWrapper = this.dataHolder[param1];
         return _loc2_ != null ? _loc2_.data as Array : null;
      }
      
      public function getBoolArray(param1:int) : Array
      {
         return this.getArray(param1);
      }
      
      public function getByteArray(param1:int) : ByteArray
      {
         var _loc2_:SFSDataWrapper = this.dataHolder[param1];
         return _loc2_ != null ? _loc2_.data as ByteArray : null;
      }
      
      public function getUnsignedByteArray(param1:int) : Array
      {
         var _loc2_:ByteArray = this.getByteArray(param1);
         if(_loc2_ == null)
         {
            return null;
         }
         var _loc3_:Array = [];
         _loc2_.position = 0;
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_.length)
         {
            _loc3_.push(_loc2_.readByte() & 255);
            _loc4_++;
         }
         return _loc3_;
      }
      
      public function getShortArray(param1:int) : Array
      {
         return this.getArray(param1);
      }
      
      public function getIntArray(param1:int) : Array
      {
         return this.getArray(param1);
      }
      
      public function getLongArray(param1:int) : Array
      {
         return this.getArray(param1);
      }
      
      public function getFloatArray(param1:int) : Array
      {
         return this.getArray(param1);
      }
      
      public function getDoubleArray(param1:int) : Array
      {
         return this.getArray(param1);
      }
      
      public function getUtfStringArray(param1:int) : Array
      {
         return this.getArray(param1);
      }
      
      public function getSFSArray(param1:int) : ISFSArray
      {
         var _loc2_:SFSDataWrapper = this.dataHolder[param1];
         return _loc2_ != null ? _loc2_.data as ISFSArray : null;
      }
      
      public function getClass(param1:int) : *
      {
         var _loc2_:SFSDataWrapper = this.dataHolder[param1];
         return _loc2_ != null ? _loc2_.data : null;
      }
      
      public function getSFSObject(param1:int) : ISFSObject
      {
         var _loc2_:SFSDataWrapper = this.dataHolder[param1];
         return _loc2_ != null ? _loc2_.data as ISFSObject : null;
      }
   }
}
