package com.smartfoxserver.v2.entities
{
   import com.smartfoxserver.v2.entities.data.ISFSArray;
   import com.smartfoxserver.v2.entities.managers.IUserManager;
   import com.smartfoxserver.v2.entities.variables.SFSUserVariable;
   import com.smartfoxserver.v2.entities.variables.UserVariable;
   import com.smartfoxserver.v2.exceptions.SFSError;
   
   public class SFSUser implements User
   {
       
      
      protected var _id:int = -1;
      
      protected var _privilegeId:int = 0;
      
      protected var _name:String;
      
      protected var _isItMe:Boolean;
      
      protected var _variables:Object;
      
      protected var _properties:Object;
      
      protected var _isModerator:Boolean;
      
      protected var _playerIdByRoomId:Object;
      
      protected var _userManager:IUserManager;
      
      public function SFSUser(param1:int, param2:String, param3:Boolean = false)
      {
         super();
         this._id = param1;
         this._name = param2;
         this._isItMe = param3;
         this._variables = {};
         this._properties = {};
         this._isModerator = false;
         this._playerIdByRoomId = {};
      }
      
      public static function fromSFSArray(param1:ISFSArray, param2:Room = null) : User
      {
         var _loc3_:User = new SFSUser(param1.getInt(0),param1.getUtfString(1));
         _loc3_.privilegeId = param1.getShort(2);
         if(param2 != null)
         {
            _loc3_.setPlayerId(param1.getShort(3),param2);
         }
         var _loc4_:ISFSArray = param1.getSFSArray(4);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_.size())
         {
            _loc3_.setVariable(SFSUserVariable.fromSFSArray(_loc4_.getSFSArray(_loc5_)));
            _loc5_++;
         }
         return _loc3_;
      }
      
      public function get id() : int
      {
         return this._id;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function get playerId() : int
      {
         return this.getPlayerId(this.userManager.smartFox.lastJoinedRoom);
      }
      
      public function isJoinedInRoom(param1:Room) : Boolean
      {
         return param1.containsUser(this);
      }
      
      public function get privilegeId() : int
      {
         return this._privilegeId;
      }
      
      public function set privilegeId(param1:int) : void
      {
         this._privilegeId = param1;
      }
      
      public function isGuest() : Boolean
      {
         return this._privilegeId == UserPrivileges.GUEST;
      }
      
      public function isStandardUser() : Boolean
      {
         return this._privilegeId == UserPrivileges.STANDARD;
      }
      
      public function isModerator() : Boolean
      {
         return this._privilegeId == UserPrivileges.MODERATOR;
      }
      
      public function isAdmin() : Boolean
      {
         return this._privilegeId == UserPrivileges.ADMINISTRATOR;
      }
      
      public function get isPlayer() : Boolean
      {
         return this.playerId > 0;
      }
      
      public function get isSpectator() : Boolean
      {
         return !this.isPlayer;
      }
      
      public function getPlayerId(param1:Room) : int
      {
         var _loc2_:int = 0;
         if(this._playerIdByRoomId[param1.id] != null)
         {
            _loc2_ = int(this._playerIdByRoomId[param1.id]);
         }
         return _loc2_;
      }
      
      public function setPlayerId(param1:int, param2:Room) : void
      {
         this._playerIdByRoomId[param2.id] = param1;
      }
      
      public function removePlayerId(param1:Room) : void
      {
         delete this._playerIdByRoomId[param1.id];
      }
      
      public function isPlayerInRoom(param1:Room) : Boolean
      {
         return this._playerIdByRoomId[param1.id] > 0;
      }
      
      public function isSpectatorInRoom(param1:Room) : Boolean
      {
         return this._playerIdByRoomId[param1.id] < 0;
      }
      
      public function get isItMe() : Boolean
      {
         return this._isItMe;
      }
      
      public function get userManager() : IUserManager
      {
         return this._userManager;
      }
      
      public function set userManager(param1:IUserManager) : void
      {
         if(this._userManager != null)
         {
            throw new SFSError("Cannot re-assign the User Manager. Already set. User: " + this);
         }
         this._userManager = param1;
      }
      
      public function getVariables() : Array
      {
         var _loc2_:SFSUserVariable = null;
         var _loc1_:Array = [];
         for each(_loc2_ in this._variables)
         {
            _loc1_.push(_loc2_);
         }
         return _loc1_;
      }
      
      public function getVariable(param1:String) : UserVariable
      {
         return this._variables[param1];
      }
      
      public function setVariable(param1:UserVariable) : void
      {
         if(param1 != null)
         {
            if(param1.isNull())
            {
               delete this._variables[param1.name];
            }
            else
            {
               this._variables[param1.name] = param1;
            }
         }
      }
      
      public function setVariables(param1:Array) : void
      {
         var _loc2_:UserVariable = null;
         for each(_loc2_ in param1)
         {
            this.setVariable(_loc2_);
         }
      }
      
      public function containsVariable(param1:String) : Boolean
      {
         return this._variables[param1] != null;
      }
      
      private function removeUserVariable(param1:String) : void
      {
         delete this._variables[param1];
      }
      
      public function get properties() : Object
      {
         return this._properties;
      }
      
      public function set properties(param1:Object) : void
      {
         this._properties = param1;
      }
      
      public function toString() : String
      {
         return "[User: " + this._name + ", Id: " + this._id + ", isMe: " + this._isItMe + "]";
      }
   }
}
