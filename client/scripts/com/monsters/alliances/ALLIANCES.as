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

      private static var _messagesData:Array = null;

      private static var _messagesLoaded:Boolean = false;

      private static var _messagesLoading:Boolean = false;

      private static var _messagesPending:Array = [];


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
      
      /**
       * Loads the player's inbox into the store. One inbox carries both directions:
       * invites and join requests waiting on them, plus the outcomes of whatever
       * they sent.
       *
       * Cached and coalesced like LoadMyAlliance, because the alliance window needs
       * the rows on open to label the Invites tab and the tab itself needs the same
       * rows to draw - one request serves both.
       *
       * @param {Function} onDone - Receives the message rows, or null on failure. May be null (warm only).
       * @param {Boolean} force - Bypass the cache and re-fetch.
       */
      public static function LoadMessages(onDone:Function, force:Boolean = false) : void
      {
         if (_messagesLoaded && !force)
         {
            if(onDone != null) onDone(_messagesData);
            return;
         }

         if (onDone != null) _messagesPending.push(onDone);

         if (_messagesLoading) return;

         _messagesLoading = true;
         new URLLoaderApi().load(GLOBAL._allianceURL + "getmessages",null,_onMessagesLoaded,_onMessagesLoadFail);
      }

      private static function _onMessagesLoaded(response:Object) : void
      {
         _messagesData = (response && !response.error) ? response.messages as Array : null;
         _messagesLoaded = true;
         _messagesLoading = false;
         _flushMessagesPending();
      }

      private static function _onMessagesLoadFail(error:IOErrorEvent) : void
      {
         _messagesData = null;
         _messagesLoaded = false;
         _messagesLoading = false;
         _flushMessagesPending();
      }

      private static function _flushMessagesPending() : void
      {
         var waiting:Array = _messagesPending;
         _messagesPending = [];

         for each (var callback:Function in waiting)
         {
            if (callback != null) callback(_messagesData);
         }
      }

      public static function InvalidateMessages() : void
      {
         _messagesLoaded = false;
         _messagesData = null;
      }

      /**
       * Rows in the cached inbox still waiting on the player, which labels the
       * Invites tab. Reads the cache rather than asking the server, so it is only
       * as fresh as the last LoadMessages().
       * 
       * @returns {int} Pending rows, or 0 before the inbox has loaded.
       */
      public static function PendingInviteCount() : int
      {
         if (_messagesData == null) return 0;

         var pending:int = 0;
         for each (var message:Object in _messagesData)
         {
            if (String(message.status) == AllianceConstants.INVITE_PENDING)
            {
               pending++;
            }
         }
         return pending;
      }

      /**
       * Members in the player's alliance, from the cached My Alliance payload.
       * 
       * @returns {int} Member count, or 0 when unaffiliated or not yet loaded.
       */
      public static function MemberCount() : int
      {
         return (_myAllianceData != null) ? int(_myAllianceData.number_of_members) : 0;
      }

      /**
       * How many members the alliance may hold, as reported by the server that
       * enforces it. Only read where the Members tab is drawn, which happens only
       * while in an alliance, so the payload is always present.
       * 
       * @returns {int} The cap, or 0 when unaffiliated or not yet loaded.
       */
      public static function MaxMembers() : int
      {
         return (_myAllianceData != null) ? int(_myAllianceData.max_members) : 0;
      }

      /**
       * Answers a pending invite or join request. Accepting either one changes the
       * player's roster, so the My Alliance cache is dropped on success.
       * 
       * @param {int} inviteId - The row being answered.
       * @param {String} status - "accepted" or "declined".
       * @param {Function} onDone - Receives the server response.
       */
      public static function ChangeInviteStatus(inviteId:int, status:String, onDone:Function) : void
      {
         new URLLoaderApi().load(GLOBAL._allianceURL + "changeinvitestatus",[["invite_id",inviteId],["status",status]],
               function(response:Object):void
               {
                  if (response != null && !response.error)
                  {
                     InvalidateMyAlliance();
                     InvalidateMessages();
                  }
                  onDone(response);
               },
               function(e:IOErrorEvent):void
               {
                  onDone(null);
               });
      }

      /**
       * Asks an alliance to take the player in, from the Browse tab.
       * 
       * @param {int} allianceId - The alliance being asked.
       * @param {Function} onDone - Receives the server response.
       */
      public static function RequestJoin(allianceId:int, onDone:Function) : void
      {
         new URLLoaderApi().load(GLOBAL._allianceURL + "requestjoin",[["alliance_id",allianceId]],
               function(response:Object):void
               {
                  onDone(response);
               },
               function(e:IOErrorEvent):void
               {
                  onDone(null);
               });
      }

      /**
       * Clears the rows checked in the Invites tab.
       * 
       * @param {String} inviteIds - Comma-separated invite ids, as the original sent them.
       * @param {Function} onDone - Receives the server response.
       */
      public static function DeleteMessages(inviteIds:String, onDone:Function) : void
      {
         new URLLoaderApi().load(GLOBAL._allianceURL + "deletemessages",[["invite_ids",inviteIds]],
               function(response:Object):void
               {
                  if (response != null && !response.error)
                  {
                     InvalidateMessages();
                  }
                  onDone(response);
               },
               function(e:IOErrorEvent):void
               {
                  onDone(null);
               });
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
         InvalidateMessages();
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
            if(param1 != null && !param1.error)
            {
               GLOBAL.Message(KEYS.Get("msg_allianceinvitesent"));
               return;
            }
            if(param1 && param1.error)
            {
               GLOBAL.Message(String(param1.error));
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
         r.load(GLOBAL._allianceURL + "inviteuser",alliancevars,onAllianceInviteSuccess,onAllianceInviteFail);
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
