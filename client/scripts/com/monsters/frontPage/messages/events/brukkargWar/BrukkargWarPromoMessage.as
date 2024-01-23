package com.monsters.frontPage.messages.events.brukkargWar
{
   import com.monsters.frontPage.messages.KeywordMessage;
   import com.monsters.replayableEvents.ReplayableEventHandler;
   import com.monsters.replayableEvents.ReplayableEventLibrary;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   
   public class BrukkargWarPromoMessage extends KeywordMessage
   {
      
      private static const k_BRUKKARG_EVENT_PAGE_URL:String = "http://www.kixeye.com/brukkarg-war";
       
      
      private var _action:Function;
      
      public function BrukkargWarPromoMessage(param1:String)
      {
         this._action = this.goToEventPage;
         super(param1,"btn_rsvp");
      }
      
      override public function setupButton(param1:Button) : Button
      {
         super.setupButton(param1);
         if(ReplayableEventHandler.currentTime >= ReplayableEventLibrary.BRUKKARG_EVENT.originalStartDate)
         {
            param1.SetupKey("btn_keepposted");
            this._action = this.optInForEventEmails;
         }
         return param1;
      }
      
      override protected function clickedButton(param1:MouseEvent) : void
      {
         POPUPS.Next();
         this._action();
      }
      
      private function goToEventPage() : void
      {
         navigateToURL(new URLRequest(k_BRUKKARG_EVENT_PAGE_URL));
      }
      
      private function optInForEventEmails() : void
      {
         ReplayableEventHandler.optInForEventEmails();
         GLOBAL.Message(KEYS.Get("msg_rsvpconfirmed",{"v1":LOGIN._email}));
      }
   }
}
