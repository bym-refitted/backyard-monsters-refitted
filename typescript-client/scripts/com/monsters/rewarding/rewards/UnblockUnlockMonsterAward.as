package com.monsters.rewarding.rewards
{
   public class UnblockUnlockMonsterAward extends UnblockMonsterAward
   {
       
      
      public function UnblockUnlockMonsterAward(param1:String)
      {
         super(param1);
      }
      
      override protected function onApplication() : void
      {
         CREATURELOCKER._lockerData[_monsterID] = {"t":2};
         super.onApplication();
      }
      
      override public function reset() : void
      {
         delete CREATURELOCKER._lockerData[_monsterID];
         super.reset();
      }
   }
}
