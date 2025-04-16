package com.monsters.monsters.components.abilities
{
   import com.monsters.interfaces.IAttackable;
   import com.monsters.interfaces.ITargetable;
   import com.monsters.monsters.components.IAttackingComponent;
   
   public class AOEDamageOnAttack extends AOEDamage implements IAttackingComponent
   {
       
      
      protected var m_rechargeDuration:int;
      
      protected var m_timeAbilityIsRecharged:Number = 0;
      
      public function AOEDamageOnAttack(radiusOuter:uint, targetFlags:int, maxTargets:uint = 4294967295, radiusInner:uint = 0, includeInitialTarget:Boolean = true, rechargeDuration:int = 0)
      {
         super(radiusOuter,targetFlags,maxTargets,radiusInner,includeInitialTarget);
         this.m_rechargeDuration = rechargeDuration;
      }
      
      public function onAttack(target:IAttackable, damageDealt:Number, projectile:ITargetable = null) : Number
      {
         if(GLOBAL.Timestamp() > this.m_timeAbilityIsRecharged)
         {
            this.dealAOEDamage(damageDealt, target);
         }
         return 0;
      }
      
      override protected function dealAOEDamage(damage:Number, initialTarget:IAttackable = null) : void
      {
         super.dealAOEDamage(damage, initialTarget);
         this.m_timeAbilityIsRecharged = GLOBAL.Timestamp() + this.m_rechargeDuration;
      }
   }
}
