package com.smartfoxserver.v2.protocol.serialization
{
   import com.smartfoxserver.v2.exceptions.SFSError;
   import flash.utils.ByteArray;
   
   public class DefaultObjectDumpFormatter
   {
      
      public static const TOKEN_INDENT_OPEN:String = "{";
      
      public static const TOKEN_INDENT_CLOSE:String = "}";
      
      public static const TOKEN_DIVIDER:String = ";";
      
      public static const NEW_LINE:String = "\n";
      
      public static const TAB:String = "\t";
      
      public static const DOT:String = ".";
      
      public static const HEX_BYTES_PER_LINE:int = 16;
       
      
      public function DefaultObjectDumpFormatter()
      {
         super();
      }
      
      public static function prettyPrintByteArray(param1:ByteArray) : String
      {
         if(param1 == null)
         {
            return "Null";
         }
         return "Byte[" + param1.length + "]";
      }
      
      public static function prettyPrintDump(param1:String) : String
      {
         var _loc6_:String = null;
         var _loc2_:String = "";
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         while(_loc5_ < param1.length)
         {
            if((_loc6_ = param1.charAt(_loc5_)) == TOKEN_INDENT_OPEN)
            {
               _loc3_++;
               _loc2_ += NEW_LINE + getFormatTabs(_loc3_);
            }
            else if(_loc6_ == TOKEN_INDENT_CLOSE)
            {
               _loc3_--;
               if(_loc3_ < 0)
               {
                  throw new SFSError("DumpFormatter: the indentPos is negative. TOKENS ARE NOT BALANCED!");
               }
               _loc2_ += NEW_LINE + getFormatTabs(_loc3_);
            }
            else if(_loc6_ == TOKEN_DIVIDER)
            {
               _loc2_ += NEW_LINE + getFormatTabs(_loc3_);
            }
            else
            {
               _loc2_ += _loc6_;
            }
            _loc5_++;
         }
         if(_loc3_ != 0)
         {
            throw new SFSError("DumpFormatter: the indentPos is not == 0. TOKENS ARE NOT BALANCED!");
         }
         return _loc2_;
      }
      
      private static function getFormatTabs(param1:int) : String
      {
         return strFill(TAB,param1);
      }
      
      private static function strFill(param1:String, param2:int) : String
      {
         var _loc3_:String = "";
         var _loc4_:int = 0;
         while(_loc4_ < param2)
         {
            _loc3_ += param1;
            _loc4_++;
         }
         return _loc3_;
      }
      
      public static function hexDump(param1:ByteArray, param2:int = -1) : String
      {
         var _loc9_:String = null;
         var _loc10_:* = 0;
         var _loc11_:String = null;
         var _loc12_:int = 0;
         var _loc3_:int = int(param1.position);
         param1.position = 0;
         if(param2 == -1)
         {
            param2 = HEX_BYTES_PER_LINE;
         }
         var _loc4_:String = "Binary Size: " + param1.length + NEW_LINE;
         var _loc5_:* = "";
         var _loc6_:* = "";
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         do
         {
            if((_loc11_ = (_loc10_ = param1.readByte() & 255).toString(16).toUpperCase()).length == 1)
            {
               _loc11_ = "0" + _loc11_;
            }
            _loc5_ += _loc11_ + " ";
            if(_loc10_ >= 33 && _loc10_ <= 126)
            {
               _loc9_ = String.fromCharCode(_loc10_);
            }
            else
            {
               _loc9_ = DOT;
            }
            _loc6_ += _loc9_;
            if(++_loc8_ == param2)
            {
               _loc8_ = 0;
               _loc4_ += _loc5_ + TAB + _loc6_ + NEW_LINE;
               _loc5_ = "";
               _loc6_ = "";
            }
         }
         while(++_loc7_ < param1.length);
         
         if(_loc8_ != 0)
         {
            _loc12_ = param2 - _loc8_;
            while(_loc12_ > 0)
            {
               _loc5_ += "   ";
               _loc6_ += " ";
               _loc12_--;
            }
            _loc4_ += _loc5_ + TAB + _loc6_ + NEW_LINE;
         }
         param1.position = _loc3_;
         return _loc4_;
      }
   }
}
