package com.monsters.maproom
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class PushPin
   {
      
      public static const GREEN:uint = 0;
      
      public static const YELLOW:uint = 1;
      
      public static const ORANGE:uint = 2;
      
      public static const RED:uint = 3;
      
      public static var columnWidth:int = 21;
      
      public static var columnHeight:int = 25;
      
      private static var keys:Object = {};
      
      private static var pins:BitmapData;
      
      private static var shadow:BitmapData;
      
      public static var loaded:Boolean = false;
      
      private static var loads:uint = 0;
      
      private static var isSetup:Boolean = false;
       
      
      public function PushPin()
      {
         super();
      }
      
      public static function Setup() : void
      {
         keys = {
            "shadow":{
               "img":"maproom/pinshadow.png",
               "data":new pin_shadow(0,0)
            },
            "pins":{
               "img":"maproom/pushpin.png",
               "data":new pushpins(0,0)
            }
         };
         isSetup = true;
      }
      
      public static function getRandomPinWithColor(param1:uint) : Sprite
      {
         var _loc2_:Sprite = null;
         var _loc3_:Bitmap = null;
         var _loc4_:BitmapData = null;
         var _loc5_:uint = 0;
         if(!isSetup)
         {
            Setup();
         }
         _loc2_ = new Sprite();
         _loc3_ = new Bitmap(keys.shadow.data);
         _loc2_.addChild(_loc3_);
         _loc4_ = new BitmapData(columnWidth,columnHeight,true);
         _loc5_ = Math.random() * 5;
         _loc3_.x = 3 + Math.random() * 3;
         _loc3_.y = 3 + Math.random() * 3;
         _loc4_.copyPixels(keys.pins.data,new Rectangle(columnWidth * _loc5_,param1 * columnHeight,columnWidth,columnHeight),new Point(0,0));
         var _loc6_:Bitmap = new Bitmap(_loc4_);
         _loc2_.addChild(_loc6_);
         _loc2_.x = -8;
         return _loc2_;
      }
   }
}
