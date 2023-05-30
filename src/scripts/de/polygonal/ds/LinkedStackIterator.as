package de.polygonal.ds
{
   import flash.Boot;
   
   public class LinkedStackIterator implements Itr
   {
       
      
      public var _walker:de.polygonal.ds.LinkedStackNode;
      
      public var _f:de.polygonal.ds.LinkedStack;
      
      public function LinkedStackIterator(param1:de.polygonal.ds.LinkedStack = undefined)
      {
         if(Boot.skip_constructor)
         {
            return;
         }
         _f = param1;
         _walker = _f._head;
      }
      
      public function reset() : void
      {
         _walker = _f._head;
      }
      
      public function next() : Object
      {
         var _loc1_:Object = _walker.val;
         _walker = _walker.next;
         return _loc1_;
      }
      
      public function hasNext() : Boolean
      {
         return _walker != null;
      }
      
      public function __head(param1:Object) : de.polygonal.ds.LinkedStackNode
      {
         return param1._head;
      }
   }
}
