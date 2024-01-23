
{
   (global.Void = §§newclass(Void,Object)).__constructs__ = [];
}

package
{
   import flash.Boot;
   
   public final class Void
   {
      
      public static const __isenum:Boolean = true;
      
      public static var __constructs__:*;
       
      
      public var tag:String;
      
      public var index:int;
      
      public var params:Array;
      
      public const __enum__:Boolean = true;
      
      public function Void(param1:String, param2:int, param3:*)
      {
         tag = param1;
         index = param2;
         params = param3;
      }
      
      final public function toString() : String
      {
         return Boot.enum_to_string(this);
      }
   }
}
