package com.monsters.baseplanner.events
{
   import flash.events.Event;
   
   public class BasePlannerTransferEvent extends Event
   {
       
      
      private var _name:String;
      
      private var _slot:uint;
      
      public function BasePlannerTransferEvent(param1:String, param2:uint, param3:String = "")
      {
         this._name = param3;
         this._slot = param2;
         super(param1);
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function get slot() : uint
      {
         return this._slot;
      }
   }
}
