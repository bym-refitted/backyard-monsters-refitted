package com.monsters.monsters.creeps.rebalance
{
   import com.monsters.display.SpriteData;
   import com.monsters.display.SpriteSheetAnimation;
   import com.monsters.interfaces.ITargetable;
   import com.monsters.monsters.MonsterBase;
   import com.monsters.monsters.creeps.CreepBase;
   import com.monsters.projectiles.Projectilev2;
   import com.monsters.projectiles.projectileComponents.FaceTargetProjectileComponent;
   import flash.geom.Point;
   import org.kissmyas.utils.loanshark.LoanShark;
   
   public class DAVEv2 extends CreepBase
   {
      
      private static const k_rocketKey:String = "rocket";
      
      private static const k_rocketSpeed:uint = 8;
      
      private static const k_projectilePoolSize:uint = 4;
       
      
      private var m_projectilePool:LoanShark;
      
      public function DAVEv2(param1:String, param2:String, param3:Point, param4:Number, param5:int = 0, param6:int = 2147483647, param7:Point = null, param8:Boolean = false, param9:BFOUNDATION = null, param10:Number = 1, param11:Boolean = false, param12:MonsterBase = null)
      {
         super(param1,param2,param3,param4,param5,param6,param7,param8,param9,param10,param11,param12);
         if(powerUpLevel())
         {
            targetMode = 1;
            SPRITES.SetupSprite(k_rocketKey);
            range = 100 + 40 * powerUpLevel();
            this.m_projectilePool = new LoanShark(Projectilev2,true,k_projectilePoolSize);
         }
      }
      
      override protected function rangedAttack(param1:ITargetable) : ITargetable
      {
         var _loc2_:Number = damage * 0.5;
         var _loc3_:SpriteSheetAnimation = new SpriteSheetAnimation(SPRITES.GetSpriteDescriptor(k_rocketKey) as SpriteData,11);
         var _loc4_:Projectilev2 = this.m_projectilePool.borrowObject() as Projectilev2;
         var _loc5_:Point = new Point(_tmpPoint.x + Math.random() * 20 - 10,_tmpPoint.y + Math.random() * 20 - 10);
         var _loc6_:FaceTargetProjectileComponent = new FaceTargetProjectileComponent(_loc4_,_loc3_);
         _loc4_.setup(_loc3_.bitmapData,_loc5_.x,_loc5_.y,param1,k_rocketSpeed,_loc2_,this,_loc6_);
         _loc4_ = this.m_projectilePool.borrowObject() as Projectilev2;
         _loc5_ = new Point(_tmpPoint.x + Math.random() * 20 - 10,_tmpPoint.y + Math.random() * 20 - 10);
         _loc6_ = new FaceTargetProjectileComponent(_loc4_,_loc3_);
         _loc4_.setup(_loc3_.bitmapData,_loc5_.x,_loc5_.y,param1,k_rocketSpeed,_loc2_,this,_loc6_);
         return _loc4_;
      }
      
      override public function die() : void
      {
         super.die();
         this.m_projectilePool.dispose();
      }
      
      override public function deathSplat() : void
      {
         SOUNDS.Play("monsterlanddave");
      }
   }
}
