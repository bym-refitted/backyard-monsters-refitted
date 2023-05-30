package de.polygonal.ds
{
   import flash.Boot;
   
   public class ArrayedStackIterator implements Itr
   {
       
      
      public var _i:int;
      
      public var _f:de.polygonal.ds.ArrayedStack;
      
      public var _a:Array;
      
      public function ArrayedStackIterator(param1:de.polygonal.ds.ArrayedStack = undefined)
      {
         if(Boot.skip_constructor)
         {
            return;
         }
         _f = param1;
         _a = _f._a;
         _i = _f._top - 1;
      }
      
      public function reset() : void
      {
         _a = _f._a;
         _i = _f._top - 1;
      }
      
      public function next() : Object
      {
         var _loc1_:int;
         _i = (_loc1_ = _i) - 1;
         return _a[_loc1_];
      }
      
      public function hasNext() : Boolean
      {
         return _i >= 0;
      }
      
      public function __top(param1:Object) : int
      {
         return int(param1._top);
      }
      
      public function __a(param1:Object) : Array
      {
         return param1._a;
      }
   }
}
