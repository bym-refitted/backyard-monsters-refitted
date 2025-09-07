package
{
   import com.monsters.interfaces.ITargetable;
   import com.monsters.monsters.DummyTarget;
   import com.monsters.monsters.MonsterBase;
   import com.monsters.pathing.PATHING;
   import flash.geom.Point;
   import flash.utils.getQualifiedClassName;
   
   public class Targeting
   {
      
      public static const k_TARGETS_DEFENDERS:int = 1 << 0;
      
      public static const k_TARGETS_ATTACKERS:int = 1 << 1;
      
      public static const k_TARGETS_GROUND:int = 1 << 2;
      
      public static const k_TARGETS_FLYING:int = 1 << 3;
      
      public static const k_TARGETS_INVISIBLE:int = 1 << 4;
      
      public static const k_TARGETS_BUILDINGS:int = 1 << 5;
      
      public static const k_TARGETS_ALL:int = int.MAX_VALUE;
      
      public static var _creepCells:Object = {};
      
      public static var _deadCreepCells:Object;
      
      public static const _CELLSIZE:int = 100;
       
      private static var _gridKeyCache:Object = {};
      
      private static var _cartesianCache:Object = {};
      
      // Performance tracking and cache management
      private static var _cacheCleanupCounter:int = 0;
      private static const CACHE_CLEANUP_INTERVAL:int = 1800; // Clean cache every 30 seconds at 60fps
      private static var _creepCellMoveCallCount:int = 0;
      
      // Range query result caching
      private static var _rangeQueryCache:Object = {};
      private static var _rangeQueryFrameStamp:Object = {};
      private static var _currentFrame:int = 0;
      
      public function Targeting()
      {
         super();
         init();
      }
      
      public static function init() : void
      {
         _creepCells = {};
         _deadCreepCells = {};
      }

      /*
       * Optimized grid key generation with coordinate transformation caching.
       * Eliminates redundant ISO/Cartesian conversions and string concatenations.
      */
      private static function getGridKey(isoPoint:Point):String {
         // Create cache key for ISO coordinates (rounded to avoid floating point issues)
         var cacheKey:String = int(isoPoint.x) + "_" + int(isoPoint.y);
         
         // Check if we already calculated this grid position
         var cachedGridKey:String = _gridKeyCache[cacheKey];
         if(cachedGridKey) {
            return cachedGridKey;
         }
         
         // Check if we already have cartesian conversion cached
         var cartesian:Point = _cartesianCache[cacheKey];
         if(!cartesian) {
            cartesian = GRID.FromISO(isoPoint.x, isoPoint.y);
            _cartesianCache[cacheKey] = cartesian;
         }
         
         // Calculate grid key once
         var gridKey:String = "node" + int(cartesian.x / _CELLSIZE) + "|" + int(cartesian.y / _CELLSIZE);
         _gridKeyCache[cacheKey] = gridKey;
         
         return gridKey;
      }

      /*
       * Clears coordinate and grid caches to prevent memory growth.
      */
      public static function clearGridCaches():void {
         _gridKeyCache = {};
         _cartesianCache = {};
      }
      
      /*
       * Reset performance counters
      */
      public static function resetPerformanceStats():void {
         _creepCellMoveCallCount = 0;
      }
      
      public static function CreepCellAdd(param1:Point, param2:String, param3:MonsterBase) : String
      {
         var _loc4_:String = getGridKey(param1);

         var _loc5_:Object;
         if(!(_loc5_ = param3.dead ? _deadCreepCells : _creepCells)[_loc4_])
         {
            _loc5_[_loc4_] = new Array();
         }
         _loc5_[_loc4_]["creep" + param2] = param3;
         return _loc4_;
      }
      
      public static function CreepCellMove(param1:Point, param2:String, param3:MonsterBase, param4:String) : String
      {
         // Performance tracking
         _creepCellMoveCallCount++;
         
         // Periodic cache cleanup to prevent memory growth
         _cacheCleanupCounter++;
         if(_cacheCleanupCounter >= CACHE_CLEANUP_INTERVAL)
         {
            _cacheCleanupCounter = 0;
            clearGridCaches();
         }
         
         var _loc5_:String = getGridKey(param1);
         
         if(_loc5_ != param4)
         {
            CreepCellDelete(param2, param4, param3.dead);
            return CreepCellAdd(param1, param2, param3);
         }
         return "";
      }
      
      public static function CreepCellDelete(param1:String, param2:String, param3:Boolean = false) : void
      {
         var _loc4_:Object;
         if((_loc4_ = param3 ? _deadCreepCells : _creepCells)[param2])
         {
            delete _loc4_[param2]["creep" + param1];
         }
      }
      
      public static function getTargetsInRange(radius:Number, location:Point, targetFlags:int, ignoreCreep:MonsterBase = null, ignoreBuilding:BFOUNDATION = null) : Array
      {
         var _loc5_:Array = [];
         if(Boolean(targetFlags & k_TARGETS_ATTACKERS) || Boolean(targetFlags & k_TARGETS_DEFENDERS))
         {
            _loc5_ = _loc5_.concat(getCreepsInRange(radius,location,targetFlags,ignoreCreep));
         }
         if(targetFlags & k_TARGETS_BUILDINGS)
         {
            _loc5_ = _loc5_.concat(getBuildingsInRange(radius,location,ignoreBuilding));
         }
         return _loc5_;
      }
      
      public static function getAllBUTTargetsInRange(param1:Number, param2:Point, param3:int = 0) : Array
      {
         var _loc4_:Array = [];
         _loc4_ = getCreepsInRange(param1,param2,~param3);
         if(!(param3 & k_TARGETS_BUILDINGS))
         {
            _loc4_ = _loc4_.concat(getBuildingsInRange(param1,param2));
         }
         return _loc4_;
      }
      
      public static function getTargetThatHasAllFlagsInRange(param1:Number, param2:Point, param3:int = 0, param4:MonsterBase = null) : Array
      {
         var _loc11_:int = 0;
         var _loc12_:String = null;
         var _loc13_:String = null;
         var _loc14_:MonsterBase = null;
         var _loc15_:Number = NaN;
         var _loc16_:Point = null;
         var _loc17_:int = 0;
         var _loc5_:int = int(param2.x / _CELLSIZE);
         var _loc6_:int = int(param2.y / _CELLSIZE);
         var _loc7_:int = int(param1 / _CELLSIZE) + 1;
         var _loc8_:Array = [];
         var _loc9_:Number = param1 * param1;
         var _loc10_:int = _loc5_ - _loc7_;
         while(_loc10_ <= _loc5_ + _loc7_)
         {
            _loc11_ = _loc6_ - _loc7_;
            while(_loc11_ <= _loc6_ + _loc7_)
            {
               _loc12_ = "node" + _loc10_ + "|" + _loc11_;
               for(_loc13_ in _creepCells[_loc12_])
               {
                  if((_loc14_ = _creepCells[_loc12_][_loc13_]) != param4 && canHitCreep(_loc14_.defenseFlags,param3))
                  {
                     _loc15_ = _loc14_.health;
                     _loc16_ = PATHING.FromISO(_loc14_._tmpPoint);
                     if((_loc17_ = int(GLOBAL.QuickDistanceSquared(param2,_loc16_))) < _loc9_)
                     {
                        _loc8_.push({
                           "creep":_loc14_,
                           "dist":Math.sqrt(_loc17_),
                           "pos":_loc16_,
                           "hp":_loc15_
                        });
                     }
                  }
               }
               _loc11_++;
            }
            _loc10_++;
         }
         return _loc8_;
      }
      
      public static function getBuildingsInRange(param1:Number, param2:Point, param3:BFOUNDATION = null) : Array
      {
         var _loc5_:BFOUNDATION = null;
         var _loc6_:int = 0;
         var _loc4_:Array = [];
         for each(_loc5_ in BASE._buildingsAll)
         {
            if(_loc5_.isTargetable && _loc5_ != param3)
            {
               if((_loc6_ = int(GLOBAL.QuickDistanceSquared(param2,new Point(_loc5_.x,_loc5_.y)))) < param1 * param1)
               {
                  _loc4_.push({
                     "creep":_loc5_,
                     "dist":Math.sqrt(_loc6_)
                  });
               }
            }
         }
         return _loc4_;
      }
      
      public static function getOldStyleTargets(param1:int) : int
      {
         var _loc2_:* = 0;
         if(param1 == -1)
         {
            _loc2_ |= k_TARGETS_GROUND | k_TARGETS_INVISIBLE;
         }
         else if(param1 == 0)
         {
            _loc2_ |= k_TARGETS_GROUND;
         }
         else if(param1 == 1)
         {
            _loc2_ |= k_TARGETS_GROUND | k_TARGETS_FLYING;
         }
         else if(param1 == 2)
         {
            _loc2_ |= k_TARGETS_FLYING;
         }
         return _loc2_ | k_TARGETS_ATTACKERS;
      }
      
      public static function getCreepsInRange(param1:Number, param2:Point, param3:int = 0, param4:MonsterBase = null) : Array
      {
         // Performance optimization: Cache range query results within the same frame
         _currentFrame = GLOBAL._frameNumber;
         var cacheKey:String = param1 + "_" + int(param2.x) + "_" + int(param2.y) + "_" + param3 + "_" + (param4 ? param4._id : "null");
         
         // Check if we have a cached result from this frame
         if(_rangeQueryCache[cacheKey] && _rangeQueryFrameStamp[cacheKey] == _currentFrame)
         {
            return _rangeQueryCache[cacheKey];
         }
         
         var _loc11_:int = 0;
         var _loc12_:String = null;
         var _loc13_:String = null;
         var _loc14_:MonsterBase = null;
         var _loc15_:Number = NaN;
         var _loc16_:Point = null;
         var _loc17_:int = 0;
         if(!(param3 & k_TARGETS_DEFENDERS || param3 & k_TARGETS_ATTACKERS))
         {
            if(GLOBAL._aiDesignMode)
            {
               print("haha, you are a fool! Attempting to get creeps in range, but targeting attacking or defending creeps not defined");
            }
            return null;
         }
         param2 = PATHING.FromISO(param2);
         var _loc5_:int = int(param2.x / _CELLSIZE);
         var _loc6_:int = int(param2.y / _CELLSIZE);
         var _loc7_:int = int(param1 / _CELLSIZE) + 1;
         var _loc8_:Array = [];
         var _loc9_:Number = param1 * param1;
         var _loc10_:int = _loc5_ - _loc7_;
         while(_loc10_ <= _loc5_ + _loc7_)
         {
            _loc11_ = _loc6_ - _loc7_;
            while(_loc11_ <= _loc6_ + _loc7_)
            {
               _loc12_ = "node" + _loc10_ + "|" + _loc11_;
               for(_loc13_ in _creepCells[_loc12_])
               {
                  if((_loc14_ = _creepCells[_loc12_][_loc13_]).health > 0 && _loc14_.isTargetable && _loc14_ != param4 && canHitCreep(param3,_loc14_.defenseFlags))
                  {
                     _loc15_ = _loc14_.health;
                     _loc16_ = PATHING.FromISO(_loc14_._tmpPoint);
                     if((_loc17_ = int(GLOBAL.QuickDistanceSquared(param2,_loc16_))) < _loc9_)
                     {
                        _loc8_.push({
                           "creep":_loc14_,
                           "dist":Math.sqrt(_loc17_),
                           "pos":_loc16_,
                           "hp":_loc15_
                        });
                     }
                  }
               }
               _loc11_++;
            }
            _loc10_++;
         }
         
         // Cache the result for this frame
         _rangeQueryCache[cacheKey] = _loc8_;
         _rangeQueryFrameStamp[cacheKey] = _currentFrame;
         
         // Periodic cleanup of old cache entries (keep last 10 frames worth)
         if(_currentFrame % 300 == 0) // Every 5 seconds at 60fps
         {
            for(var oldCacheKey:String in _rangeQueryFrameStamp)
            {
               if(_rangeQueryFrameStamp[oldCacheKey] < _currentFrame - 10)
               {
                  delete _rangeQueryCache[oldCacheKey];
                  delete _rangeQueryFrameStamp[oldCacheKey];
               }
            }
         }
         
         return _loc8_;
      }
      
      public static function getDeadCreeps(param1:Point, param2:Number, param3:int = 0, param4:MonsterBase = null) : Array
      {
         var _loc11_:int = 0;
         var _loc12_:String = null;
         var _loc13_:String = null;
         var _loc14_:MonsterBase = null;
         var _loc15_:Number = NaN;
         var _loc16_:Point = null;
         var _loc17_:int = 0;
         param1 = PATHING.FromISO(param1);
         var _loc5_:int = int(param1.x / _CELLSIZE);
         var _loc6_:int = int(param1.y / _CELLSIZE);
         var _loc7_:int = int(param2 / _CELLSIZE) + 1;
         var _loc8_:Array = [];
         var _loc9_:Number = param2 * param2;
         var _loc10_:int = _loc5_ - _loc7_;
         while(_loc10_ <= _loc5_ + _loc7_)
         {
            _loc11_ = _loc6_ - _loc7_;
            while(_loc11_ <= _loc6_ + _loc7_)
            {
               _loc12_ = "node" + _loc10_ + "|" + _loc11_;
               for(_loc13_ in _deadCreepCells[_loc12_])
               {
                  if((_loc14_ = _deadCreepCells[_loc12_][_loc13_]).health <= 0 && _loc14_._visible && _loc14_.isTargetable && _loc14_ != param4)
                  {
                     if(canHitCreep(param3,_loc14_.defenseFlags))
                     {
                        _loc15_ = _loc14_.health;
                        _loc16_ = PATHING.FromISO(_loc14_._tmpPoint);
                        if((_loc17_ = int(GLOBAL.QuickDistanceSquared(param1,_loc16_))) < _loc9_)
                        {
                           _loc8_.push({
                              "creep":_loc14_,
                              "dist":Math.sqrt(_loc17_),
                              "pos":_loc16_,
                              "hp":_loc15_
                           });
                        }
                     }
                  }
               }
               _loc11_++;
            }
            _loc10_++;
         }
         return _loc8_;
      }
      
      public static function canHitCreep(param1:int, param2:int) : Boolean
      {
         param1 = ~param1;
         return !(param1 & param2);
      }
      
      public static function getClosestCreep(param1:Number, param2:Point, param3:int = 0, param4:MonsterBase = null) : MonsterBase
      {
         var _loc5_:Array;
         if((_loc5_ = getCreepsInRange(param1,param2,param3,param4)).length <= 0)
         {
            return null;
         }
         _loc5_.sortOn(["dist"],Array.NUMERIC);
         return _loc5_[0].creep;
      }
      
      public static function DealLinearAEDamage(param1:Point, param2:Number, param3:Number, param4:Array, param5:Number = 0) : int
      {
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:String = null;
         var _loc10_:* = undefined;
         if(param5 > param2)
         {
            param5 = param2 - 1;
         }
         for each(_loc10_ in param4)
         {
            if(getQualifiedClassName(_loc10_) == "Object")
            {
               _loc6_ = int(_loc10_.dist);
               _loc10_ = _loc10_.creep;
            }
            else
            {
               _loc6_ = GLOBAL.QuickDistance(param1,new Point(_loc10_.x,_loc10_.y));
            }
            if(param2 >= _loc6_)
            {
               if(_loc6_ < param5)
               {
                  _loc7_ = param3;
               }
               else
               {
                  _loc7_ = param3 / param2 * (param2 - _loc6_);
               }
               if(_loc7_ < param3 / 5)
               {
                  _loc7_ = param3 / 5;
               }
               if(_loc10_ is BFOUNDATION)
               {
                  BFOUNDATION(_loc10_).modifyHealth(_loc7_,new DummyTarget(param1.x,param1.y));
               }
               else
               {
                  _loc7_ *= _loc10_._damageMult;
                  _loc10_.modifyHealth(-_loc7_);
               }
               _loc8_ += _loc7_;
            }
         }
         ATTACK.Damage(param1.x,param1.y,_loc8_);
         return _loc8_;
      }
      
      public static function getFriendlyFlag(param1:MonsterBase) : int
      {
         return param1._friendly ? k_TARGETS_DEFENDERS : k_TARGETS_ATTACKERS;
      }
      
      public static function getEnemyFlag(param1:MonsterBase) : int
      {
         return param1._friendly ? k_TARGETS_ATTACKERS : k_TARGETS_DEFENDERS;
      }
      
      public static function getClosestEnemy(param1:uint, param2:Point, param3:int) : ITargetable
      {
         var _loc4_:Array;
         if((_loc4_ = getTargetsInRange(param1,param2,param3)).length <= 0)
         {
            return null;
         }
         _loc4_.sortOn(["dist"],Array.NUMERIC);
         return _loc4_[0].creep;
      }
   }
}
