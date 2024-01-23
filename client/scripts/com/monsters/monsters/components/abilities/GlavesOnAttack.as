package com.monsters.monsters.components.abilities
{
   import com.monsters.interfaces.IAttackable;
   import com.monsters.interfaces.ITargetable;
   import com.monsters.monsters.components.Component;
   import com.monsters.monsters.components.IAttackingComponent;
   
   public class GlavesOnAttack extends Component implements IAttackingComponent
   {
       
      
      protected var m_amountOfGlaves:uint;
      
      public function GlavesOnAttack(param1:uint)
      {
         super();
         this.m_amountOfGlaves = param1;
      }
      
      public function onAttack(param1:IAttackable, param2:Number, param3:ITargetable = null) : Number
      {
         if(Boolean(param3) && param3 is FIREBALL)
         {
            FIREBALL(param3)._glaves = this.m_amountOfGlaves;
         }
         return 0;
      }
   }
}
