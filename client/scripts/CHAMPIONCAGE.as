package
{
   
   import com.cc.utils.SecNum;
   import com.monsters.configs.BYMConfig;
   import com.monsters.interfaces.ITargetable;
   import com.monsters.managers.InstanceManager;
   import com.monsters.maproom_manager.MapRoomManager;
   import com.monsters.monsters.MonsterBase;
   import com.monsters.monsters.champions.ChampionBase;
   import com.monsters.monsters.champions.Fomor;
   import com.monsters.monsters.champions.Korath;
   import com.monsters.monsters.champions.Krallen;
   import com.monsters.monsters.components.abilities.ProximityLootBuff;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import gs.*;
   import gs.easing.*;
   
   public class CHAMPIONCAGE extends BFOUNDATION
   {
      
      public static const TYPE:uint = 114;
      
      public static var doesShowKrallen:Boolean = false;
      
      public static var STARVETIMER:uint = 3600 * 24;
      
      public static const CLASS_TYPE_BASIC:uint = 1;
      
      public static const CLASS_TYPE_SPECIAL:uint = 2;
      
      public static const CHAMPION_ID_KRALLEN:int = 5;
      
      public static var _housed:Object;
      
      public static var _popup:CHAMPIONCAGEPOPUP;
      
      public static var _select:CHAMPIONSELECTPOPUP;
      
      public static var _namepopup:CHAMPIONNAMEPOPUP;
      
      public static var _open:Boolean = false;
      
      public static var _guardians:Object = {
         "length":5,
         "G1":{
            "name":"Gorgo",
            "description":"mon_gorgodesc",
            "title":"mon_gorgotitle",
            "selectGraphic":"popups/guardian_select_gorgo.png",
            "classType":CLASS_TYPE_BASIC,
            "spawnClass":ChampionBase,
            "props":{
               "speed":[1,1.2,1.4,1.6,1.8,2],
               "health":[40000,80000,120000,140000,160000,200000],
               "healtime":[3600,7200,14400,28800,57600,115200],
               "range":[35,45,55,65,70,70],
               "damage":[1000,1200,1500,2000,2500,3000],
               "feeds":[{"C2":8},{
                  "C2":5,
                  "C6":3
               },{"C6":20},{
                  "C6":5,
                  "C10":5
               },{"C10":10}],
               "feedShiny":[26,44,75,111,136],
               "evolveShiny":[158,530,1358,2664,4076],
               "feedCount":[3,6,9,12,15],
               "feedTime":[3600 * 23],
               "buffs":[0],
               "movement":["ground"],
               "attack":["melee"],
               "bucket":[240],
               "offset_x":[-48,-38,-42,-52,-54,-46],
               "offset_y":[-38,-36,-52,-82,-98,-80],
               "bonusSpeed":[0.1,0.2,0.4],
               "bonusHealth":[12500,27500,50000],
               "bonusRange":[0,0,0],
               "bonusDamage":[150,330,600],
               "bonusBuffs":[0,0,0],
               "bonusFeeds":[{"C10":10},{"C10":10},{"C10":10}],
               "powerLevel":1,
               "bonusFeedShiny":[136,136,136],
               "bonusFeedTime":[3600 * 24],
               "abilities":[null],
               "targetGroup":[0]
            }
         },
         "G2":{
            "name":"Drull",
            "description":"mon_drulldesc",
            "title":"mon_drulltitle",
            "selectGraphic":"popups/guardian_select_drull.png",
            "classType":CLASS_TYPE_BASIC,
            "spawnClass":ChampionBase,
            "props":{
               "speed":[2,2.2,2.5,2.8,3.2,3.6],
               "health":[12000,20000,36000,42000,52000,60000],
               "healtime":[3600,7200,14400,28800,57600,115200],
               "range":[35,45,55,65,85,90],
               "damage":[3000,3600,4200,5500,6500,8000],
               "feeds":[{"C1":15},{
                  "C1":10,
                  "C4":8
               },{"C7":25},{
                  "C7":5,
                  "C8":18
               },{"C8":15}],
               "feedShiny":[26,44,75,105,131],
               "evolveShiny":[158,530,1358,2530,3918],
               "feedCount":[3,6,9,12,15],
               "feedTime":[3600 * 23],
               "buffs":[0],
               "movement":["ground"],
               "attack":["melee"],
               "bucket":[180],
               "offset_x":[-32,-38,-52,-56,-64,-70],
               "offset_y":[-28,-36,-50,-52,-68,-76],
               "bonusSpeed":[0.1,0.2,0.4],
               "bonusHealth":[2500,5500,10000],
               "bonusRange":[0,0,0],
               "bonusDamage":[400,880,1600],
               "bonusBuffs":[0,0,0],
               "bonusFeeds":[{"C8":15},{"C8":15},{"C8":15}],
               "powerLevel":1,
               "bonusFeedShiny":[131,131,131],
               "bonusFeedTime":[3600 * 24],
               "abilities":[null],
               "targetGroup":[0]
            }
         },
         "G3":{
            "name":"Fomor",
            "description":"mon_fomordesc",
            "title":"mon_fomortitle",
            "selectGraphic":"popups/guardian_select_fomor.png",
            "classType":CLASS_TYPE_BASIC,
            "spawnClass":Fomor,
            "props":{
               "speed":[1.2,1.4,2,2.1,2.2,2.3],
               "health":[15000,17500,20000,22500,25000,40000],
               "healtime":[3600,7200,14400,28800,57600,115200],
               "range":[140,140,180,190,200,210],
               "damage":[70,80,90,100,110,120],
               "feeds":[{"C3":10},{
                  "C3":10,
                  "C9":1
               },{
                  "C3":20,
                  "C9":3
               },{
                  "C3":15,
                  "C9":5
               },{"C9":10}],
               "feedShiny":[26,45,62,76,96],
               "evolveShiny":[154,537,1116,1822,2891],
               "feedCount":[3,6,9,12,15],
               "feedTime":[3600 * 23],
               "buffs":[0.1,0.2,0.3,0.4,0.5,0.6],
               "movement":["ground","ground","fly"],
               "attack":["ranged"],
               "bucket":[200],
               "offset_x":[-20,-38,-52,-56,-60,-58],
               "offset_y":[-21,-36,-50,-52,-68,-98],
               "bonusSpeed":[0.1,0.2,0.4],
               "bonusHealth":[1000,2200,4000],
               "bonusRange":[3,6,10],
               "bonusDamage":[3,6,10],
               "bonusBuffs":[0.03,0.06,0.15],
               "bonusFeeds":[{"C9":10},{"C9":10},{"C9":10}],
               "powerLevel":1,
               "bonusFeedShiny":[96,96,96],
               "bonusFeedTime":[3600 * 24],
               "abilities":[null],
               "targetGroup":[0]
            }
         },
         "G4":{
            "name":"Korath",
            "description":"mon_korathdesc",
            "title":"mon_korathtitle",
            "selectGraphic":"popups/guardian_select_korath.v2.png",
            "classType":CLASS_TYPE_BASIC,
            "spawnClass":Korath,
            "powerLevel2Desc":"mon_korathdesc_fireball",
            "powerLevel3Desc":"mon_korathdesc_stomp",
            "props":{
               "speed":[1.4,1.6,1.8,2,2.3,2.5],
               "health":[28000,62000,96000,120000,144000,175000],
               "healtime":[3600,7200,14400,28800,57600,115200],
               "range":[35,45,55,60,65,65],
               "damage":[2000,2400,3000,3800,5000,6500],
               "feeds":[{
                  "IC1":10,
                  "IC2":5
               },{
                  "IC2":5,
                  "IC7":1
               },{"IC7":3},{"IC7":5},{"IC8":2}],
               "feedShiny":[26,44,75,111,136],
               "evolveShiny":[158,530,1358,2664,4076],
               "feedCount":[3,6,9,12,15],
               "feedTime":[3600 * 23],
               "buffs":[0],
               "movement":["ground"],
               "attack":["melee"],
               "bucket":[200],
               "offset_x":[-36,-61,-52,-62,-81,-70],
               "offset_y":[-35,-49,-70,-95,-126,-130],
               "bonusSpeed":[0.1,0.2,0.4],
               "bonusHealth":[1000,2200,4000],
               "bonusRange":[0,0,0],
               "bonusDamage":[300,600,1000],
               "bonusBuffs":[0],
               "bonusFeeds":[{"IC8":2},{"IC8":2},{"IC8":2}],
               "powerLevel":0,
               "bonusFeedShiny":[96,96,96],
               "bonusFeedTime":[3600 * 24],
               "abilities":[null],
               "targetGroup":[0]
            }
         },
         "G5":{
            "name":"Krallen",
            "description":"mon_krallendesc",
            "title":"mon_gorgotitle",
            "selectGraphic":"popups/guardian_select_korath.v2.png",
            "classType":CLASS_TYPE_SPECIAL,
            "spawnClass":Krallen,
            "powerLevel2Desc":"mon_korathdesc_fireball",
            "powerLevel3Desc":"mon_korathdesc_stomp",
            "props":{
               "speed":[2.2,2.3,2.4,2.5,2.6],
               "health":[50000,52000,54000,58000,62000],
               "healtime":[7200,14400,28800,57600,115200],
               "range":[35,45,55,60,65],
               "damage":[800,850,900,1000,1200],
               "feeds":[{
                  "IC1":20,
                  "IC2":10
               },{
                  "IC2":10,
                  "IC7":2
               },{"IC7":6},{"IC7":10},{"IC8":3}],
               "feedShiny":[26,44,75,111,136],
               "evolveShiny":[158,530,1358,2664],
               "feedCount":[3,6,9,12,15],
               "feedTime":[3600 * 23],
               "buffs":[0.2,0.22,0.24,0.27,0.3],
               "buffRadius":[250,275,300,325,350],
               "movement":["ground"],
               "attack":["melee"],
               "bucket":[200],
               "offset_x":[-64,-61,-52,-52,-52],
               "offset_y":[-50,-60,-72,-72,-72],
               "bonusSpeed":[0,0,0],
               "bonusHealth":[0,0,0],
               "bonusRange":[0,0,0],
               "bonusDamage":[0,0,0],
               "bonusBuffs":[0],
               "bonusFeeds":[{"IC8":3},{"IC8":3},{"IC8":3}],
               "powerLevel":0,
               "bonusFeedShiny":[96,96,96],
               "bonusFeedTime":[3600 * 24],
               "abilities":[null,null,ProximityLootBuff],
               "targetGroup":[0]
            }
         }
      };
       
      
      public function CHAMPIONCAGE()
      {
         super();
         _type = 114;
         _footprint = [new Rectangle(0,0,160,160)];
         _gridCost = [[new Rectangle(10,10,140,20),400],[new Rectangle(130,30,20,120),400],[new Rectangle(10,30,20,120),400],[new Rectangle(30,130,30,20),400],[new Rectangle(100,130,30,20),400]];
         SetProps();
         this.setFeedProps();
      }
      
      public static function PointInCage(param1:Point) : Point
      {
         var _loc2_:Rectangle = new Rectangle(40,40,40,40);
         return GRID.ToISO(param1.x + (_loc2_.x + Math.random() * _loc2_.width),param1.y + (_loc2_.y + Math.random() * _loc2_.height),0);
      }
      
      public static function GetFeedTime() : int
      {
         if(CREATURES._guardian)
         {
            return CREATURES._guardian._feedTime.Get();
         }
         return 0;
      }
      
      public static function GetNumFeeds() : int
      {
         if(CREATURES._guardian)
         {
            return CREATURES._guardian._feeds.Get();
         }
         return 0;
      }
      
      public static function ShowJuice() : void
      {
         GLOBAL.Message(KEYS.Get("msg_juicechampion_confirm"),KEYS.Get("msg_juicechampion_yes"),JuiceChampion);
      }
      
      public static function JuiceChampion() : void
      {
         if(CREATURES._guardian)
         {
            CREATURES._guardian.changeModeJuice();
         }
      }
      
      private static function hasBasicChampion() : Boolean
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         while(_loc2_ < BASE._guardianData.length)
         {
            _loc1_ = !!BASE._guardianData[_loc2_].status ? int(BASE._guardianData[_loc2_].status) : ChampionBase.k_CHAMPION_STATUS_NORMAL;
            if(_loc1_ == ChampionBase.k_CHAMPION_STATUS_NORMAL && _guardians["G" + BASE._guardianData[_loc2_].t].classType == CLASS_TYPE_BASIC)
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      public static function Show() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Object = null;
         if(!_open)
         {
            _open = true;
            GLOBAL.BlockerAdd();
            if(!hasBasicChampion())
            {
               _select = GLOBAL._layerWindows.addChild(new CHAMPIONSELECTPOPUP()) as CHAMPIONSELECTPOPUP;
               _select.Center();
               _select.ScaleUp();
            }
            else
            {
               _loc1_ = 0;
               for each(_loc2_ in BASE._guardianData)
               {
                  if(_loc2_.status == ChampionBase.k_CHAMPION_STATUS_NORMAL)
                  {
                     _loc1_++;
                  }
               }
               if(CREATURES._guardianList.length < BASE._guardianDataNumNormal())
               {
                  spawnAllGuardians();
               }
               _popup = GLOBAL._layerWindows.addChild(new CHAMPIONCAGEPOPUP()) as CHAMPIONCAGEPOPUP;
               _popup.Center();
               _popup.ScaleUp();
            }
         }
      }
      
      private static function spawnAllGuardians() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < BASE._guardianData.length)
         {
            if(BASE._guardianData[_loc1_] && BASE._guardianData[_loc1_].t && BASE._guardianData[_loc1_].status === ChampionBase.k_CHAMPION_STATUS_NORMAL)
            {
               GLOBAL._bCage.SpawnGuardian(BASE._guardianData[_loc1_].l.Get(),BASE._guardianData[_loc1_].fd,BASE._guardianData[_loc1_].ft,BASE._guardianData[_loc1_].t,BASE._guardianData[_loc1_].hp.Get(),BASE._guardianData[_loc1_].nm,BASE._guardianData[_loc1_].fb.Get(),BASE._guardianData[_loc1_].pl.Get());
            }
            _loc1_++;
         }
      }
      
      public static function ShowName() : void
      {
         if(!_namepopup && Boolean(CREATURES._guardian))
         {
            _namepopup = new CHAMPIONNAMEPOPUP();
            POPUPS.Push(_namepopup,null,null,null);
         }
      }
      
      public static function Hide(param1:MouseEvent = null) : void
      {
         if(_open)
         {
            GLOBAL.BlockerRemove();
            SOUNDS.Play("close");
            BASE.BuildingDeselect();
            _open = false;
            if(_select)
            {
               GLOBAL._layerWindows.removeChild(_select);
               _select = null;
               if(CREATURES._guardian)
               {
                  _popup = GLOBAL._layerWindows.addChild(new CHAMPIONCAGEPOPUP()) as CHAMPIONCAGEPOPUP;
                  _popup.scaleX = _popup.scaleY = 0.8;
                  _popup.x = GLOBAL._SCREENCENTER.x;
                  _popup.y = GLOBAL._SCREENCENTER.y;
                  TweenLite.to(_popup,0.2,{
                     "scaleX":1,
                     "scaleY":1,
                     "ease":Quad.easeOut
                  });
                  _open = true;
                  return;
               }
            }
            if(_popup)
            {
               GLOBAL._layerWindows.removeChild(_popup);
               _popup = null;
            }
            if(_namepopup)
            {
               POPUPS.Next();
               _namepopup = null;
            }
         }
      }
      
      public static function GetGuardianProperty(param1:String, param2:int, param3:String) : *
      {
         var _loc5_:Object = null;
         var _loc6_:int = 0;
         var _loc4_:Object;
         _loc4_ = _guardians[param1];
         if(_loc4_)
         {
            if((_loc5_ = _loc4_.props)[param3])
            {
               _loc6_ = int(_loc5_[param3].length);
               if(param2 > _loc6_)
               {
                  return _loc5_[param3][_loc6_ - 1];
               }
               return _loc5_[param3][param2 - 1];
            }
         }
         return null;
      }
      
      public static function GetGuardianProperties(param1:String, param2:String) : Array
      {
         var _loc3_:Object = _guardians[param1];
         if(_loc3_)
         {
            return _loc3_.props[param2];
         }
         return null;
      }
      
      public static function HealGuardian(param1:int = 0) : void
      {
         if(param1 != 0 && Boolean(CREATURES.getGuardian(param1)))
         {
            CREATURES.getGuardian(param1).heal();
         }
         else if(CREATURES._guardian)
         {
            CREATURES._guardian.heal();
         }
      }
      
      public static function Check() : String
      {
         var tmpArray:Array = null;
         var Push:Function = function(param1:int):void
         {
            var _loc2_:Object = _guardians["G" + param1];
            var _loc3_:Object = _loc2_.props;
            tmpArray.push([_loc3_.movement,_loc3_.attack,_loc3_.speed,_loc3_.health,_loc3_.damage,_loc3_.healtime,_loc3_.feedCount,_loc3_.feedShiny,_loc3_.evolveShiny,_loc3_.feedTime,_loc3_.bucket,_loc3_.buffs,_loc3_.range,_loc3_.bonusSpeed,_loc3_.bonusHealth,_loc3_.bonusRange,_loc3_.bonusDamage,_loc3_.bonusFeedShiny,_loc3_.bonusFeedTime,_loc3_.bonusBuffs]);
         };
         tmpArray = [];
         var i:int = 1;
         while(i <= 3)
         {
            Push(i);
            i++;
         }
         return md5(JSON.stringify(tmpArray));
      }
      
      public static function getGuardianSpawnClass(param1:int) : Class
      {
         return _guardians["G" + param1].spawnClass;
      }
      
      public static function getGuardianClassType(param1:int) : int
      {
         return _guardians["G" + param1].classType;
      }
      
      public static function CanTrainGuardian(param1:int) : Boolean
      {
         return _guardians["G" + param1].props.powerLevel > 0 && _guardians["G" + param1].classType == CLASS_TYPE_BASIC;
      }
      
      public static function GetAllGuardianData() : Object
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc1_:Object = {};
         if(BASE._guardianData.length)
         {
            _loc3_ = 0;
            while(_loc3_ < BASE._guardianData.length)
            {
               _loc2_ = !!BASE._guardianData[_loc3_].status ? int(BASE._guardianData[_loc3_].status) : ChampionBase.k_CHAMPION_STATUS_NORMAL;
               if(_loc2_ == ChampionBase.k_CHAMPION_STATUS_NORMAL && isBasicGuardian("G" + BASE._guardianData[_loc3_].t))
               {
                  _loc1_[BASE._guardianData[_loc3_].t] = BASE._guardianData[_loc3_];
               }
               _loc3_++;
            }
         }
         if(Boolean(GLOBAL._bChamber) && Boolean(CHAMPIONCHAMBER(GLOBAL._bChamber)._frozen))
         {
            _loc4_ = CHAMPIONCHAMBER(GLOBAL._bChamber)._frozen;
            _loc5_ = 0;
            while(_loc5_ < _loc4_.length)
            {
               _loc1_[_loc4_[_loc5_].t] = _loc4_[_loc5_];
               _loc5_++;
            }
         }
         return _loc1_;
      }
      
      public static function GetGuardianData(param1:int) : Object
      {
         var _loc3_:Array = null;
         var _loc2_:int = 0;
         while(_loc2_ < BASE._guardianData.length)
         {
            if(Boolean(BASE._guardianData[_loc2_]) && BASE._guardianData[_loc2_].t == param1)
            {
               return BASE._guardianData[_loc2_];
            }
            _loc2_++;
         }
         if(Boolean(GLOBAL._bChamber) && Boolean(CHAMPIONCHAMBER(GLOBAL._bChamber)._frozen))
         {
            _loc3_ = CHAMPIONCHAMBER(GLOBAL._bChamber)._frozen;
            _loc2_ = 0;
            while(_loc2_ < _loc3_.length)
            {
               if(_loc3_[_loc2_].t == param1)
               {
                  return _loc3_[_loc2_];
               }
               _loc2_++;
            }
         }
         return null;
      }
      
      public static function isBasicGuardian(param1:String) : Boolean
      {
         return _guardians[param1].classType == CLASS_TYPE_BASIC;
      }
      
      public static function ShowKrallenTab() : void
      {
         if(!GLOBAL._bCage)
         {
            GLOBAL.Message(KEYS.Get("krallen_nogcage"));
            return;
         }
         if(!_open)
         {
            _open = true;
            GLOBAL.BlockerAdd();
            _popup = GLOBAL._layerWindows.addChild(new CHAMPIONCAGEPOPUP()) as CHAMPIONCAGEPOPUP;
            _popup.Center();
            _popup.ScaleUp();
            _popup.Setup(2);
            if(CREATURES._guardian == null)
            {
               _popup.b1.visible = false;
               _popup.b1.mouseEnabled = false;
               _popup.b2.visible = false;
               _popup.b2.visible = false;
            }
         }
      }
      
      private function setFeedProps() : void
      {
         if(!MapRoomManager.instance.isInMapRoom3)
         {
            _guardians.G1.props.feeds = [{"C2":15},{
               "C2":10,
               "C6":5
            },{"C6":20},{
               "C6":10,
               "C10":10
            },{"C10":20}];
            _guardians.G1.props.bonusFeeds = [{"C10":20},{"C10":20},{"C10":20}];
            _guardians.G2.props.feeds = [{"C1":30},{
               "C1":20,
               "C4":15
            },{"C7":50},{
               "C7":10,
               "C8":15
            },{"C8":30}];
            _guardians.G2.props.bonusFeeds = [{"C8":30},{"C8":30},{"C8":30}];
            _guardians.G3.props.feeds = [{"C3":20},{
               "C3":20,
               "C9":2
            },{
               "C3":40,
               "C9":5
            },{
               "C3":30,
               "C9":10
            },{"C9":20}];
            _guardians.G3.props.bonusFeeds = [{"C9":20},{"C9":20},{"C9":20}];
            _guardians.G4.props.feeds = [{
               "IC1":20,
               "IC2":10
            },{
               "IC2":10,
               "IC7":2
            },{"IC7":6},{"IC7":10},{"IC8":3}];
            _guardians.G4.props.bonusFeeds = [{"IC8":3},{"IC8":3},{"IC8":3}];
         }
      }
      
      override public function StopMoveB() : void
      {
         super.StopMoveB();
         var _loc1_:int = 0;
         while(_loc1_ < CREATURES._guardianList.length)
         {
            if(CREATURES._guardianList[_loc1_])
            {
               CREATURES._guardianList[_loc1_]._targetCenter = GRID.FromISO(_mc.x,_mc.y);
               CREATURES._guardianList[_loc1_].changeModeCage();
            }
            _loc1_++;
         }
      }
      
      override public function Setup(param1:Object) : void
      {
         super.Setup(param1);
         var _loc2_:Vector.<Object> = BASE._guardianData;
         var _loc3_:int = 0;
         while(_loc3_ < BASE._guardianData.length)
         {
            if(_loc2_[_loc3_] && _loc2_[_loc3_].t && _loc2_[_loc3_].status == ChampionBase.k_CHAMPION_STATUS_NORMAL)
            {
               this.SpawnGuardian(BASE._guardianData[_loc3_].l.Get(),BASE._guardianData[_loc3_].fd,BASE._guardianData[_loc3_].ft,BASE._guardianData[_loc3_].t,BASE._guardianData[_loc3_].hp.Get(),BASE._guardianData[_loc3_].nm,BASE._guardianData[_loc3_].fb.Get(),BASE._guardianData[_loc3_].pl.Get());
               if(CREATURES._guardian && isBasicGuardian("G" + CREATURES._guardian._type) && BASE._guardianData[_loc3_].l.Get() == 6)
               {
                  ACHIEVEMENTS.Check("upgrade_champ" + CREATURES._guardian._type,1);
               }
            }
            _loc3_++;
         }
      }
      
      override public function Tick(param1:int) : void
      {
         super.Tick(param1);
         if(!GLOBAL._catchup)
         {
            if(GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD && (WMATTACK._inProgress || MONSTERBAITER._attacking) || GLOBAL.mode != GLOBAL.e_BASE_MODE.BUILD)
            {
               Render("open");
            }
            else
            {
               Render("");
            }
         }
         if(_open && Boolean(_popup))
         {
            _popup.Tick();
         }
      }
      
      public function SpawnGuardian(param1:int, param2:int, param3:int = 0, param4:int = 1, param5:int = 1000000000, param6:String = "", param7:int = 0, param8:int = 0) : void
      {
         var _loc11_:Object = null;
         var _loc12_:ChampionBase = null;
         var _loc13_:Boolean = false;
         var _loc9_:Point = GRID.FromISO(x - 20 + Math.random() * 40,y - 20 + Math.random() * 40);
         var _loc10_:Class = getGuardianSpawnClass(param4);
         if(param3 == 0)
         {
            param3 = GLOBAL.Timestamp() + GetGuardianProperty("G" + param4,param1,"feedTime");
         }
         if(!CREATURES.getGuardian(param4) && this.canSpawnGuardian(param4))
         {
            if(_guardians["G" + param4].classType == CLASS_TYPE_BASIC)
            {
               CREATURES._guardian = new _loc10_("pen",PointInCage(_loc9_),0,_loc9_,true,this,param1,param2,param3,param4,param5,param7,param8);
               for each(_loc11_ in BASE._guardianData)
               {
                  if(_loc11_.t == param4 && _loc11_.status != ChampionBase.k_CHAMPION_STATUS_NORMAL)
                  {
                     _loc11_.status = ChampionBase.k_CHAMPION_STATUS_NORMAL;
                     _loc11_.log = _loc11_.log != undefined ? _loc11_.log + "," + ChampionBase.k_CHAMPION_STATUS_NORMAL.toString() : ChampionBase.k_CHAMPION_STATUS_NORMAL.toString();
                     break;
                  }
               }
               if(GLOBAL.mode == "build")
               {
                  for each(_loc11_ in GLOBAL._playerGuardianData)
                  {
                     if(_loc11_.t == param4 && _loc11_.status != ChampionBase.k_CHAMPION_STATUS_NORMAL)
                     {
                        _loc11_.status = ChampionBase.k_CHAMPION_STATUS_NORMAL;
                        _loc11_.log = _loc11_.log != undefined ? _loc11_.log + "," + ChampionBase.k_CHAMPION_STATUS_NORMAL.toString() : ChampionBase.k_CHAMPION_STATUS_NORMAL.toString();
                        break;
                     }
                  }
               }
               CREATURES._guardian.export();
               if(param6 != "")
               {
                  CREATURES._guardian._name = param6;
               }
               if(!BYMConfig.instance.RENDERER_ON)
               {
                  MAP._BUILDINGTOPS.addChild(CREATURES._guardian.graphic);
               }
            }
            else
            {
               _loc12_ = new _loc10_("pen",PointInCage(_loc9_),0,_loc9_,true,this,param1,param2,param3,param4,param5,param7,param8);
               _loc13_ = CREATURES.addGuardian(_loc12_);
               if(_loc13_)
               {
                  _loc12_.export();
                  if(param6 != "")
                  {
                     _loc12_._name = param6;
                  }
                  if(!BYMConfig.instance.RENDERER_ON)
                  {
                     MAP._BUILDINGTOPS.addChild(_loc12_.graphic);
                  }
               }
            }
         }
         QUESTS.Check("hatch_champ" + param4,1);
      }
      
      public function canSpawnGuardian(param1:int) : Boolean
      {
         var _loc2_:int = int(BASE._guardianData.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(BASE._guardianData[_loc3_].t == param1)
            {
               return BASE._guardianData[_loc3_].status == ChampionBase.k_CHAMPION_STATUS_NORMAL;
            }
            _loc3_++;
         }
         return true;
      }
      
      public function FeedGuardian(param1:String, param2:int, param3:Boolean, param4:Boolean = false) : void
      {
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc10_:String = null;
         var _loc11_:MonsterBase = null;
         var _loc12_:Vector.<Object> = null;
         var _loc13_:BFOUNDATION = null;
         var _loc14_:String = null;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         if(_guardians[param1] == null)
         {
            return;
         }
         var _loc5_:Object = CHAMPIONCAGE.GetGuardianProperty(param1,param2,"feeds");
         var _loc6_:Object = {};
         if(param2 == 6)
         {
            _loc5_ = _guardians[param1].props.bonusFeeds[CREATURES._guardian._foodBonus.Get()];
            if(CREATURES._guardian._foodBonus.Get() == 3)
            {
               _loc5_ = CHAMPIONCAGE.GetGuardianProperty(CREATURES._guardian._creatureID,3,"bonusFeeds");
            }
         }
         var _loc9_:Boolean = true;
         if(param2 == 6)
         {
            if(param3)
            {
               _loc16_ = GetGuardianProperty(param1,CREATURES._guardian._foodBonus.Get() + 1,"bonusFeedShiny");
               if(param4)
               {
                  _loc16_ *= 2;
               }
               if(BASE._credits.Get() < _loc16_)
               {
                  POPUPS.DisplayGetShiny();
                  return;
               }
               BASE.Purchase("IFD",_loc16_,"cage");
               CREATURES._guardian._foodBonus.Add(1);
               if(CREATURES._guardian._foodBonus.Get() > 3)
               {
                  CREATURES._guardian._foodBonus.Set(3);
               }
               _loc7_ = CREATURES._guardian.health;
               if(CREATURES._guardian._foodBonus.Get() > 0 && CREATURES._guardian._foodBonus.Get() <= 3)
               {
                  _loc7_ += CHAMPIONCAGE.GetGuardianProperty(CREATURES._guardian._creatureID,CREATURES._guardian._foodBonus.Get(),"bonusHealth");
               }
               _loc8_ = CHAMPIONCAGE.GetGuardianProperty(CREATURES._guardian._creatureID,CREATURES._guardian._level.Get(),"health") + CHAMPIONCAGE.GetGuardianProperty(CREATURES._guardian._creatureID,CREATURES._guardian._foodBonus.Get(),"bonusHealth");
               if(_loc7_ >= _loc8_)
               {
                  _loc7_ = _loc8_;
               }
               CREATURES._guardian.setHealth(_loc7_);
               GLOBAL.Message(KEYS.Get("msg_champion_fed",{"v1":GLOBAL.ToTime(GetGuardianProperty(param1,CREATURES._guardian._level.Get(),"feedTime"))}));
               CREATURES._guardian._feedTime = new SecNum(GLOBAL.Timestamp() + GetGuardianProperty(param1,CREATURES._guardian._level.Get(),"feedTime"));
               CREATURES._guardian.export();
               LOGGER.Log("fed","Buff Fed shiny " + CREATURES._guardian._foodBonus.Get());
               LOGGER.Stat([60,CREATURES._guardian._creatureID,GetGuardianProperty(param1,CREATURES._guardian._foodBonus.Get(),"bonusFeedShiny"),CREATURES._guardian._foodBonus.Get()]);
               BASE.Save();
            }
            else if(_loc5_)
            {
               for(_loc10_ in _loc5_)
               {
                  if(GLOBAL.player.monsterListByID(_loc10_) == null || GLOBAL.player.monsterListByID(_loc10_) && GLOBAL.player.monsterListByID(_loc10_).numHealthyHousedCreeps < _loc5_[_loc10_])
                  {
                     _loc9_ = false;
                     break;
                  }
                  _loc6_[_loc10_] = _loc5_[_loc10_];
               }
               if(_loc9_)
               {
                  _loc12_ = InstanceManager.getInstancesByClass(BASE.isInfernoMainYardOrOutpost ? HOUSINGBUNKER : BUILDING15);
                  for(_loc14_ in _loc6_)
                  {
                     GLOBAL.player.monsterListByID(_loc14_).add(-_loc6_[_loc14_]);
                     for each(_loc11_ in CREATURES._creatures)
                     {
                        if(_loc6_[_loc14_] > 0)
                        {
                           if(_loc11_._creatureID == _loc14_ && _loc11_._behaviour != "feed" && _loc11_._behaviour != "juice")
                           {
                              _loc11_.changeModeFeed();
                              _loc6_[_loc14_] = int(_loc6_[_loc14_]) - 1;
                           }
                        }
                     }
                     _loc15_ = 0;
                     while(_loc15_ < _loc6_[_loc14_])
                     {
                        _loc13_ = _loc12_[int(Math.random() * _loc12_.length)] as BFOUNDATION;
                        CREATURES.Spawn(_loc14_,MAP._BUILDINGTOPS,"feed",new Point(_loc13_.x,_loc13_.y).add(new Point(-60 + Math.random() * 135,65 + Math.random() * 50)),Math.random() * 360);
                        _loc15_++;
                     }
                  }
                  HOUSING.HousingSpace();
                  CREATURES._guardian._foodBonus.Add(1);
                  if(CREATURES._guardian._foodBonus.Get() > 3)
                  {
                     CREATURES._guardian._foodBonus.Set(3);
                  }
                  _loc7_ = CREATURES._guardian.health;
                  if(CREATURES._guardian._foodBonus.Get() > 0 && CREATURES._guardian._foodBonus.Get() <= 3)
                  {
                     _loc7_ += CHAMPIONCAGE.GetGuardianProperty(CREATURES._guardian._creatureID,CREATURES._guardian._foodBonus.Get(),"bonusHealth");
                  }
                  _loc8_ = CHAMPIONCAGE.GetGuardianProperty(CREATURES._guardian._creatureID,CREATURES._guardian._level.Get(),"health") + CHAMPIONCAGE.GetGuardianProperty(CREATURES._guardian._creatureID,CREATURES._guardian._foodBonus.Get(),"bonusHealth");
                  if(_loc7_ >= _loc8_)
                  {
                     _loc7_ = _loc8_;
                  }
                  CREATURES._guardian.setHealth(_loc7_);
                  GLOBAL.Message(KEYS.Get("msg_champion_feeding",{"v1":GLOBAL.ToTime(GetGuardianProperty(param1,CREATURES._guardian._level.Get(),"feedTime"))}));
                  CREATURES._guardian._feedTime = new SecNum(GLOBAL.Timestamp() + GetGuardianProperty(param1,CREATURES._guardian._level.Get(),"feedTime"));
                  CREATURES._guardian.export();
                  LOGGER.Log("fed","Buff Fed creeps " + CREATURES._guardian._foodBonus.Get());
                  LOGGER.Stat([60,CREATURES._guardian._creatureID,0,CREATURES._guardian._foodBonus.Get()]);
                  BASE.Save();
               }
               else
               {
                  GLOBAL.Message(KEYS.Get("msg_champion_morecreatures"));
               }
            }
         }
         else if(param3)
         {
            if(BASE._credits.Get() < GetGuardianProperty(param1,param2,"feedShiny"))
            {
               POPUPS.DisplayGetShiny();
               return;
            }
            BASE.Purchase("IFD",GetGuardianProperty(param1,param2,"feedShiny"),"cage");
            CREATURES._guardian._feeds.Add(1);
            if(CREATURES._guardian._feeds.Get() >= GetGuardianProperty(param1,param2,"feedCount"))
            {
               if(param2 < 5)
               {
                  GLOBAL.Message(KEYS.Get("msg_champion_evolved",{
                     "v1":param2 + 1,
                     "v2":GLOBAL.ToTime(GetGuardianProperty(param1,CREATURES._guardian._level.Get(),"feedTime"))
                  }));
               }
               else
               {
                  GLOBAL.Message(KEYS.Get("msg_champion_fullyevolved",{"v1":param2 + 1}));
               }
               CREATURES._guardian.levelSet(param2 + 1);
               if(CREATURES._guardian._level.Get() == 6)
               {
                  ACHIEVEMENTS.Check("upgrade_champ" + CREATURES._guardian._type,1);
               }
            }
            else
            {
               GLOBAL.Message(KEYS.Get("msg_champion_fed",{"v1":GLOBAL.ToTime(GetGuardianProperty(param1,CREATURES._guardian._level.Get(),"feedTime"))}));
            }
            CREATURES._guardian._feedTime = new SecNum(GLOBAL.Timestamp() + GetGuardianProperty(param1,CREATURES._guardian._level.Get(),"feedTime"));
            CREATURES._guardian.export();
            LOGGER.Log("fed","Fed shiny " + CREATURES._guardian._feeds.Get());
            LOGGER.Stat([58,CREATURES._guardian._creatureID,GetGuardianProperty(param1,param2,"feedShiny"),CREATURES._guardian._level.Get()]);
            BASE.Save();
         }
         else if(_loc5_)
         {
            _loc9_ = true;
            for(_loc10_ in _loc5_)
            {
               if(GLOBAL.player.monsterListByID(_loc10_) == null || GLOBAL.player.monsterListByID(_loc10_) && GLOBAL.player.monsterListByID(_loc10_).numHealthyHousedCreeps < _loc5_[_loc10_])
               {
                  _loc9_ = false;
                  break;
               }
               _loc6_[_loc10_] = _loc5_[_loc10_];
            }
            if(_loc9_)
            {
               _loc12_ = InstanceManager.getInstancesByClass(BASE.isInfernoMainYardOrOutpost ? HOUSINGBUNKER : BUILDING15);
               for(_loc14_ in _loc6_)
               {
                  GLOBAL.player.monsterListByID(_loc14_).add(-_loc6_[_loc14_]);
                  for each(_loc11_ in CREATURES._creatures)
                  {
                     if(_loc6_[_loc14_] > 0)
                     {
                        if(_loc11_._creatureID == _loc14_ && _loc11_._behaviour != "feed" && _loc11_._behaviour != "juice")
                        {
                           _loc11_.changeModeFeed();
                           _loc6_[_loc14_] = int(_loc6_[_loc14_]) - 1;
                        }
                     }
                  }
                  _loc15_ = 0;
                  while(_loc15_ < _loc6_[_loc14_])
                  {
                     _loc13_ = _loc12_[int(Math.random() * _loc12_.length)] as BFOUNDATION;
                     CREATURES.Spawn(_loc14_,MAP._BUILDINGTOPS,"feed",new Point(_loc13_.x,_loc13_.y).add(new Point(-60 + Math.random() * 135,65 + Math.random() * 50)),Math.random() * 360);
                     _loc15_++;
                  }
               }
               HOUSING.HousingSpace();
               CREATURES._guardian._feeds.Add(1);
               if(CREATURES._guardian._feeds.Get() >= GetGuardianProperty(param1,param2,"feedCount"))
               {
                  CREATURES._guardian.levelSet(param2 + 1);
                  if(CREATURES._guardian._level.Get() == 6)
                  {
                     ACHIEVEMENTS.Check("upgrade_champ" + CREATURES._guardian._type,1);
                  }
                  if(param2 < 5)
                  {
                     GLOBAL.Message(KEYS.Get("msg_champion_evolved",{
                        "v1":param2 + 1,
                        "v2":GLOBAL.ToTime(GetGuardianProperty(param1,CREATURES._guardian._level.Get(),"feedTime"))
                     }));
                  }
                  else
                  {
                     GLOBAL.Message(KEYS.Get("msg_champion_fullyevolved",{"v1":param2 + 1}));
                  }
               }
               else
               {
                  GLOBAL.Message(KEYS.Get("msg_champion_feeding",{"v1":GLOBAL.ToTime(GetGuardianProperty(param1,CREATURES._guardian._level.Get(),"feedTime"))}));
               }
               CREATURES._guardian._feedTime = new SecNum(GLOBAL.Timestamp() + GetGuardianProperty(param1,CREATURES._guardian._level.Get(),"feedTime"));
               CREATURES._guardian.export();
               LOGGER.Log("fed","Fed creeps " + CREATURES._guardian._feeds.Get());
               LOGGER.Stat([58,CREATURES._guardian._creatureID,0,CREATURES._guardian._level.Get()]);
               BASE.Save();
            }
            else
            {
               GLOBAL.Message(KEYS.Get("msg_champion_morecreatures"));
            }
         }
      }
      
      override public function PlaceB() : void
      {
         super.PlaceB();
         GLOBAL._bCage = this;
      }
      
      override public function Description() : void
      {
         super.Description();
      }
      
      override public function Constructed() : void
      {
         super.Constructed();
         GLOBAL._bCage = this;
      }
      
      override public function Upgraded() : void
      {
         super.Upgraded();
      }
      
      override public function Recycle() : void
      {
         if(CREATURES._guardianList.length)
         {
            GLOBAL.Message(KEYS.Get("msg_cage_recycle"));
         }
         else
         {
            GLOBAL._bCage = null;
            super.Recycle();
         }
      }
      
      override public function Export() : Object
      {
         return super.Export();
      }
      
      override public function modifyHealth(param1:Number, param2:ITargetable = null) : Number
      {
         return 0;
      }
      
      public function RemoveGuardian(param1:uint, param2:int = 3) : void
      {
         CREATURES.removeGuardianType(param1);
         var _loc3_:int = 0;
         _loc3_ = GLOBAL.getPlayerGuardianIndex(param1);
         if(_loc3_ >= 0)
         {
            GLOBAL._playerGuardianData[_loc3_].status = param2;
            GLOBAL._playerGuardianData[_loc3_].log += "," + param2.toString();
         }
         _loc3_ = BASE.getGuardianIndex(param1);
         if(_loc3_ >= 0)
         {
            BASE._guardianData[_loc3_].status = param2;
            BASE._guardianData[_loc3_].log += "," + param2.toString();
         }
      }
   }
}
