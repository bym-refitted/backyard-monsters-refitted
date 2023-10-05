package com.monsters.monsters.components.modifiers
{
   import com.monsters.interfaces.IPropertyModifier;
   
   public class MonsterDust
   {
      
      public static const k_titleKey:String = "str_code_mod_title";
      
      public static const k_descriptionKey:String = "str_code_mod_body";
      
      public static const k_storeKey:String = "MOD";
      
      public static const k_color:uint = 13421568;
      
      public static const k_value:Number = 1.25;
      
      public static const k_damageModifier:IPropertyModifier = new MultiplicationPropertyModifier(k_value);
       
      
      public function MonsterDust()
      {
         super();
      }
   }
}
