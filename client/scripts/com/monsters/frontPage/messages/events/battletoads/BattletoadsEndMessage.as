package com.monsters.frontPage.messages.events.battletoads {
    import com.monsters.frontPage.messages.KeywordMessage;

    public class BattletoadsEndMessage extends KeywordMessage {

        public function BattletoadsEndMessage() {
            super("event1end", null, null, false);
            this.imageURL = _IMAGE_DIRECTORY + "fp_event1end.v2.jpg";
        }
    }
}
