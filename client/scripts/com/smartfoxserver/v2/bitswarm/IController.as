package com.smartfoxserver.v2.bitswarm
{
   public interface IController
   {
       
      
      function get id() : int;
      
      function set id(param1:int) : void;
      
      function handleMessage(param1:IMessage) : void;
   }
}
