package com.smartfoxserver.v2.requests
{
   import com.smartfoxserver.v2.SmartFox;
   import com.smartfoxserver.v2.entities.Room;
   import com.smartfoxserver.v2.exceptions.SFSValidationError;
   
   public class ChangeRoomNameRequest extends BaseRequest
   {
      
      public static const KEY_ROOM:String = "r";
      
      public static const KEY_NAME:String = "n";
       
      
      private var _room:Room;
      
      private var _newName:String;
      
      public function ChangeRoomNameRequest(param1:Room, param2:String)
      {
         super(BaseRequest.ChangeRoomName);
         this._room = param1;
         this._newName = param2;
      }
      
      override public function validate(param1:SmartFox) : void
      {
         var _loc2_:Array = [];
         if(this._room == null)
         {
            _loc2_.push("Provided room is null");
         }
         if(this._newName == null || this._newName.length == 0)
         {
            _loc2_.push("Invalid new room name. It must be a non-null and non-empty string.");
         }
         if(_loc2_.length > 0)
         {
            throw new SFSValidationError("ChangeRoomName request error",_loc2_);
         }
      }
      
      override public function execute(param1:SmartFox) : void
      {
         _sfso.putInt(KEY_ROOM,this._room.id);
         _sfso.putUtfString(KEY_NAME,this._newName);
      }
   }
}
