package com.smartfoxserver.v2.entities.invitation
{
   import com.smartfoxserver.v2.entities.User;
   import com.smartfoxserver.v2.entities.data.ISFSObject;
   
   public class SFSInvitation implements Invitation
   {
       
      
      protected var _id:int;
      
      protected var _inviter:User;
      
      protected var _invitee:User;
      
      protected var _secondsForAnswer:int;
      
      protected var _params:ISFSObject;
      
      public function SFSInvitation(param1:User, param2:User, param3:int = 15, param4:ISFSObject = null)
      {
         super();
         this._inviter = param1;
         this._invitee = param2;
         this._secondsForAnswer = param3;
         this._params = param4;
      }
      
      public function get id() : int
      {
         return this._id;
      }
      
      public function set id(param1:int) : void
      {
         this._id = param1;
      }
      
      public function get inviter() : User
      {
         return this._inviter;
      }
      
      public function get invitee() : User
      {
         return this._invitee;
      }
      
      public function get secondsForAnswer() : int
      {
         return this._secondsForAnswer;
      }
      
      public function get params() : ISFSObject
      {
         return this._params;
      }
   }
}
