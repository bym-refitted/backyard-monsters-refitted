package com.monsters.projectiles.projectileComponents
{
   import com.monsters.display.SpriteSheetAnimation;
   import com.monsters.projectiles.Projectilev2;
   import flash.display.BitmapData;
   
   public class FaceTargetProjectileComponent extends ProjectileComponent
   {
       
      
      private var m_animation:SpriteSheetAnimation;
      
      private var m_projectile:Projectilev2;
      
      public function FaceTargetProjectileComponent(param1:Projectilev2, param2:SpriteSheetAnimation)
      {
         super();
         this.m_animation = param2;
         this.m_projectile = param1;
      }
      
      override public function tick(param1:int = 1) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:BitmapData = null;
         if(Boolean(this.m_projectile.rasterData) && Boolean(this.m_projectile.angleToTargetPoint))
         {
            _loc2_ = this.m_projectile.angleToTargetPoint * (180 / Math.PI);
            if(_loc2_ < 0)
            {
               _loc2_ = 360 + _loc2_;
            }
            _loc3_ = this.m_projectile.rasterData.data as BitmapData;
            SPRITES.GetFrame(_loc3_,this.m_animation.spriteData,_loc2_ / this.m_animation.totalFrames);
         }
      }
   }
}
