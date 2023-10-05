package com.smartfoxserver.v2.requests.buddylist
{
   import com.smartfoxserver.v2.SmartFox;
   import com.smartfoxserver.v2.entities.Buddy;
   import com.smartfoxserver.v2.exceptions.SFSValidationError;
   import com.smartfoxserver.v2.requests.BaseRequest;
   
   public class BlockBuddyRequest extends BaseRequest
   {
      
      public static const KEY_BUDDY_NAME:String = "bn";
      
      public static const KEY_BUDDY_BLOCK_STATE:String = "bs";
       
      
      private var _buddyName:String;
      
      private var _blocked:Boolean;
      
      public function BlockBuddyRequest(param1:String, param2:Boolean)
      {
         super(BaseRequest.BlockBuddy);
         this._buddyName = param1;
         this._blocked = param2;
      }
      
      override public function validate(param1:SmartFox) : void
      {
         var _loc2_:Array = [];
         if(!param1.buddyManager.isInited)
         {
            _loc2_.push("BuddyList is not inited. Please send an InitBuddyRequest first.");
         }
         if(this._buddyName == null || this._buddyName.length < 1)
         {
            _loc2_.push("Invalid buddy name: " + this._buddyName);
         }
         if(param1.buddyManager.myOnlineState == false)
         {
            _loc2_.push("Can\'t block buddy while off-line");
         }
         var _loc3_:Buddy = param1.buddyManager.getBuddyByName(this._buddyName);
         if(_loc3_ == null)
         {
            _loc2_.push("Can\'t block buddy, it\'s not in your list: " + this._buddyName);
         }
         else if(_loc3_.isBlocked == this._blocked)
         {
            _loc2_.push("BuddyBlock flag is already in the requested state: " + this._blocked + ", for buddy: " + _loc3_);
         }
         if(_loc2_.length > 0)
         {
            throw new SFSValidationError("BuddyList request error",_loc2_);
         }
      }
      
      override public function execute(param1:SmartFox) : void
      {
         _sfso.putUtfString(BlockBuddyRequest.KEY_BUDDY_NAME,this._buddyName);
         _sfso.putBool(BlockBuddyRequest.KEY_BUDDY_BLOCK_STATE,this._blocked);
      }
   }
}
