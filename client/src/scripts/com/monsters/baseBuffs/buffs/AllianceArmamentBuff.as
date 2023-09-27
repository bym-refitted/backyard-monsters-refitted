package com.monsters.baseBuffs.buffs
{
   import com.monsters.baseBuffs.BaseBuff;
   import com.monsters.managers.InstanceManager;
   import com.monsters.maproom_manager.MapRoomManager;
   
   public class AllianceArmamentBuff extends BaseBuff
   {
      
      public static const k_ArmorMultiplier:Number = 1.5;
      
      public static const k_DamageMultiplier:Number = 1.25;
      
      public static const ID:uint = 8;
       
      
      public function AllianceArmamentBuff()
      {
         super("ap_armament");
      }
      
      override public function get description() : String
      {
         return KEYS.Get(MapRoomManager.instance.isInMapRoom2 ? "ap_armament_desc" : "nwm_ap_armament_desc");
      }
      
      override public function apply() : void
      {
         var _loc3_:BFOUNDATION = null;
         var _loc4_:BTRAP = null;
         var _loc1_:Vector.<Object> = InstanceManager.getInstancesByClass(BFOUNDATION);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            _loc3_ = _loc1_[_loc2_] as BFOUNDATION;
            if(_loc3_ is BTOWER || _loc3_ is BWALL)
            {
               _loc3_.maxHealthProperty.store();
               _loc3_.maxHealthProperty.addModifier(new ArmamentBuildingDefenseMultiplier());
               _loc3_.maxHealthProperty.updateHealth();
            }
            _loc2_++;
         }
         _loc1_ = InstanceManager.getInstancesByClass(BTRAP);
         _loc2_ = 0;
         while(_loc2_ < _loc1_.length)
         {
            (_loc4_ = _loc1_[_loc2_] as BTRAP).damageProperty.addModifier(new ArmamentTrapDamageMultiplier());
            _loc2_++;
         }
      }
      
      override public function clear() : void
      {
         var _loc3_:BFOUNDATION = null;
         var _loc4_:BTRAP = null;
         var _loc1_:Vector.<Object> = InstanceManager.getInstancesByClass(BFOUNDATION);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            _loc3_ = _loc1_[_loc2_] as BFOUNDATION;
            if(_loc3_ is BTOWER || _loc3_ is BWALL)
            {
               _loc3_.maxHealthProperty.store();
               _loc3_.maxHealthProperty.removeModifier(_loc3_.maxHealthProperty.getModifierByType(ArmamentBuildingDefenseMultiplier));
               _loc3_.maxHealthProperty.updateHealth();
            }
            _loc2_++;
         }
         _loc1_ = InstanceManager.getInstancesByClass(BTRAP);
         _loc2_ = 0;
         while(_loc2_ < _loc1_.length)
         {
            (_loc4_ = _loc1_[_loc2_] as BTRAP).damageProperty.removeModifier(_loc4_.damageProperty.getModifierByType(ArmamentTrapDamageMultiplier));
            _loc2_++;
         }
      }
   }
}

import com.monsters.baseBuffs.buffs.AllianceArmamentBuff;
import com.monsters.monsters.components.modifiers.MultiplicationPropertyModifier;

class ArmamentBuildingDefenseMultiplier extends MultiplicationPropertyModifier
{
    
   
   public function ArmamentBuildingDefenseMultiplier()
   {
      super(AllianceArmamentBuff.k_ArmorMultiplier);
   }
}

import com.monsters.baseBuffs.buffs.AllianceArmamentBuff;
import com.monsters.monsters.components.modifiers.MultiplicationPropertyModifier;

class ArmamentTrapDamageMultiplier extends MultiplicationPropertyModifier
{
    
   
   public function ArmamentTrapDamageMultiplier()
   {
      super(AllianceArmamentBuff.k_DamageMultiplier);
   }
}
