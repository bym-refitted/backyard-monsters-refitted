
{
   leadingZeros[0] = "";
   leadingZeros[1] = "0";
   leadingZeros[2] = "00";
   leadingZeros[3] = "000";
   leadingZeros[4] = "0000";
   leadingZeros[5] = "00000";
   leadingZeros[6] = "000000";
   return leadingZeros[7] = "0000000";
}

package
{
   import flash.utils.ByteArray;
   
   public function md5(param1:Object) : String
   {
      var _loc2_:ByteArray = null;
      var _loc3_:int = 0;
      var _loc4_:int = 0;
      var _loc5_:int = 0;
      var _loc6_:int = 0;
      var _loc7_:int = 0;
      var _loc8_:int = 0;
      var _loc15_:int = 0;
      var _loc16_:int = 0;
      var _loc17_:int = 0;
      var _loc18_:int = 0;
      var _loc19_:int = 0;
      var _loc20_:int = 0;
      var _loc21_:int = 0;
      var _loc22_:int = 0;
      var _loc23_:int = 0;
      var _loc24_:int = 0;
      var _loc25_:int = 0;
      var _loc26_:int = 0;
      var _loc27_:int = 0;
      var _loc28_:int = 0;
      var _loc29_:int = 0;
      var _loc30_:int = 0;
      if(param1 is String)
      {
         _loc2_ = new ByteArray();
         (_loc2_ as ByteArray).writeUTFBytes(param1 as String);
      }
      else
      {
         if(!(param1 is ByteArray))
         {
            throw new Error("Input is not String or ByteArray");
         }
         _loc2_ = param1 as ByteArray;
      }
      _loc2_.endian = "littleEndian";
      var _loc9_:* = 1732584193;
      var _loc10_:* = -271733879;
      var _loc11_:* = -1732584194;
      var _loc12_:* = 271733878;
      var _loc13_:uint = _loc2_.length;
      _loc8_ = _loc2_.length = _loc13_ + 72 - (_loc13_ + 8 & 63);
      _loc2_[_loc13_] = 128;
      _loc2_.position = _loc8_ - 8;
      _loc2_.writeUnsignedInt(_loc13_ << 3);
      _loc2_.writeUnsignedInt(_loc13_ >>> 29);
      _loc2_.position = 0;
      do
      {
         _loc3_ = _loc9_;
         _loc4_ = _loc10_;
         _loc5_ = _loc11_;
         _loc6_ = _loc12_;
         _loc15_ = _loc2_.readInt();
         _loc7_ = _loc3_ + (_loc4_ & _loc5_ | ~_loc4_ & _loc6_) - 680876936 + _loc15_;
         _loc3_ = _loc4_ + (_loc7_ << 7 | _loc7_ >>> 25);
         _loc16_ = _loc2_.readInt();
         _loc7_ = _loc6_ + (_loc3_ & _loc4_ | ~_loc3_ & _loc5_) - 389564586 + _loc16_;
         _loc6_ = _loc3_ + (_loc7_ << 12 | _loc7_ >>> 20);
         _loc17_ = _loc2_.readInt();
         _loc7_ = _loc5_ + (_loc6_ & _loc3_ | ~_loc6_ & _loc4_) + 606105819 + _loc17_;
         _loc5_ = _loc6_ + (_loc7_ << 17 | _loc7_ >>> 15);
         _loc18_ = _loc2_.readInt();
         _loc7_ = _loc4_ + (_loc5_ & _loc6_ | ~_loc5_ & _loc3_) - 1044525330 + _loc18_;
         _loc4_ = _loc5_ + (_loc7_ << 22 | _loc7_ >>> 10);
         _loc19_ = _loc2_.readInt();
         _loc7_ = _loc3_ + (_loc4_ & _loc5_ | ~_loc4_ & _loc6_) - 176418897 + _loc19_;
         _loc3_ = _loc4_ + (_loc7_ << 7 | _loc7_ >>> 25);
         _loc20_ = _loc2_.readInt();
         _loc7_ = _loc6_ + (_loc3_ & _loc4_ | ~_loc3_ & _loc5_) + 1200080426 + _loc20_;
         _loc6_ = _loc3_ + (_loc7_ << 12 | _loc7_ >>> 20);
         _loc21_ = _loc2_.readInt();
         _loc7_ = _loc5_ + (_loc6_ & _loc3_ | ~_loc6_ & _loc4_) - 1473231341 + _loc21_;
         _loc5_ = _loc6_ + (_loc7_ << 17 | _loc7_ >>> 15);
         _loc22_ = _loc2_.readInt();
         _loc7_ = _loc4_ + (_loc5_ & _loc6_ | ~_loc5_ & _loc3_) - 45705983 + _loc22_;
         _loc4_ = _loc5_ + (_loc7_ << 22 | _loc7_ >>> 10);
         _loc23_ = _loc2_.readInt();
         _loc7_ = _loc3_ + (_loc4_ & _loc5_ | ~_loc4_ & _loc6_) + 1770035416 + _loc23_;
         _loc3_ = _loc4_ + (_loc7_ << 7 | _loc7_ >>> 25);
         _loc24_ = _loc2_.readInt();
         _loc7_ = _loc6_ + (_loc3_ & _loc4_ | ~_loc3_ & _loc5_) - 1958414417 + _loc24_;
         _loc6_ = _loc3_ + (_loc7_ << 12 | _loc7_ >>> 20);
         _loc25_ = _loc2_.readInt();
         _loc7_ = _loc5_ + (_loc6_ & _loc3_ | ~_loc6_ & _loc4_) - 42063 + _loc25_;
         _loc5_ = _loc6_ + (_loc7_ << 17 | _loc7_ >>> 15);
         _loc26_ = _loc2_.readInt();
         _loc7_ = _loc4_ + (_loc5_ & _loc6_ | ~_loc5_ & _loc3_) - 1990404162 + _loc26_;
         _loc4_ = _loc5_ + (_loc7_ << 22 | _loc7_ >>> 10);
         _loc27_ = _loc2_.readInt();
         _loc7_ = _loc3_ + (_loc4_ & _loc5_ | ~_loc4_ & _loc6_) + 1804603682 + _loc27_;
         _loc3_ = _loc4_ + (_loc7_ << 7 | _loc7_ >>> 25);
         _loc28_ = _loc2_.readInt();
         _loc7_ = _loc6_ + (_loc3_ & _loc4_ | ~_loc3_ & _loc5_) - 40341101 + _loc28_;
         _loc6_ = _loc3_ + (_loc7_ << 12 | _loc7_ >>> 20);
         _loc29_ = _loc2_.readInt();
         _loc7_ = _loc5_ + (_loc6_ & _loc3_ | ~_loc6_ & _loc4_) - 1502002290 + _loc29_;
         _loc5_ = _loc6_ + (_loc7_ << 17 | _loc7_ >>> 15);
         _loc30_ = _loc2_.readInt();
         _loc7_ = _loc4_ + (_loc5_ & _loc6_ | ~_loc5_ & _loc3_) + 1236535329 + _loc30_;
         _loc4_ = _loc5_ + (_loc7_ << 22 | _loc7_ >>> 10);
         _loc7_ = _loc3_ + (_loc6_ & _loc4_ | ~_loc6_ & _loc5_) - 165796510 + _loc16_;
         _loc3_ = _loc4_ + (_loc7_ << 5 | _loc7_ >>> 27);
         _loc7_ = _loc6_ + (_loc5_ & _loc3_ | ~_loc5_ & _loc4_) - 1069501632 + _loc21_;
         _loc6_ = _loc3_ + (_loc7_ << 9 | _loc7_ >>> 23);
         _loc7_ = _loc5_ + (_loc4_ & _loc6_ | ~_loc4_ & _loc3_) + 643717713 + _loc26_;
         _loc5_ = _loc6_ + (_loc7_ << 14 | _loc7_ >>> 18);
         _loc7_ = _loc4_ + (_loc3_ & _loc5_ | ~_loc3_ & _loc6_) - 373897302 + _loc15_;
         _loc4_ = _loc5_ + (_loc7_ << 20 | _loc7_ >>> 12);
         _loc7_ = _loc3_ + (_loc6_ & _loc4_ | ~_loc6_ & _loc5_) - 701558691 + _loc20_;
         _loc3_ = _loc4_ + (_loc7_ << 5 | _loc7_ >>> 27);
         _loc7_ = _loc6_ + (_loc5_ & _loc3_ | ~_loc5_ & _loc4_) + 38016083 + _loc25_;
         _loc6_ = _loc3_ + (_loc7_ << 9 | _loc7_ >>> 23);
         _loc7_ = _loc5_ + (_loc4_ & _loc6_ | ~_loc4_ & _loc3_) - 660478335 + _loc30_;
         _loc5_ = _loc6_ + (_loc7_ << 14 | _loc7_ >>> 18);
         _loc7_ = _loc4_ + (_loc3_ & _loc5_ | ~_loc3_ & _loc6_) - 405537848 + _loc19_;
         _loc4_ = _loc5_ + (_loc7_ << 20 | _loc7_ >>> 12);
         _loc7_ = _loc3_ + (_loc6_ & _loc4_ | ~_loc6_ & _loc5_) + 568446438 + _loc24_;
         _loc3_ = _loc4_ + (_loc7_ << 5 | _loc7_ >>> 27);
         _loc7_ = _loc6_ + (_loc5_ & _loc3_ | ~_loc5_ & _loc4_) - 1019803690 + _loc29_;
         _loc6_ = _loc3_ + (_loc7_ << 9 | _loc7_ >>> 23);
         _loc7_ = _loc5_ + (_loc4_ & _loc6_ | ~_loc4_ & _loc3_) - 187363961 + _loc18_;
         _loc5_ = _loc6_ + (_loc7_ << 14 | _loc7_ >>> 18);
         _loc7_ = _loc4_ + (_loc3_ & _loc5_ | ~_loc3_ & _loc6_) + 1163531501 + _loc23_;
         _loc4_ = _loc5_ + (_loc7_ << 20 | _loc7_ >>> 12);
         _loc7_ = _loc3_ + (_loc6_ & _loc4_ | ~_loc6_ & _loc5_) - 1444681467 + _loc28_;
         _loc3_ = _loc4_ + (_loc7_ << 5 | _loc7_ >>> 27);
         _loc7_ = _loc6_ + (_loc5_ & _loc3_ | ~_loc5_ & _loc4_) - 51403784 + _loc17_;
         _loc6_ = _loc3_ + (_loc7_ << 9 | _loc7_ >>> 23);
         _loc7_ = _loc5_ + (_loc4_ & _loc6_ | ~_loc4_ & _loc3_) + 1735328473 + _loc22_;
         _loc5_ = _loc6_ + (_loc7_ << 14 | _loc7_ >>> 18);
         _loc7_ = _loc4_ + (_loc3_ & _loc5_ | ~_loc3_ & _loc6_) - 1926607734 + _loc27_;
         _loc4_ = _loc5_ + (_loc7_ << 20 | _loc7_ >>> 12);
         _loc7_ = _loc3_ + (_loc4_ ^ _loc5_ ^ _loc6_) - 378558 + _loc20_;
         _loc3_ = _loc4_ + (_loc7_ << 4 | _loc7_ >>> 28);
         _loc7_ = _loc6_ + (_loc3_ ^ _loc4_ ^ _loc5_) - 2022574463 + _loc23_;
         _loc6_ = _loc3_ + (_loc7_ << 11 | _loc7_ >>> 21);
         _loc7_ = _loc5_ + (_loc6_ ^ _loc3_ ^ _loc4_) + 1839030562 + _loc26_;
         _loc5_ = _loc6_ + (_loc7_ << 16 | _loc7_ >>> 16);
         _loc7_ = _loc4_ + (_loc5_ ^ _loc6_ ^ _loc3_) - 35309556 + _loc29_;
         _loc4_ = _loc5_ + (_loc7_ << 23 | _loc7_ >>> 9);
         _loc7_ = _loc3_ + (_loc4_ ^ _loc5_ ^ _loc6_) - 1530992060 + _loc16_;
         _loc3_ = _loc4_ + (_loc7_ << 4 | _loc7_ >>> 28);
         _loc7_ = _loc6_ + (_loc3_ ^ _loc4_ ^ _loc5_) + 1272893353 + _loc19_;
         _loc6_ = _loc3_ + (_loc7_ << 11 | _loc7_ >>> 21);
         _loc7_ = _loc5_ + (_loc6_ ^ _loc3_ ^ _loc4_) - 155497632 + _loc22_;
         _loc5_ = _loc6_ + (_loc7_ << 16 | _loc7_ >>> 16);
         _loc7_ = _loc4_ + (_loc5_ ^ _loc6_ ^ _loc3_) - 1094730640 + _loc25_;
         _loc4_ = _loc5_ + (_loc7_ << 23 | _loc7_ >>> 9);
         _loc7_ = _loc3_ + (_loc4_ ^ _loc5_ ^ _loc6_) + 681279174 + _loc28_;
         _loc3_ = _loc4_ + (_loc7_ << 4 | _loc7_ >>> 28);
         _loc7_ = _loc6_ + (_loc3_ ^ _loc4_ ^ _loc5_) - 358537222 + _loc15_;
         _loc6_ = _loc3_ + (_loc7_ << 11 | _loc7_ >>> 21);
         _loc7_ = _loc5_ + (_loc6_ ^ _loc3_ ^ _loc4_) - 722521979 + _loc18_;
         _loc5_ = _loc6_ + (_loc7_ << 16 | _loc7_ >>> 16);
         _loc7_ = _loc4_ + (_loc5_ ^ _loc6_ ^ _loc3_) + 76029189 + _loc21_;
         _loc4_ = _loc5_ + (_loc7_ << 23 | _loc7_ >>> 9);
         _loc7_ = _loc3_ + (_loc4_ ^ _loc5_ ^ _loc6_) - 640364487 + _loc24_;
         _loc3_ = _loc4_ + (_loc7_ << 4 | _loc7_ >>> 28);
         _loc7_ = _loc6_ + (_loc3_ ^ _loc4_ ^ _loc5_) - 421815835 + _loc27_;
         _loc6_ = _loc3_ + (_loc7_ << 11 | _loc7_ >>> 21);
         _loc7_ = _loc5_ + (_loc6_ ^ _loc3_ ^ _loc4_) + 530742520 + _loc30_;
         _loc5_ = _loc6_ + (_loc7_ << 16 | _loc7_ >>> 16);
         _loc7_ = _loc4_ + (_loc5_ ^ _loc6_ ^ _loc3_) - 995338651 + _loc17_;
         _loc4_ = _loc5_ + (_loc7_ << 23 | _loc7_ >>> 9);
         _loc7_ = _loc3_ + (_loc5_ ^ (_loc4_ | ~_loc6_)) - 198630844 + _loc15_;
         _loc3_ = _loc4_ + (_loc7_ << 6 | _loc7_ >>> 26);
         _loc7_ = _loc6_ + (_loc4_ ^ (_loc3_ | ~_loc5_)) + 1126891415 + _loc22_;
         _loc6_ = _loc3_ + (_loc7_ << 10 | _loc7_ >>> 22);
         _loc7_ = _loc5_ + (_loc3_ ^ (_loc6_ | ~_loc4_)) - 1416354905 + _loc29_;
         _loc5_ = _loc6_ + (_loc7_ << 15 | _loc7_ >>> 17);
         _loc7_ = _loc4_ + (_loc6_ ^ (_loc5_ | ~_loc3_)) - 57434055 + _loc20_;
         _loc4_ = _loc5_ + (_loc7_ << 21 | _loc7_ >>> 11);
         _loc7_ = _loc3_ + (_loc5_ ^ (_loc4_ | ~_loc6_)) + 1700485571 + _loc27_;
         _loc3_ = _loc4_ + (_loc7_ << 6 | _loc7_ >>> 26);
         _loc7_ = _loc6_ + (_loc4_ ^ (_loc3_ | ~_loc5_)) - 1894986606 + _loc18_;
         _loc6_ = _loc3_ + (_loc7_ << 10 | _loc7_ >>> 22);
         _loc7_ = _loc5_ + (_loc3_ ^ (_loc6_ | ~_loc4_)) - 1051523 + _loc25_;
         _loc5_ = _loc6_ + (_loc7_ << 15 | _loc7_ >>> 17);
         _loc7_ = _loc4_ + (_loc6_ ^ (_loc5_ | ~_loc3_)) - 2054922799 + _loc16_;
         _loc4_ = _loc5_ + (_loc7_ << 21 | _loc7_ >>> 11);
         _loc7_ = _loc3_ + (_loc5_ ^ (_loc4_ | ~_loc6_)) + 1873313359 + _loc23_;
         _loc3_ = _loc4_ + (_loc7_ << 6 | _loc7_ >>> 26);
         _loc7_ = _loc6_ + (_loc4_ ^ (_loc3_ | ~_loc5_)) - 30611744 + _loc30_;
         _loc6_ = _loc3_ + (_loc7_ << 10 | _loc7_ >>> 22);
         _loc7_ = _loc5_ + (_loc3_ ^ (_loc6_ | ~_loc4_)) - 1560198380 + _loc21_;
         _loc5_ = _loc6_ + (_loc7_ << 15 | _loc7_ >>> 17);
         _loc7_ = _loc4_ + (_loc6_ ^ (_loc5_ | ~_loc3_)) + 1309151649 + _loc28_;
         _loc4_ = _loc5_ + (_loc7_ << 21 | _loc7_ >>> 11);
         _loc7_ = _loc3_ + (_loc5_ ^ (_loc4_ | ~_loc6_)) - 145523070 + _loc19_;
         _loc3_ = _loc4_ + (_loc7_ << 6 | _loc7_ >>> 26);
         _loc7_ = _loc6_ + (_loc4_ ^ (_loc3_ | ~_loc5_)) - 1120210379 + _loc26_;
         _loc6_ = _loc3_ + (_loc7_ << 10 | _loc7_ >>> 22);
         _loc7_ = _loc5_ + (_loc3_ ^ (_loc6_ | ~_loc4_)) + 718787259 + _loc17_;
         _loc5_ = _loc6_ + (_loc7_ << 15 | _loc7_ >>> 17);
         _loc7_ = _loc4_ + (_loc6_ ^ (_loc5_ | ~_loc3_)) - 343485551 + _loc24_;
         _loc4_ = _loc5_ + (_loc7_ << 21 | _loc7_ >>> 11);
         _loc9_ += _loc3_;
         _loc10_ += _loc4_;
         _loc11_ += _loc5_;
         _loc12_ += _loc6_;
      }
      while((_loc8_ = _loc8_ - 64) > 0);
      
      _loc2_.length = _loc13_;
      _loc9_ = _loc9_ >>> 24 | _loc9_ << 8 & 16711680 | _loc9_ >>> 8 & 65280 | _loc9_ << 24;
      _loc10_ = _loc10_ >>> 24 | _loc10_ << 8 & 16711680 | _loc10_ >>> 8 & 65280 | _loc10_ << 24;
      _loc11_ = _loc11_ >>> 24 | _loc11_ << 8 & 16711680 | _loc11_ >>> 8 & 65280 | _loc11_ << 24;
      _loc12_ = _loc12_ >>> 24 | _loc12_ << 8 & 16711680 | _loc12_ >>> 8 & 65280 | _loc12_ << 24;
      var _loc14_:String = uint(_loc12_).toString(16);
      _loc14_ = uint(_loc11_).toString(16) + leadingZeros[8 - _loc14_.length] + _loc14_;
      _loc14_ = uint(_loc10_).toString(16) + leadingZeros[16 - _loc14_.length] + _loc14_;
      _loc14_ = uint(_loc9_).toString(16) + leadingZeros[24 - _loc14_.length] + _loc14_;
      return leadingZeros[32 - _loc14_.length] + _loc14_;
   }
}

const leadingZeros:Vector.<String> = new Vector.<String>(8,true);
