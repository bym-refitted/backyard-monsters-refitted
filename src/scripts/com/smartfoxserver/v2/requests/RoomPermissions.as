package com.smartfoxserver.v2.requests
{
   public class RoomPermissions
   {
       
      
      private var _allowNameChange:Boolean;
      
      private var _allowPasswordStateChange:Boolean;
      
      private var _allowPublicMessages:Boolean;
      
      private var _allowResizing:Boolean;
      
      public function RoomPermissions()
      {
         super();
      }
      
      public function get allowNameChange() : Boolean
      {
         return this._allowNameChange;
      }
      
      public function set allowNameChange(param1:Boolean) : void
      {
         this._allowNameChange = param1;
      }
      
      public function get allowPasswordStateChange() : Boolean
      {
         return this._allowPasswordStateChange;
      }
      
      public function set allowPasswordStateChange(param1:Boolean) : void
      {
         this._allowPasswordStateChange = param1;
      }
      
      public function get allowPublicMessages() : Boolean
      {
         return this._allowPublicMessages;
      }
      
      public function set allowPublicMessages(param1:Boolean) : void
      {
         this._allowPublicMessages = param1;
      }
      
      public function get allowResizing() : Boolean
      {
         return this._allowResizing;
      }
      
      public function set allowResizing(param1:Boolean) : void
      {
         this._allowResizing = param1;
      }
   }
}
