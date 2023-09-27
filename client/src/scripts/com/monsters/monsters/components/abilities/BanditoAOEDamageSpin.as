package com.monsters.monsters.components.abilities
{
   public class BanditoAOEDamageSpin extends AOEDamageOnAttack
   {
       
      
      public function BanditoAOEDamageSpin(param1:uint, param2:int, param3:uint = 4294967295, param4:int = 0)
      {
         super(param1,param2 & ~Targeting.k_TARGETS_BUILDINGS,param3,param4);
      }
      
      override public function tick(param1:int = 1) : void
      {
         if(Boolean(owner._targetCreep) && owner._atTarget)
         {
            owner._targetRotation += owner.attackCooldown * (6 * (0.5 + owner.powerUpLevel() * 0.5));
         }
      }
      
      override protected function onRegister() : void
      {
         owner.attackDelayProperty.value = owner.attackDelay / (1 + owner.powerUpLevel() * 0.5);
      }
   }
}
