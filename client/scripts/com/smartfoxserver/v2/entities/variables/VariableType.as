package com.smartfoxserver.v2.entities.variables
{
   public class VariableType
   {
      
      public static const NULL:int = 0;
      
      public static const BOOL:int = 1;
      
      public static const INT:int = 2;
      
      public static const DOUBLE:int = 3;
      
      public static const STRING:int = 4;
      
      public static const OBJECT:int = 5;
      
      public static const ARRAY:int = 6;
      
      private static const TYPES_AS_STRING:Array = ["Null","Bool","Int","Double","String","Object","Array"];
       
      
      public function VariableType()
      {
         super();
         throw new Error("This class is not instantiable");
      }
      
      public static function getTypeName(param1:int) : String
      {
         return TYPES_AS_STRING[param1];
      }
      
      public static function getTypeFromName(param1:String) : int
      {
         return TYPES_AS_STRING.indexOf(param1);
      }
   }
}
