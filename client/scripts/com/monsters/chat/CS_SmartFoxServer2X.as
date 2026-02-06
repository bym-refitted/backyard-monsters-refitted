package com.monsters.chat
{
   import com.monsters.chat.AS_Login;
   import com.monsters.chat.Channel;
   import com.monsters.chat.ChatData;
   import com.monsters.chat.ChatEvent;
   import com.monsters.chat.ChatRoom;
   import com.monsters.chat.ChatUser;
   import com.monsters.chat.IAuthenticationSystem;
   import com.monsters.chat.IChatSystem;
   import com.monsters.chat.UserRecord;
   import com.smartfoxserver.v2.SmartFox;
   import com.smartfoxserver.v2.core.SFSEvent;
   import com.smartfoxserver.v2.entities.Room;
   import com.smartfoxserver.v2.entities.User;
   import com.smartfoxserver.v2.entities.data.SFSArray;
   import com.smartfoxserver.v2.entities.data.SFSObject;
   import com.smartfoxserver.v2.entities.variables.SFSUserVariable;
   import com.smartfoxserver.v2.logging.LoggerEvent;
   import com.smartfoxserver.v2.requests.AdminMessageRequest;
   import com.smartfoxserver.v2.requests.ExtensionRequest;
   import com.smartfoxserver.v2.requests.JoinRoomRequest;
   import com.smartfoxserver.v2.requests.LeaveRoomRequest;
   import com.smartfoxserver.v2.requests.LoginRequest;
   import com.smartfoxserver.v2.requests.MessageRecipientMode;
   import com.smartfoxserver.v2.requests.PrivateMessageRequest;
   import com.smartfoxserver.v2.requests.PublicMessageRequest;
   import com.smartfoxserver.v2.requests.SetUserVariablesRequest;
   import com.smartfoxserver.v2.util.ClientDisconnectionReason;
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   
   /**
    * SmartFoxServer implementation of IChatSystem.
    * Wraps the SmartFoxServer v2 client and converts to neutral chat types.
    */
   public class CS_SmartFoxServer2X extends EventDispatcher implements IChatSystem
   {

      public static const HOST_LIVE:String = "message5.dc.kixeye.com";
      
      public static const HOST_TEST:String = "message3.dc.kixeye.com";
      
      public static const PORT:int = 9933;
      
      public static const ZONE:String = "Backyard Monsters";
      
      private static const EXT_REQ_STRING:String = "backyardmonsters";
       
      
      private var m_user:UserRecord = null;
      
      private var m_login:AS_Login = null;
      
      private var sfs:SmartFox;
      
      private var roomMap:Dictionary;
      
      private var host:String = null;
      
      private var port:int = -1;
      
      private var zone:String = null;
      
      private var _isLoggedIn:Boolean = false;
      
      private var _isLoggingOut:Boolean = false;
      
      private var join_channel:Channel = null;
      
      private var keepAliveTimer:Timer;
      
      private var keepAliveInterval:int = 120000;
      
      public function CS_SmartFoxServer2X(param1:String = "message3.dc.kixeye.com", param2:int = 9933, param3:String = "Backyard Monsters")
      {
         super();
         this.host = param1;
         this.port = param2;
         this.zone = param3;
         this.sfs = new SmartFox(true);
         this.sfs.debug = false;
         this.sfs.addEventListener(LoggerEvent.DEBUG,this.onErrorLogged);
         this.sfs.addEventListener(LoggerEvent.ERROR,this.onErrorLogged);
         this.sfs.addEventListener(LoggerEvent.INFO,this.onErrorLogged);
         this.sfs.addEventListener(LoggerEvent.WARNING,this.onErrorLogged);
         this.sfs.addEventListener(SFSEvent.EXTENSION_RESPONSE,this.onExtensionResponse);
         this.sfs.addEventListener(SFSEvent.ADMIN_MESSAGE,this.onAdminMessage);
         this.sfs.addEventListener(SFSEvent.MODERATOR_MESSAGE,this.onModeratorMessage);
         this.sfs.addEventListener(SFSEvent.CONFIG_LOAD_SUCCESS,this.onConfigLoadSuccess);
         this.sfs.addEventListener(SFSEvent.CONFIG_LOAD_FAILURE,this.onConfigLoadFailure);
         this.sfs.addEventListener(SFSEvent.CONNECTION,this.onConnection);
         this.sfs.addEventListener(SFSEvent.CONNECTION_LOST,this.onConnectionLost);
         this.sfs.addEventListener(SFSEvent.CONNECTION_RESUME,this.onConnectionResume);
         this.sfs.addEventListener(SFSEvent.CONNECTION_RETRY,this.onConnectionRetry);
         this.sfs.addEventListener(SFSEvent.LOGIN_ERROR,this.onLoginError);
         this.sfs.addEventListener(SFSEvent.LOGIN,this.onLogin);
         this.sfs.addEventListener(SFSEvent.LOGOUT,this.onLogout);
         this.sfs.addEventListener(SFSEvent.ROOM_JOIN_ERROR,this.onRoomJoinError);
         this.sfs.addEventListener(SFSEvent.ROOM_JOIN,this.onRoomJoin);
         this.sfs.addEventListener(SFSEvent.PUBLIC_MESSAGE,this.onPublicMessage);
         this.sfs.addEventListener(SFSEvent.PRIVATE_MESSAGE,this.onPrivateMessage);
         this.sfs.addEventListener(SFSEvent.USER_ENTER_ROOM,this.onUserEnterRoom);
         this.sfs.addEventListener(SFSEvent.USER_EXIT_ROOM,this.onUserExitRoom);
         this.sfs.addEventListener(SFSEvent.USER_VARIABLES_UPDATE,this.onUserVarsUpdate);
         this.connect();
      }


      public function disconnect() : void
      {
         this.sfs.disconnect();
         this.stopKeepAlive();
      }
      
      public function get isConnected() : Boolean
      {
         return this.sfs.isConnected;
      }

      public function connect() : Boolean
      {
         var _loc1_:Boolean = false;
         if(!this.sfs.isConnected)
         {
            try
            {
               this.sfs.connect(this.host,this.port);
               _loc1_ = true;
            }
            catch(e:*)
            {
            }
         }
         return _loc1_;
      }
      
      private function onErrorLogged(param1:LoggerEvent) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:Dictionary = new Dictionary();
         _loc3_["user"] = "Logger";
         _loc3_["channel"] = new Channel("World","system");
         _loc3_["message"] = param1.params.message;
         dispatchEvent(new ChatEvent(ChatEvent.SAY,_loc2_,_loc3_));
      }

      private function onExtensionResponse(param1:SFSEvent) : void
      {
         var _loc2_:String = String(param1.params.cmd);
         var _loc3_:SFSObject = param1.params.params as SFSObject;
         var _loc4_:String = _loc3_.getUtfString("command");
         switch(_loc4_)
         {
            case "room_add":
               this.roomResponse(param1,"add");
               break;
            case "room_remove":
               this.roomResponse(param1,"remove");
               break;
            case "room":
               this.roomResponse(param1);
               break;
            case "ignore":
               this.ignoreResponse(param1);
               break;
            case "ignoreerror":
               this.ignoreErrorResponse(param1);
               break;
            case "updatename":
               this.updateName(param1);
         }
      }
      
      private function updateName(param1:SFSEvent, param2:String = null) : void
      {
         var _loc3_:SFSObject = param1.params.params as SFSObject;
         var _loc4_:Boolean = _loc3_.getBool("success");
         var _loc5_:String = _loc3_.getUtfString("command");
         var _loc6_:String = null;
         if(param2 != null)
         {
            _loc6_ = param2;
         }
         else
         {
            _loc6_ = _loc3_.getUtfString("action");
         }
         switch(_loc6_)
         {
            case "updatedirect":
            case "update":
               var _loc7_:Dictionary;
               (_loc7_ = new Dictionary())["userid"] = _loc3_.getUtfString("userid");
               _loc7_["displayname"] = _loc3_.getUtfString("displayname");
               dispatchEvent(new ChatEvent(ChatEvent.UPDATE_NAME,_loc4_,_loc7_));
               return;
            default:
               LOGGER.Log("err","updateName() - unknown action: " + _loc6_);
               return;
         }
      }

      private function roomResponse(param1:SFSEvent, param2:String = null) : void
      {
         var _loc3_:SFSObject = param1.params.params as SFSObject;
         var _loc4_:String = _loc3_.getUtfString("command");
         var _loc5_:String = null;
         if(param2 != null)
         {
            _loc5_ = param2;
         }
         else
         {
            _loc5_ = _loc3_.getUtfString("action");
         }
         var _loc6_:String = null;
         switch(_loc5_)
         {
            case "add":
               _loc6_ = _loc3_.getUtfString("response");
               this.roomMap[_loc6_] = this.sfs.getRoomByName(_loc6_);
               if(_loc6_ == this.join_channel.Name)
               {
                  this.join(this.join_channel);
               }
               break;
            case "remove":
               _loc6_ = _loc3_.getUtfString("response");
               delete this.roomMap[_loc6_];
         }
      }
      
      private function ignoreResponse(param1:SFSEvent) : void
      {
         var _loc9_:int = 0;
         var _loc10_:SFSObject = null;
         var _loc11_:String = null;
         var _loc12_:String = null;
         var _loc13_:String = null;
         var _loc2_:SFSObject = param1.params.params as SFSObject;
         var _loc3_:String = _loc2_.getUtfString("command");
         var _loc4_:String = _loc2_.getUtfString("action");
         var _loc5_:Boolean = _loc2_.getBool("success");
         var _loc6_:SFSArray = _loc2_.getSFSArray("response") as SFSArray;
         var _loc7_:Array = new Array();
         var _loc8_:Dictionary;
         (_loc8_ = new Dictionary())["command"] = _loc3_;
         _loc8_["action"] = _loc4_;
         if(_loc4_ == "show")
         {
            _loc9_ = 0;
            while(_loc9_ < _loc6_.size())
            {
               _loc11_ = (_loc10_ = _loc6_.getSFSObject(_loc9_) as SFSObject).getUtfString("target");
               _loc12_ = _loc10_.getUtfString("displayname");

               // Convert to ChatData for neutral format
               var chatData:ChatData = new ChatData();
               chatData.putUtfString("target", _loc11_);
               chatData.putUtfString("displayname", _loc12_);

               _loc7_.push(chatData);
               _loc9_++;
            }
            _loc8_["ignore_list"] = _loc7_;
         }
         else
         {
            _loc8_["ignore_list"] = _loc6_ != null ? _loc6_.toArray() : null;
         }
         if(_loc4_ == "add" || _loc4_ == "remove")
         {
            _loc8_["target"] = _loc2_.getUtfString("target");
            if((_loc13_ = _loc2_.getUtfString("displayname")) != null)
            {
               _loc8_["displayname"] = _loc13_;
            }
         }
         dispatchEvent(new ChatEvent(ChatEvent.IGNORE,_loc5_,_loc8_));
      }
      
      private function ignoreErrorResponse(param1:SFSEvent) : void
      {
         var _loc2_:SFSObject = param1.params.params as SFSObject;
         var _loc3_:String = _loc2_.getUtfString("command");
         var _loc4_:String = _loc2_.getUtfString("reason");
         var _loc5_:Boolean = _loc2_.getBool("success");
         var _loc6_:Dictionary;
         (_loc6_ = new Dictionary())["command"] = _loc3_;
         _loc6_["reason"] = _loc4_;
         dispatchEvent(new ChatEvent(ChatEvent.IGNOREERROR,_loc5_,_loc6_));
      }
      
      private function onAdminMessage(param1:SFSEvent) : void
      {
         var _loc2_:Boolean = true;
         var _loc3_:Dictionary = new Dictionary();
         _loc3_["user"] = "Administrator";
         _loc3_["channel"] = new Channel(this.m_user.Name,"private");
         _loc3_["message"] = param1.params.message;
         dispatchEvent(new ChatEvent(ChatEvent.SAY,_loc2_,_loc3_));
      }
      
      private function onModeratorMessage(param1:SFSEvent) : void
      {
         var _loc2_:Boolean = true;
         var _loc3_:Dictionary = new Dictionary();
         _loc3_["user"] = "Moderator";
         _loc3_["channel"] = new Channel(this.m_user.Name,"private");
         _loc3_["message"] = param1.params.message;
         dispatchEvent(new ChatEvent(ChatEvent.SAY,_loc2_,_loc3_));
      }
      
      private function onConfigLoadSuccess(param1:SFSEvent) : void
      {
      }
      
      private function onConfigLoadFailure(param1:SFSEvent) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:Dictionary = new Dictionary();
         _loc3_["reason"] = "config load failure";
         dispatchEvent(new ChatEvent(ChatEvent.CONNECT,_loc2_,_loc3_));
      }
      
      private function onConnection(param1:SFSEvent) : void
      {
         var _loc2_:Boolean = Boolean(param1.params.success);
         var _loc3_:Dictionary = new Dictionary();
         if(!_loc2_)
         {
            _loc3_["reason"] = "connection failed";
         }
         dispatchEvent(new ChatEvent(ChatEvent.CONNECT,_loc2_,_loc3_));
      }
      
      private function onConnectionLost(param1:SFSEvent) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:Dictionary = new Dictionary();
         switch(param1.params.reason)
         {
            case ClientDisconnectionReason.MANUAL:
               _loc3_["reason"] = "client disconnect";
               break;
            case ClientDisconnectionReason.IDLE:
               _loc3_["reason"] = "idle timeout";
               break;
            case ClientDisconnectionReason.KICK:
               _loc3_["reason"] = "kicked";
               break;
            case ClientDisconnectionReason.BAN:
               _loc3_["reason"] = "banned";
               break;
            default:
               _loc3_["reason"] = "unknown: " + param1.params.reason;
         }
         dispatchEvent(new ChatEvent(ChatEvent.CONNECT,_loc2_,_loc3_));
         if(this._isLoggingOut)
         {
            this._isLoggedIn = false;
            this.stopKeepAlive();
         }
      }
      
      private function onConnectionResume(param1:SFSEvent) : void
      {
      }
      
      private function onConnectionRetry(param1:SFSEvent) : void
      {
      }
      
      public function login(param1:IAuthenticationSystem) : void
      {
         var _loc2_:AS_Login = param1 as AS_Login;
         this.m_login = _loc2_;
         this.m_user = _loc2_.User;
         var _loc3_:String = _loc2_.Password;

         // Convert ChatData to SFSObject for SmartFox
         var chatData:ChatData = _loc2_.Params;
         var _loc4_:SFSObject = this.chatDataToSFSObject(chatData);

         var _loc5_:LoginRequest = new LoginRequest(this.m_user.Name,_loc3_,this.zone,_loc4_);
         try
         {
            this.sfs.send(_loc5_);
            this._isLoggingOut = false;
         }
         catch(e:*)
         {
         }
      }
      
      private function onLogin(param1:SFSEvent) : void
      {
         var _loc3_:Room = null;
         var _loc4_:Boolean = false;
         var _loc5_:Dictionary = null;
         this.roomMap = new Dictionary();
         var _loc2_:Array = this.sfs.roomManager.getRoomList();
         for each(var _loc8_ in _loc2_)
         {
            _loc3_ = _loc8_;
            _loc8_;
            this.roomMap[_loc3_.name] = _loc3_;
         }
         _loc4_ = true;
         _loc5_ = new Dictionary();
         if(!_loc4_)
         {
            _loc5_["reason"] = "login failed";
         }
         dispatchEvent(new ChatEvent(ChatEvent.LOGIN,_loc4_,_loc5_));
         this._isLoggedIn = true;
         this.initKeepAlive();
      }
      
      private function onLoginError(param1:SFSEvent) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:Dictionary = new Dictionary();
         _loc3_["reason"] = "login error";
         dispatchEvent(new ChatEvent(ChatEvent.LOGIN,_loc2_,_loc3_));
         this._isLoggedIn = false;
      }

      public function logout() : void
      {
         this._isLoggedIn = false;
         this.sfs.disconnect();
         this.stopKeepAlive();
      }

      public function get isLoggedIn() : Boolean
      {
         return this._isLoggedIn;
      }

      private function onLogout(param1:SFSEvent) : void
      {
         this._isLoggedIn = false;
         try
         {
            this.sfs.disconnect();
         }
         catch(e:*)
         {
         }
         if(this._isLoggingOut)
         {
            this.stopKeepAlive();
            this._isLoggingOut = false;
         }
      }
      
      public function join(param1:Channel, param2:String = null, param3:Boolean = true) : void
      {
         var _loc4_:int = 0;
         var _loc5_:JoinRoomRequest = null;
         var _loc6_:SFSObject = null;
         var _loc7_:ExtensionRequest = null;
         this.join_channel = param1;
         if(Boolean(this.roomMap) && this.join_channel.Name in this.roomMap)
         {
            _loc4_ = -1;
            _loc5_ = new JoinRoomRequest(this.join_channel.Name,"",_loc4_,false);
            try
            {
               this.sfs.send(_loc5_);
            }
            catch(e:*)
            {
            }
         }
         else if(param3)
         {
            (_loc6_ = new SFSObject()).putUtfString("command","create_room");
            _loc6_.putUtfString("name",this.join_channel.Name);
            _loc7_ = new ExtensionRequest(EXT_REQ_STRING,_loc6_);
            try
            {
               this.sfs.send(_loc7_);
            }
            catch(e:*)
            {
            }
         }
      }
      
      public function setDisplayNameUserVar(param1:String) : void
      {
         var _loc2_:Array = [];
         _loc2_.push(new SFSUserVariable("displayName",param1));
         this.sfs.send(new SetUserVariablesRequest(_loc2_));
      }
      
      private function onUserVarsUpdate(param1:SFSEvent) : void
      {
         // Comment: Obfuscation
         // §§pop();
      }
      
      public function updateDisplayName(param1:Channel, param2:String, param3:String) : void
      {
         var extensionRequest:ExtensionRequest;
         var channel:Channel = param1;
         var userId:String = param2;
         var displayName:String = param3;
         var params:SFSObject = new SFSObject();
         params.putUtfString("command","updatename");
         params.putUtfString("action","update");
         params.putUtfString("roomname",channel.Name);
         params.putUtfString("userid",userId);
         params.putUtfString("displayname",displayName);
         extensionRequest = new ExtensionRequest(EXT_REQ_STRING,params);
         try
         {
            this.sfs.send(extensionRequest);
         }
         catch(e:*)
         {
            LOGGER.Log("err","Exception in updateDisplayName.sfs.send(extensionRequest): " + e);
         }
      }

      public function updateDisplayNameDirect(param1:Channel, param2:String, param3:String, param4:String) : void
      {
         var extensionRequest:ExtensionRequest;
         var channel:Channel = param1;
         var recipientId:String = param2;
         var userId:String = param3;
         var displayName:String = param4;
         var params:SFSObject = new SFSObject();
         params.putUtfString("command","updatename");
         params.putUtfString("action","updatedirect");
         params.putUtfString("roomname",channel.Name);
         params.putUtfString("userid",userId);
         params.putUtfString("displayname",displayName);
         params.putUtfString("recipientid",recipientId);
         extensionRequest = new ExtensionRequest(EXT_REQ_STRING,params);
         try
         {
            this.sfs.send(extensionRequest);
         }
         catch(e:*)
         {
            LOGGER.Log("err","Exception in updateDisplayName.sfs.send(extensionRequest): " + e);
         }
      }
      
      private function onRoomJoin(param1:SFSEvent) : void
      {
         var _loc2_:Boolean = true;
         var _loc3_:Dictionary = new Dictionary();
         _loc3_["channel"] = this.join_channel;
         dispatchEvent(new ChatEvent(ChatEvent.JOIN,_loc2_,_loc3_));
      }
      
      private function onRoomJoinError(param1:SFSEvent) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:Dictionary = new Dictionary();
         _loc3_["channel"] = this.join_channel;
         _loc3_["reason"] = "error joining room";
         dispatchEvent(new ChatEvent(ChatEvent.JOIN,_loc2_,_loc3_));
      }
      
      private function onRoomAdd(param1:SFSEvent) : void
      {
         this.roomMap[param1.params.room.name] = param1.params.room;
         if(param1.params.room.name == this.join_channel.Name)
         {
            this.join(this.join_channel);
         }
      }
      
      private function onRoomRemove(param1:SFSEvent) : void
      {
         delete this.roomMap[param1.params.room.name];
      }
      
      private function onRoomCreationError(param1:SFSEvent) : void
      {
      }
      
      public function leave(param1:Channel, param2:Boolean = true) : void
      {
         var leaveRoomRequest:LeaveRoomRequest;
         var success:Boolean;
         var params:Dictionary;
         var channel:Channel = param1;
         var autocleanup:Boolean = param2;
         if(this.roomMap == null)
         {
            return;
         }
         if(!(channel.Name in this.roomMap))
         {
            return;
         }
         leaveRoomRequest = new LeaveRoomRequest(this.roomMap[channel.Name]);
         success = true;
         try
         {
            this.sfs.send(leaveRoomRequest);
         }
         catch(e:*)
         {
            success = false;
         }
         params = new Dictionary();
         params["channel"] = channel;
         dispatchEvent(new ChatEvent(ChatEvent.LEAVE,success,params));
      }
      
      public function extension(param1:String, param2:Dictionary) : void
      {
         var _loc3_:SFSObject = new SFSObject();
         switch(param1)
         {
            case "add":
               _loc3_.putInt("n1",param2["n1"] as int);
               _loc3_.putInt("n2",param2["n2"] as int);
         }
         var _loc4_:ExtensionRequest = new ExtensionRequest(param1,_loc3_);
         try
         {
            this.sfs.send(_loc4_);
         }
         catch(e:*)
         {
         }
      }
      
      public function adminMessage(param1:String) : void
      {
         var _loc2_:MessageRecipientMode = new MessageRecipientMode(MessageRecipientMode.TO_ZONE,null);
         var _loc3_:AdminMessageRequest = new AdminMessageRequest(param1,_loc2_,null);
         this.sfs.send(_loc3_);
      }
      
      public function say(param1:Channel, param2:String) : void
      {
         var _loc4_:SFSObject = null;
         var _loc5_:User = null;
         var _loc6_:PrivateMessageRequest = null;
         var _loc7_:PublicMessageRequest = null;
         param2 = param2.replace(/&/g,"&amp;");
         param2 = param2.replace(/</g,"&lt;");
         param2 = param2.replace(/>/g,"&gt;");
         param2 = param2.replace(/\n/g,"");
         param2 = param2.replace(/\r/g,"");
         param2 = param2.replace(/&#10;/g,"");
         param2 = param2.replace(/&#13;/g,"");
         param2 = param2.replace(/^\s+$/,"");
         param2 = param2.replace(/:/g,"&#58;");
         param2 = param2.replace(/\'/g,"&#39;");
         if(param2 == "")
         {
            return;
         }
         var _loc3_:String = param1.Name;
         if(param1.Type == "private")
         {
            (_loc4_ = new SFSObject()).putUtfString("sender",this.m_user.Name);
            _loc4_.putUtfString("receiver",_loc3_);
            if((_loc5_ = this.sfs.userManager.getUserByName(_loc3_)) != null)
            {
               _loc6_ = new PrivateMessageRequest(param2,_loc5_.id,_loc4_);
               try
               {
                  this.sfs.send(_loc6_);
               }
               catch(e:*)
               {
               }
            }
            else
            {
               this.error(null,"no user found: \'" + _loc3_ + "\'");
            }
         }
         if(param1.Type == "system")
         {
            if(this.roomMap == null)
            {
            }
            if(!(param1.Name in this.roomMap))
            {
               return;
            }
            _loc7_ = new PublicMessageRequest(param2,null,this.roomMap[_loc3_]);
            try
            {
               this.sfs.send(_loc7_);
            }
            catch(e:*)
            {
            }
         }
      }
      
      private function onPrivateMessage(param1:SFSEvent) : void
      {
         var _loc2_:Boolean = true;
         var _loc3_:Dictionary = new Dictionary();
         var _loc4_:SFSObject = param1.params.data;
         _loc3_["user"] = param1.params.sender.name;
         _loc3_["channel"] = new Channel(_loc4_.getUtfString("receiver"),"private");
         _loc3_["message"] = param1.params.message;
         dispatchEvent(new ChatEvent(ChatEvent.SAY,_loc2_,_loc3_));
      }
      
      private function onPublicMessage(param1:SFSEvent) : void
      {
         var _loc2_:Boolean = true;
         var _loc3_:Dictionary = new Dictionary();
         _loc3_["user"] = param1.params.sender.name;
         _loc3_["channel"] = new Channel(param1.params.room.name,"system");
         _loc3_["message"] = param1.params.message;
         dispatchEvent(new ChatEvent(ChatEvent.SAY,_loc2_,_loc3_));
      }
      
      private function onUserEnterRoom(param1:SFSEvent) : void
      {
         // convert to neutral types
         var sfsUser:User = param1.params.user;
         var sfsRoom:Room = param1.params.room;

         var _loc2_:Boolean = true;
         var _loc3_:Dictionary = new Dictionary();
         _loc3_["user"] = new ChatUser(sfsUser.id, sfsUser.name);
         _loc3_["room"] = new ChatRoom(sfsRoom.id, sfsRoom.name, sfsRoom.userCount, sfsRoom.maxUsers);
         dispatchEvent(new ChatEvent(ChatEvent.USER_ENTER,_loc2_,_loc3_));
      }
      
      private function onUserExitRoom(event:SFSEvent) : void
      {
         // Convert to neutral types
         var sfsUser:User = event.params.user;
         var sfsRoom:Room = event.params.room;
         
         var _loc2_:Boolean = true;
         var _loc3_:Dictionary = new Dictionary();
         _loc3_["user"] = new ChatUser(sfsUser.id, sfsUser.name);
         _loc3_["room"] = new ChatRoom(sfsRoom.id, sfsRoom.name, sfsRoom.userCount, sfsRoom.maxUsers);
         dispatchEvent(new ChatEvent(ChatEvent.USER_EXIT,_loc2_,_loc3_));
      }
      
      public function list(param1:String = null) : void
      {
         var _loc2_:Boolean = true;
         var _loc3_:Dictionary = new Dictionary();
         _loc3_["list"] = new Array();
         dispatchEvent(new ChatEvent(ChatEvent.LIST,_loc2_,_loc3_));
      }
      
      public function members(param1:Channel) : void
      {
         var _loc2_:Boolean = true;
         var _loc3_:Dictionary = new Dictionary();
         _loc3_["members"] = new Array();
         dispatchEvent(new ChatEvent(ChatEvent.MEMBERS,_loc2_,_loc3_));
      }
      
      public function showIgnore() : void
      {
         var _loc1_:SFSObject = new SFSObject();
         _loc1_.putUtfString("command","ignore");
         _loc1_.putUtfString("action","show");
         var _loc2_:ExtensionRequest = new ExtensionRequest(EXT_REQ_STRING,_loc1_);
         this.sfs.send(_loc2_);
      }
      
      public function getIgnore() : void
      {
         var _loc1_:SFSObject = new SFSObject();
         _loc1_.putUtfString("command","ignore");
         _loc1_.putUtfString("action","list");
         var _loc2_:ExtensionRequest = new ExtensionRequest(EXT_REQ_STRING,_loc1_);
         this.sfs.send(_loc2_);
      }
      
      public function ignore(param1:String, param2:String) : void
      {
         var _loc3_:SFSObject = new SFSObject();
         _loc3_.putUtfString("command","ignore");
         _loc3_.putUtfString("action","add");
         _loc3_.putUtfString("target",param1);
         _loc3_.putUtfString("displayname",param2);
         var _loc4_:ExtensionRequest = new ExtensionRequest(EXT_REQ_STRING,_loc3_);
         this.sfs.send(_loc4_);
      }
      
      public function unignore(param1:String) : void
      {
         var _loc2_:SFSObject = new SFSObject();
         _loc2_.putUtfString("command","ignore");
         _loc2_.putUtfString("action","remove");
         _loc2_.putUtfString("target",param1);
         var _loc3_:ExtensionRequest = new ExtensionRequest(EXT_REQ_STRING,_loc2_);
         this.sfs.send(_loc3_);
      }
      
      public function error(param1:String, param2:String) : void
      {
         var _loc3_:Boolean = false;
         var _loc4_:Dictionary;
         (_loc4_ = new Dictionary())["error"] = param2;
         dispatchEvent(new ChatEvent(ChatEvent.SAY,_loc3_,_loc4_));
      }
      
      // ============ Keep-Alive ============
      
      private function initKeepAlive() : void
      {
         if(this.keepAliveTimer != null)
         {
            this.stopKeepAlive();
         }
         this.keepAliveTimer = new Timer(this.keepAliveInterval);
         this.keepAliveTimer.addEventListener(TimerEvent.TIMER,this.keepAliveListener);
         this.keepAliveTimer.start();
      }
      
      private function stopKeepAlive() : void
      {
         if(this.keepAliveTimer != null)
         {
            this.keepAliveTimer.removeEventListener(TimerEvent.TIMER,this.keepAliveListener);
            this.keepAliveTimer.stop();
            this.keepAliveTimer = null;
         }
      }
      
      private function keepAliveListener(param1:TimerEvent) : void
      {
         var _loc2_:SFSObject = new SFSObject();
         _loc2_.putUtfString("command","keepalive");
         var _loc3_:ExtensionRequest = new ExtensionRequest(EXT_REQ_STRING,_loc2_);
         try
         {
            this.sfs.send(_loc3_);
         }
         catch(e:*)
         {
         }
         if(!this.sfs.isConnected && this._isLoggedIn && !this._isLoggingOut)
         {
            if(!this.connect())
            {
               this._isLoggedIn = false;
               this.stopKeepAlive();
            }
         }
         if(this._isLoggingOut || !this._isLoggedIn)
         {
            this.stopKeepAlive();
         }
      }
      
      public function get roomNames() : Vector.<String>
      {
         var _loc2_:Room = null;
         var roomNames:Vector.<String> = new Vector.<String>();
         for each(var _loc5_ in this.roomMap)
         {
            _loc2_ = _loc5_;
            roomNames.push(_loc2_.name);
         }
         return roomNames;
      }
      
      public function get numUsers() : int
      {
         return this.sfs.userManager.userCount;
      }

      private function chatDataToSFSObject(chatData:ChatData) : SFSObject
      {
         var result:SFSObject = new SFSObject();
         if(chatData == null)
         {
            return result;
         }
         var keys:Array = chatData.keys;
         for each (var key:String in keys)
         {
            var value:* = chatData.get(key);
            if(value is String)
            {
               result.putUtfString(key, value as String);
            }
            else if(value is int)
            {
               result.putInt(key, value as int);
            }
            else if(value is Number)
            {
               result.putDouble(key, value as Number);
            }
            else if(value is Boolean)
            {
               result.putBool(key, value as Boolean);
            }
         }
         return result;
      }
   }
}
