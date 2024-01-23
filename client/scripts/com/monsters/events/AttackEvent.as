package com.monsters.events
{
   import flash.events.Event;
   
   public class AttackEvent extends Event
   {
      
      public static const ATTACK_OVER:String = "attackOver";
       
      
      private var _attackType:int;
      
      private var _loot:Object;
      
      private var _wasBaseDestroyed:Boolean;
      
      public function AttackEvent(param1:String, param2:Boolean, param3:int, param4:Object)
      {
         this._attackType = param3;
         this._wasBaseDestroyed = param2;
         this._loot = param4;
         super(param1);
      }
      
      public function get wasBaseDestroyed() : Boolean
      {
         return this._wasBaseDestroyed;
      }
      
      public function get attackType() : int
      {
         return this._attackType;
      }
      
      public function get loot() : Object
      {
         return this._loot;
      }
   }
}
