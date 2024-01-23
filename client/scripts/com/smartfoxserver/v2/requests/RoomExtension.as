package com.smartfoxserver.v2.requests
{
   public class RoomExtension
   {
       
      
      private var _id:String;
      
      private var _className:String;
      
      private var _propertiesFile:String;
      
      public function RoomExtension(param1:String, param2:String)
      {
         super();
         this._id = param1;
         this._className = param2;
         this._propertiesFile = "";
      }
      
      public function get id() : String
      {
         return this._id;
      }
      
      public function get className() : String
      {
         return this._className;
      }
      
      public function get propertiesFile() : String
      {
         return this._propertiesFile;
      }
      
      public function set propertiesFile(param1:String) : void
      {
         this._propertiesFile = param1;
      }
   }
}
