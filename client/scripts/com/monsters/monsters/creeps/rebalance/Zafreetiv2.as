package com.monsters.monsters.creeps.rebalance
{
   import com.monsters.interfaces.ITargetable;
   import com.monsters.monsters.MonsterBase;
   import com.monsters.monsters.components.abilities.AOEHealOnDeath;
   import com.monsters.monsters.creeps.CreepBase;
   import com.monsters.projectiles.ProjectileUtils;
   import com.monsters.projectiles.Projectilev2;
   import flash.display.BitmapData;
   import flash.geom.Point;
   import org.kissmyas.utils.loanshark.LoanShark;
   
   public class Zafreetiv2 extends CreepBase
   {
      
      private static const k_projectilePoolSize:uint = 3;
       
      
      private var m_projectilePool:LoanShark;
      
      public function Zafreetiv2(param1:String, param2:String, param3:Point, param4:Number, param5:int = 0, param6:int = 2147483647, param7:Point = null, param8:Boolean = false, param9:BFOUNDATION = null, param10:Number = 1, param11:Boolean = false, param12:MonsterBase = null)
      {
         _graphic = new BitmapData(56,70,true,0);
         super(param1,param2,param3,param4,param5,param6,param7,param8,param9,param10,param11,param12);
         if(poweredUp())
         {
            addComponent(new AOEHealOnDeath());
         }
         this.m_projectilePool = new LoanShark(Projectilev2,true,k_projectilePoolSize);
         SPRITES.SetupSprite("bigshadow");
      }
      
      override protected function rangedAttack(param1:ITargetable) : ITargetable
      {
         var _loc2_:Projectilev2 = this.m_projectilePool.borrowObject() as Projectilev2;
         _loc2_.setup(ProjectileUtils.getHealballBitmapData(),x,getDisplayY(),param1,ProjectileUtils.k_healballSpeed,damage,this);
         SOUNDS.Play("hit" + int(3 + Math.random() * 2),0.1 + Math.random() * 0.1);
         return _loc2_;
      }
      
      override public function die() : void
      {
         super.die();
         this.m_projectilePool.dispose();
      }
   }
}
