package com.smartfoxserver.v2.logging
{
   public class LogLevel
   {
      
      public static const DEBUG:int = 100;
      
      public static const INFO:int = 200;
      
      public static const WARN:int = 300;
      
      public static const ERROR:int = 400;
       
      
      public function LogLevel()
      {
         super();
      }
      
      public static function fromString(param1:int) : String
      {
         var _loc2_:String = "Unknown";
         if(param1 == DEBUG)
         {
            _loc2_ = "DEBUG";
         }
         else if(param1 == INFO)
         {
            _loc2_ = "INFO";
         }
         else if(param1 == WARN)
         {
            _loc2_ = "WARN";
         }
         else if(param1 == ERROR)
         {
            _loc2_ = "ERROR";
         }
         return _loc2_;
      }
   }
}
