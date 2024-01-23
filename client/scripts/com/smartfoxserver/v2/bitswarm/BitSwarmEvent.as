package com.smartfoxserver.v2.bitswarm
{
   import com.smartfoxserver.v2.core.BaseEvent;
   
   public class BitSwarmEvent extends BaseEvent
   {
      
      public static const CONNECT:String = "connect";
      
      public static const DISCONNECT:String = "disconnect";
      
      public static const RECONNECTION_TRY:String = "reconnectionTry";
      
      public static const IO_ERROR:String = "ioError";
      
      public static const SECURITY_ERROR:String = "securityError";
      
      public static const DATA_ERROR:String = "dataError";
       
      
      public function BitSwarmEvent(param1:String, param2:Object = null)
      {
         super(param1);
         this.params = param2;
      }
   }
}
