package com.monsters.replayableEvents.looting.wotc.messages {
    import com.monsters.frontPage.messages.KeywordMessage;
    import com.monsters.replayableEvents.ReplayableEventHandler;
    import com.monsters.replayableEvents.looting.wotc.WrathOfTheChampion;
    import flash.events.MouseEvent;
    import flash.net.URLRequest;
    import flash.net.navigateToURL;

    public class WOTCPromoMessage extends KeywordMessage {

        private var _action:Function;

        public function WOTCPromoMessage(param1:String) {
            this._action = this.goToEventPage;
            super(param1 + "live", "btn_rsvp");
            imageURL = getImageURLFromKeyword(param1);
        }

        override public function setupButton(param1:Button):Button {
            super.setupButton(param1);
            return param1;
        }

        override protected function clickedButton(param1:MouseEvent):void {
            POPUPS.Next();
            this._action();
        }

        private function goToEventPage():void {
            navigateToURL(new URLRequest(WrathOfTheChampion.EVENT_PAGE_URL));
        }

        private function optInForEventEmails():void {
            ReplayableEventHandler.optInForEventEmails();
            GLOBAL.Message(KEYS.Get("msg_rsvpconfirmed", {"v1": LOGIN._email}));
        }
    }
}
