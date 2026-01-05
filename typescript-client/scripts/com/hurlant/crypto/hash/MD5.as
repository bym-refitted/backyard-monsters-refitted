package com.hurlant.crypto.hash
{
   import flash.utils.ByteArray;
   import flash.utils.Endian;
   
   public class MD5 implements IHash
   {
      
      public static const HASH_SIZE:int = 16;
       
      
      public function MD5()
      {
         super();
      }
      
      private function ff(param1:uint, param2:uint, param3:uint, param4:uint, param5:uint, param6:uint, param7:uint) : uint
      {
         return cmn(param2 & param3 | ~param2 & param4,param1,param2,param5,param6,param7);
      }
      
      private function hh(param1:uint, param2:uint, param3:uint, param4:uint, param5:uint, param6:uint, param7:uint) : uint
      {
         return cmn(param2 ^ param3 ^ param4,param1,param2,param5,param6,param7);
      }
      
      private function cmn(param1:uint, param2:uint, param3:uint, param4:uint, param5:uint, param6:uint) : uint
      {
         return rol(param2 + param1 + param4 + param6,param5) + param3;
      }
      
      public function getHashSize() : uint
      {
         return HASH_SIZE;
      }
      
      private function ii(param1:uint, param2:uint, param3:uint, param4:uint, param5:uint, param6:uint, param7:uint) : uint
      {
         return cmn(param3 ^ (param2 | ~param4),param1,param2,param5,param6,param7);
      }
      
      private function rol(param1:uint, param2:uint) : uint
      {
         return param1 << param2 | param1 >>> 32 - param2;
      }
      
      public function toString() : String
      {
         return "md5";
      }
      
      public function getInputSize() : uint
      {
         return 64;
      }
      
      private function gg(param1:uint, param2:uint, param3:uint, param4:uint, param5:uint, param6:uint, param7:uint) : uint
      {
         return cmn(param2 & param4 | param3 & ~param4,param1,param2,param5,param6,param7);
      }
      
      public function hash(param1:ByteArray) : ByteArray
      {
         var _loc2_:uint = 0;
         var _loc3_:String = null;
         var _loc4_:Array = null;
         var _loc5_:uint = 0;
         var _loc6_:Array = null;
         var _loc7_:ByteArray = null;
         _loc2_ = param1.length * 8;
         _loc3_ = param1.endian;
         while(param1.length % 4 != 0)
         {
            param1[param1.length] = 0;
         }
         param1.position = 0;
         _loc4_ = [];
         param1.endian = Endian.LITTLE_ENDIAN;
         _loc5_ = 0;
         while(_loc5_ < param1.length)
         {
            _loc4_.push(param1.readUnsignedInt());
            _loc5_ += 4;
         }
         _loc6_ = core_md5(_loc4_,_loc2_);
         (_loc7_ = new ByteArray()).endian = Endian.LITTLE_ENDIAN;
         _loc5_ = 0;
         while(_loc5_ < 4)
         {
            _loc7_.writeUnsignedInt(_loc6_[_loc5_]);
            _loc5_++;
         }
         param1.length = _loc2_ / 8;
         param1.endian = _loc3_;
         return _loc7_;
      }
      
      private function core_md5(param1:Array, param2:uint) : Array
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         var _loc11_:uint = 0;
         param1[param2 >> 5] |= 128 << param2 % 32;
         param1[(param2 + 64 >>> 9 << 4) + 14] = param2;
         _loc3_ = 1732584193;
         _loc4_ = 4023233417;
         _loc5_ = 2562383102;
         _loc6_ = 271733878;
         _loc7_ = 0;
         while(_loc7_ < param1.length)
         {
            param1[_loc7_] = param1[_loc7_] || 0;
            param1[_loc7_ + 1] = param1[_loc7_ + 1] || 0;
            param1[_loc7_ + 2] = param1[_loc7_ + 2] || 0;
            param1[_loc7_ + 3] = param1[_loc7_ + 3] || 0;
            param1[_loc7_ + 4] = param1[_loc7_ + 4] || 0;
            param1[_loc7_ + 5] = param1[_loc7_ + 5] || 0;
            param1[_loc7_ + 6] = param1[_loc7_ + 6] || 0;
            param1[_loc7_ + 7] = param1[_loc7_ + 7] || 0;
            param1[_loc7_ + 8] = param1[_loc7_ + 8] || 0;
            param1[_loc7_ + 9] = param1[_loc7_ + 9] || 0;
            param1[_loc7_ + 10] = param1[_loc7_ + 10] || 0;
            param1[_loc7_ + 11] = param1[_loc7_ + 11] || 0;
            param1[_loc7_ + 12] = param1[_loc7_ + 12] || 0;
            param1[_loc7_ + 13] = param1[_loc7_ + 13] || 0;
            param1[_loc7_ + 14] = param1[_loc7_ + 14] || 0;
            param1[_loc7_ + 15] = param1[_loc7_ + 15] || 0;
            _loc8_ = _loc3_;
            _loc9_ = _loc4_;
            _loc10_ = _loc5_;
            _loc11_ = _loc6_;
            _loc3_ = ff(_loc3_,_loc4_,_loc5_,_loc6_,param1[_loc7_ + 0],7,3614090360);
            _loc6_ = ff(_loc6_,_loc3_,_loc4_,_loc5_,param1[_loc7_ + 1],12,3905402710);
            _loc5_ = ff(_loc5_,_loc6_,_loc3_,_loc4_,param1[_loc7_ + 2],17,606105819);
            _loc4_ = ff(_loc4_,_loc5_,_loc6_,_loc3_,param1[_loc7_ + 3],22,3250441966);
            _loc3_ = ff(_loc3_,_loc4_,_loc5_,_loc6_,param1[_loc7_ + 4],7,4118548399);
            _loc6_ = ff(_loc6_,_loc3_,_loc4_,_loc5_,param1[_loc7_ + 5],12,1200080426);
            _loc5_ = ff(_loc5_,_loc6_,_loc3_,_loc4_,param1[_loc7_ + 6],17,2821735955);
            _loc4_ = ff(_loc4_,_loc5_,_loc6_,_loc3_,param1[_loc7_ + 7],22,4249261313);
            _loc3_ = ff(_loc3_,_loc4_,_loc5_,_loc6_,param1[_loc7_ + 8],7,1770035416);
            _loc6_ = ff(_loc6_,_loc3_,_loc4_,_loc5_,param1[_loc7_ + 9],12,2336552879);
            _loc5_ = ff(_loc5_,_loc6_,_loc3_,_loc4_,param1[_loc7_ + 10],17,4294925233);
            _loc4_ = ff(_loc4_,_loc5_,_loc6_,_loc3_,param1[_loc7_ + 11],22,2304563134);
            _loc3_ = ff(_loc3_,_loc4_,_loc5_,_loc6_,param1[_loc7_ + 12],7,1804603682);
            _loc6_ = ff(_loc6_,_loc3_,_loc4_,_loc5_,param1[_loc7_ + 13],12,4254626195);
            _loc5_ = ff(_loc5_,_loc6_,_loc3_,_loc4_,param1[_loc7_ + 14],17,2792965006);
            _loc4_ = ff(_loc4_,_loc5_,_loc6_,_loc3_,param1[_loc7_ + 15],22,1236535329);
            _loc3_ = gg(_loc3_,_loc4_,_loc5_,_loc6_,param1[_loc7_ + 1],5,4129170786);
            _loc6_ = gg(_loc6_,_loc3_,_loc4_,_loc5_,param1[_loc7_ + 6],9,3225465664);
            _loc5_ = gg(_loc5_,_loc6_,_loc3_,_loc4_,param1[_loc7_ + 11],14,643717713);
            _loc4_ = gg(_loc4_,_loc5_,_loc6_,_loc3_,param1[_loc7_ + 0],20,3921069994);
            _loc3_ = gg(_loc3_,_loc4_,_loc5_,_loc6_,param1[_loc7_ + 5],5,3593408605);
            _loc6_ = gg(_loc6_,_loc3_,_loc4_,_loc5_,param1[_loc7_ + 10],9,38016083);
            _loc5_ = gg(_loc5_,_loc6_,_loc3_,_loc4_,param1[_loc7_ + 15],14,3634488961);
            _loc4_ = gg(_loc4_,_loc5_,_loc6_,_loc3_,param1[_loc7_ + 4],20,3889429448);
            _loc3_ = gg(_loc3_,_loc4_,_loc5_,_loc6_,param1[_loc7_ + 9],5,568446438);
            _loc6_ = gg(_loc6_,_loc3_,_loc4_,_loc5_,param1[_loc7_ + 14],9,3275163606);
            _loc5_ = gg(_loc5_,_loc6_,_loc3_,_loc4_,param1[_loc7_ + 3],14,4107603335);
            _loc4_ = gg(_loc4_,_loc5_,_loc6_,_loc3_,param1[_loc7_ + 8],20,1163531501);
            _loc3_ = gg(_loc3_,_loc4_,_loc5_,_loc6_,param1[_loc7_ + 13],5,2850285829);
            _loc6_ = gg(_loc6_,_loc3_,_loc4_,_loc5_,param1[_loc7_ + 2],9,4243563512);
            _loc5_ = gg(_loc5_,_loc6_,_loc3_,_loc4_,param1[_loc7_ + 7],14,1735328473);
            _loc4_ = gg(_loc4_,_loc5_,_loc6_,_loc3_,param1[_loc7_ + 12],20,2368359562);
            _loc3_ = hh(_loc3_,_loc4_,_loc5_,_loc6_,param1[_loc7_ + 5],4,4294588738);
            _loc6_ = hh(_loc6_,_loc3_,_loc4_,_loc5_,param1[_loc7_ + 8],11,2272392833);
            _loc5_ = hh(_loc5_,_loc6_,_loc3_,_loc4_,param1[_loc7_ + 11],16,1839030562);
            _loc4_ = hh(_loc4_,_loc5_,_loc6_,_loc3_,param1[_loc7_ + 14],23,4259657740);
            _loc3_ = hh(_loc3_,_loc4_,_loc5_,_loc6_,param1[_loc7_ + 1],4,2763975236);
            _loc6_ = hh(_loc6_,_loc3_,_loc4_,_loc5_,param1[_loc7_ + 4],11,1272893353);
            _loc5_ = hh(_loc5_,_loc6_,_loc3_,_loc4_,param1[_loc7_ + 7],16,4139469664);
            _loc4_ = hh(_loc4_,_loc5_,_loc6_,_loc3_,param1[_loc7_ + 10],23,3200236656);
            _loc3_ = hh(_loc3_,_loc4_,_loc5_,_loc6_,param1[_loc7_ + 13],4,681279174);
            _loc6_ = hh(_loc6_,_loc3_,_loc4_,_loc5_,param1[_loc7_ + 0],11,3936430074);
            _loc5_ = hh(_loc5_,_loc6_,_loc3_,_loc4_,param1[_loc7_ + 3],16,3572445317);
            _loc4_ = hh(_loc4_,_loc5_,_loc6_,_loc3_,param1[_loc7_ + 6],23,76029189);
            _loc3_ = hh(_loc3_,_loc4_,_loc5_,_loc6_,param1[_loc7_ + 9],4,3654602809);
            _loc6_ = hh(_loc6_,_loc3_,_loc4_,_loc5_,param1[_loc7_ + 12],11,3873151461);
            _loc5_ = hh(_loc5_,_loc6_,_loc3_,_loc4_,param1[_loc7_ + 15],16,530742520);
            _loc4_ = hh(_loc4_,_loc5_,_loc6_,_loc3_,param1[_loc7_ + 2],23,3299628645);
            _loc3_ = ii(_loc3_,_loc4_,_loc5_,_loc6_,param1[_loc7_ + 0],6,4096336452);
            _loc6_ = ii(_loc6_,_loc3_,_loc4_,_loc5_,param1[_loc7_ + 7],10,1126891415);
            _loc5_ = ii(_loc5_,_loc6_,_loc3_,_loc4_,param1[_loc7_ + 14],15,2878612391);
            _loc4_ = ii(_loc4_,_loc5_,_loc6_,_loc3_,param1[_loc7_ + 5],21,4237533241);
            _loc3_ = ii(_loc3_,_loc4_,_loc5_,_loc6_,param1[_loc7_ + 12],6,1700485571);
            _loc6_ = ii(_loc6_,_loc3_,_loc4_,_loc5_,param1[_loc7_ + 3],10,2399980690);
            _loc5_ = ii(_loc5_,_loc6_,_loc3_,_loc4_,param1[_loc7_ + 10],15,4293915773);
            _loc4_ = ii(_loc4_,_loc5_,_loc6_,_loc3_,param1[_loc7_ + 1],21,2240044497);
            _loc3_ = ii(_loc3_,_loc4_,_loc5_,_loc6_,param1[_loc7_ + 8],6,1873313359);
            _loc6_ = ii(_loc6_,_loc3_,_loc4_,_loc5_,param1[_loc7_ + 15],10,4264355552);
            _loc5_ = ii(_loc5_,_loc6_,_loc3_,_loc4_,param1[_loc7_ + 6],15,2734768916);
            _loc4_ = ii(_loc4_,_loc5_,_loc6_,_loc3_,param1[_loc7_ + 13],21,1309151649);
            _loc3_ = ii(_loc3_,_loc4_,_loc5_,_loc6_,param1[_loc7_ + 4],6,4149444226);
            _loc6_ = ii(_loc6_,_loc3_,_loc4_,_loc5_,param1[_loc7_ + 11],10,3174756917);
            _loc5_ = ii(_loc5_,_loc6_,_loc3_,_loc4_,param1[_loc7_ + 2],15,718787259);
            _loc4_ = ii(_loc4_,_loc5_,_loc6_,_loc3_,param1[_loc7_ + 9],21,3951481745);
            _loc3_ += _loc8_;
            _loc4_ += _loc9_;
            _loc5_ += _loc10_;
            _loc6_ += _loc11_;
            _loc7_ += 16;
         }
         return [_loc3_,_loc4_,_loc5_,_loc6_];
      }
   }
}
