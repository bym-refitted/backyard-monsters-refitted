package
{
   import com.cc.utils.SecNum;
   import com.monsters.ai.TRIBES;
   import com.monsters.managers.InstanceManager;
   import com.monsters.maproom_manager.MapRoomManager;
   import com.monsters.monsters.MonsterBase;
   import com.monsters.player.MonsterData;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class HOUSING
   {
      
      public static var _housingPopup:MovieClip;
      
      public static var _open:Boolean;
      
      public static var _housingCapacity:SecNum;
      
      public static var _housingUsed:SecNum;
      
      public static var _housingSpace:SecNum;
      
      public static var _housingBuildingUpgrading:Boolean;
       
      
      public function HOUSING()
      {
         super();
      }
      
      public static function Show(param1:MouseEvent = null) : void
      {
         _open = true;
         GLOBAL.BlockerAdd();
         if(MapRoomManager.instance.isInMapRoom3)
         {
            _housingPopup = new HousingPersistentPopup();
         }
         else
         {
            _housingPopup = new HOUSINGPOPUP();
         }
         GLOBAL._layerWindows.addChild(_housingPopup);
         _housingPopup.Center();
         _housingPopup.ScaleUp();
      }
      
      public static function Hide(param1:MouseEvent = null) : void
      {
         if(_open)
         {
            GLOBAL.BlockerRemove();
            SOUNDS.Play("close");
            GLOBAL._layerWindows.removeChild(_housingPopup);
            _open = false;
            _housingPopup = null;
         }
      }
      
      public static function HousingSpace() : void
      {
         var _loc3_:BFOUNDATION = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         _housingCapacity = new SecNum(0);
         _housingUsed = new SecNum(0);
         _housingSpace = new SecNum(0);
         _housingBuildingUpgrading = false;
         var _loc1_:int = 0;
         var _loc2_:Vector.<Object> = InstanceManager.getInstancesByClass(BASE.isInfernoMainYardOrOutpost ? HOUSINGBUNKER : BUILDING15);
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_._countdownBuild.Get() <= 0 && (_loc3_.health > 10 || MapRoomManager.instance.isInMapRoom3))
            {
               _loc6_ = int(_loc3_._buildingProps.capacity[_loc3_._lvl.Get() - 1]);
               if(GLOBAL._extraHousing >= GLOBAL.Timestamp() && GLOBAL._extraHousingPower.Get() > 0)
               {
                  _loc6_ = addHousingCapacityMultiplier(_loc6_);
               }
               _housingCapacity.Add(_loc6_);
               _loc1_++;
            }
            if(_loc3_._countdownBuild.Get() + _loc3_._countdownUpgrade.Get() > 0)
            {
               _housingBuildingUpgrading = true;
            }
         }
         _loc4_ = int(GLOBAL.player.monsterList.length);
         _loc5_ = 0;
         while(_loc5_ < _loc4_)
         {
            _housingUsed.Add(CREATURES.GetProperty(GLOBAL.player.monsterList[_loc5_].m_creatureID,"cStorage",0,true) * GLOBAL.player.monsterList[_loc5_].numCreeps);
            _loc5_++;
         }
         _housingSpace.Set(_housingCapacity.Get() - _housingUsed.Get());
      }
      
      private static function addHousingCapacityMultiplier(param1:int) : int
      {
         return param1 * GLOBAL._extraHousingPower.Get();
      }
      
      public static function HousingStore(param1:String, param2:Point, param3:Boolean = false, param4:int = 0) : Boolean
      {
         var _loc7_:MonsterBase = null;
         var _loc8_:MonsterBase = null;
         if(param4 > 0)
         {
            LOGGER.Log("hak","Instant monster hack");
            GLOBAL.ErrorMessage("HOUSING insta monster hack");
            return false;
         }
         if(param1 == "C100")
         {
            param1 = "C12";
         }
         var _loc5_:int = CREATURES.GetProperty(param1,"cStorage",0,true);
         var _loc6_:Boolean = (GLOBAL.mode == GLOBAL.e_BASE_MODE.WMATTACK || GLOBAL.mode == GLOBAL.e_BASE_MODE.WMVIEW) && TRIBES.TribeForBaseID(BASE._wmID).behaviour == "juice";
         HousingSpace();
         if(_housingSpace.Get() < _loc5_ && !_loc6_)
         {
            return false;
         }
         if(!param3)
         {
            if(_loc6_)
            {
               if(_loc7_ = CREATURES.Spawn(param1,MAP._BUILDINGTOPS,"juice",param2,0))
               {
                  _loc7_.changeModeJuice();
               }
            }
            else
            {
               if(!(_loc8_ = createAndHouseCreep(param1,param2)))
               {
                  return false;
               }
               GLOBAL.player.addMonster(param1,_loc8_);
            }
         }
         return true;
      }
      
      public static function createAndHouseCreep(param1:String, param2:Point) : MonsterBase
      {
         var _loc3_:BFOUNDATION = getClosestHouseToPoint(param2);
         var _loc4_:MonsterBase = null;
         if(_loc3_)
         {
            _loc4_ = CREATURES.Spawn(param1,MAP._BUILDINGTOPS,"housing",param2,0,GRID.FromISO(_loc3_._mc.x,_loc3_._mc.y),_loc3_);
         }
         return _loc4_;
      }
      
      public static function getClosestHouseToPoint(param1:Point) : BFOUNDATION
      {
         var _loc4_:BFOUNDATION = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:int = 0;
         var _loc2_:Array = [];
         var _loc3_:Vector.<Object> = InstanceManager.getInstancesByClass(BASE.isInfernoMainYardOrOutpost ? HOUSINGBUNKER : BUILDING15);
         for each(_loc4_ in _loc3_)
         {
            if(_loc4_._countdownBuild.Get() <= 0 && (_loc4_.health > 0 || MapRoomManager.instance.isInMapRoom3))
            {
               _loc5_ = _loc4_._mc.x - param1.x;
               _loc6_ = _loc4_._mc.y - param1.y;
               _loc7_ = int(_loc4_._creatures.length);
               _loc2_.push({
                  "mc":_loc4_,
                  "dist":_loc7_
               });
            }
         }
         if(_loc2_.length == 0)
         {
            return null;
         }
         _loc2_.sortOn(["dist"],Array.NUMERIC);
         return _loc2_[0].mc;
      }
      
      public static function Cull(param1:Boolean = false) : void
      {
         var _loc3_:BFOUNDATION = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         _housingCapacity = new SecNum(0);
         _housingUsed = new SecNum(0);
         _housingSpace = new SecNum(0);
         var _loc2_:Vector.<Object> = InstanceManager.getInstancesByClass(BASE.isInfernoMainYardOrOutpost ? HOUSINGBUNKER : BUILDING15);
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_._countdownBuild.Get() <= 0 && (_loc3_.health > 0 || MapRoomManager.instance.isInMapRoom3))
            {
               _loc6_ = int(_loc3_._buildingProps.capacity[_loc3_._lvl.Get() - 1]);
               if(GLOBAL._extraHousing >= GLOBAL.Timestamp() && GLOBAL._extraHousingPower.Get() > 0)
               {
                  _loc6_ = addHousingCapacityMultiplier(_loc6_);
               }
               _housingCapacity.Add(_loc6_);
            }
         }
         _loc4_ = int(GLOBAL.player.monsterList.length);
         _loc5_ = 0;
         while(_loc5_ < _loc4_)
         {
            if(GLOBAL.player.monsterList[_loc5_].numCreeps)
            {
               _housingUsed.Add(CREATURES.GetProperty(GLOBAL.player.monsterList[_loc5_].m_creatureID,"cStorage",0,true) * GLOBAL.player.monsterList[_loc5_].numCreeps);
            }
            _loc5_++;
         }
         while(_housingUsed.Get() > _housingCapacity.Get())
         {
            _housingUsed.Set(0);
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               if(GLOBAL.player.monsterList[_loc5_].numCreeps > 0)
               {
                  GLOBAL.player.monsterList[_loc5_].add(-1,null,true);
                  _housingUsed.Add(CREATURES.GetProperty(GLOBAL.player.monsterList[_loc5_].m_creatureID,"cStorage",0,true) * GLOBAL.player.monsterList[_loc5_].numCreeps);
               }
               _loc5_++;
            }
         }
         HousingSpace();
      }
      
      public static function Populate() : void
      {
         var _loc3_:BFOUNDATION = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:BFOUNDATION = null;
         var _loc10_:Point = null;
         var _loc1_:Array = [];
         var _loc2_:Vector.<Object> = InstanceManager.getInstancesByClass(BASE.isInfernoMainYardOrOutpost ? HOUSINGBUNKER : BUILDING15);
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_.health > 0 || MapRoomManager.instance.isInMapRoom3)
            {
               _loc1_.push(_loc3_);
            }
         }
         if(_loc1_.length > 0)
         {
            _loc4_ = int(GLOBAL.player.monsterList.length);
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               _loc6_ = GLOBAL.player.monsterList[_loc5_].numCreeps;
               _loc7_ = 0;
               while(_loc7_ < _loc6_)
               {
                  if(!GLOBAL.player.monsterList[_loc5_].m_creeps[_loc7_].ownerID)
                  {
                     _loc8_ = Math.random() * _loc1_.length;
                     _loc9_ = _loc1_[_loc8_];
                     _loc10_ = GRID.FromISO(_loc9_.x,_loc9_.y);
                     GLOBAL.player.monsterList[_loc5_].m_creeps[_loc7_].self = CREATURES.Spawn(GLOBAL.player.monsterList[_loc5_].m_creatureID,MAP._BUILDINGTOPS,MonsterBase.k_sBHVR_PEN,PointInHouse(_loc10_),Math.random() * 360,_loc10_,_loc9_,GLOBAL.player.monsterList[_loc5_].level,GLOBAL.player.monsterList[_loc5_].m_creeps[_loc7_].health);
                  }
                  _loc7_++;
               }
               _loc5_++;
            }
         }
      }
      
      public static function PointInHouse(param1:Point) : Point
      {
         var _loc2_:Rectangle = new Rectangle(40,40,80,80);
         return GRID.ToISO(param1.x + (_loc2_.x + Math.random() * _loc2_.width),param1.y + (_loc2_.y + Math.random() * _loc2_.height),0);
      }
      
      public static function Update() : void
      {
         if(_open)
         {
            _housingPopup.Update();
         }
      }
      
      public static function catchupTick(param1:int) : void
      {
         GLOBAL.player.tickHeal(param1);
      }
      
      public static function isHousingBuilding(param1:int) : Boolean
      {
         return param1 == 15 || param1 == 128;
      }
      
      public static function AddHouse(param1:BFOUNDATION) : void
      {
         HousingSpace();
         GLOBAL._bHousing = param1;
      }
      
      public static function RemoveHouse(param1:BFOUNDATION) : void
      {
         GLOBAL._bHousing = null;
         HousingSpace();
      }
      
      public static function GetHousingCreatures() : Array
      {
         var _loc10_:String = null;
         var _loc11_:Object = null;
         var _loc12_:String = null;
         var _loc13_:Object = null;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:MonsterData = null;
         var _loc17_:Object = null;
         var _loc1_:Array = [];
         var _loc2_:Array = [];
         var _loc3_:Array = [];
         var _loc4_:Object = CREATURELOCKER.GetCreatures("above");
         var _loc5_:*;
         if(_loc5_ = !BASE.isInfernoMainYardOrOutpost)
         {
            for(_loc10_ in _loc4_)
            {
               if(!(_loc11_ = CREATURELOCKER._creatures[_loc10_]).blocked)
               {
                  _loc11_.id = _loc10_;
                  _loc1_.push(_loc11_);
               }
            }
            _loc1_.sortOn(["index"],Array.NUMERIC);
         }
         var _loc6_:Object = CREATURELOCKER.GetCreatures("inferno");
         var _loc7_:Boolean;
         if(_loc7_ = MAPROOM_DESCENT.DescentPassed)
         {
            for(_loc12_ in _loc6_)
            {
               if(!(_loc13_ = CREATURELOCKER._creatures[_loc12_]).blocked)
               {
                  _loc13_.id = _loc12_;
                  _loc2_.push(_loc13_);
               }
            }
            _loc2_.sortOn(["index"],Array.NUMERIC);
         }
         if(_loc1_.length > 0)
         {
            _loc3_ = _loc3_.concat(_loc1_);
         }
         if(_loc2_.length > 0)
         {
            _loc3_ = _loc3_.concat(_loc2_);
         }
         var _loc8_:Array = [];
         var _loc9_:int = 0;
         while(_loc9_ < _loc3_.length)
         {
            _loc14_ = int(GLOBAL.player.monsterList.length);
            _loc15_ = 0;
            while(_loc15_ < _loc14_)
            {
               if((_loc16_ = GLOBAL.player.monsterList[_loc15_]).m_creatureID == _loc3_[_loc9_].id)
               {
                  if(_loc16_.numCreeps > 0)
                  {
                     (_loc17_ = _loc3_[_loc9_]).quantity = _loc16_.numHousedCreeps;
                     _loc8_.push(_loc17_);
                  }
               }
               _loc15_++;
            }
            _loc9_++;
         }
         return _loc8_;
      }
   }
}
