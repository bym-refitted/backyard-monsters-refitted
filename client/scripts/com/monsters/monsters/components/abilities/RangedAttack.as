package com.monsters.monsters.components.abilities
{
   import com.monsters.interfaces.ITargetable;
   import com.monsters.monsters.components.Component;
   import com.monsters.projectiles.ProjectileUtils;
   import com.monsters.projectiles.Projectilev2;
   import flash.geom.Point;
   import org.kissmyas.utils.loanshark.LoanShark;
   
   public class RangedAttack extends Component
   {
      
      private static const k_projectileSpeed:uint = 2;
      
      private static const k_projectilePoolSize:uint = 2;
       
      
      protected var m_range:uint;
      
      protected var m_rechargeDuration:uint;
      
      protected var m_timeRechargeIsComplete:uint;
      
      protected var m_projectilePool:LoanShark;
      
      protected var m_projectile:Projectilev2;
      
      protected var m_targetFlags:int;
      
      public function RangedAttack(param1:uint, param2:int, param3:int, param4:Projectilev2)
      {
         super();
         this.m_range = param1;
         this.m_rechargeDuration = param2;
         this.m_projectile = param4;
         this.m_targetFlags = param3;
      }
      
      override protected function onRegister() : void
      {
         this.m_projectilePool = new LoanShark(Object(this.m_projectile).constructor,true,k_projectilePoolSize);
      }
      
      override protected function onUnregister() : void
      {
         this.m_projectilePool.dispose();
      }
      
      override public function tick(param1:int = 1) : void
      {
         var _loc2_:Vector.<ITargetable> = null;
         if(GLOBAL.Timestamp() >= this.m_timeRechargeIsComplete)
         {
            _loc2_ = this.getValidTargetsInRange(this.m_range,new Point(owner.x,owner.y),this.m_targetFlags);
            if(Boolean(_loc2_) && _loc2_.length > 0)
            {
               this.fireAt(_loc2_[0]);
               this.m_timeRechargeIsComplete = GLOBAL.Timestamp() + this.m_rechargeDuration;
            }
         }
      }
      
      protected function getValidTargetsInRange(param1:uint, param2:Point, param3:int) : Vector.<ITargetable>
      {
         var _loc4_:Vector.<ITargetable> = null;
         var _loc5_:Array = Targeting.getTargetsInRange(param1,param2,param3);
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_.length)
         {
            if(!_loc4_)
            {
               _loc4_ = new Vector.<ITargetable>();
            }
            _loc4_.push(_loc5_[_loc6_].creep);
            _loc6_++;
         }
         return _loc4_;
      }
      
      protected function fireAt(param1:ITargetable) : Projectilev2
      {
         var _loc2_:Projectilev2 = this.m_projectilePool.borrowObject() as Projectilev2;
         _loc2_.setup(ProjectileUtils.getFireballBitmapData(),owner.x,owner.getDisplayY(),param1,ProjectileUtils.k_fireballSpeed,0,owner);
         return _loc2_;
      }
   }
}
