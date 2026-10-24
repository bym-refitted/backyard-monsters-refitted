package com.monsters.replayableEvents.looting.wotc.messages {
    import com.monsters.frontPage.messages.KeywordMessage;

    public class WOTCRewardMessage1 extends KeywordMessage {

        public function WOTCRewardMessage1() {
            super("wotcreward1", "btn_brag");
        }

        override protected function onButtonClick():void {
            GLOBAL.Brag("event6-reward", "wotcreward1_streamtitle", "wotcreward1_streambody", "wotcreward1_stream.png");
            POPUPS.Next();
        }
    }
}
