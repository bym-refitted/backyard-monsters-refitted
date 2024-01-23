package com.smartfoxserver.v2.entities
{
   import com.smartfoxserver.v2.entities.data.ISFSArray;
   import com.smartfoxserver.v2.entities.variables.BuddyVariable;
   import com.smartfoxserver.v2.entities.variables.ReservedBuddyVariables;
   import com.smartfoxserver.v2.entities.variables.SFSBuddyVariable;
   import com.smartfoxserver.v2.util.ArrayUtil;
   
   public class SFSBuddy implements Buddy
   {
       
      
      protected var _name:String;
      
      protected var _id:int;
      
      protected var _isBlocked:Boolean;
      
      protected var _variables:Object;
      
      protected var _isTemp:Boolean;
      
      public function SFSBuddy(param1:int, param2:String, param3:Boolean = false, param4:Boolean = false)
      {
         super();
         this._id = param1;
         this._name = param2;
         this._isBlocked = param3;
         this._variables = {};
         this._isTemp = param4;
      }
      
      public static function fromSFSArray(param1:ISFSArray) : Buddy
      {
         var _loc2_:Buddy = new SFSBuddy(param1.getInt(0),param1.getUtfString(1),param1.getBool(2),param1.size() > 3 ? param1.getBool(4) : false);
         var _loc3_:ISFSArray = param1.getSFSArray(3);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.size())
         {
            _loc2_.setVariable(SFSBuddyVariable.fromSFSArray(_loc3_.getSFSArray(_loc4_)));
            _loc4_++;
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
      
      public function get isBlocked() : Boolean
      {
         return this._isBlocked;
      }
      
      public function get isTemp() : Boolean
      {
         return this._isTemp;
      }
      
      public function get isOnline() : Boolean
      {
         var _loc1_:BuddyVariable = this.getVariable(ReservedBuddyVariables.BV_ONLINE);
         var _loc2_:Boolean = _loc1_ == null ? true : Boolean(_loc1_.getBoolValue());
         return _loc2_ && this._id > -1;
      }
      
      public function get state() : String
      {
         var _loc1_:BuddyVariable = this.getVariable(ReservedBuddyVariables.BV_STATE);
         return _loc1_ == null ? null : String(_loc1_.getStringValue());
      }
      
      public function get nickName() : String
      {
         var _loc1_:BuddyVariable = this.getVariable(ReservedBuddyVariables.BV_NICKNAME);
         return _loc1_ == null ? null : String(_loc1_.getStringValue());
      }
      
      public function get variables() : Array
      {
         return ArrayUtil.objToArray(this._variables);
      }
      
      public function getVariable(param1:String) : BuddyVariable
      {
         return this._variables[param1];
      }
      
      public function getOfflineVariables() : Array
      {
         var _loc2_:BuddyVariable = null;
         var _loc1_:Array = [];
         for each(_loc2_ in this._variables)
         {
            if(_loc2_.name.charAt(0) == SFSBuddyVariable.OFFLINE_PREFIX)
            {
               _loc1_.push(_loc2_);
            }
         }
         return _loc1_;
      }
      
      public function getOnlineVariables() : Array
      {
         var _loc2_:BuddyVariable = null;
         var _loc1_:Array = [];
         for each(_loc2_ in this._variables)
         {
            if(_loc2_.name.charAt(0) != SFSBuddyVariable.OFFLINE_PREFIX)
            {
               _loc1_.push(_loc2_);
            }
         }
         return _loc1_;
      }
      
      public function containsVariable(param1:String) : Boolean
      {
         return this._variables[param1] != null;
      }
      
      public function setVariable(param1:BuddyVariable) : void
      {
         this._variables[param1.name] = param1;
      }
      
      public function setVariables(param1:Array) : void
      {
         var _loc2_:BuddyVariable = null;
         for each(_loc2_ in param1)
         {
            this.setVariable(_loc2_);
         }
      }
      
      public function setId(param1:int) : void
      {
         this._id = param1;
      }
      
      public function setBlocked(param1:Boolean) : void
      {
         this._isBlocked = param1;
      }
      
      public function removeVariable(param1:String) : void
      {
         delete this._variables[param1];
      }
      
      public function clearVolatileVariables() : void
      {
         var _loc1_:BuddyVariable = null;
         for each(_loc1_ in this.variables)
         {
            if(_loc1_.name.charAt(0) != SFSBuddyVariable.OFFLINE_PREFIX)
            {
               this.removeVariable(_loc1_.name);
            }
         }
      }
      
      public function toString() : String
      {
         return "[Buddy: " + this.name + ", id: " + this.id + "]";
      }
   }
}
