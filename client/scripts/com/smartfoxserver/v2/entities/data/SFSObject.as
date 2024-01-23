package com.smartfoxserver.v2.entities.data
{
   import com.smartfoxserver.v2.protocol.serialization.DefaultObjectDumpFormatter;
   import com.smartfoxserver.v2.protocol.serialization.DefaultSFSDataSerializer;
   import com.smartfoxserver.v2.protocol.serialization.ISFSDataSerializer;
   import flash.utils.ByteArray;
   
   public class SFSObject implements ISFSObject
   {
       
      
      private var dataHolder:Object;
      
      private var serializer:ISFSDataSerializer;
      
      public function SFSObject()
      {
         super();
         this.dataHolder = {};
         this.serializer = DefaultSFSDataSerializer.getInstance();
      }
      
      public static function newFromObject(param1:Object, param2:Boolean = false) : SFSObject
      {
         return DefaultSFSDataSerializer.getInstance().genericObjectToSFSObject(param1,param2);
      }
      
      public static function newFromBinaryData(param1:ByteArray) : SFSObject
      {
         return DefaultSFSDataSerializer.getInstance().binary2object(param1) as SFSObject;
      }
      
      public static function newInstance() : SFSObject
      {
         return new SFSObject();
      }
      
      public function isNull(param1:String) : Boolean
      {
         var _loc2_:SFSDataWrapper = this.dataHolder[param1];
         if(_loc2_ == null)
         {
            return true;
         }
         return _loc2_.data == null;
      }
      
      public function containsKey(param1:String) : Boolean
      {
         var _loc3_:String = null;
         var _loc2_:Boolean = false;
         for(_loc3_ in this.dataHolder)
         {
            if(_loc3_ == param1)
            {
               _loc2_ = true;
               break;
            }
         }
         return _loc2_;
      }
      
      public function removeElement(param1:String) : void
      {
         delete this.dataHolder[param1];
      }
      
      public function getKeys() : Array
      {
         var _loc2_:String = null;
         var _loc1_:Array = [];
         for(_loc2_ in this.dataHolder)
         {
            _loc1_.push(_loc2_);
         }
         return _loc1_;
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
         return this.serializer.object2binary(this);
      }
      
      public function toObject() : Object
      {
         return DefaultSFSDataSerializer.getInstance().sfsObjectToGenericObject(this);
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
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc1_:String = DefaultObjectDumpFormatter.TOKEN_INDENT_OPEN;
         for(_loc4_ in this.dataHolder)
         {
            _loc2_ = this.getData(_loc4_);
            _loc3_ = _loc2_.type;
            _loc1_ += "(" + SFSDataType.fromId(_loc2_.type).toLowerCase() + ")";
            _loc1_ += " " + _loc4_ + ": ";
            if(_loc3_ == SFSDataType.SFS_OBJECT)
            {
               _loc1_ += (_loc2_.data as SFSObject).getDump(false);
            }
            else if(_loc3_ == SFSDataType.SFS_ARRAY)
            {
               _loc1_ += (_loc2_.data as SFSArray).getDump(false);
            }
            else if(_loc3_ == SFSDataType.BYTE_ARRAY)
            {
               _loc1_ += DefaultObjectDumpFormatter.prettyPrintByteArray(_loc2_.data as ByteArray);
            }
            else if(_loc3_ > SFSDataType.UTF_STRING && _loc3_ < SFSDataType.CLASS)
            {
               _loc1_ += "[" + _loc2_.data + "]";
            }
            else
            {
               _loc1_ += _loc2_.data;
            }
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
      
      public function getData(param1:String) : SFSDataWrapper
      {
         return this.dataHolder[param1];
      }
      
      public function getBool(param1:String) : Boolean
      {
         var _loc2_:SFSDataWrapper = this.dataHolder[param1] as SFSDataWrapper;
         if(_loc2_ != null)
         {
            return _loc2_.data as Boolean;
         }
         return undefined;
      }
      
      public function getByte(param1:String) : int
      {
         return this.getInt(param1);
      }
      
      public function getUnsignedByte(param1:String) : int
      {
         return this.getInt(param1) & 255;
      }
      
      public function getShort(param1:String) : int
      {
         return this.getInt(param1);
      }
      
      public function getInt(param1:String) : int
      {
         var _loc2_:SFSDataWrapper = this.dataHolder[param1] as SFSDataWrapper;
         if(_loc2_ != null)
         {
            return _loc2_.data as int;
         }
         return undefined;
      }
      
      public function getLong(param1:String) : Number
      {
         return this.getDouble(param1);
      }
      
      public function getFloat(param1:String) : Number
      {
         return this.getDouble(param1);
      }
      
      public function getDouble(param1:String) : Number
      {
         var _loc2_:SFSDataWrapper = this.dataHolder[param1] as SFSDataWrapper;
         if(_loc2_ != null)
         {
            return _loc2_.data as Number;
         }
         return undefined;
      }
      
      public function getUtfString(param1:String) : String
      {
         var _loc2_:SFSDataWrapper = this.dataHolder[param1] as SFSDataWrapper;
         if(_loc2_ != null)
         {
            return _loc2_.data as String;
         }
         return null;
      }
      
      private function getArray(param1:String) : Array
      {
         var _loc2_:SFSDataWrapper = this.dataHolder[param1] as SFSDataWrapper;
         if(_loc2_ != null)
         {
            return _loc2_.data as Array;
         }
         return null;
      }
      
      public function getBoolArray(param1:String) : Array
      {
         return this.getArray(param1);
      }
      
      public function getByteArray(param1:String) : ByteArray
      {
         var _loc2_:SFSDataWrapper = this.dataHolder[param1] as SFSDataWrapper;
         if(_loc2_ != null)
         {
            return _loc2_.data as ByteArray;
         }
         return null;
      }
      
      public function getUnsignedByteArray(param1:String) : Array
      {
         var _loc2_:ByteArray = this.getByteArray(param1);
         if(_loc2_ == null)
         {
            return null;
         }
         _loc2_.position = 0;
         var _loc3_:Array = [];
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_.length)
         {
            _loc3_.push(_loc2_.readByte() & 255);
            _loc4_++;
         }
         return _loc3_;
      }
      
      public function getShortArray(param1:String) : Array
      {
         return this.getArray(param1);
      }
      
      public function getIntArray(param1:String) : Array
      {
         return this.getArray(param1);
      }
      
      public function getLongArray(param1:String) : Array
      {
         return this.getArray(param1);
      }
      
      public function getFloatArray(param1:String) : Array
      {
         return this.getArray(param1);
      }
      
      public function getDoubleArray(param1:String) : Array
      {
         return this.getArray(param1);
      }
      
      public function getUtfStringArray(param1:String) : Array
      {
         return this.getArray(param1);
      }
      
      public function getSFSArray(param1:String) : ISFSArray
      {
         var _loc2_:SFSDataWrapper = this.dataHolder[param1] as SFSDataWrapper;
         if(_loc2_ != null)
         {
            return _loc2_.data as ISFSArray;
         }
         return null;
      }
      
      public function getSFSObject(param1:String) : ISFSObject
      {
         var _loc2_:SFSDataWrapper = this.dataHolder[param1] as SFSDataWrapper;
         if(_loc2_ != null)
         {
            return _loc2_.data as ISFSObject;
         }
         return null;
      }
      
      public function getClass(param1:String) : *
      {
         var _loc2_:SFSDataWrapper = this.dataHolder[param1] as SFSDataWrapper;
         if(_loc2_ != null)
         {
            return _loc2_.data;
         }
         return null;
      }
      
      public function putNull(param1:String) : void
      {
         this.dataHolder[param1] = new SFSDataWrapper(SFSDataType.NULL,null);
      }
      
      public function putBool(param1:String, param2:Boolean) : void
      {
         this.dataHolder[param1] = new SFSDataWrapper(SFSDataType.BOOL,param2);
      }
      
      public function putByte(param1:String, param2:int) : void
      {
         this.dataHolder[param1] = new SFSDataWrapper(SFSDataType.BYTE,param2);
      }
      
      public function putShort(param1:String, param2:int) : void
      {
         this.dataHolder[param1] = new SFSDataWrapper(SFSDataType.SHORT,param2);
      }
      
      public function putInt(param1:String, param2:int) : void
      {
         this.dataHolder[param1] = new SFSDataWrapper(SFSDataType.INT,param2);
      }
      
      public function putLong(param1:String, param2:Number) : void
      {
         this.dataHolder[param1] = new SFSDataWrapper(SFSDataType.LONG,param2);
      }
      
      public function putFloat(param1:String, param2:Number) : void
      {
         this.dataHolder[param1] = new SFSDataWrapper(SFSDataType.FLOAT,param2);
      }
      
      public function putDouble(param1:String, param2:Number) : void
      {
         this.dataHolder[param1] = new SFSDataWrapper(SFSDataType.DOUBLE,param2);
      }
      
      public function putUtfString(param1:String, param2:String) : void
      {
         this.dataHolder[param1] = new SFSDataWrapper(SFSDataType.UTF_STRING,param2);
      }
      
      public function putBoolArray(param1:String, param2:Array) : void
      {
         this.dataHolder[param1] = new SFSDataWrapper(SFSDataType.BOOL_ARRAY,param2);
      }
      
      public function putByteArray(param1:String, param2:ByteArray) : void
      {
         this.dataHolder[param1] = new SFSDataWrapper(SFSDataType.BYTE_ARRAY,param2);
      }
      
      public function putShortArray(param1:String, param2:Array) : void
      {
         this.dataHolder[param1] = new SFSDataWrapper(SFSDataType.SHORT_ARRAY,param2);
      }
      
      public function putIntArray(param1:String, param2:Array) : void
      {
         this.dataHolder[param1] = new SFSDataWrapper(SFSDataType.INT_ARRAY,param2);
      }
      
      public function putLongArray(param1:String, param2:Array) : void
      {
         this.dataHolder[param1] = new SFSDataWrapper(SFSDataType.LONG_ARRAY,param2);
      }
      
      public function putFloatArray(param1:String, param2:Array) : void
      {
         this.dataHolder[param1] = new SFSDataWrapper(SFSDataType.FLOAT_ARRAY,param2);
      }
      
      public function putDoubleArray(param1:String, param2:Array) : void
      {
         this.dataHolder[param1] = new SFSDataWrapper(SFSDataType.DOUBLE_ARRAY,param2);
      }
      
      public function putUtfStringArray(param1:String, param2:Array) : void
      {
         this.dataHolder[param1] = new SFSDataWrapper(SFSDataType.UTF_STRING_ARRAY,param2);
      }
      
      public function putSFSArray(param1:String, param2:ISFSArray) : void
      {
         this.dataHolder[param1] = new SFSDataWrapper(SFSDataType.SFS_ARRAY,param2);
      }
      
      public function putSFSObject(param1:String, param2:ISFSObject) : void
      {
         this.dataHolder[param1] = new SFSDataWrapper(SFSDataType.SFS_OBJECT,param2);
      }
      
      public function putClass(param1:String, param2:*) : void
      {
         this.dataHolder[param1] = new SFSDataWrapper(SFSDataType.CLASS,param2);
      }
      
      public function put(param1:String, param2:SFSDataWrapper) : void
      {
         this.dataHolder[param1] = param2;
      }
   }
}
