package com.smartfoxserver.v2.requests
{
   import com.smartfoxserver.v2.SmartFox;
   import com.smartfoxserver.v2.entities.Room;
   import com.smartfoxserver.v2.exceptions.SFSValidationError;
   
   public class SpectatorToPlayerRequest extends BaseRequest
   {
      
      public static const KEY_ROOM_ID:String = "r";
      
      public static const KEY_USER_ID:String = "u";
      
      public static const KEY_PLAYER_ID:String = "p";
       
      
      private var _room:Room;
      
      public function SpectatorToPlayerRequest(param1:Room = null)
      {
         super(BaseRequest.SpectatorToPlayer);
         this._room = param1;
      }
      
      override public function validate(param1:SmartFox) : void
      {
         var _loc2_:Array = [];
         if(param1.joinedRooms.length < 1)
         {
            _loc2_.push("You are not joined in any rooms");
         }
         if(_loc2_.length > 0)
         {
            throw new SFSValidationError("LeaveRoom request error",_loc2_);
         }
      }
      
      override public function execute(param1:SmartFox) : void
      {
         if(this._room == null)
         {
            this._room = param1.lastJoinedRoom;
         }
         _sfso.putInt(KEY_ROOM_ID,this._room.id);
      }
   }
}
