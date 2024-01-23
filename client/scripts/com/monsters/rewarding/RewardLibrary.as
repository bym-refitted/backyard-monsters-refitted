package com.monsters.rewarding
{
   import com.monsters.debug.Console;
   import com.monsters.kingOfTheHill.rewards.KrallenBuffReward;
   import com.monsters.kingOfTheHill.rewards.KrallenReward;
   import com.monsters.replayableEvents.attackDefend.brukkargWar.rewards.SpurtzCannonReward1;
   import com.monsters.replayableEvents.attackDefend.brukkargWar.rewards.SpurtzCannonReward2;
   import com.monsters.replayableEvents.attackDefend.brukkargWar.rewards.SpurtzCannonReward3;
   import com.monsters.replayableEvents.looting.wotc.rewards.KorathReward;
   import com.monsters.replayableEvents.monsterInvasion.hellRaisers.rewards.UnlockMagmaTowerInOutposts;
   import com.monsters.rewarding.rewards.rezghul.UnlockRezghulReward;
   import com.monsters.rewarding.rewards.slimeattikus.UnblockSlimeattikusReward;
   import com.monsters.rewarding.rewards.slimeattikus.UnlockSlimeattikusReward;
   import com.monsters.rewarding.rewards.vorg.UnblockVorgReward;
   import com.monsters.rewarding.rewards.vorg.UnlockVorgReward;
   import com.monsters.subscriptions.rewards.DAVEStatueReward;
   import com.monsters.subscriptions.rewards.ExtraTilesReward;
   import com.monsters.subscriptions.rewards.GoldenDAVEReward;
   import com.monsters.subscriptions.rewards.ImprovedHCCReward;
   import com.monsters.subscriptions.rewards.YardPlannerExtraSlotsReward;
   
   public class RewardLibrary
   {
      
      public static var rewardTypes:Object;
       
      
      public function RewardLibrary()
      {
         super();
      }
      
      public static function initialize() : void
      {
         rewardTypes = {};
         addRewardType(UnlockVorgReward.ID,UnlockVorgReward);
         addRewardType(UnlockSlimeattikusReward.ID,UnlockSlimeattikusReward);
         addRewardType(UnblockSlimeattikusReward.ID,UnblockSlimeattikusReward);
         addRewardType(UnblockVorgReward.ID,UnblockVorgReward);
         addRewardType(UnlockMagmaTowerInOutposts.ID,UnlockMagmaTowerInOutposts);
         addRewardType(KrallenReward.ID,KrallenReward);
         addRewardType(KrallenBuffReward.ID,KrallenBuffReward);
         addRewardType(DAVEStatueReward.ID,DAVEStatueReward);
         addRewardType(ExtraTilesReward.ID,ExtraTilesReward);
         addRewardType(GoldenDAVEReward.ID,GoldenDAVEReward);
         addRewardType(ImprovedHCCReward.ID,ImprovedHCCReward);
         addRewardType(YardPlannerExtraSlotsReward.ID,YardPlannerExtraSlotsReward);
         addRewardType(SpurtzCannonReward1.ID,SpurtzCannonReward1);
         addRewardType(SpurtzCannonReward2.ID,SpurtzCannonReward2);
         addRewardType(SpurtzCannonReward3.ID,SpurtzCannonReward3);
         addRewardType(KorathReward.k_REWARD_ID,KorathReward);
         addRewardType(UnlockRezghulReward.k_REWARD_ID,UnlockRezghulReward);
      }
      
      public static function addRewardType(param1:String, param2:Class) : void
      {
         if(rewardTypes[param1])
         {
            Console.warning("You tried to add the reward(" + param1 + ") that already exists");
         }
         rewardTypes[param1] = param2;
      }
      
      public static function getRewardByID(param1:String) : Reward
      {
         var _loc3_:Reward = null;
         var _loc2_:Class = rewardTypes[param1];
         if(_loc2_)
         {
            _loc3_ = new _loc2_() as Reward;
            _loc3_.id = param1;
            return _loc3_;
         }
         return null;
      }
   }
}
