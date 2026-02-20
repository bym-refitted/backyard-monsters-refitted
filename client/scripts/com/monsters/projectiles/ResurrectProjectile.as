package com.monsters.projectiles
{
   import com.monsters.GameObject;
   import com.monsters.display.SpriteData;
   import com.monsters.interfaces.IAttackable;
   import com.monsters.interfaces.ITargetable;
   import flash.display.BitmapData;
   import flash.display.IBitmapDrawable;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import gs.TweenMax;
   
   public class ResurrectProjectile extends Projectilev2
   {
      
      public static const k_resurecctProjectile:String = "resurrectProjectile";
      
      public static const k_projectileImageURL:String = "monsters/projectiles/rezghul_projectile.png";
      
      private static const k_MAX_DISTANCE_TO_LIGHTNING_TARGET:uint = 125;
      
      private static const k_PROJECTILE_SPEED:uint = 2;
      
      private static const k_ORBIT_RADIUS:uint = 10;
      
      private static const k_ORBIT_SPEED:Number = 0.05;
       
      
      private var m_orbitAngle:Number = 0;
      
      private var m_filter:GlowFilter;
      
      public function ResurrectProjectile()
      {
         super();
      }
      
      override public function setup(param1:IBitmapDrawable, param2:Number, param3:Number, param4:ITargetable, param5:Number, param6:Number = 0, param7:IAttackable = null, ... rest) : void
      {
         param5 = k_PROJECTILE_SPEED;
         param1 = this.getBitmapData();
         super.setup(param1,param2,param3,param4,param5,param6,param7,rest);
         this.m_filter = new GlowFilter(16777215,0,9,9,1);
         TweenMax.to(this.m_filter,1,{
            "alpha":0.8,
            "yoyo":true
         });
      }
      
      override protected function render() : void
      {
         var _loc1_:BitmapData = BitmapData(m_rasterData.data);
         var _loc2_:BitmapData = this.getBitmapData();
         _loc1_.applyFilter(_loc2_,_loc2_.rect,new Point(),this.m_filter);
         this.m_orbitAngle += k_ORBIT_SPEED;
         var _loc3_:Number = m_x + Math.cos(this.m_orbitAngle) * k_ORBIT_RADIUS;
         var _loc4_:Number = m_y + Math.sin(this.m_orbitAngle) * k_ORBIT_RADIUS;
         if(Math.random() > 0.75)
         {
            this.randerElectricityAroundProjectile(new Point(_loc3_,_loc4_),_loc2_);
         }
         var _loc5_:Point = MAP.instance.offset;
         m_rasterData.pt = new Point(_loc3_ - _loc5_.x,_loc4_ - _loc5_.y);
      }
      
      private function randerElectricityAroundProjectile(param1:Point, param2:BitmapData) : void
      {
         var _loc3_:Point = null;
         var _loc5_:Number = NaN;
         var _loc4_:ITargetable;
         _loc4_ = Targeting.getClosestEnemy(k_MAX_DISTANCE_TO_LIGHTNING_TARGET,param1,Targeting.k_TARGETS_ALL);
         if(_loc4_)
         {
            _loc3_ = new Point(_loc4_.x,_loc4_.y);
            _loc5_ = GLOBAL.QuickDistance(_loc3_,param1);
            if(Math.random() > _loc5_ / k_MAX_DISTANCE_TO_LIGHTNING_TARGET)
            {
               if(_loc4_ is GameObject)
               {
                  _loc3_ = _loc3_.add(GameObject(_loc4_).getRandomPointOnGraphic());
               }
            }
            else
            {
               _loc3_ = null;
            }
         }
         if(!_loc3_)
         {
            _loc3_ = new Point(param1.x + Math.random() * param2.width,param1.y + Math.random() * param2.height);
         }
         EFFECTS.Lightning(param1.x + Math.random() * param2.width,param1.y + Math.random() * param2.height,_loc3_.x,_loc3_.y,null,65280);
      }
      
      private function getBitmapData() : BitmapData
      {
         var _loc1_:BitmapData = SpriteData(SPRITES.GetSpriteDescriptor(k_resurecctProjectile)).sprite;
         if(!_loc1_)
         {
            _loc1_ = ProjectileUtils.getFireballBitmapData();
         }
         return _loc1_.clone();
      }
   }
}
