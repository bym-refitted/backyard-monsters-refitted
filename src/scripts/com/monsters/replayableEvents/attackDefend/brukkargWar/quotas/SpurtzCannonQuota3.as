package com.monsters.replayableEvents.attackDefend.brukkargWar.quotas
{
   import com.monsters.replayableEvents.ReplayableEventQuota;
   import com.monsters.replayableEvents.attackDefend.AttackDefend;
   import com.monsters.replayableEvents.attackDefend.brukkargWar.messages.SpurtzCannonRewardMessage3;
   import com.monsters.replayableEvents.attackDefend.brukkargWar.rewards.SpurtzCannonReward2;
   import com.monsters.replayableEvents.attackDefend.brukkargWar.rewards.SpurtzCannonReward3;
   import com.monsters.rewarding.RewardHandler;
   
   public class SpurtzCannonQuota3 extends ReplayableEventQuota
   {
       
      
      public function SpurtzCannonQuota3()
      {
         super(AttackDefend.SCORE_PER_YARD * 5,"events/brukkargWar/brukkarg_reward_3.png",SpurtzCannonReward3.ID,new SpurtzCannonRewardMessage3());
      }
      
      override public function metQuota() : void
      {
         super.metQuota();
         RewardHandler.instance.removeRewardByID(SpurtzCannonReward2.ID);
      }
   }
}
