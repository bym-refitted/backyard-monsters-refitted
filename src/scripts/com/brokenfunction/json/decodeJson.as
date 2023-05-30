package com.brokenfunction.json
{
   public const decodeJson:Function = initDecodeJson();
}

function initDecodeJson():Function
{
   var i:int;
   var parseStringEscaped:Function;
   var position:uint = 0;
   var byteInput:ByteArray = null;
   var char:uint = 0;
   var charConvert:ByteArray = null;
   var isNumberChar:ByteArray = null;
   var stringHelper:ByteArray = null;
   var isWhitespace:ByteArray = null;
   var parseNumber:Function = null;
   var parseWhitespace:Function = null;
   var parse:Object = null;
   charConvert = new ByteArray();
   charConvert.length = 256;
   var _loc2_:* = 34;
   charConvert[_loc2_] = _loc2_;
   _loc2_;
   _loc2_ = 92;
   charConvert[_loc2_] = _loc2_;
   _loc2_;
   _loc2_ = 47;
   charConvert[_loc2_] = _loc2_;
   _loc2_;
   charConvert[98] = 8;
   charConvert[102] = 12;
   charConvert[110] = 10;
   charConvert[114] = 13;
   charConvert[116] = 9;
   isNumberChar = new ByteArray();
   isNumberChar.length = 256;
   isNumberChar[43] = 1;
   isNumberChar[45] = 1;
   isNumberChar[46] = 1;
   isNumberChar[48] = 1;
   isNumberChar[49] = 1;
   isNumberChar[50] = 1;
   isNumberChar[51] = 1;
   isNumberChar[52] = 1;
   isNumberChar[53] = 1;
   isNumberChar[54] = 1;
   isNumberChar[55] = 1;
   isNumberChar[56] = 1;
   isNumberChar[57] = 1;
   isNumberChar[69] = 1;
   isNumberChar[101] = 1;
   stringHelper = new ByteArray();
   stringHelper.length = 256;
   i = 0;
   while(i < 256)
   {
      _loc2_ = i++;
      stringHelper[_loc2_] = 1;
   }
   stringHelper[34] = 0;
   stringHelper[92] = 0;
   isWhitespace = new ByteArray();
   isWhitespace.length = 256;
   isWhitespace[9] = 1;
   isWhitespace[10] = 1;
   isWhitespace[13] = 1;
   isWhitespace[32] = 1;
   parseNumber = function():Number
   {
      if(position === 1)
      {
         byteInput.position = 0;
         return parseFloat(byteInput.readUTFBytes(byteInput.length));
      }
      byteInput.position = position - 1;
      while(isNumberChar[byteInput[position++]])
      {
      }
      return Number(byteInput.readUTFBytes(position-- - byteInput.position - 1));
   };
   parseWhitespace = function():Object
   {
      while(isWhitespace[byteInput[position]])
      {
         position++;
      }
      return parse[byteInput[position++]]();
   };
   parseStringEscaped = function(param1:String):String
   {
      while(true)
      {
         if((char = byteInput[position++]) === 117)
         {
            byteInput.position = position;
            char = parseInt(byteInput.readUTFBytes(4),16);
            position = position + 4;
         }
         else
         {
            if(!(char = charConvert[char]))
            {
               break;
            }
            byteInput.position = position;
         }
         param1 = param1 + String.fromCharCode(char);
         while(stringHelper[byteInput[position++]])
         {
         }
         if(position - 1 > byteInput.position)
         {
            param1 = param1 + byteInput.readUTFBytes(position - 1 - byteInput.position);
         }
         if(byteInput[position - 1] !== 92)
         {
            return param1;
         }
      }
      throw new Error("Unknown escaped character encountered at position " + (position - 1));
   };
   parse = {
      34:function():String
      {
         if(stringHelper[byteInput[position++]])
         {
            byteInput.position = position - 1;
            while(stringHelper[byteInput[position++]])
            {
            }
            if(byteInput[position - 1] === 92)
            {
               return parseStringEscaped(byteInput.readUTFBytes(position - 1 - byteInput.position));
            }
            return byteInput.readUTFBytes(position - 1 - byteInput.position);
         }
         if(byteInput[position - 1] === 92)
         {
            return parseStringEscaped("");
         }
         return "";
      },
      123:function():Object
      {
         var _loc2_:* = undefined;
         while(isWhitespace[byteInput[position]])
         {
            position++;
         }
         if(byteInput[position] === 125)
         {
            position++;
            return {};
         }
         var _loc1_:* = {};
         while(true)
         {
            do
            {
               _loc2_ = parse[byteInput[position++]]();
               if(byteInput[position] !== 58)
               {
                  while(isWhitespace[byteInput[position]])
                  {
                     position++;
                  }
                  if(byteInput[position++] !== 58)
                  {
                     throw new Error("Expected : at " + (position - 1));
                  }
               }
               else
               {
                  position++;
               }
               _loc1_[_loc2_] = parse[byteInput[position++]]();
            }
            while(byteInput[position++] === 44);
            
            if(byteInput[position - 1] === 125)
            {
               break;
            }
            while(isWhitespace[byteInput[position]])
            {
               position++;
            }
            if(byteInput[position++] !== 44)
            {
               if(byteInput[position - 1] !== 125)
               {
                  throw new Error("Expected , or } at " + (position - 1));
               }
               return _loc1_;
            }
         }
         return _loc1_;
      },
      91:function():Object
      {
         while(isWhitespace[byteInput[position]])
         {
            position++;
         }
         if(byteInput[position] === 93)
         {
            position++;
            return [];
         }
         var _loc1_:* = [];
         while(true)
         {
            do
            {
               _loc1_[_loc1_.length] = parse[byteInput[position++]]();
            }
            while(byteInput[position++] === 44);
            
            if(byteInput[position - 1] === 93)
            {
               break;
            }
            position--;
            while(isWhitespace[byteInput[position]])
            {
               position++;
            }
            if(byteInput[position++] !== 44)
            {
               if(byteInput[position - 1] !== 93)
               {
                  throw new Error("Expected , or ] at " + (position - 1));
               }
               return _loc1_;
            }
         }
         return _loc1_;
      },
      116:function():Boolean
      {
         if(byteInput[position] === 114 && byteInput[position + 1] === 117 && byteInput[position + 2] === 101)
         {
            position = position + 3;
            return true;
         }
         throw new Error("Expected \"true\" at position " + position);
      },
      102:function():Boolean
      {
         if(byteInput[position] === 97 && byteInput[position + 1] === 108 && byteInput[position + 2] === 115 && byteInput[position + 3] === 101)
         {
            position = position + 4;
            return false;
         }
         throw new Error("Expected \"false\" at position " + (position - 1));
      },
      110:function():Object
      {
         if(byteInput[position] === 117 && byteInput[position + 1] === 108 && byteInput[position + 2] === 108)
         {
            position = position + 3;
            return null;
         }
         throw new Error("Expected \"null\" at position " + position);
      },
      93:function():void
      {
         throw new Error("Unexpected end of array at " + position);
      },
      125:function():void
      {
         throw new Error("Unexpected end of object at " + position);
      },
      44:function():void
      {
         throw new Error("Unexpected comma at " + position);
      },
      45:parseNumber,
      48:parseNumber,
      49:parseNumber,
      50:parseNumber,
      51:parseNumber,
      52:parseNumber,
      53:parseNumber,
      54:parseNumber,
      55:parseNumber,
      56:parseNumber,
      57:parseNumber,
      13:parseWhitespace,
      10:parseWhitespace,
      9:parseWhitespace,
      32:parseWhitespace
   };
   return function(param1:*):Object
   {
      var input:* = param1;
      if(input is String)
      {
         byteInput = new ByteArray();
         byteInput.writeUTFBytes(input as String);
      }
      else
      {
         if(!(input is ByteArray))
         {
            throw new Error("Unexpected input <" + input + ">");
         }
         byteInput = input as ByteArray;
      }
      position = 0;
      try
      {
         return parse[byteInput[position++]]();
      }
      catch(e:TypeError)
      {
         if(position - 1 < byteInput.length)
         {
            e.message = "Unexpected character " + String.fromCharCode(byteInput[position - 1]) + " (0x" + byteInput[position - 1].toString(16) + ")" + " at position " + (position - 1) + " (" + e.message + ")";
         }
         throw e;
      }
   };
}