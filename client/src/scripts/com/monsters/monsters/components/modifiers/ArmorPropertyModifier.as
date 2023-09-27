package com.monsters.monsters.components.modifiers
{
   import com.monsters.debug.Console;
   
   public class ArmorPropertyModifier extends MultiplicationPropertyModifier
   {
       
      
      public function ArmorPropertyModifier(param1:Number)
      {
         if(param1 > 1 || param1 <= 0)
         {
            Console.warning("you are trying to add an armor multiplier of an invalid value (" + param1 + ")");
            param1 = 1;
         }
         super(param1);
      }
      
      override public function modify(param1:Number) : Number
      {
         if(!param1)
         {
            return multiple;
         }
         return super.modify(param1);
      }
   }
}
