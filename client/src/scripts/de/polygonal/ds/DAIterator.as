package de.polygonal.ds
{
   import flash.Boot;
   
   public class DAIterator implements Itr
   {
       
      
      public var _s:int;
      
      public var _i:int;
      
      public var _f:de.polygonal.ds.DA;
      
      public var _a:Array;
      
      public function DAIterator(param1:de.polygonal.ds.DA = undefined)
      {
         if(Boot.skip_constructor)
         {
            return;
         }
         _f = param1;
         _a = _f._a;
         _s = _f._size;
         _i = 0;
      }
      
      public function reset() : void
      {
         _a = _f._a;
         _s = _f._size;
         _i = 0;
      }
      
      public function next() : Object
      {
         var _loc1_:int;
         _i = (_loc1_ = _i) + 1;
         return _a[_loc1_];
      }
      
      public function hasNext() : Boolean
      {
         return _i < _s;
      }
      
      public function __size(param1:Object) : int
      {
         return int(param1._size);
      }
      
      public function __a(param1:Object) : Array
      {
         return param1._a;
      }
   }
}
