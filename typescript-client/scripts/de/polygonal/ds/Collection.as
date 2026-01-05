package de.polygonal.ds
{
   public interface Collection extends Hashable
   {
       
      
      function toDA() : DA;
      
      function toArray() : Array;
      
      function size() : int;
      
      function remove(param1:Object) : Boolean;
      
      function iterator() : Itr;
      
      function isEmpty() : Boolean;
      
      function free() : void;
      
      function contains(param1:Object) : Boolean;
      
      function clone(param1:Boolean, param2:Object = undefined) : Collection;
      
      function clear(param1:Boolean = undefined) : void;
   }
}
