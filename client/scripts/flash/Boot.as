package flash
{
   import flash.display.MovieClip;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.utils.getQualifiedClassName;
   import flash.utils.setTimeout;
   
   public dynamic class Boot extends MovieClip
   {
      
      public static var tf:TextField;
      
      public static var lines:Array;
      
      public static var lastError:Error;
      
      public static var skip_constructor:Boolean;
       
      
      public function Boot()
      {
         super();
         if(Boot.skip_constructor)
         {
            return;
         }
      }
      
      public static function enum_to_string(param1:Object) : String
      {
         var _loc5_:* = null;
         if(param1.params == null)
         {
            return String(param1.tag);
         }
         var _loc2_:Array = [];
         var _loc3_:int = 0;
         var _loc4_:Array = param1.params;
         while(_loc3_ < int(_loc4_.length))
         {
            _loc5_ = _loc4_[_loc3_];
            _loc3_++;
            _loc2_.push(Boot.__string_rec(_loc5_,""));
         }
         return String(param1.tag) + "(" + _loc2_.join(",") + ")";
      }
      
      public static function __instanceof(param1:*, param2:*) : Boolean
      {
         var _loc4_:* = null;
         try
         {
            if(param2 == Dynamic)
            {
               return true;
            }
            return param1 is param2;
         }
         catch(_loc_e_:*)
         {
         }
      }
      
      public static function __clear_trace() : void
      {
         if(Boot.tf == null)
         {
            return;
         }
         Boot.tf.parent.removeChild(Boot.tf);
         Boot.tf = null;
         Boot.lines = null;
      }
      
      public static function __set_trace_color(param1:uint) : void
      {
         Boot.getTrace().textColor = param1;
      }
      
      public static function getTrace() : TextField
      {
         var _loc2_:* = null as TextFormat;
         var _loc1_:MovieClip = Lib.current;
         if(Boot.tf == null)
         {
            Boot.tf = new TextField();
            _loc2_ = Boot.tf.getTextFormat();
            _loc2_.font = "Consolas";
            Boot.tf.defaultTextFormat = _loc2_;
            Boot.tf.width = _loc1_.stage == null ? 800 : _loc1_.stage.stageWidth;
            Boot.tf.autoSize = TextFieldAutoSize.LEFT;
         }
         if(_loc1_.stage == null)
         {
            _loc1_.addChild(Boot.tf);
         }
         else
         {
            _loc1_.stage.addChild(Boot.tf);
         }
         return Boot.tf;
      }
      
      public static function __trace(param1:*, param2:Object) : void
      {
         var _loc3_:TextField = Boot.getTrace();
         var _loc4_:String = param2 == null ? "(null)" : String(param2.fileName) + ":" + int(param2.lineNumber);
         if(Boot.lines == null)
         {
            Boot.lines = [];
         }
         Boot.lines = Boot.lines.concat((_loc4_ + ": " + Boot.__string_rec(param1,"")).split("\n"));
         _loc3_.text = Boot.lines.join("\n");
         var _loc5_:Stage;
         if((_loc5_ = Lib.current.stage) == null)
         {
            return;
         }
         while(int(Boot.lines.length) > 1 && _loc3_.height > _loc5_.stageHeight)
         {
            Boot.lines.shift();
            _loc3_.text = Boot.lines.join("\n");
         }
      }
      
      public static function __string_rec(param1:*, param2:String) : String
      {
         var _loc4_:* = null as String;
         var _loc5_:* = null as Array;
         var _loc6_:* = null as Array;
         var _loc7_:* = 0;
         var _loc8_:* = null;
         var _loc9_:* = null as String;
         var _loc10_:Boolean = false;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:* = null as String;
         var _loc3_:String = getQualifiedClassName(param1);
         if((_loc4_ = _loc3_) == "Object")
         {
            _loc7_ = 0;
            _loc6_ = [];
            _loc8_ = param1;
            for(_loc7_ in _loc8_)
            {
               _loc6_.push(_loc7_);
            }
            _loc5_ = _loc6_;
            _loc9_ = "{";
            _loc10_ = true;
            _loc7_ = 0;
            _loc11_ = int(_loc5_.length);
            while(_loc7_ < _loc11_)
            {
               _loc12_ = _loc7_++;
               _loc13_ = String(_loc5_[_loc12_]);
               if(_loc10_)
               {
                  _loc10_ = false;
               }
               else
               {
                  _loc9_ += ",";
               }
               _loc9_ += " " + _loc13_ + " : " + Boot.__string_rec(param1[_loc13_],param2);
            }
            if(!_loc10_)
            {
               _loc9_ += " ";
            }
            return _loc9_ + "}";
         }
         if(_loc4_ == "Array")
         {
            if(param1 == Array)
            {
               return "#Array";
            }
            _loc9_ = "[";
            _loc10_ = true;
            _loc5_ = param1;
            _loc7_ = 0;
            _loc11_ = int(_loc5_.length);
            while(_loc7_ < _loc11_)
            {
               _loc12_ = _loc7_++;
               if(_loc10_)
               {
                  _loc10_ = false;
               }
               else
               {
                  _loc9_ += ",";
               }
               _loc9_ += Boot.__string_rec(_loc5_[_loc12_],param2);
            }
            return _loc9_ + "]";
         }
         if((_loc4_ = typeof param1) == "function")
         {
            return "<function>";
         }
         return new String(param1);
      }
      
      public static function __unprotect__(param1:String) : String
      {
         return param1;
      }
      
      public function start() : void
      {
         var _loc3_:* = null;
         var _loc2_:MovieClip = Lib.current;
         try
         {
            if(_loc2_ == this && _loc2_.stage != null && _loc2_.stage.align == "")
            {
               _loc2_.stage.align = "TOP_LEFT";
            }
         }
         catch(_loc_e_:*)
         {
            if(_loc2_.stage == null)
            {
               _loc2_.addEventListener(Event.ADDED_TO_STAGE,doInitDelay);
            }
            else if(_loc2_.stage.stageWidth == 0)
            {
               setTimeout(start,1);
            }
            else
            {
               init();
            }
            return;
         }
      }
      
      public function init() : void
      {
         Boot.lastError = new Error();
         throw "assert";
      }
      
      public function doInitDelay(param1:*) : void
      {
         Lib.current.removeEventListener(Event.ADDED_TO_STAGE,doInitDelay);
         start();
      }
   }
}
