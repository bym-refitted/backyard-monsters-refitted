package com.smartfoxserver.v2.exceptions
{
   public class SFSValidationError extends Error
   {
       
      
      private var _errors:Array;
      
      public function SFSValidationError(param1:String, param2:Array, param3:int = 0)
      {
         super(param1,param3);
         this._errors = param2;
      }
      
      public function get errors() : Array
      {
         return this._errors;
      }
   }
}
