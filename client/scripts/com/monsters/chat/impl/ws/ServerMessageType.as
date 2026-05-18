package com.monsters.chat.impl.ws
{
   public final class ServerMessageType
   {
      public static const AUTH_OK:String = "auth_ok";
      public static const AUTH_FAIL:String = "auth_fail";
      public static const JOINED:String = "joined";
      public static const MESSAGE:String = "message";
      public static const USER_ENTER:String = "user_enter";
      public static const USER_EXIT:String = "user_exit";
      public static const IGNORE_LIST:String = "ignore_list";

      public function ServerMessageType()
      {
         super();
      }
   }
}
