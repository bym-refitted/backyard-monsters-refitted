package com.smartfoxserver.v2.requests
{
   import com.smartfoxserver.v2.SmartFox;
   import com.smartfoxserver.v2.exceptions.SFSValidationError;
   
   public class LogoutRequest extends BaseRequest
   {
      
      public static const KEY_ZONE_NAME:String = "zn";
       
      
      public function LogoutRequest()
      {
         super(BaseRequest.Logout);
      }
      
      override public function validate(param1:SmartFox) : void
      {
         if(param1.mySelf == null)
         {
            throw new SFSValidationError("LogoutRequest Error",["You are not logged in a the moment!"]);
         }
      }
   }
}
