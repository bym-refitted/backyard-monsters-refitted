package com.monsters.subscriptions
{
   import com.brokenfunction.json.decodeJson;
   import com.monsters.debug.Console;
   import flash.events.EventDispatcher;
   import flash.external.ExternalInterface;
   
   public class SubscriptionService extends EventDispatcher
   {
       
      
      private var _callbacks:Array;
      
      public function SubscriptionService()
      {
         this._callbacks = [];
         super();
      }
      
      private function callJS(param1:String, param2:Function = null, param3:Number = 2, param4:Boolean = true) : void
      {
         var _loc5_:String = param1.replace("cc.","");
         if(param2 && ExternalInterface.available && this._callbacks.indexOf(_loc5_) < 0)
         {
            ExternalInterface.addCallback(_loc5_,param2);
            this._callbacks[_loc5_] = _loc5_;
         }
         GLOBAL.CallJS(param1,[param3],param4);
      }
      
      public function getSubscriptionData() : void
      {
         this.callJS("cc.getUserSubscriptions",this.getUserSubscriptions,2,false);
      }
      
      public function getUserSubscriptions(param1:String) : void
      {
         var _loc2_:SubscriptionStatusEvent = new SubscriptionStatusEvent(SubscriptionStatusEvent.STATUS_EVENT);
         if(!param1)
         {
            Console.warning("did not recieve json back from the server");
            dispatchEvent(_loc2_);
            return;
         }
         var _loc3_:Object = decodeJson(param1)[0];
         if(_loc3_.length == 0)
         {
            Console.warning("got subscription data but it\'s emtpy, not going to try to parse it");
            dispatchEvent(_loc2_);
            return;
         }
         _loc2_ = new SubscriptionStatusEvent(SubscriptionStatusEvent.STATUS_EVENT);
         _loc2_.subscriptionID = Number(_loc3_["fb_subscriptionid"]);
         var _loc4_:String = String(_loc3_["status"]);
         var _loc5_:Number = Number(_loc3_["nextbilltime"]);
         if(_loc4_ == "active")
         {
            _loc2_.renewalDate = _loc5_;
         }
         else if(_loc4_ == "pending_cancel")
         {
            _loc2_.expirationDate = _loc5_;
         }
         dispatchEvent(_loc2_);
      }
      
      public function startSubscription() : void
      {
         LOGGER.StatB({"st1":"daves_club"},"subscribe");
         this.callJS("cc.showSubscriptionDialog",this.showSubscriptionDialog);
      }
      
      public function reactivateSubscription(param1:Number) : void
      {
         this.callJS("cc.showSubscriptionDialog",this.showSubscriptionDialog);
      }
      
      private function showSubscriptionDialog(param1:String = null) : void
      {
         if(!param1)
         {
            Console.warning("got a calback @ \'showSubscriptionDialog\' but theres no JSON data!");
         }
         this.getUserSubscriptions(param1);
      }
      
      public function changeSubscription(param1:Number) : void
      {
         this.callJS("cc.changeSubscriptionPayType",null,param1);
      }
      
      private function changeSubscriptionCallback(param1:String) : void
      {
         this.getUserSubscriptions(param1);
      }
      
      public function cancelSubscription(param1:Number) : void
      {
         LOGGER.StatB({"st1":"daves_club"},"unsubscribe");
         this.callJS("cc.showSubscriptionDialog",this.showSubscriptionDialog);
      }
      
      private function cancelSubscriptionCallback(param1:String) : void
      {
         this.getUserSubscriptions(param1);
      }
   }
}
