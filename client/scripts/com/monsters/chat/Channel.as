package com.monsters.chat
{
   public class Channel
   {
      
      public static const ADMIN:Channel = new Channel("admin","system");
       
      
      private var name:String;
      
      private var type:String;
      
      public function Channel(param1:String, param2:String)
      {
         super();
         this.name = param1;
         this.type = param2;
      }
      
      public function get Name() : String
      {
         return this.name;
      }
      
      public function get Type() : String
      {
         return this.type;
      }
   }
}
