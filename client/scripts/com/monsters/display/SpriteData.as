package com.monsters.display
{
   import flash.display.BitmapData;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class SpriteData
   {
      
      public static const FUBAR_X:int = 26;
      
      public static const FUBAR_Y:int = 36;
       
      
      public var key:String;
      
      public var image:BitmapData;
      
      public const rect:Rectangle = new Rectangle();
      
      public const offset:Point = new Point();
      
      public const middle:Point = new Point();
      
      public function SpriteData(param1:String, param2:Number, param3:Number, param4:Number, param5:Number)
      {
         super();
         this.key = param1;
         this.rect.width = param2;
         this.rect.height = param3;
         this.offset.x = FUBAR_X - param4;
         this.offset.y = FUBAR_Y - param5;
         this.middle.x = param4;
         this.middle.y = param5;
      }
      
      public function get width() : Number
      {
         return this.rect.width;
      }
      
      public function get height() : Number
      {
         return this.rect.height;
      }
      
      public function get sprite() : BitmapData
      {
         return this.image;
      }
   }
}
