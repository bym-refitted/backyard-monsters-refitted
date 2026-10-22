// Kept for preservation only. Nothing uses this class any more, and it is commented out in full.
// 
// Brukkarg War's Spurtz Cannon rewards are now granted by the server (spurtzRewards.ts), and
// BrukkargWarEvent builds its reward quotas as ServerGrantedQuota, which only shows the popup.
// 
// This quota granted and removed its reward in the client, which proved unreliable:
// - Rewards re-apply on every load, in no fixed order. A player holding this reward next to a higher
// one could have the Spurtz Cannon unblocked alongside their two Black Diamond cannons.
// - SpurtzCannonReward3 turns every Spurtz Cannon into a Black Diamond one on load, so a cannon built
// that way became a third (or fourth) Black Diamond cannon after a refresh: one standard and one
// Diamond cannon before the refresh, both Diamond after it.
// - The client saved its rewards as it held them, so a save could add or drop this reward, as the
// Map Room yard wipe did when it saved an empty reward list.
// 
// The empty class below only gives the file the definition its name requires; the original follows it.

package com.monsters.replayableEvents.attackDefend.brukkargWar.quotas {
    public class SpurtzCannonQuota3 {
    }
}

// package com.monsters.replayableEvents.attackDefend.brukkargWar.quotas {
// import com.monsters.replayableEvents.ReplayableEventQuota;
// import com.monsters.replayableEvents.attackDefend.AttackDefend;
// import com.monsters.replayableEvents.attackDefend.brukkargWar.messages.SpurtzCannonRewardMessage3;
// import com.monsters.replayableEvents.attackDefend.brukkargWar.rewards.SpurtzCannonReward2;
// import com.monsters.replayableEvents.attackDefend.brukkargWar.rewards.SpurtzCannonReward3;
// import com.monsters.rewarding.RewardHandler;
// 
// public class SpurtzCannonQuota3 extends ReplayableEventQuota {
// 
// public function SpurtzCannonQuota3() {
// super(AttackDefend.SCORE_PER_YARD * 5, "events/brukkargWar/brukkarg_reward_3.png", SpurtzCannonReward3.ID, new SpurtzCannonRewardMessage3());
// }
// 
// override public function metQuota():void {
// super.metQuota();
// RewardHandler.instance.removeRewardByID(SpurtzCannonReward2.ID);
// }
// }
// }