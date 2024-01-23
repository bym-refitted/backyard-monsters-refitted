package com.monsters.chat
{
   import flash.events.Event;
   import flash.utils.Dictionary;
   
   public final class ChatEvent extends Event
   {
      
      public static const CONNECT:String = "connect";
      
      public static const LOGIN:String = "login";
      
      public static const JOIN:String = "join";
      
      public static const LEAVE:String = "leave";
      
      public static const SAY:String = "say";
      
      public static const LIST:String = "list";
      
      public static const MEMBERS:String = "members";
      
      public static const IGNORE:String = "ignore";
      
      public static const IGNOREERROR:String = "ignoreerror";
      
      public static const UPDATE_NAME:String = "update_name";
      
      public static const USER_ENTER:String = "user_enter";
      
      public static const USER_EXIT:String = "user_exit";
       
      
      private var map:Dictionary;
      
      public function ChatEvent(param1:String, param2:Boolean = true, param3:Dictionary = null, param4:Boolean = false, param5:Boolean = false)
      {
         super(param1,param4,param5);
         if(param3 == null)
         {
            this.map = new Dictionary();
         }
         else
         {
            this.map = param3;
         }
         this.map["success"] = param2;
      }
      
      public function get Success() : Boolean
      {
         if(this.map == null)
         {
            return false;
         }
         if("success" in this.map)
         {
            return this.map["success"];
         }
         return false;
      }
      
      public function Get(param1:String) : Object
      {
         if(this.map == null)
         {
            return null;
         }
         if(param1 in this.map)
         {
            return this.map[param1];
         }
         return null;
      }
   }
}
