package com.monsters.monsters
{
   import com.monsters.interfaces.ITargetable;
   
   public class DummyTarget implements ITargetable
   {
       
      
      private var m_x:Number;
      
      private var m_y:Number;
      
      public function DummyTarget(param1:Number, param2:Number)
      {
         super();
         this.m_x = param1;
         this.m_y = param2;
      }
      
      public function get x() : Number
      {
         return this.m_y;
      }
      
      public function get y() : Number
      {
         return this.m_y;
      }
      
      public function get defenseFlags() : int
      {
         return 0;
      }
   }
}
