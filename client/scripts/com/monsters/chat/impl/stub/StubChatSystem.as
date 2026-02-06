package com.monsters.chat.impl.stub
{
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   import com.monsters.chat.IChatSystem;
   import com.monsters.chat.ChatEvent;
   import com.monsters.chat.Channel;
   import com.monsters.chat.IAuthenticationSystem;
   
   /**
    * Stub/no-op implementation of IChatSystem.
    * Used when chat functionality is disabled or for testing.
    */
   public class StubChatSystem extends EventDispatcher implements IChatSystem
   {
      private var _isConnected:Boolean = false;
      private var _isLoggedIn:Boolean = false;

      public static const HOST_TEST:String = "stub.chat.server";
      public static const PORT:int = 12345;
      
      public function StubChatSystem(chatHost:String, chatPort:int)
      {
         super();
         // No-op: no actual connection is made in stub mode.
         // chatHost and chatPort are accepted to satisfy the IChatSystem
         // constructor/interface contract; they are intentionally unused here.
      }
      
      // Connection management
      public function connect():Boolean
      {
         this._isConnected = true;
         var params:Dictionary = new Dictionary();
         dispatchEvent(new ChatEvent(ChatEvent.CONNECT, true, params));
         return true;
      }
      
      public function disconnect():void
      {
         this._isConnected = false;
         this._isLoggedIn = false;
         var params:Dictionary = new Dictionary();
         params["reason"] = "client disconnect";
         dispatchEvent(new ChatEvent(ChatEvent.CONNECT, false, params));
      }
      
      public function get isConnected():Boolean
      {
         return this._isConnected;
      }
      
      // Authentication
      public function login(auth:IAuthenticationSystem):void
      {
         this._isLoggedIn = true;
         var params:Dictionary = new Dictionary();
         dispatchEvent(new ChatEvent(ChatEvent.LOGIN, true, params));
      }
      
      public function logout():void
      {
         this._isLoggedIn = false;
         var params:Dictionary = new Dictionary();
         dispatchEvent(new ChatEvent(ChatEvent.LOGOUT, true, params));
      }
      
      public function get isLoggedIn():Boolean
      {
         return this._isLoggedIn;
      }
      
      // Room/Channel management
      public function join(channel:Channel, password:String = null, createIfMissing:Boolean = false):void
      {
         var params:Dictionary = new Dictionary();
         params["channel"] = channel;
         dispatchEvent(new ChatEvent(ChatEvent.JOIN, true, params));
      }
      
      public function leave(channel:Channel, autocleanup:Boolean = false):void
      {
         var params:Dictionary = new Dictionary();
         params["channel"] = channel;
         dispatchEvent(new ChatEvent(ChatEvent.LEAVE, true, params));
      }
      
      public function get roomNames():Vector.<String>
      {
         return new Vector.<String>();
      }
      
      // Messaging
      public function say(channel:Channel, message:String):void
      {
         // No-op: messages go nowhere in stub mode
      }
      
      public function adminMessage(message:String):void
      {
         // No-op
      }
      
      // User management
      public function setDisplayNameUserVar(displayName:String):void
      {
         // No-op
      }
      
      public function updateDisplayName(channel:Channel, userId:String, displayName:String):void
      {
         // No-op
      }
      
      public function updateDisplayNameDirect(channel:Channel, recipientId:String, userId:String, displayName:String):void
      {
         // No-op
      }
      
      public function get numUsers():int
      {
         return 0;
      }
      
      // Ignore list management
      public function showIgnore():void
      {
         var params:Dictionary = new Dictionary();
         params["command"] = "ignore";
         params["action"] = "show";
         params["ignore_list"] = [];
         dispatchEvent(new ChatEvent(ChatEvent.IGNORE, true, params));
      }
      
      public function getIgnore():void
      {
         var params:Dictionary = new Dictionary();
         params["command"] = "ignore";
         params["action"] = "list";
         params["ignore_list"] = [];
         dispatchEvent(new ChatEvent(ChatEvent.IGNORE, true, params));
      }
      
      public function ignore(target:String, displayName:String):void
      {
         var params:Dictionary = new Dictionary();
         params["command"] = "ignore";
         params["action"] = "add";
         params["target"] = target;
         params["displayname"] = displayName;
         params["ignore_list"] = [];
         dispatchEvent(new ChatEvent(ChatEvent.IGNORE, true, params));
      }
      
      public function unignore(target:String):void
      {
         var params:Dictionary = new Dictionary();
         params["command"] = "ignore";
         params["action"] = "remove";
         params["target"] = target;
         params["ignore_list"] = [];
         dispatchEvent(new ChatEvent(ChatEvent.IGNORE, true, params));
      }
      
      // Utility
      public function list(filter:String = null):void
      {
         var params:Dictionary = new Dictionary();
         params["list"] = [];
         dispatchEvent(new ChatEvent(ChatEvent.LIST, true, params));
      }
      
      public function members(channel:Channel):void
      {
         var params:Dictionary = new Dictionary();
         params["members"] = [];
         dispatchEvent(new ChatEvent(ChatEvent.MEMBERS, true, params));
      }
      
      public function error(code:String, message:String):void
      {
         var params:Dictionary = new Dictionary();
         params["error"] = message;
         dispatchEvent(new ChatEvent(ChatEvent.SAY, false, params));
      }
   }
}
