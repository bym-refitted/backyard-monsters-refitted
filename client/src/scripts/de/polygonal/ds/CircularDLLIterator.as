package de.polygonal.ds
{
   import flash.Boot;
   
   public class CircularDLLIterator implements Itr
   {
       
      
      public var _walker:DLLNode;
      
      public var _s:int;
      
      public var _i:int;
      
      public var _f:DLL;
      
      public function CircularDLLIterator(param1:DLL = undefined)
      {
         if(Boot.skip_constructor)
         {
            return;
         }
         _f = param1;
         _walker = _f.head;
         _s = _f._size;
         _i = 0;
      }
      
      public function reset() : void
      {
         _walker = _f.head;
         _s = _f._size;
         _i = 0;
      }
      
      public function next() : Object
      {
         var _loc1_:Object = _walker.val;
         _walker = _walker.next;
         ++_i;
         return _loc1_;
      }
      
      public function hasNext() : Boolean
      {
         return _i < _s;
      }
      
      public function __size(param1:Object) : int
      {
         return int(param1._size);
      }
   }
}
