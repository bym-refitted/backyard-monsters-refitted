package as3reflect
{
   public class Accessor extends Field
   {
       
      
      private var _access:as3reflect.AccessorAccess;
      
      public function Accessor(param1:String, param2:as3reflect.AccessorAccess, param3:Type, param4:Type, param5:Boolean, param6:Array = null)
      {
         super(param1,param3,param4,param5,param6);
         _access = param2;
      }
      
      public function get access() : as3reflect.AccessorAccess
      {
         return _access;
      }
   }
}
