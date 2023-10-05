package as3reflect
{
   import flash.utils.Proxy;
   
   public class Method extends MetaDataContainer
   {
       
      
      private var _declaringType:as3reflect.Type;
      
      private var _parameters:Array;
      
      private var _name:String;
      
      private var _returnType:as3reflect.Type;
      
      private var _isStatic:Boolean;
      
      public function Method(param1:as3reflect.Type, param2:String, param3:Boolean, param4:Array, param5:*, param6:Array = null)
      {
         super(param6);
         _declaringType = param1;
         _name = param2;
         _isStatic = param3;
         _parameters = param4;
         _returnType = param5;
      }
      
      public function get declaringType() : as3reflect.Type
      {
         return _declaringType;
      }
      
      public function get name() : String
      {
         return _name;
      }
      
      public function toString() : String
      {
         return "[Method(name:\'" + name + "\', isStatic:" + isStatic + ")]";
      }
      
      public function get returnType() : as3reflect.Type
      {
         return _returnType;
      }
      
      public function invoke(param1:*, param2:Array) : *
      {
         var _loc3_:* = undefined;
         if(!(param1 is Proxy))
         {
            _loc3_ = param1[name].apply(param1,param2);
         }
         return _loc3_;
      }
      
      public function get parameters() : Array
      {
         return _parameters;
      }
      
      public function get fullName() : String
      {
         var _loc3_:Parameter = null;
         var _loc1_:* = "public ";
         if(isStatic)
         {
            _loc1_ += "static ";
         }
         _loc1_ += name + "(";
         var _loc2_:int = 0;
         while(_loc2_ < parameters.length)
         {
            _loc3_ = parameters[_loc2_] as Parameter;
            _loc1_ += _loc3_.type.name;
            _loc1_ += _loc2_ < parameters.length - 1 ? ", " : "";
            _loc2_++;
         }
         return _loc1_ + ("):" + returnType.name);
      }
      
      public function get isStatic() : Boolean
      {
         return _isStatic;
      }
   }
}
