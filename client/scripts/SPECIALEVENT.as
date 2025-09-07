package
{
   import com.cc.utils.SecNum;
   import com.monsters.managers.InstanceManager;
   import com.monsters.monsters.champions.ChampionBase;
   import com.monsters.ui.UI_BOTTOM;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import com.monsters.enums.EnumInvasionType;
   
   public class SPECIALEVENT
   {
      
      private static var _eventCount:SecNum = new SecNum(1);
      
      private static var _setupCalled:Boolean = false;
      
      private static var _lastTimestamp:Number = 0;
      
      private static var _wave:SecNum = new SecNum(-1);
      
      private static var _group:int = 0;
      
      private static var _randomDirection:Number = 0;
      
      private static var _timeOfNextWave:Number = -1;
      
      private static var _spawningWaves:Boolean = false;
      
      private static var _active:Boolean = false;
      
      private static var _isDebug:Boolean = false;
      
      private static var _retreatAllMonsters:Boolean = false;
      
      private static var _eventStartTime:SecNum = new SecNum(-1);
      
      private static var _eventEndTime:SecNum = new SecNum(-1);
      
      public static var _currentAttackers:Array = new Array();
      
      private static var _knownFlag:int = -1;
      
      public static var _whatsNewComplete:Boolean = false;
      
      private static const ACTIVE_OVERRIDE:Boolean = false;
      
      private static const DIR:Object = {
         "N":270,
         "S":90,
         "E":0,
         "W":180
      };
      
      private static const TIME_OFFSETS:Array = [new SecNum(-604800),new SecNum(-345600),new SecNum(-86400),new SecNum(0),new SecNum(604800)];
      
      private static const CREEP:int = 0;
      
      private static const GUARDIAN:int = 1;
      
      public static const BANNERIMAGE:String = "specialevent/wmi2_banner.jpg";
      
      public static const BONUSWAVE:int = 31;
      
      public static const BONUSWAVE2:int = 32;
      
      public static const EVENTEND:int = 33;
      
      public static const WAVES_DESC:Array = ["<b>Wave 1</b><br>10 Spurtz","<b>Wave 2</b><br>6 Zagnoid, 6 Malphus","<b>Wave 3</b><br>8 Zagnoid, 8 Spurtz","<b>Wave 4</b><br>10 Zagnoid, 10 Spurtz, 10 Malphus","<b>Wave 5</b><br>32 Spurtz","<b>Wave 6</b><br>12 Zagnoid, 5 Spurtz","<b>Wave 7</b><br>10 Zagnoid, 40 Malphus","<b>Wave 8</b><br>40 Spurtz, 5 Balthazar","<b>Wave 9</b><br>20 Zagnoid, 15 Spurtz, 3 Sabnox, 10 Malphus","<b>Wave 10</b><br>20 Zagnoid, 5 Sabnox, 5 Valgos, 10 Malphus, 5 Balthazar","<b>Wave 11</b><br>20 Valgos, 50 Spurtz","<b>Wave 12</b><br>16 Valgos, 36 Zagnoids, 16 Grokus","<b>Wave 13</b><br>30 Zagnoid, 6 Sabnox, 20 Spurtz, 20 Malphus, 8 Balthazar ","<b>Wave 14</b><br>14 Sabnox, 20 Grokus","<b>Wave 15</b><br>40 Spurtz, 36 Balthazars, 20 Malphus","<b>Wave 16</b><br>60 enraged Spurtz","<b>Wave 17</b><br>24 enraged Zagnoid, 60 Spurtz, 15 Balthazar","<b>Wave 18</b><br>20 enraged Zagnoid, 10 Sabnox, 80 Spurtz","<b>Wave 19</b><br>240 Spurtz","<b>Wave 20</b><br>40 Valgos, 40 Balthazar, 10 Sabnox, 30 enraged Zagnoid, 10 Grokus, 10 enraged King Wormzer","<b>Wave 21</b><br>60 L6 Balthazar, 30 enraged Grokus","<b>Wave 22</b><br>120 Zagnoid, 60 Sabnox, 100 Grokus","<b>Wave 23</b><br>60 King Wormzer, 30 Balthazar","<b>Wave 24</b><br>100 Zagnoid, 20 Balthazar, 30 enraged Sabnox, 60 Grokus","<b>Wave 25</b><br>60 enraged L6 Zagnoid, 30 enraged King Wormzer","<b>Wave 26</b><br>80 L6 Spurtz, 30 L6 enraged Zagnoid, 20 L6 Sabnox, 20 L6 King Wormzer","<b>Wave 27</b><br>80 MAX Valgos, 30 enraged King Wormzer","<b>Wave 28</b><br>80 MAX Sabnox, 40 MAX King Wormzer","<b>Wave 29</b><br>75 MAX King Wormzer","<b>Wave 30</b><br>40 Max enraged Sabnox, 80 MAX enraged Grokus, 32 max enraged King Wormzer","<b>Bonus Wave</b><br>??????","<b>Bonus Wave 2</b><br>??????"];
      
      private static const WAVES:Array = [[{
         "type":CREEP,
         "wave":[["IC1","bounce",10,250,DIR.N,0,1]],
         "powerup":0,
         "level":1
      }],[{
         "type":CREEP,
         "wave":[["IC2","bounce",6,250,DIR.N,0,1]],
         "powerup":0,
         "level":1
      },1,{
         "type":CREEP,
         "wave":[["IC3","bounce",6,250,DIR.N,0,0]],
         "powerup":0,
         "level":1
      }],[{
         "type":CREEP,
         "wave":[["IC2","bounce",8,250,DIR.N,0,1]],
         "powerup":0,
         "level":1
      },1,{
         "type":CREEP,
         "wave":[["IC1","bounce",8,250,DIR.N,0,0]],
         "powerup":0,
         "level":1
      }],[{
         "type":CREEP,
         "wave":[["IC2","bounce",10,250,DIR.N,0,1]],
         "powerup":0,
         "level":1
      },10,{
         "type":CREEP,
         "wave":[["IC3","bounce",10,250,DIR.N,0,0]],
         "powerup":0,
         "level":1
      },{
         "type":CREEP,
         "wave":[["IC1","bounce",10,250,DIR.N,0,0]],
         "powerup":0,
         "level":1
      }],[{
         "type":CREEP,
         "wave":[["IC1","bounce",16,250,DIR.N,0,1]],
         "powerup":0,
         "level":3
      },6,{
         "type":CREEP,
         "wave":[["IC1","bounce",16,250,DIR.S,0,1]],
         "powerup":0,
         "level":3
      }],[{
         "type":CREEP,
         "wave":[["IC2","bounce",12,250,DIR.N,0,1]],
         "powerup":0,
         "level":1
      },2,{
         "type":CREEP,
         "wave":[["IC1","bounce",5,250,DIR.N,0,0]],
         "powerup":0,
         "level":4
      }],[{
         "type":CREEP,
         "wave":[["IC2","bounce",15,250,DIR.N,0,1]],
         "powerup":0,
         "level":3
      },5,{
         "type":CREEP,
         "wave":[["IC3","bounce",40,250,DIR.N,0,0]],
         "powerup":0,
         "level":1
      }],[{
         "type":CREEP,
         "wave":[["IC1","bounce",40,250,DIR.N,0,1]],
         "powerup":0,
         "level":1
      },10,{
         "type":CREEP,
         "wave":[["IC5","bounce",5,250,DIR.N,0,0]],
         "powerup":0,
         "level":1
      }],[{
         "type":CREEP,
         "wave":[["IC2","bounce",20,250,DIR.N,0,1]],
         "powerup":0,
         "level":1
      },1,{
         "type":CREEP,
         "wave":[["IC1","bounce",15,250,DIR.N,0,0]],
         "powerup":0,
         "level":1
      },{
         "type":CREEP,
         "wave":[["IC7","bounce",3,250,DIR.N,0,0]],
         "powerup":0,
         "level":1
      },15,{
         "type":CREEP,
         "wave":[["IC3","bounce",10,250,DIR.N,0,0]],
         "powerup":0,
         "level":1
      }],[{
         "type":CREEP,
         "wave":[["IC2","bounce",20,250,DIR.N,0,1]],
         "powerup":0,
         "level":3
      },2,{
         "type":CREEP,
         "wave":[["IC7","bounce",5,250,DIR.N,0,0]],
         "powerup":0,
         "level":1
      },{
         "type":CREEP,
         "wave":[["IC4","bounce",5,250,DIR.N,0,0]],
         "powerup":0,
         "level":1
      },15,{
         "type":CREEP,
         "wave":[["IC3","bounce",10,250,DIR.N,0,0]],
         "powerup":0,
         "level":2
      },{
         "type":CREEP,
         "wave":[["IC5","bounce",5,500,DIR.N,0,0]],
         "powerup":0,
         "level":1
      }],[{
         "type":CREEP,
         "wave":[["IC4","bounce",10,250,DIR.W,0,1]],
         "powerup":0,
         "level":1
      },{
         "type":CREEP,
         "wave":[["IC4","bounce",10,250,DIR.E,0,0]],
         "powerup":0,
         "level":1
      },15,{
         "type":CREEP,
         "wave":[["IC1","bounce",25,250,DIR.W,0,0]],
         "powerup":0,
         "level":1
      },{
         "type":CREEP,
         "wave":[["IC1","bounce",25,250,DIR.E,0,0]],
         "powerup":0,
         "level":1
      }],[{
         "type":CREEP,
         "wave":[["IC4","bounce",8,250,DIR.E,0,1]],
         "powerup":0,
         "level":2
      },{
         "type":CREEP,
         "wave":[["IC4","bounce",8,250,DIR.E,0,0]],
         "powerup":0,
         "level":2
      },{
         "type":CREEP,
         "wave":[["IC2","bounce",18,250,DIR.E,0,1]],
         "powerup":0,
         "level":3
      },{
         "type":CREEP,
         "wave":[["IC2","bounce",18,250,DIR.W,0,0]],
         "powerup":0,
         "level":3
      },30,{
         "type":CREEP,
         "wave":[["IC6","bounce",8,250,DIR.N,0,1]],
         "powerup":0,
         "level":1
      },{
         "type":CREEP,
         "wave":[["IC6","bounce",8,250,DIR.S,0,0]],
         "powerup":0,
         "level":1
      }],[{
         "type":CREEP,
         "wave":[["IC2","bounce",15,250,DIR.E,0,1]],
         "powerup":0,
         "level":4
      },{
         "type":CREEP,
         "wave":[["IC2","bounce",15,250,DIR.W,0,0]],
         "powerup":0,
         "level":4
      },5,{
         "type":CREEP,
         "wave":[["IC7","bounce",3,250,DIR.W,0,0]],
         "powerup":0,
         "level":1
      },{
         "type":CREEP,
         "wave":[["IC7","bounce",3,250,DIR.E,0,0]],
         "powerup":0,
         "level":1
      },15,{
         "type":CREEP,
         "wave":[["IC5","bounce",4,400,DIR.W,0,0]],
         "powerup":0,
         "rage":15,
         "level":1
      },{
         "type":CREEP,
         "wave":[["IC5","bounce",4,400,DIR.E,0,0]],
         "powerup":0,
         "rage":15,
         "level":1
      },45,{
         "type":CREEP,
         "wave":[["IC1","bounce",10,250,DIR.N,0,0]],
         "powerup":0,
         "level":1
      },{
         "type":CREEP,
         "wave":[["IC1","bounce",10,250,DIR.S,0,0]],
         "powerup":0,
         "level":1
      },{
         "type":CREEP,
         "wave":[["IC3","bounce",10,250,DIR.N,0,1]],
         "powerup":0,
         "level":2
      },{
         "type":CREEP,
         "wave":[["IC3","bounce",10,250,DIR.S,0,0]],
         "powerup":0,
         "level":2
      }],[{
         "type":CREEP,
         "wave":[["IC7","bounce",7,250,DIR.E,0,1]],
         "powerup":0,
         "level":1
      },{
         "type":CREEP,
         "wave":[["IC7","bounce",7,250,DIR.W,0,0]],
         "powerup":0,
         "level":1
      },15,{
         "type":CREEP,
         "wave":[["IC6","bounce",10,250,DIR.N,0,1]],
         "powerup":0,
         "level":1
      },{
         "type":CREEP,
         "wave":[["IC6","bounce",10,250,DIR.S,0,0]],
         "powerup":0,
         "level":1
      },15],[{
         "type":CREEP,
         "wave":[["IC1","bounce",10,250,DIR.N,0,1]],
         "powerup":0,
         "level":4
      },{
         "type":CREEP,
         "wave":[["IC1","bounce",10,250,DIR.W,0,0]],
         "powerup":0,
         "level":4
      },{
         "type":CREEP,
         "wave":[["IC1","bounce",10,250,DIR.S,0,0]],
         "powerup":0,
         "level":4
      },{
         "type":CREEP,
         "wave":[["IC1","bounce",10,250,DIR.E,0,0]],
         "powerup":0,
         "level":4
      },15,{
         "type":CREEP,
         "wave":[["IC5","bounce",9,250,DIR.N,0,1]],
         "powerup":0,
         "level":1
      },{
         "type":CREEP,
         "wave":[["IC5","bounce",9,250,DIR.W,0,0]],
         "powerup":0,
         "level":1
      },{
         "type":CREEP,
         "wave":[["IC5","bounce",9,250,DIR.S,0,0]],
         "powerup":0,
         "level":1
      },{
         "type":CREEP,
         "wave":[["IC5","bounce",9,250,DIR.E,0,0]],
         "powerup":0,
         "level":1
      },10,{
         "type":CREEP,
         "wave":[["IC3","bounce",10,250,DIR.N,0,0]],
         "powerup":0,
         "level":4
      },{
         "type":CREEP,
         "wave":[["IC3","bounce",10,250,DIR.S,0,0]],
         "powerup":0,
         "level":4
      }],[{
         "type":CREEP,
         "wave":[["IC1","bounce",15,250,DIR.N,0,1]],
         "powerup":0,
         "rage":25,
         "level":4
      },{
         "type":CREEP,
         "wave":[["IC1","bounce",15,250,DIR.W,0,0]],
         "powerup":0,
         "rage":25,
         "level":4
      },{
         "type":CREEP,
         "wave":[["IC1","bounce",15,250,DIR.S,0,0]],
         "powerup":0,
         "rage":25,
         "level":4
      },{
         "type":CREEP,
         "wave":[["IC1","bounce",15,250,DIR.E,0,0]],
         "powerup":0,
         "rage":25,
         "level":4
      }],[{
         "type":CREEP,
         "wave":[["IC2","bounce",12,250,DIR.E,0,1]],
         "powerup":0,
         "rage":30,
         "level":1
      },{
         "type":CREEP,
         "wave":[["IC2","bounce",12,250,DIR.W,0,0]],
         "powerup":0,
         "rage":30,
         "level":1
      },15,{
         "type":CREEP,
         "wave":[["IC1","bounce",30,250,DIR.N,0,1]],
         "powerup":0,
         "level":5
      },{
         "type":CREEP,
         "wave":[["IC1","bounce",30,250,DIR.S,0,0]],
         "powerup":0,
         "level":5
      },15,{
         "type":CREEP,
         "wave":[["IC5","bounce",15,250,DIR.N,0,1]],
         "powerup":0,
         "level":1
      }],[{
         "type":CREEP,
         "wave":[["IC2","bounce",10,250,DIR.N,0,1]],
         "powerup":0,
         "rage":30,
         "level":2
      },{
         "type":CREEP,
         "wave":[["IC2","bounce",10,250,DIR.S,0,0]],
         "powerup":0,
         "rage":30,
         "level":2
      },15,{
         "type":CREEP,
         "wave":[["IC7","bounce",5,250,DIR.N,0,0]],
         "powerup":0,
         "level":4
      },{
         "type":CREEP,
         "wave":[["IC7","bounce",5,250,DIR.S,0,0]],
         "powerup":0,
         "level":4
      },{
         "type":CREEP,
         "wave":[["IC1","bounce",10,250,DIR.N,0,0]],
         "powerup":0,
         "level":4
      },{
         "type":CREEP,
         "wave":[["IC1","bounce",10,250,DIR.W,0,0]],
         "powerup":0,
         "level":4
      },{
         "type":CREEP,
         "wave":[["IC1","bounce",10,250,DIR.S,0,0]],
         "powerup":0,
         "level":4
      },{
         "type":CREEP,
         "wave":[["IC1","bounce",10,250,DIR.E,0,0]],
         "powerup":0,
         "level":4
      },15,{
         "type":CREEP,
         "wave":[["IC1","bounce",10,250,DIR.N,0,0]],
         "powerup":0,
         "level":4
      },{
         "type":CREEP,
         "wave":[["IC1","bounce",10,250,DIR.W,0,0]],
         "powerup":0,
         "level":4
      },{
         "type":CREEP,
         "wave":[["IC1","bounce",10,250,DIR.S,0,0]],
         "powerup":0,
         "level":4
      },{
         "type":CREEP,
         "wave":[["IC1","bounce",10,250,DIR.E,0,0]],
         "powerup":0,
         "level":4
      },15],[{
         "type":CREEP,
         "wave":[["IC1","bounce",10,250,DIR.N,0,0]],
         "powerup":0,
         "level":5
      },{
         "type":CREEP,
         "wave":[["IC1","bounce",10,250,DIR.W,0,0]],
         "powerup":0,
         "level":5
      },{
         "type":CREEP,
         "wave":[["IC1","bounce",10,250,DIR.S,0,0]],
         "powerup":0,
         "level":5
      },{
         "type":CREEP,
         "wave":[["IC1","bounce",10,250,DIR.E,0,0]],
         "powerup":0,
         "level":5
      },30,{
         "type":CREEP,
         "wave":[["IC1","bounce",10,250,DIR.N,0,0]],
         "powerup":0,
         "level":5
      },{
         "type":CREEP,
         "wave":[["IC1","bounce",10,250,DIR.W,0,0]],
         "powerup":0,
         "level":5
      },{
         "type":CREEP,
         "wave":[["IC1","bounce",10,250,DIR.S,0,0]],
         "powerup":0,
         "level":5
      },{
         "type":CREEP,
         "wave":[["IC1","bounce",10,250,DIR.E,0,0]],
         "powerup":0,
         "level":5
      },30,{
         "type":CREEP,
         "wave":[["IC1","bounce",10,250,DIR.N,0,0]],
         "powerup":0,
         "level":5
      },{
         "type":CREEP,
         "wave":[["IC1","bounce",10,250,DIR.W,0,0]],
         "powerup":0,
         "level":5
      },{
         "type":CREEP,
         "wave":[["IC1","bounce",10,250,DIR.S,0,0]],
         "powerup":0,
         "level":5
      },{
         "type":CREEP,
         "wave":[["IC1","bounce",10,250,DIR.E,0,0]],
         "powerup":0,
         "level":5
      },30,{
         "type":CREEP,
         "wave":[["IC1","bounce",10,250,DIR.N,0,0]],
         "powerup":0,
         "level":5
      },{
         "type":CREEP,
         "wave":[["IC1","bounce",10,250,DIR.W,0,0]],
         "powerup":0,
         "level":5
      },{
         "type":CREEP,
         "wave":[["IC1","bounce",10,250,DIR.S,0,0]],
         "powerup":0,
         "level":5
      },{
         "type":CREEP,
         "wave":[["IC1","bounce",10,250,DIR.E,0,0]],
         "powerup":0,
         "level":5
      },30,{
         "type":CREEP,
         "wave":[["IC1","bounce",10,250,DIR.N,0,0]],
         "powerup":0,
         "level":4
      },{
         "type":CREEP,
         "wave":[["IC1","bounce",10,250,DIR.W,0,0]],
         "powerup":0,
         "level":4
      },{
         "type":CREEP,
         "wave":[["IC1","bounce",10,250,DIR.S,0,0]],
         "powerup":0,
         "level":4
      },{
         "type":CREEP,
         "wave":[["IC1","bounce",10,250,DIR.E,0,0]],
         "powerup":0,
         "level":4
      },30,{
         "type":CREEP,
         "wave":[["IC1","bounce",10,250,DIR.N,0,0]],
         "powerup":0,
         "level":4
      },{
         "type":CREEP,
         "wave":[["IC1","bounce",10,250,DIR.W,0,0]],
         "powerup":0,
         "level":4
      },{
         "type":CREEP,
         "wave":[["IC1","bounce",10,250,DIR.S,0,0]],
         "powerup":0,
         "level":4
      },{
         "type":CREEP,
         "wave":[["IC1","bounce",10,250,DIR.E,0,0]],
         "powerup":0,
         "level":4
      }],[{
         "type":CREEP,
         "wave":[["IC4","bounce",10,250,DIR.N,0,1]],
         "powerup":0,
         "level":4
      },{
         "type":CREEP,
         "wave":[["IC4","bounce",10,250,DIR.W,0,0]],
         "powerup":0,
         "level":4
      },{
         "type":CREEP,
         "wave":[["IC4","bounce",10,250,DIR.S,0,0]],
         "powerup":0,
         "level":4
      },{
         "type":CREEP,
         "wave":[["IC4","bounce",10,250,DIR.E,0,0]],
         "powerup":0,
         "level":4
      },15,{
         "type":CREEP,
         "wave":[["IC5","bounce",10,250,DIR.N,0,0]],
         "powerup":0,
         "level":4
      },{
         "type":CREEP,
         "wave":[["IC5","bounce",10,250,DIR.W,0,0]],
         "powerup":0,
         "level":4
      },{
         "type":CREEP,
         "wave":[["IC5","bounce",10,250,DIR.S,0,0]],
         "powerup":0,
         "level":4
      },{
         "type":CREEP,
         "wave":[["IC5","bounce",10,250,DIR.E,0,0]],
         "powerup":0,
         "level":4
      },15,{
         "type":CREEP,
         "wave":[["IC2","bounce",10,250,DIR.N,0,1]],
         "powerup":0,
         "rage":30,
         "level":4
      },{
         "type":CREEP,
         "wave":[["IC2","bounce",10,250,DIR.W,0,0]],
         "powerup":0,
         "rage":30,
         "level":4
      },{
         "type":CREEP,
         "wave":[["IC2","bounce",10,250,DIR.S,0,0]],
         "powerup":0,
         "rage":30,
         "level":4
      },{
         "type":CREEP,
         "wave":[["IC2","bounce",10,250,DIR.E,0,0]],
         "powerup":0,
         "rage":30,
         "level":4
      },5,{
         "type":CREEP,
         "wave":[["IC7","bounce",5,250,DIR.N,0,0]],
         "powerup":0,
         "level":1
      },{
         "type":CREEP,
         "wave":[["IC7","bounce",5,250,DIR.S,0,0]],
         "powerup":0,
         "level":1
      },30,{
         "type":CREEP,
         "wave":[["IC6","bounce",5,250,DIR.N,0,1]],
         "powerup":0,
         "level":1
      },{
         "type":CREEP,
         "wave":[["IC6","bounce",5,250,DIR.S,0,0]],
         "powerup":0,
         "level":1
      },30,{
         "type":CREEP,
         "wave":[["IC8","bounce",5,250,DIR.N,0,1]],
         "powerup":0,
         "rage":30,
         "level":1
      },{
         "type":CREEP,
         "wave":[["IC8","bounce",5,250,DIR.S,0,0]],
         "powerup":0,
         "rage":30,
         "level":1
      }],[{
         "type":CREEP,
         "wave":[["IC6","bounce",30,250,DIR.N,0,1]],
         "powerup":0,
         "rage":45,
         "level":6
      },30,{
         "type":CREEP,
         "wave":[["IC5","bounce",60,250,DIR.N,0,1]],
         "powerup":0,
         "level":6
      }],[{
         "type":CREEP,
         "wave":[["IC2","bounce",30,250,DIR.S,0,1]],
         "powerup":0,
         "level":6
      },2,{
         "type":CREEP,
         "wave":[["IC2","bounce",30,250,DIR.E,0,0]],
         "powerup":0,
         "level":6
      },2,{
         "type":CREEP,
         "wave":[["IC2","bounce",30,250,DIR.N,0,0]],
         "powerup":0,
         "level":6
      },2,{
         "type":CREEP,
         "wave":[["IC2","bounce",30,250,DIR.W,0,0]],
         "powerup":0,
         "level":6
      },10,{
         "type":CREEP,
         "wave":[["IC7","bounce",15,250,DIR.S,0,0]],
         "powerup":0,
         "level":3
      },2,{
         "type":CREEP,
         "wave":[["IC7","bounce",15,250,DIR.E,0,0]],
         "powerup":0,
         "level":3
      },2,{
         "type":CREEP,
         "wave":[["IC7","bounce",15,250,DIR.N,0,0]],
         "powerup":0,
         "level":3
      },2,{
         "type":CREEP,
         "wave":[["IC7","bounce",15,250,DIR.W,0,0]],
         "powerup":0,
         "level":3
      },45,{
         "type":CREEP,
         "wave":[["IC6","bounce",25,250,DIR.S,0,1]],
         "powerup":0,
         "level":6
      },2,{
         "type":CREEP,
         "wave":[["IC6","bounce",25,250,DIR.E,0,0]],
         "powerup":0,
         "level":6
      },2,{
         "type":CREEP,
         "wave":[["IC6","bounce",25,250,DIR.N,0,0]],
         "powerup":0,
         "level":6
      },2,{
         "type":CREEP,
         "wave":[["IC6","bounce",25,250,DIR.W,0,0]],
         "powerup":0,
         "level":6
      },10],[{
         "type":CREEP,
         "wave":[["IC8","bounce",20,250,DIR.E,0,1]],
         "powerup":0,
         "level":3
      },15,{
         "type":CREEP,
         "wave":[["IC8","bounce",20,250,DIR.E,0,1]],
         "powerup":0,
         "level":3
      },15,{
         "type":CREEP,
         "wave":[["IC8","bounce",20,250,DIR.E,0,1]],
         "powerup":0,
         "level":3
      },15,{
         "type":CREEP,
         "wave":[["IC5","bounce",30,250,DIR.E,0,1]],
         "powerup":0,
         "level":3
      }],[{
         "type":CREEP,
         "wave":[["IC2","bounce",25,250,DIR.N,0,1]],
         "powerup":0,
         "level":6
      },5,{
         "type":CREEP,
         "wave":[["IC2","bounce",25,250,DIR.S,0,0]],
         "powerup":0,
         "level":6
      },5,{
         "type":CREEP,
         "wave":[["IC2","bounce",25,250,DIR.E,0,0]],
         "powerup":0,
         "level":6
      },5,{
         "type":CREEP,
         "wave":[["IC2","bounce",25,250,DIR.W,0,0]],
         "powerup":0,
         "level":6
      },15,{
         "type":CREEP,
         "wave":[["IC5","bounce",20,250,DIR.N,0,1]],
         "powerup":0,
         "level":6
      },5,{
         "type":CREEP,
         "wave":[["IC7","bounce",30,250,DIR.N,0,1]],
         "powerup":0,
         "rage":45,
         "level":6
      },15,{
         "type":CREEP,
         "wave":[["IC6","bounce",30,250,DIR.N,0,1]],
         "powerup":0,
         "level":6
      },15,{
         "type":CREEP,
         "wave":[["IC6","bounce",30,250,DIR.N,0,1]],
         "powerup":0,
         "level":6
      }],[{
         "type":CREEP,
         "wave":[["IC2","bounce",60,250,DIR.N,0,1]],
         "powerup":0,
         "rage":30,
         "level":6
      },20,{
         "type":CREEP,
         "wave":[["IC8","bounce",30,250,DIR.N,0,0]],
         "powerup":0,
         "rage":25,
         "level":3
      }],[{
         "type":CREEP,
         "wave":[["IC1","bounce",40,250,DIR.N,0,1]],
         "powerup":0,
         "level":6
      },15,{
         "type":CREEP,
         "wave":[["IC1","bounce",40,250,DIR.N,0,0]],
         "powerup":0,
         "level":6
      },15,{
         "type":CREEP,
         "wave":[["IC2","bounce",30,250,DIR.N,0,1]],
         "powerup":0,
         "rage":25,
         "level":6
      },15,{
         "type":CREEP,
         "wave":[["IC7","bounce",20,250,DIR.N,0,1]],
         "powerup":0,
         "level":6
      },15,{
         "type":CREEP,
         "wave":[["IC8","bounce",10,250,DIR.N,0,1]],
         "powerup":0,
         "rage":45,
         "level":6
      },15,{
         "type":CREEP,
         "wave":[["IC8","bounce",10,250,DIR.N,0,1]],
         "powerup":0,
         "rage":45,
         "level":6
      }],[{
         "type":CREEP,
         "wave":[["IC4","bounce",20,250,DIR.N,0,1]],
         "powerup":3,
         "rage":20,
         "level":6
      },15,{
         "type":CREEP,
         "wave":[["IC4","bounce",20,250,DIR.N,0,1]],
         "powerup":3,
         "rage":20,
         "level":6
      },15,{
         "type":CREEP,
         "wave":[["IC4","bounce",20,250,DIR.N,0,1]],
         "powerup":3,
         "rage":20,
         "level":6
      },15,{
         "type":CREEP,
         "wave":[["IC4","bounce",20,250,DIR.N,0,1]],
         "powerup":3,
         "rage":20,
         "level":6
      },15,{
         "type":CREEP,
         "wave":[["IC8","bounce",10,250,DIR.N,0,0]],
         "powerup":3,
         "rage":30,
         "level":6
      },{
         "type":CREEP,
         "wave":[["IC8","bounce",10,250,DIR.S,0,0]],
         "powerup":3,
         "rage":30,
         "level":6
      },{
         "type":CREEP,
         "wave":[["IC8","bounce",10,250,DIR.E,0,0]],
         "powerup":3,
         "rage":30,
         "level":6
      }],[{
         "type":CREEP,
         "wave":[["IC7","bounce",20,250,DIR.N,0,1]],
         "powerup":3,
         "level":6
      },10,{
         "type":CREEP,
         "wave":[["IC7","bounce",20,250,DIR.N,0,1]],
         "powerup":3,
         "level":6
      },10,{
         "type":CREEP,
         "wave":[["IC7","bounce",20,250,DIR.N,0,1]],
         "powerup":3,
         "level":6
      },10,{
         "type":CREEP,
         "wave":[["IC7","bounce",20,250,DIR.N,0,1]],
         "powerup":3,
         "level":6
      },30,{
         "type":CREEP,
         "wave":[["IC8","bounce",20,250,DIR.N,0,1]],
         "powerup":3,
         "rage":30,
         "level":6
      },10,{
         "type":CREEP,
         "wave":[["IC8","bounce",20,250,DIR.N,0,1]],
         "powerup":3,
         "rage":30,
         "level":6
      }],[{
         "type":CREEP,
         "wave":[["IC8","bounce",5,250,DIR.N,0,1]],
         "powerup":3,
         "rage":30,
         "level":6
      },15,{
         "type":CREEP,
         "wave":[["IC8","bounce",5,250,DIR.E,0,1]],
         "powerup":3,
         "rage":30,
         "level":6
      },15,{
         "type":CREEP,
         "wave":[["IC8","bounce",5,250,DIR.S,0,1]],
         "powerup":3,
         "rage":30,
         "level":6
      },15,{
         "type":CREEP,
         "wave":[["IC8","bounce",5,250,DIR.W,0,1]],
         "powerup":3,
         "rage":30,
         "level":6
      },15,{
         "type":CREEP,
         "wave":[["IC8","bounce",5,250,DIR.N,0,1]],
         "powerup":3,
         "rage":30,
         "level":6
      },15,{
         "type":CREEP,
         "wave":[["IC8","bounce",5,250,DIR.E,0,1]],
         "powerup":3,
         "rage":30,
         "level":6
      },15,{
         "type":CREEP,
         "wave":[["IC8","bounce",5,250,DIR.S,0,1]],
         "powerup":3,
         "rage":30,
         "level":6
      },15,{
         "type":CREEP,
         "wave":[["IC8","bounce",5,250,DIR.W,0,1]],
         "powerup":3,
         "rage":30,
         "level":6
      },15,{
         "type":CREEP,
         "wave":[["IC8","bounce",5,250,DIR.N,0,1]],
         "powerup":3,
         "rage":30,
         "level":6
      },15,{
         "type":CREEP,
         "wave":[["IC8","bounce",5,250,DIR.E,0,1]],
         "powerup":3,
         "rage":30,
         "level":6
      },15,{
         "type":CREEP,
         "wave":[["IC8","bounce",5,250,DIR.S,0,1]],
         "powerup":3,
         "rage":30,
         "level":6
      },15,{
         "type":CREEP,
         "wave":[["IC8","bounce",5,250,DIR.W,0,1]],
         "powerup":3,
         "rage":30,
         "level":6
      },15,{
         "type":CREEP,
         "wave":[["IC8","bounce",5,250,DIR.N,0,1]],
         "powerup":3,
         "rage":30,
         "level":6
      },15,{
         "type":CREEP,
         "wave":[["IC8","bounce",5,250,DIR.E,0,1]],
         "powerup":3,
         "rage":30,
         "level":6
      },15,{
         "type":CREEP,
         "wave":[["IC8","bounce",5,250,DIR.S,0,1]],
         "powerup":3,
         "rage":30,
         "level":6
      }],[{
         "type":CREEP,
         "wave":[["IC7","bounce",10,250,DIR.N,0,1]],
         "powerup":3,
         "rage":45,
         "level":6
      },1,{
         "type":CREEP,
         "wave":[["IC7","bounce",10,250,DIR.N,0,0]],
         "powerup":3,
         "rage":45,
         "level":6
      },1,{
         "type":CREEP,
         "wave":[["IC7","bounce",10,250,DIR.N,0,0]],
         "powerup":3,
         "rage":45,
         "level":6
      },1,{
         "type":CREEP,
         "wave":[["IC7","bounce",10,250,DIR.N,0,0]],
         "powerup":3,
         "rage":45,
         "level":6
      },30,{
         "type":CREEP,
         "wave":[["IC6","bounce",5,250,DIR.N,0,1]],
         "powerup":3,
         "rage":30,
         "level":6
      },2,{
         "type":CREEP,
         "wave":[["IC6","bounce",5,250,DIR.E,0,0]],
         "powerup":3,
         "rage":30,
         "level":6
      },2,{
         "type":CREEP,
         "wave":[["IC6","bounce",5,250,DIR.S,0,0]],
         "powerup":3,
         "rage":30,
         "level":6
      },2,{
         "type":CREEP,
         "wave":[["IC6","bounce",5,250,DIR.W,0,0]],
         "powerup":3,
         "rage":30,
         "level":6
      },2,{
         "type":CREEP,
         "wave":[["IC6","bounce",5,250,DIR.N,0,0]],
         "powerup":3,
         "rage":30,
         "level":6
      },2,{
         "type":CREEP,
         "wave":[["IC6","bounce",5,250,DIR.E,0,0]],
         "powerup":3,
         "rage":30,
         "level":6
      },2,{
         "type":CREEP,
         "wave":[["IC6","bounce",5,250,DIR.S,0,0]],
         "powerup":3,
         "rage":30,
         "level":6
      },2,{
         "type":CREEP,
         "wave":[["IC6","bounce",5,250,DIR.W,0,0]],
         "powerup":3,
         "rage":30,
         "level":6
      },2,{
         "type":CREEP,
         "wave":[["IC6","bounce",5,250,DIR.N,0,0]],
         "powerup":3,
         "rage":30,
         "level":6
      },2,{
         "type":CREEP,
         "wave":[["IC6","bounce",5,250,DIR.E,0,0]],
         "powerup":3,
         "rage":30,
         "level":6
      },2,{
         "type":CREEP,
         "wave":[["IC6","bounce",5,250,DIR.S,0,0]],
         "powerup":3,
         "rage":30,
         "level":6
      },2,{
         "type":CREEP,
         "wave":[["IC6","bounce",5,250,DIR.W,0,0]],
         "powerup":3,
         "rage":30,
         "level":6
      },2,{
         "type":CREEP,
         "wave":[["IC6","bounce",5,250,DIR.N,0,0]],
         "powerup":3,
         "rage":30,
         "level":6
      },2,{
         "type":CREEP,
         "wave":[["IC6","bounce",5,250,DIR.E,0,0]],
         "powerup":3,
         "rage":30,
         "level":6
      },2,{
         "type":CREEP,
         "wave":[["IC6","bounce",5,250,DIR.E,0,0]],
         "powerup":3,
         "rage":30,
         "level":6
      },2,{
         "type":CREEP,
         "wave":[["IC6","bounce",5,250,DIR.S,0,0]],
         "powerup":3,
         "rage":30,
         "level":6
      },60,{
         "type":CREEP,
         "wave":[["IC8","bounce",32,250,DIR.N,0,1]],
         "powerup":3,
         "rage":30,
         "level":6
      }],[{
         "type":CREEP,
         "wave":[["IC2","bounce",25,250,DIR.N,0,1]],
         "powerup":3,
         "rage":45,
         "level":6
      },1,{
         "type":CREEP,
         "wave":[["IC2","bounce",25,250,DIR.E,0,0]],
         "powerup":3,
         "rage":45,
         "level":6
      },1,{
         "type":CREEP,
         "wave":[["IC2","bounce",25,250,DIR.S,0,0]],
         "powerup":3,
         "rage":45,
         "level":6
      },1,{
         "type":CREEP,
         "wave":[["IC2","bounce",25,250,DIR.W,0,0]],
         "powerup":3,
         "rage":45,
         "level":6
      },45,{
         "type":CREEP,
         "wave":[["IC5","bounce",6,400,DIR.N,0,0]],
         "powerup":0,
         "rage":35,
         "level":6
      },1,{
         "type":CREEP,
         "wave":[["IC5","bounce",6,400,DIR.E,0,0]],
         "powerup":0,
         "rage":35,
         "level":6
      },1,{
         "type":CREEP,
         "wave":[["IC5","bounce",6,400,DIR.S,0,0]],
         "powerup":0,
         "rage":35,
         "level":6
      },1,{
         "type":CREEP,
         "wave":[["IC5","bounce",6,400,DIR.W,0,0]],
         "powerup":0,
         "rage":35,
         "level":6
      },1,{
         "type":CREEP,
         "wave":[["IC7","bounce",10,250,DIR.N,0,1]],
         "powerup":3,
         "rage":30,
         "level":6
      },1,{
         "type":CREEP,
         "wave":[["IC7","bounce",10,250,DIR.E,0,0]],
         "powerup":3,
         "rage":30,
         "level":6
      },1,{
         "type":CREEP,
         "wave":[["IC7","bounce",10,250,DIR.S,0,0]],
         "powerup":3,
         "rage":30,
         "level":6
      },1,{
         "type":CREEP,
         "wave":[["IC7","bounce",10,250,DIR.W,0,0]],
         "powerup":3,
         "rage":30,
         "level":6
      },40,{
         "type":CREEP,
         "wave":[["IC3","bounce",50,400,DIR.N,0,1]],
         "powerup":0,
         "rage":30,
         "level":1
      },2,{
         "type":CREEP,
         "wave":[["IC3","bounce",50,400,DIR.S,0,0]],
         "powerup":0,
         "rage":30,
         "level":1
      },2,{
         "type":CREEP,
         "wave":[["IC3","bounce",50,400,DIR.W,0,0]],
         "powerup":0,
         "rage":30,
         "level":1
      },2,{
         "type":CREEP,
         "wave":[["IC3","bounce",50,400,DIR.E,0,0]],
         "powerup":0,
         "rage":30,
         "level":1
      },45,{
         "type":CREEP,
         "wave":[["IC8","bounce",10,250,DIR.N,0,1]],
         "powerup":3,
         "rage":30,
         "level":6
      },1,{
         "type":CREEP,
         "wave":[["IC8","bounce",10,250,DIR.E,0,0]],
         "powerup":3,
         "rage":30,
         "level":6
      },1,{
         "type":CREEP,
         "wave":[["IC8","bounce",10,250,DIR.S,0,0]],
         "powerup":3,
         "rage":30,
         "level":6
      },1,{
         "type":CREEP,
         "wave":[["IC8","bounce",10,250,DIR.W,0,0]],
         "powerup":3,
         "rage":30,
         "level":6
      }],[{
         "type":CREEP,
         "wave":[["IC4","bounce",12,250,DIR.N,0,1]],
         "powerup":3,
         "rage":20,
         "level":6
      },5,{
         "type":CREEP,
         "wave":[["IC4","bounce",12,250,DIR.N,0,1]],
         "powerup":3,
         "rage":20,
         "level":6
      },5,{
         "type":CREEP,
         "wave":[["IC4","bounce",12,250,DIR.N,0,1]],
         "powerup":3,
         "rage":20,
         "level":6
      },5,{
         "type":CREEP,
         "wave":[["IC4","bounce",12,250,DIR.N,0,1]],
         "powerup":3,
         "rage":20,
         "level":6
      },25,{
         "type":CREEP,
         "wave":[["IC1","bounce",50,250,DIR.N,0,1]],
         "powerup":3,
         "rage":30,
         "level":6
      },5,{
         "type":CREEP,
         "wave":[["IC1","bounce",50,250,DIR.S,0,0]],
         "powerup":3,
         "rage":30,
         "level":6
      },5,{
         "type":CREEP,
         "wave":[["IC1","bounce",50,250,DIR.E,0,0]],
         "powerup":3,
         "rage":30,
         "level":6
      },5,{
         "type":CREEP,
         "wave":[["IC1","bounce",50,250,DIR.W,0,0]],
         "powerup":3,
         "rage":30,
         "level":6
      },60,{
         "type":CREEP,
         "wave":[["IC5","bounce",25,400,DIR.W,0,0]],
         "powerup":0,
         "rage":35,
         "level":6
      },{
         "type":CREEP,
         "wave":[["IC5","bounce",25,400,DIR.E,0,0]],
         "powerup":0,
         "rage":35,
         "level":6
      },45,{
         "type":CREEP,
         "wave":[["IC7","bounce",15,250,DIR.N,0,1]],
         "powerup":3,
         "rage":45,
         "level":6
      },1,{
         "type":CREEP,
         "wave":[["IC7","bounce",15,250,DIR.N,0,0]],
         "powerup":3,
         "rage":45,
         "level":6
      },1,{
         "type":CREEP,
         "wave":[["IC7","bounce",15,250,DIR.N,0,0]],
         "powerup":3,
         "rage":45,
         "level":6
      },1,{
         "type":CREEP,
         "wave":[["IC7","bounce",15,250,DIR.N,0,0]],
         "powerup":3,
         "rage":45,
         "level":6
      },40,{
         "type":CREEP,
         "wave":[["IC6","bounce",5,250,DIR.N,0,1]],
         "powerup":3,
         "rage":15,
         "level":6
      },5,{
         "type":CREEP,
         "wave":[["IC6","bounce",5,250,DIR.E,0,0]],
         "powerup":3,
         "rage":15,
         "level":6
      },5,{
         "type":CREEP,
         "wave":[["IC6","bounce",5,250,DIR.S,0,0]],
         "powerup":3,
         "rage":15,
         "level":6
      },5,{
         "type":CREEP,
         "wave":[["IC6","bounce",5,250,DIR.W,0,0]],
         "powerup":3,
         "rage":15,
         "level":6
      },5,{
         "type":CREEP,
         "wave":[["IC6","bounce",5,250,DIR.N,0,0]],
         "powerup":3,
         "rage":15,
         "level":6
      },5,{
         "type":CREEP,
         "wave":[["IC6","bounce",5,250,DIR.E,0,0]],
         "powerup":3,
         "rage":15,
         "level":6
      },5,{
         "type":CREEP,
         "wave":[["IC6","bounce",5,250,DIR.S,0,0]],
         "powerup":3,
         "rage":15,
         "level":6
      },5,{
         "type":CREEP,
         "wave":[["IC6","bounce",5,250,DIR.W,0,0]],
         "powerup":3,
         "rage":15,
         "level":6
      },45,{
         "type":CREEP,
         "wave":[["IC8","bounce",60,250,DIR.N,0,1]],
         "powerup":3,
         "rage":45,
         "level":6
      },5]];
      
      private static const DEBUGCREATURES:Array = ["C1","C2","C3","C4","C5","C6","C7","C8","C9","C10","C11","C12","C13","C14","C15","IC1"];
       
      
      public function SPECIALEVENT()
      {
         super();
      }
      
      public static function Setup() : void
      {
         if(_setupCalled) return;

         if (GLOBAL._flags.activeInvasion != EnumInvasionType.WMI2) return;
                  
         _setupCalled = true;
         _wave = new SecNum(GetStat("wmi2_wave"));
         _group = 0;
         _knownFlag = invasionpop;
         InitializeTimes();
      }
      
      private static function InitializeTimes() : void
      {
         new URLLoaderApi().load(
               GLOBAL._apiURL + "events/wmi?type=wmi2",
               null,
               function(serverData:Object):void
               {
                  if (serverData)
                  {
                     _eventStartTime = new SecNum(serverData.start);
                     _eventEndTime = new SecNum(_eventStartTime.Get() + 60 * 60 * 24 * 7);
                  }
               }
            );
      }

      // Use server-provided activeInvasion flag to determine which event should be active
      public static function getActiveSpecialEvent() : * 
      {
         if (GLOBAL._flags.activeInvasion == EnumInvasionType.WMI1) 
            return SPECIALEVENT_WM1;

         return SPECIALEVENT;
      }
      
      public static function updateNextWaveUI() : void
      {
         if(UI_BOTTOM._nextwave)
         {
            UI_BOTTOM._nextwave.visible = false;
         }
         if(UI_BOTTOM._nextwave_wm1)
         {
            UI_BOTTOM._nextwave_wm1.visible = false;
         }
         
         var activeEvent:* = getActiveSpecialEvent();
         if(activeEvent)
         {
            if(activeEvent == SPECIALEVENT && UI_BOTTOM._nextwave && UI_NEXTWAVE.ShouldDisplay())
            {
               UI_BOTTOM._nextwave.visible = true;
            }
            else if(activeEvent == SPECIALEVENT_WM1 && UI_BOTTOM._nextwave_wm1 && UI_NEXTWAVE_WM1.ShouldDisplay())
            {
               UI_BOTTOM._nextwave_wm1.visible = true;
            }
         }
      }
      
      public static function updateWaveDisplay(waveNumber:int) : void
      {
         var activeEvent:* = getActiveSpecialEvent();
         if(activeEvent == SPECIALEVENT && UI_BOTTOM._nextwave)
         {
            UI_BOTTOM._nextwave.SetWave(waveNumber);
         }
         else if(activeEvent == SPECIALEVENT_WM1 && UI_BOTTOM._nextwave_wm1)
         {
            UI_BOTTOM._nextwave_wm1.SetWave(waveNumber);
         }
      }
      
      public static function StartRound() : void
      {
         if(_active)
         {
            return;
         }
         _active = true;
         if(_wave.Get() == -1)
         {
            _wave.Set(SPECIALEVENT.GetStat("wmi2_wave"));
         }
         _group = 0;
         _currentAttackers = new Array();
         _retreatAllMonsters = false;
         _randomDirection = Math.floor(Math.random() * 4) * 90;
         LOGGER.Stat([83,_wave.Get()]);
         SendWave();
      }
      
      public static function EndRound(param1:Boolean, param2:Boolean = false) : void
      {
         var _loc3_:MovieClip = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Vector.<Object> = null;
         var _loc8_:BFOUNDATION = null;
         if(param1)
         {
            LOGGER.Stat([84,_wave.Get()]);
            StartRepairs();
            if(isMajorWave(wave) && wave != 1)
            {
               BTOTEM.UpgradeTotem();
            }
            _loc3_ = new WMIROUNDCOMPLETE(wave);
            POPUPS.Push(_loc3_,null,null,null,null,false,"now");
            _wave.Add(1);
            SPECIALEVENT.updateWaveDisplay(wave);
            SetStat("wmi2_wave",_wave.Get());
         }
         else
         {
            LOGGER.Stat([85,_wave.Get()]);
            StartRepairs();
            _loc3_ = new WMIROUNDCOMPLETE(-1,param2);
            POPUPS.Push(_loc3_,null,null,null,null,false,"now");
         }
         if(GLOBAL._aiDesignMode)
         {
            _loc4_ = 0;
            _loc5_ = 0;
            _loc7_ = InstanceManager.getInstancesByClass(BFOUNDATION);
            for each(_loc8_ in _loc7_)
            {
               if(_loc8_._class != "wall" && (_loc8_._type == 53 && _loc8_._expireTime < GLOBAL.Timestamp()) === false && (_loc8_._class == "trap" && _loc8_._fired) === false)
               {
                  _loc4_ += _loc8_.health;
                  _loc5_ += _loc8_.maxHealth;
               }
            }
            _loc6_ = 100 - 100 / _loc5_ * _loc4_;
            GLOBAL.Message("Base is " + _loc6_ + " percent destroyed.");
         }
         ClearWildMonsterPowerups();
         _active = false;
      }
      
      public static function Surrender() : void
      {
         _retreatAllMonsters = true;
         _timeOfNextWave = -1;
         EndRound(false,true);
      }
      
      private static function StartRepairs() : void
      {
         var _loc2_:BFOUNDATION = null;
         var _loc1_:Vector.<Object> = InstanceManager.getInstancesByClass(BFOUNDATION);
         for each(_loc2_ in _loc1_)
         {
            if(_loc2_.health < _loc2_.maxHealth && _loc2_._repairing == 0)
            {
               _loc2_.Repair();
            }
         }
      }
      
      private static function SendWave() : void
      {
         var _loc1_:Array = null;
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Array = null;
         var _loc7_:Object = null;
         var _loc8_:Number = NaN;
         var _loc9_:Point = null;
         var _loc10_:ChampionBase = null;
         if(_wave.Get() >= WAVES.length)
         {
            return;
         }
         if(BASE.isInfernoMainYardOrOutpost)
         {
            SOUNDS.PlayMusic("musicipanic");
         }
         else
         {
            SOUNDS.PlayMusic("musicpanic");
         }
         _spawningWaves = true;
         switch(WAVES[_wave.Get()][_group].type)
         {
            case CREEP:
               _loc1_ = WAVES[_wave.Get()][_group].wave;
               _loc2_ = String(_loc1_[0][0]);
               _loc3_ = int(WAVES[_wave.Get()][_group].powerup);
               _loc4_ = int(WAVES[_wave.Get()][_group].level);
               _loc5_ = int(WAVES[_wave.Get()][_group].rage);
               GLOBAL._wmCreaturePowerups[_loc2_] = _loc3_;
               GLOBAL._wmCreatureLevels[_loc2_] = _loc4_;
               _loc1_[0][4] = (_loc1_[0][4] + _randomDirection) % 360;
               _loc1_[0][3] = GLOBAL._mapWidth * 0.25;
               if(_loc5_)
               {
                  WMATTACK._rage = _loc5_;
               }
               _loc6_ = CUSTOMATTACKS.WMIAttack(_loc1_);
               if(_loc5_)
               {
                  WMATTACK._rage = 0;
               }
               _currentAttackers = _currentAttackers.concat(_loc6_);
               break;
            case GUARDIAN:
               _loc8_ = ((_loc7_ = WAVES[_wave.Get()][_group]).angle + _randomDirection) % 360;
               _loc9_ = GRID.ToISO(Math.cos(_loc8_ * 0.0174532925) * 900,Math.sin(_loc8_ * 0.0174532925) * 900,0);
               _loc10_ = CREEPS.SpawnGuardian(_loc7_.guardianID,MAP._BUILDINGTOPS,"bounce",_loc7_.level,_loc9_,_loc7_.direction,_loc7_.health,_loc7_.foodbonus,0,true);
               _currentAttackers.push([_loc10_]);
         }
         _timeOfNextWave = GLOBAL.Timestamp();
         while(++_group < WAVES[_wave.Get()].length && Boolean(WAVES[_wave.Get()][_group] as Number))
         {
            _timeOfNextWave += WAVES[_wave.Get()][_group];
         }
         if(_group >= WAVES[_wave.Get()].length)
         {
            _spawningWaves = false;
            _timeOfNextWave = -1;
         }
         updateWarningText();
      }
      
      public static function isMajorWave(param1:int) : Boolean
      {
         switch(param1)
         {
            case 1:
            case 10:
            case 20:
            case 30:
            case 31:
            case 32:
               return true;
            default:
               return false;
         }
      }
      
      private static function updateWarningText() : void
      {
         var _loc1_:String = KEYS.Get("wmi_warning",{"v1":String(wave)});
         if(wave == BONUSWAVE)
         {
            _loc1_ = KEYS.Get("wmi_warningbonus");
         }
         else if(wave == BONUSWAVE2)
         {
            _loc1_ = KEYS.Get("wmi_warningbonus2");
         }
         UI2._warning.Update("<font size=\"26\">" + _loc1_ + "</font>");
      }
      
      public static function ClearWildMonsterPowerups() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         for each(_loc1_ in GLOBAL._wmCreaturePowerups)
         {
            _loc1_ = 0;
         }
         for each(_loc2_ in GLOBAL._wmCreatureLevels)
         {
            _loc2_ = 0;
         }
      }
      
      public static function Tick() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Array = null;
         var _loc3_:uint = 0;
         if(Boolean(GLOBAL._flags.viximo) || Boolean(GLOBAL._flags.kongregate))
         {
            return;
         }
         if(!BASE.isMainYard)
         {
            return;
         }
         if(GLOBAL.Timestamp() == _lastTimestamp)
         {
            return;
         }
         _lastTimestamp = GLOBAL.Timestamp();
         if(_knownFlag != invasionpop)
         {
            FlagChanged();
         }
         if(_retreatAllMonsters)
         {
            _loc1_ = 0;
            for each(_loc2_ in _currentAttackers)
            {
               _loc3_ = 0;
               while(_loc3_ < _loc2_.length)
               {
                  if(_loc2_[_loc3_]._behaviour != "retreat")
                  {
                     _loc1_++;
                     // Original implementation had a ModeRetreat function
                     // _loc2_[_loc3_].ModeRetreat();
                     _loc2_[_loc3_].changeModeRetreat();
                  }
                  _loc3_++;
               }
            }
            if(_loc1_ == 0)
            {
               _retreatAllMonsters = false;
            }
         }
         if(_timeOfNextWave == -1)
         {
            return;
         }
         if(_active)
         {
            GLOBAL.UpdateAFKTimer();
         }
         if(GLOBAL.Timestamp() >= _timeOfNextWave || CREEPS._creepCount == 0)
         {
            SendWave();
         }
      }
      
      public static function MonstersRetreating() : Boolean
      {
         return _retreatAllMonsters || CREEPS._creepCount > 0;
      }
      
      public static function GetTimeUntilStart() : Number
      {
         return _eventStartTime.Get() - GLOBAL.Timestamp();
      }
      
      public static function GetTimeUntilEnd() : Number
      {
         return _eventEndTime.Get() - GLOBAL.Timestamp();
      }
      
      public static function TimerClicked(param1:MouseEvent) : void
      {
         if(!_active)
         {
            ShowDefenseEventPopup("now");
         }
      }
      
      public static function ShowDefenseEventPopup(param1:String) : void
      {
         var _loc2_:MovieClip = null;
         if(!WMIROUNDCOMPLETE.open && !DEFENSEEVENTPOPUP.open && !WMIEXTENSIONPOPUP.open && !_active)
         {
            _loc2_ = null;
            if(invasionpop == 4)
            {
               _loc2_ = new WMIEXTENSIONPOPUP();
            }
            else
            {
               _loc2_ = new DEFENSEEVENTPOPUP(invasionpop);
            }
            POPUPS.Push(_loc2_,null,null,null,null,false,param1);
            SetStat("lasttdpopup",invasionpop);
         }
      }
      
      public static function ShowEventEndPopup() : void
      {
         var _loc1_:MovieClip = null;
         if(!WMIROUNDCOMPLETE.open && !DEFENSEEVENTPOPUP.open && !WMIEXTENSIONPOPUP.open && !_active)
         {
            _loc1_ = new WMIROUNDCOMPLETE(EVENTEND);
            POPUPS.Push(_loc1_,null,null,null,null,false,"now");
            SPECIALEVENT.SetStat("wmi_end",1);
         }
      }
      
      public static function EventActive() : Boolean
      {
         if(!BASE.isMainYard)
         {
            return false;
         }
         if(ACTIVE_OVERRIDE)
         {
            return true;
         }
         if(SPECIALEVENT_WM1.EventActive())
         {
            return false;
         }
         return SPECIALEVENT.invasionpop == 4;
      }
      
      public static function get invasionpop() : Number
      {
         if(_eventStartTime.Get() <= 0)
         {
            return -1;
         }
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < TIME_OFFSETS.length)
         {
            if(GLOBAL.Timestamp() < _eventStartTime.Get() + TIME_OFFSETS[_loc1_].Get())
            {
               return _loc1_;
            }
            _loc1_++;
         }
         return 0;
      }
      
      public static function AllWavesSpawned() : Boolean
      {
         return !_spawningWaves;
      }
      
      public static function FlagChanged() : void
      {
         if(!_whatsNewComplete)
         {
            return;
         }
         if(GLOBAL.mode != GLOBAL.e_BASE_MODE.BUILD || !BASE.isMainYard || TUTORIAL._stage <= 200 || GLOBAL._sessionCount < 5)
         {
            return;
         }
         _knownFlag = invasionpop;
         switch(_knownFlag)
         {
            case -1:
               if(GetStat("lasttdpopup") != 0)
               {
                  SetStat("lasttdpopup",0);
               }
               break;
            case 1:
            case 2:
            case 3:
            case 4:
               if(GetStat("lasttdpopup") < _knownFlag)
               {
                  ShowDefenseEventPopup("now");
               }
         }
      }
      
      public static function DEBUGOVERRIDEWAVE(param1:int) : void
      {
         _wave.Set(param1);
         SPECIALEVENT.updateWaveDisplay(param1);
      }
      
      public static function DebugToggleActive(param1:Boolean) : void
      {
         _active = param1;
      }
      
      public static function DebugSetRound(param1:Number) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:String = null;
         ClearWildMonsterPowerups();
         switch(param1)
         {
            case 1:
               _loc2_ = 0;
               _loc3_ = 1;
               for each(_loc4_ in DEBUGCREATURES)
               {
                  GLOBAL._wmCreatureLevels[_loc4_] = _loc3_;
               }
               for each(_loc4_ in DEBUGCREATURES)
               {
                  GLOBAL._wmCreaturePowerups[_loc4_] = _loc2_;
               }
               break;
            case 2:
               _loc2_ = 0;
               _loc3_ = 6;
               for each(_loc4_ in DEBUGCREATURES)
               {
                  GLOBAL._wmCreatureLevels[_loc4_] = _loc3_;
               }
               for each(_loc4_ in DEBUGCREATURES)
               {
                  GLOBAL._wmCreaturePowerups[_loc4_] = _loc2_;
               }
               break;
            case 3:
               _loc2_ = 3;
               _loc3_ = 6;
               for each(_loc4_ in DEBUGCREATURES)
               {
                  GLOBAL._wmCreatureLevels[_loc4_] = _loc3_;
               }
               for each(_loc4_ in DEBUGCREATURES)
               {
                  GLOBAL._wmCreaturePowerups[_loc4_] = _loc2_;
               }
         }
      }
      
      public static function GetStat(param1:String) : int
      {
         var _loc2_:int = GLOBAL.StatGet(param1);
         if(_loc2_ < _eventCount.Get() * 100)
         {
            _loc2_ = 0;
         }
         else
         {
            _loc2_ %= 100;
         }
         return _loc2_;
      }
      
      public static function SetStat(param1:String, param2:int) : void
      {
         if(param2 < 0)
         {
            param2 = 0;
         }
         param2 += _eventCount.Get() * 100;
         GLOBAL.StatSet(param1,param2);
      }
      
      public static function get wave() : int
      {
         return _wave.Get() + 1;
      }
      
      public static function get active() : Boolean
      {
         return _active;
      }
      
      public static function get numWaves() : int
      {
         return WAVES.length;
      }
   }
}
