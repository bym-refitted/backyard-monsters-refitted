package as3reflect
{
   public class AbstractMember extends MetaDataContainer implements IMember
   {
       
      
      private var _declaringType:as3reflect.Type;
      
      private var _name:String;
      
      private var _isStatic:Boolean;
      
      private var _type:as3reflect.Type;
      
      public function AbstractMember(param1:String, param2:as3reflect.Type, param3:as3reflect.Type, param4:Boolean, param5:Array = null)
      {
         super(param5);
         _name = param1;
         _type = param2;
         _declaringType = param3;
         _isStatic = param4;
      }
      
      public function get name() : String
      {
         return _name;
      }
      
      public function get declaringType() : as3reflect.Type
      {
         return _declaringType;
      }
      
      public function get type() : as3reflect.Type
      {
         return _type;
      }
      
      public function get isStatic() : Boolean
      {
         return _isStatic;
      }
   }
}
