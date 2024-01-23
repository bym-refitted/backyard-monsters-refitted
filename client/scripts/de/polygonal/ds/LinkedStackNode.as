package de.polygonal.ds
{
   import flash.Boot;
   
   public class LinkedStackNode
   {
       
      
      public var val:Object;
      
      public var next:LinkedStackNode;
      
      public function LinkedStackNode(param1:Object = undefined)
      {
         if(Boot.skip_constructor)
         {
            return;
         }
         val = param1;
      }
      
      public function toString() : String
      {
         return Std.string(val);
      }
   }
}
