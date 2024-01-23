package com.hurlant.util
{
   import flash.utils.ByteArray;
   
   public class Base64
   {
      
      public static const version:String = "1.0.0";
      
      private static const BASE64_CHARS:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
       
      
      public function Base64()
      {
         super();
         throw new Error("Base64 class is static container only");
      }
      
      public static function encode(param1:String) : String
      {
         var _loc2_:ByteArray = null;
         _loc2_ = new ByteArray();
         _loc2_.writeUTFBytes(param1);
         return encodeByteArray(_loc2_);
      }
      
      public static function encodeByteArray(param1:ByteArray) : String
      {
         var _loc2_:String = null;
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         _loc2_ = "";
         _loc4_ = new Array(4);
         param1.position = 0;
         while(param1.bytesAvailable > 0)
         {
            _loc3_ = new Array();
            _loc5_ = 0;
            while(_loc5_ < 3 && param1.bytesAvailable > 0)
            {
               _loc3_[_loc5_] = param1.readUnsignedByte();
               _loc5_++;
            }
            _loc4_[0] = (_loc3_[0] & 252) >> 2;
            _loc4_[1] = (_loc3_[0] & 3) << 4 | _loc3_[1] >> 4;
            _loc4_[2] = (_loc3_[1] & 15) << 2 | _loc3_[2] >> 6;
            _loc4_[3] = _loc3_[2] & 63;
            _loc6_ = _loc3_.length;
            while(_loc6_ < 3)
            {
               _loc4_[_loc6_ + 1] = 64;
               _loc6_++;
            }
            _loc7_ = 0;
            while(_loc7_ < _loc4_.length)
            {
               _loc2_ += BASE64_CHARS.charAt(_loc4_[_loc7_]);
               _loc7_++;
            }
         }
         return _loc2_;
      }
      
      public static function decode(param1:String) : String
      {
         var _loc2_:ByteArray = null;
         _loc2_ = decodeToByteArray(param1);
         return _loc2_.readUTFBytes(_loc2_.length);
      }
      
      public static function decodeToByteArray(param1:String) : ByteArray
      {
         var _loc2_:ByteArray = null;
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         _loc2_ = new ByteArray();
         _loc3_ = new Array(4);
         _loc4_ = new Array(3);
         _loc5_ = 0;
         while(_loc5_ < param1.length)
         {
            _loc6_ = 0;
            while(_loc6_ < 4 && _loc5_ + _loc6_ < param1.length)
            {
               _loc3_[_loc6_] = BASE64_CHARS.indexOf(param1.charAt(_loc5_ + _loc6_));
               _loc6_++;
            }
            _loc4_[0] = (_loc3_[0] << 2) + ((_loc3_[1] & 48) >> 4);
            _loc4_[1] = ((_loc3_[1] & 15) << 4) + ((_loc3_[2] & 60) >> 2);
            _loc4_[2] = ((_loc3_[2] & 3) << 6) + _loc3_[3];
            _loc7_ = 0;
            while(_loc7_ < _loc4_.length)
            {
               if(_loc3_[_loc7_ + 1] == 64)
               {
                  break;
               }
               _loc2_.writeByte(_loc4_[_loc7_]);
               _loc7_++;
            }
            _loc5_ += 4;
         }
         _loc2_.position = 0;
         return _loc2_;
      }
   }
}
