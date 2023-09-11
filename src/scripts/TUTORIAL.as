package
{
   import com.cc.utils.SecNum;
   import com.monsters.debug.Console;
   import com.monsters.display.ImageCache;
   import com.monsters.managers.InstanceManager;
   import com.monsters.maproom3.MapRoom3Tutorial;
   import com.monsters.maproom_manager.MapRoomManager;
   import com.monsters.ui.UI_BOTTOM;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import gs.TweenLite;
   import gs.easing.Elastic;
   
   public class TUTORIAL
   {
      
      public static var _stage:int = 0;
      
      public static var _currentStage:int = 0;
      
      public static const _endstage:int = 205;
      
      public static var _arrowRotation:int = 0;
      
      public static var _isSmallSizeOffset:int = 0;
      
      public static const k_STAGE_SNIPER_SPEEDUP:uint = 37;
      
      public static const k_STAGE_DAMAGE_PROTECT:uint = 190;
      
      private static const ARROW_STORE_BUY_1:Point = new Point(215,200);
      
      private static const ARROW_STORE_BUY_2:Point = new Point(225,200);
      
      private static const ARROW_STORE_BUY_3:Point = new Point(580,345);
      
      private static const ARROW_STORE_BUY_4:Point = new Point(225,365);
      
      private static const ARROW_BUILDING_UPGRADE:Point = new Point(586,300);
      
      private static const ARROW_BUILDINGS_HOUSING:Point = new Point(470,240);
      
      private static const ARROW_BUILDINGS_FLINGER:Point = new Point(250,300);
      
      private static const ARROW_BUILDINGS_MAPROOM:Point = new Point(510,300);
      
      private static const ARROW_BUILDINGS_HATCHERY:Point = new Point(610,240);
      
      public static var BOBBOTTOMLEFTLOW:Point = new Point(10,560);
      
      public static var BOBBOTTOMLEFTHIGH:Point = new Point(10,560);
      
      public static var POINT_QUEST:Point = new Point(583,481 + _isSmallSizeOffset);
      
      public static var POINT_BUILDINGS:Point = new Point(496,483 + _isSmallSizeOffset);
      
      public static var POINT_MAP:Point = new Point(706,474 + _isSmallSizeOffset);
      
      public static var POINT_FULLSCREEN:Point = new Point(640,14 + _isSmallSizeOffset);
      
      public static var _advanceCondition:Function = null;
      
      public static var _rewindCondition:Function = null;
      
      public static var _doBob:DisplayObject;
      
      public static var _doArrow:DisplayObject;
      
      public static var _container;
      
      public static var _timer:int;
      
      public static var _setupDone:Boolean;
      
      public static var _secondWorker:Boolean = false;
      
      public static var _freeSpeedup:Boolean = true;
      
      public static var _mcBob:TUTORIALPOPUPMC;
      
      public static var _mcArrow:MovieClip;
       
      
      public function TUTORIAL()
      {
         super();
      }
      
      public static function get hasFinished() : Boolean
      {
         return _stage >= _endstage;
      }
      
      public static function Setup() : void
      {
         _container = GLOBAL._layerMessages;
         _doBob = null;
         _doArrow = null;
         _mcBob = new TUTORIALPOPUPMC();
         _mcArrow = new TUTORIALARROWMC();
         _currentStage = 0;
         _isSmallSizeOffset = GAME._isSmallSize ? -80 : 0;
         if(GAME._isSmallSize)
         {
            BOBBOTTOMLEFTLOW = new Point(10,560 + _isSmallSizeOffset);
            BOBBOTTOMLEFTHIGH = new Point(10,560 + _isSmallSizeOffset);
         }
      }
      
      public static function Process() : void
      {
         if(_stage < 200)
         {
            if(BASE.isInfernoMainYardOrOutpost)
            {
               _stage = _endstage;
            }
            if(GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD)
            {
               if(_stage > 1 && _stage < 31)
               {
                  _stage = 31;
               }
               if(Boolean(GLOBAL._bHousing) && _stage < 57)
               {
                  _stage = 57;
               }
               if(_stage == 102)
               {
                  _stage = 101;
               }
               if(QUESTS._completed.WM1 == 1)
               {
                  _stage = 130;
               }
               if(QUESTS._completed.WM1 == 2)
               {
                  _stage = 140;
               }
               if(QUESTS._global.b4lvl > 0)
               {
                  _stage = 180;
               }
               if(_stage > 58 && _stage < 65)
               {
                  _stage = 65;
               }
               if(_stage >= 113 && _stage <= 116 || _stage == 120)
               {
                  _stage = 130;
               }
               else if(_stage >= 110 && _stage < 130)
               {
                  _stage = 99;
               }
               if(_stage < 150 && Boolean(GLOBAL._bHatchery))
               {
                  if(GLOBAL._bHatchery._countdownBuild.Get() > 0)
                  {
                     _stage = 145;
                  }
                  else
                  {
                     _stage = 150;
                  }
               }
            }
            else if(GLOBAL.mode == GLOBAL.e_BASE_MODE.WMATTACK)
            {
               _stage = 110;
            }
         }
      }
      
      public static function Advance(param1:MouseEvent = null) : void
      {
         if(MapRoomManager.instance.isInMapRoom3 && MapRoom3Tutorial.instance.isStarted && !MapRoom3Tutorial.instance.isHolding && param1 && TUTORIAL._stage < 150)
         {
            MapRoom3Tutorial.instance.advance();
            return;
         }
         clearStage();
         _stage += 1;
         if(_stage > 1 && _stage < 31)
         {
            _stage = 31;
         }
         QUESTS.Check();
         Tick();
      }
      
      private static function Rewind() : void
      {
         if(Boolean(_doBob) && Boolean(_doBob.parent))
         {
            _container.removeChild(_doBob);
         }
         if(Boolean(_doArrow) && Boolean(_doArrow.parent))
         {
            _container.removeChild(_doArrow);
         }
         _advanceCondition = null;
         _rewindCondition = null;
         --_stage;
         Tick();
      }
      
      public static function clearStage() : void
      {
         if(Boolean(_doBob) && Boolean(_doBob.parent))
         {
            _container.removeChild(_doBob);
         }
         if(Boolean(_doArrow) && Boolean(_doArrow.parent))
         {
            _container.removeChild(_doArrow);
         }
         if(_mcArrow.rotation != 0)
         {
            _mcArrow.rotation = 0;
         }
         _advanceCondition = null;
         _rewindCondition = null;
      }
      
      public static function set stage(param1:int) : void
      {
         if(Boolean(_doBob) && Boolean(_doBob.parent))
         {
            _container.removeChild(_doBob);
         }
         if(Boolean(_doArrow) && Boolean(_doArrow.parent))
         {
            _container.removeChild(_doArrow);
         }
         if(_mcArrow.rotation != 0)
         {
            _mcArrow.rotation = 0;
         }
         _advanceCondition = null;
         _rewindCondition = null;
         _stage = param1;
         Tick();
      }
      
      public static function Tick() : void
      {
         if(!BASE.isInfernoMainYardOrOutpost && (GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD || GLOBAL.mode == GLOBAL.e_BASE_MODE.WMATTACK || GLOBAL.mode == GLOBAL.e_BASE_MODE.WMVIEW))
         {
            if(_stage < 1)
            {
               _stage = 1;
            }
            if(_stage > _endstage)
            {
               _stage = _endstage;
            }
            if(!GLOBAL._catchup)
            {
               if(_currentStage != _stage)
               {
                  _currentStage = _stage;
                  Show();
               }
               if(_advanceCondition != null)
               {
                  _advanceCondition();
               }
               if(_rewindCondition != null)
               {
                  _rewindCondition();
               }
            }
         }
      }
      
      public static function Show() : void
      {
         var _loc1_:Point = null;
         var _loc2_:BFOUNDATION = null;
         var _loc3_:int = 0;
         var _loc5_:Point = null;
         var _loc6_:Number = NaN;
         var _loc7_:BFOUNDATION = null;
         var _loc8_:Boolean = false;
         var _loc9_:int = 0;
         var _loc10_:String = null;
         if(BASE.isInfernoMainYardOrOutpost)
         {
            return;
         }
         Console.print("TUTORIAL STAGE:" + TUTORIAL._stage + " " + TUTORIAL._currentStage);
         _loc1_ = new Point();
         var _loc4_:MovieClip = new MovieClip();
         if(_stage > 59)
         {
         }
         switch(_stage)
         {
            case 1:
               MAP._canScroll = false;
               for each(_loc2_ in BASE._buildingsAll)
               {
                  if(_loc2_._type == 1)
                  {
                     MAP.Focus(_loc2_.x,_loc2_.y);
                     break;
                  }
               }
               Add(2,BOBBOTTOMLEFTLOW,KEYS.Get("tut_1b",{"v1":LOGIN._playerName}),new Point(GLOBAL._SCREEN.right - 100,POINT_FULLSCREEN.y),["mc",UI2._top.mcFullscreen,new Point(0,12)],true,true);
               _mcBob.showTwoButtons("btn_nothanks","btn_fullscreen",clickedFullScreen);
               _mcBob.addFullScreenButton(clickedFullScreen);
               break;
            case 3:
               _stage = 31;
               break;
            case 4:
               MAP._canScroll = false;
               BASE._bankedValue = 0;
               Add(2,BOBBOTTOMLEFTLOW,KEYS.Get("tut_4"),null,null,false,false,ConditionBank,ConditionDeselectTwig);
               break;
            case 5:
               MAP._canScroll = false;
               Add(1,BOBBOTTOMLEFTLOW,KEYS.Get("tut_5",{"v1":BASE._bankedValue}),null,null,true,true);
               break;
            case 20:
               if(QUESTS._global.b1lvl == 2)
               {
                  Advance();
               }
               else
               {
                  BASE.BuildingDeselect();
                  MAP._canScroll = false;
                  for each(_loc2_ in BASE._buildingsAll)
                  {
                     if(_loc2_._type == 1)
                     {
                        MAP.Focus(_loc2_.x,_loc2_.y);
                        _loc1_.x = _loc2_.x + MAP._GROUND.x;
                        _loc1_.y = _loc2_.y + MAP._GROUND.y + 20;
                        break;
                     }
                  }
                  Add(2,BOBBOTTOMLEFTLOW,KEYS.Get("tut_20"),_loc1_,["mc",_loc2_._mcHit,new Point(0,20),-25],false,false,ConditionSelectTwig);
               }
               break;
            case 21:
               if(QUESTS._global.b1lvl == 2)
               {
                  Advance();
               }
               else
               {
                  MAP._canScroll = false;
                  Add(2,BOBBOTTOMLEFTLOW,KEYS.Get("tut_21"),null,null,false,false,ConditionBuildingOptionsOpen,ConditionDeselectTwig);
               }
               break;
            case 22:
               if(QUESTS._global.b1lvl == 2)
               {
                  Advance();
               }
               else
               {
                  MAP._canScroll = false;
                  if(BUILDINGOPTIONS._open)
                  {
                     _loc4_ = (BUILDINGOPTIONS._do as BUILDINGOPTIONSPOPUP).mcResources.bAction as MovieClip;
                     Add(2,BOBBOTTOMLEFTLOW,KEYS.Get("tut_22"),ARROW_BUILDING_UPGRADE,["mc",_loc4_,new Point(10,20),-130],false,false,ConditionBuildingOptionsClose);
                  }
                  else
                  {
                     Add(2,BOBBOTTOMLEFTLOW,KEYS.Get("tut_22"),ARROW_BUILDING_UPGRADE,null,false,false,ConditionBuildingOptionsClose);
                  }
               }
               break;
            case 23:
               if(QUESTS._global.b1lvl == 2)
               {
                  Advance();
               }
               else
               {
                  BASE.BuildingDeselect();
                  MAP._canScroll = false;
                  for each(_loc2_ in BASE._buildingsAll)
                  {
                     if(_loc2_._type == 1)
                     {
                        MAP.Focus(_loc2_.x,_loc2_.y);
                        _loc1_.x = _loc2_.x + MAP._GROUND.x;
                        _loc1_.y = _loc2_.y + MAP._GROUND.y + 20;
                        break;
                     }
                  }
                  Add(2,BOBBOTTOMLEFTLOW,KEYS.Get("tut_23"),_loc1_,["mc",_loc2_._mcHit,new Point(0,20),-35],false,false,ConditionSelectTwig,ConditionRewindNotUpgrading);
               }
               break;
            case 24:
               if(QUESTS._global.b1lvl == 2)
               {
                  Advance();
               }
               else
               {
                  MAP._canScroll = false;
                  Add(2,BOBBOTTOMLEFTLOW,KEYS.Get("tut_24"),null,null,false,false,ConditionStoreOpen,ConditionRewindDeselect);
               }
               break;
            case 25:
               if(QUESTS._global.b1lvl == 2)
               {
                  Advance();
               }
               else
               {
                  MAP._canScroll = false;
                  if(_freeSpeedup)
                  {
                     Add(2,BOBBOTTOMLEFTLOW,KEYS.Get("tut_25"),ARROW_STORE_BUY_1,["mc",STORE._mc as STOREPOPUP as MovieClip,new Point(-160,-72)],false,false,ConditionStoreClose);
                  }
                  else
                  {
                     Add(2,BOBBOTTOMLEFTLOW,KEYS.Get("tut_25_b"),ARROW_STORE_BUY_3,null,false,false,ConditionStoreClose);
                  }
               }
               break;
            case 26:
               QUESTS.Check();
               if(QUESTS._global.b1lvl < 2)
               {
                  _stage = 22;
                  Advance();
               }
               else
               {
                  BASE.BuildingDeselect();
                  MAP._canScroll = false;
                  if(GLOBAL._flags.viximo)
                  {
                     Add(2,BOBBOTTOMLEFTLOW,KEYS.Get("tut_26"),POINT_QUEST,["mc",UI_BOTTOM._mc.bQuests,new Point(15,15),-25],false,false,ConditionQuestsOpen,ConditionQuestCollectU1);
                  }
                  else
                  {
                     Add(2,BOBBOTTOMLEFTLOW,KEYS.Get("tut_26"),POINT_QUEST,["mc",UI_BOTTOM._missions,new Point(35,-150),-25],false,false,ConditionQuestsOpen,ConditionQuestCollectU1);
                  }
               }
               break;
            case 27:
               _advanceCondition = ConditionQuestCollectU1;
               break;
            case 31:
               SPRITES.SetupSprite("C2");
               Add(2,BOBBOTTOMLEFTLOW,KEYS.Get("tut_NWM_Step2"),POINT_BUILDINGS,["mc",UI_BOTTOM._mc.bBuild,new Point(15,15),-30],false,false,ConditionBuildingsOpen);
               break;
            case 32:
               if(BUILDINGS._open)
               {
                  _loc4_ = (BUILDINGS._mc as BUILDINGSPOPUP).b3 as MovieClip;
                  Add(2,BOBBOTTOMLEFTLOW,KEYS.Get("tut_NWM_Step3"),new Point(445,52),["mc",_loc4_,new Point(60,2),-160],false,false,ConditionBuildingsDefense,ConditionRewindBuildingsClosed);
               }
               else
               {
                  Add(2,BOBBOTTOMLEFTLOW,KEYS.Get("tut_NWM_Step3"),new Point(445,52),["percent",new Point(445,52),-160],false,false,ConditionBuildingsDefense,ConditionRewindBuildingsClosed);
               }
               break;
            case 33:
               Add(2,BOBBOTTOMLEFTLOW,KEYS.Get("tut_NWM_Step4"),new Point(166,242),["mc",BUILDINGS._mc as BUILDINGSPOPUP as MovieClip,new Point(160,247),150],false,false,ConditionBuildingsSniper,ConditionRewindBuildingsClosed);
               break;
            case 34:
               BASE.Fund(1,Math.max(GLOBAL._buildingProps[20].costs[0].r1 - BASE._resources.r1.Get(),0),false,null,false,false);
               BASE.Fund(2,Math.max(GLOBAL._buildingProps[20].costs[0].r2 - BASE._resources.r2.Get(),0),false,null,false,false);
               BASE.Fund(3,Math.max(GLOBAL._buildingProps[20].costs[0].r3 - BASE._resources.r3.Get(),0),false,null,false,false);
               BASE.Fund(4,Math.max(GLOBAL._buildingProps[20].costs[0].r4 - BASE._resources.r4.Get(),0),false,null,false,false);
               Add(2,BOBBOTTOMLEFTLOW,KEYS.Get("tut_NWM_Step5"),new Point(595,430 + _isSmallSizeOffset * 0.7),["mc",BUILDINGOPTIONS._do as BUILDINGOPTIONSPOPUP as MovieClip,new Point(500,230),-50],false,false,ConditionNewBuilding,ConditionRewindBuildingsDeselect21);
               break;
            case 35:
               MAP._canScroll = true;
               QUEUE._placed = 0;
               Add(2,BOBBOTTOMLEFTLOW,KEYS.Get("tut_NWM_Step6"),null,null,false,false,ConditionPlacedBuilding,ConditionRewindNoNewBuilding);
               break;
            case 36:
               if(QUESTS._global.b21lvl > 0)
               {
                  Advance();
               }
               else
               {
                  MAP._canScroll = false;
                  var _loc11_:int = 0;
                  var _loc12_:* = BASE._buildingsTowers;
                  for each(_loc2_ in _loc12_)
                  {
                     MAP.Focus(_loc2_.x,_loc2_.y);
                     _loc1_.x = _loc2_.x + MAP._GROUND.x;
                     _loc1_.y = _loc2_.y + MAP._GROUND.y + 20;
                  }
                  Add(1,BOBBOTTOMLEFTLOW,KEYS.Get("tut_NWM_Step7"),_loc1_,["mc",_loc2_._mcHit,new Point(30,0),-150],false,false,ConditionStoreOpen,ConditionConstructed21);
               }
               break;
            case k_STAGE_SNIPER_SPEEDUP:
               if(_freeSpeedup)
               {
                  Add(2,BOBBOTTOMLEFTLOW,KEYS.Get("tut_NWM_Step8"),ARROW_STORE_BUY_1,["mc",STORE._mc as STOREPOPUP as MovieClip,new Point(-160,-72),-120],false,false,ConditionConstructed21,ConditionStoreClose);
               }
               else
               {
                  Add(2,BOBBOTTOMLEFTLOW,KEYS.Get("tut_25_b"),ARROW_STORE_BUY_3,null,false,false,ConditionConstructed21,ConditionStoreClose);
               }
               break;
            case 38:
               MAP._canScroll = true;
               if(GLOBAL._flags.viximo)
               {
                  Add(1,BOBBOTTOMLEFTLOW,KEYS.Get("tut_NWM_Step9"),POINT_QUEST,["mc",UI_BOTTOM._mc.bQuests,new Point(15,15),-30],false,false,ConditionQuestsOpen,ConditionQuestCollectT1);
               }
               else
               {
                  Add(1,BOBBOTTOMLEFTLOW,KEYS.Get("tut_NWM_Step9"),POINT_QUEST,["mc",UI_BOTTOM._missions,new Point(35,-150),-30],false,false,ConditionQuestsOpen,ConditionQuestCollectT1);
               }
               break;
            case 39:
               _advanceCondition = ConditionQuestCollectT1;
               break;
            case 40:
               CUSTOMATTACKS.TutorialAttack();
               Add(4,BOBBOTTOMLEFTLOW,KEYS.Get("tut_NWM_Step10"),null,null,false,false,ConditionAttackOver);
               break;
            case 41:
               for each(_loc7_ in BASE._buildingsAll)
               {
                  if(_loc7_.health < _loc7_.maxHealth && _loc7_._repairing == 0)
                  {
                     _loc7_.Repair();
                  }
               }
               Advance();
               break;
            case 42:
               BUILDINGS._buildingID = 0;
               if(!("D1" in QUESTS._completed))
               {
                  QUESTS._completed.D1 = 1;
               }
               if(GLOBAL._flags.viximo)
               {
                  Add(6,BOBBOTTOMLEFTLOW,KEYS.Get("tut_NWM_Step11"),POINT_QUEST,["mc",UI_BOTTOM._mc.bQuests,new Point(15,15),-30],false,false,ConditionQuestsOpen,ConditionQuestCollectD1);
               }
               else
               {
                  Add(6,BOBBOTTOMLEFTLOW,KEYS.Get("tut_NWM_Step11"),POINT_QUEST,["mc",UI_BOTTOM._missions,new Point(35,-150),-30],false,false,ConditionQuestsOpen,ConditionQuestCollectD1);
               }
               break;
            case 43:
               _advanceCondition = ConditionQuestCollectD1;
               break;
            case 44:
               Add(8,BOBBOTTOMLEFTHIGH,KEYS.Get("tut_NWM_Step12"),new Point(_mcBob.mcButton.x,_mcBob.mcButton.y),["mc",_mcBob.mcButton,new Point(200,30),150],true,false);
               break;
            case 50:
               ImageCache.GetImageWithCallBack("buildingbuttons/15.jpg");
               Add(6,BOBBOTTOMLEFTLOW,KEYS.Get("tut_NWM_Step13"),POINT_BUILDINGS,["mc",UI_BOTTOM._mc.bBuild,new Point(15,15),-30],false,false,ConditionBuildingsOpen);
               break;
            case 51:
               if(BUILDINGS._mc)
               {
                  _loc4_ = (BUILDINGS._mc as BUILDINGSPOPUP).b2 as MovieClip;
               }
               Add(6,BOBBOTTOMLEFTLOW,KEYS.Get("tut_NWM_Step14"),new Point(322,51),["mc",_loc4_,new Point(60,22),160],false,false,ConditionBuildingsBuildings,ConditionRewindBuildingsClosedB);
               break;
            case 52:
               BASE.Fund(1,Math.max(GLOBAL._buildingProps[14].costs[0].r1 - BASE._resources.r1.Get(),0),false,null,false,false);
               BASE.Fund(2,Math.max(GLOBAL._buildingProps[14].costs[0].r2 - BASE._resources.r2.Get(),0),false,null,false,false);
               BASE.Fund(3,Math.max(GLOBAL._buildingProps[14].costs[0].r3 - BASE._resources.r3.Get(),0),false,null,false,false);
               BASE.Fund(4,Math.max(GLOBAL._buildingProps[14].costs[0].r4 - BASE._resources.r4.Get(),0),false,null,false,false);
               Add(6,BOBBOTTOMLEFTLOW,KEYS.Get("tut_NWM_Step15"),ARROW_BUILDINGS_HOUSING,["mc",BUILDINGS._mc as BUILDINGSPOPUP as MovieClip,new Point(500,240),-120],false,false,ConditionBuildingsHousing,ConditionRewindBuildingsClosedB);
               break;
            case 53:
               Add(6,BOBBOTTOMLEFTLOW,KEYS.Get("tut_NWM_Step16"),new Point(595,430 + _isSmallSizeOffset * 0.7),["mc",BUILDINGOPTIONS._do as BUILDINGOPTIONSPOPUP as MovieClip,new Point(500,230),-40],false,false,ConditionNewBuilding,ConditionRewindBuildingsDeselect15);
               break;
            case 54:
               SPRITES.SetupSprite("C1");
               MAP._canScroll = true;
               QUEUE._placed = 0;
               Add(6,BOBBOTTOMLEFTLOW,KEYS.Get("tut_NWM_Step17"),null,null,false,false,ConditionPlacedBuilding,ConditionRewindNoNewBuildingB);
               break;
            case 55:
               if(QUESTS._global.b15lvl > 0)
               {
                  Advance();
               }
               else
               {
                  _loc8_ = false;
                  MAP._canScroll = false;
                  for each(_loc2_ in BASE._buildingsAll)
                  {
                     if(_loc2_._type == 15)
                     {
                        MAP.Focus(_loc2_.x,_loc2_.y + 100);
                        _loc1_.x = _loc2_.x + MAP._GROUND.x;
                        _loc1_.y = _loc2_.y + MAP._GROUND.y + 200;
                        _loc8_ = true;
                        break;
                     }
                  }
                  if(Boolean(_loc2_) && _loc8_)
                  {
                     Add(6,BOBBOTTOMLEFTLOW,KEYS.Get("tut_NWM_Step18"),_loc1_,["mc",_loc2_._mcHit,new Point(0,80),-50],false,false,ConditionStoreOpen,ConditionConstructed15);
                  }
                  else
                  {
                     Add(6,BOBBOTTOMLEFTLOW,KEYS.Get("tut_NWM_Step18"),null,null,false,false,ConditionStoreOpen,ConditionConstructed15);
                  }
               }
               break;
            case 56:
               if(QUESTS._global.b15lvl > 0)
               {
                  Advance();
               }
               else if(!HOUSING.isHousingBuilding(GLOBAL._selectedBuilding._type))
               {
                  Rewind();
               }
               else if(_freeSpeedup)
               {
                  Add(6,BOBBOTTOMLEFTLOW,KEYS.Get("tut_NWM_Step19"),ARROW_STORE_BUY_1,["mc",STORE._mc as STOREPOPUP as MovieClip,new Point(-160,-72),160],false,false,ConditionConstructed15,ConditionRewindStoreClosed);
               }
               else
               {
                  Add(6,BOBBOTTOMLEFTLOW,KEYS.Get("tut_56_b"),ARROW_STORE_BUY_3,null,false,false,ConditionConstructed15,ConditionRewindStoreClosed);
               }
               break;
            case 57:
               BASE.BuildingDeselect();
               _loc5_ = GRID.ToISO(-600,0,0);
               _loc6_ = Point.distance(new Point(GLOBAL._bHousing.x,GLOBAL._bHousing.y),_loc5_);
               _loc9_ = 0;
               while(_loc9_ < 15)
               {
                  HOUSING.HousingStore("C1",new Point(_loc5_.x - 200 + Math.random() * 400,_loc5_.y - 100 + Math.random() * 200),false);
                  _loc9_++;
               }
               MAP.Focus(_loc5_.x,_loc5_.y);
               MAP.FocusTo(GLOBAL._bHousing.x,GLOBAL._bHousing.y,int(_loc6_ / 120),0,0,false);
               if(GLOBAL._flags.viximo)
               {
                  Add(6,BOBBOTTOMLEFTLOW,KEYS.Get("tut_NWM_Step20"),POINT_QUEST,["mc",UI_BOTTOM._mc.bQuests,new Point(15,15),-30],false,false,ConditionQuestsOpen,ConditionQuestCollectCR3);
               }
               else
               {
                  Add(6,BOBBOTTOMLEFTLOW,KEYS.Get("tut_NWM_Step20"),POINT_QUEST,["mc",UI_BOTTOM._missions,new Point(35,-150),-30],false,false,ConditionQuestsOpen,ConditionQuestCollectCR3);
               }
               break;
            case 58:
               _advanceCondition = ConditionQuestCollectCR3;
               break;
            case 60:
               MAP._canScroll = true;
               if(!_secondWorker)
               {
                  _stage = 64;
                  Advance();
               }
               else
               {
                  Add(6,BOBBOTTOMLEFTLOW,KEYS.Get("tut_60"),new Point(300,30),["mc",UI2._top.mc.mcR5,new Point(0,30),-170],true,true);
               }
               break;
            case 61:
               if(!_secondWorker)
               {
                  _stage = 64;
                  Advance();
               }
               else
               {
                  UI_BOTTOM.Update();
                  Add(6,BOBBOTTOMLEFTLOW,KEYS.Get("tut_61"),new Point(652,477),["mc",UI_BOTTOM._mc.bStore,new Point(15,15),-70],false,false,ConditionStoreOpen);
               }
               break;
            case 62:
               if(!_secondWorker)
               {
                  _stage = 64;
                  Advance();
               }
               else
               {
                  Add(6,BOBBOTTOMLEFTLOW,KEYS.Get("tut_62"),new Point(225,200),["mc",STORE._mc as STOREPOPUP as MovieClip,new Point(-160,-72),160],false,false,Condition2Workers,ConditionRewindStoreClosed);
               }
               break;
            case 63:
               Add(6,BOBBOTTOMLEFTLOW,KEYS.Get("tut_63"),null,null,true,true);
               break;
            case 65:
               if(QUESTS._global.b5lvl > 0)
               {
                  Advance();
               }
               else
               {
                  MAP._canScroll = true;
                  BUILDINGS._buildingID = 0;
                  Add(6,BOBBOTTOMLEFTLOW,KEYS.Get("tut_NWM_Step21"),POINT_BUILDINGS,["mc",UI_BOTTOM._mc.bBuild,new Point(15,15),-30],false,false,ConditionBuildingsOpen);
               }
               break;
            case 66:
               if(QUESTS._global.b5lvl > 0)
               {
                  Advance();
               }
               else
               {
                  _loc4_ = (BUILDINGS._mc as BUILDINGSPOPUP).b2 as MovieClip;
                  Add(6,BOBBOTTOMLEFTLOW,KEYS.Get("tut_66"),new Point(322,51),["mc",_loc4_,new Point(60,22),-160],false,false,ConditionBuildingsBuildings,ConditionRewindBuildingsClosedC);
               }
               break;
            case 67:
               if(QUESTS._global.b5lvl > 0)
               {
                  Advance();
               }
               else
               {
                  BASE.Fund(1,Math.max(GLOBAL._buildingProps[4].costs[0].r1 - BASE._resources.r1.Get(),0),false,null,false,false);
                  BASE.Fund(2,Math.max(GLOBAL._buildingProps[4].costs[0].r2 - BASE._resources.r2.Get(),0),false,null,false,false);
                  BASE.Fund(3,Math.max(GLOBAL._buildingProps[4].costs[0].r3 - BASE._resources.r3.Get(),0),false,null,false,false);
                  BASE.Fund(4,Math.max(GLOBAL._buildingProps[4].costs[0].r4 - BASE._resources.r4.Get(),0),false,null,false,false);
                  Add(6,BOBBOTTOMLEFTLOW,KEYS.Get("tut_NWM_Step22"),ARROW_BUILDINGS_FLINGER,["mc",BUILDINGS._mc as BUILDINGSPOPUP as MovieClip,new Point(225,330),-30],false,false,ConditionBuildingsFlinger,ConditionRewindBuildingsClosedC);
               }
               break;
            case 68:
               if(QUESTS._global.b5lvl > 0)
               {
                  Advance();
               }
               else
               {
                  Add(6,BOBBOTTOMLEFTLOW,KEYS.Get("tut_NWM_Step23"),new Point(595,430 + _isSmallSizeOffset * 0.7),["mc",BUILDINGOPTIONS._do as BUILDINGOPTIONSPOPUP as MovieClip,new Point(500,230),-150],false,false,ConditionNewBuilding,ConditionRewindBuildingsDeselect5);
               }
               break;
            case 69:
               if(QUESTS._global.b5lvl > 0)
               {
                  Advance();
               }
               else
               {
                  QUEUE._placed = 0;
                  MAP._canScroll = true;
                  Add(6,BOBBOTTOMLEFTLOW,KEYS.Get("tut_NWM_Step24"),null,null,false,false,ConditionPlacedBuilding,ConditionRewindNoNewBuildingC);
               }
               break;
            case 80:
               if(!_secondWorker)
               {
                  MAP._canScroll = false;
                  for each(_loc2_ in BASE._buildingsAll)
                  {
                     if(_loc2_._type == 5)
                     {
                        MAP.Focus(_loc2_.x,_loc2_.y);
                        _loc1_.x = _loc2_.x + MAP._GROUND.x;
                        _loc1_.y = _loc2_.y + MAP._GROUND.y + 20;
                        break;
                     }
                  }
                  if(GAME._isSmallSize)
                  {
                     Add(6,BOBBOTTOMLEFTLOW,KEYS.Get("tut_NWM_Step25"),_loc1_,["mc",_loc2_._mcHit,new Point(50,100),-160],false,false,ConditionStoreOpen,ConditionConstructed11);
                  }
                  else
                  {
                     Add(6,BOBBOTTOMLEFTLOW,KEYS.Get("tut_NWM_Step25"),_loc1_,["mc",_loc2_._mcHit,new Point(0,30),-160],false,false,ConditionStoreOpen,ConditionConstructed11);
                  }
                  break;
               }
               Advance();
               break;
            case 81:
               if(!_secondWorker)
               {
                  if(_freeSpeedup)
                  {
                     Add(6,BOBBOTTOMLEFTLOW,KEYS.Get("tut_NWM_Step26"),ARROW_STORE_BUY_4,["mc",STORE._mc as STOREPOPUP as MovieClip,new Point(-150,100),-30],false,false,ConditionConstructed5);
                  }
                  else
                  {
                     Add(6,BOBBOTTOMLEFTLOW,KEYS.Get("tut_NWM_Step26"),ARROW_STORE_BUY_3,null,false,false,ConditionConstructed5);
                  }
               }
               else
               {
                  Advance();
               }
               break;
            case 90:
               if(QUESTS._global.b11lvl > 0)
               {
                  Advance();
               }
               else
               {
                  BUILDINGS._buildingID = 0;
                  if(_secondWorker)
                  {
                     Add(6,BOBBOTTOMLEFTLOW,KEYS.Get("tut_90"),POINT_BUILDINGS,["mc",UI_BOTTOM._mc.bBuild,new Point(15,15),-30],false,false,ConditionBuildingsOpen);
                  }
                  else
                  {
                     Add(6,BOBBOTTOMLEFTLOW,KEYS.Get("tut_NWM_Step27"),POINT_BUILDINGS,["mc",UI_BOTTOM._mc.bBuild,new Point(15,15),-30],false,false,ConditionBuildingsOpen);
                  }
               }
               break;
            case 91:
               if(QUESTS._global.b11lvl > 0)
               {
                  Advance();
               }
               else
               {
                  _loc4_ = (BUILDINGS._mc as BUILDINGSPOPUP).b2 as MovieClip;
                  Add(6,BOBBOTTOMLEFTLOW,KEYS.Get("tut_NWM_Step27"),new Point(322,51),["mc",_loc4_,new Point(60,22),170],false,false,ConditionBuildingsBuildings,ConditionRewindBuildingsClosedD);
               }
               break;
            case 92:
               if(QUESTS._global.b11lvl > 0)
               {
                  Advance();
               }
               else
               {
                  BASE.Fund(1,Math.max(GLOBAL._buildingProps[10].costs[0].r1 - BASE._resources.r1.Get(),0),false,null,false,false);
                  BASE.Fund(2,Math.max(GLOBAL._buildingProps[10].costs[0].r2 - BASE._resources.r2.Get(),0),false,null,false,false);
                  BASE.Fund(3,Math.max(GLOBAL._buildingProps[10].costs[0].r3 - BASE._resources.r3.Get(),0),false,null,false,false);
                  BASE.Fund(4,Math.max(GLOBAL._buildingProps[10].costs[0].r4 - BASE._resources.r4.Get(),0),false,null,false,false);
                  if(GAME._isSmallSize)
                  {
                     Add(6,BOBBOTTOMLEFTLOW,KEYS.Get("tut_NWM_Step28"),ARROW_BUILDINGS_MAPROOM,["mc",BUILDINGS._mc as BUILDINGSPOPUP as MovieClip,new Point(480,340),-30],false,false,ConditionBuildingsMapRoom,ConditionRewindBuildingsDeselectBuildingsD);
                  }
                  else
                  {
                     Add(6,BOBBOTTOMLEFTLOW,KEYS.Get("tut_NWM_Step28"),ARROW_BUILDINGS_MAPROOM,["mc",BUILDINGS._mc as BUILDINGSPOPUP as MovieClip,new Point(480,330),-30],false,false,ConditionBuildingsMapRoom,ConditionRewindBuildingsDeselectBuildingsD);
                  }
               }
               break;
            case 93:
               if(QUESTS._global.b11lvl > 0)
               {
                  Advance();
               }
               else
               {
                  Add(6,BOBBOTTOMLEFTLOW,KEYS.Get("tut_NWM_Step29"),new Point(595,430 + _isSmallSizeOffset * 0.7),["mc",BUILDINGOPTIONS._do as BUILDINGOPTIONSPOPUP as MovieClip,new Point(500,230),-50],false,false,ConditionNewBuilding,ConditionRewindBuildingsDeselect11);
               }
               break;
            case 94:
               if(QUESTS._global.b11lvl > 0)
               {
                  Advance();
               }
               else
               {
                  QUEUE._placed = 0;
                  Add(6,BOBBOTTOMLEFTLOW,KEYS.Get("tut_NWM_Step30"),null,null,false,false,ConditionPlacedBuilding,ConditionRewindNoNewBuildingD);
               }
               break;
            case 95:
               if(QUESTS._global.b5lvl > 0 || !_secondWorker)
               {
                  Advance();
               }
               else
               {
                  for each(_loc2_ in BASE._buildingsAll)
                  {
                     if(_loc2_._type == 5)
                     {
                        MAP.Focus(_loc2_.x,_loc2_.y);
                        _loc1_.x = _loc2_.x + MAP._GROUND.x;
                        _loc1_.y = _loc2_.y + MAP._GROUND.y + 20;
                        break;
                     }
                  }
                  MAP._canScroll = false;
                  Add(6,BOBBOTTOMLEFTLOW,KEYS.Get("tut_95"),_loc1_,["mc",_loc2_._mcHit,new Point(0,20),-40],false,false,ConditionStoreOpen,ConditionConstructed5);
               }
               break;
            case 96:
               MAP._canScroll = true;
               if(QUESTS._global.b5lvl > 0)
               {
                  Advance();
               }
               else
               {
                  Add(6,BOBBOTTOMLEFTLOW,KEYS.Get("tut_96"),ARROW_STORE_BUY_4,["mc",STORE._mc as STOREPOPUP as MovieClip,new Point(-150,100),80],false,false,ConditionConstructed5,ConditionRewindStoreClosed);
               }
               break;
            case 97:
               if(QUESTS._global.b11lvl > 0)
               {
                  Advance();
               }
               else
               {
                  MAP._canScroll = false;
                  for each(_loc2_ in BASE._buildingsAll)
                  {
                     if(_loc2_._type == 11)
                     {
                        MAP.Focus(_loc2_.x,_loc2_.y);
                        _loc1_.x = _loc2_.x + MAP._GROUND.x;
                        _loc1_.y = _loc2_.y + MAP._GROUND.y + 20;
                        break;
                     }
                  }
                  if(GAME._isSmallSize)
                  {
                     Add(6,BOBBOTTOMLEFTLOW,KEYS.Get("tut_NWM_Step31"),_loc1_,["mc",_loc2_._mcHit,new Point(50,100),-160],false,false,ConditionStoreOpen,ConditionConstructed11);
                  }
                  else
                  {
                     Add(6,BOBBOTTOMLEFTLOW,KEYS.Get("tut_NWM_Step31"),_loc1_,["mc",_loc2_._mcHit,new Point(0,30),-160],false,false,ConditionStoreOpen,ConditionConstructed11);
                  }
               }
               break;
            case 98:
               MAP._canScroll = true;
               if(QUESTS._global.b11lvl > 0)
               {
                  Advance();
               }
               else if(_freeSpeedup)
               {
                  Add(6,BOBBOTTOMLEFTLOW,KEYS.Get("tut_98"),ARROW_STORE_BUY_4,["mc",STORE._mc as STOREPOPUP as MovieClip,new Point(-150,100),80],false,false,ConditionConstructed11,ConditionRewindStoreClosed);
               }
               else
               {
                  Add(6,BOBBOTTOMLEFTLOW,KEYS.Get("tut_98"),ARROW_STORE_BUY_3,null,false,false,ConditionConstructed11,ConditionRewindStoreClosed);
               }
               break;
            case 99:
               MAP._canScroll = true;
               if(GLOBAL._flags.viximo)
               {
                  Add(6,BOBBOTTOMLEFTLOW,KEYS.Get("tut_99"),POINT_QUEST,["mc",UI_BOTTOM._mc.bQuests,new Point(15,15),-30],false,false,ConditionQuestsOpen,ConditionQuestCollectBunch);
               }
               else
               {
                  Add(6,BOBBOTTOMLEFTLOW,KEYS.Get("tut_99"),POINT_QUEST,["mc",UI_BOTTOM._missions,new Point(35,-150),-30],false,false,ConditionQuestsOpen,ConditionQuestCollectBunch);
               }
               break;
            case 100:
               _advanceCondition = ConditionQuestCollectBunch;
               _rewindCondition = ConditionRewindQuestsClose;
               break;
            case 101:
               if(MapRoomManager.instance.isInMapRoom3)
               {
                  MapRoom3Tutorial.instance.start();
               }
               else
               {
                  BASE.BuildingDeselect();
                  Add(6,BOBBOTTOMLEFTLOW,KEYS.Get("tut_101"),POINT_MAP,["mc",UI_BOTTOM._mc.bMap,new Point(15,15),-30],false,false,ConditionMapRoomOpen);
               }
               break;
            case 102:
               if(!MAPROOM._open)
               {
                  Rewind();
               }
               else
               {
                  Add(6,BOBBOTTOMLEFTLOW,KEYS.Get("tut_102"),POINT_MAP,["mc",MAPROOM._mc,new Point(310,270),-30],false,false,ConditionFightBack,ConditionRewindMapClosed);
                  _mcArrow.alpha = 0;
                  TweenLite.to(_mcArrow,0.75,{
                     "autoAlpha":1,
                     "delay":1,
                     "overwrite":1
                  });
               }
               break;
            case 110:
               MapRoom3Tutorial.instance.advance();
               MAP.Focus(-200,0);
               MAP.FocusTo(200,0,5,0,0,false);
               Add(6,BOBBOTTOMLEFTLOW,KEYS.Get("tut_110"),new Point(_mcBob.mcButton.x,_mcBob.mcButton.y),["mc",_mcBob.mcButton,new Point(200,30),150],true,true);
               break;
            case 111:
               if(GLOBAL.mode == GLOBAL.e_BASE_MODE.ATTACK || GLOBAL.mode == GLOBAL.e_BASE_MODE.WMATTACK)
               {
                  if(UI2._top._creatureButtons[0])
                  {
                     _loc4_ = UI2._top._creatureButtons[0];
                     Add(6,BOBBOTTOMLEFTLOW,KEYS.Get("tut_111"),new Point(102,152),["mc",_loc4_,new Point(100,40),160],false,false,ConditionFlingerAdd15,ConditionFlung);
                  }
               }
               else
               {
                  Add(6,BOBBOTTOMLEFTLOW,KEYS.Get("tut_111"),new Point(102,152),null,false,false,ConditionFlingerAdd15,ConditionFlung);
               }
               break;
            case 112:
               MAP._canScroll = false;
               for each(_loc2_ in BASE._buildingsAll)
               {
                  if(_loc2_._type == 14)
                  {
                     MAP.Focus(_loc2_.x,_loc2_.y);
                     _loc1_.x = _loc2_.x + MAP._GROUND.x;
                     _loc1_.y = _loc2_.y + MAP._GROUND.y + 20;
                     break;
                  }
               }
               Add(6,BOBBOTTOMLEFTLOW,KEYS.Get("tut_112"),_loc1_,["mc",_loc2_._mcHit,new Point(0,-200),-160],false,false,ConditionFlung);
               break;
            case 113:
               MapRoom3Tutorial.instance.clear();
               MAP._canScroll = true;
               _timer = 0;
               _loc3_ = 0;
               for(_loc10_ in ATTACK._curCreaturesAvailable)
               {
                  _loc3_ += ATTACK._curCreaturesAvailable[_loc10_];
               }
               if(_loc3_ > 0)
               {
                  Add(6,BOBBOTTOMLEFTLOW,KEYS.Get("tut_113_more"),null,null,false,false,ConditionTimer10);
               }
               else
               {
                  Add(6,BOBBOTTOMLEFTLOW,KEYS.Get("tut_113"),null,null,false,false,ConditionTimer5);
               }
               break;
            case 114:
               _timer = 0;
               Add(6,BOBBOTTOMLEFTLOW,KEYS.Get("tut_114"),null,null,false,false,ConditionTimer5);
               break;
            case 115:
               _timer = 0;
               Add(6,BOBBOTTOMLEFTLOW,KEYS.Get("tut_115"),null,null,false,false,ConditionTimer5);
               break;
            case 116:
               _timer = 0;
               Add(6,BOBBOTTOMLEFTLOW,KEYS.Get("tut_116"),null,null,false,false,ConditionCrushedEnemy);
               break;
            case 120:
               Add(6,BOBBOTTOMLEFTLOW,KEYS.Get("tut_120"),null,null,false,false,ConditionReturnToYard);
               break;
            case 130:
               MapRoom3Tutorial.instance.finish();
               QUESTS.Check("destroy_tribe1",1);
               MAP._canScroll = false;
               Add(6,BOBBOTTOMLEFTLOW,KEYS.Get("tut_130"),new Point(84,60),null,false,false,ConditionPopupClose);
               break;
            case 131:
               QUESTS.Check("destroy_tribe1",1);
               MAP._canScroll = false;
               if(GLOBAL._flags.viximo)
               {
                  Add(6,BOBBOTTOMLEFTLOW,KEYS.Get("tut_131"),POINT_QUEST,["mc",UI_BOTTOM._mc.bQuests,new Point(15,15),-30],false,false,ConditionQuestsOpen,ConditionQuestCollectWM1);
               }
               else
               {
                  Add(6,BOBBOTTOMLEFTLOW,KEYS.Get("tut_131"),POINT_QUEST,["mc",UI_BOTTOM._missions,new Point(35,-150),-30],false,false,ConditionQuestsOpen,ConditionQuestCollectWM1);
               }
               break;
            case 132:
               QUESTS.Check("destroy_tribe1",1);
               MAP._canScroll = false;
               _advanceCondition = ConditionQuestCollectWM1;
               break;
            case 140:
               if(QUESTS._global.b13lvl > 0)
               {
                  Advance();
               }
               else
               {
                  MAP._canScroll = true;
                  Add(2,BOBBOTTOMLEFTLOW,KEYS.Get("tut_140"),POINT_BUILDINGS,["mc",UI_BOTTOM._mc.bBuild,new Point(15,15),-30],false,false,ConditionBuildingsOpen);
               }
               break;
            case 141:
               if(QUESTS._global.b13lvl > 0)
               {
                  Advance();
               }
               else
               {
                  _loc4_ = (BUILDINGS._mc as BUILDINGSPOPUP).b2 as MovieClip;
                  Add(2,BOBBOTTOMLEFTLOW,KEYS.Get("tut_141"),new Point(322,51),["mc",_loc4_,new Point(60,22),-170],false,false,ConditionBuildingsBuildings,ConditionRewindBuildingsClosedE);
               }
               break;
            case 142:
               if(QUESTS._global.b13lvl > 0)
               {
                  Advance();
               }
               else
               {
                  Add(2,BOBBOTTOMLEFTLOW,KEYS.Get("tut_142"),ARROW_BUILDINGS_HATCHERY,["mc",BUILDINGS._mc as BUILDINGSPOPUP as MovieClip,new Point(600,230),-160],false,false,ConditionBuildingsHatchery,ConditionRewindBuildingsClosedE);
               }
               break;
            case 143:
               if(QUESTS._global.b13lvl > 0)
               {
                  Advance();
               }
               else
               {
                  Add(2,BOBBOTTOMLEFTLOW,KEYS.Get("tut_143"),new Point(595,430 + _isSmallSizeOffset * 0.7),["mc",BUILDINGOPTIONS._do as BUILDINGOPTIONSPOPUP as MovieClip,new Point(500,230),-30],false,false,ConditionNewBuilding,ConditionRewindBuildingsDeselect13);
               }
               break;
            case 144:
               if(QUESTS._global.b13lvl > 0)
               {
                  Advance();
               }
               else
               {
                  QUEUE._placed = 0;
                  Add(2,BOBBOTTOMLEFTLOW,KEYS.Get("tut_144"),null,null,false,false,ConditionPlacedBuilding,ConditionRewindNoNewBuildingE);
               }
               break;
            case 145:
               if(QUESTS._global.b13lvl > 0)
               {
                  Advance();
               }
               else
               {
                  MAP._canScroll = false;
                  for each(_loc2_ in BASE._buildingsAll)
                  {
                     if(_loc2_._type == 13)
                     {
                        MAP.Focus(_loc2_.x,_loc2_.y);
                        _loc1_.x = _loc2_.x + MAP._GROUND.x;
                        _loc1_.y = _loc2_.y + MAP._GROUND.y + 20;
                        break;
                     }
                  }
                  if(GAME._isSmallSize)
                  {
                     Add(6,BOBBOTTOMLEFTLOW,KEYS.Get("tut_145"),_loc1_,["mc",_loc2_._mcHit,new Point(50,100),-160],false,false,ConditionStoreOpen,ConditionConstructed13);
                  }
                  else
                  {
                     Add(6,BOBBOTTOMLEFTLOW,KEYS.Get("tut_145"),_loc1_,["mc",_loc2_._mcHit,new Point(0,30),-160],false,false,ConditionStoreOpen,ConditionConstructed13);
                  }
               }
               break;
            case 146:
               MAP._canScroll = true;
               if(QUESTS._global.b13lvl > 0)
               {
                  Advance();
               }
               else if(_freeSpeedup)
               {
                  Add(2,BOBBOTTOMLEFTLOW,KEYS.Get("tut_146"),ARROW_STORE_BUY_4,["mc",STORE._mc as STOREPOPUP as MovieClip,new Point(-150,100),160],false,false,ConditionConstructed13,ConditionRewindStoreClosed);
               }
               else
               {
                  Add(2,BOBBOTTOMLEFTLOW,KEYS.Get("tut_146"),ARROW_STORE_BUY_3,null,false,false,ConditionConstructed13,ConditionRewindStoreClosed);
               }
               break;
            case 150:
               MAP._canScroll = false;
               for each(_loc2_ in BASE._buildingsAll)
               {
                  if(_loc2_._type == 13)
                  {
                     MAP.Focus(_loc2_.x,_loc2_.y);
                     _loc1_.x = _loc2_.x + MAP._GROUND.x;
                     _loc1_.y = _loc2_.y + MAP._GROUND.y + 20;
                     break;
                  }
               }
               if(GAME._isSmallSize)
               {
                  Add(2,BOBBOTTOMLEFTLOW,KEYS.Get("tut_150"),_loc1_,["mc",_loc2_._mcHit,new Point(50,100),-160],false,false,ConditionHatcheryOpen);
               }
               else
               {
                  Add(2,BOBBOTTOMLEFTLOW,KEYS.Get("tut_150"),_loc1_,["mc",_loc2_._mcHit,new Point(0,30),-160],false,false,ConditionHatcheryOpen);
               }
               break;
            case 151:
               MAP._canScroll = true;
               _timer = 0;
               if(HATCHERY._mc._monsterSlots[0])
               {
                  _loc4_ = HATCHERY._mc._monsterSlots[0];
               }
               else
               {
                  (_loc4_ = new MovieClip()).x = HATCHERY._mc.x + HATCHERY._mc.monsterCanvas.x;
                  _loc4_.y = HATCHERY._mc.y + HATCHERY._mc.monsterCanvas.y;
               }
               Add(2,BOBBOTTOMLEFTLOW,KEYS.Get("tut_151"),new Point(130,217),["mc",_loc4_,new Point(55,40),160],false,false,ConditionHatcheryProducing,ConditionRewindHatcheryClose);
               break;
            case 152:
               Add(1,BOBBOTTOMLEFTLOW,KEYS.Get("tut_152"),new Point(730,21),["mc",HATCHERY._mc as MovieClip,new Point(346,-240),-120],false,false,ConditionHatcheryClose);
               break;
            case 160:
               if(!_secondWorker)
               {
                  _stage = 169;
                  Advance();
               }
               else if(QUESTS._global.b3lvl > 0)
               {
                  Advance();
               }
               else
               {
                  Add(2,BOBBOTTOMLEFTLOW,KEYS.Get("tut_NWM_Step51"),POINT_BUILDINGS,["mc",UI_BOTTOM._mc.bBuild,new Point(15,15),-30],false,false,ConditionBuildingsOpen);
               }
               break;
            case 161:
               if(QUESTS._global.b3lvl > 0)
               {
                  Advance();
               }
               else
               {
                  _loc4_ = (BUILDINGS._mc as BUILDINGSPOPUP).b1 as MovieClip;
                  Add(2,BOBBOTTOMLEFTLOW,KEYS.Get("tut_NWM_Step52"),new Point(216,50),["mc",_loc4_,new Point(60,22),170],false,false,ConditionBuildingsResources,ConditionRewindBuildingsClosedF);
               }
               break;
            case 162:
               if(QUESTS._global.b3lvl > 0)
               {
                  Advance();
               }
               else
               {
                  Add(2,BOBBOTTOMLEFTLOW,KEYS.Get("tut_NWM_Step53"),new Point(363,256),["mc",BUILDINGS._mc as BUILDINGSPOPUP as MovieClip,new Point(356,253),-155],false,false,ConditionBuildingsPutty,ConditionRewindBuildingsClosedF);
               }
               break;
            case 163:
               if(QUESTS._global.b3lvl > 0)
               {
                  Advance();
               }
               else
               {
                  Add(2,BOBBOTTOMLEFTLOW,KEYS.Get("tut_NWM_Step54"),new Point(595,430 + _isSmallSizeOffset * 0.7),["mc",BUILDINGOPTIONS._do as BUILDINGOPTIONSPOPUP as MovieClip,new Point(500,230),-120],false,false,ConditionNewBuilding,ConditionRewindBuildingsDeselect3);
               }
               break;
            case 164:
               if(QUESTS._global.b3lvl > 0)
               {
                  Advance();
               }
               else
               {
                  QUEUE._placed = 0;
                  Add(2,BOBBOTTOMLEFTLOW,KEYS.Get("tut_NWM_Step55"),null,null,false,false,ConditionPlacedBuilding,ConditionRewindNoNewBuildingF);
               }
               break;
            case 170:
               if(QUESTS._global.b4lvl > 0)
               {
                  Advance();
               }
               else
               {
                  Add(2,BOBBOTTOMLEFTLOW,KEYS.Get("tut_NWM_Step56"),POINT_BUILDINGS,["mc",UI_BOTTOM._mc.bBuild,new Point(15,15),-30],false,false,ConditionBuildingsOpen);
               }
               break;
            case 171:
               if(QUESTS._global.b4lvl > 0)
               {
                  Advance();
               }
               else
               {
                  _loc4_ = (BUILDINGS._mc as BUILDINGSPOPUP).b1 as MovieClip;
                  Add(2,BOBBOTTOMLEFTLOW,KEYS.Get("tut_171"),new Point(300,300),["mc",_loc4_,new Point(60,22),170],false,false,ConditionBuildingsResources,ConditionRewindBuildingsClosedG);
               }
               break;
            case 172:
               if(QUESTS._global.b4lvl > 0)
               {
                  Advance();
               }
               else
               {
                  Add(2,BOBBOTTOMLEFTLOW,KEYS.Get("tut_NWM_Step57"),new Point(488,245),["mc",BUILDINGS._mc as BUILDINGSPOPUP as MovieClip,new Point(470,240),-160],false,false,ConditionBuildingsGoo,ConditionRewindBuildingsClosedG);
               }
               break;
            case 173:
               if(QUESTS._global.b4lvl > 0)
               {
                  Advance();
               }
               else
               {
                  Add(2,BOBBOTTOMLEFTLOW,KEYS.Get("tut_NWM_Step58"),new Point(595,430 + _isSmallSizeOffset * 0.7),["mc",BUILDINGOPTIONS._do as BUILDINGOPTIONSPOPUP as MovieClip,new Point(500,230),-30],false,false,ConditionNewBuilding,ConditionRewindBuildingsDeselect4);
               }
               break;
            case 174:
               if(QUESTS._global.b4lvl > 0)
               {
                  Advance();
               }
               else
               {
                  QUEUE._placed = 0;
                  Add(2,BOBBOTTOMLEFTLOW,KEYS.Get("tut_NWM_Step59"),null,null,false,false,ConditionPlacedGooFactory,ConditionRewindNoNewBuildingG);
               }
               break;
            case 180:
               Add(1,BOBBOTTOMLEFTHIGH,KEYS.Get("tut_NWM_Step60"),new Point(205,-5),["mc",_mcBob.mcButton,new Point(200,30),150],true,true);
               break;
            case 181:
               Add(1,BOBBOTTOMLEFTHIGH,KEYS.Get("tut_NWM_Step61"),new Point(205,-5),["mc",_mcBob.mcButton,new Point(200,30),150],true,true);
               break;
            case k_STAGE_DAMAGE_PROTECT:
               BASE._isProtected = GLOBAL.Timestamp() + 604800;
               UI2.Update();
               Add(1,BOBBOTTOMLEFTHIGH,KEYS.Get("tut_NWM_Step62"),new Point(740,70),["mc",UI2._top.mcProtected,new Point(5,20),-160],true,true);
               break;
            case 191:
               Advance();
               break;
            case 192:
               if(GLOBAL._flags.viximo)
               {
                  Add(1,BOBBOTTOMLEFTHIGH,KEYS.Get("tut_NWM_Step63"),POINT_QUEST,["mc",UI_BOTTOM._mc.bQuests,new Point(15,15),-30],true,true);
               }
               else
               {
                  Add(1,BOBBOTTOMLEFTHIGH,KEYS.Get("tut_NWM_Step63"),POINT_QUEST,["mc",UI_BOTTOM._missions,new Point(35,-150),-30],true,true);
               }
               break;
            case 193:
               UI_WORKERS.Show();
               BASE.Save();
               Advance();
               break;
            default:
               if(_stage >= _endstage)
               {
                  _stage = _endstage;
               }
               else
               {
                  Advance();
               }
         }
         if(STORE._open || BUILDINGS._open)
         {
            ShowStoreCB();
         }
      }
      
      public static function ShowStoreCB() : void
      {
         var _loc2_:BFOUNDATION = null;
         var _loc3_:int = 0;
         var _loc4_:DisplayObject = null;
         var _loc5_:Point = null;
         var _loc6_:Array = null;
         var _loc7_:* = undefined;
         var _loc8_:int = 0;
      }
      
      public static function Add(param1:int, param2:Point, param3:String, param4:Point = null, param5:Array = null, param6:Boolean = false, param7:Boolean = false, param8:Function = null, param9:Function = null) : void
      {
         param2 = AdjustPoint(param2,"bob");
         _mcBob.SetPos(param2.x,param2.y);
         _mcBob.Say(param3,param7,param6);
         if(param6)
         {
            _advanceCondition = null;
         }
         else
         {
            _advanceCondition = param8;
         }
         _rewindCondition = param9;
         if(_stage < 200)
         {
            _mcBob.mcButton.SetupKey("tut_next_btn");
         }
         else
         {
            _mcBob.mcButton.SetupKey("tut_finish_btn");
         }
         if(param7)
         {
            _mcBob.mcBlocker.visible = true;
         }
         else
         {
            _mcBob.mcBlocker.visible = false;
         }
         _mcBob.mcArrow.visible = false;
         if(param6)
         {
            if(_stage <= 5)
            {
               _mcBob.mcArrow.visible = true;
            }
            _mcBob.mcButton.visible = true;
            _mcBob.mcBubble.height = _mcBob.mcText.height + 55;
            _advanceCondition = null;
         }
         else
         {
            _mcBob.mcButton.visible = false;
            _mcBob.mcBubble.height = _mcBob.mcText.height + 15;
            _advanceCondition = param8;
         }
         _mcBob.mcText.y = 0 - _mcBob.mcBubble.height + 10;
         if(param4)
         {
            if(param5)
            {
               _mcArrow.ResizeParams = param5;
               if(param5[0] == "mc" && param5[1] && param5[1] is DisplayObject)
               {
                  if(param5[2] is Point)
                  {
                     param4 = AdjustPoint(param4,"mc",param5[1],param5[2]);
                  }
                  else
                  {
                     param4 = AdjustPoint(param4,"mc",param5[1]);
                  }
               }
               else if(param5[0] == "percent" && param5[1] && param5[1] is Point)
               {
                  _mcArrow.SetPos(param4.x,param4.y);
                  param4 = AdjustPoint(param4,"percent");
               }
            }
            else
            {
               _mcArrow.SetPos(param4.x,param4.y);
               param4 = AdjustPoint(param4,"hand");
               _mcArrow.ResizeParams = null;
            }
         }
         if(param4)
         {
            _mcArrow.x = param4.x;
            _mcArrow.y = param4.y;
            _mcArrow.Rotate();
            _mcArrow.mcArrow.mcArrow.y = -82;
            TweenLite.to(_mcArrow.mcArrow.mcArrow,0.6,{
               "y":-72,
               "ease":Elastic.easeOut
            });
            _doArrow = _container.addChild(_mcArrow);
         }
         _doBob = _container.addChild(_mcBob);
         _mcBob.Resize();
      }
      
      private static function clickedFullScreen(param1:MouseEvent) : void
      {
         _mcBob.removeFullScreenButton();
         if(!GLOBAL.isFullScreen)
         {
            GLOBAL.goFullScreen(param1);
         }
         TUTORIAL.Advance(param1);
      }
      
      private static function ConditionScroll() : void
      {
         if(MAP._dragDistance > 100)
         {
            Advance();
         }
      }
      
      private static function ConditionSelectTwig() : void
      {
         if(Boolean(GLOBAL._selectedBuilding) && GLOBAL._selectedBuilding._type != 1)
         {
            BASE.BuildingDeselect();
         }
         if(Boolean(GLOBAL._selectedBuilding) && GLOBAL._selectedBuilding._type == 1)
         {
            Advance();
         }
      }
      
      private static function ConditionBank() : void
      {
         if(BASE._bankedValue > 0)
         {
            Advance();
         }
      }
      
      private static function ConditionDeselectTwig() : void
      {
         if(!GLOBAL._selectedBuilding || GLOBAL._selectedBuilding._type != 1)
         {
            Rewind();
         }
      }
      
      private static function ConditionQuestCollectQ1() : void
      {
         if(QUESTS._completed.Q1 == 2)
         {
            Advance();
         }
      }
      
      private static function ConditionQuestCollectQ2() : void
      {
         if(QUESTS._completed.Q2 == 2)
         {
            Advance();
         }
      }
      
      private static function ConditionQuestCollectU1() : void
      {
         if(QUESTS._completed.U1 == 2)
         {
            Advance();
         }
      }
      
      private static function ConditionQuestCollectT1() : void
      {
         if(QUESTS._completed.T1 == 2)
         {
            Advance();
         }
      }
      
      private static function ConditionQuestCollectD1() : void
      {
         if(QUESTS._completed.D1 == 2)
         {
            Advance();
         }
      }
      
      private static function ConditionQuestCollectWM1() : void
      {
         if(QUESTS._completed.WM1 == 2)
         {
            Advance();
         }
      }
      
      private static function ConditionQuestCollectCR3() : void
      {
         if(QUESTS._completed.CR3 == 2)
         {
            Advance();
         }
      }
      
      private static function ConditionQuestCollectBunch() : void
      {
         if(QUESTS._completed.C17 == 2 && QUESTS._completed.C18 == 2)
         {
            Advance();
         }
      }
      
      private static function ConditionPopupOpen() : void
      {
         if(POPUPS._open)
         {
            Advance();
         }
      }
      
      private static function ConditionPopupClose() : void
      {
         if(!POPUPS._open)
         {
            Advance();
         }
      }
      
      private static function ConditionBuildingOptionsOpen() : void
      {
         if(BUILDINGOPTIONS._open)
         {
            Advance();
         }
      }
      
      private static function ConditionBuildingOptionsClose() : void
      {
         if(!BUILDINGOPTIONS._open)
         {
            Advance();
         }
      }
      
      private static function ConditionStoreOpen() : void
      {
         if(STORE._open)
         {
            Advance();
         }
      }
      
      private static function ConditionStoreClose() : void
      {
         if(!STORE._open)
         {
            Advance();
         }
      }
      
      private static function ConditionBuildingsOpen() : void
      {
         if(BUILDINGS._open)
         {
            Advance();
         }
      }
      
      private static function ConditionMapRoomOpen() : void
      {
         if(MAPROOM._open)
         {
            Advance();
         }
      }
      
      private static function ConditionBuildingsDefense() : void
      {
         if(BUILDINGS._open && BUILDINGS._menuA == 3)
         {
            Advance();
         }
      }
      
      private static function ConditionBuildingsBuildings() : void
      {
         if(BUILDINGS._open && BUILDINGS._menuA == 2)
         {
            Advance();
         }
      }
      
      private static function ConditionBuildingsResources() : void
      {
         if(BUILDINGS._open && BUILDINGS._menuA == 1)
         {
            Advance();
         }
      }
      
      private static function ConditionBuildingsSniper() : void
      {
         if(BUILDINGS._open && BUILDINGS._buildingID == 21)
         {
            Advance();
         }
      }
      
      private static function ConditionBuildingsHatchery() : void
      {
         if(BUILDINGS._open && BUILDINGS._buildingID == 13)
         {
            Advance();
         }
      }
      
      private static function ConditionBuildingsHousing() : void
      {
         if(BUILDINGS._open && HOUSING.isHousingBuilding(BUILDINGS._buildingID))
         {
            Advance();
         }
      }
      
      private static function ConditionBuildingsPutty() : void
      {
         if(BUILDINGS._open && BUILDINGS._buildingID == 3)
         {
            Advance();
         }
      }
      
      private static function ConditionBuildingsGoo() : void
      {
         if(BUILDINGS._open && BUILDINGS._buildingID == 4)
         {
            Advance();
         }
      }
      
      private static function ConditionBuildingsFlinger() : void
      {
         if(BUILDINGS._open && BUILDINGS._buildingID == 5)
         {
            Advance();
         }
      }
      
      private static function ConditionBuildingsMapRoom() : void
      {
         if(BUILDINGS._open && BUILDINGS._buildingID == 11)
         {
            Advance();
         }
      }
      
      private static function ConditionHatcheryProducing() : void
      {
         ++_timer;
         if(Boolean((GLOBAL._bHatchery as BUILDING13)._inProduction) && _timer > 40 * 2)
         {
            Advance();
         }
      }
      
      private static function ConditionNewBuilding() : void
      {
         if(GLOBAL._newBuilding)
         {
            Advance();
         }
      }
      
      private static function ConditionPlacedBuilding() : void
      {
         if(QUEUE._placed > 0)
         {
            Advance();
         }
      }
      
      private static function ConditionPlacedGooFactory() : void
      {
         var _loc1_:Vector.<Object> = InstanceManager.getInstancesByClass(BUILDING4);
         if(!_loc1_ || _loc1_.length <= 0)
         {
            return;
         }
         var _loc2_:BUILDING4 = _loc1_[0] as BUILDING4;
         if(Boolean(_loc2_) && !_loc2_._placing)
         {
            Advance();
         }
      }
      
      private static function ConditionWorkerBusy() : void
      {
         if(QUEUE._workingCount > 0)
         {
            Advance();
         }
      }
      
      private static function ConditionConstructed21() : void
      {
         if(QUESTS._global.b21lvl > 0)
         {
            Advance();
         }
      }
      
      private static function ConditionConstructed15() : void
      {
         if(QUESTS._global.b15lvl > 0)
         {
            Advance();
         }
      }
      
      private static function ConditionConstructed5() : void
      {
         if(QUESTS._global.b5lvl > 0)
         {
            Advance();
         }
      }
      
      private static function ConditionConstructed11() : void
      {
         if(QUESTS._global.b11lvl > 0)
         {
            Advance();
         }
      }
      
      private static function ConditionConstructed13() : void
      {
         if(QUESTS._global.b13lvl > 0)
         {
            Advance();
         }
      }
      
      private static function ConditionAttackOver() : void
      {
         if(CREEPS._creepCount == 2)
         {
            CREEPS.Retreat();
         }
         if(!WMATTACK._inProgress)
         {
            Advance();
         }
      }
      
      private static function Condition2Workers() : void
      {
         if(QUEUE._workerCount > 1)
         {
            Advance();
         }
      }
      
      private static function ConditionBuildingFlinger() : void
      {
         if(GLOBAL._bFlinger)
         {
            Advance();
         }
      }
      
      private static function ConditionBuildingMapRoom() : void
      {
         if(GLOBAL._bMap)
         {
            Advance();
         }
      }
      
      private static function ConditionRewindBuildingOptionsClose() : void
      {
         if(!BUILDINGOPTIONS._open)
         {
            Rewind();
         }
      }
      
      private static function ConditionRewindNotUpgrading() : void
      {
         if(QUEUE._workingCount == 0)
         {
            _stage = 9;
            Advance();
         }
      }
      
      private static function ConditionRewindNotLevel2() : void
      {
         if(QUESTS._global.blvl < 2)
         {
            _stage = 19;
            Advance();
         }
      }
      
      private static function ConditionTimer5() : void
      {
         ++_timer;
         if(_timer == 40 * 3)
         {
            Advance();
         }
      }
      
      private static function ConditionTimer10() : void
      {
         ++_timer;
         if(_timer == 40 * 7)
         {
            Advance();
         }
      }
      
      private static function ConditionFightBack() : void
      {
         if(GLOBAL.mode == GLOBAL.e_BASE_MODE.WMATTACK)
         {
            Advance();
         }
      }
      
      private static function ConditionReturnToYard() : void
      {
         if(GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD)
         {
            Advance();
         }
      }
      
      private static function ConditionFlingerAdd15() : void
      {
         var _loc2_:SecNum = null;
         var _loc1_:int = 0;
         for each(_loc2_ in ATTACK._flingerBucket)
         {
            _loc1_ += _loc2_.Get();
         }
         if(_loc1_ >= 15)
         {
            Advance();
         }
      }
      
      private static function ConditionFlung() : void
      {
         if(CREEPS._creepCount > 0)
         {
            Advance();
         }
      }
      
      private static function ConditionCrushedEnemy() : void
      {
         var _loc3_:BFOUNDATION = null;
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         for each(_loc3_ in BASE._buildingsAll)
         {
            if(_loc3_._class != "wall")
            {
               _loc1_ += _loc3_.health;
               _loc2_ += 1;
            }
         }
         if(_loc1_ <= 0)
         {
            Advance();
         }
      }
      
      private static function ConditionQuestsOpen() : void
      {
         if(QUESTS._open)
         {
            Advance();
         }
      }
      
      private static function ConditionHatcheryOpen() : void
      {
         if(HATCHERY._open)
         {
            Advance();
         }
      }
      
      private static function ConditionHatcheryClose() : void
      {
         if(!HATCHERY._open)
         {
            Advance();
         }
      }
      
      private static function ConditionRewindDeselect() : void
      {
         if(!GLOBAL._selectedBuilding)
         {
            Rewind();
         }
      }
      
      private static function ConditionRewindBuildingsClosed() : void
      {
         if(!BUILDINGS._open)
         {
            _stage = 30;
            Advance();
         }
      }
      
      private static function ConditionRewindBuildingsClosedB() : void
      {
         if(!BUILDINGS._open)
         {
            _stage = 49;
            Advance();
         }
      }
      
      private static function ConditionRewindBuildingsClosedC() : void
      {
         if(!BUILDINGS._open)
         {
            _stage = 61;
            Advance();
         }
      }
      
      private static function ConditionRewindBuildingsClosedD() : void
      {
         if(!BUILDINGS._open)
         {
            _stage = 89;
            Advance();
         }
      }
      
      private static function ConditionRewindBuildingsClosedE() : void
      {
         if(!BUILDINGS._open)
         {
            _stage = 139;
            Advance();
         }
      }
      
      private static function ConditionRewindBuildingsClosedF() : void
      {
         if(!BUILDINGS._open)
         {
            _stage = 159;
            Advance();
         }
      }
      
      private static function ConditionRewindBuildingsClosedG() : void
      {
         if(!BUILDINGS._open)
         {
            _stage = 169;
            Advance();
         }
      }
      
      private static function ConditionRewindQuestsClose() : void
      {
         if(!QUESTS._open)
         {
            Rewind();
         }
      }
      
      private static function ConditionRewindNoNewBuilding() : void
      {
         if(!GLOBAL._newBuilding)
         {
            _stage = 31;
            Advance();
         }
      }
      
      private static function ConditionRewindNoNewBuildingB() : void
      {
         if(!GLOBAL._newBuilding)
         {
            _stage = 51;
            Advance();
         }
      }
      
      private static function ConditionRewindNoNewBuildingC() : void
      {
         if(!GLOBAL._newBuilding)
         {
            _stage = 61;
            Advance();
         }
      }
      
      private static function ConditionRewindNoNewBuildingD() : void
      {
         if(!GLOBAL._newBuilding)
         {
            _stage = 89;
            Advance();
         }
      }
      
      private static function ConditionRewindNoNewBuildingE() : void
      {
         if(!GLOBAL._newBuilding)
         {
            _stage = 139;
            Advance();
         }
      }
      
      private static function ConditionRewindNoNewBuildingF() : void
      {
         if(!GLOBAL._newBuilding)
         {
            _stage = 159;
            Advance();
         }
      }
      
      private static function ConditionRewindNoNewBuildingG() : void
      {
         if(!GLOBAL._newBuilding)
         {
            _stage = 169;
            Advance();
         }
      }
      
      private static function ConditionRewindHatcheryClose() : void
      {
         if(!HATCHERY._open)
         {
            Rewind();
         }
      }
      
      private static function ConditionRewindStoreClosed() : void
      {
         if(!STORE._open)
         {
            Rewind();
         }
      }
      
      private static function ConditionRewindBuildingsDeselect21() : void
      {
         if(!BUILDINGS._open)
         {
            _stage = 30;
            Advance();
         }
         if(BUILDINGS._buildingID == 0)
         {
            Rewind();
         }
      }
      
      private static function ConditionRewindBuildingsDeselect3() : void
      {
         ConditionRewindBuildingsClosedF();
         if(BUILDINGS._buildingID == 0)
         {
            Rewind();
         }
      }
      
      private static function ConditionRewindBuildingsDeselect4() : void
      {
         ConditionRewindBuildingsClosedG();
         if(BUILDINGS._buildingID == 0)
         {
            Rewind();
         }
      }
      
      private static function ConditionRewindBuildingsDeselect5() : void
      {
         ConditionRewindBuildingsClosedC();
         if(BUILDINGS._buildingID == 0)
         {
            Rewind();
         }
      }
      
      private static function ConditionRewindBuildingsDeselect11() : void
      {
         ConditionRewindBuildingsClosedD();
         if(BUILDINGS._buildingID == 0)
         {
            Rewind();
         }
      }
      
      private static function ConditionRewindBuildingsDeselect13() : void
      {
         ConditionRewindBuildingsClosedE();
         if(BUILDINGS._buildingID == 0)
         {
            Rewind();
         }
      }
      
      private static function ConditionRewindBuildingsDeselect15() : void
      {
         ConditionRewindBuildingsClosedB();
         if(BUILDINGS._buildingID == 0)
         {
            Rewind();
         }
      }
      
      private static function ConditionRewindBuildingsDeselectBuildingsC() : void
      {
         if(!BUILDINGS._open)
         {
            _stage = 64;
            Advance();
         }
         if(BUILDINGS._open && BUILDINGS._menuA != 2)
         {
            Rewind();
         }
      }
      
      private static function ConditionRewindBuildingsDeselectBuildingsD() : void
      {
         if(!BUILDINGS._open)
         {
            _stage = 89;
            Advance();
         }
         if(BUILDINGS._open && BUILDINGS._menuA != 2)
         {
            Rewind();
         }
      }
      
      private static function ConditionRewindMapClosed() : void
      {
         if(!MAPROOM._open)
         {
            _stage = 99;
            Advance();
         }
      }
      
      private static function AdjustPoint(param1:Point = null, param2:String = "", param3:DisplayObject = null, param4:Point = null) : Point
      {
         var _loc5_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:DisplayObject = null;
         var _loc6_:int = GLOBAL._ROOT.stage.stageWidth;
         var _loc7_:Point = param1;
         var _loc8_:Point = param4;
         if(param2 == "percent")
         {
            if(param1)
            {
               _loc7_.x = Math.floor(param1.x * (GLOBAL._SCREEN.width / GLOBAL._SCREENINIT.width));
            }
         }
         else if(param2 == "mc" && Boolean(param3))
         {
            _loc9_ = param3.x;
            _loc10_ = param3.y;
            if(_loc11_ = param3.parent)
            {
               while(_loc11_.parent)
               {
                  _loc9_ += _loc11_.x;
                  _loc10_ += _loc11_.y;
                  if(_loc11_.parent == GLOBAL._ROOT.stage)
                  {
                     break;
                  }
                  _loc11_ = _loc11_.parent;
               }
            }
            if(_loc8_)
            {
               _loc9_ += _loc8_.x;
               _loc10_ += _loc8_.y;
            }
            _loc7_ = new Point(_loc9_,_loc10_);
         }
         else if(param1)
         {
            if(param1.x > 470 && param1.y > 385)
            {
               _loc5_ = GLOBAL._SCREEN.width - param1.x;
               param1.x = GLOBAL._SCREEN.width + (_loc6_ - GLOBAL._SCREEN.width) * 0.5 - _loc5_;
            }
            else if(param1.x < 465 && param1.y > 358)
            {
               param1.x -= (_loc6_ - GLOBAL._SCREEN.width) * 0.5;
            }
            else if(param1.x < 150 && param1.y < 230)
            {
               param1.x -= (_loc6_ - GLOBAL._SCREEN.width) * 0.5;
            }
            else if(param1.x > 470 && param1.y > 385)
            {
               _loc5_ = GLOBAL._SCREEN.width - param1.x;
               param1.x = GLOBAL._SCREEN.width + (_loc6_ - GLOBAL._SCREENINIT.width) * 0.5 - _loc5_;
            }
            _loc7_ = param1;
         }
         return _loc7_;
      }
      
      public static function Resize() : void
      {
         if(TUTORIAL._stage < TUTORIAL._endstage)
         {
            if(_mcBob)
            {
               _mcBob.Resize();
            }
            if(_mcArrow)
            {
               _mcArrow.Resize();
            }
         }
      }
   }
}
