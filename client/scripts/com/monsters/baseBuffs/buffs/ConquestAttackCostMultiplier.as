package com.monsters.baseBuffs.buffs
{
   import com.monsters.monsters.components.modifiers.MultiplicationPropertyModifier;

   public class ConquestAttackCostMultiplier extends MultiplicationPropertyModifier
   {
      public function ConquestAttackCostMultiplier()
      {
         super(AllianceConquestBuff.k_AttackCostMultiplier);
      }
   }
}
