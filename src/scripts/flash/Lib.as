package flash
{
   import flash.display.MovieClip;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.system.fscommand;
   import flash.utils.getDefinitionByName;
   import flash.utils.getTimer;
   
   public class Lib
   {
      
      public static var current:MovieClip;
       
      
      public function Lib()
      {
      }
      
      public static function getTimer() : int
      {
         return getTimer();
      }
      
      public static function eval(param1:String) : *
      {
         var _loc6_:* = null;
         var _loc8_:* = null as String;
         var _loc3_:Array = param1.split(".");
         var _loc4_:Array = [];
         var _loc5_:* = null;
         while(int(_loc3_.length) > 0)
         {
            try
            {
               _loc5_ = getDefinitionByName(_loc3_.join("."));
            }
            catch(_loc_e_:*)
            {
               _loc4_.unshift(_loc3_.pop());
               if(_loc5_ != null)
               {
                  break;
               }
               continue;
            }
         }
         var _loc7_:int = 0;
         while(_loc7_ < int(_loc4_.length))
         {
            _loc8_ = String(_loc4_[_loc7_]);
            _loc7_++;
            if(_loc5_ == null)
            {
               return null;
            }
            _loc5_ = _loc5_[_loc8_];
         }
         return _loc5_;
      }
      
      public static function getURL(param1:URLRequest, param2:String = undefined) : void
      {
         var _loc3_:Function = navigateToURL;
         if(param2 == null)
         {
            _loc3_(param1);
         }
         else
         {
            _loc3_(param1,param2);
         }
      }
      
      public static function fscommand(param1:String, param2:String = undefined) : void
      {
         fscommand(param1,param2 == null ? "" : param2);
      }
      
      public static function trace(param1:*) : void
      {
         trace(param1);
      }
      
      public static function attach(param1:String) : MovieClip
      {
         var _loc2_:* = getDefinitionByName(param1) as Class;
         return new _loc2_();
      }
      
      public static function §as§(param1:*, param2:Class) : Object
      {
         return param1 as param2;
      }
   }
}
