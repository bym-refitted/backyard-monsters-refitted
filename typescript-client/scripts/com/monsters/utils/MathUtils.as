package com.monsters.utils
{
   import flash.geom.Point;
   
   public class MathUtils
   {
      
      public static const DEGREES_TO_RADIANS:Number = Math.PI / 180;
      
      public static const RADIANS_TO_DEGREES:Number = 180 / Math.PI;
       
      
      public function MathUtils()
      {
         super();
      }
      
      public static function getDistanceBetweenTwoPoints(param1:Point, param2:Point) : Number
      {
         return GLOBAL.QuickDistance(param1,param2);
      }
      
      public static function getAngleBetweenTwoPointsInRadians(param1:Point, param2:Point) : Number
      {
         return Math.atan2(param2.y - param1.y,param2.x - param1.x);
      }
      
      public static function getAngleBetweenTwoPointsInDegrees(param1:Point, param2:Point) : Number
      {
         return getAngleBetweenTwoPointsInRadians(param1,param2) * RADIANS_TO_DEGREES;
      }
   }
}
