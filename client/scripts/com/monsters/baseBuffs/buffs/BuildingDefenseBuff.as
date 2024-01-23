package com.monsters.baseBuffs.buffs
{
   import com.monsters.baseBuffs.BaseBuff;
   import com.monsters.managers.InstanceManager;
   
   public class BuildingDefenseBuff extends BaseBuff
   {
      
      public static const ID:uint = 1;
       
      
      public function BuildingDefenseBuff()
      {
         super("Tower Defense","bufficons/towerdefensebuff.png");
      }
      
      override public function get description() : String
      {
         return "";
      }
      
      override public function apply() : void
      {
         var _loc3_:BFOUNDATION = null;
         var _loc1_:Vector.<Object> = InstanceManager.getInstancesByClass(BFOUNDATION);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            _loc3_ = _loc1_[_loc2_] as BFOUNDATION;
            _loc3_.armorProperty.addModifier(new BuildingDefenseMultiplier(getValue() * 0.01));
            _loc2_++;
         }
      }
      
      override public function clear() : void
      {
         var _loc3_:BFOUNDATION = null;
         var _loc1_:Vector.<Object> = InstanceManager.getInstancesByClass(BFOUNDATION);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            _loc3_ = _loc1_[_loc2_] as BFOUNDATION;
            _loc3_.armorProperty.removeModifier(_loc3_.damageProperty.getModifierByType(BuildingDefenseMultiplier));
            _loc2_++;
         }
      }
   }
}

import com.monsters.monsters.components.modifiers.ArmorPropertyModifier;

class BuildingDefenseMultiplier extends ArmorPropertyModifier
{
    
   
   public function BuildingDefenseMultiplier(param1:Number)
   {
      super(param1);
   }
}
