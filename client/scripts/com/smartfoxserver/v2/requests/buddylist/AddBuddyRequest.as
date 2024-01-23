package com.smartfoxserver.v2.requests.buddylist
{
   import com.smartfoxserver.v2.SmartFox;
   import com.smartfoxserver.v2.entities.Buddy;
   import com.smartfoxserver.v2.exceptions.SFSValidationError;
   import com.smartfoxserver.v2.requests.BaseRequest;
   
   public class AddBuddyRequest extends BaseRequest
   {
      
      public static const KEY_BUDDY_NAME:String = "bn";
       
      
      private var _name:String;
      
      public function AddBuddyRequest(param1:String)
      {
         super(BaseRequest.AddBuddy);
         this._name = param1;
      }
      
      override public function validate(param1:SmartFox) : void
      {
         var _loc2_:Array = [];
         if(!param1.buddyManager.isInited)
         {
            _loc2_.push("BuddyList is not inited. Please send an InitBuddyRequest first.");
         }
         if(this._name == null || this._name.length < 1)
         {
            _loc2_.push("Invalid buddy name: " + this._name);
         }
         if(param1.buddyManager.myOnlineState == false)
         {
            _loc2_.push("Can\'t add buddy while off-line");
         }
         var _loc3_:Buddy = param1.buddyManager.getBuddyByName(this._name);
         if(_loc3_ != null && !_loc3_.isTemp)
         {
            _loc2_.push("Can\'t add buddy, it is already in your list: " + this._name);
         }
         if(_loc2_.length > 0)
         {
            throw new SFSValidationError("BuddyList request error",_loc2_);
         }
      }
      
      override public function execute(param1:SmartFox) : void
      {
         _sfso.putUtfString(KEY_BUDDY_NAME,this._name);
      }
   }
}
