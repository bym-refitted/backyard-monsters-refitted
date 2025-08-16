package
{
   import com.monsters.configs.BYMConfig;
   import com.monsters.events.CreepEvent;
   import com.monsters.monsters.MonsterBase;
   import com.monsters.monsters.champions.ChampionBase;
   import com.monsters.monsters.creeps.CreepBase;
   import flash.geom.Point;
   
   public class CREATURES
   {
      
      public static var _creatures:Object;
      
      public static var _creatureID:int;
      
      public static var _creatureCount:int;
      
      public static var _ticks:int;
      
      public static var _guardianList:Vector.<ChampionBase> = new Vector.<ChampionBase>();
       
      
      public function CREATURES()
      {
         super();
         _creatures = {};
         _creatureID = 0;
         _creatureCount = 0;
         _ticks = 0;
         _guardianList.length = 0;
      }
      
      public static function GetProperty(param1:String, param2:String, param3:int = 0, param4:Boolean = true) : Number
      {
         var stat:Array = null;
         var checkID:String = null;
         var monsterID:String = param1;
         var statID:String = param2;
         var level:int = param3;
         var friendly:Boolean = param4;
         if(!monsterID || monsterID.substr(0,1) == "G")
         {
            return 0;
         }
         try
         {
            try
            {
               if(monsterID == "C100")
               {
                  monsterID = "C12";
               }
               if(!GLOBAL.player.m_upgrades[monsterID])
               {
                  GLOBAL.player.m_upgrades[monsterID] = {"level":1};
               }
               stat = CREATURELOCKER._creatures[monsterID].props[statID];
               if(!stat)
               {
                  return 0;
               }
               checkID = monsterID;
               if(CREATURELOCKER._creatures[checkID].dependent)
               {
                  checkID = String(CREATURELOCKER._creatures[checkID].dependent);
               }
               if(GLOBAL.mode == GLOBAL.e_BASE_MODE.ATTACK || GLOBAL.mode == GLOBAL.e_BASE_MODE.WMATTACK || !friendly)
               {
                  if(level == 0)
                  {
                     if(!friendly && Boolean(GLOBAL.attackingPlayer))
                     {
                        if(GLOBAL.attackingPlayer.m_upgrades[checkID] != null)
                        {
                           level = int(GLOBAL.attackingPlayer.m_upgrades[checkID].level);
                        }
                     }
                     else if(GLOBAL.player.m_upgrades[checkID] != null)
                     {
                        level = int(GLOBAL.player.m_upgrades[checkID].level);
                     }
                  }
               }
               else if(level == 0 && GLOBAL.player.m_upgrades[checkID] != null)
               {
                  // The following logic was added from an older SWF which included Wild Monster Invasion 1 specific logic
                  // SWF version: game-v120.v7
                  // =============================================== // 
                  if(SPECIALEVENT_WM1.active && !friendly)
                  {
                     level = int(GLOBAL._wmCreatureLevels[monsterID]);
                  }
                  // =============================================== // 
                  level = int(GLOBAL.player.m_upgrades[checkID].level);
               }
               if(stat.length < level)
               {
                  level = int(stat.length);
               }
            }
            catch(e:Error)
            {
            }
            return stat[level - 1];
         }
         catch(e:Error)
         {
         }
         return 0;
      }
      
      public static function Tick() : void
      {
         var _loc1_:MonsterBase = null;
         var _loc2_:String = null;
         for(_loc2_ in _creatures)
         {
            _loc1_ = _creatures[_loc2_];
            if(_loc1_.tick())
            {
               if(!_loc1_.dying || _loc1_.juiceReady)
               {
                  _loc1_.die();
                  if(!_loc1_.isDisposable && Boolean(GLOBAL.player.monsterListByID(_loc1_._creatureID)))
                  {
                     GLOBAL.player.monsterListByID(_loc1_._creatureID).unlinkCreepFromData(_loc1_);
                  }
               }
               if(_loc1_.dead)
               {
                  if(!BYMConfig.instance.RENDERER_ON)
                  {
                     MAP._BUILDINGTOPS.removeChild(_loc1_.graphic);
                  }
                  --_creatureCount;
                  delete _creatures[_loc2_];
               }
            }
         }
         if(_creatureCount <= 0)
         {
            _creatureCount = 0;
         }
      }
      
      public static function Spawn(param1:String, param2:*, param3:String, param4:Point, param5:Number, param6:Point = null, param7:BFOUNDATION = null, param8:int = 0, param9:int = 2147483647) : MonsterBase
      {
         var _loc10_:MonsterBase = null;
         var _loc11_:String = null;
         if(!CREATURELOCKER._creatures[param1])
         {
            return null;
         }
         ++_creatureID;
         ++_creatureCount;
         var _loc12_:Class;
         if(!(_loc12_ = CREATURELOCKER._creatures[param1].classType))
         {
            _loc12_ = CreepBase;
         }
         if(!BYMConfig.instance.RENDERER_ON)
         {
            _loc10_ = new _loc12_(param1,param3,param4,param5,param8,param9,param6,true,param7,1,false,null);
            param2.addChild(_loc10_.graphic);
         }
         else
         {
            _loc10_ = new _loc12_(param1,param3,param4,param5,param8,param9,param6,true,param7,1,false,null);
         }
         _creatures[_creatureID] = _loc10_;
         if(GLOBAL._render)
         {
            _loc10_._spawned = true;
         }
         GLOBAL.eventDispatcher.dispatchEvent(new CreepEvent(CreepEvent.DEFENDING_CREEP_SPAWNED,_loc10_));
         return _loc10_;
      }
      
      public static function Clear() : void
      {
         var _loc1_:MonsterBase = null;
         var _loc2_:String = null;
         var _loc3_:int = 0;
         for(_loc2_ in _creatures)
         {
            _loc1_ = _creatures[_loc2_];
            _loc1_.clear();
            if(!BYMConfig.instance.RENDERER_ON)
            {
               MAP._BUILDINGTOPS.removeChild(_loc1_.graphic);
            }
         }
         _creatures = {};
         _creatureCount = 0;
         _loc3_ = 0;
         while(_loc3_ < _guardianList.length)
         {
            if(!BYMConfig.instance.RENDERER_ON)
            {
               MAP._BUILDINGTOPS.removeChild(_guardianList[_loc3_].graphic);
            }
            _guardianList[_loc3_] = null;
            _loc3_++;
         }
         _guardianList.length = 0;
      }
      
      public static function get _hasLivingGuardian() : Boolean
      {
         for(var idx:int = 0; idx < _guardianList.length; idx++)
         {
            if(_guardianList[idx] && _guardianList[idx].health > 0)
            {
               return true;
            }
         }
         return false;
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
      
      public static function get _krallen() : ChampionBase
      {
         var _loc1_:int = 0;
         while(_loc1_ < _guardianList.length)
         {
            if(Boolean(_guardianList[_loc1_]) && _guardianList[_loc1_]._creatureID == "G5")
            {
               return _guardianList[_loc1_];
            }
            _loc1_++;
         }
         return null;
      }
      
      public static function getGuardian(param1:int) : ChampionBase
      {
         var _loc2_:int = 0;
         while(_loc2_ < _guardianList.length)
         {
            if(int(_guardianList[_loc2_]._creatureID.substr(1)) == param1)
            {
               return _guardianList[_loc2_];
            }
            _loc2_++;
         }
         return null;
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
      
      public static function set _guardian(param1:ChampionBase) : void
      {
         var _loc2_:int = -1;
         var _loc3_:int = 0;
         while(_loc3_ < _guardianList.length)
         {
            if(Boolean(_guardianList[_loc3_]) && CHAMPIONCAGE.isBasicGuardian(_guardianList[_loc3_]._creatureID))
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
      
      public static function removeGuardianType(param1:int) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < _guardianList.length)
         {
            if(int(_guardianList[_loc2_]._creatureID.substr(1)) == param1)
            {
               break;
            }
            _loc2_++;
         }
         if(_loc2_ < _guardianList.length)
         {
            if(!BYMConfig.instance.RENDERER_ON)
            {
               MAP._BUILDINGTOPS.removeChild(_guardianList[_loc2_].graphic);
            }
            if(_guardianList[_loc2_] == _guardian)
            {
               _guardian = null;
            }
            else
            {
               _guardianList.splice(_loc2_,1);
            }
         }
      }
      
      public static function removeAllGuardians() : void
      {
         var _loc1_:int = int(_guardianList.length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            if(!BYMConfig.instance.RENDERER_ON)
            {
               MAP._BUILDINGTOPS.removeChild(_guardianList[_loc2_].graphic);
            }
            _loc2_++;
         }
         _guardianList.length = 0;
      }
   }
}
