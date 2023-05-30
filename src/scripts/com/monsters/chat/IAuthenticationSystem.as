package com.monsters.chat
{
   public interface IAuthenticationSystem
   {
       
      
      function authenticate() : Boolean;
      
      function get User() : UserRecord;
   }
}
