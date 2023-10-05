package com.monsters.projectiles.projectileComponents
{
   import com.monsters.interfaces.IAttackable;
   import com.monsters.interfaces.ITargetable;
   import com.monsters.projectiles.Projectilev2;
   import flash.geom.Point;
   
   public class GlaiveProjectileComponent extends ProjectileComponent
   {
       
      
      private var m_targetsLeft:uint;
      
      private var m_targetFlags:int;
      
      private var m_range:uint;
      
      private var m_targetsAlreadyHit:Vector.<IAttackable>;
      
      public function GlaiveProjectileComponent(param1:uint, param2:uint, param3:Number = 0)
      {
         super();
         this.m_targetsLeft = param1;
         this.m_targetFlags = param3;
         this.m_targetsAlreadyHit = new Vector.<IAttackable>();
         this.m_range = param2;
      }
      
      override public function onAttack(param1:IAttackable, param2:Number, param3:ITargetable = null) : Number
      {
         if(this.m_targetsLeft > 0)
         {
            this.m_targetsAlreadyHit.push(param1);
            param1 = this.getViableTarget(new Point(param3.x,param3.y));
            if(param1)
            {
               Projectilev2(param3).target = param1;
               Projectilev2(param3).damage = Projectilev2(param3).damage * 0.5;
               --this.m_targetsLeft;
            }
         }
         return param2;
      }
      
      private function getViableTarget(param1:Point) : IAttackable
      {
         var _loc3_:int = 0;
         var _loc4_:IAttackable = null;
         var _loc2_:Array = Targeting.getTargetsInRange(this.m_range,param1,this.m_targetFlags);
         if(_loc2_.length > 0)
         {
            _loc2_.sortOn(["dist"],Array.NUMERIC);
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length)
            {
               _loc4_ = _loc2_[_loc3_].creep;
               if(this.m_targetsAlreadyHit.indexOf(_loc4_) == -1)
               {
                  return _loc4_;
               }
               _loc3_++;
            }
         }
         return null;
      }
   }
}
