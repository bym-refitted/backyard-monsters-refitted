package com.smartfoxserver.v2.entities.managers
{
   import com.smartfoxserver.v2.entities.Buddy;
   import com.smartfoxserver.v2.entities.variables.BuddyVariable;
   
   public interface IBuddyManager
   {
       
      
      function get isInited() : Boolean;
      
      function setInited() : void;
      
      function addBuddy(param1:Buddy) : void;
      
      function removeBuddyById(param1:int) : Buddy;
      
      function removeBuddyByName(param1:String) : Buddy;
      
      function containsBuddy(param1:String) : Boolean;
      
      function getBuddyById(param1:int) : Buddy;
      
      function getBuddyByName(param1:String) : Buddy;
      
      function getBuddyByNickName(param1:String) : Buddy;
      
      function get offlineBuddies() : Array;
      
      function get onlineBuddies() : Array;
      
      function get buddyList() : Array;
      
      function get buddyStates() : Array;
      
      function getMyVariable(param1:String) : BuddyVariable;
      
      function get myVariables() : Array;
      
      function get myOnlineState() : Boolean;
      
      function get myNickName() : String;
      
      function get myState() : String;
      
      function setMyVariable(param1:BuddyVariable) : void;
      
      function setMyVariables(param1:Array) : void;
      
      function setMyOnlineState(param1:Boolean) : void;
      
      function setMyNickName(param1:String) : void;
      
      function setMyState(param1:String) : void;
      
      function setBuddyStates(param1:Array) : void;
      
      function clearAll() : void;
   }
}
