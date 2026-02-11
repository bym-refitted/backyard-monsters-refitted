package com.monsters.chat
{
   /**
    * Neutral room type for chat system abstraction.
    * Replaces direct dependency on SmartFoxServer Room type.
    */
   public class ChatRoom
   {
      private var _id:int;
      private var _name:String;
      private var _userCount:int;
      private var _maxUsers:int;
      
      public function ChatRoom(id:int, name:String, userCount:int = 0, maxUsers:int = 0)
      {
         this._id = id;
         this._name = name;
         this._userCount = userCount;
         this._maxUsers = maxUsers;
      }
      
      public function get id():int
      {
         return this._id;
      }
      
      public function get name():String
      {
         return this._name;
      }
      
      public function get userCount():int
      {
         return this._userCount;
      }
      
      public function get maxUsers():int
      {
         return this._maxUsers;
      }
   }
}
