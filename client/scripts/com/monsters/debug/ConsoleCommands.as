package com.monsters.debug
{
   import com.cc.utils.SecNum;
   // this is used by commented out methods
   // import com.monsters.baseplanner.BaseTemplate;
   import com.monsters.baseplanner.PlannerDesignView;
   import com.monsters.configs.BYMConfig;
   import com.monsters.frontPage.FrontPageGraphic;
   import com.monsters.frontPage.FrontPageLibrary;
   import com.monsters.frontPage.messages.Message;
   import com.monsters.kingOfTheHill.KOTHHandler;
   import com.monsters.monsters.champions.ChampionBase;
   import com.monsters.rendering.RasterData;
   import com.monsters.rendering.Renderer;
   import com.monsters.replayableEvents.ReplayableEvent;
   import com.monsters.replayableEvents.ReplayableEventHandler;
   import com.monsters.replayableEvents.ReplayableEventLibrary;
   import com.monsters.subscriptions.SubscriptionHandler;

   import flash.display.Shape;
   import flash.events.Event;
   import flash.filters.GlowFilter;
   import flash.geom.ColorTransform;
   import flash.utils.getDefinitionByName;

   public class ConsoleCommands
   {
      public function ConsoleCommands()
      {
         super();
      }

      public static function initialize():void
      {
         Console.registerCommand("unlockquest", unlockQuest);
         Console.registerCommand("lockquest", lockQuest);
         Console.registerCommand("lab", creatureLab);
         Console.registerCommand("academy", creatureAcademy);
         Console.registerCommand("setfeedtime", setChampionFeedTime);
         Console.registerCommand("setstarvetime", setChampionStarveTime);
         Console.registerCommand("tut_stage", tutorialGetStage);
         Console.registerCommand("tutorialArrowRotation", tutorialArrowRotation);
         Console.registerCommand("resetfrontpage", resetFrontPageData);
         Console.registerCommand("frontpageShow", showFrontPageMsg);
         Console.registerCommand("removeDP", removeDamageProtection);
         Console.registerCommand("settime", setERSTime);
         Console.registerCommand("gettime", getERSTime);
         Console.registerCommand("setscore", setERSScore);
         Console.registerCommand("getscore", getERSScore);
         Console.registerCommand("startevent", startERSEvent);
         Console.registerCommand("clearers", clearERSData);
         Console.registerCommand("setwmi2level", setWMI2Level);
         Console.registerCommand("kothendin", setKOTHEndDate);
         Console.registerCommand("kothdata", getKOTHdata);
         Console.registerCommand("setKorathLevel", setKorathLevel);
         Console.registerCommand("champCageHasKoth", champCageHasKoth);
         Console.registerCommand("debugChampion", setDebugChampion);
         Console.registerCommand("giveChampion", giveChampion);
         Console.registerCommand("setChampionPL", setChampionPL);
         Console.registerCommand("deletechamps", deleteChampions);
         Console.registerCommand("sam", sam);
         Console.registerCommand("ROFLPWN", roflpwn);
         Console.registerCommand("printMaxResources", printMaxResources);
         Console.registerCommand("showbuffradius", showBuffRadius);
         Console.registerCommand("setkrallenlevel", setKrallenLevel);
         Console.registerCommand("expirationDate", setSubscriptionsExpirationDate);
         Console.registerCommand("renewalDate", setSubscriptionsRenewalDate);
         Console.registerCommand("changeAlpha", changeAlpha);
         Console.registerCommand("forceAFK", forceAFK);
         Console.registerCommand("plannerZoom", plannerZoom);
         Console.registerCommand("plannerTool", plannerTool);
         Console.registerCommand("plannerRedraw", plannerRedraw);
         Console.registerCommand("showbaseresources", showBaseResources);
         Console.registerCommand("getsubscriptiondata", subscriptionsGetSubscriptionData);
         Console.registerCommand("startsubscription", subscriptionsStartSubscription);
         Console.registerCommand("reactivatesubscription", subscriptionsReactivateSubscription);
         Console.registerCommand("changesubscription", subscriptionsChangeSubscription);
         Console.registerCommand("cancelsubscription", subscriptionsCancelSubscription);
         Console.registerCommand("givesubscription", subscriptionsGiveSubscription);
         Console.registerCommand("trojan", spawnTrojan);
         Console.registerCommand("wmattack", spawnWildMonsters);
         Console.registerCommand("showsubscriptiondata", showSubscriptionData);
         Console.registerCommand("toggleBuildingBases", toggleBuildingBases);
         Console.registerCommand("toggleBuildingTops", toggleBuildingTops);
         Console.registerCommand("toggleRenderer", toggleRenderer);
         Console.registerCommand("rendererdebug", showRendererDebug);
         Console.registerCommand("numBuildings", showNumBuildings);
         Console.registerCommand("version", showVersion);
         Console.registerCommand("printJS", printJSCalls);
         Console.registerCommand("fullscreen", toggleFullScreen);
         Console.registerCommand("ncpElligible", fbCNcpElligibility);
      }

      private static function setSubscriptionsRenewalDate(param1:*):String
      {
         var _loc2_:uint = uint(param1);
         if (!_loc2_)
         {
            return "invalid date";
         }
         SubscriptionHandler.setRenewalDateDEBUG(_loc2_);
         return "renewal date set to " + new Date(_loc2_).toUTCString();
      }

      private static function setSubscriptionsExpirationDate(param1:*):String
      {
         var _loc2_:uint = uint(param1);
         if (!_loc2_)
         {
            return "invalid date";
         }
         SubscriptionHandler.setExpirationDateDEBUG(_loc2_);
         return "expiration date set to " + new Date(_loc2_).toUTCString();
      }

      private static function setKrallenLevel(param1:*):String
      {
         CREATURES._krallen.levelSet(int(param1), 0);
         return "Set KOTH\'s level to " + param1;
      }

      private static function showBuffRadius(_param1:*):String
      {
         var _loc2_:Shape = null;
         if (CREEPS.krallen)
         {
            _loc2_ = new Shape();
            _loc2_.graphics.beginFill(0xff00, 0.3);
            _loc2_.graphics.drawEllipse(0, 0, CREEPS.krallen._buffRadius * 2, CREEPS.krallen._buffRadius);
            _loc2_.graphics.endFill();
            _loc2_.x = -_loc2_.width / 2;
            _loc2_.y = -_loc2_.height / 2;
            CREEPS.krallen.addChild(_loc2_);
            return "toggled showing Champion buff radius.";
         }
         return "Must have a Krallen attacking.";
      }

      private static function getKOTHdata(_param1:*):String
      {
         var _loc2_:KOTHHandler = KOTHHandler.instance;
         return "tier: " + _loc2_.tier + ", wins:" + _loc2_.wins + ", server event ends in: " + _loc2_.timeToReset;
      }

      private static function sam(_param1:*):String
      {
         var shape:Shape = null;
         shape = new Shape();
         shape.graphics.beginFill(0xffffff);
         shape.graphics.drawRect(GLOBAL._SCREEN.x, GLOBAL._SCREEN.y, GLOBAL._SCREEN.width, GLOBAL._SCREEN.height);
         shape.graphics.endFill();
         shape.filters = [new GlowFilter(0xffffff, 1, 10, 10, 2, 1, true)];
         GAME._instance.stage.addChild(shape);
         shape.addEventListener(Event.ENTER_FRAME, function (param1:Event):void
         {
            param1.currentTarget.transform.colorTransform = new ColorTransform(Math.random(), Math.random(), Math.random());
            shape.x = GLOBAL._SCREEN.x;
            shape.y = GLOBAL._SCREEN.y;
            shape.width = GLOBAL._SCREEN.width + 100;
            shape.height = GLOBAL._SCREEN.height + 100;
         });
         return "";
      }

      private static function roflpwn(_param1:*):String
      {
         var _loc2_:int = 1;
         while (_loc2_ < CHAMPIONCAGE._guardians.length + 1)
         {
            CHAMPIONCAGE._guardians["G" + _loc2_].classType = CHAMPIONCAGE.CLASS_TYPE_SPECIAL;
            _loc2_++;
         }
         _loc2_ = 1;
         while (_loc2_ < CHAMPIONCAGE._guardians.length + 1)
         {
            GLOBAL._bCage.SpawnGuardian(6, 0, 0, _loc2_, 1000000000, "", 0, 3);
            _loc2_++;
         }
         return "  lolol";
      }

      private static function printMaxResources(_param1:*):String
      {
         var _loc3_:int;
         var _loc2_:String = "";
         _loc3_ = 1;
         while (_loc3_ < int.MAX_VALUE)
         {
            if (!GLOBAL._resources["r" + _loc3_ + "max"])
            {
               break;
            }
            _loc2_ += "r" + _loc3_ + ":" + GLOBAL._resources["r" + _loc3_ + "max"] + " ";
            _loc3_++;
         }
         return _loc2_;
      }

      private static function setDebugChampion(_param1:*):String
      {
         var _loc3_:ChampionBase = null;
         var _loc2_:Shape = new Shape();
         switch (true)
         {
            case CREATURES._guardian is ChampionBase:
               _loc3_ = CREATURES._guardian as ChampionBase;
               break;
            case CREEPS._guardian is ChampionBase:
               _loc3_ = CREEPS._guardian as ChampionBase;
               break;
            default:
               return "No Champion found.";
         }
         _loc2_.graphics.beginFill(0xff00);
         _loc2_.graphics.drawCircle(0, 0, 8);
         _loc2_.graphics.endFill();
         _loc3_.addChild(_loc2_);
         return "Champion debug on.";
      }

      private static function deleteChampions(param1:*):String
      {
         if(param1)
         {
            return "This function is broken";
         }
         var _loc2_:int = 0;
         GLOBAL._playerGuardianData.length = 0;
         BASE._guardianData.length = 0;
         if (!BYMConfig.instance.RENDERER_ON)
         {
            _loc2_ = 0;
            while (_loc2_ < CREATURES._guardianList.length)
            {
               // MAP._BUILDINGTOPS.removeChild(CREATURES._guardianList[_loc2_]);
               _loc2_++;
            }
         }
         CREATURES._guardianList.length = 0;
         CREEPS._guardianList.length = 0;
         return "ALL champs have been destroyed, GLHF";
      }

      private static function giveChampion(param1:*):String
      {
         var _loc3_:BFOUNDATION = null;
         if (!param1)
         {
            return "Specify a champion type.";
         }
         var _loc2_:Object = BASE._buildingsAll;
         for each(_loc3_ in _loc2_)
         {
            if (_loc3_ is CHAMPIONCAGE)
            {
               break;
            }
         }
         if (_loc3_)
         {
            (_loc3_ as CHAMPIONCAGE).SpawnGuardian(1, 0, 0, param1, CHAMPIONCAGE.GetGuardianProperty("G" + param1, 1, "health"), "", 0, 1);
            return "Champion " + param1 + " given.";
         }
         return "No champion cage found.";
      }

      private static function setChampionPL(param1:*):String
      {
         var _loc3_:ChampionBase = null;
         if (!param1)
         {
            return "Specify a powerlevel.";
         }
         for each(_loc3_ in CREATURES._guardianList)
         {
            _loc3_._powerLevel.Set(Number(param1));
         }
         return "Champion powerlevel set to " + param1 + " .";
      }

      private static function setKOTHEndDate(param1:*):String
      {
         var _loc2_:uint = uint(param1);
         var _loc3_:uint = _loc2_ * 3600;
         KOTHHandler.instance.setDebugTimeToReset(_loc3_);
         return "KOTH event will end in " + _loc3_ + " seconds.";
      }

      private static function setWMI2Level(param1:*):String
      {
         var _loc2_:uint = uint(param1);
         SPECIALEVENT.DEBUGOVERRIDEWAVE(_loc2_);
         return null;
      }

      // These functions are unused, but can serve some imagination to debug stuff
      /*
      private static function deleteTemplate(param1:*):String
      {
         var _loc2_:uint = uint(param1);
         return null;
      }

      private static function loadTemplateList(param1:*):String
      {
         return "this method is broken";
      }
      private static function saveCurrentBaseAsTemplate(param1:*):String
      {
         var _loc2_:uint = uint(param1);
         var _loc3_:BaseTemplate = BASE.getTemplate();
         return null;
      }

      private static function applyBaseTemplate(param1:*):String
      {
         return "this method is broken";
      }
*/

      private static function clearERSData(_param1:*):String
      {
         ReplayableEventHandler.doesDebugClear = true;
         return "deleting all ers data....";
      }

      private static function setERSTime(param1:*):String
      {
         if (!ReplayableEventHandler.debugDate)
         {
            ReplayableEventHandler.debugDate = new Date();
         }
         ReplayableEventHandler.debugDate.time = param1 * 1000 as Number;
         return "ERS time is now " + ReplayableEventHandler.debugDate.toUTCString();
      }

      private static function getERSTime(_param1:*):String
      {
         if (!ReplayableEventHandler.debugDate)
         {
            return "ERS debug time not set. Using real time " + new Date(GLOBAL.Timestamp() * 1000).toUTCString();
         }
         return ReplayableEventHandler.debugDate.toUTCString();
      }

      private static function setERSScore(param1:*):String
      {
         var _loc2_:ReplayableEvent = ReplayableEventHandler.activeEvent;
         if (!_loc2_)
         {
            return "There is no active event";
         }
         var _loc3_:uint = _loc2_.score;
         _loc2_.score = param1 as uint;
         return _loc2_.name + " score was set from " + _loc3_ + " to " + param1;
      }

      private static function getERSScore(_param1:*):String
      {
         var _loc2_:ReplayableEvent = ReplayableEventHandler.activeEvent;
         if (!_loc2_)
         {
            return "There is no active event";
         }
         return "score for " + _loc2_.name + " is " + _loc2_.score;
      }

      private static function startERSEvent(param1:*):String
      {
         var _loc2_:ReplayableEvent = ReplayableEventLibrary.getEventByID(uint(param1));
         if (!_loc2_)
         {
            return "Invalid event ID";
         }
         var _loc3_:Number = ReplayableEventHandler.currentTime + 7 * 24 * 60 * 60;
         if (!_loc3_)
         {
            return "Could not schedule a start date for this event(probably because there\'s a new LIVE event soon";
         }
         ReplayableEventHandler.scheduleNewEvent(_loc2_, _loc3_);
         ReplayableEventHandler.initialize();
         return "Sucessfully scheduled " + _loc2_.name + " for " + new Date(_loc2_.startDate).toUTCString();
      }

      public static function setChampionStarveTime(param1:*):String
      {
         var _loc2_:* = 0;
         if (CREATURES._guardian)
         {
            _loc2_ = CHAMPIONCAGE.STARVETIMER;
            CHAMPIONCAGE.STARVETIMER = uint(param1);
            CREATURES._guardian._feedTime = new SecNum(GLOBAL.Timestamp());
            return "Champion starve time set to " + CHAMPIONCAGE.STARVETIMER + " from " + _loc2_;
         }
         return "You dont have a champion... idiot";
      }

      public static function setChampionFeedTime(param1:*):String
      {
         var _loc2_:* = 0;
         var _loc3_:* = 0;
         if (CREATURES._guardian)
         {
            _loc2_ = CREATURES._guardian._feedTime.Get();
            _loc3_ = uint(GLOBAL.Timestamp() + uint(param1));
            CREATURES._guardian._feedTime = new SecNum(_loc3_);
            return "Champion feed time set to " + GLOBAL.ToTime(_loc3_ - GLOBAL.Timestamp()) + " from " + GLOBAL.ToTime(_loc2_ - GLOBAL.Timestamp());
         }
         return "You dont have a champion... idiot";
      }

      public static function setKorathLevel(param1:int):String
      {
         if (GLOBAL.mode != "build")
         {
            return "ERROR: can only set level in your base!";
         }
         CHAMPIONCAGE._guardians["G4"].props.powerLevel = param1;
         var _loc2_:Object = CHAMPIONCAGE.GetGuardianData(4);
         if (_loc2_)
         {
            _loc2_.pl = new SecNum(param1);
         }
         return "Korath level targeted: " + param1 + " set: " + _loc2_.pl;
      }

      public static function creatureAcademy(param1:String = null, param2:uint = 0):String
      {
         if (param1 == null || param1 == "all")
         {
            for (var _loc3_:String  in CREATURELOCKER._creatures)
            {
               GLOBAL.player.m_upgrades[param1].powerup = param2;
            }
            return null;
         }
         GLOBAL.player.m_upgrades[param1].powerup = param2;
         return KEYS.Get(CREATURELOCKER._creatures[param1].name) + " upgraded to " + param2;
      }

      public static function creatureLab(param1:*, param2:uint):String
      {
         if (param1 == null || param1 == "all")
         {
            for (var _loc3_:String in CREATURELOCKER._creatures)
            {
               GLOBAL.player.m_upgrades[param1] = {"level": param2};
            }
            return null;
         }
         GLOBAL.player.m_upgrades[param1] = {"level": param2};
         return KEYS.Get(CREATURELOCKER._creatures[param1].name) + " upgraded to " + param2;
      }

      public static function changeAlpha(param1:Number = 1):String
      {
         MAP._GROUND.alpha = param1;
         return param1.toString();
      }

      public static function unlockQuest(param1:*):String
      {
         var _loc2_:Object = null;
         if (param1 == null || param1 == "all")
         {
            for each(_loc2_ in QUESTS._quests)
            {
               QUESTS._completed[_loc2_.id] = 1;
            }
            return null;
         }
         QUESTS._completed[param1] = 1;
         return KEYS.Get(QUESTS.GetQuestByID(param1).name);
      }

      public static function lockQuest(param1:*):String
      {
         var _loc2_:Object = null;
         if (param1 == null || param1 == "all")
         {
            for each(_loc2_ in QUESTS._quests)
            {
               delete QUESTS._completed[_loc2_.id];
            }
            return null;
         }
         delete QUESTS._completed[_loc2_.id];
         return KEYS.Get(QUESTS.GetQuestByID(param1).name);
      }

      public static function tutorialArrowRotation(param1:Number = 0):String
      {
         if (TUTORIAL._mcArrow)
         {
            TUTORIAL._mcArrow.mcArrow.rotation = param1;
            return "TUTORIAL._mcArrow: Rotation - " + TUTORIAL._mcArrow.rotation;
         }
         return "TUTORIAL._mcArrow is NULL - there is no arrow to manipulate.";
      }

      public static function tutorialGetStage(_param1:int = 0):String
      {
         return "TUTORIAL._stage = " + TUTORIAL._stage;
      }

      public static function forceAFK(param1:int = 0):String
      {
         var _loc2_:String;
         if (param1 == 1)
         {
            POPUPS.AFK();
            _loc2_ = "afk";
         } else
         {
            POPUPS.Timeout();
            _loc2_ = "timeout";
         }
         return "forcing afk popup type: " + _loc2_;
      }

      public static function resetFrontPageData(_param1:* = null):String
      {
         FrontPageLibrary.initialize();
         GLOBAL.StatSet("CM3", 0);
         return "reset frontpage save data";
      }

      public static function showFrontPageMsg(param1:String):String
      {
         var _loc2_:Class = getDefinitionByName(param1) as Class;
         var _loc3_:Message = new _loc2_();
         print(param1);
         if (_loc3_ == null)
         {
            return "ERROR: " + param1 + " is not a valid class.";
         }
         var _loc4_:FrontPageGraphic = new FrontPageGraphic();
         _loc4_.showMessage(_loc3_);
         POPUPS.Push(_loc4_);
         return "CONSOLE: Adding frontpage graphic: " + param1;
      }

      public static function printJSCalls(param1:* = null):String
      {
         if (param1 != 1 && param1 != 0)
         {
            return "CONSOLE: printJS - ERROR - please provide a 1 or 0 value";
         }
         GLOBAL.debugLogJSCalls = Boolean(param1);
         return "CONSOLE: printJS set to " + GLOBAL.debugLogJSCalls;
      }

      public static function toggleFullScreen(_param1:* = null):String
      {
         GLOBAL.goFullScreen();
         return "CONSOLE: Toggle FullScreen, press ESC to exit";
      }

      public static function removeDamageProtection(_param1:* = null):String
      {
         BASE._isProtected = 0;
         BASE.Save();
         return "CONSOLE: BASE._isProtected set to: " + Boolean(BASE._isProtected);
      }

      public static function plannerZoom(param1:* = null):String
      {
         if (PLANNER.basePlanner && PLANNER.basePlanner.popup && Boolean(PLANNER.basePlanner.popup.designView))
         {
            if (Boolean(PLANNER.basePlanner.popup.designView) && param1 > 0)
            {
               PLANNER.basePlanner.popup.designView.setZoom(param1);
               return "PlannerDesignView Zoomed To: " + PlannerDesignView.zoomValue;
            }
            return "enter a value noob.";
         }
         return "open yard planner 2 before you try anything else.";
      }

      public static function plannerTool(param1:* = null):String
      {
         if (PLANNER.basePlanner && PLANNER.basePlanner.popup && Boolean(PLANNER.basePlanner.popup.designView))
         {
            if (Boolean(PLANNER.basePlanner.popup.designView) && param1)
            {
               if (param1 == "selectmove" || param1 == "storebuilding")
               {
                  PLANNER.basePlanner.popup.designView.currentTool = param1;
               } else
               {
                  PLANNER.basePlanner.popup.designView.currentTool = "selectmove";
               }
               return "PlannerDesignView Tool Set To: " + PLANNER.basePlanner.popup.designView.currentTool;
            }
            return "enter a value noob.";
         }
         return "open yard planner 2 before you try anything else.";
      }

      public static function plannerRedraw(_param1:* = null):String
      {
         if (PLANNER.basePlanner && PLANNER.basePlanner.popup && Boolean(PLANNER.basePlanner.popup.designView))
         {
            if (PLANNER.basePlanner.popup)
            {
               PLANNER.basePlanner.popup.redraw();
               return "PlannerDesignView Redraw";
            }
            return "enter a value noob.";
         }
         return "open yard planner 2 before you try anything else.";
      }

      public static function champCageHasKoth(_param1:* = null):String
      {
         if (!CHAMPIONCAGEPOPUP._kothEnabled)
         {
            CHAMPIONCAGEPOPUP._kothEnabled = true;
         }
         return "_kothEnabled is " + CHAMPIONCAGEPOPUP._kothEnabled;
      }

      public static function showBaseResources(_param1:* = null):String
      {
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc2_:* = "BASE RESOURCES:";
         _loc2_ += "\n";
         for (_loc3_ in BASE._resources)
         {
            _loc4_ = 0;
            if (BASE._resources[_loc3_] is SecNum)
            {
               _loc4_ = int(BASE._resources[_loc3_].Get());
            } else
            {
               _loc4_ = int(BASE._resources[_loc3_]);
            }
            _loc2_ += " | " + _loc3_ + ": " + _loc4_;
         }
         _loc2_ += "\n";
         if (BASE._iresources)
         {
            for (_loc5_ in BASE._iresources)
            {
               _loc6_ = 0;
               if (BASE._iresources[_loc5_] is SecNum)
               {
                  _loc6_ = int(BASE._iresources[_loc5_].Get());
               } else
               {
                  _loc6_ = int(BASE._iresources[_loc5_]);
               }
               _loc2_ += " I " + _loc5_ + ": " + _loc6_;
            }
         }
         return _loc2_;
      }

      public static function subscriptionsGetSubscriptionData(_param1:* = null):String
      {
         SubscriptionHandler.instance.service.getSubscriptionData();
         return "SUBSCRIPTIONS> trying to get data";
      }

      public static function subscriptionsStartSubscription(_param1:* = null):String
      {
         SubscriptionHandler.instance.service.getSubscriptionData();
         return "SUBSCRIPTIONS> trying to get data";
      }

      public static function subscriptionsReactivateSubscription(_param1:* = null):String
      {
         SubscriptionHandler.instance.service.getSubscriptionData();
         return "SUBSCRIPTIONS> trying to get data";
      }

      public static function subscriptionsChangeSubscription(_param1:* = null):String
      {
         SubscriptionHandler.instance.service.getSubscriptionData();
         return "SUBSCRIPTIONS> trying to get data";
      }

      public static function subscriptionsCancelSubscription(_param1:* = null):String
      {
         SubscriptionHandler.instance.service.getSubscriptionData();
         return "SUBSCRIPTIONS> trying to get data";
      }

      public static function fbCNcpElligibility(_param1:* = null):String
      {
         BUY.FBCNcpCheckEligibility();
         return "console: trying to check ncp";
      }

      public static function subscriptionsGiveSubscription(_param1:* = null):String
      {
         SubscriptionHandler.ignoreAB = true;
         SubscriptionHandler.instance.initialize();
         SubscriptionHandler.setRenewalDateDEBUG(123456);
         return "SUBSCRIPTIONS> forcing subscription for this session";
      }

      public static function spawnTrojan(_param1:* = null):String
      {
         CUSTOMATTACKS.TrojanHorse();
         return "Creating CUSTOMATTACKS.TrojanHorse";
      }

      public static function spawnWildMonsters(_param1:* = null):String
      {
         WMATTACK.Trigger(true);
         return "Creating Wild Monster attacks via WMATTACK.Trigger.";
      }

      public static function toggleBuildingBases(_param1:* = null):String
      {
         MAP._BUILDINGBASES.visible = !MAP._BUILDINGBASES.visible;
         return "Building Bases Visible:" + MAP._BUILDINGBASES.visible;
      }

      public static function toggleBuildingTops(_param1:* = null):String
      {
         MAP._BUILDINGTOPS.visible = !MAP._BUILDINGTOPS.visible;
         return "Building Tops Visible:" + MAP._BUILDINGTOPS.visible;
      }

      public static function toggleRenderer(_param1:* = null):String
      {
         MAP.instance.canvasContainer.visible = !MAP.instance.canvasContainer.visible;
         return "Renderer set to:" + MAP.instance.canvasContainer.visible.toString();
      }

      public static function showSubscriptionData(_param1:* = null):String
      {
         return "name:" + SubscriptionHandler.instance.name + " exp:" + SubscriptionHandler.instance.expirationDate + " renew:" + SubscriptionHandler.instance.renewalDate + " active:" + SubscriptionHandler.instance.isSubscriptionActive;
      }

      public static function showRendererDebug(_param1:* = null):String
      {
         if (!BYMConfig.instance.RENDERER_ON)
         {
            return "Renderer disabled";
         }
         Renderer.debug = !Renderer.debug;
         return "RasterData:" + RasterData.rasterData.length + " | " + RasterData.visibleData.length + " | " + int(RasterData.totalMemory / 1024) + "Kb";
      }

      public static function showNumBuildings(_param1:* = null):String
      {
         var _loc2_:int = 0;
         for each(var _loc3_:BFOUNDATION in BASE._buildingsAll)
         {
            _loc2_++;
         }
         return "NumBuildings:" + _loc2_.toString();
      }

      public static function showVersion(_param1:* = null):String
      {
         return "version:" + GLOBAL._version.Get() + " " + GLOBAL._softversion;
      }
   }
}

