package com.smartfoxserver.v2.entities.invitation
{
   import com.smartfoxserver.v2.entities.User;
   import com.smartfoxserver.v2.entities.data.ISFSObject;
   
   public interface Invitation
   {
       
      
      function get id() : int;
      
      function set id(param1:int) : void;
      
      function get inviter() : User;
      
      function get invitee() : User;
      
      function get secondsForAnswer() : int;
      
      function get params() : ISFSObject;
   }
}
