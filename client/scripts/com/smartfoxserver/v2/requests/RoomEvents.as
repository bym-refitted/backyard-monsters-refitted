package com.smartfoxserver.v2.requests
{
   public class RoomEvents
   {
       
      
      private var _allowUserEnter:Boolean;
      
      private var _allowUserExit:Boolean;
      
      private var _allowUserCountChange:Boolean;
      
      private var _allowUserVariablesUpdate:Boolean;
      
      public function RoomEvents()
      {
         super();
         this._allowUserCountChange = false;
         this._allowUserEnter = false;
         this._allowUserExit = false;
         this._allowUserVariablesUpdate = false;
      }
      
      public function get allowUserEnter() : Boolean
      {
         return this._allowUserEnter;
      }
      
      public function set allowUserEnter(param1:Boolean) : void
      {
         this._allowUserEnter = param1;
      }
      
      public function get allowUserExit() : Boolean
      {
         return this._allowUserExit;
      }
      
      public function set allowUserExit(param1:Boolean) : void
      {
         this._allowUserExit = param1;
      }
      
      public function get allowUserCountChange() : Boolean
      {
         return this._allowUserCountChange;
      }
      
      public function set allowUserCountChange(param1:Boolean) : void
      {
         this._allowUserCountChange = param1;
      }
      
      public function get allowUserVariablesUpdate() : Boolean
      {
         return this._allowUserVariablesUpdate;
      }
      
      public function set allowUserVariablesUpdate(param1:Boolean) : void
      {
         this._allowUserVariablesUpdate = param1;
      }
   }
}
