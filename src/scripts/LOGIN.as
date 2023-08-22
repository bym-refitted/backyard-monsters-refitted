package
{
   import com.cc.utils.SecNum;
   import com.monsters.configs.BYMDevConfig;
   import com.monsters.enums.EnumYardType;
   import com.monsters.maproom_manager.MapRoomManager;
   import com.monsters.player.Player;
   import flash.events.*;
   import flash.external.ExternalInterface;
   import flash.net.*;
   import flash.system.Capabilities;
   
   public class LOGIN
   {
      
      public static var _playerID:int;
      
      public static var _playerName:String;
      
      public static var _playerLastName:String;
      
      public static var _playerPic:String;
      
      public static var _timePlayed:int;
      
      public static var _playerLevel:int;
      
      public static var _email:String;
      
      public static var _proxymail:String;
      
      public static var _settings:Object;
      
      public static var _digits:Array;
      
      public static var _sumdigit:int;
      
      public static var _inferno:int = 0;
       
      
      public function LOGIN()
      {
         super();
      }
      
      public static function Login() : void
      {
         // Comment: Setting onMapRoom3 to true forces the player onto map room 3 and skips the migration process.
         var onMapRoom3:Boolean = true;
         var mapRoom3HeaderURL:String = "http://localhost:3001/" + "api/bm/getnewmap";
         MapRoomManager.instance.init(onMapRoom3, mapRoom3HeaderURL);
         LOGIN.Process();
         // new URLLoaderApi().load(GLOBAL._apiURL + "bm/getnewmap",null, OnGetNewMap); // OnGetNewMap
      }
      
      private static function OnGetNewMap(serverData:Object) : void
      {
         _Login(serverData.newmap, serverData.mapheaderurl);
      }
      
      // Comment: This function is skipped. We directly process login instead.
      private static function _Login(newmap:Boolean, mapheaderurl:String) : void
      {
         var handleLoadSuccessful:Function;
         var handleLoadError:Function;
         var onMapRoom3:Boolean = newmap;
         var mapRoom3HeaderURL:String = mapheaderurl;
         MapRoomManager.instance.init(onMapRoom3,mapRoom3HeaderURL);
         if(GLOBAL._local)
         {
            handleLoadSuccessful = function(serverData:Object):void
            {
               if(serverData.error == 0)
               {
                  LOGIN.Process(serverData);
               }
               else
               {
                  GLOBAL.ErrorMessage(serverData.error,GLOBAL.ERROR_ORANGE_BOX_ONLY);
               }
            };
            handleLoadError = function(serverData:IOErrorEvent):void
            {
               GLOBAL.WaitHide();
               GLOBAL.ErrorMessage("LOGIN loadEror");
            };
            new URLLoaderApi().load(GLOBAL._apiURL + "player/getinfo",[["version",GLOBAL._version.Get()]],handleLoadSuccessful);
         }
         else
         {
            ExternalInterface.addCallback("loginsuccessful",function(param1:String):void
            {
               var _loc2_:Object = JSON.decode(param1);
               GLOBAL.WaitHide();
               if(_loc2_.error == 0)
               {
                  if(LOGIN.checkHash(param1))
                  {
                     LOGIN.Process(_loc2_);
                  }
                  else
                  {
                     LOGGER.Log("err","JSLogin",true);
                     GLOBAL.ErrorMessage("JSLogin");
                  }
               }
               else
               {
                  GLOBAL.ErrorMessage(_loc2_.error,GLOBAL.ERROR_ORANGE_BOX_ONLY);
               }
            });
            if(BYMDevConfig.instance.USE_CLIENT_WITH_CALLBACK)
            {
               GLOBAL.CallJSWithClient("cc.initApplication","loginsuccessful",[GLOBAL._version.Get()]);
            }
            else
            {
               GLOBAL.CallJS("cc.initApplication",[GLOBAL._version.Get(),"loginsuccessful"]);
            }
            logFlashCapabilities();
         }
      }
      
      public static function Process() : void
      {
         GLOBAL.player = new Player();
         GLOBAL.player.ID = 10101010;
         GLOBAL.player.name = "John";
         GLOBAL.player.lastName = "Doe";
         GLOBAL.player.picture = "";
         GLOBAL.player.timePlayed = 200;
         GLOBAL.player.email = "reactX@hotmail.com";
         _playerID = 101;
         _playerName = "John";
         _playerLastName = "Doe";
         _playerPic = "";
         _timePlayed = 200;
         _email = "reactX@hotmail.com";
         GLOBAL._friendCount = 0;
         GLOBAL._sessionCount = 1;
         GLOBAL._addTime = 100;
         GLOBAL._mapVersion = 3;
         GLOBAL._mailVersion = 1;
         GLOBAL._soundVersion = 1;
         GLOBAL._languageVersion = 8;
         GLOBAL._appid = "2de76fv89";
         GLOBAL._tpid = "t76fbxXsw";
         GLOBAL._currencyURL = "";
         BASE._isFan = int(0);
         KEYS._storageURL = GLOBAL.languageUrl;
         KEYS._logFunction = LOGGER.Log;
         KEYS._languageVersion = GLOBAL._languageVersion;
         KEYS._language = "en";
         POPUPS.Setup();
         Digits(_playerID);
         KEYS.Setup(Done);
      }
      
      public static function Digits(param1:int) : void
      {
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc2_:String = param1.toString();
         _digits = [];
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            _digits.push(int(_loc2_.charAt(_loc3_)));
            _loc3_++;
         }
         _sumdigit = 0;
         if(_digits.length >= 3)
         {
            _loc5_ = (_loc4_ = int(_digits[_digits.length - 1] + _digits[_digits.length - 2] + _digits[_digits.length - 3])).toString();
            _sumdigit = int(_loc5_.substr(_loc5_.length - 1,1));
         }
      }
      
      public static function Done() : void
      {
         var _loc1_:int = 0;
         GLOBAL.Setup();
         if(GLOBAL._openBase && GLOBAL._openBase.url && (Boolean(GLOBAL._openBase.userid) || Boolean(GLOBAL._openBase.baseid)) && GLOBAL._openBase.userid != LOGIN._playerID)
         {
            BASE.yardType = MapRoomManager.instance.isInMapRoom3 ? int(EnumYardType.PLAYER) : int(EnumYardType.MAIN_YARD);
            if(!GLOBAL._openBase.userid)
            {
               GLOBAL._openBase.userid = 0;
            }
            if(!GLOBAL._openBase.baseid)
            {
               GLOBAL._openBase.baseid = 0;
            }
            GLOBAL._currentCell = null;
            GLOBAL.setMode(GLOBAL.e_BASE_MODE.HELP);
            _loc1_ = 1;
            while(_loc1_ < 5)
            {
               GLOBAL._resources["r" + _loc1_] = new SecNum(0);
               GLOBAL._hpResources["r" + _loc1_] = 0;
               _loc1_++;
            }
            BASE.Load(GLOBAL._openBase.url,GLOBAL._openBase.userid,GLOBAL._openBase.baseid);
         }
         else if(_inferno != 0)
         {
            MapRoomManager.instance.mapRoomVersion = MapRoomManager.MAP_ROOM_VERSION_1;
            BASE.yardType = EnumYardType.INFERNO_YARD;
            BASE.LoadBase(GLOBAL._infBaseURL,0,0,"ibuild",false,EnumYardType.INFERNO_YARD);
         }
         else
         {
            BASE.yardType = MapRoomManager.instance.isInMapRoom3 ? int(EnumYardType.PLAYER) : int(EnumYardType.MAIN_YARD);
            var s:String = "Comment: The Load() function gets called from this block.";
            BASE.Load();
         }
      }
      
      private static function logFlashCapabilities() : void
      {
         var _loc1_:Object = null;
         if(ExternalInterface.available)
         {
            _loc1_ = {
               "flash_version":Capabilities.version,
               "screen_resolution":Capabilities.screenResolutionX + "x" + Capabilities.screenResolutionY,
               "screen_dpi":Capabilities.screenDPI
            };
            GLOBAL.CallJS("cc.logFlashCapabilities",[_loc1_]);
         }
      }
      
      public static function checkHash(param1:String) : Boolean
      {
         var _loc2_:Array = param1.split(",\"h\":");
         param1 = _loc2_[0] + "}";
         var _loc3_:String = "{\"h\":" + _loc2_[1];
         var _loc4_:String = param1;
         var _loc5_:* = JSON.decode(param1);
         var _loc6_:* = JSON.decode(_loc3_);
         var _loc7_:String;
         if((_loc7_ = md5(getSalt() + _loc4_ + getNum(_loc6_.hn))) !== _loc6_.h)
         {
            return false;
         }
         return true;
      }
      
      public static function getNum(param1:int) : int
      {
         return param1 * (param1 % 11);
      }
      
      public static function getSalt() : String
      {
         return decodeSalt("84V37530976X4W7175W9Z02U3483Y6VW");
      }
      
      public static function decodeSalt(param1:String) : String
      {
         var _loc4_:String = null;
         var _loc2_:* = "";
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc4_ = param1.substring(_loc3_,_loc3_ + 1);
            switch(_loc4_)
            {
               case "a":
                  _loc2_ += "Z";
                  break;
               case "b":
                  _loc2_ += "Y";
                  break;
               case "c":
                  _loc2_ += "X";
                  break;
               case "d":
                  _loc2_ += "W";
                  break;
               case "e":
                  _loc2_ += "V";
                  break;
               case "f":
                  _loc2_ += "U";
                  break;
               case "g":
                  _loc2_ += "T";
                  break;
               case "h":
                  _loc2_ += "S";
                  break;
               case "i":
                  _loc2_ += "R";
                  break;
               case "j":
                  _loc2_ += "Q";
                  break;
               case "k":
                  _loc2_ += "P";
                  break;
               case "l":
                  _loc2_ += "O";
                  break;
               case "m":
                  _loc2_ += "N";
                  break;
               case "n":
                  _loc2_ += "M";
                  break;
               case "o":
                  _loc2_ += "L";
                  break;
               case "p":
                  _loc2_ += "K";
                  break;
               case "q":
                  _loc2_ += "J";
                  break;
               case "r":
                  _loc2_ += "I";
                  break;
               case "s":
                  _loc2_ += "H";
                  break;
               case "t":
                  _loc2_ += "G";
                  break;
               case "u":
                  _loc2_ += "F";
                  break;
               case "v":
                  _loc2_ += "E";
                  break;
               case "w":
                  _loc2_ += "D";
                  break;
               case "x":
                  _loc2_ += "C";
                  break;
               case "y":
                  _loc2_ += "B";
                  break;
               case "z":
                  _loc2_ += "A";
                  break;
               case "A":
                  _loc2_ += "z";
                  break;
               case "B":
                  _loc2_ += "y";
                  break;
               case "C":
                  _loc2_ += "x";
                  break;
               case "D":
                  _loc2_ += "w";
                  break;
               case "E":
                  _loc2_ += "v";
                  break;
               case "F":
                  _loc2_ += "u";
                  break;
               case "G":
                  _loc2_ += "t";
                  break;
               case "H":
                  _loc2_ += "s";
                  break;
               case "I":
                  _loc2_ += "r";
                  break;
               case "J":
                  _loc2_ += "q";
                  break;
               case "K":
                  _loc2_ += "p";
                  break;
               case "L":
                  _loc2_ += "o";
                  break;
               case "M":
                  _loc2_ += "n";
                  break;
               case "N":
                  _loc2_ += "m";
                  break;
               case "O":
                  _loc2_ += "l";
                  break;
               case "P":
                  _loc2_ += "k";
                  break;
               case "Q":
                  _loc2_ += "j";
                  break;
               case "R":
                  _loc2_ += "i";
                  break;
               case "S":
                  _loc2_ += "h";
                  break;
               case "T":
                  _loc2_ += "g";
                  break;
               case "U":
                  _loc2_ += "f";
                  break;
               case "V":
                  _loc2_ += "e";
                  break;
               case "W":
                  _loc2_ += "d";
                  break;
               case "X":
                  _loc2_ += "c";
                  break;
               case "Y":
                  _loc2_ += "b";
                  break;
               case "Z":
                  _loc2_ += "a";
                  break;
               case "0":
                  _loc2_ += "9";
                  break;
               case "1":
                  _loc2_ += "8";
                  break;
               case "2":
                  _loc2_ += "7";
                  break;
               case "3":
                  _loc2_ += "6";
                  break;
               case "4":
                  _loc2_ += "5";
                  break;
               case "5":
                  _loc2_ += "4";
                  break;
               case "6":
                  _loc2_ += "3";
                  break;
               case "7":
                  _loc2_ += "2";
                  break;
               case "8":
                  _loc2_ += "1";
                  break;
               case "9":
                  _loc2_ += "0";
                  break;
            }
            _loc3_++;
         }
         return _loc2_;
      }
   }
}
