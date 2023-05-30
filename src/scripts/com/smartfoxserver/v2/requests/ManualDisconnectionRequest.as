package com.smartfoxserver.v2.requests
{
   import com.smartfoxserver.v2.SmartFox;
   
   public class ManualDisconnectionRequest extends BaseRequest
   {
       
      
      public function ManualDisconnectionRequest()
      {
         super(BaseRequest.ManualDisconnection);
      }
      
      override public function validate(param1:SmartFox) : void
      {
      }
      
      override public function execute(param1:SmartFox) : void
      {
      }
   }
}
