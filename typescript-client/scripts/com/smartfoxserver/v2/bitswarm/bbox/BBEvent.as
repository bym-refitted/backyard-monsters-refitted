package com.smartfoxserver.v2.bitswarm.bbox
{
   import com.smartfoxserver.v2.core.BaseEvent;
   
   public class BBEvent extends BaseEvent
   {
      
      public static const CONNECT:String = "bb-connect";
      
      public static const DISCONNECT:String = "bb-disconnect";
      
      public static const DATA:String = "bb-data";
      
      public static const IO_ERROR:String = "bb-ioError";
      
      public static const SECURITY_ERROR:String = "bb-securityError";
       
      
      public function BBEvent(param1:String, param2:Object = null)
      {
         super(param1);
         this.params = param2;
      }
   }
}
