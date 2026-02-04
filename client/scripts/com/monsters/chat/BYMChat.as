package com.monsters.chat
{
   import com.monsters.chat.impl.smartfox.SmartFoxChatSystem;
   import com.monsters.chat.ui.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.ui.Keyboard;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import gs.TweenLite;
   
   public class BYMChat extends Sprite
   {
      
      private static var _chat:IChatSystem = null;
      
      public static var _userRecord:UserRecord = null;
      
      public static const WIDTH:int = 380;
      
      private static var _serverInited:Boolean = false;
      
      private static var _displayNameMap:Dictionary = new Dictionary();
       
      
      public const GLOBAL_CHANNEL:Channel = new Channel("World","system");
      
      public const IGNORE_LIST_CHANNEL:Channel = new Channel("IgnoreList","system");
      
      private var _auth:AS_Login = null;
      
      private var _joinAttempts:int = 0;
      
      private const DELAY_INITIAL:int = 1000;
      
      private const DELAY_INCREASE:int = 500;
      
      private const DELAY_DECREASE:int = 500;
      
      private const DELAY_DECREASE_TIME:int = 1000;
      
      private var delay:int = 1000;
      
      public var initialized:Boolean = false;
      
      private var _sectorBaseName:String = null;
      
      private const MESSAGE_QUEUE_SIZE:int = 2;
      
      private var messageQueue:Array;
      
      public var sector_channel:Channel = null;
      
      private var default_chat_channel:String = "sector";
      
      private var _ignore_list:Array = null;
      
      public var isLoggingOut:Boolean = false;
      
      private var isLoggingOutTimer:Number = 5;
      
      public var chatBox:ChatBox;
      
      private var _chatHost:String;
      
      private var _chatPort:int;
      
      private var _isConnected:Boolean = false;
      
      private var _isJoined:Boolean = false;
      
      private var _hideX:int;
      
      private var _hideY:int;
      
      private var _showX:int;
      
      private var _showY:int;
      
      public var _open:Boolean = true;
      
      private var globalChatTimer:Timer = null;
      
      private var globalChatLastSent:Date = null;
      
      private var overheat:Boolean = false;
      
      private var messageQueueTimer:Timer = null;
      
      private var messageQueueLastCheck:Date = null;
      
      public function BYMChat(param1:ChatBox, param2:String)
      {
         this.messageQueue = new Array();
         super();
         this.chatBox = param1;
         addChild(param1 as MovieClip);
         param1.addEventListener(KeyboardEvent.KEY_DOWN,this.keyboardEventHandler);
         var _loc3_:String = param2 == null || param2 == "" ? SmartFoxChatSystem.HOST_TEST : param2;
         var _loc4_:int = SmartFoxChatSystem.PORT;
         var _loc5_:Array;
         if((_loc5_ = _loc3_.split(":")).length > 1)
         {
            _loc3_ = String(_loc5_[0]);
            _loc4_ = int(_loc5_[1]);
         }
         this._chatHost = _loc3_;
         this._chatPort = _loc4_;
         if(GLOBAL.StatGet("chatmin") == 1)
         {
            this._open = false;
         }
         else
         {
            this._open = true;
         }
      }
      
      public static function get serverInited() : Boolean
      {
         return _serverInited;
      }
      
      public function get IsAnimating() : Boolean
      {
         return this.chatBox._animating;
      }
      
      public function get IsConnected() : Boolean
      {
         return this._isConnected;
      }
      
      public function get IsJoined() : Boolean
      {
         return this._isJoined;
      }
      
      public function initServer() : void
      {
         try
         {
            _chat = new SmartFoxChatSystem(this._chatHost,this._chatPort);
            _chat.addEventListener(ChatEvent.CONNECT,this.onConnect);
            _chat.addEventListener(ChatEvent.LOGIN,this.onLogin);
            _chat.addEventListener(ChatEvent.JOIN,this.onJoin);
            _chat.addEventListener(ChatEvent.LEAVE,this.onLeave);
            _chat.addEventListener(ChatEvent.SAY,this.onSay);
            _chat.addEventListener(ChatEvent.LIST,this.onList);
            _chat.addEventListener(ChatEvent.MEMBERS,this.onMembers);
            _chat.addEventListener(ChatEvent.IGNORE,this.onIgnore);
            _chat.addEventListener(ChatEvent.IGNOREERROR,this.onIgnoreError);
            _chat.addEventListener(ChatEvent.UPDATE_NAME,this.onUpdateName);
            _chat.addEventListener(ChatEvent.USER_ENTER,this.onUserEnter);
            _chat.addEventListener(ChatEvent.USER_EXIT,this.onUserExit);
            _serverInited = true;
         }
         catch(e:*)
         {
            displayUnavailable("init failed");
         }
      }
      
      public function init() : void
      {
         this.chatBox.init();
         this.toggleVisibleB();
         this.initialized = true;
      }
      
      private function keyboardEventHandler(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.ENTER)
         {
            this.processInput();
         }
      }
      
      public function broadcastDisplayNameUpdate(param1:int) : void
      {
         if(this.sector_channel == null)
         {
            return;
         }
         if(_userRecord == null)
         {
            return;
         }
         _chat.setDisplayNameUserVar("[" + param1 + "] " + _userRecord.Id);
         _chat.updateDisplayName(this.sector_channel,_userRecord.Name,"[" + param1 + "] " + _userRecord.Id);
      }
      
      private function clearChat() : void
      {
         this.chatBox.clearChat();
      }
      
      public function SendMessage() : void
      {
         this.processInput();
      }
      
      private function processInput() : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc1_:String = this.chatBox.inputText;
         if(_loc1_.length > 0)
         {
            _loc1_ = _loc1_.replace(/\s+/g," ");
            _loc2_ = null;
            _loc3_ = null;
            _loc4_ = null;
            if(_loc1_.charAt(0) == "/")
            {
               if((_loc5_ = _loc1_.search(/\s+/)) == -1)
               {
                  _loc2_ = _loc1_;
                  _loc1_ = "";
               }
               else
               {
                  _loc2_ = _loc1_.substring(0,_loc5_);
                  _loc1_ = _loc1_.slice(_loc5_ + 1);
                  _loc1_ = _loc1_.replace(/^\s+/,"");
               }
               switch(_loc2_)
               {
                  case "/entersector":
                     this.clearChat();
                     this.enter_sector(_loc1_,true);
                     break;
                  case "/l":
                  case "/list":
                  case "/ignored":
                  case "/listignored":
                  case "/igd":
                     _chat.showIgnore();
                     break;
                  case "/?":
                  case "/h":
                  case "/help":
                     this.system_message("<b>- Commands -</b>\n" + "To list ignored users: /list");
                     break;
                  default:
                     this.default_chat(_loc1_);
               }
            }
            else
            {
               this.default_chat(_loc1_);
            }
         }
         this.chatBox.clearInputText();
      }
      
      public function connect() : void
      {
         if(!this._isConnected)
         {
            _chat.connect();
         }
      }
      
      public function login(param1:String, param2:String, param3:int) : void
      {
         _userRecord = new UserRecord(param1,param2);
         this._auth = new AS_Login(_userRecord);
         this._auth.authenticate();
         if(this._isConnected)
         {
            _chat.login(this._auth);
         }
      }
      
      public function logout() : void
      {
         if(_chat)
         {
            _chat.logout();
            this.isLoggingOut = true;
            TweenLite.delayedCall(3,this.logoutDelayCB);
         }
      }
      
      public function logoutDelayCB() : void
      {
         this.isLoggingOut = false;
      }
      
      public function disableChat() : void
      {
         this._joinAttempts = 0;
         _serverInited = false;
         this._isConnected = false;
         this._isJoined = false;
         this.logout();
         this.clearChat();
         this.chatBox.EnableInput(false);
         this.system_message("Chat is currently disconnected.");
      }
      
      public function system_message(param1:String) : void
      {
         this.showChatMessage(null,null,param1);
      }
      
      public function default_chat(param1:String) : void
      {
         if(!this._isConnected)
         {
            return;
         }
         switch(this.default_chat_channel)
         {
            case "sector":
            case "combat":
               this.sector_chat(param1);
               break;
            default:
               this.sector_chat(param1);
         }
      }
      
      public function global_chat(param1:String) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:String = null;
         if(!this._isConnected)
         {
            LOGGER.Log("err","BYMChat.global_chat(): not connected");
            return;
         }
         if(this.globalChatTimer == null)
         {
            _chat.say(this.GLOBAL_CHANNEL,param1);
            this.delay += this.DELAY_INCREASE;
            this.globalChatLastSent = new Date();
            this.globalChatTimer = new Timer(250);
            this.globalChatTimer.addEventListener(TimerEvent.TIMER,this.globalChatListener);
            this.globalChatTimer.start();
         }
         else if(this.messageQueue.length < this.MESSAGE_QUEUE_SIZE)
         {
            _loc2_ = false;
            for each(_loc3_ in this.messageQueue)
            {
               if(_loc3_ == param1)
               {
                  _loc2_ = true;
               }
            }
            if(!_loc2_)
            {
               this.messageQueue.push(param1);
            }
         }
         else
         {
            this.system_message("<font color=\"#FF0000\">Your comlink is overheating.</font>");
            this.overheat = true;
         }
         if(this.messageQueueTimer != null)
         {
            this.messageQueueTimer.stop();
            this.messageQueueTimer = null;
         }
      }
      
      private function globalChatListener(param1:TimerEvent) : void
      {
         var _loc4_:String = null;
         var _loc2_:Date = new Date();
         var _loc3_:Number = _loc2_.time - this.globalChatLastSent.time;
         if(_loc3_ > this.delay)
         {
            if(this.messageQueue.length > 0)
            {
               _loc4_ = this.messageQueue.shift() as String;
               _chat.say(this.GLOBAL_CHANNEL,_loc4_);
               this.globalChatLastSent = new Date();
               this.delay += this.DELAY_INCREASE;
               if(this.messageQueue.length == 0)
               {
                  if(this.messageQueueTimer != null)
                  {
                     this.messageQueueTimer.stop();
                     this.messageQueueTimer = null;
                  }
                  this.messageQueueLastCheck = new Date();
                  this.messageQueueTimer = new Timer(250);
                  this.messageQueueTimer.addEventListener(TimerEvent.TIMER,this.messageQueueListener);
                  this.messageQueueTimer.start();
                  if(this.globalChatTimer != null)
                  {
                     this.globalChatTimer.stop();
                     this.globalChatTimer = null;
                  }
               }
            }
            else if(this.globalChatTimer != null)
            {
               this.globalChatTimer.stop();
               this.globalChatTimer = null;
            }
         }
      }
      
      private function messageQueueListener(param1:TimerEvent) : void
      {
         var _loc2_:Date = new Date();
         var _loc3_:Number = _loc2_.time - this.messageQueueLastCheck.time;
         if(_loc3_ > this.DELAY_DECREASE_TIME)
         {
            this.messageQueueLastCheck = new Date();
            this.delay -= this.DELAY_DECREASE;
            if(this.delay <= this.DELAY_INITIAL)
            {
               if(this.messageQueueTimer != null)
               {
                  this.messageQueueTimer.stop();
                  this.messageQueueTimer = null;
                  if(this.overheat)
                  {
                     this.system_message("<font color=\"0x00FFFF\">Your comlink cools down.</font>");
                     this.overheat = false;
                  }
               }
            }
         }
      }
      
      public function enter_sector(param1:String, param2:Boolean = false) : void
      {
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         if(!param2)
         {
            if(this._joinAttempts >= 10)
            {
               LOGGER.Log("err","BYMChat.enter_sector: failed to connect to 10 chat rooms; giving up");
               this.displayUnavailable("unable to find open chat room");
               return;
            }
            _loc3_ = param1.split(/(\d+)/);
            if(_loc3_.length == 0)
            {
               LOGGER.Log("err","BYMChat.enter_sector(): invalid sectorName");
               this.displayUnavailable("invalid chat room");
               return;
            }
            this._sectorBaseName = _loc3_[0];
            _loc4_ = int(_loc3_[1]);
            if(this._joinAttempts > 0)
            {
               _loc4_++;
            }
            ++this._joinAttempts;
            _loc4_ %= Chat.NUM_CHAT_ROOMS;
            param1 = this._sectorBaseName + _loc4_.toString();
         }
         if(this.sector_channel != null && this.sector_channel.Name == param1)
         {
            return;
         }
         if(this._isConnected)
         {
            if(this.sector_channel != null)
            {
               _chat.leave(this.sector_channel);
            }
         }
         this.sector_channel = new Channel(param1,"system");
         if(this._isConnected)
         {
            this.joinSector();
         }
      }
      
      private function clearDisplayNameMap() : void
      {
         _displayNameMap = new Dictionary();
      }
      
      public function sector_chat(param1:String) : void
      {
         if(!this._isConnected)
         {
            LOGGER.Log("err","BYMChat.sector_chat(): not connected");
            return;
         }
         if(this.sector_channel != null)
         {
            _chat.say(this.sector_channel,param1);
         }
         else
         {
            _chat.error(ChatEvent.SAY,"Not in a sector channel.");
         }
      }
      
      public function private_chat(param1:String, param2:String) : void
      {
         if(!this._isConnected)
         {
            LOGGER.Log("err","BYMChat.private_chat(): not connected");
            return;
         }
         if(this.userIsIgnored(param1))
         {
            return;
         }
         var _loc3_:Channel = new Channel(param1,"private");
         _chat.say(_loc3_,param2);
      }
      
      private function onConnect(param1:ChatEvent) : void
      {
         var reason:String = null;
         var chatEvent:ChatEvent = param1;
         try
         {
            this._isConnected = chatEvent.Success;
            if(!this._isConnected)
            {
               reason = chatEvent.Get("reason") as String;
               this.displayUnavailable(reason != null ? reason : "connection failed");
            }
            else if(this._auth != null && _chat != null)
            {
               _chat.login(this._auth);
            }
            else
            {
               this.displayUnavailable();
            }
         }
         catch(e:Error)
         {
            reason = chatEvent.Get("reason") as String;
            displayUnavailable(reason != null ? reason : "connect failed");
            LOGGER.Log("err","BYMChat.onConnect: " + e.message + "\n" + e.getStackTrace());
         }
      }
      
      private function onLogin(param1:ChatEvent) : void
      {
         var _loc2_:String = null;
         if(param1.Success)
         {
            this.joinSector();
            _chat.getIgnore();
         }
         else
         {
            _loc2_ = param1.Get("reason") as String;
            this.displayUnavailable(_loc2_ != null ? _loc2_ : "login failed");
            LOGGER.Log("err","onLogin() " + param1.Success + ": \'" + param1.Get("error") + "\'");
         }
      }
      
      public function joinGlobal() : void
      {
         this.clearChat();
         _chat.join(this.GLOBAL_CHANNEL);
      }
      
      public function joinSector() : void
      {
         if(this.sector_channel != null)
         {
            this.clearDisplayNameMap();
            _chat.join(this.sector_channel);
            this.default_chat_channel = "sector";
         }
      }
      
      private function onJoin(param1:ChatEvent) : void
      {
         var _loc2_:Channel = null;
         if(param1.Success)
         {
            _loc2_ = param1.Get("channel") as Channel;
            this.clearChat();
            this.system_message("Joined channel " + _loc2_.Name + ".");
            this.system_message("Type /h for help.");
            _chat.setDisplayNameUserVar("[" + BASE.BaseLevel().level + "] " + _userRecord.Id);
            _chat.updateDisplayName(_loc2_,_userRecord.Name,"[" + BASE.BaseLevel().level + "] " + _userRecord.Id);
            this.chatBox.EnableInput(true);
            this._isJoined = true;
         }
         else
         {
            this.clearChat();
            this.system_message("Join attempt " + this._joinAttempts + " failed. Trying again.");
            this.enter_sector(this._sectorBaseName);
         }
      }
      
      private function onLeave(param1:ChatEvent) : void
      {
         if(!param1.Success)
         {
            LOGGER.Log("err","BYMChat.onLeave() " + param1.Success + ": \'" + param1.Get("error") + "\'");
         }
      }
      
      private function onSay(param1:ChatEvent) : void
      {
         var _loc2_:Channel = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         if(param1.Success)
         {
            _loc2_ = param1.Get("channel") as Channel;
            _loc3_ = param1.Get("user") as String;
            _loc4_ = param1.Get("message") as String;
            if(this.userIsIgnored(_loc3_))
            {
               return;
            }
            this.showChatMessage(_loc2_,_loc3_,_loc4_);
         }
         else
         {
            LOGGER.Log("err","BYMChat.onSay() " + param1.Success + ": \'" + param1.Get("error") + "\'");
         }
      }
      
      private function onList(param1:ChatEvent) : void
      {
         if(!param1.Success)
         {
            LOGGER.Log("err","BYMChat.onList() " + param1.Success + ": \'" + param1.Get("error") + "\'");
         }
      }
      
      private function onMembers(param1:ChatEvent) : void
      {
         if(!param1.Success)
         {
            LOGGER.Log("err","BYMChat.onMembers() " + param1.Success + ": \'" + param1.Get("error") + "\'");
         }
      }
      
      private function onIgnore(param1:ChatEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:Array = null;
         var _loc6_:ChatData = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         if(param1.Success)
         {
            _loc2_ = param1.Get("action") as String;
            _loc3_ = param1.Get("target") as String;
            _loc4_ = param1.Get("displayname") as String;
            if(_loc2_ != "show")
            {
               this._ignore_list = param1.Get("ignore_list") as Array;
            }
            if(_loc4_ == null)
            {
               _loc4_ = this.fetchDisplayName(_loc3_);
            }
            if(_loc2_ == "add")
            {
               this.system_message("\'" + _loc4_ + "\' (id: " + _loc3_ + ") is now being ignored.");
            }
            else if(_loc2_ == "remove")
            {
               this.system_message("\'" + _loc4_ + "\' (id: " + _loc3_ + ") is no longer ignored.");
            }
            else if(_loc2_ == "show")
            {
               if((_loc5_ = param1.Get("ignore_list") as Array).length == 0)
               {
                  this.system_message("You are not ignoring any users.");
               }
               else
               {
                  this.system_message("<b><font color=\"#0000FF\">List of ignored users:</font></b>");
                  for each(_loc6_ in _loc5_)
                  {
                     _loc7_ = String(_loc6_.getUtfString("target"));
                     if((_loc8_ = _loc6_.getUtfString("displayname")) == null || _loc8_.length == 0)
                     {
                        _loc8_ = this.fetchDisplayName(_loc7_);
                     }
                     if(_loc8_ != null)
                     {
                        this.showIgnoreListMessage(_loc7_,_loc8_);
                     }
                     else
                     {
                        this.showIgnoreListMessage(_loc7_,"");
                     }
                  }
               }
            }
         }
         else
         {
            LOGGER.Log("err","BYMChat.onIgnore() " + param1.Success + ": \'" + param1.Get("error") + "\'");
         }
      }
      
      private function onIgnoreError(param1:ChatEvent) : void
      {
         var _loc2_:String = param1.Get("reason") as String;
         if(_loc2_ == "ignorelistfull")
         {
            this.system_message("Ignore list full. You must remove someone from your list before adding another.");
         }
      }
      
      private function onUpdateName(param1:ChatEvent) : void
      {
         var _loc2_:String = param1.Get("userid") as String;
         var _loc3_:String = param1.Get("displayname") as String;
         _displayNameMap[_loc2_] = _loc3_;
      }
      
      private function onUserEnter(param1:ChatEvent) : void
      {
         var _loc2_:ChatUser = param1.Get("user") as ChatUser;
         var _loc3_:ChatRoom = param1.Get("room") as ChatRoom;
         if(this.sector_channel == null)
         {
            LOGGER.Log("err","BYMChat.onUserEnter(): No sector has been joined yet");
            return;
         }
         if(_userRecord == null)
         {
            LOGGER.Log("err","BYMChat.onUserEnter(): No user record available");
            return;
         }
         if(_loc2_.name == _userRecord.Name)
         {
            return;
         }
         _chat.updateDisplayNameDirect(this.sector_channel,_loc2_.name,_userRecord.Name,"[" + BASE.BaseLevel().level + "] " + _userRecord.Id);
      }
      
      private function onUserExit(param1:ChatEvent) : void
      {
         var _loc2_:ChatUser = param1.Get("user") as ChatUser;
         var _loc3_:ChatRoom = param1.Get("room") as ChatRoom;
         delete _displayNameMap[_loc2_.name];
      }
      
      public function toggleVisible(... rest) : void
      {
         this._open = !this._open;
         this.toggleVisibleB();
         GLOBAL.StatSet("chatvis",this._open ? 1 : 0);
      }
      
      public function toggleVisibleB(... rest) : void
      {
         this.position();
         this.chatBox.update();
      }
      
      public function show() : void
      {
         this.visible = true;
      }
      
      public function hide() : void
      {
         this.visible = true;
      }
      
      public function showUnavailableInYourArea() : void
      {
         this.chatBox.disableChatBoxForAB();
         this.system_message("Chat is currently unavailable in your area.");
      }
      
      public function showInvalidName() : void
      {
         this.chatBox.disableChatBoxForAB();
         this.system_message("Chat is currently unavailable. (EC:13)");
      }
      
      public function fetchDisplayName(param1:String) : String
      {
         var _loc2_:String = null;
         return String(_displayNameMap[param1]);
      }
      
      public function toggleMinimizedStat(param1:Boolean = true) : void
      {
         if(param1 == true)
         {
            if(GLOBAL.StatGet("chatmin") != 1)
            {
               GLOBAL.StatSet("chatmin",1);
            }
         }
         else if(GLOBAL.StatGet("chatmin") != 0)
         {
            GLOBAL.StatSet("chatmin",0);
         }
      }
      
      private function showIgnoreListMessage(param1:String, param2:String) : void
      {
         var _loc3_:* = "<i>\'" + param2 + "\' (id: " + param1 + ")</i>";
         this.chatBox.push(_loc3_,param2,param1,"IgnoreList");
      }
      
      private function showChatMessage(param1:Channel, param2:String, param3:String) : void
      {
         var _loc4_:* = null;
         var _loc5_:String = null;
         var _loc6_:* = null;
         var _loc7_:String = null;
         if(param3 == "")
         {
            return;
         }
         param3 = ProfanityFilter.filterMessage(param3);
         if(param2 == null)
         {
            _loc4_ = "<i>" + param3 + "</i>";
            _loc5_ = "System";
         }
         else
         {
            if((_loc7_ = this.fetchDisplayName(param2)) == null)
            {
               return;
            }
            if(param2 == "Administrator")
            {
               _loc4_ = "<b><font color=\"#FF0000\">Admin: </font></b>";
               _loc6_ = "<b><font color=\"#FF0000\">Admin: </font></b>";
               _loc5_ = "Administrator";
            }
            else if(param2 == "Moderator")
            {
               _loc4_ = "<b><font color=\"#FF0000\">Mod: </font></b>";
               _loc6_ = "<b><font color=\"#FF0000\">Mod: </font></b>";
               _loc5_ = "Moderator";
            }
            else if(param1.Type == "private")
            {
               _loc4_ = "<b><font color=\"#076bbf\">";
               _loc6_ = "<b><font color=\"#076bbf\">";
               if(_userRecord.Name == param2)
               {
                  _loc4_ += "to " + _loc7_ + ": ";
                  _loc6_ += "to " + _loc7_ + ": ";
               }
               else
               {
                  _loc4_ += _loc7_ + ": ";
                  _loc6_ += _loc7_ + ": ";
               }
               _loc4_ += "</font></b>";
               _loc6_ += "</font></b>";
               _loc5_ = "Private";
            }
            else
            {
               _loc4_ = "<font color=\"#000000\">";
               _loc6_ = "<font color=\"#000000\">";
               _loc4_ += "<b>" + _loc7_ + ":</b> ";
               _loc6_ += "<b>" + _loc7_ + ":</b> ";
               _loc4_ += "</font>";
               _loc6_ += "</font>";
               _loc5_ = "Default";
            }
            _loc4_ += param3;
         }
         this.chatBox.push(_loc4_,_loc6_,param2,_loc5_);
      }
      
      public function ignoreUser(param1:String = null, param2:String = null) : void
      {
         if(param1 != null)
         {
            GLOBAL.Message(KEYS.Get("chat_ignore") + " \'" + param2 + "\' (id: " + param1 + ")<br><br>" + KEYS.Get("chat_ignore_confirm"),KEYS.Get("btn_yes"),_chat.ignore,[param1,param2]);
         }
      }
      
      public function unignoreUser(param1:String) : void
      {
         if(param1 != null)
         {
            _chat.unignore(param1);
         }
      }
      
      public function position() : void
      {
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc1_:int = GLOBAL._ROOT.stage.stageWidth;
         var _loc2_:int = GLOBAL._ROOT.stage.stageHeight;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Rectangle = new Rectangle(0 - (_loc1_ - GLOBAL._SCREENINIT.width) / 2 + 0,0 - (_loc2_ - GLOBAL._SCREENINIT.height) / 2 + _loc4_,_loc1_,_loc2_);
         this._hideX = _loc5_.x;
         this._showX = _loc5_.x;
         this._showY = GLOBAL._SCREENINIT.height + (_loc2_ - GLOBAL._SCREENINIT.height) / 2 - 30;
         this._hideY = GLOBAL._SCREENINIT.height + (_loc2_ - GLOBAL._SCREENINIT.height) / 2 - 30;
         this._hideX += _loc3_;
         this._showX += _loc3_;
         this._showY += _loc4_;
         this._hideY += _loc4_;
         if(this._open)
         {
            _loc6_ = this._showX;
            _loc7_ = this._showY;
         }
         else
         {
            _loc6_ = this._hideX;
            _loc7_ = this._hideY;
         }
         x = _loc6_;
         y = _loc7_;
         this.chatBox.update();
      }
      
      public function fetchIDFromDisplayName(param1:String, param2:Boolean) : String
      {
         var _loc3_:String = null;
         if(param1 == null || param1.length == 0)
         {
            return "";
         }
         for each(_loc3_ in _displayNameMap)
         {
            if(_displayNameMap[_loc3_] != null && _displayNameMap[_loc3_].toString() == param1)
            {
               return _loc3_;
            }
         }
         if(param2)
         {
            for(_loc3_ in _displayNameMap)
            {
               if(_displayNameMap[_loc3_] != null && _displayNameMap[_loc3_].indexOf(param1) != -1)
               {
                  return _loc3_;
               }
            }
         }
         return "";
      }
      
      public function userIsIgnored(param1:String) : Boolean
      {
         if(this._ignore_list == null)
         {
            return false;
         }
         if(this._ignore_list.indexOf(param1) == -1)
         {
            return false;
         }
         return true;
      }
      
      public function displayUnavailable(param1:String = null) : void
      {
         this.clearChat();
         if(param1 != null)
         {
            this.system_message("Chat is currently unavailable. Reason: " + param1);
         }
         else
         {
            this.system_message("Chat is currently unavailable.");
         }
      }
      
      public function get roomNames() : Vector.<String>
      {
         if(_chat != null)
         {
            return _chat.roomNames;
         }
         return new Vector.<String>();
      }
      
      public function chatInputHasFocus() : Boolean
      {
         if(Boolean(stage) && Boolean(this.chatBox))
         {
            return stage.focus == this.chatBox.input;
         }
         return false;
      }
   }
}
