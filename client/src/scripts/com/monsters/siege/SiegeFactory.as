package com.monsters.siege
{
   import com.cc.utils.SecNum;
   import com.monsters.siege.weapons.*;
   import flash.events.MouseEvent;
   
   public class SiegeFactory extends SiegeBuilding
   {
      
      public static const ID:int = 133;
      
      public static const SIEGE_BUTTON:String = "btn_siegefactory";
       
      
      public function SiegeFactory()
      {
         _type = ID;
         GLOBAL._bSiegeFactory = this;
         super();
      }
      
      public static function Show() : void
      {
         if(GLOBAL._bSiegeFactory.health >= GLOBAL._bSiegeFactory.maxHealth * 0.5)
         {
            SiegeBuilding.Show("factory");
         }
         else
         {
            GLOBAL.Message(KEYS.Get("msg_sfactory_damaged"));
         }
      }
      
      override public function Setup(param1:Object) : void
      {
         GLOBAL._bSiegeFactory = this;
         return super.Setup(param1);
      }
      
      override public function Constructed() : void
      {
         GLOBAL._bSiegeFactory = this;
         return super.Constructed();
      }
      
      public function get hasBuiltWeapon() : Boolean
      {
         var _loc1_:SiegeWeapon = null;
         for each(_loc1_ in SiegeWeapons.weapons)
         {
            if(_loc1_.quantity > 0)
            {
               return true;
            }
         }
         return false;
      }
      
      override public function Upgrade() : Boolean
      {
         if(upgradingWeapon)
         {
            GLOBAL.Message(KEYS.Get("msg_sfactory_cantupgrade1"));
         }
         else
         {
            if(!this.hasBuiltWeapon)
            {
               return super.Upgrade();
            }
            GLOBAL.Message(KEYS.Get("msg_sfactory_cantupgrade2"));
         }
         return false;
      }
      
      override public function Recycle() : void
      {
         if(upgradingWeapon)
         {
            GLOBAL.Message(KEYS.Get("msg_sfactory_cantrecycle1"));
         }
         else
         {
            if(!this.hasBuiltWeapon)
            {
               return super.Recycle();
            }
            GLOBAL.Message(KEYS.Get("msg_sfactory_cantrecycle2"));
         }
      }
      
      override public function RecycleC() : void
      {
         GLOBAL._bSiegeFactory = null;
         super.RecycleC();
      }
      
      private function ShowWarnDialog(param1:SiegeWeapon) : void
      {
         var Post:Function = null;
         var weapon:SiegeWeapon = param1;
         Post = function(param1:MouseEvent):void
         {
            if(weapon.weaponID == Jars.ID)
            {
               GLOBAL.CallJS("sendFeed",["siege-weapon-build",KEYS.Get("warn_jars_streamtitle"),KEYS.Get("warn_jars_streambody"),"siegebuild_" + weapon.weaponID + ".png",0]);
            }
            else if(weapon.weaponID == Decoy.ID)
            {
               GLOBAL.CallJS("sendFeed",["siege-weapon-build",KEYS.Get("warn_decoy_streamtitle"),KEYS.Get("warn_decoy_streambody"),"siegebuild_" + weapon.weaponID + ".png",0]);
            }
            else if(weapon.weaponID == Vacuum.ID)
            {
               GLOBAL.CallJS("sendFeed",["siege-weapon-build",KEYS.Get("warn_vacuum_streamtitle"),KEYS.Get("warn_vacuum_streambody"),"siegebuild_" + weapon.weaponID + ".png",0]);
            }
            POPUPS.Next();
         };
         var popup:popup_siegebrag = new popup_siegebrag();
         popup.tText.htmlText = KEYS.Get("msg_weaponbuilt",{
            "v1":weapon.name,
            "v2":weapon.level,
            "v3":weapon.name
         });
         popup.bAction.SetupKey("btn_warnyourfriends");
         popup.bAction.addEventListener(MouseEvent.CLICK,Post);
         popup.bAction.Highlight = true;
         popup.bSpeedup.visible = false;
         POPUPS.Push(popup,null,null,null,weapon.warnPopupImage);
      }
      
      override protected function ShowBragPopup(param1:String) : void
      {
         this.ShowWarnDialog(SiegeWeapons.getWeapon(param1));
      }
      
      override protected function UpgradeWeapon(param1:String) : void
      {
         SiegeWeapons.getWeapon(param1).quantity = 1;
         QUESTS.Check("siege_" + param1 + "_built",SiegeWeapons.getWeapon(param1).quantity);
      }
      
      public function StartUpgradingWeapon(param1:String) : void
      {
         var _loc2_:Object = SiegeWeapons.getWeapon(param1).buildCosts;
         unlockingWeapons[param1] = new SecNum(_loc2_.time);
         BASE.Charge(1,_loc2_.r1,false,true);
         BASE.Charge(2,_loc2_.r2,false,true);
         BASE.Charge(3,_loc2_.r3,false,true);
         BASE.Charge(4,_loc2_.r4,false,true);
         BASE.Save();
         LOGGER.Stat([92,param1,SiegeWeapons.getWeapon(param1).level,"start"]);
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
         var _loc2_:Object = SiegeWeapons.getWeapon(param1).buildCosts;
         BASE.Fund(1,_loc2_.r1,false,null,true);
         BASE.Fund(2,_loc2_.r2,false,null,true);
         BASE.Fund(3,_loc2_.r3,false,null,true);
         BASE.Fund(4,_loc2_.r4,false,null,true);
         BASE.Save();
         LOGGER.Stat([92,param1,SiegeWeapons.getWeapon(param1).level,"cancel"]);
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
         LOGGER.Stat([92,param1,SiegeWeapons.getWeapon(param1).level,"finish"]);
      }
      
      public function InstantUpgrade(param1:String) : void
      {
         var _loc2_:Number = this.getInstantUpgradeCost(param1);
         this.CompleteUpgradingWeapon(param1);
         BASE.Purchase("IBSW",_loc2_,"building");
         LOGGER.Stat([92,param1,SiegeWeapons.getWeapon(param1).level,"instant",_loc2_]);
      }
      
      override public function CompleteUpgradingWeapon(param1:String, param2:Boolean = true) : void
      {
         if(param2)
         {
            this.ShowBragPopup(param1);
         }
         this.UpgradeWeapon(param1);
         this.FinishUpgradingWeapon(param1);
      }
      
      public function getInstantUpgradeCost(param1:String) : int
      {
         var _loc2_:SiegeWeapon = SiegeWeapons.getWeapon(param1);
         var _loc3_:Object = _loc2_.buildCosts;
         if(Boolean(upgradingWeapon) && upgradingWeapon.weaponID == param1)
         {
            return STORE.GetTimeCost(UpgradeTimeLeft(_loc2_));
         }
         return _loc2_.instantBuildCost;
      }
      
      public function HasEnoughShinyToUpgrade(param1:SiegeWeapon) : Boolean
      {
         return BASE._credits.Get() >= this.getInstantUpgradeCost(param1.weaponID);
      }
      
      public function UpgradeTimeTotal(param1:SiegeWeapon) : int
      {
         return param1.buildCosts.time;
      }
   }
}
