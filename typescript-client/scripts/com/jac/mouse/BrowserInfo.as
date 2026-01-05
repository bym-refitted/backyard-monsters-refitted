package com.jac.mouse
{
   public class BrowserInfo
   {
      
      public static const WIN_PLATFORM:String = "win";
      
      public static const MAC_PLATFORM:String = "mac";
      
      public static const SAFARI_AGENT:String = "safari";
      
      public static const OPERA_AGENT:String = "opera";
      
      public static const IE_AGENT:String = "msie";
      
      public static const MOZILLA_AGENT:String = "mozilla";
      
      public static const CHROME_AGENT:String = "chrome";
       
      
      private var _platform:String = "undefined";
      
      private var _browser:String = "undefined";
      
      private var _version:String = "undefined";
      
      public function BrowserInfo(param1:Object, param2:Object, param3:String)
      {
         var _loc4_:String = null;
         var _loc5_:String = null;
         super();
         if(!param1 || !param2 || !param3)
         {
            return;
         }
         this._version = param1.version;
         for(_loc4_ in param1)
         {
            if(_loc4_ != "version")
            {
               if(param1[_loc4_] == true)
               {
                  this._browser = _loc4_;
                  break;
               }
            }
         }
         for(_loc5_ in param2)
         {
            if(param2[_loc5_] == true)
            {
               this._platform = _loc5_;
            }
         }
      }
      
      public function get platform() : String
      {
         return this._platform;
      }
      
      public function get browser() : String
      {
         return this._browser;
      }
      
      public function get version() : String
      {
         return this._version;
      }
   }
}
