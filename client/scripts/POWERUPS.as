package
{
   import com.cc.utils.SecNum;
   import com.monsters.alliances.ALLIANCES;
   import com.monsters.baseBuffs.BaseBuffHandler;
   import com.monsters.baseBuffs.buffs.AllianceArmamentBuff;
   import com.monsters.baseBuffs.buffs.AllianceConquestBuff;
   import com.monsters.baseBuffs.buffs.AllianceDeclareWarBuff;
   import com.monsters.debug.Console;
   
   public class POWERUPS
   {
      
      public static var _powerups:Object;
      
      public static var _attpowerups:Object;
      
      public static var _powerupProps:Object;
      
      public static var _mypowerups:Object;
      
      public static var OFFENSE:Boolean = false;
      
      public static var DEFENSE:Boolean = false;
      
      public static var NORMAL:Boolean = false;
      
      public static const ALLIANCE_TYPE_DEFENSE:String = "DEFENSE";
      
      public static const ALLIANCE_ARMAMENT:String = "ap_armament";
      
      public static const ALLIANCE_CONQUEST:String = "ap_conquest";
      
      public static const ALLIANCE_DECLAREWAR:String = "ap_declarewar";
      
      public static const _expireRealTime:Boolean = false;
      
      public static const _updateOnPage:Boolean = true;
      
      public static var _testToggleOffPowers:Boolean = false;
       
      
      public function POWERUPS()
      {
         super();
      }
      
      public static function Setup(param1:Array = null, param2:Array = null, param3:Boolean = false) : void
      {
         var _loc4_:int = 0;
         var _loc5_:SecNum = null;
         if(!_powerupProps)
         {
            _powerupProps = new Object();
            _powerupProps[ALLIANCE_ARMAMENT] = {
               "id":1,
               "endtime":0,
               "duration":0,
               "cooldown":0,
               "mod":PowArmament
            };
            _powerupProps[ALLIANCE_CONQUEST] = {
               "id":1,
               "endtime":0,
               "duration":0,
               "cooldown":0,
               "mod":PowConquest
            };
            _powerupProps[ALLIANCE_DECLAREWAR] = {
               "id":1,
               "endtime":0,
               "duration":0,
               "cooldown":0,
               "mod":PowDeclareWar
            };
            if(!_powerups)
            {
               _powerups = new Object();
            }
            if(!_attpowerups)
            {
               _attpowerups = new Object();
            }
            if(!_mypowerups)
            {
               _mypowerups = new Object();
            }
         }
         GetMode();
         Clear(param3);
         if(_testToggleOffPowers || !_updateOnPage)
         {
            return;
         }
         if(param1)
         {
            _loc4_ = 0;
            while(_loc4_ < param1.length)
            {
               if(Boolean(param1[_loc4_].id) && Boolean(param1[_loc4_].endtime))
               {
                  (_loc5_ = new SecNum(0)).Set(param1[_loc4_].endtime);
                  _powerups[param1[_loc4_].id] = {
                     "name":param1[_loc4_].id,
                     "endtime":_loc5_
                  };
                  if(DEFENSE)
                  {
                     _mypowerups[param1[_loc4_].id] = {
                        "name":param1[_loc4_].id,
                        "endtime":_loc5_
                     };
                  }
               }
               _loc4_++;
            }
         }
         if(param2)
         {
            _loc4_ = 0;
            while(_loc4_ < param2.length)
            {
               if(Boolean(param2[_loc4_].id) && Boolean(param2[_loc4_].endtime))
               {
                  (_loc5_ = new SecNum(0)).Set(param2[_loc4_].endtime);
                  _attpowerups[param2[_loc4_].id] = {
                     "name":param2[_loc4_].id,
                     "endtime":_loc5_
                  };
                  if(OFFENSE)
                  {
                     _mypowerups[param2[_loc4_].id] = {
                        "name":param2[_loc4_].id,
                        "endtime":_loc5_
                     };
                  }
                  else if(NORMAL)
                  {
                     _mypowerups[param2[_loc4_].id] = {
                        "name":param2[_loc4_].id,
                        "endtime":_loc5_
                     };
                  }
               }
               _loc4_++;
            }
         }
         if(CheckPowers(ALLIANCE_ARMAMENT) && DEFENSE && !BaseBuffHandler.instance.getBuffByID(AllianceArmamentBuff.ID))
         {
            BaseBuffHandler.instance.addBuffByID(AllianceArmamentBuff.ID);
         }
         if(Boolean(CheckPowers(ALLIANCE_CONQUEST)) && !BaseBuffHandler.instance.getBuffByID(AllianceConquestBuff.ID))
         {
            BaseBuffHandler.instance.addBuffByID(AllianceConquestBuff.ID);
         }
         if(Boolean(CheckPowers(ALLIANCE_DECLAREWAR)) && !BaseBuffHandler.instance.getBuffByID(AllianceDeclareWarBuff.ID))
         {
            BaseBuffHandler.instance.addBuffByID(AllianceDeclareWarBuff.ID);
         }
      }
      
      public static function Apply(param1:String, param2:Array) : Number
      {
         var _loc4_:Function = null;
         GetMode();
         var _loc3_:Number = 0;
         if(NORMAL)
         {
            if(_powerupProps && _powerupProps[param1] && _mypowerups && Boolean(_mypowerups[param1]))
            {
               _loc4_ = _powerupProps[param1].mod;
               if(_expireRealTime && _mypowerups[param1].endtime.Get() < GLOBAL.Timestamp())
               {
                  _loc3_ = Number(param2[0]);
               }
               else
               {
                  _loc3_ = _loc4_.apply(null,param2);
               }
            }
            else
            {
               _loc3_ = Number(param2[0]);
            }
         }
         if(DEFENSE)
         {
            if(_powerupProps && _powerupProps[param1] && _powerups && Boolean(_powerups[param1]))
            {
               _loc4_ = _powerupProps[param1].mod;
               if(_expireRealTime && _powerups[param1].endtime.Get() < GLOBAL.Timestamp())
               {
                  _loc3_ = Number(param2[0]);
               }
               else
               {
                  _loc3_ = _loc4_.apply(null,param2);
               }
            }
            else
            {
               _loc3_ = Number(param2[0]);
            }
         }
         if(OFFENSE)
         {
            if(_powerupProps && _powerupProps[param1] && _attpowerups && Boolean(_attpowerups[param1]))
            {
               _loc4_ = _powerupProps[param1].mod;
               if(_expireRealTime && _attpowerups[param1].endtime.Get() < GLOBAL.Timestamp())
               {
                  _loc3_ = Number(param2[0]);
               }
               else
               {
                  _loc3_ = _loc4_.apply(null,param2);
               }
            }
            else
            {
               _loc3_ = Number(param2[0]);
            }
         }
         return _loc3_;
      }
      
      public static function CheckPowers(param1:String = null, param2:String = null) : int
      {
         var _loc3_:Object = null;
         var _loc4_:Number = NaN;
         var _loc5_:String = null;
         GetMode();
         if(NORMAL)
         {
            _loc3_ = _mypowerups;
         }
         if(DEFENSE)
         {
            _loc3_ = _powerups;
         }
         if(OFFENSE)
         {
            _loc3_ = _attpowerups;
         }
         if(param2)
         {
            if(param2 == "NORMAL")
            {
               _loc3_ = _mypowerups;
            }
            if(param2 == "DEFENSE")
            {
               _loc3_ = _powerups;
            }
            if(param2 == "OFFENSE")
            {
               _loc3_ = _attpowerups;
            }
         }
         if(param1)
         {
            if(Boolean(_loc3_) && Boolean(_loc3_[param1]))
            {
               if(_expireRealTime)
               {
                  if(_loc3_[param1].endtime.Get() < GLOBAL.Timestamp())
                  {
                     return 0;
                  }
               }
               return 1;
            }
            return 0;
         }
         _loc4_ = 0;
         for(_loc5_ in _loc3_)
         {
            if(_expireRealTime)
            {
               if(_loc3_[_loc5_].endtime.Get() > GLOBAL.Timestamp())
               {
                  _loc4_++;
               }
            }
            else
            {
               _loc4_++;
            }
         }
         return _loc4_;
      }
      
      public static function Timeleft(param1:String, param2:String = null) : Number
      {
         var _loc3_:Object = null;
         var _loc4_:Number = NaN;
         GetMode();
         if(NORMAL)
         {
            _loc3_ = _mypowerups;
         }
         if(DEFENSE)
         {
            _loc3_ = _powerups;
         }
         if(OFFENSE)
         {
            _loc3_ = _attpowerups;
         }
         if(param2)
         {
            if(param2 == "NORMAL")
            {
               _loc3_ = _mypowerups;
            }
            if(param2 == "DEFENSE")
            {
               _loc3_ = _powerups;
            }
            if(param2 == "OFFENSE")
            {
               _loc3_ = _attpowerups;
            }
         }
         if(Boolean(_loc3_) && Boolean(_loc3_[param1]))
         {
            return _loc3_[param1].endtime.Get() - GLOBAL.Timestamp();
         }
         return 0;
      }
      
      public static function Remove(param1:String, param2:String = null) : void
      {
         GetMode();
         if(NORMAL || param2 == "NORMAL")
         {
            if(_powerupProps && _powerupProps[param1] && _mypowerups && Boolean(_mypowerups[param1]))
            {
               _mypowerups[param1].endtime.Set(GLOBAL.Timestamp());
            }
         }
         if(DEFENSE || param2 == "DEFENSE")
         {
            if(_powerupProps && _powerupProps[param1] && _powerups && Boolean(_powerups[param1]))
            {
               _powerups[param1].endtime.Set(GLOBAL.Timestamp());
            }
         }
         if(OFFENSE || param2 == "OFFENSE")
         {
            if(_powerupProps && _powerupProps[param1] && _attpowerups && Boolean(_attpowerups[param1]))
            {
               _attpowerups[param1].endtime.Set(GLOBAL.Timestamp());
            }
         }
      }
      
      public static function GetMode() : void
      {
         if(GLOBAL.mode == GLOBAL.e_BASE_MODE.ATTACK || GLOBAL.mode == GLOBAL.e_BASE_MODE.WMATTACK)
         {
            OFFENSE = true;
            DEFENSE = false;
            NORMAL = false;
         }
         else if(GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD)
         {
            OFFENSE = false;
            DEFENSE = true;
            NORMAL = false;
         }
         else
         {
            OFFENSE = false;
            DEFENSE = false;
            NORMAL = true;
         }
      }
      
      public static function GetPowerups(param1:String = null) : Object
      {
         var _loc2_:Object = null;
         GetMode();
         if(NORMAL)
         {
            _loc2_ = _mypowerups;
         }
         if(DEFENSE)
         {
            _loc2_ = _powerups;
         }
         if(OFFENSE)
         {
            _loc2_ = _attpowerups;
         }
         if(param1)
         {
            if(param1 == "NORMAL")
            {
               _loc2_ = _mypowerups;
            }
            if(param1 == "DEFENSE")
            {
               _loc2_ = _powerups;
            }
            if(param1 == "OFFENSE")
            {
               _loc2_ = _attpowerups;
            }
         }
         return _loc2_;
      }
      
      private static function PowArmament(... rest) : Number
      {
         Console.warning("Alliance Armament shouldnt be called this way, it should be a base buff");
         return 0;
      }
      
      private static function PowConquest(... rest) : Number
      {
         return Math.ceil(rest[0] * 0.75);
      }
      
      private static function PowDeclareWar(... rest) : Number
      {
         var _loc2_:Number = Number(rest[0]);
         return rest[0] + 2;
      }
      
      public static function Clear(param1:Boolean = false) : void
      {
         if(_updateOnPage || param1)
         {
            if(_powerups)
            {
               _powerups = null;
            }
            _powerups = new Object();
            if(_attpowerups)
            {
               _attpowerups = null;
            }
            _attpowerups = new Object();
            if(_mypowerups)
            {
               _mypowerups = null;
            }
            _mypowerups = new Object();
         }
      }
      
      public static function Validate() : void
      {
         GetMode();
         if(!ALLIANCES._myAlliance)
         {
            if(_mypowerups)
            {
               _mypowerups = null;
            }
            _mypowerups = new Object();
         }
         if(DEFENSE && !ALLIANCES._allianceID && BASE._userID == LOGIN._playerID)
         {
            if(_powerups)
            {
               _powerups = null;
            }
            _powerups = new Object();
         }
         if(OFFENSE && !ALLIANCES._allianceID && BASE._userID != LOGIN._playerID)
         {
            if(_attpowerups)
            {
               _attpowerups = null;
            }
            _attpowerups = new Object();
         }
      }
   }
}
