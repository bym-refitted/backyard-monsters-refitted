package com.monsters.interfaces
{
   public interface IAttackable extends ITargetable
   {
       
      
      function modifyHealth(param1:Number, param2:ITargetable = null) : Number;
      
      function get maxHealth() : Number;
      
      function get health() : Number;
      
      function get attackFlags() : int;
      
      function get attackPriorityFlags() : Vector.<int>;
   }
}
