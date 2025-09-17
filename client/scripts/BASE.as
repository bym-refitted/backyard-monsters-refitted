package
{
   import com.cc.utils.SecNum;
   import com.jac.mouse.MouseWheelEnabler;
   import com.monsters.ai.TRIBES;
   import com.monsters.ai.WMBASE;
   import com.monsters.alliances.ALLIANCES;
   import com.monsters.autobanking.AutoBankManager;
   import com.monsters.baseBuffs.BaseBuffHandler;
   import com.monsters.baseBuffs.buffs.ResourceCapacityBaseBuff;
   import com.monsters.baseplanner.BaseTemplate;
   import com.monsters.baseplanner.BaseTemplateNode;
   import com.monsters.baseplanner.PlannerTemplate;
   import com.monsters.chat.Chat;
   import com.monsters.configs.BYMConfig;
   import com.monsters.debug.Console;
   import com.monsters.display.BuildingOverlay;
   import com.monsters.effects.ResourceBombs;
   import com.monsters.effects.fire.Fire;
   import com.monsters.effects.particles.ParticleText;
   import com.monsters.effects.smoke.Smoke;
   import com.monsters.enums.EnumYardType;
   import com.monsters.frontPage.FrontPageHandler;
   import com.monsters.interfaces.ICoreBuilding;
   import com.monsters.interfaces.IHandler;
   import com.monsters.inventory.InventoryManager;
   import com.monsters.managers.InstanceManager;
   import com.monsters.maproom3.MapRoom3;
   import com.monsters.maproom3.MapRoom3Tutorial;
   import com.monsters.maproom3.popups.MapRoom3OutpostSecured;
   import com.monsters.maproom_advanced.CellData;
   import com.monsters.maproom_advanced.MapRoom;
   import com.monsters.maproom_advanced.MapRoomCell;
   import com.monsters.maproom_advanced.PopupLostMainBase;
   import com.monsters.maproom_manager.MapRoomManager;
   import com.monsters.monsters.champions.ChampionBase;
   import com.monsters.pathing.PATHING;
   import com.monsters.player.Player;
   import com.monsters.radio.RADIO;
   import com.monsters.rendering.RasterData;
   import com.monsters.replayableEvents.ReplayableEventHandler;
   import com.monsters.replayableEvents.attacking.monsterMadness.MonsterMadness;
   import com.monsters.rewarding.RewardHandler;
   import com.monsters.siege.*;
   import com.monsters.siege.weapons.*;
   import flash.display.*;
   import flash.events.*;
   import flash.external.ExternalInterface;
   import flash.geom.Point;
   import flash.net.*;
   import flash.system.System;
   import flash.text.TextField;
   import flash.utils.Dictionary;
   import flash.utils.getTimer;
   import gs.*;
   import gs.easing.*;

   public class BASE
   {
      public static var _baseID:Number;

      public static var _wmID:int;

      public static var _resources:Object;

      public static var _hpResources:Object;

      public static var _bankedValue:Number;

      public static var _bankedTime:int;

      public static var _shakeCountdown:int;

      public static var _blockSave:Boolean;

      public static var _attackerArray:Array;

      public static var _attackerNameArray:Array;
      
      public static var _currentAttacks:Array;
      
      public static var _attacksModified:Boolean;

      public static var _deltaResources:Object;

      public static var _hpDeltaResources:Object;

      public static var _savedDeltaResources:Object;

      public static var _GIP:Object;

      public static var _processedGIP:Object;

      public static var _rawGIP:Object;

      public static var _lastProcessedGIP:int;

      public static var _credits:SecNum;

      public static var _hpCredits:int;

      public static var _saveCounterA:int;

      public static var _saveCounterB:int;

      public static var _saving:Boolean;

      public static var _paging:Boolean;

      public static var _lastSaveID:int;

      public static var _attackID:int;

      public static var _lastSaved:int;

      public static var _lastSaveRequest:int;

      public static var _saveOver:int;

      public static var _returnHome:Boolean;

      public static var _saveProtect:int;

      public static var _saveErrors:int;

      public static var _pageErrors:int;

      public static var _loadTime:int;

      public static var _loading:Boolean;

      public static var _infernoSaveLoad:Boolean;

      public static var _lastProcessed:int;

      public static var _lastProcessedB:int;

      public static var _catchupTime:int;

      public static var _currentTime:int;

      public static var _baseData:Array;

      public static var _upgradeData:Object;

      public static var _buildingCount:int;

      public static var _buildingHealthData:Object;

      public static var _buildingData:Object;

      public static var _buildingsAll:Object;

      public static var _buildingsWalls:Object;

      public static var _buildingsTowers:Object;

      public static var _buildingsBunkers:Object;

      public static var _buildingsHousing:Array;

      public static var _buildingsMain:Object;

      public static var _buildingsMushrooms:Object;

      public static var _buildingsGifts:Object;

      public static var _buildingsStored:Object;

      public static var buildings:Vector.<BFOUNDATION>;

      public static var _rawMonsters:Object;

      public static var _mushroomList:Array;

      public static var _lastSpawnedMushroom:int;

      public static var _baseName:String;

      public static var _baseSeed:int;

      public static var _loadedBaseID:Number;

      public static var _loadedFriendlyBaseID:Number;

      public static var _loadedFBID:Number;

      public static var _baseLevel:int;

      public static var _baseValue:Number;

      public static var _basePoints:Number;

      public static var _outpostValue:Number;

      public static var _processing:Boolean;

      public static var _timer:int;

      public static var _size:int;

      public static var _angle:Number;

      public static var _buildingCounts:Object;

      public static var _buildingStatsToggle:Boolean;

      public static var _lastPaged:int;

      public static var _tempLoot:Object;

      public static var _tempGifts:Array;

      public static var _tempSentGifts:Array;

      public static var _tempSentInvites:Array;

      public static var _isProtected:int;

      public static var _isReinforcements:int;

      public static var _isSanctuary:int;

      public static var _isFan:int;

      public static var _isBookmarked:int;

      public static var _installsGenerated:int;

      public static var _ownerName:String;

      public static var _ownerPic:String;

      public static var _pendingPurchase:Array;

      public static var _pendingPromo:int;

      public static var _pendingFBPromo:int;

      public static var _pendingFBPromoIDs:Array;

      public static var _salePromoTime:int;

      public static var _loadBase:Array;

      public static var _percentDamaged:int;

      public static var _userID:int;

      public static var _allianceID:int;

      public static var _damagedBaseWarnTime:Number;

      public static var _takeoverFirstOpen:int;

      public static var _takeoverPreviousOwnersName:String;

      private static var s_processing:Boolean;

      private static var _tmpPercent:Number;

      private static var _oldSiegeData:Object;

      public static var loadObject:Object;

      public static var _ideltaResources:Object = null;

      public static var _iresources:Object = null;

      public static var _allianceArmamentTime:SecNum = new SecNum(0);

      private static var s_resourceCells:Object = {};

      public static var _loadedYardType:int = 0;

      private static var m_yardType:int = EnumYardType.MAIN_YARD;

      protected static var _firstBaseLoaded:Boolean = true;

      public static var _userDigits:Array = [];

      public static var _guardianData:Vector.<Object> = new Vector.<Object>();

      public static var s_eventBases:Vector.<Number> = new Vector.<Number>();

      public static var _showingWhatsNew:Boolean = false;

      public static var _needCurrentCell:Boolean = false;

      public static var _currentCellLoc:Point = null;

      private static const s_levels:Array = [0, 900, 3500, 5000, 7500, 10500, 14700, 20580, 28812, 40337, 56472, 79060, 110684, 154958, 216941, 303717, 425204, 595286, 833401, 1166761, 1633465, 2286851, 3201591, 4482228, 6275119, 8785167, 12299234, 17218927, 24106498, 33749097, 47248736, 66148230, 92607522, 129650530, 181510743, 254115040, 355761056, 498065478, 697291669, 976208337, 1366691671, 1913368339, 2678715675, 3750201945, 5250282723, 7350395812, 10290554137, 14406775792, 20169486109, 28237280553, 39532192774, 55345069884, 77483097838, 108476336973, 151866871762, 212613620467
            , 297659068653, 357190880000, 428629050000, 514354860000, 617225830000, 740670990000, 888805180000, 1066566210000, 1279879450000, 1535853400000, 1843026400000, 2211631680000, 2653958010000, 3184749610000, 3821699530000, 4586039430000, 5503247310000, 6603896770000, 7924676120000, 9509611340000, 11411533600000, 13693840320000, 16432608380000, 19719130050000, 23662956060000, 28395547270000, 34074656720000, 40889588060000, 49067505670000, 58881006800000, 70657208160000, 84788649790000, 101746379740000, 122095655680000, 146514786810000
            , 175817744170000, 210981293000000, 253177551600000, 303813061920000, 364575674300000, 437490809160000, 524988970990000, 629986765180000, 755984118210000];

      private static var _loadedSomething:Boolean = false;

      private static var _addtionalLoadArguments:Array = [];

      public function BASE()
      {
         super();
         _baseID = 0;
         Setup();
         Load();
      }

      public static function get yardType():int
      {
         return m_yardType;
      }

      public static function set yardType(param1:int):void
      {
         m_yardType = param1;
      }

      public static function get firstBaseLoaded():Boolean
      {
         return _firstBaseLoaded;
      }

      public static function get processing():Boolean
      {
         return s_processing;
      }

      public static function get resourceCells():Object
      {
         return s_resourceCells;
      }

      public static function Setup():void
      {
         _buildingsHousing = [];
         _buildingsBunkers = {};
         _pendingPurchase = [];
         _buildingCount = 0;
         _processing = false;
         _buildingStatsToggle = false;
         _angle = 0.8;
         _lastPaged = 0;
         _blockSave = false;
         _damagedBaseWarnTime = 0;
         _saveCounterA = 0;
         _saveCounterB = 0;
         _saveOver = 0;
         _returnHome = false;
         _saveProtect = 0;
         _saving = false;
         _paging = false;
         _saveErrors = 0;
         _currentAttacks = [];
         _attacksModified = false;
         _pageErrors = 0;
         _lastSaved = 0;
         _infernoSaveLoad = false;
         _isProtected = 0;
         _isReinforcements = 0;
         _isSanctuary = 0;
         _isFan = 0;
         _isBookmarked = 0;
         _installsGenerated = 0;
         _ideltaResources = {
               "dirty": false,
               "r1": new SecNum(0),
               "r2": new SecNum(0),
               "r3": new SecNum(0),
               "r4": new SecNum(0),
               "r1max": 0,
               "r2max": 0,
               "r3max": 0,
               "r4max": 0
            };
         _iresources = {
               "r1": new SecNum(0),
               "r2": new SecNum(0),
               "r3": new SecNum(0),
               "r4": new SecNum(0),
               "r1max": 0,
               "r2max": 0,
               "r3max": 0,
               "r4max": 0
            };
         _deltaResources = {
               "dirty": false,
               "r1": new SecNum(0),
               "r2": new SecNum(0),
               "r3": new SecNum(0),
               "r4": new SecNum(0)
            };
         _hpDeltaResources = {
               "dirty": false,
               "r1": Number(0),
               "r2": Number(0),
               "r3": Number(0),
               "r4": Number(0)
            };
         _savedDeltaResources = {
               "r1": new SecNum(0),
               "r2": new SecNum(0),
               "r3": new SecNum(0),
               "r4": new SecNum(0)
            };
         _loadBase = [];
         GLOBAL.Clear();
      }

      public static function Cleanup():void
      {
         SPECIALEVENT.ClearWildMonsterPowerups();
         SPECIALEVENT_WM1.ClearWildMonsterPowerups();
         BaseBuffHandler.instance.clearBuffs();
         RewardHandler.instance.clear();
         GLOBAL.player.clear();
         if (GLOBAL.attackingPlayer)
         {
            GLOBAL.attackingPlayer.clear();
         }
         CREATURES.Clear();
         CREEPS.Clear();
         GLOBAL._ROOT.removeChild(GLOBAL._layerMap);
         GLOBAL._ROOT.removeChild(GLOBAL._layerUI);
         GLOBAL._ROOT.removeChild(GLOBAL._layerWindows);
         GLOBAL._ROOT.removeChild(GLOBAL._layerMessages);
         GLOBAL._ROOT.removeChild(GLOBAL._layerTop);
         GLOBAL._layerMap = GLOBAL._ROOT.addChild(new Sprite()) as Sprite;
         GLOBAL._layerUI = GLOBAL._ROOT.addChild(new Sprite()) as Sprite;
         GLOBAL._layerWindows = GLOBAL._ROOT.addChild(new Sprite()) as Sprite;
         GLOBAL._layerMessages = GLOBAL._ROOT.addChild(new Sprite()) as Sprite;
         GLOBAL._layerTop = GLOBAL._ROOT.addChild(new Sprite()) as Sprite;
         GLOBAL._layerMap.mouseEnabled = false;
         GLOBAL._layerUI.mouseEnabled = false;
         GLOBAL._layerWindows.mouseEnabled = false;
         GLOBAL._layerMessages.mouseEnabled = false;
         GLOBAL._layerTop.mouseEnabled = false;
         var _loc1_:Vector.<Object> = InstanceManager.getInstancesByClass(BFOUNDATION);
         while (_loc1_.length)
         {
            (_loc1_[0] as BFOUNDATION).clear();
         }
         InstanceManager.clearAll();
         buildings = new Vector.<BFOUNDATION>();
         _buildingsAll = {};
         _buildingsWalls = {};
         _buildingsTowers = {};
         _buildingsMain = {};
         _buildingsMushrooms = {};
         _buildingsGifts = {};
         _buildingsStored = {};
         GLOBAL.setTownHall(null);
         GLOBAL._bAcademy = null;
         GLOBAL._bBaiter = null;
         GLOBAL._bFlinger = null;
         GLOBAL._bHatchery = null;
         GLOBAL._bHatcheryCC = null;
         GLOBAL._bHousing = null;
         GLOBAL._bJuicer = null;
         GLOBAL._bLocker = null;
         GLOBAL._bMap = null;
         GLOBAL._bStore = null;
         UI2.Hide("warning");
         UI2.Hide("scareAway");
         WMATTACK._inProgress = false;
         MONSTERBAITER._scaredAway = false;
         CUSTOMATTACKS._started = false;
         WMATTACK._queued = null;
         if (Boolean(WMATTACK._history) && Boolean(WMATTACK._history._queued))
         {
            delete WMATTACK._history.queued;
         }
         if (UI2._wildMonsterBar)
         {
            UI2.Hide("wmbar");
         }
         GRID.Cleanup();
         PATHING.Cleanup();
         RasterData.clear();
         _showingWhatsNew = false;
         _deltaResources = {
               "dirty": false,
               "r1": new SecNum(0),
               "r2": new SecNum(0),
               "r3": new SecNum(0),
               "r4": new SecNum(0)
            };
         _hpDeltaResources = {
               "dirty": false,
               "r1": 0,
               "r2": 0,
               "r3": 0,
               "r4": 0
            };
         _savedDeltaResources = {
               "r1": new SecNum(0),
               "r2": new SecNum(0),
               "r3": new SecNum(0),
               "r4": new SecNum(0)
            };
      }

      public static function LoadBase(url:String = null, userId:Number = 0, baseId:Number = 0, baseMode:String = "build", isError:Boolean = false, baseType:int = -1, cellId:Number = 0, keyValuePairs:Array = null):Boolean
      {
         if (isNaN(baseId))
         {
            baseId = 0;
         }
         if (isNaN(userId))
         {
            userId = 0;
         }
         if (MapRoomManager.instance.isInMapRoom2or3 && MapRoomManager.instance.isOpen)
         {
            MapRoomManager.instance.Hide();
         }
         if (MAPROOM_INFERNO._open)
         {
            MAPROOM_INFERNO.Hide();
         }
         if (MAPROOM._open)
         {
            MAPROOM.Hide();
         }
         if (!MapRoomManager.instance.isInMapRoom2or3 && (baseMode == GLOBAL.e_BASE_MODE.ATTACK || baseMode == GLOBAL.e_BASE_MODE.IATTACK) && (GLOBAL.mode != GLOBAL.e_BASE_MODE.BUILD && GLOBAL.mode != GLOBAL.e_BASE_MODE.IBUILD))
         {
            return false;
         }
         if (!_loading)
         {
            GLOBAL._reloadonerror = isError;
            if (baseId == 0 && userId == 0)
            {
               if (baseMode != GLOBAL.e_BASE_MODE.IBUILD)
               {
                  baseMode = GLOBAL.e_BASE_MODE.BUILD;
               }
            }
            if ((baseMode == GLOBAL.e_BASE_MODE.ATTACK || baseMode == GLOBAL.e_BASE_MODE.WMATTACK) && (!MapRoomManager.instance.isInMapRoom2or3 && (!GLOBAL._bFlinger || !GLOBAL._bFlinger._canFunction) && !isInfernoMainYardOrOutpost))
            {
               LOGGER.Log("err", "Impossible fling");
               GLOBAL.ErrorMessage("BASE.LoadBase impossible fling");
               return false;
            }
            _loadBase = [url, userId, baseId, baseMode, baseType, cellId];
            if (!MapRoomManager.instance.isInMapRoom2or3 && (baseMode == GLOBAL.e_BASE_MODE.ATTACK || baseMode == GLOBAL.e_BASE_MODE.WMATTACK || baseMode == GLOBAL.e_BASE_MODE.IATTACK || baseMode == GLOBAL.e_BASE_MODE.IWMATTACK))
            {
               PLEASEWAIT.Show(KEYS.Get("msg_preparing"));
               Save(0, false, true);
            }
            else if (!_saving)
            {
               if (keyValuePairs)
               {
                  _addtionalLoadArguments.push(keyValuePairs);
               }
               LoadBaseB();
               _addtionalLoadArguments = [];
            }
         }
         return true;
      }

      public static function LoadBaseB():void
      {
         print("|BASE| - LoadBaseB() _loadBase:" + JSON.encode(_loadBase));
         GLOBAL._baseURL2 = _loadBase[0];
         var userId:Number = Number(_loadBase[1]);
         var baseId:Number = Number(_loadBase[2]);
         var baseMode:String = String(_loadBase[3]);
         var baseType:int = int(_loadBase[4]);
         var cellId:int = int(_loadBase[5]);
         _loadBase = [];
         GLOBAL.Setup(baseMode);
         Load(GLOBAL._baseURL2, userId, baseId, baseType, cellId);
      }

      public static function Load(url:String = null, userId:Number = 0, baseId:Number = 0, baseType:int = -1, cellId:Number = 0):void
      {
         var _loc15_:int = 0;
         GLOBAL._baseLoads += 1;
         var _loc6_:int = getTimer();
         _loading = true;
         _baseID = baseId;
         _baseLevel = 0;
         _saveOver = 0;
         _returnHome = false;
         _saveProtect = 0;
         PLEASEWAIT.Hide();
         Cleanup();
         if (MapRoomManager.instance.isInMapRoom3 && baseType != -1)
         {
            m_yardType = baseType;
         }
         else if (baseType >= EnumYardType.MAIN_YARD)
         {
            m_yardType = baseType;
         }
         if (isMainYardOrInfernoMainYard)
         {
            if (GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD || GLOBAL.mode == GLOBAL.e_BASE_MODE.IBUILD)
            {
               GLOBAL.attackingPlayer = GLOBAL.player;
            }
         }
         GLOBAL.attackingPlayer.isAttacking = GLOBAL.attackingPlayer != GLOBAL.player;
         PLEASEWAIT.Show(KEYS.Get("msg_loading"));
         GRID.CreateGrid();
         POPUPS.Setup();
         CREEPS.Clear();
         GLOBAL.Clear();
         MAP.Clear();
         UI2.Clear();
         ResourceBombs.Clear();
         CREATURES.Clear();
         PROJECTILES.Clear();
         ATTACK.Setup();
         ResourcePackages.Clear();
         GIBLETS.Clear();
         CREATURELOCKER.Setup();
         CUSTOMATTACKS.Setup();
         UPDATES.Setup();
         BuildingOverlay.Clear();
         ParticleText.Clear();
         SPRITES.Clear();
         SPRITES.Setup();
         Fire.Clear();
         ResourceBombs.Data();
         ALLIANCES.Setup();
         GLOBAL._catchup = true;
         _mushroomList = [];
         _lastSpawnedMushroom = 0;
         _size = 400;
         var _loc7_:String = GLOBAL._loadmode;
         if (MapRoomManager.instance.isInMapRoom2or3)
         {
            if (_loc7_ == GLOBAL.e_BASE_MODE.WMATTACK)
            {
               _loc7_ = GLOBAL.e_BASE_MODE.ATTACK;
            }
            if (_loc7_ == GLOBAL.e_BASE_MODE.WMVIEW)
            {
               _loc7_ = GLOBAL.e_BASE_MODE.VIEW;
            }
         }
         if (MAPROOM_INFERNO._open)
         {
            MAPROOM_INFERNO.Hide();
         }
         if (MAPROOM._open)
         {
            MAPROOM.Hide();
         }
         var requestData:Array = [];
         requestData.push(["userid", userId > 0 ? userId : ""]);
         if (cellId)
         {
            requestData.push(["cellid", cellId]);
         }
         requestData.push(["baseid", _baseID]);
         requestData.push(["type", _loc7_]);
         if (MapRoomManager.instance.viewOnly && (GLOBAL.mode == GLOBAL.e_BASE_MODE.VIEW || GLOBAL.mode == GLOBAL.e_BASE_MODE.WMVIEW))
         {
            requestData.push(["worldid", MapRoomManager.instance.worldID]);
         }
         if (_loc7_ == GLOBAL.e_BASE_MODE.ATTACK || _loc7_ == GLOBAL.e_BASE_MODE.WMATTACK || _loc7_ == GLOBAL.e_BASE_MODE.IATTACK || _loc7_ == GLOBAL.e_BASE_MODE.IWMATTACK)
         {
            var attackData:String = JSON.encode(ATTACK.AttackData());
            requestData.push(["attackData", attackData]);
         }
         var _loc9_:int = 0;
         var _loc10_:int = int(LOGIN._digits[LOGIN._digits.length - 1]);
         var _loc11_:int = int(LOGIN._digits[LOGIN._digits.length - 2]);
         var _loc12_:int = int(LOGIN._digits[LOGIN._digits.length - 3]);
         var _loc13_:int = (_loc12_ + _loc10_) % 10;
         var _loc14_:int = (_loc11_ + _loc10_) % 10;
         if (_loc13_ <= 7)
         {
            _loc9_ = 0;
         }
         else if (_loc13_ == 8)
         {
            if (_loc14_ <= 4)
            {
               _loc9_ = 1;
            }
            else
            {
               _loc9_ = 2;
            }
         }
         else if (_loc13_ == 9)
         {
            if (_loc14_ <= 4)
            {
               _loc9_ = 3;
            }
            else
            {
               _loc9_ = 4;
            }
         }
         if (GLOBAL._checkPromo == 1 && _loc9_ != 0)
         {
            requestData.push(["checkpromotion", 1]);
         }
         if (_addtionalLoadArguments)
         {
            _loc15_ = 0;
            while (_loc15_ < _addtionalLoadArguments.length)
            {
               requestData.push(_addtionalLoadArguments[_loc15_]);
               _loc15_++;
            }
         }
         if (!_loadedSomething && ExternalInterface.available)
         {
            ExternalInterface.call("cc.recordStats", "basestart");
         }
         if (url)
         {
            new URLLoaderApi().load(url + "load", requestData, handleBaseLoadSuccessful, handleBaseLoadError);
         }
         else if (isInfernoMainYardOrOutpost || isEventBaseId(_baseID) && GLOBAL.mode == GLOBAL.e_BASE_MODE.WMATTACK)
         {
            new URLLoaderApi().load(GLOBAL._infBaseURL + "load", requestData, handleBaseLoadSuccessful, handleBaseLoadError);
         }
         else
         {
            new URLLoaderApi().load(GLOBAL._baseURL + "load", requestData, handleBaseLoadSuccessful, handleBaseLoadError);
         }
      }

      private static function continueFromBaseLoadError():void
      {
         GLOBAL.CallJS("cc.reloadParent");
      }

      private static function parseBaseLoadMessages(param1:Object):Boolean
      {
         if (param1.hasOwnProperty("ownershipchanged"))
         {
            GLOBAL.Message("mr3_baseoccupied_message", "btn_ok", handleBaseLoadError, null, null, null, null, 1, false);
            return true;
         }
         if (param1.hasOwnProperty("baseoccupied"))
         {
            GLOBAL.Message("mr3_baseoccupied_message", "btn_ok", handleBaseLoadError, null, null, null, null, 1, false);
            return true;
         }
         return false;
      }

      private static function handleBaseLoadSuccessful(data:Object):void
      {
         var TauntB:Function;
         var onImageLoad:Function;
         var LoadImageError:Function;
         var firstLoad:Boolean = false;
         var idstr:String = null;
         var ix:int = 0;
         var resources:Object = null;
         var building:Object = null;
         var researchdata:String = null;
         var iresources:Object = null;
         var kx:int = 0;
         var champion:Object = null;
         var size:int = 0;
         var existingGuardians:Dictionary = null;
         var playerGuardianIndex:int = 0;
         var guardianIndex:int = 0;
         var addedGuardian:Boolean = false;
         var unfrozenFound:Boolean = false;
         var j:int = 0;
         var championString:String = null;
         var attacksArr:Array = null;
         var attackCount:int = 0;
         var attackObj:Object = null;
         var found:Boolean = false;
         var listed:Object = null;
         var popupMC:popup_attackedme = null;
         var loader:Loader = null;
         var promoTimer:int = 0;
         var promoItemsArr:Array = null;
         var promoID:Array = null;
         var promoGifts:Array = null;
         var serverData:Object = data;
         try
         {
            if (serverData.error == 0)
            {
               if (parseBaseLoadMessages(serverData))
               {
                  return;
               }
               loadObject = serverData;
               if (serverData && serverData.player && Boolean(serverData.player.buffs))
               {
                  s_resourceCells = serverData.player.buffs.resources;
               }
               if (MapRoomManager.instance.isInMapRoom3)
               {
                  _baseID = loadObject.baseid;
               }
               firstLoad = false;
               if (!_loadedSomething)
               {
                  if (ExternalInterface.available)
                  {
                     ExternalInterface.call("cc.recordStats", "baseend");
                  }
                  firstLoad = true;
                  _loadedSomething = true;
                  GAME._firstLoadComplete = true;
               }
               else
               {
                  _firstBaseLoaded = false;
               }
               if (GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD || GLOBAL.mode == GLOBAL.e_BASE_MODE.IBUILD)
               {
                  GLOBAL._openBase = null;
               }
               MapRoomManager.instance.worldID = 0;
               GLOBAL.SetFlags(serverData.flags);
               QUESTS.Setup();
               GLOBAL._reloadonerror = false;
               if (TUTORIAL.hasFinished)
               {
                  _isProtected = int(serverData["protected"]);
               }
               _isFan = int(serverData.fan);
               _isFan = int(0);
               _isBookmarked = int(serverData.bookmarked);
               _isBookmarked = int(0);
               _installsGenerated = int(42069);
               if (serverData.fan)
               {
                  QUESTS._global.bonus_fan = 1;
               }
               if (serverData.bookmarked)
               {
                  QUESTS._global.bonus_bookmark = 1;
               }
               if (serverData.giftsentcount)
               {
                  QUESTS._global.bonus_gifts = serverData.giftsentcount;
               }
               QUESTS._global.bonus_invites = _installsGenerated;
               _lastProcessed = int(serverData.savetime);
               GLOBAL.t = _lastProcessed;
               _currentTime = int(serverData.currenttime);
               if (_lastProcessed < _currentTime - 60 * 60 * 24 * 30)
               {
                  // Limits the last known save time to 30 days ago at most, as this affects load times.
                  // Practically, no single time-based action in a base will take longer than this.
                  _lastProcessed = _currentTime - 60 * 60 * 24 * 30;
               }
               if (serverData.chatservers != null)
               {
                  Chat._chatServers = serverData.chatservers;
               }
               else
               {
                  Chat._chatServers = new Array();
               }
               _lastSaveID = serverData.id;
               _baseSeed = serverData.baseseed;
               _loadedBaseID = serverData.baseid;
               if (GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD)
               {
                  _loadedFriendlyBaseID = serverData.baseid;
                  _loadedYardType = m_yardType;
               }
               _loadedFBID = serverData.fbid;
               _userID = serverData.userid;
               idstr = _userID.toString();
               _userDigits = [];
               ix = 0;
               while (ix < idstr.length)
               {
                  _userDigits.push(int(idstr.charAt(ix)));
                  ix++;
               }
               if (GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD && isMainYard)
               {
                  if (serverData.alliancedata)
                  {
                     _allianceID = int(serverData.alliancedata.alliance_id);
                     if (_userID == LOGIN._playerID)
                     {
                        ALLIANCES._allianceID = int(serverData.alliancedata.alliance_id);
                        ALLIANCES._myAlliance = ALLIANCES.SetAlliance(serverData.alliancedata);
                        ACHIEVEMENTS.Check("alliance", 1);
                     }
                  }
                  else if (_userID == LOGIN._playerID && (ALLIANCES._allianceID || ALLIANCES._myAlliance))
                  {
                     ALLIANCES.Clear();
                  }
               }
               if (serverData.powerups)
               {
                  POWERUPS.Setup(serverData.powerups, null, true);
               }
               if (serverData.attpowerups)
               {
                  POWERUPS.Setup(null, serverData.attpowerups, true);
               }
               _attackID = int(serverData.attackid);
               if (serverData.worldsize)
               {
                  MapRoomManager.instance.mapWidth = serverData.worldsize[0];
                  MapRoomManager.instance.mapHeight = serverData.worldsize[1];
               }
               if (serverData.usemap)
               {
                  if (isInfernoMainYardOrOutpost)
                  {
                     MapRoomManager.instance.mapRoomVersion = MapRoomManager.instance.currentMapRoom is MapRoom3 ? MapRoomManager.MAP_ROOM_VERSION_3 : MapRoomManager.MAP_ROOM_VERSION_1;
                  }
                  else
                  {
                     MapRoomManager.instance.mapRoomVersion = MapRoomManager.instance.currentMapRoom is MapRoom3 ? MapRoomManager.MAP_ROOM_VERSION_3 : MapRoomManager.MAP_ROOM_VERSION_2;
                  }
               }
               if (MapRoomManager.instance.isInMapRoom2)
               {
                  if (GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD)
                  {
                     if (serverData.homebaseid)
                     {
                        GLOBAL._homeBaseID = serverData.homebaseid;
                     }
                     if (serverData.homebase)
                     {
                        if (serverData.homebase.length == 2 && serverData.homebase[0] > -1 && serverData.homebase[1] > -1)
                        {
                           if (serverData.outposts)
                           {
                              GLOBAL._mapOutpost = [];
                              GLOBAL._mapOutpostIDs = [];
                              ix = 0;
                              while (ix < serverData.outposts.length)
                              {
                                 if (serverData.outposts[ix].length == 3)
                                 {
                                    GLOBAL._mapOutpost.push(new Point(serverData.outposts[ix][0], serverData.outposts[ix][1]));
                                    GLOBAL._mapOutpostIDs.push(serverData.outposts[ix][2]);
                                 }
                                 ix++;
                              }
                           }
                           GLOBAL._mapHome = new Point(serverData.homebase[0], serverData.homebase[1]);
                        }
                        else
                        {
                           LOGGER.Log("err", "BASE.Process Invalid home base coordinate. " + serverData.homebase);
                        }
                     }
                     if (serverData.empiredestroyed)
                     {
                        GLOBAL._empireDestroyed = serverData.empiredestroyed;
                     }
                     else
                     {
                        GLOBAL._empireDestroyed = 0;
                     }
                  }
               }
               else if (MapRoomManager.instance.isInMapRoom3 && Boolean(serverData.homebase))
               {
                  GLOBAL._mapHome = new Point(serverData.homebase[0], serverData.homebase[1]);
               }
               GLOBAL._unreadMessages = serverData.unreadmessages;
               resources = serverData.resources;
               if (resources == null)
               {
                  _resources.r1 = 1000;
                  _resources.r2 = 1000;
                  _resources.r3 = 1000;
                  _resources.r4 = 1000;
                  _resources.r1max = 10000;
                  _resources.r2max = 10000;
                  _resources.r3max = 10000;
                  _resources.r4max = 10000;
               }
               else
               {
                  _resources = _resources || {};
                  _resources.r1 = new SecNum(Math.floor(resources.r1));
                  _resources.r2 = new SecNum(Math.floor(resources.r2));
                  _resources.r3 = new SecNum(Math.floor(resources.r3));
                  _resources.r4 = new SecNum(Math.floor(resources.r4));
                  _resources.r1bonus = resources.r1bonus;
                  _resources.r2bonus = resources.r2bonus;
                  _resources.r3bonus = resources.r3bonus;
                  _resources.r4bonus = resources.r4bonus;
               }
               if (serverData.iresources)
               {
                  iresources = serverData.iresources;
                  _iresources.r1 = new SecNum(Math.floor(iresources.r1));
                  _iresources.r2 = new SecNum(Math.floor(iresources.r2));
                  _iresources.r3 = new SecNum(Math.floor(iresources.r3));
                  _iresources.r4 = new SecNum(Math.floor(iresources.r4));
                  _iresources.r1max = int(iresources.r1max);
                  _iresources.r2max = int(iresources.r2max);
                  _iresources.r3max = int(iresources.r3max);
                  _iresources.r4max = int(iresources.r4max);
               }
               if (Boolean(serverData.updates) && serverData.updates.length > 0)
               {
                  UPDATES.Process(serverData.updates);
               }
               else if (serverData.lastupdate)
               {
                  UPDATES._lastUpdateID = Number(serverData.lastupdate);
               }
               else
               {
                  UPDATES._lastUpdateID = 0;
               }
               if (serverData.mushrooms.l)
               {
                  _mushroomList = serverData.mushrooms.l;
               }
               if (serverData.mushrooms.s)
               {
                  _lastSpawnedMushroom = int(serverData.mushrooms.s);
               }
               _buildingHealthData = serverData.buildinghealthdata;
               _buildingData = serverData.buildingdata;
               if (!MapRoomManager.instance.isInMapRoom3)
               {
                  for each (building in _buildingData)
                  {
                     if (building.t == 14)
                     {
                        if (isOutpost && (GLOBAL._currentCell && GLOBAL._currentCell.baseType == EnumYardType.INFERNO_OUTPOST))
                        {
                           LOGGER.Log("err", "Base ID " + _loadedBaseID + " outpost w TH bdg");
                           GLOBAL.ErrorMessage("BASE.Process outpost w TH");
                        }
                        break;
                     }
                     if (building.t == 112)
                     {
                        if (isMainYardOrInfernoMainYard && (GLOBAL._currentCell && GLOBAL._currentCell.baseType != EnumYardType.INFERNO_OUTPOST))
                        {
                           LOGGER.Log("err", "Base ID " + _loadedBaseID + " yard w OP bdg");
                           GLOBAL.ErrorMessage("BASE.Process yard w outpost");
                        }
                        break;
                     }
                  }
               }
               _rawGIP = serverData.buildingresources;
               _processedGIP = {};
               _GIP = {
                     "r1": new SecNum(0),
                     "r2": new SecNum(0),
                     "r3": new SecNum(0),
                     "r4": new SecNum(0)
                  };
               _lastProcessedGIP = AutoBankManager.updateLoadData(_rawGIP, _GIP, _processedGIP, _lastProcessed, _lastProcessedGIP);
               _baseName = serverData.basename;
               _baseValue = Number(serverData.basevalue);
               _basePoints = Number(serverData.points);
               if (!_outpostValue)
               {
                  _outpostValue = 0;
               }
               if (!_basePoints)
               {
                  _basePoints = 0;
               }
               _credits = new SecNum(int(serverData.credits));
               GLOBAL._credits = new SecNum(int(serverData.credits));
               _hpCredits = int(serverData.credits);
               _tempLoot = serverData.loot;
               GLOBAL.SetBuildingProps();
               _buildingsStored = {};
               for (researchdata in serverData.researchdata)
               {
                  if (serverData.researchdata[researchdata])
                  {
                     _buildingsStored[researchdata] = new SecNum(serverData.researchdata[researchdata]);
                  }
               }
               _hpResources = {
                     "r1": _resources.r1.Get(),
                     "r2": _resources.r2.Get(),
                     "r3": _resources.r3.Get(),
                     "r4": _resources.r4.Get()
                  };
               if (GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD)
               {
                  kx = 1;
                  while (kx < 5)
                  {
                     GLOBAL._resources["r" + kx] = new SecNum(_resources["r" + kx].Get());
                     GLOBAL._hpResources["r" + kx] = _resources["r" + kx].Get();
                     kx++;
                  }
               }
               if (serverData.stats.mp)
               {
                  QUESTS._global.mushroomspicked = serverData.stats.mp;
               }
               if (serverData.stats.mg)
               {
                  QUESTS._global.goldmushroomspicked = serverData.stats.mg;
               }
               if (serverData.stats.mob)
               {
                  QUESTS._global.monstersblended = serverData.stats.mob;
               }
               if (serverData.stats.mobg)
               {
                  QUESTS._global.monstersblendedgoo = serverData.stats.mobg;
               }
               if (serverData.stats.moga)
               {
                  QUESTS._global.gift_accept = serverData.stats.moga;
               }
               NewPopupSystem.instance.Setup(serverData.stats.popupdata);
               if (serverData.stats.updateid)
               {
                  GLOBAL._whatsnewid = serverData.stats.updateid;
               }
               if (serverData.stats.updateid_mr2 != null)
               {
                  GLOBAL._mr2TutorialId = Math.max(GLOBAL._mr2TutorialId, serverData.stats.updateid_mr2);
               }
               else
               {
                  GLOBAL._mr2TutorialId = Math.max(GLOBAL._mr2TutorialId, MapRoomManager.instance.isInMapRoom2 ? 1 : 0);
               }
               MapRoom3Tutorial.instance.importData(serverData);
               GLOBAL._otherStats = {"s": 1};
               if (serverData.stats.other)
               {
                  GLOBAL._otherStats = serverData.stats.other;
               }
               if (GLOBAL.StatGet(BUILDING11.CHANGED_TO_MR2) == 1)
               {
                  LOGGER.StatB({
                           "st1": "world_map",
                           "st2": "enter"
                        }, MapRoomManager.instance.worldID);
                  GLOBAL.StatSet(BUILDING11.CHANGED_TO_MR2, 2);
               }
               if (serverData.wmid)
               {
                  _wmID = serverData.wmid;
               }
               if (GLOBAL._otherStats && GLOBAL._otherStats.descentLvl && GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD)
               {
                  if (Boolean(WMBASE._descentBases) && WMBASE._descentBases.length > 0)
                  {
                     if (MAPROOM_DESCENT.DescentLevel > 1)
                     {
                        MAPROOM_DESCENT._descentLvl = MAPROOM_DESCENT.DescentLevel;
                        GLOBAL.StatSet("descentLvl", MAPROOM_DESCENT._descentLvl);
                     }
                  }
                  else if (MAPROOM_DESCENT._descentLvl < serverData.stats.other.descentLvl)
                  {
                     MAPROOM_DESCENT._descentLvl = serverData.stats.other.descentLvl;
                  }
               }
               GLOBAL.player.importAcademyData(serverData.academy);
               if (GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD && isMainYardOrInfernoMainYard)
               {
                  SiegeWeapons.importWeapons(serverData.siege);
               }
               else
               {
                  _oldSiegeData = serverData.siege;
               }
               EFFECTS.Setup(serverData.effects);
               if (Boolean(serverData.monsters) && Boolean(serverData.monsters.housed))
               {
                  GLOBAL.player.fillMonsterData(serverData.monsters.housed);
               }
               else if (serverData.monsters)
               {
                  GLOBAL.player.fillMonsterData(serverData.monsters);
               }
               _rawMonsters = serverData.monsters;
               TRIBES.Setup();
               if (serverData.wmstatus)
               {
                  WMBASE.Data(serverData.wmstatus);
               }
               else
               {
                  WMBASE.Clear();
               }
               WMATTACK.Setup(serverData.aiattacks);
               if (GLOBAL.mode == GLOBAL.e_BASE_MODE.WMATTACK || GLOBAL.mode == GLOBAL.e_BASE_MODE.WMVIEW || GLOBAL.mode == GLOBAL.e_BASE_MODE.IWMATTACK)
               {
                  WMBASE.Setup();
               }
               TUTORIAL.Setup();
               if (GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD)
               {
                  if (BASE.isInfernoMainYardOrOutpost)
                  {
                     TUTORIAL._stage = TUTORIAL._endstage;
                  }
                  else
                  {
                     TUTORIAL._stage = int(serverData.tutorialstage);
                  }
                  TUTORIAL.Tick();
               }
               WORKERS.Setup();
               QUEUE.Setup();
               STORE.Data(serverData.storeitems, serverData.storedata, serverData.inventory);
               CREATURELOCKER.Data(serverData.lockerdata);
               QUESTS.Data(serverData.quests);
               MONSTERBAITER.Setup(serverData.monsterbaiter);
               if (serverData.chatenabled != null)
               {
                  Chat._chatEnabled = serverData.chatenabled;
                  if (Chat.flagsShouldChatExist())
                  {
                     Chat.initChat();
                  }
               }
               if (serverData.stats.achievements)
               {
                  ACHIEVEMENTS.Data(serverData.stats.achievements);
                  ACHIEVEMENTS.CheckRetroactiveAchievments();
               }
               else if (serverData.quests)
               {
                  if (GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD)
                  {
                     ACHIEVEMENTS._stats.upgrade_champ1 = QUESTS._global.upgrade_champ1;
                     ACHIEVEMENTS._stats.upgrade_champ2 = QUESTS._global.upgrade_champ2;
                     ACHIEVEMENTS._stats.upgrade_champ3 = QUESTS._global.upgrade_champ3;
                     ACHIEVEMENTS._stats.monstersblended = QUESTS._global.monstersblended;
                     ACHIEVEMENTS._stats.wm2hall = QUESTS._global.destroy_tribe2;
                     if (serverData.alliancedata)
                     {
                        if (serverData.alliancedata.alliance_id)
                        {
                           ACHIEVEMENTS._stats.alliance = 1;
                        }
                     }
                     ACHIEVEMENTS.Check();
                  }
               }
               _guardianData.length = 0;
               if (serverData.champion)
               {
                  if (serverData.champion != "\"null\"" && serverData.champion != "null")
                  {
                     champion = JSON.decode(serverData.champion);
                     size = 0;
                     if (champion.t)
                     {
                        size = 1;
                        champion = [champion];
                     }
                     else
                     {
                        size = int(champion.length);
                     }
                     existingGuardians = new Dictionary();
                     playerGuardianIndex = 0;
                     guardianIndex = 0;
                     addedGuardian = false;
                     unfrozenFound = false;
                     j = 0;
                     while (j < size)
                     {
                        try
                        {
                           if (Boolean(champion[j].t) && !existingGuardians[champion[j].t])
                           {
                              existingGuardians[champion[j].t] = true;
                              _guardianData[guardianIndex] = {};
                              addedGuardian = true;
                              if (champion[j].nm)
                              {
                                 _guardianData[guardianIndex].nm = champion[j].nm;
                              }
                              _guardianData[guardianIndex].t = champion[j].t;
                              if (champion[j].ft)
                              {
                                 _guardianData[guardianIndex].ft = champion[j].ft;
                              }
                              if (champion[j].fd)
                              {
                                 _guardianData[guardianIndex].fd = champion[j].fd;
                              }
                              else
                              {
                                 _guardianData[guardianIndex].fd = 0;
                              }
                              if (champion[j].l)
                              {
                                 _guardianData[guardianIndex].l = new SecNum(champion[j].l);
                              }
                              else
                              {
                                 _guardianData[guardianIndex].l = new SecNum(0);
                              }
                              if (champion[j].hp)
                              {
                                 _guardianData[guardianIndex].hp = new SecNum(champion[j].hp);
                              }
                              else
                              {
                                 _guardianData[guardianIndex].hp = new SecNum(0);
                              }
                              if (champion[j].fb)
                              {
                                 _guardianData[guardianIndex].fb = new SecNum(champion[j].fb);
                              }
                              else
                              {
                                 _guardianData[guardianIndex].fb = new SecNum(0);
                              }
                              if (champion[j].pl)
                              {
                                 _guardianData[guardianIndex].pl = new SecNum(champion[j].pl);
                              }
                              else
                              {
                                 _guardianData[guardianIndex].pl = new SecNum(0);
                              }
                              if (champion[j].status is int)
                              {
                                 _guardianData[guardianIndex].status = champion[j].status;
                              }
                              else
                              {
                                 _guardianData[guardianIndex].status = ChampionBase.k_CHAMPION_STATUS_NORMAL;
                              }
                              if (champion[j].log)
                              {
                                 _guardianData[guardianIndex].log = champion[j].log;
                              }
                              else
                              {
                                 _guardianData[guardianIndex].log = String(_guardianData[guardianIndex].status).toString();
                              }
                              if (_guardianData[guardianIndex].t != 5)
                              {
                                 if (unfrozenFound && _guardianData[guardianIndex].status == ChampionBase.k_CHAMPION_STATUS_NORMAL)
                                 {
                                    _guardianData[guardianIndex].status = ChampionBase.k_CHAMPION_STATUS_FROZEN;
                                    _guardianData[guardianIndex].log += "," + ChampionBase.k_CHAMPION_STATUS_FROZEN.toString();
                                 }
                                 else if (!unfrozenFound && _guardianData[guardianIndex].status == ChampionBase.k_CHAMPION_STATUS_NORMAL)
                                 {
                                    unfrozenFound = true;
                                 }
                              }
                           }
                        }
                        catch (e:Error)
                        {
                           championString = JSON.decode(serverData.champion) as String;
                           _guardianData[j] = JSON.decode(championString);
                           Console.warning("Base::handleBaseLoadSuccessful - Error thrown on champion, champion data is - " + championString, true);
                           continue;
                        }
                        if (GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD && isMainYard && Boolean(_guardianData[j]))
                        {
                           GLOBAL._playerGuardianData[j] = _guardianData[j];
                        }
                        if (addedGuardian)
                        {
                           guardianIndex++;
                        }
                        addedGuardian = false;
                        j++;
                     }
                  }
               }
               _attackerArray = [];
               _attackerNameArray = [];
               if (GLOBAL.mode != GLOBAL.e_BASE_MODE.WMATTACK && GLOBAL.mode != GLOBAL.e_BASE_MODE.WMVIEW && Boolean(serverData.attacks))
               {
                  _currentAttacks = serverData.attacks;
                  TauntB = function(param1:int, param2:int):Function
                  {
                     var n:int = param1;
                     var fbid:int = param2;
                     return function(param1:MouseEvent):void
                     {
                        GLOBAL.CallJS("sendFeed", ["tauntB", KEYS.Get("js_attackedmyyard"), KEYS.Get("js_tauned"), "taunt" + n + ".png", fbid]);
                        POPUPS.Next();
                     };
                  };
                  attacksArr = serverData.attacks;
                  attackCount = 0;
                  for each (attackObj in attacksArr)
                  {
                     if (attackObj.seen) continue;
                     
                     attackCount++;
                     found = false;
                     for each (listed in _attackerArray)
                     {
                        if (listed.fbid == attackObj.fbid)
                        {
                           found = true;
                           ++listed.count;
                           listed.lastTime = attackObj.starttime;
                        }
                     }
                     if (!found)
                     {
                        _attackerNameArray.push([0, attackObj.name]);
                        _attackerArray.push({
                                 "fbid": attackObj.fbid,
                                 "name": attackObj.name,
                                 "pic": attackObj.pic_square,
                                 "friend": attackObj.friend,
                                 "count": 1,
                                 "lastTime": attackObj.starttime
                              });
                     }
                  }
                  for each (attackObj in _attackerArray)
                  {
                     popupMC = new popup_attackedme();
                     popupMC.gotoAndStop(1);
                     if (attackObj.count == 1)
                     {
                        popupMC.tA.htmlText = KEYS.Get("pop_attackedyou", {
                                 "v1": attackObj.name,
                                 "v2": GLOBAL.ToTime(_currentTime - int(attackObj.lastTime), true)
                              });
                     }
                     else
                     {
                        popupMC.tA.htmlText = KEYS.Get("pop_attackedyouxtimes", {
                                 "v1": attackObj.name,
                                 "v2": attackObj.count,
                                 "v3": GLOBAL.ToTime(_currentTime - int(attackObj.lastTime), true)
                              });
                     }
                     if (attackObj.pic)
                     {
                        onImageLoad = function(param1:Event):void
                        {
                           loader.height = 50;
                           loader.width = 50;
                        };
                        LoadImageError = function(param1:IOErrorEvent):void
                        {
                        };
                        loader = new Loader();
                        loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, LoadImageError, false, 0, true);
                        loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageLoad);
                        popupMC.mcPic.mcBG.addChild(loader);
                        loader.load(new URLRequest(attackObj.pic));
                     }
                     if (attackObj.friend == 1)
                     {
                        popupMC.bShare.SetupKey("btn_talktrash");
                        popupMC.bShare.Highlight = true;
                        popupMC.bShare.addEventListener(MouseEvent.CLICK, function TauntA(param1:MouseEvent):void
                           {
                              var _loc2_:MovieClip = param1.target.parent;
                              _loc2_.gotoAndStop(2);
                              var _loc3_:int = 1;
                              while (_loc3_ < 4)
                              {
                                 _loc2_["b" + _loc3_].gotoAndStop(_loc3_);
                                 _loc2_["b" + _loc3_].buttonMode = true;
                                 _loc2_["b" + _loc3_].addEventListener(MouseEvent.CLICK, TauntB(_loc3_, attackObj.fbid));
                                 _loc3_++;
                              }
                           });
                     }
                     else
                     {
                        popupMC.bShare.visible = false;
                     }
                     POPUPS.Push(popupMC);
                  }
               }
               _ownerName = GLOBAL.mode == GLOBAL.e_BASE_MODE.WMATTACK || GLOBAL.mode == GLOBAL.e_BASE_MODE.WMVIEW ? String(TRIBES.TribeForBaseID(_wmID).name) : String(serverData.name);
               _ownerPic = GLOBAL.mode == GLOBAL.e_BASE_MODE.WMATTACK || GLOBAL.mode == GLOBAL.e_BASE_MODE.WMVIEW ? String(TRIBES.TribeForBaseID(_wmID).profilepic) : String(serverData.pic_square);
               if (!GLOBAL._flags.viximo && !GLOBAL._flags.kongregate)
               {
                  if (serverData.promotiontimer)
                  {
                     if (serverData.promotiontimer is int)
                     {
                        promoTimer = int(serverData.promotiontimer);
                        GLOBAL._flags.hasPromo = 1;
                     }
                     else if (serverData.promotiontimer is String && serverData.promotiontimer == "purchasereceive")
                     {
                        if (serverData.purchasereceive)
                        {
                           promoItemsArr = serverData.purchasereceive;
                           BUY.purchaseProcess(promoItemsArr);
                           BUY.purchaseComplete(serverData.promotiontimer);
                           GLOBAL._flags.hasPromo = 1;
                        }
                     }
                  }
               }
               if (!GLOBAL._flags.viximo && !GLOBAL._flags.kongregate)
               {
                  if (serverData.fbpromos)
                  {
                     promoID = [];
                     promoGifts = [];
                     if (serverData.fbpromos)
                     {
                        if (serverData.fbpromos.ids)
                        {
                           promoID = serverData.fbpromos.ids;
                        }
                        if (promoGifts)
                        {
                           promoGifts = serverData.fbpromos.items;
                        }
                        if (Boolean(promoID) && Boolean(promoGifts))
                        {
                           _pendingFBPromo = 1;
                           GLOBAL._flags.hasFBPromo = 1;
                           if (promoGifts)
                           {
                              BUY.purchaseProcess(promoGifts);
                              BUY.purchaseComplete("biggulp");
                           }
                           if (promoID)
                           {
                              _pendingFBPromoIDs = promoID;
                           }
                        }
                        GLOBAL._flags.hasPromo = 1;
                     }
                  }
               }
               _tempGifts = serverData.gifts;
               if (serverData.sentgifts)
               {
                  _tempSentGifts = serverData.sentgifts;
               }
               if (serverData.sentinvites)
               {
                  _tempSentInvites = serverData.sentinvites;
               }
               else
               {
                  _tempSentInvites = [];
               }
               Build();
               WMBASE.CheckQuests();
            }
            else if (GLOBAL._reloadonerror)
            {
               GLOBAL.CallJS("reloadPage");
            }
            else if (GLOBAL._local && serverData.error == "Incorrect map version")
            {
               switch (GLOBAL._localMode)
               {
                  case 1:
                     if (GLOBAL._baseURL == "http://bym-fb-trunk.dev.kixeye.com/base/")
                     {
                        GLOBAL._baseURL = "http://bym-fb-trunk.dev.kixeye.com/api/bm/base/";
                        break;
                     }
                     GLOBAL._baseURL = "http://bym-fb-trunk.dev.kixeye.com/base/";
                     break;
                  case 2:
                     if (GLOBAL._baseURL == "http://bym-ko-halbvip1.dc.kixeye.com/base/")
                     {
                        GLOBAL._baseURL = "http://bym-ko-halbvip1.dc.kixeye.com/api/bm/base/";
                        break;
                     }
                     GLOBAL._baseURL = "http://bym-ko-halbvip1.dc.kixeye.com/base/";
                     break;
                  case 3:
                     if (GLOBAL._baseURL == "http://bmdev.vx.casualcollective.com/base/")
                     {
                        GLOBAL._baseURL = "http://bmdev.vx.casualcollective.com/api/bm/base/";
                        break;
                     }
                     GLOBAL._baseURL = "http://bmdev.vx.casualcollective.com/base/";
                     break;
                  case 4:
                     if (GLOBAL._baseURL == "http://bym-vx2-vip.sjc.kixeye.com/base/")
                     {
                        GLOBAL._baseURL = "http://bym-vx2-vip.sjc.kixeye.com/api/bm/base/";
                        break;
                     }
                     GLOBAL._baseURL = "http://bym-vx2-vip.sjc.kixeye.com/base/";
                     break;
                  case 5:
                     if (GLOBAL._baseURL == "http://bym-fb-inferno.dev.kixeye.com/base/")
                     {
                        GLOBAL._baseURL = "http://bym-fb-inferno.dev.kixeye.com/api/bm/base/";
                        break;
                     }
                     GLOBAL._baseURL = "http://bym-fb-inferno.dev.kixeye.com/base/";
                     break;
                  case 6:
                     if (GLOBAL._baseURL == "https://bym-fb-lbns.dc.kixeye.com/base/")
                     {
                        GLOBAL._baseURL = "https://bym-fb-lbns.dc.kixeye.com/api/bm/base/";
                        break;
                     }
                     GLOBAL._baseURL = "https://bym-fb-lbns.dc.kixeye.com/base/";
                     break;
                  case 7:
                     if (GLOBAL._baseURL == "http://bym-vx-web.stage.kixeye.com/base/")
                     {
                        GLOBAL._baseURL = "http://bym-vx-web.stage.kixeye.com/api/bm/base/";
                        break;
                     }
                     GLOBAL._baseURL = "http://bym-vx-web.stage.kixeye.com/base/";
                     break;
                  case 8:
                     if (GLOBAL._baseURL == "http://bym-fb-alex.dev.kixeye.com/base/")
                     {
                        GLOBAL._baseURL = "http://bym-fb-alex.dev.kixeye.com/api/bm/base/";
                        break;
                     }
                     GLOBAL._baseURL = "http://bym-fb-alex.dev.kixeye.com/base/";
                     break;
                  case 9:
                     if (GLOBAL._baseURL == "http://bym-fb-nmoore.dev.kixeye.com/base/")
                     {
                        GLOBAL._baseURL = "http://bym-fb-nmoore.dev.kixeye.com/api/bm/base/";
                        break;
                     }
                     GLOBAL._baseURL = "http://bym-fb-nmoore.dev.kixeye.com/base/";
                     break;
                  case 10:
                     if (GLOBAL._baseURL == "http://bm-kg-web2.dev.casualcollective.com/base/")
                     {
                        GLOBAL._baseURL = "http://bm-kg-web2.dev.casualcollective.com/api/bm/base/";
                        break;
                     }
                     GLOBAL._baseURL = "http://bm-kg-web2.dev.casualcollective.com/base/";
                     break;
                  case 11:
                     if (GLOBAL._baseURL == "http://bym-ko-web1.stage.com/base/")
                     {
                        GLOBAL._baseURL = "http://bym-ko-web1.stage.com/api/bm/base/";
                        break;
                     }
                     GLOBAL._baseURL = "http://bym-ko-web1.stage.kixeye.com/api/bm/base/";
                     break;
                  default:
                     if (GLOBAL._baseURL == "http://bym-fb-web1.stage.kixeye.com/base/")
                     {
                        GLOBAL._baseURL = "http://bym-fb-web1.stage.kixeye.com/api/bm/base/";
                     }
                     else
                     {
                        GLOBAL._baseURL = "http://bym-fb-web1.stage.kixeye.com/base/";
                     }
               }
               BASE.Load();
            }
            else
            {
               GLOBAL.ErrorMessage(serverData.error, GLOBAL.ERROR_ORANGE_BOX_ONLY);
               PLEASEWAIT.Hide();
            }
            LOGGER.StatB({
                     "st1": MapRoomManager.instance.mapRoomVersion + "_loadmode",
                     "st2": BASE.yardType
                  }, GLOBAL.mode);
            if (Boolean(LOGIN._playerID) && int(LOGIN._playerID % 100) == 0)
            {
               LOGGER.Stat([LOGGER.STAT_MEM, "loadbase", (System.totalMemory / 1024 / 1024).toString(), int(getTimer() * 0.001).toString()]);
            }
         }
         catch (error:Error)
         {
            GLOBAL.Message(KEYS.Get("err_loading_base"));
            LOGGER.Log("err", "Failed to load user base with error: " + error.getStackTrace());
         }
      }

      private static function handleBaseLoadError(param1:IOErrorEvent):void
      {
         if (GLOBAL._reloadonerror)
         {
            GLOBAL.CallJS("reloadPage");
         }
         else
         {
            LOGGER.Log("err", "BASE.Load HTTP");
            PLEASEWAIT.Hide();
            GLOBAL.ErrorMessage("BASE.Load HTTP");
         }
      }

      public static function Build():void
      {
         var buildingFoundation:BFOUNDATION = null;
         var counter:int = 0;
         var building:Object = null;
         var displayObject:DisplayObject = null;
         var rawMonstersHidLength:int = 0;
         var rawMonstersHLength:int = 0;
         var rawMonsterIndex:int = 0;
         var townHallLevel:int = 0;
         var buildingTypeCount:int = 0;
         var props:Object = null;
         var foundationIndex:int = 0;
         var propCount:int = 0;
         PLEASEWAIT.Update(KEYS.Get("msg_building"));
         if (MAPROOM_INFERNO._open)
         {
            MAPROOM_INFERNO.Hide();
         }
         if (MAPROOM._open)
         {
            MAPROOM.Hide();
         }
         var mapIndex:int = GLOBAL._layerMap.numChildren - 1;
         while (mapIndex >= 0)
         {
            displayObject = GLOBAL._layerMap.getChildAt(mapIndex);
            if (displayObject.parent)
            {
               displayObject.parent.removeChild(displayObject);
            }
            mapIndex--;
         }
         UI2.Setup();
         GLOBAL.ResizeGame(null);
         GLOBAL._render = false;
         PATHING.Setup();
         var timer:int = getTimer();
         var terrainType:String = "grass";
         if (!MapRoomManager.instance.isInMapRoom3 && GLOBAL._currentCell && (isOutpostOrInfernoOutpost || GLOBAL.mode == GLOBAL.e_BASE_MODE.WMATTACK || GLOBAL.mode == GLOBAL.e_BASE_MODE.WMVIEW))
         {
            terrainType = (GLOBAL._currentCell as MapRoomCell).terrain;
         }
         if (BASE.isInfernoMainYardOrOutpost)
         {
            terrainType = "lava";
         }
         var map:MAP = new MAP(terrainType);
         var targeting:Targeting = new Targeting();
         QUEUE.Spawn(0);
         Smoke.Setup();
         var currentBuilding:Object = {};
         var buildingCount:int = 0;
         var foundationType:int = 0;
         var isCoreBuilding:Boolean = false;
         if (MapRoom3Tutorial.instance.isStarted && (MapRoom3Tutorial.instance.tutorialStep === MapRoom3Tutorial.k_STEP_SCOUTWM || MapRoom3Tutorial.instance.tutorialStep === MapRoom3Tutorial.k_STEP_ATTACKWM))
         {
            _buildingData = null;
         }

         // Always ensure that the main yard has a town hall
         if (isMainYard && _buildingData.hasOwnProperty("0") && _buildingData["0"].t !== 14)
         {
            _buildingData["0"].t = 14;
         }

         // Always ensure that the outpost has an outpost building
         if (isOutpost && _buildingData.hasOwnProperty("0") && _buildingData["0"].t !== 112)
         {
            _buildingData["0"].t = 112;
         }

         var buildingTypeCounts:Dictionary = new Dictionary();
         for each (building in _buildingData)
         {
            if (building)
            {
               if (building.t)
               {
                  buildingTypeCounts[building.t] ||= 0;
                  ++buildingTypeCounts[building.t];
               }
               if (!(building.t == 53 || building.t == 54))
               {
                  currentBuilding = building;
                  if (building.t == 18)
                  {
                     building.t = 17;
                     building.l = 2;
                  }
                  if (building.t == 14)
                  {
                  }
                  if (building.t == 7)
                  {
                     counter++;
                  }
                  buildingFoundation = addBuildingC(building.t);
                  if (buildingFoundation)
                  {
                     foundationType = buildingFoundation._type;
                  }
                  if (building.t == 16 && _rawMonsters && Boolean(_rawMonsters.hcc))
                  {
                     building.mq = _rawMonsters.hcc;
                  }
                  if (building.t == 13 && _rawMonsters && Boolean(_rawMonsters.h) && Boolean(_rawMonsters.hid))
                  {
                     rawMonstersHidLength = int(_rawMonsters.hid.length);
                     rawMonstersHLength = int(_rawMonsters.h.length);
                     rawMonsterIndex = 0;
                     while (rawMonsterIndex < rawMonstersHidLength && rawMonsterIndex < rawMonstersHLength)
                     {
                        if (_rawMonsters.hid[rawMonsterIndex] == building.id)
                        {
                           if (_rawMonsters.h[rawMonsterIndex].length > 0)
                           {
                              building.rIP = _rawMonsters.h[rawMonsterIndex][0];
                              building.rCP = _rawMonsters.h[rawMonsterIndex][1];
                           }
                           else
                           {
                              building.rIP = "";
                              building.rCP = 0;
                           }
                           if (Boolean(_rawMonsters.hstage) && _rawMonsters.hstage.length > rawMonsterIndex)
                           {
                              building.rPS = _rawMonsters.hstage[rawMonsterIndex];
                           }
                           if (building.id == _rawMonsters.hid[rawMonsterIndex] && _rawMonsters.h[rawMonsterIndex].length > 2)
                           {
                              building.mq = _rawMonsters.h[rawMonsterIndex][2];
                           }
                           else
                           {
                              building.mq = [];
                           }
                           building.saved = _rawMonsters.saved;
                           break;
                        }
                        rawMonsterIndex++;
                     }
                  }
                  if (buildingFoundation)
                  {
                     if (Boolean(_buildingHealthData) && building.id in _buildingHealthData)
                     {
                        building.hp = _buildingHealthData[building.id];
                     }
                     else if (MapRoomManager.instance.isInMapRoom3 && !BASE.isInfernoMainYardOrOutpost)
                     {
                        delete building.hp;
                     }
                     buildingFoundation.Setup(building);
                     if (buildingFoundation._id > _buildingCount)
                     {
                        _buildingCount = buildingFoundation._id;
                     }
                     if (buildingFoundation is ICoreBuilding)
                     {
                        isCoreBuilding = true;
                     }
                     buildingCount++;
                  }
               }
            }
         }
         BFOUNDATION.redrawAllShadowData();
         _buildingHealthData = null;
         _buildingData = null;
         if (buildingCount == 0)
         {
            if (isOutpost && !MapRoom3Tutorial.instance.isStarted)
            {
               buildingFoundation = addBuildingC(112);
               buildingFoundation.Setup({
                        "X": 0,
                        "Y": -50,
                        "id": buildingCount++,
                        "t": 112,
                        "l": 1
                     });
            }
            else if (BASE.isInfernoMainYardOrOutpost)
            {
               buildingFoundation = addBuildingC(14);
               buildingFoundation.Setup({
                        "X": -100,
                        "Y": 0,
                        "id": buildingCount++,
                        "t": 14,
                        "l": 1
                     });
               buildingFoundation = addBuildingC(1);
               buildingFoundation.Setup({
                        "X": 60,
                        "Y": 0,
                        "id": buildingCount++,
                        "t": 1,
                        "l": 1
                     });
               buildingFoundation = addBuildingC(2);
               buildingFoundation.Setup({
                        "X": 60,
                        "Y": 70,
                        "id": buildingCount++,
                        "t": 2,
                        "l": 1
                     });
               buildingFoundation = addBuildingC(6);
               buildingFoundation.Setup({
                        "X": 130,
                        "Y": 0,
                        "id": buildingCount++,
                        "t": 6,
                        "l": 3
                     });
               buildingFoundation = addBuildingC(6);
               buildingFoundation.Setup({
                        "X": 130,
                        "Y": 80,
                        "id": buildingCount++,
                        "t": 6,
                        "l": 3
                     });
               _basePoints = 0;
            }
            else
            {
               buildingFoundation = addBuildingC(14);
               buildingFoundation.Setup({
                        "X": -70,
                        "Y": 0,
                        "id": buildingCount++,
                        "t": 14,
                        "l": 1
                     });
               buildingFoundation = addBuildingC(1);
               buildingFoundation.Setup({
                        "X": 60,
                        "Y": 0,
                        "id": buildingCount++,
                        "t": 1,
                        "l": 1
                     });
               buildingFoundation._stored.Set(200);
               buildingFoundation._hpStored = 200;
               buildingFoundation = addBuildingC(2);
               buildingFoundation.Setup({
                        "X": 60,
                        "Y": 70,
                        "id": buildingCount++,
                        "t": 2,
                        "l": 1
                     });
               buildingFoundation = addBuildingC(12);
               buildingFoundation.Setup({
                        "X": 60,
                        "Y": -70,
                        "id": buildingCount++,
                        "t": 12,
                        "l": 1
                     });
               _resources.r1.Set(1600);
               _resources.r2.Set(1600);
               _hpResources.r1 = 1600;
               _hpResources.r2 = 1600;
               _deltaResources.r1.Set(1600);
               _deltaResources.r2.Set(1600);
               _hpDeltaResources.r1 = 1600;
               _hpDeltaResources.r2 = 1600;
               _basePoints = 0;
               _deltaResources.dirty = true;
               _hpDeltaResources.dirty = true;
               SOUNDS.TutorialStopMusic();
            }
         }
         else if (isMainYard && !isCoreBuilding)
         {
            LOGGER.Log("err", "Town Hall Missing");
         }
         // Comment: RebuildTH() is commented out as it's a dangerous bad-practice implementation from
         // the original game, causing unintended behavior.
         // RebuildTH();
         var bFoundation:Vector.<Object> = InstanceManager.getInstancesByClass(BFOUNDATION);
         if (GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD && GLOBAL.townHall && isMainYardOrInfernoMainYard && !GLOBAL._aiDesignMode)
         {
            townHallLevel = GLOBAL.townHall._lvl.Get();
            buildingTypeCount = 0;
            for each (props in GLOBAL._buildingProps)
            {
               if (props.type != "decoration")
               {
                  buildingTypeCount = 0;
                  foundationIndex = int(bFoundation.length - 1);
                  while (foundationIndex >= 0)
                  {
                     buildingFoundation = bFoundation[foundationIndex] as BFOUNDATION;
                     if (buildingFoundation)
                     {
                        if (buildingFoundation._type == props.id)
                        {
                           buildingTypeCount += 1;
                        }
                        propCount = townHallLevel < props.quantity.length ? int(props.quantity[townHallLevel]) : int(props.quantity[props.quantity.length - 1]);
                        if (buildingTypeCount > propCount)
                        {
                           Console.print("BASE::Build:too many buildings " + buildingTypeCount + "/" + propCount + " type:" + buildingFoundation._type);
                           LOGGER.Log("log", "Too many buildings of type " + buildingFoundation._type + " th " + townHallLevel + " count " + buildingTypeCount);
                           BASE.BuildingDeselect();
                           buildingFoundation.clear();
                           buildingTypeCount--;
                        }
                     }
                     foundationIndex--;
                  }
               }
            }
         }
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         bFoundation = InstanceManager.getInstancesByClass(BFOUNDATION);
         for each (buildingFoundation in bFoundation)
         {
            if (GRID.FromISO(buildingFoundation.x, buildingFoundation.y).x > 1000)
            {
               GRID.FindSpace(buildingFoundation);
            }
            if (buildingFoundation is BTRAP === false && buildingFoundation is BWALL === false)
            {
               _loc15_ += buildingFoundation.health;
               _loc16_ += buildingFoundation.maxHealth;
            }
         }
         LOGGER.Stat([17, 1, int(_tempLoot.r1)]);
         if (_attackerNameArray.length > 0)
         {
            if (_loc15_ > _loc16_ * 0.8)
            {
               ATTACK.WellDefended(false, GLOBAL.Array2StringB(_attackerNameArray));
            }
         }
         GRID.Clear();
         MAP.SortDepth();
         HOUSING.HousingSpace();
         MONSTERBAITER.Update();
         if (GLOBAL.mode == GLOBAL.e_BASE_MODE.WMVIEW || GLOBAL.mode == GLOBAL.e_BASE_MODE.WMATTACK)
         {
            _lastProcessed = _currentTime;
         }
         Process();
         RADIO.Setup();
      }

      public static function Process():void
      {
         var hatqueue2:Array;
         var hatcount2:int;
         var hatcheryInstances:Vector.<Object>;
         var Post:Function;
         var building:BFOUNDATION = null;
         var hatchery:BUILDING13 = null;
         var lootArray:Array = null;
         var lootString:String = null;
         var popupMC:popup_loot = null;
         PLEASEWAIT.Update(KEYS.Get("msg_processing"));
         _tmpPercent = 0;
         HOUSING.Cull();
         CalcResources();
         if (_tempLoot)
         {
            lootArray = [];
            if (Boolean(_tempLoot.r1) && _tempLoot.r1 > 0)
            {
               BASE.PointsAdd(_tempLoot.r1);
               lootArray.push([_tempLoot.r1, GLOBAL._resourceNames[0]]);
            }
            if (Boolean(_tempLoot.r2) && _tempLoot.r2 > 0)
            {
               BASE.PointsAdd(_tempLoot.r2);
               lootArray.push([_tempLoot.r2, GLOBAL._resourceNames[1]]);
            }
            if (Boolean(_tempLoot.r3) && _tempLoot.r3 > 0)
            {
               BASE.PointsAdd(_tempLoot.r3);
               lootArray.push([_tempLoot.r3, GLOBAL._resourceNames[2]]);
            }
            if (Boolean(_tempLoot.r4) && _tempLoot.r4 > 0)
            {
               BASE.PointsAdd(_tempLoot.r4);
               lootArray.push([_tempLoot.r4, GLOBAL._resourceNames[3]]);
            }
            if (GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD && lootArray.length > 0 && (BASE.isInfernoMainYardOrOutpost || !_tempLoot.isInferno))
            {
               Post = function(param1:MouseEvent):void
               {
                  GLOBAL.CallJS("sendFeed", ["loot", KEYS.Get("pop_youlooted_streamtitle", {
                                 "v1": lootString,
                                 "v2": _tempLoot.name
                              }), KEYS.Get("pop_youlooted_streambody"), "loot.png"]);
                  POPUPS.Next();
               };
               lootString = GLOBAL.Array2String(lootArray);
               popupMC = new popup_loot();
               popupMC.tB.htmlText = "<b>" + KEYS.Get("pop_youlooted_title") + "</b>";
               popupMC.tA.htmlText = KEYS.Get("pop_youlooted", {
                        "v1": _tempLoot.name,
                        "v2": lootString
                     });
               popupMC.bAction.SetupKey("btn_brag");
               popupMC.bAction.addEventListener(MouseEvent.CLICK, Post);
               popupMC.bAction.Highlight = true;
               POPUPS.Push(popupMC, null, null, null, "loot.png");
               if (_tempLoot.r1)
               {
                  LOGGER.Stat([17, 1, int(_tempLoot.r1)]);
                  LOGGER.Stat([18, 1, Math.floor(100 / _resources.r1max * int(_tempLoot.r1))]);
               }
               if (_tempLoot.r2)
               {
                  LOGGER.Stat([17, 2, int(_tempLoot.r2)]);
                  LOGGER.Stat([18, 2, Math.floor(100 / _resources.r2max * int(_tempLoot.r2))]);
               }
               if (_tempLoot.r3)
               {
                  LOGGER.Stat([17, 3, int(_tempLoot.r3)]);
                  LOGGER.Stat([18, 3, Math.floor(100 / _resources.r3max * int(_tempLoot.r3))]);
               }
               if (_tempLoot.r4)
               {
                  LOGGER.Stat([17, 4, int(_tempLoot.r4)]);
                  LOGGER.Stat([18, 4, Math.floor(100 / _resources.r4max * int(_tempLoot.r4))]);
               }
            }
         }
         _baseLevel = BaseLevel().level;
         _bankedValue = 0;
         GLOBAL.t = _lastProcessed;
         _lastProcessedB = _lastProcessed;
         _catchupTime = _currentTime - _lastProcessed;
         if (!isInfernoMainYardOrOutpost && !MapRoomManager.instance.isInMapRoom3)
         {
            AutoBankManager.autobank(MapRoomManager.instance.isInMapRoom3 ? _currentTime : _currentTime - _lastProcessedGIP, true);
         }
         hatqueue2 = [];
         hatcount2 = 0;
         hatcheryInstances = InstanceManager.getInstancesByClass(BUILDING13);
         for each (hatchery in hatcheryInstances)
         {
            hatqueue2[hatcount2] = [hatchery._inProduction, hatchery._countdownProduce.Get()];
            if (hatchery._monsterQueue)
            {
               hatqueue2[hatcount2].push(hatchery._monsterQueue);
            }
            hatcount2++;
         }
         _timer = getTimer();
         HideFootprints();
         GLOBAL._ROOT.addEventListener(Event.ENTER_FRAME, ProcessB);
      }

      public static function ProcessB(param1:Event):void
      {
         var _loc2_:int = getTimer();
         while (getTimer() - _loc2_ < 10)
         {
            ProcessC(_currentTime + (getTimer() - _timer) / 1000);
         }
         if (_lastProcessed >= _currentTime)
         {
            _currentTime += (getTimer() - _timer) / 1000;
            GLOBAL._ROOT.removeEventListener(Event.ENTER_FRAME, ProcessB);
            GLOBAL.t = _currentTime;
            ProcessD();
         }
      }

      public static function ProcessC(param1:int):void
      {
         var allBuildings:Vector.<Object> = null;
         var tickDelta:int = 0;
         var building:BFOUNDATION = null;
         var storeProcessAmount:int = 0;
         var guardianIndex:int = 0;
         var allTowers:Vector.<Object> = null;
         var allTraps:Vector.<Object> = null;
         var allBunkers:Vector.<Object> = null;
         var tower:BFOUNDATION = null;
         var trap:BTRAP = null;
         var bunker:Bunker = null;
         var tickIteration:int = 0;
         var progress:Number = NaN;
         if (_lastProcessed < param1)
         {
            GLOBAL.t = _lastProcessed;
            tickDelta = param1 - _lastProcessed;
            if (CREEPS._creepCount > 0)
            {
               tickDelta = 1;
            }
            else
            {
               allBuildings ||= InstanceManager.getInstancesByClass(BFOUNDATION);
               for each (building in allBuildings)
               {
                  tickDelta = Math.min(tickDelta, building.tickLimit);
               }
               if (CREATURES._guardian)
               {
                  tickDelta = Math.min(tickDelta, CREATURES._guardian.tickLimit);
               }
               if (tickDelta < 1)
               {
                  tickDelta = 1;
               }
            }
            WMATTACK.Tick();
            if (WMATTACK._inProgress)
            {
               tickDelta = 1;
            }
            storeProcessAmount = int(_lastProcessed / 60) - int((_lastProcessed + tickDelta) / 60);
            while (storeProcessAmount >= 0)
            {
               STORE.ProcessPurchases();
               storeProcessAmount--;
            }
            allBuildings ||= InstanceManager.getInstancesByClass(BFOUNDATION);
            for each (building in allBuildings)
            {
               building.Tick(tickDelta);
            }
            HOUSING.catchupTick(tickDelta);
            guardianIndex = 0;
            while (guardianIndex < CREATURES._guardianList.length)
            {
               if (Boolean(CREATURES._guardianList[guardianIndex]) && CREATURES._guardianList[guardianIndex].tick(tickDelta))
               {
                  if (!BYMConfig.instance.RENDERER_ON)
                  {
                     MAP._BUILDINGTOPS.removeChild(CREATURES._guardianList[guardianIndex].graphic);
                  }
                  CREATURES._guardianList[guardianIndex].clearRasterData();
                  if (CREATURES._guardianList[guardianIndex] == CREATURES._guardian)
                  {
                     CREATURES._guardian = null;
                  }
                  else
                  {
                     CREATURES._guardianList.splice(guardianIndex, 1);
                  }
               }
               guardianIndex++;
            }
            if (isMainYard)
            {
               CREATURELOCKER.Tick();
               ACADEMY.Tick();
            }
            if (CREEPS._creepCount > 0)
            {
               GLOBAL._render = true;
               PATHING.Tick();
               allTowers = InstanceManager.getInstancesByClass(BTOWER);
               allTraps = InstanceManager.getInstancesByClass(BTRAP);
               allBunkers = InstanceManager.getInstancesByClass(Bunker);
               tickIteration = 0;
               while (tickIteration < 80)
               {
                  CREEPS.Tick();
                  CREATURES.Tick();
                  for each (tower in allTowers)
                  {
                     tower.TickAttack();
                  }
                  for each (trap in allTraps)
                  {
                     trap.TickAttack();
                  }
                  for each (bunker in allBunkers)
                  {
                     bunker.TickAttack();
                  }
                  PROJECTILES.Tick();
                  FIREBALLS.Tick();
                  EFFECTS.Tick();
                  tickIteration++;
               }
            }
            if (GLOBAL.mode == GLOBAL.e_BASE_MODE.WMATTACK || GLOBAL.mode == GLOBAL.e_BASE_MODE.WMVIEW)
            {
               WMBASE.Tick();
            }
            UPDATES.Check();
            _lastProcessed += tickDelta;
         }
         if (CREEPS._creepCount == 0)
         {
            progress = (_lastProcessed - _lastProcessedB) / (param1 - _lastProcessedB);
            PLEASEWAIT.Update(KEYS.Get("msg_rendering") + int(100 * progress) + "% ");
         }
         else
         {
            if (_tmpPercent < 100)
            {
               _tmpPercent += 0.5;
            }
            PLEASEWAIT.Update(KEYS.Get("msg_crunching") + int(_tmpPercent) + "%");
         }
      }

      public static function ProcessD():void
      {
         var damageCount:int;
         var bb:int;
         var upgradeCount:int;
         var helpedCount:int;
         var MoreInfo711:Function;
         var Action:Function;
         var BragA:Function;
         var BragB:Function;
         var building:BFOUNDATION = null;
         var buildingInstances:Vector.<Object> = null;
         var helper:int = 0;
         var needToHealCreeps:Boolean = false;
         var length:int = 0;
         var i:int = 0;
         var popupMCDamaged:popup_damaged = null;
         var RepairAll:Function = null;
         var RepairNow:Function = null;
         var numCreepsDamaged:int = 0;
         var popupMCCreepDamaged:popup_damaged = null;
         var StartHealAll:Function = null;
         var HealShinyNow:Function = null;
         var hasBigGulp:Boolean = false;
         var fbPromoTimer:Number = NaN;
         var fbPromoPopup:MovieClip = null;
         var promptSPost:Boolean = false;
         var b:BFOUNDATION = null;
         var popupMCdamaged:MovieClip = null;
         var hp:int = 0;
         var hpMax:int = 0;
         var popupMCDestroyed:PopupLostMainBase = null;
         var t:int = getTimer();
         s_processing = true;
         if (GLOBAL.mode == GLOBAL.e_BASE_MODE.ATTACK || GLOBAL.mode == GLOBAL.e_BASE_MODE.WMATTACK)
         {
            ATTACK.Setup();
         }
         if (GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD)
         {
            if (CREEPS._creepCount == 0)
            {
               buildingInstances = InstanceManager.getInstancesByClass(BFOUNDATION);
               for each (building in buildingInstances)
               {
                  building.GridCost(true);
               }
            }
         }
         EFFECTS.Process(_catchupTime);
         if (isMainYard)
         {
            CREATURELOCKER.Tick();
         }
         if (_tempGifts)
         {
            GIFTS.Process(_tempGifts);
         }
         if (_tempSentGifts)
         {
            GIFTS.ProcessAcceptedGifts(_tempSentGifts);
         }
         if (_tempSentInvites)
         {
            GIFTS.ProcessAcceptedInvites(_tempSentInvites);
         }
         UPDATES.Catchup();
         HOUSING.Cull();
         HOUSING.Populate();
         SOUNDS.Setup();
         GLOBAL._render = true;
         GLOBAL._catchup = false;
         damageCount = 0;
         buildingInstances ||= InstanceManager.getInstancesByClass(BFOUNDATION);
         for each (building in buildingInstances)
         {
            building.Update(true);
            if (building.health < building.maxHealth && building._repairing == 0)
            {
               damageCount++;
            }
            if (building._countdownBuild.Get() + building._countdownUpgrade.Get() + building._countdownFortify.Get() > 0)
            {
               upgradeCount++;
               for each (helper in building._helpList)
               {
                  if (helper == LOGIN._playerID)
                  {
                     helpedCount++;
                  }
               }
            }
         }
         if (GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD && !WMATTACK._inProgress)
         {
            if (damageCount > 0)
            {
               RepairAll = function(param1:MouseEvent = null):void
               {
                  var _loc3_:BFOUNDATION = null;
                  if (MapRoomManager.instance.isInMapRoom3 && BASE.isOutpost)
                  {
                     repairAllBuildingsToMinimumPercentage(0.25);
                  }
                  popupMCDamaged.bAction.removeEventListener(MouseEvent.CLICK, RepairAll);
                  popupMCDamaged.bAction2.removeEventListener(MouseEvent.CLICK, RepairNow);
                  var _loc2_:Vector.<Object> = InstanceManager.getInstancesByClass(BFOUNDATION);
                  for each (_loc3_ in _loc2_)
                  {
                     if (_loc3_.health < _loc3_.maxHealth && _loc3_._repairing == 0)
                     {
                        _loc3_.Repair();
                     }
                  }
                  SOUNDS.Play("repair1", 0.25);
                  POPUPS.Next();
               };
               RepairNow = function(param1:MouseEvent = null):void
               {
                  var _loc3_:BFOUNDATION = null;
                  if (MapRoomManager.instance.isInMapRoom3 && BASE.isOutpost)
                  {
                     repairAllBuildingsToMinimumPercentage(0.25);
                  }
                  popupMCDamaged.bAction.removeEventListener(MouseEvent.CLICK, RepairAll);
                  popupMCDamaged.bAction2.removeEventListener(MouseEvent.CLICK, RepairNow);
                  var _loc2_:Vector.<Object> = InstanceManager.getInstancesByClass(BFOUNDATION);
                  for each (_loc3_ in _loc2_)
                  {
                     if (_loc3_.health < _loc3_.maxHealth && _loc3_._repairing == 0)
                     {
                        _loc3_.Repair();
                     }
                  }
                  STORE.ShowB(3, 1, ["FIX"], true);
                  POPUPS.Next();
               };
               popupMCDamaged = new popup_damaged();
               popupMCDamaged.mcFrame.Setup(false);
               popupMCDamaged.title.htmlText = "<b>" + KEYS.Get("pop_damaged_title") + "</b>";
               popupMCDamaged.tA.htmlText = KEYS.Get("pop_damaged", {"v1": damageCount});
               popupMCDamaged.bAction.SetupKey("pop_damaged_repairall_btn");
               popupMCDamaged.bAction.addEventListener(MouseEvent.CLICK, RepairAll);
               popupMCDamaged.bAction2.SetupKey("pop_damaged_repairnow_btn");
               popupMCDamaged.bAction2.addEventListener(MouseEvent.CLICK, RepairNow);
               popupMCDamaged.bAction2.Highlight = true;
               POPUPS.Push(popupMCDamaged, null, null, null, "duct-tape.png");
               if (damageCount > 30)
               {
                  MARKETING.Show("catapult");
               }
            }
            needToHealCreeps = false;
            length = int(GLOBAL.player.monsterList.length);
            i = 0;
            while (i < length && !needToHealCreeps)
            {
               if (GLOBAL.player.monsterList[i].needsHeals())
               {
                  needToHealCreeps = true;
               }
               i++;
            }
            if (needToHealCreeps)
            {
               StartHealAll = function(param1:MouseEvent = null):void
               {
                  popupMCCreepDamaged.bAction.removeEventListener(MouseEvent.CLICK, StartHealAll);
                  popupMCCreepDamaged.bAction2.removeEventListener(MouseEvent.CLICK, HealShinyNow);
                  startHealAllHelper();
               };
               HealShinyNow = function(param1:MouseEvent = null):void
               {
                  popupMCCreepDamaged.bAction.removeEventListener(MouseEvent.CLICK, StartHealAll);
                  popupMCCreepDamaged.bAction2.removeEventListener(MouseEvent.CLICK, HealShinyNow);
                  healShinyNowHelper();
               };
               numCreepsDamaged = GLOBAL.player.getNumDamagedCreeps();
               popupMCCreepDamaged = new popup_damaged();
               popupMCCreepDamaged.mcFrame.Setup(false);
               popupMCCreepDamaged.title.htmlText = "<b>" + KEYS.Get("pop_injured_title") + "</b>";
               popupMCCreepDamaged.tA.htmlText = KEYS.Get("pop_injured", {"1": numCreepsDamaged});
               popupMCCreepDamaged.bAction.SetupKey("btn_startheal");
               popupMCCreepDamaged.bAction.addEventListener(MouseEvent.CLICK, StartHealAll);
               popupMCCreepDamaged.bAction2.SetupKey("btn_healnow");
               popupMCCreepDamaged.bAction2.addEventListener(MouseEvent.CLICK, HealShinyNow);
               popupMCCreepDamaged.bAction2.Highlight = true;
               POPUPS.Push(popupMCCreepDamaged, null, null, null, "duct-tape.png");
            }
         }
         INFERNO_EMERGENCE_EVENT.Initialize();
         if (INFERNO_DESCENT_POPUPS.isInDescent() && MAPROOM_DESCENT._descentLvl < MAPROOM_DESCENT._descentLvlMax && MAPROOM_DESCENT._descentLvl > 0)
         {
            INFERNO_DESCENT_POPUPS.ShowTauntDialog(MAPROOM_DESCENT._descentLvl);
         }
         FrontPageHandler.initialize();
         MonsterMadness.initialize();
         GLOBAL.player.initializeHandlers(loadObject);
         GLOBAL.player.importPlayerSpecificHandlers(loadObject);
         if (Boolean(GLOBAL.attackingPlayer) && GLOBAL.attackingPlayer != GLOBAL.player)
         {
            GLOBAL.attackingPlayer.importPlayerSpecificHandlers(loadObject);
         }
         if (!isInfernoMainYardOrOutpost)
         {
            MonsterMadness.updateKorathStats();
         }
         FrontPageHandler.setup(loadObject["frontpage"]);
         FrontPageHandler.showPopup();
         if (GLOBAL.DOES_USE_SCROLL)
         {
            MouseWheelEnabler.init(MAP.stage);
         }
         bb = 0;
         upgradeCount = 0;
         helpedCount = 0;
         if (!GLOBAL._flags.viximo && !GLOBAL._flags.kongregate)
         {
         }
         if (is711Valid())
         {
            if (GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD && isMainYard && TUTORIAL._stage > 200 && GLOBAL._sessionCount >= 5)
            {
               if (!GLOBAL._flags.viximo && !GLOBAL._flags.kongregate && !GLOBAL._displayedPromoNew && !_showingWhatsNew)
               {
                  hasBigGulp = Boolean(_buildingsStored["b120"]);
                  if (!hasBigGulp)
                  {
                     buildingInstances ||= InstanceManager.getInstancesByClass(BDECORATION);
                     for each (building in buildingInstances)
                     {
                        if (building._type == 120)
                        {
                           hasBigGulp = true;
                           break;
                        }
                     }
                  }
                  if (!hasBigGulp)
                  {
                     fbPromoTimer = GLOBAL.Timestamp() + GLOBAL.StatGet("fbpromotimer");
                     if (GLOBAL.StatGet("fbpromotimer") == 0 || GLOBAL.StatGet("fbpromotimer") > 0 && GLOBAL.Timestamp() > GLOBAL.StatGet("fbpromotimer") + GLOBAL._fbPromoTimer)
                     {
                        if (GLOBAL._countryCode == "us")
                        {
                           MoreInfo711 = function(param1:MouseEvent):void
                           {
                              GLOBAL.gotoURL("http://on.fb.me/mTMRnd", null, true, null);
                              POPUPS.Next();
                           };
                           fbPromoPopup = new FBPROMO_711_CLIP();
                           fbPromoPopup.bAction3.buttonMode = true;
                           fbPromoPopup.bAction3.useHandCursor = true;
                           fbPromoPopup.bAction3.mouseChildren = false;
                           fbPromoPopup.bAction3.txt.htmlText = KEYS.Get("btn_goldenbiggulp");
                           fbPromoPopup.bAction3.bg.visible = false;
                           fbPromoPopup.bAction3.addEventListener(MouseEvent.CLICK, MoreInfo711);
                           fbPromoPopup.bAction4.buttonMode = true;
                           fbPromoPopup.bAction4.useHandCursor = true;
                           fbPromoPopup.bAction4.mouseChildren = false;
                           fbPromoPopup.bAction4.txt.htmlText = KEYS.Get("btn_hatcheryoverdrives");
                           fbPromoPopup.bAction4.addEventListener(MouseEvent.CLICK, MoreInfo711);
                           fbPromoPopup.bAction4.bg.visible = false;
                           fbPromoPopup.bInfo.useHandCursor = true;
                           fbPromoPopup.bInfo.buttonMode = true;
                           fbPromoPopup.bInfo.mouseChildren = false;
                           fbPromoPopup.bInfo.addEventListener(MouseEvent.CLICK, MoreInfo711);
                           POPUPS.Push(fbPromoPopup, BUY.logFB711PromoShown, null, null, null, false);
                           GLOBAL.StatSet("fbpromotimer", GLOBAL.Timestamp());
                           GLOBAL._displayedPromoNew = true;
                        }
                     }
                  }
               }
            }
         }
         if (GLOBAL._flags && GLOBAL._flags.fbcncpshow == 2 && GLOBAL._fbcncp > 0)
         {
            BUY.FBCNcpCheckEligibility();
         }
         if (GLOBAL.mode == GLOBAL.e_BASE_MODE.HELP && !(MapRoomManager.instance.isInMapRoom3 && BASE.isOutpost))
         {
            if (upgradeCount > 0)
            {
               if (upgradeCount - helpedCount == 1)
               {
                  GLOBAL.Message(KEYS.Get("base_pleasehelp"));
               }
               if (upgradeCount - helpedCount > 1)
               {
                  GLOBAL.Message(KEYS.Get("base_pleasehelpx", {"v1": upgradeCount - helpedCount}));
               }
            }
            else
            {
               GLOBAL.Message(KEYS.Get("base_nohelpneeded"));
            }
         }
         UI2.Update();
         PLEASEWAIT.Hide();
         CalcResources();
         UI2._scrollMap = true;
         if (GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD)
         {
            if (!WMATTACK._inProgress)
            {
               UI2.Show("top");
               UI2.Show("bottom");
            }
         }
         else if (GLOBAL.mode == GLOBAL.e_BASE_MODE.ATTACK || GLOBAL.mode == GLOBAL.e_BASE_MODE.WMATTACK)
         {
            UI2.Show("top");
         }
         else if (!WMATTACK._inProgress)
         {
            UI2.Show("top");
         }
         _baseLevel = BaseLevel().level;
         _loadTime = GLOBAL.Timestamp();
         _lastSaved = GLOBAL.Timestamp();
         Save();
         buildingInstances ||= InstanceManager.getInstancesByClass(BFOUNDATION);
         for each (building in buildingInstances)
         {
            if (!building._repairing && building.health > 0 && building.health <= building.maxHealth * 0.5)
            {
               Smoke.CreateStream(new Point(building.x, building.y + building._middle));
            }
         }
         QUESTS.TutorialCheck();
         QUESTS.Check();
         PATHING.ResetCosts();
         TUTORIAL.Process();
         MUSHROOMS.Setup();
         NewPopupSystem.instance.CheckAll(true);
         if (GLOBAL.mode == "help" && !(MapRoomManager.instance.isInMapRoom3 && BASE.isOutpost))
         {
            promptSPost = false;
            for each (b in buildingInstances)
            {
               if (b.health < b.maxHealth && b._repairing == 0)
               {
                  promptSPost = true;
               }
            }
            if (GLOBAL.Timestamp() - 24 * 3600 < BASE._damagedBaseWarnTime)
            {
               promptSPost = false;
            }
            if (promptSPost)
            {
               Action = function(param1:MouseEvent = null):void
               {
                  GLOBAL.CallJS("sendFeed", ["warn-damaged", KEYS.Get("base_damaged_streamtitle"), KEYS.Get("base_damaged_streambody", {"v1": BASE._ownerName}), "monstersatwork.png", _loadedFBID]);
                  UPDATES.Create(["DBU"]);
                  POPUPS.Next();
               };
               popupMCdamaged = new popup_damagedbase_onvisit();
               popupMCdamaged.title_txt.htmlText = "<b>" + KEYS.Get("base_damaged_title") + "</b>";
               popupMCdamaged.body_txt.htmlText = KEYS.Get("base_damaged_body", {"v1": BASE._ownerName});
               popupMCdamaged.bAction.SetupKey("base_damaged_alert_btn");
               popupMCdamaged.bAction.Highlight = true;
               popupMCdamaged.bAction.addEventListener(MouseEvent.CLICK, Action);
               POPUPS.Push(popupMCdamaged);
            }
         }
         LOGGER.Stat([29, GLOBAL.mode]);
         LOGGER.Stat([88, GLOBAL._loadmode, m_yardType]);
         _loading = false;
         if (_takeoverFirstOpen)
         {
            WMATTACK._history.lastAttack = GLOBAL.Timestamp() + 12 * 60 * 60;
            WMATTACK._history.sessionsSinceLastAttack = 0;
            if (WMATTACK._history.nextAttack)
            {
               delete WMATTACK._history.nextAttack;
            }
            if (WMATTACK._history.queued)
            {
               delete WMATTACK._history.queued;
            }
            if (_takeoverFirstOpen == 1)
            {
               BragA = function():void
               {
                  GLOBAL.CallJS("sendFeed", ["upgrade-mr", KEYS.Get("conqueredbase", {"v1": _takeoverPreviousOwnersName}), KEYS.Get("newmap_destroyed3"), "build-outpost.png"]);
                  POPUPS.Next();
               };
               ACHIEVEMENTS.Check("wmoutpost", 1);
               POPUPS.DisplayGeneric(KEYS.Get("venividivici"), KEYS.Get("destroyedbase_takeover", {"v1": _takeoverPreviousOwnersName}), KEYS.Get("btn_brag"), "building-outpost.png", BragA);
            }
            else if (_takeoverFirstOpen == 2)
            {
               BragB = function():void
               {
                  GLOBAL.CallJS("sendFeed", ["upgrade-mr", KEYS.Get("conqueredoutpost", {"v1": _takeoverPreviousOwnersName}), KEYS.Get("venividivici"), "build-outpost.png"]);
                  POPUPS.Next();
               };
               ++ACHIEVEMENTS._stats.playeroutpost;
               ACHIEVEMENTS.Check();
               POPUPS.DisplayGeneric(KEYS.Get("venividivici"), KEYS.Get("destroyedoutpost_takeover", {"v1": _takeoverPreviousOwnersName}), KEYS.Get("btn_brag"), "building-outpost.png", BragB);
            }
         }
         _takeoverFirstOpen = 0;
         if (GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD)
         {
            if (isOutpostMapRoom2Only || isOutpostInfernoOnly)
            {
               if (_buildingCount == 1)
               {
                  POPUPS.Push(new popup_prefab_help());
               }
            }
            else
            {
               MARKETING.Process();
               if (GLOBAL._flags.trialpayDealspot == 1 && (TUTORIAL._stage > 200 && GLOBAL._sessionCount > 10))
               {
                  UI2._top.InitDealspot();
               }
               hp = 0;
               hpMax = 0;
               buildingInstances ||= InstanceManager.getInstancesByClass(BFOUNDATION);
               for each (building in buildingInstances)
               {
                  if (building._class != "trap" && building._class != "wall")
                  {
                     hp += building.health;
                     hpMax += building.maxHealth;
                  }
               }
               if (!ALLIANCES._myAlliance)
               {
                  if (GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD && !GLOBAL._empireDestroyedShown && MapRoomManager.instance.isInMapRoom2 && isMainYard && !WMATTACK._inProgress && (GLOBAL._mapOutpost.length == 0 || GLOBAL._empireDestroyed == 1) && hp < hpMax * 0.1)
                  {
                     GLOBAL._empireDestroyedShown = true;
                     popupMCDestroyed = new PopupLostMainBase();
                     popupMCDestroyed.Setup();
                     POPUPS.Push(popupMCDestroyed, null, null, null, "base-destroyed.png");
                  }
               }
            }
         }
         GLOBAL.CallJS("cc.injectFriendsSwf", null, false);
         s_processing = false;
         HideFootprints();
      }

      public static function repairAllBuildingsToMinimumPercentage(param1:Number):void
      {
         var _loc3_:BFOUNDATION = null;
         var _loc4_:Number = NaN;
         param1 = Math.max(0, param1);
         param1 = Math.min(1, param1);
         var _loc2_:Vector.<Object> = InstanceManager.getInstancesByClass(BFOUNDATION);
         for each (_loc3_ in _loc2_)
         {
            _loc4_ = _loc3_.maxHealth * param1;
            if (_loc3_.health < _loc4_)
            {
               _loc3_.setHealth(_loc4_);
            }
         }
      }

      public static function startHealAllHelper():void
      {
         var _loc7_:String = null;
         var _loc11_:Vector.<Object> = null;
         var _loc12_:int = 0;
         var _loc13_:Number = NaN;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:String = null;
         var _loc1_:Player = GLOBAL.player;
         var _loc2_:Vector.<String> = new Vector.<String>();
         var _loc3_:int = int(GLOBAL.player.monsterList.length);
         var _loc4_:Number = 0;
         var _loc5_:Number = 0;
         var _loc6_:Number = 0;
         var _loc8_:int = 0;
         var _loc9_:Boolean = isInfernoMainYardOrOutpost;
         var _loc10_:int = 0;
         while (_loc10_ < _loc3_)
         {
            _loc7_ = _loc1_.monsterList[_loc10_].m_creatureID;
            _loc4_ = _loc1_.getResourceCostByID(_loc7_) - _loc1_.getResourceCostByID(_loc7_, true);
            if (_loc4_)
            {
               _loc2_[_loc8_] = _loc7_;
               _loc8_++;
               if (!_loc9_ && _loc7_.substr(0, 1) == "I")
               {
                  _loc6_ += _loc4_;
               }
               else
               {
                  _loc5_ += _loc4_;
               }
            }
            _loc10_++;
         }
         if (!_loc9_)
         {
            _loc3_ = int((_loc11_ = InstanceManager.getInstancesByClass(Bunker)).length);
            _loc10_ = 0;
            while (_loc10_ < _loc3_)
            {
               _loc7_ = "B" + _loc11_[_loc10_]._id;
               _loc4_ = GLOBAL.player.getResourceCostByID(_loc7_) - GLOBAL.player.getResourceCostByID(_loc7_, true);
               if (_loc4_)
               {
                  var _loc17_:*;
                  _loc2_[_loc17_ = _loc8_++] = _loc7_;
                  _loc5_ += _loc4_;
               }
               _loc10_++;
            }
         }
         if ((!_loc5_ || Charge(4, _loc5_, true, _loc9_)) && (!_loc6_ || Charge(4, _loc6_, true, !_loc9_)))
         {
            Charge(4, _loc5_, false, _loc9_);
            Charge(4, _loc6_, false, !_loc9_);
            _loc3_ = int(_loc2_.length);
            _loc12_ = 0;
            while (_loc12_ < _loc3_)
            {
               GLOBAL.player.queueHeal(_loc2_[_loc12_], true);
               _loc12_++;
            }
            BASE.Save();
         }
         else
         {
            _loc13_ = 0;
            _loc14_ = int(BASE._resources.r4.Get());
            if (_loc5_ > _loc14_)
            {
               _loc13_ = _loc5_ - _loc14_;
               _loc5_ = Number(BASE._resources.r4.Get());
            }
            _loc14_ = int(BASE._iresources.r4.Get());
            if (_loc6_ > _loc14_)
            {
               _loc13_ += _loc6_ - _loc14_;
               _loc6_ = Number(BASE._iresources.r4.Get());
            }
            _loc15_ = Math.ceil(Math.pow(Math.sqrt(_loc13_ / 2), 0.75));
            _loc16_ = _loc9_ ? "msg_moremagmaheal" : "msg_moreresourcesheal";
            GLOBAL.Message(KEYS.Get(_loc16_, {
                        "v1": GLOBAL.FormatNumber(_loc13_),
                        "v2": GLOBAL.FormatNumber(_loc15_)
                     }), KEYS.Get("buildoptions_shiny", {"v1": _loc15_}), startHealWithShiny, [_loc15_, _loc5_, _loc6_, _loc2_]);
         }
         POPUPS.Next();
      }

      public static function startHealWithShiny(param1:int, param2:Number, param3:Number, param4:Vector.<String>):void
      {
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc5_:Boolean = Boolean(BASE.isInfernoMainYardOrOutpost);
         if (BASE._pendingPurchase.length == 0)
         {
            if (param1 > BASE._credits.Get())
            {
               POPUPS.DisplayGetShiny();
            }
            else
            {
               BASE.Charge(4, param2, false, _loc5_);
               BASE.Charge(4, param3, false, !_loc5_);
               _loc6_ = int(param4.length);
               _loc7_ = 0;
               while (_loc7_ < _loc6_)
               {
                  GLOBAL.player.queueHeal(param4[_loc7_]);
                  _loc7_++;
               }
               if (param1 > 0)
               {
                  BASE.Purchase("MHTOPUP", param1, "BASE.startHealWithShiny");
               }
            }
         }
      }

      public static function healShinyNowHelper():void
      {
         var _loc1_:int = STORE.GetHealAllShinyCost();
         STORE.ShowB(3, 1, ["HAMS"], true);
         POPUPS.Next();
      }

      public static function ShowSiegeWeaponWhatsNew(param1:MovieClip, param2:String):void
      {
         var ShowLab:Function;
         var popup:MovieClip = param1;
         var weaponID:String = param2;
         popup.tTitle.htmlText = "<b>" + KEYS.Get("whatsnew_title") + "</b>";
         if (isInfernoMainYardOrOutpost || !INFERNOPORTAL.isAboveMaxLevel() || !MAPROOM_DESCENT.DescentPassed)
         {
            popup.bAction.visible = false;
         }
         else if (GLOBAL._bSiegeLab)
         {
            ShowLab = function(param1:MouseEvent):void
            {
               BUILDINGS._buildingID = SiegeLab.ID;
               SiegeBuilding.Show("lab", weaponID);
               POPUPS.Next();
            };
            popup.bAction.SetupKey("btn_unlocknow");
            popup.bAction.addEventListener(MouseEvent.CLICK, ShowLab);
         }
         else
         {
            popup.bAction.SetupKey("btn_buildnow");
            popup.bAction.addEventListener(MouseEvent.CLICK, ShowBuildLab);
         }
      }

      private static function ShowBuildLab(param1:MouseEvent):void
      {
         BUILDINGS._buildingID = SiegeLab.ID;
         BUILDINGS.Show();
         POPUPS.Next();
      }

      public static function Tick():void
      {
         var saveDelay:int = 2;
         if (GLOBAL._flags.savedelay)
         {
            saveDelay = int(GLOBAL._flags.savedelay);
         }
         if (_saveCounterA != _saveCounterB)
         {
            if (GLOBAL.mode == GLOBAL.e_BASE_MODE.ATTACK && BASE._saveOver != 1)
            {
               if (GLOBAL.Timestamp() - _lastSaveRequest > saveDelay * 2 || GLOBAL.Timestamp() - _lastSaved > 15)
               {
                  SaveB();
               }
            }
            else if (GLOBAL.mode == GLOBAL.e_BASE_MODE.WMATTACK && BASE._saveOver != 1)
            {
               if (GLOBAL.Timestamp() - _lastSaveRequest > saveDelay * 2 || GLOBAL.Timestamp() - _lastSaved > 20)
               {
                  SaveB();
               }
            }
            else if (GLOBAL.Timestamp() - _lastSaveRequest >= saveDelay || _pendingPurchase.length > 0 || _loadBase.length > 0 && BASE._saveOver != 1)
            {
               SaveB();
            }
            if (GLOBAL.mode == GLOBAL.e_BASE_MODE.ATTACK || GLOBAL.mode == GLOBAL.e_BASE_MODE.WMATTACK)
            {
               UI2._top.mcSave.gotoAndStop(2 + 2);
            }
            else
            {
               UI2._top.mcSave.gotoAndStop(2);
            }
         }
         else if (GLOBAL.mode == GLOBAL.e_BASE_MODE.ATTACK || GLOBAL.mode == GLOBAL.e_BASE_MODE.WMATTACK)
         {
            UI2._top.mcSave.gotoAndStop(1 + 2);
         }
         else
         {
            UI2._top.mcSave.gotoAndStop(1);
         }
         if (GLOBAL.Timestamp() % 10 == 0)
         {
            CHECKER.Check();
            if (!isInfernoMainYardOrOutpost)
            {
               AutoBankManager.autobank();
            }
         }
         var _loc2_:int = int(Math.random() * 10) + 25;
         if (GLOBAL._flags.pageinterval)
         {
            _loc2_ = int(GLOBAL._flags.pageinterval);
         }
         if (_lastPaged >= _loc2_ && !_paging && !_saving && GLOBAL.Timestamp() - _lastSaved >= _loc2_)
         {
            var activeEvent:* = SPECIALEVENT.getActiveSpecialEvent();
            if (activeEvent.active)
            {
               _blockSave = false;
               Save(0, false, true);
               _lastSaved = GLOBAL.Timestamp();
            }
            else
            {
               Page();
            }
         }
         ++_lastPaged;
         if (GLOBAL._extraHousing < GLOBAL.Timestamp() && HOUSING._housingUsed.Get() > HOUSING._housingCapacity.Get())
         {
            HOUSING.Cull(false);
            GLOBAL._extraHousing = 0;
            GLOBAL._extraHousingPower.Set(0);
            BASE.Save();
         }
         ShakeB();
      }

      public static function Purchase(param1:String, param2:int, param3:String, param4:Boolean = false):Boolean
      {
         if (_pendingPurchase.length > 0)
         {
            GLOBAL.ErrorMessage(KEYS.Get("msg_err_purchase"), GLOBAL.ERROR_ORANGE_BOX_ONLY);
            return false;
         }
         if (!param2)
         {
            return false;
         }
         if (param2 <= 0)
         {
            GLOBAL.ErrorMessage("BASE.Purchase zero quantity");
            LOGGER.Log("err", "BASE.Purchase Id " + param1 + ", illegal quantity " + param2 + ", possible hack");
            return false;
         }
         _pendingPurchase = [param1, param2, _saveCounterA + 1, param3, param4];
         if (param3 != "store")
         {
            LOGGER.Stat([61, param1, param2]);
         }
         BASE.Save();
         return true;
      }

      public static function Save(param1:int = 0, param2:Boolean = false, param3:Boolean = false, param4:Boolean = false):void
      {
         if (Boolean(UI2._top) && Boolean(UI2._top.mcSave))
         {
            UI2._top.mcSave.gotoAndStop(2);
            if (GLOBAL.mode == GLOBAL.e_BASE_MODE.ATTACK || GLOBAL.mode == GLOBAL.e_BASE_MODE.WMATTACK)
            {
               UI2._top.mcSave.gotoAndStop(2 + 2);
            }
            else
            {
               UI2._top.mcSave.gotoAndStop(2);
            }
         }
         if (param1 > 0)
         {
            _saveOver = param1;
         }
         if (param2)
         {
            _returnHome = true;
         }
         _lastSaveRequest = GLOBAL.Timestamp();
         ++_saveCounterA;
         if (param3 || _pendingPurchase.length > 0)
         {
            SaveB();
         }
         if (isInfernoMainYardOrOutpost || param4 || GLOBAL._loadmode != GLOBAL.mode)
         {
            _infernoSaveLoad = true;
         }
      }

      public static function saveBLite():Boolean
      {
         return true;
      }

      private static function getStatsSaveData():Object
      {
         var _loc1_:Object = {};
         _loc1_.mp = int(QUESTS._global.mushroomspicked);
         _loc1_.mg = int(QUESTS._global.goldmushroomspicked);
         _loc1_.mob = int(QUESTS._global.monstersblended);
         _loc1_.mobg = int(QUESTS._global.monstersblendedgoo);
         _loc1_.moga = int(QUESTS._global.gift_accept);
         _loc1_.updateid = GLOBAL._whatsnewid;
         _loc1_.updateid_mr2 = GLOBAL._mr2TutorialId;
         _loc1_.updateid_mr3 = MapRoom3Tutorial.instance.tutorialId;
         _loc1_.other = GLOBAL._otherStats;
         _loc1_.achievements = ACHIEVEMENTS.Export();
         _loc1_.popupdata = NewPopupSystem.instance.Export();
         if (BASE.isInfernoMainYardOrOutpost && GLOBAL._otherStats.descentLvl >= MAPROOM_DESCENT._descentLvlMax)
         {
            _loc1_.inferno = 1;
         }
         else
         {
            _loc1_.inferno = 0;
         }
         return _loc1_;
      }

      private static function getResourceSaveData():Object
      {
         return {
               "r1": _savedDeltaResources.r1.Get(),
               "r2": _savedDeltaResources.r2.Get(),
               "r3": _savedDeltaResources.r3.Get(),
               "r4": _savedDeltaResources.r4.Get(),
               "r1max": _resources.r1max,
               "r2max": _resources.r2max,
               "r3max": _resources.r3max,
               "r4max": _resources.r4max
            };
      }

      private static function getHousingSaveData():Object
      {
         var _loc1_:int = 0;
         var _loc8_:BUILDING13 = null;
         var _loc9_:Object = null;
         var _loc2_:Object = {};
         var _loc3_:int = 0;
         var _loc4_:Array = [];
         var _loc5_:Array = [];
         var _loc6_:Array = [];
         if (WORKERS._workers && WORKERS._workers.length > 0 && Boolean(WORKERS._workers[0].task))
         {
            _loc1_ = GLOBAL.Timestamp() + WORKERS._workers[0].task._countdownBuild.Get() + WORKERS._workers[0].task._countdownUpgrade.Get() + WORKERS._workers[0].task._countdownFortify.Get();
         }
         var _loc7_:Vector.<Object> = InstanceManager.getInstancesByClass(BUILDING13);
         for each (_loc8_ in _loc7_)
         {
            _loc4_[_loc3_] = [_loc8_._inProduction, _loc8_._countdownProduce.Get()];
            _loc5_[_loc3_] = _loc8_._productionStage.Get();
            _loc6_[_loc3_] = _loc8_._id;
            if (_loc8_._monsterQueue)
            {
               _loc4_[_loc3_].push(_loc8_._monsterQueue);
            }
            _loc3_++;
         }
         _loc2_ = GLOBAL.player.exportMonsters();
         if (GLOBAL._bHatcheryCC)
         {
            _loc9_ = {
                  "saved": GLOBAL.Timestamp(),
                  "housed": _loc2_,
                  "space": HOUSING._housingCapacity.Get(),
                  "hcount": _loc3_,
                  "hcc": GLOBAL._bHatcheryCC._monsterQueue,
                  "h": _loc4_,
                  "hid": _loc6_,
                  "hstage": _loc5_,
                  "overdrivepower": GLOBAL._hatcheryOverdrivePower.Get(),
                  "overdrivetime": GLOBAL._hatcheryOverdrive,
                  "finishtime": _loc1_
               };
         }
         else
         {
            _loc9_ = {
                  "saved": GLOBAL.Timestamp(),
                  "housed": _loc2_,
                  "space": HOUSING._housingCapacity.Get(),
                  "hcount": _loc3_,
                  "hcc": [],
                  "h": _loc4_,
                  "hid": _loc6_,
                  "hstage": _loc5_,
                  "overdrivepower": GLOBAL._hatcheryOverdrivePower.Get(),
                  "overdrivetime": GLOBAL._hatcheryOverdrive,
                  "finishtime": _loc1_
               };
         }
         return _loc9_;
      }

      private static function getStoredBuildingsSaveData():Object
      {
         var _loc2_:String = null;
         var _loc1_:Object = {};
         for (_loc2_ in _buildingsStored)
         {
            if (_buildingsStored[_loc2_].Get())
            {
               _loc1_[_loc2_] = _buildingsStored[_loc2_].Get();
            }
         }
         return _loc1_;
      }

      private static function getInfernoResourcesSaveData():Object
      {
         var _loc2_:String = null;
         var _loc1_:Object = {
               "r1": _ideltaResources.r1.Get(),
               "r2": _ideltaResources.r2.Get(),
               "r3": _ideltaResources.r3.Get(),
               "r4": _ideltaResources.r4.Get(),
               "r1max": _iresources.r1max,
               "r2max": _iresources.r2max,
               "r3max": _iresources.r3max,
               "r4max": _iresources.r4max
            };
         for (_loc2_ in _loc1_)
         {
            if (!_loc1_[_loc2_])
            {
               delete _loc1_[_loc2_];
            }
         }
         if (Boolean(_loc1_.r1) || Boolean(_loc1_.r2) || Boolean(_loc1_.r3) || Boolean(_loc1_.r4))
         {
            return _loc1_;
         }
         return null;
      }

      private static function getMushroomSaveData():Object
      {
         var _loc1_:BFOUNDATION = null;
         var _loc2_:Object = null;
         _mushroomList = [];
         var _loc3_:Vector.<Object> = InstanceManager.getInstancesByClass(BMUSHROOM);
         for each (_loc1_ in _loc3_)
         {
            _loc2_ = _loc1_.Export();
            _mushroomList.push([_loc2_.frame, _loc2_.X, _loc2_.Y]);
         }
         return {
               "l": _mushroomList,
               "s": int(_lastSpawnedMushroom)
            };
      }

      private static function getLootReportSaveData():Object
      {
         return {
               "r1": ATTACK._loot.r1.Get(),
               "r2": ATTACK._loot.r2.Get(),
               "r3": ATTACK._loot.r3.Get(),
               "r4": ATTACK._loot.r4.Get(),
               "isInferno": BASE.isInfernoMainYardOrOutpost,
               "name": _ownerName
            };
      }

      private static function getChampionSaveData():Array
      {
         var _loc5_:int = 0;
         var _loc7_:Vector.<Object> = null;
         var _loc8_:int = 0;
         var _loc1_:Dictionary = new Dictionary();
         var _loc2_:Boolean = false;
         var _loc3_:int = 0;
         var _loc4_:Array = new Array();
         var _loc6_:Boolean = false;
         _loc5_ = 0;
         while (_loc5_ < _guardianData.length)
         {
            if (Boolean(_guardianData[_loc5_]) && _loc1_[_guardianData[_loc5_].t] === undefined)
            {
               _loc1_[_guardianData[_loc5_].t] = _loc5_;
               _loc4_.push(new Object());
               if (_guardianData[_loc5_].nm)
               {
                  _loc4_[_loc3_].nm = _guardianData[_loc5_].nm;
               }
               if (_guardianData[_loc5_].t)
               {
                  _loc4_[_loc3_].t = _guardianData[_loc5_].t;
               }
               if (_guardianData[_loc5_].hp)
               {
                  _loc4_[_loc3_].hp = _guardianData[_loc5_].hp.Get();
               }
               else
               {
                  _loc4_[_loc3_].hp = 0;
               }
               if (_guardianData[_loc5_].l)
               {
                  _loc4_[_loc3_].l = _guardianData[_loc5_].l.Get();
               }
               if (_guardianData[_loc5_].ft)
               {
                  _loc4_[_loc3_].ft = _guardianData[_loc5_].ft;
               }
               if (_guardianData[_loc5_].fd)
               {
                  _loc4_[_loc3_].fd = _guardianData[_loc5_].fd;
               }
               else
               {
                  _loc4_[_loc3_].fd = 0;
               }
               if (_guardianData[_loc5_].fb)
               {
                  _loc4_[_loc3_].fb = _guardianData[_loc5_].fb.Get();
               }
               else
               {
                  _loc4_[_loc3_].fb = 0;
               }
               if (_guardianData[_loc5_].pl)
               {
                  if (_guardianData[_loc5_].pl is SecNum)
                  {
                     _loc4_[_loc3_].pl = _guardianData[_loc5_].pl.Get();
                  }
                  else
                  {
                     _loc4_[_loc3_].pl = _guardianData[_loc5_].pl;
                  }
               }
               else
               {
                  _loc4_[_loc3_].pl = 0;
               }
               if (_guardianData[_loc5_].status == ChampionBase.k_CHAMPION_STATUS_NORMAL && _guardianData[_loc5_].t != 5)
               {
                  if (_loc2_)
                  {
                     _guardianData[_loc5_].status = ChampionBase.k_CHAMPION_STATUS_FROZEN;
                     _guardianData[_loc5_].log += "," + ChampionBase.k_CHAMPION_STATUS_FROZEN.toString();
                  }
                  _loc2_ = true;
               }
               if (_guardianData[_loc5_].status)
               {
                  _loc4_[_loc3_].status = _guardianData[_loc5_].status;
               }
               else
               {
                  _loc4_[_loc3_].status = ChampionBase.k_CHAMPION_STATUS_NORMAL;
               }
               if (_guardianData[_loc5_].log)
               {
                  _loc4_[_loc3_].log = String(_guardianData[_loc5_].log).substr(0, 255);
               }
               else
               {
                  _loc4_[_loc3_].log = String(_loc4_[_loc3_].status).toString();
               }
               _loc3_++;
            }
            else
            {
               _loc6_ = true;
            }
            _loc5_++;
         }
         if (_loc6_)
         {
            _loc7_ = new Vector.<Object>();
            for each (_loc8_ in _loc1_)
            {
               _loc7_.push(_guardianData[_loc8_]);
            }
            _guardianData = _loc7_;
         }
         if (_loc4_.length)
         {
            return _loc4_;
         }
         return null;
      }

      private static function getAttackerDeltaResourcesSaveData():Object
      {
         return {
               "r1": ATTACK._savedDeltaLoot.r1.Get() + GLOBAL._savedAttackersDeltaResources.r1.Get(),
               "r2": ATTACK._savedDeltaLoot.r2.Get() + GLOBAL._savedAttackersDeltaResources.r2.Get(),
               "r3": ATTACK._savedDeltaLoot.r3.Get() + GLOBAL._savedAttackersDeltaResources.r3.Get(),
               "r4": ATTACK._savedDeltaLoot.r4.Get() + GLOBAL._savedAttackersDeltaResources.r4.Get()
            };
      }

      public static function getGuardianIndex(param1:int):int
      {
         var _loc2_:int = 0;
         while (_loc2_ < _guardianData.length)
         {
            if (_guardianData[_loc2_].t == param1)
            {
               return _loc2_;
            }
            _loc2_++;
         }
         return -1;
      }

      private static function getAttackingPlayerGuardianSaveData():Array
      {
         var _loc1_:Array = new Array(GLOBAL._playerGuardianData.length);
         var _loc2_:Boolean = false;
         var _loc3_:int = 0;
         while (_loc3_ < GLOBAL._playerGuardianData.length)
         {
            if (Boolean(GLOBAL._playerGuardianData[_loc3_]) && GLOBAL._playerGuardianData[_loc3_].t > 0)
            {
               _loc1_[_loc3_] = new Object();
               if (GLOBAL._playerGuardianData[_loc3_].nm)
               {
                  _loc1_[_loc3_].nm = GLOBAL._playerGuardianData[_loc3_].nm;
               }
               if (GLOBAL._playerGuardianData[_loc3_].t)
               {
                  _loc1_[_loc3_].t = GLOBAL._playerGuardianData[_loc3_].t;
               }
               if (GLOBAL._playerGuardianData[_loc3_].hp)
               {
                  _loc1_[_loc3_].hp = GLOBAL._playerGuardianData[_loc3_].hp.Get();
               }
               if (GLOBAL._playerGuardianData[_loc3_].l)
               {
                  _loc1_[_loc3_].l = GLOBAL._playerGuardianData[_loc3_].l.Get();
               }
               if (GLOBAL._playerGuardianData[_loc3_].ft)
               {
                  _loc1_[_loc3_].ft = GLOBAL._playerGuardianData[_loc3_].ft;
               }
               if (GLOBAL._playerGuardianData[_loc3_].fd)
               {
                  _loc1_[_loc3_].fd = GLOBAL._playerGuardianData[_loc3_].fd;
               }
               else
               {
                  _loc1_[_loc3_].fd = 0;
               }
               if (GLOBAL._playerGuardianData[_loc3_].fb)
               {
                  _loc1_[_loc3_].fb = GLOBAL._playerGuardianData[_loc3_].fb.Get();
               }
               else
               {
                  _loc1_[_loc3_].fb = 0;
               }
               if (GLOBAL._playerGuardianData[_loc3_].pl)
               {
                  _loc1_[_loc3_].pl = GLOBAL._playerGuardianData[_loc3_].pl.Get();
               }
               else
               {
                  _loc1_[_loc3_].pl = 0;
               }
               if (GLOBAL._playerGuardianData[_loc3_].status == ChampionBase.k_CHAMPION_STATUS_NORMAL && GLOBAL._playerGuardianData[_loc3_].t != 5)
               {
                  if (_loc2_)
                  {
                     GLOBAL._playerGuardianData[_loc3_].status = ChampionBase.k_CHAMPION_STATUS_FROZEN;
                     GLOBAL._playerGuardianData[_loc3_].log += "," + ChampionBase.k_CHAMPION_STATUS_FROZEN.toString();
                  }
                  _loc2_ = true;
               }
               if (GLOBAL._playerGuardianData[_loc3_].status)
               {
                  _loc1_[_loc3_].status = GLOBAL._playerGuardianData[_loc3_].status;
               }
               else
               {
                  _loc1_[_loc3_].status = 0;
               }
               if (GLOBAL._playerGuardianData[_loc3_].log)
               {
                  _loc1_[_loc3_].log = GLOBAL._playerGuardianData[_loc3_].log;
               }
               else
               {
                  _loc1_[_loc3_].log = int(_loc1_[_loc3_].status).toString();
               }
            }
            _loc3_++;
         }
         if (_loc1_.length)
         {
            return _loc1_;
         }
         return null;
      }

      public static function _guardianDataNumNormal():int
      {
         var _loc1_:int = int(_guardianData.length);
         var _loc2_:int = _loc1_ - 1;
         while (_loc2_ >= 0)
         {
            if (_guardianData[_loc2_].status != ChampionBase.k_CHAMPION_STATUS_NORMAL)
            {
               _loc1_--;
            }
            _loc2_--;
         }
         return _loc1_;
      }

      private static function getMR2MonsterUpdateSaveData():Object
      {
         var attackerCellData:CellData = null;
         var attackerHomeCell:MapRoomCell = null;
         var attackerCell:MapRoomCell = null;
         var flingerRange:Number = NaN;
         var monsterId:String = null;
         var amtAllCells:Number = NaN;
         var amtCurCell:Number = NaN;
         var amtAvailable:Number = NaN;
         var amtUsed:Number = NaN;
         var attackerCellUpdates:Object = null;
         var homeCellUpdates:Object = null;
         var cellUpdates:Object = [];
         var resourceLoot:Object = {
               "r1": ATTACK._loot.r1.Get(),
               "r2": ATTACK._loot.r2.Get(),
               "r3": ATTACK._loot.r3.Get(),
               "r4": ATTACK._loot.r4.Get()
            };
         for each (attackerCellData in GLOBAL._attackerCellsInRange)
         {
            attackerCell = attackerCellData.cell;
            if (attackerCell && attackerCell.mine && Boolean(attackerCell.resources))
            {
               if (attackerCell.flingerRange.Get())
               {
                  flingerRange = POWERUPS.Apply(POWERUPS.ALLIANCE_DECLAREWAR, [attackerCell.flingerRange.Get()]);
                  if (flingerRange >= attackerCellData.range)
                  {
                     for (monsterId in GLOBAL._attackerMapCreaturesStart)
                     {
                        if (Boolean(attackerCell.monsters[monsterId]) && attackerCell.monsters[monsterId].Get() > 0)
                        {
                           amtAllCells = GLOBAL._attackerMapCreaturesStart[monsterId].Get();
                           amtCurCell = attackerCell.monsters[monsterId].Get();
                           amtAvailable = ATTACK._curCreaturesAvailable[monsterId]; 
                           if (ATTACK._flingerBucket[monsterId])
                           {
                              // Monsters in the flinger's bucket have not been used yet, thus shouldn't be removed from cells.
                              amtAvailable += ATTACK._flingerBucket[monsterId].Get();
                           }
                           amtUsed = amtAllCells - amtAvailable;
                           if (amtAllCells > amtAvailable)
                           {
                              if (amtUsed >= amtCurCell)
                              {
                                 GLOBAL._attackerMapCreaturesStart[monsterId].Add(-amtCurCell);
                                 attackerCell.monsterData.saved = GLOBAL.Timestamp();
                                 delete attackerCell.monsters[monsterId];
                                 delete attackerCell.hpMonsters[monsterId];
                                 attackerCell.isDirty = true;
                              }
                              else
                              {
                                 attackerCell.monsters[monsterId].Add(-amtUsed);
                                 attackerCell.hpMonsters[monsterId] -= amtUsed;
                                 attackerCell.monsterData.saved = GLOBAL.Timestamp();
                                 GLOBAL._attackerMapCreaturesStart[monsterId].Set(amtAvailable);
                                 attackerCell.isDirty = true;
                              }
                           }
                        }
                     }
                  }
               }
               if (attackerCell.isDirty)
               {
                  if (attackerCell.Check())
                  {
                     attackerCell.monsterData["housed"] = attackerCell.monsters;
                     attackerCell.hpMonsterData["housed"] = attackerCell.hpMonsters;
                     attackerCell.monsterData.saved = GLOBAL.Timestamp();
                     attackerCell.hpMonsterData.saved = GLOBAL.Timestamp();
                     attackerCellUpdates = {
                           "baseid": attackerCell.baseID,
                           "m": attackerCell.hpMonsterData
                        };
                     if (attackerCell.isProtected)
                     {
                        attackerCellUpdates.p = 1;
                        attackerCell.isProtected = 0;
                     }
                     cellUpdates.push(attackerCellUpdates);
                     attackerCell.isDirty = false;
                  }
                  else
                  {
                     LOGGER.Log("err", "BASE.Save:  Dirty Cell " + attackerCell.cellX + "," + attackerCell.cellY + "does not check out before doing map update!  " + JSON.encode(attackerCell.hpResources));
                  }
               }
            }
         }
         attackerHomeCell = MapRoom.homeCell as MapRoomCell;
         if (attackerHomeCell && attackerHomeCell.isProtected && (guardianFlung() || SiegeWeapons.didActivatWeapon || ResourceBombs.launchedBomb))
         {
            attackerHomeCell.isProtected = 0;
            homeCellUpdates = {
                  "baseid": GLOBAL._homeBaseID,
                  "m": attackerHomeCell.hpMonsterData,
                  "p": 1
               };
            cellUpdates.push(homeCellUpdates);
         }
         if (GLOBAL._attackerCellsInRange.length == 0 && GLOBAL.mode === GLOBAL.e_BASE_MODE.ATTACK)
         {
            LOGGER.Log("err", "BASE.Save: No Cells in Range.");
         }
         return cellUpdates;
      }

      private static function getPurchaseSaveData():Object
      {
         var _loc1_:Array = [_pendingPurchase[0], _pendingPurchase[1]];
         if (_pendingPurchase[0].substr(0, 8) == "MUSHROOM")
         {
            if (_pendingPurchase[1] > 1)
            {
               LOGGER.Log("log", "HACK " + _pendingPurchase[0] + " " + _pendingPurchase[1]);
               GLOBAL.ErrorMessage("BASE.Save Mushroom hack 1");
               return false;
            }
            ++GLOBAL._shinyShroomCount;
            if (GLOBAL._shinyShroomCount > 30)
            {
               LOGGER.Log("log", "Too many shiny shrooms in session");
               GLOBAL.ErrorMessage("BASE.Save Mushroom hack 2");
               return false;
            }
            if (!GLOBAL._shinyShroomValid)
            {
               LOGGER.Log("log", "Shiny shroom not validated");
               GLOBAL.ErrorMessage("BASE.Save Mushroom hack 3");
               return false;
            }
            GLOBAL._shinyShroomValid = false;
         }
         if (_pendingPurchase[4])
         {
            _loc1_.push("inv=1");
         }
         return _loc1_;
      }

      private static function fixNegativeResourceValues():void
      {
         if (_resources.r1.Get() < 0)
         {
            LOGGER.Log("err", "Negative twigs reset: " + _resources.r1.Get());
            Fund(1, _resources.r1.Get() * -1, true);
         }
         if (_resources.r2.Get() < 0)
         {
            LOGGER.Log("err", "Negative pebbles reset: " + _resources.r2.Get());
            Fund(2, _resources.r2.Get() * -1, true);
         }
         if (_resources.r3.Get() < 0)
         {
            LOGGER.Log("err", "Negative putty reset: " + _resources.r3.Get());
            Fund(3, _resources.r3.Get() * -1, true);
         }
         if (_resources.r4.Get() < 0)
         {
            LOGGER.Log("err", "Negative goo reset: " + _resources.r4.Get());
            Fund(4, _resources.r4.Get() * -1, true);
         }
      }

      private static function getOrderedSaveVariablesFromObject(param1:Object):Array
      {
         var _loc2_:Array = ["baseid", "lastupdate", "resources", "academy", "stats", "mushrooms", "basename", "baseseed", "buildingdata", "researchdata", "lockerdata", "quests", "basevalue", "points", "tutorialstage", "basesaveid", "clienttime", "monsters", "attacks", "monsterbaiter", "version", "attackreport", "over", "protect", "monsterupdate", "attackid", "aiattacks", "effects", "catapult", "flinger", "gifts", "sentgifts", "sentinvites", "purchase", "inventory", "timeplayed", "destroyed", "damage", "type", "attackcreatures", "attackloot", "lootreport"
               , "empirevalue", "champion", "attackerchampion", "attackersiege", "purchasecomplete", "achieved", "fbpromos", "iresources", "siege", "buildingresources", "frontpage", "events", "buildinghealthdata", "healtime"];
         var _loc3_:int = int(GLOBAL.player.handlers.length);
         var _loc4_:int = 0;
         while (_loc4_ < _loc3_)
         {
            _loc2_.push(GLOBAL.player.handlers[_loc4_].name);
            _loc4_++;
         }
         var _loc5_:Array = [];
         var _loc6_:uint = _loc2_.length;
         var _loc7_:uint = 0;
         while (_loc7_ < _loc6_)
         {
            if (param1.hasOwnProperty(_loc2_[_loc7_]))
            {
               _loc5_.push([_loc2_[_loc7_], param1[_loc2_[_loc7_]]]);
            }
            _loc7_++;
         }
         return _loc5_;
      }

      public static function SaveB():Boolean
      {
         var handler:IHandler = null;
         var exportedData:Object = null;
         var updateAutoBank:Object = null;
         var attackerChampion:Array = null;
         if (GLOBAL._halt)
         {
            return false;
         }
         if (_blockSave || GLOBAL.mode == GLOBAL.e_BASE_MODE.VIEW || GLOBAL.mode == GLOBAL.e_BASE_MODE.HELP || GLOBAL.mode == GLOBAL.e_BASE_MODE.WMVIEW || _loading || GLOBAL.mode == GLOBAL.e_BASE_MODE.IVIEW || GLOBAL.mode == GLOBAL.e_BASE_MODE.IHELP || GLOBAL.mode == GLOBAL.e_BASE_MODE.IWMVIEW)
         {
            _saveCounterB = _saveCounterA;
            return false;
         }
         if (_saving)
         {
            return false;
         }
         if (GLOBAL._catchup)
         {
            _saveCounterB = _saveCounterA;
            return false;
         }
         _saving = true;
         _saveCounterB = _saveCounterA;
         fixNegativeResourceValues();
         CalcBaseValue();
         CalcResources();
         SaveDeltaResources();
         var saveData:Object = {};
         if (MapRoomManager.instance.isInMapRoom3 && !BASE.isInfernoMainYardOrOutpost)
         {
            saveData["healtime"] = getEstimatedRepairDuration();
         }
         var buildingSaveData:Vector.<Object> = BFOUNDATION.getBuildingSaveData();
         if (!MapRoomManager.instance.isInMapRoom3 || !GLOBAL.isInAttackMode || BASE.isInfernoMainYardOrOutpost)
         {
            saveData["buildingdata"] = JSON.encode(buildingSaveData[0]);
         }
         // Old implementation - was specific to MapRoom3, should have been for every map room.
         // if(MapRoomManager.instance.isInMapRoom3 && !BASE.isInfernoMainYardOrOutpost)
         // {
         // saveData["buildinghealthdata"] = JSON.encode(buildingSaveData[1]);
         // saveData["buildingkeydata"] = JSON.encode(buildingSaveData[2]);
         // }
         saveData["buildinghealthdata"] = JSON.encode(buildingSaveData[1]);
         saveData["buildingkeydata"] = JSON.encode(buildingSaveData[2]);
         saveData["stats"] = JSON.encode(getStatsSaveData());
         saveData["resources"] = JSON.encode(getResourceSaveData());
         if (MapRoomManager.instance.isInMapRoom2)
         {
            saveData["monsters"] = JSON.encode(getHousingSaveData());
         }
         else
         {
            saveData["monsters"] = JSON.encode(GLOBAL.player.exportMonsters());
         }
         saveData["catapult"] = !!GLOBAL._bCatapult ? GLOBAL._bCatapult._lvl.Get() : 0;
         saveData["flinger"] = !!GLOBAL._bFlinger ? GLOBAL._bFlinger._lvl.Get() : 0;
         saveData["researchdata"] = JSON.encode(getStoredBuildingsSaveData());
         if (!MapRoomManager.instance.isInMapRoom3 || !GLOBAL.isInAttackMode)
         {
            saveData["mushrooms"] = JSON.encode(getMushroomSaveData());
         }
         saveData["quests"] = JSON.encode(QUESTS._completed);
         saveData["basename"] = GLOBAL.mode == GLOBAL.e_BASE_MODE.WMATTACK ? TRIBES.TribeForBaseID(_wmID).name : _baseName;
         saveData["siege"] = JSON.encode(GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD && isMainYardOrInfernoMainYard ? SiegeWeapons.exportWeapons() : _oldSiegeData);
         saveData["attackersiege"] = JSON.encode(GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD && isMainYardOrInfernoMainYard ? null : SiegeWeapons.exportWeapons());
         saveData["baseid"] = _baseID;
         saveData["lastupdate"] = !!isNaN(UPDATES._lastUpdateID) ? 0 : UPDATES._lastUpdateID;
         saveData["academy"] = JSON.encode(GLOBAL.player.exportAcademyData());
         saveData["baseseed"] = _baseSeed;
         saveData["lockerdata"] = JSON.encode(CREATURELOCKER._lockerData);
         saveData["basevalue"] = _baseValue;
         saveData["points"] = _basePoints;
         saveData["tutorialstage"] = !!BASE.isInfernoMainYardOrOutpost ? TUTORIAL._endstage : TUTORIAL._stage;
         saveData["basesaveid"] = _lastSaveID;
         saveData["clienttime"] = GLOBAL.Timestamp();
         saveData["monsterbaiter"] = JSON.encode(MONSTERBAITER.Export());
         saveData["version"] = GLOBAL._version.Get();
         saveData["aiattacks"] = JSON.encode(WMATTACK.Export());
         if (_attacksModified) {
            saveData["attacks"] = JSON.encode(_currentAttacks);
            _attacksModified = false;
         }
         saveData["effects"] = EFFECTS._effectsJSON;
         saveData["empirevalue"] = CalcBaseValue();
         saveData["inventory"] = STORE.InventoryExport();
         saveData["achieved"] = JSON.encode(ACHIEVEMENTS.Report());
         var frontpageData:Object = FrontPageHandler.export();
         if (frontpageData)
         {
            saveData["frontpage"] = JSON.encode(frontpageData);
         }
         frontpageData = ReplayableEventHandler.exportData();
         if (frontpageData)
         {
            saveData["events"] = JSON.encode(frontpageData);
         }
         var counter:int = 0;
         while (counter < GLOBAL.player.handlers.length)
         {
            handler = GLOBAL.player.handlers[counter];
            exportedData = handler.exportData();
            if (exportedData)
            {
               saveData[handler.name] = JSON.encode(exportedData);
            }
            counter++;
         }
         frontpageData = getInfernoResourcesSaveData();
         if (frontpageData)
         {
            saveData["iresources"] = JSON.encode(frontpageData);
         }
         if (MapRoomManager.instance.isInMapRoom2or3)
         {
            updateAutoBank = AutoBankManager.updateSaveData();
            if (updateAutoBank)
            {
               updateAutoBank = JSON.encode(updateAutoBank);
            }
            if (MapRoomManager.instance.isInMapRoom2)
            {
               saveData["buildingresources"] = updateAutoBank;
            }
         }
         if (_saveOver)
         {
            saveData["over"] = _saveOver;
         }
         if (!BASE.isOutpost)
         {
            saveData.champion = JSON.encode(getChampionSaveData());
         }
         if (GLOBAL.mode != GLOBAL.e_BASE_MODE.BUILD && GLOBAL.mode != GLOBAL.e_BASE_MODE.IBUILD)
         {
            _saveProtect = 0;
            if (isMainYardOrInfernoMainYard)
            {
               if (BFOUNDATION.totalBuildingHP < BFOUNDATION.totalBuildingMaxHP * 0.65)
               {
                  _saveProtect = 1;
               }
               if (BFOUNDATION.totalBuildingHP < BFOUNDATION.totalBuildingMaxHP * 0.45)
               {
                  _saveProtect = 2;
               }
            }
            ATTACK.SaveDeltaLoot();
            GLOBAL.SaveAttackersDeltaResources();
            saveData.attackreport = ATTACK.LogRead();
            saveData.protect = _saveProtect;
            saveData.attackid = _attackID;
            saveData.lootreport = JSON.encode(getLootReportSaveData());
            if (!MapRoomManager.instance.isInMapRoom2or3 || BASE.isInfernoMainYardOrOutpost)
            {
               saveData.attackcreatures = JSON.encode(GLOBAL.attackingPlayer.exportMonsters());
            }
            saveData.attackloot = JSON.encode(getAttackerDeltaResourcesSaveData());
            attackerChampion = getAttackingPlayerGuardianSaveData();
            if (attackerChampion)
            {
               saveData.attackerchampion = JSON.encode(attackerChampion);
            }
         }
         if (MapRoomManager.instance.isInMapRoom2 && !GLOBAL.InfernoMode(GLOBAL._loadmode))
         {
            saveData.monsterupdate = JSON.encode(getMR2MonsterUpdateSaveData());
         }
         else if (MapRoomManager.instance.isInMapRoom3 && !BASE.isInfernoMainYardOrOutpost)
         {
            if (GLOBAL.attackingPlayer)
            {
               saveData.monsterupdate = JSON.encode(GLOBAL.attackingPlayer.exportMonsters());
            }
         }
         if (GIFTS._giftsAccepted.length > 0)
         {
            saveData.gifts = JSON.encode(GIFTS._giftsAccepted);
         }
         if (GIFTS._sentGiftsAccepted.length > 0)
         {
            saveData.sentgifts = JSON.encode(GIFTS._sentGiftsAccepted);
         }
         if (GIFTS._sentInvitesAccepted.length > 0)
         {
            saveData.sentinvites = JSON.encode(GIFTS._sentInvitesAccepted);
         }
         if (_pendingPurchase.length > 0)
         {
            saveData.purchase = JSON.encode(getPurchaseSaveData());
            _pendingPurchase = [];
         }
         saveData.timeplayed = int(GLOBAL._timePlayed);
         if (GLOBAL.mode == "wmattack" || GLOBAL.mode == "iwmattack")
         {
            if (!MapRoomManager.instance.isInMapRoom2or3 || MapRoomManager.instance.isInMapRoom3 && isInfernoMainYardOrOutpost)
            {
               saveData.type = GLOBAL._loadmode == "iwmattack" || BASE.isInfernoMainYardOrOutpost && GLOBAL.mode == "wmattack" ? "iwm" : "wm";
               saveData.destroyed = _percentDamaged >= 90 ? 1 : 0;
            }
            else
            {
               saveData.destroyed = _percentDamaged >= 90 ? 1 : 0;
            }
         }
         else if (isOutpostOrInfernoOutpost && GLOBAL.mode != GLOBAL.e_BASE_MODE.BUILD)
         {
            saveData.destroyed = _percentDamaged >= 90 ? 1 : 0;
         }
         else if (isInfernoMainYardOrOutpost || GLOBAL._loadmode != GLOBAL.mode)
         {
            saveData.type = "inferno";
         }
         saveData.damage = _percentDamaged;
         if (_pendingPromo)
         {
            saveData.purchasecomplete = 1;
            _pendingPromo = 0;
         }
         if (_pendingFBPromo)
         {
            saveData.fbpromos = JSON.encode(_pendingFBPromoIDs);
            _pendingFBPromo = 0;
            GLOBAL._displayedPromoNew = true;
            GLOBAL.StatSet("fbpromotimer", GLOBAL.Timestamp());
         }
         GLOBAL._timePlayed = 0;
         var saveDataList:Array = getOrderedSaveVariablesFromObject(saveData);
         if (!GLOBAL._save)
         {
            _saving = false;
            _lastSaved = GLOBAL.Timestamp();
            return false;
         }
         if (isInfernoMainYardOrOutpost || _infernoSaveLoad && saveData.type == "inferno" || isEventBaseId(_baseID) && GLOBAL.mode == GLOBAL.e_BASE_MODE.WMATTACK)
         {
            new URLLoaderApi().load(GLOBAL._infBaseURL + "save", saveDataList, handleLoadSuccessful, handleLoadError);
         }
         else
         {
            new URLLoaderApi().load(GLOBAL._baseURL + "save", saveDataList, handleLoadSuccessful, handleLoadError);
         }
         if (_saveOver)
         {
            _blockSave = true;
         }
         return true;
      }

      private static function handleLoadSuccessful(serverData:Object):void
      {
         var yardType:int = 0;
         var resourceIndex:int = 0;
         var securedOutpost:MapRoom3OutpostSecured = null;
         if (serverData.error == 0)
         {
            GLOBAL.CleanAttackersDeltaResources();
            CleanDeltaResources();
            if (GLOBAL.mode != GLOBAL.e_BASE_MODE.BUILD && GLOBAL.mode != "ibuild")
            {
               ATTACK.CleanLoot();
            }
            if (_returnHome && serverData.over == 1)
            {
               if (isInfernoMainYardOrOutpost)
               {
                  LoadBase(null, 0, 0, "ibuild", false, EnumYardType.INFERNO_YARD);
               }
               else
               {
                  yardType = MapRoomManager.instance.isInMapRoom3 ? int(EnumYardType.PLAYER) : int(EnumYardType.MAIN_YARD);
                  LoadBase(null, 0, 0, GLOBAL.e_BASE_MODE.BUILD, false, yardType);
               }
               return;
            }
            _saveErrors = 0;
            _lastSaved = GLOBAL.Timestamp();
            _lastSaveID = serverData.basesaveid;
            _credits.Set(int(serverData.credits));
            _hpCredits = int(serverData.credits);
            GLOBAL._credits.Set(int(serverData.credits));
            if (serverData.resources)
            {
               if (_saveCounterA == _saveCounterB)
               {
                  resourceIndex = 1;
                  while (resourceIndex < 5)
                  {
                     if (serverData.resources["r" + resourceIndex])
                     {
                        _resources["r" + resourceIndex].Set(serverData.resources["r" + resourceIndex]);
                        _hpResources["r" + resourceIndex] = _resources["r" + resourceIndex].Get();
                        if (GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD || GLOBAL.mode == "ibuild")
                        {
                           GLOBAL._resources["r" + resourceIndex].Set(serverData.resources["r" + resourceIndex]);
                           GLOBAL._hpResources["r" + resourceIndex] = GLOBAL._resources["r" + resourceIndex].Get();
                        }
                     }
                     resourceIndex++;
                  }
               }
               if (GLOBAL.mode != GLOBAL.e_BASE_MODE.BUILD && GLOBAL.mode != "ibuild")
               {
                  ATTACK.CleanLoot();
                  GLOBAL.CleanAttackersDeltaResources();
               }
               CleanDeltaResources();
            }
            _isProtected = int(serverData["protected"]);
            _isFan = int(serverData.fan);
            _isBookmarked = int(serverData.bookmarked);
            _installsGenerated = int(serverData.installsgenerated);
            if (serverData.fan)
            {
               QUESTS._global.bonus_fan = 1;
            }
            if (serverData.bookmarked)
            {
               QUESTS._global.bonus_bookmark = 1;
            }
            if (Boolean(serverData.updates) && serverData.updates.length > 0)
            {
               UPDATES.Process(serverData.updates);
            }
            if (_loadBase.length > 0)
            {
               LoadBaseB();
            }
            if (ATTACK.waitingForSaveToComplete)
            {
               ATTACK.End();
            }
            if (serverData.takeover)
            {
               securedOutpost = new MapRoom3OutpostSecured(BASE.yardType, serverData.takeover);
               POPUPS.Push(securedOutpost);
            }
         }
         else
         {
            LOGGER.Log("err", "Base.Save: " + JSON.encode(serverData));
            GLOBAL.ErrorMessage("BASE.SaveB 2: " + serverData.error);
         }
         _saving = false;
      }

      private static function handleLoadError(param1:IOErrorEvent):void
      {
         ++_saveErrors;
         --_saveCounterB;
         _saving = false;
         if (_saveErrors >= 5)
         {
            LOGGER.Log("err", "Base.Save HTTP");
            GLOBAL.ErrorMessage("BASE.Save HTTP");
         }
      }

      private static function guardianFlung():Boolean
      {
         var _loc1_:String = null;
         for (_loc1_ in CREEPS._flungGuardian)
         {
            if (CREEPS._flungGuardian[_loc1_])
            {
               return true;
            }
         }
         return false;
      }

      public static function Page():void
      {
         var handleLoadSuccessful:Function = null;
         var handleLoadError:Function = null;
         handleLoadSuccessful = function(serverData:Object):void
         {
            var resourceIndex:int = 0;
            var resourceDelta:int = 0;
            var _loc4_:String = null;
            var _loc5_:Object = null;
            var _loc6_:int = 0;
            var _loc7_:Object = null;
            var _loc8_:int = 0;
            _lastPaged = int(Math.random() * 5);
            if (serverData.error == 0)
            {
               _paging = false;
               GLOBAL.SetFlags(serverData.flags);
               GLOBAL._unreadMessages = !!serverData.unreadmessages ? int(serverData.unreadmessages) : 0;
               _pageErrors = 0;
               _credits.Set(int(serverData.credits));
               _hpCredits = int(serverData.credits);
               GLOBAL._credits.Set(int(serverData.credits));
               _isProtected = int(serverData["protected"]);
               _isFan = int(serverData.fan);
               _isBookmarked = int(serverData.bookmarked);
               _installsGenerated = int(serverData.installsgenerated);
               if ((GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD || GLOBAL.mode == GLOBAL.e_BASE_MODE.IBUILD) && serverData.resources && _saveCounterA == _saveCounterB)
               {
                  if (serverData.resources.r1 != _resources.r1.Get() || serverData.resources.r2 != _resources.r2.Get() || serverData.resources.r3 != _resources.r3.Get() || serverData.resources.r4 != _resources.r4.Get())
                  {
                  }
                  resourceIndex = 1;
                  while (resourceIndex < 5)
                  {
                     if (serverData.resources["r" + resourceIndex])
                     {
                        resourceDelta = 0;
                        if (BASE._deltaResources && BASE._deltaResources["r" + resourceIndex] && BASE._deltaResources["r" + resourceIndex].Get() > 0)
                        {
                           resourceDelta = int(BASE._deltaResources["r" + resourceIndex].Get());
                        }
                        _resources["r" + resourceIndex].Set(serverData.resources["r" + resourceIndex] + resourceDelta);
                        _hpResources["r" + resourceIndex] = _resources["r" + resourceIndex].Get();
                        GLOBAL._resources["r" + resourceIndex].Set(serverData.resources["r" + resourceIndex] + resourceDelta);
                        GLOBAL._hpResources["r" + resourceIndex] = GLOBAL._resources["r" + resourceIndex].Get();
                     }
                     resourceIndex++;
                  }
               }
               if (serverData.fan)
               {
                  QUESTS._global.bonus_fan = 1;
               }
               if (serverData.bookmarked)
               {
                  QUESTS._global.bonus_bookmark = 1;
               }
               if (serverData.giftsentcount)
               {
                  QUESTS._global.bonus_gifts = serverData.giftsentcount;
               }
               if (Boolean(serverData.updates) && serverData.updates.length > 0)
               {
                  UPDATES.Process(serverData.updates);
               }
               if (serverData.buildingresources)
               {
                  _rawGIP = serverData.buildingresources;
                  _processedGIP = {};
                  _GIP = {
                        "r1": new SecNum(0),
                        "r2": new SecNum(0),
                        "r3": new SecNum(0),
                        "r4": new SecNum(0)
                     };
                  if (_rawGIP)
                  {
                     if (_rawGIP["b" + GLOBAL._homeBaseID])
                     {
                        delete _rawGIP["b" + GLOBAL._homeBaseID];
                     }
                     if (_rawGIP["t"])
                     {
                        _lastProcessedGIP = _rawGIP["t"];
                        delete _rawGIP["t"];
                     }
                     if (GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD || GLOBAL.mode == GLOBAL.e_BASE_MODE.ATTACK)
                     {
                        for (_loc4_ in _rawGIP)
                        {
                           _loc5_ = _rawGIP[_loc4_];
                           if (_loc4_ == "t")
                           {
                              _lastProcessedGIP = _rawGIP[_loc4_];
                           }
                           else
                           {
                              if (_loc5_ is String)
                              {
                                 break;
                              }
                              if (_loc5_["r1"] != undefined)
                              {
                                 _processedGIP[_loc4_] = {
                                       "r1": new SecNum(_loc5_["r1"]),
                                       "r2": new SecNum(_loc5_["r2"]),
                                       "r3": new SecNum(_loc5_["r3"]),
                                       "r4": new SecNum(_loc5_["r4"])
                                    };
                              }
                              else
                              {
                                 _loc6_ = int(_rawGIP[_loc4_]["height"]);
                                 if (_loc6_)
                                 {
                                    delete _loc5_["height"];
                                 }
                                 else
                                 {
                                    _loc6_ = 100;
                                 }
                                 _processedGIP[_loc4_] = {
                                       "r1": new SecNum(0),
                                       "r2": new SecNum(0),
                                       "r3": new SecNum(0),
                                       "r4": new SecNum(0)
                                    };
                                 for each (_loc7_ in _loc5_)
                                 {
                                    if (_loc7_.t >= 1 && _loc7_.t <= 4)
                                    {
                                       if (_loc7_.l)
                                       {
                                          _loc8_ = int(OUTPOST_YARD_PROPS._outpostProps[_loc7_.t - 1].produce[_loc7_.l - 1]);
                                       }
                                       else
                                       {
                                          _loc8_ = int(OUTPOST_YARD_PROPS._outpostProps[_loc7_.t - 1].produce[0]);
                                       }
                                       _loc8_ = Math.max(int(_loc8_ * GLOBAL._averageAltitude.Get() / _loc6_), 1);
                                       _processedGIP[_loc4_]["r" + _loc7_.t].Add(_loc8_);
                                    }
                                 }
                                 _rawGIP[_loc4_] = {
                                       "r1": _processedGIP[_loc4_].r1.Get(),
                                       "r2": _processedGIP[_loc4_].r2.Get(),
                                       "r3": _processedGIP[_loc4_].r3.Get(),
                                       "r4": _processedGIP[_loc4_].r4.Get()
                                    };
                              }
                              _GIP["r1"].Add(_processedGIP[_loc4_]["r1"].Get());
                              _GIP["r2"].Add(_processedGIP[_loc4_]["r2"].Get());
                              _GIP["r3"].Add(_processedGIP[_loc4_]["r3"].Get());
                              _GIP["r4"].Add(_processedGIP[_loc4_]["r4"].Get());
                           }
                        }
                        if (!_rawGIP["t"])
                        {
                           _lastProcessedGIP = _lastProcessed;
                        }
                        if (GLOBAL.Timestamp() - _lastProcessedGIP > 3600 * 24)
                        {
                           _lastProcessedGIP = GLOBAL.Timestamp() - 3600 * 24;
                        }
                        _processedGIP["t"] = _lastProcessedGIP;
                     }
                  }
               }
               if (GLOBAL._loadmode == GLOBAL.e_BASE_MODE.BUILD && isMainYard)
               {
                  if (serverData.alliancedata)
                  {
                     _allianceID = int(serverData.alliancedata.alliance_id);
                     if (_userID == LOGIN._playerID)
                     {
                        ALLIANCES._allianceID = int(serverData.alliancedata.alliance_id);
                        ALLIANCES._myAlliance = ALLIANCES.SetAlliance(serverData.alliancedata);
                     }
                  }
                  else if (_userID == LOGIN._playerID && (ALLIANCES._allianceID || ALLIANCES._myAlliance))
                  {
                     ALLIANCES.Clear();
                     POWERUPS.Validate();
                  }
               }
               if (serverData.powerups)
               {
                  POWERUPS.Setup(serverData.powerups, null, false);
               }
               if (serverData.attpowerups)
               {
                  POWERUPS.Setup(null, serverData.attpowerups, false);
               }
               QUESTS.Check();
            }
            else
            {
               LOGGER.Log("err", "Base.Page: " + JSON.encode(serverData));
               GLOBAL.ErrorMessage("Base.Page: " + serverData.error);
            }
         };
         handleLoadError = function(param1:IOErrorEvent):void
         {
            ++_pageErrors;
            _paging = false;
            Console.warning("BASE.Page ERROR", Boolean(_pageErrors));
            _lastPaged = int(10 + int(Math.random() * 5));
            if (_pageErrors >= 6)
            {
               LOGGER.Log("err", "Base.Page HTTP");
               GLOBAL.ErrorMessage("BASE.Page HTTP");
            }
         };
         var t:int = getTimer();
         var tmpMode:String = GLOBAL._loadmode;
         switch (tmpMode)
         {
            case GLOBAL.e_BASE_MODE.WMATTACK:
               tmpMode = GLOBAL.e_BASE_MODE.ATTACK;
               break;
            case GLOBAL.e_BASE_MODE.WMVIEW:
               tmpMode = GLOBAL.e_BASE_MODE.VIEW;
               break;
            case GLOBAL.e_BASE_MODE.IWMATTACK:
               tmpMode = GLOBAL.e_BASE_MODE.IATTACK;
               break;
            case GLOBAL.e_BASE_MODE.IWMVIEW:
               tmpMode = GLOBAL.e_BASE_MODE.IVIEW;
         }
         _paging = true;
         if (isInfernoMainYardOrOutpost || isEventBaseId(_baseID) && GLOBAL.mode == "wmattack")
         {
            new URLLoaderApi().load(GLOBAL._infBaseURL + "updatesaved", [["baseid", BASE._loadedBaseID], ["version", GLOBAL._version.Get()], ["lastupdate", UPDATES._lastUpdateID], ["type", tmpMode]], handleLoadSuccessful, handleLoadError);
         }
         else
         {
            new URLLoaderApi().load(GLOBAL._baseURL + "updatesaved", [["baseid", BASE._loadedBaseID], ["version", GLOBAL._version.Get()], ["lastupdate", UPDATES._lastUpdateID], ["type", tmpMode]], handleLoadSuccessful, handleLoadError);
         }
      }

      public static function CanBuild(param1:int, param2:Boolean = false):Object
      {
         var _loc7_:String = null;
         var _loc8_:Vector.<Object> = null;
         var _loc9_:Array = null;
         var _loc10_:int = 0;
         var _loc11_:Boolean = false;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:BFOUNDATION = null;
         var _loc17_:Array = null;
         var _loc18_:int = 0;
         var _loc19_:int = 0;
         var _loc20_:int = 0;
         var _loc21_:int = 0;
         var _loc22_:int = 0;
         var _loc23_:int = 0;
         var _loc24_:int = 0;
         var _loc25_:int = 0;
         var _loc26_:Boolean = false;
         var _loc27_:Object = null;
         var _loc28_:Array = null;
         var _loc3_:Object = {};
         var _loc4_:Boolean = false;
         var _loc5_:String = "";
         var _loc6_:int = 0;
         if (GLOBAL._aiDesignMode)
         {
            return {"error": false};
         }
         for (_loc7_ in GLOBAL._buildingProps)
         {
            if (GLOBAL._buildingProps[_loc7_].id == param1)
            {
               if (GLOBAL._buildingProps[_loc7_].rewarded)
               {
                  return {"error": false};
               }
               _loc3_ = GLOBAL._buildingProps[_loc7_];
               break;
            }
         }
         if (TUTORIAL._stage < 200 && _loc3_.tutstage > TUTORIAL._stage)
         {
            _loc4_ = true;
            _loc5_ = KEYS.Get("base_builderr_locked");
         }
         else if (GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD && (_loc3_.type == "taunt" || _loc3_.type == "gift"))
         {
            _loc4_ = true;
            _loc5_ = KEYS.Get("base_builderr_ownyard1");
         }
         else if (GLOBAL.mode != GLOBAL.e_BASE_MODE.BUILD && _loc3_.type != "taunt" && _loc3_.type != "gift")
         {
            _loc4_ = true;
            _loc5_ = KEYS.Get("base_builderr_ownyard2");
         }
         else
         {
            _loc9_ = _loc3_.quantity;
            _loc10_ = 0;
            _loc11_ = isInfernoMainYardOrOutpost;
            if (GLOBAL.townHall)
            {
               _loc10_ = GLOBAL.townHall._lvl.Get();
               if (Boolean(_loc3_.costs[0].re[0]) && _loc3_.costs[0].re[0][0] == INFERNOQUAKETOWER.UNDERHALL_ID)
               {
                  if (!MAPROOM_DESCENT.DescentPassed)
                  {
                     _loc4_ = true;
                     _loc5_ = KEYS.Get("inferno_building_requirement");
                     return {
                           "error": _loc4_,
                           "errorMessage": _loc5_
                        };
                  }
                  _loc10_ = GLOBAL.StatGet(BUILDING14.UNDERHALL_LEVEL);
                  _loc11_ = true;
                  if (!_loc10_)
                  {
                     _loc4_ = true;
                     _loc5_ = KEYS.Get("base_builderr_noinfstate", {"v1": _loc10_});
                     return {
                           "error": _loc4_,
                           "errorMessage": _loc5_
                        };
                  }
               }
            }
            _loc12_ = _loc10_ < _loc9_.length ? _loc10_ : int(_loc9_.length - 1);
            _loc13_ = int(_loc9_[_loc12_]);
            if (_loc3_.type == "decoration")
            {
               _loc14_ = _loc13_ = int(_loc9_[0]);
            }
            else
            {
               _loc14_ = _loc13_;
               if (_loc9_.length > _loc10_)
               {
                  _loc14_ = int(_loc9_[_loc10_ + 1]);
               }
            }
            if (_loc13_ == 0)
            {
               _loc15_ = 0;
               while (_loc15_ < _loc9_.length)
               {
                  if (_loc9_[_loc15_] > 0)
                  {
                     _loc4_ = true;
                     _loc5_ = KEYS.Get(_loc11_ ? "base_builderr_uhlevelreqd" : "base_builderr_thlevelreqd", {"v1": _loc15_});
                     break;
                  }
                  _loc15_++;
               }
            }
            else if (_loc3_.type != "decoration" || _loc3_.type == "decoration" && _loc3_.quantity[0] != 0)
            {
               _loc6_ = 0;
               _loc8_ = InstanceManager.getInstancesByClass(BFOUNDATION);
               for each (_loc16_ in _loc8_)
               {
                  if (_loc16_._type == param1 && GLOBAL._newBuilding !== _loc16_)
                  {
                     _loc6_++;
                  }
               }
               if (_loc6_ >= _loc13_)
               {
                  _loc4_ = true;
                  if (_loc14_ > _loc13_)
                  {
                     _loc5_ = KEYS.Get(isInfernoBuilding(param1) || isInfernoMainYardOrOutpost ? "base_builderr_uuh" : "base_builderr_uth");
                  }
                  else
                  {
                     _loc5_ = KEYS.Get("base_builderr_onlybuildx", {"v1": _loc13_});
                  }
               }
            }
         }
         if (!_loc4_)
         {
            _loc17_ = _loc3_.costs[0].re;
            _loc18_ = 0;
            _loc15_ = 0;
            while (_loc15_ < _loc17_.length)
            {
               _loc6_ = 0;
               if (_loc17_[_loc15_][0] == INFERNOQUAKETOWER.UNDERHALL_ID)
               {
                  if (GLOBAL.StatGet(BUILDING14.UNDERHALL_LEVEL) >= _loc17_[_loc15_][2])
                  {
                     _loc6_++;
                  }
               }
               else
               {
                  _loc8_ ||= InstanceManager.getInstancesByClass(BFOUNDATION);
                  for each (_loc16_ in _loc8_)
                  {
                     if (_loc16_._type == _loc17_[_loc15_][0] && _loc16_._lvl.Get() >= _loc17_[_loc15_][2])
                     {
                        _loc6_++;
                     }
                  }
               }
               if (_loc6_ >= _loc17_[_loc15_][1])
               {
                  _loc18_++;
               }
               _loc15_++;
            }
            if (_loc18_ < _loc17_.length)
            {
               _loc4_ = true;
               _loc5_ = KEYS.Get("requirements_notmet");
            }
         }
         if (!_loc4_ && !param2)
         {
            _loc19_ = int(_loc3_.costs[0].r1.Get());
            _loc20_ = int(_loc3_.costs[0].r2.Get());
            _loc21_ = int(_loc3_.costs[0].r3.Get());
            _loc22_ = int(_loc3_.costs[0].r4.Get());
            _loc23_ = 0;
            _loc25_ = 0;
            if (GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD || GLOBAL.mode == "ibuild")
            {
               _loc26_ = Boolean(BASE.isInfernoBuilding(param1));
               _loc27_ = _loc26_ ? BASE._iresources : BASE._resources;
               if (_loc19_ > _loc27_.r1.Get())
               {
                  _loc24_ = 1;
                  _loc25_ = _loc19_ - _loc27_.r1.Get();
               }
               if (_loc20_ > _loc27_.r2.Get())
               {
                  _loc24_ = 2;
                  _loc25_ = _loc20_ - _loc27_.r2.Get();
               }
               if (_loc21_ > _loc27_.r3.Get())
               {
                  _loc24_ = 3;
                  _loc25_ = _loc21_ - _loc27_.r3.Get();
               }
               if (_loc22_ > _loc27_.r4.Get())
               {
                  _loc24_ = 4;
                  _loc25_ = _loc22_ - _loc27_.r4.Get();
               }
               if (_loc24_ > 0)
               {
                  _loc4_ = true;
                  _loc28_ = _loc26_ ? GLOBAL.iresourceNames : GLOBAL._resourceNames;
                  _loc5_ = "You need " + GLOBAL.FormatNumber(_loc25_) + " more " + KEYS.Get(_loc28_[_loc24_ - 1]);
               }
            }
         }
         return {
               "error": _loc4_,
               "errorMessage": _loc5_,
               "needResource": _loc24_
            };
      }

      public static function CanUpgrade(param1:BFOUNDATION):Object
      {
         var _loc7_:String = null;
         var _loc8_:Array = null;
         var _loc9_:Array = null;
         var _loc10_:Array = null;
         var _loc11_:Boolean = false;
         var _loc12_:int = 0;
         var _loc13_:String = null;
         var _loc14_:Vector.<Object> = null;
         var _loc15_:BFOUNDATION = null;
         var _loc16_:Array = null;
         var _loc17_:int = 0;
         var _loc18_:int = 0;
         var _loc19_:Object = null;
         if (param1._class == "mushroom")
         {
            return {"error": false};
         }
         var _loc2_:Object = {};
         var _loc3_:Object = {
               "r1": 0,
               "r2": 0,
               "r3": 0,
               "r4": 0,
               "time": new SecNum(0)
            };
         var _loc4_:Boolean = false;
         var _loc5_:String = "";
         var _loc6_:int = param1._lvl.Get();
         for (_loc7_ in GLOBAL._buildingProps)
         {
            if (GLOBAL._buildingProps[_loc7_].id == param1._type)
            {
               _loc2_ = GLOBAL._buildingProps[_loc7_];
               break;
            }
         }
         _loc8_ = _loc2_.costs;
         if (!GLOBAL.townHall)
         {
            _loc4_ = true;
            _loc5_ = KEYS.Get("base_uperr_th");
         }
         else if (_loc6_ >= _loc8_.length)
         {
            _loc4_ = true;
            _loc5_ = KEYS.Get("base_uperr_fully");
         }
         else if (param1._countdownBuild.Get())
         {
            _loc4_ = true;
            _loc5_ = KEYS.Get("base_uperr_stillbuilding");
         }
         else if (param1._countdownUpgrade.Get())
         {
            _loc4_ = true;
            _loc5_ = KEYS.Get("base_uperr_alreadyupgrading");
         }
         else if (param1._countdownFortify.Get())
         {
            _loc4_ = true;
            _loc5_ = KEYS.Get("base_uperr_stillfortifying");
         }
         else
         {
            _loc9_ = [];
            for each (_loc10_ in _loc8_[_loc6_].re)
            {
               _loc12_ = 0;
               if (_loc10_[0] == INFERNOQUAKETOWER.UNDERHALL_ID)
               {
                  _loc13_ = "#bi_townhall#";
                  if (GLOBAL.StatGet(BUILDING14.UNDERHALL_LEVEL) >= _loc10_[2])
                  {
                     _loc12_++;
                  }
               }
               else
               {
                  _loc13_ = String(GLOBAL._buildingProps[_loc10_[0] - 1].name);
                  _loc14_ = InstanceManager.getInstancesByClass(BFOUNDATION);
                  for each (_loc15_ in _loc14_)
                  {
                     if (_loc15_._type == _loc10_[0] && _loc15_._lvl.Get() >= _loc10_[2])
                     {
                        _loc12_++;
                     }
                  }
               }
               if (_loc12_ < _loc10_[1])
               {
                  if (_loc10_[1] == 1)
                  {
                     if (_loc10_[2] == 1)
                     {
                        _loc9_.push([0, KEYS.Get("base_uperr_bdgpart1", {"v1": KEYS.Get(_loc13_)})]);
                     }
                     else
                     {
                        _loc9_.push([0, KEYS.Get("base_uperr_bdgpart2", {
                                       "v1": _loc10_[2],
                                       "v2": KEYS.Get(_loc13_)
                                    })]);
                     }
                  }
                  else if (_loc10_[2] == 1)
                  {
                     _loc9_.push([0, KEYS.Get("base_uperr_bdgpart3", {
                                    "v1": KEYS.Get(_loc13_),
                                    "v2": _loc10_[1]
                                 })]);
                  }
                  else
                  {
                     _loc9_.push([0, KEYS.Get("base_uperr_bdgpart4", {
                                    "v1": _loc10_[2],
                                    "v2": KEYS.Get(_loc13_),
                                    "v3": _loc10_[1]
                                 })]);
                  }
               }
            }
            if (_loc9_.length > 0)
            {
               _loc4_ = true;
               _loc5_ = KEYS.Get("base_uperr_buildings", {"v1": GLOBAL.Array2StringB(_loc9_)});
            }
            _loc11_ = Boolean(BASE.isInfernoBuilding(param1._type));
            if (_loc17_ > 0)
            {
               _loc4_ = true;
               _loc16_ = _loc11_ ? GLOBAL.iresourceNames : GLOBAL._resourceNames;
               _loc5_ = "You need " + GLOBAL.FormatNumber(_loc18_) + " more " + KEYS.Get(_loc16_[_loc17_ - 1]);
            }
            if (!_loc4_)
            {
               if (_loc6_ < _loc8_.length)
               {
                  _loc3_ = _loc8_[_loc6_];
                  if (!_loc4_)
                  {
                     _loc18_ = 0;
                     _loc19_ = _loc11_ ? BASE._iresources : BASE._resources;
                     if (_loc3_.r1.Get() > _loc19_.r1.Get())
                     {
                        _loc17_ = 1;
                        _loc18_ = _loc3_.r1.Get() - _loc19_.r1.Get();
                     }
                     if (_loc3_.r2.Get() > _loc19_.r2.Get())
                     {
                        _loc17_ = 2;
                        _loc18_ = _loc3_.r2.Get() - _loc19_.r2.Get();
                     }
                     if (_loc3_.r3.Get() > _loc19_.r3.Get())
                     {
                        _loc17_ = 3;
                        _loc18_ = _loc3_.r3.Get() - _loc19_.r3.Get();
                     }
                     if (_loc3_.r4.Get() > _loc19_.r4.Get())
                     {
                        _loc17_ = 4;
                        _loc18_ = _loc3_.r4.Get() - _loc19_.r4.Get();
                     }
                     if (_loc17_ > 0)
                     {
                        _loc4_ = true;
                        _loc5_ = KEYS.Get("base_uperr_resources", {
                                 "v1": GLOBAL.FormatNumber(_loc18_),
                                 "v2": KEYS.Get(GLOBAL._resourceNames[_loc17_ - 1])
                              });
                     }
                  }
               }
            }
         }
         return {
               "error": _loc4_,
               "errorMessage": _loc5_,
               "costs": _loc3_,
               "needResource": _loc17_
            };
      }

      public static function CanFortify(param1:BFOUNDATION):Object
      {
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         var _loc4_:Boolean = false;
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc7_:String = null;
         var _loc8_:Array = null;
         var _loc9_:Array = null;
         var _loc10_:Array = null;
         var _loc11_:int = 0;
         var _loc12_:Vector.<Object> = null;
         var _loc13_:BFOUNDATION = null;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         if (param1._class == "mushroom")
         {
            return {"error": false};
         }
         _loc2_ = {};
         _loc3_ = {
               "r1": new SecNum(0),
               "r2": new SecNum(0),
               "r3": new SecNum(0),
               "r4": new SecNum(0),
               "time": new SecNum(0)
            };
         _loc4_ = false;
         _loc5_ = "";
         _loc6_ = param1._fortification.Get();
         for (_loc7_ in GLOBAL._buildingProps)
         {
            if (GLOBAL._buildingProps[_loc7_].id == param1._type)
            {
               _loc2_ = GLOBAL._buildingProps[_loc7_];
               break;
            }
         }
         if (!_loc2_.can_fortify)
         {
            return {"error": true};
         }
         _loc8_ = _loc2_.fortify_costs;
         if (!GLOBAL.townHall)
         {
            _loc4_ = true;
            _loc5_ = KEYS.Get("base_forterr_th");
         }
         else if (_loc6_ >= _loc8_.length)
         {
            _loc4_ = true;
            _loc5_ = KEYS.Get("base_forterr_fully");
         }
         else if (param1._countdownBuild.Get())
         {
            _loc4_ = true;
            _loc5_ = KEYS.Get("base_forterr_stillbuilding");
         }
         else if (param1._countdownUpgrade.Get())
         {
            _loc4_ = true;
            _loc5_ = KEYS.Get("base_forterr_stillupgrading");
         }
         else if (param1._countdownFortify.Get())
         {
            _loc4_ = true;
            _loc5_ = KEYS.Get("base_forterr_stillfortifying");
         }
         else
         {
            _loc9_ = [];
            for each (_loc10_ in _loc8_[_loc6_].re)
            {
               _loc11_ = 0;
               _loc12_ = InstanceManager.getInstancesByClass(BFOUNDATION);
               for each (_loc13_ in _loc12_)
               {
                  if (_loc13_._type == _loc10_[0] && _loc13_._lvl.Get() >= _loc10_[2])
                  {
                     _loc11_++;
                  }
               }
               if (_loc11_ < _loc10_[1])
               {
                  if (_loc10_[1] == 1)
                  {
                     if (_loc10_[2] == 1)
                     {
                        _loc9_.push([0, KEYS.Get("base_forterr_bdgpart1", {"v1": KEYS.Get(GLOBAL._buildingProps[_loc10_[0] - 1].name)})]);
                     }
                     else
                     {
                        _loc9_.push([0, KEYS.Get("base_forterr_bdgpart2", {
                                       "v1": _loc10_[2],
                                       "v2": KEYS.Get(GLOBAL._buildingProps[_loc10_[0] - 1].name)
                                    })]);
                     }
                  }
                  else if (_loc10_[2] == 1)
                  {
                     _loc9_.push([0, KEYS.Get("base_forterr_bdgpart3", {
                                    "v1": KEYS.Get(GLOBAL._buildingProps[_loc10_[0] - 1].name),
                                    "v2": _loc10_[1]
                                 })]);
                  }
                  else
                  {
                     _loc9_.push([0, KEYS.Get("base_forterr_bdgpart4", {
                                    "v1": _loc10_[2],
                                    "v2": KEYS.Get(GLOBAL._buildingProps[_loc10_[0] - 1].name),
                                    "v3": _loc10_[1]
                                 })]);
                  }
               }
            }
            if (_loc9_.length > 0)
            {
               _loc4_ = true;
               _loc5_ = KEYS.Get("base_forterr_buildings", {"v1": GLOBAL.Array2StringB(_loc9_)});
            }
            if (!_loc4_)
            {
               if (_loc6_ < _loc8_.length)
               {
                  _loc3_ = _loc8_[_loc6_];
                  if (!_loc4_)
                  {
                     _loc15_ = 0;
                     if (_loc3_.r1.Get() > BASE._resources.r1.Get())
                     {
                        _loc14_ = 1;
                        _loc15_ = _loc3_.r1.Get() - BASE._resources.r1.Get();
                     }
                     if (_loc3_.r2.Get() > BASE._resources.r2.Get())
                     {
                        _loc14_ = 2;
                        _loc15_ = _loc3_.r2.Get() - BASE._resources.r2.Get();
                     }
                     if (_loc3_.r3.Get() > BASE._resources.r3.Get())
                     {
                        _loc14_ = 3;
                        _loc15_ = _loc3_.r3.Get() - BASE._resources.r3.Get();
                     }
                     if (_loc3_.r4.Get() > BASE._resources.r4.Get())
                     {
                        _loc14_ = 4;
                        _loc15_ = _loc3_.r4.Get() - BASE._resources.r4.Get();
                     }
                     if (_loc14_ > 0)
                     {
                        _loc4_ = true;
                        _loc5_ = KEYS.Get("base_forterr_resources", {
                                 "v1": GLOBAL.FormatNumber(_loc15_),
                                 "v2": KEYS.Get(GLOBAL._resourceNames[_loc14_ - 1])
                              });
                     }
                  }
               }
            }
         }
         return {
               "error": _loc4_,
               "errorMessage": _loc5_,
               "costs": _loc3_,
               "needResource": _loc14_
            };
      }

      public static function is711Valid():Boolean
      {
         var _loc1_:Date = null;
         _loc1_ = new Date();
         return _loc1_.getUTCFullYear() == 2011;
      }

      public static function addBuilding(param1:MouseEvent):BFOUNDATION
      {
         var _loc2_:int = 0;
         _loc2_ = int(param1.target.name.split("b")[1]);
         return addBuildingB(_loc2_);
      }

      public static function addBuildingB(param1:int, param2:Boolean = false):BFOUNDATION
      {
         var _loc3_:* = false;
         var _loc4_:Object = null;
         BuildingDeselect();
         _loc3_ = GLOBAL._buildingProps[param1 - 1].costs[0].time.Get() == 0;
         if (!_loc3_)
         {
            _loc3_ = QUEUE.CanDo().error == false;
         }
         if (InventoryManager.buildingStorageCount(param1) > 0)
         {
            _loc3_ = true;
         }
         if (_loc3_)
         {
            _loc4_ = CanBuild(param1, param2);
            if (!_loc4_.error)
            {
               BASE.BuildingDeselect();
               ShowFootprints();
               GLOBAL._newBuilding = addBuildingC(param1);
               if (GLOBAL._newBuilding)
               {
                  GLOBAL._newBuilding._mc.alpha = 0.5;
                  GLOBAL._newBuilding.FollowMouse();
               }
               else
               {
                  BuildingDeselect();
               }
               return GLOBAL._newBuilding;
            }
            GLOBAL.Message(_loc4_.errorMessage);
         }
         else
         {
            POPUPS.DisplayWorker(0, param1);
         }
         return null;
      }

      private static function ConvertToInfernoBuilding(param1:int):int
      {
         switch (param1)
         {
            case 15:
               param1 = 128;
               break;
            case 23:
               param1 = 129;
               break;
            case 25:
               param1 = 132;
         }
         return param1;
      }

      public static function addBuildingC(buildingNum:int):BFOUNDATION
      {
         var buildingFoundation:BFOUNDATION = null;
         var buildingProperties:Object = null;
         buildingProperties = GLOBAL._buildingProps[buildingNum - 1] || {};
         if (buildingProperties.type == "decoration")
         {
            if (BTOTEM.IsTotem(buildingNum) || BTOTEM.IsTotem2(buildingNum))
            {
               buildingFoundation = new BTOTEM(buildingNum);
            }
            else
            {
               buildingFoundation = new BDECORATION(buildingNum);
            }
            return buildingFoundation;
         }
         if (buildingProperties.cls)
         {
            return new buildingProperties.cls();
         }
         if (buildingNum == 1)
         {
            buildingFoundation = new BUILDING1();
         }
         else if (buildingNum == 2)
         {
            buildingFoundation = new BUILDING2();
         }
         else if (buildingNum == 3)
         {
            buildingFoundation = new BUILDING3();
         }
         else if (buildingNum == 4)
         {
            buildingFoundation = new BUILDING4();
         }
         else if (buildingNum == 5)
         {
            buildingFoundation = new BUILDING5();
         }
         else if (buildingNum == 6)
         {
            buildingFoundation = new BUILDING6();
         }
         else if (buildingNum == 7)
         {
            buildingFoundation = new BUILDING7();
         }
         else if (buildingNum == 8)
         {
            buildingFoundation = new BUILDING8();
         }
         else if (buildingNum == 9)
         {
            buildingFoundation = new BUILDING9();
         }
         else if (buildingNum == 10)
         {
            buildingFoundation = new BUILDING10();
         }
         else if (buildingNum == 11)
         {
            buildingFoundation = new BUILDING11();
         }
         else if (buildingNum == 12)
         {
            buildingFoundation = new BUILDING12();
         }
         else if (buildingNum == 13)
         {
            buildingFoundation = new BUILDING13();
         }
         else if (buildingNum == 14)
         {
            buildingFoundation = new BUILDING14();
         }
         else if (buildingNum == 15)
         {
            buildingFoundation = new BUILDING15();
         }
         else if (buildingNum == 16)
         {
            buildingFoundation = new BUILDING16();
         }
         else if (buildingNum == 17)
         {
            buildingFoundation = new BUILDING17();
         }
         else if (buildingNum == 18)
         {
            buildingFoundation = new BUILDING18();
         }
         else if (buildingNum == 19)
         {
            buildingFoundation = new BUILDING19();
         }
         else if (buildingNum == 20)
         {
            buildingFoundation = new BUILDING20();
         }
         else if (buildingNum == 21)
         {
            buildingFoundation = new BUILDING21();
         }
         else if (buildingNum == 22)
         {
            buildingFoundation = new BUILDING22();
         }
         else if (buildingNum == 23)
         {
            buildingFoundation = new BUILDING23();
         }
         else if (buildingNum == 24)
         {
            buildingFoundation = new BUILDING24();
         }
         else if (buildingNum == 25)
         {
            buildingFoundation = new BUILDING25();
         }
         else if (buildingNum == 26)
         {
            buildingFoundation = new BUILDING26();
         }
         else if (buildingNum == 27)
         {
            buildingFoundation = new BUILDING27();
         }
         else if (buildingNum == 51)
         {
            buildingFoundation = new BUILDING51();
         }
         else if (buildingNum == 52)
         {
            buildingFoundation = new BUILDING52();
         }
         else if (buildingNum == 112)
         {
            buildingFoundation = new BUILDING112();
         }
         else if (buildingNum == 113)
         {
            buildingFoundation = new BUILDING113();
         }
         else if (buildingNum == 114)
         {
            buildingFoundation = new CHAMPIONCAGE();
         }
         else if (buildingNum == 115)
         {
            buildingFoundation = new BUILDING115();
         }
         else if (buildingNum == 116)
         {
            buildingFoundation = new MONSTERLAB();
         }
         else if (buildingNum == 117)
         {
            buildingFoundation = new BUILDING117();
         }
         else if (buildingNum == 118)
         {
            buildingFoundation = new BUILDING118();
         }
         else if (buildingNum == 119)
         {
            buildingFoundation = new CHAMPIONCHAMBER();
         }
         else if (buildingNum == 128)
         {
            buildingFoundation = new HOUSINGBUNKER();
         }
         else if (buildingNum == 127)
         {
            buildingFoundation = new INFERNOPORTAL();
         }
         else if (buildingNum == 129)
         {
            buildingFoundation = new INFERNOQUAKETOWER();
         }
         else if (buildingNum == 130)
         {
            buildingFoundation = new INFERNO_CANNON_TOWER();
         }
         else if (buildingNum == 132)
         {
            buildingFoundation = new INFERNO_MAGMA_TOWER();
         }
         return !!buildingProperties.cls ? new buildingProperties.cls() : buildingFoundation;
      }

      public static function ShowFootprints():void
      {
         var _loc1_:BFOUNDATION = null;
         var _loc2_:Vector.<Object> = null;
         _loc2_ = InstanceManager.getInstancesByClass(BFOUNDATION);
         for each (_loc1_ in _loc2_)
         {
            _loc1_.showFootprint(true);
         }
      }

      public static function HideFootprints():void
      {
         var _loc1_:BFOUNDATION = null;
         var _loc2_:Boolean = false;
         var _loc3_:Vector.<Object> = null;
         _loc2_ = GLOBAL.mode !== GLOBAL.e_BASE_MODE.ATTACK && GLOBAL.mode !== "wmattack" && GLOBAL.mode !== "iattack";
         _loc3_ = InstanceManager.getInstancesByClass(BFOUNDATION);
         for each (_loc1_ in _loc3_)
         {
            _loc1_.hideFootprint(_loc2_ || _loc1_._senderid == LOGIN._playerID);
         }
         BFOUNDATION.redrawAllShadowData();
      }

      public static function BuildingSelect(param1:BFOUNDATION, param2:Boolean = false):void
      {
         if (GLOBAL._selectedBuilding)
         {
            BuildingDeselect();
         }
         if (GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD || GLOBAL.mode == "ibuild")
         {
            if (UI2._showBottom || TUTORIAL._stage == 3 || TUTORIAL._stage == 4 || TUTORIAL._stage == 20 || TUTORIAL._stage == 21 || TUTORIAL._stage == 23)
            {
               GLOBAL._selectedBuilding = param1;
               if (param1._class != "mushroom")
               {
                  GLOBAL._selectedBuilding.showFootprint(false, true);
               }
               param1.Update();
               if (!param2)
               {
                  if (param1._type == 127 && GLOBAL.StatGet("p_id") != 1 && !MAPROOM_DESCENT.DescentPassed && !BASE.isInfernoMainYardOrOutpost)
                  {
                     INFERNO_DESCENT_POPUPS.ShowEnticePopup();
                  }
                  else
                  {
                     BUILDINGINFO.Show(param1);
                  }
               }
            }
         }
         else if (GLOBAL.mode == "help" || GLOBAL.mode == "ihelp" || LOGIN._playerID == param1._senderid)
         {
            GLOBAL._selectedBuilding = param1;
            GLOBAL._selectedBuilding.showFootprint(false);
            param1.Update();
            if (!param2)
            {
               BUILDINGINFO.Show(param1);
            }
         }
      }

      public static function BuildingDeselect():void
      {
         var _loc1_:BFOUNDATION = null;
         BUILDINGINFO.Hide();
         HideFootprints();
         if (GLOBAL._newBuilding)
         {
            GLOBAL._newBuilding.Cancel();
         }
         if (Boolean(GLOBAL._selectedBuilding) && GLOBAL._selectedBuilding._moving)
         {
            GLOBAL._selectedBuilding.StopMoveB();
         }
         if (GLOBAL._selectedBuilding)
         {
            _loc1_ = GLOBAL._selectedBuilding;
            GLOBAL._selectedBuilding = null;
            if (Boolean(_loc1_) && Boolean(_loc1_._mc))
            {
               _loc1_.Update();
               _loc1_.hideFootprint(false);
            }
            BUILDINGINFO.Hide();
         }
      }

      public static function Shake(param1:int):void
      {
         _shakeCountdown = param1;
      }

      public static function ShakeB():void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if (_shakeCountdown > 0)
         {
            --_shakeCountdown;
            _loc1_ = int(_shakeCountdown / 10 - Math.random() * (_shakeCountdown / 5));
            _loc2_ = int(_shakeCountdown / 10 - Math.random() * (_shakeCountdown / 5));
            MAP._GROUND.x += _loc1_;
            MAP._GROUND.y += _loc2_;
         }
      }

      public static function Charge(param1:int, param2:Number, param3:Boolean = false, param4:Boolean = false):int
      {
         var _loc5_:Object = null;
         var _loc6_:Object = null;
         var _loc7_:Object = null;
         param2 = Math.floor(param2);
         if (param4 && isInfernoMainYardOrOutpost)
         {
            param4 = false;
         }
         _loc5_ = param4 ? _ideltaResources : _deltaResources;
         _loc6_ = GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD || GLOBAL.mode == "ibuild" ? (param4 ? _iresources : _resources) : GLOBAL._attackersResources;
         _loc7_ = GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD || GLOBAL.mode == "ibuild" ? _hpResources : GLOBAL._hpAttackersResources;
         if (param2 <= _loc6_["r" + param1].Get())
         {
            if (!param3)
            {
               _loc6_["r" + param1].Add(-param2);
               if (!param4)
               {
                  _loc7_["r" + param1] -= param2;
               }
               if (GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD || GLOBAL.mode == "ibuild")
               {
                  if (param4)
                  {
                     if (_loc5_["r" + param1])
                     {
                        _loc5_["r" + param1].Add(Math.floor(-param2));
                     }
                     else
                     {
                        _loc5_["r" + param1] = new SecNum(Math.floor(-param2));
                     }
                     _loc5_.dirty = true;
                     GLOBAL._resources["r" + param1].Add(-param2);
                     GLOBAL._hpResources["r" + param1] -= param2;
                  }
                  else
                  {
                     if (_loc5_["r" + param1])
                     {
                        _loc5_["r" + param1].Add(Math.floor(-param2));
                        _hpDeltaResources["r" + param1] += Math.floor(-param2);
                     }
                     else
                     {
                        _loc5_["r" + param1] = new SecNum(Math.floor(-param2));
                        _hpDeltaResources["r" + param1] = Math.floor(-param2);
                     }
                     _loc5_.dirty = true;
                     _hpDeltaResources.dirty = true;
                     GLOBAL._resources["r" + param1].Add(-param2);
                     GLOBAL._hpResources["r" + param1] -= param2;
                  }
               }
               else
               {
                  if (GLOBAL._attackersDeltaResources["r" + param1])
                  {
                     GLOBAL._attackersDeltaResources["r" + param1].Add(Math.floor(-param2));
                  }
                  else
                  {
                     GLOBAL._attackersDeltaResources["r" + param1] = new SecNum(Math.floor(-param2));
                  }
                  GLOBAL._attackersDeltaResources.dirty = true;
               }
               if (GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD || GLOBAL.mode == "ibuild")
               {
               }
               CalcResources();
            }
            return param2;
         }
         return 0;
      }

      public static function Fund(param1:int, param2:Number, param3:Boolean = false, param4:BFOUNDATION = null, param5:Boolean = false, param6:Boolean = true):Number
      {
         var _loc7_:Object = null;
         var _loc8_:Object = null;
         var _loc9_:Object = null;
         var _loc10_:String = null;
         var _loc11_:* = null;
         var _loc12_:Number = NaN;
         param2 = Math.floor(param2);
         if (param5 && isInfernoMainYardOrOutpost)
         {
            param5 = false;
         }
         if (param1 < 5)
         {
            _loc7_ = param5 ? _iresources : _resources;
            _loc8_ = param5 ? _ideltaResources : _deltaResources;
            _loc9_ = param5 ? {} : _hpDeltaResources;
            _loc10_ = "r" + param1;
            _loc11_ = "r" + param1 + "max";
            _loc12_ = 0;
            if (_loc7_[_loc10_].Get() < _loc7_[_loc11_] || param3)
            {
               if (_loc7_[_loc10_].Get() + param2 < _loc7_[_loc11_] || param3)
               {
                  _loc7_[_loc10_].Add(param2);
                  if (!param5)
                  {
                     _hpResources[_loc10_] += param2;
                  }
                  if (_loc8_[_loc10_])
                  {
                     _loc8_[_loc10_].Add(param2);
                     _loc9_[_loc10_] += param2;
                  }
                  else
                  {
                     _loc8_[_loc10_] = new SecNum(param2);
                     _loc9_[_loc10_] = param2;
                  }
                  if (GLOBAL.mode === GLOBAL.e_BASE_MODE.BUILD || GLOBAL.mode === GLOBAL.e_BASE_MODE.IBUILD)
                  {
                     GLOBAL._resources[_loc10_].Add(param2);
                     GLOBAL._hpResources[_loc10_] += param2;
                  }
                  _loc8_.dirty = true;
                  _loc9_.dirty = true;
                  _loc12_ = param2;
               }
               else
               {
                  _loc12_ = _loc7_[_loc11_] - _loc7_[_loc10_].Get();
                  _loc7_[_loc10_].Set(_loc7_[_loc11_]);
                  if (!param5)
                  {
                     _hpResources[_loc10_] = _loc7_[_loc11_];
                  }
                  if (_loc8_[_loc10_])
                  {
                     _loc8_[_loc10_].Add(Math.floor(_loc12_));
                     _loc9_[_loc10_] += Math.floor(_loc12_);
                  }
                  else
                  {
                     _loc8_[_loc10_] = new SecNum(Math.floor(_loc12_));
                     _loc9_[_loc10_] = Math.floor(_loc12_);
                  }
                  if (GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD || GLOBAL.mode === GLOBAL.e_BASE_MODE.IBUILD)
                  {
                     GLOBAL._resources[_loc10_].Add(Math.floor(_loc12_));
                     GLOBAL._hpResources[_loc10_] += Math.floor(_loc12_);
                  }
                  _loc8_.dirty = true;
                  _loc9_.dirty = true;
               }
               _bankedValue += _loc12_;
               _bankedTime = GLOBAL.Timestamp();
               if ((GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD || GLOBAL.mode === GLOBAL.e_BASE_MODE.IBUILD) && !param5)
               {
               }
            }
            else if ((GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD || GLOBAL.mode === GLOBAL.e_BASE_MODE.IBUILD) && !param5 && !WMATTACK._inProgress && param6)
            {
               UI2._top.OverchargeShow(param1);
            }
            if (param4)
            {
               param4._stored.Add(-_loc12_);
               if (!param4._producing)
               {
                  param4.StartProduction();
               }
               param4.Update();
            }
            if (_loc12_ > 0 && (GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD || GLOBAL.mode === GLOBAL.e_BASE_MODE.IBUILD) && param6)
            {
               Save();
            }
         }
         UI2.Update();
         return _loc12_;
      }

      private static function JiggleResource(param1:int, param2:Number):void
      {
         var _loc3_:MovieClip = null;
         var _loc4_:TextField = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         if (param2 == 0)
         {
            return;
         }
         _loc3_ = UI2._top.mc["mcR" + param1];
         _loc3_.x = -15;
         TweenLite.to(_loc3_, 0.6, {
                  "x": 0,
                  "ease": Elastic.easeOut
               });
         if (BASE.isInfernoMainYardOrOutpost)
         {
            return;
         }
         _loc4_ = _loc3_.mcPoints.txt;
         if (param2 >= 0)
         {
            _loc5_ = "00FF00";
            _loc6_ = "+";
         }
         else
         {
            _loc5_ = "FF0000";
            _loc6_ = "-";
         }
         _loc4_.y = 0;
         _loc4_.x = 0;
         _loc3_.mcPoints.alpha = 1;
         _loc4_.alpha = 1;
         _loc4_.htmlText = "<font color=\"#" + _loc5_ + "\">" + _loc6_ + GLOBAL.FormatNumber(param2) + "</font>";
         TweenLite.to(_loc4_, 3 + Math.random(), {
                  "y": _loc4_.y - (15 + Math.random() * 10),
                  "x": Math.random() * 10,
                  "alpha": 0
               });
      }

      public static function SaveDeltaResources():void
      {
         var _loc1_:int = 0;
         if (_deltaResources.dirty)
         {
            _loc1_ = 1;
            while (_loc1_ < 5)
            {
               if (_deltaResources["r" + _loc1_])
               {
                  if (_deltaResources["r" + _loc1_].Get() != _hpDeltaResources["r" + _loc1_])
                  {
                     LOGGER.Log("log", "Delta resources r" + _loc1_ + " secure " + _deltaResources["r" + _loc1_] + " unsecure " + _hpDeltaResources["r" + _loc1_]);
                     GLOBAL.ErrorMessage("BASE.SaveDeltaResources");
                  }
                  if (_savedDeltaResources["r" + _loc1_])
                  {
                     _savedDeltaResources["r" + _loc1_].Add(_deltaResources["r" + _loc1_].Get());
                  }
                  else
                  {
                     _savedDeltaResources["r" + _loc1_] = new SecNum(_deltaResources["r" + _loc1_].Get());
                  }
               }
               _loc1_++;
            }
         }
         _deltaResources = {"dirty": false};
         _hpDeltaResources = {"dirty": false};
      }

      public static function CleanDeltaResources():void
      {
         _savedDeltaResources = {
               "r1": new SecNum(0),
               "r2": new SecNum(0),
               "r3": new SecNum(0),
               "r4": new SecNum(0)
            };
         _ideltaResources.r1.Set(0);
         _ideltaResources.r2.Set(0);
         _ideltaResources.r3.Set(0);
         _ideltaResources.r4.Set(0);
      }

      public static function BuildBlockers(param1:BFOUNDATION, param2:Boolean = false):String
      {
         if (GRID.FootprintBlocked(param1._footprint, new Point(param1._mc.x, param1._mc.y), true, param2))
         {
            return "overlap";
         }
         return "";
      }

      public static function CountBuildings():void
      {
         var _loc1_:int = 0;
         var _loc2_:Vector.<Object> = null;
         var _loc3_:BFOUNDATION = null;
         _buildingCounts = {};
         _loc1_ = 0;
         while (_loc1_ < GLOBAL._buildingProps.length)
         {
            _buildingCounts["b" + (_loc1_ + 1)] = 0;
            _loc1_++;
         }
         _loc2_ = InstanceManager.getInstancesByClass(BFOUNDATION);
         for each (_loc3_ in _loc2_)
         {
            ++_buildingCount["b" + _loc3_._type];
         }
      }

      public static function LoadNext(param1:MouseEvent = null):void
      {
         var _loc2_:Number = NaN;
         var _loc3_:int = 0;
         if (_saving || _loading || BASE._saveCounterA != BASE._saveCounterB)
         {
            GLOBAL._nextOutpostWaiting = 1;
            return;
         }
         if (MapRoomManager.instance.isInMapRoom2)
         {
            if (isMainYard && !GLOBAL._bMap._canFunction)
            {
               GLOBAL.Message(KEYS.Get("map_msg_damaged"));
               return;
            }
            if (Boolean(GLOBAL._mapOutpostIDs) && GLOBAL._mapOutpostIDs.length > 0)
            {
               if (GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD || GLOBAL.mode == "ibuild")
               {
                  if (isMainYardOrInfernoMainYard)
                  {
                     _currentCellLoc = GLOBAL._mapOutpost[0];
                     GLOBAL._currentCell = null;
                     _needCurrentCell = true;
                     MapRoomManager.instance.LoadCell(GLOBAL._mapOutpost[0].x, GLOBAL._mapOutpost[0].y, true);
                     PLEASEWAIT.Show(KEYS.Get("process_outpost"));
                  }
                  else
                  {
                     _loc2_ = 0;
                     _loc3_ = 0;
                     while (_loc3_ < GLOBAL._mapOutpostIDs.length)
                     {
                        if (GLOBAL._mapOutpostIDs[_loc3_] == _loadedBaseID)
                        {
                           if (_loc3_ < GLOBAL._mapOutpostIDs.length - 1)
                           {
                              _currentCellLoc = GLOBAL._mapOutpost[_loc3_ + 1];
                              GLOBAL._currentCell = null;
                              _needCurrentCell = true;
                              MapRoomManager.instance.LoadCell(GLOBAL._mapOutpost[_loc3_ + 1].x, GLOBAL._mapOutpost[_loc3_ + 1].y, true);
                              PLEASEWAIT.Show(KEYS.Get("process_outpost"));
                              break;
                           }
                           _needCurrentCell = false;
                           GLOBAL._currentCell = null;
                           LoadBase(null, 0, GLOBAL._homeBaseID, GLOBAL.e_BASE_MODE.BUILD, false, EnumYardType.MAIN_YARD);
                           break;
                        }
                        _loc3_++;
                     }
                  }
               }
            }
         }
      }

      public static function CalcResources():void
      {
         var _loc1_:Number = NaN;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Vector.<Object> = null;
         var _loc6_:BFOUNDATION = null;
         var _loc7_:ResourceCapacityBaseBuff = null;
         var _loc8_:int = 0;
         if (isOutpostOrInfernoOutpost)
         {
            if (GLOBAL.mode != GLOBAL.e_BASE_MODE.BUILD || MapRoomManager.instance.isInMapRoom3)
            {
               return;
            }
         }
         else
         {
            _resources.r1max = 10000;
            _resources.r2max = 10000;
            _resources.r3max = 10000;
            _resources.r4max = 10000;
         }
         if (_resources.r1.Get() > 25000000 && _resources.r2.Get() > 25000000 && _resources.r3.Get() > 25000000 && _resources.r4.Get() > 25000000)
         {
            ACHIEVEMENTS.Check("stockpile", 1);
         }
         _resources.r1Rate = 0;
         _resources.r2Rate = 0;
         _resources.r3Rate = 0;
         _resources.r4Rate = 0;
         _loc5_ = InstanceManager.getInstancesByClass(BRESOURCE);
         for each (_loc6_ in _loc5_)
         {
            _loc3_ = int(_loc6_._type);
            _loc4_ = _loc6_._lvl.Get();
            if (isOutpost && Boolean(GLOBAL._currentCell))
            {
               if (Boolean(_loc6_._countdownUpgrade) && _loc6_._countdownUpgrade.Get() > 0)
               {
                  _loc4_++;
               }
            }
            switch (_loc3_)
            {
               case 1:
                  if (isOutpost && Boolean(GLOBAL._currentCell))
                  {
                     _resources.r1Rate += int(BRESOURCE.AdjustProduction(GLOBAL._currentCell, GLOBAL._buildingProps[_loc3_ - 1].produce[_loc4_ - 1]) / GLOBAL._buildingProps[_loc3_ - 1].cycleTime[_loc4_ - 1] * 60 * 60);
                  }
                  else
                  {
                     _resources.r1Rate += int(GLOBAL._buildingProps[_loc3_ - 1].produce[_loc4_ - 1] / GLOBAL._buildingProps[_loc3_ - 1].cycleTime[_loc4_ - 1] * 60 * 60);
                  }
                  break;
               case 2:
                  if (isOutpost && Boolean(GLOBAL._currentCell))
                  {
                     _resources.r2Rate += int(BRESOURCE.AdjustProduction(GLOBAL._currentCell, GLOBAL._buildingProps[_loc3_ - 1].produce[_loc4_ - 1]) / GLOBAL._buildingProps[_loc3_ - 1].cycleTime[_loc4_ - 1] * 60 * 60);
                  }
                  else
                  {
                     _resources.r2Rate += int(GLOBAL._buildingProps[_loc3_ - 1].produce[_loc4_ - 1] / GLOBAL._buildingProps[_loc3_ - 1].cycleTime[_loc4_ - 1] * 60 * 60);
                  }
                  break;
               case 3:
                  if (isOutpost && Boolean(GLOBAL._currentCell))
                  {
                     _resources.r3Rate += int(BRESOURCE.AdjustProduction(GLOBAL._currentCell, GLOBAL._buildingProps[_loc3_ - 1].produce[_loc4_ - 1]) / GLOBAL._buildingProps[_loc3_ - 1].cycleTime[_loc4_ - 1] * 60 * 60);
                  }
                  else
                  {
                     _resources.r3Rate += int(GLOBAL._buildingProps[_loc3_ - 1].produce[_loc4_ - 1] / GLOBAL._buildingProps[_loc3_ - 1].cycleTime[_loc4_ - 1] * 60 * 60);
                  }
                  break;
               case 4:
                  if (isOutpost && Boolean(GLOBAL._currentCell))
                  {
                     _resources.r4Rate += int(BRESOURCE.AdjustProduction(GLOBAL._currentCell, GLOBAL._buildingProps[_loc3_ - 1].produce[_loc4_ - 1]) / GLOBAL._buildingProps[_loc3_ - 1].cycleTime[_loc4_ - 1] * 60 * 60);
                  }
                  else
                  {
                     _resources.r4Rate += int(GLOBAL._buildingProps[_loc3_ - 1].produce[_loc4_ - 1] / GLOBAL._buildingProps[_loc3_ - 1].cycleTime[_loc4_ - 1] * 60 * 60);
                  }
                  break;
            }
         }
         _loc5_ = InstanceManager.getInstancesByClass(BUILDING6);
         for each (_loc6_ in _loc5_)
         {
            if (_loc6_._lvl.Get() >= 1 && isMainYardOrInfernoMainYard)
            {
               _loc3_ = _loc6_._type;
               _resources.r1max += GLOBAL._buildingProps[_loc3_ - 1].capacity[_loc6_._lvl.Get() - 1];
               _resources.r2max += GLOBAL._buildingProps[_loc3_ - 1].capacity[_loc6_._lvl.Get() - 1];
               _resources.r3max += GLOBAL._buildingProps[_loc3_ - 1].capacity[_loc6_._lvl.Get() - 1];
               _resources.r4max += GLOBAL._buildingProps[_loc3_ - 1].capacity[_loc6_._lvl.Get() - 1];
            }
         }
         if (MapRoomManager.instance.isInMapRoom3 && isMainYardOrInfernoMainYard && BaseBuffHandler.instance.isInitialized)
         {
            _loc7_ = BaseBuffHandler.instance.getBuffByName(ResourceCapacityBaseBuff.k_NAME) as ResourceCapacityBaseBuff;
            if (_loc7_)
            {
               _loc2_ = 1;
               while (_loc2_ < 5)
               {
                  _resources["r" + _loc2_ + "max"] += _loc7_.value;
                  _loc2_++;
               }
            }
         }
         if (GLOBAL._harvesterOverdrive >= GLOBAL.Timestamp() && GLOBAL._harvesterOverdrivePower.Get() > 0)
         {
            _resources.r1Rate *= GLOBAL._harvesterOverdrivePower.Get();
            _resources.r2Rate *= GLOBAL._harvesterOverdrivePower.Get();
            _resources.r3Rate *= GLOBAL._harvesterOverdrivePower.Get();
            _resources.r4Rate *= GLOBAL._harvesterOverdrivePower.Get();
         }
         if (isMainYardOrInfernoMainYard)
         {
            _loc2_ = 1;
            while (_loc2_ < 5)
            {
               _resources["r" + _loc2_ + "max"] *= GLOBAL._upgradePacking;
               _resources["r" + _loc2_ + "max"] = Math.floor(_resources["r" + _loc2_ + "max"]);
               if (GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD && isMainYardOrInfernoMainYard)
               {
                  GLOBAL._yardResources["r" + _loc2_ + "max"] = _resources["r" + _loc2_ + "max"];
                  GLOBAL._yardResources["r" + _loc2_ + "Rate"] = _resources["r" + _loc2_ + "Rate"];
               }
               _loc2_++;
            }
         }
         if (GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD)
         {
            _loc8_ = 1;
            while (_loc8_ < 5)
            {
               if (MapRoomManager.instance.isInMapRoom2 && !BASE.isInfernoMainYardOrOutpost)
               {
                  GLOBAL._resources["r" + _loc8_ + "max"] = GLOBAL._yardResources["r" + _loc8_ + "max"] + GLOBAL._mapOutpost.length * GLOBAL._outpostCapacity.Get();
                  _resources["r" + _loc8_ + "max"] = GLOBAL._resources["r" + _loc8_ + "max"];
               }
               else
               {
                  GLOBAL._resources["r" + _loc8_ + "max"] = GLOBAL._yardResources["r" + _loc8_ + "max"];
               }
               _loc8_++;
            }
         }
         UI2.Update();
      }

      public static function CalcBaseValue():Number
      {
         var _loc1_:Boolean = false;
         var _loc2_:Vector.<Object> = null;
         var _loc3_:BFOUNDATION = null;
         var _loc4_:Number = NaN;
         var _loc5_:int = 0;
         var _loc6_:Object = null;
         var _loc7_:Object = null;
         _loc1_ = isOutpost;
         _loc2_ = InstanceManager.getInstancesByClass(BFOUNDATION);
         _loc4_ = 0;
         for each (_loc3_ in _loc2_)
         {
            if (_loc3_._class != "decoration" && _loc3_._class != "enemy" && _loc3_._class != "immovable" && _loc3_._class != "trap" && _loc3_ !== GLOBAL._newBuilding && (_loc1_ || _loc3_._countdownBuild.Get() <= 0))
            {
               _loc5_ = _loc3_._lvl.Get();
               if (_loc5_ <= 0)
               {
                  _loc5_ = 1;
               }
               if (Boolean(_loc6_ = GLOBAL._buildingProps[_loc3_._type - 1]) && Boolean(_loc6_.costs[_loc5_ - 1]))
               {
                  _loc7_ = _loc6_.costs[_loc5_ - 1];
                  _loc4_ += _loc7_.time.Get() + _loc7_.r1.Get() + _loc7_.r2.Get() + _loc7_.r3.Get() + _loc7_.r4.Get();
               }
            }
         }
         _loc4_ = Math.ceil(_loc4_ * 0.1);
         if (isOutpostOrInfernoOutpost)
         {
            _outpostValue = _loc4_;
         }
         if (_loc4_ > _baseValue && isMainYardOrInfernoMainYard)
         {
            _baseValue = _loc4_;
         }
         return _loc4_;
      }

      public static function PointsAdd(param1:uint):void
      {
         _basePoints = Math.floor(_basePoints + param1);
      }

      public static function BaseLevel():Object
      {
         var points:Number = NaN;
         var lvl:Object = null;
         var length:int = 0;
         var i:int = 0;
         var mc:popup_levelup = null;
         var title:String = null;
         var body:String = null;
         var StreamPost:Function = null;
         CalcBaseValue();
         points = _basePoints + Number(_baseValue);
         lvl = {
               "level": 0,
               "lower": 0,
               "upper": 0,
               "leveled": false
            };
         length = int(s_levels.length - 1);
         lvl.points = points;
         while (i < length)
         {
            if (points >= s_levels[i])
            {
               lvl.level = i + 1;
               lvl.lower = s_levels[i];
               lvl.upper = s_levels[i + 1];
               lvl.needed = lvl.upper - points;
            }
            i++;
         }
         if (GLOBAL._render && lvl.level > _baseLevel && lvl.level > 1 && GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD)
         {
            if (_baseLevel > 0)
            {
               lvl.leveled = true;
               if (TUTORIAL._stage > 200)
               {
                  StreamPost = function(param1:MouseEvent):void
                  {
                     GLOBAL.CallJS("sendFeed", ["levelup" + lvl.level, KEYS.Get(title, {"v1": lvl.level}), KEYS.Get(body), "levelup/levelup" + lvl.level + ".v2.png"]);
                     POPUPS.Next();
                  };
                  mc = new popup_levelup();
                  title = "pop_levelup_streamtitle";
                  body = "pop_levelup_body";
                  if (BASE.isInfernoMainYardOrOutpost)
                  {
                     title = "inf_pop_levelup_streamtitle";
                     body = "inf_pop_levelup_body";
                  }
                  mc.title_txt.htmlText = "<b>" + KEYS.Get("pop_levelup_title") + "</b>";
                  mc.headline_txt.htmlText = KEYS.Get("pop_levelup_headline", {"v1": lvl.level});
                  mc.body_txt.htmlText = KEYS.Get("pop_levelup_body");
                  mc.bPost.SetupKey("btn_brag");
                  mc.bPost.addEventListener(MouseEvent.CLICK, StreamPost);
                  mc.bPost.Highlight = true;
                  POPUPS.Push(mc, null, null, "levelup", "levelup.v2.png");
               }
            }
            _baseLevel = lvl.level;
            LOGGER.Stat([33, _baseLevel]);
         }
         if (lvl.leveled)
         {
            BASE.Save();
            if (Chat._bymChat)
            {
               Chat._bymChat.broadcastDisplayNameUpdate(lvl.level);
            }
         }
         if (GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD)
         {
            LOGIN._playerLevel = lvl.level;
         }
         return lvl;
      }

      public static function GetBuildingOverlap(param1:Number, param2:Number, param3:Number, param4:Vector.<BFOUNDATION>):void
      {
         var _loc5_:Point = null;
         var _loc6_:Vector.<Object> = null;
         var _loc7_:BFOUNDATION = null;
         var _loc8_:Point = null;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         _loc5_ = new Point(param1, param2);
         _loc6_ = InstanceManager.getInstancesByClass(BFOUNDATION);
         for each (_loc7_ in _loc6_)
         {
            if (!(_loc7_ is BMUSHROOM))
            {
               _loc8_ = new Point(_loc7_._mc.x, _loc7_._mc.y + _loc7_._middle);
               _loc9_ = Math.atan2(_loc5_.y - _loc8_.y, _loc5_.x - _loc8_.x);
               _loc10_ = EllipseEdgeDistance(_loc9_, param3, param3 * _angle);
               _loc9_ = Math.atan2(_loc8_.y - _loc5_.y, _loc8_.x - _loc5_.x);
               _loc11_ = EllipseEdgeDistance(_loc9_, _loc7_._size * 0.5, _loc7_._size * 0.5 * _angle);
               _loc12_ = _loc5_.x - _loc8_.x;
               _loc13_ = _loc5_.y - _loc8_.y;
               _loc14_ = int(Math.sqrt(_loc12_ * _loc12_ + _loc13_ * _loc13_));
               if (_loc14_ < _loc10_ + _loc11_)
               {
                  param4.push(_loc7_);
               }
            }
         }
      }

      public static function BuildingOverlap(param1:Point, param2:int, param3:Boolean, param4:Boolean = false, param5:Boolean = false, param6:Boolean = false):Boolean
      {
         var _loc7_:Vector.<Object> = null;
         var _loc8_:BFOUNDATION = null;
         var _loc9_:Point = null;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:int = 0;
         _loc7_ = InstanceManager.getInstancesByClass(BFOUNDATION);
         for each (_loc8_ in _loc7_)
         {
            if (!(_loc8_ is BMUSHROOM))
            {
               _loc9_ = new Point(_loc8_._mc.x, _loc8_._mc.y + _loc8_._middle);
               if (!(param3 && _loc8_._class == "trap" || param4 && _loc8_.health <= 0 || param5 && _loc8_._class == "decoration" || param6 && (_loc8_._class == "immovable" || _loc8_._class == "enemy")))
               {
                  _loc10_ = Math.atan2(param1.y - _loc9_.y, param1.x - _loc9_.x);
                  _loc11_ = EllipseEdgeDistance(_loc10_, param2, param2 * _angle);
                  _loc10_ = Math.atan2(_loc9_.y - param1.y, _loc9_.x - param1.x);
                  _loc12_ = EllipseEdgeDistance(_loc10_, _loc8_._size * 0.5, _loc8_._size * 0.5 * _angle);
                  _loc13_ = param1.x - _loc9_.x;
                  _loc14_ = param1.y - _loc9_.y;
                  _loc15_ = int(Math.sqrt(_loc13_ * _loc13_ + _loc14_ * _loc14_));
                  if (_loc15_ < _loc11_ + _loc12_)
                  {
                     return true;
                  }
               }
            }
         }
         return false;
      }

      public static function EllipseEdgeDistance(param1:Number, param2:int, param3:int):Number
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         _loc4_ = Math.pow(Math.pow(param2 / 2, -2) + Math.pow(Math.tan(param1), 2) * Math.pow(param3 / 2, -2), -0.5);
         _loc5_ = param1 * 180 / Math.PI;
         if (_loc5_ < -90 || _loc5_ > 90)
         {
            _loc4_ *= -1;
         }
         _loc6_ = Math.tan(param1) * _loc4_;
         return Math.sqrt(_loc4_ * _loc4_ + _loc6_ * _loc6_);
      }

      public static function EllipseEdgeDistanceSqrd(param1:Number, param2:int, param3:int):Number
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         _loc4_ = Math.pow(Math.pow(param2 / 2, -2) + Math.pow(Math.tan(param1), 2) * Math.pow(param3 / 2, -2), -0.5);
         _loc5_ = param1 * 180 / Math.PI;
         if (_loc5_ < -90 || _loc5_ > 90)
         {
            _loc4_ *= -1;
         }
         _loc6_ = Math.tan(param1) * _loc4_;
         return _loc4_ * _loc4_ + _loc6_ * _loc6_;
      }

      public static function InsideCircle(param1:Point, param2:int):Boolean
      {
         return true;
      }

      public static function applyTemplate(param1:BaseTemplate):void
      {
         var _loc2_:int = 0;
         var _loc3_:BaseTemplateNode = null;
         var _loc4_:Point = null;
         var _loc5_:BFOUNDATION = null;
         _loc2_ = 0;
         while (_loc2_ < param1.nodes.length)
         {
            _loc3_ = param1.nodes[_loc2_];
            _loc4_ = GRID.ToISO(_loc3_.x, _loc3_.y, 0);
            _loc5_ = getBuildingFromNode(_loc3_);
            if (_loc5_)
            {
               _loc5_.moveTo(_loc4_.x, _loc4_.y);
            }
            _loc2_++;
         }
         Save();
      }

      private static function getBuildingFromNode(param1:BaseTemplateNode):BFOUNDATION
      {
         var _loc3_:BFOUNDATION = null;
         var _loc4_:int = 0;
         var _loc5_:Object = null;
         var _loc2_:Point = GRID.ToISO(param1.x, param1.y, 0);
         if (param1.id == PlannerTemplate._DECORATION_ID)
         {
            _loc4_ = int(param1.type);
            _loc3_ = addBuildingC(_loc4_);
            _loc5_ = {
                  "X": param1.x,
                  "Y": param1.y,
                  "t": _loc4_,
                  "id": BASE._buildingCount++
               };
            if (_buildingsStored["bl" + _loc4_])
            {
               _loc5_.l = _buildingsStored["bl" + _loc4_].Get();
            }
            _loc3_.Setup(_loc5_);
            param1.id = _loc3_._id;
            _buildingsStored["b" + _loc4_].Set(_buildingsStored["b" + _loc4_].Get() - 1);
         }
         else
         {
            _loc3_ = getBuildingByID(param1.id);
         }
         return _loc3_;
      }

      public static function getTemplate():BaseTemplate
      {
         var _loc1_:BaseTemplate = null;
         var _loc2_:Vector.<BFOUNDATION> = null;
         var _loc3_:BFOUNDATION = null;
         var _loc4_:Point = null;
         _loc1_ = new BaseTemplate();
         _loc1_.name = _baseName;
         _loc2_ = getYardPlannerBuildings();
         for each (_loc3_ in _loc2_)
         {
            _loc4_ = GRID.FromISO(_loc3_.x, _loc3_.y);
            _loc1_.addNode(new BaseTemplateNode(_loc4_.x, _loc4_.y, _loc3_._id, _loc3_._type));
         }
         return _loc1_;
      }

      public static function getYardPlannerBuildings():Vector.<BFOUNDATION>
      {
         var _loc1_:Vector.<Object> = null;
         var _loc2_:Vector.<BFOUNDATION> = null;
         var _loc3_:BFOUNDATION = null;
         _loc1_ = InstanceManager.getInstancesByClass(BFOUNDATION);
         _loc2_ = new Vector.<BFOUNDATION>();
         for each (_loc3_ in _loc1_)
         {
            if (_loc3_._type != 7)
            {
               _loc2_.push(_loc3_);
            }
         }
         return _loc2_;
      }

      public static function isBuildingIgnoredInYardPlannerSave(param1:BFOUNDATION):Boolean
      {
         return param1._class == "enemy";
      }

      public static function getBuildingByID(param1:uint):BFOUNDATION
      {
         var _loc2_:Vector.<Object> = null;
         var _loc3_:BFOUNDATION = null;
         _loc2_ = InstanceManager.getInstancesByClass(BFOUNDATION);
         for each (_loc3_ in _loc2_)
         {
            if (_loc3_._id == param1)
            {
               return _loc3_;
            }
         }
         return null;
      }

      public static function RebuildTH(param1:Boolean = false):void
      {
         var _loc2_:Point = null;
         var _loc3_:BFOUNDATION = null;
         var _loc4_:int = 0;
         if (!isMainYard && m_yardType !== EnumYardType.INFERNO_YARD)
         {
            return;
         }
         if (!param1 && (GLOBAL.townHall is ResourceOutpost || GLOBAL.townHall is GuardTower || GLOBAL.townHall is OutpostDefender))
         {
            return;
         }
         CalcBaseValue();
         if (BASE._basePoints + BASE._baseValue >= 2000000)
         {
            _loc4_ = CaluclateExpectedTownHallLevel();
            if (GLOBAL.townHall)
            {
               if (GLOBAL.townHall._lvl.Get() < _loc4_)
               {
                  if (GLOBAL.townHall._countdownUpgrade.Get() > 0)
                  {
                     GLOBAL.townHall.Upgraded();
                     _loc4_ = CaluclateExpectedTownHallLevel();
                  }
                  if (GLOBAL.townHall._lvl.Get() < _loc4_)
                  {
                     GLOBAL.townHall._lvl.Set(_loc4_ - 1);
                     GLOBAL.townHall.Upgraded();
                  }
               }
            }
            else
            {
               _loc2_ = new Point(-800, -40);
               _loc3_ = BASE.addBuildingC(14);
               ++BASE._buildingCount;
               _loc3_.Setup({
                        "t": 14,
                        "X": _loc2_.x,
                        "Y": _loc2_.y,
                        "id": BASE._buildingCount,
                        "l": _loc4_
                     });
               _loc2_ = GRID.ToISO(_loc2_.x, _loc2_.y, 0);
               MAP.FocusTo(_loc2_.x, _loc2_.y, 2);
               GLOBAL.Message(KEYS.Get("msg_rebuildTH"));
            }
         }
         else if (!GLOBAL.townHall || param1)
         {
            _loc2_ = new Point(-800, -40);
            _loc3_ = BASE.addBuildingC(14);
            ++BASE._buildingCount;
            _loc4_ = CaluclateExpectedTownHallLevel();
            _loc3_.Setup({
                     "t": 14,
                     "X": _loc2_.x,
                     "Y": _loc2_.y,
                     "id": BASE._buildingCount,
                     "l": _loc4_
                  });
            _loc2_ = GRID.ToISO(_loc2_.x, _loc2_.y, 0);
            MAP.FocusTo(_loc2_.x, _loc2_.y, 2);
            GLOBAL.Message(KEYS.Get("msg_rebuildTH"));
         }
      }

      private static function CaluclateExpectedTownHallLevel():int
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:BFOUNDATION = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc17_:int = 0;
         var _loc18_:int = 0;
         var _loc19_:int = 0;
         var _loc20_:int = 0;
         var _loc21_:int = 0;
         var _loc22_:int = 0;
         var _loc23_:int = 0;
         var _loc24_:int = 0;
         var _loc25_:int = 0;
         var _loc26_:int = 0;
         var _loc27_:int = 0;
         var _loc28_:Boolean = false;
         var _loc29_:int = 0;
         var _loc30_:int = 0;
         var _loc31_:int = 0;
         var _loc32_:int = 0;
         var _loc33_:Vector.<Object> = null;
         var _loc34_:BFOUNDATION = null;
         _loc1_ = 1;
         _loc6_ = 0;
         _loc16_ = 0;
         _loc27_ = 0;
         _loc28_ = false;
         _loc32_ = 0;
         _loc33_ = InstanceManager.getInstancesByClass(BTOWER);
         for each (_loc34_ in _loc33_)
         {
            if (_loc34_._type == 20)
            {
               _loc3_++;
            }
            if (_loc34_._type == 21)
            {
               _loc2_++;
            }
            if (_loc34_._type == 129)
            {
               _loc5_++;
            }
            if (_loc34_._type == 130)
            {
               _loc4_++;
            }
            if (_loc34_._type == 132)
            {
               _loc6_++;
            }
         }
         for each (_loc7_ in buildings)
         {
            if ((_loc7_._type == 1 || _loc7_._type == 2 || _loc7_._type == 3 || _loc7_._type == 4) && _loc26_ < _loc7_._hpLvl)
            {
               _loc26_ = _loc7_._hpLvl;
            }
            else if (_loc7_._type == 5)
            {
               _loc17_ = _loc7_._hpLvl;
            }
            else if (_loc7_._type == 6 && _loc27_ < _loc7_._hpLvl)
            {
               _loc27_ = _loc7_._hpLvl;
            }
            else if (_loc7_._type == 8)
            {
               _loc19_ = _loc7_._hpLvl;
            }
            else if (_loc7_._type == 9)
            {
               _loc8_ = _loc7_._hpLvl;
            }
            else if (_loc7_._type == 10)
            {
               _loc10_ = _loc7_._hpLvl;
            }
            else if (_loc7_._type == 13 && _loc20_ < _loc7_._hpLvl)
            {
               _loc20_ = _loc7_._hpLvl;
            }
            else if (_loc7_._type == 15 && _loc21_ < _loc7_._hpLvl)
            {
               _loc21_ = _loc7_._hpLvl;
            }
            else if (_loc7_._type == 16)
            {
               _loc12_ = _loc7_._hpLvl;
            }
            else if (_loc7_._type == 17 && _loc25_ < _loc7_._hpLvl)
            {
               _loc25_ = _loc7_._hpLvl;
            }
            else if (_loc7_._type == 19)
            {
               _loc13_ = _loc7_._hpLvl;
            }
            else if (_loc7_._type == 20 && _loc24_ < _loc7_._hpLvl)
            {
               _loc24_ = _loc7_._hpLvl;
            }
            else if (_loc7_._type == 21 && _loc18_ < _loc7_._hpLvl)
            {
               _loc18_ = _loc7_._hpLvl;
            }
            else if (_loc7_._type == 22)
            {
               _loc11_ = _loc7_._hpLvl;
            }
            else if (_loc7_._type == 23)
            {
               _loc15_ = _loc7_._hpLvl;
            }
            else if (_loc7_._type == 24)
            {
               _loc28_ = true;
            }
            else if (_loc7_._type == 25)
            {
               _loc14_ = _loc7_._hpLvl;
            }
            else if (_loc7_._type == 26 && _loc23_ < _loc7_._hpLvl)
            {
               _loc23_ = _loc7_._hpLvl;
            }
            else if (_loc7_._type == 51)
            {
               _loc9_ = _loc7_._hpLvl;
            }
            else if (_loc7_._type == 115)
            {
               _loc16_ = _loc7_._hpLvl;
            }
            else if (_loc7_._type == 116)
            {
               _loc22_ = _loc7_._hpLvl;
            }
            else if (_loc7_._type == 128 && _loc29_ < _loc7_._hpLvl)
            {
               _loc29_ = _loc7_._hpLvl;
            }
            else if (_loc7_._type == 129 && _loc31_ < _loc7_._hpLvl)
            {
               _loc31_ = _loc7_._hpLvl;
            }
            else if (_loc7_._type == 130 && _loc30_ < _loc7_._hpLvl)
            {
               _loc30_ = _loc7_._hpLvl;
            }
            else if (_loc7_._type == 132 && _loc32_ < _loc7_._hpLvl)
            {
               _loc32_ = _loc7_._hpLvl;
            }
         }
         if (!BASE.isInfernoMainYardOrOutpost)
         {
            if (QUESTS._global.brlvl >= 4 || QUESTS._global.b6lvl >= 2 || _loc8_ >= 2 || _loc28_ || _loc17_ >= 2 || _loc19_ > 0)
            {
               _loc1_ = 2;
            }
            if (QUESTS._global.brlvl >= 6 || QUESTS._global.b6lvl >= 4 || QUESTS._global.b15lvl >= 2 || _loc20_ >= 2 || _loc21_ >= 2 || _loc17_ >= 3 || _loc3_ >= 4 || _loc2_ >= 4 || _loc19_ > 0 || _loc12_ > 0 || _loc9_ > 0 || _loc10_ > 0 || _loc11_ > 0 || _loc19_ >= 2 || _loc21_ >= 2 || _loc23_ > 0 || _loc11_ > 0)
            {
               _loc1_ = 3;
            }
            if (QUESTS._global.brlvl >= 8 || QUESTS._global.b6lvl >= 7 || QUESTS._global.b15lvl >= 3 || QUESTS._global.b23lvl >= 1 || QUESTS._global.b25lvl >= 1 || _loc21_ >= 3 || _loc23_ >= 2 || _loc11_ >= 2 || QUESTS._global.b19lvl > 0 || _loc3_ >= 5 || _loc2_ >= 5 || _loc13_ > 0 || _loc14_ > 0 || _loc16_ > 0 || _loc15_ > 0 || _loc20_ >= 3 || _loc19_ >= 4 || _loc17_ >= 4)
            {
               _loc1_ = 4;
            }
            if (_loc19_ >= 4 || _loc17_ >= 5 || _loc21_ >= 4 || _loc13_ >= 4 || _loc23_ >= 3 || _loc11_ >= 3)
            {
               _loc1_ = 5;
            }
            if (_loc21_ >= 5 || _loc13_ >= 5 || _loc23_ >= 4)
            {
               _loc1_ = 6;
            }
            if ((_loc21_ >= 7 || _loc13_ >= 6 || _loc23_ >= 5 || _loc18_ >= 7) && !BASE.isInfernoMainYardOrOutpost)
            {
               _loc1_ = 7;
            }
            if ((_loc21_ >= 8 || _loc13_ >= 7) && !BASE.isInfernoMainYardOrOutpost)
            {
               _loc1_ = 8;
            }
            if ((_loc21_ >= 9 || _loc11_ >= 4) && !BASE.isInfernoMainYardOrOutpost)
            {
               _loc1_ = 9;
            }
            if ((_loc21_ >= 10 || _loc11_ >= 5) && !BASE.isInfernoMainYardOrOutpost)
            {
               _loc1_ = 10;
            }
         }
         else if (BASE.isInfernoMainYardOrOutpost)
         {
            if (_loc29_ >= 2 || _loc19_ >= 2 || _loc28_ || _loc18_ >= 2 || _loc30_ >= 2 || _loc25_ > 0 || _loc26_ >= 4 || _loc27_ >= 4 || _loc2_ >= 3 || _loc4_ >= 3)
            {
               _loc1_ = 2;
            }
            if (_loc29_ >= 3 || _loc19_ >= 3 || _loc23_ > 0 || _loc20_ >= 2 || _loc18_ >= 3 || _loc30_ >= 3 || _loc31_ > 0 || _loc32_ > 0 || _loc25_ >= 2 || _loc26_ >= 6 || _loc27_ >= 5)
            {
               _loc1_ = 3;
            }
            if (_loc29_ >= 4 || _loc19_ >= 4 || _loc23_ >= 2 || _loc20_ >= 3 || _loc18_ >= 4 || _loc30_ >= 4 || _loc31_ >= 2 || _loc32_ >= 2 || _loc25_ >= 3 || _loc26_ >= 8 || _loc27_ >= 7 || _loc2_ >= 4 || _loc4_ >= 4)
            {
               _loc1_ = 4;
            }
            if (_loc29_ >= 5 || _loc23_ >= 3 || _loc18_ >= 6 || _loc30_ >= 6 || _loc31_ >= 4 || _loc32_ >= 4 || _loc26_ >= 10 || _loc27_ >= 9 || _loc5_ >= 4)
            {
               _loc1_ = 5;
            }
            if (_loc29_ >= 6 || _loc23_ >= 4 || _loc18_ >= 7 || _loc30_ >= 7 || _loc31_ >= 6 || _loc32_ >= 6 || _loc27_ >= 10 || _loc2_ >= 6 || _loc4_ >= 6 || _loc6_ >= 3)
            {
               _loc1_ = 6;
            }
         }
         return _loc1_;
      }

      public static function addEventBaseException(param1:Number):void
      {
         if (s_eventBases.indexOf(param1) == -1)
         {
            s_eventBases.push(param1);
         }
      }

      public static function isEventBaseId(param1:Number):Boolean
      {
         return s_eventBases.indexOf(param1) != -1;
      }

      public static function get isInfernoMainYardOrOutpost():Boolean
      {
         return m_yardType == EnumYardType.INFERNO_OUTPOST || m_yardType == EnumYardType.INFERNO_YARD;
      }

      public static function get isMainYard():Boolean
      {
         return m_yardType == EnumYardType.MAIN_YARD || m_yardType == EnumYardType.PLAYER;
      }

      public static function get isMainYardInfernoOnly():Boolean
      {
         return m_yardType == EnumYardType.INFERNO_YARD;
      }

      public static function get isMainYardOrInfernoMainYard():Boolean
      {
         return m_yardType == EnumYardType.MAIN_YARD || m_yardType == EnumYardType.INFERNO_YARD || m_yardType == EnumYardType.PLAYER;
      }

      public static function get isOutpost():Boolean
      {
         return m_yardType == EnumYardType.OUTPOST || m_yardType == EnumYardType.RESOURCE || m_yardType == EnumYardType.STRONGHOLD || m_yardType == EnumYardType.FORTIFICATION;
      }

      public static function get isOutpostMapRoom2Only():Boolean
      {
         return m_yardType == EnumYardType.OUTPOST;
      }

      public static function get isOutpostInfernoOnly():Boolean
      {
         return m_yardType == EnumYardType.INFERNO_OUTPOST;
      }

      public static function get isOutpostOrInfernoOutpost():Boolean
      {
         return m_yardType == EnumYardType.OUTPOST || m_yardType == EnumYardType.INFERNO_OUTPOST || m_yardType == EnumYardType.RESOURCE || m_yardType == EnumYardType.STRONGHOLD || m_yardType == EnumYardType.FORTIFICATION;
      }

      public static function get isOutpostResource():Boolean
      {
         return m_yardType == EnumYardType.RESOURCE;
      }

      public static function get isOutpostStronghold():Boolean
      {
         return m_yardType == EnumYardType.STRONGHOLD;
      }

      public static function get isOutpostFortification():Boolean
      {
         return m_yardType == EnumYardType.FORTIFICATION;
      }

      public static function getEmpireResources(param1:int):Number
      {
         var _loc2_:int = 0;
         _loc2_ = 1;
         if (GLOBAL._harvesterOverdrive >= GLOBAL.Timestamp() && GLOBAL._harvesterOverdrivePower.Get() > 0)
         {
            _loc2_ = GLOBAL._harvesterOverdrivePower.Get();
         }
         return _GIP["r" + param1].Get() * 360 * _loc2_;
      }

      public static function HasRequirements(param1:Object):Boolean
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:Vector.<Object> = null;
         var _loc5_:BFOUNDATION = null;
         for each (_loc2_ in param1.re)
         {
            _loc3_ = 0;
            if (_loc2_[0] == INFERNOQUAKETOWER.UNDERHALL_ID)
            {
               if (GLOBAL.StatGet(BUILDING14.UNDERHALL_LEVEL) >= _loc2_[2] && MAPROOM_DESCENT.DescentPassed)
               {
                  _loc3_ = 1;
               }
            }
            else
            {
               _loc4_ = InstanceManager.getInstancesByClass(BFOUNDATION);
               for each (_loc5_ in _loc4_)
               {
                  if (_loc5_._type == _loc2_[0] && _loc5_._lvl.Get() >= _loc2_[2])
                  {
                     _loc3_++;
                  }
               }
            }
            if (_loc3_ < _loc2_[1])
            {
               return false;
            }
         }
         return true;
      }

      public static function isInfernoBuilding(param1:uint):Boolean
      {
         return (param1 == INFERNOQUAKETOWER.TYPE || param1 == INFERNO_MAGMA_TOWER.ID || param1 == SiegeFactory.ID || param1 == SiegeLab.ID || param1 == SpurtzCannon.TYPE || param1 == BlackSpurtzCannon.TYPE) && !BASE.isInfernoMainYardOrOutpost;
      }

      public static function hasNumBuildings(param1:int, param2:int = 0, param3:Boolean = false):int
      {
         var _loc4_:Object = null;
         var _loc5_:Vector.<Object> = null;
         var _loc6_:int = 0;
         var _loc7_:BFOUNDATION = null;
         _loc4_ = GLOBAL._buildingProps[param1 - 1];
         _loc5_ = InstanceManager.getInstancesByClass(!!_loc4_.cls ? _loc4_.cls : BFOUNDATION);
         _loc6_ = 0;
         for each (_loc7_ in _loc5_)
         {
            if (_loc7_._type == param1 && _loc7_._lvl.Get() >= param2)
            {
               _loc6_++;
               if (param3)
               {
                  break;
               }
            }
         }
         return _loc6_;
      }

      public static function findBuilding(param1:int):BFOUNDATION
      {
         var _loc2_:Object = null;
         var _loc3_:Vector.<Object> = null;
         var _loc4_:BFOUNDATION = null;
         _loc2_ = GLOBAL._buildingProps[param1];
         _loc3_ = InstanceManager.getInstancesByClass(!!_loc2_.cls ? _loc2_.cls : BFOUNDATION);
         for each (_loc4_ in _loc3_)
         {
            if (_loc4_._type === param1)
            {
               return _loc4_;
            }
         }
         return null;
      }

      public static function isInfernoCreep(param1:String):Boolean
      {
         return param1.substring(0, 1) == "I";
      }

      public static function getEstimatedRepairDuration():Number
      {
         var _loc1_:Number = NaN;
         var _loc2_:Vector.<Object> = null;
         var _loc3_:BFOUNDATION = null;
         var _loc4_:Number = NaN;
         _loc1_ = 0;
         _loc2_ = InstanceManager.getInstancesByClass(BFOUNDATION);
         for each (_loc3_ in _loc2_)
         {
            _loc4_ = _loc3_.getEstimatedRepairTimeRemaining();
            if (_loc4_ > _loc1_)
            {
               _loc1_ = _loc4_;
            }
         }
         return _loc1_;
      }

      public static function getNumHousingHealsPerTick():int
      {
         var _loc1_:int = 0;
         var _loc2_:Vector.<Object> = null;
         var _loc3_:BFOUNDATION = null;
         _loc1_ = 0;
         _loc2_ = InstanceManager.getInstancesByClass(!!BASE.isInfernoMainYardOrOutpost ? HOUSINGBUNKER : BUILDING15);
         if (isInfernoMainYardOrOutpost)
         {
            if (_loc2_[0])
            {
               _loc1_ = Math.min(4, _loc2_[0]._lvl.Get());
            }
         }
         else
         {
            for each (_loc3_ in _loc2_)
            {
               _loc1_++;
            }
         }
         return _loc1_;
      }

      public static function FindClosestHousingToPoint(param1:int, param2:int, param3:BFOUNDATION = null, param4:Boolean = true, param5:Boolean = true):BFOUNDATION
      {
         var _loc6_:Array = null;
         var _loc7_:Vector.<Object> = null;
         var _loc8_:BFOUNDATION = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         _loc6_ = [];
         _loc7_ = InstanceManager.getInstancesByClass(!!BASE.isInfernoMainYardOrOutpost ? HOUSINGBUNKER : BUILDING15);
         for each (_loc8_ in _loc7_)
         {
            if (_loc8_ != param3)
            {
               if (!(param4 == true && _loc8_._countdownBuild.Get() > 0))
               {
                  if (!(param5 == true && _loc8_.health <= 0))
                  {
                     _loc9_ = _loc8_.x - param1;
                     _loc10_ = _loc8_.y - param2;
                     _loc11_ = int(Math.sqrt(_loc9_ * _loc9_ + _loc10_ * _loc10_));
                     _loc6_.push({
                              "house": _loc8_,
                              "dist": _loc11_
                           });
                  }
               }
            }
         }
         if (_loc6_.length == 0)
         {
            return null;
         }
         _loc6_.sortOn(["dist"], Array.NUMERIC);
         return _loc6_[0].house;
      }
   }
}