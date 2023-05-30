package com.monsters.monsters.components
{
   import com.monsters.interfaces.IAttackable;
   import com.monsters.interfaces.ITargetable;
   
   public interface IAttackingComponent
   {
       
      
      function onAttack(param1:IAttackable, param2:Number, param3:ITargetable = null) : Number;
   }
}
