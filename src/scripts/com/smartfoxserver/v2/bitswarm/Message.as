package com.smartfoxserver.v2.bitswarm
{
   import com.smartfoxserver.v2.entities.data.ISFSObject;
   
   public class Message implements IMessage
   {
       
      
      private var _id:int;
      
      private var _content:ISFSObject;
      
      private var _targetController:int;
      
      private var _isEncrypted:Boolean;
      
      private var _isUDP:Boolean;
      
      private var _packetId:Number = NaN;
      
      public function Message()
      {
         super();
         this._isEncrypted = false;
         this._isUDP = false;
      }
      
      public function get id() : int
      {
         return this._id;
      }
      
      public function set id(param1:int) : void
      {
         this._id = param1;
      }
      
      public function get content() : ISFSObject
      {
         return this._content;
      }
      
      public function set content(param1:ISFSObject) : void
      {
         this._content = param1;
      }
      
      public function get targetController() : int
      {
         return this._targetController;
      }
      
      public function set targetController(param1:int) : void
      {
         this._targetController = param1;
      }
      
      public function get isEncrypted() : Boolean
      {
         return this._isEncrypted;
      }
      
      public function set isEncrypted(param1:Boolean) : void
      {
         this._isEncrypted = param1;
      }
      
      public function get isUDP() : Boolean
      {
         return this._isUDP;
      }
      
      public function set isUDP(param1:Boolean) : void
      {
         this._isUDP = param1;
      }
      
      public function get packetId() : Number
      {
         return this._packetId;
      }
      
      public function set packetId(param1:Number) : void
      {
         this._packetId = param1;
      }
      
      public function toString() : String
      {
         var _loc1_:* = "{ Message id: " + this._id + " }\n";
         _loc1_ += "{ Dump: }\n";
         return _loc1_ + this._content.getDump();
      }
   }
}
