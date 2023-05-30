package com.monsters.monsters.components
{
   import com.monsters.GameObject;
   
   public class MaxHealthProperty extends CModifiableProperty
   {
       
      
      private var m_healthProperty:GameObject;
      
      private var m_lastKnownValue:Number;
      
      public function MaxHealthProperty(param1:GameObject, param2:Number = 1.7976931348623157e+308, param3:Number = -Infinity)
      {
         super(param2,param3,0);
         this.m_healthProperty = param1;
      }
      
      public function store() : void
      {
         this.m_lastKnownValue = value;
      }
      
      public function updateHealth() : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc1_:Number = value;
         if(this.m_lastKnownValue != _loc1_)
         {
            _loc2_ = this.m_healthProperty.health / this.m_lastKnownValue;
            _loc3_ = _loc2_ * _loc1_;
            if(_loc2_)
            {
               this.m_healthProperty.setHealth(_loc3_);
            }
         }
      }
   }
}
