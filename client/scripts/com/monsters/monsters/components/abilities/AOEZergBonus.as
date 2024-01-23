package com.monsters.monsters.components.abilities
{
   import com.monsters.monsters.MonsterBase;
   import com.monsters.monsters.components.Component;
   import flash.geom.Point;
   
   public class AOEZergBonus extends Component
   {
       
      
      protected var m_type:String;
      
      protected var m_radius:Number;
      
      protected var m_modifierPerUnit:Number;
      
      protected var m_maxBonus:Number;
      
      public function AOEZergBonus(param1:String, param2:Number = 200, param3:Number = 0.5, param4:Number = 10)
      {
         super();
         this.m_modifierPerUnit = param3;
         this.m_radius = param2;
         this.m_type = param1;
         this.m_maxBonus = param4;
      }
      
      override public function tick(param1:int = 1) : void
      {
         var _loc3_:int = 0;
         var _loc2_:Array = Targeting.getAllBUTTargetsInRange(this.m_radius,new Point(owner.x,owner.y),owner.targetMode);
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_.length)
         {
            if(MonsterBase(_loc2_.creep)._creatureID == this.m_type)
            {
               _loc3_++;
               if(_loc3_ >= this.m_maxBonus)
               {
                  break;
               }
            }
            _loc4_++;
         }
         var _loc5_:ZergDamageModifier = owner.damageProperty.getModifierByType(ZergDamageModifier) as ZergDamageModifier;
         var _loc6_:ZergArmorModifier = owner.armorProperty.getModifierByType(ZergArmorModifier) as ZergArmorModifier;
         if(_loc3_)
         {
            if(!_loc5_)
            {
               _loc5_ = new ZergDamageModifier();
               _loc6_ = new ZergArmorModifier();
            }
            _loc6_.multiple = _loc3_ * this.m_modifierPerUnit;
            _loc5_.multiple = _loc3_ * this.m_modifierPerUnit;
         }
         else if(_loc5_)
         {
            owner.damageProperty.removeModifier(_loc5_);
            owner.armorProperty.removeModifier(_loc6_);
         }
      }
   }
}

import com.monsters.monsters.components.modifiers.MultiplicationPropertyModifier;

class ZergDamageModifier extends MultiplicationPropertyModifier
{
    
   
   public function ZergDamageModifier(param1:Number = 0)
   {
      super(param1);
   }
}

import com.monsters.monsters.components.modifiers.ArmorPropertyModifier;

class ZergArmorModifier extends ArmorPropertyModifier
{
    
   
   public function ZergArmorModifier(param1:Number = 0)
   {
      super(param1);
   }
}
