package com.monsters.replayableEvents.attacking.hellRaisers.messages
{
   import com.monsters.frontPage.FrontPageGraphic;
   import com.monsters.frontPage.messages.KeywordMessage;
   import com.monsters.frontPage.messages.Message;
   import com.monsters.frontPage.messages.promotions.Maproom3OptInPopup;
   import com.monsters.maproom_manager.MapRoomManager;
   import com.monsters.replayableEvents.attacking.hellRaisers.HellRaisers;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   
   public class HellRaisersPromoMessage extends Message
   {
       
      
      private var _buttonAction:Function;
      
      public function HellRaisersPromoMessage(param1:String)
      {
         var _loc2_:* = null;
         if(MapRoomManager.instance.isInMapRoom2)
         {
            _loc2_ += "_upgrade";
            _buttonCopy = "btn_joinnow";
            this._buttonAction = this.showUpgradeToMR3Popup;
         }
         else
         {
            _loc2_ = param1;
            _buttonCopy = "btn_rsvp";
            this._buttonAction = this.RSVP;
         }
         super(KeywordMessage.PREFIX + _loc2_ + "_title",KeywordMessage.PREFIX + _loc2_,KeywordMessage.PREFIX + param1 + ".jpg",_buttonCopy);
      }
      
      override protected function onButtonClick() : void
      {
         POPUPS.Next();
         this._buttonAction();
      }
      
      private function showUpgradeToMR3Popup() : void
      {
         POPUPS.Push(new FrontPageGraphic(new Maproom3OptInPopup()));
      }
      
      private function RSVP() : void
      {
         navigateToURL(new URLRequest(HellRaisers.k_eventPage));
      }
   }
}
