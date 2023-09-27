package de.polygonal.ds
{
   import flash.Boot;
   
   public class DLLIterator implements Itr
   {
       
      
      public var _walker:de.polygonal.ds.DLLNode;
      
      public var _f:de.polygonal.ds.DLL;
      
      public function DLLIterator(param1:de.polygonal.ds.DLL = undefined)
      {
         if(Boot.skip_constructor)
         {
            return;
         }
         _f = param1;
         _walker = _f.head;
      }
      
      public function reset() : void
      {
         _walker = _f.head;
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
   }
}
