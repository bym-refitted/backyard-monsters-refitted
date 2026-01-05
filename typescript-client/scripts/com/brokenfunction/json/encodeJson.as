package com.brokenfunction.json
{
   public const encodeJson:Function = initDecodeJson();
}

import flash.utils.IDataOutput;
import flash.utils.ByteArray;

function initDecodeJson():Function
{
   var parseArray:Function;
   var result:IDataOutput = null;
   var i:int = 0;
   var j:int = 0;
   var strLen:int = 0;
   var str:String = null;
   var char:int = 0;
   var tempBytes:ByteArray = null;
   var blockNonFiniteNumbers:Boolean = false;
   var charConvert:Array = null;
   var parseString:Function = null;
   var parse:Object = null;
   tempBytes = new ByteArray();
   charConvert = new Array(256);
   j = 0;
   while(j < 10)
   {
      charConvert[j] = j + 48 | 808464384;
      j++;
   }
   while(j < 16)
   {
      charConvert[j] = j + 55 | 808464384;
      j++;
   }
   while(j < 26)
   {
      charConvert[j] = j + 32 | 808464640;
      j++;
   }
   while(j < 32)
   {
      charConvert[j] = j + 39 | 808464640;
      j++;
   }
   while(j < 256)
   {
      charConvert[j] = j;
      j++;
   }
   charConvert[10] = 23662;
   charConvert[13] = 23666;
   charConvert[9] = 23668;
   charConvert[8] = 23650;
   charConvert[12] = 23654;
   charConvert[8] = 23650;
   charConvert[34] = 23586;
   charConvert[92] = 23644;
   charConvert[127] = 808466246;
   parseArray = function(param1:Array):void
   {
      result.writeByte(91);
      var _loc2_:int = 0;
      var _loc3_:int = int(param1.length - 1);
      if(_loc3_ >= 0)
      {
         while(_loc2_ < _loc3_)
         {
            parse[typeof param1[_loc2_]](param1[_loc2_]);
            result.writeByte(44);
            _loc2_++;
         }
         parse[typeof param1[_loc2_]](param1[_loc2_]);
      }
      result.writeByte(93);
   };
   parseString = function(param1:String):void
   {
      result.writeByte(34);
      tempBytes.position = 0;
      tempBytes.length = 0;
      tempBytes.writeUTFBytes(param1);
      i = 0;
      j = 0;
      strLen = tempBytes.length;
      while(j < strLen)
      {
         char = charConvert[tempBytes[j++]];
         if(char > 256)
         {
            if(j - 1 > i)
            {
               result.writeBytes(tempBytes,i,j - 1 - i);
            }
            if(char > 65536)
            {
               result.writeShort(23669);
               result.writeUnsignedInt(char);
            }
            else
            {
               result.writeShort(char);
            }
            i = j;
         }
      }
      if(strLen > i)
      {
         result.writeBytes(tempBytes,i,strLen - i);
      }
      result.writeByte(34);
   };
   parse = {
      "object":function(param1:Object):void
      {
         var _loc2_:* = undefined;
         if(param1)
         {
            if(param1 is Array)
            {
               parseArray(param1);
            }
            else
            {
               result.writeByte(123);
               _loc2_ = true;
               for(var _loc5_ in param1)
               {
                  str = _loc5_;
                  _loc5_;
                  if(_loc2_)
                  {
                     _loc2_ = false;
                  }
                  else
                  {
                     result.writeByte(44);
                  }
                  parseString(str);
                  result.writeByte(58);
                  parse[typeof param1[str]](param1[str]);
               }
               result.writeByte(125);
            }
         }
         else
         {
            result.writeUnsignedInt(1853189228);
         }
      },
      "string":parseString,
      "number":function(param1:Number):void
      {
         if(blockNonFiniteNumbers && !isFinite(param1))
         {
            throw new Error("Number " + param1 + " is not encodable");
         }
         result.writeUTFBytes(String(param1));
      },
      "boolean":function(param1:Boolean):void
      {
         if(param1)
         {
            result.writeUnsignedInt(1953658213);
         }
         else
         {
            result.writeByte(102);
            result.writeUnsignedInt(1634497381);
         }
      },
      "xml":function(param1:Object):void
      {
         if(!param1.toXMLString is Function || (param1 = param1.toXMLString() as String) == null)
         {
            throw new Error("unserializable XML object encountered");
         }
         parseString(param1);
      },
      "undefined":function(param1:Boolean):void
      {
         result.writeUnsignedInt(1853189228);
      }
   };
   return function(param1:Object, param2:IDataOutput = null, param3:Boolean = false):String
   {
      var byteOutput:* = undefined;
      var input:Object = param1;
      var writeTo:IDataOutput = param2;
      var strictNumberSupport:Boolean = param3;
      blockNonFiniteNumbers = strictNumberSupport;
      try
      {
         if(writeTo)
         {
            result = writeTo;
            result.endian = "bigEndian";
            parse[typeof input](input);
            byteOutput.position = 0;
            return byteOutput.readUTFBytes(byteOutput.length);
         }
         switch(typeof input)
         {
            case "xml":
               if(!input.toXMLString is Function || (input = input.toXMLString() as String) == null)
               {
                  throw new Error("unserializable XML object encountered");
               }
               break;
            case "object":
            case "string":
               break;
            case "number":
               if(blockNonFiniteNumbers && !isFinite(input as Number))
               {
                  throw new Error("Number " + input + " is not encodable");
               }
               return String(input);
               break;
            case "boolean":
               return !!input ? "true" : "false";
            case "undefined":
               return "null";
            default:
               throw new Error("Unexpected type \"" + typeof input + "\" encountered");
         }
         result = byteOutput = new ByteArray();
         result.endian = "bigEndian";
         parse[typeof input](input);
         byteOutput.position = 0;
         return byteOutput.readUTFBytes(byteOutput.length);
      }
      catch(e:TypeError)
      {
         throw new Error("Unexpected type encountered");
      }
   };
}