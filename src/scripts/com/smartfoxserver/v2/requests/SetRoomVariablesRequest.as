package com.smartfoxserver.v2.requests
{
   import com.smartfoxserver.v2.SmartFox;
   import com.smartfoxserver.v2.entities.Room;
   import com.smartfoxserver.v2.entities.data.ISFSArray;
   import com.smartfoxserver.v2.entities.data.SFSArray;
   import com.smartfoxserver.v2.entities.variables.RoomVariable;
   import com.smartfoxserver.v2.exceptions.SFSValidationError;
   
   public class SetRoomVariablesRequest extends BaseRequest
   {
      
      public static const KEY_VAR_ROOM:String = "r";
      
      public static const KEY_VAR_LIST:String = "vl";
       
      
      private var _roomVariables:Array;
      
      private var _room:Room;
      
      public function SetRoomVariablesRequest(param1:Array, param2:Room = null)
      {
         super(BaseRequest.SetRoomVariables);
         this._roomVariables = param1;
         this._room = param2;
      }
      
      override public function validate(param1:SmartFox) : void
      {
         var _loc2_:Array = [];
         if(this._room != null)
         {
            if(!this._room.containsUser(param1.mySelf))
            {
               _loc2_.push("You are not joined in the target room");
            }
         }
         else if(param1.lastJoinedRoom == null)
         {
            _loc2_.push("You are not joined in any rooms");
         }
         if(this._roomVariables == null || this._roomVariables.length == 0)
         {
            _loc2_.push("No variables were specified");
         }
         if(_loc2_.length > 0)
         {
            throw new SFSValidationError("SetRoomVariables request error",_loc2_);
         }
      }
      
      override public function execute(param1:SmartFox) : void
      {
         var _loc3_:RoomVariable = null;
         var _loc2_:ISFSArray = SFSArray.newInstance();
         for each(_loc3_ in this._roomVariables)
         {
            _loc2_.addSFSArray(_loc3_.toSFSArray());
         }
         if(this._room == null)
         {
            this._room = param1.lastJoinedRoom;
         }
         _sfso.putSFSArray(KEY_VAR_LIST,_loc2_);
         _sfso.putInt(KEY_VAR_ROOM,this._room.id);
      }
   }
}
