package com.monsters.rewarding.rewards.rezghul
{
   import com.monsters.rewarding.rewards.UnblockUnlockMonsterAward;
   
   public class UnlockRezghulReward extends UnblockUnlockMonsterAward
   {
      
      public static const k_REWARD_ID:String = "unlockRezghul";
       
      
      public function UnlockRezghulReward()
      {
         super("C19");
      }
      
      override protected function onApplication() : void
      {
         super.onApplication();
      }
   }
}
