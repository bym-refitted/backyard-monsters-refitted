package com.monsters.subscriptions.rewards
{
   import com.monsters.display.CreepSkinManager;
   import com.monsters.events.CreepEvent;
   import com.monsters.rewarding.Reward;
   
   public class GoldenDAVEReward extends Reward
   {
      
      public static const ID:String = "goldenDAVE";
      
      private static const DAVE_CREEP_ID:String = "C12";
      
      private static const GOLD_SKIN_ID:String = "C12Gold";
       
      
      public function GoldenDAVEReward()
      {
         super();
      }
      
      override protected function onApplication() : void
      {
         var _loc1_:String = !!_value ? GOLD_SKIN_ID : null;
         CreepSkinManager.instance.SetSkin(DAVE_CREEP_ID,_loc1_);
         GLOBAL.eventDispatcher.addEventListener(CreepEvent.ATTACKING_MONSTER_SPAWNED,this.onAttackingCreepSpawned);
         GLOBAL.eventDispatcher.addEventListener(CreepEvent.DEFENDING_CREEP_SPAWNED,this.onDefendingCreepSpawned);
      }
      
      override public function removed() : void
      {
         CreepSkinManager.instance.SetSkin(DAVE_CREEP_ID,null);
         GLOBAL.eventDispatcher.removeEventListener(CreepEvent.ATTACKING_MONSTER_SPAWNED,this.onAttackingCreepSpawned);
         GLOBAL.eventDispatcher.removeEventListener(CreepEvent.DEFENDING_CREEP_SPAWNED,this.onDefendingCreepSpawned);
      }
      
      override public function reset() : void
      {
      }
      
      private function onAttackingCreepSpawned(param1:CreepEvent) : void
      {
         if(GLOBAL.isAtHomeOrInOutpost() && _value && param1.creep && param1.creep._creatureID == DAVE_CREEP_ID)
         {
            param1.creep.currentSkinOverride = DAVE_CREEP_ID;
         }
      }
      
      private function onDefendingCreepSpawned(param1:CreepEvent) : void
      {
         if(!GLOBAL.isAtHomeOrInOutpost() && _value && param1.creep && param1.creep._creatureID == DAVE_CREEP_ID)
         {
            param1.creep.currentSkinOverride = DAVE_CREEP_ID;
         }
      }
   }
}
