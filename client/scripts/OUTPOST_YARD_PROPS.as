package
{
   import com.cc.utils.SecNum;
   import com.monsters.siege.SiegeFactory;
   import com.monsters.siege.SiegeLab;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class OUTPOST_YARD_PROPS
   {
      public static const _outpostProps:Array = [{
         "id":1,
         "group":1,
         "order":1,
         "buildStatus":0,
         "type":"resource",
         "name":"#b_twigsnapper#",
         "size":100,
         "cycle":30,
         "attackgroup":1,
         "tutstage":0,
         "sale":0,
         "description":"twigsnapper_desc",
         "costs":[{
            "r1":0,
            "r2":750,
            "r3":0,
            "r4":0,
            "time":new SecNum(15),
            "re":[[112,1,1]]
         },{
            "r1":0,
            "r2":1575,
            "r3":0,
            "r4":0,
            "time":new SecNum(300),
            "re":[[112,1,1]]
         },{
            "r1":0,
            "r2":3300,
            "r3":0,
            "r4":0,
            "time":new SecNum(1200),
            "re":[[112,1,1]]
         },{
            "r1":0,
            "r2":6950,
            "r3":0,
            "r4":0,
            "time":new SecNum(3600),
            "re":[[112,1,1]]
         },{
            "r1":0,
            "r2":14500,
            "r3":0,
            "r4":0,
            "time":new SecNum(7200),
            "re":[[112,1,1]]
         },{
            "r1":0,
            "r2":30600,
            "r3":0,
            "r4":0,
            "time":new SecNum(18000),
            "re":[[112,1,1]]
         },{
            "r1":0,
            "r2":64300,
            "r3":0,
            "r4":0,
            "time":new SecNum(43200),
            "re":[[112,1,1]]
         },{
            "r1":0,
            "r2":135000,
            "r3":0,
            "r4":0,
            "time":new SecNum(86400),
            "re":[[112,1,1]]
         },{
            "r1":0,
            "r2":283600,
            "r3":0,
            "r4":0,
            "time":new SecNum(172800),
            "re":[[112,1,1]]
         },{
            "r1":0,
            "r2":600000,
            "r3":0,
            "r4":0,
            "time":new SecNum(259200),
            "re":[[112,1,1]]
         }],
         "imageData":{
            "baseurl":"buildings/twigsnapper.v2/",
            1:{
               "anim":["anim.1.png",new Rectangle(-4,10,23,33),34],
               "top":["top.1.png",new Point(-30,-19)],
               "shadow":["shadow.1.jpg",new Point(-23,29)],
               "topdamaged":["top.1.damaged.png",new Point(-30,-19)],
               "shadowdamaged":["shadow.1.damaged.jpg",new Point(-28,28)],
               "topdestroyed":["top.destroyed.png",new Point(-34,2)],
               "shadowdestroyed":["shadow.destroyed.jpg",new Point(-31,20)]
            },
            3:{
               "anim":["anim.3.png",new Rectangle(0,6,23,30),34],
               "top":["top.3.png",new Point(-32,-40)],
               "shadow":["shadow.3.jpg",new Point(-38,11)],
               "topdamaged":["top.3.damaged.png",new Point(-33,-37)],
               "shadowdamaged":["shadow.3.damaged.jpg",new Point(-27,25)],
               "topdestroyed":["top.destroyed.png",new Point(-34,2)],
               "shadowdestroyed":["shadow.destroyed.jpg",new Point(-31,20)]
            },
            6:{
               "anim":["anim.6.png",new Rectangle(-1,1,34,34),34],
               "top":["top.6.png",new Point(-34,-42)],
               "shadow":["shadow.6.jpg",new Point(-25,26)],
               "topdamaged":["top.6.damaged.png",new Point(-35,-42)],
               "shadowdamaged":["shadow.6.damaged.jpg",new Point(-28,25)],
               "topdestroyed":["top.destroyed.png",new Point(-34,2)],
               "shadowdestroyed":["shadow.destroyed.jpg",new Point(-31,20)]
            },
            10:{
               "anim":["anim.10.png",new Rectangle(-2,3,35,33),34],
               "top":["top.10.png",new Point(-34,-54)],
               "shadow":["shadow.10.jpg",new Point(-26,26)],
               "topdamaged":["top.10.damaged.png",new Point(-35,-41)],
               "shadowdamaged":["shadow.10.damaged.jpg",new Point(-28,22)],
               "topdestroyed":["top.destroyed.png",new Point(-34,2)],
               "shadowdestroyed":["shadow.destroyed.jpg",new Point(-31,20)]
            }
         },
         "upgradeImgData":{
            "baseurl":"buildingbuttons/",
            1:{
               "img":"1.1.jpg",
               "silhouette_img":"1.1.silhouette.jpg"
            },
            3:{"img":"1.3.jpg"},
            6:{"img":"1.6.jpg"},
            10:{"img":"1.10.jpg"}
         },
         "thumbImgData":{
            "baseurl":"buildingthumbs/",
            1:{"img":"1.1.png"},
            3:{"img":"1.3.png"},
            6:{"img":"1.6.png"},
            10:{"img":"1.10.png"}
         },
         "quantity":[0,4],
         "produce":[2,4,7,11,16,22,29,37,46,56],
         "cycleTime":[10,10,10,10,10,10,10,10,10,10],
         "capacity":[720,2160,5670,13365,29160,60142,118918,227584,424414,775018],
         "hp":[500,950,1800,3400,6500,12000,24000,45000,85000,165000],
         "repairTime":[30,60,120,240,480,960,1920,3840,7680,15360]
      },{
         "id":2,
         "group":1,
         "order":2,
         "buildStatus":0,
         "type":"resource",
         "name":"#b_pebbleshiner#",
         "size":100,
         "cycle":30,
         "attackgroup":1,
         "tutstage":0,
         "sale":0,
         "description":"pebbleshiner_desc",
         "costs":[{
            "r1":750,
            "r2":0,
            "r3":0,
            "r4":0,
            "time":new SecNum(15),
            "re":[[112,1,1]]
         },{
            "r1":1575,
            "r2":0,
            "r3":0,
            "r4":0,
            "time":new SecNum(300),
            "re":[[112,1,1]]
         },{
            "r1":3300,
            "r2":0,
            "r3":0,
            "r4":0,
            "time":new SecNum(1200),
            "re":[[112,1,1]]
         },{
            "r1":6950,
            "r2":0,
            "r3":0,
            "r4":0,
            "time":new SecNum(3600),
            "re":[[112,1,1]]
         },{
            "r1":14500,
            "r2":0,
            "r3":0,
            "r4":0,
            "time":new SecNum(7200),
            "re":[[112,1,1]]
         },{
            "r1":30600,
            "r2":0,
            "r3":0,
            "r4":0,
            "time":new SecNum(18000),
            "re":[[112,1,1]]
         },{
            "r1":64300,
            "r2":0,
            "r3":0,
            "r4":0,
            "time":new SecNum(43200),
            "re":[[112,1,1]]
         },{
            "r1":135000,
            "r2":0,
            "r3":0,
            "r4":0,
            "time":new SecNum(86400),
            "re":[[112,1,1]]
         },{
            "r1":283600,
            "r2":0,
            "r3":0,
            "r4":0,
            "time":new SecNum(172800),
            "re":[[112,1,1]]
         },{
            "r1":600000,
            "r2":0,
            "r3":0,
            "r4":0,
            "time":new SecNum(259200),
            "re":[[112,1,1]]
         }],
         "imageData":{
            "baseurl":"buildings/pebbleshiner.v2/",
            1:{
               "anim":["anim.1.png",new Rectangle(-21,8,42,24),26],
               "top":["top.1.png",new Point(-34,-12)],
               "shadow":["shadow.1.jpg",new Point(-33,27)],
               "topdamaged":["top.1.damaged.png",new Point(-34,-6)],
               "shadowdamaged":["shadow.1.damaged.jpg",new Point(-31,27)],
               "topdestroyed":["top.destroyed.png",new Point(-35,-2)],
               "shadowdestroyed":["shadow.destroyed.jpg",new Point(-33,22)]
            },
            3:{
               "anim":["anim.3.png",new Rectangle(-29,3,58,31),26],
               "top":["top.3.png",new Point(-34,-27)],
               "shadow":["shadow.3.jpg",new Point(-33,27)],
               "topdamaged":["top.3.damaged.png",new Point(-33,-26)],
               "shadowdamaged":["shadow.3.damaged.jpg",new Point(-31,22)],
               "topdestroyed":["top.destroyed.png",new Point(-35,-2)],
               "shadowdestroyed":["shadow.destroyed.jpg",new Point(-32,22)]
            },
            6:{
               "anim":["anim.6.png",new Rectangle(-29,-5,58,41),26],
               "top":["top.6.png",new Point(-34,-34)],
               "shadow":["shadow.6.jpg",new Point(-34,20)],
               "topdamaged":["top.6.damaged.png",new Point(-45,-32)],
               "shadowdamaged":["shadow.6.damaged.jpg",new Point(-34,20)],
               "topdestroyed":["top.destroyed.png",new Point(-35,-2)],
               "shadowdestroyed":["shadow.destroyed.jpg",new Point(-33,22)]
            },
            10:{
               "anim":["anim.10.png",new Rectangle(-29,-37,62,72),24],
               "top":["top.10.png",new Point(-34,-32)],
               "shadow":["shadow.10.jpg",new Point(-34,22)],
               "topdamaged":["top.10.damaged.png",new Point(-34,-36)],
               "shadowdamaged":["shadow.10.damaged.jpg",new Point(-34,15)],
               "topdestroyed":["top.destroyed.png",new Point(-35,-2)],
               "shadowdestroyed":["shadow.destroyed.jpg",new Point(-33,22)]
            }
         },
         "upgradeImgData":{
            "baseurl":"buildingbuttons/",
            1:{
               "img":"2.1.jpg",
               "silhouette_img":"2.1.silhouette.jpg"
            },
            3:{"img":"2.3.jpg"},
            6:{"img":"2.6.jpg"},
            10:{"img":"2.10.jpg"}
         },
         "thumbImgData":{
            "baseurl":"buildingthumbs/",
            1:{"img":"2.1.png"},
            3:{"img":"2.3.png"},
            6:{"img":"2.6.png"},
            10:{"img":"2.10.png"}
         },
         "quantity":[0,4],
         "produce":[2,4,7,11,16,22,29,37,46,56],
         "cycleTime":[10,10,10,10,10,10,10,10,10,10],
         "capacity":[720,2160,5670,13365,29160,60142,118918,227584,424414,775018],
         "hp":[500,950,1800,3400,6500,12000,24000,45000,85000,165000],
         "repairTime":[30,60,120,240,480,960,1920,3840,7680,15360]
      },{
         "id":3,
         "group":1,
         "order":3,
         "buildStatus":0,
         "type":"resource",
         "name":"#b_puttysquisher#",
         "size":100,
         "cycle":30,
         "attackgroup":1,
         "tutstage":80,
         "sale":0,
         "description":"puttysquisher_desc",
         "costs":[{
            "r1":525,
            "r2":224,
            "r3":0,
            "r4":0,
            "time":new SecNum(20),
            "re":[[112,1,1]]
         },{
            "r1":1102,
            "r2":470,
            "r3":0,
            "r4":0,
            "time":new SecNum(300),
            "re":[[112,1,1]]
         },{
            "r1":2315,
            "r2":992,
            "r3":0,
            "r4":0,
            "time":new SecNum(1200),
            "re":[[112,1,1]]
         },{
            "r1":4862,
            "r2":2086,
            "r3":0,
            "r4":0,
            "time":new SecNum(3600),
            "re":[[112,1,1]]
         },{
            "r1":10210,
            "r2":4375,
            "r3":0,
            "r4":0,
            "time":new SecNum(7200),
            "re":[[112,1,1]]
         },{
            "r1":21441,
            "r2":9190,
            "r3":0,
            "r4":0,
            "time":new SecNum(18000),
            "re":[[112,1,1]]
         },{
            "r1":45027,
            "r2":19298,
            "r3":0,
            "r4":0,
            "time":new SecNum(43200),
            "re":[[112,1,1]]
         },{
            "r1":94557,
            "r2":40524,
            "r3":0,
            "r4":0,
            "time":new SecNum(86400),
            "re":[[112,1,1]]
         },{
            "r1":198570,
            "r2":85102,
            "r3":0,
            "r4":0,
            "time":new SecNum(172800),
            "re":[[112,1,1]]
         },{
            "r1":416997,
            "r2":178716,
            "r3":0,
            "r4":0,
            "time":new SecNum(259200),
            "re":[[112,1,1]]
         }],
         "imageData":{
            "baseurl":"buildings/puttysquisher.v2/",
            1:{
               "anim":["anim.1.png",new Rectangle(-10,8,28,18),26],
               "top":["top.1.png",new Point(-26,5)],
               "shadow":["shadow.1.jpg",new Point(-21,29)],
               "topdamaged":["top.1.damaged.png",new Point(-29,4)],
               "shadowdamaged":["shadow.1.damaged.jpg",new Point(-28,28)],
               "topdestroyed":["top.destroyed.png",new Point(-39,5)],
               "shadowdestroyed":["shadow.destroyed.jpg",new Point(-36,21)]
            },
            3:{
               "anim":["anim.3.png",new Rectangle(-10,-7,29,20),26],
               "top":["top.3.png",new Point(-28,-20)],
               "shadow":["shadow.3.jpg",new Point(-33,18)],
               "topdamaged":["top.3.damaged.png",new Point(-38,-20)],
               "shadowdamaged":["shadow.3.damaged.jpg",new Point(-37,26)],
               "topdestroyed":["top.destroyed.png",new Point(-39,5)],
               "shadowdestroyed":["shadow.destroyed.jpg",new Point(-36,21)]
            },
            6:{
               "anim":["anim.6.png",new Rectangle(-10,-6,29,19),26],
               "top":["top.6.png",new Point(-30,-43)],
               "shadow":["shadow.6.jpg",new Point(-28,23)],
               "topdamaged":["top.6.damaged.png",new Point(-28,-38)],
               "shadowdamaged":["shadow.6.damaged.jpg",new Point(-29,25)],
               "topdestroyed":["top.destroyed.png",new Point(-39,5)],
               "shadowdestroyed":["shadow.destroyed.jpg",new Point(-36,21)]
            },
            10:{
               "anim":["anim.10.png",new Rectangle(-10,-39,44,52),25],
               "top":["top.10.png",new Point(-31,-42)],
               "shadow":["shadow.10.jpg",new Point(-31,22)],
               "topdamaged":["top.10.damaged.png",new Point(-40,-40)],
               "shadowdamaged":["shadow.10.damaged.jpg",new Point(-38,24)],
               "topdestroyed":["top.destroyed.png",new Point(-39,5)],
               "shadowdestroyed":["shadow.destroyed.jpg",new Point(-36,21)]
            }
         },
         "upgradeImgData":{
            "baseurl":"buildingbuttons/",
            1:{
               "img":"3.1.jpg",
               "silhouette_img":"3.1.silhouette.jpg"
            },
            3:{"img":"3.3.v2.jpg"},
            6:{"img":"3.6.v2.jpg"},
            10:{"img":"3.10.v2.jpg"}
         },
         "thumbImgData":{
            "baseurl":"buildingthumbs/",
            1:{"img":"3.1.png"},
            3:{"img":"3.3.png"},
            6:{"img":"3.6.png"},
            10:{"img":"3.10.png"}
         },
         "quantity":[0,4],
         "produce":[2,4,7,11,16,22,29,37,46,56],
         "cycleTime":[10,10,10,10,10,10,10,10,10,10],
         "capacity":[720,2160,5670,13365,29160,60142,118918,227584,424414,775018],
         "hp":[500,950,1800,3400,6500,12000,24000,45000,85000,165000],
         "repairTime":[30,60,120,240,480,960,1920,3840,7680,15360]
      },{
         "id":4,
         "group":1,
         "order":4,
         "buildStatus":0,
         "type":"resource",
         "name":"#b_goofactory#",
         "size":100,
         "cycle":30,
         "attackgroup":1,
         "tutstage":80,
         "sale":0,
         "description":"goofactory_desc",
         "costs":[{
            "r1":247,
            "r2":577,
            "r3":0,
            "r4":0,
            "time":new SecNum(20),
            "re":[[112,1,1]]
         },{
            "r1":520,
            "r2":1212,
            "r3":0,
            "r4":0,
            "time":new SecNum(300),
            "re":[[112,1,1]]
         },{
            "r1":1090,
            "r2":2546,
            "r3":0,
            "r4":0,
            "time":new SecNum(1200),
            "re":[[112,1,1]]
         },{
            "r1":2290,
            "r2":5348,
            "r3":0,
            "r4":0,
            "time":new SecNum(3600),
            "re":[[112,1,1]]
         },{
            "r1":4810,
            "r2":11231,
            "r3":0,
            "r4":0,
            "time":new SecNum(7200),
            "re":[[112,1,1]]
         },{
            "r1":10108,
            "r2":23585,
            "r3":0,
            "r4":0,
            "time":new SecNum(18000),
            "re":[[112,1,1]]
         },{
            "r1":21227,
            "r2":49529,
            "r3":0,
            "r4":0,
            "time":new SecNum(43200),
            "re":[[112,1,1]]
         },{
            "r1":44580,
            "r2":104012,
            "r3":0,
            "r4":0,
            "time":new SecNum(86400),
            "re":[[112,1,1]]
         },{
            "r1":93600,
            "r2":218427,
            "r3":0,
            "r4":0,
            "time":new SecNum(172800),
            "re":[[112,1,1]]
         },{
            "r1":196584,
            "r2":458696,
            "r3":0,
            "r4":0,
            "time":new SecNum(259200),
            "re":[[112,1,1]]
         }],
         "imageData":{
            "baseurl":"buildings/goofactory.v2/",
            1:{
               "anim":["anim.1.png",new Rectangle(3,14,22,40),26],
               "top":["top.1.png",new Point(-26,-33)],
               "shadow":["shadow.1.jpg",new Point(-25,29)],
               "topdamaged":["top.1.damaged.png",new Point(-32,-15)],
               "shadowdamaged":["shadow.1.damaged.jpg",new Point(-30,27)],
               "topdestroyed":["top.destroyed.png",new Point(-31,0)],
               "shadowdestroyed":["shadow.destroyed.jpg",new Point(-35,24)]
            },
            3:{
               "anim":["anim.3.png",new Rectangle(4,12,25,45),26],
               "top":["top.3.png",new Point(-27,-33)],
               "shadow":["shadow.3.jpg",new Point(-31,21)],
               "topdamaged":["top.3.damaged.png",new Point(-28,-31)],
               "shadowdamaged":["shadow.3.damaged.jpg",new Point(-31,20)],
               "topdestroyed":["top.destroyed.png",new Point(-31,0)],
               "shadowdestroyed":["shadow.destroyed.jpg",new Point(-35,24)]
            },
            6:{
               "anim":["anim.6.png",new Rectangle(-21,12,51,48),26],
               "top":["top.6.png",new Point(-33,-33)],
               "shadow":["shadow.6.jpg",new Point(-26,27)],
               "topdamaged":["top.6.damaged.png",new Point(-37,-29)],
               "shadowdamaged":["shadow.6.damaged.jpg",new Point(-36,25)],
               "topdestroyed":["top.destroyed.png",new Point(-31,0)],
               "shadowdestroyed":["shadow.destroyed.jpg",new Point(-35,24)]
            },
            10:{
               "anim":["anim.10.png",new Rectangle(-21,11,51,47),26],
               "top":["top.10.png",new Point(-40,-48)],
               "shadow":["shadow.10.jpg",new Point(-35,28)],
               "topdamaged":["top.10.damaged.png",new Point(-45,-42)],
               "shadowdamaged":["shadow.10.damaged.jpg",new Point(-37,25)],
               "topdestroyed":["top.destroyed.png",new Point(-31,0)],
               "shadowdestroyed":["shadow.destroyed.jpg",new Point(-35,24)]
            }
         },
         "upgradeImgData":{
            "baseurl":"buildingbuttons/",
            1:{
               "img":"4.1.jpg",
               "silhouette_img":"4.1.silhouette.jpg"
            },
            3:{"img":"4.3.jpg"},
            6:{"img":"4.6.jpg"},
            10:{"img":"4.10.jpg"}
         },
         "upgradeImgData":{
            "baseurl":"buildingbuttons/",
            1:{"img":"4.1.png"},
            3:{"img":"4.3.png"},
            6:{"img":"4.6.png"},
            10:{"img":"4.10.png"}
         },
         "quantity":[0,4],
         "produce":[2,4,7,11,16,22,29,37,46,56],
         "cycleTime":[10,10,10,10,10,10,10,10,10,10],
         "capacity":[720,2160,5670,13365,29160,60142,118918,227584,424414,775018],
         "hp":[500,950,1800,3400,6500,12000,24000,45000,85000,165000],
         "repairTime":[30,60,120,240,480,960,1920,3840,7680,15360]
      },{
         "id":5,
         "group":2,
         "order":9,
         "buildStatus":0,
         "type":"special",
         "name":"#b_flinger#",
         "size":190,
         "attackgroup":1,
         "tutstage":60,
         "sale":0,
         "description":"flinger_desc",
         "costs":[{
            "r1":10000,
            "r2":10000,
            "r3":5000,
            "r4":0,
            "time":new SecNum(900),
            "re":[[112,1,1]]
         },{
            "r1":64300,
            "r2":64300,
            "r3":32150,
            "r4":0,
            "time":new SecNum(10800),
            "re":[[112,1,1]]
         },{
            "r1":283600,
            "r2":283600,
            "r3":141800,
            "r4":0,
            "time":new SecNum(32400),
            "re":[[112,1,1]]
         },{
            "r1":1247840,
            "r2":1247840,
            "r3":623920,
            "r4":0,
            "time":new SecNum(97200),
            "re":[[112,1,1]]
         }],
         "imageData":{
            "baseurl":"buildings/flinger/",
            1:{
               "top":["top.1.png",new Point(-46,-43)],
               "shadow":["shadow.1.jpg",new Point(-50,20)],
               "topdamaged":["top.1.damaged.png",new Point(-63,-36)],
               "shadowdamaged":["shadow.1.damaged.jpg",new Point(-63,23)],
               "topdestroyed":["top.2.destroyed.png",new Point(-75,-3)],
               "shadowdestroyed":["shadow.2.destroyed.jpg",new Point(-70,24)]
            },
            2:{
               "top":["top.2.png",new Point(-45,-40)],
               "shadow":["shadow.2.jpg",new Point(-48,19)],
               "topdamaged":["top.2.damaged.png",new Point(-63,-18)],
               "shadowdamaged":["shadow.2.damaged.jpg",new Point(-63,26)],
               "topdestroyed":["top.2.destroyed.png",new Point(-75,-3)],
               "shadowdestroyed":["shadow.2.destroyed.jpg",new Point(-70,24)]
            },
            3:{
               "top":["top.3.png",new Point(-47,-45)],
               "shadow":["shadow.3.jpg",new Point(-44,20)],
               "topdamaged":["top.3.damaged.png",new Point(-75,-37)],
               "shadowdamaged":["shadow.3.damaged.jpg",new Point(-73,23)],
               "topdestroyed":["top.2.destroyed.png",new Point(-75,-3)],
               "shadowdestroyed":["shadow.2.destroyed.jpg",new Point(-70,24)]
            },
            4:{
               "top":["top.4.png",new Point(-45,-66)],
               "shadow":["shadow.4.jpg",new Point(-47,22)],
               "topdamaged":["top.4.damaged.png",new Point(-76,-53)],
               "shadowdamaged":["shadow.4.damaged.jpg",new Point(-76,23)],
               "topdestroyed":["top.2.destroyed.png",new Point(-75,-3)],
               "shadowdestroyed":["shadow.2.destroyed.jpg",new Point(-70,24)]
            }
         },
         "upgradeImgData":{
            "baseurl":"buildingbuttons/",
            1:{
               "img":"5.1.jpg",
               "silhouette_img":"5.1.silhouette.jpg"
            },
            2:{"img":"5.2.jpg"},
            3:{"img":"5.3.jpg"},
            4:{"img":"5.4.jpg"}
         },
         "thumbImgData":{
            "baseurl":"buildingthumbs/",
            1:{"img":"5.1.png"},
            2:{"img":"5.2.png"},
            3:{"img":"5.3.png"},
            4:{"img":"5.4.png"}
         },
         "quantity":[0,1,1,1,1,1,1,1],
         "capacity":[500,1000,1750,2250,3000,4000],
         "hp":[4000,8000,16000,28000],
         "repairTime":[100,300,600,900]
      },{
         "id":6,
         "group":1,
         "order":5,
         "buildStatus":0,
         "type":"special",
         "name":"#b_storagesilo#",
         "size":120,
         "attackgroup":1,
         "tutstage":200,
         "sale":0,
         "description":"storagesilo_desc",
         "block":true,
         "quantity":[0,0]
      },{
         "id":7,
         "group":999,
         "order":1,
         "buildStatus":0,
         "type":"mushroom",
         "name":"#b_mushroom#",
         "size":10,
         "attackgroup":0,
         "tutstage":0,
         "sale":0,
         "description":"flag_desc",
         "quantity":[0],
         "hp":[10],
         "repairTime":[10]
      },{
         "id":8,
         "group":2,
         "order":3,
         "buildStatus":0,
         "type":"special",
         "name":"#b_monsterlocker#",
         "size":120,
         "attackgroup":2,
         "tutstage":200,
         "sale":0,
         "description":"monsterlocker_desc",
         "block":true,
         "quantity":[0,0]
      },{
         "id":9,
         "group":2,
         "order":14,
         "buildStatus":0,
         "type":"special",
         "name":"#b_monsterjuicer#",
         "size":120,
         "attackgroup":2,
         "tutstage":200,
         "sale":0,
         "description":"monsterjuicer_desc",
         "costs":[{
            "r1":1000000,
            "r2":1000000,
            "r3":1000000,
            "r4":0,
            "time":new SecNum(43200),
            "re":[[112,1,1],[15,1,1]]
         },{
            "r1":250000,
            "r2":250000,
            "r3":0,
            "r4":0,
            "time":new SecNum(21600),
            "re":[[112,1,1],[15,1,1]]
         },{
            "r1":500000,
            "r2":500000,
            "r3":0,
            "r4":0,
            "time":new SecNum(43200),
            "re":[[112,1,1],[15,1,1]]
         }],
         "imageData":{
            "baseurl":"buildings/monsterjuiceloosener/",
            1:{
               "anim":["anim.2.png",new Rectangle(-30,-17,60,39),51],
               "top":["top.2.png",new Point(-44,-8)],
               "shadow":["shadow.2.jpg",new Point(-44,16)],
               "topdamaged":["top.2.damaged.png",new Point(-59,-8)],
               "shadowdamaged":["shadow.2.damaged.jpg",new Point(-59,21)],
               "topdestroyed":["top.2.destroyed.png",new Point(-55,0)],
               "shadowdestroyed":["shadow.2.destroyed.jpg",new Point(-49,17)]
            }
         },
         "upgradeImgData":{
            "baseurl":"buildingbuttons/",
            1:{
               "img":"9.jpg",
               "silhouette_img":"9.silhouette.jpg"
            }
         },
         "thumbImgData":{
            "baseurl":"buildingthumbs/",
            1:{"img":"9.png"}
         },
         "quantity":[0,1],
         "hp":[16000,32000,64000],
         "repairTime":[480,1920,7680]
      },{
         "id":10,
         "group":2,
         "order":13,
         "buildStatus":0,
         "type":"special",
         "name":"#b_yardplanner#",
         "size":120,
         "attackgroup":2,
         "tutstage":200,
         "sale":0,
         "description":"yardplanner_desc",
         "costs":[{
            "r1":125000,
            "r2":125000,
            "r3":0,
            "r4":0,
            "r5":0,
            "time":new SecNum(43200),
            "re":[[112,1,1]]
         }],
         "imageData":{
            "baseurl":"buildings/yardplanner/",
            1:{
               "top":["top.1.png",new Point(-45,-29)],
               "shadow":["shadow.1.jpg",new Point(-57,16)],
               "topdamaged":["top.1.damaged.png",new Point(-58,-27)],
               "shadowdamaged":["shadow.1.damaged.jpg",new Point(-46,23)],
               "topdestroyed":["top.1.destroyed.png",new Point(-52,6)],
               "shadowdestroyed":["shadow.1.destroyed.jpg",new Point(-50,32)]
            }
         },
         "upgradeImgData":{
            "baseurl":"buildingbuttons/",
            1:{
               "img":"10.jpg",
               "silhouette_img":"10.silhouette.jpg"
            }
         },
         "thumbImgData":{
            "baseurl":"buildingthumbs/",
            1:{"img":"10.png"}
         },
         "quantity":[0,1,1,1,1,1,1,1],
         "hp":[16000],
         "repairTime":[3840]
      },{
         "id":11,
         "group":2,
         "order":11,
         "buildStatus":0,
         "type":"special",
         "name":"#b_maproom#",
         "size":120,
         "attackgroup":1,
         "tutstage":80,
         "sale":0,
         "description":"maproom_desc",
         "block":true,
         "quantity":[0,0]
      },{
         "id":12,
         "group":2,
         "order":2,
         "buildStatus":0,
         "type":"special",
         "name":"#b_generalstore#",
         "size":80,
         "attackgroup":2,
         "tutstage":0,
         "sale":0,
         "description":"generalstore_desc",
         "block":true,
         "quantity":[0,0]
      },{
         "id":13,
         "group":2,
         "order":7,
         "buildStatus":0,
         "type":"special",
         "name":"#b_hatchery#",
         "size":120,
         "attackgroup":2,
         "tutstage":140,
         "sale":0,
         "description":"hatchery_desc",
         "costs":[{
            "r1":2000,
            "r2":2000,
            "r3":0,
            "r4":0,
            "time":new SecNum(900),
            "re":[[112,1,1],[15,1,1]]
         },{
            "r1":21227,
            "r2":49529,
            "r3":0,
            "r4":0,
            "time":new SecNum(3600),
            "re":[[112,1,1]]
         },{
            "r1":93600,
            "r2":218427,
            "r3":0,
            "r4":0,
            "time":new SecNum(43200),
            "re":[[112,1,1]]
         }],
         "imageData":{
            "baseurl":"buildings/hatchery/",
            1:{
               "anim":["anim.2.png",new Rectangle(-53,-104,103,80),31],
               "top":["top.2.png",new Point(-50,-52)],
               "shadow":["shadow.2.jpg",new Point(-31,32)],
               "topdamaged":["top.2.damaged.png",new Point(-78,-92)],
               "shadowdamaged":["shadow.2.damaged.jpg",new Point(-48,36)],
               "topdestroyed":["top.1.destroyed.png",new Point(-58,0)],
               "shadowdestroyed":["shadow.1.destroyed.jpg",new Point(-58,32)]
            },
            2:{
               "anim":["anim.3.png",new Rectangle(-40,-123,105,124),31],
               "top":["top.3.png",new Point(-51,-62)],
               "shadow":["shadow.3.jpg",new Point(-48,26)],
               "topdamaged":["top.3.damaged.png",new Point(-53,-113)],
               "shadowdamaged":["shadow.3.damaged.jpg",new Point(-45,32)],
               "topdestroyed":["top.1.destroyed.png",new Point(-58,0)],
               "shadowdestroyed":["shadow.1.destroyed.jpg",new Point(-58,32)]
            },
            3:{
               "anim":["anim.4.png",new Rectangle(-12,-112,113,105),31],
               "top":["top.4.png",new Point(-50,-114)],
               "shadow":["shadow.4.jpg",new Point(-44,25)],
               "topdamaged":["top.4.damaged.png",new Point(-60,-117)],
               "shadowdamaged":["shadow.4.damaged.jpg",new Point(-52,23)],
               "topdestroyed":["top.1.destroyed.png",new Point(-58,0)],
               "shadowdestroyed":["shadow.1.destroyed.jpg",new Point(-58,32)]
            }
         },
         "upgradeImgData":{
            "baseurl":"buildingbuttons/",
            1:{
               "img":"13.1.jpg",
               "silhouette_img":"13.2.silhouette.jpg"
            },
            2:{"img":"13.2.jpg"},
            3:{"img":"13.3.jpg"}
         },
         "thumbImgData":{
            "baseurl":"buildingthumbs/",
            1:{"img":"13.1.png"},
            2:{"img":"13.2.png"},
            3:{"img":"13.3.png"}
         },
         "quantity":[0,2],
         "hp":[4000,16000,32000],
         "repairTime":[60,150,300]
      },{
         "id":14,
         "group":2,
         "order":1,
         "buildStatus":0,
         "type":"special",
         "name":"#b_townhall#",
         "size":190,
         "attackgroup":1,
         "tutstage":0,
         "sale":0,
         "description":"townhall_desc",
         "block":true,
         "costs":[{
            "r1":0,
            "r2":0,
            "r3":0,
            "r4":0,
            "time":new SecNum(10),
            "re":[]
         },{
            "r1":7000,
            "r2":7000,
            "r3":0,
            "r4":0,
            "time":new SecNum(600),
            "re":[[112,1,1]]
         },{
            "r1":42000,
            "r2":42000,
            "r3":0,
            "r4":0,
            "time":new SecNum(14400),
            "re":[[112,1,1]]
         },{
            "r1":240000,
            "r2":240000,
            "r3":0,
            "r4":0,
            "time":new SecNum(57600),
            "re":[[112,1,1]]
         },{
            "r1":1400000,
            "r2":1400000,
            "r3":0,
            "r4":0,
            "time":new SecNum(172800),
            "re":[[112,1,1]]
         },{
            "r1":7560000,
            "r2":7560000,
            "r3":0,
            "r4":0,
            "time":new SecNum(345600),
            "re":[[112,1,1]]
         },{
            "r1":11340000,
            "r2":11340000,
            "r3":0,
            "r4":0,
            "time":new SecNum(518400),
            "re":[[112,1,1]]
         }],
         "imageData":{
            "baseurl":"buildings/townhall/",
            1:{
               "top":["top.1.png",new Point(-45,-52)],
               "shadow":["shadow.1.jpg",new Point(-55,37)],
               "topdamaged":["top.1.damaged.png",new Point(-50,-50)],
               "shadowdamaged":["shadow.1.damaged.jpg",new Point(-55,38)],
               "topdestroyed":["top.1.destroyed.png",new Point(-57,17)],
               "shadowdestroyed":["shadow.1.destroyed.jpg",new Point(-54,37)],
               "topdestroyedfire":["top.1.destroyed.fire.png",new Point(-57,17)]
            },
            2:{
               "top":["top.2.png",new Point(-48,-62)],
               "shadow":["shadow.2.jpg",new Point(-55,36)],
               "topdamaged":["top.2.damaged.png",new Point(-49,-59)],
               "shadowdamaged":["shadow.2.damaged.jpg",new Point(-65,32)],
               "topdestroyed":["top.2.destroyed.png",new Point(-61,6)],
               "shadowdestroyed":["shadow.2.destroyed.jpg",new Point(-59,28)],
               "topdestroyedfire":["top.2.destroyed.fire.png",new Point(-61,6)]
            },
            3:{
               "top":["top.3.png",new Point(-65,-67)],
               "shadow":["shadow.3.jpg",new Point(-70,28)],
               "topdamaged":["top.3.damaged.png",new Point(-69,-68)],
               "shadowdamaged":["shadow.3.damaged.jpg",new Point(-74,29)],
               "topdestroyed":["top.3.destroyed.png",new Point(-70,-8)],
               "shadowdestroyed":["shadow.3.destroyed.jpg",new Point(-70,30)],
               "topdestroyedfire":["top.3.destroyed.fire.png",new Point(-70,-8)]
            },
            4:{
               "top":["top.4.png",new Point(-66,-72)],
               "shadow":["shadow.4.jpg",new Point(-88,20)],
               "topdamaged":["top.4.damaged.png",new Point(-66,-72)],
               "shadowdamaged":["shadow.4.damaged.jpg",new Point(-77,25)],
               "topdestroyed":["top.4.destroyed.png",new Point(-92,-18)],
               "shadowdestroyed":["shadow.4.destroyed.jpg",new Point(-91,25)],
               "topdestroyedfire":["top.4.destroyed.fire.png",new Point(-92,-18)]
            },
            5:{
               "top":["top.5.png",new Point(-67,-75)],
               "shadow":["shadow.5.jpg",new Point(-67,33)],
               "topdamaged":["top.5.damaged.png",new Point(-70,-69)],
               "shadowdamaged":["shadow.5.damaged.jpg",new Point(-17,20)],
               "topdestroyed":["top.5.destroyed.png",new Point(-89,-16)],
               "shadowdestroyed":["shadow.5.destroyed.jpg",new Point(-88,30)],
               "topdestroyedfire":["top.5.destroyed.fire.png",new Point(-89,-16)]
            },
            6:{
               "top":["top.6.png",new Point(-72,-82)],
               "shadow":["shadow.6.jpg",new Point(-84,26)],
               "topdamaged":["top.6.damaged.png",new Point(-72,-67)],
               "shadowdamaged":["shadow.6.damaged.jpg",new Point(-85,25)],
               "topdestroyed":["top.6.destroyed.png",new Point(-92,-8)],
               "shadowdestroyed":["shadow.6.destroyed.jpg",new Point(-90,25)],
               "topdestroyedfire":["top.6.destroyed.fire.png",new Point(-92,-8)]
            },
            7:{
               "top":["top.7.png",new Point(-81,-88)],
               "shadow":["shadow.7.jpg",new Point(-121,-3)],
               "topdamaged":["top.7.damaged.png",new Point(-81,-89)],
               "shadowdamaged":["shadow.7.damaged.jpg",new Point(-103,3)],
               "topdestroyed":["top.7.destroyed.png",new Point(-84,-13)],
               "shadowdestroyed":["shadow.7.destroyed.jpg",new Point(-102,8)]
            },
            8:{
               "top":["top.8.png",new Point(-80,-87)],
               "shadow":["shadow.8.jpg",new Point(-94,8)],
               "topdamaged":["top.8.damaged.png",new Point(-86,-91)],
               "shadowdamaged":["shadow.8.damaged.jpg",new Point(-86,13)],
               "topdestroyed":["top.8.destroyed.png",new Point(-84,-13)],
               "shadowdestroyed":["shadow.8.destroyed.jpg",new Point(-102,8)]
            }
         },
         "upgradeImgData":{
            "baseurl":"buildingbuttons/",
            1:{
               "img":"14.1.jpg",
               "silhouette_img":"14.1.silhouette.jpg"
            },
            2:{"img":"14.2.jpg"},
            3:{"img":"14.3.jpg"},
            4:{"img":"14.4.jpg"},
            5:{"img":"14.5.jpg"},
            6:{"img":"14.6.jpg"},
            7:{"img":"14.7.jpg"},
            8:{"img":"14.8.jpg"}
         },
         "thumbImgData":{
            "baseurl":"buildingthumbs/",
            1:{"img":"14.1.png"},
            2:{"img":"14.2.png"},
            3:{"img":"14.3.png"},
            4:{"img":"14.4.png"},
            5:{"img":"14.5.png"},
            6:{"img":"14.6.png"},
            7:{"img":"14.7.png"},
            8:{"img":"14.8.png"}
         },
         "quantity":[1,1,1,1,1,1,1,1,1],
         "hp":[4000,8800,20000,42000,94000,200000,300000,400000],
         "repairTime":[480,1920,3840,7680,15360,30720,64800,86400]
      },{
         "id":15,
         "group":2,
         "order":6,
         "buildStatus":0,
         "type":"special",
         "name":"#b_housing#",
         "size":200,
         "attackgroup":2,
         "tutstage":50,
         "sale":0,
         "description":"housing_desc",
         "costs":[{
            "r1":2160,
            "r2":2160,
            "r3":0,
            "r4":0,
            "time":new SecNum(300),
            "re":[[112,1,1]]
         },{
            "r1":8640,
            "r2":8640,
            "r3":0,
            "r4":0,
            "time":new SecNum(4500),
            "re":[[112,1,1]]
         },{
            "r1":34560,
            "r2":34560,
            "r3":0,
            "r4":0,
            "time":new SecNum(10800),
            "re":[[112,1,1]]
         },{
            "r1":138240,
            "r2":138240,
            "r3":0,
            "r4":0,
            "time":new SecNum(28800),
            "re":[[112,1,1]]
         },{
            "r1":552960,
            "r2":552960,
            "r3":0,
            "r4":0,
            "time":new SecNum(72000),
            "re":[[112,1,1]]
         },{
            "r1":2211840,
            "r2":2211840,
            "r3":0,
            "r4":0,
            "time":new SecNum(144000),
            "re":[[112,1,1]]
         }],
         "imageData":{
            "baseurl":"buildings/monsterhousing/",
            1:{
               "top":["top.3.v2.png",new Point(-109,11)],
               "shadow":["shadow.3.v2.jpg",new Point(-112,23)],
               "topdamaged":["top.3.damaged.v2.png",new Point(-107,12)],
               "shadowdamaged":["shadow.3.damaged.v2.jpg",new Point(-110,25)],
               "topdestroyed":["top.3.destroyed.v2.png",new Point(-108,21)],
               "shadowdestroyed":["shadow.3.destroyed.v2.jpg",new Point(-109,25)]
            }
         },
         "upgradeImgData":{
            "baseurl":"buildingbuttons/",
            1:{
               "img":"15.jpg",
               "silhouette_img":"15.silhouette.jpg"
            }
         },
         "thumbImgData":{
            "baseurl":"buildingthumbs/",
            1:{"img":"15.png"}
         },
         "quantity":[0,1],
         "capacity":[200,260,320,380,450,540],
         "hp":[4000,14000,25000,43000,75000,130000],
         "repairTime":[100,200,300,400,500,600]
      },{
         "id":16,
         "group":2,
         "order":8,
         "buildStatus":0,
         "type":"special",
         "name":"#b_hcc#",
         "size":120,
         "attackgroup":2,
         "tutstage":200,
         "sale":0,
         "description":"hcc_desc",
         "costs":[{
            "r1":500000,
            "r2":500000,
            "r3":500000,
            "r4":0,
            "time":new SecNum(90000),
            "re":[[112,1,1],[13,2,1]]
         }],
         "imageData":{
            "baseurl":"buildings/hatcherycontrolcenter/",
            1:{
               "top":["top.1.png",new Point(-40,-58)],
               "shadow":["shadow.1.jpg",new Point(-51,20)],
               "topdamaged":["top.1.damaged.png",new Point(-51,-59)],
               "shadowdamaged":["shadow.1.damaged.jpg",new Point(-50,25)],
               "topdestroyed":["top.1.destroyed.png",new Point(-53,-7)],
               "shadowdestroyed":["shadow.1.destroyed.jpg",new Point(-57,24)]
            }
         },
         "upgradeImgData":{
            "baseurl":"buildingbuttons/",
            1:{
               "img":"16.jpg",
               "silhouette_img":"16.silhouette.jpg"
            }
         },
         "thumbImgData":{
            "baseurl":"buildingthumbs/",
            1:{"img":"16.png"}
         },
         "quantity":[0,1],
         "hp":[64000],
         "repairTime":[300]
      },{
         "id":17,
         "group":3,
         "order":7,
         "buildStatus":0,
         "type":"wall",
         "name":"#b_woodenblock#",
         "size":50,
         "attackgroup":1,
         "tutstage":200,
         "sale":0,
         "description":"woodenblock_desc",
         "costs":[{
            "r1":1000,
            "r2":0,
            "r3":0,
            "r4":0,
            "time":new SecNum(5),
            "re":[[112,1,1]]
         },{
            "r1":0,
            "r2":10000,
            "r3":0,
            "r4":0,
            "time":new SecNum(5),
            "re":[[112,1,1]]
         },{
            "r1":100000,
            "r2":100000,
            "r3":0,
            "r4":0,
            "time":new SecNum(5),
            "re":[[112,1,1]]
         },{
            "r1":200000,
            "r2":200000,
            "r3":0,
            "r4":0,
            "time":new SecNum(5),
            "re":[[112,1,1]]
         },{
            "r1":400000,
            "r2":400000,
            "r3":0,
            "r4":0,
            "time":new SecNum(5),
            "re":[[112,1,1]]
         }],
         "imageData":{
            "baseurl":"buildings/walls/",
            1:{
               "top":["top.1.png",new Point(-21,-21)],
               "shadow":["shadow.jpg",new Point(-28,-7)],
               "topdamaged":["top.1.damaged.png",new Point(-21,-21)],
               "shadowdamaged":["shadow.jpg",new Point(-28,-7)],
               "topdestroyed":["top.1.destroyed.png",new Point(-21,-5)],
               "shadowdestroyed":["shadow.jpg",new Point(-28,-7)]
            },
            2:{
               "top":["top.2.png",new Point(-20,-20)],
               "shadow":["shadow.jpg",new Point(-28,-7)],
               "topdamaged":["top.2.damaged.png",new Point(-21,-20)],
               "shadowdamaged":["shadow.jpg",new Point(-28,-7)],
               "topdestroyed":["top.2.destroyed.png",new Point(-19,0)],
               "shadowdestroyed":["shadow.jpg",new Point(-28,-7)]
            },
            3:{
               "top":["top.3.png",new Point(-21,-21)],
               "shadow":["shadow.jpg",new Point(-28,-7)],
               "topdamaged":["top.3.damaged.png",new Point(-22,-21)],
               "shadowdamaged":["shadow.jpg",new Point(-28,-7)],
               "topdestroyed":["top.3.destroyed.png",new Point(-21,-3)],
               "shadowdestroyed":["shadow.jpg",new Point(-28,-7)]
            },
            4:{
               "top":["top.4.v2.png",new Point(-20,-22)],
               "shadow":["shadow.jpg",new Point(-28,-7)],
               "topdamaged":["top.4.damaged.v2.png",new Point(-20,-22)],
               "shadowdamaged":["shadow.jpg",new Point(-28,-7)],
               "topdestroyed":["top.4.destroyed.png",new Point(-20,-2)],
               "shadowdestroyed":["shadow.jpg",new Point(-28,-7)]
            },
            5:{
               "top":["top.5.png",new Point(-20,-22)],
               "shadow":["shadow.jpg",new Point(-28,-7)],
               "topdamaged":["top.5.damaged.png",new Point(-20,-19)],
               "shadowdamaged":["shadow.jpg",new Point(-28,-7)],
               "topdestroyed":["top.5.destroyed.png",new Point(-20,-3)],
               "shadowdestroyed":["shadow.jpg",new Point(-28,-7)]
            }
         },
         "upgradeImgData":{
            "baseurl":"buildingbuttons/",
            1:{
               "img":"17.1.jpg",
               "silhouette_img":"17.1.silhouette.jpg"
            },
            2:{"img":"17.2.v2.jpg"},
            3:{
               "img":"17.3.v2.jpg",
               "silhouette_img":"17.3.v2.silhouette.jpg"
            },
            4:{
               "img":"17.4.jpg",
               "silhouette_img":"17.4.silhouette.jpg"
            },
            5:{"img":"17.5.jpg"}
         },
         "thumbImgData":{
            "baseurl":"buildingthumbs/",
            1:{"img":"17.1.png"},
            2:{"img":"17.2.png"},
            3:{"img":"17.3.png"},
            4:{"img":"17.4.png"},
            5:{"img":"17.5.png"}
         },
         "quantity":[0,100],
         "hp":[1000,2300,5750,18000,27000],
         "repairTime":[5,5,5,5,5]
      },{
         "id":18,
         "group":3,
         "order":7,
         "buildStatus":0,
         "type":"wall",
         "name":"#b_stoneblock#",
         "size":50,
         "attackgroup":1,
         "tutstage":200,
         "sale":0,
         "description":"stoneblock_desc",
         "block":true,
         "quantity":[0,0]
      },{
         "id":19,
         "group":2,
         "order":12,
         "buildStatus":0,
         "type":"special",
         "name":"#b_wildmonsterbaiter#",
         "size":120,
         "attackgroup":2,
         "tutstage":200,
         "sale":0,
         "description":"wildmonsterbaiter_desc",
         "block":true,
         "quantity":[0,0]
      },{
         "id":20,
         "group":3,
         "order":2,
         "buildStatus":0,
         "type":"tower",
         "name":"#b_cannontower#",
         "size":64,
         "attackgroup":1,
         "tutstage":200,
         "sale":0,
         "description":"cannontower_desc",
         "stats":[{
            "range":160,
            "damage":20,
            "rate":40,
            "speed":5,
            "splash":30
         },{
            "range":170,
            "damage":40,
            "rate":40,
            "speed":6,
            "splash":35
         },{
            "range":180,
            "damage":60,
            "rate":40,
            "speed":7,
            "splash":40
         },{
            "range":190,
            "damage":80,
            "rate":40,
            "speed":8,
            "splash":45
         },{
            "range":200,
            "damage":100,
            "rate":40,
            "speed":8,
            "splash":50
         },{
            "range":210,
            "damage":120,
            "rate":40,
            "speed":8,
            "splash":55
         },{
            "range":220,
            "damage":140,
            "rate":40,
            "speed":8,
            "splash":60
         },{
            "range":230,
            "damage":160,
            "rate":40,
            "speed":8,
            "splash":65
         },{
            "range":240,
            "damage":180,
            "rate":40,
            "speed":8,
            "splash":70
         },{
            "range":250,
            "damage":200,
            "rate":40,
            "speed":8,
            "splash":75
         }],
         "costs":[{
            "r1":2000,
            "r2":1500,
            "r3":500,
            "r4":0,
            "time":new SecNum(30),
            "re":[[112,1,1]]
         },{
            "r1":10000,
            "r2":7500,
            "r3":2500,
            "r4":0,
            "time":new SecNum(900),
            "re":[[112,1,1]]
         },{
            "r1":50000,
            "r2":37500,
            "r3":12500,
            "r4":0,
            "time":new SecNum(2700),
            "re":[[112,1,1]]
         },{
            "r1":250000,
            "r2":187500,
            "r3":62500,
            "r4":0,
            "time":new SecNum(8100),
            "re":[[112,1,1]]
         },{
            "r1":1250000,
            "r2":937500,
            "r3":312500,
            "r4":0,
            "time":new SecNum(24300),
            "re":[[112,1,1]]
         },{
            "r1":6250000,
            "r2":4687500,
            "r3":1562500,
            "r4":0,
            "time":new SecNum(72900),
            "re":[[112,1,1]]
         },{
            "r1":9375000,
            "r2":7000000,
            "r3":1562500,
            "r4":0,
            "time":new SecNum(172800),
            "re":[[112,1,1]]
         },{
            "r1":14000000,
            "r2":10500000,
            "r3":1562500,
            "r4":0,
            "time":new SecNum(259200),
            "re":[[112,1,1]]
         },{
            "r1":21000000,
            "r2":15800000,
            "r3":1562500,
            "r4":0,
            "time":new SecNum(345600),
            "re":[[112,1,1]]
         },{
            "r1":31600000,
            "r2":23700000,
            "r3":1562500,
            "r4":0,
            "time":new SecNum(475200),
            "re":[[112,1,1]]
         }],
         "can_fortify":true,
         "fortify_costs":[{
            "r1":50000,
            "r2":37500,
            "r3":12500,
            "r4":0,
            "time":new SecNum(8100),
            "re":[[112,1,1]]
         },{
            "r1":250000,
            "r2":187500,
            "r3":62500,
            "r4":0,
            "time":new SecNum(24300),
            "re":[[112,1,1]]
         },{
            "r1":1250000,
            "r2":937500,
            "r3":312500,
            "r4":0,
            "time":new SecNum(72900),
            "re":[[112,1,1]]
         },{
            "r1":6250000,
            "r2":4687500,
            "r3":1562500,
            "r4":0,
            "time":new SecNum(172800),
            "re":[[112,1,1]]
         }],
         "imageData":{
            "baseurl":"buildings/cannontower/",
            1:{
               "top":["top.3.png",new Point(-33,-25)],
               "shadow":["shadow.3.jpg",new Point(-38,20)],
               "topdamaged":["top.3.damaged.png",new Point(-48,-25)],
               "shadowdamaged":["shadow.3.jpg",new Point(-47,20)],
               "topdestroyed":["top.3.destroyed.png",new Point(-46,8)],
               "shadowdestroyed":["shadow.3.jpg",new Point(-43,22)],
               "topdestroyedfire":["top.3.destroyed.fire.png",new Point(-46,8)]
            }
         },
         "upgradeImgData":{
            "baseurl":"buildingbuttons/",
            1:{
               "img":"20.jpg",
               "silhouette_img":"20.silhouette.jpg"
            }
         },
         "thumbImgData":{
            "baseurl":"buildingthumbs/",
            1:{"img":"20.png"}
         },
         "fortImgData":{
            "baseurl":"buildings/fortifications/",
            1:{
               "front":["fort70_F1.png",new Point(-73,21)],
               "back":["fort70_B1.png",new Point(-70,-10)]
            },
            2:{
               "front":["fort70_F2.png",new Point(-69,22)],
               "back":["fort70_B2.png",new Point(-65,-12)]
            },
            3:{
               "front":["fort70_F3.png",new Point(-72,10)],
               "back":["fort70_B3.png",new Point(-68,-12)]
            },
            4:{
               "front":["fort70_F4.png",new Point(-70,-11)],
               "back":["fort70_B4.png",new Point(-61,-36)]
            }
         },
         "quantity":[0,4],
         "hp":[6000,9000,12600,17640,26460,34400,45000,58000,75500,98200],
         "repairTime":[360,720,1440,2880,5760,11520,23000,46000,64800,86400]
      },{
         "id":21,
         "group":3,
         "order":1,
         "buildStatus":0,
         "type":"tower",
         "name":"#b_snipertower#",
         "size":64,
         "attackgroup":3,
         "tutstage":28,
         "sale":0,
         "description":"snipertower_desc",
         "stats":[{
            "range":300,
            "damage":100,
            "rate":80,
            "speed":10,
            "splash":0
         },{
            "range":308,
            "damage":210,
            "rate":80,
            "speed":10,
            "splash":0
         },{
            "range":316,
            "damage":320,
            "rate":80,
            "speed":10,
            "splash":0
         },{
            "range":324,
            "damage":430,
            "rate":80,
            "speed":12,
            "splash":0
         },{
            "range":332,
            "damage":540,
            "rate":80,
            "speed":15,
            "splash":0
         },{
            "range":340,
            "damage":650,
            "rate":80,
            "speed":17,
            "splash":0
         },{
            "range":348,
            "damage":760,
            "rate":80,
            "speed":18,
            "splash":0
         },{
            "range":356,
            "damage":870,
            "rate":80,
            "speed":19,
            "splash":0
         },{
            "range":364,
            "damage":980,
            "rate":80,
            "speed":20,
            "splash":0
         },{
            "range":372,
            "damage":1100,
            "rate":80,
            "speed":20,
            "splash":0
         }],
         "costs":[{
            "r1":1500,
            "r2":2000,
            "r3":500,
            "r4":0,
            "time":new SecNum(30),
            "re":[[112,1,1]]
         },{
            "r1":7500,
            "r2":10000,
            "r3":2500,
            "r4":0,
            "time":new SecNum(900),
            "re":[[112,1,1]]
         },{
            "r1":37500,
            "r2":50000,
            "r3":12500,
            "r4":0,
            "time":new SecNum(2700),
            "re":[[112,1,1]]
         },{
            "r1":187500,
            "r2":250000,
            "r3":62500,
            "r4":0,
            "time":new SecNum(18000),
            "re":[[112,1,1]]
         },{
            "r1":937500,
            "r2":1250000,
            "r3":312500,
            "r4":0,
            "time":new SecNum(43200),
            "re":[[112,1,1]]
         },{
            "r1":4687500,
            "r2":6250000,
            "r3":1562500,
            "r4":0,
            "time":new SecNum(86400),
            "re":[[112,1,1]]
         },{
            "r1":7031250,
            "r2":9375000,
            "r3":2343750,
            "r4":0,
            "time":new SecNum(172800),
            "re":[[112,1,1]]
         },{
            "r1":10547000,
            "r2":14062000,
            "r3":3515000,
            "r4":0,
            "time":new SecNum(259200),
            "re":[[112,1,1]]
         },{
            "r1":15820000,
            "r2":21095000,
            "r3":5275000,
            "r4":0,
            "time":new SecNum(345600),
            "re":[[112,1,1]]
         },{
            "r1":32730000,
            "r2":31650000,
            "r3":7900000,
            "r4":0,
            "time":new SecNum(475200),
            "re":[[112,1,1]]
         }],
         "can_fortify":true,
         "fortify_costs":[{
            "r1":37500,
            "r2":50000,
            "r3":12500,
            "r4":0,
            "time":new SecNum(18000),
            "re":[[112,1,1]]
         },{
            "r1":187500,
            "r2":250000,
            "r3":62500,
            "r4":0,
            "time":new SecNum(43200),
            "re":[[112,1,1]]
         },{
            "r1":937500,
            "r2":1250000,
            "r3":312500,
            "r4":0,
            "time":new SecNum(86400),
            "re":[[112,1,1]]
         },{
            "r1":4687500,
            "r2":6250000,
            "r3":1562500,
            "r4":0,
            "time":new SecNum(172800),
            "re":[[112,1,1]]
         }],
         "imageData":{
            "baseurl":"buildings/snipertower/",
            1:{
               "anim":["anim.3.png",new Rectangle(-27,-50,55,47),30],
               "top":["top.3.png",new Point(-40,-30)],
               "shadow":["shadow.3.jpg",new Point(-43,12)],
               "animdamaged":["anim.3.damaged.png",new Rectangle(-28,-49,55,46),30],
               "topdamaged":["top.3.damaged.png",new Point(-39,-25)],
               "shadowdamaged":["shadow.3.jpg",new Point(-39,15)],
               "topdestroyed":["top.3.destroyed.png",new Point(-45,-13)],
               "shadowdestroyed":["shadow.3.jpg",new Point(-45,-4)],
               "topdestroyedfire":["top.3.destroyed.fire.png",new Point(-45,-13)]
            }
         },
         "upgradeImgData":{
            "baseurl":"buildingbuttons/",
            1:{
               "img":"21.jpg",
               "silhouette_img":"21.silhouette.jpg"
            }
         },
         "thumbImgData":{
            "baseurl":"buildingthumbs/",
            1:{"img":"21.png"}
         },
         "fortImgData":{
            "baseurl":"buildings/fortifications/",
            1:{
               "front":["fort70_F1.png",new Point(-73,21)],
               "back":["fort70_B1.png",new Point(-70,-10)]
            },
            2:{
               "front":["fort70_F2.png",new Point(-69,22)],
               "back":["fort70_B2.png",new Point(-65,-12)]
            },
            3:{
               "front":["fort70_F3.png",new Point(-72,10)],
               "back":["fort70_B3.png",new Point(-68,-12)]
            },
            4:{
               "front":["fort70_F4.png",new Point(-70,-11)],
               "back":["fort70_B4.png",new Point(-61,-36)]
            }
         },
         "quantity":[0,4],
         "hp":[6000,9000,12600,17640,26460,34400,45000,58000,75500,98200],
         "repairTime":[360,720,1440,2880,5760,11520,23000,46000,64800,86400]
      },{
         "id":22,
         "isNew":true,
         "group":3,
         "order":5,
         "buildStatus":0,
         "type":"tower",
         "name":"#b_monsterbunker#",
         "size":120,
         "attackgroup":2,
         "tutstage":200,
         "sale":0,
         "description":"monsterbunker_desc",
         "stats":[{"range":300},{"range":350},{"range":400},{"range":450}],
         "costs":[{
            "r1":250000,
            "r2":187500,
            "r3":62500,
            "r4":0,
            "time":new SecNum(21600),
            "re":[[112,1,1],[15,1,1]]
         },{
            "r1":1000000,
            "r2":1000000,
            "r3":500000,
            "r4":0,
            "time":new SecNum(43200),
            "re":[[112,1,1],[15,1,1]]
         },{
            "r1":2000000,
            "r2":2000000,
            "r3":1000000,
            "r4":0,
            "time":new SecNum(86400),
            "re":[[112,1,1],[15,1,1]]
         },{
            "r1":3000000,
            "r2":3000000,
            "r3":1500000,
            "r4":0,
            "time":new SecNum(86400),
            "re":[[112,1,1],[15,1,1]]
         }],
         "imageData":{
            "baseurl":"buildings/bunker/",
            1:{
               "anim":["anim.1.png",new Rectangle(-46,-15,90,83),15],
               "shadow":["shadow.1.jpg",new Point(-66,10)],
               "topdamaged":["top.1.damaged.png",new Point(-45,-8)],
               "shadowdamaged":["shadow.1.damaged.jpg",new Point(-66,5)],
               "topdestroyed":["top.1.destroyed.png",new Point(-50,4)],
               "shadowdamaged":["shadow.1.destroyed.jpg",new Point(-61,14)]
            }
         },
         "upgradeImgData":{
            "baseurl":"buildingbuttons/",
            1:{
               "img":"22.jpg",
               "silhouette_img":"22.silhouette.jpg"
            }
         },
         "thumbImgData":{
            "baseurl":"buildingthumbs/",
            1:{"img":"22.png"}
         },
         "quantity":[0,2],
         "capacity":[380,450,540,660],
         "hp":[10000,24500,52000,130000],
         "repairTime":[120,240,480,960]
      },{
         "id":23,
         "group":3,
         "order":4,
         "buildStatus":0,
         "type":"tower",
         "name":"#b_lasertower#",
         "tutstage":200,
         "sale":0,
         "description":"lasertower_desc",
         "stats":[{
            "range":160,
            "damage":120,
            "rate":80,
            "speed":0,
            "splash":40
         },{
            "range":162,
            "damage":150,
            "rate":80,
            "speed":0,
            "splash":40
         },{
            "range":164,
            "damage":180,
            "rate":80,
            "speed":0,
            "splash":40
         },{
            "range":168,
            "damage":200,
            "rate":80,
            "speed":0,
            "splash":40
         },{
            "range":170,
            "damage":220,
            "rate":80,
            "speed":0,
            "splash":40
         },{
            "range":172,
            "damage":240,
            "rate":80,
            "speed":0,
            "splash":40
         }],
         "costs":[{
            "r1":500000,
            "r2":250000,
            "r3":100000,
            "r4":0,
            "time":new SecNum(18000),
            "re":[[112,1,1]]
         },{
            "r1":1000000,
            "r2":500000,
            "r3":200000,
            "r4":0,
            "time":new SecNum(86400),
            "re":[[112,1,1]]
         },{
            "r1":2000000,
            "r2":1000000,
            "r3":400000,
            "r4":0,
            "time":new SecNum(172800),
            "re":[[112,1,1]]
         },{
            "r1":4000000,
            "r2":2000000,
            "r3":800000,
            "r4":0,
            "time":new SecNum(259200),
            "re":[[112,1,1]]
         },{
            "r1":8000000,
            "r2":4000000,
            "r3":1600000,
            "r4":0,
            "time":new SecNum(388800),
            "re":[[112,1,1]]
         },{
            "r1":16000000,
            "r2":8000000,
            "r3":3200000,
            "r4":0,
            "time":new SecNum(428800),
            "re":[[112,1,1]]
         }],
         "can_fortify":true,
         "fortify_costs":[{
            "r1":500000,
            "r2":250000,
            "r3":100000,
            "r4":0,
            "time":new SecNum(18000),
            "re":[[112,1,1]]
         },{
            "r1":1000000,
            "r2":500000,
            "r3":200000,
            "r4":0,
            "time":new SecNum(86400),
            "re":[[112,1,1]]
         },{
            "r1":2000000,
            "r2":1000000,
            "r3":400000,
            "r4":0,
            "time":new SecNum(172800),
            "re":[[112,1,1]]
         },{
            "r1":4000000,
            "r2":2000000,
            "r3":800000,
            "r4":0,
            "time":new SecNum(259200),
            "re":[[112,1,1]]
         }],
         "imageData":{
            "baseurl":"buildings/lasertower/",
            1:{
               "anim":["anim.1.png",new Rectangle(-13,-50,29,32),54],
               "top":["top.1.png",new Point(-33,-29)],
               "shadow":["shadow.1.jpg",new Point(-36,15)],
               "animdamaged":["anim.1.damaged.png",new Rectangle(-22,-46,52,44),54],
               "topdamaged":["top.1.damaged.png",new Point(-40,-28)],
               "shadowdamaged":["shadow.1.jpg",new Point(-37,-17)],
               "topdestroyed":["top.1.destroyed.png",new Point(-39,-3)],
               "shadowdestroyed":["shadow.1.jpg",new Point(-37,14)],
               "topdestroyedfire":["top.1.destroyed.fire.png",new Point(-39,-3)]
            }
         },
         "upgradeImgData":{
            "baseurl":"buildingbuttons/",
            1:{
               "img":"23.jpg",
               "silhouette_img":"23.silhouette.jpg"
            }
         },
         "thumbImgData":{
            "baseurl":"buildingthumbs/",
            1:{"img":"23.png"}
         },
         "fortImgData":{
            "baseurl":"buildings/fortifications/",
            1:{
               "front":["fort70_F1.png",new Point(-73,21)],
               "back":["fort70_B1.png",new Point(-70,-10)]
            },
            2:{
               "front":["fort70_F2.png",new Point(-69,22)],
               "back":["fort70_B2.png",new Point(-65,-12)]
            },
            3:{
               "front":["fort70_F3.png",new Point(-72,10)],
               "back":["fort70_B3.png",new Point(-68,-12)]
            },
            4:{
               "front":["fort70_F4.png",new Point(-70,-11)],
               "back":["fort70_B4.png",new Point(-61,-36)]
            }
         },
         "quantity":[0,2],
         "hp":[9000,12600,17640,26460,34400,60200],
         "repairTime":[1440,2880,5760,11520,23000,46000]
      },{
         "id":24,
         "group":3,
         "order":6,
         "buildStatus":0,
         "type":"trap",
         "name":"#b_boobytrap#",
         "size":50,
         "attackgroup":4,
         "tutstage":200,
         "sale":0,
         "description":"boobytrap_desc",
         "costs":[{
            "r1":1000,
            "r2":1000,
            "r3":1000,
            "r4":0,
            "time":new SecNum(5),
            "re":[[112,1,1]]
         }],
         "imageData":{
            "baseurl":"buildings/boobytrap/",
            1:{
               "top":["top.1.png",new Point(-15,1)],
               "shadow":["shadow.1.jpg",new Point(-13,3)],
               "topdestroyed":["top.1.destroyed.png",new Point(-15,2)],
               "shadowdestroyed":["shadow.1.jpg",new Point(-13,3)]
            }
         },
         "upgradeImgData":{
            "baseurl":"buildingbuttons/",
            1:{
               "img":"24.jpg",
               "silhouette_img":"24.silhouette.jpg"
            }
         },
         "thumbImgData":{
            "baseurl":"buildingthumbs/",
            1:{"img":"24.png"}
         },
         "quantity":[0,25],
         "damage":[1000],
         "hp":[10],
         "repairTime":[1]
      },{
         "id":25,
         "group":3,
         "order":3,
         "buildStatus":0,
         "type":"tower",
         "name":"#b_teslatower#",
         "tutstage":200,
         "sale":0,
         "description":"teslatower_desc",
         "stats":[{
            "range":250,
            "damage":100,
            "rate":10,
            "speed":10,
            "splash":0
         },{
            "range":270,
            "damage":120,
            "rate":15,
            "speed":10,
            "splash":0
         },{
            "range":300,
            "damage":140,
            "rate":20,
            "speed":10,
            "splash":0
         },{
            "range":320,
            "damage":160,
            "rate":25,
            "speed":10,
            "splash":0
         },{
            "range":340,
            "damage":180,
            "rate":25,
            "speed":10,
            "splash":0
         },{
            "range":360,
            "damage":200,
            "rate":25,
            "speed":10,
            "splash":0
         }],
         "costs":[{
            "r1":187500,
            "r2":250000,
            "r3":62500,
            "r4":0,
            "time":new SecNum(18000),
            "re":[[112,1,1]]
         },{
            "r1":750000,
            "r2":1000000,
            "r3":250000,
            "r4":0,
            "time":new SecNum(86400),
            "re":[[112,1,1]]
         },{
            "r1":2250000,
            "r2":3000000,
            "r3":750000,
            "r4":0,
            "time":new SecNum(172800),
            "re":[[112,1,1]]
         },{
            "r1":5250000,
            "r2":5000000,
            "r3":1250000,
            "r4":0,
            "time":new SecNum(345600),
            "re":[[112,1,1]]
         },{
            "r1":12000000,
            "r2":10000000,
            "r3":2000000,
            "r4":0,
            "time":new SecNum(518400),
            "re":[[112,1,1]]
         },{
            "r1":22000000,
            "r2":15000000,
            "r3":3000000,
            "r4":0,
            "time":new SecNum(718400),
            "re":[[112,1,1]]
         }],
         "can_fortify":true,
         "fortify_costs":[{
            "r1":187500,
            "r2":250000,
            "r3":62500,
            "r4":0,
            "time":new SecNum(18000),
            "re":[[112,1,1]]
         },{
            "r1":750000,
            "r2":1000000,
            "r3":250000,
            "r4":0,
            "time":new SecNum(86400),
            "re":[[112,1,1]]
         },{
            "r1":2250000,
            "r2":3000000,
            "r3":750000,
            "r4":0,
            "time":new SecNum(172800),
            "re":[[112,1,1]]
         },{
            "r1":5250000,
            "r2":5000000,
            "r3":1250000,
            "r4":0,
            "time":new SecNum(345600),
            "re":[[112,1,1]]
         }],
         "imageData":{
            "baseurl":"buildings/lightningtower/",
            1:{
               "anim":["anim.3.png",new Rectangle(-25,-15,27,53),55],
               "top":["top.3.png",new Point(-33,-57)],
               "shadow":["shadow.3.jpg",new Point(-38,18)],
               "animdamaged":["anim.3.damaged.png",new Rectangle(-26,-19,30,57),55],
               "topdamaged":["top.3.damaged.png",new Point(-46,-58)],
               "shadowdamaged":["shadow.3.jpg",new Point(-44,21)],
               "topdestroyed":["top.3.destroyed.png",new Point(-46,6)],
               "shadowdestroyed":["shadow.3.jpg",new Point(-44,17)],
               "topdestroyedfire":["top.3.destroyed.fire.png",new Point(-46,6)]
            }
         },
         "upgradeImgData":{
            "baseurl":"buildingbuttons/",
            1:{
               "img":"25.jpg",
               "silhouette_img":"25.silhouette.jpg"
            }
         },
         "thumbImgData":{
            "baseurl":"buildingthumbs/",
            1:{"img":"25.png"}
         },
         "fortImgData":{
            "baseurl":"buildings/fortifications/",
            1:{
               "front":["fort70_F1.png",new Point(-73,21)],
               "back":["fort70_B1.png",new Point(-70,-10)]
            },
            2:{
               "front":["fort70_F2.png",new Point(-69,22)],
               "back":["fort70_B2.png",new Point(-65,-12)]
            },
            3:{
               "front":["fort70_F3.png",new Point(-72,10)],
               "back":["fort70_B3.png",new Point(-68,-12)]
            },
            4:{
               "front":["fort70_F4.png",new Point(-70,-11)],
               "back":["fort70_B4.png",new Point(-61,-36)]
            }
         },
         "quantity":[0,2],
         "hp":[15000,22000,30000,48000,60000,72000],
         "repairTime":[1920,3840,7680,9260,12000,21000]
      },{
         "id":26,
         "group":2,
         "order":5,
         "buildStatus":0,
         "type":"special",
         "name":"#b_monsteracademy#",
         "tutstage":200,
         "sale":0,
         "description":"monsteracademy_desc",
         "block":true,
         "quantity":[0,0,0,0,1,2,2,2,2]
      },{
         "id":27,
         "group":999,
         "order":0,
         "buildStatus":0,
         "type":"enemy",
         "name":"#b_trojanhorse#",
         "size":100,
         "attackgroup":999,
         "tutstage":200,
         "sale":0,
         "description":"trojanhorse_desc",
         "costs":[{
            "r1":0,
            "r2":0,
            "r3":0,
            "r4":0,
            "time":new SecNum(5),
            "re":[[112,1,1]]
         }],
         "imageData":{
            "baseurl":"buildings/trojanhorse/",
            1:{
               "anim":["anim.1.png",new Rectangle(-92,-23,39,31),2],
               "top":["top.1.png",new Point(-91,-65)],
               "shadow":["shadow.1.jpg",new Point(-72,11)]
            }
         },
         "upgradeImgData":{
            "baseurl":"buildingbuttons/",
            1:{"img":"27.jpg"}
         },
         "quantity":[1],
         "damage":[1],
         "hp":[1],
         "repairTime":[1]
      },{
         "id":28,
         "group":4,
         "subgroup":3,
         "order":5,
         "buildStatus":0,
         "type":"decoration",
         "name":"#b_americanflag#",
         "size":20,
         "attackgroup":999,
         "tutstage":200,
         "sale":0,
         "description":"flag_desc",
         "block":true,
         "costs":[{
            "r1":0,
            "r2":0,
            "r3":0,
            "r4":0,
            "r5":150,
            "time":new SecNum(0),
            "re":[]
         }],
         "imageData":{
            "baseurl":"buildings/decorations/flags/",
            1:{
               "anim":["flag-usa.png",new Rectangle(1,-35,24,30),21],
               "top":["flagpole.png",new Point(-5,-43)],
               "shadow":["shadow.jpg",new Point(-3,5)]
            }
         },
         "quantity":[0],
         "hp":[100],
         "repairTime":[1]
      },{
         "id":29,
         "group":4,
         "subgroup":3,
         "order":6,
         "buildStatus":0,
         "type":"decoration",
         "name":"#b_britishflag#",
         "size":20,
         "attackgroup":999,
         "tutstage":200,
         "sale":0,
         "description":"flag_desc",
         "block":true,
         "costs":[{
            "r1":0,
            "r2":0,
            "r3":0,
            "r4":0,
            "r5":150,
            "time":new SecNum(0),
            "re":[]
         }],
         "imageData":{
            "baseurl":"buildings/decorations/flags/",
            1:{
               "anim":["flag-britain.png",new Rectangle(1,-35,24,30),21],
               "top":["flagpole.png",new Point(-5,-43)],
               "shadow":["shadow.jpg",new Point(-3,5)]
            }
         },
         "quantity":[0],
         "hp":[100],
         "repairTime":[1]
      },{
         "id":30,
         "group":4,
         "subgroup":3,
         "order":7,
         "buildStatus":0,
         "type":"decoration",
         "name":"#b_australianflag#",
         "size":20,
         "attackgroup":999,
         "tutstage":200,
         "sale":0,
         "description":"flag_desc",
         "block":true,
         "costs":[{
            "r1":0,
            "r2":0,
            "r3":0,
            "r4":0,
            "r5":150,
            "time":new SecNum(0),
            "re":[]
         }],
         "imageData":{
            "baseurl":"buildings/decorations/flags/",
            1:{
               "anim":["flag-australia.png",new Rectangle(1,-35,24,30),21],
               "top":["flagpole.png",new Point(-5,-43)],
               "shadow":["shadow.jpg",new Point(-3,5)]
            }
         },
         "quantity":[0],
         "hp":[100],
         "repairTime":[1]
      },{
         "id":31,
         "group":4,
         "subgroup":3,
         "order":8,
         "buildStatus":0,
         "type":"decoration",
         "name":"#b_brazilianflag#",
         "size":20,
         "attackgroup":999,
         "tutstage":200,
         "sale":0,
         "description":"flag_desc",
         "block":true,
         "costs":[{
            "r1":0,
            "r2":0,
            "r3":0,
            "r4":0,
            "r5":150,
            "time":new SecNum(0),
            "re":[]
         }],
         "imageData":{
            "baseurl":"buildings/decorations/flags/",
            1:{
               "anim":["flag-brazil.png",new Rectangle(1,-35,24,30),21],
               "top":["flagpole.png",new Point(-5,-43)],
               "shadow":["shadow.jpg",new Point(-3,5)]
            }
         },
         "quantity":[0],
         "hp":[100],
         "repairTime":[1]
      },{
         "id":32,
         "group":4,
         "subgroup":3,
         "order":25,
         "buildStatus":0,
         "type":"decoration",
         "name":"#b_europeanflag#",
         "size":20,
         "attackgroup":999,
         "tutstage":200,
         "sale":0,
         "description":"flag_desc",
         "block":true,
         "costs":[{
            "r1":0,
            "r2":0,
            "r3":0,
            "r4":0,
            "r5":150,
            "r4":0,
            "time":new SecNum(0),
            "re":[]
         }],
         "imageData":{
            "baseurl":"buildings/decorations/flags/",
            1:{
               "anim":["flag-europe.png",new Rectangle(1,-35,24,30),21],
               "top":["flagpole.png",new Point(-5,-43)],
               "shadow":["shadow.jpg",new Point(-3,5)]
            }
         },
         "quantity":[0],
         "hp":[100],
         "repairTime":[1]
      },{
         "id":33,
         "group":4,
         "subgroup":3,
         "order":9,
         "buildStatus":0,
         "type":"decoration",
         "name":"#b_frenchflag#",
         "size":20,
         "attackgroup":999,
         "tutstage":200,
         "sale":0,
         "description":"flag_desc",
         "block":true,
         "costs":[{
            "r1":0,
            "r2":0,
            "r3":0,
            "r4":0,
            "r5":150,
            "time":new SecNum(0),
            "re":[]
         }],
         "imageData":{
            "baseurl":"buildings/decorations/flags/",
            1:{
               "anim":["flag-france.png",new Rectangle(1,-35,24,30),21],
               "top":["flagpole.png",new Point(-5,-43)],
               "shadow":["shadow.jpg",new Point(-3,5)]
            }
         },
         "quantity":[0],
         "hp":[100],
         "repairTime":[1]
      },{
         "id":34,
         "group":4,
         "subgroup":3,
         "order":10,
         "buildStatus":0,
         "type":"decoration",
         "name":"#b_indonesianflag#",
         "size":20,
         "attackgroup":999,
         "tutstage":200,
         "sale":0,
         "description":"flag_desc",
         "block":true,
         "costs":[{
            "r1":0,
            "r2":0,
            "r3":0,
            "r4":0,
            "r5":150,
            "time":new SecNum(0),
            "re":[]
         }],
         "imageData":{
            "baseurl":"buildings/decorations/flags/",
            1:{
               "anim":["flag-indonesian.png",new Rectangle(1,-35,24,30),21],
               "top":["flagpole.png",new Point(-5,-43)],
               "shadow":["shadow.jpg",new Point(-3,5)]
            }
         },
         "quantity":[0],
         "hp":[100],
         "repairTime":[1]
      },{
         "id":35,
         "group":4,
         "subgroup":3,
         "order":11,
         "buildStatus":0,
         "type":"decoration",
         "name":"#b_italianflag#",
         "size":20,
         "attackgroup":999,
         "tutstage":200,
         "sale":0,
         "description":"flag_desc",
         "block":true,
         "costs":[{
            "r1":0,
            "r2":0,
            "r3":0,
            "r4":0,
            "r5":150,
            "time":new SecNum(0),
            "re":[]
         }],
         "imageData":{
            "baseurl":"buildings/decorations/flags/",
            1:{
               "anim":["flag-italy.png",new Rectangle(1,-35,24,30),21],
               "top":["flagpole.png",new Point(-5,-43)],
               "shadow":["shadow.jpg",new Point(-3,5)]
            }
         },
         "quantity":[0],
         "hp":[100],
         "repairTime":[1]
      },{
         "id":36,
         "group":4,
         "subgroup":3,
         "order":12,
         "buildStatus":0,
         "type":"decoration",
         "name":"#b_malaysianflag#",
         "size":20,
         "attackgroup":999,
         "tutstage":200,
         "sale":0,
         "description":"flag_desc",
         "block":true,
         "costs":[{
            "r1":0,
            "r2":0,
            "r3":0,
            "r4":0,
            "r5":150,
            "time":new SecNum(0),
            "re":[]
         }],
         "imageData":{
            "baseurl":"buildings/decorations/flags/",
            1:{
               "anim":["flag-malaysia.png",new Rectangle(1,-35,24,30),21],
               "top":["flagpole.png",new Point(-5,-43)],
               "shadow":["shadow.jpg",new Point(-3,5)]
            }
         },
         "quantity":[0],
         "hp":[100],
         "repairTime":[1]
      },{
         "id":37,
         "group":4,
         "subgroup":3,
         "order":13,
         "buildStatus":0,
         "type":"decoration",
         "name":"#b_dutchflag#",
         "size":20,
         "attackgroup":999,
         "tutstage":200,
         "sale":0,
         "description":"flag_desc",
         "block":true,
         "costs":[{
            "r1":0,
            "r2":0,
            "r3":0,
            "r4":0,
            "r5":150,
            "time":new SecNum(0),
            "re":[]
         }],
         "imageData":{
            "baseurl":"buildings/decorations/flags/",
            1:{
               "anim":["flag-dutch.png",new Rectangle(1,-35,24,30),21],
               "top":["flagpole.png",new Point(-5,-43)],
               "shadow":["shadow.jpg",new Point(-3,5)]
            }
         },
         "quantity":[0],
         "hp":[100],
         "repairTime":[1]
      },{
         "id":38,
         "group":4,
         "subgroup":3,
         "order":14,
         "buildStatus":0,
         "type":"decoration",
         "name":"#b_newzealandflag#",
         "size":20,
         "attackgroup":999,
         "tutstage":200,
         "sale":0,
         "description":"flag_desc",
         "block":true,
         "costs":[{
            "r1":0,
            "r2":0,
            "r3":0,
            "r4":0,
            "r5":150,
            "time":new SecNum(0),
            "re":[]
         }],
         "imageData":{
            "baseurl":"buildings/decorations/flags/",
            1:{
               "anim":["flag-newzealand.png",new Rectangle(1,-35,24,30),21],
               "top":["flagpole.png",new Point(-5,-43)],
               "shadow":["shadow.jpg",new Point(-3,5)]
            }
         },
         "quantity":[0],
         "hp":[100],
         "repairTime":[1]
      },{
         "id":39,
         "group":4,
         "subgroup":3,
         "order":15,
         "buildStatus":0,
         "type":"decoration",
         "name":"#b_norwegianflag#",
         "size":20,
         "attackgroup":999,
         "tutstage":200,
         "sale":0,
         "description":"flag_desc",
         "block":true,
         "costs":[{
            "r1":0,
            "r2":0,
            "r3":0,
            "r4":0,
            "r5":150,
            "time":new SecNum(0),
            "re":[]
         }],
         "imageData":{
            "baseurl":"buildings/decorations/flags/",
            1:{
               "anim":["flag-norway.png",new Rectangle(1,-35,24,30),21],
               "top":["flagpole.png",new Point(-5,-43)],
               "shadow":["shadow.jpg",new Point(-3,5)]
            }
         },
         "quantity":[0],
         "hp":[100],
         "repairTime":[1]
      },{
         "id":40,
         "group":4,
         "subgroup":3,
         "order":16,
         "buildStatus":0,
         "type":"decoration",
         "name":"#b_polishflag#",
         "size":20,
         "attackgroup":999,
         "tutstage":200,
         "sale":0,
         "description":"flag_desc",
         "block":true,
         "costs":[{
            "r1":0,
            "r2":0,
            "r3":0,
            "r4":0,
            "r5":150,
            "time":new SecNum(0),
            "re":[]
         }],
         "imageData":{
            "baseurl":"buildings/decorations/flags/",
            1:{
               "anim":["flag-poland.png",new Rectangle(1,-35,24,30),21],
               "top":["flagpole.png",new Point(-5,-43)],
               "shadow":["shadow.jpg",new Point(-3,5)]
            }
         },
         "quantity":[0],
         "hp":[100],
         "repairTime":[1]
      },{
         "id":41,
         "group":4,
         "subgroup":3,
         "order":17,
         "buildStatus":0,
         "type":"decoration",
         "name":"#b_swedishflag#",
         "size":20,
         "attackgroup":999,
         "tutstage":200,
         "sale":0,
         "description":"flag_desc",
         "block":true,
         "costs":[{
            "r1":0,
            "r2":0,
            "r3":0,
            "r4":0,
            "r5":150,
            "time":new SecNum(0),
            "re":[]
         }],
         "imageData":{
            "baseurl":"buildings/decorations/flags/",
            1:{
               "anim":["flag-sweden.png",new Rectangle(1,-35,24,30),21],
               "top":["flagpole.png",new Point(-5,-43)],
               "shadow":["shadow.jpg",new Point(-3,5)]
            }
         },
         "quantity":[0],
         "hp":[100],
         "repairTime":[1]
      },{
         "id":42,
         "group":4,
         "subgroup":3,
         "order":18,
         "buildStatus":0,
         "type":"decoration",
         "name":"#b_turkishflag#",
         "size":20,
         "attackgroup":999,
         "tutstage":200,
         "sale":0,
         "description":"flag_desc",
         "block":true,
         "costs":[{
            "r1":0,
            "r2":0,
            "r3":0,
            "r4":0,
            "r5":150,
            "time":new SecNum(0),
            "re":[]
         }],
         "imageData":{
            "baseurl":"buildings/decorations/flags/",
            1:{
               "anim":["flag-turkey.png",new Rectangle(1,-35,24,30),21],
               "top":["flagpole.png",new Point(-5,-43)],
               "shadow":["shadow.jpg",new Point(-3,5)]
            }
         },
         "quantity":[0],
         "hp":[100],
         "repairTime":[1]
      },{
         "id":43,
         "group":4,
         "subgroup":3,
         "order":19,
         "buildStatus":0,
         "type":"decoration",
         "name":"#b_canadianflag#",
         "size":20,
         "attackgroup":999,
         "tutstage":200,
         "sale":0,
         "description":"flag_desc",
         "block":true,
         "costs":[{
            "r1":0,
            "r2":0,
            "r3":0,
            "r4":0,
            "r5":150,
            "time":new SecNum(0),
            "re":[]
         }],
         "imageData":{
            "baseurl":"buildings/decorations/flags/",
            1:{
               "anim":["flag-canadian.png",new Rectangle(1,-35,24,30),21],
               "top":["flagpole.png",new Point(-5,-43)],
               "shadow":["shadow.jpg",new Point(-3,5)]
            }
         },
         "quantity":[0],
         "hp":[100],
         "repairTime":[1]
      },{
         "id":44,
         "group":4,
         "subgroup":3,
         "order":20,
         "buildStatus":0,
         "type":"decoration",
         "name":"#b_danishflag#",
         "size":20,
         "attackgroup":999,
         "tutstage":200,
         "sale":0,
         "description":"flag_desc",
         "block":true,
         "costs":[{
            "r1":0,
            "r2":0,
            "r3":0,
            "r4":0,
            "r5":150,
            "time":new SecNum(0),
            "re":[]
         }],
         "imageData":{
            "baseurl":"buildings/decorations/flags/",
            1:{
               "anim":["flag-denmark.png",new Rectangle(1,-35,24,30),21],
               "top":["flagpole.png",new Point(-5,-43)],
               "shadow":["shadow.jpg",new Point(-3,5)]
            }
         },
         "quantity":[0],
         "hp":[100],
         "repairTime":[1]
      },{
         "id":45,
         "group":4,
         "subgroup":3,
         "order":21,
         "buildStatus":0,
         "type":"decoration",
         "name":"#b_germanflag#",
         "size":20,
         "attackgroup":999,
         "tutstage":200,
         "sale":0,
         "description":"flag_desc",
         "block":true,
         "costs":[{
            "r1":0,
            "r2":0,
            "r3":0,
            "r4":0,
            "r5":150,
            "time":new SecNum(0),
            "re":[]
         }],
         "imageData":{
            "baseurl":"buildings/decorations/flags/",
            1:{
               "anim":["flag-germany.png",new Rectangle(1,-35,24,30),21],
               "top":["flagpole.png",new Point(-5,-43)],
               "shadow":["shadow.jpg",new Point(-3,5)]
            }
         },
         "quantity":[0],
         "hp":[100],
         "repairTime":[1]
      },{
         "id":46,
         "group":4,
         "subgroup":3,
         "order":22,
         "buildStatus":0,
         "type":"decoration",
         "name":"#b_filipinoflag#",
         "size":20,
         "attackgroup":999,
         "tutstage":200,
         "sale":0,
         "description":"flag_desc",
         "block":true,
         "costs":[{
            "r1":0,
            "r2":0,
            "r3":0,
            "r4":0,
            "r5":150,
            "time":new SecNum(0),
            "re":[]
         }],
         "imageData":{
            "baseurl":"buildings/decorations/flags/",
            1:{
               "anim":["flag-philippines.png",new Rectangle(1,-35,24,30),21],
               "top":["flagpole.png",new Point(-5,-43)],
               "shadow":["shadow.jpg",new Point(-3,5)]
            }
         },
         "quantity":[0],
         "hp":[100],
         "repairTime":[1]
      },{
         "id":47,
         "group":4,
         "subgroup":3,
         "order":23,
         "buildStatus":0,
         "type":"decoration",
         "name":"#b_singaporeanflag#",
         "size":20,
         "attackgroup":999,
         "tutstage":200,
         "sale":0,
         "description":"flag_desc",
         "block":true,
         "costs":[{
            "r1":0,
            "r2":0,
            "r3":0,
            "r4":0,
            "r5":150,
            "time":new SecNum(0),
            "re":[]
         }],
         "imageData":{
            "baseurl":"buildings/decorations/flags/",
            1:{
               "anim":["flag-singapore.png",new Rectangle(1,-35,24,30),21],
               "top":["flagpole.png",new Point(-5,-43)],
               "shadow":["shadow.jpg",new Point(-3,5)]
            }
         },
         "quantity":[0],
         "hp":[100],
         "repairTime":[1]
      },{
         "id":48,
         "group":4,
         "subgroup":3,
         "order":24,
         "buildStatus":0,
         "type":"decoration",
         "name":"#b_austrianflag#",
         "size":20,
         "attackgroup":999,
         "tutstage":200,
         "sale":0,
         "description":"flag_desc",
         "block":true,
         "costs":[{
            "r1":0,
            "r2":0,
            "r3":0,
            "r4":0,
            "r5":150,
            "time":new SecNum(0),
            "re":[]
         }],
         "imageData":{
            "baseurl":"buildings/decorations/flags/",
            1:{
               "anim":["flag-austria.png",new Rectangle(1,-35,24,30),21],
               "top":["flagpole.png",new Point(-5,-43)],
               "shadow":["shadow.jpg",new Point(-3,5)]
            }
         },
         "quantity":[0],
         "hp":[100],
         "repairTime":[1]
      },{
         "id":49,
         "group":4,
         "subgroup":3,
         "order":-1,
         "buildStatus":0,
         "type":"decoration",
         "name":"#b_pirateflag#",
         "size":20,
         "attackgroup":999,
         "tutstage":200,
         "sale":1,
         "description":"flag_desc",
         "block":true,
         "costs":[{
            "r1":0,
            "r2":0,
            "r3":0,
            "r4":0,
            "r5":250,
            "r4":0,
            "time":new SecNum(0),
            "re":[]
         }],
         "imageData":{
            "baseurl":"buildings/decorations/flags/",
            1:{
               "anim":["flag-pirate.png",new Rectangle(1,-35,24,30),21],
               "top":["flagpole.png",new Point(-5,-43)],
               "shadow":["shadow.jpg",new Point(-3,5)]
            }
         },
         "quantity":[0],
         "hp":[100],
         "repairTime":[1]
      },{
         "id":50,
         "group":4,
         "subgroup":3,
         "order":0,
         "buildStatus":0,
         "type":"decoration",
         "name":"#b_peaceflag#",
         "size":20,
         "attackgroup":999,
         "tutstage":200,
         "sale":1,
         "description":"flag_desc",
         "block":true,
         "costs":[{
            "r1":0,
            "r2":0,
            "r3":0,
            "r4":0,
            "r5":250,
            "r4":0,
            "time":new SecNum(0),
            "re":[]
         }],
         "imageData":{
            "baseurl":"buildings/decorations/flags/",
            1:{
               "anim":["flag-peace.png",new Rectangle(1,-35,24,30),21],
               "top":["flagpole.png",new Point(-5,-43)],
               "shadow":["shadow.jpg",new Point(-3,5)]
            }
         },
         "quantity":[0],
         "hp":[100],
         "repairTime":[1]
      },{
         "id":51,
         "group":2,
         "order":10,
         "buildStatus":0,
         "type":"special",
         "name":"#b_catapult#",
         "size":190,
         "attackgroup":1,
         "tutstage":200,
         "sale":0,
         "description":"catapult_desc",
         "block":true,
         "costs":[{
            "r1":75000,
            "r2":75000,
            "r3":75000,
            "r4":0,
            "time":new SecNum(10800),
            "re":[[112,1,1],[5,1,1]]
         },{
            "r1":128600,
            "r2":128600,
            "r3":128600,
            "r4":0,
            "time":new SecNum(21600),
            "re":[[112,1,1],[5,1,1]]
         },{
            "r1":257200,
            "r2":257200,
            "r3":257200,
            "r4":0,
            "time":new SecNum(43200),
            "re":[[112,1,1],[5,1,1]]
         },{
            "r1":514400,
            "r2":514400,
            "r3":514400,
            "r4":0,
            "time":new SecNum(86400),
            "re":[[112,1,1],[5,1,1]]
         }],
         "imageData":{
            "baseurl":"buildings/catapult/",
            1:{
               "top":["top.1.png",new Point(-43,12)],
               "shadow":["shadow.1.jpg",new Point(-42,28)],
               "topdamaged":["top.1.damaged.png",new Point(-40,12)],
               "shadowdamaged":["shadow.1.damaged.jpg",new Point(-39,28)],
               "topdestroyed":["top.3.destroyed.png",new Point(-48,9)],
               "shadowdestroyed":["shadow.3.destroyed.jpg",new Point(-47,23)]
            },
            2:{
               "top":["top.2.png",new Point(-44,-21)],
               "shadow":["shadow.2.jpg",new Point(-49,19)],
               "topdamaged":["top.2.damaged.png",new Point(-43,-16)],
               "shadowdamaged":["shadow.2.damaged.jpg",new Point(-41,29)],
               "topdestroyed":["top.3.destroyed.png",new Point(-48,9)],
               "shadowdestroyed":["shadow.3.destroyed.jpg",new Point(-47,23)]
            },
            3:{
               "top":["top.3.png",new Point(-43,-29)],
               "shadow":["shadow.3.jpg",new Point(-39,27)],
               "topdamaged":["top.3.damaged.png",new Point(-51,-29)],
               "shadowdamaged":["shadow.3.damaged.jpg",new Point(-51,30)],
               "topdestroyed":["top.3.destroyed.png",new Point(-48,9)],
               "shadowdestroyed":["shadow.3.destroyed.jpg",new Point(-47,23)]
            }
         },
         "upgradeImgData":{
            "baseurl":"buildingbuttons/",
            1:{
               "img":"51.1.jpg",
               "silhouette_img":"51.3.silhouette.jpg"
            },
            2:{"img":"51.2.jpg"},
            3:{"img":"51.3.jpg"}
         },
         "thumbImgData":{
            "baseurl":"buildingthumbs/",
            1:{"img":"51.1.png"},
            2:{"img":"51.2.png"},
            3:{"img":"51.3.png"}
         },
         "quantity":[0,1],
         "hp":[4000,8000,16000,32000],
         "repairTime":[120,240,480,960]
      },{
         "id":52,
         "group":999,
         "subgroup":5,
         "order":1,
         "buildStatus":0,
         "type":"taunt",
         "name":"Simple Sign",
         "lifespan":172800,
         "size":100,
         "attackgroup":999,
         "tutstage":200,
         "sale":0,
         "description":"Leave a little note for a friend.",
         "block":true,
         "costs":[{
            "r1":100000,
            "r2":100000,
            "r3":100000,
            "r4":100000,
            "r5":0,
            "time":new SecNum(0),
            "re":[]
         }],
         "imageData":{
            "baseurl":"buildings/decorations/flags/",
            1:{
               "anim":["flag-pirate.png",new Rectangle(1,-25,24,30),21],
               "top":["flagpole.png",new Point(-5,-33)],
               "shadow":["shadow.jpg",new Point(-3,15)]
            }
         },
         "quantity":[0],
         "hp":[100],
         "repairTime":[1]
      },{
         "id":53,
         "group":999,
         "order":1,
         "buildStatus":0,
         "type":"immovable",
         "name":"hwn_pumpkin",
         "size":10,
         "attackgroup":0,
         "tutstage":0,
         "sale":0,
         "description":"Temporary pumpkin for picking",
         "block":true,
         "quantity":[0],
         "hp":[10],
         "repairTime":[10],
         "imageData":{
            "baseurl":"buildings/decorations/pumpkins/",
            1:{
               "anim":["anim.png",new Rectangle(-18,-15,37,36),30],
               "shadow":["shadow.jpg",new Point(-22,-1)]
            }
         }
      },{
         "id":54,
         "group":999,
         "order":1,
         "buildStatus":0,
         "type":"immovable",
         "name":"hwn_massivepumpkin",
         "size":10,
         "attackgroup":0,
         "tutstage":0,
         "sale":0,
         "description":"Massive Pumpkin for the \"Event\"",
         "block":true,
         "quantity":[0],
         "hp":[10],
         "repairTime":[10],
         "imageData":{
            "baseurl":"buildings/decorations/pumpkins/",
            1:{
               "top":["large-top-6.png",new Point(-169,-60)],
               "shadow":["large-shadow-6.jpg",new Point(-168,5)],
               "anim":["large-anim-6.png",new Rectangle(-119,-113,189,155),45]
            }
         }
      },{
         "id":55,
         "group":4,
         "subgroup":1,
         "order":1,
         "buildStatus":0,
         "type":"decoration",
         "name":"bdg_acorn",
         "size":30,
         "attackgroup":999,
         "tutstage":200,
         "sale":0,
         "description":"bdg_acorn_desc",
         "block":true,
         "costs":[{
            "r1":0,
            "r2":0,
            "r3":0,
            "r4":0,
            "r5":150,
            "time":new SecNum(0),
            "re":[]
         }],
         "imageData":{
            "baseurl":"buildings/decorations/acorn/",
            1:{
               "top":["top.png",new Point(-10,-9)],
               "shadow":["shadow.jpg",new Point(-9,8)]
            }
         },
         "quantity":[0],
         "hp":[100],
         "repairTime":[1]
      },{
         "id":56,
         "group":4,
         "subgroup":1,
         "order":11,
         "buildStatus":0,
         "type":"decoration",
         "name":"bdg_beehive",
         "size":40,
         "attackgroup":999,
         "tutstage":200,
         "sale":0,
         "description":"bdg_beehive_desc",
         "block":true,
         "costs":[{
            "r1":0,
            "r2":0,
            "r3":0,
            "r4":0,
            "r5":150,
            "time":new SecNum(0),
            "re":[]
         }],
         "imageData":{
            "baseurl":"buildings/decorations/beehive/",
            1:{
               "top":["top.png",new Point(-18,-15)],
               "shadow":["shadow.jpg",new Point(-14,6)]
            }
         },
         "quantity":[0],
         "hp":[100],
         "repairTime":[1]
      },{
         "id":57,
         "group":4,
         "subgroup":2,
         "order":2,
         "buildStatus":0,
         "type":"decoration",
         "name":"bdg_birdhous",
         "size":30,
         "attackgroup":999,
         "tutstage":200,
         "sale":0,
         "description":"bdg_birdhous_desc",
         "block":true,
         "costs":[{
            "r1":0,
            "r2":0,
            "r3":0,
            "r4":0,
            "r5":150,
            "time":new SecNum(0),
            "re":[]
         }],
         "imageData":{
            "baseurl":"buildings/decorations/birdhouse/",
            1:{
               "top":["top.png",new Point(-16,-46)],
               "shadow":["shadow.jpg",new Point(-2,17)]
            }
         },
         "quantity":[0],
         "hp":[100],
         "repairTime":[1]
      },{
         "id":58,
         "group":4,
         "subgroup":2,
         "order":3,
         "buildStatus":0,
         "type":"decoration",
         "name":"bdg_tent",
         "size":40,
         "attackgroup":999,
         "tutstage":200,
         "sale":0,
         "description":"bdg_tent_desc",
         "block":true,
         "costs":[{
            "r1":0,
            "r2":0,
            "r3":0,
            "r4":0,
            "r5":150,
            "time":new SecNum(0),
            "re":[]
         }],
         "imageData":{
            "baseurl":"buildings/decorations/campingtent/",
            1:{
               "top":["top.png",new Point(-30,-12)],
               "shadow":["shadow.jpg",new Point(-29,6)]
            }
         },
         "quantity":[0],
         "hp":[100],
         "repairTime":[1]
      },{
         "id":59,
         "group":4,
         "subgroup":1,
         "order":5,
         "buildStatus":0,
         "type":"decoration",
         "name":"bdg_jax",
         "size":20,
         "attackgroup":999,
         "tutstage":200,
         "sale":0,
         "description":"bdg_jax_desc",
         "block":true,
         "costs":[{
            "r1":0,
            "r2":0,
            "r3":0,
            "r4":0,
            "r5":150,
            "time":new SecNum(0),
            "re":[]
         }],
         "imageData":{
            "baseurl":"buildings/decorations/childrensjax/",
            1:{
               "top":["top.png",new Point(-11,-11)],
               "shadow":["shadow.jpg",new Point(-7,5)]
            }
         },
         "quantity":[0],
         "hp":[100],
         "repairTime":[1]
      },{
         "id":60,
         "group":4,
         "subgroup":2,
         "order":12,
         "buildStatus":0,
         "type":"decoration",
         "name":"bdg_redgnome",
         "size":20,
         "attackgroup":999,
         "tutstage":200,
         "sale":0,
         "description":"bdg_gnome_desc",
         "block":true,
         "costs":[{
            "r1":0,
            "r2":0,
            "r3":0,
            "r4":0,
            "r5":150,
            "time":new SecNum(0),
            "re":[]
         }],
         "imageData":{
            "baseurl":"buildings/decorations/gnomes/",
            1:{
               "top":["top-red.png",new Point(-10,-31)],
               "shadow":["shadow.jpg",new Point(-13,2)]
            }
         },
         "quantity":[0],
         "hp":[100],
         "repairTime":[1]
      },{
         "id":61,
         "group":4,
         "subgroup":2,
         "order":10,
         "buildStatus":0,
         "type":"decoration",
         "name":"bdg_bluegnome",
         "size":20,
         "attackgroup":999,
         "tutstage":200,
         "sale":0,
         "description":"bdg_gnome_desc",
         "block":true,
         "costs":[{
            "r1":0,
            "r2":0,
            "r3":0,
            "r4":0,
            "r5":150,
            "time":new SecNum(0),
            "re":[]
         }],
         "imageData":{
            "baseurl":"buildings/decorations/gnomes/",
            1:{
               "top":["top-blue.png",new Point(-10,-31)],
               "shadow":["shadow.jpg",new Point(-13,2)]
            }
         },
         "quantity":[0],
         "hp":[100],
         "repairTime":[1]
      },{
         "id":62,
         "group":4,
         "subgroup":2,
         "order":11,
         "buildStatus":0,
         "type":"decoration",
         "name":"bdg_greengnome",
         "size":20,
         "attackgroup":999,
         "tutstage":200,
         "sale":0,
         "description":"bdg_gnome_desc",
         "block":true,
         "costs":[{
            "r1":0,
            "r2":0,
            "r3":0,
            "r4":0,
            "r5":150,
            "time":new SecNum(0),
            "re":[]
         }],
         "imageData":{
            "baseurl":"buildings/decorations/gnomes/",
            1:{
               "top":["top-green.png",new Point(-10,-31)],
               "shadow":["shadow.jpg",new Point(-13,2)]
            }
         },
         "quantity":[0],
         "hp":[100],
         "repairTime":[1]
      },{
         "id":63,
         "group":4,
         "subgroup":2,
         "order":5,
         "buildStatus":0,
         "type":"decoration",
         "name":"bdg_hammock",
         "size":40,
         "attackgroup":999,
         "tutstage":200,
         "sale":0,
         "description":"bdg_hammock_desc",
         "block":true,
         "costs":[{
            "r1":0,
            "r2":0,
            "r3":0,
            "r4":0,
            "r5":150,
            "time":new SecNum(0),
            "re":[]
         }],
         "imageData":{
            "baseurl":"buildings/decorations/hammock/",
            1:{
               "top":["top.png",new Point(-25,-8)],
               "shadow":["shadow.jpg",new Point(-26,6)]
            }
         },
         "quantity":[0],
         "hp":[100],
         "repairTime":[1]
      },{
         "id":64,
         "group":4,
         "subgroup":2,
         "order":6,
         "buildStatus":0,
         "type":"decoration",
         "name":"bdg_lawnchair",
         "size":40,
         "attackgroup":999,
         "tutstage":200,
         "sale":0,
         "description":"bdg_lawnchair_desc",
         "block":true,
         "costs":[{
            "r1":0,
            "r2":0,
            "r3":0,
            "r4":0,
            "r5":150,
            "time":new SecNum(0),
            "re":[]
         }],
         "imageData":{
            "baseurl":"buildings/decorations/lawnchair/",
            1:{
               "top":["top.png",new Point(-24,-14)],
               "shadow":["shadow.jpg",new Point(-25,4)]
            }
         },
         "quantity":[0],
         "hp":[100],
         "repairTime":[1]
      },{
         "id":65,
         "group":4,
         "subgroup":2,
         "order":4,
         "buildStatus":0,
         "type":"decoration",
         "name":"bdg_outhouse",
         "size":30,
         "attackgroup":999,
         "tutstage":200,
         "sale":0,
         "description":"bdg_outhouse_desc",
         "block":true,
         "costs":[{
            "r1":0,
            "r2":0,
            "r3":0,
            "r4":0,
            "r5":150,
            "time":new SecNum(0),
            "re":[]
         }],
         "imageData":{
            "baseurl":"buildings/decorations/outhouse/",
            1:{
               "top":["top.png",new Point(-16,-19)],
               "shadow":["shadow.jpg",new Point(-11,10)]
            }
         },
         "quantity":[0],
         "hp":[100],
         "repairTime":[1]
      },{
         "id":66,
         "group":4,
         "subgroup":1,
         "order":2,
         "buildStatus":0,
         "type":"decoration",
         "name":"bdg_pinecone",
         "size":30,
         "attackgroup":999,
         "tutstage":200,
         "sale":0,
         "description":"bdg_pinecone_desc",
         "block":true,
         "costs":[{
            "r1":0,
            "r2":0,
            "r3":0,
            "r4":0,
            "r5":150,
            "time":new SecNum(0),
            "re":[]
         }],
         "imageData":{
            "baseurl":"buildings/decorations/pinecone/",
            1:{
               "top":["top.png",new Point(-13,-10)],
               "shadow":["shadow.jpg",new Point(-23,3)]
            }
         },
         "quantity":[0],
         "hp":[100],
         "repairTime":[1]
      },{
         "id":67,
         "group":4,
         "subgroup":1,
         "order":4,
         "buildStatus":0,
         "type":"decoration",
         "name":"bdg_rock",
         "size":30,
         "attackgroup":999,
         "tutstage":200,
         "sale":0,
         "description":"bdg_rock_desc",
         "block":true,
         "costs":[{
            "r1":0,
            "r2":0,
            "r3":0,
            "r4":0,
            "r5":150,
            "time":new SecNum(0),
            "re":[]
         }],
         "imageData":{
            "baseurl":"buildings/decorations/rock/",
            1:{
               "top":["top.png",new Point(-15,0)],
               "shadow":["shadow.jpg",new Point(-15,9)]
            }
         },
         "quantity":[0],
         "hp":[100],
         "repairTime":[1]
      },{
         "id":68,
         "group":4,
         "subgroup":2,
         "order":15,
         "buildStatus":0,
         "type":"decoration",
         "name":"bdg_scaleelectric",
         "size":100,
         "attackgroup":999,
         "tutstage":200,
         "sale":0,
         "description":"bdg_scaleelectric_desc",
         "block":true,
         "costs":[{
            "r1":0,
            "r2":0,
            "r3":0,
            "r4":0,
            "r5":150,
            "time":new SecNum(0),
            "re":[]
         }],
         "imageData":{
            "baseurl":"buildings/decorations/scaleelectriccartoyset/",
            1:{
               "top":["top.png",new Point(-48,0)],
               "shadow":["shadow.jpg",new Point(-57,8)]
            }
         },
         "quantity":[0],
         "hp":[100],
         "repairTime":[1]
      },{
         "id":69,
         "group":4,
         "subgroup":1,
         "order":12,
         "buildStatus":0,
         "type":"decoration",
         "name":"bdg_scarecrow",
         "size":40,
         "attackgroup":999,
         "tutstage":200,
         "sale":0,
         "description":"flag_desc",
         "block":true,
         "costs":[{
            "r1":0,
            "r2":0,
            "r3":0,
            "r4":0,
            "r5":150,
            "time":new SecNum(0),
            "re":[]
         }],
         "imageData":{
            "baseurl":"buildings/decorations/scarecrow/",
            1:{
               "top":["top.png",new Point(-25,-43)],
               "shadow":["shadow.jpg",new Point(-20,8)]
            }
         },
         "quantity":[0],
         "hp":[100],
         "repairTime":[1]
      },{
         "id":70,
         "group":4,
         "subgroup":2,
         "order":1,
         "buildStatus":0,
         "type":"decoration",
         "name":"bdg_sundial",
         "size":40,
         "attackgroup":999,
         "tutstage":200,
         "sale":0,
         "description":"bdg_sundial_desc",
         "block":true,
         "costs":[{
            "r1":0,
            "r2":0,
            "r3":0,
            "r4":0,
            "r5":150,
            "time":new SecNum(0),
            "re":[]
         }],
         "imageData":{
            "baseurl":"buildings/decorations/sundial/",
            1:{
               "top":["top.png",new Point(-23,-6)],
               "shadow":["shadow.jpg",new Point(-23,8)]
            }
         },
         "quantity":[0],
         "hp":[100],
         "repairTime":[1]
      },{
         "id":71,
         "group":4,
         "subgroup":2,
         "order":7,
         "buildStatus":0,
         "type":"decoration",
         "name":"bdg_tikitorch",
         "size":20,
         "attackgroup":999,
         "tutstage":200,
         "sale":0,
         "description":"bdg_tikitorch_desc",
         "block":true,
         "costs":[{
            "r1":0,
            "r2":0,
            "r3":0,
            "r4":0,
            "r5":150,
            "time":new SecNum(0),
            "re":[]
         }],
         "imageData":{
            "baseurl":"buildings/decorations/tikitorch/",
            1:{
               "anim":["anim.png",new Rectangle(-11,-71,16,36),25],
               "top":["top.png",new Point(-8,-38)],
               "shadow":["shadow.jpg",new Point(-6,3)]
            }
         },
         "quantity":[0],
         "hp":[100],
         "repairTime":[1]
      },{
         "id":72,
         "group":4,
         "subgroup":1,
         "order":3,
         "buildStatus":0,
         "type":"decoration",
         "name":"bdg_walnut",
         "size":30,
         "attackgroup":999,
         "tutstage":200,
         "sale":0,
         "description":"bdg_walnut_desc",
         "block":true,
         "costs":[{
            "r1":0,
            "r2":0,
            "r3":0,
            "r4":0,
            "r5":150,
            "time":new SecNum(0),
            "re":[]
         }],
         "imageData":{
            "baseurl":"buildings/decorations/walnut/",
            1:{
               "top":["top.png",new Point(-12,-2)],
               "shadow":["shadow.jpg",new Point(-23,3)]
            }
         },
         "quantity":[0],
         "hp":[100],
         "repairTime":[1]
      },{
         "id":73,
         "group":4,
         "subgroup":0,
         "order":15,
         "buildStatus":0,
         "type":"decoration",
         "name":"bdg_tombstone",
         "size":40,
         "attackgroup":999,
         "tutstage":200,
         "sale":0,
         "description":"bdg_tombstone_desc",
         "block":true,
         "costs":[{
            "r1":0,
            "r2":0,
            "r3":0,
            "r4":0,
            "r5":150,
            "time":new SecNum(0),
            "re":[]
         }],
         "imageData":{
            "baseurl":"buildings/decorations/graveyardtombstone/",
            1:{
               "top":["top.png",new Point(-22,-13)],
               "shadow":["shadow.jpg",new Point(-20,9)]
            }
         },
         "quantity":[0],
         "hp":[100],
         "repairTime":[1]
      },{
         "id":74,
         "group":4,
         "subgroup":0,
         "order":3,
         "buildStatus":0,
         "type":"decoration",
         "name":"bdg_pokeyhead",
         "size":20,
         "attackgroup":999,
         "tutstage":200,
         "sale":0,
         "description":"bdg_pokeyhead_desc",
         "block":true,
         "costs":[{
            "r1":0,
            "r2":0,
            "r3":0,
            "r4":0,
            "r5":150,
            "time":new SecNum(0),
            "re":[]
         }],
         "imageData":{
            "baseurl":"buildings/decorations/headsonsticks/",
            1:{
               "top":["top-pokey.png",new Point(-6,-28)],
               "shadow":["shadow.jpg",new Point(-1,7)]
            }
         },
         "quantity":[0],
         "hp":[100],
         "repairTime":[1]
      },{
         "id":75,
         "group":4,
         "subgroup":0,
         "order":4,
         "buildStatus":0,
         "type":"decoration",
         "name":"bdg_octohead",
         "size":20,
         "attackgroup":999,
         "tutstage":200,
         "sale":0,
         "description":"bdg_octohead_desc",
         "block":true,
         "costs":[{
            "r1":0,
            "r2":0,
            "r3":0,
            "r4":0,
            "r5":150,
            "time":new SecNum(0),
            "re":[]
         }],
         "imageData":{
            "baseurl":"buildings/decorations/headsonsticks/",
            1:{
               "top":["top-octo.png",new Point(-6,-23)],
               "shadow":["shadow.jpg",new Point(-1,7)]
            }
         },
         "quantity":[0],
         "hp":[100],
         "repairTime":[1]
      },{
         "id":76,
         "group":4,
         "subgroup":0,
         "order":5,
         "buildStatus":0,
         "type":"decoration",
         "name":"bdg_bolthead",
         "size":20,
         "attackgroup":999,
         "tutstage":200,
         "sale":0,
         "description":"bdg_bolthead_desc",
         "block":true,
         "costs":[{
            "r1":0,
            "r2":0,
            "r3":0,
            "r4":0,
            "r5":150,
            "time":new SecNum(0),
            "re":[]
         }],
         "imageData":{
            "baseurl":"buildings/decorations/headsonsticks/",
            1:{
               "top":["top-bolt.png",new Point(-10,-23)],
               "shadow":["shadow.jpg",new Point(-1,7)]
            }
         },
         "quantity":[0],
         "hp":[100],
         "repairTime":[1]
      },{
         "id":77,
         "group":4,
         "subgroup":0,
         "order":6,
         "buildStatus":0,
         "type":"decoration",
         "name":"bdg_banditohead",
         "size":20,
         "attackgroup":999,
         "tutstage":200,
         "sale":0,
         "description":"bdg_banditohead_desc",
         "block":true,
         "costs":[{
            "r1":0,
            "r2":0,
            "r3":0,
            "r4":0,
            "r5":150,
            "time":new SecNum(0),
            "re":[]
         }],
         "imageData":{
            "baseurl":"buildings/decorations/headsonsticks/",
            1:{
               "top":["top-bandito.png",new Point(-5,-26)],
               "shadow":["shadow.jpg",new Point(-1,7)]
            }
         },
         "quantity":[0],
         "hp":[100],
         "repairTime":[1]
      },{
         "id":78,
         "group":4,
         "subgroup":0,
         "order":7,
         "buildStatus":0,
         "type":"decoration",
         "name":"bdg_brainhead",
         "size":20,
         "attackgroup":999,
         "tutstage":200,
         "sale":0,
         "description":"bdg_brainhead_desc",
         "block":true,
         "costs":[{
            "r1":0,
            "r2":0,
            "r3":0,
            "r4":0,
            "r5":150,
            "time":new SecNum(0),
            "re":[]
         }],
         "imageData":{
            "baseurl":"buildings/decorations/headsonsticks/",
            1:{
               "top":["top-brain.png",new Point(-9,-28)],
               "shadow":["shadow.jpg",new Point(-1,7)]
            }
         },
         "quantity":[0],
         "hp":[100],
         "repairTime":[1]
      },{
         "id":79,
         "group":4,
         "subgroup":0,
         "order":8,
         "buildStatus":0,
         "type":"decoration",
         "name":"bdg_crabhead",
         "size":20,
         "attackgroup":999,
         "tutstage":200,
         "sale":0,
         "description":"bdg_crabhead_desc",
         "block":true,
         "costs":[{
            "r1":0,
            "r2":0,
            "r3":0,
            "r4":0,
            "r5":150,
            "time":new SecNum(0),
            "re":[]
         }],
         "imageData":{
            "baseurl":"buildings/decorations/headsonsticks/",
            1:{
               "top":["top-crabatron.png",new Point(-10,-29)],
               "shadow":["shadow.jpg",new Point(-1,7)]
            }
         },
         "quantity":[0],
         "hp":[100],
         "repairTime":[1]
      },{
         "id":80,
         "group":4,
         "subgroup":0,
         "order":14,
         "buildStatus":0,
         "type":"decoration",
         "name":"bdg_davehead",
         "size":20,
         "attackgroup":999,
         "tutstage":200,
         "sale":0,
         "description":"bdg_davehead_desc",
         "block":true,
         "costs":[{
            "r1":0,
            "r2":0,
            "r3":0,
            "r4":0,
            "r5":150,
            "time":new SecNum(0),
            "re":[]
         }],
         "imageData":{
            "baseurl":"buildings/decorations/headsonsticks/",
            1:{
               "top":["top-dave.png",new Point(-14,-30)],
               "shadow":["shadow.jpg",new Point(-1,7)]
            }
         },
         "quantity":[0],
         "hp":[100],
         "repairTime":[1]
      },{
         "id":81,
         "group":4,
         "subgroup":0,
         "order":9,
         "buildStatus":0,
         "type":"decoration",
         "name":"bdg_eyerahead",
         "size":20,
         "attackgroup":999,
         "tutstage":200,
         "sale":0,
         "description":"bdg_eyerahead_desc",
         "block":true,
         "costs":[{
            "r1":0,
            "r2":0,
            "r3":0,
            "r4":0,
            "r5":150,
            "time":new SecNum(0),
            "re":[]
         }],
         "imageData":{
            "baseurl":"buildings/decorations/headsonsticks/",
            1:{
               "top":["top-eyera.png",new Point(-4,-23)],
               "shadow":["shadow.jpg",new Point(-1,7)]
            }
         },
         "quantity":[0],
         "hp":[100],
         "repairTime":[1]
      },{
         "id":82,
         "group":4,
         "subgroup":0,
         "order":10,
         "buildStatus":0,
         "type":"decoration",
         "name":"bdg_fanghead",
         "size":20,
         "attackgroup":999,
         "tutstage":200,
         "sale":0,
         "description":"bdg_fanghead_desc",
         "block":true,
         "costs":[{
            "r1":0,
            "r2":0,
            "r3":0,
            "r4":0,
            "r5":150,
            "time":new SecNum(0),
            "re":[]
         }],
         "imageData":{
            "baseurl":"buildings/decorations/headsonsticks/",
            1:{
               "top":["top-fang.png",new Point(-10,-30)],
               "shadow":["shadow.jpg",new Point(-1,7)]
            }
         },
         "quantity":[0],
         "hp":[100],
         "repairTime":[1]
      },{
         "id":83,
         "group":4,
         "subgroup":0,
         "order":11,
         "buildStatus":0,
         "type":"decoration",
         "name":"bdg_finkhead",
         "size":20,
         "attackgroup":999,
         "tutstage":200,
         "sale":0,
         "description":"bdg_finkhead_desc",
         "block":true,
         "costs":[{
            "r1":0,
            "r2":0,
            "r3":0,
            "r4":0,
            "r5":150,
            "time":new SecNum(0),
            "re":[]
         }],
         "imageData":{
            "baseurl":"buildings/decorations/headsonsticks/",
            1:{
               "top":["top-fink.png",new Point(-11,-29)],
               "shadow":["shadow.jpg",new Point(-1,7)]
            }
         },
         "quantity":[0],
         "hp":[100],
         "repairTime":[1]
      },{
         "id":84,
         "group":4,
         "subgroup":0,
         "order":12,
         "buildStatus":0,
         "type":"decoration",
         "name":"bdg_ichihead",
         "size":20,
         "attackgroup":999,
         "tutstage":200,
         "sale":0,
         "description":"bdg_ichihead_desc",
         "block":true,
         "costs":[{
            "r1":0,
            "r2":0,
            "r3":0,
            "r4":0,
            "r5":150,
            "time":new SecNum(0),
            "re":[]
         }],
         "imageData":{
            "baseurl":"buildings/decorations/headsonsticks/",
            1:{
               "top":["top-ichi.png",new Point(-6,-29)],
               "shadow":["shadow.jpg",new Point(-1,7)]
            }
         },
         "quantity":[0],
         "hp":[100],
         "repairTime":[1]
      },{
         "id":85,
         "group":4,
         "subgroup":0,
         "order":13,
         "buildStatus":0,
         "type":"decoration",
         "name":"bdg_projectxhead",
         "size":20,
         "attackgroup":999,
         "tutstage":200,
         "sale":0,
         "description":"bdg_projectxhead_desc",
         "block":true,
         "costs":[{
            "r1":0,
            "r2":0,
            "r3":0,
            "r4":0,
            "r5":150,
            "time":new SecNum(0),
            "re":[]
         }],
         "imageData":{
            "baseurl":"buildings/decorations/headsonsticks/",
            1:{
               "top":["top-projectx.png",new Point(-19,-24)],
               "shadow":["shadow.jpg",new Point(-1,7)]
            }
         },
         "quantity":[0],
         "hp":[100],
         "repairTime":[1]
      },{
         "id":86,
         "group":4,
         "subgroup":1,
         "order":13,
         "buildStatus":0,
         "type":"decoration",
         "name":"bdg_blackberrybush",
         "size":40,
         "attackgroup":999,
         "tutstage":200,
         "sale":0,
         "description":"bdg_blackberrybush_desc",
         "block":true,
         "costs":[{
            "r1":0,
            "r2":0,
            "r3":0,
            "r4":0,
            "r5":150,
            "time":new SecNum(0),
            "re":[]
         }],
         "imageData":{
            "baseurl":"buildings/decorations/blackberrybush/",
            1:{"top":["top.png",new Point(-25,-13)]}
         },
         "quantity":[0],
         "hp":[100],
         "repairTime":[1]
      },{
         "id":87,
         "group":4,
         "subgroup":1,
         "order":16,
         "buildStatus":0,
         "type":"decoration",
         "name":"bdg_bonsaitree",
         "size":40,
         "attackgroup":999,
         "tutstage":200,
         "sale":0,
         "description":"bdg_bonsaitree_desc",
         "block":true,
         "costs":[{
            "r1":0,
            "r2":0,
            "r3":0,
            "r4":0,
            "r5":150,
            "time":new SecNum(0),
            "re":[]
         }],
         "imageData":{
            "baseurl":"buildings/decorations/bonsaitree/",
            1:{
               "top":["top.png",new Point(-41,-36)],
               "shadow":["shadow.jpg",new Point(-22,15)]
            }
         },
         "quantity":[0],
         "hp":[100],
         "repairTime":[1]
      },{
         "id":88,
         "group":4,
         "subgroup":1,
         "order":14,
         "buildStatus":0,
         "type":"decoration",
         "name":"bdg_cactus",
         "size":20,
         "attackgroup":999,
         "tutstage":200,
         "sale":0,
         "description":"bdg_cactus_desc",
         "block":true,
         "costs":[{
            "r1":0,
            "r2":0,
            "r3":0,
            "r4":0,
            "r5":150,
            "time":new SecNum(0),
            "re":[]
         }],
         "imageData":{
            "baseurl":"buildings/decorations/cactus/",
            1:{
               "top":["top.png",new Point(-14,-30)],
               "shadow":["shadow.jpg",new Point(-12,2)]
            }
         },
         "quantity":[0],
         "hp":[100],
         "repairTime":[1]
      },{
         "id":89,
         "group":4,
         "subgroup":1,
         "order":15,
         "buildStatus":0,
         "type":"decoration",
         "name":"bdg_flytrap",
         "size":70,
         "attackgroup":999,
         "tutstage":200,
         "sale":0,
         "description":"bdg_flytrap_desc",
         "block":true,
         "costs":[{
            "r1":0,
            "r2":0,
            "r3":0,
            "r4":0,
            "r5":150,
            "time":new SecNum(0),
            "re":[]
         }],
         "imageData":{
            "baseurl":"buildings/decorations/flytrap/",
            1:{
               "top":["top.png",new Point(-33,-5)],
               "shadow":["shadow.jpg",new Point(-38,20)]
            }
         },
         "quantity":[0],
         "hp":[100],
         "repairTime":[1]
      },{
         "id":90,
         "group":4,
         "subgroup":1,
         "order":12,
         "buildStatus":0,
         "type":"decoration",
         "name":"bdg_thorns",
         "size":40,
         "attackgroup":999,
         "tutstage":200,
         "sale":0,
         "description":"bdg_thorns_desc",
         "block":true,
         "costs":[{
            "r1":0,
            "r2":0,
            "r3":0,
            "r4":0,
            "r5":150,
            "time":new SecNum(0),
            "re":[]
         }],
         "imageData":{
            "baseurl":"buildings/decorations/thorns/",
            1:{
               "top":["top.png",new Point(-23,-18)],
               "shadow":["shadow.jpg",new Point(-25,7)]
            }
         },
         "quantity":[0],
         "hp":[100],
         "repairTime":[1]
      },{
         "id":91,
         "group":4,
         "subgroup":1,
         "order":5,
         "buildStatus":0,
         "type":"decoration",
         "name":"bdg_pinkflowers",
         "size":20,
         "attackgroup":999,
         "tutstage":200,
         "sale":0,
         "description":"bdg_pinkflowers_desc",
         "block":true,
         "costs":[{
            "r1":0,
            "r2":0,
            "r3":0,
            "r4":0,
            "r5":150,
            "time":new SecNum(0),
            "re":[]
         }],
         "imageData":{
            "baseurl":"buildings/decorations/flowers/",
            1:{
               "top":["top-pink.png",new Point(-18,-21)],
               "shadow":["shadow.jpg",new Point(-10,2)]
            }
         },
         "quantity":[0],
         "hp":[100],
         "repairTime":[1]
      },{
         "id":92,
         "group":4,
         "subgroup":1,
         "order":6,
         "buildStatus":0,
         "type":"decoration",
         "name":"bdg_purpleflowers",
         "size":20,
         "attackgroup":999,
         "tutstage":200,
         "sale":0,
         "description":"bdg_purpleflowers_desc",
         "block":true,
         "costs":[{
            "r1":0,
            "r2":0,
            "r3":0,
            "r4":0,
            "r5":150,
            "time":new SecNum(0),
            "re":[]
         }],
         "imageData":{
            "baseurl":"buildings/decorations/flowers/",
            1:{
               "top":["top-purple.png",new Point(-18,-21)],
               "shadow":["shadow.jpg",new Point(-10,2)]
            }
         },
         "quantity":[0],
         "hp":[100],
         "repairTime":[1]
      },{
         "id":93,
         "group":4,
         "subgroup":1,
         "order":9,
         "buildStatus":0,
         "type":"decoration",
         "name":"bdg_redflowers",
         "size":20,
         "attackgroup":999,
         "tutstage":200,
         "sale":0,
         "description":"bdg_redflowers_desc",
         "block":true,
         "costs":[{
            "r1":0,
            "r2":0,
            "r3":0,
            "r4":0,
            "r5":150,
            "time":new SecNum(0),
            "re":[]
         }],
         "imageData":{
            "baseurl":"buildings/decorations/flowers/",
            1:{
               "top":["top-red.png",new Point(-18,-21)],
               "shadow":["shadow.jpg",new Point(-10,2)]
            }
         },
         "quantity":[0],
         "hp":[100],
         "repairTime":[1]
      },{
         "id":94,
         "group":4,
         "subgroup":1,
         "order":7,
         "buildStatus":0,
         "type":"decoration",
         "name":"bdg_whiteflowers",
         "size":20,
         "attackgroup":999,
         "tutstage":200,
         "sale":0,
         "description":"bdg_whiteflowers_desc",
         "block":true,
         "costs":[{
            "r1":0,
            "r2":0,
            "r3":0,
            "r4":0,
            "r5":150,
            "time":new SecNum(0),
            "re":[]
         }],
         "imageData":{
            "baseurl":"buildings/decorations/flowers/",
            1:{
               "top":["top-white.png",new Point(-18,-21)],
               "shadow":["shadow.jpg",new Point(-10,2)]
            }
         },
         "quantity":[0],
         "hp":[100],
         "repairTime":[1]
      },{
         "id":95,
         "group":4,
         "subgroup":1,
         "order":8,
         "buildStatus":0,
         "type":"decoration",
         "name":"bdg_yellowflowers",
         "size":20,
         "attackgroup":999,
         "tutstage":200,
         "sale":0,
         "description":"bdg_yellowflowers_desc",
         "block":true,
         "costs":[{
            "r1":0,
            "r2":0,
            "r3":0,
            "r4":0,
            "r5":150,
            "time":new SecNum(0),
            "re":[]
         }],
         "imageData":{
            "baseurl":"buildings/decorations/flowers/",
            1:{
               "top":["top-yellow.png",new Point(-18,-21)],
               "shadow":["shadow.jpg",new Point(-10,2)]
            }
         },
         "quantity":[0],
         "hp":[100],
         "repairTime":[1]
      },{
         "id":96,
         "group":4,
         "subgroup":4,
         "order":5,
         "buildStatus":0,
         "type":"decoration",
         "name":"bdg_baseballstatue",
         "size":40,
         "attackgroup":999,
         "tutstage":200,
         "sale":0,
         "description":"bdg_baseballstatue_desc",
         "block":true,
         "costs":[{
            "r1":0,
            "r2":0,
            "r3":0,
            "r4":0,
            "r5":150,
            "time":new SecNum(0),
            "re":[]
         }],
         "imageData":{
            "baseurl":"buildings/decorations/statue-baseball/",
            1:{
               "top":["top.png",new Point(-20,-36)],
               "shadow":["shadow.jpg",new Point(-21,10)]
            }
         },
         "quantity":[0],
         "hp":[100],
         "repairTime":[1]
      },{
         "id":97,
         "group":4,
         "subgroup":4,
         "order":6,
         "buildStatus":0,
         "type":"decoration",
         "name":"bdg_footballstatue",
         "size":40,
         "attackgroup":999,
         "tutstage":200,
         "sale":0,
         "description":"bdg_footballstatue_desc",
         "block":true,
         "costs":[{
            "r1":0,
            "r2":0,
            "r3":0,
            "r4":0,
            "r5":150,
            "time":new SecNum(0),
            "re":[]
         }],
         "imageData":{
            "baseurl":"buildings/decorations/statue-football/",
            1:{
               "top":["top.png",new Point(-19,-39)],
               "shadow":["shadow.jpg",new Point(-17,10)]
            }
         },
         "quantity":[0],
         "hp":[100],
         "repairTime":[1]
      },{
         "id":98,
         "group":4,
         "subgroup":4,
         "order":7,
         "buildStatus":0,
         "type":"decoration",
         "name":"bdg_soccerstatue",
         "size":40,
         "attackgroup":999,
         "tutstage":200,
         "sale":0,
         "description":"bdg_soccerstatue_desc",
         "block":true,
         "costs":[{
            "r1":0,
            "r2":0,
            "r3":0,
            "r4":0,
            "r5":150,
            "time":new SecNum(0),
            "re":[]
         }],
         "imageData":{
            "baseurl":"buildings/decorations/statue-soccer/",
            1:{
               "top":["top.png",new Point(-23,-36)],
               "shadow":["shadow.jpg",new Point(-15,12)]
            }
         },
         "quantity":[0],
         "hp":[100],
         "repairTime":[1]
      },{
         "id":99,
         "group":4,
         "subgroup":4,
         "order":8,
         "buildStatus":0,
         "type":"decoration",
         "name":"bdg_libertystatue",
         "size":70,
         "attackgroup":999,
         "tutstage":200,
         "sale":0,
         "description":"bdg_libertystatue_desc",
         "block":true,
         "costs":[{
            "r1":0,
            "r2":0,
            "r3":0,
            "r4":0,
            "r5":150,
            "time":new SecNum(0),
            "re":[]
         }],
         "imageData":{
            "baseurl":"buildings/decorations/statue-liberty/",
            1:{
               "top":["top.png",new Point(-37,-118)],
               "shadow":["shadow.jpg",new Point(-31,20)]
            }
         },
         "quantity":[0],
         "hp":[100],
         "repairTime":[1]
      },{
         "id":100,
         "group":4,
         "subgroup":4,
         "order":9,
         "buildStatus":0,
         "type":"decoration",
         "name":"bdg_eiffelstatue",
         "size":70,
         "attackgroup":999,
         "tutstage":200,
         "sale":0,
         "description":"bdg_eiffelstatue_desc",
         "block":true,
         "costs":[{
            "r1":0,
            "r2":0,
            "r3":0,
            "r4":0,
            "r5":150,
            "time":new SecNum(0),
            "re":[]
         }],
         "imageData":{
            "baseurl":"buildings/decorations/statue-eiffeltower/",
            1:{
               "top":["top.png",new Point(-60,-121)],
               "shadow":["shadow.jpg",new Point(-60,5)]
            }
         },
         "quantity":[0],
         "hp":[100],
         "repairTime":[1]
      },{
         "id":101,
         "group":4,
         "subgroup":4,
         "order":10,
         "buildStatus":0,
         "type":"decoration",
         "name":"bdg_bigben",
         "size":70,
         "attackgroup":999,
         "tutstage":200,
         "sale":0,
         "description":"bdg_bigben_desc",
         "block":true,
         "costs":[{
            "r1":0,
            "r2":0,
            "r3":0,
            "r4":0,
            "r5":150,
            "time":new SecNum(0),
            "re":[]
         }],
         "imageData":{
            "baseurl":"buildings/decorations/statue-bigben/",
            1:{
               "top":["top.png",new Point(-32,-104)],
               "shadow":["shadow.jpg",new Point(-32,19)]
            }
         },
         "quantity":[0],
         "hp":[100],
         "repairTime":[1]
      },{
         "id":102,
         "group":4,
         "subgroup":2,
         "order":13,
         "buildStatus":0,
         "type":"decoration",
         "name":"bdg_pool",
         "size":100,
         "attackgroup":999,
         "tutstage":200,
         "sale":0,
         "description":"bdg_pool_desc",
         "block":true,
         "costs":[{
            "r1":0,
            "r2":0,
            "r3":0,
            "r4":0,
            "r5":150,
            "time":new SecNum(0),
            "re":[]
         }],
         "imageData":{
            "baseurl":"buildings/decorations/pool/",
            1:{
               "top":["top.png",new Point(-65,8)],
               "shadow":["shadow.jpg",new Point(-65,15)]
            }
         },
         "quantity":[0],
         "hp":[100],
         "repairTime":[1]
      },{
         "id":103,
         "group":4,
         "subgroup":2,
         "order":14,
         "buildStatus":0,
         "type":"decoration",
         "name":"bdg_pond",
         "size":100,
         "attackgroup":999,
         "tutstage":200,
         "sale":0,
         "description":"bdg_pond_desc",
         "block":true,
         "costs":[{
            "r1":0,
            "r2":0,
            "r3":0,
            "r4":0,
            "r5":150,
            "time":new SecNum(0),
            "re":[]
         }],
         "imageData":{
            "baseurl":"buildings/decorations/pond/",
            1:{"top":["top.png",new Point(-40,14)]}
         },
         "quantity":[0],
         "hp":[100],
         "repairTime":[1]
      },{
         "id":104,
         "group":4,
         "subgroup":2,
         "order":16,
         "buildStatus":0,
         "type":"decoration",
         "name":"bdg_zengarden",
         "size":100,
         "attackgroup":999,
         "tutstage":200,
         "sale":0,
         "description":"bdg_zengarden_desc",
         "block":true,
         "costs":[{
            "r1":0,
            "r2":0,
            "r3":0,
            "r4":0,
            "r5":150,
            "time":new SecNum(0),
            "re":[]
         }],
         "imageData":{
            "baseurl":"buildings/decorations/zengarden/",
            1:{
               "top":["top.png",new Point(-72,-5)],
               "shadow":["shadow.jpg",new Point(-72,16)]
            }
         },
         "quantity":[0],
         "hp":[100],
         "repairTime":[1]
      },{
         "id":105,
         "group":4,
         "subgroup":2,
         "order":17,
         "buildStatus":0,
         "type":"decoration",
         "name":"bdg_fountain",
         "size":70,
         "attackgroup":999,
         "tutstage":200,
         "sale":0,
         "description":"bdg_fountain_desc",
         "block":true,
         "costs":[{
            "r1":0,
            "r2":0,
            "r3":0,
            "r4":0,
            "r5":150,
            "time":new SecNum(0),
            "re":[]
         }],
         "imageData":{
            "baseurl":"buildings/decorations/fountain/",
            1:{
               "anim":["anim.png",new Rectangle(-47,-51,89,114),42],
               "shadow":["shadow.jpg",new Point(-41,16)]
            }
         },
         "quantity":[0],
         "hp":[100],
         "repairTime":[1]
      },{
         "id":106,
         "group":4,
         "subgroup":2,
         "order":18,
         "buildStatus":0,
         "type":"decoration",
         "name":"bdg_teagarden",
         "size":100,
         "attackgroup":999,
         "tutstage":200,
         "sale":0,
         "description":"bdg_teargarden_desc",
         "block":true,
         "costs":[{
            "r1":0,
            "r2":0,
            "r3":0,
            "r4":0,
            "r5":150,
            "time":new SecNum(0),
            "re":[]
         }],
         "imageData":{
            "baseurl":"buildings/decorations/japaneseteagarden/",
            1:{
               "top":["top.png",new Point(-62,-38)],
               "shadow":["shadow.jpg",new Point(-57,12)]
            }
         },
         "quantity":[0],
         "hp":[100],
         "repairTime":[1]
      },{
         "id":107,
         "group":4,
         "subgroup":0,
         "order":1,
         "buildStatus":0,
         "type":"decoration",
         "name":"bdg_monsterskull",
         "size":20,
         "attackgroup":999,
         "tutstage":200,
         "sale":0,
         "description":"bdg_monsterskull_desc",
         "block":true,
         "costs":[{
            "r1":0,
            "r2":0,
            "r3":0,
            "r4":0,
            "r5":150,
            "time":new SecNum(0),
            "re":[]
         }],
         "imageData":{
            "baseurl":"buildings/decorations/headsonsticks/",
            1:{
               "top":["top-skull.png",new Point(-7,-39)],
               "shadow":["shadow.jpg",new Point(-1,-7)]
            }
         },
         "quantity":[0],
         "hp":[100],
         "repairTime":[1]
      },{
         "id":108,
         "group":4,
         "subgroup":2,
         "order":8,
         "buildStatus":0,
         "type":"decoration",
         "name":"bdg_rubikunsolved",
         "size":20,
         "attackgroup":999,
         "tutstage":200,
         "sale":0,
         "description":"bdg_rubikunsolved_desc",
         "block":true,
         "costs":[{
            "r1":0,
            "r2":0,
            "r3":0,
            "r4":0,
            "r5":150,
            "time":new SecNum(0),
            "re":[]
         }],
         "imageData":{
            "baseurl":"buildings/decorations/rubikscube/",
            1:{
               "top":["top-unsolved.png",new Point(-20,-23)],
               "shadow":["shadow.jpg",new Point(-22,-5)]
            }
         },
         "quantity":[0],
         "hp":[100],
         "repairTime":[1]
      },{
         "id":109,
         "group":4,
         "subgroup":2,
         "order":9,
         "buildStatus":0,
         "type":"decoration",
         "name":"bdg_rubiksolved",
         "size":20,
         "attackgroup":999,
         "tutstage":200,
         "sale":0,
         "description":"bdg_rubiksolved_desc",
         "block":true,
         "costs":[{
            "r1":0,
            "r2":0,
            "r3":0,
            "r4":0,
            "r5":150,
            "time":new SecNum(0),
            "re":[]
         }],
         "imageData":{
            "baseurl":"buildings/decorations/rubikscube/",
            1:{
               "top":["top-solved.png",new Point(-20,-23)],
               "shadow":["shadow.jpg",new Point(-22,-5)]
            }
         },
         "quantity":[0],
         "hp":[100],
         "repairTime":[1]
      },{
         "id":110,
         "group":4,
         "subgroup":4,
         "order":11,
         "buildStatus":0,
         "type":"decoration",
         "name":"bdg_halloween",
         "size":40,
         "attackgroup":999,
         "tutstage":200,
         "sale":0,
         "description":"bdg_halloween_desc",
         "block":true,
         "costs":[{
            "r1":0,
            "r2":0,
            "r3":0,
            "r4":0,
            "r5":1000,
            "time":new SecNum(0),
            "re":[]
         }],
         "imageData":{
            "baseurl":"buildings/decorations/pumpkins/",
            1:{
               "top":["attended-large-top.png",new Point(-24,-32)],
               "shadow":["attended-large-shadow.jpg",new Point(-25,1)]
            }
         },
         "quantity":[0],
         "hp":[100],
         "repairTime":[1]
      },{
         "id":111,
         "group":4,
         "subgroup":4,
         "order":12,
         "buildStatus":0,
         "type":"decoration",
         "name":"bdg_halloween_small",
         "size":20,
         "attackgroup":999,
         "tutstage":200,
         "sale":0,
         "description":"bdg_halloween_desc",
         "block":true,
         "costs":[{
            "r1":0,
            "r2":0,
            "r3":0,
            "r4":0,
            "r5":0,
            "time":new SecNum(0),
            "re":[]
         }],
         "imageData":{
            "baseurl":"buildings/decorations/pumpkins/",
            1:{
               "top":["attended-small-top.png",new Point(-10,-4)],
               "shadow":["attended-small-shadow.jpg",new Point(-12,2)]
            }
         },
         "quantity":[6],
         "hp":[100],
         "repairTime":[1]
      },{
         "id":112,
         "group":2,
         "order":1,
         "buildStatus":0,
         "type":"special",
         "name":"b_outpost",
         "size":190,
         "attackgroup":1,
         "tutstage":0,
         "sale":0,
         "description":"outpost_desc",
         "block":true,
         "costs":[{
            "r1":0,
            "r2":0,
            "r3":0,
            "r4":0,
            "time":new SecNum(10),
            "re":[]
         }],
         "imageData":{
            "baseurl":"buildings/outpost/",
            1:{
               "top":["top.1.png",new Point(-63,-72)],
               "shadow":["shadow.1.jpg",new Point(-77,22)],
               "topdamaged":["top.1.damaged.png",new Point(-63,-66)],
               "shadowdamaged":["shadow.1.damaged.jpg",new Point(-90,14)],
               "topdestroyed":["top.1.destroyed.png",new Point(-96,1)],
               "shadowdestroyed":["shadow.1.destroyed.jpg",new Point(-95,20)]
            }
         },
         "upgradeImgData":{
            "baseurl":"buildingbuttons/",
            1:{
               "img":"112.jpg",
               "silhouette_img":"112.silhouette.jpg"
            }
         },
         "thumbImgData":{
            "baseurl":"buildingthumbs/",
            1:{"img":"112.png"}
         },
         "fortImgData":{
            "baseurl":"buildings/fortifications/",
            1:{
               "front":["fort130_F1.png",new Point(-127,46)],
               "back":["fort130_B1.png",new Point(-122,-10)]
            },
            2:{
               "front":["fort130_F2.png",new Point(-124,48)],
               "back":["fort130_B2.png",new Point(-120,-15)]
            },
            3:{
               "front":["fort130_F3.png",new Point(-124,32)],
               "back":["fort130_B3.png",new Point(-110,-11)]
            },
            4:{
               "front":["fort130_F4.png",new Point(-124,15)],
               "back":["fort130_B4.png",new Point(-116,-49)]
            }
         },
         "can_fortify":true,
         "fortify_costs":[{
            "r1":250000,
            "r2":50000,
            "r3":25000,
            "r4":0,
            "time":new SecNum(14400),
            "re":[[112,1,1]]
         },{
            "r1":500000,
            "r2":500000,
            "r3":500000,
            "r4":0,
            "time":new SecNum(57600),
            "re":[[112,1,1]]
         },{
            "r1":2500000,
            "r2":2500000,
            "r3":1000000,
            "r4":0,
            "time":new SecNum(172800),
            "re":[[112,1,1]]
         },{
            "r1":5000000,
            "r2":5000000,
            "r3":2500000,
            "r4":0,
            "time":new SecNum(345600),
            "re":[[112,1,1]]
         }],
         "quantity":[1,1,1,1,1,1,1,1,1],
         "hp":[200000],
         "repairTime":[3600]
      },{
         "id":113,
         "group":2,
         "order":15,
         "buildStatus":0,
         "type":"special",
         "name":"#b_radio#",
         "size":80,
         "attackgroup":1,
         "tutstage":0,
         "sale":0,
         "description":"radio_build_desc",
         "block":true,
         "quantity":[0]
      },{
         "id":114,
         "group":3,
         "order":6,
         "buildStatus":0,
         "type":"tower",
         "name":"#b_monstercage#",
         "size":200,
         "attackgroup":2,
         "tutstage":200,
         "sale":0,
         "description":"monstercage_desc",
         "block":true,
         "quantity":[0]
      },{
         "id":115,
         "group":3,
         "order":5,
         "buildStatus":0,
         "type":"tower",
         "name":"#b_flaktower#",
         "attackgroup":2,
         "tutstage":200,
         "sale":0,
         "description":"flaktower_desc",
         "stats":[{
            "range":300,
            "damage":200,
            "rate":60,
            "speed":20,
            "splash":180
         },{
            "range":320,
            "damage":250,
            "rate":60,
            "speed":24,
            "splash":185
         },{
            "range":340,
            "damage":250,
            "rate":60,
            "speed":28,
            "splash":190
         },{
            "range":360,
            "damage":250,
            "rate":60,
            "speed":32,
            "splash":195
         },{
            "range":380,
            "damage":300,
            "rate":60,
            "speed":36,
            "splash":200
         },{
            "range":400,
            "damage":350,
            "rate":60,
            "speed":40,
            "splash":205
         }],
         "costs":[{
            "r1":215000,
            "r2":280000,
            "r3":62500,
            "r4":0,
            "time":new SecNum(18000),
            "re":[[112,1,1]]
         },{
            "r1":850000,
            "r2":1200000,
            "r3":250000,
            "r4":0,
            "time":new SecNum(86400),
            "re":[[112,1,1]]
         },{
            "r1":2750000,
            "r2":3400000,
            "r3":750000,
            "r4":0,
            "time":new SecNum(172800),
            "re":[[112,1,1]]
         },{
            "r1":5750000,
            "r2":5200000,
            "r3":1250000,
            "r4":0,
            "time":new SecNum(345600),
            "re":[[112,1,1]]
         },{
            "r1":13500000,
            "r2":11000000,
            "r3":2000000,
            "r4":0,
            "time":new SecNum(518400),
            "re":[[112,1,1]]
         },{
            "r1":27000000,
            "r2":22000000,
            "r3":2750000,
            "r4":0,
            "time":new SecNum(718400),
            "re":[[112,1,1]]
         }],
         "can_fortify":true,
         "fortify_costs":[{
            "r1":215000,
            "r2":280000,
            "r3":62500,
            "r4":0,
            "time":new SecNum(18000),
            "re":[[112,1,1]]
         },{
            "r1":850000,
            "r2":1200000,
            "r3":250000,
            "r4":0,
            "time":new SecNum(86400),
            "re":[[112,1,1]]
         },{
            "r1":2750000,
            "r2":3400000,
            "r3":750000,
            "r4":0,
            "time":new SecNum(172800),
            "re":[[112,1,1]]
         },{
            "r1":5750000,
            "r2":5200000,
            "r3":1250000,
            "r4":0,
            "time":new SecNum(345600),
            "re":[[112,1,1]]
         }],
         "imageData":{
            "baseurl":"buildings/flaktower/",
            1:{
               "anim":["anim.3.png",new Rectangle(-32,-23,62,52),32],
               "top":["top.3.png",new Point(-39,6)],
               "shadow":["shadow.3.jpg",new Point(-43,14)],
               "animdamaged":["anim.3.damaged.png",new Rectangle(-29,-17,62,53),32],
               "topdamaged":["top.3.damaged.png",new Point(-39,5)],
               "shadowdamaged":["shadow.3.jpg",new Point(-40,24)],
               "topdestroyed":["top.3.destroyed.png",new Point(-36,13)],
               "shadowdestroyed":["shadow.3.destroyed.jpg",new Point(-33,26)],
               "topdestroyedfire":["top.3.destroyed.fire.png",new Point(-45,-13)]
            }
         },
         "upgradeImgData":{
            "baseurl":"buildingbuttons/",
            1:{
               "img":"115.jpg",
               "silhouette_img":"115.silhouette.jpg"
            }
         },
         "fortImgData":{
            "baseurl":"buildings/fortifications/",
            1:{
               "front":["fort70_F1.png",new Point(-73,21)],
               "back":["fort70_B1.png",new Point(-70,-10)]
            },
            2:{
               "front":["fort70_F2.png",new Point(-69,22)],
               "back":["fort70_B2.png",new Point(-65,-12)]
            },
            3:{
               "front":["fort70_F3.png",new Point(-72,10)],
               "back":["fort70_B3.png",new Point(-68,-12)]
            },
            4:{
               "front":["fort70_F4.png",new Point(-70,-11)],
               "back":["fort70_B4.png",new Point(-61,-36)]
            }
         },
         "quantity":[0,2],
         "hp":[15000,22000,30000,48000,60000,75000],
         "repairTime":[1920,3840,7680,9260,12000,13440]
      },{
         "id":116,
         "group":2,
         "order":12,
         "buildStatus":0,
         "type":"special",
         "name":"#b_monsterlab#",
         "attackgroup":1,
         "tutstage":200,
         "sale":0,
         "description":"monsterlab_desc",
         "block":true,
         "quantity":[0]
      },{
         "id":117,
         "group":3,
         "order":10,
         "buildStatus":0,
         "type":"trap",
         "name":"#b_heavytrap#",
         "size":90,
         "attackgroup":4,
         "tutstage":200,
         "sale":0,
         "description":"heavytrap_desc",
         "costs":[{
            "r1":50000,
            "r2":50000,
            "r3":50000,
            "r4":0,
            "time":new SecNum(5),
            "re":[[112,1,1]]
         }],
         "imageData":{
            "baseurl":"buildings/heavytrap/",
            1:{
               "top":["top.1.png",new Point(-16,-5)],
               "shadow":["shadow.1.jpg",new Point(-18,1)],
               "topdestroyed":["top.1.destroyed.png",new Point(-16,5)],
               "shadowdestroyed":["shadow.1.jpg",new Point(-18,1)]
            }
         },
         "upgradeImgData":{
            "baseurl":"buildingbuttons/",
            1:{
               "img":"117.jpg",
               "silhouette_img":"117.silhouette.jpg"
            }
         },
         "quantity":[0,5],
         "damage":[10000],
         "hp":[10],
         "repairTime":[1]
      },{
         "id":118,
         "group":3,
         "order":5,
         "buildStatus":0,
         "type":"tower",
         "name":"#b_railguntower#",
         "size":64,
         "attackgroup":3,
         "tutstage":28,
         "sale":0,
         "description":"railguntower_desc",
         "stats":[{
            "range":300,
            "damage":400,
            "rate":160,
            "speed":20,
            "splash":0
         },{
            "range":315,
            "damage":600,
            "rate":160,
            "speed":20,
            "splash":0
         },{
            "range":330,
            "damage":900,
            "rate":160,
            "speed":20,
            "splash":0
         },{
            "range":345,
            "damage":1200,
            "rate":160,
            "speed":20,
            "splash":0
         },{
            "range":360,
            "damage":1600,
            "rate":160,
            "speed":20,
            "splash":0
         },{
            "range":375,
            "damage":2000,
            "rate":160,
            "speed":20,
            "splash":0
         }],
         "costs":[{
            "r1":1600000,
            "r2":1920000,
            "r3":1280000,
            "r4":0,
            "time":new SecNum(43200),
            "re":[[112,1,1]]
         },{
            "r1":2880000,
            "r2":3456000,
            "r3":2304000,
            "r4":0,
            "time":new SecNum(86400),
            "re":[[112,1,1]]
         },{
            "r1":5184000,
            "r2":6220800,
            "r3":4147200,
            "r4":0,
            "time":new SecNum(172800),
            "re":[[112,1,1]]
         },{
            "r1":9331200,
            "r2":11197440,
            "r3":7464960,
            "r4":0,
            "time":new SecNum(345600),
            "re":[[112,1,1]]
         },{
            "r1":16796160,
            "r2":20115392,
            "r3":13436928,
            "r4":0,
            "time":new SecNum(518400),
            "re":[[112,1,1]]
         },{
            "r1":21796160,
            "r2":30117392,
            "r3":20136928,
            "r4":0,
            "time":new SecNum(718400),
            "re":[[112,1,1]]
         }],
         "can_fortify":true,
         "fortify_costs":[{
            "r1":2000000,
            "r2":2400000,
            "r3":1600000,
            "r4":0,
            "time":new SecNum(43200),
            "re":[[112,1,1]]
         },{
            "r1":2600000,
            "r2":3320000,
            "r3":1880000,
            "r4":0,
            "time":new SecNum(86400),
            "re":[[112,1,1]]
         },{
            "r1":4480000,
            "r2":4776000,
            "r3":2184000,
            "r4":0,
            "time":new SecNum(172800),
            "re":[[112,1,1]]
         },{
            "r1":9664000,
            "r2":9996800,
            "r3":4331200,
            "r4":0,
            "time":new SecNum(345600),
            "re":[[112,1,1]]
         }],
         "imageData":{
            "baseurl":"buildings/railguntower/",
            1:{
               "anim":["anim.3.loaded.png",new Rectangle(-49,-9,96,56),32],
               "top":["top.3.png",new Point(-39,7)],
               "shadow":["shadow.3.jpg",new Point(-40,20)],
               "animdamaged":["anim.3.damaged.png",new Rectangle(-49,-9,97,56),32],
               "topdamaged":["top.3.damaged.png",new Point(-39,7)],
               "shadowdamaged":["shadow.3.jpg",new Point(-40,20)],
               "topdestroyed":["top.3.destroyed.png",new Point(-34,-5)],
               "shadowdestroyed":["shadow.3.destroyed.jpg",new Point(-36,23)],
               "topdestroyedfire":["top.3.destroyed.fire.png",new Point(-45,-13)]
            }
         },
         "upgradeImgData":{
            "baseurl":"buildingbuttons/",
            1:{
               "img":"118.jpg",
               "silhouette_img":"118.silhouette.jpg"
            }
         },
         "thumbImgData":{
            "baseurl":"buildingthumbs/",
            1:{"img":"118.png"}
         },
         "fortImgData":{
            "baseurl":"buildings/fortifications/",
            1:{
               "front":["fort70_F1.png",new Point(-73,21)],
               "back":["fort70_B1.png",new Point(-70,-10)]
            },
            2:{
               "front":["fort70_F2.png",new Point(-69,22)],
               "back":["fort70_B2.png",new Point(-65,-12)]
            },
            3:{
               "front":["fort70_F3.png",new Point(-72,10)],
               "back":["fort70_B3.png",new Point(-68,-12)]
            },
            4:{
               "front":["fort70_F4.png",new Point(-70,-11)],
               "back":["fort70_B4.png",new Point(-61,-36)]
            }
         },
         "quantity":[0,1],
         "hp":[17640,34400,45000,58000,75500,13200],
         "repairTime":[2880,5760,11520,23000,46000,9200]
      },{
         "id":119,
         "group":3,
         "order":10,
         "buildStatus":0,
         "type":"special",
         "name":"#b_championchamber#",
         "size":64,
         "attackgroup":3,
         "tutstage":28,
         "sale":0,
         "description":"championchamber_desc",
         "block":true,
         "quantity":[0]
      },{
         "id":120,
         "group":4,
         "subgroup":4,
         "order":1,
         "buildStatus":0,
         "type":"decoration",
         "name":"bdg_biggulp",
         "size":70,
         "attackgroup":999,
         "tutstage":200,
         "sale":0,
         "description":"bdg_biggulp_desc",
         "block":true,
         "quantity":[0]
      },{
         "id":121,
         "group":4,
         "subgroup":4,
         "order":13,
         "buildStatus":0,
         "type":"decoration",
         "name":"bdg_wmitotem1",
         "size":40,
         "attackgroup":999,
         "tutstage":200,
         "sale":0,
         "description":"bdg_wmitotem1_desc",
         "block":true,
         "costs":[{
            "r1":0,
            "r2":0,
            "r3":0,
            "r4":0,
            "r5":150,
            "time":new SecNum(0),
            "re":[]
         }],
         "imageData":{
            "baseurl":"buildings/decorations/statue-soccer/",
            1:{
               "top":["top.png",new Point(-23,-36)],
               "shadow":["shadow.jpg",new Point(-15,12)]
            }
         },
         "quantity":[0],
         "hp":[100],
         "repairTime":[1]
      },{
         "id":122,
         "group":4,
         "subgroup":4,
         "order":14,
         "buildStatus":0,
         "type":"decoration",
         "name":"bdg_wmitotem2",
         "size":40,
         "attackgroup":999,
         "tutstage":200,
         "sale":0,
         "description":"bdg_wmitotem2_desc",
         "block":true,
         "costs":[{
            "r1":0,
            "r2":0,
            "r3":0,
            "r4":0,
            "r5":150,
            "time":new SecNum(0),
            "re":[]
         }],
         "imageData":{
            "baseurl":"buildings/decorations/statue-soccer/",
            1:{
               "top":["top.png",new Point(-23,-36)],
               "shadow":["shadow.jpg",new Point(-15,12)]
            }
         },
         "quantity":[0],
         "hp":[100],
         "repairTime":[1]
      },{
         "id":123,
         "group":4,
         "subgroup":4,
         "order":15,
         "buildStatus":0,
         "type":"decoration",
         "name":"bdg_wmitotem3",
         "size":40,
         "attackgroup":999,
         "tutstage":200,
         "sale":0,
         "description":"bdg_wmitotem3_desc",
         "block":true,
         "costs":[{
            "r1":0,
            "r2":0,
            "r3":0,
            "r4":0,
            "r5":150,
            "time":new SecNum(0),
            "re":[]
         }],
         "imageData":{
            "baseurl":"buildings/decorations/statue-soccer/",
            1:{
               "top":["top.png",new Point(-23,-36)],
               "shadow":["shadow.jpg",new Point(-15,12)]
            }
         },
         "quantity":[0],
         "hp":[100],
         "repairTime":[1]
      },{
         "id":124,
         "group":4,
         "subgroup":4,
         "order":16,
         "buildStatus":0,
         "type":"decoration",
         "name":"bdg_wmitotem4",
         "size":40,
         "attackgroup":999,
         "tutstage":200,
         "sale":0,
         "description":"bdg_wmitotem4_desc",
         "block":true,
         "costs":[{
            "r1":0,
            "r2":0,
            "r3":0,
            "r4":0,
            "r5":150,
            "time":new SecNum(0),
            "re":[]
         }],
         "imageData":{
            "baseurl":"buildings/decorations/statue-soccer/",
            1:{
               "top":["top.png",new Point(-23,-36)],
               "shadow":["shadow.jpg",new Point(-15,12)]
            }
         },
         "quantity":[0],
         "hp":[100],
         "repairTime":[1]
      },{
         "id":125,
         "group":4,
         "subgroup":4,
         "order":17,
         "buildStatus":0,
         "type":"decoration",
         "name":"bdg_wmitotem5",
         "size":40,
         "attackgroup":999,
         "tutstage":200,
         "sale":0,
         "description":"bdg_wmitotem5_desc",
         "block":true,
         "costs":[{
            "r1":0,
            "r2":0,
            "r3":0,
            "r4":0,
            "r5":150,
            "time":new SecNum(0),
            "re":[]
         }],
         "imageData":{
            "baseurl":"buildings/decorations/statue-soccer/",
            1:{
               "top":["top.png",new Point(-23,-36)],
               "shadow":["shadow.jpg",new Point(-15,12)]
            }
         },
         "quantity":[0],
         "hp":[100],
         "repairTime":[1]
      },{
         "id":126,
         "group":4,
         "subgroup":4,
         "order":18,
         "buildStatus":0,
         "type":"decoration",
         "name":"bdg_wmitotem6",
         "size":40,
         "attackgroup":999,
         "tutstage":200,
         "sale":0,
         "description":"bdg_wmitotem6_desc",
         "block":true,
         "costs":[{
            "r1":0,
            "r2":0,
            "r3":0,
            "r4":0,
            "r5":150,
            "time":new SecNum(0),
            "re":[]
         }],
         "imageData":{
            "baseurl":"buildings/decorations/statue-soccer/",
            1:{
               "top":["top.png",new Point(-23,-36)],
               "shadow":["shadow.jpg",new Point(-15,12)]
            }
         },
         "quantity":[0],
         "hp":[100],
         "repairTime":[1]
      },{
         "id":127,
         "group":999,
         "order":0,
         "buildStatus":0,
         "type":"enemy",
         "name":"#b_trojanhorse#",
         "size":100,
         "attackgroup":999,
         "tutstage":200,
         "sale":0,
         "description":"trojanhorse_desc",
         "costs":[{
            "r1":0,
            "r2":0,
            "r3":0,
            "r4":0,
            "time":new SecNum(5),
            "re":[[14,1,1]]
         },{
            "r1":0,
            "r2":0,
            "r3":0,
            "r4":0,
            "time":new SecNum(5),
            "re":[[14,1,1]]
         },{
            "r1":0,
            "r2":0,
            "r3":0,
            "r4":0,
            "time":new SecNum(5),
            "re":[[14,1,1]]
         },{
            "r1":0,
            "r2":0,
            "r3":0,
            "r4":0,
            "time":new SecNum(5),
            "re":[[14,1,1]]
         }],
         "imageData":{
            "baseurl":"buildings/trojanhorse/",
            1:{
               "anim":["anim.1.png",new Rectangle(-92,-23,39,31),2],
               "top":["top.1.png",new Point(-91,-65)],
               "shadow":["shadow.1.jpg",new Point(-72,11)]
            }
         },
         "quantity":[1,1,1,1],
         "damage":[1,1,1,1],
         "hp":[1,1,1,1],
         "repairTime":[1,1,1,1]
      },{
         "id":128,
         "group":2,
         "order":6,
         "buildStatus":0,
         "type":"tower",
         "name":"#b_housingbunker#",
         "size":200,
         "attackgroup":2,
         "tutstage":50,
         "sale":0,
         "description":"housing_desc",
         "block":true,
         "quantity":[0]
      },{
         "id":129,
         "group":3,
         "order":2,
         "buildStatus":0,
         "type":"tower",
         "name":"#b_quaketower#",
         "size":64,
         "attackgroup":1,
         "tutstage":200,
         "sale":0,
         "description":"cannontower_desc",
         "block":true,
         "quantity":[0]
      },{
         "id":130,
         "group":3,
         "order":2,
         "buildStatus":0,
         "type":"tower",
         "name":"#b_icannontower#",
         "size":64,
         "attackgroup":1,
         "tutstage":200,
         "sale":0,
         "description":"icannontower_desc",
         "block":true,
         "quantity":[0]
      },{
         "id":131,
         "group":4,
         "subgroup":4,
         "order":19,
         "buildStatus":0,
         "type":"decoration",
         "name":"bdg_wmi2totem",
         "size":40,
         "attackgroup":999,
         "tutstage":200,
         "sale":0,
         "description":"bdg_wmi2totem_desc",
         "block":true,
         "quantity":[0]
      },{
         "id":132,
         "group":3,
         "order":5,
         "buildStatus":0,
         "type":"tower",
         "name":"#bi_magmatower#",
         "attackType":1,
         "size":64,
         "attackgroup":1,
         "tutstage":200,
         "sale":0,
         "description":"bi_magmatower_desc",
         "block":true,
         "rewarded":false,
         "stats":[{
            "range":180,
            "damage":180,
            "rate":20,
            "speed":14,
            "splash":0
         },{
            "range":190,
            "damage":240,
            "rate":20,
            "speed":15,
            "splash":0
         },{
            "range":200,
            "damage":300,
            "rate":20,
            "speed":16,
            "splash":0
         },{
            "range":210,
            "damage":360,
            "rate":20,
            "speed":17,
            "splash":0
         },{
            "range":220,
            "damage":420,
            "rate":20,
            "speed":18,
            "splash":0
         },{
            "range":230,
            "damage":480,
            "rate":20,
            "speed":19,
            "splash":0
         }],
         "costs":[{
            "r1":187500,
            "r2":250000,
            "r3":62500,
            "r4":0,
            "time":new SecNum(18000),
            "re":[[INFERNOQUAKETOWER.UNDERHALL_ID,1,1]]
         },{
            "r1":750000,
            "r2":1000000,
            "r3":250000,
            "r4":0,
            "time":new SecNum(86400),
            "re":[[INFERNOQUAKETOWER.UNDERHALL_ID,1,1]]
         },{
            "r1":2250000,
            "r2":3000000,
            "r3":750000,
            "r4":0,
            "time":new SecNum(172800),
            "re":[[INFERNOQUAKETOWER.UNDERHALL_ID,1,1]]
         },{
            "r1":5250000,
            "r2":5000000,
            "r3":1250000,
            "r4":0,
            "time":new SecNum(345600),
            "re":[[INFERNOQUAKETOWER.UNDERHALL_ID,1,1]]
         },{
            "r1":12000000,
            "r2":10000000,
            "r3":2000000,
            "r4":0,
            "time":new SecNum(518400),
            "re":[[INFERNOQUAKETOWER.UNDERHALL_ID,1,1]]
         },{
            "r1":16000000,
            "r2":15000000,
            "r3":3000000,
            "r4":0,
            "time":new SecNum(791200),
            "re":[[INFERNOQUAKETOWER.UNDERHALL_ID,1,1]]
         }],
         "fortify_costs":[{
            "r1":215000,
            "r2":280000,
            "r3":62500,
            "r4":0,
            "time":new SecNum(18000),
            "re":[[14,1,5]]
         },{
            "r1":850000,
            "r2":1200000,
            "r3":250000,
            "r4":0,
            "time":new SecNum(86400),
            "re":[[14,1,6]]
         },{
            "r1":2750000,
            "r2":3400000,
            "r3":750000,
            "r4":0,
            "time":new SecNum(172800),
            "re":[[14,1,7]]
         },{
            "r1":5750000,
            "r2":5200000,
            "r3":1250000,
            "r4":0,
            "time":new SecNum(345600),
            "re":[[14,1,8]]
         }],
         "imageData":{
            "baseurl":"buildings/imagmatower/",
            1:{
               "anim":["anim.1.v2.png",new Rectangle(-26,-50,54,42),31],
               "anim2":["anim.2.v2.png",new Rectangle(-17,26,38,19),31],
               "top":["top.1.v2.png",new Point(-34,-9)],
               "shadow":["shadow.1.v2.jpg",new Point(-31,10)],
               "animdamaged":["anim.1.damaged.v2.png",new Rectangle(-28.6,-47.6,52,43),31],
               "animdamaged2":["anim.2.damaged.v2.png",new Rectangle(-21,28,38,19),31],
               "topdamaged":["top.1.damaged.v2.png",new Point(-38,-4)],
               "shadowdamaged":["shadow.1.v2.jpg",new Point(-38,16)],
               "topdestroyed":["top.1.destroyed.v2.png",new Point(-36,6)],
               "shadowdestroyed":["shadow.1.destroyed.v2.jpg",new Point(-36,22)]
            }
         },
         "buildingbuttons":["magma_tower.v2"],
         "upgradeImgData":{
            "baseurl":"buildingbuttons/",
            1:{
               "img":"magma_tower.v2.jpg",
               "silhouette_img":"magma_tower.v2.silhouette.jpg"
            }
         },
         "fortImgData":{
            "baseurl":"buildings/fortifications/",
            1:{
               "front":["fort70_F1.png",new Point(-73,21)],
               "back":["fort70_B1.png",new Point(-70,-10)]
            },
            2:{
               "front":["fort70_F2.png",new Point(-69,22)],
               "back":["fort70_B2.png",new Point(-65,-12)]
            },
            3:{
               "front":["fort70_F3.png",new Point(-72,10)],
               "back":["fort70_B3.png",new Point(-68,-12)]
            },
            4:{
               "front":["fort70_F4.png",new Point(-70,-11)],
               "back":["fort70_B4.png",new Point(-61,-36)]
            }
         },
         "quantity":[0,1,1,1,2,2,2,2,2,2,2],
         "hp":[15000,22000,30000,49000,59000,70000],
         "repairTime":[1440,2880,5760,11520,23000,46000,92000]
      },{
         "id":133,
         "group":2,
         "order":8,
         "buildStatus":0,
         "type":"special",
         "name":"#b_siegefactory#",
         "size":90,
         "attackgroup":2,
         "tutstage":200,
         "sale":0,
         "description":"b_siegefactory_desc",
         "block":true,
         "cls":SiegeFactory,
         "hitCls":siegeFactoryHit,
         "costs":[{
            "r1":0,
            "r2":0,
            "r3":0,
            "r4":0,
            "r5":0,
            "time":new SecNum(0),
            "re":[]
         }],
         "imageData":{
            "baseurl":"buildings/siegefactory/",
            1:{
               "top":["top.1.png",new Point(-75,-23)],
               "topdamaged":["top.1.damaged.png",new Point(-75,-96)],
               "topdestroyed":["top.1.destroyed.png",new Point(-75,-48)],
               "anim":["anim.1.png",new Rectangle(-76,-101,154,80),34]
            }
         },
         "stats":[{
            "range":200,
            "duration":380,
            "radius":200
         },{
            "range":210,
            "duration":390,
            "radius":210
         },{
            "range":235,
            "duration":400,
            "radius":235
         },{
            "range":335,
            "duration":410,
            "radius":335
         },{
            "range":360,
            "duration":200,
            "radius":360
         },{
            "range":370,
            "duration":210,
            "radius":370
         },{
            "range":380,
            "duration":235,
            "radius":380
         },{
            "range":390,
            "duration":335,
            "radius":390
         },{
            "range":400,
            "duration":360,
            "radius":400
         },{
            "range":410,
            "duration":370,
            "radius":410
         }],
         "quantity":[1,1,1,1,1,1,1,1,1,1],
         "hp":[100,100,100,100,100,100],
         "repairTime":[1,1,1,1,1,1,1]
      },{
         "id":134,
         "group":2,
         "order":8,
         "buildStatus":0,
         "type":"special",
         "name":"#b_siegeworks#",
         "size":90,
         "attackgroup":2,
         "tutstage":200,
         "sale":0,
         "description":"b_siegeworks_desc",
         "block":true,
         "cls":SiegeLab,
         "hitCls":siegeLabHit,
         "costs":[{
            "r1":0,
            "r2":0,
            "r3":0,
            "r4":0,
            "r5":0,
            "time":new SecNum(0),
            "re":[]
         }],
         "imageData":{
            "baseurl":"buildings/siegelab/",
            1:{
               "top":["top.1.png",new Point(-68,-66)],
               "topdamaged":["top.1.damaged.png",new Point(-69,-111)],
               "topdestroyed":["top.1.destroyed.png",new Point(-68,-47)],
               "anim":["anim.1.png",new Rectangle(-70,-106,118,166),60]
            }
         },
         "stats":[{
            "range":200,
            "duration":380,
            "radius":200
         },{
            "range":210,
            "duration":390,
            "radius":210
         },{
            "range":235,
            "duration":400,
            "radius":235
         },{
            "range":335,
            "duration":410,
            "radius":335
         },{
            "range":360,
            "duration":200,
            "radius":360
         },{
            "range":370,
            "duration":210,
            "radius":370
         },{
            "range":380,
            "duration":235,
            "radius":380
         },{
            "range":390,
            "duration":335,
            "radius":390
         },{
            "range":400,
            "duration":360,
            "radius":400
         },{
            "range":410,
            "duration":370,
            "radius":410
         }],
         "quantity":[1,1,1,1,1,1,1,1,1,1],
         "hp":[100,100,100,100,100,100],
         "repairTime":[1,1,1,1,1,1,1]
      },{
         "id":135,
         "group":4,
         "subgroup":4,
         "order":11,
         "buildStatus":0,
         "type":"decoration",
         "name":"bdg_dave_trophy",
         "size":70,
         "attackgroup":999,
         "tutstage":200,
         "sale":0,
         "description":"bdg_dave_trophy_desc",
         "block":true,
         "locked":true,
         "lockedButtonOverlay":"buildingbuttons/135locked.png",
         "costs":[{
            "r1":0,
            "r2":0,
            "r3":0,
            "r4":0,
            "r5":0,
            "time":new SecNum(0),
            "re":[]
         }],
         "buildingbuttons":["135"],
         "imageData":{
            "baseurl":"buildings/decorations/dave_trophy/",
            1:{
               "top":["top.png",new Point(-38,-30)],
               "shadow":["shadow.jpg",new Point(-38,20)]
            }
         },
         "quantity":[0],
         "hp":[100],
         "repairTime":[1]
      }];
      
      public function OUTPOST_YARD_PROPS()
      {
         super();
      }
   }
}