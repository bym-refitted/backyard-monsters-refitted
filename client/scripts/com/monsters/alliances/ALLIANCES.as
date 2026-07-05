package com.monsters.alliances
{
   import com.monsters.maproom_advanced.MapRoomCell;
   import flash.events.IOErrorEvent;
   
   public class ALLIANCES
   {
      
      public static var _allianceID:int;
      
      private static var _alliances:Object;
      
      public static var _myAlliance:AllyInfo;

      public static var _isLeader:Boolean = false;

      private static var _open:Boolean;

      private static var _myAllianceData:Object = null;

      private static var _myAllianceLoaded:Boolean = false;

      private static var _myAllianceLoading:Boolean = false;

      private static var _myAlliancePending:Array = [];


      public function ALLIANCES()
      {
         super();
      }

      /**
       * Loads the player's My Alliance payload into the store, firing the network
       * request at most once per open/mutation cycle. A warm cache invokes onDone
       * synchronously; concurrent callers coalesce onto the single in-flight
       * request. Mirrors the original client, which loaded alliance info on popup
       * open and refreshed it on mutations rather than on every tab switch.
       * @param {Function} onDone - Receives the alliance data object, or null when
       *   the player is unaffiliated or the request fails. May be null (warm only).
       * @param {Boolean} force - Bypass the cache and re-fetch (used on popup open).
       */
      public static function LoadMyAlliance(onDone:Function, force:Boolean = false) : void
      {
         if(_myAllianceLoaded && !force)
         {
            if(onDone != null)
            {
               onDone(_myAllianceData);
            }
            return;
         }
         if(onDone != null)
         {
            _myAlliancePending.push(onDone);
         }
         if(_myAllianceLoading)
         {
            return;
         }
         _myAllianceLoading = true;
         var r:URLLoaderApi = new URLLoaderApi();
         r.load(GLOBAL._allianceURL + "myalliance",null,_onMyAllianceLoaded,_onMyAllianceLoadFail);
      }

      private static function _onMyAllianceLoaded(param1:Object) : void
      {
         _myAllianceData = (param1 && param1.alliance) ? param1.alliance : null;
         _myAllianceLoaded = true;
         _myAllianceLoading = false;
         _flushMyAlliancePending();
      }

      private static function _onMyAllianceLoadFail(param1:IOErrorEvent) : void
      {
         _myAllianceData = null;
         _myAllianceLoaded = false;
         _myAllianceLoading = false;
         _flushMyAlliancePending();
      }

      private static function _flushMyAlliancePending() : void
      {
         var _loc1_:Array = _myAlliancePending;
         _myAlliancePending = [];
         for each(var _loc2_:Function in _loc1_)
         {
            if(_loc2_ != null)
            {
               _loc2_(_myAllianceData);
            }
         }
      }

      /**
       * Drops the cached My Alliance payload so the next LoadMyAlliance() re-fetches.
       * Call after any mutation that changes the player's alliance (create, edit,
       * leave, join, kick, promote).
       */
      public static function InvalidateMyAlliance() : void
      {
         _myAllianceLoaded = false;
         _myAllianceData = null;
      }
      
      public static function Setup(param1:int = 0) : void
      {
         _alliances = new Object();
         if(param1 > 0)
         {
            if(GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD)
            {
               _allianceID = param1;
               ACHIEVEMENTS.Check("alliance",1,true);
            }
         }
      }
      
      public static function Clear() : void
      {
         if(_alliances)
         {
            _alliances = null;
         }
         _alliances = new Object();
         if(_myAlliance)
         {
            _myAlliance = null;
         }
         _isLeader = false;
         InvalidateMyAlliance();
      }
      
      public static function SetCellAlliance(param1:MapRoomCell, param2:Boolean = false) : AllyInfo
      {
         var _loc3_:AllyInfo = null;
         var _loc4_:int = 0;
         if(Boolean(param1.allianceID) && param1.allianceID != 0)
         {
            _loc4_ = param1.allianceID;
            if(_alliances[_loc4_])
            {
               _loc3_ = _alliances[_loc4_];
               param1.alliance = _loc3_;
            }
            if(_allianceID && _allianceID != 0 && Boolean(_loc3_))
            {
               _loc3_.Relations(_allianceID);
            }
            return _loc3_;
         }
         return null;
      }
      
      public static function SetAlliance(param1:Object) : AllyInfo
      {
         var _loc2_:AllyInfo = null;
         var _loc3_:int = int(param1.alliance_id);
         if(_alliances[param1.alliance_id])
         {
            _loc2_ = _alliances[_loc3_];
         }
         else
         {
            _loc2_ = new AllyInfo(param1);
         }
         if(_allianceID && _allianceID != 0 && _loc2_ && !_loc2_.relationship)
         {
            _loc2_.Relations(_allianceID);
         }
         return _loc2_;
      }
      
      public static function ProcessAlliances(param1:Array) : void
      {
         var _loc3_:Object = null;
         var _loc4_:AllyInfo = null;
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = param1[_loc2_];
            _loc4_ = new AllyInfo(_loc3_);
            _alliances[_loc3_.alliance_id] = _loc4_;
            _loc2_++;
         }
      }
      
      public static function AllianceInvite(param1:int) : void
      {
         var r:URLLoaderApi;
         var alliancevars:Array;
         var onAllianceInviteSuccess:Function = null;
         var onAllianceInviteFail:Function = null;
         var _userId:int = param1;
         onAllianceInviteSuccess = function(param1:Object):void
         {
            PLEASEWAIT.Hide();
            if(param1.response == "success")
            {
               GLOBAL.Message(KEYS.Get("msg_allianceinvitesent"));
               return;
            }
            if(param1.error)
            {
               GLOBAL.Message(KEYS.Get("msg_err_processinginvite_long") + " - " + param1.error + ": " + param1.error_code);
            }
            else
            {
               GLOBAL.Message(KEYS.Get("msg_err_processinginvite_short"));
            }
         };
         onAllianceInviteFail = function(param1:IOErrorEvent):void
         {
            GLOBAL.Message(KEYS.Get("msg_err_sendinginvite"));
         };
         if(!_myAlliance)
         {
            GLOBAL.Message(KEYS.Get("msg_notinalliance"));
            return;
         }
         r = new URLLoaderApi();
         alliancevars = [["user_id",_userId]];
         r.load(GLOBAL._allianceURL + "inviteuserclient",alliancevars,onAllianceInviteSuccess,onAllianceInviteFail);
      }
      
      public static function AlliancesServerUpdate(param1:String) : void
      {
         if(ALLIANCES._open)
         {
            if(!GLOBAL._local)
            {
               POPUPS.RemoveBG();
            }
            ALLIANCES._open = false;
         }
         if(BASE._userID == LOGIN._playerID)
         {
            BASE.Page();
         }
         else
         {
            BASE.Page();
         }
      }
      
      public static function AlliancesViewLeader(param1:String) : void
      {
      }
   }
}
