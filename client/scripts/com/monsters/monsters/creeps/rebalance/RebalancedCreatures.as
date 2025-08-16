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
               "health":[300,330,360,390,420,450],
               "damage":[90,105,120,135,150,165],
               "cTime":[15,10,8,7,6,5],
               "cResource":[250,450,675,800,1000,1250],
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
               "health":[1000,1100,1300,1450,1600,1800],
               "damage":[30,30,40,50,60,70],
               "cTime":[15,16],
               "cResource":[500,900,1350,1800,2100,2500],
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
               "health":[600,660,720,780,840,900],
               "damage":[45,60,75,105,135,165],
               "cTime":[23],
               "cResource":[350,675,1015,1400,1800,2400],
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
               "health":[350,400,450,500,550,600],
               "damage":[450,495,570,645,705,780],
               "cTime":[100,100,100,100,90,90],
               "cResource":[1500,2250,3375,4800,7200,10000],
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
               "health":[600,900,1200,1600,2000,2400],
               "damage":[4000,8000,12000,16000,20000,24000],
               "cTime":[1500],
               "cResource":[5000,15000,30000,45000,60000,80000],
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
               "health":[2000,2100,2200,2300,2400,2500],
               "damage":[75,90,105,120,143,165],
               "cTime":[100,100,90],
               "cResource":[5000,5625,8440,11200,16000,24000],
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
               "health":[750,825,900,975,1125,1200],
               "damage":[300,375,450,525,600,675],
               "cTime":[225,225,225,225,180,180],
               "cResource":[2500,4500,6750,8750,11200,14400],
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
               "health":[600,630,660,720,750,780],
               "damage":[1200,1280,1360,1440,1520,1600],
               "cTime":[450,350,250,225,195,195],
               "cResource":[18000,27000,40500,60500,80000,100000],
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
               "health":[1300,1400,1500,1600,1700,1800],
               "damage":[340,380,420,460,500,540],
               "cTime":[342],
               "cResource":[12000,20250,30375,35000,50000,75000],
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
               "health":[4000,4000,4300,4400,4600,4800],
               "damage":[200,240,260,280,300,340],
               "cTime":[750],
               "cResource":[30000,45000,67500,75000,90000,120000],
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
               "health":[1200,1350,1425,1500,1650,1800],
               "damage":[1200,1400,1600,1800,2000,2200],
               "cTime":[1384],
               "cResource":[60000,90000,135000,180000,234000,280000],
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
               "health":[8000,9100,10000,12000,16500,21000],
               "damage":[1500,1500,1600,1700,1800,1900],
               "cTime":[3600],
               "cResource":[150000,225000,337500,440000,600000,800000],
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
               "health":[900,1200,1650,1950,2250,2550],
               "damage":[600,800,1100,1200,1300,1400],
               "cTime":[1384],
               "cResource":[20000,25000,30000,35000,40000,47500],
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
               "health":[1600,1900,2400,3000,3600,4200],
               "damage":[300,350,400,500,600,700],
               "cTime":[1800,1920,2040,2160,2280,2400],
               "cResource":[70000,95000,145000,200000,300000,400000],
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
               "health":[8000],
               "damage":[-800,-1100,-1400,-1700,-2100],
               "cTime":[2400],
               "cResource":[120000,180000,256000,324000,468000],
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
               "health":[750],
               "damage":[-30,-35,-40,-45,-50,-55],
               "cTime":[1200],
               "cResource":[16000,25000,38500,62500,75000,90000],
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
               "health":[700,725,750,800,900,1000],
               "damage":[850,850,900,1000,1200,1400],
               "cTime":[500,450,400,350,300,250],
               "cResource":[27000,40500,60750,90000,125000,150000],
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
               "health":[250],
               "damage":[310,320,330,340,350],
               "cTime":[500,450,400,350,300,250],
               "cResource":[27000,40500,60750,90000,125000,150000],
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
               "health":[400,425,450,475,510,550],
               "damage":[160,200,200,250,300,350],
               "cTime":[15,10,8,7,6,5],
               "cResource":[500,1000,2000,4000,6000,10000],
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
               "health":[1500,1820,2300,2800,3350,3600],
               "damage":[80,85,90,95,100,110],
               "cTime":[15,16,16,16,16,16],
               "cResource":[2500,4000,8000,12000,16000,20000],
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
               "health":[2000,2400,2800,3200,3600,4000],
               "damage":[490,530,580,645,700,775],
               "cTime":[450,350,250,225,195,195],
               "cResource":[31000,35000,39000,44000,50000,55000],
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
               "health":[450,470,500,540,580,620],
               "damage":[100,105,110,120,130,140],
               "cTime":[100,100,90,90,90,90],
               "cResource":[3000,3500,4100,4800,5500,7000],
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
               "health":[3200,3600,4000,4500,5000,5600],
               "damage":[600,665,730,795,860,930],
               "cTime":[1800,1920,2040,2160,2280,2400],
               "cResource":[88000,104000,161000,249000,327000,487000],
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
               "health":[7600,8750,9900,10100,11300,12500],
               "damage":[400,425,450,475,500,550],
               "cTime":[1800,1800,1800,1800,1800,1800],
               "cResource":[80000,105000,135000,175000,210000,325000],
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
               "health":[1120,1260,1400,1650,1900,2200],
               "damage":[700,825,950,1075,1200,1350],
               "cTime":[1384,1384,1384,1384,1384,1384],
               "cResource":[60000,90000,145000,200000,330000,450000],
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
               "health":[6200,7600,8700,10900,13100,16000],
               "damage":[1200,1360,1630,1920,2220,2500],
               "cTime":[2700],
               "cResource":[425000,476000,580000,700000,910000,1204000],
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
               "health":[200],
               "damage":[20],
               "cTime":[10],
               "cResource":[10],
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
