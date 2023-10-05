package com.smartfoxserver.v2.controllers
{
   import com.smartfoxserver.v2.SmartFox;
   import com.smartfoxserver.v2.bitswarm.BaseController;
   import com.smartfoxserver.v2.bitswarm.BitSwarmClient;
   import com.smartfoxserver.v2.bitswarm.IMessage;
   import com.smartfoxserver.v2.core.SFSBuddyEvent;
   import com.smartfoxserver.v2.core.SFSEvent;
   import com.smartfoxserver.v2.entities.Buddy;
   import com.smartfoxserver.v2.entities.Room;
   import com.smartfoxserver.v2.entities.SFSBuddy;
   import com.smartfoxserver.v2.entities.SFSRoom;
   import com.smartfoxserver.v2.entities.SFSUser;
   import com.smartfoxserver.v2.entities.User;
   import com.smartfoxserver.v2.entities.data.ISFSArray;
   import com.smartfoxserver.v2.entities.data.ISFSObject;
   import com.smartfoxserver.v2.entities.invitation.Invitation;
   import com.smartfoxserver.v2.entities.invitation.SFSInvitation;
   import com.smartfoxserver.v2.entities.managers.IRoomManager;
   import com.smartfoxserver.v2.entities.managers.IUserManager;
   import com.smartfoxserver.v2.entities.variables.BuddyVariable;
   import com.smartfoxserver.v2.entities.variables.ReservedBuddyVariables;
   import com.smartfoxserver.v2.entities.variables.RoomVariable;
   import com.smartfoxserver.v2.entities.variables.SFSBuddyVariable;
   import com.smartfoxserver.v2.entities.variables.SFSRoomVariable;
   import com.smartfoxserver.v2.entities.variables.SFSUserVariable;
   import com.smartfoxserver.v2.entities.variables.UserVariable;
   import com.smartfoxserver.v2.kernel;
   import com.smartfoxserver.v2.requests.BaseRequest;
   import com.smartfoxserver.v2.requests.ChangeRoomCapacityRequest;
   import com.smartfoxserver.v2.requests.ChangeRoomNameRequest;
   import com.smartfoxserver.v2.requests.ChangeRoomPasswordStateRequest;
   import com.smartfoxserver.v2.requests.CreateRoomRequest;
   import com.smartfoxserver.v2.requests.FindRoomsRequest;
   import com.smartfoxserver.v2.requests.FindUsersRequest;
   import com.smartfoxserver.v2.requests.GenericMessageRequest;
   import com.smartfoxserver.v2.requests.GenericMessageType;
   import com.smartfoxserver.v2.requests.JoinRoomRequest;
   import com.smartfoxserver.v2.requests.LoginRequest;
   import com.smartfoxserver.v2.requests.LogoutRequest;
   import com.smartfoxserver.v2.requests.PlayerToSpectatorRequest;
   import com.smartfoxserver.v2.requests.SetRoomVariablesRequest;
   import com.smartfoxserver.v2.requests.SetUserVariablesRequest;
   import com.smartfoxserver.v2.requests.SpectatorToPlayerRequest;
   import com.smartfoxserver.v2.requests.SubscribeRoomGroupRequest;
   import com.smartfoxserver.v2.requests.buddylist.AddBuddyRequest;
   import com.smartfoxserver.v2.requests.buddylist.BlockBuddyRequest;
   import com.smartfoxserver.v2.requests.buddylist.GoOnlineRequest;
   import com.smartfoxserver.v2.requests.buddylist.InitBuddyListRequest;
   import com.smartfoxserver.v2.requests.buddylist.RemoveBuddyRequest;
   import com.smartfoxserver.v2.requests.buddylist.SetBuddyVariablesRequest;
   import com.smartfoxserver.v2.requests.game.InviteUsersRequest;
   import com.smartfoxserver.v2.util.BuddyOnlineState;
   import com.smartfoxserver.v2.util.ClientDisconnectionReason;
   import com.smartfoxserver.v2.util.SFSErrorCodes;
   
   public class SystemController extends BaseController
   {
       
      
      private var sfs:SmartFox;
      
      private var bitSwarm:BitSwarmClient;
      
      private var requestHandlers:Object;
      
      public function SystemController(param1:BitSwarmClient)
      {
         super();
         this.bitSwarm = param1;
         this.sfs = param1.sfs;
         this.requestHandlers = new Object();
         this.initRequestHandlers();
      }
      
      private function initRequestHandlers() : void
      {
         this.requestHandlers[BaseRequest.Handshake] = "fnHandshake";
         this.requestHandlers[BaseRequest.Login] = "fnLogin";
         this.requestHandlers[BaseRequest.Logout] = "fnLogout";
         this.requestHandlers[BaseRequest.JoinRoom] = "fnJoinRoom";
         this.requestHandlers[BaseRequest.CreateRoom] = "fnCreateRoom";
         this.requestHandlers[BaseRequest.GenericMessage] = "fnGenericMessage";
         this.requestHandlers[BaseRequest.ChangeRoomName] = "fnChangeRoomName";
         this.requestHandlers[BaseRequest.ChangeRoomPassword] = "fnChangeRoomPassword";
         this.requestHandlers[BaseRequest.ChangeRoomCapacity] = "fnChangeRoomCapacity";
         this.requestHandlers[BaseRequest.ObjectMessage] = "fnSendObject";
         this.requestHandlers[BaseRequest.SetRoomVariables] = "fnSetRoomVariables";
         this.requestHandlers[BaseRequest.SetUserVariables] = "fnSetUserVariables";
         this.requestHandlers[BaseRequest.CallExtension] = "fnCallExtension";
         this.requestHandlers[BaseRequest.SubscribeRoomGroup] = "fnSubscribeRoomGroup";
         this.requestHandlers[BaseRequest.UnsubscribeRoomGroup] = "fnUnsubscribeRoomGroup";
         this.requestHandlers[BaseRequest.SpectatorToPlayer] = "fnSpectatorToPlayer";
         this.requestHandlers[BaseRequest.PlayerToSpectator] = "fnPlayerToSpectator";
         this.requestHandlers[BaseRequest.InitBuddyList] = "fnInitBuddyList";
         this.requestHandlers[BaseRequest.AddBuddy] = "fnAddBuddy";
         this.requestHandlers[BaseRequest.RemoveBuddy] = "fnRemoveBuddy";
         this.requestHandlers[BaseRequest.BlockBuddy] = "fnBlockBuddy";
         this.requestHandlers[BaseRequest.GoOnline] = "fnGoOnline";
         this.requestHandlers[BaseRequest.SetBuddyVariables] = "fnSetBuddyVariables";
         this.requestHandlers[BaseRequest.FindRooms] = "fnFindRooms";
         this.requestHandlers[BaseRequest.FindUsers] = "fnFindUsers";
         this.requestHandlers[BaseRequest.InviteUser] = "fnInviteUsers";
         this.requestHandlers[BaseRequest.InvitationReply] = "fnInvitationReply";
         this.requestHandlers[BaseRequest.QuickJoinGame] = "fnQuickJoinGame";
         this.requestHandlers[BaseRequest.PingPong] = "fnPingPong";
         this.requestHandlers[1000] = "fnUserEnterRoom";
         this.requestHandlers[1001] = "fnUserCountChange";
         this.requestHandlers[1002] = "fnUserLost";
         this.requestHandlers[1003] = "fnRoomLost";
         this.requestHandlers[1004] = "fnUserExitRoom";
         this.requestHandlers[1005] = "fnClientDisconnection";
      }
      
      override public function handleMessage(param1:IMessage) : void
      {
         if(this.sfs.debug)
         {
            log.info(this.getEvtName(param1.id),param1);
         }
         var _loc2_:String = String(this.requestHandlers[param1.id]);
         if(_loc2_ != null)
         {
            this[_loc2_](param1);
         }
         else
         {
            log.warn("Unknown message id: " + param1.id);
         }
      }
      
      private function getEvtName(param1:int) : String
      {
         var _loc2_:String = String(this.requestHandlers[param1]);
         return _loc2_.substr(2);
      }
      
      private function fnHandshake(param1:IMessage) : void
      {
         var _loc2_:Object = {"message":param1};
         this.sfs.dispatchEvent(new SFSEvent(SFSEvent.HANDSHAKE,_loc2_));
      }
      
      private function fnLogin(param1:IMessage) : void
      {
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc2_:ISFSObject = param1.content;
         var _loc3_:Object = {};
         if(_loc2_.isNull(BaseRequest.KEY_ERROR_CODE))
         {
            this.populateRoomList(_loc2_.getSFSArray(LoginRequest.KEY_ROOMLIST));
            this.sfs.mySelf = new SFSUser(_loc2_.getInt(LoginRequest.KEY_ID),_loc2_.getUtfString(LoginRequest.KEY_USER_NAME),true);
            this.sfs.mySelf.userManager = this.sfs.userManager;
            this.sfs.mySelf.privilegeId = _loc2_.getShort(LoginRequest.KEY_PRIVILEGE_ID);
            this.sfs.userManager.addUser(this.sfs.mySelf);
            this.sfs.setReconnectionSeconds(_loc2_.getShort(LoginRequest.KEY_RECONNECTION_SECONDS));
            _loc3_.zone = _loc2_.getUtfString(LoginRequest.KEY_ZONE_NAME);
            _loc3_.user = this.sfs.mySelf;
            _loc3_.data = _loc2_.getSFSObject(LoginRequest.KEY_PARAMS);
            this.sfs.dispatchEvent(new SFSEvent(SFSEvent.LOGIN,_loc3_));
         }
         else
         {
            _loc4_ = _loc2_.getShort(BaseRequest.KEY_ERROR_CODE);
            _loc5_ = SFSErrorCodes.getErrorMessage(_loc4_,_loc2_.getUtfStringArray(BaseRequest.KEY_ERROR_PARAMS));
            _loc3_ = {
               "errorMessage":_loc5_,
               "errorCode":_loc4_
            };
            this.sfs.dispatchEvent(new SFSEvent(SFSEvent.LOGIN_ERROR,_loc3_));
         }
      }
      
      private function fnCreateRoom(param1:IMessage) : void
      {
         var _loc4_:IRoomManager = null;
         var _loc5_:Room = null;
         var _loc6_:int = 0;
         var _loc7_:String = null;
         var _loc2_:ISFSObject = param1.content;
         var _loc3_:Object = {};
         if(_loc2_.isNull(BaseRequest.KEY_ERROR_CODE))
         {
            _loc4_ = this.sfs.roomManager;
            (_loc5_ = SFSRoom.fromSFSArray(_loc2_.getSFSArray(CreateRoomRequest.KEY_ROOM))).roomManager = this.sfs.roomManager;
            _loc4_.addRoom(_loc5_);
            _loc3_.room = _loc5_;
            this.sfs.dispatchEvent(new SFSEvent(SFSEvent.ROOM_ADD,_loc3_));
         }
         else
         {
            _loc6_ = _loc2_.getShort(BaseRequest.KEY_ERROR_CODE);
            _loc7_ = SFSErrorCodes.getErrorMessage(_loc6_,_loc2_.getUtfStringArray(BaseRequest.KEY_ERROR_PARAMS));
            _loc3_ = {
               "errorMessage":_loc7_,
               "errorCode":_loc6_
            };
            this.sfs.dispatchEvent(new SFSEvent(SFSEvent.ROOM_CREATION_ERROR,_loc3_));
         }
      }
      
      private function fnJoinRoom(param1:IMessage) : void
      {
         var _loc5_:ISFSArray = null;
         var _loc6_:ISFSArray = null;
         var _loc7_:Room = null;
         var _loc8_:int = 0;
         var _loc9_:ISFSArray = null;
         var _loc10_:User = null;
         var _loc11_:int = 0;
         var _loc12_:String = null;
         var _loc2_:IRoomManager = this.sfs.roomManager;
         var _loc3_:ISFSObject = param1.content;
         var _loc4_:Object = {};
         this.sfs.isJoining = false;
         if(_loc3_.isNull(BaseRequest.KEY_ERROR_CODE))
         {
            _loc5_ = _loc3_.getSFSArray(JoinRoomRequest.KEY_ROOM);
            _loc6_ = _loc3_.getSFSArray(JoinRoomRequest.KEY_USER_LIST);
            (_loc7_ = SFSRoom.fromSFSArray(_loc5_)).roomManager = this.sfs.roomManager;
            _loc7_ = _loc2_.replaceRoom(_loc7_,_loc2_.containsGroup(_loc7_.groupId));
            _loc8_ = 0;
            while(_loc8_ < _loc6_.size())
            {
               _loc9_ = _loc6_.getSFSArray(_loc8_);
               (_loc10_ = this.getOrCreateUser(_loc9_,true,_loc7_)).setPlayerId(_loc9_.getShort(3),_loc7_);
               _loc7_.addUser(_loc10_);
               _loc8_++;
            }
            _loc7_.isJoined = true;
            this.sfs.lastJoinedRoom = _loc7_;
            _loc4_.room = _loc7_;
            this.sfs.dispatchEvent(new SFSEvent(SFSEvent.ROOM_JOIN,_loc4_));
         }
         else
         {
            _loc11_ = _loc3_.getShort(BaseRequest.KEY_ERROR_CODE);
            _loc12_ = SFSErrorCodes.getErrorMessage(_loc11_,_loc3_.getUtfStringArray(BaseRequest.KEY_ERROR_PARAMS));
            _loc4_ = {
               "errorMessage":_loc12_,
               "errorCode":_loc11_
            };
            this.sfs.dispatchEvent(new SFSEvent(SFSEvent.ROOM_JOIN_ERROR,_loc4_));
         }
      }
      
      private function fnUserEnterRoom(param1:IMessage) : void
      {
         var _loc5_:ISFSArray = null;
         var _loc6_:User = null;
         var _loc2_:ISFSObject = param1.content;
         var _loc3_:Object = {};
         var _loc4_:Room;
         if((_loc4_ = this.sfs.roomManager.getRoomById(_loc2_.getInt("r"))) != null)
         {
            _loc5_ = _loc2_.getSFSArray("u");
            _loc6_ = this.getOrCreateUser(_loc5_,true,_loc4_);
            _loc4_.addUser(_loc6_);
            this.sfs.dispatchEvent(new SFSEvent(SFSEvent.USER_ENTER_ROOM,{
               "user":_loc6_,
               "room":_loc4_
            }));
         }
      }
      
      private function fnUserCountChange(param1:IMessage) : void
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc2_:ISFSObject = param1.content;
         var _loc3_:Object = {};
         var _loc4_:Room;
         if((_loc4_ = this.sfs.roomManager.getRoomById(_loc2_.getInt("r"))) != null)
         {
            _loc5_ = _loc2_.getShort("uc");
            _loc6_ = 0;
            if(_loc2_.containsKey("sc"))
            {
               _loc6_ = _loc2_.getShort("sc");
            }
            _loc4_.userCount = _loc5_;
            _loc4_.spectatorCount = _loc6_;
            this.sfs.dispatchEvent(new SFSEvent(SFSEvent.USER_COUNT_CHANGE,{
               "room":_loc4_,
               "uCount":_loc5_,
               "sCount":_loc6_
            }));
         }
      }
      
      private function fnUserLost(param1:IMessage) : void
      {
         var _loc5_:Array = null;
         var _loc6_:Room = null;
         var _loc2_:ISFSObject = param1.content;
         var _loc3_:int = _loc2_.getInt("u");
         var _loc4_:User;
         if((_loc4_ = this.sfs.userManager.getUserById(_loc3_)) != null)
         {
            _loc5_ = this.sfs.roomManager.getUserRooms(_loc4_);
            this.sfs.roomManager.removeUser(_loc4_);
            this.sfs.userManager.removeUser(_loc4_);
            for each(_loc6_ in _loc5_)
            {
               this.sfs.dispatchEvent(new SFSEvent(SFSEvent.USER_EXIT_ROOM,{
                  "user":_loc4_,
                  "room":_loc6_
               }));
            }
         }
      }
      
      private function fnRoomLost(param1:IMessage) : void
      {
         var _loc7_:User = null;
         var _loc2_:ISFSObject = param1.content;
         var _loc3_:Object = {};
         var _loc4_:int = _loc2_.getInt("r");
         var _loc5_:Room = this.sfs.roomManager.getRoomById(_loc4_);
         var _loc6_:IUserManager = this.sfs.userManager;
         if(_loc5_ != null)
         {
            this.sfs.roomManager.removeRoom(_loc5_);
            for each(_loc7_ in _loc5_.userList)
            {
               _loc6_.removeUser(_loc7_);
            }
            _loc3_.room = _loc5_;
            this.sfs.dispatchEvent(new SFSEvent(SFSEvent.ROOM_REMOVE,_loc3_));
         }
      }
      
      private function fnGenericMessage(param1:IMessage) : void
      {
         var _loc2_:ISFSObject = param1.content;
         var _loc3_:int = _loc2_.getByte(GenericMessageRequest.KEY_MESSAGE_TYPE);
         switch(_loc3_)
         {
            case GenericMessageType.PUBLIC_MSG:
               this.handlePublicMessage(_loc2_);
               break;
            case GenericMessageType.PRIVATE_MSG:
               this.handlePrivateMessage(_loc2_);
               break;
            case GenericMessageType.BUDDY_MSG:
               this.handleBuddyMessage(_loc2_);
               break;
            case GenericMessageType.MODERATOR_MSG:
               this.handleModMessage(_loc2_);
               break;
            case GenericMessageType.ADMING_MSG:
               this.handleAdminMessage(_loc2_);
               break;
            case GenericMessageType.OBJECT_MSG:
               this.handleObjectMessage(_loc2_);
         }
      }
      
      private function handlePublicMessage(param1:ISFSObject) : void
      {
         var _loc2_:Object = {};
         var _loc3_:int = param1.getInt(GenericMessageRequest.KEY_ROOM_ID);
         var _loc4_:Room;
         if((_loc4_ = this.sfs.roomManager.getRoomById(_loc3_)) != null)
         {
            _loc2_.room = _loc4_;
            _loc2_.sender = this.sfs.userManager.getUserById(param1.getInt(GenericMessageRequest.KEY_USER_ID));
            _loc2_.message = param1.getUtfString(GenericMessageRequest.KEY_MESSAGE);
            _loc2_.data = param1.getSFSObject(GenericMessageRequest.KEY_XTRA_PARAMS);
            this.sfs.dispatchEvent(new SFSEvent(SFSEvent.PUBLIC_MESSAGE,_loc2_));
         }
         else
         {
            log.warn("Unexpected, PublicMessage target room doesn\'t exist. RoomId: " + _loc3_);
         }
      }
      
      public function handlePrivateMessage(param1:ISFSObject) : void
      {
         var _loc2_:Object = {};
         var _loc3_:int = param1.getInt(GenericMessageRequest.KEY_USER_ID);
         var _loc4_:User;
         if((_loc4_ = this.sfs.userManager.getUserById(_loc3_)) == null)
         {
            if(!param1.containsKey(GenericMessageRequest.KEY_SENDER_DATA))
            {
               log.warn("Unexpected. Private message has no Sender details!");
               return;
            }
            _loc4_ = SFSUser.fromSFSArray(param1.getSFSArray(GenericMessageRequest.KEY_SENDER_DATA));
         }
         _loc2_.sender = _loc4_;
         _loc2_.message = param1.getUtfString(GenericMessageRequest.KEY_MESSAGE);
         _loc2_.data = param1.getSFSObject(GenericMessageRequest.KEY_XTRA_PARAMS);
         this.sfs.dispatchEvent(new SFSEvent(SFSEvent.PRIVATE_MESSAGE,_loc2_));
      }
      
      public function handleBuddyMessage(param1:ISFSObject) : void
      {
         var _loc2_:Object = {};
         var _loc3_:int = param1.getInt(GenericMessageRequest.KEY_USER_ID);
         var _loc4_:Buddy = this.sfs.buddyManager.getBuddyById(_loc3_);
         _loc2_.isItMe = this.sfs.mySelf.id == _loc3_;
         _loc2_.buddy = _loc4_;
         _loc2_.message = param1.getUtfString(GenericMessageRequest.KEY_MESSAGE);
         _loc2_.data = param1.getSFSObject(GenericMessageRequest.KEY_XTRA_PARAMS);
         this.sfs.dispatchEvent(new SFSBuddyEvent(SFSBuddyEvent.BUDDY_MESSAGE,_loc2_));
      }
      
      public function handleModMessage(param1:ISFSObject) : void
      {
         var _loc2_:Object = {};
         _loc2_.sender = SFSUser.fromSFSArray(param1.getSFSArray(GenericMessageRequest.KEY_SENDER_DATA));
         _loc2_.message = param1.getUtfString(GenericMessageRequest.KEY_MESSAGE);
         _loc2_.data = param1.getSFSObject(GenericMessageRequest.KEY_XTRA_PARAMS);
         this.sfs.dispatchEvent(new SFSEvent(SFSEvent.MODERATOR_MESSAGE,_loc2_));
      }
      
      public function handleAdminMessage(param1:ISFSObject) : void
      {
         var _loc2_:Object = {};
         _loc2_.sender = SFSUser.fromSFSArray(param1.getSFSArray(GenericMessageRequest.KEY_SENDER_DATA));
         _loc2_.message = param1.getUtfString(GenericMessageRequest.KEY_MESSAGE);
         _loc2_.data = param1.getSFSObject(GenericMessageRequest.KEY_XTRA_PARAMS);
         this.sfs.dispatchEvent(new SFSEvent(SFSEvent.ADMIN_MESSAGE,_loc2_));
      }
      
      public function handleObjectMessage(param1:ISFSObject) : void
      {
         var _loc2_:Object = {};
         var _loc3_:int = param1.getInt(GenericMessageRequest.KEY_USER_ID);
         _loc2_.sender = this.sfs.userManager.getUserById(_loc3_);
         _loc2_.message = param1.getSFSObject(GenericMessageRequest.KEY_XTRA_PARAMS);
         this.sfs.dispatchEvent(new SFSEvent(SFSEvent.OBJECT_MESSAGE,_loc2_));
      }
      
      private function fnUserExitRoom(param1:IMessage) : void
      {
         var _loc2_:ISFSObject = param1.content;
         var _loc3_:Object = {};
         var _loc4_:int = _loc2_.getInt("r");
         var _loc5_:int = _loc2_.getInt("u");
         var _loc6_:Room = this.sfs.roomManager.getRoomById(_loc4_);
         var _loc7_:User = this.sfs.userManager.getUserById(_loc5_);
         if(_loc6_ != null && _loc7_ != null)
         {
            _loc6_.removeUser(_loc7_);
            this.sfs.userManager.removeUser(_loc7_);
            if(_loc7_.isItMe && _loc6_.isJoined)
            {
               _loc6_.isJoined = false;
               if(this.sfs.joinedRooms.length == 0)
               {
                  this.sfs.lastJoinedRoom = null;
               }
               if(!_loc6_.isManaged)
               {
                  this.sfs.roomManager.removeRoom(_loc6_);
               }
            }
            _loc3_.user = _loc7_;
            _loc3_.room = _loc6_;
            this.sfs.dispatchEvent(new SFSEvent(SFSEvent.USER_EXIT_ROOM,_loc3_));
         }
         else
         {
            log.debug("Failed to handle UserExit event. Room: " + _loc6_ + ", User: " + _loc7_);
         }
      }
      
      private function fnClientDisconnection(param1:IMessage) : void
      {
         var _loc2_:ISFSObject = param1.content;
         var _loc3_:int = _loc2_.getByte("dr");
         this.sfs.handleClientDisconnection(ClientDisconnectionReason.getReason(_loc3_));
      }
      
      private function fnSetRoomVariables(param1:IMessage) : void
      {
         var _loc8_:int = 0;
         var _loc9_:RoomVariable = null;
         var _loc2_:ISFSObject = param1.content;
         var _loc3_:Object = {};
         var _loc4_:int = _loc2_.getInt(SetRoomVariablesRequest.KEY_VAR_ROOM);
         var _loc5_:ISFSArray = _loc2_.getSFSArray(SetRoomVariablesRequest.KEY_VAR_LIST);
         var _loc6_:Room = this.sfs.roomManager.getRoomById(_loc4_);
         var _loc7_:Array = [];
         if(_loc6_ != null)
         {
            _loc8_ = 0;
            while(_loc8_ < _loc5_.size())
            {
               _loc9_ = SFSRoomVariable.fromSFSArray(_loc5_.getSFSArray(_loc8_));
               _loc6_.setVariable(_loc9_);
               _loc7_.push(_loc9_.name);
               _loc8_++;
            }
            _loc3_.changedVars = _loc7_;
            _loc3_.room = _loc6_;
            this.sfs.dispatchEvent(new SFSEvent(SFSEvent.ROOM_VARIABLES_UPDATE,_loc3_));
         }
         else
         {
            log.warn("RoomVariablesUpdate, unknown Room id = " + _loc4_);
         }
      }
      
      private function fnSetUserVariables(param1:IMessage) : void
      {
         var _loc8_:int = 0;
         var _loc9_:UserVariable = null;
         var _loc2_:ISFSObject = param1.content;
         var _loc3_:Object = {};
         var _loc4_:int = _loc2_.getInt(SetUserVariablesRequest.KEY_USER);
         var _loc5_:ISFSArray = _loc2_.getSFSArray(SetUserVariablesRequest.KEY_VAR_LIST);
         var _loc6_:User = this.sfs.userManager.getUserById(_loc4_);
         var _loc7_:Array = [];
         if(_loc6_ != null)
         {
            _loc8_ = 0;
            while(_loc8_ < _loc5_.size())
            {
               _loc9_ = SFSUserVariable.fromSFSArray(_loc5_.getSFSArray(_loc8_));
               _loc6_.setVariable(_loc9_);
               _loc7_.push(_loc9_.name);
               _loc8_++;
            }
            _loc3_.changedVars = _loc7_;
            _loc3_.user = _loc6_;
            this.sfs.dispatchEvent(new SFSEvent(SFSEvent.USER_VARIABLES_UPDATE,_loc3_));
         }
         else
         {
            log.warn("UserVariablesUpdate: unknown user id = " + _loc4_);
         }
      }
      
      private function fnSubscribeRoomGroup(param1:IMessage) : void
      {
         var _loc4_:String = null;
         var _loc5_:ISFSArray = null;
         var _loc6_:int = 0;
         var _loc7_:String = null;
         var _loc2_:ISFSObject = param1.content;
         var _loc3_:Object = {};
         if(_loc2_.isNull(BaseRequest.KEY_ERROR_CODE))
         {
            _loc4_ = _loc2_.getUtfString(SubscribeRoomGroupRequest.KEY_GROUP_ID);
            _loc5_ = _loc2_.getSFSArray(SubscribeRoomGroupRequest.KEY_ROOM_LIST);
            if(this.sfs.roomManager.containsGroup(_loc4_))
            {
               log.warn("SubscribeGroup Error. Group:",_loc4_,"already subscribed!");
            }
            this.populateRoomList(_loc5_);
            _loc3_.groupId = _loc4_;
            _loc3_.newRooms = this.sfs.roomManager.getRoomListFromGroup(_loc4_);
            this.sfs.dispatchEvent(new SFSEvent(SFSEvent.ROOM_GROUP_SUBSCRIBE,_loc3_));
         }
         else
         {
            _loc6_ = _loc2_.getShort(BaseRequest.KEY_ERROR_CODE);
            _loc7_ = SFSErrorCodes.getErrorMessage(_loc6_,_loc2_.getUtfStringArray(BaseRequest.KEY_ERROR_PARAMS));
            _loc3_ = {
               "errorMessage":_loc7_,
               "errorCode":_loc6_
            };
            this.sfs.dispatchEvent(new SFSEvent(SFSEvent.ROOM_GROUP_SUBSCRIBE_ERROR,_loc3_));
         }
      }
      
      private function fnUnsubscribeRoomGroup(param1:IMessage) : void
      {
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc2_:ISFSObject = param1.content;
         var _loc3_:Object = {};
         if(_loc2_.isNull(BaseRequest.KEY_ERROR_CODE))
         {
            _loc4_ = _loc2_.getUtfString(SubscribeRoomGroupRequest.KEY_GROUP_ID);
            if(!this.sfs.roomManager.containsGroup(_loc4_))
            {
               log.warn("UnsubscribeGroup Error. Group:",_loc4_,"is not subscribed!");
            }
            this.sfs.roomManager.removeGroup(_loc4_);
            _loc3_.groupId = _loc4_;
            this.sfs.dispatchEvent(new SFSEvent(SFSEvent.ROOM_GROUP_UNSUBSCRIBE,_loc3_));
         }
         else
         {
            _loc5_ = _loc2_.getShort(BaseRequest.KEY_ERROR_CODE);
            _loc6_ = SFSErrorCodes.getErrorMessage(_loc5_,_loc2_.getUtfStringArray(BaseRequest.KEY_ERROR_PARAMS));
            _loc3_ = {
               "errorMessage":_loc6_,
               "errorCode":_loc5_
            };
            this.sfs.dispatchEvent(new SFSEvent(SFSEvent.ROOM_GROUP_UNSUBSCRIBE_ERROR,_loc3_));
         }
      }
      
      private function fnChangeRoomName(param1:IMessage) : void
      {
         var _loc4_:int = 0;
         var _loc5_:Room = null;
         var _loc6_:int = 0;
         var _loc7_:String = null;
         var _loc2_:ISFSObject = param1.content;
         var _loc3_:Object = {};
         if(_loc2_.isNull(BaseRequest.KEY_ERROR_CODE))
         {
            _loc4_ = _loc2_.getInt(ChangeRoomNameRequest.KEY_ROOM);
            if((_loc5_ = this.sfs.roomManager.getRoomById(_loc4_)) != null)
            {
               _loc3_.oldName = _loc5_.name;
               this.sfs.roomManager.changeRoomName(_loc5_,_loc2_.getUtfString(ChangeRoomNameRequest.KEY_NAME));
               _loc3_.room = _loc5_;
               this.sfs.dispatchEvent(new SFSEvent(SFSEvent.ROOM_NAME_CHANGE,_loc3_));
            }
            else
            {
               log.warn("Room not found, ID:",_loc4_,", Room name change failed.");
            }
         }
         else
         {
            _loc6_ = _loc2_.getShort(BaseRequest.KEY_ERROR_CODE);
            _loc7_ = SFSErrorCodes.getErrorMessage(_loc6_,_loc2_.getUtfStringArray(BaseRequest.KEY_ERROR_PARAMS));
            _loc3_ = {
               "errorMessage":_loc7_,
               "errorCode":_loc6_
            };
            this.sfs.dispatchEvent(new SFSEvent(SFSEvent.ROOM_NAME_CHANGE_ERROR,_loc3_));
         }
      }
      
      private function fnChangeRoomPassword(param1:IMessage) : void
      {
         var _loc4_:int = 0;
         var _loc5_:Room = null;
         var _loc6_:int = 0;
         var _loc7_:String = null;
         var _loc2_:ISFSObject = param1.content;
         var _loc3_:Object = {};
         if(_loc2_.isNull(BaseRequest.KEY_ERROR_CODE))
         {
            _loc4_ = _loc2_.getInt(ChangeRoomPasswordStateRequest.KEY_ROOM);
            if((_loc5_ = this.sfs.roomManager.getRoomById(_loc4_)) != null)
            {
               this.sfs.roomManager.changeRoomPasswordState(_loc5_,_loc2_.getBool(ChangeRoomPasswordStateRequest.KEY_PASS));
               _loc3_.room = _loc5_;
               this.sfs.dispatchEvent(new SFSEvent(SFSEvent.ROOM_PASSWORD_STATE_CHANGE,_loc3_));
            }
            else
            {
               log.warn("Room not found, ID:",_loc4_,", Room password change failed.");
            }
         }
         else
         {
            _loc6_ = _loc2_.getShort(BaseRequest.KEY_ERROR_CODE);
            _loc7_ = SFSErrorCodes.getErrorMessage(_loc6_,_loc2_.getUtfStringArray(BaseRequest.KEY_ERROR_PARAMS));
            _loc3_ = {
               "errorMessage":_loc7_,
               "errorCode":_loc6_
            };
            this.sfs.dispatchEvent(new SFSEvent(SFSEvent.ROOM_PASSWORD_STATE_CHANGE_ERROR,_loc3_));
         }
      }
      
      private function fnChangeRoomCapacity(param1:IMessage) : void
      {
         var _loc4_:int = 0;
         var _loc5_:Room = null;
         var _loc6_:int = 0;
         var _loc7_:String = null;
         var _loc2_:ISFSObject = param1.content;
         var _loc3_:Object = {};
         if(_loc2_.isNull(BaseRequest.KEY_ERROR_CODE))
         {
            _loc4_ = _loc2_.getInt(ChangeRoomCapacityRequest.KEY_ROOM);
            if((_loc5_ = this.sfs.roomManager.getRoomById(_loc4_)) != null)
            {
               this.sfs.roomManager.changeRoomCapacity(_loc5_,_loc2_.getInt(ChangeRoomCapacityRequest.KEY_USER_SIZE),_loc2_.getInt(ChangeRoomCapacityRequest.KEY_SPEC_SIZE));
               _loc3_.room = _loc5_;
               this.sfs.dispatchEvent(new SFSEvent(SFSEvent.ROOM_CAPACITY_CHANGE,_loc3_));
            }
            else
            {
               log.warn("Room not found, ID:",_loc4_,", Room capacity change failed.");
            }
         }
         else
         {
            _loc6_ = _loc2_.getShort(BaseRequest.KEY_ERROR_CODE);
            _loc7_ = SFSErrorCodes.getErrorMessage(_loc6_,_loc2_.getUtfStringArray(BaseRequest.KEY_ERROR_PARAMS));
            _loc3_ = {
               "errorMessage":_loc7_,
               "errorCode":_loc6_
            };
            this.sfs.dispatchEvent(new SFSEvent(SFSEvent.ROOM_CAPACITY_CHANGE_ERROR,_loc3_));
         }
      }
      
      private function fnLogout(param1:IMessage) : void
      {
         this.sfs.handleLogout();
         var _loc2_:ISFSObject = param1.content;
         var _loc3_:Object = {};
         _loc3_.zoneName = _loc2_.getUtfString(LogoutRequest.KEY_ZONE_NAME);
         this.sfs.dispatchEvent(new SFSEvent(SFSEvent.LOGOUT,_loc3_));
      }
      
      private function fnSpectatorToPlayer(param1:IMessage) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:User = null;
         var _loc8_:Room = null;
         var _loc9_:int = 0;
         var _loc10_:String = null;
         var _loc2_:ISFSObject = param1.content;
         var _loc3_:Object = {};
         if(_loc2_.isNull(BaseRequest.KEY_ERROR_CODE))
         {
            _loc4_ = _loc2_.getInt(SpectatorToPlayerRequest.KEY_ROOM_ID);
            _loc5_ = _loc2_.getInt(SpectatorToPlayerRequest.KEY_USER_ID);
            _loc6_ = _loc2_.getShort(SpectatorToPlayerRequest.KEY_PLAYER_ID);
            _loc7_ = this.sfs.userManager.getUserById(_loc5_);
            if((_loc8_ = this.sfs.roomManager.getRoomById(_loc4_)) != null)
            {
               if(_loc7_ != null)
               {
                  if(_loc7_.isJoinedInRoom(_loc8_))
                  {
                     _loc7_.setPlayerId(_loc6_,_loc8_);
                     _loc3_.room = _loc8_;
                     _loc3_.user = _loc7_;
                     _loc3_.playerId = _loc6_;
                     this.sfs.dispatchEvent(new SFSEvent(SFSEvent.SPECTATOR_TO_PLAYER,_loc3_));
                  }
                  else
                  {
                     log.warn("User: " + _loc7_ + " not joined in Room: ",_loc8_,", SpectatorToPlayer failed.");
                  }
               }
               else
               {
                  log.warn("User not found, ID:",_loc5_,", SpectatorToPlayer failed.");
               }
            }
            else
            {
               log.warn("Room not found, ID:",_loc4_,", SpectatorToPlayer failed.");
            }
         }
         else
         {
            _loc9_ = _loc2_.getShort(BaseRequest.KEY_ERROR_CODE);
            _loc10_ = SFSErrorCodes.getErrorMessage(_loc9_,_loc2_.getUtfStringArray(BaseRequest.KEY_ERROR_PARAMS));
            _loc3_ = {
               "errorMessage":_loc10_,
               "errorCode":_loc9_
            };
            this.sfs.dispatchEvent(new SFSEvent(SFSEvent.SPECTATOR_TO_PLAYER_ERROR,_loc3_));
         }
      }
      
      private function fnPlayerToSpectator(param1:IMessage) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:User = null;
         var _loc7_:Room = null;
         var _loc8_:int = 0;
         var _loc9_:String = null;
         var _loc2_:ISFSObject = param1.content;
         var _loc3_:Object = {};
         if(_loc2_.isNull(BaseRequest.KEY_ERROR_CODE))
         {
            _loc4_ = _loc2_.getInt(PlayerToSpectatorRequest.KEY_ROOM_ID);
            _loc5_ = _loc2_.getInt(PlayerToSpectatorRequest.KEY_USER_ID);
            _loc6_ = this.sfs.userManager.getUserById(_loc5_);
            if((_loc7_ = this.sfs.roomManager.getRoomById(_loc4_)) != null)
            {
               if(_loc6_ != null)
               {
                  if(_loc6_.isJoinedInRoom(_loc7_))
                  {
                     _loc6_.setPlayerId(-1,_loc7_);
                     _loc3_.room = _loc7_;
                     _loc3_.user = _loc6_;
                     this.sfs.dispatchEvent(new SFSEvent(SFSEvent.PLAYER_TO_SPECTATOR,_loc3_));
                  }
                  else
                  {
                     log.warn("User: " + _loc6_ + " not joined in Room: ",_loc7_,", PlayerToSpectator failed.");
                  }
               }
               else
               {
                  log.warn("User not found, ID:",_loc5_,", PlayerToSpectator failed.");
               }
            }
            else
            {
               log.warn("Room not found, ID:",_loc4_,", PlayerToSpectator failed.");
            }
         }
         else
         {
            _loc8_ = _loc2_.getShort(BaseRequest.KEY_ERROR_CODE);
            _loc9_ = SFSErrorCodes.getErrorMessage(_loc8_,_loc2_.getUtfStringArray(BaseRequest.KEY_ERROR_PARAMS));
            _loc3_ = {
               "errorMessage":_loc9_,
               "errorCode":_loc8_
            };
            this.sfs.dispatchEvent(new SFSEvent(SFSEvent.PLAYER_TO_SPECTATOR_ERROR,_loc3_));
         }
      }
      
      private function fnInitBuddyList(param1:IMessage) : void
      {
         var _loc4_:ISFSArray = null;
         var _loc5_:ISFSArray = null;
         var _loc6_:Array = null;
         var _loc7_:int = 0;
         var _loc8_:Array = null;
         var _loc9_:Buddy = null;
         var _loc10_:int = 0;
         var _loc11_:String = null;
         var _loc2_:ISFSObject = param1.content;
         var _loc3_:Object = {};
         if(_loc2_.isNull(BaseRequest.KEY_ERROR_CODE))
         {
            _loc4_ = _loc2_.getSFSArray(InitBuddyListRequest.KEY_BLIST);
            _loc5_ = _loc2_.getSFSArray(InitBuddyListRequest.KEY_MY_VARS);
            _loc6_ = _loc2_.getUtfStringArray(InitBuddyListRequest.KEY_BUDDY_STATES);
            this.sfs.buddyManager.clearAll();
            _loc7_ = 0;
            while(_loc7_ < _loc4_.size())
            {
               _loc9_ = SFSBuddy.fromSFSArray(_loc4_.getSFSArray(_loc7_));
               this.sfs.buddyManager.addBuddy(_loc9_);
               _loc7_++;
            }
            if(_loc6_ != null)
            {
               this.sfs.buddyManager.setBuddyStates(_loc6_);
            }
            _loc8_ = [];
            _loc7_ = 0;
            while(_loc7_ < _loc5_.size())
            {
               _loc8_.push(SFSBuddyVariable.fromSFSArray(_loc5_.getSFSArray(_loc7_)));
               _loc7_++;
            }
            this.sfs.buddyManager.setMyVariables(_loc8_);
            this.sfs.buddyManager.setInited();
            _loc3_.buddyList = this.sfs.buddyManager.buddyList;
            _loc3_.myVariables = this.sfs.buddyManager.myVariables;
            this.sfs.dispatchEvent(new SFSBuddyEvent(SFSBuddyEvent.BUDDY_LIST_INIT,_loc3_));
         }
         else
         {
            _loc10_ = _loc2_.getShort(BaseRequest.KEY_ERROR_CODE);
            _loc11_ = SFSErrorCodes.getErrorMessage(_loc10_,_loc2_.getUtfStringArray(BaseRequest.KEY_ERROR_PARAMS));
            _loc3_ = {
               "errorMessage":_loc11_,
               "errorCode":_loc10_
            };
            this.sfs.dispatchEvent(new SFSBuddyEvent(SFSBuddyEvent.BUDDY_ERROR,_loc3_));
         }
      }
      
      private function fnAddBuddy(param1:IMessage) : void
      {
         var _loc4_:Buddy = null;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc2_:ISFSObject = param1.content;
         var _loc3_:Object = {};
         if(_loc2_.isNull(BaseRequest.KEY_ERROR_CODE))
         {
            _loc4_ = SFSBuddy.fromSFSArray(_loc2_.getSFSArray(AddBuddyRequest.KEY_BUDDY_NAME));
            this.sfs.buddyManager.addBuddy(_loc4_);
            _loc3_.buddy = _loc4_;
            this.sfs.dispatchEvent(new SFSBuddyEvent(SFSBuddyEvent.BUDDY_ADD,_loc3_));
         }
         else
         {
            _loc5_ = _loc2_.getShort(BaseRequest.KEY_ERROR_CODE);
            _loc6_ = SFSErrorCodes.getErrorMessage(_loc5_,_loc2_.getUtfStringArray(BaseRequest.KEY_ERROR_PARAMS));
            _loc3_ = {
               "errorMessage":_loc6_,
               "errorCode":_loc5_
            };
            this.sfs.dispatchEvent(new SFSBuddyEvent(SFSBuddyEvent.BUDDY_ERROR,_loc3_));
         }
      }
      
      private function fnRemoveBuddy(param1:IMessage) : void
      {
         var _loc4_:String = null;
         var _loc5_:Buddy = null;
         var _loc6_:int = 0;
         var _loc7_:String = null;
         var _loc2_:ISFSObject = param1.content;
         var _loc3_:Object = {};
         if(_loc2_.isNull(BaseRequest.KEY_ERROR_CODE))
         {
            _loc4_ = _loc2_.getUtfString(RemoveBuddyRequest.KEY_BUDDY_NAME);
            if((_loc5_ = this.sfs.buddyManager.removeBuddyByName(_loc4_)) != null)
            {
               _loc3_.buddy = _loc5_;
               this.sfs.dispatchEvent(new SFSBuddyEvent(SFSBuddyEvent.BUDDY_REMOVE,_loc3_));
            }
            else
            {
               log.warn("RemoveBuddy failed, buddy not found: " + _loc4_);
            }
         }
         else
         {
            _loc6_ = _loc2_.getShort(BaseRequest.KEY_ERROR_CODE);
            _loc7_ = SFSErrorCodes.getErrorMessage(_loc6_,_loc2_.getUtfStringArray(BaseRequest.KEY_ERROR_PARAMS));
            _loc3_ = {
               "errorMessage":_loc7_,
               "errorCode":_loc6_
            };
            this.sfs.dispatchEvent(new SFSBuddyEvent(SFSBuddyEvent.BUDDY_ERROR,_loc3_));
         }
      }
      
      private function fnBlockBuddy(param1:IMessage) : void
      {
         var _loc4_:String = null;
         var _loc5_:Buddy = null;
         var _loc6_:int = 0;
         var _loc7_:String = null;
         var _loc2_:ISFSObject = param1.content;
         var _loc3_:Object = {};
         if(_loc2_.isNull(BaseRequest.KEY_ERROR_CODE))
         {
            _loc4_ = _loc2_.getUtfString(BlockBuddyRequest.KEY_BUDDY_NAME);
            if((_loc5_ = this.sfs.buddyManager.getBuddyByName(_loc4_)) != null)
            {
               _loc5_.setBlocked(_loc2_.getBool(BlockBuddyRequest.KEY_BUDDY_BLOCK_STATE));
               _loc3_.buddy = _loc5_;
               this.sfs.dispatchEvent(new SFSBuddyEvent(SFSBuddyEvent.BUDDY_BLOCK,_loc3_));
            }
            else
            {
               log.warn("BlockBuddy failed, buddy not found: " + _loc4_ + ", in local BuddyList");
            }
         }
         else
         {
            _loc6_ = _loc2_.getShort(BaseRequest.KEY_ERROR_CODE);
            _loc7_ = SFSErrorCodes.getErrorMessage(_loc6_,_loc2_.getUtfStringArray(BaseRequest.KEY_ERROR_PARAMS));
            _loc3_ = {
               "errorMessage":_loc7_,
               "errorCode":_loc6_
            };
            this.sfs.dispatchEvent(new SFSBuddyEvent(SFSBuddyEvent.BUDDY_ERROR,_loc3_));
         }
      }
      
      private function fnGoOnline(param1:IMessage) : void
      {
         var _loc4_:String = null;
         var _loc5_:Buddy = null;
         var _loc6_:* = false;
         var _loc7_:int = 0;
         var _loc8_:* = false;
         var _loc9_:Boolean = false;
         var _loc10_:int = 0;
         var _loc11_:String = null;
         var _loc2_:ISFSObject = param1.content;
         var _loc3_:Object = {};
         if(_loc2_.isNull(BaseRequest.KEY_ERROR_CODE))
         {
            _loc4_ = _loc2_.getUtfString(GoOnlineRequest.KEY_BUDDY_NAME);
            _loc5_ = this.sfs.buddyManager.getBuddyByName(_loc4_);
            _loc6_ = _loc4_ == this.sfs.mySelf.name;
            _loc8_ = (_loc7_ = _loc2_.getByte(GoOnlineRequest.KEY_ONLINE)) == BuddyOnlineState.ONLINE;
            _loc9_ = true;
            if(_loc6_)
            {
               if(this.sfs.buddyManager.myOnlineState != _loc8_)
               {
                  log.warn("Unexpected: MyOnlineState is not in synch with the server. Resynching: " + _loc8_);
                  this.sfs.buddyManager.setMyOnlineState(_loc8_);
               }
            }
            else
            {
               if(_loc5_ == null)
               {
                  log.warn("GoOnline error, buddy not found: " + _loc4_ + ", in local BuddyList.");
                  return;
               }
               _loc5_.setId(_loc2_.getInt(GoOnlineRequest.KEY_BUDDY_ID));
               _loc5_.setVariable(new SFSBuddyVariable(ReservedBuddyVariables.BV_ONLINE,_loc8_));
               if(_loc7_ == BuddyOnlineState.LEFT_THE_SERVER)
               {
                  _loc5_.clearVolatileVariables();
               }
               _loc9_ = this.sfs.buddyManager.myOnlineState;
            }
            if(_loc9_)
            {
               _loc3_.buddy = _loc5_;
               _loc3_.isItMe = _loc6_;
               this.sfs.dispatchEvent(new SFSBuddyEvent(SFSBuddyEvent.BUDDY_ONLINE_STATE_UPDATE,_loc3_));
            }
         }
         else
         {
            _loc10_ = _loc2_.getShort(BaseRequest.KEY_ERROR_CODE);
            _loc11_ = SFSErrorCodes.getErrorMessage(_loc10_,_loc2_.getUtfStringArray(BaseRequest.KEY_ERROR_PARAMS));
            _loc3_ = {
               "errorMessage":_loc11_,
               "errorCode":_loc10_
            };
            this.sfs.dispatchEvent(new SFSBuddyEvent(SFSBuddyEvent.BUDDY_ERROR,_loc3_));
         }
      }
      
      private function fnSetBuddyVariables(param1:IMessage) : void
      {
         var _loc4_:String = null;
         var _loc5_:ISFSArray = null;
         var _loc6_:Buddy = null;
         var _loc7_:* = false;
         var _loc8_:Array = null;
         var _loc9_:Array = null;
         var _loc10_:Boolean = false;
         var _loc11_:int = 0;
         var _loc12_:BuddyVariable = null;
         var _loc13_:int = 0;
         var _loc14_:String = null;
         var _loc2_:ISFSObject = param1.content;
         var _loc3_:Object = {};
         if(_loc2_.isNull(BaseRequest.KEY_ERROR_CODE))
         {
            _loc4_ = _loc2_.getUtfString(SetBuddyVariablesRequest.KEY_BUDDY_NAME);
            _loc5_ = _loc2_.getSFSArray(SetBuddyVariablesRequest.KEY_BUDDY_VARS);
            _loc6_ = this.sfs.buddyManager.getBuddyByName(_loc4_);
            _loc7_ = _loc4_ == this.sfs.mySelf.name;
            _loc8_ = [];
            _loc9_ = [];
            _loc10_ = true;
            _loc11_ = 0;
            while(_loc11_ < _loc5_.size())
            {
               _loc12_ = SFSBuddyVariable.fromSFSArray(_loc5_.getSFSArray(_loc11_));
               _loc9_.push(_loc12_);
               _loc8_.push(_loc12_.name);
               _loc11_++;
            }
            if(_loc7_)
            {
               this.sfs.buddyManager.setMyVariables(_loc9_);
            }
            else
            {
               if(_loc6_ == null)
               {
                  log.warn("Unexpected. Target of BuddyVariables update not found: " + _loc4_);
                  return;
               }
               _loc6_.setVariables(_loc9_);
               _loc10_ = this.sfs.buddyManager.myOnlineState;
            }
            if(_loc10_)
            {
               _loc3_.isItMe = _loc7_;
               _loc3_.changedVars = _loc8_;
               _loc3_.buddy = _loc6_;
               this.sfs.dispatchEvent(new SFSBuddyEvent(SFSBuddyEvent.BUDDY_VARIABLES_UPDATE,_loc3_));
            }
         }
         else
         {
            _loc13_ = _loc2_.getShort(BaseRequest.KEY_ERROR_CODE);
            _loc14_ = SFSErrorCodes.getErrorMessage(_loc13_,_loc2_.getUtfStringArray(BaseRequest.KEY_ERROR_PARAMS));
            _loc3_ = {
               "errorMessage":_loc14_,
               "errorCode":_loc13_
            };
            this.sfs.dispatchEvent(new SFSBuddyEvent(SFSBuddyEvent.BUDDY_ERROR,_loc3_));
         }
      }
      
      private function fnFindRooms(param1:IMessage) : void
      {
         var _loc2_:ISFSObject = param1.content;
         var _loc3_:Object = {};
         var _loc4_:ISFSArray = _loc2_.getSFSArray(FindRoomsRequest.KEY_FILTERED_ROOMS);
         var _loc5_:Array = [];
         var _loc6_:int = 0;
         while(_loc6_ < _loc4_.size())
         {
            _loc5_.push(SFSRoom.fromSFSArray(_loc4_.getSFSArray(_loc6_)));
            _loc6_++;
         }
         _loc3_.rooms = _loc5_;
         this.sfs.dispatchEvent(new SFSEvent(SFSEvent.ROOM_FIND_RESULT,_loc3_));
      }
      
      private function fnFindUsers(param1:IMessage) : void
      {
         var _loc8_:User = null;
         var _loc2_:ISFSObject = param1.content;
         var _loc3_:Object = {};
         var _loc4_:ISFSArray = _loc2_.getSFSArray(FindUsersRequest.KEY_FILTERED_USERS);
         var _loc5_:Array = [];
         var _loc6_:User = this.sfs.mySelf;
         var _loc7_:int = 0;
         while(_loc7_ < _loc4_.size())
         {
            if((_loc8_ = SFSUser.fromSFSArray(_loc4_.getSFSArray(_loc7_))).id == _loc6_.id)
            {
               _loc8_ = _loc6_;
            }
            _loc5_.push(_loc8_);
            _loc7_++;
         }
         _loc3_.users = _loc5_;
         this.sfs.dispatchEvent(new SFSEvent(SFSEvent.USER_FIND_RESULT,_loc3_));
      }
      
      private function fnInviteUsers(param1:IMessage) : void
      {
         var _loc2_:ISFSObject = param1.content;
         var _loc3_:Object = {};
         var _loc4_:User = null;
         if(_loc2_.containsKey(InviteUsersRequest.KEY_USER_ID))
         {
            _loc4_ = this.sfs.userManager.getUserById(_loc2_.getInt(InviteUsersRequest.KEY_USER_ID));
         }
         else
         {
            _loc4_ = SFSUser.fromSFSArray(_loc2_.getSFSArray(InviteUsersRequest.KEY_USER));
         }
         var _loc5_:int = _loc2_.getShort(InviteUsersRequest.KEY_TIME);
         var _loc6_:int = _loc2_.getInt(InviteUsersRequest.KEY_INVITATION_ID);
         var _loc7_:ISFSObject = _loc2_.getSFSObject(InviteUsersRequest.KEY_PARAMS);
         var _loc8_:Invitation;
         (_loc8_ = new SFSInvitation(_loc4_,this.sfs.mySelf,_loc5_,_loc7_)).id = _loc6_;
         _loc3_.invitation = _loc8_;
         this.sfs.dispatchEvent(new SFSEvent(SFSEvent.INVITATION,_loc3_));
      }
      
      private function fnInvitationReply(param1:IMessage) : void
      {
         var _loc4_:User = null;
         var _loc5_:int = 0;
         var _loc6_:ISFSObject = null;
         var _loc7_:int = 0;
         var _loc8_:String = null;
         var _loc2_:ISFSObject = param1.content;
         var _loc3_:Object = {};
         if(_loc2_.isNull(BaseRequest.KEY_ERROR_CODE))
         {
            _loc4_ = null;
            if(_loc2_.containsKey(InviteUsersRequest.KEY_USER_ID))
            {
               _loc4_ = this.sfs.userManager.getUserById(_loc2_.getInt(InviteUsersRequest.KEY_USER_ID));
            }
            else
            {
               _loc4_ = SFSUser.fromSFSArray(_loc2_.getSFSArray(InviteUsersRequest.KEY_USER));
            }
            _loc5_ = _loc2_.getUnsignedByte(InviteUsersRequest.KEY_REPLY_ID);
            _loc6_ = _loc2_.getSFSObject(InviteUsersRequest.KEY_PARAMS);
            _loc3_.invitee = _loc4_;
            _loc3_.reply = _loc5_;
            _loc3_.data = _loc6_;
            this.sfs.dispatchEvent(new SFSEvent(SFSEvent.INVITATION_REPLY,_loc3_));
         }
         else
         {
            _loc7_ = _loc2_.getShort(BaseRequest.KEY_ERROR_CODE);
            _loc8_ = SFSErrorCodes.getErrorMessage(_loc7_,_loc2_.getUtfStringArray(BaseRequest.KEY_ERROR_PARAMS));
            _loc3_ = {
               "errorMessage":_loc8_,
               "errorCode":_loc7_
            };
            this.sfs.dispatchEvent(new SFSEvent(SFSEvent.INVITATION_REPLY_ERROR,_loc3_));
         }
      }
      
      private function fnQuickJoinGame(param1:IMessage) : void
      {
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc2_:ISFSObject = param1.content;
         var _loc3_:Object = {};
         if(_loc2_.containsKey(BaseRequest.KEY_ERROR_CODE))
         {
            _loc4_ = _loc2_.getShort(BaseRequest.KEY_ERROR_CODE);
            _loc5_ = SFSErrorCodes.getErrorMessage(_loc4_,_loc2_.getUtfStringArray(BaseRequest.KEY_ERROR_PARAMS));
            _loc3_ = {
               "errorMessage":_loc5_,
               "errorCode":_loc4_
            };
            this.sfs.dispatchEvent(new SFSEvent(SFSEvent.ROOM_JOIN_ERROR,_loc3_));
         }
      }
      
      private function fnPingPong(param1:IMessage) : void
      {
         var _loc2_:int = int(this.sfs.kernel::lagMonitor.onPingPong());
         var _loc3_:SFSEvent = new SFSEvent(SFSEvent.PING_PONG,{"lagValue":_loc2_});
         this.sfs.dispatchEvent(_loc3_);
      }
      
      private function populateRoomList(param1:ISFSArray) : void
      {
         var _loc4_:ISFSArray = null;
         var _loc5_:Room = null;
         var _loc2_:IRoomManager = this.sfs.roomManager;
         var _loc3_:int = 0;
         while(_loc3_ < param1.size())
         {
            _loc4_ = param1.getSFSArray(_loc3_);
            _loc5_ = SFSRoom.fromSFSArray(_loc4_);
            _loc2_.replaceRoom(_loc5_);
            _loc3_++;
         }
      }
      
      private function getOrCreateUser(param1:ISFSArray, param2:Boolean = false, param3:Room = null) : User
      {
         var _loc6_:ISFSArray = null;
         var _loc7_:int = 0;
         var _loc4_:int = param1.getInt(0);
         var _loc5_:User;
         if((_loc5_ = this.sfs.userManager.getUserById(_loc4_)) == null)
         {
            (_loc5_ = SFSUser.fromSFSArray(param1,param3)).userManager = this.sfs.userManager;
         }
         else if(param3 != null)
         {
            _loc5_.setPlayerId(param1.getShort(3),param3);
            _loc6_ = param1.getSFSArray(4);
            _loc7_ = 0;
            while(_loc7_ < _loc6_.size())
            {
               _loc5_.setVariable(SFSUserVariable.fromSFSArray(_loc6_.getSFSArray(_loc7_)));
               _loc7_++;
            }
         }
         if(param2)
         {
            this.sfs.userManager.addUser(_loc5_);
         }
         return _loc5_;
      }
   }
}
