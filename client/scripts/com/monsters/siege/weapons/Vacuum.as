package com.monsters.siege.weapons
{
   import com.monsters.siege.SiegeWeaponProperty;
   import com.monsters.siege.SiegeWeapons;
   import flash.events.Event;
   import flash.utils.getQualifiedClassName;
   
   public class Vacuum extends SiegeWeapon implements IDurable
   {
      
      private static const k_BUILDINGS_THAT_CAN_BE_SUCKED:Vector.<String> = Vector.<String>([getQualifiedClassName(BUILDING14),getQualifiedClassName(ResourceOutpost)]);
      
      public static const ID:String = "vacuum";
      
      public static const LOOT_BONUS:String = "siegeWeaponLootBonus";
      
      public static var target:BFOUNDATION;
       
      
      public var hose:VacuumHose;
      
      public function Vacuum()
      {
         weaponID = ID;
         dropTarget = DROPZONE.SIEGEWEAPON_GROUND;
         super();
         addProperty(LOOT_BONUS,new SiegeWeaponProperty([25000,38153,58225,88856,135604,206945,292002,380324,495361,593977],1));
         addProperty(DURABILITY,new SiegeWeaponProperty([6000,7200,7800,9400,10300,11200,14600,20500,29000,44200],2));
         addProperty(DURATION,new SiegeWeaponProperty([30,35,40,45,50,60,65,70,80,85],3));
         addProperty(RANGE,new SiegeWeaponProperty([]));
         addProperty(UPGRADE_COSTS,new SiegeWeaponProperty([{
            "r1":36525.6742111195,
            "r2":35451.3896754984,
            "r3":35451.3896754984,
            "r4":0,
            "time":7200
         },{
            "r1":72856.8101856925,
            "r2":70713.9628272898,
            "r3":70713.9628272898,
            "r4":0,
            "time":11700
         },{
            "r1":145311.983388114,
            "r2":141038.101523758,
            "r3":141038.101523758,
            "r4":0,
            "time":18900
         },{
            "r1":289715.138033823,
            "r2":281194.10456224,
            "r3":281194.10456224,
            "r4":0,
            "time":28800
         },{
            "r1":576767.5769981,
            "r2":559803.82473345,
            "r3":559803.82473345,
            "r4":0,
            "time":49500
         },{
            "r1":1141625.06806759,
            "r2":1108047.86018325,
            "r3":1108047.86018325,
            "r4":0,
            "time":86400
         },{
            "r1":2211351.3581495,
            "r2":2146311.61232158,
            "r3":2146311.61232158,
            "r4":0,
            "time":259200
         },{
            "r1":3995477.90599582,
            "r2":3877963.84993712,
            "r3":3877963.84993712,
            "r4":0,
            "time":388800
         },{
            "r1":6194145.1020071,
            "r2":6011964.36371277,
            "r3":6011964.36371277,
            "r4":0,
            "time":475200
         },{
            "r1":7981712.40588686,
            "r2":7746956.15865489,
            "r3":7746956.15865489,
            "r4":0,
            "time":475200
         }]));
         addProperty(BUILD_COSTS,new SiegeWeaponProperty([{
            "r1":28648,
            "r2":14324,
            "r3":28648,
            "r4":0,
            "time":14400
         },{
            "r1":57143,
            "r2":28571,
            "r3":57143,
            "r4":0,
            "time":19800
         },{
            "r1":113970,
            "r2":56985,
            "r3":113970,
            "r4":0,
            "time":27900
         },{
            "r1":227228,
            "r2":113614,
            "r3":227228,
            "r4":0,
            "time":39600
         },{
            "r1":452367,
            "r2":226183,
            "r3":452367,
            "r4":0,
            "time":54900
         },{
            "r1":895392,
            "r2":447696,
            "r3":895392,
            "r4":0,
            "time":77400
         },{
            "r1":1734393,
            "r2":867197,
            "r3":1734393,
            "r4":0,
            "time":86400
         },{
            "r1":3133708,
            "r2":1566854,
            "r3":3133708,
            "r4":0,
            "time":129600
         },{
            "r1":4858153,
            "r2":2429077,
            "r3":4858153,
            "r4":0,
            "time":172800
         },{
            "r1":6260167,
            "r2":3130083,
            "r3":6260167,
            "r4":0,
            "time":259200
         }]));
         canUseInOutposts = true;
      }
      
      public static function getHose() : VacuumHose
      {
         var _loc1_:SiegeWeapon = SiegeWeapons.activeWeapon;
         if(Boolean(_loc1_) && _loc1_ is Vacuum)
         {
            return Vacuum(_loc1_).hose;
         }
         return null;
      }
      
      public static function getTarget() : BFOUNDATION
      {
         var _loc1_:SiegeWeapon = SiegeWeapons.activeWeapon;
         if(Boolean(_loc1_) && _loc1_ is Vacuum)
         {
            return Vacuum(_loc1_).hose._target;
         }
         return null;
      }
      
      override public function canFire() : Boolean
      {
         return super.canFire() && this.findTarget() != null;
      }
      
      public function get lootBonus() : int
      {
         return getProperty(LOOT_BONUS).getValueForLevel(level);
      }
      
      public function get durability() : int
      {
         return getProperty(DURABILITY).getValueForLevel(level);
      }
      
      public function get activeDurability() : Number
      {
         if(this.hose)
         {
            return this.hose.health;
         }
         return 0;
      }
      
      override public function activate(param1:Number, param2:Number) : Boolean
      {
         var _loc3_:BFOUNDATION = this.findTarget();
         if(!_loc3_ || Boolean(this.hose))
         {
            print("Could not start Vacuum, either no valid target or the weapon is already on");
            return false;
         }
         return super.activate(param1,param2);
      }
      
      override public function onActivation(param1:Number, param2:Number) : void
      {
         var _loc3_:BFOUNDATION = this.findTarget();
         if(!_loc3_ || Boolean(this.hose))
         {
            print("Could not start Vacuum, either no valid target or the weapon is already on");
            return;
         }
         this.hose = new VacuumHose(_loc3_,this.durability,this.lootBonus);
         this.hose._vacuum.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         Vacuum.target;
      }
      
      protected function onEnterFrame(param1:Event) : void
      {
         if(this.hose)
         {
            this.hose.tick();
         }
      }
      
      override public function onDeactivation() : void
      {
         if(this.hose)
         {
            this.hose._vacuum.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
            this.hose.RemoveVacuum();
         }
         this.hose = null;
      }
      
      private function findTarget() : BFOUNDATION
      {
         return Boolean(GLOBAL.townHall) && k_BUILDINGS_THAT_CAN_BE_SUCKED.indexOf(getQualifiedClassName(GLOBAL.townHall)) >= 0 ? GLOBAL.townHall : null;
      }
   }
}
