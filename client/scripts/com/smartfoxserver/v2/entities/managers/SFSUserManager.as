package com.smartfoxserver.v2.entities.managers
{
   import com.smartfoxserver.v2.SmartFox;
   import com.smartfoxserver.v2.entities.User;
   import com.smartfoxserver.v2.kernel;
   import com.smartfoxserver.v2.logging.Logger;
   import de.polygonal.ds.HashMap;
   import de.polygonal.ds.Itr;
   
   use namespace kernel;
   
   public class SFSUserManager implements IUserManager
   {
       
      
      private var _usersByName:HashMap;
      
      private var _usersById:HashMap;
      
      protected var _log:Logger;
      
      protected var _smartFox:SmartFox;
      
      public function SFSUserManager(param1:SmartFox)
      {
         super();
         this._smartFox = param1;
         this._log = Logger.getInstance();
         this._usersByName = new HashMap();
         this._usersById = new HashMap();
      }
      
      public function containsUserName(param1:String) : Boolean
      {
         return this._usersByName.hasKey(param1);
      }
      
      public function containsUserId(param1:int) : Boolean
      {
         return this._usersById.hasKey(param1);
      }
      
      public function containsUser(param1:User) : Boolean
      {
         return this._usersByName.contains(param1);
      }
      
      public function getUserByName(param1:String) : User
      {
         return this._usersByName.get(param1) as User;
      }
      
      public function getUserById(param1:int) : User
      {
         return this._usersById.get(param1) as User;
      }
      
      public function addUser(param1:User) : void
      {
         if(this._usersById.hasKey(param1.id))
         {
            this._log.warn("Unexpected: duplicate user in UserManager: " + param1);
         }
         this._addUser(param1);
      }
      
      protected function _addUser(param1:User) : void
      {
         this._usersByName.set(param1.name,param1);
         this._usersById.set(param1.id,param1);
      }
      
      public function removeUser(param1:User) : void
      {
         this._usersByName.clr(param1.name);
         this._usersById.clr(param1.id);
      }
      
      public function removeUserById(param1:int) : void
      {
         var _loc2_:User = this._usersById.get(param1) as User;
         if(_loc2_ != null)
         {
            this.removeUser(_loc2_);
         }
      }
      
      public function get userCount() : int
      {
         return this._usersById.size();
      }
      
      public function get smartFox() : SmartFox
      {
         return this._smartFox;
      }
      
      public function getUserList() : Array
      {
         var _loc1_:Array = [];
         var _loc2_:Itr = this._usersById.iterator();
         while(_loc2_.hasNext())
         {
            _loc1_.push(_loc2_.next());
         }
         return _loc1_;
      }
      
      kernel function clearAll() : void
      {
         this._usersByName = new HashMap();
         this._usersById = new HashMap();
      }
   }
}
