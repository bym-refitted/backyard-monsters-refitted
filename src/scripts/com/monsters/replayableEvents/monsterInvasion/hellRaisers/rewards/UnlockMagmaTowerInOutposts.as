package com.monsters.replayableEvents.monsterInvasion.hellRaisers.rewards
{
   import com.monsters.rewarding.Reward;
   
   public class UnlockMagmaTowerInOutposts extends Reward
   {
      
      public static const ID:String = "magmaTowersInOutpostsReward";
       
      
      public function UnlockMagmaTowerInOutposts()
      {
         super();
      }
      
      override protected function onApplication() : void
      {
         GLOBAL._buildingProps[INFERNO_MAGMA_TOWER.ID - 1].block = false;
         GLOBAL._buildingProps[INFERNO_MAGMA_TOWER.ID - 1].quantity = [value];
      }
      
      override public function removed() : void
      {
         GLOBAL._buildingProps[INFERNO_MAGMA_TOWER.ID - 1].block = false;
      }
      
      override public function reset() : void
      {
         if(this.canBeApplied())
         {
            this.removed();
         }
      }
      
      override public function canBeApplied() : Boolean
      {
         return GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD && BASE.isOutpost;
      }
   }
}
