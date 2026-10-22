package com.monsters.replayableEvents.attackDefend.brukkargWar.rewards {
    import com.monsters.rewarding.Reward;
    import com.monsters.rewarding.RewardHandler;

    /**
     * Brukkarg War's Spurtz Cannon rewards. The server grants them (spurtzRewards.ts) and a player
     * holds at most one, each replacing the ones before it. The client only applies the one the
     * server reports, and never grants or removes one by itself.
     */
    public class SpurtzCannonRewards {

        private static const REWARD_IDS:Vector.<String> = Vector.<String>([SpurtzCannonReward1.ID, SpurtzCannonReward2.ID, SpurtzCannonReward3.ID]);

        /**
         * Whether the player holds a higher Spurtz Cannon reward than the given one. A reward that is
         * outranked is not applied, so only the highest one decides which cannons can be built.
         *
         * @param rewardID The reward to check
         * @return True when a higher one is held
         */
        public static function isOutranked(rewardID:String):Boolean {
            var rewardHandler:RewardHandler = RewardHandler.instance;
            var rank:int = REWARD_IDS.indexOf(rewardID);

            for (var higherRank:int = rank + 1; higherRank < REWARD_IDS.length; higherRank++) {
                if (rewardHandler.getRewardByID(REWARD_IDS[higherRank]))
                    return true;
            }

            return false;
        }

        /**
         * Makes the Spurtz Cannon reward the player holds the one the server reports. The others are
         * removed first, since removing one blocks the cannon again, and the held one is applied last.
         * Away from home this does nothing, as the next home load reads the rewards from the server.
         *
         * @param heldRewardID The reward the server reports, or null for none
         */
        public static function sync(heldRewardID:String):void {
            if (!GLOBAL.isAtHome())
                return;

            var rewardHandler:RewardHandler = RewardHandler.instance;

            for each (var rewardID:String in REWARD_IDS) {
                if (rewardID != heldRewardID)
                    rewardHandler.removeRewardByID(rewardID);
            }

            if (!heldRewardID)
                return;

            var heldReward:Reward = rewardHandler.updateExistingOrAddNewReward(heldRewardID);

            if (heldReward)
                rewardHandler.applyReward(heldReward);
        }
    }
}
