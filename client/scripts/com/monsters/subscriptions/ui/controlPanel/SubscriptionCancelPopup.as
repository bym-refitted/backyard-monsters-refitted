package com.monsters.subscriptions.ui.controlPanel
{
   import com.monsters.subscriptions.SubscriptionHandler;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class SubscriptionCancelPopup extends subscriptions_cancelconfirm_popup
   {
       
      
      public function SubscriptionCancelPopup()
      {
         super();
         tTitle.htmlText = KEYS.Get("dc_panel_cancel");
         tDesc.htmlText = KEYS.Get("dc_cancel_confirmation");
         bConfirm.Highlight = false;
         bConfirm.buttonMode = true;
         bConfirm.Setup(KEYS.Get("btn_cancelsub_confirm"));
         bConfirm.addEventListener(MouseEvent.CLICK,this.clickedConfirm);
         bCancel.Highlight = true;
         bCancel.buttonMode = true;
         bCancel.Setup(KEYS.Get("btn_cancelsub_keepsub"));
         bCancel.addEventListener(MouseEvent.CLICK,this.Hide);
      }
      
      private function clickedConfirm(param1:MouseEvent = null) : void
      {
         dispatchEvent(new Event(SubscriptionHandler.CANCELCONFIRM));
         this.Hide(param1);
      }
      
      private function clickedCancel(param1:MouseEvent = null) : void
      {
         this.Hide(param1);
      }
      
      public function Hide(param1:MouseEvent = null) : void
      {
         dispatchEvent(new Event(SubscriptionHandler.CLOSECONFIRM));
         bConfirm.removeEventListener(MouseEvent.CLICK,this.clickedConfirm);
         bCancel.removeEventListener(MouseEvent.CLICK,this.Hide);
         dispatchEvent(new Event(Event.CLOSE));
      }
   }
}
