package com.smartfoxserver.v2.entities
{
   import com.smartfoxserver.v2.entities.managers.IRoomManager;
   import com.smartfoxserver.v2.entities.variables.RoomVariable;
   
   public interface Room
   {
       
      
      function get id() : int;
      
      function get name() : String;
      
      function set name(param1:String) : void;
      
      function get groupId() : String;
      
      function get isJoined() : Boolean;
      
      function get isGame() : Boolean;
      
      function get isHidden() : Boolean;
      
      function get isPasswordProtected() : Boolean;
      
      function set isPasswordProtected(param1:Boolean) : void;
      
      function get isManaged() : Boolean;
      
      function get userCount() : int;
      
      function get maxUsers() : int;
      
      function get spectatorCount() : int;
      
      function get maxSpectators() : int;
      
      function get capacity() : int;
      
      function set isJoined(param1:Boolean) : void;
      
      function set isGame(param1:Boolean) : void;
      
      function set isHidden(param1:Boolean) : void;
      
      function set isManaged(param1:Boolean) : void;
      
      function set userCount(param1:int) : void;
      
      function set maxUsers(param1:int) : void;
      
      function set spectatorCount(param1:int) : void;
      
      function set maxSpectators(param1:int) : void;
      
      function addUser(param1:User) : void;
      
      function removeUser(param1:User) : void;
      
      function containsUser(param1:User) : Boolean;
      
      function getUserByName(param1:String) : User;
      
      function getUserById(param1:int) : User;
      
      function get userList() : Array;
      
      function get playerList() : Array;
      
      function get spectatorList() : Array;
      
      function getVariable(param1:String) : RoomVariable;
      
      function getVariables() : Array;
      
      function setVariable(param1:RoomVariable) : void;
      
      function setVariables(param1:Array) : void;
      
      function containsVariable(param1:String) : Boolean;
      
      function get properties() : Object;
      
      function set properties(param1:Object) : void;
      
      function get roomManager() : IRoomManager;
      
      function set roomManager(param1:IRoomManager) : void;
      
      function setPasswordProtected(param1:Boolean) : void;
   }
}
