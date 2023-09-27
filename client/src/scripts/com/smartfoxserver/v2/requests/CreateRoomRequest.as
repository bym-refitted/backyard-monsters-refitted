package com.smartfoxserver.v2.requests
{
   import com.smartfoxserver.v2.SmartFox;
   import com.smartfoxserver.v2.entities.Room;
   import com.smartfoxserver.v2.entities.data.ISFSArray;
   import com.smartfoxserver.v2.entities.data.SFSArray;
   import com.smartfoxserver.v2.entities.variables.RoomVariable;
   import com.smartfoxserver.v2.exceptions.SFSValidationError;
   
   public class CreateRoomRequest extends BaseRequest
   {
      
      public static const KEY_ROOM:String = "r";
      
      public static const KEY_NAME:String = "n";
      
      public static const KEY_PASSWORD:String = "p";
      
      public static const KEY_GROUP_ID:String = "g";
      
      public static const KEY_ISGAME:String = "ig";
      
      public static const KEY_MAXUSERS:String = "mu";
      
      public static const KEY_MAXSPECTATORS:String = "ms";
      
      public static const KEY_MAXVARS:String = "mv";
      
      public static const KEY_ROOMVARS:String = "rv";
      
      public static const KEY_PERMISSIONS:String = "pm";
      
      public static const KEY_EVENTS:String = "ev";
      
      public static const KEY_EXTID:String = "xn";
      
      public static const KEY_EXTCLASS:String = "xc";
      
      public static const KEY_EXTPROP:String = "xp";
      
      public static const KEY_AUTOJOIN:String = "aj";
      
      public static const KEY_ROOM_TO_LEAVE:String = "rl";
       
      
      private var _settings:com.smartfoxserver.v2.requests.RoomSettings;
      
      private var _autoJoin:Boolean;
      
      private var _roomToLeave:Room;
      
      public function CreateRoomRequest(param1:com.smartfoxserver.v2.requests.RoomSettings, param2:Boolean = false, param3:Room = null)
      {
         super(BaseRequest.CreateRoom);
         this._settings = param1;
         this._autoJoin = param2;
         this._roomToLeave = param3;
      }
      
      override public function execute(param1:SmartFox) : void
      {
         var _loc2_:ISFSArray = null;
         var _loc3_:* = undefined;
         var _loc4_:RoomVariable = null;
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         _sfso.putUtfString(KEY_NAME,this._settings.name);
         _sfso.putUtfString(KEY_GROUP_ID,this._settings.groupId);
         _sfso.putUtfString(KEY_PASSWORD,this._settings.password);
         _sfso.putBool(KEY_ISGAME,this._settings.isGame);
         _sfso.putShort(KEY_MAXUSERS,this._settings.maxUsers);
         _sfso.putShort(KEY_MAXSPECTATORS,this._settings.maxSpectators);
         _sfso.putShort(KEY_MAXVARS,this._settings.maxVariables);
         if(this._settings.variables != null && this._settings.variables.length > 0)
         {
            _loc2_ = SFSArray.newInstance();
            for each(_loc3_ in this._settings.variables)
            {
               if(_loc3_ is RoomVariable)
               {
                  _loc4_ = _loc3_ as RoomVariable;
                  _loc2_.addSFSArray(_loc4_.toSFSArray());
               }
            }
            _sfso.putSFSArray(KEY_ROOMVARS,_loc2_);
         }
         if(this._settings.permissions != null)
         {
            (_loc5_ = []).push(this._settings.permissions.allowNameChange);
            _loc5_.push(this._settings.permissions.allowPasswordStateChange);
            _loc5_.push(this._settings.permissions.allowPublicMessages);
            _loc5_.push(this._settings.permissions.allowResizing);
            _sfso.putBoolArray(KEY_PERMISSIONS,_loc5_);
         }
         if(this._settings.events != null)
         {
            (_loc6_ = []).push(this._settings.events.allowUserEnter);
            _loc6_.push(this._settings.events.allowUserExit);
            _loc6_.push(this._settings.events.allowUserCountChange);
            _loc6_.push(this._settings.events.allowUserVariablesUpdate);
            _sfso.putBoolArray(KEY_EVENTS,_loc6_);
         }
         if(this._settings.extension != null)
         {
            _sfso.putUtfString(KEY_EXTID,this._settings.extension.id);
            _sfso.putUtfString(KEY_EXTCLASS,this._settings.extension.className);
            if(this._settings.extension.propertiesFile != null && this._settings.extension.propertiesFile.length > 0)
            {
               _sfso.putUtfString(KEY_EXTPROP,this._settings.extension.propertiesFile);
            }
         }
         _sfso.putBool(KEY_AUTOJOIN,this._autoJoin);
         if(this._roomToLeave != null)
         {
            _sfso.putInt(KEY_ROOM_TO_LEAVE,this._roomToLeave.id);
         }
      }
      
      override public function validate(param1:SmartFox) : void
      {
         var _loc2_:Array = [];
         if(this._settings.name == null || this._settings.name.length == 0)
         {
            _loc2_.push("Missing room name");
         }
         if(this._settings.maxUsers <= 0)
         {
            _loc2_.push("maxUsers must be > 0");
         }
         if(this._settings.extension != null)
         {
            if(this._settings.extension.className == null || this._settings.extension.className.length == 0)
            {
               _loc2_.push("Missing Extension class name");
            }
            if(this._settings.extension.id == null || this._settings.extension.id.length == 0)
            {
               _loc2_.push("Missing Extension id");
            }
         }
         if(_loc2_.length > 0)
         {
            throw new SFSValidationError("CreateRoom request error",_loc2_);
         }
      }
   }
}
