package as3reflect
{
   public class Parameter
   {
       
      
      private var _type:as3reflect.Type;
      
      private var _index:int;
      
      private var _isOptional:Boolean;
      
      public function Parameter(param1:int, param2:as3reflect.Type, param3:Boolean = false)
      {
         super();
         _index = param1;
         _type = param2;
         _isOptional = param3;
      }
      
      public function get index() : int
      {
         return _index;
      }
      
      public function get isOptional() : Boolean
      {
         return _isOptional;
      }
      
      public function get type() : as3reflect.Type
      {
         return _type;
      }
   }
}
