package com.monsters.replayableEvents.attackDefend.brukkargWar.quotas
{
   import com.monsters.replayableEvents.ReplayableEventQuota;
   import com.monsters.replayableEvents.attackDefend.AttackDefend;
   import com.monsters.replayableEvents.attackDefend.brukkargWar.messages.SpurtzCannonRewardMessage1;
   import com.monsters.replayableEvents.attackDefend.brukkargWar.rewards.SpurtzCannonReward1;
   
   public class SpurtzCannonQuota1 extends ReplayableEventQuota
   {
       
      
      public function SpurtzCannonQuota1()
      {
         super(AttackDefend.SCORE_PER_YARD * 3,"events/brukkargWar/brukkarg_reward_1.png",SpurtzCannonReward1.ID,new SpurtzCannonRewardMessage1());
      }
   }
}
