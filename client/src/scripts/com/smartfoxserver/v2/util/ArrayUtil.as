package com.smartfoxserver.v2.util
{
   public class ArrayUtil
   {
       
      
      public function ArrayUtil()
      {
         super();
         throw new Error("This class contains static methods only! Do not instaniate it");
      }
      
      public static function removeElement(param1:Array, param2:*) : void
      {
         var _loc3_:int = param1.indexOf(param2);
         if(_loc3_ > -1)
         {
            param1.splice(_loc3_,1);
         }
      }
      
      public static function copy(param1:Array) : Array
      {
         var _loc2_:Array = new Array();
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_[_loc3_] = param1[_loc3_];
            _loc3_++;
         }
         return _loc2_;
      }
      
      public static function objToArray(param1:Object) : Array
      {
         var _loc3_:* = undefined;
         var _loc2_:Array = [];
         for each(_loc3_ in param1)
         {
            _loc2_.push(_loc3_);
         }
         return _loc2_;
      }
   }
}
