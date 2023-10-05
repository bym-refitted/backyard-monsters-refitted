package com.monsters.baseplanner.events
{
   import flash.events.Event;
   
   public class BasePlannerEvent extends Event
   {
      
      public static const LOAD:String = "loadTemplate";
      
      public static const SAVE:String = "saveTemplate";
      
      public static const APPLY:String = "applyTemplate";
      
      public static const CLEARALL:String = "emptyTemplate";
       
      
      public function BasePlannerEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
   }
}
