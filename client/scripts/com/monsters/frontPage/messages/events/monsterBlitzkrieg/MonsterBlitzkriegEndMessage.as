package com.monsters.frontPage.messages.events.monsterBlitzkrieg {
    import com.monsters.frontPage.messages.KeywordMessage;

    public class MonsterBlitzkriegEndMessage extends KeywordMessage {

        public function MonsterBlitzkriegEndMessage() {
            super("event2end", null, null, false);
            // this.imageURL = _IMAGE_DIRECTORY + "fp_event2start.v2.jpg";
            this.imageURL = _IMAGE_DIRECTORY + "fp_event2end.v2.jpg";
        }
    }
}
