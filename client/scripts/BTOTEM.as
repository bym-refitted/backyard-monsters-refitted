package
{
   import com.cc.utils.SecNum;
   import com.monsters.inventory.InventoryManager;
   import com.monsters.managers.InstanceManager;
   
   public class BTOTEM extends BDECORATION
   {
      
      public static const BTOTEM_BUILDING_TYPE:int = 131;
       
      
      public function BTOTEM(param1:int)
      {
         super(param1);
         if(Boolean(BASE._buildingsStored["b" + _type]) && Boolean(BASE._buildingsStored["bl" + _type]))
         {
            _lvl = new SecNum(BASE._buildingsStored["bl" + _type].Get());
            _hpLvl = _lvl.Get();
         }
      }
      
      public static function TotemReward() : void
      {
         RemoveAllFromStorage(false,true);
         RemoveAllFromYard(false,true);
         InventoryManager.buildingStorageAdd(BTOTEM_BUILDING_TYPE,1);
      }
      
      public static function TotemPlace() : void
      {
         BUILDINGS._buildingID = BTOTEM_BUILDING_TYPE;
         BUILDINGS.Show();
         BUILDINGS._mc.SwitchB(4,4,0);
      }
      
      public static function UpgradeTotem() : void
      {
         var _loc2_:BFOUNDATION = null;
         var _loc1_:Vector.<Object> = InstanceManager.getInstancesByClass(BDECORATION);
         for each(_loc2_ in _loc1_)
         {
            if(_loc2_._type === BTOTEM_BUILDING_TYPE)
            {
               _loc2_.Upgraded();
            }
         }
         if(BASE._buildingsStored["bl" + BTOTEM_BUILDING_TYPE])
         {
            BASE._buildingsStored["bl" + BTOTEM_BUILDING_TYPE].Add(1);
         }
      }
      
      public static function DowngradeTotem() : void
      {
         var _loc2_:BFOUNDATION = null;
         var _loc1_:Vector.<Object> = InstanceManager.getInstancesByClass(BDECORATION);
         for each(_loc2_ in _loc1_)
         {
            if(_loc2_._type === BTOTEM_BUILDING_TYPE)
            {
               _loc2_.Downgrade_TOTEM_DEBUG();
            }
         }
         if(BASE._buildingsStored["bl" + BTOTEM_BUILDING_TYPE])
         {
            BASE._buildingsStored["bl" + BTOTEM_BUILDING_TYPE].Add(-1);
         }
      }
      
      public static function RemoveAllFromStorage(param1:Boolean = false, param2:Boolean = false) : void
      {
         var _loc3_:Number = NaN;
         if(param1)
         {
            _loc3_ = 121;
            while(_loc3_ <= 126)
            {
               if(BASE._buildingsStored["b" + _loc3_])
               {
                  delete BASE._buildingsStored["b" + _loc3_];
               }
               if(BASE._buildingsStored["bl" + _loc3_])
               {
                  delete BASE._buildingsStored["bl" + _loc3_];
               }
               _loc3_++;
            }
         }
         if(param2)
         {
            if(BASE._buildingsStored["b" + BTOTEM_BUILDING_TYPE])
            {
               delete BASE._buildingsStored["b" + BTOTEM_BUILDING_TYPE];
            }
            if(BASE._buildingsStored["bl" + BTOTEM_BUILDING_TYPE])
            {
               delete BASE._buildingsStored["bl" + BTOTEM_BUILDING_TYPE];
            }
         }
      }
      
      public static function RemoveAllFromYard(param1:Boolean = false, param2:Boolean = false) : void
      {
         var _loc4_:BFOUNDATION = null;
         var _loc3_:Vector.<Object> = InstanceManager.getInstancesByClass(BDECORATION);
         for each(_loc4_ in _loc3_)
         {
            if(param1)
            {
               if(_loc4_._type >= 121 && _loc4_._type <= 126)
               {
                  _loc4_.GridCost(false);
                  _loc4_.clear();
               }
            }
            if(param2)
            {
               if(_loc4_._type === BTOTEM_BUILDING_TYPE)
               {
                  _loc4_.GridCost(false);
                  _loc4_.clear();
               }
            }
         }
      }
      
      public static function FindMissingTotem() : void
      {
         var _loc2_:Vector.<Object> = null;
         var _loc3_:BFOUNDATION = null;
         if(GLOBAL.mode != GLOBAL.e_BASE_MODE.BUILD)
         {
            return;
         }
         var _loc1_:int = EarnedTotemLevel();
         if(_loc1_ > 0 && BASE.isMainYard)
         {
            _loc2_ = InstanceManager.getInstancesByClass(BDECORATION);
            for each(_loc3_ in _loc2_)
            {
               if(_loc3_._type === BTOTEM_BUILDING_TYPE)
               {
                  return;
               }
            }
            if(!BASE._buildingsStored["b" + BTOTEM_BUILDING_TYPE])
            {
               InventoryManager.buildingStorageAdd(BTOTEM_BUILDING_TYPE,_loc1_);
               GLOBAL.Message("It\'s come to our attention that the Wild Monsters have been stealing some players\' Totems. If yours seems to be missing, don\'t fret! Just check your storage and it should be ready for placement.");
            }
         }
      }
      
      private static function EarnedTotemLevel() : int
      {
         switch(SPECIALEVENT.wave)
         {
            case 0:
            case 1:
               return 0;
            case 2:
            case 3:
            case 4:
            case 5:
            case 6:
            case 7:
            case 8:
            case 9:
            case 10:
               return 1;
            case 11:
            case 12:
            case 13:
            case 14:
            case 15:
            case 16:
            case 17:
            case 18:
            case 19:
            case 20:
               return 2;
            case 21:
            case 22:
            case 23:
            case 24:
            case 25:
            case 26:
            case 27:
            case 28:
            case 29:
            case 30:
               return 3;
            case 31:
               return 4;
            case 32:
               return 5;
            default:
               return 6;
         }
      }

      private static function EarnedTotemLevel2() : int
      {
         var wmi2_wave:int = GLOBAL.StatGet("wmi2_wave");
         var currentLevel:int = 0;
         
         switch(wmi2_wave)
         {
            case 0:
            case 101:
            case 102:
            case 103:
            case 104:
               currentLevel = 0;
               break;
            case 105:
            case 106:
            case 107:
            case 108:
            case 109:
               currentLevel = 1;
               break;
            case 110:
            case 111:
            case 112:
            case 113:
            case 114:
            case 115:
            case 116:
            case 117:
            case 118:
            case 119:
               currentLevel = 2;
               break;
            case 120:
            case 121:
            case 122:
            case 123:
            case 124:
            case 125:
            case 126:
            case 127:
            case 128:
            case 129:
               currentLevel = 3;
               break;
            case 130:
               currentLevel = 4;
               break;
            case 131:
               currentLevel = 5;
               break;
            default:
               currentLevel = 6;
               break;
         }
         
         var storedLevel:int = GLOBAL.StatGet("bl" + BTOTEM_BUILDING_TYPE);
         if(currentLevel > storedLevel)
         {
            GLOBAL.StatSet("bl" + BTOTEM_BUILDING_TYPE, currentLevel);
            return currentLevel;
         }
         
         return storedLevel;
      }
      
      public static function IsTotem(param1:int, param2:Boolean = true) : Boolean
      {
         return param1 >= 121 && param1 <= 126 || !param2 && param1 == BTOTEM_BUILDING_TYPE;
      }
      
      public static function IsTotem2(param1:int) : Boolean
      {
         return param1 == BTOTEM_BUILDING_TYPE;
      }
      
      override public function Tick(param1:int) : void
      {
         super.Tick(param1);
         // Only update totem level for WMI2 totems (type 131)
         // WMI1 totems (types 121-126) should be managed by SPECIALEVENT_WM1.TotemQualified()
         if(_type == BTOTEM_BUILDING_TYPE)
         {
            var _loc2_:int = EarnedTotemLevel2();
            if(_lvl.Get() != _loc2_)
            {
               _lvl.Set(_loc2_);
               _hpLvl = _loc2_;
            }
         }
      }
   }
}
