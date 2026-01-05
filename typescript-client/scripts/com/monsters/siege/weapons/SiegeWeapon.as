package com.monsters.siege.weapons
{
   import com.cc.utils.SecNum;
   import com.monsters.siege.SiegeWeaponProperty;
   
   public class SiegeWeapon
   {
      
      public static const RANGE:String = "siegeWeaponRange";
      
      public static const UPGRADE_COSTS:String = "siegeWeaponUpgradeCosts";
      
      public static const BUILD_COSTS:String = "siegeWeaponBuildCosts";
      
      public static const DURATION:String = "siegeWeaponDuration";
      
      public static const DURABILITY:String = "siegeWeaponDurability";
      
      public static const MAX_LEVEL:int = 10;
      
      private static const _IMAGE_FOLDER_URL:String = "siegebuttons/";
      
      private static const _ICON_FOLDER_URL:String = "popups/";
      
      private static const _STREAMPOST_FOLDER_URL:String = "quests/";
       
      
      public var weaponID:String;
      
      public var name:String;
      
      public var icon:String;
      
      public var image:String;
      
      public var video:String;
      
      public var videopreview:String;
      
      public var description:String;
      
      public var tooltip:String;
      
      public var dropTarget:int;
      
      public var canUseInOutposts:Boolean = true;
      
      protected var _quantity:SecNum;
      
      protected var _level:SecNum;
      
      private var _properties:Object;
      
      public function SiegeWeapon()
      {
         this._quantity = new SecNum(0);
         this._level = new SecNum(0);
         super();
         this._properties = {};
         this.image = _IMAGE_FOLDER_URL + this.weaponID + ".png";
         this.icon = _ICON_FOLDER_URL + "siege_icon_" + this.weaponID + ".png";
         this.video = "assets/videos/" + this.weaponID + "400x175.flv";
         this.videopreview = "videos/" + this.weaponID + "_preview" + ".png";
         this.name = KEYS.Get("#w_" + this.weaponID + "#");
         this.description = KEYS.Get("w_" + this.weaponID + "desc");
         this.tooltip = KEYS.Get("w_" + this.weaponID + "_tooltip");
         this.quantity = 0;
      }
      
      public function canFire() : Boolean
      {
         return GLOBAL.isInAttackMode;
      }
      
      public function get buildCosts() : Object
      {
         return this.getProperty(SiegeWeapon.BUILD_COSTS).getValueForLevel(this.level);
      }
      
      public function get upgradeCosts() : Object
      {
         return this.getProperty(SiegeWeapon.UPGRADE_COSTS).getValueForLevel(this.level + 1);
      }
      
      public function get level() : int
      {
         return Math.min(SiegeWeapon.MAX_LEVEL,this._level.Get());
      }
      
      public function set level(param1:int) : void
      {
         this._level.Set(Math.min(SiegeWeapon.MAX_LEVEL,param1));
      }
      
      public function get quantity() : int
      {
         return this._quantity.Get();
      }
      
      public function set quantity(param1:int) : void
      {
         this._quantity.Set(param1);
      }
      
      public function get instantUpgradeCost() : int
      {
         return STORE.GetInstantBuyCost(this.upgradeCosts);
      }
      
      public function get instantBuildCost() : int
      {
         return STORE.GetInstantBuyCost(this.buildCosts);
      }
      
      public function get logMessage() : String
      {
         return KEYS.Get("attack_log_siege",{
            "v1":this.level,
            "v2":this.name
         });
      }
      
      public function get warnPopupImage() : String
      {
         return "siegebuild_" + this.weaponID + ".png";
      }
      
      public function get streamImage() : String
      {
         return _STREAMPOST_FOLDER_URL + "siege_" + this.weaponID + "_stream" + ".png";
      }
      
      public function get rewardImage() : String
      {
         return "siegebuttons/" + this.weaponID + "_tiny.png";
      }
      
      public function importVariables(param1:Object) : void
      {
         this.level = param1["level"];
         this.quantity = param1["quantity"];
      }
      
      public function exportVariables() : Object
      {
         return {
            "level":Math.min(MAX_LEVEL,this.level),
            "quantity":this.quantity
         };
      }
      
      public function onActivation(param1:Number, param2:Number) : void
      {
      }
      
      public function onDeactivation() : void
      {
      }
      
      public function get range() : int
      {
         return this.getProperty(RANGE).getValueForLevel(this.level);
      }
      
      public function get duration() : int
      {
         return this.getProperty(DURATION).getValueForLevel(this.level);
      }
      
      public function getProperties() : Vector.<SiegeWeaponProperty>
      {
         var _loc2_:SiegeWeaponProperty = null;
         var _loc1_:Vector.<SiegeWeaponProperty> = new Vector.<SiegeWeaponProperty>();
         for each(_loc2_ in this._properties)
         {
            if(_loc2_.order)
            {
               _loc1_.push(_loc2_);
            }
         }
         return _loc1_.sort(this.sortOnOrder);
      }
      
      private function sortOnOrder(param1:SiegeWeaponProperty, param2:SiegeWeaponProperty) : Number
      {
         return param1.order - param2.order;
      }
      
      public function addProperty(param1:String, param2:SiegeWeaponProperty) : void
      {
         this._properties[param1] = param2;
         if(param2.order)
         {
            param2.label = KEYS.Get("label_" + this.weaponID + "_stat" + param2.order);
            param2.descriptionKey = this.weaponID + "_stat" + param2.order;
         }
      }
      
      public function getProperty(param1:String) : SiegeWeaponProperty
      {
         return this._properties[param1];
      }
      
      public function activate(param1:Number, param2:Number) : Boolean
      {
         this.onActivation(param1,param2);
         return true;
      }
      
      public function deactivate() : void
      {
         this.onDeactivation();
      }
      
      public function get hasCapacityToUpgrade() : Boolean
      {
         var _loc1_:int = 1;
         while(_loc1_ < 5)
         {
            if(BASE._iresources["r" + _loc1_ + "max"] < this.upgradeCosts["r" + _loc1_])
            {
               return false;
            }
            _loc1_++;
         }
         return true;
      }
      
      public function get hasCapacityToBuild() : Boolean
      {
         var _loc1_:int = 1;
         while(_loc1_ < 5)
         {
            if(BASE._iresources["r" + _loc1_ + "max"] < this.buildCosts["r" + _loc1_])
            {
               return false;
            }
            _loc1_++;
         }
         return true;
      }
      
      public function get hasResourcesToUpgrade() : Boolean
      {
         return this.numResourcesToUpgradeNeeded <= 0;
      }
      
      public function get hasResourcesToBuild() : Boolean
      {
         return this.numResourcesToBuildNeeded <= 0;
      }
      
      public function get numResourcesToUpgradeNeeded() : int
      {
         var _loc1_:int = 0;
         var _loc2_:int = 1;
         while(_loc2_ < 5)
         {
            _loc1_ += Math.max(this.upgradeCosts["r" + _loc2_] - BASE._iresources["r" + _loc2_].Get(),0);
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function get numResourcesToBuildNeeded() : int
      {
         var _loc1_:int = 0;
         var _loc2_:int = 1;
         while(_loc2_ < 5)
         {
            _loc1_ += Math.max(this.buildCosts["r" + _loc2_] - BASE._iresources["r" + _loc2_].Get(),0);
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function get numResourcesToUpgradeTotal() : int
      {
         var _loc1_:int = 0;
         var _loc2_:int = 1;
         while(_loc2_ < 5)
         {
            if(this.upgradeCosts["r" + _loc2_] > 0)
            {
               _loc1_ += this.upgradeCosts["r" + _loc2_];
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function get numResourcesToBuildTotal() : int
      {
         var _loc1_:int = 0;
         var _loc2_:int = 1;
         while(_loc2_ < 5)
         {
            if(this.buildCosts["r" + _loc2_] > 0)
            {
               _loc1_ += this.buildCosts["r" + _loc2_];
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function get instantBuildResourceCost() : int
      {
         var _loc1_:Object = {};
         var _loc2_:int = 1;
         while(_loc2_ < 5)
         {
            _loc1_["r" + _loc2_] = Math.max(this.buildCosts["r" + _loc2_] - BASE._iresources["r" + _loc2_].Get(),0);
            _loc2_++;
         }
         return STORE.GetInstantBuyCost(_loc1_);
      }
      
      public function get instantUpgradeResourceCost() : int
      {
         var _loc1_:Object = {};
         var _loc2_:int = 1;
         while(_loc2_ < 5)
         {
            _loc1_["r" + _loc2_] = Math.max(this.upgradeCosts["r" + _loc2_] - BASE._iresources["r" + _loc2_].Get(),0);
            _loc2_++;
         }
         return STORE.GetInstantBuyCost(_loc1_);
      }
      
      public function buyResourcesAndUpgrade() : void
      {
         var _loc1_:int = this.instantUpgradeResourceCost;
         BASE.Fund(1,Math.max(this.upgradeCosts.r1 - BASE._iresources.r1,0),false,null,true);
         BASE.Fund(2,Math.max(this.upgradeCosts.r2 - BASE._iresources.r2,0),false,null,true);
         BASE.Fund(3,Math.max(this.upgradeCosts.r3 - BASE._iresources.r3,0),false,null,true);
         BASE.Fund(4,Math.max(this.upgradeCosts.r4 - BASE._iresources.r4,0),false,null,true);
         GLOBAL._bSiegeLab.StartUpgradingWeapon(this.weaponID);
         BASE.Purchase("BRAU",_loc1_,"building");
      }
      
      public function buyResourcesAndBuild() : void
      {
         var _loc1_:int = this.instantBuildResourceCost;
         BASE.Fund(1,Math.max(this.buildCosts.r1 - BASE._iresources.r1,0),false,null,true);
         BASE.Fund(2,Math.max(this.buildCosts.r2 - BASE._iresources.r2,0),false,null,true);
         BASE.Fund(3,Math.max(this.buildCosts.r3 - BASE._iresources.r3,0),false,null,true);
         BASE.Fund(4,Math.max(this.buildCosts.r4 - BASE._iresources.r4,0),false,null,true);
         GLOBAL._bSiegeFactory.StartUpgradingWeapon(this.weaponID);
         BASE.Purchase("BRAB",_loc1_,"building");
      }
   }
}
