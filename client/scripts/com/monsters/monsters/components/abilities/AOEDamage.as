package com.monsters.monsters.components.abilities
{
   import com.monsters.interfaces.IAttackable;
   import com.monsters.monsters.components.Component;
   import com.monsters.monsters.MonsterBase;
   import flash.geom.Point;
   
   public class AOEDamage extends Component
   {
       
      
      protected var m_radiusInner:uint;

      protected var m_radiusOuter:uint;
      
      protected var m_maxTargets:uint;
      
      protected var m_targetFlags:int;

      protected var m_includeInitialTarget:Boolean;
      
      public function AOEDamage(radiusOuter:uint, targetFlags:int, maxTargets:uint = 4294967295, radiusInner:uint = 0, includeInitialTarget:Boolean = true)
      {
         super();
         this.m_radiusOuter = radiusOuter;
         this.m_radiusInner = radiusInner;
         this.m_maxTargets = maxTargets;
         this.m_targetFlags = targetFlags;
         this.m_includeInitialTarget = includeInitialTarget;
      }
      
      protected function dealAOEDamage(param1:Number, initialTarget:IAttackable = null) : void
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
