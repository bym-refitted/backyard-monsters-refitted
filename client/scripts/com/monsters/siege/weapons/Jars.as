package com.monsters.siege.weapons
{
   import com.cc.utils.SecNum;
   import com.monsters.siege.SiegeWeaponProperty;
   import com.monsters.siege.SiegeWeapons;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class Jars extends SiegeWeapon implements IDurable
   {
      
      public static const ID:String = "jars";
      
      public static const CRACKING_SOUNDS:Vector.<String> = Vector.<String>(["othersounds/glass_cracking_1.mp3","othersounds/glass_cracking_2.mp3","othersounds/glass_cracking_3.mp3","othersounds/glass_cracking_4.mp3"]);
      
      public static const EXPLODE_SOUNDS:Vector.<String> = Vector.<String>(["othersounds/glass_explode_1.mp3","othersounds/glass_explode_2.mp3"]);
      
      public static const LAND_SOUNDS:Vector.<String> = Vector.<String>(["othersounds/jar_land_2.mp3"]);
      
      public static const JAR_GRAPHIC:String = "jarAnimation";
      
      public static const JAR_GRAPHIC_URL:String = "siegeimages/jar_anim.v2.png";
      
      public static const JAR_GRAPHIC_WIDTH:int = 163;
      
      public static const JAR_GRAPHIC_HEIGHT:int = 150;
      
      public static const JAR_GRAPHIC_FRAMES:int = 23;
       
      
      private var _targets:Vector.<BTOWER>;
      
      private var _activeTimer:Timer;
      
      public function Jars()
      {
         weaponID = ID;
         dropTarget = DROPZONE.SIEGEWEAPON_BUILDINGS;
         super();
         addProperty(RANGE,new SiegeWeaponProperty([200,210,235,335,360,370,380,390,400,410],1));
         addProperty(DURABILITY,new SiegeWeaponProperty([2000,3000,4500,7000,11000,13500,16500,20500,25500,31500],2));
         addProperty(DURATION,new SiegeWeaponProperty([0,0,0,0,0,0,0,0,0,0]));
         addProperty(UPGRADE_COSTS,new SiegeWeaponProperty([{
            "r1":54788.2570728397,
            "r2":73051.0094304529,
            "r3":54788.2570728397,
            "r4":0,
            "time":8100
         },{
            "r1":94981.5611740237,
            "r2":126642.081565365,
            "r3":94981.5611740237,
            "r4":0,
            "time":13500
         },{
            "r1":164651.086038632,
            "r2":219534.781384843,
            "r3":164651.086038632,
            "r4":0,
            "time":19800
         },{
            "r1":285371.258002827,
            "r2":380495.010670437,
            "r3":285371.258002827,
            "r4":0,
            "time":30600
         },{
            "r1":494329.891507663,
            "r2":659106.522010217,
            "r3":494329.891507663,
            "r4":0,
            "time":51300
         },{
            "r1":854888.169815886,
            "r2":1139850.89308785,
            "r3":854888.169815886,
            "r4":0,
            "time":86400
         },{
            "r1":1471266.3489287,
            "r2":1961688.46523827,
            "r3":1471266.3489287,
            "r4":0,
            "time":216000
         },{
            "r1":2497108.33129819,
            "r2":3329477.77506425,
            "r3":2497108.33129819,
            "r4":0,
            "time":302400
         },{
            "r1":4086751.48181388,
            "r2":5449001.97575184,
            "r3":4086751.48181388,
            "r4":0,
            "time":345600
         },{
            "r1":6188066.53345743,
            "r2":8250755.37794324,
            "r3":6188066.53345743,
            "r4":0,
            "time":388800
         }]));
         addProperty(BUILD_COSTS,new SiegeWeaponProperty([{
            "r4":0,
            "r1":42971,
            "r2":42971,
            "r3":21486,
            "time":3600
         },{
            "r4":0,
            "r1":74495,
            "r2":74495,
            "r3":37248,
            "time":5400
         },{
            "r4":0,
            "r1":129138,
            "r2":129138,
            "r3":64569,
            "time":8100
         },{
            "r4":0,
            "r1":223821,
            "r2":223821,
            "r3":111910,
            "time":12600
         },{
            "r4":0,
            "r1":387710,
            "r2":387710,
            "r3":193855,
            "time":18000
         },{
            "r4":0,
            "r1":670501,
            "r2":670501,
            "r3":335250,
            "time":27000
         },{
            "r4":0,
            "r1":1153934,
            "r2":1153934,
            "r3":576967,
            "time":41400
         },{
            "r4":0,
            "r1":1958516,
            "r2":1958516,
            "r3":979258,
            "time":61200
         },{
            "r4":0,
            "r1":3205295,
            "r2":3205295,
            "r3":1602648,
            "time":86400
         },{
            "r4":0,
            "r1":4853386,
            "r2":4853386,
            "r3":2426693,
            "time":172800
         }]));
         SPRITES.SetupSprite(JAR_GRAPHIC);
      }
      
      override public function get logMessage() : String
      {
         return KEYS.Get("attack_log_siegeplural",{
            "v1":level,
            "v2":name
         });
      }
      
      public function get durability() : int
      {
         return getProperty(DURABILITY).getValueForLevel(level);
      }
      
      public function get activeDurability() : Number
      {
         var _loc4_:SecNum = null;
         var _loc1_:Number = 0;
         var _loc2_:uint = this._targets.length;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this._targets[_loc3_]._jarHealth;
            if(_loc4_)
            {
               _loc1_ += _loc4_.Get();
            }
            _loc3_++;
         }
         return _loc1_ / (_loc2_ * this.durability) * this.durability;
      }
      
      override public function onActivation(param1:Number, param2:Number) : void
      {
         SPRITES.SetupSprite(JAR_GRAPHIC);
         this._targets = this.getValidTargets(param1,param2);
         var _loc3_:int = 0;
         while(_loc3_ < this._targets.length)
         {
            this._targets[_loc3_].ApplyJar(this.durability);
            _loc3_++;
         }
         this._activeTimer = new Timer(1000,duration);
         this._activeTimer.addEventListener(TimerEvent.TIMER,this.update);
         this._activeTimer.start();
      }
      
      private function update(param1:TimerEvent) : void
      {
         if(Boolean(SiegeWeapons.activeWeapon) && this.activeDurability <= 0)
         {
            SiegeWeapons.deactivateWeapon();
         }
      }
      
      override public function onDeactivation() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._targets.length)
         {
            this._targets[_loc1_].KillJar();
            _loc1_++;
         }
         this._activeTimer.removeEventListener(TimerEvent.TIMER,this.update);
         this._activeTimer.stop();
      }
      
      private function getValidTargets(param1:Number, param2:Number) : Vector.<BTOWER>
      {
         var _loc5_:* = undefined;
         var _loc3_:Vector.<BFOUNDATION> = new Vector.<BFOUNDATION>();
         BASE.GetBuildingOverlap(param1,param2,range,_loc3_);
         var _loc4_:Vector.<BTOWER> = new Vector.<BTOWER>();
         for each(_loc5_ in _loc3_)
         {
            if(_loc5_ is BTOWER)
            {
               _loc4_.push(_loc5_);
            }
         }
         return _loc4_;
      }
   }
}
