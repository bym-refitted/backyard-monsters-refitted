package com.monsters.monsters.components.abilities
{
   import com.monsters.monsters.MonsterBase;
   import flash.events.Event;
   
   public class AOEDamageOnDeath extends AOEDamage
   {
       
      
      public function AOEDamageOnDeath(radiusOuter:uint, targetFlags:int, maxTargets:uint = 4294967295)
      {
         super(radiusOuter,targetFlags,maxTargets);
      }
      
      override protected function onRegister() : void
      {
         owner.addEventListener(MonsterBase.k_DEATH_EVENT,this.onDeath);
      }
      
      override protected function onUnregister() : void
      {
         owner.removeEventListener(MonsterBase.k_DEATH_EVENT,this.onDeath);
      }
      
      protected function onDeath(param1:Event = null) : void
      {
         var _loc2_:Number = owner.damage * (1 + owner.powerUpLevel() * 0.5);
         dealAOEDamage(_loc2_);
      }
   }
}
