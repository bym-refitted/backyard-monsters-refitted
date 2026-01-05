package com.monsters.siege
{
   import com.monsters.siege.weapons.SiegeWeapon;
   
   public class SiegeWeaponProperty
   {
       
      
      public var label:String;
      
      public var order:int;
      
      public var descriptionKey:String;
      
      private var _values:Array;
      
      public function SiegeWeaponProperty(param1:Array, param2:int = 0)
      {
         super();
         this._values = param1;
         this.order = param2;
      }
      
      public function get values() : Array
      {
         return this._values;
      }
      
      public function getDescription(param1:int) : String
      {
         return KEYS.Get(this.descriptionKey,{"v1":this.getValueForLevel(param1)});
      }
      
      public function getValueForLevel(param1:int) : *
      {
         return this._values[Math.max(0,Math.min(param1,SiegeWeapon.MAX_LEVEL)) - 1];
      }
      
      public function getProgressForLevel(param1:int) : Number
      {
         return this._values[Math.max(0,Math.min(param1,SiegeWeapon.MAX_LEVEL)) - 1] / this._values[SiegeWeapon.MAX_LEVEL - 1];
      }
   }
}
