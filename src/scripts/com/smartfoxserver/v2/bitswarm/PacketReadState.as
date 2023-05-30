package com.smartfoxserver.v2.bitswarm
{
   public class PacketReadState
   {
      
      public static const WAIT_NEW_PACKET:int = 0;
      
      public static const WAIT_DATA_SIZE:int = 1;
      
      public static const WAIT_DATA_SIZE_FRAGMENT:int = 2;
      
      public static const WAIT_DATA:int = 3;
       
      
      public function PacketReadState()
      {
         super();
      }
   }
}
