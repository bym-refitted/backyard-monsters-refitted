package com.monsters.baseBuffs.buffs
{
   import com.monsters.baseBuffs.BaseBuff;
   import com.monsters.managers.InstanceManager;
   
   public class TowerDamageBuff extends BaseBuff
   {
      
      public static const ID:uint = 6;
       
      
      public function TowerDamageBuff()
      {
         super("Tower Damage","bufficons/towerdamagebuff.png");
      }
      
      override public function get description() : String
      {
         return "";
      }
      
      override public function apply() : void
      {
         var _loc3_:BTOWER = null;
         var _loc1_:Vector.<Object> = InstanceManager.getInstancesByClass(BTOWER);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            _loc3_ = _loc1_[_loc2_] as BTOWER;
            _loc3_.damageProperty.addModifier(new TowerDamageMultiplier(getValue() * 0.01 + 1));
            _loc2_++;
         }
      }
      
      override public function clear() : void
      {
         var _loc3_:BTOWER = null;
         var _loc1_:Vector.<Object> = InstanceManager.getInstancesByClass(BTOWER);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            _loc3_ = _loc1_[_loc2_] as BTOWER;
            _loc3_.damageProperty.removeModifier(_loc3_.damageProperty.getModifierByType(TowerDamageMultiplier));
            _loc2_++;
         }
      }
   }
}

import com.monsters.monsters.components.modifiers.MultiplicationPropertyModifier;

class TowerDamageMultiplier extends MultiplicationPropertyModifier
{
    
   
   public function TowerDamageMultiplier(param1:Number)
   {
      super(param1);
   }
}
