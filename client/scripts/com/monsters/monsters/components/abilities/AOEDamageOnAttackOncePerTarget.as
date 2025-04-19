package com.monsters.monsters.components.abilities
{
   import com.monsters.interfaces.IAttackable;
   import com.monsters.interfaces.ITargetable;
   
   public class AOEDamageOnAttackOncePerTarget extends AOEDamageOnAttack
   {
       
      
      protected var m_lastTarget:IAttackable;
      
      protected var m_damageMultiplier:Number;
      
      public function AOEDamageOnAttackOncePerTarget(radiusOuter:uint, targetFlags:int, damageMultiplier:Number = 1, maxTargets:uint = 4294967295, radiusInner:uint = 0, includeInitialTarget:Boolean = true, rechargeDuration:int = 0)
      {
         super(radiusOuter,targetFlags,maxTargets,radiusInner,includeInitialTarget,rechargeDuration);
         this.m_damageMultiplier = damageMultiplier;
      }
      
      override public function onAttack(target:IAttackable, damageDealt:Number, projectile:ITargetable = null) : Number
      {
         if(GLOBAL.Timestamp() > m_timeAbilityIsRecharged && target != this.m_lastTarget)
         {
            dealAOEDamage(damageDealt * this.m_damageMultiplier, target);
            this.m_lastTarget = target;
         }
         return 0;
      }
   }
}
