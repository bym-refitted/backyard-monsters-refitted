package com.monsters.monsters.components.modifiers
{
   import com.monsters.interfaces.IPropertyModifier;
   
   public class BeastMode
   {
      
      public static const k_color:uint = 255;
      
      public static const k_value:Number = 0.3;
      
      public static const k_armorModifier:IPropertyModifier = new ArmorPropertyModifier(k_value);
       
      
      public function BeastMode()
      {
         super();
      }
   }
}
