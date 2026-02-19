package com.monsters.pathing
{
   
   public class PATHINGfloodobject
   {
       
      
      public var pending:int = 0;
      
      public var flood:Object;
      
      public var edge:Object;
      
      public var minDepth:int = 9999999;
      
      public var startpoints:Object;
      
      public var ignoreWalls:Boolean = false;
      
      public function PATHINGfloodobject()
      {
         this.startpoints = {};
         super();
      }
   }
}
