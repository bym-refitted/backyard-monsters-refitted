package com.monsters.chat
{
   import flash.events.IEventDispatcher;
   
   /**
    * Interface for chat system implementations.
    * Abstracts the underlying chat protocol (SmartFoxServer, WebSocket, etc.)
    */
   public interface IChatSystem extends IEventDispatcher
   {
      // Connection management
      function connect():Boolean;
      function disconnect():void;
      function get isConnected():Boolean;
      
      // Authentication
      function login(auth:IAuthenticationSystem):void;
      function logout():void;
      function get isLoggedIn():Boolean;
      
      // Room/Channel management
      function join(channel:Channel, password:String = null, createIfMissing:Boolean = false):void;
      function leave(channel:Channel, autocleanup:Boolean = false):void;
      function get roomNames():Vector.<String>;
      
      // Messaging
      function say(channel:Channel, message:String):void;
      function adminMessage(message:String):void;
      
      // User management
      function setDisplayNameUserVar(displayName:String):void;
      function updateDisplayName(channel:Channel, userId:String, displayName:String):void;
      function updateDisplayNameDirect(channel:Channel, recipientId:String, userId:String, displayName:String):void;
      function get numUsers():int;
      
      // Ignore list management
      function showIgnore():void;
      function getIgnore():void;
      function ignore(target:String, displayName:String):void;
      function unignore(target:String):void;
      
      // Utility
      function list(filter:String = null):void;
      function members(channel:Channel):void;
      function error(code:String, message:String):void;
   }
}
