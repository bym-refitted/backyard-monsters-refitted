package de.polygonal.ds
{
   import de.polygonal.core.fmt.Sprintf;
   import flash.Boot;
   
   public class DLLNode
   {
       
      
      public var val:Object;
      
      public var prev:de.polygonal.ds.DLLNode;
      
      public var next:de.polygonal.ds.DLLNode;
      
      public var _list:de.polygonal.ds.DLL;
      
      public function DLLNode(param1:Object = undefined, param2:de.polygonal.ds.DLL = undefined)
      {
         if(Boot.skip_constructor)
         {
            return;
         }
         val = param1;
         _list = param2;
      }
      
      public function unlink() : de.polygonal.ds.DLLNode
      {
         null;
         return _list.unlink(this);
      }
      
      public function toString() : String
      {
         return Sprintf.format("{DLLNode %s}",[Std.string(val)]);
      }
      
      public function prevVal() : Object
      {
         null;
         return prev.val;
      }
      
      public function prependTo(param1:de.polygonal.ds.DLLNode) : de.polygonal.ds.DLLNode
      {
         null;
         null;
         null;
         next = param1;
         if(param1 != null)
         {
            param1.prev = this;
         }
         return this;
      }
      
      public function prepend(param1:de.polygonal.ds.DLLNode) : de.polygonal.ds.DLLNode
      {
         null;
         null;
         null;
         param1.next = this;
         prev = param1;
         return param1;
      }
      
      public function nextVal() : Object
      {
         null;
         return next.val;
      }
      
      public function isTail() : Boolean
      {
         null;
         return this == _list.tail;
      }
      
      public function isHead() : Boolean
      {
         null;
         return this == _list.head;
      }
      
      public function hasPrev() : Boolean
      {
         return prev != null;
      }
      
      public function hasNext() : Boolean
      {
         return next != null;
      }
      
      public function getList() : de.polygonal.ds.DLL
      {
         return _list;
      }
      
      public function free() : void
      {
         var _loc1_:Object = null;
         val = _loc1_;
         next = prev = null;
         _list = null;
      }
      
      public function appendTo(param1:de.polygonal.ds.DLLNode) : de.polygonal.ds.DLLNode
      {
         null;
         null;
         null;
         prev = param1;
         if(param1 != null)
         {
            param1.next = this;
         }
         return this;
      }
      
      public function append(param1:de.polygonal.ds.DLLNode) : de.polygonal.ds.DLLNode
      {
         null;
         null;
         null;
         next = param1;
         param1.prev = this;
         return param1;
      }
      
      public function _unlink() : de.polygonal.ds.DLLNode
      {
         var _loc1_:de.polygonal.ds.DLLNode = next;
         if(prev != null)
         {
            prev.next = next;
         }
         if(next != null)
         {
            next.prev = prev;
         }
         next = prev = null;
         return _loc1_;
      }
      
      public function _insertBefore(param1:de.polygonal.ds.DLLNode) : void
      {
         param1.next = this;
         param1.prev = prev;
         if(prev != null)
         {
            prev.next = param1;
         }
         prev = param1;
      }
      
      public function _insertAfter(param1:de.polygonal.ds.DLLNode) : void
      {
         param1.next = next;
         param1.prev = this;
         if(next != null)
         {
            next.prev = param1;
         }
         next = param1;
      }
   }
}
