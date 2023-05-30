package com.monsters.siege
{
   import com.monsters.siege.weapons.*;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class SiegeWeapons
   {
      
      public static var weapons:Object = {};
      
      public static var activeWeaponID:String;
      
      public static var didActivatWeapon:Boolean = false;
      
      public static var activeWeaponTimer:Timer;
      
      private static var _weaponsList:Object = {};
      
      private static var _poop:String;
      
      {
         _weaponsList[Decoy.ID] = new Decoy();
         _weaponsList[Vacuum.ID] = new Vacuum();
         _weaponsList[Jars.ID] = new Jars();
      }
      
      public function SiegeWeapons()
      {
         super();
      }
      
      public static function getTimeRemaingOnActiveWeapon() : Number
      {
         if(!activeWeapon)
         {
            return -1;
         }
         if(activeWeaponTimer)
         {
            return activeWeaponTimer.repeatCount - activeWeaponTimer.currentCount;
         }
         return -1;
      }
      
      public static function get activeWeapon() : SiegeWeapon
      {
         return getWeapon(activeWeaponID);
      }
      
      public static function addCurrentWeapons(param1:Vector.<SiegeWeapon>) : void
      {
         var _loc2_:String = null;
         for(_loc2_ in _weaponsList)
         {
            param1.push(_weaponsList[_loc2_]);
         }
      }
      
      public static function activateWeapon(param1:String, param2:Number = 0, param3:Number = 0) : Boolean
      {
         var _loc4_:SiegeWeapon;
         if(!(_loc4_ = getWeapon(param1)).activate(param2,param3))
         {
            return false;
         }
         activeWeaponID = param1;
         ATTACK.Log("siegeWeaponActivation","<font color=\"#0000FF\">" + _loc4_.logMessage + "</font>");
         if(_loc4_.duration > 0)
         {
            activeWeaponTimer = new Timer(1000,_loc4_.duration);
            activeWeaponTimer.addEventListener(TimerEvent.TIMER_COMPLETE,onDurationTimerComplete);
            activeWeaponTimer.start();
         }
         --_loc4_.quantity;
         didActivatWeapon = true;
         LOGGER.Stat([93,param1,_loc4_.level]);
         return true;
      }
      
      public static function onDurationTimerComplete(param1:TimerEvent) : void
      {
         deactivateWeapon();
      }
      
      public static function deactivateWeapon() : void
      {
         if(!activeWeapon)
         {
            return;
         }
         if(activeWeaponTimer)
         {
            activeWeaponTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,onDurationTimerComplete);
            activeWeaponTimer.stop();
            activeWeaponTimer.reset();
            activeWeaponTimer = null;
         }
         activeWeapon.deactivate();
         activeWeaponID = null;
      }
      
      public static function importWeapons(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:SiegeWeapon = null;
         var _loc4_:Object = null;
         for(_loc2_ in _weaponsList)
         {
            _loc3_ = getWeapon(_loc2_);
            weapons[_loc2_] = _loc3_;
            if(param1)
            {
               if(_loc4_ = param1[_loc2_])
               {
                  _loc3_.importVariables(_loc4_);
               }
            }
            else
            {
               _loc3_.level = 0;
            }
         }
      }
      
      public static function exportWeapons() : Object
      {
         var _loc1_:Object = null;
         var _loc2_:SiegeWeapon = null;
         for each(_loc2_ in weapons)
         {
            if(_loc2_.level > 0)
            {
               if(!_loc1_)
               {
                  _loc1_ = {};
               }
               _loc1_[_loc2_.weaponID] = _loc2_.exportVariables();
            }
         }
         return _loc1_;
      }
      
      public static function getWeapon(param1:String) : SiegeWeapon
      {
         return _weaponsList[param1];
      }
      
      public static function get availableWeapon() : SiegeWeapon
      {
         var _loc1_:SiegeWeapon = null;
         for each(_loc1_ in weapons)
         {
            if(_loc1_.quantity > 0)
            {
               return _loc1_;
            }
         }
         return null;
      }
      
      public static function Check() : String
      {
         var _loc1_:Array = [];
         var _loc2_:int = 0;
         while(_loc2_ < 10)
         {
            _loc1_.push(getWeapon(Decoy.ID).getProperty(SiegeWeapon.UPGRADE_COSTS).values[_loc2_].r1);
            _loc1_.push(getWeapon(Decoy.ID).getProperty(SiegeWeapon.UPGRADE_COSTS).values[_loc2_].r2);
            _loc1_.push(getWeapon(Decoy.ID).getProperty(SiegeWeapon.UPGRADE_COSTS).values[_loc2_].r3);
            _loc1_.push(getWeapon(Decoy.ID).getProperty(SiegeWeapon.UPGRADE_COSTS).values[_loc2_].r4);
            _loc1_.push(getWeapon(Decoy.ID).getProperty(Decoy.DAMAGE).values[_loc2_]);
            _loc1_.push(getWeapon(Decoy.ID).getProperty(SiegeWeapon.RANGE).values[_loc2_]);
            _loc1_.push(getWeapon(Decoy.ID).getProperty(SiegeWeapon.DURATION).values[_loc2_]);
            _loc1_.push(getWeapon(Vacuum.ID).getProperty(SiegeWeapon.UPGRADE_COSTS).values[_loc2_].r1);
            _loc1_.push(getWeapon(Vacuum.ID).getProperty(SiegeWeapon.UPGRADE_COSTS).values[_loc2_].r2);
            _loc1_.push(getWeapon(Vacuum.ID).getProperty(SiegeWeapon.UPGRADE_COSTS).values[_loc2_].r3);
            _loc1_.push(getWeapon(Vacuum.ID).getProperty(SiegeWeapon.UPGRADE_COSTS).values[_loc2_].r4);
            _loc1_.push(getWeapon(Vacuum.ID).getProperty(SiegeWeapon.DURATION).values[_loc2_]);
            _loc1_.push(getWeapon(Vacuum.ID).getProperty(SiegeWeapon.DURABILITY).values[_loc2_]);
            _loc1_.push(getWeapon(Vacuum.ID).getProperty(Vacuum.LOOT_BONUS).values[_loc2_]);
            _loc1_.push(getWeapon(Jars.ID).getProperty(SiegeWeapon.UPGRADE_COSTS).values[_loc2_].r1);
            _loc1_.push(getWeapon(Jars.ID).getProperty(SiegeWeapon.UPGRADE_COSTS).values[_loc2_].r2);
            _loc1_.push(getWeapon(Jars.ID).getProperty(SiegeWeapon.UPGRADE_COSTS).values[_loc2_].r3);
            _loc1_.push(getWeapon(Jars.ID).getProperty(SiegeWeapon.UPGRADE_COSTS).values[_loc2_].r4);
            _loc1_.push(getWeapon(Jars.ID).getProperty(SiegeWeapon.RANGE).values[_loc2_]);
            _loc1_.push(getWeapon(Jars.ID).getProperty(SiegeWeapon.DURABILITY).values[_loc2_]);
            _loc2_++;
         }
         return md5(JSON.encode(_loc1_));
      }
   }
}
