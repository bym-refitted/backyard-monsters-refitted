package com.monsters.monsters.creeps.rebalance
{
   import com.monsters.interfaces.ITargetable;
   import com.monsters.monsters.MonsterBase;
   import com.monsters.monsters.creeps.CreepBase;
   import com.monsters.projectiles.ProjectileUtils;
   import com.monsters.projectiles.Projectilev2;
   import com.monsters.projectiles.projectileComponents.GlaiveProjectileComponent;
   import com.monsters.projectiles.projectileComponents.SetFireProjectileComponent;
   import flash.geom.Point;
   import org.kissmyas.utils.loanshark.LoanShark;
   
   public class Teratornv2 extends CreepBase
   {
      
      private static const k_maxGlaiveTargets:uint = 3;
      
      private static const k_glaiveRange:uint = 100;
      
      private static const k_projectilePoolSize:uint = 5;
       
      
      private var m_projectilePool:LoanShark;
      
      public function Teratornv2(param1:String, param2:String, param3:Point, param4:Number, param5:int = 0, param6:int = 2147483647, param7:Point = null, param8:Boolean = false, param9:BFOUNDATION = null, param10:Number = 1, param11:Boolean = false, param12:MonsterBase = null)
      {
         super(param1,param2,param3,param4,param5,param6,param7,param8,param9,param10,param11,param12);
         SPRITES.SetupSprite("shadow");
         this.m_projectilePool = new LoanShark(Projectilev2,true,k_projectilePoolSize);
      }
      
      override protected function rangedAttack(param1:ITargetable) : ITargetable
      {
         var _loc2_:uint = uint(powerUpLevel());
         var _loc3_:Projectilev2 = this.m_projectilePool.borrowObject() as Projectilev2;
         if(_loc2_)
         {
            _loc3_.addComponent(new GlaiveProjectileComponent(k_maxGlaiveTargets,k_glaiveRange,Targeting.k_TARGETS_BUILDINGS));
         }
         _loc3_.addComponent(new SetFireProjectileComponent(damage * 0.1));
         _loc3_.setup(ProjectileUtils.getFireballBitmapData(),x,getDisplayY(),param1,ProjectileUtils.k_fireballSpeed,damage,this);
         return _loc3_;
      }
      
      override public function die() : void
      {
         super.die();
         this.m_projectilePool.dispose();
      }
   }
}
