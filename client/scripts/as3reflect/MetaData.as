package as3reflect
{
   public class MetaData
   {
      
      public static const TRANSIENT:String = "Transient";
      
      public static const BINDABLE:String = "Bindable";
       
      
      private var _arguments:Array;
      
      private var _name:String;
      
      public function MetaData(param1:String, param2:Array = null)
      {
         super();
         _name = param1;
         _arguments = param2 == null ? [] : param2;
      }
      
      public function hasArgumentWithKey(param1:String) : Boolean
      {
         return getArgument(param1) != null;
      }
      
      public function getArgument(param1:String) : MetaDataArgument
      {
         var _loc2_:MetaDataArgument = null;
         var _loc3_:int = 0;
         while(_loc3_ < _arguments.length)
         {
            if(_arguments[_loc3_].key == param1)
            {
               _loc2_ = _arguments[_loc3_];
               break;
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function get arguments() : Array
      {
         return _arguments;
      }
      
      public function get name() : String
      {
         return _name;
      }
      
      public function toString() : String
      {
         return "[MetaData(" + name + ", " + arguments + ")]";
      }
   }
}
