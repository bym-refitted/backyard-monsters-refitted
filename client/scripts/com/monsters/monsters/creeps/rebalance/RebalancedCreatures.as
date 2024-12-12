package com.monsters.monsters.creeps.rebalance
{
   import com.monsters.monsters.creeps.Brain;
   import com.monsters.monsters.creeps.Eyera;
   import com.monsters.monsters.creeps.Fang;
   import com.monsters.monsters.creeps.Fink;
   import com.monsters.monsters.creeps.Slimeattikus;
   import com.monsters.monsters.creeps.Wormzer;
   import com.monsters.monsters.creeps.inferno.Balthazar;
   import com.monsters.monsters.creeps.inferno.KingWormzer;
   import com.monsters.monsters.creeps.inferno.Spurtz;
   import com.cc.utils.SecNum;
   
   public class RebalancedCreatures
   {
      
      public static const REBALANCED_CREATURES:Object = {
         "C1":{
            "index":1,
            "page":1,
            "order":1,
            "resource":4000,
            "time":new SecNum(10 * 60),
            "level":1,
            "name":"#m_pokey#",
            "classType":Pokeyv2,
            "description":"mon_pokeydesc",
            "stream":["mon_pokeystream","mon_pokeystreambody","quests/monster1.v2.png"],
            "unlock":[""],
            "trainingCosts":[[new SecNum(4000),new SecNum(60 * 60 * 2)],[new SecNum(8000),new SecNum(60 * 60 * 3)],[new SecNum(12000),new SecNum(60 * 60 * 5)],[new SecNum(16000),new SecNum(60 * 60 * 8)],[new SecNum(22000),new SecNum(60 * 60 * 12)]], // For dev info sub arrays for costs 0 - putty, 1 - time
            "props":{
               "speed":[1.2],
               "health":[new SecNum(300),new SecNum(330),new SecNum(360),new SecNum(390),new SecNum(420),new SecNum(450)],
               "damage":[new SecNum(90),new SecNum(105),new SecNum(120),new SecNum(135),new SecNum(150),new SecNum(165)],
               "cTime":[new SecNum(15),new SecNum(10),new SecNum(8),new SecNum(7),new SecNum(6),new SecNum(5)],
               "cResource":[new SecNum(250),new SecNum(450),new SecNum(675),new SecNum(800),new SecNum(1000),new SecNum(1250)],
               "cStorage":[10,10,10,9,8,7],
               "bucket":[20],
               "targetGroup":[1]
            }
         },
         "C2":{
            "index":2,
            "page":1,
            "order":2,
            "resource":8000,
            "time":new SecNum(1 * 60 * 60),
            "level":1,
            "name":"#m_octoooze#",
            "classType":Octooozev2,
            "description":"mon_octooozedesc",
            "stream":["mon_octooozestream","mon_octooozestreambody","quests/monster2.v2.png"],
            "trainingCosts":[[new SecNum(8000),new SecNum(60 * 60 * 4)],[new SecNum(16000),new SecNum(60 * 60 * 6)],[new SecNum(24000),new SecNum(60 * 60 * 10)],[new SecNum(48000),new SecNum(60 * 60 * 16)],[new SecNum(64000),new SecNum(60 * 60 * 24)]],
            "props":{
               "speed":[1.4],
               "health":[new SecNum(1000),new SecNum(1100),new SecNum(1300),new SecNum(1450),new SecNum(1600),new SecNum(1800)],
               "damage":[new SecNum(30),new SecNum(30),new SecNum(40),new SecNum(50),new SecNum(60),new SecNum(70)],
               "cTime":[new SecNum(15),new SecNum(16)],
               "cResource":[new SecNum(500),new SecNum(900),new SecNum(1350),new SecNum(1800),new SecNum(2100),new SecNum(2500)],
               "cStorage":[10],
               "bucket":[20],
               "targetGroup":[4]
            }
         },
         "C3":{
            "index":3,
            "page":1,
            "order":3,
            "resource":16000,
            "time":new SecNum(2 * 60 * 60),
            "level":1,
            "name":"#m_bolt#",
            "classType":Boltv2,
            "description":"mon_boltdesc",
            "stream":["mon_boltstream","mon_boltstreambody","quests/monster3.v2.png"],
            "trainingCosts":[[new SecNum(16000),new SecNum(60 * 60 * 4)],[new SecNum(32000),new SecNum(60 * 60 * 6)],[new SecNum(48000),new SecNum(60 * 60 * 8)],[new SecNum(96000),new SecNum(60 * 60 * 12)],[new SecNum(144000),new SecNum(60 * 60 * 16)]],
            "props":{
               "speed":[2.5,2.55,2.6,2.8,3,3.2],
               "health":[new SecNum(600),new SecNum(660),new SecNum(720),new SecNum(780),new SecNum(840),new SecNum(900)],
               "damage":[new SecNum(45),new SecNum(60),new SecNum(75),new SecNum(105),new SecNum(135),new SecNum(165)],
               "cTime":[new SecNum(23)],
               "cResource":[new SecNum(350),new SecNum(675),new SecNum(1015),new SecNum(1400),new SecNum(1800),new SecNum(2400)],
               "cStorage":[15],
               "bucket":[30],
               "targetGroup":[3]
            }
         },
         "C4":{
            "index":4,
            "page":1,
            "order":4,
            "resource":32000,
            "time":new SecNum(4 * 60 * 60),
            "level":1,
            "name":"#m_fink#",
            "classType":Fink,
            "description":"mon_finkdesc",
            "stream":["mon_finkstream","mon_finkstreambody","quests/monster4.v2.png"],
            "trainingCosts":[[new SecNum(32000),new SecNum(60 * 60 * 8)],[new SecNum(64000),new SecNum(60 * 60 * 12)],[new SecNum(96000),new SecNum(60 * 60 * 18)],[new SecNum(128000),new SecNum(60 * 60 * 24)],[new SecNum(160000),new SecNum(60 * 60 * 30)]],
            "props":{
               "speed":[1.3],
               "health":[new SecNum(350),new SecNum(400),new SecNum(450),new SecNum(500),new SecNum(550),new SecNum(600)],
               "damage":[new SecNum(450),new SecNum(495),new SecNum(570),new SecNum(645),new SecNum(705),new SecNum(780)],
               "cTime":[new SecNum(100),new SecNum(100),new SecNum(100),new SecNum(100),new SecNum(90),new SecNum(90)],
               "cResource":[new SecNum(1500),new SecNum(2250),new SecNum(3375),new SecNum(4800),new SecNum(7200),new SecNum(10000)],
               "cStorage":[20],
               "bucket":[30],
               "targetGroup":[1]
            }
         },
         "C5":{
            "index":5,
            "page":2,
            "order":1,
            "resource":64000,
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
               "bucket":[100],
               "targetGroup":[2],
               "explode":[1]
            }
         },
         "C6":{
            "index":6,
            "page":2,
            "order":2,
            "resource":128000,
            "time":new SecNum(16 * 60 * 60),
            "level":2,
            "name":"#m_ichi#",
            "classType":Ichiv2,
            "description":"mon_ichidesc",
            "stream":["mon_ichistream","mon_ichistreambody","quests/monster6.v2.png"],
            "trainingCosts":[[new SecNum(128000),new SecNum(60 * 60 * 12)],[new SecNum(256000),new SecNum(60 * 60 * 18)],[new SecNum(409600),new SecNum(60 * 60 * 24)],[new SecNum(640000),new SecNum(60 * 60 * 48)],[new SecNum(820000),new SecNum(60 * 60 * 72)]],
            "props":{
               "speed":[1.2],
               "health":[new SecNum(2000),new SecNum(2100),new SecNum(2200),new SecNum(2300),new SecNum(2400),new SecNum(2500)],
               "damage":[new SecNum(75),new SecNum(90),new SecNum(105),new SecNum(120),new SecNum(143),new SecNum(165)],
               "cTime":[new SecNum(100),new SecNum(100),new SecNum(90)],
               "cResource":[new SecNum(5000),new SecNum(5625),new SecNum(8440),new SecNum(11200),new SecNum(16000),new SecNum(24000)],
               "cStorage":[20],
               "bucket":[20],
               "targetGroup":[4]
            }
         },
         "C7":{
            "index":7,
            "page":2,
            "order":3,
            "resource":256000,
            "time":new SecNum(28 * 60 * 60),
            "level":2,
            "name":"#m_bandito#",
            "classType":Banditov2,
            "description":"mon_banditodesc",
            "stream":["mon_banditostream","mon_banditostreambody","quests/monster7.v2.png"],
            "trainingCosts":[[new SecNum(256000),new SecNum(60 * 60 * 12)],[new SecNum(512000),new SecNum(60 * 60 * 16)],[new SecNum(756000),new SecNum(60 * 60 * 24)],[new SecNum(1024000),new SecNum(60 * 60 * 36)],[new SecNum(1440000),new SecNum(60 * 60 * 48)]],
            "props":{
               "speed":[1],
               "health":[new SecNum(750),new SecNum(825),new SecNum(900),new SecNum(975),new SecNum(1125),new SecNum(1200)],
               "damage":[new SecNum(300),new SecNum(375),new SecNum(450),new SecNum(525),new SecNum(600),new SecNum(675)],
               "cTime":[new SecNum(225),new SecNum(225),new SecNum(225),new SecNum(225),new SecNum(180),new SecNum(180)],
               "cResource":[new SecNum(2500),new SecNum(4500),new SecNum(6750),new SecNum(8750),new SecNum(11200),new SecNum(14400)],
               "cStorage":[20],
               "bucket":[20],
               "targetGroup":[1]
            }
         },
         "C8":{
            "index":8,
            "page":2,
            "order":4,
            "resource":512000,
            "time":new SecNum(40 * 60 * 60),
            "level":2,
            "name":"#m_fang#",
            "classType":Fang,
            "description":"mon_fangdesc",
            "stream":["mon_fangstream","mon_fangstreambody","quests/monster8.v2.png"],
            "trainingCosts":[[new SecNum(512000),new SecNum(60 * 60 * 12)],[new SecNum(512000),new SecNum(60 * 60 * 16)],[new SecNum(756000),new SecNum(60 * 60 * 24)],[new SecNum(1024000),new SecNum(60 * 60 * 36)],[new SecNum(1440000),new SecNum(60 * 60 * 48)]],
            "props":{
               "speed":[1.1,1.2,1.3,1.4,1.5,1.6],
               "health":[new SecNum(600),new SecNum(630),new SecNum(660),new SecNum(720),new SecNum(750),new SecNum(780)],
               "damage":[new SecNum(1200),new SecNum(1280),new SecNum(1360),new SecNum(1440),new SecNum(1520),new SecNum(1600)],
               "cTime":[new SecNum(450),new SecNum(350),new SecNum(250),new SecNum(225),new SecNum(195),new SecNum(195)],
               "cResource":[new SecNum(18000),new SecNum(27000),new SecNum(40500),new SecNum(60500),new SecNum(80000),new SecNum(100000)],
               "cStorage":[30],
               "bucket":[30],
               "targetGroup":[1]
            }
         },
         "C9":{
            "index":10,
            "page":3,
            "order":1,
            "resource":1024000,
            "time":new SecNum(52 * 60 * 60),
            "level":3,
            "name":"#m_brain#",
            "classType":Brain,
            "description":"mon_braindesc",
            "stream":["mon_brainstream","mon_brainstreambody","quests/monster9.v2.png"],
            "trainingCosts":[[new SecNum(1024000),new SecNum(60 * 60 * 12)],[new SecNum(2056000),new SecNum(60 * 60 * 16)],[new SecNum(2870000),new SecNum(60 * 60 * 20)],[new SecNum(4500000),new SecNum(60 * 60 * 40)],[new SecNum(6000000),new SecNum(60 * 60 * 60)]],
            "props":{
               "speed":[2,2,2,2,2.1,2.2],
               "health":[new SecNum(1300),new SecNum(1400),new SecNum(1500),new SecNum(1600),new SecNum(1700),new SecNum(1800)],
               "damage":[new SecNum(340),new SecNum(380),new SecNum(420),new SecNum(460),new SecNum(500),new SecNum(540)],
               "cTime":[new SecNum(342)],
               "cResource":[new SecNum(12000),new SecNum(20250),new SecNum(30375),new SecNum(35000),new SecNum(50000),new SecNum(75000)],
               "cStorage":[30],
               "bucket":[30],
               "targetGroup":[3]
            }
         },
         "C10":{
            "index":11,
            "page":3,
            "order":3,
            "resource":2048000,
            "time":new SecNum(58 * 60 * 60),
            "level":3,
            "name":"#m_crabatron#",
            "description":"mon_crabatrondesc",
            "stream":["mon_crabatronstream","mon_crabatronstreambody","quests/monster10.v2.png"],
            "trainingCosts":[[new SecNum(2048000),new SecNum(60 * 60 * 12)],[new SecNum(3000000),new SecNum(60 * 60 * 18)],[new SecNum(4400000),new SecNum(60 * 60 * 24)],[new SecNum(6000000),new SecNum(60 * 60 * 48)],[new SecNum(7500000),new SecNum(60 * 60 * 72)]],
            "props":{
               "speed":[1,1,1,1.2,1.4,1.5],
               "health":[new SecNum(4000),new SecNum(4000),new SecNum(4300),new SecNum(4400),new SecNum(4600),new SecNum(4800)],
               "damage":[new SecNum(200),new SecNum(240),new SecNum(260),new SecNum(280),new SecNum(300),new SecNum(340)],
               "cTime":[new SecNum(750)],
               "cResource":[new SecNum(30000),new SecNum(45000),new SecNum(67500),new SecNum(75000),new SecNum(90000),new SecNum(120000)],
               "cStorage":[40],
               "bucket":[40],
               "targetGroup":[4]
            }
         },
         "C11":{
            "index":12,
            "page":3,
            "order":4,
            "resource":4096000,
            "time":new SecNum(62 * 60 * 60),
            "level":3,
            "name":"#m_projectx#",
            "classType":ProjectXv2,
            "description":"mon_projectxdesc",
            "stream":["mon_projectxstream","mon_projectxstreambody","quests/monster11.v2.png"],
            "trainingCosts":[[new SecNum(4096000),new SecNum(60 * 60 * 24)],[new SecNum(7000000),new SecNum(60 * 60 * 36)],[new SecNum(12000000),new SecNum(60 * 60 * 48)],[new SecNum(18000000),new SecNum(60 * 60 * 96)],[new SecNum(24000000),new SecNum(60 * 60 * 128)]],
            "props":{
               "speed":[0.9,0.9,1,1.2,1.2,1.3],
               "health":[new SecNum(1200),new SecNum(1350),new SecNum(1425),new SecNum(1500),new SecNum(1650),new SecNum(1800)],
               "damage":[new SecNum(1200),new SecNum(1400),new SecNum(1600),new SecNum(1800),new SecNum(2000),new SecNum(2200)],
               "cTime":[new SecNum(1384)],
               "cResource":[new SecNum(60000),new SecNum(90000),new SecNum(135000),new SecNum(180000),new SecNum(234000),new SecNum(280000)],
               "cStorage":[70],
               "bucket":[70],
               "targetGroup":[4]
            }
         },
         "C12":{
            "index":16,
            "page":4,
            "order":3,
            "resource":8192000,
            "time":new SecNum(72 * 60 * 60),
            "level":4,
            "name":"#m_dave#",
            "classType":DAVEv2,
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
               "targetGroup":[1]
            }
         },
         "C13":{
            "index":15,
            "page":4,
            "order":2,
            "resource":4096000,
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
               "health":[new SecNum(900),new SecNum(1200),new SecNum(1650),new SecNum(1950),new SecNum(2250),new SecNum(2550)],
               "damage":[new SecNum(600),new SecNum(800),new SecNum(1100),new SecNum(1200),new SecNum(1300),new SecNum(1400)],
               "cTime":[new SecNum(1384)],
               "cResource":[new SecNum(20000),new SecNum(25000),new SecNum(30000),new SecNum(35000),new SecNum(40000),new SecNum(47500)],
               "cStorage":[70],
               "bucket":[70],
               "targetGroup":[1]
            }
         },
         "C14":{
            "index":14,
            "page":4,
            "order":1,
            "resource":4096000,
            "time":new SecNum(60 * 60 * 60),
            "level":4,
            "name":"#m_teratorn#",
            "classType":Teratornv2,
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
               "targetGroup":[1]
            }
         },
         "C15":{
            "index":13,
            "page":3,
            "order":5,
            "resource":6192000,
            "time":new SecNum(60 * 60 * 60),
            "level":3,
            "name":"#m_zafreeti#",
            "classType":Zafreetiv2,
            "description":"mon_zafreetidesc",
            "stream":["mon_zafreetistream","mon_zafreetistreambody","quests/monster15.v2.png"],
            "trainingCosts":[[new SecNum(6192000),new SecNum(60 * 60 * 36)],[new SecNum(7800000),new SecNum(60 * 60 * 54)],[new SecNum(12000000),new SecNum(60 * 60 * 80)],[new SecNum(18000000),new SecNum(60 * 60 * 136)]],
            "movement":"fly",
            "pathing":"direct",
            "antiHeal":true,
            "props":{
               "range":[10],
               "attackDelay":[30],
               "speed":[0.75,0.8,0.85,0.9,0.95],
               "health":[new SecNum(8000)],
               "damage":[new SecNum(-800),new SecNum(-1100),new SecNum(-1400),new SecNum(-1700),new SecNum(-2100)],
               "cTime":[new SecNum(2400)],
               "cResource":[new SecNum(120000),new SecNum(180000),new SecNum(256000),new SecNum(324000),new SecNum(468000)],
               "cStorage":[200],
               "bucket":[200],
               "targetGroup":[5]
            }
         },
         "C16":{
            "index":9,
            "page":2,
            "order":5,
            "resource":384000,
            "time":new SecNum(36 * 60 * 60),
            "level":2,
            "name":"#m_vorg#",
            "blocked":true,
            "classType":Vorgv2,
            "description":"mon_vorgdesc",
            "trainingCosts":[[new SecNum(384000),new SecNum(60 * 60 * 24)],[new SecNum(384000),new SecNum(60 * 60 * 36)],[new SecNum(512000),new SecNum(60 * 60 * 48)],[new SecNum(768000),new SecNum(60 * 60 * 60)],[new SecNum(1024000),new SecNum(60 * 60 * 72)]],
            "movement":"fly",
            "stream":["","","quests/monster16.png"],
            "pathing":"direct",
            "antiHeal":true,
            "blocked":true,
            "props":{
               "altitude":[61],
               "range":[200],
               "attackDelay":[10],
               "speed":[2.5,2.75,3,3.25,3.5],
               "health":[new SecNum(750)],
               "damage":[new SecNum(-30),new SecNum(-35),new SecNum(-40),new SecNum(-45),new SecNum(-50),new SecNum(-55)],
               "cTime":[new SecNum(1200)],
               "cResource":[new SecNum(16000),new SecNum(25000),new SecNum(38500),new SecNum(62500),new SecNum(75000),new SecNum(90000)],
               "cStorage":[60],
               "bucket":[60],
               "targetGroup":[5]
            }
         },
         "C17":{
            "index":10,
            "page":3,
            "order":2,
            "resource":2048000,
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
               "splits":[2,2,3,3,4,5]
            }
         },
         "C18":{
            "index":18,
            "page":3,
            "order":2,
            "resource":2048000,
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
         "IC1":{
            "index":1,
            "page":1,
            "order":1,
            "resource":2400,
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
               "bucket":[20],
               "targetGroup":[1]
            }
         },
         "IC2":{
            "index":2,
            "page":1,
            "order":2,
            "resource":4800,
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
               "bucket":[20],
               "targetGroup":[4]
            }
         },
         "IC4":{
            "index":3,
            "page":2,
            "order":1,
            "resource":38400,
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
               "bucket":[20],
               "targetGroup":[2]
            }
         },
         "IC3":{
            "index":4,
            "page":2,
            "order":2,
            "resource":76800,
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
               "bucket":[20],
               "targetGroup":[3]
            }
         },
         "IC5":{
            "index":5,
            "page":3,
            "order":1,
            "resource":614400,
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
               "bucket":[60],
               "targetGroup":[6]
            }
         },
         "IC6":{
            "index":6,
            "page":3,
            "order":2,
            "resource":1228800,
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
               "bucket":[60],
               "targetGroup":[3]
            }
         },
         "IC7":{
            "index":7,
            "page":3,
            "order":3,
            "resource":2457600,
            "time":new SecNum(172800),
            "level":3,
            "name":"#m_sabnox#",
            "classType":Sabnoxv2,
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
               "bucket":[90],
               "targetGroup":[4]
            }
         },
         "IC8":{
            "index":8,
            "page":4,
            "order":1,
            "resource":4915200,
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
               "targetGroup":[1]
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
       
      
      public function RebalancedCreatures()
      {
         super();
      }
   }
}
