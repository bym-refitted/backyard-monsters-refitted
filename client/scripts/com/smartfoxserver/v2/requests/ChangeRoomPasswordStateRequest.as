package com.smartfoxserver.v2.requests
{
   import com.smartfoxserver.v2.SmartFox;
   import com.smartfoxserver.v2.entities.Room;
   import com.smartfoxserver.v2.exceptions.SFSValidationError;
   
   public class ChangeRoomPasswordStateRequest extends BaseRequest
   {
      
      public static const KEY_ROOM:String = "r";
      
      public static const KEY_PASS:String = "p";
       
      
      private var _room:Room;
      
      private var _newPass:String;
      
      public function ChangeRoomPasswordStateRequest(param1:Room, param2:String)
      {
         super(BaseRequest.ChangeRoomPassword);
         this._room = param1;
         this._newPass = param2;
      }
      
      override public function validate(param1:SmartFox) : void
      {
         var _loc2_:Array = [];
         if(this._room == null)
         {
            _loc2_.push("Provided room is null");
         }
         if(this._newPass == null)
         {
            _loc2_.push("Invalid new room password. It must be a non-null string.");
         }
         if(_loc2_.length > 0)
         {
            throw new SFSValidationError("ChangePassState request error",_loc2_);
         }
      }
      
      override public function execute(param1:SmartFox) : void
      {
         _sfso.putInt(KEY_ROOM,this._room.id);
         _sfso.putUtfString(KEY_PASS,this._newPass);
      }
   }
}
