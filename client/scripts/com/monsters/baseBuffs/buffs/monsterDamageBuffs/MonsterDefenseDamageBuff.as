package com.monsters.baseBuffs.buffs.monsterDamageBuffs
{
   import com.monsters.events.CreepEvent;
   
   public class MonsterDefenseDamageBuff extends MonsterDamageBuff
   {
       
      
      public function MonsterDefenseDamageBuff()
      {
         super(CreepEvent.DEFENDING_CREEP_SPAWNED);
      }
   }
}
