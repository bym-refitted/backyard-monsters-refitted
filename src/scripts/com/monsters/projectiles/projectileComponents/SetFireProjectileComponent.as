package com.monsters.projectiles.projectileComponents
{
   import com.monsters.interfaces.IAttackable;
   import com.monsters.interfaces.ITargetable;
   import com.monsters.monsters.MonsterBase;
   import com.monsters.monsters.components.statusEffects.FlameEffect;
   
   public class SetFireProjectileComponent extends ProjectileComponent
   {
       
      
      private var m_DoT:uint;
      
      public function SetFireProjectileComponent(param1:uint)
      {
         super();
         this.m_DoT = param1;
      }
      
      override public function onAttack(param1:IAttackable, param2:Number, param3:ITargetable = null) : Number
      {
         if(param1 is MonsterBase)
         {
            MonsterBase(param1).addStatusEffect(new FlameEffect(owner,this.m_DoT));
         }
         return param2;
      }
   }
}
