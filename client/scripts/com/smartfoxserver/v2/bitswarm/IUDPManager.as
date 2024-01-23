package com.smartfoxserver.v2.bitswarm
{
   import com.smartfoxserver.v2.SmartFox;
   import flash.utils.ByteArray;
   
   public interface IUDPManager
   {
       
      
      function initialize(param1:String, param2:int) : void;
      
      function get inited() : Boolean;
      
      function set sfs(param1:SmartFox) : void;
      
      function nextUdpPacketId() : Number;
      
      function send(param1:ByteArray) : void;
      
      function reset() : void;
   }
}
