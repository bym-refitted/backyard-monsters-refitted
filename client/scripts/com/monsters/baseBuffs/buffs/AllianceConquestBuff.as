package com.monsters.baseBuffs.buffs
{
   import com.monsters.baseBuffs.BaseBuff;
   import com.monsters.maproom_manager.MapRoomManager;
   
   public class AllianceConquestBuff extends BaseBuff
   {
      
      public static const k_AttackCostMultiplier:Number = 0.75;
      
      public static const ID:uint = 9;
       
      
      public function AllianceConquestBuff()
      {
         super("ap_conquest");
      }
      
      override public function get description() : String
      {
         return KEYS.Get(MapRoomManager.instance.isInMapRoom2 ? "ap_conquest_desc" : "nwm_ap_conquest_desc");
      }
      
      override public function apply() : void
      {
         MapRoomManager.instance.attackCostMultiplier.addModifier(new ConquestAttackCostMultiplier());
      }
      
      override public function clear() : void
      {
         MapRoomManager.instance.attackCostMultiplier.removeModifier(MapRoomManager.instance.attackCostMultiplier.getModifierByType(ConquestAttackCostMultiplier));
      }
   }
}

import com.monsters.monsters.components.modifiers.MultiplicationPropertyModifier;
import com.monsters.baseBuffs.buffs.AllianceConquestBuff;

class ConquestAttackCostMultiplier extends MultiplicationPropertyModifier
{
    
   
   public function ConquestAttackCostMultiplier()
   {
      super(AllianceConquestBuff.k_AttackCostMultiplier);
   }
}
