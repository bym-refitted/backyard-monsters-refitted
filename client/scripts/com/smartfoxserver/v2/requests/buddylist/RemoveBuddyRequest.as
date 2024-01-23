package com.smartfoxserver.v2.requests.buddylist
{
   import com.smartfoxserver.v2.SmartFox;
   import com.smartfoxserver.v2.exceptions.SFSValidationError;
   import com.smartfoxserver.v2.requests.BaseRequest;
   
   public class RemoveBuddyRequest extends BaseRequest
   {
      
      public static const KEY_BUDDY_NAME:String = "bn";
       
      
      private var _name:String;
      
      public function RemoveBuddyRequest(param1:String)
      {
         super(BaseRequest.RemoveBuddy);
         this._name = param1;
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
            _loc2_.push("Can\'t remove buddy while off-line");
         }
         if(!param1.buddyManager.containsBuddy(this._name))
         {
            _loc2_.push("Can\'t remove buddy, it\'s not in your list: " + this._name);
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
