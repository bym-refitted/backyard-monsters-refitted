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
      
      protected function dealAOEDamage(damage:Number, initialTarget:IAttackable = null) : void
      {
         var ownerLocation:Point = new Point(owner.x,owner.y);
         var allTargets:Array = getAllTargets(ownerLocation, initialTarget);
         if(allTargets.length <= 0)
         {
            return;
         }
         allTargets.sortOn(["dist"],Array.NUMERIC);
         if(allTargets.length > this.m_maxTargets)
         {
            allTargets.length = this.m_maxTargets;
         }
         Targeting.DealLinearAEDamage(ownerLocation,this.m_radiusOuter,Math.abs(damage),allTargets,m_radiusInner);
      }

      private function getAllTargets(ownerLocation:Point, initialTarget:IAttackable = null):Array
      {
         var targetFlags:int = this.m_targetFlags;
         var ignoreCreep:MonsterBase = null;
         var ignoreBuilding:BFOUNDATION = null;
         if(owner._friendly && Boolean(targetFlags & Targeting.k_TARGETS_BUILDINGS) && !(initialTarget is BFOUNDATION))
         {
            // Defending monsters will not hit their own base's buildings unless specifically targetting them.
            targetFlags ^= Targeting.k_TARGETS_BUILDINGS;
         }
         if(!this.m_includeInitialTarget)
         {
            if(initialTarget is MonsterBase)
            {
               ignoreCreep = initialTarget as MonsterBase;
            }
            else if(initialTarget is BFOUNDATION)
            {
               ignoreBuilding = initialTarget as BFOUNDATION;
            }
         }
         return Targeting.getTargetsInRange(this.m_radiusOuter,ownerLocation,targetFlags,ignoreCreep,ignoreBuilding);
      }
   }
}
