package com.smartfoxserver.v2.core
{
   import flash.events.Event;
   
   public class BaseEvent extends Event
   {
       
      
      public var params:Object;
      
      public function BaseEvent(param1:String, param2:Object = null)
      {
         super(param1);
         this.params = param2;
      }
      
      override public function clone() : Event
      {
         return new BaseEvent(this.type,this.params);
      }
      
      override public function toString() : String
      {
         return formatToString("BaseEvent","type","bubbles","cancelable","eventPhase","params");
      }
   }
}
