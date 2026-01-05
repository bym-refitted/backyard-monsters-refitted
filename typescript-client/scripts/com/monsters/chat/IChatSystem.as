package com.monsters.chat
{
   public interface IChatSystem
   {
       
      
      function login(param1:IAuthenticationSystem) : void;
      
      function join(param1:Channel, param2:String = null, param3:Boolean = false) : void;
      
      function leave(param1:Channel, param2:Boolean = false) : void;
      
      function say(param1:Channel, param2:String) : void;
      
      function list(param1:String = null) : void;
      
      function members(param1:Channel) : void;
      
      function ignore(param1:String, param2:String) : void;
      
      function unignore(param1:String) : void;
      
      function error(param1:String, param2:String) : void;
   }
}
