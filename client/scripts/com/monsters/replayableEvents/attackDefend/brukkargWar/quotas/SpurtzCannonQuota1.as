package com.monsters.replayableEvents.attackDefend.brukkargWar.quotas {
    import com.monsters.frontPage.FrontPageGraphic;
    import com.monsters.replayableEvents.ReplayableEventQuota;
    import com.monsters.replayableEvents.attackDefend.AttackDefend;
    import com.monsters.replayableEvents.attackDefend.brukkargWar.messages.SpurtzCannonRewardMessage1;
    import com.monsters.replayableEvents.attackDefend.brukkargWar.rewards.SpurtzCannonReward1;
    import com.monsters.replayableEvents.attackDefend.brukkargWar.rewards.SpurtzCannonReward2;
    import com.monsters.replayableEvents.attackDefend.brukkargWar.rewards.SpurtzCannonReward3;
    import com.monsters.rewarding.RewardHandler;

    public class SpurtzCannonQuota1 extends ReplayableEventQuota {

        public function SpurtzCannonQuota1() {
            super(AttackDefend.SCORE_PER_YARD * 3, "events/brukkargWar/brukkarg_reward_1.png", SpurtzCannonReward1.ID, new SpurtzCannonRewardMessage1());
        }

        /**
         * Shows the reward message without the reward when the player already holds a later
         * Spurtz Cannon reward, as this one would unlock a cannon on top of the ones they own.
         */
        override public function metQuota():void {
            var rewardHandler:RewardHandler = RewardHandler.instance;

            var hasSecondReward:Boolean = rewardHandler.getRewardByID(SpurtzCannonReward2.ID) != null;
            var hasThirdReward:Boolean = rewardHandler.getRewardByID(SpurtzCannonReward3.ID) != null;

            if (hasSecondReward || hasThirdReward) {
                POPUPS.Push(new FrontPageGraphic(message));
                _dateAwarded = GLOBAL.Timestamp();
                return;
            }

            super.metQuota();
        }
    }
}
