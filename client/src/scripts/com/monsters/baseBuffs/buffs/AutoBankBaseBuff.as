package com.monsters.baseBuffs.buffs
{
   import com.monsters.baseBuffs.BaseBuff;
   
   public class AutoBankBaseBuff extends BaseBuff
   {
      
      public static const ID:uint = 2;
      
      public static const k_NAME:String = "AutoBank";
       
      
      public function AutoBankBaseBuff()
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
   }
}
