package com.smartfoxserver.v2.util
{
   public class BuddyOnlineState
   {
      
      public static const ONLINE:int = 0;
      
      public static const OFFLINE:int = 1;
      
      public static const LEFT_THE_SERVER:int = 2;
       
      
      public function BuddyOnlineState()
      {
         super();
         throw new Error("This class should not be instantiated");
      }
   }
}
