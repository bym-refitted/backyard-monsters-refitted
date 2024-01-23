package com.smartfoxserver.v2.requests
{
   import com.hurlant.crypto.hash.IHash;
   import com.hurlant.crypto.hash.MD5;
   import com.hurlant.util.Hex;
   import com.smartfoxserver.v2.SmartFox;
   import com.smartfoxserver.v2.entities.data.ISFSObject;
   import com.smartfoxserver.v2.exceptions.SFSValidationError;
   import flash.utils.ByteArray;
   
   public class LoginRequest extends BaseRequest
   {
      
      public static const KEY_ZONE_NAME:String = "zn";
      
      public static const KEY_USER_NAME:String = "un";
      
      public static const KEY_PASSWORD:String = "pw";
      
      public static const KEY_PARAMS:String = "p";
      
      public static const KEY_PRIVILEGE_ID:String = "pi";
      
      public static const KEY_ID:String = "id";
      
      public static const KEY_ROOMLIST:String = "rl";
      
      public static const KEY_RECONNECTION_SECONDS:String = "rs";
       
      
      private var _zoneName:String;
      
      private var _userName:String;
      
      private var _password:String;
      
      private var _params:ISFSObject;
      
      public function LoginRequest(param1:String = "", param2:String = "", param3:String = "", param4:ISFSObject = null)
      {
         super(BaseRequest.Login);
         this._zoneName = param3;
         this._userName = param1;
         this._password = param2 == null ? "" : param2;
         this._params = param4;
      }
      
      override public function execute(param1:SmartFox) : void
      {
         _sfso.putUtfString(KEY_ZONE_NAME,this._zoneName);
         _sfso.putUtfString(KEY_USER_NAME,this._userName);
         if(this._password.length > 0)
         {
            this._password = this.getMD5Hash(param1.sessionToken + this._password);
         }
         _sfso.putUtfString(KEY_PASSWORD,this._password);
         if(this._params != null)
         {
            _sfso.putSFSObject(KEY_PARAMS,this._params);
         }
      }
      
      override public function validate(param1:SmartFox) : void
      {
         if(param1.mySelf != null)
         {
            throw new SFSValidationError("LoginRequest Error",["You are already logged in. Logout first"]);
         }
         if((this._zoneName == null || this._zoneName.length == 0) && param1.config != null)
         {
            this._zoneName = param1.config.zone;
         }
         if(this._zoneName == null || this._zoneName.length == 0)
         {
            throw new SFSValidationError("LoginRequest Error",["Missing Zone name"]);
         }
      }
      
      private function getMD5Hash(param1:String) : String
      {
         var _loc2_:IHash = new MD5();
         var _loc3_:ByteArray = Hex.toArray(Hex.fromString(param1));
         return Hex.fromArray(_loc2_.hash(_loc3_));
      }
   }
}
