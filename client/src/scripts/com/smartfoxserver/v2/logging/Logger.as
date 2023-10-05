package com.smartfoxserver.v2.logging
{
   import flash.events.EventDispatcher;
   
   public class Logger extends EventDispatcher
   {
      
      private static var _instance:com.smartfoxserver.v2.logging.Logger;
      
      private static var _locked:Boolean = true;
       
      
      private var _enableConsoleTrace:Boolean = true;
      
      private var _enableEventDispatching:Boolean = false;
      
      private var _loggingLevel:int;
      
      public function Logger()
      {
         super();
         if(_locked)
         {
            throw new Error("Cannot instantiate the Logger using the constructor. Please use the getInstance() method");
         }
         this._loggingLevel = LogLevel.INFO;
      }
      
      public static function getInstance() : com.smartfoxserver.v2.logging.Logger
      {
         if(_instance == null)
         {
            _locked = false;
            _instance = new com.smartfoxserver.v2.logging.Logger();
            _locked = true;
         }
         return _instance;
      }
      
      public function get enableConsoleTrace() : Boolean
      {
         return this._enableConsoleTrace;
      }
      
      public function set enableConsoleTrace(param1:Boolean) : void
      {
         this._enableConsoleTrace = param1;
      }
      
      public function get enableEventDispatching() : Boolean
      {
         return this._enableEventDispatching;
      }
      
      public function set enableEventDispatching(param1:Boolean) : void
      {
         this._enableEventDispatching = param1;
      }
      
      public function get loggingLevel() : int
      {
         return this._loggingLevel;
      }
      
      public function set loggingLevel(param1:int) : void
      {
         this._loggingLevel = param1;
      }
      
      public function debug(... rest) : void
      {
         this.log(LogLevel.DEBUG,rest.join(" "));
      }
      
      public function info(... rest) : void
      {
         this.log(LogLevel.INFO,rest.join(" "));
      }
      
      public function warn(... rest) : void
      {
         this.log(LogLevel.WARN,rest.join(" "));
      }
      
      public function error(... rest) : void
      {
         this.log(LogLevel.ERROR,rest.join(" "));
      }
      
      private function log(param1:int, param2:String) : void
      {
         var _loc4_:Object = null;
         var _loc5_:LoggerEvent = null;
         if(param1 < this._loggingLevel)
         {
            return;
         }
         var _loc3_:String = LogLevel.fromString(param1);
         if(this._enableConsoleTrace)
         {
            trace("[SFS - " + _loc3_ + "]",param2);
         }
         if(this._enableEventDispatching)
         {
            (_loc4_ = {}).message = param2;
            _loc5_ = new LoggerEvent(_loc3_,_loc4_);
            dispatchEvent(_loc5_);
         }
      }
   }
}
