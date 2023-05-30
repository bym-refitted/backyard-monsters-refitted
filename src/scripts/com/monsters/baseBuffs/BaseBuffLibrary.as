package com.monsters.baseBuffs
{
   import com.monsters.baseBuffs.buffs.AllianceArmamentBuff;
   import com.monsters.baseBuffs.buffs.AllianceConquestBuff;
   import com.monsters.baseBuffs.buffs.AllianceDeclareWarBuff;
   import com.monsters.baseBuffs.buffs.AutoBankBaseBuff;
   import com.monsters.baseBuffs.buffs.BuildingDefenseBuff;
   import com.monsters.baseBuffs.buffs.ResourceCapacityBaseBuff;
   import com.monsters.baseBuffs.buffs.TowerDamageBuff;
   import com.monsters.baseBuffs.buffs.monsterDamageBuffs.MonsterAttackDamageBuff;
   import com.monsters.baseBuffs.buffs.monsterDamageBuffs.MonsterDamageBuff;
   import com.monsters.baseBuffs.buffs.monsterDamageBuffs.MonsterDefenseDamageBuff;
   import com.monsters.debug.Console;
   
   public class BaseBuffLibrary
   {
      
      public static const k_ATTACKING:String = "attacking";
      
      public static const k_DEFENDING:String = "defending";
      
      private static var m_buffTypes:Object = {};
       
      
      public function BaseBuffLibrary()
      {
         super();
      }
      
      internal static function initialize() : void
      {
         addBaseBuff(TowerDamageBuff.ID,new BuffData(TowerDamageBuff));
         addBaseBuff(BuildingDefenseBuff.ID,new BuffData(BuildingDefenseBuff));
         addBaseBuff(MonsterDamageBuff.ID,new BuffData(MonsterAttackDamageBuff,k_ATTACKING),new BuffData(MonsterDefenseDamageBuff,k_DEFENDING));
         addBaseBuff(AllianceArmamentBuff.ID,new BuffData(AllianceArmamentBuff));
         addBaseBuff(AllianceConquestBuff.ID,new BuffData(AllianceConquestBuff));
         addBaseBuff(ResourceCapacityBaseBuff.ID,new BuffData(ResourceCapacityBaseBuff));
         addBaseBuff(AutoBankBaseBuff.ID,new BuffData(AutoBankBaseBuff));
         addBaseBuff(AllianceDeclareWarBuff.ID,new BuffData(AllianceDeclareWarBuff));
      }
      
      private static function addBaseBuff(param1:uint, ... rest) : void
      {
         var _loc4_:BuffData = null;
         if(m_buffTypes[param1])
         {
            Console.print("You tried to add the BaseBuff(" + param1 + ") that already exists");
            return;
         }
         var _loc3_:int = 0;
         while(_loc3_ < rest.length)
         {
            _loc4_ = rest[_loc3_];
            rest[_loc4_.state] = _loc4_;
            _loc3_++;
         }
         m_buffTypes[param1] = rest;
      }
      
      public static function getBuffByID(param1:uint, param2:String = "") : BaseBuff
      {
         var _loc4_:BuffData = null;
         var _loc5_:BaseBuff = null;
         if(!param2)
         {
            param2 = k_DEFENDING;
         }
         var _loc3_:Array = m_buffTypes[param1];
         if(_loc3_)
         {
            if(_loc4_ = _loc3_[param2])
            {
               (_loc5_ = new _loc4_.type() as BaseBuff).id = param1;
               return _loc5_;
            }
         }
         Console.print("There is no BassBuff in the BaseBuffLibrary with an id of " + param1 + " for the state " + param2);
         return null;
      }
   }
}

import com.monsters.baseBuffs.BaseBuffLibrary;

class BuffData
{
    
   
   public var type:Class;
   
   public var state:String;
   
   public function BuffData(param1:Class, param2:String = "")
   {
      super();
      this.type = param1;
      if(!param2)
      {
         param2 = BaseBuffLibrary.k_DEFENDING;
      }
      this.state = param2;
   }
}
