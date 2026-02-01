package
{
   import com.monsters.enums.EnumYardType;
   import flash.events.IOErrorEvent;
   
   public class LOGGER
   {
      
      public static var _logged:Object = {};
      
      public static var _statQueue:Array = [];
      
      public static var _statUpdated:int = 0;
      
      public static const STAT_MEM:uint = 99;
      
      //public static var logQueue:Array  = [];
      
      public function LOGGER()
      {
         super();
      }
      
      public static function Log(logType:String, message:String, param3:Boolean = false) : void
      {
         var _loc4_:Array = null;
         if(message.search("recorddebugdata") != -1)
         {
            return;
         }
         if(param3 || !GLOBAL._flags || GLOBAL._flags && GLOBAL._flags.gamedebug == 1)
         {
            if(!_logged[logType + message])
            {
               if(logType == "hak" || logType == "err" || logType == "log")
               {
                  _logged[logType + message] = 1;
               }
               message = "" + "[v" + GLOBAL._version.Get() + "" + "r" + GLOBAL._softversion + "] " + message + " [mode: " + GLOBAL._loadmode + " baseid:" + BASE._baseID + "]";
               _loc4_ = [["key",logType],["value",message],["saveid",BASE._lastSaveID]];
               print(_loc4_.toString());
               new URLLoaderApi().load(GLOBAL._apiURL + "player/recorddebugdata",_loc4_,handleLoadSuccessful,handleLoadError);
            }
         }
      }
   
      /*public static function DebugQAdd(logMessage:String, debugVars:Object): void {
         logQueue.push({logMessage: logMessage, debugVars: JSON.stringify(debugVars)});
      }

      public static function DebugQPost(trace: Error = null) : void
      {
         var logger:Array = [["key", "logType"], ["message", JSON.stringify(logQueue)], ["saveid", BASE._lastSaveID] ];

         if (trace){
            logger.push(["error", JSON.stringify(trace.getStackTrace())]);
         }
         new URLLoaderApi().load(GLOBAL._apiURL + "player/recorddebugdata", logger, handleLoadSuccessful, handleLoadError);
      }*/
      
      public static function info(param1:String) : void
      {
         LOGGER.Log("info",param1);
      }
      
      public static function Stat(param1:Array) : void
      {
         var st1:String = null;
         var st2:String = null;
         var st3:String = null;
         var name:String = null;
         var val:int = 0;
         var level:int = 0;
         var n2:int = 0;
         var monsterID:String = null;
         var yardType:String = null;
         var o:Object = null;
         var data:Array = param1;
         if(!GLOBAL._flags.gamestatsb)
         {
            return;
         }
         try
         {
            n2 = 0;
            if(data[0] >= 1 && data[0] <= 4 || data[0] == 26 || data[0] == 51)
            {
               if(data[0] == 1 || data[0] == 2 || data[0] == 26 || data[0] == 67)
               {
                  st1 = "buildings";
               }
               if(data[0] == 1)
               {
                  st2 = GLOBAL.e_BASE_MODE.BUILD;
               }
               if(data[0] == 2)
               {
                  st2 = "upgrade";
               }
               if(data[0] == 26)
               {
                  st2 = "repairing";
               }
               if(data[0] == 67)
               {
                  st2 = "fortifying";
               }
               if(data[0] == 3 || data[0] == 4 || data[0] == 51)
               {
                  st1 = "monsters";
               }
               if(data[0] == 3)
               {
                  st2 = "unlocking";
               }
               if(data[0] == 4)
               {
                  st2 = "training";
               }
               if(data[0] == 51)
               {
                  st2 = "powerup";
               }
               if(data[0] == 1 || data[0] == 2 || data[0] == 26 || data[0] == 67)
               {
                  st3 = KEYS.Get(GLOBAL._buildingProps[data[1] - 1].name);
               }
               else
               {
                  monsterID = BASE.isInfernoMainYardOrOutpost ? "IC" : "C";
                  st3 = KEYS.Get(CREATURELOCKER._creatures[monsterID + data[1]].name);
               }
               name = "speedup";
               val = int(data[4]);
            }
            else if(data[0] == 5)
            {
               st1 = "buildings";
               st2 = GLOBAL.e_BASE_MODE.BUILD;
               st3 = KEYS.Get(GLOBAL._buildingProps[data[1] - 1].name);
               name = "build_start";
            }
            else if(data[0] == 6)
            {
               st1 = "buildings";
               st2 = GLOBAL.e_BASE_MODE.BUILD;
               st3 = KEYS.Get(GLOBAL._buildingProps[data[1] - 1].name);
               name = "build_finish";
            }
            else if(data[0] == 7)
            {
               st1 = "buildings";
               st2 = "upgrade";
               st3 = KEYS.Get(GLOBAL._buildingProps[data[1] - 1].name);
               name = "upgrade_start";
               val = int(data[2]);
            }
            else if(data[0] == 8)
            {
               st1 = "buildings";
               st2 = "upgrade";
               st3 = KEYS.Get(GLOBAL._buildingProps[data[1] - 1].name);
               name = "upgrade_finish";
               val = int(data[2]);
            }
            else if(data[0] == 9)
            {
               st1 = "monsters";
               st2 = "unlock";
               monsterID = BASE.isInfernoMainYardOrOutpost ? "IC" : "C";
               st3 = KEYS.Get(CREATURELOCKER._creatures[monsterID + data[1]].name);
               name = "start";
            }
            else if(data[0] == 10)
            {
               st1 = "monsters";
               st2 = "unlock";
               monsterID = BASE.isInfernoMainYardOrOutpost ? "IC" : "C";
               st3 = KEYS.Get(CREATURELOCKER._creatures[monsterID + data[1]].name);
               name = "finish";
            }
            else if(data[0] == 11)
            {
               st1 = "monsters";
               st2 = "train";
               monsterID = BASE.isInfernoMainYardOrOutpost ? "IC" : "C";
               st3 = KEYS.Get(CREATURELOCKER._creatures[monsterID + data[1]].name);
               name = "start";
               val = int(data[2]);
            }
            else if(data[0] == 12)
            {
               st1 = "monsters";
               st2 = "train";
               monsterID = BASE.isInfernoMainYardOrOutpost ? "IC" : "C";
               st3 = KEYS.Get(CREATURELOCKER._creatures[monsterID + data[1]].name);
               name = "finish";
               val = int(data[2]);
            }
            else if(data[0] == 13)
            {
               st1 = "store";
               st2 = String(data[1]);
               name = "cost";
               val = int(data[2]);
            }
            else if(data[0] == 14 || data[0] == 15 || data[0] == 66)
            {
               st1 = "helping";
               st2 = "buildings";
               name = String(data[1]);
               val = int(data[4]);
            }
            else if(data[0] != 16)
            {
               if(data[0] == 17)
               {
                  st1 = "looting";
                  st2 = KEYS.Get(GLOBAL._resourceNames[data[1] - 1]);
                  name = "quantity";
                  val = int(data[2]);
               }
               else if(data[0] == 18)
               {
                  st1 = "looting";
                  st2 = KEYS.Get(GLOBAL._resourceNames[data[1] - 1]);
                  name = "percent";
                  val = int(data[2]);
               }
               else if(data[0] != 19)
               {
                  if(data[0] == 27)
                  {
                     st1 = "catapult";
                     if(data[1] == 1)
                     {
                        st2 = "twig";
                     }
                     if(data[1] == 2)
                     {
                        st2 = "pebble";
                     }
                     if(data[1] == 3)
                     {
                        st2 = "putty";
                     }
                     if(data[2] == 0)
                     {
                        name = "small";
                     }
                     if(data[2] == 1)
                     {
                        name = "medium";
                     }
                     if(data[2] == 2)
                     {
                        name = "large";
                     }
                     if(data[2] == 3)
                     {
                        name = "huge";
                     }
                     val = int(data[3]);
                     if(data.length > 4)
                     {
                        n2 = int(data[4]);
                     }
                  }
                  else if(data[0] == 28)
                  {
                     st1 = "flinger";
                     name = String(data[1]);
                     val = int(data[2]);
                     if(data.length > 3)
                     {
                        n2 = int(data[3]);
                     }
                  }
                  else if(data[0] == 29)
                  {
                     st1 = "load";
                     name = String(data[1]);
                  }
                  else if(data[0] == 30)
                  {
                     st1 = "tutorial";
                     name = "start";
                  }
                  else if(data[0] == 31)
                  {
                     st1 = "tutorial";
                     name = "finish";
                  }
                  else if(data[0] == 32)
                  {
                     st1 = "banking";
                     name = KEYS.Get(GLOBAL._resourceNames[data[1] - 1]);
                     val = int(data[2]);
                  }
                  else if(data[0] == 33)
                  {
                     st1 = "levelup";
                     name = "level" + data[1];
                  }
                  else if(data[0] == 34)
                  {
                     st1 = "mushrooms";
                     name = "pick";
                     val = int(data[1]);
                  }
                  else if(data[0] == 35)
                  {
                     st1 = "mushrooms";
                     name = "spawn";
                     val = int(data[1]);
                  }
                  else if(data[0] == 36)
                  {
                     st1 = "marketing";
                     name = String(data[1]);
                     val = 1;
                  }
                  else if(data[0] == 37)
                  {
                     st1 = "takeover";
                     name = data[1] == 1 ? "wildmonster" : "player";
                     val = 1;
                  }
                  else if(data[0] == 38)
                  {
                     st1 = "starterkit";
                     name = String(data[1]);
                     val = int(data[2]);
                  }
                  else if(data[0] == 39)
                  {
                     st1 = "mushrooms";
                     name = "prompt";
                  }
                  else if(data[0] == 40)
                  {
                     st1 = "buildings";
                     st2 = "recycle";
                     st3 = KEYS.Get(GLOBAL._buildingProps[data[1] - 1].name);
                     name = "level";
                     val = int(data[2]);
                  }
                  else if(data[0] == 41)
                  {
                     st1 = "starterkit";
                     name = String(data[1]);
                     val = int(data[2]);
                  }
                  else if(data[0] == 42)
                  {
                     st1 = "dailybonus";
                     name = "drop";
                     LOGGER.Log("log","db:drop",true);
                  }
                  else if(data[0] == 43)
                  {
                     st1 = "dailybonus";
                     name = "win";
                     val = int(data[1]);
                     LOGGER.Log("log","db:win " + data[1],true);
                  }
                  else if(data[0] == 44)
                  {
                     st1 = "dailybonus";
                     name = "buy";
                     val = int(data[1]);
                     LOGGER.Log("log","db:buy " + data[1],true);
                  }
                  else if(data[0] == 45)
                  {
                     st1 = "mapv2relocate";
                     name = "mine";
                     val = int(data[1]);
                  }
                  else if(data[0] == 46)
                  {
                     st1 = "monsters";
                     st2 = "unlock";
                     monsterID = BASE.isInfernoMainYardOrOutpost ? "IC" : "C";
                     st3 = KEYS.Get(CREATURELOCKER._creatures[monsterID + data[1]].name);
                     name = "instant";
                  }
                  else if(data[0] == 47)
                  {
                     st1 = "monsters";
                     st2 = "train";
                     st3 = KEYS.Get(CREATURELOCKER._creatures[data[1]].name);
                     name = "instant";
                     val = int(data[2]);
                  }
                  else if(data[0] == 48)
                  {
                     st1 = "monsters";
                     st2 = "powerup";
                     monsterID = BASE.isInfernoMainYardOrOutpost ? "IC" : "C";
                     st3 = KEYS.Get(CREATURELOCKER._creatures[monsterID + data[1]].name);
                     name = "shiny";
                     val = int(data[2]);
                  }
                  else if(data[0] == 49)
                  {
                     st1 = "monsters";
                     st2 = "powerup";
                     monsterID = BASE.isInfernoMainYardOrOutpost ? "IC" : "C";
                     st3 = KEYS.Get(CREATURELOCKER._creatures[monsterID + data[1]].name);
                     name = "start";
                     val = int(data[2]);
                  }
                  else if(data[0] == 50)
                  {
                     st1 = "monsters";
                     st2 = "powerup";
                     monsterID = BASE.isInfernoMainYardOrOutpost ? "IC" : "C";
                     st3 = KEYS.Get(CREATURELOCKER._creatures[monsterID + data[1]].name);
                     name = "finish";
                     val = int(data[2]);
                  }
                  else if(data[0] == 59)
                  {
                     st1 = "champion";
                     st2 = "heal";
                     name = "level" + data[3];
                     st3 = String(CHAMPIONCAGE._guardians[data[1]].name);
                     val = int(data[2]);
                  }
                  else if(data[0] == 52)
                  {
                     st1 = "champion";
                     st2 = "select";
                     name = "level1";
                     st3 = String(CHAMPIONCAGE._guardians[data[1]].name);
                     val = int(data[2]);
                  }
                  else if(data[0] == 53)
                  {
                     st1 = "champion";
                     st2 = "attack_win";
                     name = "level" + data[3];
                     st3 = String(CHAMPIONCAGE._guardians[data[1]].name);
                     val = int(data[2]);
                  }
                  else if(data[0] == 54)
                  {
                     st1 = "champion";
                     st2 = "attack_lose";
                     name = "level" + data[3];
                     st3 = String(CHAMPIONCAGE._guardians[data[1]].name);
                     val = int(data[2]);
                  }
                  else if(data[0] == 55)
                  {
                     st1 = "champion";
                     st2 = "defense_win";
                     name = "level" + data[3];
                     st3 = String(CHAMPIONCAGE._guardians[data[1]].name);
                     val = int(data[2]);
                  }
                  else if(data[0] == 56)
                  {
                     st1 = "champion";
                     st2 = "defense_lose";
                     name = "level" + data[3];
                     st3 = String(CHAMPIONCAGE._guardians[data[1]].name);
                     val = int(data[2]);
                  }
                  else if(data[0] == 57)
                  {
                     st1 = "champion";
                     st2 = "evolve";
                     name = "level" + data[3];
                     st3 = String(CHAMPIONCAGE._guardians[data[1]].name);
                     val = int(data[2]);
                  }
                  else if(data[0] == 58)
                  {
                     st1 = "champion";
                     st2 = "feed";
                     name = "level" + data[3];
                     st3 = String(CHAMPIONCAGE._guardians[data[1]].name);
                     val = int(data[2]);
                  }
                  else if(data[0] == 60)
                  {
                     st1 = "champion";
                     st2 = "feed";
                     name = "buff" + data[3];
                     st3 = String(CHAMPIONCAGE._guardians[data[1]].name);
                     val = int(data[2]);
                  }
                  else if(data[0] == 61)
                  {
                     if(BASE.isInfernoMainYardOrOutpost)
                     {
                        st1 = "storeinf";
                     }
                     else
                     {
                        st1 = "store";
                     }
                     st2 = String(data[1]);
                     name = "cost-var";
                     val = int(data[2]);
                  }
                  else if(data[0] == 62)
                  {
                     st1 = "zazzle";
                     name = "view";
                     val = int(data[1]);
                  }
                  else if(data[0] == 63)
                  {
                     st1 = "zazzle";
                     name = "click";
                     val = int(data[1]);
                  }
                  else if(data[0] == 64)
                  {
                     st1 = "buildings";
                     st2 = "fortify" + data[2];
                     st3 = KEYS.Get(GLOBAL._buildingProps[data[1] - 1].name);
                     name = "fortify_start";
                     val = 1;
                  }
                  else if(data[0] == 65)
                  {
                     st1 = "buildings";
                     st2 = "fortify" + data[2];
                     st3 = KEYS.Get(GLOBAL._buildingProps[data[1] - 1].name);
                     name = "fortify_finish";
                     val = 1;
                  }
                  else if(data[0] == 68)
                  {
                     st1 = "chat";
                     name = String(data[1]);
                     val = 1;
                  }
                  else if(data[0] == 69)
                  {
                     st1 = "champion";
                     st2 = "freeze";
                     st3 = String(CHAMPIONCAGE._guardians["G" + data[1]].name);
                     name = "Level" + data[2];
                     val = 1;
                  }
                  else if(data[0] == 70)
                  {
                     st1 = "champion";
                     st2 = "thaw";
                     st3 = String(CHAMPIONCAGE._guardians["G" + data[1]].name);
                     name = "Level" + data[2];
                     val = 1;
                  }
                  else if(data[0] == 71)
                  {
                     st1 = "buildings";
                     st2 = GLOBAL.e_BASE_MODE.BUILD;
                     st3 = KEYS.Get(GLOBAL._buildingProps[data[2] - 1].name);
                     name = "build_instant";
                     val = int(data[1]);
                  }
                  else if(data[0] == 72)
                  {
                     st1 = "buildings";
                     st2 = "upgrade";
                     st3 = KEYS.Get(GLOBAL._buildingProps[data[2] - 1].name) + "_level" + data[3];
                     name = "upgrade_instant";
                     val = int(data[1]);
                  }
                  else if(data[0] == 74)
                  {
                     st1 = "711promo";
                     name = "popup";
                     val = int(data[1]);
                  }
                  else if(data[0] == 75)
                  {
                     st1 = "711promo";
                     name = "goldenbiggulp";
                     val = int(data[1]);
                  }
                  else if(data[0] == 76)
                  {
                     st1 = "711promo";
                     name = "overdriveused";
                     val = int(data[1]);
                  }
                  else if(data[0] == 77)
                  {
                     st1 = "711promo";
                     name = "tutorial";
                     val = int(data[1]);
                  }
                  else if(data[0] == 78)
                  {
                     st1 = "711promo";
                     name = "redemption";
                     val = int(data[1]);
                  }
                  else if(data[0] == 79)
                  {
                     st1 = "WMI";
                     name = "attempted";
                     val = int(data[1]);
                  }
                  else if(data[0] == 80)
                  {
                     st1 = "WMI";
                     name = "success";
                     val = int(data[1]);
                  }
                  else if(data[0] == 81)
                  {
                     st1 = "WMI";
                     name = "failed";
                     val = int(data[1]);
                  }
                  else if(data[0] == 82)
                  {
                     st1 = "WMI";
                     name = "totem_placed";
                     val = int(data[1]);
                  }
                  else if(data[0] == 83)
                  {
                     st1 = "WMI2";
                     st2 = "attempted";
                     name = String(data[1]);
                  }
                  else if(data[0] == 84)
                  {
                     st1 = "WMI2";
                     st2 = "success";
                     name = String(data[1]);
                  }
                  else if(data[0] == 85)
                  {
                     st1 = "WMI2";
                     st2 = "failed";
                     name = String(data[1]);
                  }
                  else if(data[0] == 86)
                  {
                     st1 = "WMI2";
                     st2 = "totem_placed";
                     name = String(data[1]);
                  }
                  else if(data[0] == 87)
                  {
                     st1 = "Inferno";
                     st2 = "Descent";
                     st3 = String(data[1]);
                     name = String(data[2]);
                  }
                  else if(data[0] == 88)
                  {
                     st1 = "loadmode";
                     name = String(data[1]);
                     switch(data[2])
                     {
                        case EnumYardType.MAIN_YARD:
                           yardType = "main_yard";
                           break;
                        case EnumYardType.OUTPOST:
                           yardType = "outpost";
                           break;
                        case EnumYardType.INFERNO_YARD:
                           yardType = "inferno_yard";
                           break;
                        case EnumYardType.INFERNO_OUTPOST:
                           yardType = "outpost";
                           break;
                        default:
                           yardType = "none";
                     }
                     st2 = yardType;
                  }
                  else if(data[0] == 89)
                  {
                     st1 = "attackpref";
                     st2 = "inferno";
                     name = String(data[1]);
                  }
                  else if(data[0] == 90)
                  {
                     st1 = "siege-weapon";
                     st2 = "unlock";
                     st3 = String(data[1] + data[2]);
                     name = String(data[3]);
                     if(data[4])
                     {
                        val = int(data[4]);
                     }
                  }
                  else if(data[0] == 91)
                  {
                     st1 = "siege-weapon";
                     st2 = "upgrade";
                     st3 = String(data[1] + data[2]);
                     name = String(data[3]);
                     if(data[4])
                     {
                        val = int(data[4]);
                     }
                  }
                  else if(data[0] == 92)
                  {
                     st1 = "siege-weapon";
                     st2 = GLOBAL.e_BASE_MODE.BUILD;
                     st3 = String(data[1] + data[2]);
                     name = String(data[3]);
                     if(data[4])
                     {
                        val = int(data[4]);
                     }
                  }
                  else if(data[0] == 93)
                  {
                     st1 = "siege-weapon";
                     st2 = "used_in_battle";
                     name = String(data[1] + data[2]);
                  }
                  else if(data[0] == 94)
                  {
                     st1 = "siege-weapon";
                     st2 = "vacuumloot";
                     st3 = "defender";
                     name = String(data[1] + data[2]);
                  }
                  else if(data[0] == 95)
                  {
                     st1 = "video";
                     val = 1;
                     name = "showed";
                  }
                  else if(data[0] == 96)
                  {
                     st1 = "banking";
                     st2 = "autobank";
                     switch(data[1])
                     {
                        case 1:
                           name = "Twigs";
                           break;
                        case 2:
                           name = "Pebbles";
                           break;
                        case 3:
                           name = "Putty";
                           break;
                        case 4:
                           name = "Goo";
                     }
                     val = int(data[2]);
                  }
                  else if(data[0] == 97)
                  {
                     st1 = "Monster_Madness";
                     val = int(data[1]);
                     name = "EV_current";
                  }
                  else if(data[0] == 98)
                  {
                     st1 = "video";
                     val = int(data[1]);
                     name = "EV_taken";
                  }
                  else if(data[0] == STAT_MEM)
                  {
                     st1 = "performance";
                     st2 = "mem";
                     name = String(data[1]);
                     val = int(data[2]);
                     n2 = int(data[3]);
                  }
               }
            }
            if(st1)
            {
               o = {};
               if(st1)
               {
                  o.st1 = st1.toLowerCase().replace(" ","_");
                  if(BASE.isOutpost)
                  {
                     o.st1 = "outpost-" + o.st1;
                  }
                  if(BASE.isMainYardInfernoOnly)
                  {
                     o.st1 = "inferno-" + o.st1;
                  }
               }
               if(st2)
               {
                  o.st2 = st2.toLowerCase().replace(" ","_");
               }
               if(st3)
               {
                  o.st3 = st3.toLowerCase().replace(" ","_");
               }
               if(val)
               {
                  o.value = val;
               }
               if(n2)
               {
                  o.n2 = n2;
               }
               StatB(o,name);
            }
         }
         catch(e:Error)
         {
            LOGGER.Log("log","LOGGER.Stat " + data);
         }
      }
      
      public static function StatB(param1:Object, param2:*) : void
      {
         if(!GLOBAL._flags || !GLOBAL._flags.gamestatsb)
         {
            return;
         }
         param1.level = BASE.BaseLevel().level;
         GLOBAL.CallJS("cc.recordEvent",[param2,param1],false);
      }
      
      public static function KongStat(param1:Array) : void
      {
         var st1:String = null;
         var st2:String = null;
         var st3:String = null;
         var name:String = null;
         var val:int = 0;
         var level:int = 0;
         var monsternames:Array = null;
         var arg:Object = null;
         var arrArg:Array = null;
         var data:Array = param1;
         if(!GLOBAL._flags.kongregate)
         {
            return;
         }
         try
         {
            monsternames = ["pokey","octo","bolt","fink","eyera","ichi","bandito","fang","brain","crabatron","projectx","dave","wormzer","teratorn","zafreeti"];
            switch(data[0])
            {
               case 1:
                  arg = {};
                  arg["unlock_" + monsternames[data[1] - 1]] = 1;
                  break;
               case 2:
                  arg = {"Townhall":data[1]};
                  break;
               case 3:
                  arg = {"looted":data[1]};
                  break;
               case 4:
                  arg = {"defense":data[1]};
                  break;
               case 5:
                  arg = {};
                  arg["train_" + monsternames[data[1] - 1]] = 1;
            }
            arrArg = [JSON.stringify(arg)];
            GLOBAL.CallJS("cc.kg_statsUpdate",[arg],false);
         }
         catch(e:Error)
         {
            LOGGER.Log("err","LOGGER.KongStat " + data);
         }
      }
      
      public static function Tick() : void
      {
      }
      
      public static function handleLoadSuccessful(param1:Object) : void
      {
         if(param1.error == 0)
         {
         }
      }
      
      public static function handleLoadError(param1:IOErrorEvent) : void
      {
      }
   }
}
