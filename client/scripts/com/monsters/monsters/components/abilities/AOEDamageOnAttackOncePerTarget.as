package com.monsters.monsters.components.abilities
{
   import com.monsters.interfaces.IAttackable;
   import com.monsters.interfaces.ITargetable;
   
   public class AOEDamageOnAttackOncePerTarget extends AOEDamageOnAttack
   {
       
      
      protected var m_lastTarget:IAttackable;
      
      protected var m_damageMultiplier:Number;
      
      public function AOEDamageOnAttackOncePerTarget(param1:uint, param2:int, param3:Number = 1, param4:uint = 4294967295, param5:int = 0)
      {
         super(param1,param2,param4,param5);
         this.m_damageMultiplier = param3;
      }
      
      override public function onAttack(param1:IAttackable, param2:Number, param3:ITargetable = null) : Number
      {
         if(GLOBAL.Timestamp() > m_timeAbilityIsRecharged && param1 != this.m_lastTarget)
         {
            dealAOEDamage(param2 * this.m_damageMultiplier);
            this.m_lastTarget = param1;
         }
         return 0;
      }
   }
}
