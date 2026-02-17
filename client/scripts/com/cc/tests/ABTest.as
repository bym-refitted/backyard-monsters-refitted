package com.cc.tests
{
   public class ABTest
   {
       
      
      public function ABTest()
      {
         super();
      }
      
      public static function isInTestGroup(param1:String, param2:int) : Boolean
      {
         return lastTwoDigits(UserMD5(param1)) < param2;
      }
      
      public static function lastDigit(param1:String) : int
      {
         var _loc2_:String = param1.substr(-1,1);
         return parseInt("0x" + _loc2_);
      }
      
      public static function lastTwoDigits(param1:String) : int
      {
         var _loc2_:String = param1.substr(-2,2);
         return parseInt("0x" + _loc2_);
      }
      
      public static function UserMD5(param1:String = "", param2:int = 0) : String
      {
         var _loc3_:String = null;
         if(param2 != 0)
         {
            _loc3_ = param2.toString();
         }
         else
         {
            _loc3_ = LOGIN._playerID.toString();
         }
         _loc3_ = param1 + _loc3_;
         return md5(_loc3_);
      }
   }
}
