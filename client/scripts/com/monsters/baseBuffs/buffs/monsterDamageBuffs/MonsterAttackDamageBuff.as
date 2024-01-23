package com.monsters.baseBuffs.buffs.monsterDamageBuffs
{
   import com.monsters.events.CreepEvent;
   
   public class MonsterAttackDamageBuff extends MonsterDamageBuff
   {
       
      
      public function MonsterAttackDamageBuff()
      {
         super(CreepEvent.ATTACKING_MONSTER_SPAWNED);
      }
   }
}
