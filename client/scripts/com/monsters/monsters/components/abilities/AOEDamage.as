package com.monsters.monsters.components.abilities
{
   import com.monsters.monsters.components.Component;
   import flash.geom.Point;
   
   public class AOEDamage extends Component
   {
       
      
      protected var m_radius:uint;
      
      protected var m_maxTargets:uint;
      
      protected var m_targetFlags:int;
      
      protected var m_doesTargetBuildings:Boolean;
      
      public function AOEDamage(param1:uint, param2:int, param3:uint = 4294967295)
      {
         super();
         this.m_radius = param1;
         this.m_maxTargets = param3;
         this.m_targetFlags = param2;
      }
      
      protected function dealAOEDamage(param1:Number) : void
      {
         var _loc2_:Point = new Point(owner.x,owner.y);
         var _loc3_:Array = Targeting.getTargetsInRange(this.m_radius,_loc2_,this.m_targetFlags);
         _loc3_.sortOn(["dist"],Array.NUMERIC);
         if(_loc3_.length > this.m_maxTargets)
         {
            _loc3_.length = this.m_maxTargets;
         }
         Targeting.DealLinearAEDamage(_loc2_,this.m_radius,param1,_loc3_,0);
      }
   }
}
