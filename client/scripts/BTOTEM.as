package
{
   import com.cc.utils.SecNum;
   import com.monsters.inventory.InventoryManager;
   import com.monsters.managers.InstanceManager;
   import com.monsters.enums.EnumInvasionType;
   
   public class BTOTEM extends BDECORATION
   {
      
      public static const BTOTEM_WMI1:int = 121;

      public static const BTOTEM_WMI2:int = 131;
       
      
      public function BTOTEM(param1:int)
      {
         super(param1);
         if(Boolean(BASE._buildingsStored["b" + _type]) && Boolean(BASE._buildingsStored["bl" + _type]))
         {
            _lvl = new SecNum(BASE._buildingsStored["bl" + _type].Get());
            _hpLvl = _lvl.Get();
         }
      }
      
      public static function HasTotemPlaced(param1:Boolean = false, param2:Boolean = false) : Boolean
      {
         var _loc4_:BFOUNDATION = null;
         var _loc3_:Vector.<Object> = InstanceManager.getInstancesByClass(BDECORATION);
         for each(_loc4_ in _loc3_)
         {
            if(param1 && _loc4_._type == BTOTEM_WMI1)
            {
               return true;
            }
            if(param2 && _loc4_._type === BTOTEM_WMI2)
            {
               return true;
            }
         }
         return false;
      }
      
      public static function TotemReward() : void
      {
         if (GLOBAL._flags.activeInvasion == EnumInvasionType.WMI1) 
         {
            if(HasTotemPlaced(true, false)) return;
            
            RemoveAllFromStorage(true,false);
            RemoveAllFromYard(true,false);
            InventoryManager.buildingStorageAdd(BTOTEM_WMI1, 1);
         }
         else 
         {
            if(HasTotemPlaced(false, true)) return;
         
            RemoveAllFromStorage(false,true);
            RemoveAllFromYard(false,true);
            InventoryManager.buildingStorageAdd(BTOTEM_WMI2,1);
         }
      }
      
      public static function TotemPlace() : void
      {
         var totemType:int;
         if (GLOBAL._flags.activeInvasion == EnumInvasionType.WMI1) 
         {
            totemType = BTOTEM_WMI1;
         }
         else 
         {
            totemType = BTOTEM_WMI2;
         }
         
         // Check if there's actually a totem in storage to place
         if(!BASE._buildingsStored["b" + totemType] || BASE._buildingsStored["b" + totemType].Get() <= 0)
         {
            return;
         }
         
         BUILDINGS._buildingID = totemType;
         BUILDINGS.Show();
         BUILDINGS._mc.SwitchB(4,4,0);
      }
      
      public static function UpgradeTotem() : void
      {
         var _loc2_:BFOUNDATION = null;
         var _loc1_:Vector.<Object> = InstanceManager.getInstancesByClass(BDECORATION);
         for each(_loc2_ in _loc1_)
         {
            if(_loc2_._type === BTOTEM_WMI1 || _loc2_._type === BTOTEM_WMI2)
            {
               _loc2_.Upgraded();
            }
         }
         
         if(GLOBAL._flags.activeInvasion == EnumInvasionType.WMI1)
         {
            if(BASE._buildingsStored["bl" + BTOTEM_WMI1])
            {
               BASE._buildingsStored["bl" + BTOTEM_WMI1].Set(EarnedTotemLevel());
            }
         }
         else
         {
            if(BASE._buildingsStored["bl" + BTOTEM_WMI2])
            {
               BASE._buildingsStored["bl" + BTOTEM_WMI2].Set(EarnedTotemLevel2());
            }
         }
      }
      
      public static function RemoveAllFromStorage(param1:Boolean = false, param2:Boolean = false) : void
      {
         if(param1)
         {
            if(BASE._buildingsStored["b" + BTOTEM_WMI1])
            {
               delete BASE._buildingsStored["b" + BTOTEM_WMI1];
            }
            if(BASE._buildingsStored["bl" + BTOTEM_WMI1])
            {
               delete BASE._buildingsStored["bl" + BTOTEM_WMI1];
            }
         }
         if(param2)
         {
            if(BASE._buildingsStored["b" + BTOTEM_WMI2])
            {
               delete BASE._buildingsStored["b" + BTOTEM_WMI2];
            }
            if(BASE._buildingsStored["bl" + BTOTEM_WMI2])
            {
               delete BASE._buildingsStored["bl" + BTOTEM_WMI2];
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
               if(_loc4_._type == BTOTEM_WMI1)
               {
                  _loc4_.GridCost(false);
                  _loc4_.clear();
               }
            }
            if(param2)
            {
               if(_loc4_._type === BTOTEM_WMI2)
               {
                  _loc4_.GridCost(false);
                  _loc4_.clear();
               }
            }
         }
      }
      
      public static function EarnedTotemLevel() : int
      {
         var currentLevel:int = 0;
         var wmi_wave:int = GLOBAL.StatGet("wmi_wave");
         var storedLevel:int = GLOBAL.StatGet("wmi1_totem_level");
         
         switch(wmi_wave)
         {
            case 0:
               currentLevel = 0;
               break;
            case 1:
            case 2:
            case 3:
            case 4:
            case 5:
            case 6:
            case 7:
            case 8:
            case 9:
               currentLevel = 1;
               break;
            case 10:
            case 11:
            case 12:
            case 13:
            case 14:
            case 15:
            case 16:
            case 17:
            case 18:
            case 19:
               currentLevel = 2;
               break;
            case 20:
            case 21:
            case 22:
            case 23:
            case 24:
            case 25:
            case 26:
            case 27:
            case 28:
            case 29:
               currentLevel = 3;
               break;
            case 30:
               currentLevel = 4;
               break;
            case 31:
               currentLevel = 5;
               break;
            case 32:
               currentLevel = 6;
               break;
            default:
               currentLevel = 6;
               break;
         }
         
         if(currentLevel > storedLevel)
         {
            GLOBAL.StatSet("wmi1_totem_level", currentLevel);
            return currentLevel;
         }
         
         return storedLevel;
      }

      private static function EarnedTotemLevel2() : int
      {
         var currentLevel:int = 0;
         var wmi2_wave:int = GLOBAL.StatGet("wmi2_wave");
         var storedLevel:int = GLOBAL.StatGet("wmi2_totem_level");
         
         switch(wmi2_wave)
         {
            case 100:
               currentLevel = 0;
               break;
            case 101:
            case 102:
            case 103:
            case 104:
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
            case 132:
               currentLevel = 6;
               break;
            default:
               currentLevel = 6;
               break;
         }
         
         if(currentLevel > storedLevel)
         {
            GLOBAL.StatSet("wmi2_totem_level", currentLevel);
            return currentLevel;
         }
         
         return storedLevel;
      }
      
      public static function IsTotem(param1:int) : Boolean
      {
         return param1 == BTOTEM_WMI1;
      }
      
      public static function IsTotem2(param1:int) : Boolean
      {
         return param1 == BTOTEM_WMI2;
      }
      
      override public function Tick(param1:int) : void
      {
         super.Tick(param1);
         
         var earnedLevel:int;
         if(_type == BTOTEM_WMI1)
         {
            earnedLevel = EarnedTotemLevel();
         }
         else if(_type == BTOTEM_WMI2)
         {
            earnedLevel = EarnedTotemLevel2();
         }
         else
         {
            return;
         }
         
         if(_lvl.Get() != earnedLevel)
         {
            _lvl.Set(earnedLevel);
            _hpLvl = earnedLevel;
         }
      }
   }
}
