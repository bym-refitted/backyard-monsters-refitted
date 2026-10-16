package com.monsters.replayableEvents.attackDefend.brukkargWar.quotas {
    import com.monsters.frontPage.FrontPageGraphic;
    import com.monsters.replayableEvents.ReplayableEventQuota;
    import com.monsters.replayableEvents.attackDefend.AttackDefend;
    import com.monsters.replayableEvents.attackDefend.brukkargWar.messages.SpurtzCannonRewardMessage2;
    import com.monsters.replayableEvents.attackDefend.brukkargWar.rewards.SpurtzCannonReward1;
    import com.monsters.replayableEvents.attackDefend.brukkargWar.rewards.SpurtzCannonReward2;
    import com.monsters.replayableEvents.attackDefend.brukkargWar.rewards.SpurtzCannonReward3;
    import com.monsters.rewarding.RewardHandler;

    public class SpurtzCannonQuota2 extends ReplayableEventQuota {

        public function SpurtzCannonQuota2() {
            super(AttackDefend.SCORE_PER_YARD * 4, "events/brukkargWar/brukkarg_reward_2.png", SpurtzCannonReward2.ID, new SpurtzCannonRewardMessage2());
        }

        /**
         * Shows the reward message without the reward when the player already holds the last
         * Spurtz Cannon reward, as this one would unlock cannons on top of the ones they own.
         *
         * The first reward is removed before this one is applied, as removing it blocks the
         * Spurtz Cannon again and would leave the message's Build Now button doing nothing.
         */
        override public function metQuota():void {
            var hasThirdReward:Boolean = RewardHandler.instance.getRewardByID(SpurtzCannonReward3.ID) != null;

            if (hasThirdReward) {
                POPUPS.Push(new FrontPageGraphic(message));
                _dateAwarded = GLOBAL.Timestamp();
                return;
            }

            // super.metQuota();
            // RewardHandler.instance.removeRewardByID(SpurtzCannonReward1.ID);
            RewardHandler.instance.removeRewardByID(SpurtzCannonReward1.ID);
            super.metQuota();
        }
    }
}
