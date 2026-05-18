package com.monsters.chat.impl.ws
{
   import com.monsters.chat.Channel;
   import com.monsters.chat.Chat;
   import com.monsters.chat.ChatData;
   import com.monsters.chat.ChatEvent;
   import com.monsters.chat.ChatRoom;
   import com.monsters.chat.ChatUser;
   import com.monsters.chat.IAuthenticationSystem;
   import com.monsters.chat.IChatSystem;
   import com.worlize.websocket.WebSocket;
   import com.worlize.websocket.WebSocketErrorEvent;
   import com.worlize.websocket.WebSocketEvent;
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.Dictionary;
   import flash.utils.Timer;

   public class WSChatSystem extends EventDispatcher implements IChatSystem
   {
      private var _ws:WebSocket;
      private var _host:String;
      private var _port:int;
      private var _connected:Boolean = false;
      private var _loggedIn:Boolean = false;
      private var _rooms:Vector.<String> = new Vector.<String>();

      private var _pingTimer:Timer = null;

      private var _pendingUserId:String = null;
      private var _pendingIgnoreAction:String = "show";
      private var _pendingIgnoreTarget:String = null;

      public function WSChatSystem(host:String, port:int)
      {
         _host = host;
         _port = port;
      }

      // ── IChatSystem: Connection ───────────────────────────────────────────

      public function connect():Boolean
      {
         _ws = new WebSocket("ws://" + _host + ":" + _port + "/", "http://" + _host);
         _ws.addEventListener(WebSocketEvent.OPEN, onWsOpen);
         _ws.addEventListener(WebSocketEvent.MESSAGE, onWsMessage);
         _ws.addEventListener(WebSocketEvent.CLOSED, onWsClose);
         _ws.addEventListener(WebSocketErrorEvent.CONNECTION_FAIL, onWsError);
         _ws.addEventListener(WebSocketErrorEvent.ABNORMAL_CLOSE, onWsError);
         _ws.connect();
         _pingTimer = new Timer(90000);
         _pingTimer.addEventListener(TimerEvent.TIMER, onPingTimer);
         _pingTimer.start();
         return true;
      }

      public function disconnect():void
      {
         if (_pingTimer)
         {
            _pingTimer.stop();
            _pingTimer = null;
         }
         if (_ws)
            _ws.close();
         _connected = false;
         _loggedIn = false;
      }

      public function get isConnected():Boolean
      {
         return _connected;
      }

      // ── IChatSystem: Authentication ───────────────────────────────────────

      public function login(auth:IAuthenticationSystem):void
      {
         var userId:String = auth.User.Name;
         _pendingUserId = userId;
         if (_connected)
            sendAuth(userId);
      }

      public function logout():void
      {
         disconnect();
      }
      public function get isLoggedIn():Boolean
      {
         return _loggedIn;
      }

      // ── IChatSystem: Channels ─────────────────────────────────────────────

      public function join(channel:Channel, password:String = null, createIfMissing:Boolean = false):void
      {
         sendJson({type: ClientMessageType.JOIN, channel: channel.Name});
      }

      public function leave(channel:Channel, autocleanup:Boolean = false):void
      {
         sendJson({type: ClientMessageType.LEAVE, channel: channel.Name});
         var idx:int = _rooms.indexOf(channel.Name);
         if (idx != -1)
            _rooms.splice(idx, 1);
      }

      public function get roomNames():Vector.<String>
      {
         return _rooms;
      }

      // ── IChatSystem: Messaging ────────────────────────────────────────────

      public function say(channel:Channel, message:String):void
      {
         sendJson({type: ClientMessageType.SAY, channel: channel.Name, message: message});
      }

      public function adminMessage(message:String):void
      {
      }

      // ── IChatSystem: Display names ────────────────────────────────────────

      public function setDisplayNameUserVar(displayName:String):void
      {
         sendJson({type: ClientMessageType.UPDATE_NAME, displayName: displayName});
      }

      public function updateDisplayName(channel:Channel, userId:String, displayName:String):void
      {
         sendJson({type: ClientMessageType.UPDATE_NAME, displayName: displayName});
      }

      public function updateDisplayNameDirect(channel:Channel, recipientId:String, userId:String, displayName:String):void
      {
      }

      public function get numUsers():int
      {
         return 0;
      }

      // ── IChatSystem: Ignore list ──────────────────────────────────────────

      public function showIgnore():void
      {
         _pendingIgnoreAction = "show";
         _pendingIgnoreTarget = null;
         sendJson({type: ClientMessageType.GET_IGNORE});
      }
      public function getIgnore():void
      {
         _pendingIgnoreAction = "show";
         _pendingIgnoreTarget = null;
         sendJson({type: ClientMessageType.GET_IGNORE});
      }

      public function ignore(target:String, displayName:String):void
      {
         _pendingIgnoreAction = "add";
         _pendingIgnoreTarget = target;
         sendJson({type: ClientMessageType.IGNORE, targetId: target});
      }

      public function unignore(target:String):void
      {
         _pendingIgnoreAction = "remove";
         _pendingIgnoreTarget = target;
         sendJson({type: ClientMessageType.UNIGNORE, targetId: target});
      }

      // ── IChatSystem: Utility ──────────────────────────────────────────────

      public function list(filter:String = null):void
      {
      }
      public function members(channel:Channel):void
      {
      }
      public function error(code:String, message:String):void
      {
      }

      // ── WebSocket event handlers ──────────────────────────────────────────

      private function onWsOpen(e:WebSocketEvent):void
      {
         _connected = true;
         dispatchEvent(new ChatEvent(ChatEvent.CONNECT, true));
         if (_pendingUserId != null)
            sendAuth(_pendingUserId);
      }

      private function onWsClose(e:WebSocketEvent):void
      {
         _connected = false;
         _loggedIn = false;
      }

      private function onWsError(e:WebSocketErrorEvent):void
      {
         _connected = false;
         _loggedIn = false;
         var params:Dictionary = new Dictionary();
         params["reason"] = e.text != null ? e.text : "connection error";
         dispatchEvent(new ChatEvent(ChatEvent.CONNECT, false, params));
      }

      private function onWsMessage(e:WebSocketEvent):void
      {
         var raw:String = e.message ? e.message.utf8Data : null;
         if (!raw)
            return;

         var msg:Object;
         try
         {
            msg = JSON.parse(raw);
         }
         catch (err:*)
         {
            return;
         }

         var type:String = msg.type as String;

         switch (type)
         {
            case ServerMessageType.AUTH_OK:
               _loggedIn = true;
               dispatchEvent(new ChatEvent(ChatEvent.LOGIN, true));
               break;

            case ServerMessageType.AUTH_FAIL:
               _loggedIn = false;
               var failParams:Dictionary = new Dictionary();
               failParams["reason"] = msg.reason;
               dispatchEvent(new ChatEvent(ChatEvent.LOGIN, false, failParams));
               break;

            case ServerMessageType.JOINED:
               var channelName:String = msg.channel as String;
               if (_rooms.indexOf(channelName) == -1)
                  _rooms.push(channelName);
               var joinParams:Dictionary = new Dictionary();
               joinParams["channel"] = new Channel(channelName, "system");
               dispatchEvent(new ChatEvent(ChatEvent.JOIN, true, joinParams));
               if (msg.history && msg.history is Array)
               {
                  var history:Array = msg.history as Array;
                  for each (var entry:Object in history)
                  {
                     var histUserId:String = String(int(entry.userId));
                     updateNameMap(histUserId, String(entry.displayName));
                     dispatchSay(channelName, histUserId, String(entry.body));
                  }
               }
               break;

            case ServerMessageType.MESSAGE:
               var senderIdStr:String = String(int(msg.userId));
               updateNameMap(senderIdStr, msg.displayName as String);
               dispatchSay(msg.channel as String, senderIdStr, msg.body as String);
               break;

            case ServerMessageType.USER_ENTER:
               var enterIdStr:String = String(int(msg.userId));
               var enterDisplayName:String = msg.displayName as String;
               updateNameMap(enterIdStr, enterDisplayName);
               var enterParams:Dictionary = new Dictionary();
               enterParams["user"] = new ChatUser(int(msg.userId), enterDisplayName);
               enterParams["room"] = new ChatRoom(0, msg.channel as String);
               dispatchEvent(new ChatEvent(ChatEvent.USER_ENTER, true, enterParams));
               break;

            case ServerMessageType.USER_EXIT:
               var exitId:int = int(msg.userId);
               var exitParams:Dictionary = new Dictionary();
               exitParams["user"] = new ChatUser(exitId, String(exitId));
               exitParams["room"] = new ChatRoom(0, msg.channel as String);
               dispatchEvent(new ChatEvent(ChatEvent.USER_EXIT, true, exitParams));
               break;

            case ServerMessageType.IGNORE_LIST:
               var rawList:Array = msg.list as Array;
               var ignoreParams:Dictionary = new Dictionary();
               ignoreParams["action"] = _pendingIgnoreAction;
               ignoreParams["target"] = _pendingIgnoreTarget;
               if (_pendingIgnoreAction == "show")
               {
                  // "show" display loop expects ChatData objects with getUtfString()
                  var chatDataList:Array = [];
                  for each (var item:Object in rawList)
                  {
                     var cd:ChatData = new ChatData();
                     cd.putUtfString("target", String(item.target));
                     cd.putUtfString("displayname", item.displayname ? String(item.displayname) : "");
                     chatDataList.push(cd);
                  }
                  ignoreParams["ignore_list"] = chatDataList;
               }
               else
               {
                  // add/remove: userIsIgnored() calls indexOf(userId) on this array — must be strings
                  var stringList:Array = [];
                  for each (var item2:Object in rawList)
                     stringList.push(String(item2.target));
                  ignoreParams["ignore_list"] = stringList;
               }
               dispatchEvent(new ChatEvent(ChatEvent.IGNORE, true, ignoreParams));
               _pendingIgnoreAction = "show";
               _pendingIgnoreTarget = null;
               break;
         }
      }

      // ── Helpers ───────────────────────────────────────────────────────────

      private function onPingTimer(e:TimerEvent):void
      {
         if (_connected)
            sendJson({type: ClientMessageType.PING});
      }

      private function sendAuth(userId:String):void
      {
         var token:String = Chat._chatToken;
         if (token == null || token.length == 0)
         {
            var failParams:Dictionary = new Dictionary();
            failParams["reason"] = "no_chat_token";
            dispatchEvent(new ChatEvent(ChatEvent.LOGIN, false, failParams));
            return;
         }
         sendJson({type: ClientMessageType.AUTH, userId: int(userId), token: token});
         _pendingUserId = null;
      }

      private function updateNameMap(userId:String, displayName:String):void
      {
         var params:Dictionary = new Dictionary();
         params["userid"] = userId;
         params["displayname"] = displayName;
         dispatchEvent(new ChatEvent(ChatEvent.UPDATE_NAME, true, params));
      }

      private function dispatchSay(channelName:String, userId:String, body:String):void
      {
         var params:Dictionary = new Dictionary();
         params["channel"] = new Channel(channelName, "system");
         params["user"] = userId;
         params["message"] = body;
         dispatchEvent(new ChatEvent(ChatEvent.SAY, true, params));
      }

      private function sendJson(obj:Object):void
      {
         if (!_connected || !_ws)
            return;
         _ws.sendUTF(JSON.stringify(obj));
      }
   }
}
