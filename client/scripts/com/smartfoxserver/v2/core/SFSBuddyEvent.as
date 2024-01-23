package com.smartfoxserver.v2.core
{
   import flash.events.Event;
   
   public class SFSBuddyEvent extends BaseEvent
   {
      
      public static const BUDDY_LIST_INIT:String = "buddyListInit";
      
      public static const BUDDY_ADD:String = "buddyAdd";
      
      public static const BUDDY_REMOVE:String = "buddyRemove";
      
      public static const BUDDY_BLOCK:String = "buddyBlock";
      
      public static const BUDDY_ERROR:String = "buddyError";
      
      public static const BUDDY_ONLINE_STATE_UPDATE:String = "buddyOnlineStateChange";
      
      public static const BUDDY_VARIABLES_UPDATE:String = "buddyVariablesUpdate";
      
      public static const BUDDY_MESSAGE:String = "buddyMessage";
       
      
      public function SFSBuddyEvent(param1:String, param2:Object)
      {
         super(param1);
         this.params = param2;
      }
      
      override public function clone() : Event
      {
         return new SFSEvent(this.type,this.params);
      }
      
      override public function toString() : String
      {
         return formatToString("SFSBuddyEvent","type","bubbles","cancelable","eventPhase","params");
      }
   }
}
