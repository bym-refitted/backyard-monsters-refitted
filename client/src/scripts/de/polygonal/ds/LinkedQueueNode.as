package de.polygonal.ds
{
   import flash.Boot;
   
   public class LinkedQueueNode
   {
       
      
      public var val:Object;
      
      public var next:LinkedQueueNode;
      
      public function LinkedQueueNode(param1:Object = undefined)
      {
         if(Boot.skip_constructor)
         {
            return;
         }
         val = param1;
      }
      
      public function toString() : String
      {
         return "" + val;
      }
   }
}
