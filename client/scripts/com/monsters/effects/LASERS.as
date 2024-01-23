package com.monsters.effects
{
   import flash.geom.Point;
   
   public class LASERS
   {
      
      public static var _distance:int;
      
      public static var _angle:Number;
      
      public static var _pointA:Point = new Point(50,50);
      
      public static var _pointB:Point;
      
      public static var _duration:Number = 0;
      
      public static var _power:Number = 0;
      
      public static var _lasers:Object = {};
      
      public static var _laserCount:int = 0;
       
      
      public function LASERS()
      {
         super();
      }
      
      public static function Fire(param1:int, param2:int, param3:int, param4:int, param5:int = 0, param6:Number = 0, param7:Number = 0, param8:Function = null) : void
      {
         var _loc9_:LASER;
         (_loc9_ = new LASER()).Fire(MAP._PROJECTILES,new Point(param1,param2),new Point(param3,param4),param5,param6,param7,param8);
         _lasers["l" + _laserCount] = _loc9_;
         ++_laserCount;
      }
      
      public static function Tick() : void
      {
         var _loc1_:String = null;
         for(_loc1_ in _lasers)
         {
            if(_lasers[_loc1_].Tick())
            {
               delete _lasers[_loc1_];
            }
         }
      }
   }
}
