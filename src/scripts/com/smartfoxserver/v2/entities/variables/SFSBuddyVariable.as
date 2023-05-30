package com.smartfoxserver.v2.entities.variables
{
   import as3reflect.Type;
   import com.smartfoxserver.v2.entities.data.ISFSArray;
   import com.smartfoxserver.v2.entities.data.ISFSObject;
   import com.smartfoxserver.v2.entities.data.SFSArray;
   import com.smartfoxserver.v2.exceptions.SFSError;
   
   public class SFSBuddyVariable implements BuddyVariable
   {
      
      public static const OFFLINE_PREFIX:String = "$";
       
      
      protected var _name:String;
      
      protected var _type:String;
      
      protected var _value;
      
      public function SFSBuddyVariable(param1:String, param2:*, param3:int = -1)
      {
         super();
         this._name = param1;
         if(param3 > -1)
         {
            this._value = param2;
            this._type = VariableType.getTypeName(param3);
         }
         else
         {
            this.setValue(param2);
         }
      }
      
      public static function fromSFSArray(param1:ISFSArray) : BuddyVariable
      {
         return new SFSBuddyVariable(param1.getUtfString(0),param1.getElementAt(2),param1.getByte(1));
      }
      
      public function get isOffline() : Boolean
      {
         return this._name.charAt(0) == "$";
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function get type() : String
      {
         return this._type;
      }
      
      public function getValue() : *
      {
         return this._value;
      }
      
      public function getBoolValue() : Boolean
      {
         return this._value as Boolean;
      }
      
      public function getIntValue() : int
      {
         return this._value as int;
      }
      
      public function getDoubleValue() : Number
      {
         return this._value as Number;
      }
      
      public function getStringValue() : String
      {
         return this._value as String;
      }
      
      public function getSFSObjectValue() : ISFSObject
      {
         return this._value as ISFSObject;
      }
      
      public function getSFSArrayValue() : ISFSArray
      {
         return this._value as ISFSArray;
      }
      
      public function isNull() : Boolean
      {
         return this.type == VariableType.getTypeName(VariableType.NULL);
      }
      
      public function toSFSArray() : ISFSArray
      {
         var _loc1_:ISFSArray = SFSArray.newInstance();
         _loc1_.addUtfString(this._name);
         _loc1_.addByte(VariableType.getTypeFromName(this._type));
         this.populateArrayWithValue(_loc1_);
         return _loc1_;
      }
      
      public function toString() : String
      {
         return "[BuddyVar: " + this._name + ", type: " + this._type + ", value: " + this._value + "]";
      }
      
      private function populateArrayWithValue(param1:ISFSArray) : void
      {
         var _loc2_:int = VariableType.getTypeFromName(this._type);
         switch(_loc2_)
         {
            case VariableType.NULL:
               param1.addNull();
               break;
            case VariableType.BOOL:
               param1.addBool(this.getBoolValue());
               break;
            case VariableType.INT:
               param1.addInt(this.getIntValue());
               break;
            case VariableType.DOUBLE:
               param1.addDouble(this.getDoubleValue());
               break;
            case VariableType.STRING:
               param1.addUtfString(this.getStringValue());
               break;
            case VariableType.OBJECT:
               param1.addSFSObject(this.getSFSObjectValue());
               break;
            case VariableType.ARRAY:
               param1.addSFSArray(this.getSFSArrayValue());
         }
      }
      
      private function setValue(param1:*) : void
      {
         var _loc2_:* = null;
         var _loc3_:String = null;
         this._value = param1;
         if(param1 == null)
         {
            this._type = VariableType.getTypeName(VariableType.NULL);
         }
         else
         {
            _loc2_ = typeof param1;
            if(_loc2_ == "boolean")
            {
               this._type = VariableType.getTypeName(VariableType.BOOL);
            }
            else if(_loc2_ == "number")
            {
               if(int(param1) == param1)
               {
                  this._type = VariableType.getTypeName(VariableType.INT);
               }
               else
               {
                  this._type = VariableType.getTypeName(VariableType.DOUBLE);
               }
            }
            else if(_loc2_ == "string")
            {
               this._type = VariableType.getTypeName(VariableType.STRING);
            }
            else if(_loc2_ == "object")
            {
               _loc3_ = Type.forInstance(param1).name;
               if(_loc3_ == "SFSObject")
               {
                  this._type = VariableType.getTypeName(VariableType.OBJECT);
               }
               else
               {
                  if(_loc3_ != "SFSArray")
                  {
                     throw new SFSError("Unsupport SFS Variable type: " + _loc3_);
                  }
                  this._type = VariableType.getTypeName(VariableType.ARRAY);
               }
            }
         }
      }
   }
}
