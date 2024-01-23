package com.monsters.monsters.components.abilities
{
   import com.monsters.interfaces.IAttackable;
   import com.monsters.interfaces.ITargetable;
   import com.monsters.monsters.components.IAttackingComponent;
   
   public class AOEDamageOnAttack extends AOEDamage implements IAttackingComponent
   {
       
      
      protected var m_rechargeDuration:int;
      
      protected var m_timeAbilityIsRecharged:Number = 0;
      
      public function AOEDamageOnAttack(param1:uint, param2:int, param3:uint = 4294967295, param4:int = 0)
      {
         super(param1,param2,param3);
         this.m_rechargeDuration = param4;
      }
      
      public function onAttack(param1:IAttackable, param2:Number, param3:ITargetable = null) : Number
      {
         if(GLOBAL.Timestamp() > this.m_timeAbilityIsRecharged)
         {
            this.dealAOEDamage(param2);
         }
         return 0;
      }
      
      override protected function dealAOEDamage(param1:Number) : void
      {
         super.dealAOEDamage(param1);
         this.m_timeAbilityIsRecharged = GLOBAL.Timestamp() + this.m_rechargeDuration;
      }
   }
}
