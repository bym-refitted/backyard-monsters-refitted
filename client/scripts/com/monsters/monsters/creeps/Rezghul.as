package com.monsters.monsters.creeps
{
   import com.monsters.configs.BYMConfig;
   import com.monsters.display.CreepSkinManager;
   import com.monsters.interfaces.ITargetable;
   import com.monsters.monsters.MonsterBase;
   import com.monsters.monsters.components.abilities.RezghulResurrectAttack;
   import com.monsters.monsters.components.abilities.Zombiefy;
   import com.monsters.projectiles.ProjectileUtils;
   import com.monsters.projectiles.Projectilev2;
   import com.monsters.projectiles.ResurrectProjectile;
   import com.monsters.rendering.RasterData;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.geom.Point;
   import org.kissmyas.utils.loanshark.LoanShark;
   
   public class Rezghul extends CreepBase
   {
      
      private static const k_projectileSpeed:uint = 3;
      
      private static const k_projectilePoolSize:uint = 4;
      
      public static const k_ZOMBIE_HEALTH_MULTIPLIER:String = "zombieHealthMultiplier";
      
      public static const k_ZOMBIE_DAMAGE_MULTIPLIER:String = "zombieDamageMultiplier";
      
      public static const k_ZOMBIE_SPEED_MULTIPLIER:String = "zombieSpeedMultiplier";
      
      public static const k_RESSURECT_COOLDOWN:String = "resurrectCooldown";
       
      
      private var m_projectilePool:LoanShark;
      
      public function Rezghul(param1:String, param2:String, param3:Point, param4:Number, param5:int = 0, param6:int = 2147483647, param7:Point = null, param8:Boolean = false, param9:BFOUNDATION = null, param10:Number = 1, param11:Boolean = false, param12:MonsterBase = null)
      {
         var _loc13_:Zombiefy = null;
         var _loc14_:ResurrectProjectile = null;
         super(param1,param2,param3,param4,param5,param6,param7,param8,param9,param10,param11,param12);
         SPRITES.SetupSprite(ResurrectProjectile.k_resurecctProjectile);
         SPRITES.SetupSprite("shadow");
         _shadow = new BitmapData(52,50,true,0);
         _shadowMC = BYMConfig.instance.RENDERER_ON ? new Bitmap(_shadow) : graphic.addChild(new Bitmap(_shadow));
         _shadowMC.x = -21;
         _shadowMC.y = -25;
         if(BYMConfig.instance.RENDERER_ON)
         {
            _shadowData = new RasterData(_shadow,_shadowPt,MAP.DEPTH_SHADOW);
         }
         this.m_projectilePool = new LoanShark(Projectilev2,true,k_projectilePoolSize);
         _loc13_ = new Zombiefy(CREATURES.GetProperty(_creatureID,k_ZOMBIE_SPEED_MULTIPLIER,param5,_friendly),CREATURES.GetProperty(_creatureID,k_ZOMBIE_HEALTH_MULTIPLIER,param5,_friendly),CREATURES.GetProperty(_creatureID,k_ZOMBIE_DAMAGE_MULTIPLIER,param5,_friendly));
         _loc14_ = new ResurrectProjectile();
         var _loc15_:RezghulResurrectAttack = new RezghulResurrectAttack(300,CREATURES.GetProperty(_creatureID,k_RESSURECT_COOLDOWN,param5,_friendly),Targeting.getFriendlyFlag(this) | Targeting.k_TARGETS_GROUND,50,_loc14_,_loc13_);
         addComponent(_loc15_);
      }
      
      override protected function rangedAttack(param1:ITargetable) : ITargetable
      {
         var _loc2_:Projectilev2 = this.m_projectilePool.borrowObject() as Projectilev2;
         _loc2_.setup(this.getProjectileBitmapData(),x,getDisplayY(),param1,k_projectileSpeed,-damage,this);
         return _loc2_;
      }
      
      override protected function getNextSprite() : void
      {
         if(!_atTarget)
         {
            spriteAction = "moving";
         }
         else
         {
            spriteAction = "idle";
         }
         SPRITES.GetSprite(_shadow,"shadow","shadow",0);
         _lastFrame = CreepSkinManager.instance.GetSprite(_graphic,_creatureID,spriteAction,m_rotation,_frameNumber,_lastFrame,_currentSkinOverride);
      }
      
      override public function die() : void
      {
         super.die();
         this.m_projectilePool.dispose();
      }
      
      private function getProjectileBitmapData() : BitmapData
      {
         return ProjectileUtils.getFomorballBitmapData();
      }
   }
}
