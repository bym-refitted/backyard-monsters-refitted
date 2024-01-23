package com.smartfoxserver.v2.entities.managers
{
   import com.smartfoxserver.v2.SmartFox;
   import com.smartfoxserver.v2.entities.Room;
   import com.smartfoxserver.v2.entities.User;
   
   public interface IRoomManager
   {
       
      
      function get ownerZone() : String;
      
      function addRoom(param1:Room, param2:Boolean = true) : void;
      
      function addGroup(param1:String) : void;
      
      function replaceRoom(param1:Room, param2:Boolean = true) : Room;
      
      function removeGroup(param1:String) : void;
      
      function containsGroup(param1:String) : Boolean;
      
      function containsRoom(param1:*) : Boolean;
      
      function containsRoomInGroup(param1:*, param2:String) : Boolean;
      
      function changeRoomName(param1:Room, param2:String) : void;
      
      function changeRoomPasswordState(param1:Room, param2:Boolean) : void;
      
      function changeRoomCapacity(param1:Room, param2:int, param3:int) : void;
      
      function getRoomById(param1:int) : Room;
      
      function getRoomByName(param1:String) : Room;
      
      function getRoomList() : Array;
      
      function getRoomCount() : int;
      
      function getRoomGroups() : Array;
      
      function getRoomListFromGroup(param1:String) : Array;
      
      function getJoinedRooms() : Array;
      
      function getUserRooms(param1:User) : Array;
      
      function removeRoom(param1:Room) : void;
      
      function removeRoomById(param1:int) : void;
      
      function removeRoomByName(param1:String) : void;
      
      function removeUser(param1:User) : void;
      
      function get smartFox() : SmartFox;
   }
}
