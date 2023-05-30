package com.smartfoxserver.v2.entities
{
   import com.smartfoxserver.v2.entities.data.ISFSArray;
   import com.smartfoxserver.v2.entities.managers.IRoomManager;
   import com.smartfoxserver.v2.entities.managers.IUserManager;
   import com.smartfoxserver.v2.entities.managers.SFSUserManager;
   import com.smartfoxserver.v2.entities.variables.RoomVariable;
   import com.smartfoxserver.v2.entities.variables.SFSRoomVariable;
   import com.smartfoxserver.v2.exceptions.SFSError;
   import com.smartfoxserver.v2.kernel;
   import com.smartfoxserver.v2.util.ArrayUtil;
   
   public class SFSRoom implements Room
   {
       
      
      protected var _id:int;
      
      protected var _name:String;
      
      protected var _groupId:String;
      
      protected var _isGame:Boolean;
      
      protected var _isHidden:Boolean;
      
      protected var _isJoined:Boolean;
      
      protected var _isPasswordProtected:Boolean;
      
      protected var _isManaged:Boolean;
      
      protected var _variables:Object;
      
      protected var _properties:Object;
      
      protected var _userManager:IUserManager;
      
      protected var _maxUsers:int;
      
      protected var _maxSpectators:int;
      
      protected var _userCount:int;
      
      protected var _specCount:int;
      
      protected var _roomManager:IRoomManager;
      
      public function SFSRoom(param1:int, param2:String, param3:String = "default")
      {
         super();
         this._id = param1;
         this._name = param2;
         this._groupId = param3;
         this._isJoined = this._isGame = this._isHidden = false;
         this._isManaged = true;
         this._userCount = this._specCount = 0;
         this._variables = new Object();
         this._properties = new Object();
         this._userManager = new SFSUserManager(null);
      }
      
      public static function fromSFSArray(param1:ISFSArray) : Room
      {
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:RoomVariable = null;
         var _loc2_:Room = new SFSRoom(param1.getInt(0),param1.getUtfString(1),param1.getUtfString(2));
         _loc2_.isGame = param1.getBool(3);
         _loc2_.isHidden = param1.getBool(4);
         _loc2_.isPasswordProtected = param1.getBool(5);
         _loc2_.userCount = param1.getShort(6);
         _loc2_.maxUsers = param1.getShort(7);
         var _loc3_:ISFSArray = param1.getSFSArray(8);
         if(_loc3_.size() > 0)
         {
            _loc4_ = new Array();
            _loc5_ = 0;
            while(_loc5_ < _loc3_.size())
            {
               _loc6_ = SFSRoomVariable.fromSFSArray(_loc3_.getSFSArray(_loc5_));
               _loc4_.push(_loc6_);
               _loc5_++;
            }
            _loc2_.setVariables(_loc4_);
         }
         if(_loc2_.isGame)
         {
            _loc2_.spectatorCount = param1.getShort(9);
            _loc2_.maxSpectators = param1.getShort(10);
         }
         return _loc2_;
      }
      
      public function get id() : int
      {
         return this._id;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function set name(param1:String) : void
      {
         this._name = param1;
      }
      
      public function get groupId() : String
      {
         return this._groupId;
      }
      
      public function get isGame() : Boolean
      {
         return this._isGame;
      }
      
      public function get isHidden() : Boolean
      {
         return this._isHidden;
      }
      
      public function get isJoined() : Boolean
      {
         return this._isJoined;
      }
      
      public function get isPasswordProtected() : Boolean
      {
         return this._isPasswordProtected;
      }
      
      public function set isPasswordProtected(param1:Boolean) : void
      {
         this._isPasswordProtected = param1;
      }
      
      public function set isJoined(param1:Boolean) : void
      {
         this._isJoined = param1;
      }
      
      public function set isGame(param1:Boolean) : void
      {
         this._isGame = param1;
      }
      
      public function set isHidden(param1:Boolean) : void
      {
         this._isHidden = param1;
      }
      
      public function get isManaged() : Boolean
      {
         return this._isManaged;
      }
      
      public function set isManaged(param1:Boolean) : void
      {
         this._isManaged = param1;
      }
      
      public function getVariables() : Array
      {
         return ArrayUtil.objToArray(this._variables);
      }
      
      public function getVariable(param1:String) : RoomVariable
      {
         return this._variables[param1];
      }
      
      public function get userCount() : int
      {
         if(this._isJoined)
         {
            return this._userManager.userCount;
         }
         return this._userCount;
      }
      
      public function get maxUsers() : int
      {
         return this._maxUsers;
      }
      
      public function get capacity() : int
      {
         return this._maxUsers + this._maxSpectators;
      }
      
      public function get spectatorCount() : int
      {
         var _loc1_:int = 0;
         var _loc2_:User = null;
         if(this._isJoined)
         {
            _loc1_ = 0;
            for each(_loc2_ in this._userManager.getUserList())
            {
               if(_loc2_.isSpectatorInRoom(this))
               {
                  _loc1_++;
               }
            }
            return _loc1_;
         }
         return this._specCount;
      }
      
      public function get maxSpectators() : int
      {
         return this._maxSpectators;
      }
      
      public function set userCount(param1:int) : void
      {
         this._userCount = param1;
      }
      
      public function set maxUsers(param1:int) : void
      {
         this._maxUsers = param1;
      }
      
      public function set spectatorCount(param1:int) : void
      {
         this._specCount = param1;
      }
      
      public function set maxSpectators(param1:int) : void
      {
         this._maxSpectators = param1;
      }
      
      public function getUserByName(param1:String) : User
      {
         return this._userManager.getUserByName(param1);
      }
      
      public function getUserById(param1:int) : User
      {
         return this._userManager.getUserById(param1);
      }
      
      public function get userList() : Array
      {
         return this._userManager.getUserList();
      }
      
      public function get playerList() : Array
      {
         var _loc2_:User = null;
         var _loc1_:Array = [];
         for each(_loc2_ in this._userManager.getUserList())
         {
            if(_loc2_.isPlayerInRoom(this))
            {
               _loc1_.push(_loc2_);
            }
         }
         return _loc1_;
      }
      
      public function get spectatorList() : Array
      {
         var _loc2_:User = null;
         var _loc1_:Array = [];
         for each(_loc2_ in this._userManager.getUserList())
         {
            if(_loc2_.isSpectatorInRoom(this))
            {
               _loc1_.push(_loc2_);
            }
         }
         return _loc1_;
      }
      
      public function removeUser(param1:User) : void
      {
         this._userManager.removeUser(param1);
      }
      
      public function setVariable(param1:RoomVariable) : void
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
      
      public function setVariables(param1:Array) : void
      {
         var _loc2_:RoomVariable = null;
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
      
      public function addUser(param1:User) : void
      {
         this._userManager.addUser(param1);
      }
      
      public function containsUser(param1:User) : Boolean
      {
         return this._userManager.containsUser(param1);
      }
      
      public function get roomManager() : IRoomManager
      {
         return this._roomManager;
      }
      
      public function set roomManager(param1:IRoomManager) : void
      {
         if(this._roomManager != null)
         {
            throw new SFSError("Room manager already assigned. Room: " + this);
         }
         this._roomManager = param1;
      }
      
      public function setPasswordProtected(param1:Boolean) : void
      {
         this._isPasswordProtected = param1;
      }
      
      public function toString() : String
      {
         return "[Room: " + this._name + ", Id: " + this._id + ", GroupId: " + this._groupId + "]";
      }
      
      kernel function merge(param1:Room) : void
      {
         var _loc2_:RoomVariable = null;
         var _loc3_:User = null;
         for each(_loc2_ in param1.getVariables())
         {
            this._variables[_loc2_.name] = _loc2_;
         }
         this._userManager.kernel::clearAll();
         for each(_loc3_ in param1.userList)
         {
            this._userManager.addUser(_loc3_);
         }
      }
   }
}
