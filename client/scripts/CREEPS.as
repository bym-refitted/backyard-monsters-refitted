package
{
   import com.monsters.configs.BYMConfig;
   import com.monsters.events.CreepEvent;
   import com.monsters.monsters.MonsterBase;
   import com.monsters.monsters.champions.ChampionBase;
   import com.monsters.monsters.champions.Krallen;
   import com.monsters.monsters.creeps.CreepBase;
   import flash.display.BitmapData;
   import flash.geom.Point;
   import flash.utils.getTimer;
   
   public class CREEPS
   {
      
      public static var _creeps:Object;
      
      public static var m_attackingCreeps:Vector.<MonsterBase> = new Vector.<MonsterBase>();
      
      public static var _creepID:int;
      
      public static var _creepCount:int;
      
      public static var _flungCount:int;
      
      public static var _ticks:int;
      
      public static var _bmdHPbar:BitmapData = new bmp_healthbarsmall(0,0);
      
      private static var _creepOverlap:Object;
      
      public static var _flungGuardian:Array = [];
      
      public static var _guardianList:Vector.<ChampionBase> = new Vector.<ChampionBase>();
       
      private static var _overlapKeyCache:Object = {};

      private static var _cacheHits:int = 0;
      
      private static var _cacheMisses:int = 0;
      
      private static var _lastCacheClear:int = 0;
      
      // Performance optimization: Batch processing arrays
      private static var _aliveCreeps:Vector.<MonsterBase> = new Vector.<MonsterBase>();
      private static var _deadCreeps:Vector.<String> = new Vector.<String>();
      private static var _visibleCreepCount:int = 0;
      private static var _overlapProcessingIndex:int = 0;
      private static const OVERLAP_BATCH_SIZE:int = 10;
      
      public function CREEPS()
      {
         super();
         _creeps = {};
         m_attackingCreeps.length = 0;
         _creepID = 0;
         _creepCount = _flungCount = 0;
         _ticks = 0;
         _creepOverlap = {};
         _flungGuardian = new Array();
         _guardianList.length = 0;
      }
      
      public static function get krallen() : Krallen
      {
         var _loc2_:ChampionBase = null;
         var _loc1_:Vector.<ChampionBase> = CREEPS._guardianList;
         for each(_loc2_ in _loc1_)
         {
            if(_loc2_._creatureID === "G5")
            {
               return _loc2_ as Krallen;
            }
         }
         return null;
      }

      /*
      * Generates overlap key for creep positioning, using cache to avoid expensive string operations.
      * Caches frequently used position keys to eliminate repeated string concatenations.
      * 
      * @param creatureID The creature identifier
      * @param x The x coordinate 
      * @param y The y coordinate
      * @return Cached or newly created overlap key string
      */
      private static function getOverlapKey(creatureID:String, x:Number, y:Number):String {
         var gridX:int = int(x * 0.5);
         var gridY:int = int(y * 0.5);
         
         var cacheKey:String = creatureID + "_" + gridX + "_" + gridY;
         
         var cachedKey:String = _overlapKeyCache[cacheKey];
         if(cachedKey) {
            _cacheHits++;
            return cachedKey;
         }
         
         // Cache miss - create the overlap key
         _cacheMisses++;
         var overlapKey:String = creatureID + "x" + gridX + "y" + gridY;
         _overlapKeyCache[cacheKey] = overlapKey;
         
         return overlapKey;
      }

      /*
      * Clears the overlap key cache periodically to prevent memory growth.
      */
      private static function clearOverlapCache():void {
         _overlapKeyCache = {};
         _cacheHits = _cacheMisses = 0;
      }
      
      public static function Tick() : void
      {
         var _loc1_:int = getTimer();
         
         // Clear cache periodically to prevent memory bloat
         if(_loc1_ - _lastCacheClear > 30000)
         {
            clearOverlapCache();
            _lastCacheClear = _loc1_;
         }
         
         _aliveCreeps.length = 0;
         _deadCreeps.length = 0;
         _visibleCreepCount = 0;
         
         // Phase 1: Separate alive/dead creeps and tick alive ones
         var creepId:String;
         var creep:MonsterBase;
         for(creepId in _creeps)
         {
            creep = _creeps[creepId];
            
            if(!creep)
            {
               _deadCreeps.push(creepId);
               continue;
            }
            
            // Tick the creep first
            if(creep.tick(1))
            {
               if(!creep.dying)
               {
                  creep.die();
               }
               if(creep.dead)
               {
                  _deadCreeps.push(creepId);
                  continue;
               }
            }
            
            // Creep is alive, add to processing list
            _aliveCreeps.push(creep);
         }
         
         // Phase 2: Clean up dead creeps (batch operation)
         var deadId:String;
         for each(deadId in _deadCreeps)
         {
            creep = _creeps[deadId];
            
            if(!creep)
            {
               delete _creeps[deadId];
               continue;
            }
            
            if(!BYMConfig.instance.RENDERER_ON)
            {
               if(creep.graphic)
               {
                  MAP._BUILDINGTOPS.removeChild(creep.graphic);
               }
            }
            --_creepCount;
            
            if(creep._creatureID && (creep._creatureID.substr(0,1) == "G" || (GLOBAL.mode == GLOBAL.e_BASE_MODE.ATTACK || GLOBAL.mode == GLOBAL.e_BASE_MODE.WMATTACK) && !creep.isDisposable))
            {
               --_flungCount;
               ATTACK._creaturesFlung.Add(-1);
            }
            delete _creeps[deadId];
         }
         
         // Phase 3: Process overlap detection in batches (spread across multiple frames)
         processOverlapBatch();
         
         if(_creepCount <= 0) _flungCount = _creepCount = 0;
         
         if(GLOBAL.mode == GLOBAL.e_BASE_MODE.ATTACK || GLOBAL.mode == GLOBAL.e_BASE_MODE.WMATTACK)
         {
            if(ATTACK._creaturesFlung.Get() < _flungCount && ATTACK._creaturesFlung.Get() > 0)
            {
               LOGGER.Log("log","More creeps than flung creatures");
               GLOBAL.ErrorMessage();
            }
         }
      }
      
      /*
       * Process overlap detection in small batches to spread CPU load across frames
       */
      private static function processOverlapBatch():void
      {
         if(_aliveCreeps.length == 0) return;
         
         _creepOverlap = {}; // Reset overlap data
         var processed:int = 0;
         var startIndex:int = _overlapProcessingIndex;
         var creep:MonsterBase;
         var overlapKey:String;
         
         // Process a batch of creeps
         while(processed < OVERLAP_BATCH_SIZE && _overlapProcessingIndex < _aliveCreeps.length)
         {
            creep = _aliveCreeps[_overlapProcessingIndex];
            
            if(!creep || !creep._tmpPoint || !creep._creatureID)
            {
               _overlapProcessingIndex++;
               processed++;
               continue;
            }
            
            overlapKey = getOverlapKey(creep._creatureID, creep._tmpPoint.x, creep._tmpPoint.y);
            
            if(!_creepOverlap[overlapKey])
            {
               _creepOverlap[overlapKey] = 1;
               if(Boolean(creep._mc) && !creep._mc.visible)
               {
                  creep._mc.visible = true;
               }
            }
            else
            {
               _creepOverlap[overlapKey] += 1;
               if(_creepOverlap[overlapKey] > 1)
               {
                  if(Boolean(creep._mc) && creep._mc.visible)
                  {
                     creep._mc.visible = false;
                  }
               }
               else if(Boolean(creep._mc) && !creep._mc.visible)
               {
                  creep._mc.visible = true;
               }
            }
            
            if(Boolean(creep._mc) && creep._mc.visible)
            {
               _visibleCreepCount++;
            }
            
            _overlapProcessingIndex++;
            processed++;
         }
         
         // Reset index when we've processed all creeps
         if(_overlapProcessingIndex >= _aliveCreeps.length)
         {
            _overlapProcessingIndex = 0;
         }
      }
      
      public static function Spawn(param1:String, param2:*, param3:String, param4:Point, param5:Number, param6:Number = 1, param7:Boolean = false, param8:Boolean = false) : MonsterBase
      {
         var _loc9_:MonsterBase = null;
         ++_creepID;
         if(!param8)
         {
            ++_flungCount;
         }
         ++_creepCount;
         var _loc10_:Class;
         _loc10_ = CREATURELOCKER._creatures[param1].classType;
         if(!_loc10_)
         {
            _loc10_ = CreepBase;
         }
         _loc9_ = new _loc10_(param1,param3,param4,param5,0,int.MAX_VALUE,null,false,null,param6,param7);
         if(!BYMConfig.instance.RENDERER_ON)
         {
            param2.addChild(_loc9_.graphic);
         }
         _loc9_.isDisposable = param8;
         _creeps[_creepID] = _loc9_;
         m_attackingCreeps.push(_loc9_);
         GLOBAL.eventDispatcher.dispatchEvent(new CreepEvent(CreepEvent.ATTACKING_MONSTER_SPAWNED,_loc9_));
         return _loc9_;
      }
      
      public static function SpawnGuardian(param1:int, param2:*, param3:String, param4:int, param5:Point, param6:Number, param7:int = 20000, param8:int = 0, param9:int = 0, param10:Boolean = false) : ChampionBase
      {
         var _loc13_:int = 0;
         var _loc11_:Class = CHAMPIONCAGE.getGuardianSpawnClass(param1);
         ++_creepID;
         ++_creepCount;
         ++_flungCount;
         var _loc12_:ChampionBase = null;
         if(param10)
         {
            _loc12_ = new _loc11_(param3,param5,0,null,false,null,param4,0,0,param1,param7,param8,param9);
         }
         else
         {
            _loc13_ = GLOBAL.getPlayerGuardianIndex(param1);
            if(GLOBAL._playerGuardianData[_loc13_].status == ChampionBase.k_CHAMPION_STATUS_NORMAL)
            {
               _loc12_ = new _loc11_(param3,param5,0,null,false,null,param4,GLOBAL._playerGuardianData[_loc13_].fd,GLOBAL._playerGuardianData[_loc13_].ft,param1,param7,param8,param9);
               if(CHAMPIONCAGE.getGuardianClassType(param1) == CHAMPIONCAGE.CLASS_TYPE_BASIC)
               {
                  _guardian = _loc12_;
               }
               else if(!addGuardian(_loc12_))
               {
                  _loc12_ = null;
               }
            }
         }
         if(_loc12_)
         {
            _creeps[_creepID] = _loc12_;
            if(!BYMConfig.instance.RENDERER_ON)
            {
               param2.addChild(_loc12_.graphic);
            }
         }
         GLOBAL.eventDispatcher.dispatchEvent(new CreepEvent(CreepEvent.ATTACKING_MONSTER_SPAWNED,_loc12_));
         return _loc12_;
      }
      
      public static function Retreat() : void
      {
         var _loc1_:MonsterBase = null;
         for each(_loc1_ in _creeps)
         {
            _loc1_.changeModeRetreat();
         }
      }
      
      public static function CreepOverlap(param1:Point, param2:int) : Boolean
      {
         var _loc3_:MonsterBase = null;
         var _loc4_:Object = null;
         var _loc5_:Point = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:int = 0;
         for each(_loc3_ in _creeps)
         {
            if(_loc3_._creatureID.substr(0,1) == "G")
            {
               _loc4_ = SPRITES._sprites[(_loc3_ as ChampionBase)._spriteID];
            }
            else
            {
               _loc4_ = SPRITES._sprites[_loc3_._creatureID];
            }
            _loc5_ = new Point(_loc3_.x + _loc4_.middle.x,_loc3_.y + _loc4_.middle.y);
            _loc6_ = Math.atan2(param1.y - _loc5_.y,param1.x - _loc5_.x);
            _loc7_ = BASE.EllipseEdgeDistance(_loc6_,param2,param2 * BASE._angle);
            _loc6_ = Math.atan2(_loc5_.y - param1.y,_loc5_.x - param1.x);
            _loc8_ = BASE.EllipseEdgeDistance(_loc6_,_loc4_.width * 0.5,_loc4_.width * 0.5 * BASE._angle);
            _loc9_ = param1.x - _loc5_.x;
            _loc10_ = param1.y - _loc5_.y;
            if((_loc11_ = int(Math.sqrt(_loc9_ * _loc9_ + _loc10_ * _loc10_))) < _loc7_ + _loc8_)
            {
               return true;
            }
         }
         return false;
      }
      
      public static function Clear() : void
      {
         var _loc1_:MonsterBase = null;
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:int = 0;
         if(m_attackingCreeps)
         {
            m_attackingCreeps.length = 0;
         }
         for(_loc2_ in _creeps)
         {
            _loc1_ = _creeps[_loc2_];
            _loc1_.clear();
            if(!BYMConfig.instance.RENDERER_ON)
            {
               MAP._BUILDINGTOPS.removeChild(_loc1_.graphic);
            }
         }
         _creeps = {};
         _creepCount = _flungCount = 0;
         for(_loc3_ in _flungGuardian)
         {
            _flungGuardian[_loc3_] = false;
         }
         _loc4_ = 0;
         while(_loc4_ < _guardianList.length)
         {
            _guardianList[_loc4_] = null;
            _loc4_++;
         }
         _guardianList.length = 0;
         clearOverlapCache();
         Targeting.clearGridCaches();
      }
      
      public static function get _guardian() : ChampionBase
      {
         var _loc1_:int = 0;
         while(_loc1_ < _guardianList.length)
         {
            if(Boolean(_guardianList[_loc1_]) && CHAMPIONCAGE.isBasicGuardian(_guardianList[_loc1_]._creatureID))
            {
               return _guardianList[_loc1_];
            }
            _loc1_++;
         }
         return null;
      }
      
      public static function set _guardian(param1:ChampionBase) : void
      {
         var _loc2_:int = -1;
         var _loc3_:int = 0;
         while(_loc3_ < _guardianList.length)
         {
            if(CHAMPIONCAGE.isBasicGuardian(_guardianList[_loc3_]._creatureID))
            {
               _loc2_ = _loc3_;
            }
            _loc3_++;
         }
         if(_loc2_ == -1)
         {
            if(param1)
            {
               _guardianList.unshift(param1);
            }
         }
         else if(!param1)
         {
            _guardianList.splice(_loc2_,1);
         }
         else
         {
            _guardianList[_loc2_] = param1;
         }
      }
      
      public static function addGuardian(param1:ChampionBase) : Boolean
      {
         var _loc2_:int = -1;
         var _loc3_:int = 0;
         while(_loc3_ < _guardianList.length)
         {
            if(_guardianList[_loc3_]._creatureID == param1._creatureID)
            {
               _loc2_ = _loc3_;
            }
            _loc3_++;
         }
         if(_loc2_ == -1)
         {
            if(param1)
            {
               _guardianList.push(param1);
               return true;
            }
         }
         return false;
      }
      
      public static function getGuardianIndex(param1:int) : int
      {
         var _loc2_:int = 0;
         while(_loc2_ < _guardianList.length)
         {
            if(int(_guardianList[_loc2_]._creatureID.substr(1)) == param1)
            {
               return _loc2_;
            }
            _loc2_++;
         }
         return -1;
      }
   }
}
