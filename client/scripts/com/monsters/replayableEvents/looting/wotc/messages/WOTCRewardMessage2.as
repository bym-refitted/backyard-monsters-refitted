package com.monsters.replayableEvents.looting.wotc.messages {
    import com.monsters.frontPage.messages.KeywordMessage;

    public class WOTCRewardMessage2 extends KeywordMessage {

        public function WOTCRewardMessage2() {
            super("wotcreward2", "btn_brag");
        }

        override protected function onButtonClick():void {
            GLOBAL.Brag("event6-reward", "wotcreward2_streamtitle", "wotcreward2_streambody", "wotcreward2_stream.png");
            POPUPS.Next();
        }
    }
}
