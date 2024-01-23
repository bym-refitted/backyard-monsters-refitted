package com.monsters.monsters.components.abilities
{
   import com.monsters.interfaces.IAttackable;
   import com.monsters.interfaces.ITargetable;
   import com.monsters.monsters.components.Component;
   import com.monsters.monsters.components.IAttackingComponent;
   
   public class DAVERockets extends Component implements IAttackingComponent
   {
       
      
      public function DAVERockets()
      {
         super();
      }
      
      override protected function onRegister() : void
      {
         owner.targetMode = 1;
         SPRITES.SetupSprite("rocket");
         owner.range = 100 + 40 * owner.powerUpLevel();
      }
      
      override protected function onUnregister() : void
      {
         owner.targetMode = 0;
         owner.range = 1;
      }
      
      public function onAttack(param1:IAttackable, param2:Number, param3:ITargetable = null) : Number
      {
         return 0;
      }
   }
}
