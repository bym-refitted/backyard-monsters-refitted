package com.monsters.replayableEvents.looting.wotc.rewards {
    import com.monsters.replayableEvents.attacking.monsterMadness.MonsterMadness;
    import com.monsters.rewarding.RewardHandler;

    /**
     * Monster Madness's Korath reward. The server grants it (korathRewards.ts): one reward whose value
     * is the level held, 1 for Korath, 2 for Breath of Fire and 3 for Fists of Doom, never lowered.
     * The client only applies the level the server reports, and never grants or raises it by itself.
     */
    public class KorathRewards {

        /**
         * Makes the Korath level the player holds the one the server reports. Away from home this does
         * nothing, as the next home load reads the rewards from the server.
         *
         * @param heldLevel The level the server reports, or 0 for none
         */
        public static function sync(heldLevel:int):void {
            if (!GLOBAL.isAtHome())
                return;

            var hasKorath:Boolean = heldLevel > 0;

            if (!hasKorath) {
                RewardHandler.instance.removeRewardByID(KorathReward.k_REWARD_ID);
                return;
            }

            MonsterMadness.setKorathPowerLevel(heldLevel);
        }
    }
}
