package com.smartfoxserver.v2.entities.data
{
   public class SFSDataWrapper
   {
       
      
      private var _type:int;
      
      private var _data;
      
      public function SFSDataWrapper(param1:int, param2:*)
      {
         super();
         this._type = param1;
         this._data = param2;
      }
      
      public function get type() : int
      {
         return this._type;
      }
      
      public function get data() : *
      {
         return this._data;
      }
   }
}
