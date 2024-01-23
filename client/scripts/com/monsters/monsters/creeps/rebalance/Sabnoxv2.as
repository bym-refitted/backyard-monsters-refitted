package com.monsters.monsters.creeps.rebalance
{
   import com.monsters.interfaces.ITargetable;
   import com.monsters.monsters.MonsterBase;
   import com.monsters.monsters.creeps.CreepBase;
   import com.monsters.projectiles.ProjectileUtils;
   import com.monsters.projectiles.Projectilev2;
   import flash.geom.Point;
   import org.kissmyas.utils.loanshark.LoanShark;
   
   public class Sabnoxv2 extends CreepBase
   {
      
      private static const k_projectileSpeed:uint = 10;
      
      private static const k_projectilePoolSize:uint = 3;
       
      
      private var m_projectilePool:LoanShark;
      
      public function Sabnoxv2(param1:String, param2:String, param3:Point, param4:Number, param5:int = 0, param6:int = 2147483647, param7:Point = null, param8:Boolean = false, param9:BFOUNDATION = null, param10:Number = 1, param11:Boolean = false, param12:MonsterBase = null)
      {
         super(param1,param2,param3,param4,param5,param6,param7,param8,param9,param10,param11,param12);
         this.m_projectilePool = new LoanShark(Projectilev2,true,k_projectilePoolSize);
      }
      
      override protected function rangedAttack(param1:ITargetable) : ITargetable
      {
         var _loc2_:Projectilev2 = this.m_projectilePool.borrowObject() as Projectilev2;
         _loc2_.setup(ProjectileUtils.getFireballBitmapData()(),x,getDisplayY(),param1,k_projectileSpeed,damage,this);
         return _loc2_;
      }
      
      override public function die() : void
      {
         super.die();
         this.m_projectilePool.dispose();
      }
   }
}
