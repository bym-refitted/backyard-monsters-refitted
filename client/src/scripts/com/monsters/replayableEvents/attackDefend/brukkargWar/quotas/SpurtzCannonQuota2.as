package com.monsters.replayableEvents.attackDefend.brukkargWar.quotas
{
   import com.monsters.replayableEvents.ReplayableEventQuota;
   import com.monsters.replayableEvents.attackDefend.AttackDefend;
   import com.monsters.replayableEvents.attackDefend.brukkargWar.messages.SpurtzCannonRewardMessage2;
   import com.monsters.replayableEvents.attackDefend.brukkargWar.rewards.SpurtzCannonReward1;
   import com.monsters.replayableEvents.attackDefend.brukkargWar.rewards.SpurtzCannonReward2;
   import com.monsters.rewarding.RewardHandler;
   
   public class SpurtzCannonQuota2 extends ReplayableEventQuota
   {
       
      
      public function SpurtzCannonQuota2()
      {
         super(AttackDefend.SCORE_PER_YARD * 4,"events/brukkargWar/brukkarg_reward_2.png",SpurtzCannonReward2.ID,new SpurtzCannonRewardMessage2());
      }
      
      override public function metQuota() : void
      {
         super.metQuota();
         RewardHandler.instance.removeRewardByID(SpurtzCannonReward1.ID);
      }
   }
}
