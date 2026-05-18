package com.monsters.chat.impl.ws
{
   public final class ClientMessageType
   {
      public static const AUTH:String = "auth";
      public static const JOIN:String = "join";
      public static const LEAVE:String = "leave";
      public static const SAY:String = "say";
      public static const UPDATE_NAME:String = "updatename";
      public static const GET_IGNORE:String = "getignore";
      public static const IGNORE:String = "ignore";
      public static const UNIGNORE:String = "unignore";
      public static const PING:String = "ping";

      public function ClientMessageType()
      {
         super();
      }
   }
}
