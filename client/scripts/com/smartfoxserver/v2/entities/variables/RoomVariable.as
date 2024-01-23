package com.smartfoxserver.v2.entities.variables
{
   public interface RoomVariable extends UserVariable
   {
       
      
      function get isPrivate() : Boolean;
      
      function get isPersistent() : Boolean;
      
      function set isPrivate(param1:Boolean) : void;
      
      function set isPersistent(param1:Boolean) : void;
   }
}
