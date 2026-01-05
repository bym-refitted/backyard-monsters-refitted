package com.monsters.siege
{
   import com.cc.utils.SecNum;
   import com.monsters.siege.weapons.SiegeWeapon;
   import flash.events.Event;
   import flash.geom.Rectangle;
   
   public class SiegeBuilding extends BFOUNDATION
   {
      
      public static const START:String = "siegeBuildingStart";
      
      public static const STOP:String = "siegeBuildingStop";
      
      public static const INSTANT:String = "siegeBuildingInstant";
      
      private static var _popup:SiegeBuildingPopup;
       
      
      public var unlockingWeapons:Object;
      
      public function SiegeBuilding()
      {
         this.unlockingWeapons = {};
         super();
         _footprint = [new Rectangle(0,0,100,100)];
         _gridCost = [[new Rectangle(0,0,100,100),10],[new Rectangle(10,10,80,80),200]];
         _animRandomStart = false;
         SetProps();
      }
      
      public static function Show(param1:String, param2:String = null) : void
      {
         if(!_popup)
         {
            _popup = new SiegeBuildingPopup(param1,param2);
            GLOBAL.BlockerAdd();
            GLOBAL._layerWindows.addChild(_popup);
            POPUPSETTINGS.AlignToCenter(_popup);
            POPUPSETTINGS.ScaleUp(_popup);
         }
      }
      
      public static function Hide() : void
      {
         if(_popup)
         {
            GLOBAL.BlockerRemove();
            SOUNDS.Play("close");
            GLOBAL._layerWindows.removeChild(_popup);
            _popup = null;
         }
      }
      
      public function get upgradingWeapon() : SiegeWeapon
      {
         var _loc1_:String = null;
         var _loc2_:int = 0;
         var _loc3_:* = this.unlockingWeapons;
         for(_loc1_ in _loc3_)
         {
            return SiegeWeapons.getWeapon(_loc1_);
         }
         return null;
      }
      
      public function IsUpgrading(param1:SiegeWeapon) : Boolean
      {
         var _loc2_:String = null;
         for(_loc2_ in this.unlockingWeapons)
         {
            if(param1.weaponID == _loc2_)
            {
               return true;
            }
         }
         return false;
      }
      
      public function UpgradeTimeLeft(param1:SiegeWeapon) : int
      {
         var _loc2_:String = null;
         for(_loc2_ in this.unlockingWeapons)
         {
            if(param1.weaponID == _loc2_)
            {
               return this.unlockingWeapons[_loc2_].Get();
            }
         }
         return -1;
      }
      
      override public function get tickLimit() : int
      {
         var _loc2_:String = null;
         var _loc1_:int = super.tickLimit;
         for(_loc2_ in this.unlockingWeapons)
         {
            _loc1_ = Math.min(_loc1_,this.unlockingWeapons[_loc2_].Get());
         }
         return _loc1_;
      }
      
      override public function Tick(param1:int) : void
      {
         var _loc2_:String = null;
         if(!_destroyed)
         {
            for(_loc2_ in this.unlockingWeapons)
            {
               if(this.unlockingWeapons[_loc2_].Get() > 0)
               {
                  this.unlockingWeapons[_loc2_].Add(-param1);
               }
               if(this.unlockingWeapons[_loc2_].Get() <= 0)
               {
                  this.CompleteUpgradingWeapon(_loc2_);
               }
            }
         }
         super.Tick(param1);
      }
      
      public function CompleteUpgradingWeapon(param1:String, param2:Boolean = true) : void
      {
      }
      
      override public function TickFast(param1:Event = null) : void
      {
         super.TickFast(param1);
         if(this.upgradingWeapon)
         {
            AnimFrame();
         }
      }
      
      override public function Setup(param1:Object) : void
      {
         var _loc2_:String = null;
         super.Setup(param1);
         if(Boolean(param1.unlockingWeapons) && !(param1.unlockingWeapons is Array))
         {
            this.unlockingWeapons = {};
            for(_loc2_ in param1.unlockingWeapons)
            {
               this.unlockingWeapons[_loc2_] = new SecNum(param1.unlockingWeapons[_loc2_] - GLOBAL.Timestamp());
            }
         }
         else if(param1.unlockingWeapons2)
         {
            this.unlockingWeapons = {};
            for(_loc2_ in param1.unlockingWeapons2)
            {
               this.unlockingWeapons[_loc2_] = new SecNum(param1.unlockingWeapons2[_loc2_]);
            }
         }
      }
      
      override public function Export() : Object
      {
         var _loc2_:String = null;
         var _loc1_:Object = super.Export();
         if(this.unlockingWeapons)
         {
            _loc1_.unlockingWeapons2 = {};
            for(_loc2_ in this.unlockingWeapons)
            {
               _loc1_.unlockingWeapons2[_loc2_] = this.unlockingWeapons[_loc2_].Get();
            }
         }
         return _loc1_;
      }
      
      protected function UpgradeWeapon(param1:String) : void
      {
      }
      
      protected function ShowBragPopup(param1:String) : void
      {
      }
   }
}
