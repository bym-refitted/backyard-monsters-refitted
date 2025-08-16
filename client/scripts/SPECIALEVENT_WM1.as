package
{
   import com.monsters.ui.UI_BOTTOM;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import com.monsters.monsters.champions.ChampionBase;
   
   /*
   * This is the original SPECIALEVENT.as class for Wild Monster Invasion 1.
   * The original developers rewrote this class when Wild Monster Invasion 2 was released
   * instead of creating a new class.
   * 
   * This file archives the original implementation for reference and renamed to SPECIALEVENT_WM1.
   */
   public class SPECIALEVENT_WM1
   {
      
      private static const INVASIONPOP_OVERRIDE:int = -1;
      
      private static var _setupCalled:Boolean = false;
      
      private static var _lastTimestamp:Number = 0;
      
      private static var _round:int = -1;
      
      private static var _wave:int = 0;
      
      private static var _randomDirection:Number = 0;
      
      private static var _timeOfNextWave:Number = -1;
      
      private static var _spawningWaves:Boolean = false;
      
      private static var _active:Boolean = false;
      
      private static var _isDebug:Boolean = false;
      
      private static var _retreatAllMonsters:Boolean = false;
      
      private static var _eventStartTime:Number = -1;
      
      private static var _eventEndTime:Number = -1;
      
      private static var _eventExtensionTime:Number = -1;
      
      public static var _currentAttackers:Array = new Array();
      
      private static var _knownFlag:int = -1;
      
      public static const WONSTAGE:Array = [1,10,20,30,31,32];
      
      private static const DIR:Object = {
         "N":270,
         "S":90,
         "E":0,
         "W":180
      };
      
      private static const CREEP:int = 0;
      
      private static const GUARDIAN:int = 1;
      
      public static const BONUSWAVE:int = 31;
      
      public static const BONUSWAVE2:int = 32;
      
      public static const EVENTEND:int = 33;
      
      public static const WAVES_DESC:Array = ["<b>Wave 1</b><br>5 Octo-oozes","<b>Wave 2</b><br>4 Octo-oozes, 5 Bolts","<b>Wave 3</b><br>5 Octo-oozes, 5 Pokeys","<b>Wave 4</b><br>10 Pokeys, 10 Bolts","<b>Wave 5</b><br>10 Finks","<b>Wave 6</b><br>5 Octo-oozes, 2 Finks","<b>Wave 7</b><br>10 Ichis, 50 Bolts","<b>Wave 8</b><br>40 Pokeys, 8 Finks","<b>Wave 9</b><br>10 Octo-oozes, 10 Pokeys, 10 Finks, 10 Bolts","<b>Wave 10</b><br>8 Ichis, 8 Finks","<b>Wave 11</b><br>10 Finks, 10 Banditos, 10 ??????","<b>Wave 12</b><br>16 Ichis, 30 Banditos"
      ,"<b>Wave 13</b><br>16 Banditos, 30 Ichis","<b>Wave 14</b><br>20 Ichis, 30 Banditos, 10 Fangs","<b>Wave 15</b><br>20 Ichis, 15 Fangs","<b>Wave 16</b><br>20 Banditos, 20 Fangs","<b>Wave 17</b><br>24 Ichis, 36 Banditos, 15 Fangs","<b>Wave 18</b><br>50 Banditos, 25 Fangs","<b>Wave 19</b><br>20 Ichis, 20 Fangs, 30 Banditos","<b>Wave 20</b><br>10 Eye-ras, 40 Banditos, 10 Project X\'s, 10 Crabatrons, Drull (L1)","<b>Wave 21</b><br>30 Wormzers (Level 6, Splash Damage), 15 ??????","<b>Wave 22</b><br>20 Bolts (L3), 10 Brains (L3, Invisibility), Gorgo (L3)"
      ,"<b>Wave 23</b><br>60 Crabatrons (L6), 5 Zafreetis (L5)","<b>Wave 24</b><br>40 Pokeys (L6), 30 Ichis (L6), 20 Banditos (L6), 10 Crabatrons (L6), 5 D.A.V.E.s (L6)","<b>Wave 25</b><br>30 Eye-ras (L6, Airburst 3), 30 Bolts (L6, Teleportation 3), 30 Wormzers (L6, Splash Damage 3), 30 Finks (L6, Claws 3), 30 Banditos (L6, Whirlwind 3), 30 Fangs (L6, Venom 3), 30 Brains (L6, Invisibility 3)","<b>Wave 26</b><br>40 Eye-ras (L6, Airburst 3), 50 ?????? (L6), Drull (L6)","<b>Wave 27</b><br>30 Teratorns (L6)"
      ,"<b>Wave 28</b><br>80 Project Xs (L6, Acid Spores 3), 80 Wormzers (L6, Splash Damage 3)","<b>Wave 29</b><br>40 D.A.V.E.s (L6, Rockets 3)","<b>Wave 30</b><br>30 D.A.V.E.s (L6, Rockets 3), 30 Wormzers (L6, Splash Damage 3), 10 Zafreetis (L5), Fomor (L6)","<b>Bonus Wave</b><br>??????","<b>Bonus Wave 2</b><br>??????"];
      
      private static const WAVES:Array = [[{
         "type":CREEP,
         "wave":[["C2","bounce",5,250,DIR.N,0,1]],
         "powerup":0,
         "level":1
      }],[{
         "type":CREEP,
         "wave":[["C2","bounce",4,250,DIR.N,0,1]],
         "powerup":0,
         "level":1
      },1,{
         "type":CREEP,
         "wave":[["C3","bounce",5,250,DIR.N,0,0]],
         "powerup":0,
         "level":1
      }],[{
         "type":CREEP,
         "wave":[["C2","bounce",5,250,DIR.N,0,1]],
         "powerup":0,
         "level":1
      },1,{
         "type":CREEP,
         "wave":[["C1","bounce",5,250,DIR.N,0,0]],
         "powerup":0,
         "level":1
      }],[{
         "type":CREEP,
         "wave":[["C1","bounce",10,250,DIR.N,0,1]],
         "powerup":0,
         "level":1
      },1,{
         "type":CREEP,
         "wave":[["C3","bounce",10,250,DIR.N,0,0]],
         "powerup":0,
         "level":1
      }],[{
         "type":CREEP,
         "wave":[["C4","bounce",10,250,DIR.N,0,1]],
         "powerup":0,
         "level":1
      }],[{
         "type":CREEP,
         "wave":[["C2","bounce",5,250,DIR.N,0,1]],
         "powerup":0,
         "level":1
      },2,{
         "type":CREEP,
         "wave":[["C4","bounce",2,250,DIR.N,0,0]],
         "powerup":0,
         "level":1
      }],[{
         "type":CREEP,
         "wave":[["C6","bounce",10,250,DIR.N,0,1]],
         "powerup":0,
         "level":1
      },5,{
         "type":CREEP,
         "wave":[["C3","bounce",50,250,DIR.N,0,0]],
         "powerup":0,
         "level":1
      }],[{
         "type":CREEP,
         "wave":[["C1","bounce",40,250,DIR.N,0,1]],
         "powerup":0,
         "level":1
      },2,{
         "type":CREEP,
         "wave":[["C4","bounce",8,250,DIR.N,0,0]],
         "powerup":0,
         "level":1
      }],[{
         "type":CREEP,
         "wave":[["C2","bounce",10,250,DIR.N,0,1]],
         "powerup":0,
         "level":1
      },1,{
         "type":CREEP,
         "wave":[["C1","bounce",10,250,DIR.N,0,0]],
         "powerup":0,
         "level":1
      },{
         "type":CREEP,
         "wave":[["C4","bounce",10,250,DIR.N,0,0]],
         "powerup":0,
         "level":1
      },5,{
         "type":CREEP,
         "wave":[["C3","bounce",10,250,DIR.N,0,0]],
         "powerup":0,
         "level":1
      }],[{
         "type":CREEP,
         "wave":[["C6","bounce",8,250,DIR.N,0,1]],
         "powerup":0,
         "level":1
      },2,{
         "type":CREEP,
         "wave":[["C4","bounce",8,250,DIR.N,0,0]],
         "powerup":0,
         "level":1
      }],[{
         "type":CREEP,
         "wave":[["C4","bounce",10,250,DIR.W,0,1]],
         "powerup":0,
         "level":1
      },{
         "type":CREEP,
         "wave":[["IC1","bounce",5,250,DIR.W,0,0]],
         "powerup":0,
         "level":1
      },{
         "type":CREEP,
         "wave":[["C7","bounce",10,250,DIR.E,0,0]],
         "powerup":0,
         "level":1
      },{
         "type":CREEP,
         "wave":[["IC1","bounce",5,250,DIR.E,0,0]],
         "powerup":0,
         "level":1
      }],[{
         "type":CREEP,
         "wave":[["C6","bounce",8,250,DIR.E,0,1]],
         "powerup":0,
         "level":1
      },{
         "type":CREEP,
         "wave":[["C6","bounce",8,250,DIR.W,0,0]],
         "powerup":0,
         "level":1
      },15,{
         "type":CREEP,
         "wave":[["C7","bounce",15,250,DIR.N,0,1]],
         "powerup":0,
         "level":1
      },{
         "type":CREEP,
         "wave":[["C7","bounce",15,250,DIR.S,0,0]],
         "powerup":0,
         "level":1
      }],[{
         "type":CREEP,
         "wave":[["C7","bounce",8,250,DIR.E,0,1]],
         "powerup":0,
         "level":1
      },{
         "type":CREEP,
         "wave":[["C7","bounce",8,250,DIR.W,0,0]],
         "powerup":0,
         "level":1
      },15,{
         "type":CREEP,
         "wave":[["C6","bounce",15,250,DIR.N,0,1]],
         "powerup":0,
         "level":1
      },{
         "type":CREEP,
         "wave":[["C6","bounce",15,250,DIR.S,0,0]],
         "powerup":0,
         "level":1
      }],[{
         "type":CREEP,
         "wave":[["C6","bounce",10,250,DIR.E,0,1]],
         "powerup":0,
         "level":1
      },{
         "type":CREEP,
         "wave":[["C6","bounce",10,250,DIR.W,0,0]],
         "powerup":0,
         "level":1
      },15,{
         "type":CREEP,
         "wave":[["C7","bounce",15,250,DIR.N,0,1]],
         "powerup":0,
         "level":1
      },{
         "type":CREEP,
         "wave":[["C7","bounce",15,250,DIR.S,0,0]],
         "powerup":0,
         "level":1
      },15,{
         "type":CREEP,
         "wave":[["C8","bounce",10,250,DIR.N,0,1]],
         "powerup":0,
         "level":1
      }],[{
         "type":CREEP,
         "wave":[["C6","bounce",20,250,DIR.N,0,1]],
         "powerup":0,
         "level":1
      },{
         "type":CREEP,
         "wave":[["C8","bounce",15,250,DIR.N,0,0]],
         "powerup":0,
         "level":1
      }],[{
         "type":CREEP,
         "wave":[["C7","bounce",20,250,DIR.N,0,1]],
         "powerup":0,
         "level":1
      },{
         "type":CREEP,
         "wave":[["C8","bounce",20,250,DIR.N,0,0]],
         "powerup":0,
         "level":1
      }],[{
         "type":CREEP,
         "wave":[["C6","bounce",12,250,DIR.E,0,1]],
         "powerup":0,
         "level":1
      },{
         "type":CREEP,
         "wave":[["C6","bounce",12,250,DIR.W,0,0]],
         "powerup":0,
         "level":1
      },15,{
         "type":CREEP,
         "wave":[["C7","bounce",18,250,DIR.N,0,1]],
         "powerup":0,
         "level":1
      },{
         "type":CREEP,
         "wave":[["C7","bounce",18,250,DIR.S,0,0]],
         "powerup":0,
         "level":1
      },15,{
         "type":CREEP,
         "wave":[["C8","bounce",15,250,DIR.N,0,1]],
         "powerup":0,
         "level":1
      }],[{
         "type":CREEP,
         "wave":[["C7","bounce",25,250,DIR.N,0,1]],
         "powerup":0,
         "level":1
      },{
         "type":CREEP,
         "wave":[["C7","bounce",25,250,DIR.S,0,0]],
         "powerup":0,
         "level":1
      },15,{
         "type":CREEP,
         "wave":[["C8","bounce",25,250,DIR.N,0,1]],
         "powerup":0,
         "level":1
      }],[{
         "type":CREEP,
         "wave":[["C6","bounce",10,250,DIR.N,0,1]],
         "powerup":0,
         "level":1
      },{
         "type":CREEP,
         "wave":[["C6","bounce",10,250,DIR.E,0,0]],
         "powerup":0,
         "level":1
      },15,{
         "type":CREEP,
         "wave":[["C8","bounce",10,250,DIR.N,0,1]],
         "powerup":0,
         "level":1
      },{
         "type":CREEP,
         "wave":[["C8","bounce",10,250,DIR.E,0,0]],
         "powerup":0,
         "level":1
      },15,{
         "type":CREEP,
         "wave":[["C7","bounce",15,250,DIR.N,0,1]],
         "powerup":0,
         "level":1
      },{
         "type":CREEP,
         "wave":[["C7","bounce",15,250,DIR.E,0,0]],
         "powerup":0,
         "level":1
      }],[{
         "type":CREEP,
         "wave":[["C5","bounce",5,250,DIR.N,0,1]],
         "powerup":0,
         "level":1
      },{
         "type":CREEP,
         "wave":[["C5","bounce",5,250,DIR.S,0,0]],
         "powerup":0,
         "level":1
      },15,{
         "type":GUARDIAN,
         "guardianID":2,
         "level":1,
         "angle":DIR.N,
         "direction":0,
         "health":12000,
         "foodbonus":0
      },{
         "type":CREEP,
         "wave":[["C7","bounce",20,250,DIR.N,0,1]],
         "powerup":0,
         "level":1
      },{
         "type":CREEP,
         "wave":[["C7","bounce",20,250,DIR.S,0,0]],
         "powerup":0,
         "level":1
      },30,{
         "type":CREEP,
         "wave":[["C11","bounce",5,250,DIR.N,0,1]],
         "powerup":0,
         "level":1
      },{
         "type":CREEP,
         "wave":[["C11","bounce",5,250,DIR.S,0,0]],
         "powerup":0,
         "level":1
      },30,{
         "type":CREEP,
         "wave":[["C10","bounce",5,250,DIR.N,0,1]],
         "powerup":0,
         "level":1
      },{
         "type":CREEP,
         "wave":[["C10","bounce",5,250,DIR.S,0,0]],
         "powerup":0,
         "level":1
      }],[{
         "type":CREEP,
         "wave":[["C13","bounce",30,250,DIR.S,0,1]],
         "powerup":1,
         "level":6
      },{
         "type":CREEP,
         "wave":[["IC1","bounce",15,250,DIR.S,0,0]],
         "powerup":0,
         "level":1
      }],[{
         "type":CREEP,
         "wave":[["C2","bounce",20,250,DIR.E,0,1]],
         "powerup":0,
         "level":3
      },{
         "type":GUARDIAN,
         "guardianID":1,
         "level":3,
         "angle":DIR.E,
         "direction":0,
         "health":120000,
         "foodbonus":0
      },15,{
         "type":CREEP,
         "wave":[["C9","bounce",10,250,DIR.E,0,1]],
         "powerup":1,
         "level":3
      }],[{
         "type":CREEP,
         "wave":[["C6","bounce",60,250,DIR.N,0,1]],
         "powerup":0,
         "level":6
      },{
         "type":CREEP,
         "wave":[["C15","bounce",6,250,DIR.N,0,0]],
         "powerup":0,
         "level":5
      }],[{
         "type":CREEP,
         "wave":[["C1","bounce",40,250,DIR.N,0,1]],
         "powerup":0,
         "level":6
      },15,{
         "type":CREEP,
         "wave":[["C6","bounce",30,250,DIR.N,0,1]],
         "powerup":0,
         "level":6
      },15,{
         "type":CREEP,
         "wave":[["C7","bounce",20,250,DIR.N,0,1]],
         "powerup":0,
         "level":6
      },15,{
         "type":CREEP,
         "wave":[["C10","bounce",10,250,DIR.N,0,1]],
         "powerup":0,
         "level":6
      },15,{
         "type":CREEP,
         "wave":[["C12","bounce",5,250,DIR.N,0,1]],
         "powerup":0,
         "level":6
      }],[{
         "type":CREEP,
         "wave":[["C5","bounce",30,250,DIR.N,0,1]],
         "powerup":3,
         "level":6
      },{
         "type":CREEP,
         "wave":[["C3","bounce",30,250,DIR.N,0,0]],
         "powerup":3,
         "level":6
      },{
         "type":CREEP,
         "wave":[["C13","bounce",30,250,DIR.N,0,0]],
         "powerup":3,
         "level":6
      },15,{
         "type":CREEP,
         "wave":[["C4","bounce",30,250,DIR.N,0,1]],
         "powerup":3,
         "level":6
      },{
         "type":CREEP,
         "wave":[["C7","bounce",30,250,DIR.N,0,0]],
         "powerup":3,
         "level":6
      },{
         "type":CREEP,
         "wave":[["C8","bounce",30,250,DIR.N,0,0]],
         "powerup":3,
         "level":6
      },{
         "type":CREEP,
         "wave":[["C9","bounce",30,250,DIR.N,0,0]],
         "powerup":3,
         "level":6
      }],[{
         "type":CREEP,
         "wave":[["C5","bounce",40,250,DIR.N,0,1]],
         "powerup":3,
         "level":6
      },5,{
         "type":CREEP,
         "wave":[["IC1","bounce",50,250,DIR.N,0,0]],
         "powerup":3,
         "level":6
      },{
         "type":GUARDIAN,
         "guardianID":2,
         "level":6,
         "angle":DIR.N,
         "direction":0,
         "health":60000,
         "foodbonus":0
      }],[{
         "type":CREEP,
         "wave":[["C14","bounce",30,250,DIR.N,0,1]],
         "powerup":0,
         "level":6
      }],[{
         "type":CREEP,
         "wave":[["C11","bounce",40,250,DIR.N,0,1]],
         "powerup":3,
         "level":6
      },10,{
         "type":CREEP,
         "wave":[["C13","bounce",40,250,DIR.N,0,1]],
         "powerup":3,
         "level":6
      },30,{
         "type":CREEP,
         "wave":[["C11","bounce",40,250,DIR.N,0,1]],
         "powerup":3,
         "level":6
      },15,{
         "type":CREEP,
         "wave":[["C13","bounce",40,250,DIR.N,0,1]],
         "powerup":3,
         "level":6
      }],[{
         "type":CREEP,
         "wave":[["C12","bounce",5,250,DIR.N,0,1]],
         "powerup":3,
         "level":6
      },15,{
         "type":CREEP,
         "wave":[["C12","bounce",5,250,DIR.E,0,1]],
         "powerup":3,
         "level":6
      },15,{
         "type":CREEP,
         "wave":[["C12","bounce",5,250,DIR.S,0,1]],
         "powerup":3,
         "level":6
      },15,{
         "type":CREEP,
         "wave":[["C12","bounce",5,250,DIR.W,0,1]],
         "powerup":3,
         "level":6
      },15,{
         "type":CREEP,
         "wave":[["C12","bounce",5,250,DIR.N,0,1]],
         "powerup":3,
         "level":6
      },15,{
         "type":CREEP,
         "wave":[["C12","bounce",5,250,DIR.E,0,1]],
         "powerup":3,
         "level":6
      },15,{
         "type":CREEP,
         "wave":[["C12","bounce",5,250,DIR.S,0,1]],
         "powerup":3,
         "level":6
      },15,{
         "type":CREEP,
         "wave":[["C12","bounce",5,250,DIR.W,0,1]],
         "powerup":3,
         "level":6
      }],[{
         "type":GUARDIAN,
         "guardianID":3,
         "level":6,
         "angle":DIR.N,
         "direction":0,
         "health":40000,
         "foodbonus":0
      },{
         "type":CREEP,
         "wave":[["C12","bounce",15,250,DIR.N,0,1]],
         "powerup":3,
         "level":6
      },{
         "type":CREEP,
         "wave":[["C13","bounce",15,250,DIR.W,0,0]],
         "powerup":3,
         "level":6
      },{
         "type":CREEP,
         "wave":[["C13","bounce",15,250,DIR.S,0,0]],
         "powerup":3,
         "level":6
      },{
         "type":CREEP,
         "wave":[["C15","bounce",5,250,DIR.N,0,0]],
         "powerup":0,
         "level":6
      },30,{
         "type":CREEP,
         "wave":[["C12","bounce",15,250,DIR.E,0,1]],
         "powerup":3,
         "level":6
      },{
         "type":CREEP,
         "wave":[["C15","bounce",5,250,DIR.E,0,0]],
         "powerup":0,
         "level":6
      }],[{
         "type":CREEP,
         "wave":[["IC1","bounce",50,250,DIR.N,0,0]],
         "powerup":3,
         "level":5
      },{
         "type":CREEP,
         "wave":[["IC1","bounce",50,250,DIR.S,0,0]],
         "powerup":3,
         "level":5
      },{
         "type":CREEP,
         "wave":[["IC1","bounce",50,250,DIR.E,0,0]],
         "powerup":3,
         "level":5
      },{
         "type":CREEP,
         "wave":[["IC1","bounce",50,250,DIR.W,0,0]],
         "powerup":3,
         "level":5
      },5,{
         "type":GUARDIAN,
         "guardianID":1,
         "level":6,
         "angle":DIR.N,
         "direction":0,
         "health":200000,
         "foodbonus":0
      },{
         "type":CREEP,
         "wave":[["C10","bounce",15,250,DIR.N,0,0]],
         "powerup":0,
         "level":6
      },{
         "type":CREEP,
         "wave":[["C12","bounce",10,250,DIR.N,0,0]],
         "powerup":3,
         "level":6
      },{
         "type":CREEP,
         "wave":[["C14","bounce",10,250,DIR.N,0,0]],
         "powerup":3,
         "level":6
      },{
         "type":CREEP,
         "wave":[["C15","bounce",4,250,DIR.N,0,0]],
         "powerup":0,
         "level":6
      },{
         "type":GUARDIAN,
         "guardianID":2,
         "level":6,
         "angle":DIR.S,
         "direction":0,
         "health":60000,
         "foodbonus":0
      },{
         "type":CREEP,
         "wave":[["C10","bounce",15,250,DIR.S,0,0]],
         "powerup":0,
         "level":6
      },{
         "type":CREEP,
         "wave":[["C12","bounce",10,250,DIR.S,0,0]],
         "powerup":3,
         "level":6
      },{
         "type":CREEP,
         "wave":[["C14","bounce",10,250,DIR.S,0,0]],
         "powerup":3,
         "level":6
      },{
         "type":CREEP,
         "wave":[["C15","bounce",6,250,DIR.S,0,0]],
         "powerup":0,
         "level":6
      },{
         "type":GUARDIAN,
         "guardianID":3,
         "level":4,
         "angle":DIR.E,
         "direction":0,
         "health":40000,
         "foodbonus":0
      },{
         "type":CREEP,
         "wave":[["C12","bounce",10,250,DIR.E,0,0]],
         "powerup":3,
         "level":6
      },{
         "type":CREEP,
         "wave":[["C14","bounce",10,250,DIR.E,0,0]],
         "powerup":3,
         "level":6
      },{
         "type":CREEP,
         "wave":[["C15","bounce",4,250,DIR.E,0,0]],
         "powerup":0,
         "level":6
      },60,{
         "type":GUARDIAN,
         "guardianID":2,
         "level":6,
         "angle":DIR.W,
         "direction":0,
         "health":60000,
         "foodbonus":0
      },{
         "type":GUARDIAN,
         "guardianID":2,
         "level":6,
         "angle":DIR.E,
         "direction":0,
         "health":60000,
         "foodbonus":0
      }],[{
         "type":CREEP,
         "wave":[["IC2","bounce",40,250,DIR.N,0,0]],
         "powerup":0,
         "level":6,
         "rage":30
      },{
         "type":CREEP,
         "wave":[["IC2","bounce",40,250,DIR.S,0,0]],
         "powerup":0,
         "level":6,
         "rage":30
      },{
         "type":CREEP,
         "wave":[["IC2","bounce",40,250,DIR.W,0,0]],
         "powerup":0,
         "level":6,
         "rage":30
      },{
         "type":CREEP,
         "wave":[["IC2","bounce",40,250,DIR.E,0,0]],
         "powerup":0,
         "level":6,
         "rage":30
      },60,{
         "type":CREEP,
         "wave":[["C13","bounce",30,250,DIR.N,0,0]],
         "powerup":3,
         "level":6,
         "rage":25
      },{
         "type":CREEP,
         "wave":[["C13","bounce",30,250,DIR.W,0,0]],
         "powerup":3,
         "level":6,
         "rage":25
      },{
         "type":CREEP,
         "wave":[["C13","bounce",30,250,DIR.E,0,0]],
         "powerup":3,
         "level":6,
         "rage":25
      },{
         "type":CREEP,
         "wave":[["C13","bounce",30,250,DIR.S,0,0]],
         "powerup":3,
         "level":6,
         "rage":25
      },60,{
         "type":CREEP,
         "wave":[["IC7","bounce",10,250,DIR.N,0,0]],
         "powerup":0,
         "level":6,
         "rage":30
      },{
         "type":CREEP,
         "wave":[["IC7","bounce",10,250,DIR.W,0,0]],
         "powerup":0,
         "level":6,
         "rage":30
      },{
         "type":CREEP,
         "wave":[["IC7","bounce",10,250,DIR.E,0,0]],
         "powerup":0,
         "level":6,
         "rage":30
      },{
         "type":CREEP,
         "wave":[["IC7","bounce",10,250,DIR.S,0,0]],
         "powerup":0,
         "level":6,
         "rage":30
      },{
         "type":CREEP,
         "wave":[["C14","bounce",5,250,DIR.N,0,0]],
         "powerup":3,
         "level":6,
         "rage":10
      },{
         "type":CREEP,
         "wave":[["C14","bounce",5,250,DIR.W,0,0]],
         "powerup":3,
         "level":6,
         "rage":10
      },{
         "type":CREEP,
         "wave":[["C14","bounce",5,250,DIR.S,0,0]],
         "powerup":3,
         "level":6,
         "rage":10
      },{
         "type":CREEP,
         "wave":[["C14","bounce",5,250,DIR.E,0,0]],
         "powerup":3,
         "level":6,
         "rage":10
      }]];
      
      private static const DEBUGCREATURES:Array = ["C1","C2","C3","C4","C5","C6","C7","C8","C9","C10","C11","C12","C13","C14","C15","IC1"];
      
      public function SPECIALEVENT_WM1()
      {
         super();
      }
      
      public static function Setup() : void
      {
         if(_setupCalled)
         {
            return;
         }
         _setupCalled = true;
         _round = GLOBAL.StatGet("wmi_wave");
         _wave = 0;
         _knownFlag = invasionpop;
         InitializeTimes();
      }
      
      private static function InitializeTimes() : void
      {
         var _loc1_:Date = new Date();
         _loc1_.setUTCFullYear(2011,10,10);
         _loc1_.setUTCHours(20,0,0,0);
         _eventStartTime = Math.floor(_loc1_.getTime() / 1000);
         var _loc2_:Date = new Date();
         _loc2_.setUTCFullYear(2011,10,17);
         _loc2_.setUTCHours(20,0,0,0);
         _eventExtensionTime = Math.floor(_loc2_.getTime() / 1000);
         var _loc3_:Date = new Date();
         _loc3_.setUTCFullYear(2011,10,20);
         _loc3_.setUTCHours(20,0,0,0);
         _eventEndTime = Math.floor(_loc3_.getTime() / 1000);
      }
      
      public static function StartRound() : void
      {
         if(_active)
         {
            return;
         }
         _active = true;
         if(_round == -1)
         {
            _round = GLOBAL.StatGet("wmi_wave");
         }
         _wave = 0;
         _currentAttackers = new Array();
         _retreatAllMonsters = false;
         _randomDirection = Math.floor(Math.random() * 4) * 90;
         LOGGER.Stat([79,_round]);
         SendWave();
      }
      
      public static function EndRound(param1:Boolean, param2:Boolean = false) : void
      {
         var _loc3_:MovieClip = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:* = undefined;
         var _loc8_:BFOUNDATION = null;
         if(param1)
         {
            LOGGER.Stat([80,_round]);
            StartRepairs();
            _loc3_ = new WMIROUNDCOMPLETE_WM1(wave);
            POPUPS.Push(_loc3_,null,null,null,null,false,"now");
            ++_round;
            UI_BOTTOM._nextwave_wm1.SetWave(wave);
            GLOBAL.StatSet("wmi_wave",_round);
            if(GLOBAL._bTotem)
            {
               GLOBAL._bTotem._renderState = null;
            }
         }
         else
         {
            LOGGER.Stat([81,_round]);
            StartRepairs();
            _loc3_ = new WMIROUNDCOMPLETE_WM1(-1,param2);
            POPUPS.Push(_loc3_,null,null,null,null,false,"now");
         }
         if(GLOBAL._aiDesignMode)
         {
            _loc4_ = 0;
            _loc5_ = 0;
            for(_loc7_ in BASE._buildingsAll)
            {
               _loc8_ = BASE._buildingsAll[_loc7_];
               if(!(_loc8_._class == "trap" && _loc8_._fired || _loc8_._type == 53 && _loc8_._expireTime < GLOBAL.Timestamp()))
               {
                  if(_loc8_._class != "wall")
                  {
                     _loc4_ += _loc8_._hp.Get();
                     _loc5_ += _loc8_._hpMax.Get();
                  }
                  if(BTOTEM.IsTotem(_loc8_._type))
                  {
                     _loc8_._type = SPECIALEVENT_WM1.TotemQualified(_loc8_._type);
                  }
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
         var _loc1_:BFOUNDATION = null;
         for each(_loc1_ in BASE._buildingsAll)
         {
            if(_loc1_._hp.Get() < _loc1_._hpMax.Get() && _loc1_._repairing == 0)
            {
               _loc1_.Repair();
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
         var _loc7_:* = undefined;
         var _loc8_:Number = NaN;
         var _loc9_:Point = null;
         // Original version had a CHAMPIONMONSTER.as class before the refactor to ChampionBase.as
         // var _loc10_:CHAMPIONMONSTER = null;
         var _loc10_:ChampionBase = null;
         if(_round >= WAVES.length)
         {
            return;
         }
         SOUNDS.PlayMusic("musicpanic");
         _spawningWaves = true;
         switch(WAVES[_round][_wave].type)
         {
            case CREEP:
               _loc1_ = WAVES[_round][_wave].wave;
               _loc2_ = _loc1_[0][0];
               _loc3_ = int(WAVES[_round][_wave].powerup);
               _loc4_ = int(WAVES[_round][_wave].level);
               _loc5_ = int(WAVES[_round][_wave].rage);
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
               _loc7_ = WAVES[_round][_wave];
               _loc8_ = (_loc7_.angle + _randomDirection) % 360;
               _loc9_ = GRID.ToISO(Math.cos(_loc8_ * 0.0174532925) * 900,Math.sin(_loc8_ * 0.0174532925) * 900,0);
               _loc10_ = CREEPS.SpawnGuardian(_loc7_.guardianID,MAP._BUILDINGTOPS,"bounce",_loc7_.level,_loc9_,_loc7_.direction,_loc7_.health,_loc7_.foodbonus,true);
               _currentAttackers.push([_loc10_]);
         }
         _timeOfNextWave = GLOBAL.Timestamp();
         while(++_wave < WAVES[_round].length && WAVES[_round][_wave] instanceof Number)
         {
            _timeOfNextWave += WAVES[_round][_wave];
         }
         if(_wave >= WAVES[_round].length)
         {
            _spawningWaves = false;
            _timeOfNextWave = -1;
         }
         updateWarningText();
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
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         for each(_loc1_ in GLOBAL._wmCreaturePowerups)
         {
            _loc1_ = null;
         }
         for each(_loc2_ in GLOBAL._wmCreatureLevels)
         {
            _loc2_ = null;
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
                     _loc2_[_loc3_].ModeRetreat();
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
      
      public static function GetTimeUntilStart() : Number
      {
         return _eventStartTime - GLOBAL.Timestamp();
      }
      
      public static function GetTimeUntilExtension() : Number
      {
         return _eventExtensionTime - GLOBAL.Timestamp();
      }
      
      public static function GetTimeUntilEnd() : Number
      {
         return _eventEndTime - GLOBAL.Timestamp();
      }
      
      public static function TimerClicked(param1:MouseEvent) : void
      {
         if(!_active)
         {
            if(invasionpop == 5)
            {
               ShowExtensionPopup("now");
            }
            else
            {
               ShowDefenseEventPopup("now");
            }
         }
      }
      
      public static function ShowDefenseEventPopup(param1:String) : void
      {
         var _loc2_:MovieClip = null;
         if(!DEFENSEEVENTPOPUP_WM1.open && !_active)
         {
            _loc2_ = new DEFENSEEVENTPOPUP_WM1(SPECIALEVENT_WM1.invasionpop);
            POPUPS.Push(_loc2_,null,null,null,null,false,param1);
            GLOBAL.StatSet("lasttdpopup",SPECIALEVENT_WM1.invasionpop);
         }
      }
      
      public static function ShowExtensionPopup(param1:String) : void
      {
         var _loc2_:MovieClip = null;
         if(!WMIEXTENSIONPOPUP_WM1.open && !_active)
         {
            _loc2_ = new WMIEXTENSIONPOPUP_WM1();
            POPUPS.Push(_loc2_,null,null,null,null,false,param1);
            GLOBAL.StatSet("lasttdpopup",SPECIALEVENT_WM1.invasionpop);
         }
      }
      
      public static function ShowTShirtPopup(param1:String) : void
      {
         var _loc2_:MovieClip = null;
         if(!DEFENSEEVENTPOPUP_WM1.open && !_active)
         {
            _loc2_ = new DEFENSEEVENTPOPUP_WM1(5);
            POPUPS.Push(_loc2_,null,null,null,null,false,param1);
            GLOBAL.StatSet("lasttdpopup",6);
         }
      }
      
      public static function ShowEventEndPopup() : void
      {
         var _loc1_:MovieClip = null;
         if(!WMIROUNDCOMPLETE_WM1.open && !_active)
         {
            _loc1_ = new WMIROUNDCOMPLETE_WM1(EVENTEND);
            POPUPS.Push(_loc1_,null,null,null,null,false,"wait");
            GLOBAL.StatSet("wmi_end",1);
         }
      }
      
      public static function EventActive() : Boolean
      {
         if(BASE._isOutpost)
         {
            return false;
         }
         return SPECIALEVENT.invasionpop == 4 || SPECIALEVENT.invasionpop == 5;
      }
      
      public static function get invasionpop() : Number
      {
         if(INVASIONPOP_OVERRIDE > 0)
         {
            return INVASIONPOP_OVERRIDE;
         }
         if(GLOBAL._flags.invasionpop2 == -1)
         {
            return -1;
         }
         return Math.max(GLOBAL._flags.invasionpop,GLOBAL._flags.invasionpop2);
      }
      
      public static function AllWavesSpawned() : Boolean
      {
         return !_spawningWaves;
      }
      
      public static function TotemReward() : void
      {
         var _loc1_:int = TotemQualified(121);
         BASE.BuildingStorageAdd(_loc1_);
      }
      
      public static function TotemPlace() : void
      {
         var _loc1_:int = TotemQualified(121);
         BUILDINGS._buildingID = _loc1_;
         BUILDINGS.Show();
         BUILDINGS._mc.SwitchB(4,4,0);
      }
      
      public static function TotemQualified(param1:int) : Number
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         if(BTOTEM.IsTotem(param1))
         {
            _loc2_ = GLOBAL.StatGet("wmi_wave");
            _loc3_ = 0;
            _loc4_ = 0;
            while(_loc4_ < SPECIALEVENT_WM1.WONSTAGE.length)
            {
               if(_loc2_ >= SPECIALEVENT_WM1.WONSTAGE[_loc4_])
               {
                  _loc3_ = _loc4_ + 1;
               }
               _loc4_++;
            }
            switch(_loc3_)
            {
               case 1:
                  param1 = 121;
                  break;
               case 2:
                  param1 = 122;
                  break;
               case 3:
                  param1 = 123;
                  break;
               case 4:
                  param1 = 124;
                  break;
               case 5:
                  param1 = 125;
                  break;
               case 6:
                  param1 = 126;
                  break;
               default:
                  param1 = 121;
            }
         }
         return param1;
      }
      
      public static function FlagChanged() : void
      {
         _knownFlag = invasionpop;
         switch(_knownFlag)
         {
            case -1:
            case 0:
               GLOBAL.StatSet("lasttdpopup",0);
               break;
            case 1:
            case 2:
            case 3:
            case 4:
               if(GLOBAL.StatGet("lasttdpopup") < _knownFlag)
               {
                  ShowDefenseEventPopup("wait");
               }
               break;
            case 5:
               if(GLOBAL.StatGet("lasttdpopup") < 5)
               {
                  if(wave == BONUSWAVE2 && UI_BOTTOM._nextwave_wm1 && !UI_BOTTOM._nextwave_wm1.visible)
                  {
                     UI_BOTTOM._nextwave_wm1.visible = true;
                  }
                  ShowExtensionPopup("wait");
               }
               else if(GLOBAL.StatGet("lasttdpopup") == 5)
               {
                  ShowTShirtPopup("wait");
               }
         }
      }
      
      public static function DEBUGOVERRIDEROUND(param1:int) : void
      {
         _round = param1;
         UI_BOTTOM._nextwave_wm1.SetWave(wave);
      }
      
      public static function DebugToggleActive(param1:Boolean) : void
      {
         _active = param1;
      }
      
      public static function DebugSetRound(param1:Number) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:* = undefined;
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
      
      public static function get wave() : int
      {
         return _round + 1;
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