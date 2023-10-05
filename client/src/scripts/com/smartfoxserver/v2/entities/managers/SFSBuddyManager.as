package com.smartfoxserver.v2.entities.managers
{
   import com.smartfoxserver.v2.SmartFox;
   import com.smartfoxserver.v2.entities.Buddy;
   import com.smartfoxserver.v2.entities.variables.BuddyVariable;
   import com.smartfoxserver.v2.entities.variables.ReservedBuddyVariables;
   import com.smartfoxserver.v2.entities.variables.SFSBuddyVariable;
   import com.smartfoxserver.v2.util.ArrayUtil;
   
   public class SFSBuddyManager implements IBuddyManager
   {
       
      
      protected var _buddiesByName:Object;
      
      protected var _myVariables:Object;
      
      protected var _myOnlineState:Boolean;
      
      protected var _inited:Boolean;
      
      private var _buddyStates:Array;
      
      private var _sfs:SmartFox;
      
      public function SFSBuddyManager(param1:SmartFox)
      {
         super();
         this._sfs = param1;
         this._buddiesByName = {};
         this._myVariables = {};
         this._inited = false;
      }
      
      public function get isInited() : Boolean
      {
         return this._inited;
      }
      
      public function setInited() : void
      {
         this._inited = true;
      }
      
      public function addBuddy(param1:Buddy) : void
      {
         this._buddiesByName[param1.name] = param1;
      }
      
      public function clearAll() : void
      {
         this._buddiesByName = {};
      }
      
      public function removeBuddyById(param1:int) : Buddy
      {
         var _loc2_:Buddy = this.getBuddyById(param1);
         if(_loc2_ != null)
         {
            delete this._buddiesByName[_loc2_.name];
         }
         return _loc2_;
      }
      
      public function removeBuddyByName(param1:String) : Buddy
      {
         var _loc2_:Buddy = this.getBuddyByName(param1);
         if(_loc2_ != null)
         {
            delete this._buddiesByName[param1];
         }
         return _loc2_;
      }
      
      public function getBuddyById(param1:int) : Buddy
      {
         var _loc2_:Buddy = null;
         if(param1 > -1)
         {
            for each(_loc2_ in this._buddiesByName)
            {
               if(_loc2_.id == param1)
               {
                  return _loc2_;
               }
            }
         }
         return null;
      }
      
      public function containsBuddy(param1:String) : Boolean
      {
         return this.getBuddyByName(param1) != null;
      }
      
      public function getBuddyByName(param1:String) : Buddy
      {
         return this._buddiesByName[param1];
      }
      
      public function getBuddyByNickName(param1:String) : Buddy
      {
         var _loc2_:Buddy = null;
         for each(_loc2_ in this._buddiesByName)
         {
            if(_loc2_.nickName == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function get offlineBuddies() : Array
      {
         var _loc2_:Buddy = null;
         var _loc1_:Array = [];
         for each(_loc2_ in this._buddiesByName)
         {
            if(!_loc2_.isOnline)
            {
               _loc1_.push(_loc2_);
            }
         }
         return _loc1_;
      }
      
      public function get onlineBuddies() : Array
      {
         var _loc2_:Buddy = null;
         var _loc1_:Array = [];
         for each(_loc2_ in this._buddiesByName)
         {
            if(_loc2_.isOnline)
            {
               _loc1_.push(_loc2_);
            }
         }
         return _loc1_;
      }
      
      public function get buddyList() : Array
      {
         return ArrayUtil.objToArray(this._buddiesByName);
      }
      
      public function getMyVariable(param1:String) : BuddyVariable
      {
         return this._myVariables[param1] as BuddyVariable;
      }
      
      public function get myVariables() : Array
      {
         return ArrayUtil.objToArray(this._myVariables);
      }
      
      public function get myOnlineState() : Boolean
      {
         if(!this._inited)
         {
            return false;
         }
         var _loc1_:Boolean = true;
         var _loc2_:BuddyVariable = this.getMyVariable(ReservedBuddyVariables.BV_ONLINE);
         if(_loc2_ != null)
         {
            _loc1_ = Boolean(_loc2_.getBoolValue());
         }
         return _loc1_;
      }
      
      public function get myNickName() : String
      {
         var _loc1_:BuddyVariable = this.getMyVariable(ReservedBuddyVariables.BV_NICKNAME);
         return _loc1_ != null ? String(_loc1_.getStringValue()) : null;
      }
      
      public function get myState() : String
      {
         var _loc1_:BuddyVariable = this.getMyVariable(ReservedBuddyVariables.BV_STATE);
         return _loc1_ != null ? String(_loc1_.getStringValue()) : null;
      }
      
      public function get buddyStates() : Array
      {
         return this._buddyStates;
      }
      
      public function setMyVariable(param1:BuddyVariable) : void
      {
         this._myVariables[param1.name] = param1;
      }
      
      public function setMyVariables(param1:Array) : void
      {
         var _loc2_:BuddyVariable = null;
         for each(_loc2_ in param1)
         {
            this.setMyVariable(_loc2_);
         }
      }
      
      public function setMyOnlineState(param1:Boolean) : void
      {
         this.setMyVariable(new SFSBuddyVariable(ReservedBuddyVariables.BV_ONLINE,param1));
      }
      
      public function setMyNickName(param1:String) : void
      {
         this.setMyVariable(new SFSBuddyVariable(ReservedBuddyVariables.BV_NICKNAME,param1));
      }
      
      public function setMyState(param1:String) : void
      {
         this.setMyVariable(new SFSBuddyVariable(ReservedBuddyVariables.BV_STATE,param1));
      }
      
      public function setBuddyStates(param1:Array) : void
      {
         this._buddyStates = param1;
      }
   }
}
