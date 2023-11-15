package com.monsters.subscriptions.ui.controlPanel
{
   import com.monsters.subscriptions.SubscriptionHandler;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class MembershipPopup extends subscriptions_membership_popup
   {
       
      
      private var _cancelConfirm:SubscriptionCancelPopup;
      
      public function MembershipPopup()
      {
         var _loc1_:Boolean = false;
         super();
         _loc1_ = this.subscriptionActive();
         tTitle.htmlText = KEYS.Get("dc_panel_benefits");
         tDescription.htmlText = KEYS.Get("dc_benefits_desc");
         if(_loc1_)
         {
            tRenew.htmlText = KEYS.Get("dc_benefits_renew",{"v1":new Date(SubscriptionHandler.instance.renewalDate * 1000).toLocaleDateString()});
         }
         else
         {
            tRenew.htmlText = KEYS.Get("dc_benefits_expire",{"v1":new Date(SubscriptionHandler.instance.expirationDate * 1000).toLocaleDateString()});
         }
         if(_loc1_)
         {
            bChange.buttonMode = true;
            bChange.Setup(KEYS.Get("btn_changepayment"));
            bChange.addEventListener(MouseEvent.CLICK,this.clickedChange);
         }
         else
         {
            bChange.Enabled = false;
            bChange.buttonMode = false;
            bChange.mouseEnabled = false;
            bChange.visible = false;
         }
         bCancel.buttonMode = true;
         if(_loc1_)
         {
            bCancel.Setup(KEYS.Get("btn_cancelsub"));
            bCancel.addEventListener(MouseEvent.CLICK,this.clickedCancelConfirm);
         }
         else
         {
            bCancel.Setup(KEYS.Get("btn_reactivatesub"));
            bCancel.addEventListener(MouseEvent.CLICK,this.clickedReactivate);
         }
         bClose.Highlight = true;
         bClose.buttonMode = true;
         bClose.Setup(KEYS.Get("btn_close"));
         bClose.addEventListener(MouseEvent.CLICK,this.Hide);
      }
      
      protected function clickedReactivate(param1:MouseEvent) : void
      {
         dispatchEvent(new Event(SubscriptionHandler.REACTIVATE));
         this.Hide();
      }
      
      private function subscriptionActive() : Boolean
      {
         return Boolean(SubscriptionHandler.instance.renewalDate);
      }
      
      private function clickedChange(param1:MouseEvent = null) : void
      {
         dispatchEvent(new Event(SubscriptionHandler.CHANGE));
         this.Hide(param1);
      }
      
      private function clickedCancel(param1:MouseEvent = null) : void
      {
         dispatchEvent(new Event(SubscriptionHandler.CANCEL));
         this.Hide(param1);
      }
      
      private function eventCancel(param1:Event = null) : void
      {
         this.clickedCancel();
      }
      
      private function clickedCancelConfirm(param1:MouseEvent = null) : void
      {
         this._cancelConfirm = new SubscriptionCancelPopup();
         POPUPS.Add(this._cancelConfirm);
         this._cancelConfirm.addEventListener(SubscriptionHandler.CANCELCONFIRM,this.eventCancel);
         this._cancelConfirm.addEventListener(SubscriptionHandler.CLOSECONFIRM,this.removeConfirmationPopup);
         POPUPSETTINGS.AlignToCenter(this._cancelConfirm);
      }
      
      private function removeConfirmationPopup(param1:Event = null) : void
      {
         this._cancelConfirm.removeEventListener(SubscriptionHandler.CANCELCONFIRM,this.clickedCancel);
         this._cancelConfirm.removeEventListener(SubscriptionHandler.CLOSECONFIRM,this.removeConfirmationPopup);
         POPUPS.Remove(this._cancelConfirm);
      }
      
      public function Hide(param1:MouseEvent = null) : void
      {
         if(this._cancelConfirm)
         {
            this.removeConfirmationPopup();
         }
         bChange.removeEventListener(MouseEvent.CLICK,this.clickedChange);
         bCancel.removeEventListener(MouseEvent.CLICK,this.clickedCancel);
         bClose.removeEventListener(MouseEvent.CLICK,this.Hide);
         dispatchEvent(new Event(Event.CLOSE));
      }
   }
}
