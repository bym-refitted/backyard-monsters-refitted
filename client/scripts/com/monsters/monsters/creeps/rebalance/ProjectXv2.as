package com.monsters.monsters.creeps.rebalance
{
   import com.monsters.interfaces.IAttackable;
   import com.monsters.interfaces.ITargetable;
   import com.monsters.monsters.MonsterBase;
   import com.monsters.monsters.components.abilities.AOEDamageOnDeath;
   import com.monsters.monsters.components.abilities.AcidOnDeath;
   import com.monsters.monsters.components.modifiers.AdditionPropertyModifier;
   import com.monsters.monsters.creeps.CreepBase;
   import flash.geom.Point;
   
   public class ProjectXv2 extends CreepBase
   {
       
      
      private var m_damageComponent:AOEDamageOnDeath;
      
      private var m_acidComponent:AcidOnDeath;
      
      private var m_lastingDamageModifier:AdditionPropertyModifier;
      
      public function ProjectXv2(param1:String, param2:String, param3:Point, param4:Number, param5:int = 0, param6:int = 2147483647, param7:Point = null, param8:Boolean = false, param9:BFOUNDATION = null, param10:Number = 1, param11:Boolean = false, param12:MonsterBase = null)
      {
         var _loc13_:* = 0;
         super(param1,param2,param3,param4,param5,param6,param7,param8,param9,param10,param11,param12);
         _loc13_ = Targeting.k_TARGETS_BUILDINGS | Targeting.k_TARGETS_GROUND;
         if(param8)
         {
            _loc13_ |= Targeting.k_TARGETS_ATTACKERS;
         }
         else
         {
            _loc13_ |= Targeting.k_TARGETS_DEFENDERS;
         }
         this.m_damageComponent = addComponent(new AOEDamageOnDeath(60,_loc13_)) as AOEDamageOnDeath;
         this.m_acidComponent = addComponent(new AcidOnDeath(60,100,10)) as AcidOnDeath;
         this.m_lastingDamageModifier = new AdditionPropertyModifier();
         damageProperty.addModifier(this.m_lastingDamageModifier);
      }
      
      override protected function attacked(param1:IAttackable, param2:Number, param3:ITargetable = null) : void
      {
         ++this.m_lastingDamageModifier.value;
         super.attacked(param1,param2,param3);
      }
      
      override public function die() : void
      {
         super.die();
      }
   }
}
