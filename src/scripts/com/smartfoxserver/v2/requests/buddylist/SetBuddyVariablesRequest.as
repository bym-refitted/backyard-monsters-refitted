package com.smartfoxserver.v2.requests.buddylist
{
   import com.smartfoxserver.v2.SmartFox;
   import com.smartfoxserver.v2.entities.data.ISFSArray;
   import com.smartfoxserver.v2.entities.data.SFSArray;
   import com.smartfoxserver.v2.entities.variables.BuddyVariable;
   import com.smartfoxserver.v2.exceptions.SFSValidationError;
   import com.smartfoxserver.v2.requests.BaseRequest;
   
   public class SetBuddyVariablesRequest extends BaseRequest
   {
      
      public static const KEY_BUDDY_NAME:String = "bn";
      
      public static const KEY_BUDDY_VARS:String = "bv";
       
      
      private var _buddyVariables:Array;
      
      public function SetBuddyVariablesRequest(param1:Array)
      {
         super(BaseRequest.SetBuddyVariables);
         this._buddyVariables = param1;
      }
      
      override public function validate(param1:SmartFox) : void
      {
         var _loc2_:Array = [];
         if(!param1.buddyManager.isInited)
         {
            _loc2_.push("BuddyList is not inited. Please send an InitBuddyRequest first.");
         }
         if(param1.buddyManager.myOnlineState == false)
         {
            _loc2_.push("Can\'t set buddy variables while off-line");
         }
         if(this._buddyVariables == null || this._buddyVariables.length == 0)
         {
            _loc2_.push("No variables were specified");
         }
         if(_loc2_.length > 0)
         {
            throw new SFSValidationError("SetBuddyVariables request error",_loc2_);
         }
      }
      
      override public function execute(param1:SmartFox) : void
      {
         var _loc3_:BuddyVariable = null;
         var _loc2_:ISFSArray = new SFSArray();
         for each(_loc3_ in this._buddyVariables)
         {
            _loc2_.addSFSArray(_loc3_.toSFSArray());
         }
         _sfso.putSFSArray(KEY_BUDDY_VARS,_loc2_);
      }
   }
}
