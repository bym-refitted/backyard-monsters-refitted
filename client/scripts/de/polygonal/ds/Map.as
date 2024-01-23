package de.polygonal.ds
{
   public interface Map extends Collection
   {
       
      
      function toValSet() : Set;
      
      function toKeySet() : Set;
      
      function set(param1:Object, param2:Object) : Boolean;
      
      function remap(param1:Object, param2:Object) : Boolean;
      
      function keys() : Itr;
      
      function hasKey(param1:Object) : Boolean;
      
      function has(param1:Object) : Boolean;
      
      function get(param1:Object) : Object;
      
      function clr(param1:Object) : Boolean;
   }
}
