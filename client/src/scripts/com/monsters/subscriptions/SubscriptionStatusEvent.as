package com.monsters.subscriptions
{
   import flash.events.Event;
   
   public class SubscriptionStatusEvent extends Event
   {
      
      public static const STATUS_EVENT:String = "statusEvent";
       
      
      public var renewalDate:uint;
      
      public var expirationDate:uint;
      
      public var subscriptionID:Number;
      
      public function SubscriptionStatusEvent(param1:String, param2:uint = 0, param3:uint = 0, param4:Number = 0)
      {
         this.renewalDate = param2;
         this.expirationDate = param3;
         this.subscriptionID = param4;
         super(param1,bubbles,cancelable);
      }
      
      override public function toString() : String
      {
         return "renewalDate:" + this.renewalDate + " expirationDate:" + this.expirationDate + " subscriptionID:" + this.subscriptionID;
      }
   }
}
