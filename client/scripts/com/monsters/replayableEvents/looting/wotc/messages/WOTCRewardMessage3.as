package com.monsters.replayableEvents.looting.wotc.messages {
    import com.monsters.frontPage.messages.KeywordMessage;

    public class WOTCRewardMessage3 extends KeywordMessage {

        public function WOTCRewardMessage3() {
            super("wotcreward3", "btn_brag");
        }

        override protected function onButtonClick():void {
            GLOBAL.Brag("event6-reward", "wotcreward3_streamtitle", "wotcreward3_streambody", "wotcreward3_stream.png");
            POPUPS.Next();
        }
    }
}
