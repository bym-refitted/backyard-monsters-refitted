package com.smartfoxserver.v2.requests.buddylist
{
   import com.smartfoxserver.v2.SmartFox;
   import com.smartfoxserver.v2.exceptions.SFSValidationError;
   import com.smartfoxserver.v2.requests.BaseRequest;
   
   public class InitBuddyListRequest extends BaseRequest
   {
      
      public static const KEY_BLIST:String = "bl";
      
      public static const KEY_BUDDY_STATES:String = "bs";
      
      public static const KEY_MY_VARS:String = "mv";
       
      
      public function InitBuddyListRequest()
      {
         super(BaseRequest.InitBuddyList);
      }
      
      override public function validate(param1:SmartFox) : void
      {
         var _loc2_:Array = [];
         if(param1.buddyManager.isInited)
         {
            _loc2_.push("Buddy List is already initialized.");
         }
         if(_loc2_.length > 0)
         {
            throw new SFSValidationError("InitBuddyRequest error",_loc2_);
         }
      }
      
      override public function execute(param1:SmartFox) : void
      {
      }
   }
}
