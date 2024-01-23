package com.smartfoxserver.v2.protocol.serialization
{
   import as3reflect.ClassUtils;
   import as3reflect.Field;
   import as3reflect.Type;
   import com.smartfoxserver.v2.entities.data.ISFSArray;
   import com.smartfoxserver.v2.entities.data.ISFSObject;
   import com.smartfoxserver.v2.entities.data.SFSArray;
   import com.smartfoxserver.v2.entities.data.SFSDataType;
   import com.smartfoxserver.v2.entities.data.SFSDataWrapper;
   import com.smartfoxserver.v2.entities.data.SFSObject;
   import com.smartfoxserver.v2.exceptions.SFSCodecError;
   import flash.utils.ByteArray;
   
   public class DefaultSFSDataSerializer implements ISFSDataSerializer
   {
      
      private static const CLASS_MARKER_KEY:String = "$C";
      
      private static const CLASS_FIELDS_KEY:String = "$F";
      
      private static const FIELD_NAME_KEY:String = "N";
      
      private static const FIELD_VALUE_KEY:String = "V";
      
      private static var _instance:DefaultSFSDataSerializer;
      
      private static var _lock:Boolean = true;
       
      
      public function DefaultSFSDataSerializer()
      {
         super();
         if(_lock)
         {
            throw new Error("Can\'t use constructor, please use getInstance() method");
         }
      }
      
      public static function getInstance() : DefaultSFSDataSerializer
      {
         if(_instance == null)
         {
            _lock = false;
            _instance = new DefaultSFSDataSerializer();
            _lock = true;
         }
         return _instance;
      }
      
      public function object2binary(param1:ISFSObject) : ByteArray
      {
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.writeByte(SFSDataType.SFS_OBJECT);
         _loc2_.writeShort(param1.size());
         return this.obj2bin(param1,_loc2_);
      }
      
      private function obj2bin(param1:ISFSObject, param2:ByteArray) : ByteArray
      {
         var _loc4_:SFSDataWrapper = null;
         var _loc5_:String = null;
         var _loc3_:Array = param1.getKeys();
         for each(_loc5_ in _loc3_)
         {
            _loc4_ = param1.getData(_loc5_);
            param2 = this.encodeSFSObjectKey(param2,_loc5_);
            param2 = this.encodeObject(param2,_loc4_.type,_loc4_.data);
         }
         return param2;
      }
      
      public function array2binary(param1:ISFSArray) : ByteArray
      {
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.writeByte(SFSDataType.SFS_ARRAY);
         _loc2_.writeShort(param1.size());
         return this.arr2bin(param1,_loc2_);
      }
      
      private function arr2bin(param1:ISFSArray, param2:ByteArray) : ByteArray
      {
         var _loc3_:SFSDataWrapper = null;
         var _loc4_:int = 0;
         while(_loc4_ < param1.size())
         {
            _loc3_ = param1.getWrappedElementAt(_loc4_);
            param2 = this.encodeObject(param2,_loc3_.type,_loc3_.data);
            _loc4_++;
         }
         return param2;
      }
      
      public function binary2object(param1:ByteArray) : ISFSObject
      {
         if(param1.length < 3)
         {
            throw new SFSCodecError("Can\'t decode an SFSObject. Byte data is insufficient. Size: " + param1.length + " byte(s)");
         }
         param1.position = 0;
         return this.decodeSFSObject(param1);
      }
      
      private function decodeSFSObject(param1:ByteArray) : ISFSObject
      {
         var size:int;
         var i:int = 0;
         var key:String = null;
         var decodedObject:SFSDataWrapper = null;
         var buffer:ByteArray = param1;
         var sfsObject:SFSObject = SFSObject.newInstance();
         var headerByte:int = buffer.readByte();
         if(headerByte != SFSDataType.SFS_OBJECT)
         {
            throw new SFSCodecError("Invalid SFSDataType. Expected: " + SFSDataType.SFS_OBJECT + ", found: " + headerByte);
         }
         size = buffer.readShort();
         if(size < 0)
         {
            throw new SFSCodecError("Can\'t decode SFSObject. Size is negative: " + size);
         }
         try
         {
            i = 0;
            while(i < size)
            {
               key = buffer.readUTF();
               decodedObject = this.decodeObject(buffer);
               if(decodedObject == null)
               {
                  throw new SFSCodecError("Could not decode value for SFSObject with key: " + key);
               }
               sfsObject.put(key,decodedObject);
               i++;
            }
         }
         catch(err:SFSCodecError)
         {
            throw err;
         }
         return sfsObject;
      }
      
      public function binary2array(param1:ByteArray) : ISFSArray
      {
         if(param1.length < 3)
         {
            throw new SFSCodecError("Can\'t decode an SFSArray. Byte data is insufficient. Size: " + param1.length + " byte(s)");
         }
         param1.position = 0;
         return this.decodeSFSArray(param1);
      }
      
      private function decodeSFSArray(param1:ByteArray) : ISFSArray
      {
         var size:int;
         var i:int = 0;
         var decodedObject:SFSDataWrapper = null;
         var buffer:ByteArray = param1;
         var sfsArray:ISFSArray = SFSArray.newInstance();
         var headerByte:int = buffer.readByte();
         if(headerByte != SFSDataType.SFS_ARRAY)
         {
            throw new SFSCodecError("Invalid SFSDataType. Expected: " + SFSDataType.SFS_ARRAY + ", found: " + headerByte);
         }
         size = buffer.readShort();
         if(size < 0)
         {
            throw new SFSCodecError("Can\'t decode SFSArray. Size is negative: " + size);
         }
         try
         {
            i = 0;
            while(i < size)
            {
               decodedObject = this.decodeObject(buffer);
               if(decodedObject == null)
               {
                  throw new SFSCodecError("Could not decode SFSArray item at index: " + i);
               }
               sfsArray.add(decodedObject);
               i++;
            }
         }
         catch(err:SFSCodecError)
         {
            throw err;
         }
         return sfsArray;
      }
      
      private function decodeObject(param1:ByteArray) : SFSDataWrapper
      {
         var _loc2_:SFSDataWrapper = null;
         var _loc4_:ISFSObject = null;
         var _loc5_:int = 0;
         var _loc6_:* = undefined;
         var _loc3_:int = param1.readByte();
         if(_loc3_ == SFSDataType.NULL)
         {
            _loc2_ = this.binDecode_NULL(param1);
         }
         else if(_loc3_ == SFSDataType.BOOL)
         {
            _loc2_ = this.binDecode_BOOL(param1);
         }
         else if(_loc3_ == SFSDataType.BOOL_ARRAY)
         {
            _loc2_ = this.binDecode_BOOL_ARRAY(param1);
         }
         else if(_loc3_ == SFSDataType.BYTE)
         {
            _loc2_ = this.binDecode_BYTE(param1);
         }
         else if(_loc3_ == SFSDataType.BYTE_ARRAY)
         {
            _loc2_ = this.binDecode_BYTE_ARRAY(param1);
         }
         else if(_loc3_ == SFSDataType.SHORT)
         {
            _loc2_ = this.binDecode_SHORT(param1);
         }
         else if(_loc3_ == SFSDataType.SHORT_ARRAY)
         {
            _loc2_ = this.binDecode_SHORT_ARRAY(param1);
         }
         else if(_loc3_ == SFSDataType.INT)
         {
            _loc2_ = this.binDecode_INT(param1);
         }
         else if(_loc3_ == SFSDataType.INT_ARRAY)
         {
            _loc2_ = this.binDecode_INT_ARRAY(param1);
         }
         else if(_loc3_ == SFSDataType.LONG)
         {
            _loc2_ = this.binDecode_LONG(param1);
         }
         else if(_loc3_ == SFSDataType.LONG_ARRAY)
         {
            _loc2_ = this.binDecode_LONG_ARRAY(param1);
         }
         else if(_loc3_ == SFSDataType.FLOAT)
         {
            _loc2_ = this.binDecode_FLOAT(param1);
         }
         else if(_loc3_ == SFSDataType.FLOAT_ARRAY)
         {
            _loc2_ = this.binDecode_FLOAT_ARRAY(param1);
         }
         else if(_loc3_ == SFSDataType.DOUBLE)
         {
            _loc2_ = this.binDecode_DOUBLE(param1);
         }
         else if(_loc3_ == SFSDataType.DOUBLE_ARRAY)
         {
            _loc2_ = this.binDecode_DOUBLE_ARRAY(param1);
         }
         else if(_loc3_ == SFSDataType.UTF_STRING)
         {
            _loc2_ = this.binDecode_UTF_STRING(param1);
         }
         else if(_loc3_ == SFSDataType.UTF_STRING_ARRAY)
         {
            _loc2_ = this.binDecode_UTF_STRING_ARRAY(param1);
         }
         else if(_loc3_ == SFSDataType.SFS_ARRAY)
         {
            --param1.position;
            _loc2_ = new SFSDataWrapper(SFSDataType.SFS_ARRAY,this.decodeSFSArray(param1));
         }
         else
         {
            if(_loc3_ != SFSDataType.SFS_OBJECT)
            {
               throw new Error("Unknow SFSDataType ID: " + _loc3_);
            }
            --param1.position;
            _loc4_ = this.decodeSFSObject(param1);
            _loc5_ = SFSDataType.SFS_OBJECT;
            _loc6_ = _loc4_;
            if(_loc4_.containsKey(CLASS_MARKER_KEY) && _loc4_.containsKey(CLASS_FIELDS_KEY))
            {
               _loc5_ = SFSDataType.CLASS;
               _loc6_ = this.sfs2as(_loc4_);
            }
            _loc2_ = new SFSDataWrapper(_loc5_,_loc6_);
         }
         return _loc2_;
      }
      
      private function encodeObject(param1:ByteArray, param2:int, param3:*) : ByteArray
      {
         switch(param2)
         {
            case SFSDataType.NULL:
               param1 = this.binEncode_NULL(param1);
               break;
            case SFSDataType.BOOL:
               param1 = this.binEncode_BOOL(param1,param3 as Boolean);
               break;
            case SFSDataType.BYTE:
               param1 = this.binEncode_BYTE(param1,param3 as int);
               break;
            case SFSDataType.SHORT:
               param1 = this.binEncode_SHORT(param1,param3 as int);
               break;
            case SFSDataType.INT:
               param1 = this.binEncode_INT(param1,param3 as int);
               break;
            case SFSDataType.LONG:
               param1 = this.binEncode_LONG(param1,param3 as Number);
               break;
            case SFSDataType.FLOAT:
               param1 = this.binEncode_FLOAT(param1,param3 as Number);
               break;
            case SFSDataType.DOUBLE:
               param1 = this.binEncode_DOUBLE(param1,param3 as Number);
               break;
            case SFSDataType.UTF_STRING:
               param1 = this.binEncode_UTF_STRING(param1,param3 as String);
               break;
            case SFSDataType.BOOL_ARRAY:
               param1 = this.binEncode_BOOL_ARRAY(param1,param3 as Array);
               break;
            case SFSDataType.BYTE_ARRAY:
               param1 = this.binEncode_BYTE_ARRAY(param1,param3 as ByteArray);
               break;
            case SFSDataType.SHORT_ARRAY:
               param1 = this.binEncode_SHORT_ARRAY(param1,param3 as Array);
               break;
            case SFSDataType.INT_ARRAY:
               param1 = this.binEncode_INT_ARRAY(param1,param3 as Array);
               break;
            case SFSDataType.LONG_ARRAY:
               param1 = this.binEncode_LONG_ARRAY(param1,param3 as Array);
               break;
            case SFSDataType.FLOAT_ARRAY:
               param1 = this.binEncode_FLOAT_ARRAY(param1,param3 as Array);
               break;
            case SFSDataType.DOUBLE_ARRAY:
               param1 = this.binEncode_DOUBLE_ARRAY(param1,param3 as Array);
               break;
            case SFSDataType.UTF_STRING_ARRAY:
               param1 = this.binEncode_UTF_STRING_ARRAY(param1,param3 as Array);
               break;
            case SFSDataType.SFS_ARRAY:
               param1 = this.addData(param1,this.array2binary(param3 as SFSArray));
               break;
            case SFSDataType.SFS_OBJECT:
               param1 = this.addData(param1,this.object2binary(param3 as SFSObject));
               break;
            case SFSDataType.CLASS:
               param1 = this.addData(param1,this.object2binary(this.as2sfs(param3)));
               break;
            default:
               throw new SFSCodecError("Unrecognized type in SFSObject serialization: " + param2);
         }
         return param1;
      }
      
      private function binDecode_NULL(param1:ByteArray) : SFSDataWrapper
      {
         return new SFSDataWrapper(SFSDataType.NULL,null);
      }
      
      private function binDecode_BOOL(param1:ByteArray) : SFSDataWrapper
      {
         return new SFSDataWrapper(SFSDataType.BOOL,param1.readBoolean());
      }
      
      private function binDecode_BYTE(param1:ByteArray) : SFSDataWrapper
      {
         return new SFSDataWrapper(SFSDataType.BYTE,param1.readByte());
      }
      
      private function binDecode_SHORT(param1:ByteArray) : SFSDataWrapper
      {
         return new SFSDataWrapper(SFSDataType.SHORT,param1.readShort());
      }
      
      private function binDecode_INT(param1:ByteArray) : SFSDataWrapper
      {
         return new SFSDataWrapper(SFSDataType.INT,param1.readInt());
      }
      
      private function binDecode_LONG(param1:ByteArray) : SFSDataWrapper
      {
         return new SFSDataWrapper(SFSDataType.LONG,this.decodeLongValue(param1));
      }
      
      private function decodeLongValue(param1:ByteArray) : Number
      {
         var _loc2_:int = param1.readInt();
         var _loc3_:uint = param1.readUnsignedInt();
         return _loc2_ * Math.pow(2,32) + _loc3_;
      }
      
      private function encodeLongValue(param1:Number, param2:ByteArray) : void
      {
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(param1 > -1)
         {
            _loc3_ = param1 / Math.pow(2,32);
            _loc4_ = param1 % Math.pow(2,32);
         }
         else
         {
            _loc3_ = (_loc6_ = (_loc5_ = Math.abs(param1)) - 1) / Math.pow(2,32);
            _loc4_ = _loc6_ % Math.pow(2,32);
            _loc3_ = ~_loc3_;
            _loc4_ = ~_loc4_;
         }
         param2.writeUnsignedInt(_loc3_);
         param2.writeUnsignedInt(_loc4_);
      }
      
      private function binDecode_FLOAT(param1:ByteArray) : SFSDataWrapper
      {
         return new SFSDataWrapper(SFSDataType.FLOAT,param1.readFloat());
      }
      
      private function binDecode_DOUBLE(param1:ByteArray) : SFSDataWrapper
      {
         return new SFSDataWrapper(SFSDataType.DOUBLE,param1.readDouble());
      }
      
      private function binDecode_UTF_STRING(param1:ByteArray) : SFSDataWrapper
      {
         return new SFSDataWrapper(SFSDataType.UTF_STRING,param1.readUTF());
      }
      
      private function binDecode_BOOL_ARRAY(param1:ByteArray) : SFSDataWrapper
      {
         var _loc2_:int = this.getTypedArraySize(param1);
         var _loc3_:Array = [];
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            _loc3_.push(param1.readBoolean());
            _loc4_++;
         }
         return new SFSDataWrapper(SFSDataType.BOOL_ARRAY,_loc3_);
      }
      
      private function binDecode_BYTE_ARRAY(param1:ByteArray) : SFSDataWrapper
      {
         var _loc2_:int = param1.readInt();
         if(_loc2_ < 0)
         {
            throw new SFSCodecError("Array negative size: " + _loc2_);
         }
         var _loc3_:ByteArray = new ByteArray();
         param1.readBytes(_loc3_,0,_loc2_);
         return new SFSDataWrapper(SFSDataType.BYTE_ARRAY,_loc3_);
      }
      
      private function binDecode_SHORT_ARRAY(param1:ByteArray) : SFSDataWrapper
      {
         var _loc2_:int = this.getTypedArraySize(param1);
         var _loc3_:Array = [];
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            _loc3_.push(param1.readShort());
            _loc4_++;
         }
         return new SFSDataWrapper(SFSDataType.SHORT_ARRAY,_loc3_);
      }
      
      private function binDecode_INT_ARRAY(param1:ByteArray) : SFSDataWrapper
      {
         var _loc2_:int = this.getTypedArraySize(param1);
         var _loc3_:Array = [];
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            _loc3_.push(param1.readInt());
            _loc4_++;
         }
         return new SFSDataWrapper(SFSDataType.INT_ARRAY,_loc3_);
      }
      
      private function binDecode_LONG_ARRAY(param1:ByteArray) : SFSDataWrapper
      {
         var _loc2_:int = this.getTypedArraySize(param1);
         var _loc3_:Array = [];
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            _loc3_.push(this.decodeLongValue(param1));
            _loc4_++;
         }
         return new SFSDataWrapper(SFSDataType.LONG_ARRAY,_loc3_);
      }
      
      private function binDecode_FLOAT_ARRAY(param1:ByteArray) : SFSDataWrapper
      {
         var _loc2_:int = this.getTypedArraySize(param1);
         var _loc3_:Array = [];
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            _loc3_.push(param1.readFloat());
            _loc4_++;
         }
         return new SFSDataWrapper(SFSDataType.FLOAT_ARRAY,_loc3_);
      }
      
      private function binDecode_DOUBLE_ARRAY(param1:ByteArray) : SFSDataWrapper
      {
         var _loc2_:int = this.getTypedArraySize(param1);
         var _loc3_:Array = [];
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            _loc3_.push(param1.readDouble());
            _loc4_++;
         }
         return new SFSDataWrapper(SFSDataType.DOUBLE_ARRAY,_loc3_);
      }
      
      private function binDecode_UTF_STRING_ARRAY(param1:ByteArray) : SFSDataWrapper
      {
         var _loc2_:int = this.getTypedArraySize(param1);
         var _loc3_:Array = [];
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            _loc3_.push(param1.readUTF());
            _loc4_++;
         }
         return new SFSDataWrapper(SFSDataType.UTF_STRING_ARRAY,_loc3_);
      }
      
      private function getTypedArraySize(param1:ByteArray) : int
      {
         var _loc2_:int = param1.readShort();
         if(_loc2_ < 0)
         {
            throw new SFSCodecError("Array negative size: " + _loc2_);
         }
         return _loc2_;
      }
      
      private function binEncode_NULL(param1:ByteArray) : ByteArray
      {
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.writeByte(0);
         return this.addData(param1,_loc2_);
      }
      
      private function binEncode_BOOL(param1:ByteArray, param2:Boolean) : ByteArray
      {
         var _loc3_:ByteArray = new ByteArray();
         _loc3_.writeByte(SFSDataType.BOOL);
         _loc3_.writeBoolean(param2);
         return this.addData(param1,_loc3_);
      }
      
      private function binEncode_BYTE(param1:ByteArray, param2:int) : ByteArray
      {
         var _loc3_:ByteArray = new ByteArray();
         _loc3_.writeByte(SFSDataType.BYTE);
         _loc3_.writeByte(param2);
         return this.addData(param1,_loc3_);
      }
      
      private function binEncode_SHORT(param1:ByteArray, param2:int) : ByteArray
      {
         var _loc3_:ByteArray = new ByteArray();
         _loc3_.writeByte(SFSDataType.SHORT);
         _loc3_.writeShort(param2);
         return this.addData(param1,_loc3_);
      }
      
      private function binEncode_INT(param1:ByteArray, param2:int) : ByteArray
      {
         var _loc3_:ByteArray = new ByteArray();
         _loc3_.writeByte(SFSDataType.INT);
         _loc3_.writeInt(param2);
         return this.addData(param1,_loc3_);
      }
      
      private function binEncode_LONG(param1:ByteArray, param2:Number) : ByteArray
      {
         var _loc3_:ByteArray = new ByteArray();
         _loc3_.writeByte(SFSDataType.LONG);
         this.encodeLongValue(param2,_loc3_);
         return this.addData(param1,_loc3_);
      }
      
      private function binEncode_FLOAT(param1:ByteArray, param2:Number) : ByteArray
      {
         var _loc3_:ByteArray = new ByteArray();
         _loc3_.writeByte(SFSDataType.FLOAT);
         _loc3_.writeFloat(param2);
         return this.addData(param1,_loc3_);
      }
      
      private function binEncode_DOUBLE(param1:ByteArray, param2:Number) : ByteArray
      {
         var _loc3_:ByteArray = new ByteArray();
         _loc3_.writeByte(SFSDataType.DOUBLE);
         _loc3_.writeDouble(param2);
         return this.addData(param1,_loc3_);
      }
      
      private function binEncode_UTF_STRING(param1:ByteArray, param2:String) : ByteArray
      {
         var _loc3_:ByteArray = new ByteArray();
         _loc3_.writeByte(SFSDataType.UTF_STRING);
         _loc3_.writeUTF(param2);
         return this.addData(param1,_loc3_);
      }
      
      private function binEncode_BOOL_ARRAY(param1:ByteArray, param2:Array) : ByteArray
      {
         var _loc3_:ByteArray = new ByteArray();
         _loc3_.writeByte(SFSDataType.BOOL_ARRAY);
         _loc3_.writeShort(param2.length);
         var _loc4_:int = 0;
         while(_loc4_ < param2.length)
         {
            _loc3_.writeBoolean(param2[_loc4_]);
            _loc4_++;
         }
         return this.addData(param1,_loc3_);
      }
      
      private function binEncode_BYTE_ARRAY(param1:ByteArray, param2:ByteArray) : ByteArray
      {
         var _loc3_:ByteArray = new ByteArray();
         _loc3_.writeByte(SFSDataType.BYTE_ARRAY);
         _loc3_.writeInt(param2.length);
         _loc3_.writeBytes(param2,0,param2.length);
         return this.addData(param1,_loc3_);
      }
      
      private function binEncode_SHORT_ARRAY(param1:ByteArray, param2:Array) : ByteArray
      {
         var _loc3_:ByteArray = new ByteArray();
         _loc3_.writeByte(SFSDataType.SHORT_ARRAY);
         _loc3_.writeShort(param2.length);
         var _loc4_:int = 0;
         while(_loc4_ < param2.length)
         {
            _loc3_.writeShort(param2[_loc4_]);
            _loc4_++;
         }
         return this.addData(param1,_loc3_);
      }
      
      private function binEncode_INT_ARRAY(param1:ByteArray, param2:Array) : ByteArray
      {
         var _loc3_:ByteArray = new ByteArray();
         _loc3_.writeByte(SFSDataType.INT_ARRAY);
         _loc3_.writeShort(param2.length);
         var _loc4_:int = 0;
         while(_loc4_ < param2.length)
         {
            _loc3_.writeInt(param2[_loc4_]);
            _loc4_++;
         }
         return this.addData(param1,_loc3_);
      }
      
      private function binEncode_LONG_ARRAY(param1:ByteArray, param2:Array) : ByteArray
      {
         var _loc3_:ByteArray = new ByteArray();
         _loc3_.writeByte(SFSDataType.LONG_ARRAY);
         _loc3_.writeShort(param2.length);
         var _loc4_:int = 0;
         while(_loc4_ < param2.length)
         {
            this.encodeLongValue(param2[_loc4_],_loc3_);
            _loc4_++;
         }
         return this.addData(param1,_loc3_);
      }
      
      private function binEncode_FLOAT_ARRAY(param1:ByteArray, param2:Array) : ByteArray
      {
         var _loc3_:ByteArray = new ByteArray();
         _loc3_.writeByte(SFSDataType.FLOAT_ARRAY);
         _loc3_.writeShort(param2.length);
         var _loc4_:int = 0;
         while(_loc4_ < param2.length)
         {
            _loc3_.writeFloat(param2[_loc4_]);
            _loc4_++;
         }
         return this.addData(param1,_loc3_);
      }
      
      private function binEncode_DOUBLE_ARRAY(param1:ByteArray, param2:Array) : ByteArray
      {
         var _loc3_:ByteArray = new ByteArray();
         _loc3_.writeByte(SFSDataType.DOUBLE_ARRAY);
         _loc3_.writeShort(param2.length);
         var _loc4_:int = 0;
         while(_loc4_ < param2.length)
         {
            _loc3_.writeDouble(param2[_loc4_]);
            _loc4_++;
         }
         return this.addData(param1,_loc3_);
      }
      
      private function binEncode_UTF_STRING_ARRAY(param1:ByteArray, param2:Array) : ByteArray
      {
         var _loc3_:ByteArray = new ByteArray();
         _loc3_.writeByte(SFSDataType.UTF_STRING_ARRAY);
         _loc3_.writeShort(param2.length);
         var _loc4_:int = 0;
         while(_loc4_ < param2.length)
         {
            _loc3_.writeUTF(param2[_loc4_]);
            _loc4_++;
         }
         return this.addData(param1,_loc3_);
      }
      
      private function encodeSFSObjectKey(param1:ByteArray, param2:String) : ByteArray
      {
         param1.writeUTF(param2);
         return param1;
      }
      
      private function addData(param1:ByteArray, param2:ByteArray) : ByteArray
      {
         param1.writeBytes(param2,0,param2.length);
         return param1;
      }
      
      public function as2sfs(param1:*) : ISFSObject
      {
         var _loc2_:ISFSObject = SFSObject.newInstance();
         this.convertAsObj(param1,_loc2_);
         return _loc2_;
      }
      
      private function encodeClassName(param1:String) : String
      {
         return param1.replace("::",".");
      }
      
      private function convertAsObj(param1:*, param2:ISFSObject) : void
      {
         var _loc6_:Field = null;
         var _loc7_:String = null;
         var _loc8_:* = undefined;
         var _loc9_:ISFSObject = null;
         var _loc3_:Type = Type.forInstance(param1);
         var _loc4_:String;
         if((_loc4_ = this.encodeClassName(ClassUtils.getFullyQualifiedName(_loc3_.clazz))) == null)
         {
            throw new SFSCodecError("Cannot detect class name: " + param2);
         }
         if(!(param1 is SerializableSFSType))
         {
            throw new SFSCodecError("Cannot serialize object: " + param1 + ", type: " + _loc4_ + " -- It doesn\'t implement the SerializableSFSType interface");
         }
         var _loc5_:ISFSArray = SFSArray.newInstance();
         param2.putUtfString(CLASS_MARKER_KEY,_loc4_);
         param2.putSFSArray(CLASS_FIELDS_KEY,_loc5_);
         for each(_loc6_ in _loc3_.fields)
         {
            if(!_loc6_.isStatic)
            {
               _loc7_ = _loc6_.name;
               _loc8_ = param1[_loc7_];
               if(_loc7_.charAt(0) != "$")
               {
                  (_loc9_ = SFSObject.newInstance()).putUtfString(FIELD_NAME_KEY,_loc7_);
                  _loc9_.put(FIELD_VALUE_KEY,this.wrapASField(_loc8_));
                  _loc5_.addSFSObject(_loc9_);
               }
            }
         }
      }
      
      private function wrapASField(param1:*) : SFSDataWrapper
      {
         var _loc2_:SFSDataWrapper = null;
         if(param1 == null)
         {
            return new SFSDataWrapper(SFSDataType.NULL,null);
         }
         var _loc3_:String = Type.forInstance(param1).name;
         if(param1 is Boolean)
         {
            _loc2_ = new SFSDataWrapper(SFSDataType.BOOL,param1);
         }
         else if(param1 is int || param1 is uint)
         {
            _loc2_ = new SFSDataWrapper(SFSDataType.INT,param1);
         }
         else if(param1 is Number)
         {
            if(param1 == Math.floor(param1))
            {
               _loc2_ = new SFSDataWrapper(SFSDataType.LONG,param1);
            }
            else
            {
               _loc2_ = new SFSDataWrapper(SFSDataType.DOUBLE,param1);
            }
         }
         else if(param1 is String)
         {
            _loc2_ = new SFSDataWrapper(SFSDataType.UTF_STRING,param1);
         }
         else if(param1 is Array)
         {
            _loc2_ = new SFSDataWrapper(SFSDataType.SFS_ARRAY,this.unrollArray(param1));
         }
         else if(param1 is SerializableSFSType)
         {
            _loc2_ = new SFSDataWrapper(SFSDataType.SFS_OBJECT,this.as2sfs(param1));
         }
         else if(param1 is Object)
         {
            _loc2_ = new SFSDataWrapper(SFSDataType.SFS_OBJECT,this.unrollDictionary(param1));
         }
         return _loc2_;
      }
      
      private function unrollArray(param1:Array) : ISFSArray
      {
         var _loc2_:ISFSArray = SFSArray.newInstance();
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_.add(this.wrapASField(param1[_loc3_]));
            _loc3_++;
         }
         return _loc2_;
      }
      
      private function unrollDictionary(param1:Object) : ISFSObject
      {
         var _loc3_:String = null;
         var _loc2_:ISFSObject = SFSObject.newInstance();
         for(_loc3_ in param1)
         {
            _loc2_.put(_loc3_,this.wrapASField(param1[_loc3_]));
         }
         return _loc2_;
      }
      
      public function sfs2as(param1:ISFSObject) : *
      {
         var _loc2_:* = undefined;
         if(!param1.containsKey(CLASS_MARKER_KEY) && !param1.containsKey(CLASS_FIELDS_KEY))
         {
            throw new SFSCodecError("The SFSObject passed does not represent any serialized class.");
         }
         var _loc3_:String = param1.getUtfString(CLASS_MARKER_KEY);
         var _loc4_:Class;
         _loc2_ = new (_loc4_ = ClassUtils.forName(_loc3_))();
         if(!(_loc2_ is SerializableSFSType))
         {
            throw new SFSCodecError("Cannot deserialize object: " + _loc2_ + ", type: " + _loc3_ + " -- It doesn\'t implement the SerializableSFSType interface");
         }
         this.convertSFSObject(param1.getSFSArray(CLASS_FIELDS_KEY),_loc2_);
         return _loc2_;
      }
      
      private function convertSFSObject(param1:ISFSArray, param2:*) : void
      {
         var _loc3_:ISFSObject = null;
         var _loc4_:String = null;
         var _loc5_:* = undefined;
         var _loc6_:int = 0;
         while(_loc6_ < param1.size())
         {
            _loc3_ = param1.getSFSObject(_loc6_);
            _loc4_ = _loc3_.getUtfString(FIELD_NAME_KEY);
            _loc5_ = this.unwrapAsField(_loc3_.getData(FIELD_VALUE_KEY));
            param2[_loc4_] = _loc5_;
            _loc6_++;
         }
      }
      
      private function unwrapAsField(param1:SFSDataWrapper) : *
      {
         var _loc2_:* = undefined;
         var _loc3_:int = param1.type;
         if(_loc3_ <= SFSDataType.UTF_STRING)
         {
            _loc2_ = param1.data;
         }
         else if(_loc3_ == SFSDataType.SFS_ARRAY)
         {
            _loc2_ = this.rebuildArray(param1.data as ISFSArray);
         }
         else if(_loc3_ == SFSDataType.SFS_OBJECT)
         {
            _loc2_ = this.rebuildDict(param1.data as ISFSObject);
         }
         else if(_loc3_ == SFSDataType.CLASS)
         {
            _loc2_ = param1.data;
         }
         return _loc2_;
      }
      
      private function rebuildArray(param1:ISFSArray) : Array
      {
         var _loc2_:Array = [];
         var _loc3_:int = 0;
         while(_loc3_ < param1.size())
         {
            _loc2_.push(this.unwrapAsField(param1.getWrappedElementAt(_loc3_)));
            _loc3_++;
         }
         return _loc2_;
      }
      
      private function rebuildDict(param1:ISFSObject) : Object
      {
         var _loc3_:String = null;
         var _loc2_:Object = {};
         for each(_loc3_ in param1.getKeys())
         {
            _loc2_[_loc3_] = this.unwrapAsField(param1.getData(_loc3_));
         }
         return _loc2_;
      }
      
      public function genericObjectToSFSObject(param1:Object, param2:Boolean = false) : SFSObject
      {
         var _loc3_:SFSObject = new SFSObject();
         this._scanGenericObject(param1,_loc3_,param2);
         return _loc3_;
      }
      
      private function _scanGenericObject(param1:Object, param2:ISFSObject, param3:Boolean = false) : void
      {
         var _loc4_:String = null;
         var _loc5_:* = undefined;
         var _loc6_:ISFSObject = null;
         for(_loc4_ in param1)
         {
            if((_loc5_ = param1[_loc4_]) == null)
            {
               param2.putNull(_loc4_);
            }
            else if(_loc5_.toString() == "[object Object]" && !(_loc5_ is Array))
            {
               _loc6_ = new SFSObject();
               param2.putSFSObject(_loc4_,_loc6_);
               this._scanGenericObject(_loc5_,_loc6_,param3);
            }
            else if(_loc5_ is Array)
            {
               param2.putSFSArray(_loc4_,this.genericArrayToSFSArray(_loc5_,param3));
            }
            else if(_loc5_ is Boolean)
            {
               param2.putBool(_loc4_,_loc5_);
            }
            else if(_loc5_ is int && !param3)
            {
               param2.putInt(_loc4_,_loc5_);
            }
            else if(_loc5_ is Number)
            {
               param2.putDouble(_loc4_,_loc5_);
            }
            else if(_loc5_ is String)
            {
               param2.putUtfString(_loc4_,_loc5_);
            }
         }
      }
      
      public function sfsObjectToGenericObject(param1:ISFSObject) : Object
      {
         var _loc2_:Object = {};
         this._scanSFSObject(param1,_loc2_);
         return _loc2_;
      }
      
      private function _scanSFSObject(param1:ISFSObject, param2:Object) : void
      {
         var _loc4_:String = null;
         var _loc5_:SFSDataWrapper = null;
         var _loc6_:Object = null;
         var _loc3_:Array = param1.getKeys();
         for each(_loc4_ in _loc3_)
         {
            if((_loc5_ = param1.getData(_loc4_)).type == SFSDataType.NULL)
            {
               param2[_loc4_] = null;
            }
            else if(_loc5_.type == SFSDataType.SFS_OBJECT)
            {
               _loc6_ = {};
               param2[_loc4_] = _loc6_;
               this._scanSFSObject(_loc5_.data as ISFSObject,_loc6_);
            }
            else if(_loc5_.type == SFSDataType.SFS_ARRAY)
            {
               param2[_loc4_] = (_loc5_.data as SFSArray).toArray();
            }
            else if(_loc5_.type != SFSDataType.CLASS)
            {
               param2[_loc4_] = _loc5_.data;
            }
         }
      }
      
      public function genericArrayToSFSArray(param1:Array, param2:Boolean = false) : SFSArray
      {
         var _loc3_:SFSArray = new SFSArray();
         this._scanGenericArray(param1,_loc3_,param2);
         return _loc3_;
      }
      
      private function _scanGenericArray(param1:Array, param2:ISFSArray, param3:Boolean = false) : void
      {
         var _loc5_:* = undefined;
         var _loc6_:ISFSArray = null;
         var _loc4_:int = 0;
         while(_loc4_ < param1.length)
         {
            if((_loc5_ = param1[_loc4_]) == null)
            {
               param2.addNull();
            }
            else if(_loc5_.toString() == "[object Object]" && !(_loc5_ is Array))
            {
               param2.addSFSObject(this.genericObjectToSFSObject(_loc5_,param3));
            }
            else if(_loc5_ is Array)
            {
               _loc6_ = new SFSArray();
               param2.addSFSArray(_loc6_);
               this._scanGenericArray(_loc5_,_loc6_,param3);
            }
            else if(_loc5_ is Boolean)
            {
               param2.addBool(_loc5_);
            }
            else if(_loc5_ is int && !param3)
            {
               param2.addInt(_loc5_);
            }
            else if(_loc5_ is Number)
            {
               param2.addDouble(_loc5_);
            }
            else if(_loc5_ is String)
            {
               param2.addUtfString(_loc5_);
            }
            _loc4_++;
         }
      }
      
      public function sfsArrayToGenericArray(param1:ISFSArray) : Array
      {
         var _loc2_:Array = [];
         this._scanSFSArray(param1,_loc2_);
         return _loc2_;
      }
      
      private function _scanSFSArray(param1:ISFSArray, param2:Array) : void
      {
         var _loc4_:SFSDataWrapper = null;
         var _loc5_:Array = null;
         var _loc3_:int = 0;
         while(_loc3_ < param1.size())
         {
            if((_loc4_ = param1.getWrappedElementAt(_loc3_)).type == SFSDataType.NULL)
            {
               param2[_loc3_] = null;
            }
            else if(_loc4_.type == SFSDataType.SFS_OBJECT)
            {
               param2[_loc3_] = (_loc4_.data as SFSObject).toObject();
            }
            else if(_loc4_.type == SFSDataType.SFS_ARRAY)
            {
               _loc5_ = [];
               param2[_loc3_] = _loc5_;
               this._scanSFSArray(_loc4_.data as ISFSArray,_loc5_);
            }
            else if(_loc4_.type != SFSDataType.CLASS)
            {
               param2[_loc3_] = _loc4_.data;
            }
            _loc3_++;
         }
      }
   }
}
