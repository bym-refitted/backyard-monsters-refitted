package de.polygonal.ds
{
   public class HashKey
   {
      
      public static var _counter:int;
       
      
      public function HashKey()
      {
      }
      
      public static function next() : int
      {
         var _loc1_:int;
         HashKey._counter = (_loc1_ = int(HashKey._counter)) + 1;
         return _loc1_;
      }
   }
}
