package com.smartfoxserver.v2.requests
{
   import com.smartfoxserver.v2.SmartFox;
   import com.smartfoxserver.v2.entities.Room;
   import com.smartfoxserver.v2.exceptions.SFSValidationError;
   
   public class ChangeRoomCapacityRequest extends BaseRequest
   {
      
      public static const KEY_ROOM:String = "r";
      
      public static const KEY_USER_SIZE:String = "u";
      
      public static const KEY_SPEC_SIZE:String = "s";
       
      
      private var _room:Room;
      
      private var _newMaxUsers:int;
      
      private var _newMaxSpect:int;
      
      public function ChangeRoomCapacityRequest(param1:Room, param2:int, param3:int)
      {
         super(BaseRequest.ChangeRoomCapacity);
         this._room = param1;
         this._newMaxUsers = param2;
         this._newMaxSpect = param3;
      }
      
      override public function validate(param1:SmartFox) : void
      {
         var _loc2_:Array = [];
         if(this._room == null)
         {
            _loc2_.push("Provided room is null");
         }
         if(_loc2_.length > 0)
         {
            throw new SFSValidationError("ChangeRoomCapacity request error",_loc2_);
         }
      }
      
      override public function execute(param1:SmartFox) : void
      {
         _sfso.putInt(KEY_ROOM,this._room.id);
         _sfso.putInt(KEY_USER_SIZE,this._newMaxUsers);
         _sfso.putInt(KEY_SPEC_SIZE,this._newMaxSpect);
      }
   }
}
