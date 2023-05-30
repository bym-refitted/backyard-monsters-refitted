package
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.getTimer;
   
   public class GRID
   {
      
      public static const _mapWidth:int = 2600;
      
      public static const _mapHeight:int = 2600;
      
      public static const _rowOffset:int = Math.ceil(_mapWidth / 5);
      
      public static var _grid:Vector.<uint>;
       
      
      public function GRID()
      {
         super();
      }
      
      public static function CreateGrid() : void
      {
         var _loc1_:int = getTimer();
         Cleanup();
      }
      
      public static function Block(param1:Rectangle, param2:Boolean = false) : void
      {
         var _loc4_:Point = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc3_:Point = FromISO(param1.x,param1.y);
         param1.x = _loc3_.x;
         param1.y = _loc3_.y;
         var _loc5_:int = 0;
         while(_loc5_ < param1.width)
         {
            _loc6_ = 0;
            while(_loc6_ < param1.height)
            {
               if((_loc7_ = (_loc4_ = GlobalLocal(new Point(_loc5_ + param1.x,_loc6_ + param1.y),5)).x + _loc4_.y * _rowOffset) > 0 && _loc7_ < _grid.length)
               {
                  if(param2)
                  {
                     _grid[_loc4_.x + _loc4_.y * _rowOffset] |= 1;
                  }
                  else
                  {
                     _grid[_loc4_.x + _loc4_.y * _rowOffset] &= ~1;
                  }
               }
               _loc6_ += 5;
            }
            _loc5_ += 5;
         }
         Clear();
      }
      
      public static function FindSpace(param1:BFOUNDATION) : void
      {
         var _loc3_:Boolean = false;
         var _loc4_:Point = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc9_:int = 0;
         var _loc2_:Rectangle = param1._footprint[0];
         var _loc8_:int = 0;
         while(_loc8_ < 120)
         {
            _loc9_ = 0;
            while(_loc9_ < 100)
            {
               _loc4_ = ToISO(-(GLOBAL._mapWidth * 0.5) + _loc8_ * 10,-(GLOBAL._mapHeight * 0.5) + _loc9_ * 10,0);
               if(!FootprintBlocked(param1._footprint,_loc4_,true))
               {
                  LOGGER.Log("err","GRID.FindSpace " + _loc8_ + ", " + _loc9_ + ", " + _loc4_.x + ", " + _loc4_.y);
                  param1._mc.x = _loc4_.x;
                  param1._mc.y = _loc4_.y;
                  param1._mcBase.x = _loc4_.x;
                  param1._mcBase.y = _loc4_.y;
                  param1._mcFootprint.x = _loc4_.x;
                  param1._mcFootprint.y = _loc4_.y;
                  param1.GridCost(true);
                  return;
               }
               _loc9_++;
            }
            _loc8_++;
         }
      }
      
      public static function FootprintBlocked(param1:Array, param2:Point, param3:Boolean = false, param4:Boolean = false) : Boolean
      {
         var _loc5_:Rectangle = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         param2 = FromISO(param2.x,param2.y);
         for each(_loc5_ in param1)
         {
            _loc6_ = 0;
            while(_loc6_ < _loc5_.width)
            {
               _loc7_ = 0;
               while(_loc7_ < _loc5_.height)
               {
                  if(Blocked(new Point(_loc6_ + _loc5_.x + param2.x,_loc7_ + _loc5_.y + param2.y),param3,param4) > 0)
                  {
                     return true;
                  }
                  _loc7_ += 5;
               }
               _loc6_ += 5;
            }
         }
         return false;
      }
      
      public static function Blocked(param1:Point, param2:Boolean = false, param3:Boolean = false) : int
      {
         var _loc4_:Point;
         if((_loc4_ = GlobalLocal(new Point(param1.x,param1.y),5)).x < 0 || _loc4_.y < 0 || _loc4_.x >= _mapWidth / 5 || _loc4_.y >= _mapHeight / 5)
         {
            return 3;
         }
         var _loc5_:int = GLOBAL._mapWidth * 0.5;
         var _loc6_:int = GLOBAL._mapHeight * 0.5;
         if(param2 && !param3 && (param1.x < 0 - _loc5_ || param1.x >= _loc5_ || param1.y < 0 - _loc6_ || param1.y >= _loc6_))
         {
            return 2;
         }
         return _grid[_loc4_.x + _loc4_.y * _rowOffset] & 1;
      }
      
      public static function Clear() : void
      {
      }
      
      public static function Cleanup() : void
      {
         var _loc1_:int = Math.ceil(_mapWidth / 5) * Math.ceil(_mapHeight / 5);
         _grid = new Vector.<uint>(_loc1_,true);
      }
      
      public static function GlobalLocal(param1:Point, param2:int) : Point
      {
         var _loc3_:Number = int((param1.x + _mapWidth * 0.5) / param2);
         var _loc4_:Number = int((param1.y + _mapHeight * 0.5) / param2);
         return new Point(_loc3_,_loc4_);
      }
      
      public static function LocalGlobal(param1:Point, param2:int) : Point
      {
         var _loc3_:Number = int(param1.x * param2 - _mapWidth * 0.5) + param2 * 0.5;
         var _loc4_:Number = int(param1.y * param2 - _mapHeight * 0.5) + param2 * 0.5;
         return new Point(_loc3_,_loc4_);
      }
      
      public static function ToISO(param1:Number, param2:Number, param3:Number) : Point
      {
         var _loc4_:Number = (param1 + param2) * 0.5 - param3;
         var _loc5_:Number = param1 - param2;
         return new Point(Math.floor(_loc5_),Math.floor(_loc4_));
      }
      
      public static function FromISO(param1:Number, param2:Number) : Point
      {
         var _loc3_:Number = param2 - param1 * 0.5;
         var _loc4_:Number = param1 * 0.5 + param2;
         return new Point(Math.ceil(_loc4_),Math.ceil(_loc3_));
      }
   }
}
