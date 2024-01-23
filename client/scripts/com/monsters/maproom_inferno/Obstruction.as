package com.monsters.maproom_inferno
{
   import flash.geom.Rectangle;
   
   public class Obstruction
   {
      
      public static var Obstructions:Array = new Array();
      
      public static var Reserved:Array = new Array(new Rectangle(196,771,209,184),new Rectangle(605,478,186,174),new Rectangle(917,1137,191,162),new Rectangle(1238,1084,198,174));
      
      public static var Slots:Array = new Array(new Rectangle(350,320,160,160),new Rectangle(170,610,160,160),new Rectangle(670,540,160,160),new Rectangle(145,890,160,160),new Rectangle(570,1000,160,160),new Rectangle(1060,340,160,160),new Rectangle(1400,1000,160,160),new Rectangle(1100,600,160,160),new Rectangle(1500,580,160,160),new Rectangle(1220,800,160,160));
       
      
      public function Obstruction()
      {
         super();
      }
      
      public static function Clear() : void
      {
         Obstructions = [];
      }
      
      public static function pointIsBlocked(param1:int, param2:int) : Boolean
      {
         var _loc3_:* = undefined;
         for each(_loc3_ in Obstructions)
         {
            if(param1 > _loc3_.x && param1 < _loc3_.x + _loc3_.width && param2 > _loc3_.y && param2 < _loc3_.y + _loc3_.height)
            {
               return true;
            }
         }
         return false;
      }
      
      public static function Register(param1:*, param2:Boolean = false) : void
      {
         Obstructions.push(param1);
         if(param2)
         {
            Reserved.push(param1);
         }
      }
   }
}
