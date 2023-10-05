package de.polygonal.ds
{
   import flash.Boot;
   
   public class HashSetIterator implements Itr
   {
       
      
      public var _vals:Array;
      
      public var _s:int;
      
      public var _i:int;
      
      public var _f:Object;
      
      public function HashSetIterator(param1:Object = undefined)
      {
         if(Boot.skip_constructor)
         {
            return;
         }
         _f = param1;
         _vals = _f._vals;
         _i = -1;
         _s = _f._h._capacity;
      }
      
      public function reset() : void
      {
         _vals = _f._vals;
         _i = -1;
         _s = _f._h._capacity;
      }
      
      public function next() : Object
      {
         return _vals[_i];
      }
      
      public function hasNext() : Boolean
      {
         var _loc1_:int = 0;
         while((_i = _i + 1) < _s)
         {
            if(_vals[_i] != null)
            {
               return true;
            }
         }
         return false;
      }
      
      public function __vals(param1:Object) : Array
      {
         return param1._vals;
      }
      
      public function __h(param1:Object) : IntIntHashTable
      {
         return param1._h;
      }
   }
}
