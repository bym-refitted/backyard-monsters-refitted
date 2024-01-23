package com.monsters.baseBuffs.buffs.monsterDamageBuffs
{
   import com.monsters.baseBuffs.BaseBuff;
   import com.monsters.events.CreepEvent;
   
   public class MonsterDamageBuff extends BaseBuff
   {
      
      public static const ID:uint = 5;
       
      
      private var m_eventType:String;
      
      public function MonsterDamageBuff(param1:String)
      {
         this.m_eventType = param1;
         super("Monster Damage","bufficons/monsterdamagebuff.png");
      }
      
      override public function get description() : String
      {
         return "";
      }
      
      override public function apply() : void
      {
         GLOBAL.eventDispatcher.addEventListener(this.m_eventType,this.spawnedDefendingCreep);
      }
      
      protected function spawnedDefendingCreep(param1:CreepEvent) : void
      {
         param1.creep.damageProperty.addModifier(new MonsterDamageMultiplier(getValue() * 0.01 + 1));
      }
      
      override public function clear() : void
      {
         GLOBAL.eventDispatcher.removeEventListener(this.m_eventType,this.spawnedDefendingCreep);
      }
   }
}

import com.monsters.monsters.components.modifiers.MultiplicationPropertyModifier;

class MonsterDamageMultiplier extends MultiplicationPropertyModifier
{
    
   
   public function MonsterDamageMultiplier(param1:Number)
   {
      super(param1);
   }
}
