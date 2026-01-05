package com.monsters.subscriptions.ui
{
   public class SubscriptionResourceIcon extends daveClubBar
   {
       
      
      public function SubscriptionResourceIcon(param1:Boolean)
      {
         super();
         this.update(param1);
         buttonMode = true;
         mouseChildren = false;
      }
      
      public function update(param1:Boolean) : void
      {
         if(param1)
         {
            gotoAndStop("on");
         }
         else
         {
            gotoAndStop("off");
         }
      }
   }
}
