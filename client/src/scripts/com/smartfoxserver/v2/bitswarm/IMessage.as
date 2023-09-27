package com.smartfoxserver.v2.bitswarm
{
   import com.smartfoxserver.v2.entities.data.ISFSObject;
   
   public interface IMessage
   {
       
      
      function get id() : int;
      
      function set id(param1:int) : void;
      
      function get content() : ISFSObject;
      
      function set content(param1:ISFSObject) : void;
      
      function get targetController() : int;
      
      function set targetController(param1:int) : void;
      
      function get isEncrypted() : Boolean;
      
      function set isEncrypted(param1:Boolean) : void;
      
      function get isUDP() : Boolean;
      
      function set isUDP(param1:Boolean) : void;
      
      function get packetId() : Number;
      
      function set packetId(param1:Number) : void;
   }
}
