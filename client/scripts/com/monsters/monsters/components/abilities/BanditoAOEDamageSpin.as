package com.monsters.monsters.components.abilities
{
   public class BanditoAOEDamageSpin extends AOEDamageOnAttack
   {
       
      
      public function BanditoAOEDamageSpin(radiusOuter:uint, targetFlags:int, radiusInner:uint = 0, includeInitialTarget:Boolean = true, maxTargets:uint = 4294967295, rechargeDuration:int = 0)
      {
         super(radiusOuter,targetFlags,maxTargets,radiusInner,includeInitialTarget,rechargeDuration);
      }
      
      override public function tick(param1:int = 1) : void
      {
         if(Boolean(owner._targetCreep) && owner._atTarget)
         {
            owner._lockRotation = true;
            owner._targetRotation += owner.attackCooldown * (6 * (0.5 + owner.powerUpLevel() * 0.5));
         }
         else
         {
            owner._lockRotation = false;
         }
      }
      
      override protected function onRegister() : void
      {
         owner.attackDelayProperty.value = owner.attackDelay / (1 + owner.powerUpLevel() * 0.5);
      }
   }
}
