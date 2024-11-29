package com.monsters.debug
{
   import flash.display.Stage;
   import flash.events.KeyboardEvent;
   import flash.external.ExternalInterface;
   import flash.utils.Dictionary;
   import flash.utils.getTimer;
   
   public class Console
   {
      
      public static const PRINT:String = "print";
      
      public static const WARNING:String = "warning";
      
      public static const ERROR:String = "error";
      
      public static const keyCodes:Vector.<uint> = Vector.<uint>([223,192]);
      
      public static var view:ConsoleView;
      
      private static var _commands:Dictionary;
       
      
      public function Console()
      {
         super();
      }
      
      public static function initialize(param1:Stage) : void
      {
         if(!GLOBAL._aiDesignMode)
         {
            return;
         }
         view = new ConsoleView();
         _commands = new Dictionary();
         param1.addChild(view);
         param1.tabChildren = false;
         view.deactivate();
         param1.addEventListener(KeyboardEvent.KEY_UP,onKeyDown);
         ConsoleCommands.initialize();
      }
      
      protected static function onKeyDown(param1:KeyboardEvent) : void
      {
         if(isKey(param1.keyCode) && Boolean(view))
         {
            view.toggleActive();
            param1.stopImmediatePropagation();
         }
      }
      
      public static function warning(param1:String = "", param2:Boolean = false) : void
      {
         print("WARNING: " + param1,param2,WARNING);
      }
      
      public static function print(param1:*, param2:Boolean = false, param3:String = "print") : void
      {
         var _loc5_:String = null;
         if(!GLOBAL._aiDesignMode)
         {
            return;
         }
         if(!(param1 is String))
         {
            param1 = Object(param1).toString();
         }
         if(!GLOBAL._aiDesignMode)
         {
            return;
         }
         var _loc4_:int = getTimer() / 1000;
         if(param2 && !ExternalInterface.available)
         {
            param1 = getSource() + "|| " + param1;
         }
         view.addLogMessage(param3,"",param1);
      }
      
      public static function processLine(param1:String) : String
      {
         var _loc6_:Number = NaN;
         var _loc3_:int = param1.indexOf(" ") + 1;
         var _loc4_:String = param1.substring(0,!!_loc3_ ? _loc3_ - 1 : param1.length).toLowerCase();
         var _loc5_:Function;
         if((_loc5_ = _commands[_loc4_]) != null)
         {
            arguments = [];
            _loc6_ = param1.indexOf(",",_loc3_);
            arguments.push(param1.substring(_loc3_,_loc6_ != -1 ? _loc6_ : param1.length));
            _loc3_ = _loc6_;
            while(_loc6_ != -1)
            {
               arguments.push(param1.substring(_loc3_,_loc6_));
               _loc6_ = param1.indexOf(",",_loc6_);
            }
            return _loc5_.apply(null,arguments);
         }
         view.addLogMessage(WARNING,"","INVALID COMMAND");
         return null;
      }
      
      public static function registerCommand(param1:String, param2:Function) : void
      {
         _commands[param1.toLowerCase()] = param2;
      }
      
      public static function getSource(param1:uint = 4) : String
      {
         if(ExternalInterface.available)
         {
            return "";
         }
         var _loc2_:String = getStackTrace();
         _loc2_ = String(_loc2_.split("at ")[param1]);
         if(!_loc2_)
         {
            return "invalid stack trace";
         }
         var _loc3_:String = _loc2_.substring(_loc2_.lastIndexOf(":"),_loc2_.indexOf("]"));
         _loc2_ = _loc2_.substring(0,_loc2_.indexOf("()") + 2);
         _loc2_ = _loc2_.replace("Function","");
         _loc2_ = _loc2_.replace("$","");
         while(_loc2_.search("/") != -1)
         {
            _loc2_ = _loc2_.replace("/",".");
         }
         return _loc2_ + _loc3_;
      }
      
      public static function getStackTrace() : String
      {
         var stackTrace:String = null;
         try
         {
            throw new Error();
         }
         catch(e:Error)
         {
            stackTrace = String(e.getStackTrace());
         }
         return stackTrace;
      }
      
      public static function isKey(param1:uint) : Boolean
      {
         var _loc2_:int = 0;
         while(_loc2_ < keyCodes.length)
         {
            if(keyCodes[_loc2_] == param1)
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      public static function get commands() : Dictionary
      {
         return _commands;
      }
   }
}
