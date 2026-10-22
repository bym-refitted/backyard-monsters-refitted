package com.monsters.replayableEvents {
    import com.monsters.frontPage.FrontPageGraphic;
    import com.monsters.frontPage.messages.Message;

    /**
     * A quota whose reward the server grants. Meeting it only shows its message, as the reward comes
     * back with the server's reply to the score. It keeps its rewardID so the event's reward ribbons
     * still show the reward.
     */
    public class ServerGrantedQuota extends ReplayableEventQuota {

        public function ServerGrantedQuota(quota:Number, imageURL:String, rewardID:String, message:Message) {
            super(quota, imageURL, rewardID, message);
        }

        override public function metQuota():void {
            if (message)
                POPUPS.Push(new FrontPageGraphic(message));

            _dateAwarded = GLOBAL.Timestamp();
        }
    }
}
