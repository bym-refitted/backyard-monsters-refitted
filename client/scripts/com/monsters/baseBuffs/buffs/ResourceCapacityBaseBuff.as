package com.monsters.baseBuffs.buffs
{
   import com.monsters.baseBuffs.BaseBuff;
   import com.monsters.interfaces.IPropertyModifier;
   
   public class ResourceCapacityBaseBuff extends BaseBuff
   {
      
      public static const ID:uint = 10;
      
      public static const k_NAME:String = "Resource Capacity";
       
      
      private var m_capacityModifier:IPropertyModifier;
      
      public function ResourceCapacityBaseBuff()
      {
         super(k_NAME,"bufficons/resourcebuff.png");
      }
      
      override public function get description() : String
      {
         return "";
      }
      
      public function get value() : Number
      {
         return getValue();
      }
      
      override public function apply() : void
      {
      }
      
      override public function clear() : void
      {
      }
   }
}
