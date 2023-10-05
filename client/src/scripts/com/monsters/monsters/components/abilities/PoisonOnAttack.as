package com.monsters.monsters.components.abilities
{
   import com.monsters.interfaces.IAttackable;
   import com.monsters.interfaces.ITargetable;
   import com.monsters.monsters.MonsterBase;
   import com.monsters.monsters.components.Component;
   import com.monsters.monsters.components.IAttackingComponent;
   import com.monsters.monsters.components.statusEffects.DOTEffect;
   
   public class PoisonOnAttack extends Component implements IAttackingComponent
   {
       
      
      public function PoisonOnAttack()
      {
         super();
      }
      
      public function onAttack(param1:IAttackable, param2:Number, param3:ITargetable = null) : Number
      {
         var _loc4_:MonsterBase = null;
         if(param1 is MonsterBase)
         {
            (_loc4_ = param1 as MonsterBase).addStatusEffect(new DOTEffect(_loc4_,owner.damage * owner.powerUpLevel() * 0.1));
         }
         return 0;
      }
   }
}
