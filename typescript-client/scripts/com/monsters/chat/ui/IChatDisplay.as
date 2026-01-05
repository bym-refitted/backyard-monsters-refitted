package com.monsters.chat.ui
{
   import flash.events.IEventDispatcher;
   
   public interface IChatDisplay extends IEventDispatcher
   {
       
      
      function clearChat() : void;
      
      function init() : void;
      
      function push(param1:String, param2:String = null, param3:String = null, param4:String = null, param5:Boolean = false) : void;
      
      function update() : void;
      
      function get inputText() : String;
      
      function clearInputText() : void;
   }
}
