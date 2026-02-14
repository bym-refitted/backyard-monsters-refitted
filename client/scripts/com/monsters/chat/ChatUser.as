package com.monsters.chat
{
   /**
    * Neutral user type for chat system abstraction.
    * Replaces direct dependency on SmartFoxServer User type.
    */
   public class ChatUser
   {
      private var _id:int;
      private var _name:String;
      private var _variables:Object;
      
      public function ChatUser(id:int, name:String)
      {
         this._id = id;
         this._name = name;
         this._variables = {};
      }
      
      public function get id():int
      {
         return this._id;
      }
      
      public function get name():String
      {
         return this._name;
      }
      
      public function getVariable(key:String):*
      {
         return this._variables[key];
      }
      
      public function setVariable(key:String, value:*):void
      {
         this._variables[key] = value;
      }
      
      public function hasVariable(key:String):Boolean
      {
         return key in this._variables;
      }
   }
}
