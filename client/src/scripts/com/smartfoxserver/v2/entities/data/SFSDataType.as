package com.smartfoxserver.v2.entities.data
{
   public class SFSDataType
   {
      
      public static const NULL:int = 0;
      
      public static const BOOL:int = 1;
      
      public static const BYTE:int = 2;
      
      public static const SHORT:int = 3;
      
      public static const INT:int = 4;
      
      public static const LONG:int = 5;
      
      public static const FLOAT:int = 6;
      
      public static const DOUBLE:int = 7;
      
      public static const UTF_STRING:int = 8;
      
      public static const BOOL_ARRAY:int = 9;
      
      public static const BYTE_ARRAY:int = 10;
      
      public static const SHORT_ARRAY:int = 11;
      
      public static const INT_ARRAY:int = 12;
      
      public static const LONG_ARRAY:int = 13;
      
      public static const FLOAT_ARRAY:int = 14;
      
      public static const DOUBLE_ARRAY:int = 15;
      
      public static const UTF_STRING_ARRAY:int = 16;
      
      public static const SFS_ARRAY:int = 17;
      
      public static const SFS_OBJECT:int = 18;
      
      public static const CLASS:int = 19;
      
      private static const TYPE_NAMES:Array = ["NULL","BOOL","BYTE","SHORT","INT","LONG","FLOAT","DOUBLE","UTF_STRING","BOOL_ARRAY","BYTE_ARRAY","SHORT_ARRAY","INT_ARRAY","LONG_ARRAY","FLOAT_ARRAY","DOUBLE_ARRAY","UTF_STRING_ARRAY","SFS_ARRAY","SFS_OBJECT","CLASS"];
       
      
      public function SFSDataType()
      {
         super();
      }
      
      public static function fromId(param1:int) : String
      {
         return TYPE_NAMES[param1];
      }
   }
}
