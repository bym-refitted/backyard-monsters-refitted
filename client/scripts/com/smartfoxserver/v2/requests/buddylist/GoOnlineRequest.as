package com.smartfoxserver.v2.requests.buddylist
{
   import com.smartfoxserver.v2.SmartFox;
   import com.smartfoxserver.v2.exceptions.SFSValidationError;
   import com.smartfoxserver.v2.requests.BaseRequest;
   
   public class GoOnlineRequest extends BaseRequest
   {
      
      public static const KEY_ONLINE:String = "o";
      
      public static const KEY_BUDDY_NAME:String = "bn";
      
      public static const KEY_BUDDY_ID:String = "bi";
       
      
      private var _online:Boolean;
      
      public function GoOnlineRequest(param1:Boolean)
      {
         super(BaseRequest.GoOnline);
         this._online = param1;
      }
      
      override public function validate(param1:SmartFox) : void
      {
         var _loc2_:Array = [];
         if(!param1.buddyManager.isInited)
         {
            _loc2_.push("BuddyList is not inited. Please send an InitBuddyRequest first.");
         }
         if(_loc2_.length > 0)
         {
            throw new SFSValidationError("GoOnline request error",_loc2_);
         }
      }
      
      override public function execute(param1:SmartFox) : void
      {
         param1.buddyManager.setMyOnlineState(this._online);
         _sfso.putBool(KEY_ONLINE,this._online);
      }
   }
}
