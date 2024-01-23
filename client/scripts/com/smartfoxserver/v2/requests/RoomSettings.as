package com.smartfoxserver.v2.requests
{
   import com.smartfoxserver.v2.entities.SFSConstants;
   
   public class RoomSettings
   {
       
      
      private var _name:String;
      
      private var _password:String;
      
      private var _groupId:String;
      
      private var _isGame:Boolean;
      
      private var _maxUsers:int;
      
      private var _maxSpectators:int;
      
      private var _maxVariables:int;
      
      private var _variables:Array;
      
      private var _permissions:RoomPermissions;
      
      private var _events:RoomEvents;
      
      private var _extension:RoomExtension;
      
      public function RoomSettings(param1:String)
      {
         super();
         this._name = param1;
         this._password = "";
         this._isGame = false;
         this._maxUsers = 10;
         this._maxSpectators = 0;
         this._maxVariables = 5;
         this._groupId = SFSConstants.DEFAULT_GROUP_ID;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function set name(param1:String) : void
      {
         this._name = param1;
      }
      
      public function get password() : String
      {
         return this._password;
      }
      
      public function set password(param1:String) : void
      {
         this._password = param1;
      }
      
      public function get isGame() : Boolean
      {
         return this._isGame;
      }
      
      public function set isGame(param1:Boolean) : void
      {
         this._isGame = param1;
      }
      
      public function get maxUsers() : int
      {
         return this._maxUsers;
      }
      
      public function set maxUsers(param1:int) : void
      {
         this._maxUsers = param1;
      }
      
      public function get maxVariables() : int
      {
         return this._maxVariables;
      }
      
      public function set maxVariables(param1:int) : void
      {
         this._maxVariables = param1;
      }
      
      public function get maxSpectators() : int
      {
         return this._maxSpectators;
      }
      
      public function set maxSpectators(param1:int) : void
      {
         this._maxSpectators = param1;
      }
      
      public function get variables() : Array
      {
         return this._variables;
      }
      
      public function set variables(param1:Array) : void
      {
         this._variables = param1;
      }
      
      public function get permissions() : RoomPermissions
      {
         return this._permissions;
      }
      
      public function set permissions(param1:RoomPermissions) : void
      {
         this._permissions = param1;
      }
      
      public function get events() : RoomEvents
      {
         return this._events;
      }
      
      public function set events(param1:RoomEvents) : void
      {
         this._events = param1;
      }
      
      public function get extension() : RoomExtension
      {
         return this._extension;
      }
      
      public function set extension(param1:RoomExtension) : void
      {
         this._extension = param1;
      }
      
      public function get groupId() : String
      {
         return this._groupId;
      }
      
      public function set groupId(param1:String) : void
      {
         this._groupId = param1;
      }
   }
}
