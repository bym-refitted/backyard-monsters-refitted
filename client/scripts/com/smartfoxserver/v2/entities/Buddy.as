package com.smartfoxserver.v2.entities
{
   import com.smartfoxserver.v2.entities.variables.BuddyVariable;
   
   public interface Buddy
   {
       
      
      function get id() : int;
      
      function get name() : String;
      
      function get isBlocked() : Boolean;
      
      function get isOnline() : Boolean;
      
      function get isTemp() : Boolean;
      
      function get state() : String;
      
      function get nickName() : String;
      
      function get variables() : Array;
      
      function getVariable(param1:String) : BuddyVariable;
      
      function containsVariable(param1:String) : Boolean;
      
      function getOfflineVariables() : Array;
      
      function getOnlineVariables() : Array;
      
      function setVariable(param1:BuddyVariable) : void;
      
      function setVariables(param1:Array) : void;
      
      function setId(param1:int) : void;
      
      function setBlocked(param1:Boolean) : void;
      
      function removeVariable(param1:String) : void;
      
      function clearVolatileVariables() : void;
   }
}
