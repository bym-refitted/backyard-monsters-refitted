package com.smartfoxserver.v2.entities
{
   public class SFSConstants
   {
      
      public static const DEFAULT_GROUP_ID:String = "default";
      
      public static const REQUEST_UDP_PACKET_ID:String = "$FS_REQUEST_UDP_TIMESTAMP";
       
      
      public function SFSConstants()
      {
         super();
         throw new Error("This class should not be instantiated");
      }
   }
}
