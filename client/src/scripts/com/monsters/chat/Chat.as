package com.monsters.chat
{
   import com.monsters.chat.ui.ChatBox;
   import com.monsters.maproom_manager.MapRoomManager;
   import flash.display.DisplayObjectContainer;
   import flash.display.StageDisplayState;
   
   public class Chat
   {
      
      public static var _bymChat:BYMChat;
      
      public static var _chatroomNumber:Number = 0;
      
      public static const NUM_CHAT_ROOMS:int = 300;
      
      public static var _chatInited:Boolean = false;
      
      public static var _chatEnabled:Boolean = true;
      
      public static var _validName:Boolean = true;
      
      public static var _chatServers:Array = null;
      
      public static var _chatBlackList:Array = null;
      
      public static var _chatWhiteList:Array = null;
      
      public static var _countryCodeBlackList:Array = null;
      
      public static var _chatServer:String;
       
      
      public function Chat()
      {
         super();
      }
      
      public static function initChat() : void
      {
         if(_chatInited)
         {
            if(_bymChat != null)
            {
               _bymChat.show();
            }
            if(_bymChat.IsConnected)
            {
               return;
            }
         }
         if(_chatServers == null || _chatServers.length == 0)
         {
            return;
         }
         if(!flagsShouldChatExist())
         {
            if(_bymChat != null)
            {
               _bymChat.logout();
               _bymChat.hide();
               _bymChat = null;
               _chatInited = false;
            }
            return;
         }
         _chatroomNumber = 0;
         if(!GLOBAL._local)
         {
            if(MapRoomManager.instance.isInMapRoom3)
            {
               _chatroomNumber = MapRoomManager.instance.worldID;
            }
            else
            {
               _chatroomNumber = LOGIN._playerID % (GLOBAL._flags != null && Boolean(GLOBAL._flags.numchatrooms) ? GLOBAL._flags.numchatrooms : NUM_CHAT_ROOMS);
            }
         }
         if(!_chatEnabled || _chatServers.length == 0)
         {
            if(_bymChat != null)
            {
               _bymChat.logout();
               _bymChat.hide();
               _bymChat = null;
               _chatInited = false;
            }
            return;
         }
         _chatServer = _chatServers[_chatroomNumber % _chatServers.length];
         if(_bymChat == null)
         {
            _bymChat = new BYMChat(new ChatBox(),_chatServer);
            _bymChat.system_message("Connecting to chat");
            _chatInited = true;
            GLOBAL._layerUI.addChild(_bymChat);
         }
         _bymChat.init();
         if(!chatUserIsInABTest())
         {
            _bymChat.disableChat();
            _bymChat.showUnavailableInYourArea();
            return;
         }
         if(TUTORIAL._stage >= TUTORIAL._endstage && flagsShouldChatExist())
         {
            if(_chatEnabled && !_bymChat.IsConnected && _bymChat._open)
            {
               connectAndLogin();
            }
         }
         else
         {
            _bymChat.disableChat();
         }
      }
      
      public static function connectAndLogin() : void
      {
         var _loc1_:String = null;
         if(!_chatInited)
         {
            return;
         }
         if(!_validName)
         {
            return;
         }
         if(_bymChat == null || BYMChat.serverInited || _bymChat.IsConnected || _bymChat.IsJoined)
         {
            return;
         }
         if(_bymChat)
         {
            _loc1_ = getFirstNameLastInitial();
            if(_loc1_ == null || _loc1_.length == 0)
            {
               _validName = false;
               _bymChat.showInvalidName();
               return;
            }
            _bymChat.initServer();
            _bymChat.login(_loc1_,LOGIN._playerID.toString(),BASE.BaseLevel().level);
            _bymChat.show();
            _bymChat.enter_sector("Sector-" + _chatroomNumber.toString());
         }
      }
      
      private static function getFirstNameLastInitial() : String
      {
         var _loc1_:String = LOGIN._playerName;
         if(_loc1_ != null && _loc1_.length > 0)
         {
            _loc1_ = _loc1_.replace(/ /,"_");
            var _loc2_:String = LOGIN._playerLastName;
            if(_loc2_ != null && _loc2_.length > 0)
            {
               _loc2_ = _loc2_.substr(0,1);
               if(_loc2_.length == 1)
               {
                  _loc2_ = _loc2_.toUpperCase();
                  if(_loc2_ != null && _loc2_.length == 1)
                  {
                     _loc2_ = _loc2_.replace(/ /,"_");
                  }
               }
               if(_loc2_ == null || _loc2_.length != 1)
               {
                  return null;
               }
            }
            return _loc1_ + _loc2_;
         }
         return null;
      }
      
      public static function setChatPosition(param1:DisplayObjectContainer = null, param2:Number = NaN, param3:Number = NaN) : void
      {
         if(_bymChat != null)
         {
            if(!isNaN(param2))
            {
               _bymChat.x = param2;
            }
            if(!isNaN(param3))
            {
               _bymChat.y = param3;
            }
            if(param1 != null)
            {
               param1.addChild(_bymChat);
            }
            _bymChat.position();
            _bymChat.show();
         }
      }
      
      public static function chatUserIsInABTest() : Boolean
      {
         if(GLOBAL._flags)
         {
            if(GLOBAL._flags.hasOwnProperty("chatwhitelist"))
            {
               _chatWhiteList = String(GLOBAL._flags.chatwhitelist).split(",");
            }
            if(GLOBAL._flags.hasOwnProperty("chatblacklist"))
            {
               _chatBlackList = String(GLOBAL._flags.chatblacklist).split(",");
            }
            if(GLOBAL._flags.hasOwnProperty("countrycodeblacklist"))
            {
               _countryCodeBlackList = String(GLOBAL._flags.countrycodeblacklist).split(",");
            }
         }
         if(_chatWhiteList != null && _chatWhiteList.indexOf(LOGIN._playerID.toString()) != -1)
         {
            return true;
         }
         if(_chatBlackList != null && _chatBlackList.indexOf(LOGIN._playerID.toString()) != -1)
         {
            return false;
         }
         if(_countryCodeBlackList != null && _countryCodeBlackList.indexOf(GLOBAL._countryCode) != -1)
         {
            return false;
         }
         if(!_chatEnabled)
         {
            return false;
         }
         return true;
      }
      
      public static function flagsShouldChatDisplay() : Boolean
      {
         if(GLOBAL._flags == null)
         {
            return false;
         }
         if(!GLOBAL._flags.hasOwnProperty("chat"))
         {
            return false;
         }
         if(GLOBAL._flags.chat != 2)
         {
            return false;
         }
         if(MapRoomManager.instance.isInMapRoom2 && MapRoomManager.instance.isOpen && GLOBAL._ROOT.stage.displayState == StageDisplayState.FULL_SCREEN)
         {
            return false;
         }
         return true;
      }
      
      public static function flagsShouldChatExist() : Boolean
      {
         if(GLOBAL._flags == null)
         {
            return false;
         }
         if(!GLOBAL._flags.hasOwnProperty("chat"))
         {
            return false;
         }
         if(GLOBAL._flags.chat <= 0)
         {
            return false;
         }
         if(!chatUserIsInABTest())
         {
            return false;
         }
         return true;
      }
   }
}
