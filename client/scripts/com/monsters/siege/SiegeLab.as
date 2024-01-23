package com.monsters.siege
{
   import com.cc.utils.SecNum;
   import com.monsters.siege.weapons.SiegeWeapon;
   
   public class SiegeLab extends SiegeBuilding
   {
      
      public static const ID:int = 134;
      
      public static const SIEGE_BUTTON:String = "btn_siegelab";
       
      
      public function SiegeLab()
      {
         _type = ID;
         super();
      }
      
      public static function Show() : void
      {
         if(GLOBAL._bSiegeLab.health >= GLOBAL._bSiegeLab.maxHealth * 0.5)
         {
            SiegeBuilding.Show("lab");
         }
         else
         {
            GLOBAL.Message(KEYS.Get("msg_sworks_damaged"));
         }
      }
      
      override public function Setup(param1:Object) : void
      {
         GLOBAL._bSiegeLab = this;
         return super.Setup(param1);
      }
      
      override public function Constructed() : void
      {
         GLOBAL._bSiegeLab = this;
         return super.Constructed();
      }
      
      override public function Upgrade() : Boolean
      {
         if(upgradingWeapon)
         {
            if(upgradingWeapon.level > 0)
            {
               GLOBAL.Message(KEYS.Get("msg_sworks_cantupgrade2"));
            }
            else
            {
               GLOBAL.Message(KEYS.Get("msg_sworks_cantupgrade1"));
            }
            return false;
         }
         return super.Upgrade();
      }
      
      override public function Recycle() : void
      {
         if(upgradingWeapon)
         {
            if(upgradingWeapon.level > 0)
            {
               GLOBAL.Message(KEYS.Get("msg_sworks_cantrecycle2"));
            }
            else
            {
               GLOBAL.Message(KEYS.Get("msg_sworks_cantrecycle1"));
            }
            return;
         }
         return super.Recycle();
      }
      
      override public function RecycleC() : void
      {
         GLOBAL._bSiegeLab = null;
         super.RecycleC();
      }
      
      override protected function UpgradeWeapon(param1:String) : void
      {
         ++SiegeWeapons.getWeapon(param1).level;
         QUESTS.Check("siege_" + param1 + "_level",SiegeWeapons.getWeapon(param1).level);
      }
      
      public function StartUpgradingWeapon(param1:String) : void
      {
         var _loc2_:Object = SiegeWeapons.getWeapon(param1).upgradeCosts;
         unlockingWeapons[param1] = new SecNum(_loc2_.time);
         BASE.Charge(1,_loc2_.r1,false,true);
         BASE.Charge(2,_loc2_.r2,false,true);
         BASE.Charge(3,_loc2_.r3,false,true);
         BASE.Charge(4,_loc2_.r4,false,true);
         BASE.Save();
         var _loc3_:int = SiegeWeapons.getWeapon(param1).level;
         if(_loc3_ == 0)
         {
            LOGGER.Stat([90,param1,_loc3_,"start"]);
         }
         else
         {
            LOGGER.Stat([91,param1,_loc3_,"start"]);
         }
      }
      
      public function CancelUpgradingWeapon(param1:String) : void
      {
         _animTick = 0;
         AnimFrame();
         if(!unlockingWeapons[param1])
         {
            return;
         }
         delete unlockingWeapons[param1];
         var _loc2_:Object = SiegeWeapons.getWeapon(param1).upgradeCosts;
         BASE.Fund(1,_loc2_.r1,false,null,true);
         BASE.Fund(2,_loc2_.r2,false,null,true);
         BASE.Fund(3,_loc2_.r3,false,null,true);
         BASE.Fund(4,_loc2_.r4,false,null,true);
         BASE.Save();
         var _loc3_:int = SiegeWeapons.getWeapon(param1).level;
         if(_loc3_ == 0)
         {
            LOGGER.Stat([90,param1,_loc3_,"cancel"]);
         }
         else
         {
            LOGGER.Stat([91,param1,_loc3_,"cancel"]);
         }
      }
      
      public function FinishUpgradingWeapon(param1:String) : void
      {
         _animTick = 0;
         AnimFrame();
         if(!unlockingWeapons[param1])
         {
            return;
         }
         delete unlockingWeapons[param1];
         BASE.Save();
         var _loc2_:int = SiegeWeapons.getWeapon(param1).level;
         if(_loc2_ == 0)
         {
            LOGGER.Stat([90,param1,_loc2_,"finish"]);
         }
         else
         {
            LOGGER.Stat([91,param1,_loc2_,"finish"]);
         }
      }
      
      public function InstantUpgrade(param1:String) : void
      {
         var _loc2_:Number = this.getInstantUpgradeCost(param1);
         this.CompleteUpgradingWeapon(param1);
         BASE.Purchase("IBSW",_loc2_,"building");
         var _loc3_:int = SiegeWeapons.getWeapon(param1).level;
         if(_loc3_ == 0)
         {
            LOGGER.Stat([90,param1,_loc3_,"instant",_loc2_]);
         }
         else
         {
            LOGGER.Stat([91,param1,_loc3_,"instant",_loc2_]);
         }
      }
      
      override public function CompleteUpgradingWeapon(param1:String, param2:Boolean = true) : void
      {
         if(param2)
         {
            ShowBragPopup(param1);
         }
         this.UpgradeWeapon(param1);
         this.FinishUpgradingWeapon(param1);
      }
      
      public function getInstantUpgradeCost(param1:String) : int
      {
         var _loc2_:SiegeWeapon = SiegeWeapons.getWeapon(param1);
         var _loc3_:Object = _loc2_.upgradeCosts;
         if(Boolean(upgradingWeapon) && upgradingWeapon.weaponID == param1)
         {
            return STORE.GetTimeCost(UpgradeTimeLeft(_loc2_));
         }
         return _loc2_.instantUpgradeCost;
      }
      
      public function HasEnoughShinyToUpgrade(param1:SiegeWeapon) : Boolean
      {
         return BASE._credits.Get() >= this.getInstantUpgradeCost(param1.weaponID);
      }
      
      public function UpgradeTimeTotal(param1:SiegeWeapon) : int
      {
         return param1.upgradeCosts.time;
      }
   }
}
