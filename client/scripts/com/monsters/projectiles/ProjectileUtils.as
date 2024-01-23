package com.monsters.projectiles
{
   import com.monsters.utils.MovieClipUtils;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.filters.GlowFilter;
   
   public class ProjectileUtils
   {
      
      public static const k_fireballSpeed:uint = 6;
      
      public static const k_healballSpeed:uint = 25;
       
      
      public function ProjectileUtils()
      {
         super();
      }
      
      public static function getFireballBitmapData() : BitmapData
      {
         var _loc1_:MovieClip = new FIREBALL_CLIP();
         _loc1_.scaleX = 2;
         _loc1_.scaleY = 2;
         _loc1_.stop();
         _loc1_.filters = [new GlowFilter(16748544,1,12,12,6,1,false,false)];
         return MovieClipUtils.getBitmapDataFromDisplayObject(_loc1_);
      }
      
      public static function getHealballBitmapData() : BitmapData
      {
         var _loc1_:MovieClip = null;
         _loc1_ = new FIREBALL_CLIP();
         _loc1_.gotoAndStop(2);
         _loc1_.scaleX = 2;
         _loc1_.scaleY = 2;
         return MovieClipUtils.getBitmapDataFromDisplayObject(_loc1_);
      }
      
      public static function getFomorballBitmapData() : BitmapData
      {
         var _loc1_:MovieClip = null;
         _loc1_ = new FIREBALL_CLIP();
         _loc1_.gotoAndStop(3);
         _loc1_.scaleX = 2;
         _loc1_.scaleY = 2;
         return MovieClipUtils.getBitmapDataFromDisplayObject(_loc1_);
      }
   }
}
