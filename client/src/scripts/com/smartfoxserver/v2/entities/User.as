package com.smartfoxserver.v2.entities
{
   import com.smartfoxserver.v2.entities.managers.IUserManager;
   import com.smartfoxserver.v2.entities.variables.UserVariable;
   
   public interface User
   {
       
      
      function get id() : int;
      
      function get name() : String;
      
      function get playerId() : int;
      
      function get isPlayer() : Boolean;
      
      function get isSpectator() : Boolean;
      
      function getPlayerId(param1:Room) : int;
      
      function setPlayerId(param1:int, param2:Room) : void;
      
      function removePlayerId(param1:Room) : void;
      
      function get privilegeId() : int;
      
      function set privilegeId(param1:int) : void;
      
      function get userManager() : IUserManager;
      
      function set userManager(param1:IUserManager) : void;
      
      function isGuest() : Boolean;
      
      function isStandardUser() : Boolean;
      
      function isModerator() : Boolean;
      
      function isAdmin() : Boolean;
      
      function isPlayerInRoom(param1:Room) : Boolean;
      
      function isSpectatorInRoom(param1:Room) : Boolean;
      
      function isJoinedInRoom(param1:Room) : Boolean;
      
      function get isItMe() : Boolean;
      
      function getVariables() : Array;
      
      function getVariable(param1:String) : UserVariable;
      
      function setVariable(param1:UserVariable) : void;
      
      function setVariables(param1:Array) : void;
      
      function containsVariable(param1:String) : Boolean;
      
      function get properties() : Object;
      
      function set properties(param1:Object) : void;
   }
}
