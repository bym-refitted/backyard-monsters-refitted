package com.monsters.monsters.components.abilities
{
   import com.monsters.monsters.components.Component;
   import flash.geom.Point;
   
   public class TowerTaunt extends Component
   {
       
      
      protected var m_radius:uint;
      
      public function TowerTaunt(param1:uint = 500)
      {
         super();
         this.m_radius = param1;
      }
      
      override public function tick(param1:int = 1) : void
      {
         var _loc4_:BTOWER = null;
         var _loc2_:Array = Targeting.getBuildingsInRange(this.m_radius,new Point(owner.x,owner.y));
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            if(_loc2_[_loc3_] is BTOWER)
            {
               (_loc4_ = _loc2_[_loc3_].creep as BTOWER).setTarget(owner);
            }
            _loc3_++;
         }
      }
   }
}
