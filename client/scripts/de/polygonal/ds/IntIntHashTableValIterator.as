package de.polygonal.ds
{
   import flash.Boot;
   
   public class IntIntHashTableValIterator implements Itr
   {
       
      
      public var _s:int;
      
      public var _i:int;
      
      public var _f:Object;
      
      public var _data:Array;
      
      public function IntIntHashTableValIterator(param1:Object = undefined)
      {
         if(Boot.skip_constructor)
         {
            return;
         }
         _f = param1;
         _data = _f._data;
         _i = 0;
         _s = int(_f._capacity);
         while(_i < _s && int(_data[_i * 3 + 1]) == -2147483648)
         {
            ++_i;
         }
      }
      
      public function reset() : void
      {
         _data = _f._data;
         _i = 0;
         _s = int(_f._capacity);
         while(_i < _s && int(_data[_i * 3 + 1]) == -2147483648)
         {
            ++_i;
         }
      }
      
      public function next() : Object
      {
         var _loc2_:int;
         _i = (_loc2_ = _i) + 1;
         var _loc1_:int = int(_data[_loc2_ * 3 + 1]);
         while(_i < _s && int(_data[_i * 3 + 1]) == -2147483648)
         {
            ++_i;
         }
         return _loc1_;
      }
      
      public function hasNext() : Boolean
      {
         return _i < _s;
      }
      
      public function _scan() : void
      {
         while(_i < _s && int(_data[_i * 3 + 1]) == -2147483648)
         {
            ++_i;
         }
      }
      
      public function __getData(param1:int) : int
      {
         return int(_data[param1]);
      }
   }
}
