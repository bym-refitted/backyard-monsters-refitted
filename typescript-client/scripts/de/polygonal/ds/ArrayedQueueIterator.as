package de.polygonal.ds
{
   import flash.Boot;
   
   public class ArrayedQueueIterator implements Itr
   {
       
      
      public var _size:int;
      
      public var _i:int;
      
      public var _front:int;
      
      public var _f:ArrayedQueue;
      
      public var _capacity:int;
      
      public var _a:Array;
      
      public function ArrayedQueueIterator(param1:ArrayedQueue = undefined)
      {
         if(Boot.skip_constructor)
         {
            return;
         }
         _f = param1;
         _a = _f._a;
         _front = _f._front;
         _capacity = _f._capacity;
         _size = _f._size;
         _i = 0;
      }
      
      public function reset() : void
      {
         _a = _f._a;
         _front = _f._front;
         _capacity = _f._capacity;
         _size = _f._size;
         _i = 0;
      }
      
      public function next() : Object
      {
         var _loc1_:int;
         _i = (_loc1_ = _i) + 1;
         return _a[int((_loc1_ + _front) % _capacity)];
      }
      
      public function hasNext() : Boolean
      {
         return _i < _size;
      }
      
      public function __size(param1:Object) : int
      {
         return int(param1._capacity);
      }
      
      public function __front(param1:Object) : int
      {
         return int(param1._front);
      }
      
      public function __count(param1:Object) : int
      {
         return int(param1._size);
      }
      
      public function __a(param1:Object) : Array
      {
         return param1._a;
      }
   }
}
