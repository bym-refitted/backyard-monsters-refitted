package com.smartfoxserver.v2.requests
{
   import com.smartfoxserver.v2.SmartFox;
   import com.smartfoxserver.v2.entities.Room;
   import com.smartfoxserver.v2.entities.data.ISFSObject;
   import com.smartfoxserver.v2.entities.data.SFSObject;
   import com.smartfoxserver.v2.exceptions.SFSValidationError;
   
   public class ExtensionRequest extends BaseRequest
   {
      
      public static const KEY_CMD:String = "c";
      
      public static const KEY_PARAMS:String = "p";
      
      public static const KEY_ROOM:String = "r";
       
      
      private var _extCmd:String;
      
      private var _params:ISFSObject;
      
      private var _room:Room;
      
      private var _useUDP:Boolean;
      
      public function ExtensionRequest(param1:String, param2:ISFSObject = null, param3:Room = null, param4:Boolean = false)
      {
         super(BaseRequest.CallExtension);
         _targetController = 1;
         this._extCmd = param1;
         this._params = param2;
         this._room = param3;
         this._useUDP = param4;
         if(this._params == null)
         {
            this._params = new SFSObject();
         }
      }
      
      public function get useUDP() : Boolean
      {
         return this._useUDP;
      }
      
      override public function validate(param1:SmartFox) : void
      {
         var _loc2_:Array = [];
         if(this._extCmd == null || this._extCmd.length == 0)
         {
            _loc2_.push("Missing extension command");
         }
         if(this._params == null)
         {
            _loc2_.push("Missing extension parameters");
         }
         if(_loc2_.length > 0)
         {
            throw new SFSValidationError("ExtensionCall request error",_loc2_);
         }
      }
      
      override public function execute(param1:SmartFox) : void
      {
         _sfso.putUtfString(KEY_CMD,this._extCmd);
         _sfso.putInt(KEY_ROOM,this._room == null ? -1 : this._room.id);
         _sfso.putSFSObject(KEY_PARAMS,this._params);
      }
   }
}
