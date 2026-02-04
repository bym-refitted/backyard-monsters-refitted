package com.monsters.chat
{
   /**
    * Interface for chat authentication systems.
    */
   public interface IAuthenticationSystem
   {
      function authenticate():Boolean;
      
      function get User():UserRecord;
      
      function get Password():String;
      
      function get Params():ChatData;
   }
}
