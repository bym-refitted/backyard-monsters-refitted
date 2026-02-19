package
{
   
   import com.monsters.creep_types.CreepTypeManager;
   import com.monsters.maproom_manager.MapRoomManager;
   import com.monsters.monsters.creeps.Bandito;
   import com.monsters.monsters.creeps.Bolt;
   import com.monsters.monsters.creeps.Brain;
   import com.monsters.monsters.creeps.DAVE;
   import com.monsters.monsters.creeps.Eyera;
   import com.monsters.monsters.creeps.Fang;
   import com.monsters.monsters.creeps.Fink;
   import com.monsters.monsters.creeps.ProjectX;
   import com.monsters.monsters.creeps.Rezghul;
   import com.monsters.monsters.creeps.Slimeattikus;
   import com.monsters.monsters.creeps.Teratorn;
   import com.monsters.monsters.creeps.Vorg;
   import com.monsters.monsters.creeps.Wormzer;
   import com.monsters.monsters.creeps.Zafreeti;
   import com.monsters.monsters.creeps.inferno.Balthazar;
   import com.monsters.monsters.creeps.inferno.KingWormzer;
   import com.monsters.monsters.creeps.inferno.Sabnox;
   import com.monsters.monsters.creeps.inferno.Spurtz;
   import com.monsters.monsters.creeps.rebalance.RebalancedCreatures;
   import com.monsters.subscriptions.SubscriptionHandler;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import com.cc.utils.SecNum;
   
   public class CREATURELOCKER
   {
      
      public static const k_USE_REBALANCED_MONSTERS:Boolean = false;
      
      public static var _lockerData:Object;
      
      public static var _open:Boolean;
      
      public static var _mc:CREATURELOCKERPOPUP;
      
      public static var _mainCreatures:Object;
      
      public static var _page:int;
      
      public static var _unlocking:String;
      
      public static var _popupCreatureID:String;
      
      public static const NUM_CREEP_TYPE:int = 18;
      
      public static const NUM_ICREEP_TYPE:int = 8;
       
      
      public function CREATURELOCKER()
      {
         super();
      }
      
      public static function get _creatures() : Object
      {
         return _mainCreatures;
      }
      
      public static function getFirstCreatureID() : String
      {
         return BASE.isInfernoMainYardOrOutpost ? "IC1" : "C1";
      }
      
      public static function Data(param1:Object) : void
      {
         var _loc2_:int = 0;
         _lockerData = param1;
         _lockerData[getFirstCreatureID()] = {"t":2};
         if(_lockerData.C100)
         {
            _lockerData.C12 = _lockerData.C100;
            delete _lockerData.C100;
         }
         if(GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD)
         {
            if(BASE.isInfernoMainYardOrOutpost)
            {
               _loc2_ = 2;
               while(_loc2_ <= NUM_ICREEP_TYPE)
               {
                  if(Boolean(_lockerData["IC" + _loc2_]) && _lockerData["IC" + _loc2_].t == 2)
                  {
                     ACHIEVEMENTS.Check("unlock_monster",1);
                     break;
                  }
                  _loc2_++;
               }
            }
            else
            {
               _loc2_ = 2;
               while(_loc2_ <= NUM_CREEP_TYPE)
               {
                  if(Boolean(_lockerData["C" + _loc2_]) && _lockerData["C" + _loc2_].t == 2)
                  {
                     ACHIEVEMENTS.Check("unlock_monster",1);
                     break;
                  }
                  _loc2_++;
               }
            }
         }
      }
      
      public static function Setup() : void
      {
         var _loc1_:String = null;
         _page = 1;
         _popupCreatureID = getFirstCreatureID();
         _lockerData = {};
         _open = false;
         _mainCreatures = {
            "C1":{
               "index":1,
               "page":1,
               "order":1,
               "resource":new SecNum(4000),
               "time":new SecNum(10 * 60),
               "level":1,
               "name":"#m_pokey#",
               "description":"mon_pokeydesc",
               "stream":["mon_pokeystream","mon_pokeystreambody","quests/monster1.v2.png"],
               "unlock":[""],
               "trainingCosts":[[new SecNum(4000),new SecNum(60 * 60 * 2)],[new SecNum(8000),new SecNum(60 * 60 * 3)],[new SecNum(12000),new SecNum(60 * 60 * 5)],[new SecNum(16000),new SecNum(60 * 60 * 8)],[new SecNum(22000),new SecNum(60 * 60 * 12)]],
               "props":{
                  "speed":[1.2],
                  "health":[new SecNum(200),new SecNum(220),new SecNum(240),new SecNum(260),new SecNum(280),new SecNum(300)],
                  "damage":[new SecNum(60),new SecNum(65),new SecNum(70),new SecNum(75),new SecNum(80),new SecNum(85)],
                  "cTime":[new SecNum(15),new SecNum(10),new SecNum(8),new SecNum(7),new SecNum(6),new SecNum(5)],
                  "cResource":[new SecNum(250),new SecNum(450),new SecNum(675),new SecNum(800),new SecNum(1000),new SecNum(1250)],
                  "cStorage":[10,10,10,9,8,7],
                  "bucket":[7],
                  "targetGroup":[1],
                  "hTime":[5,3,2,2,2,2],
                  "hResource":[75,135,203,240,300,375]
               }
            },
            "C2":{
               "index":2,
               "page":1,
               "order":2,
               "resource":new SecNum(8000),
               "time":new SecNum(1 * 60 * 60),
               "level":1,
               "name":"#m_octoooze#",
               "description":"mon_octooozedesc",
               "stream":["mon_octooozestream","mon_octooozestreambody","quests/monster2.v2.png"],
               "trainingCosts":[[new SecNum(8000),new SecNum(60 * 60 * 4)],[new SecNum(16000),new SecNum(60 * 60 * 6)],[new SecNum(24000),new SecNum(60 * 60 * 10)],[new SecNum(48000),new SecNum(60 * 60 * 16)],[new SecNum(64000),new SecNum(60 * 60 * 24)]],
               "props":{
                  "speed":[1.4],
                  "health":[new SecNum(1000),new SecNum(1100),new SecNum(1300),new SecNum(1450),new SecNum(1600),new SecNum(1800)],
                  "damage":[new SecNum(15),new SecNum(15),new SecNum(20),new SecNum(25),new SecNum(30),new SecNum(35)],
                  "cTime":[new SecNum(15),new SecNum(16)],
                  "cResource":[new SecNum(500),new SecNum(900),new SecNum(1350),new SecNum(1800),new SecNum(2100),new SecNum(2500)],
                  "cStorage":[10],
                  "bucket":[10],
                  "targetGroup":[4],
                  "hTime":[5],
                  "hResource":[150,270,405,540,630,750]
               }
            },
            "C3":{
               "index":3,
               "page":1,
               "order":3,
               "resource":new SecNum(16000),
               "time":new SecNum(2 * 60 * 60),
               "level":1,
               "name":"#m_bolt#",
               "classType":Bolt,
               "description":"mon_boltdesc",
               "stream":["mon_boltstream","mon_boltstreambody","quests/monster3.v2.png"],
               "trainingCosts":[[new SecNum(16000),new SecNum(60 * 60 * 4)],[new SecNum(32000),new SecNum(60 * 60 * 6)],[new SecNum(48000),new SecNum(60 * 60 * 8)],[new SecNum(96000),new SecNum(60 * 60 * 12)],[new SecNum(144000),new SecNum(60 * 60 * 16)]],
               "props":{
                  "speed":[2.5,2.55,2.6,2.8,3,3.2],
                  "health":[new SecNum(150)],
                  "damage":[new SecNum(15),new SecNum(20),new SecNum(25),new SecNum(35),new SecNum(45),new SecNum(55)],
                  "cTime":[new SecNum(23)],
                  "cResource":[new SecNum(350),new SecNum(675),new SecNum(1015),new SecNum(1400),new SecNum(1800),new SecNum(2400)],
                  "cStorage":[15],
                  "bucket":[15],
                  "targetGroup":[3],
                  "hTime":[7],
                  "hResource":[105,203,305,420,540,720]
               }
            },
            "C4":{
               "index":4,
               "page":1,
               "order":4,
               "resource":new SecNum(32000),
               "time":new SecNum(4 * 60 * 60),
               "level":1,
               "name":"#m_fink#",
               "classType":Fink,
               "description":"mon_finkdesc",
               "stream":["mon_finkstream","mon_finkstreambody","quests/monster4.v2.png"],
               "trainingCosts":[[new SecNum(32000),new SecNum(60 * 60 * 8)],[new SecNum(64000),new SecNum(60 * 60 * 12)],[new SecNum(96000),new SecNum(60 * 60 * 18)],[new SecNum(128000),new SecNum(60 * 60 * 24)],[new SecNum(160000),new SecNum(60 * 60 * 30)]],
               "props":{
                  "speed":[1.3],
                  "health":[new SecNum(200),new SecNum(200),new SecNum(200),new SecNum(200),new SecNum(220),new SecNum(240)],
                  "damage":[new SecNum(300),new SecNum(330),new SecNum(380),new SecNum(430),new SecNum(470),new SecNum(520)],
                  "cTime":[new SecNum(100),new SecNum(100),new SecNum(100),new SecNum(100),new SecNum(90),new SecNum(90)],
                  "cResource":[new SecNum(1500),new SecNum(2250),new SecNum(3375),new SecNum(4800),new SecNum(7200),new SecNum(10000)],
                  "cStorage":[20],
                  "bucket":[20],
                  "targetGroup":[1],
                  "hTime":[30,30,30,30,27,27],
                  "hResource":[450,675,1013,1440,2160,3000]
               }
            },
            "C5":{
               "index":5,
               "page":2,
               "order":1,
               "resource":new SecNum(64000),
               "time":new SecNum(8 * 60 * 60),
               "level":2,
               "name":"#m_eyera#",
               "classType":Eyera,
               "description":"mon_eyeradesc",
               "stream":["mon_eyerastream","mon_eyerastreambody","quests/monster5.v2.png"],
               "trainingCosts":[[new SecNum(64000),new SecNum(60 * 60 * 5)],[new SecNum(128000),new SecNum(60 * 60 * 7)],[new SecNum(192000),new SecNum(60 * 60 * 12)],[new SecNum(384000),new SecNum(60 * 60 * 24)],[new SecNum(512000),new SecNum(60 * 60 * 36)]],
               "props":{
                  "speed":[2,2.2,2.4,2.6,2.8,3],
                  "health":[new SecNum(600),new SecNum(900),new SecNum(1200),new SecNum(1600),new SecNum(2000),new SecNum(2400)],
                  "damage":[new SecNum(4000),new SecNum(8000),new SecNum(12000),new SecNum(16000),new SecNum(20000),new SecNum(24000)],
                  "cTime":[new SecNum(1500)],
                  "cResource":[new SecNum(5000),new SecNum(15000),new SecNum(30000),new SecNum(45000),new SecNum(60000),new SecNum(80000)],
                  "cStorage":[60],
                  "bucket":[60],
                  "targetGroup":[2],
                  "explode":[1],
                  "hTime":[450,450,450,450,450,450],
                  "hResource":[1500,4500,9000,13500,18000,24000]
               }
            },
            "C6":{
               "index":6,
               "page":2,
               "order":2,
               "resource":new SecNum(128000),
               "time":new SecNum(16 * 60 * 60),
               "level":2,
               "name":"#m_ichi#",
               "description":"mon_ichidesc",
               "stream":["mon_ichistream","mon_ichistreambody","quests/monster6.v2.png"],
               "trainingCosts":[[new SecNum(128000),new SecNum(60 * 60 * 12)],[new SecNum(256000),new SecNum(60 * 60 * 18)],[new SecNum(409600),new SecNum(60 * 60 * 24)],[new SecNum(640000),new SecNum(60 * 60 * 48)],[new SecNum(820000),new SecNum(60 * 60 * 72)]],
               "props":{
                  "speed":[1.2],
                  "health":[new SecNum(2000),new SecNum(2100),new SecNum(2200),new SecNum(2300),new SecNum(2500),new SecNum(2800)],
                  "damage":[new SecNum(50),new SecNum(60),new SecNum(70),new SecNum(80),new SecNum(95),new SecNum(110)],
                  "cTime":[new SecNum(100),new SecNum(100),new SecNum(90)],
                  "cResource":[new SecNum(5000),new SecNum(5625),new SecNum(8440),new SecNum(11200),new SecNum(16000),new SecNum(24000)],
                  "cStorage":[20],
                  "bucket":[20],
                  "targetGroup":[4],
                  "hTime":[30,30,27],
                  "hResource":[1500,1688,2532,3360,4800,7200]
               }
            },
            "C7":{
               "index":7,
               "page":2,
               "order":3,
               "resource":new SecNum(256000),
               "time":new SecNum(28 * 60 * 60),
               "level":2,
               "name":"#m_bandito#",
               "classType":Bandito,
               "description":"mon_banditodesc",
               "stream":["mon_banditostream","mon_banditostreambody","quests/monster7.v2.png"],
               "trainingCosts":[[new SecNum(256000),new SecNum(60 * 60 * 12)],[new SecNum(512000),new SecNum(60 * 60 * 16)],[new SecNum(756000),new SecNum(60 * 60 * 24)],[new SecNum(1024000),new SecNum(60 * 60 * 36)],[new SecNum(1440000),new SecNum(60 * 60 * 48)]],
               "props":{
                  "speed":[1],
                  "health":[new SecNum(500),new SecNum(550),new SecNum(600),new SecNum(650),new SecNum(750),new SecNum(900)],
                  "damage":[new SecNum(200),new SecNum(250),new SecNum(300),new SecNum(350),new SecNum(400),new SecNum(450)],
                  "cTime":[new SecNum(225),new SecNum(225),new SecNum(225),new SecNum(225),new SecNum(180),new SecNum(180)],
                  "cResource":[new SecNum(2500),new SecNum(4500),new SecNum(6750),new SecNum(8750),new SecNum(11200),new SecNum(14400)],
                  "cStorage":[20],
                  "bucket":[20],
                  "targetGroup":[1],
                  "hTime":[68,68,68,68,54,54],
                  "hResource":[750,1350,2025,2625,3360,4320]
               }
            },
            "C8":{
               "index":8,
               "page":2,
               "order":4,
               "resource":new SecNum(512000),
               "time":new SecNum(40 * 60 * 60),
               "level":2,
               "name":"#m_fang#",
               "classType":Fang,
               "description":"mon_fangdesc",
               "stream":["mon_fangstream","mon_fangstreambody","quests/monster8.v2.png"],
               "trainingCosts":[[new SecNum(512000),new SecNum(60 * 60 * 12)],[new SecNum(512000),new SecNum(60 * 60 * 16)],[new SecNum(756000),new SecNum(60 * 60 * 24)],[new SecNum(1024000),new SecNum(60 * 60 * 36)],[new SecNum(1440000),new SecNum(60 * 60 * 48)]],
               "props":{
                  "speed":[1.1,1.2,1.3,1.4,1.5,1.6],
                  "health":[new SecNum(400)],
                  "damage":[new SecNum(600),new SecNum(600),new SecNum(620),new SecNum(660),new SecNum(720),new SecNum(800)],
                  "cTime":[new SecNum(450),new SecNum(350),new SecNum(250),new SecNum(225),new SecNum(195),new SecNum(195)],
                  "cResource":[new SecNum(18000),new SecNum(27000),new SecNum(40500),new SecNum(60500),new SecNum(80000),new SecNum(100000)],
                  "cStorage":[30],
                  "bucket":[30],
                  "targetGroup":[1],
                  "hTime":[135,105,75,68,59,59],
                  "hResource":[5400,8100,12150,18150,24000,30000]
               }
            },
            "C9":{
               "index":10,
               "page":3,
               "order":1,
               "resource":new SecNum(1024000),
               "time":new SecNum(52 * 60 * 60),
               "level":3,
               "name":"#m_brain#",
               "classType":Brain,
               "description":"mon_braindesc",
               "stream":["mon_brainstream","mon_brainstreambody","quests/monster9.v2.png"],
               "trainingCosts":[[new SecNum(1024000),new SecNum(60 * 60 * 12)],[new SecNum(2056000),new SecNum(60 * 60 * 16)],[new SecNum(2870000),new SecNum(60 * 60 * 20)],[new SecNum(4500000),new SecNum(60 * 60 * 40)],[new SecNum(6000000),new SecNum(60 * 60 * 60)]],
               "props":{
                  "speed":[2,2,2,2,2.1,2.2],
                  "health":[new SecNum(600),new SecNum(700),new SecNum(750),new SecNum(800),new SecNum(1100),new SecNum(1400)],
                  "damage":[new SecNum(100),new SecNum(100),new SecNum(200),new SecNum(250),new SecNum(300),new SecNum(350)],
                  "cTime":[new SecNum(342)],
                  "cResource":[new SecNum(12000),new SecNum(20250),new SecNum(30375),new SecNum(35000),new SecNum(50000),new SecNum(75000)],
                  "cStorage":[30],
                  "bucket":[30],
                  "targetGroup":[3],
                  "hTime":[103],
                  "hResource":[3600,6075,9113,10500,1500,22500]
               }
            },
            "C10":{
               "index":11,
               "page":3,
               "order":3,
               "resource":new SecNum(2048000),
               "time":new SecNum(58 * 60 * 60),
               "level":3,
               "name":"#m_crabatron#",
               "description":"mon_crabatrondesc",
               "stream":["mon_crabatronstream","mon_crabatronstreambody","quests/monster10.v2.png"],
               "trainingCosts":[[new SecNum(2048000),new SecNum(60 * 60 * 12)],[new SecNum(3000000),new SecNum(60 * 60 * 18)],[new SecNum(4400000),new SecNum(60 * 60 * 24)],[new SecNum(6000000),new SecNum(60 * 60 * 48)],[new SecNum(7500000),new SecNum(60 * 60 * 72)]],
               "props":{
                  "speed":[1,1,1,1.2,1.4,1.5],
                  "health":[new SecNum(4000),new SecNum(4000),new SecNum(4300),new SecNum(4400),new SecNum(4600),new SecNum(4800)],
                  "damage":[new SecNum(100),new SecNum(120),new SecNum(130),new SecNum(140),new SecNum(150),new SecNum(170)],
                  "cTime":[new SecNum(750)],
                  "cResource":[new SecNum(30000),new SecNum(45000),new SecNum(67500),new SecNum(75000),new SecNum(90000),new SecNum(120000)],
                  "cStorage":[40],
                  "bucket":[40],
                  "targetGroup":[4],
                  "hTime":[225],
                  "hResource":[9000,13500,20250,22500,27000,36000]
               }
            },
            "C11":{
               "index":12,
               "page":3,
               "order":4,
               "resource":new SecNum(4096000),
               "time":new SecNum(62 * 60 * 60),
               "level":3,
               "name":"#m_projectx#",
               "classType":ProjectX,
               "description":"mon_projectxdesc",
               "stream":["mon_projectxstream","mon_projectxstreambody","quests/monster11.v2.png"],
               "trainingCosts":[[new SecNum(4096000),new SecNum(60 * 60 * 24)],[new SecNum(7000000),new SecNum(60 * 60 * 36)],[new SecNum(12000000),new SecNum(60 * 60 * 48)],[new SecNum(18000000),new SecNum(60 * 60 * 96)],[new SecNum(24000000),new SecNum(60 * 60 * 128)]],
               "props":{
                  "speed":[0.9,0.9,1,1.2,1.2,1.3],
                  "health":[new SecNum(800),new SecNum(900),new SecNum(950),new SecNum(1000),new SecNum(1100),new SecNum(1200)],
                  "damage":[new SecNum(1200),new SecNum(1400),new SecNum(1600),new SecNum(1800),new SecNum(2000),new SecNum(2200)],
                  "cTime":[new SecNum(1384)],
                  "cResource":[new SecNum(60000),new SecNum(90000),new SecNum(135000),new SecNum(180000),new SecNum(234000),new SecNum(280000)],
                  "cStorage":[70],
                  "bucket":[70],
                  "targetGroup":[4],
                  "hTime":[415],
                  "hResource":[18000,27000,40500,54000,70200,84000]
               }
            },
            "C12":{
               "index":16,
               "page":4,
               "order":3,
               "resource":new SecNum(8192000),
               "time":new SecNum(72 * 60 * 60),
               "level":4,
               "name":"#m_dave#",
               "classType":DAVE,
               "description":"mon_davedesc",
               "stream":["mon_davestream","mon_davestreambody","quests/monster12.v2.png"],
               "trainingCosts":[[new SecNum(8192000),new SecNum(60 * 60 * 48)],[new SecNum(10000000),new SecNum(60 * 60 * 72)],[new SecNum(12200000),new SecNum(60 * 60 * 96)],[new SecNum(19200000),new SecNum(60 * 60 * 144)],[new SecNum(28000000),new SecNum(60 * 60 * 192)]],
               "props":{
                  "speed":[0.8,0.85,0.9,1,1.1,1.2],
                  "health":[new SecNum(8000),new SecNum(9100),new SecNum(10000),new SecNum(12000),new SecNum(16500),new SecNum(21000)],
                  "damage":[new SecNum(1500),new SecNum(1500),new SecNum(1600),new SecNum(1700),new SecNum(1800),new SecNum(1900)],
                  "cTime":[new SecNum(3600)],
                  "cResource":[new SecNum(150000),new SecNum(225000),new SecNum(337500),new SecNum(440000),new SecNum(600000),new SecNum(800000)],
                  "cStorage":[160],
                  "bucket":[160],
                  "targetGroup":[1],
                  "hTime":[1080],
                  "hResource":[45000,67500,101250,132000,180000,240000]
               }
            },
            "C13":{
               "index":15,
               "page":4,
               "order":2,
               "resource":new SecNum(4096000),
               "time":new SecNum(62 * 60 * 60),
               "level":4,
               "name":"#m_wormzer#",
               "classType":Wormzer,
               "description":"mon_wormzerdesc",
               "stream":["mon_wormzerstream","mon_wormzerstreambody","quests/monster13.v2.png"],
               "trainingCosts":[[new SecNum(4096000),new SecNum(60 * 60 * 24)],[new SecNum(8192000),new SecNum(60 * 60 * 48)],[new SecNum(8192000),new SecNum(60 * 60 * 72)],[new SecNum(8192000),new SecNum(60 * 60 * 96)],[new SecNum(12800000),new SecNum(60 * 60 * 128)]],
               "movement":"burrow",
               "pathing":"direct",
               "props":{
                  "speed":[3,4],
                  "health":[new SecNum(600),new SecNum(800),new SecNum(1100),new SecNum(1300),new SecNum(1500),new SecNum(1700)],
                  "damage":[new SecNum(300),new SecNum(400),new SecNum(550),new SecNum(600),new SecNum(650),new SecNum(700)],
                  "cTime":[new SecNum(1384)],
                  "cResource":[new SecNum(20000),new SecNum(25000),new SecNum(30000),new SecNum(35000),new SecNum(40000),new SecNum(47500)],
                  "cStorage":[70],
                  "bucket":[70],
                  "targetGroup":[1],
                  "hTime":[415],
                  "hResource":[6000,7500,9000,10500,12000,14250]
               }
            },
            "C14":{
               "index":14,
               "page":4,
               "order":1,
               "resource":new SecNum(4096000),
               "time":new SecNum(60 * 60 * 60),
               "level":4,
               "name":"#m_teratorn#",
               "classType":Teratorn,
               "description":"mon_teratorndesc",
               "stream":["mon_teratornstream","mon_teratornstreambody","quests/monster14.v3.png"],
               "trainingCosts":[[new SecNum(4096000),new SecNum(60 * 60 * 36)],[new SecNum(7000000),new SecNum(60 * 60 * 54)],[new SecNum(10000000),new SecNum(60 * 60 * 80)],[new SecNum(16000000),new SecNum(60 * 60 * 136)],[new SecNum(24000000),new SecNum(60 * 60 * 180)]],
               "movement":"fly",
               "pathing":"direct",
               "props":{
                  "range":[150],
                  "attackDelay":[90],
                  "speed":[2.5,2.75,3,3.25,3.5],
                  "health":[new SecNum(1600),new SecNum(1900),new SecNum(2400),new SecNum(3000),new SecNum(3600),new SecNum(4200)],
                  "damage":[new SecNum(300),new SecNum(350),new SecNum(400),new SecNum(500),new SecNum(600),new SecNum(700)],
                  "cTime":[new SecNum(1800),new SecNum(1920),new SecNum(2040),new SecNum(2160),new SecNum(2280),new SecNum(2400)],
                  "cResource":[new SecNum(70000),new SecNum(95000),new SecNum(145000),new SecNum(200000),new SecNum(300000),new SecNum(400000)],
                  "cStorage":[70],
                  "bucket":[70],
                  "targetGroup":[1],
                  "hTime":[540,576,612,648,684,720],
                  "hResource":[21000,28500,43500,60000,90000,120000]
               }
            },
            "C15":{
               "index":13,
               "page":3,
               "order":5,
               "resource":new SecNum(6192000),
               "time":new SecNum(60 * 60 * 60),
               "level":3,
               "name":"#m_zafreeti#",
               "classType":Zafreeti,
               "description":"mon_zafreetidesc",
               "stream":["mon_zafreetistream","mon_zafreetistreambody","quests/monster15.v2.png"],
               "trainingCosts":[[new SecNum(6192000),new SecNum(60 * 60 * 36)],[new SecNum(7800000),new SecNum(60 * 60 * 54)],[new SecNum(12000000),new SecNum(60 * 60 * 80)],[new SecNum(18000000),new SecNum(60 * 60 * 136)]],
               "movement":"fly",
               "pathing":"direct",
               "antiHeal":true,
               "props":{
                  "range":[150],
                  "attackDelay":[20],
                  "speed":[0.75,0.8,0.85,0.9,0.95],
                  "health":[new SecNum(8000)],
                  "damage":[new SecNum(-400),new SecNum(-550),new SecNum(-700),new SecNum(-850),new SecNum(-1000)],
                  "cTime":[new SecNum(2400)],
                  "cResource":[new SecNum(120000),new SecNum(180000),new SecNum(256000),new SecNum(324000),new SecNum(468000)],
                  "cStorage":[200],
                  "bucket":[200],
                  "targetGroup":[5],
                  "hTime":[720],
                  "hResource":[36000,54000,76800,97200,140400]
               }
            },
            "C16":{
               "index":9,
               "page":2,
               "order":5,
               "resource":new SecNum(384000),
               "time":new SecNum(36 * 60 * 60),
               "level":2,
               "name":"#m_vorg#",
               "blocked":true,
               "classType":Vorg,
               "description":"mon_vorgdesc",
               "trainingCosts":[[new SecNum(384000),new SecNum(60 * 60 * 24)],[new SecNum(384000),new SecNum(60 * 60 * 36)],[new SecNum(512000),new SecNum(60 * 60 * 48)],[new SecNum(768000),new SecNum(60 * 60 * 60)],[new SecNum(1024000),new SecNum(60 * 60 * 72)]],
               "movement":"fly",
               "stream":["","","quests/monster16.png"],
               "pathing":"direct",
               "antiHeal":true,
               "blocked":true,
               "props":{
                  "range":[150],
                  "attackDelay":[10],
                  "speed":[1.5,1.75,2,2.25,2.5],
                  "health":[new SecNum(750)],
                  "damage":[new SecNum(-60),new SecNum(-70),new SecNum(-80),new SecNum(-90),new SecNum(-100),new SecNum(-110)],
                  "cTime":[new SecNum(1200)],
                  "cResource":[new SecNum(16000),new SecNum(25000),new SecNum(38500),new SecNum(62500),new SecNum(75000),new SecNum(90000)],
                  "cStorage":[60],
                  "bucket":[60],
                  "targetGroup":[5],
                  "hTime":[360],
                  "hResource":[4800,7500,11550,18750,22500,27000]
               }
            },
            "C17":{
               "index":10,
               "page":3,
               "order":2,
               "resource":new SecNum(2048000),
               "time":new SecNum(36 * 60 * 60),
               "level":3,
               "name":"#m_slimeattikus#",
               "classType":Slimeattikus,
               "description":"mon_slimeattikusdesc",
               "trainingCosts":[[new SecNum(2560000),new SecNum(60 * 60 * 24)],[new SecNum(3840000),new SecNum(60 * 60 * 36)],[new SecNum(4096000),new SecNum(60 * 60 * 48)],[new SecNum(6250000),new SecNum(60 * 60 * 60)],[new SecNum(8500000),new SecNum(60 * 60 * 80)]],
               "stream":["","","quests/monster17.png"],
               "blocked":true,
               "props":{
                  "speed":[1,1.1,1.2,1.3,1.4,1.5],
                  "health":[new SecNum(700),new SecNum(725),new SecNum(750),new SecNum(800),new SecNum(900),new SecNum(1000)],
                  "damage":[new SecNum(850),new SecNum(850),new SecNum(900),new SecNum(1000),new SecNum(1200),new SecNum(1400)],
                  "cTime":[new SecNum(500),new SecNum(450),new SecNum(400),new SecNum(350),new SecNum(300),new SecNum(250)],
                  "cResource":[new SecNum(27000),new SecNum(40500),new SecNum(60750),new SecNum(90000),new SecNum(125000),new SecNum(150000)],
                  "cStorage":[40],
                  "bucket":[40],
                  "targetGroup":[1],
                  "splits":[2,2,3,3,4,5],
                  "hTime":[150,135,120,105,90,75],
                  "hResource":[8100,12150,18225,27000,37500,45000]
               }
            },
            "C18":{
               "index":0,
               "page":0,
               "order":0,
               "resource":new SecNum(2048000),
               "time":new SecNum(36 * 60 * 60),
               "level":3,
               "name":"#m_slimeattikusmini#",
               "blocked":true,
               "description":"mon_slimeattikusminidesc",
               "trainingCosts":[[new SecNum(2560000),new SecNum(60 * 60 * 24)],[new SecNum(3840000),new SecNum(60 * 60 * 36)],[new SecNum(4096000),new SecNum(60 * 60 * 48)],[new SecNum(6250000),new SecNum(60 * 60 * 60)],[new SecNum(8500000),new SecNum(60 * 60 * 80)]],
               "stream":["","",""],
               "blocked":true,
               "fake":true,
               "dependent":"C17",
               "props":{
                  "speed":[1.5,1.6,1.7,1.8,1.9,2],
                  "health":[new SecNum(250)],
                  "damage":[new SecNum(310),new SecNum(320),new SecNum(330),new SecNum(340),new SecNum(350)],
                  "cTime":[new SecNum(500),new SecNum(450),new SecNum(400),new SecNum(350),new SecNum(300),new SecNum(250)],
                  "cResource":[new SecNum(27000),new SecNum(40500),new SecNum(60750),new SecNum(90000),new SecNum(125000),new SecNum(150000)],
                  "cStorage":[40],
                  "bucket":[40],
                  "targetGroup":[1]
               }
            },
            "C19":{
               "index":17,
               "page":0,
               "order":0,
               "resource":new SecNum(2048000),
               "time":new SecNum(36 * 60 * 60),
               "level":3,
               "name":"#m_rezghul#",
               "classType":Rezghul,
               "description":"mon_rezghuldesc",
               "trainingCosts":[[new SecNum(16000000),new SecNum(60 * 60 * 24)],[new SecNum(19000000),new SecNum(60 * 60 * 36)],[new SecNum(22000000),new SecNum(60 * 60 * 48)],[new SecNum(25000000),new SecNum(60 * 60 * 60)],[new SecNum(28000000),new SecNum(60 * 60 * 72)]],
               "stream":["","","quests/monster19.png"],
               "blocked":true,
               "props":{
                  "range":[200],
                  "speed":[0.8,0.9,1,1.1,1.2,1.3],
                  "health":[new SecNum(7000),new SecNum(7500),new SecNum(8000),new SecNum(8500),new SecNum(9000),new SecNum(10000)],
                  "damage":[new SecNum(700),new SecNum(800),new SecNum(900),new SecNum(1000),new SecNum(1100),new SecNum(1200)],
                  "cTime":[new SecNum(4500)],
                  "cResource":[new SecNum(3000000 / 3)],
                  "cStorage":[250],
                  "bucket":[250],
                  "targetGroup":[4],
                  "zombieSpeedMultiplier":[0.75],
                  "zombieHealthMultiplier":[1,1.1,1.2,1.3,1.4,1.5],
                  "zombieDamageMultiplier":[1,1.1,1.2,1.3,1.4,1.5],
                  "resurrectCooldown":[7,7,6,6,5,4]
               }
            },
            "IC1":{
               "index":1,
               "page":1,
               "order":1,
               "resource":new SecNum(2400),
               "time":new SecNum(3600),
               "level":1,
               "name":"#m_spurtz#",
               "classType":Spurtz,
               "description":"mi_Spurtz_desc",
               "stream":["mi_Spurtz_stream","mi_Spurtz_streambody","quests/inferno_monster1.png"],
               "trainingCosts":[[new SecNum(2400),new SecNum(3600)],[new SecNum(4800),new SecNum(7200)],[new SecNum(7200),new SecNum(10800)],[new SecNum(9600),new SecNum(14400)],[new SecNum(14400),new SecNum(21600)]],
               "props":{
                  "speed":[1.2],
                  "health":[new SecNum(400),new SecNum(425),new SecNum(450),new SecNum(475),new SecNum(510),new SecNum(550)],
                  "damage":[new SecNum(160),new SecNum(200),new SecNum(200),new SecNum(250),new SecNum(300),new SecNum(350)],
                  "cTime":[new SecNum(15),new SecNum(10),new SecNum(8),new SecNum(7),new SecNum(6),new SecNum(5)],
                  "cResource":[new SecNum(500),new SecNum(1000),new SecNum(2000),new SecNum(4000),new SecNum(6000),new SecNum(10000)],
                  "cStorage":[15],
                  "bucket":[15],
                  "targetGroup":[1],
                  "hTime":[5,3,2],
                  "hResource":[150,300,600,1200,1800,3000]
               }
            },
            "IC2":{
               "index":2,
               "page":1,
               "order":2,
               "resource":new SecNum(4800),
               "time":new SecNum(14400),
               "level":1,
               "name":"#m_zagnoid#",
               "description":"mi_Zagnoid_desc",
               "stream":["mi_Zagnoid_stream","mi_Zagnoid_streambody","quests/zagnoid.v3.png"],
               "trainingCosts":[[new SecNum(4800),new SecNum(14400)],[new SecNum(9600),new SecNum(28800)],[new SecNum(14400),new SecNum(43200)],[new SecNum(19200),new SecNum(57600)],[new SecNum(28800),new SecNum(86400)]],
               "props":{
                  "speed":[1.8],
                  "health":[new SecNum(1500),new SecNum(1820),new SecNum(2300),new SecNum(2800),new SecNum(3350),new SecNum(3600)],
                  "damage":[new SecNum(80),new SecNum(85),new SecNum(90),new SecNum(95),new SecNum(100),new SecNum(110)],
                  "cTime":[new SecNum(15),new SecNum(16),new SecNum(16),new SecNum(16),new SecNum(16),new SecNum(16)],
                  "cResource":[new SecNum(2500),new SecNum(4000),new SecNum(8000),new SecNum(12000),new SecNum(16000),new SecNum(20000)],
                  "cStorage":[15],
                  "bucket":[15],
                  "targetGroup":[4],
                  "hTime":[5],
                  "hResource":[750,1200,2400,3600,4800,6000]
               }
            },
            "IC4":{
               "index":3,
               "page":2,
               "order":1,
               "resource":new SecNum(38400),
               "time":new SecNum(64800),
               "level":2,
               "name":"#m_valgos#",
               "description":"mi_Valgos_desc",
               "stream":["mi_Valgos_stream","mi_Valgos_streambody","quests/valgos.png"],
               "trainingCosts":[[new SecNum(38400),new SecNum(64800)],[new SecNum(76800),new SecNum(129600)],[new SecNum(115200),new SecNum(194400)],[new SecNum(153600),new SecNum(259200)],[new SecNum(230400),new SecNum(388800)]],
               "movement":"burrow",
               "pathing":"direct",
               "props":{
                  "speed":[2,2,2,2,2,2],
                  "health":[new SecNum(2000),new SecNum(2400),new SecNum(2800),new SecNum(3200),new SecNum(3600),new SecNum(4000)],
                  "damage":[new SecNum(490),new SecNum(530),new SecNum(580),new SecNum(645),new SecNum(700),new SecNum(775)],
                  "cTime":[new SecNum(450),new SecNum(350),new SecNum(250),new SecNum(225),new SecNum(195),new SecNum(195)],
                  "cResource":[new SecNum(31000),new SecNum(35000),new SecNum(39000),new SecNum(44000),new SecNum(50000),new SecNum(55000)],
                  "cStorage":[30],
                  "bucket":[30],
                  "targetGroup":[2],
                  "hTime":[135,105,75,68,59,59],
                  "hResource":[9300,10500,11700,13200,15000,16500]
               }
            },
            "IC3":{
               "index":4,
               "page":2,
               "order":2,
               "resource":new SecNum(76800),
               "time":new SecNum(64800),
               "level":2,
               "name":"#m_malphus#",
               "description":"mi_Malphus_desc",
               "stream":["mi_Malphus_stream","mi_Malphus_streambody","quests/malphus.png"],
               "trainingCosts":[[new SecNum(76800),new SecNum(64800)],[new SecNum(153600),new SecNum(129600)],[new SecNum(230400),new SecNum(194400)],[new SecNum(307200),new SecNum(259200)],[new SecNum(460800),new SecNum(388800)]],
               "movement":"jump",
               "props":{
                  "speed":[3.2],
                  "health":[new SecNum(450),new SecNum(470),new SecNum(500),new SecNum(540),new SecNum(580),new SecNum(620)],
                  "damage":[new SecNum(100),new SecNum(105),new SecNum(110),new SecNum(120),new SecNum(130),new SecNum(140)],
                  "cTime":[new SecNum(100),new SecNum(100),new SecNum(90),new SecNum(90),new SecNum(90),new SecNum(90)],
                  "cResource":[new SecNum(3000),new SecNum(3500),new SecNum(4100),new SecNum(4800),new SecNum(5500),new SecNum(7000)],
                  "cStorage":[15],
                  "bucket":[15],
                  "targetGroup":[3],
                  "hTime":[30,30,27],
                  "hResource":[900,1050,1230,1440,1650,2100]
               }
            },
            "IC5":{
               "index":5,
               "page":3,
               "order":1,
               "resource":new SecNum(614400),
               "time":new SecNum(86400),
               "level":3,
               "name":"#m_balthazar#",
               "classType":Balthazar,
               "description":"mi_Balthazar_desc",
               "stream":["mi_Balthazar_stream","mi_Balthazar_streambody","quests/balthazar.png"],
               "trainingCosts":[[new SecNum(614400),new SecNum(86400)],[new SecNum(1228800),new SecNum(172800)],[new SecNum(1843200),new SecNum(259200)],[new SecNum(2457600),new SecNum(345600)],[new SecNum(3686400),new SecNum(518400)]],
               "movement":"fly",
               "pathing":"direct",
               "props":{
                  "speed":[4.5],
                  "health":[new SecNum(3200),new SecNum(3600),new SecNum(4000),new SecNum(4500),new SecNum(5000),new SecNum(5600)],
                  "damage":[new SecNum(600),new SecNum(665),new SecNum(730),new SecNum(795),new SecNum(860),new SecNum(930)],
                  "cTime":[new SecNum(1800),new SecNum(1920),new SecNum(2040),new SecNum(2160),new SecNum(2280),new SecNum(2400)],
                  "cResource":[new SecNum(88000),new SecNum(104000),new SecNum(161000),new SecNum(249000),new SecNum(327000),new SecNum(487000)],
                  "cStorage":[40],
                  "bucket":[40],
                  "targetGroup":[6],
                  "hTime":[540,576,612,648,684,720],
                  "hResource":[26400,31200,48300,74700,98100,146100]
               }
            },
            "IC6":{
               "index":6,
               "page":3,
               "order":2,
               "resource":new SecNum(1228800),
               "time":new SecNum(86400),
               "level":3,
               "name":"#m_grokus#",
               "description":"mi_Grokus_desc",
               "stream":["mi_Grokus_stream","mi_Grokus_streambody","quests/grokus.png"],
               "trainingCosts":[[new SecNum(1228800),new SecNum(86400)],[new SecNum(2457600),new SecNum(172800)],[new SecNum(3686400),new SecNum(259200)],[new SecNum(4915200),new SecNum(345600)],[new SecNum(7372800),new SecNum(518400)]],
               "props":{
                  "speed":[1.3,1.3,1.4,1.4,1.5,1.6],
                  "health":[new SecNum(7600),new SecNum(8750),new SecNum(9900),new SecNum(10100),new SecNum(11300),new SecNum(12500)],
                  "damage":[new SecNum(400),new SecNum(425),new SecNum(450),new SecNum(475),new SecNum(500),new SecNum(550)],
                  "cTime":[new SecNum(1800),new SecNum(1800),new SecNum(1800),new SecNum(1800),new SecNum(1800),new SecNum(1800)],
                  "cResource":[new SecNum(80000),new SecNum(105000),new SecNum(135000),new SecNum(175000),new SecNum(210000),new SecNum(325000)],
                  "cStorage":[50],
                  "bucket":[50],
                  "targetGroup":[3],
                  "hTime":[540],
                  "hResource":[24000,31500,40500,52500,63000,97500]
               }
            },
            "IC7":{
               "index":7,
               "page":3,
               "order":3,
               "resource":new SecNum(2457600),
               "time":new SecNum(172800),
               "level":3,
               "name":"#m_sabnox#",
               "classType":Sabnox,
               "description":"mi_Sabnox_desc",
               "stream":["mi_Sabnox_stream","mi_Sabnox_streambody","quests/sabnox.png"],
               "trainingCosts":[[new SecNum(2457600),new SecNum(172800)],[new SecNum(4915200),new SecNum(345600)],[new SecNum(7372800),new SecNum(518400)],[new SecNum(9830400),new SecNum(691200)],[new SecNum(14745600),new SecNum(1036800)]],
               "props":{
                  "range":[240],
                  "speed":[1.7,1.8,1.9,2,2.1,2.2],
                  "health":[new SecNum(1120),new SecNum(1260),new SecNum(1400),new SecNum(1650),new SecNum(1900),new SecNum(2200)],
                  "damage":[new SecNum(700),new SecNum(825),new SecNum(950),new SecNum(1075),new SecNum(1200),new SecNum(1350)],
                  "cTime":[new SecNum(1384),new SecNum(1384),new SecNum(1384),new SecNum(1384),new SecNum(1384),new SecNum(1384)],
                  "cResource":[new SecNum(60000),new SecNum(90000),new SecNum(145000),new SecNum(200000),new SecNum(330000),new SecNum(450000)],
                  "cStorage":[80],
                  "bucket":[80],
                  "targetGroup":[4],
                  "hTime":[415],
                  "hResource":[18000,27000,43500,60000,99000,135000]
               }
            },
            "IC8":{
               "index":8,
               "page":4,
               "order":1,
               "resource":new SecNum(4915200),
               "time":new SecNum(259200),
               "level":4,
               "name":"#m_king_wormzer#",
               "shortName":"#m_k_wormzer#",
               "classType":KingWormzer,
               "description":"mi_King_Wormzer_desc",
               "stream":["mi_King_Wormzer_stream","mi_King_Wormzer_streambody","quests/king_wormzer.png"],
               "trainingCosts":[[new SecNum(4915200),new SecNum(259200)],[new SecNum(7268000),new SecNum(518400)],[new SecNum(9296000),new SecNum(777600)],[new SecNum(13624000),new SecNum(1036800)],[new SecNum(19248000),new SecNum(1555200)]],
               "movement":"burrow",
               "pathing":"direct",
               "props":{
                  "speed":[2.5,2.6,2.7,2.8,2.9,3],
                  "health":[new SecNum(6200),new SecNum(7600),new SecNum(8700),new SecNum(10900),new SecNum(13100),new SecNum(16000)],
                  "damage":[new SecNum(1200),new SecNum(1360),new SecNum(1630),new SecNum(1920),new SecNum(2220),new SecNum(2500)],
                  "cTime":[new SecNum(2700)],
                  "cResource":[new SecNum(425000),new SecNum(476000),new SecNum(580000),new SecNum(700000),new SecNum(910000),new SecNum(1204000)],
                  "cStorage":[100],
                  "bucket":[100],
                  "targetGroup":[1],
                  "hTime":[810],
                  "hResource":[127500,142800,174000,210000,273000,361200]
               }
            },
            "C200":{
               "name":"AILooter1",
               "blocked":true,
               "props":{
                  "speed":[3],
                  "health":[new SecNum(200)],
                  "damage":[new SecNum(20)],
                  "cTime":[new SecNum(10)],
                  "cResource":[new SecNum(10)],
                  "cStorage":[10],
                  "bucket":[50],
                  "size":[32],
                  "targetGroup":[3]
               }
            }
         };
         if(k_USE_REBALANCED_MONSTERS)
         {
            _mainCreatures = RebalancedCreatures.REBALANCED_CREATURES;
            for(_loc1_ in _mainCreatures)
            {
               _mainCreatures[_loc1_].props.hResource = [10];
               _mainCreatures[_loc1_].props.hTime = [2];
            }
         }
         modifyCreepData();
         CreepTypeManager.instance.AddExposedCreepTypes(_mainCreatures);
      }
      
      private static function modifyCreepData() : void
      {
         var _loc1_:int = 0;
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         if(MapRoomManager.instance.isInMapRoom3)
         {
            _loc1_ = 0;
            for(_loc2_ in _mainCreatures)
            {
               _loc1_ = int(_mainCreatures[_loc2_].props.cResource.length);
               _loc3_ = 0;
               while(_loc3_ < _loc1_)
               {
                  _mainCreatures[_loc2_].props.cResource[_loc3_] *= 3;
                  _loc3_++;
               }
               _loc1_ = int(_mainCreatures[_loc2_].props.cTime.length);
               _loc3_ = 0;
               while(_loc3_ < _loc1_)
               {
                  _mainCreatures[_loc2_].props.cTime[_loc3_] *= 3;
                  _loc3_++;
               }
            }
         }
         if(MapRoomManager.instance.isInMapRoom3)
         {
            _loc4_ = 15;
            _loc5_ = 35;
            _loc6_ = 0;
            for(_loc2_ in _mainCreatures)
            {
               if(_mainCreatures[_loc2_].props.hResource)
               {
                  _loc1_ = int(_mainCreatures[_loc2_].props.hResource.length);
                  _loc6_ = _mainCreatures[_loc2_].props.cResource.length - 1;
                  _loc3_ = 0;
                  while(_loc3_ < _loc1_)
                  {
                     _mainCreatures[_loc2_].props.hResource[_loc3_] = 0.25 * _mainCreatures[_loc2_].props.cResource[_loc3_ < _loc6_ ? _loc3_ : _loc6_];
                     _loc3_++;
                  }
                  _loc1_ = int(_mainCreatures[_loc2_].props.hTime.length);
                  _loc6_ = _mainCreatures[_loc2_].props.cTime.length - 1;
                  _loc3_ = 0;
                  while(_loc3_ < _loc1_)
                  {
                     _mainCreatures[_loc2_].props.hTime[_loc3_] = 0.25 * _mainCreatures[_loc2_].props.cTime[_loc3_ < _loc6_ ? _loc3_ : _loc6_];
                     _loc3_++;
                  }
               }
            }
         }
      }
      
      public static function Tick() : void
      {
         var StreamPost:Function;
         var i:String = null;
         var isInfernoType:Boolean = false;
         var creature:Object = null;
         var img:String = null;
         var mc:popup_monster = null;
         var _body:String = null;
         var hatcheryName:String = null;
         _unlocking = null;
         for(i in _lockerData)
         {
            if(_lockerData[i].t == 1)
            {
               isInfernoType = i.substring(0,2) == "IC";
               if(BASE.isInfernoMainYardOrOutpost && isInfernoType || !BASE.isInfernoMainYardOrOutpost && !isInfernoType)
               {
                  _unlocking = i;
                  break;
               }
            }
         }
         if(_unlocking != null)
         {
            if(GLOBAL._lockerOverdrive > 0)
            {
               _lockerData[_unlocking].e -= 4;
            }
            if(_lockerData[_unlocking].e - GLOBAL.Timestamp() <= 0)
            {
               _lockerData[_unlocking].t = 2;
               GLOBAL.player.m_upgrades[_unlocking] = {"level":1};
               ACHIEVEMENTS.Check("unlock_monster",1);
               delete _lockerData[_unlocking].s;
               delete _lockerData[_unlocking].e;
               creature = _creatures[_unlocking];
               img = "quests/monster" + _unlocking.substr(1) + ".v2.png";
               if(creature.stream[2])
               {
                  img = String(creature.stream[2]);
               }
               LOGGER.Stat([10,int(_unlocking.substr(1))]);
               if(GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD)
               {
                  StreamPost = function(param1:String, param2:String, param3:String):Function
                  {
                     var st:String = param1;
                     var sd:String = param2;
                     var im:String = param3;
                     return function(param1:MouseEvent = null):void
                     {
                        GLOBAL.CallJS("sendFeed",["unlock-end",st,sd,im,0]);
                        POPUPS.Next();
                     };
                  };
                  mc = new popup_monster();
                  mc.bSpeedup.SetupKey("btn_warnyourfriends");
                  if(!creature.stream[0])
                  {
                     mc.bSpeedup.visible = false;
                  }
                  _body = "";
                  if(creature.stream[1])
                  {
                     _body = KEYS.Get(creature.stream[1]);
                  }
                  mc.bSpeedup.addEventListener(MouseEvent.CLICK,StreamPost(KEYS.Get(creature.stream[0]),_body,img));
                  mc.bSpeedup.Highlight = true;
                  mc.bAction.visible = false;
                  hatcheryName = hatcheryName = !!GLOBAL._bHatchery ? String(GLOBAL._bHatchery._buildingProps.name) : String(GLOBAL._buildingProps[12].name);
                  mc.tText.htmlText = KEYS.Get("pop_unlock_complete",{
                     "v1":KEYS.Get(CREATURELOCKER._creatures[_unlocking].name),
                     "v2":KEYS.Get(hatcheryName)
                  });
                  POPUPS.Push(mc,null,null,null,_unlocking + "-150.png");
               }
               if(_mc)
               {
                  _mc.Update();
               }
               _unlocking = null;
               QUESTS.Check();
            }
         }
         if(_mc)
         {
            _mc.Tick();
         }
      }
      
      public static function Start(param1:String) : Boolean
      {
         var StreamPost:Function;
         var SpeedUp:Function;
         var creature:Object = null;
         var popupMC:MovieClip = null;
         var creatureID:String = param1;
         if(_lockerData[creatureID])
         {
            return false;
         }
         if(_unlocking != null)
         {
            GLOBAL.Message(KEYS.Get("mon_alreadyunlocking"),KEYS.Get("btn_speedup"),STORE.ShowB,[3,0,["SP1","SP2","SP3","SP4"]]);
            return false;
         }
         creature = _creatures[creatureID];
         if(GLOBAL._bLocker._lvl.Get() < creature.level)
         {
            GLOBAL.Message(KEYS.Get("mon_upgradelocker",{
               "v1":KEYS.Get(GLOBAL._bLocker._buildingProps.name),
               "v2":creature.level
            }));
            return false;
         }
         if(BASE.Charge(3,creature.resource.Get()))
         {
            StreamPost = function(param1:MouseEvent = null):void
            {
               GLOBAL.CallJS("sendFeed",["unlock-start",KEYS.Get("mon_unlockstart",{
                  "v1":KEYS.Get(creature.name),
                  "v2":KEYS.Get(creature.name)
               }),KEYS.Get("mon_unlockstart_streambody",{"v1":KEYS.Get(creature.name)}),CREATURELOCKER._creatures[creatureID].stream[2],0]);
               POPUPS.Next();
            };
            SpeedUp = function(param1:MouseEvent = null):void
            {
               POPUPS.Next();
               STORE.SpeedUp("SP4");
            };
            _lockerData[creatureID] = {
               "t":1,
               "s":GLOBAL.Timestamp(),
               "e":GLOBAL.Timestamp() + creature.time.Get()
            };
            _unlocking = creatureID;
            BASE.Save();
            LOGGER.Stat([9,int(creatureID.substr(1))]);
            popupMC = new popup_monster();
            popupMC.bAction.SetupKey("btn_warnyourfriends");
            popupMC.bAction.addEventListener(MouseEvent.CLICK,StreamPost);
            if(!CREATURELOCKER._creatures[creatureID].stream[0])
            {
               popupMC.bAction.visible = false;
            }
            popupMC.bSpeedup.SetupKey("btn_speedup");
            popupMC.bSpeedup.addEventListener(MouseEvent.CLICK,SpeedUp);
            popupMC.bSpeedup.Highlight = true;
            popupMC.tText.htmlText = KEYS.Get("pop_unlock_start",{
               "v1":KEYS.Get(CREATURELOCKER._creatures[creatureID].name),
               "v2":GLOBAL.ToTime(CREATURELOCKER._creatures[creatureID].time.Get(),false,false,true)
            });
            POPUPS.Push(popupMC,null,null,null,creatureID + "-150.png");
            return true;
         }
         if(!BASE.isInfernoMainYardOrOutpost)
         {
            GLOBAL.Message(KEYS.Get("mon_needputty"),KEYS.Get("btn_openstore"),STORE.ShowB,[2,0.8,["BR31","BR32","BR33"]]);
         }
         else
         {
            GLOBAL.Message(KEYS.Get("mon_needsulfur"),KEYS.Get("btn_openstore"),STORE.ShowB,[2,0.8,["BR31I","BR32I","BR33I"]]);
         }
         return false;
      }
      
      public static function Cancel() : void
      {
         if(_unlocking)
         {
            delete _lockerData[_unlocking];
            BASE.Fund(3,_creatures[_unlocking].resource.Get());
            _unlocking = null;
         }
         Update();
         BASE.Save();
      }
      
      public static function Show() : void
      {
         if(Boolean(GLOBAL._bLocker) && GLOBAL._bLocker._lvl.Get() >= 1)
         {
            if(!_open)
            {
               _open = true;
               GLOBAL.BlockerAdd();
               _mc = GLOBAL._layerWindows.addChild(new CREATURELOCKERPOPUP()) as CREATURELOCKERPOPUP;
               _mc.Center();
               _mc.ScaleUp();
            }
         }
         else
         {
            GLOBAL.Message(KEYS.Get("msg_nomonsterlocker"));
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
            GLOBAL._layerWindows.removeChild(_mc);
            _mc = null;
         }
      }
      
      public static function Update() : void
      {
         if(_mc)
         {
            _mc.Update();
         }
      }
      
      public static function Check() : String
      {
         var tmpArray:Array = null;
         var Push:Function = function(param1:String):void
         {
            var _loc2_:Object = _creatures[param1];
            var _loc3_:Object = _loc2_.props;
            for (var temp = 0; temp < _loc2_.trainingCosts.length; temp++)
            {
               _loc2_.trainingCosts[temp][0] = int(_loc2_.trainingCosts[temp][0].Get())
               _loc2_.trainingCosts[temp][1] = int(_loc2_.trainingCosts[temp][1].Get())
            }
            for (var temp = 0; temp < _loc3_.health.length; temp++)
            {
               _loc3_.health[temp] = int(_loc3_.health[temp].Get())
            }
            for (var temp = 0; temp < _loc3_.damage.length; temp++)
            {
               _loc3_.damage[temp] = int(_loc3_.damage[temp].Get())
            }
            for (var temp = 0; temp < _loc3_.cTime.length; temp++)
            {
               _loc3_.cTime[temp] = int(_loc3_.cTime[temp].Get())
            }
            for (var temp = 0; temp < _loc3_.cResource.length; temp++)
            {
               _loc3_.cResource[temp] = int(_loc3_.cResource[temp].Get())
            }
            tmpArray.push([_loc2_.page,_loc2_.resource.Get(),_loc2_.time.Get(),_loc2_.level,_loc2_.trainingCosts,_loc3_.speed,_loc3_.health,_loc3_.damage,_loc3_.armor,_loc3_.accuracy,_loc3_.cTime,_loc3_.cResource,_loc3_.cStorage,_loc3_.bucket,_loc3_.size]);
         };
         tmpArray = [];
         var i:int = 1;
         while(i <= 16)
         {
            Push("C" + i);
            i++;
         }
         i = 1;
         while(i <= 8)
         {
            Push("IC" + i);
            i++;
         }
         return md5(JSON.stringify(tmpArray));
      }
      
      public static function GetAppropriateCreatures() : Object
      {
         var _loc3_:String = null;
         var _loc1_:Object = CREATURELOCKER._creatures;
         var _loc2_:Object = {};
         for(_loc3_ in _loc1_)
         {
            if(!(_loc3_.substr(0,1) == "C" && BASE.isInfernoMainYardOrOutpost || _loc3_.substr(0,1) == "I" && !BASE.isInfernoMainYardOrOutpost || _loc3_ == "C200"))
            {
               _loc2_[_loc3_] = _loc1_[_loc3_];
            }
         }
         return _loc2_;
      }
      
      public static function GetCreatures(param1:String = "full") : Object
      {
         var _loc4_:String = null;
         var _loc2_:Object = CREATURELOCKER._creatures;
         var _loc3_:Object = {};
         switch(param1)
         {
            case "inferno":
               _loc3_ = GetInfernoCreatures();
               break;
            case "above":
               _loc3_ = GetAboveCreatures();
               break;
            case "full":
            default:
               for(_loc4_ in _loc2_)
               {
                  if(!(_loc4_.substr(0,1) == "C" && BASE.isInfernoMainYardOrOutpost || _loc4_.substr(0,1) == "I" && !BASE.isInfernoMainYardOrOutpost || _loc4_ == "C200"))
                  {
                     _loc3_[_loc4_] = _loc2_[_loc4_];
                  }
               }
         }
         return _loc3_;
      }
      
      public static function GetAboveCreatures() : Object
      {
         var _loc3_:String = null;
         var _loc1_:Object = CREATURELOCKER._creatures;
         var _loc2_:Object = {};
         for(_loc3_ in _loc1_)
         {
            if(_loc3_.substr(0,1) == "C" && _loc3_ != "C200")
            {
               _loc2_[_loc3_] = _loc1_[_loc3_];
            }
         }
         return _loc2_;
      }
      
      public static function maxCreatures(param1:String = "full") : int
      {
         var _loc3_:Object = null;
         var _loc4_:String = null;
         var _loc5_:Object = null;
         var _loc2_:int = 0;
         switch(param1)
         {
            case "inferno":
               _loc3_ = GetInfernoCreatures();
               break;
            case "above":
               _loc3_ = GetAboveCreatures();
               break;
            case "full":
            default:
               _loc3_ = {};
               _loc5_ = CREATURELOCKER._creatures;
               for(_loc4_ in _loc5_)
               {
                  if(_loc4_ != "C200")
                  {
                     _loc3_[_loc4_] = _loc5_[_loc4_];
                  }
               }
         }
         for(_loc4_ in _loc3_)
         {
            _loc2_++;
         }
         return _loc2_;
      }
      
      public static function GetInfernoCreatures() : Object
      {
         var _loc3_:String = null;
         var _loc1_:Object = CREATURELOCKER._creatures;
         var _loc2_:Object = {};
         for(_loc3_ in _loc1_)
         {
            if(_loc3_.substr(0,1) == "I")
            {
               _loc2_[_loc3_] = _loc1_[_loc3_];
            }
         }
         return _loc2_;
      }
      
      public static function get maxInfernoCreatures() : int
      {
         var _loc3_:String = null;
         var _loc1_:int = 0;
         var _loc2_:Object = GetInfernoCreatures();
         for(_loc3_ in _loc2_)
         {
            _loc1_++;
         }
         return _loc1_;
      }
      
      public static function CheckCreatureAvailable(param1:String) : Boolean
      {
         var _loc4_:String = null;
         var _loc2_:Boolean = false;
         var _loc3_:Object = CREATURELOCKER._lockerData;
         for(_loc4_ in _loc3_)
         {
            if(_loc4_ == param1)
            {
               _loc2_ = true;
            }
         }
         return _loc2_;
      }
      
      public static function GetAvailableCreatures() : Object
      {
         var _loc4_:String = null;
         var _loc1_:Object = CREATURELOCKER._creatures;
         var _loc2_:Object = {};
         var _loc3_:Boolean = MAPROOM_DESCENT.DescentPassed && !BASE.isInfernoMainYardOrOutpost;
         for(_loc4_ in _loc1_)
         {
            if(_loc3_)
            {
               if(_loc4_ != "C200")
               {
                  _loc2_[_loc4_] = _loc1_[_loc4_];
               }
            }
            else if(!(_loc4_.substr(0,1) == "C" && BASE.isInfernoMainYardOrOutpost || _loc4_.substr(0,1) == "I" && !BASE.isInfernoMainYardOrOutpost || _loc4_ == "C200"))
            {
               _loc2_[_loc4_] = _loc1_[_loc4_];
            }
         }
         return _loc2_;
      }
      
      public static function GetSortedCreatures(param1:Boolean = false) : Array
      {
         var _loc8_:Object = null;
         var _loc9_:String = null;
         var _loc10_:Object = null;
         var _loc11_:int = 0;
         var _loc12_:Object = null;
         var _loc13_:String = null;
         var _loc14_:Object = null;
         var _loc2_:Object = GetAvailableCreatures();
         var _loc3_:Array = [];
         var _loc4_:Array = [];
         var _loc5_:Array = [];
         var _loc6_:*;
         if(_loc6_ = !BASE.isInfernoMainYardOrOutpost)
         {
            _loc8_ = CREATURELOCKER.GetCreatures("above");
            for(_loc9_ in _loc8_)
            {
               if(!(_loc10_ = CREATURELOCKER._creatures[_loc9_]).blocked || param1)
               {
                  _loc10_.id = _loc9_;
                  _loc11_ = int(_loc10_.id.substr(_loc10_.id.indexOf("C") + 1));
                  _loc10_.type = _loc11_;
                  _loc3_.push(_loc10_);
               }
            }
            _loc3_.sortOn(["index"],Array.NUMERIC);
         }
         var _loc7_:Boolean;
         if(_loc7_ = MAPROOM_DESCENT.DescentPassed && (BASE.isInfernoMainYardOrOutpost || SubscriptionHandler.isEnabledForAll || HATCHERYCC.doesShowInfernoCreeps))
         {
            _loc12_ = CREATURELOCKER.GetCreatures("inferno");
            for(_loc13_ in _loc12_)
            {
               if(!(_loc14_ = CREATURELOCKER._creatures[_loc13_]).blocked || param1)
               {
                  _loc14_.id = _loc13_;
                  _loc4_.push(_loc14_);
               }
            }
            _loc4_.sortOn(["index"],Array.NUMERIC);
         }
         if(_loc3_.length > 0)
         {
            _loc5_ = _loc5_.concat(_loc3_);
         }
         if(_loc4_.length > 0)
         {
            _loc5_ = _loc5_.concat(_loc4_);
         }
         return _loc5_;
      }
      
      public static function getShortCreatureName(param1:String) : String
      {
         if(CREATURELOCKER._creatures[param1].shortName)
         {
            return CREATURELOCKER._creatures[param1].shortName;
         }
         return CREATURELOCKER._creatures[param1].name;
      }
   }
}
