package com.monsters.chat.impl.smartfox
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
   public class SmartFoxChatSystem extends EventDispatcher implements IChatSystem
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
      
      public function SmartFoxChatSystem(host:String = "message3.dc.kixeye.com", port:int = 9933, zone:String = "Backyard Monsters")
      {
         super();
         this.host = host;
         this.port = port;
         this.zone = zone;
         this.sfs = new SmartFox(true);
         this.sfs.debug = false;
         this.sfs.addEventListener(LoggerEvent.DEBUG, this.onErrorLogged);
         this.sfs.addEventListener(LoggerEvent.ERROR, this.onErrorLogged);
         this.sfs.addEventListener(LoggerEvent.INFO, this.onErrorLogged);
         this.sfs.addEventListener(LoggerEvent.WARNING, this.onErrorLogged);
         this.sfs.addEventListener(SFSEvent.EXTENSION_RESPONSE, this.onExtensionResponse);
         this.sfs.addEventListener(SFSEvent.ADMIN_MESSAGE, this.onAdminMessage);
         this.sfs.addEventListener(SFSEvent.MODERATOR_MESSAGE, this.onModeratorMessage);
         this.sfs.addEventListener(SFSEvent.CONFIG_LOAD_SUCCESS, this.onConfigLoadSuccess);
         this.sfs.addEventListener(SFSEvent.CONFIG_LOAD_FAILURE, this.onConfigLoadFailure);
         this.sfs.addEventListener(SFSEvent.CONNECTION, this.onConnection);
         this.sfs.addEventListener(SFSEvent.CONNECTION_LOST, this.onConnectionLost);
         this.sfs.addEventListener(SFSEvent.CONNECTION_RESUME, this.onConnectionResume);
         this.sfs.addEventListener(SFSEvent.CONNECTION_RETRY, this.onConnectionRetry);
         this.sfs.addEventListener(SFSEvent.LOGIN_ERROR, this.onLoginError);
         this.sfs.addEventListener(SFSEvent.LOGIN, this.onSFSLogin);
         this.sfs.addEventListener(SFSEvent.LOGOUT, this.onSFSLogout);
         this.sfs.addEventListener(SFSEvent.ROOM_JOIN_ERROR, this.onRoomJoinError);
         this.sfs.addEventListener(SFSEvent.ROOM_JOIN, this.onRoomJoin);
         this.sfs.addEventListener(SFSEvent.PUBLIC_MESSAGE, this.onPublicMessage);
         this.sfs.addEventListener(SFSEvent.PRIVATE_MESSAGE, this.onPrivateMessage);
         this.sfs.addEventListener(SFSEvent.USER_ENTER_ROOM, this.onUserEnterRoom);
         this.sfs.addEventListener(SFSEvent.USER_EXIT_ROOM, this.onUserExitRoom);
         this.sfs.addEventListener(SFSEvent.USER_VARIABLES_UPDATE, this.onUserVarsUpdate);
         this.connect();
      }
      
      // ============ IChatSystem Implementation ============
      
      public function connect():Boolean
      {
         var success:Boolean = false;
         if (!this.sfs.isConnected)
         {
            try
            {
               this.sfs.connect(this.host, this.port);
               success = true;
            }
            catch (e:*)
            {
            }
         }
         return success;
      }
      
      public function disconnect():void
      {
         this.sfs.disconnect();
         this.stopKeepAlive();
      }
      
      public function get isConnected():Boolean
      {
         return this.sfs.isConnected;
      }
      
      public function login(auth:IAuthenticationSystem):void
      {
         var asLogin:AS_Login = auth as AS_Login;
         this.m_login = asLogin;
         this.m_user = asLogin.User;
         var password:String = asLogin.Password;
         var chatData:ChatData = asLogin.Params;
         
         // Convert ChatData to SFSObject for SmartFox
         var sfsParams:SFSObject = this.chatDataToSFSObject(chatData);
         var loginReq:LoginRequest = new LoginRequest(this.m_user.Name, password, this.zone, sfsParams);
         try
         {
            this.sfs.send(loginReq);
            this._isLoggingOut = false;
         }
         catch (e:*)
         {
         }
      }
      
      public function logout():void
      {
         this._isLoggedIn = false;
         this.sfs.disconnect();
         this.stopKeepAlive();
      }
      
      public function get isLoggedIn():Boolean
      {
         return this._isLoggedIn;
      }
      
      public function join(channel:Channel, password:String = null, createIfMissing:Boolean = false):void
      {
         var roomId:int = 0;
         var joinReq:JoinRoomRequest = null;
         var params:SFSObject = null;
         var extReq:ExtensionRequest = null;
         
         this.join_channel = channel;
         if (Boolean(this.roomMap) && channel.Name in this.roomMap)
         {
            roomId = -1;
            joinReq = new JoinRoomRequest(channel.Name, "", roomId, false);
            try
            {
               this.sfs.send(joinReq);
            }
            catch (e:*)
            {
            }
         }
         else if (createIfMissing)
         {
            params = new SFSObject();
            params.putUtfString("command", "create_room");
            params.putUtfString("name", channel.Name);
            extReq = new ExtensionRequest(EXT_REQ_STRING, params);
            try
            {
               this.sfs.send(extReq);
            }
            catch (e:*)
            {
            }
         }
      }
      
      public function leave(channel:Channel, autocleanup:Boolean = false):void
      {
         var leaveReq:LeaveRoomRequest;
         var success:Boolean;
         var params:Dictionary;
         
         if (this.roomMap == null)
         {
            return;
         }
         if (!(channel.Name in this.roomMap))
         {
            return;
         }
         leaveReq = new LeaveRoomRequest(this.roomMap[channel.Name]);
         success = true;
         try
         {
            this.sfs.send(leaveReq);
         }
         catch (e:*)
         {
            success = false;
         }
         params = new Dictionary();
         params["channel"] = channel;
         dispatchEvent(new ChatEvent(ChatEvent.LEAVE, success, params));
      }
      
      public function get roomNames():Vector.<String>
      {
         var room:Room = null;
         var result:Vector.<String> = new Vector.<String>();
         for each (var item:* in this.roomMap)
         {
            room = item;
            result.push(room.name);
         }
         return result;
      }
      
      public function say(channel:Channel, message:String):void
      {
         var params:SFSObject = null;
         var user:User = null;
         var pmReq:PrivateMessageRequest = null;
         var pubReq:PublicMessageRequest = null;
         
         message = message.replace(/&/g, "&amp;");
         message = message.replace(/</g, "&lt;");
         message = message.replace(/>/g, "&gt;");
         message = message.replace(/\n/g, "");
         message = message.replace(/\r/g, "");
         message = message.replace(/&#10;/g, "");
         message = message.replace(/&#13;/g, "");
         message = message.replace(/^\s+$/, "");
         message = message.replace(/:/g, "&#58;");
         message = message.replace(/\'/g, "&#39;");
         
         if (message == "")
         {
            return;
         }
         
         var channelName:String = channel.Name;
         if (channel.Type == "private")
         {
            params = new SFSObject();
            params.putUtfString("sender", this.m_user.Name);
            params.putUtfString("receiver", channelName);
            user = this.sfs.userManager.getUserByName(channelName);
            if (user != null)
            {
               pmReq = new PrivateMessageRequest(message, user.id, params);
               try
               {
                  this.sfs.send(pmReq);
               }
               catch (e:*)
               {
               }
            }
            else
            {
               this.error(null, "no user found: '" + channelName + "'");
            }
         }
         if (channel.Type == "system")
         {
            if (this.roomMap == null)
            {
            }
            if (!(channel.Name in this.roomMap))
            {
               return;
            }
            pubReq = new PublicMessageRequest(message, null, this.roomMap[channelName]);
            try
            {
               this.sfs.send(pubReq);
            }
            catch (e:*)
            {
            }
         }
      }
      
      public function adminMessage(message:String):void
      {
         var mode:MessageRecipientMode = new MessageRecipientMode(MessageRecipientMode.TO_ZONE, null);
         var req:AdminMessageRequest = new AdminMessageRequest(message, mode, null);
         this.sfs.send(req);
      }
      
      public function setDisplayNameUserVar(displayName:String):void
      {
         var vars:Array = [];
         vars.push(new SFSUserVariable("displayName", displayName));
         this.sfs.send(new SetUserVariablesRequest(vars));
      }
      
      public function updateDisplayName(channel:Channel, userId:String, displayName:String):void
      {
         var params:SFSObject = new SFSObject();
         params.putUtfString("command", "updatename");
         params.putUtfString("action", "update");
         params.putUtfString("roomname", channel.Name);
         params.putUtfString("userid", userId);
         params.putUtfString("displayname", displayName);
         var extReq:ExtensionRequest = new ExtensionRequest(EXT_REQ_STRING, params);
         try
         {
            this.sfs.send(extReq);
         }
         catch (e:*)
         {
            LOGGER.Log("err", "Exception in updateDisplayName.sfs.send(extensionRequest): " + e);
         }
      }
      
      public function updateDisplayNameDirect(channel:Channel, recipientId:String, userId:String, displayName:String):void
      {
         var params:SFSObject = new SFSObject();
         params.putUtfString("command", "updatename");
         params.putUtfString("action", "updatedirect");
         params.putUtfString("roomname", channel.Name);
         params.putUtfString("userid", userId);
         params.putUtfString("displayname", displayName);
         params.putUtfString("recipientid", recipientId);
         var extReq:ExtensionRequest = new ExtensionRequest(EXT_REQ_STRING, params);
         try
         {
            this.sfs.send(extReq);
         }
         catch (e:*)
         {
            LOGGER.Log("err", "Exception in updateDisplayNameDirect.sfs.send(extensionRequest): " + e);
         }
      }
      
      public function get numUsers():int
      {
         return this.sfs.userManager.userCount;
      }
      
      public function showIgnore():void
      {
         var params:SFSObject = new SFSObject();
         params.putUtfString("command", "ignore");
         params.putUtfString("action", "show");
         var extReq:ExtensionRequest = new ExtensionRequest(EXT_REQ_STRING, params);
         this.sfs.send(extReq);
      }
      
      public function getIgnore():void
      {
         var params:SFSObject = new SFSObject();
         params.putUtfString("command", "ignore");
         params.putUtfString("action", "list");
         var extReq:ExtensionRequest = new ExtensionRequest(EXT_REQ_STRING, params);
         this.sfs.send(extReq);
      }
      
      public function ignore(target:String, displayName:String):void
      {
         var params:SFSObject = new SFSObject();
         params.putUtfString("command", "ignore");
         params.putUtfString("action", "add");
         params.putUtfString("target", target);
         params.putUtfString("displayname", displayName);
         var extReq:ExtensionRequest = new ExtensionRequest(EXT_REQ_STRING, params);
         this.sfs.send(extReq);
      }
      
      public function unignore(target:String):void
      {
         var params:SFSObject = new SFSObject();
         params.putUtfString("command", "ignore");
         params.putUtfString("action", "remove");
         params.putUtfString("target", target);
         var extReq:ExtensionRequest = new ExtensionRequest(EXT_REQ_STRING, params);
         this.sfs.send(extReq);
      }
      
      public function list(filter:String = null):void
      {
         var success:Boolean = true;
         var params:Dictionary = new Dictionary();
         params["list"] = new Array();
         dispatchEvent(new ChatEvent(ChatEvent.LIST, success, params));
      }
      
      public function members(channel:Channel):void
      {
         var success:Boolean = true;
         var params:Dictionary = new Dictionary();
         params["members"] = new Array();
         dispatchEvent(new ChatEvent(ChatEvent.MEMBERS, success, params));
      }
      
      public function error(code:String, message:String):void
      {
         var success:Boolean = false;
         var params:Dictionary = new Dictionary();
         params["error"] = message;
         dispatchEvent(new ChatEvent(ChatEvent.SAY, success, params));
      }
      
      // ============ SmartFox Event Handlers ============
      
      private function onErrorLogged(event:LoggerEvent):void
      {
         var success:Boolean = false;
         var params:Dictionary = new Dictionary();
         params["user"] = "Logger";
         params["channel"] = new Channel("World", "system");
         params["message"] = event.params.message;
         dispatchEvent(new ChatEvent(ChatEvent.SAY, success, params));
      }
      
      private function onExtensionResponse(event:SFSEvent):void
      {
         var cmd:String = String(event.params.cmd);
         var data:SFSObject = event.params.params as SFSObject;
         var command:String = data.getUtfString("command");
         switch (command)
         {
            case "room_add":
               this.roomResponse(event, "add");
               break;
            case "room_remove":
               this.roomResponse(event, "remove");
               break;
            case "room":
               this.roomResponse(event);
               break;
            case "ignore":
               this.ignoreResponse(event);
               break;
            case "ignoreerror":
               this.ignoreErrorResponse(event);
               break;
            case "updatename":
               this.updateNameResponse(event);
         }
      }
      
      private function updateNameResponse(event:SFSEvent, action:String = null):void
      {
         var data:SFSObject = event.params.params as SFSObject;
         var success:Boolean = data.getBool("success");
         var command:String = data.getUtfString("command");
         var actionStr:String = action != null ? action : data.getUtfString("action");
         
         switch (actionStr)
         {
            case "updatedirect":
            case "update":
               var params:Dictionary = new Dictionary();
               params["userid"] = data.getUtfString("userid");
               params["displayname"] = data.getUtfString("displayname");
               dispatchEvent(new ChatEvent(ChatEvent.UPDATE_NAME, success, params));
               return;
            default:
               LOGGER.Log("err", "updateNameResponse() - unknown action: " + actionStr);
               return;
         }
      }
      
      private function roomResponse(event:SFSEvent, action:String = null):void
      {
         var data:SFSObject = event.params.params as SFSObject;
         var command:String = data.getUtfString("command");
         var actionStr:String = action != null ? action : data.getUtfString("action");
         var roomName:String = null;
         
         switch (actionStr)
         {
            case "add":
               roomName = data.getUtfString("response");
               this.roomMap[roomName] = this.sfs.getRoomByName(roomName);
               if (roomName == this.join_channel.Name)
               {
                  this.join(this.join_channel);
               }
               break;
            case "remove":
               roomName = data.getUtfString("response");
               delete this.roomMap[roomName];
         }
      }
      
      private function ignoreResponse(event:SFSEvent):void
      {
         var i:int = 0;
         var item:SFSObject = null;
         var target:String = null;
         var displayname:String = null;
         var targetStr:String = null;
         
         var data:SFSObject = event.params.params as SFSObject;
         var command:String = data.getUtfString("command");
         var action:String = data.getUtfString("action");
         var success:Boolean = data.getBool("success");
         var response:SFSArray = data.getSFSArray("response") as SFSArray;
         var ignoreList:Array = new Array();
         
         var params:Dictionary = new Dictionary();
         params["command"] = command;
         params["action"] = action;
         
         if (action == "show")
         {
            i = 0;
            while (i < response.size())
            {
               item = response.getSFSObject(i) as SFSObject;
               target = item.getUtfString("target");
               displayname = item.getUtfString("displayname");
               // Convert to ChatData for neutral format
               var chatData:ChatData = new ChatData();
               chatData.putUtfString("target", target);
               chatData.putUtfString("displayname", displayname);
               ignoreList.push(chatData);
               i++;
            }
            params["ignore_list"] = ignoreList;
         }
         else
         {
            params["ignore_list"] = response != null ? response.toArray() : null;
         }
         
         if (action == "add" || action == "remove")
         {
            params["target"] = data.getUtfString("target");
            targetStr = data.getUtfString("displayname");
            if (targetStr != null)
            {
               params["displayname"] = targetStr;
            }
         }
         dispatchEvent(new ChatEvent(ChatEvent.IGNORE, success, params));
      }
      
      private function ignoreErrorResponse(event:SFSEvent):void
      {
         var data:SFSObject = event.params.params as SFSObject;
         var command:String = data.getUtfString("command");
         var reason:String = data.getUtfString("reason");
         var success:Boolean = data.getBool("success");
         
         var params:Dictionary = new Dictionary();
         params["command"] = command;
         params["reason"] = reason;
         dispatchEvent(new ChatEvent(ChatEvent.IGNOREERROR, success, params));
      }
      
      private function onAdminMessage(event:SFSEvent):void
      {
         var success:Boolean = true;
         var params:Dictionary = new Dictionary();
         params["user"] = "Administrator";
         params["channel"] = new Channel(this.m_user.Name, "private");
         params["message"] = event.params.message;
         dispatchEvent(new ChatEvent(ChatEvent.SAY, success, params));
      }
      
      private function onModeratorMessage(event:SFSEvent):void
      {
         var success:Boolean = true;
         var params:Dictionary = new Dictionary();
         params["user"] = "Moderator";
         params["channel"] = new Channel(this.m_user.Name, "private");
         params["message"] = event.params.message;
         dispatchEvent(new ChatEvent(ChatEvent.SAY, success, params));
      }
      
      private function onConfigLoadSuccess(event:SFSEvent):void
      {
      }
      
      private function onConfigLoadFailure(event:SFSEvent):void
      {
         var success:Boolean = false;
         var params:Dictionary = new Dictionary();
         params["reason"] = "config load failure";
         dispatchEvent(new ChatEvent(ChatEvent.CONNECT, success, params));
      }
      
      private function onConnection(event:SFSEvent):void
      {
         var success:Boolean = Boolean(event.params.success);
         var params:Dictionary = new Dictionary();
         if (!success)
         {
            params["reason"] = "connection failed";
         }
         dispatchEvent(new ChatEvent(ChatEvent.CONNECT, success, params));
      }
      
      private function onConnectionLost(event:SFSEvent):void
      {
         var success:Boolean = false;
         var params:Dictionary = new Dictionary();
         switch (event.params.reason)
         {
            case ClientDisconnectionReason.MANUAL:
               params["reason"] = "client disconnect";
               break;
            case ClientDisconnectionReason.IDLE:
               params["reason"] = "idle timeout";
               break;
            case ClientDisconnectionReason.KICK:
               params["reason"] = "kicked";
               break;
            case ClientDisconnectionReason.BAN:
               params["reason"] = "banned";
               break;
            default:
               params["reason"] = "unknown: " + event.params.reason;
         }
         dispatchEvent(new ChatEvent(ChatEvent.CONNECT, success, params));
         if (this._isLoggingOut)
         {
            this._isLoggedIn = false;
            this.stopKeepAlive();
         }
      }
      
      private function onConnectionResume(event:SFSEvent):void
      {
      }
      
      private function onConnectionRetry(event:SFSEvent):void
      {
      }
      
      private function onSFSLogin(event:SFSEvent):void
      {
         var room:Room = null;
         var success:Boolean = false;
         var params:Dictionary = null;
         
         this.roomMap = new Dictionary();
         var roomList:Array = this.sfs.roomManager.getRoomList();
         for each (var item:* in roomList)
         {
            room = item;
            this.roomMap[room.name] = room;
         }
         success = true;
         params = new Dictionary();
         if (!success)
         {
            params["reason"] = "login failed";
         }
         dispatchEvent(new ChatEvent(ChatEvent.LOGIN, success, params));
         this._isLoggedIn = true;
         this.initKeepAlive();
      }
      
      private function onLoginError(event:SFSEvent):void
      {
         var success:Boolean = false;
         var params:Dictionary = new Dictionary();
         params["reason"] = "login error";
         dispatchEvent(new ChatEvent(ChatEvent.LOGIN, success, params));
         this._isLoggedIn = false;
      }
      
      private function onSFSLogout(event:SFSEvent):void
      {
         this._isLoggedIn = false;
         try
         {
            this.sfs.disconnect();
         }
         catch (e:*)
         {
         }
         if (this._isLoggingOut)
         {
            this.stopKeepAlive();
            this._isLoggingOut = false;
         }
      }
      
      private function onRoomJoin(event:SFSEvent):void
      {
         var success:Boolean = true;
         var params:Dictionary = new Dictionary();
         params["channel"] = this.join_channel;
         dispatchEvent(new ChatEvent(ChatEvent.JOIN, success, params));
      }
      
      private function onRoomJoinError(event:SFSEvent):void
      {
         var success:Boolean = false;
         var params:Dictionary = new Dictionary();
         params["channel"] = this.join_channel;
         params["reason"] = "error joining room";
         dispatchEvent(new ChatEvent(ChatEvent.JOIN, success, params));
      }
      
      private function onRoomAdd(event:SFSEvent):void
      {
         this.roomMap[event.params.room.name] = event.params.room;
         if (event.params.room.name == this.join_channel.Name)
         {
            this.join(this.join_channel);
         }
      }
      
      private function onRoomRemove(event:SFSEvent):void
      {
         delete this.roomMap[event.params.room.name];
      }
      
      private function onRoomCreationError(event:SFSEvent):void
      {
      }
      
      private function onPrivateMessage(event:SFSEvent):void
      {
         var success:Boolean = true;
         var params:Dictionary = new Dictionary();
         var data:SFSObject = event.params.data;
         params["user"] = event.params.sender.name;
         params["channel"] = new Channel(data.getUtfString("receiver"), "private");
         params["message"] = event.params.message;
         dispatchEvent(new ChatEvent(ChatEvent.SAY, success, params));
      }
      
      private function onPublicMessage(event:SFSEvent):void
      {
         var success:Boolean = true;
         var params:Dictionary = new Dictionary();
         params["user"] = event.params.sender.name;
         params["channel"] = new Channel(event.params.room.name, "system");
         params["message"] = event.params.message;
         dispatchEvent(new ChatEvent(ChatEvent.SAY, success, params));
      }
      
      private function onUserEnterRoom(event:SFSEvent):void
      {
         var sfsUser:User = event.params.user;
         var sfsRoom:Room = event.params.room;
         
         // Convert to neutral types
         var chatUser:ChatUser = new ChatUser(sfsUser.id, sfsUser.name);
         var chatRoom:ChatRoom = new ChatRoom(sfsRoom.id, sfsRoom.name, sfsRoom.userCount, sfsRoom.maxUsers);
         
         var success:Boolean = true;
         var params:Dictionary = new Dictionary();
         params["user"] = chatUser;
         params["room"] = chatRoom;
         dispatchEvent(new ChatEvent(ChatEvent.USER_ENTER, success, params));
      }
      
      private function onUserExitRoom(event:SFSEvent):void
      {
         var sfsUser:User = event.params.user;
         var sfsRoom:Room = event.params.room;
         
         // Convert to neutral types
         var chatUser:ChatUser = new ChatUser(sfsUser.id, sfsUser.name);
         var chatRoom:ChatRoom = new ChatRoom(sfsRoom.id, sfsRoom.name, sfsRoom.userCount, sfsRoom.maxUsers);
         
         var success:Boolean = true;
         var params:Dictionary = new Dictionary();
         params["user"] = chatUser;
         params["room"] = chatRoom;
         dispatchEvent(new ChatEvent(ChatEvent.USER_EXIT, success, params));
      }
      
      private function onUserVarsUpdate(event:SFSEvent):void
      {
         // No-op
      }
      
      // ============ Keep-Alive ============
      
      private function initKeepAlive():void
      {
         if (this.keepAliveTimer != null)
         {
            this.stopKeepAlive();
         }
         this.keepAliveTimer = new Timer(this.keepAliveInterval);
         this.keepAliveTimer.addEventListener(TimerEvent.TIMER, this.keepAliveListener);
         this.keepAliveTimer.start();
      }
      
      private function stopKeepAlive():void
      {
         if (this.keepAliveTimer != null)
         {
            this.keepAliveTimer.removeEventListener(TimerEvent.TIMER, this.keepAliveListener);
            this.keepAliveTimer.stop();
            this.keepAliveTimer = null;
         }
      }
      
      private function keepAliveListener(event:TimerEvent):void
      {
         var params:SFSObject = new SFSObject();
         params.putUtfString("command", "keepalive");
         var extReq:ExtensionRequest = new ExtensionRequest(EXT_REQ_STRING, params);
         try
         {
            this.sfs.send(extReq);
         }
         catch (e:*)
         {
         }
         if (!this.sfs.isConnected && this._isLoggedIn && !this._isLoggingOut)
         {
            if (!this.connect())
            {
               this._isLoggedIn = false;
               this.stopKeepAlive();
            }
         }
         if (this._isLoggingOut || !this._isLoggedIn)
         {
            this.stopKeepAlive();
         }
      }
      
      // ============ Helpers ============
      
      private function chatDataToSFSObject(chatData:ChatData):SFSObject
      {
         var result:SFSObject = new SFSObject();
         if (chatData == null)
         {
            return result;
         }
         var keys:Array = chatData.keys;
         for each (var key:String in keys)
         {
            var value:* = chatData.get(key);
            if (value is String)
            {
               result.putUtfString(key, value as String);
            }
            else if (value is int)
            {
               result.putInt(key, value as int);
            }
            else if (value is Number)
            {
               result.putDouble(key, value as Number);
            }
            else if (value is Boolean)
            {
               result.putBool(key, value as Boolean);
            }
         }
         return result;
      }
   }
}
