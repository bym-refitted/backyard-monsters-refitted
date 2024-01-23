package de.polygonal.ds
{
   public interface Queue extends Collection
   {
       
      
      function peek() : Object;
      
      function enqueue(param1:Object) : void;
      
      function dequeue() : Object;
      
      function back() : Object;
   }
}
